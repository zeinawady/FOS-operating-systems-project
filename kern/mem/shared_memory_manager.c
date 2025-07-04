#include <inc/memlayout.h>
#include "shared_memory_manager.h"

#include <inc/mmu.h>
#include <inc/error.h>
#include <inc/string.h>
#include <inc/assert.h>
#include <inc/queue.h>
#include <inc/environment_definitions.h>

#include <kern/proc/user_environment.h>
#include <kern/trap/syscall.h>
#include "kheap.h"
#include "memory_manager.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//
struct Share* get_share(int32 ownerID, char* name);

//===========================
// [1] INITIALIZE SHARES:
//===========================
//Initialize the list and the corresponding lock
void sharing_init() {
#if USE_KHEAP
	LIST_INIT(&AllShares.shares_list)
	;
	init_spinlock(&AllShares.shareslock, "shares lock");
#else
	panic("not handled when KERN HEAP is disabled");
#endif
}

//==============================
// [2] Get Size of Share Object:
//==============================
int getSizeOfSharedObject(int32 ownerID, char* shareName) {
	//[PROJECT'24.MS2] DONE
	// This function should return the size of the given shared object
	// RETURN:
	//	a) If found, return size of shared object
	//	b) Else, return E_SHARED_MEM_NOT_EXISTS
	//
	struct Share* ptr_share = get_share(ownerID, shareName);
	if (ptr_share == NULL)
		return E_SHARED_MEM_NOT_EXISTS;
	else
		return ptr_share->size;

	return 0;
}

//===========================================================

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//
//===========================
// [1] Create frames_storage:
//===========================
// Create the frames_storage and initialize it by 0
inline struct FrameInfo** create_frames_storage(int numOfFrames) {
	//TODO: [PROJECT'24.MS2 - #16] [4] SHARED MEMORY - create_frames_storage()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_frames_storage is not implemented yet");
	//Your Code is Here...
	if (numOfFrames < 0) {
		return NULL;
	}
	struct FrameInfo *ss = NULL;
	uint32 ListSZ = numOfFrames * sizeof(ss);
	struct FrameInfo **framesListtt = (struct FrameInfo**) kmalloc(ListSZ);
	if (framesListtt == NULL) {
		kfree((void*) framesListtt);
		return NULL;
	}
	for (int k = 0; k < numOfFrames; k++) {
		framesListtt[k] = 0;
	}
	return framesListtt;
}

//=====================================
// [2] Alloc & Initialize Share Object:
//=====================================
//Allocates a new shared object and initialize its member
//It dynamically creates the "framesStorage"
//Return: allocatedObject (pointer to struct Share) passed by reference
struct Share* create_share(int32 ownerID, char* shareName, uint32 size,
		uint8 isWritable) {
	//TODO: [PROJECT'24.MS2 - #16] [4] SHARED MEMORY - create_share()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_share is not implemented yet");
	//Your Code is Here...
	if (shareName == NULL || size == 0) {
		return NULL;
	}
	struct Share * new_Shared_Obj = (struct Share *) kmalloc(
			sizeof(struct Share));
	if (new_Shared_Obj == NULL) {
		kfree(new_Shared_Obj);
		return NULL;
	}
	new_Shared_Obj->references = 1;
	new_Shared_Obj->ID = (uint32) new_Shared_Obj & 0x7FFFFFFF;	//Masking
	new_Shared_Obj->ownerID = ownerID;
	strcpy(new_Shared_Obj->name, shareName);
	new_Shared_Obj->isWritable = isWritable;
	new_Shared_Obj->size = size;
	uint32 FramesNumb = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
	new_Shared_Obj->framesStorage = create_frames_storage(FramesNumb);
	if (new_Shared_Obj->framesStorage[0] != 0) {
		return NULL;
	}
	return new_Shared_Obj;
}

//=============================
// [3] Search for Share Object:
//=============================
//Search for the given shared object in the "shares_list"
//Return:
//	a) if found: ptr to Share object
//	b) else: NULL
struct Share* get_share(int32 ownerID, char* name) {
	//TODO: [PROJECT'24.MS2 - #17] [4] SHARED MEMORY - get_share()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_share is not implemented yet");
	//Your Code is Here...
	if (name == NULL) {
		return NULL;
	}
	acquire_spinlock(&(AllShares.shareslock));
	struct Share* current_Shared_Obj;
	LIST_FOREACH(current_Shared_Obj, &(AllShares.shares_list))
	{
		if (current_Shared_Obj->ownerID == ownerID
				&& strcmp(current_Shared_Obj->name, name) == 0) {
			release_spinlock(&(AllShares.shareslock));
			return current_Shared_Obj;
		}
	}
	release_spinlock(&(AllShares.shareslock));
	return NULL;
}

//=========================
// [4] Create Share Object:
//=========================
int createSharedObject(int32 ownerID, char* shareName, uint32 size,
		uint8 isWritable, void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - #19] [4] SHARED MEMORY [KERNEL SIDE] - createSharedObject()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("createSharedObject is not implemented yet");
	//Your Code is Here...
	struct Env* myenv = get_cpu_proc(); //The calling environment

	if (shareName == NULL || size == 0 || virtual_address == NULL) {
		return E_NO_SHARE;
	}
	struct Share * ss = get_share(ownerID, shareName);
	if (ss != NULL) {
		return E_SHARED_MEM_EXISTS;
	}
	acquire_spinlock(&(AllShares.shareslock));
	struct Share * shared_Objk = create_share(ownerID, shareName, size,
			isWritable);
	if (shared_Objk == NULL) {
		kfree((void*) shared_Objk);
		release_spinlock(&(AllShares.shareslock));
		return E_NO_SHARE;
	}
	uint32 Frames_Numb = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
	for (uint32 k = 0; k < Frames_Numb; k++) {
		int allocate_return = allocate_frame(&(shared_Objk->framesStorage[k]));
		if (allocate_return != 0) {
			kfree((void*) shared_Objk);
			release_spinlock(&(AllShares.shareslock));
			return E_NO_SHARE;
		}
		uint32 VA_of_map = ((uint32) virtual_address + k * PAGE_SIZE);
		int map_perms = PERM_USER | PERM_WRITEABLE;
		struct FrameInfo * shared_frame_ptr = shared_Objk->framesStorage[k];
		int map_return = map_frame(myenv->env_page_directory, shared_frame_ptr,
				VA_of_map, map_perms);
		if (map_return != 0) {
			kfree((void*) shared_Objk);
			release_spinlock(&(AllShares.shareslock));
			return E_NO_SHARE;
		}
	}

	LIST_INSERT_TAIL(&(AllShares.shares_list), shared_Objk);
	release_spinlock(&(AllShares.shareslock));
	return shared_Objk->ID;
}

//======================
// [5] Get Share Object:
//======================
int getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - #21] [4] SHARED MEMORY [KERNEL SIDE] - getSharedObject()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("getSharedObject is not implemented yet");
	//Your Code is Here...
	struct Env* myenv = get_cpu_proc(); //The calling environment
	struct Share * shared_Objk = get_share(ownerID, shareName);
	if (shared_Objk == NULL) {
		return E_SHARED_MEM_NOT_EXISTS;
	}
	uint32 map_perms;
	if (shared_Objk->isWritable) {
		map_perms = PERM_WRITEABLE | PERM_USER;
	} else {
		map_perms = PERM_USER;
	}
	uint32 Frames_Numb = ROUNDUP(shared_Objk->size, PAGE_SIZE) / PAGE_SIZE;
	for (uint32 s = 0; s < Frames_Numb; s++) {
		struct FrameInfo * shared_frame_ptr = shared_Objk->framesStorage[s];
		uint32 VA_of_map = ((uint32) virtual_address + (s * PAGE_SIZE));
		int map_return = map_frame(myenv->env_page_directory, shared_frame_ptr,
				VA_of_map, map_perms);
		if (map_return != 0) {
			kfree((void*) shared_Objk);

			return E_NO_SHARE;
		}
	}
	shared_Objk->references += 1;
	return shared_Objk->ID;
}

//==================================================================================//
//============================== BONUS FUNCTIONS ===================================//
//==================================================================================//

//==========================
// [B1] Delete Share Object:
//==========================
//delete the given shared object from the "shares_list"
//it should free its framesStorage and the share object itself
void free_share(struct Share* ptrShare) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [KERNEL SIDE] - free_share()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_share is not implemented yet");
	//Your Code is Here...
	if (ptrShare == NULL) {
		return;
	}
	acquire_spinlock((&(AllShares.shareslock)));
	LIST_REMOVE((&(AllShares.shares_list)), ptrShare);
	release_spinlock((&(AllShares.shareslock)));
	kfree((void*) (ptrShare->framesStorage));
	kfree((void*) ptrShare);


}
//========================
// [B2] Free Share Object:
//========================
int freeSharedObject(int32 sharedObjectID, void *startVA) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [KERNEL SIDE] - freeSharedObject()
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("freeSharedObject is not implemented yet");
	//Your Code is Here...
	struct Env* myenv = get_cpu_proc();
	struct Share *sharedObj = NULL;
	acquire_spinlock(&(AllShares.shareslock));
	struct Share* current_Shared_Obj;
	LIST_FOREACH(current_Shared_Obj, &(AllShares.shares_list))
	{
		if (current_Shared_Obj->ID == sharedObjectID) {
			release_spinlock(&(AllShares.shareslock));
			sharedObj = current_Shared_Obj;
			break;
		}
	}

	if (sharedObj == NULL) {
		release_spinlock(&(AllShares.shareslock));
		return E_SHARED_MEM_NOT_EXISTS;
	}
	uint32 Frames_Numb = ROUNDUP(sharedObj->size, PAGE_SIZE) / PAGE_SIZE;
	uint32 start=(uint32) startVA;

	for (uint32 s = 0; s < Frames_Numb; s++) {
		uint32 VA_of_map = ( start + (s * PAGE_SIZE));
		uint32 *ptrtable = NULL;
		struct FrameInfo *frame = get_frame_info(myenv->env_page_directory,VA_of_map,&ptrtable);
		unmap_frame(myenv->env_page_directory, VA_of_map);
		int isempty = 1;
		for (uint32 i = 0; i < 1024; i++) {
			if (ptrtable[i] & PERM_PRESENT) {
				isempty = 0;
				break;
			}
		}
		if (isempty) {
			kfree((void*)ptrtable);
			pd_clear_page_dir_entry(myenv->env_page_directory,
					(uint32) VA_of_map);
		}
	}
	sharedObj->references--;
	if (sharedObj->references == 0) {
		free_share(sharedObj);
	}

	tlbflush();
	return 0;
}

