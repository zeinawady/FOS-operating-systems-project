#include "kheap.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"
#include "../conc/sleeplock.h"

//Initialize the dynamic allocator of kernel heap with the given start address, size & limit
//All pages in the given range should be allocated
//Remember: call the initialize_dynamic_allocator(..) to complete the initialization
//Return:
//	On success: 0
//	Otherwise (if no memory OR initial size exceed the given limit): PANIC

struct sleeplock k_lock;

int initialize_kheap_dynamic_allocator(uint32 daStart,uint32 initSizeToAllocate, uint32 daLimit) {
	//[PROJECT'24.MS2] [USER HEAP - KERNEL SIDE] initialize_kheap_dynamic_allocator
	// Write your code here, remove the panic and write your code
	//panic("initialize_kheap_dynamic_allocator() is not implemented yet...!!");

	// check if the daStart + initSizeToAllocate will fit in the defined limit
	if (daStart + initSizeToAllocate > daLimit) {
		panic("Initial size exceeds the limit");
	}

	// calc no of physical pages required
	uint32 pagesToAllocate = ROUNDUP(initSizeToAllocate, PAGE_SIZE) / PAGE_SIZE; // no. of pages

	void *currentAddress = (void *) daStart;

	//loop over required no. of pages
	for (uint32 i = 0; i < pagesToAllocate; i++) {
		//allocate frame
		struct FrameInfo *frame_info;
		if (allocate_frame(&frame_info) != 0) {
			panic("Failed to allocate a frame for kernel heap");
		}
		//map frame to va
		if (map_frame(ptr_page_directory, frame_info, (uint32) currentAddress,
				PERM_PRESENT | PERM_WRITEABLE) != 0) {
			panic("Failed to map frame into kernel heap");
		}
		currentAddress += PAGE_SIZE;
	}

	init_sleeplock(&k_lock,"Kernel Side Sleep Lock");
	kheapStart = daStart;  //starting address of heap
	kheapBreak = daStart + initSizeToAllocate; //initial end of the heap
	kheapHardLimit = daLimit; //max allowed addr for heap

	initialize_dynamic_allocator(daStart, initSizeToAllocate);
	return 0;
}

void* sbrk(int numOfPages) {
	/* numOfPages > 0: move the segment break of the kernel to increase the size of its heap by the given numOfPages,
	 *         you should allocate pages and map them into the kernel virtual address space,
	 *         and returns the address of the previous break (i.e. the beginning of newly mapped memory).
	 * numOfPages = 0: just return the current position of the segment break
	 *
	 * NOTES:
	 *   1) Allocating additional pages for a kernel dynamic allocator will fail if the free frames are exhausted
	 *     or the break exceed the limit of the dynamic allocator. If sbrk fails, kernel should panic(...)
	 */

	//MS2: COMMENT THIS LINE BEFORE START CODING====
	//return (void*)-1 ;
	//====================================================
	//[PROJECT'24.MS2] Implement this function
	// Write your code here, remove the panic and write your code
	//panic("sbrk() is not implemented yet...!!");
	acquire_sleeplock(&k_lock);
	if (numOfPages == 0) {
		release_sleeplock(&k_lock);
		return (void *) kheapBreak; // Return current break
	}

	uint32 newBreak = kheapBreak + (numOfPages * PAGE_SIZE);

	// Check if it exceeds the heap limit
	if (newBreak > kheapHardLimit) {
		release_sleeplock(&k_lock);
		return (void *) -1; // Failed to allocate memory
	}

	void *oldBreak = (void *) kheapBreak;
	// Allocate new pages
	for (uint32 addr = kheapBreak; addr < newBreak; addr += PAGE_SIZE)
	{
		struct FrameInfo *frame;
		if (allocate_frame(&frame) != 0 || map_frame(ptr_page_directory, frame, addr, PERM_PRESENT | PERM_WRITEABLE) != 0) {
			release_sleeplock(&k_lock);
			return (void *) -1; // Allocation or mapping failed
		}
	}
	// Update the break pointer
	kheapBreak = newBreak;
	release_sleeplock(&k_lock);
	return oldBreak; // Return old break

}
//TODO: [PROJECT'24.MS2 - BONUS#2] [1] KERNEL HEAP - Fast Page Allocator

void* kmalloc(unsigned int size) {
	//TODO: [PROJECT'24.MS2 - #03] [1] KERNEL HEAP - kmalloc
	// Write your code here, remove the panic and write your code
	//kpanic_into_prompt("kmalloc() is not implemented yet...!!");

	// use "isKHeapPlacementStrategyFIRSTFIT() ..." functions to check the current strategy

	if (size == 0) {
		return NULL;
	}
	// Handle small allocations using the block allocator
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
		if (isKHeapPlacementStrategyFIRSTFIT()) {
			return alloc_block_FF((uint32) size);
		} else {
			return NULL;
		}
	}

	// Handle large allocations using page allocator
	uint32 pagesToAllocate = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE; // no. of pages
	uint32 currentAddr = kheapHardLimit + PAGE_SIZE;
	uint32 kheapSize = KERNEL_HEAP_MAX - currentAddr;

	if (size > kheapSize) {
		return NULL;
	}

	int freeSpace = 0;
	int count = 0;
	int start = -1;
	acquire_sleeplock(&k_lock);
	for (uint32 i = currentAddr; i < KERNEL_HEAP_MAX; i += PAGE_SIZE)
	{
		uint32 *pageTable = NULL;
		struct FrameInfo *frame_info = get_frame_info(ptr_page_directory, i,
				&pageTable);
		if (frame_info == 0) {
			freeSpace += PAGE_SIZE;
			count++;
			if (freeSpace == ROUNDUP(size, PAGE_SIZE)) {
				start = i - ((count - 1) * PAGE_SIZE);
				break;
			}
		} else {
			freeSpace = 0;
			count = 0;
		}
	}
	if (start == -1|| count < pagesToAllocate || freeSpace < ROUNDUP(size, PAGE_SIZE)) {
		release_sleeplock(&k_lock);
		return NULL;
	}
	for (uint32 j = start; j < start + ROUNDUP(size, PAGE_SIZE); j += PAGE_SIZE)
	{
		struct FrameInfo *frame_info_ptr = NULL;
		int ret = allocate_frame(&frame_info_ptr);
		ret = map_frame(ptr_page_directory, frame_info_ptr, j,
				PERM_PRESENT | PERM_WRITEABLE);
		if (j == start) {
			frame_info_ptr->size = ROUNDUP(size, PAGE_SIZE);
		}
	}
	release_sleeplock(&k_lock);
	return (void *) start;
}

void kfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - #04] [1] KERNEL HEAP - kfree
	// Write your code here, remove the panic and write your code
	//panic("kfree() is not implemented yet...!!");
	//you need to get the size of the given allocation using its address
	//refer to the project presentation and documentation for details

	if (virtual_address == NULL) {
		return;
	}

	if ((uint32) virtual_address
			< kheapStart|| (uint32)virtual_address > KERNEL_HEAP_MAX) {
		panic("INVALID VIRTUAL ADDRESS!!");
	}

	if ((uint32) virtual_address >= kheapStart
			&& (uint32) virtual_address < kheapBreak) {
		free_block(virtual_address);
		return;
	}

	acquire_sleeplock(&k_lock);

	uint32 *pageTable = NULL;
	struct FrameInfo *frame_info = get_frame_info(ptr_page_directory,
			(uint32) virtual_address, &pageTable);
	uint32 frameSize = frame_info->size;

	if (frameSize == 0) {
		release_sleeplock(&k_lock);
		return;
	}
	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + frameSize; i += PAGE_SIZE)
			{
		uint32 *page_table = NULL;
		struct FrameInfo *frame_info = get_frame_info(ptr_page_directory, i, &page_table);
		unmap_frame(ptr_page_directory, i);
	}
	frame_info->size = 0;
	release_sleeplock(&k_lock);
}

unsigned int kheap_physical_address(unsigned int virtual_address) {
	//TODO: [PROJECT'24.MS2 - #05] [1] KERNEL HEAP - kheap_physical_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_physical_address() is not implemented yet...!!");

	//return the physical address corresponding to given virtual_address
	//refer to the project presentation and documentation for details

	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================

	acquire_sleeplock(&k_lock);
	unsigned int *ptr_page_table = NULL;
	struct FrameInfo * ptr_frame_info = get_frame_info(ptr_page_directory,
			virtual_address, &ptr_page_table);
	if (ptr_frame_info == NULL) {
		release_sleeplock(&k_lock);
		return 0;
	}

	unsigned int physical_frame_base = to_physical_address(ptr_frame_info);
	unsigned int page_offset = virtual_address & 0xFFF; // Lower 12 bits
	unsigned int physical_address = physical_frame_base + page_offset;

	release_sleeplock(&k_lock);
	return physical_address;
}

unsigned int kheap_virtual_address(unsigned int physical_address) {
	//TODO: [PROJECT'24.MS2 - #06] [1] KERNEL HEAP - kheap_virtual_address
	// Write your code here, remove the panic and write your code
	//panic("kheap_virtual_address() is not implemented yet...!!");
	//return the virtual address corresponding to given physical_address
	//refer to the project presentation and documentation for details

	//EFFICIENT IMPLEMENTATION ~O(1) IS REQUIRED ==================

	acquire_sleeplock(&k_lock);
	unsigned int *ptr_page_table = NULL;
	struct FrameInfo * ptr_frame_info = to_frame_info(physical_address);
	if (ptr_frame_info->va == 0 || ptr_frame_info == NULL) {
		release_sleeplock(&k_lock);
		return 0;
	}
	unsigned int page_offset = physical_address & 0xFFF; // Lower 12 bits
	unsigned int virtual_address = ptr_frame_info->va + page_offset;

	release_sleeplock(&k_lock);
	return virtual_address;

}
//=================================================================================//
//============================== BONUS FUNCTION ===================================//
//=================================================================================//
// krealloc():

//	Attempts to resize the allocated space at "virtual_address" to "new_size" bytes,
//	possibly moving it in the heap.
//	If successful, returns the new virtual_address, if moved to another loc: the old virtual_address must no longer be accessed.
//	On failure, returns a null pointer, and the old virtual_address remains valid.

//	A call with virtual_address = null is equivalent to kmalloc().
//	A call with new_size = zero is equivalent to kfree().

void *krealloc(void *virtual_address, uint32 new_size) {
	//TODO: [PROJECT'24.MS2 - BONUS#1] [1] KERNEL HEAP - krealloc
	// Write your code here, remove the panic and write your code
	//return NULL;
	panic("krealloc() is not implemented yet...!!");

//  our code
//	if (virtual_address == NULL && new_size == 0) {
//		return NULL;
//	}
//
//	if (new_size == 0) {
//		kfree(virtual_address);
//		return NULL;
//	}
//
//	if (virtual_address == NULL) {
//		return kmalloc(new_size);
//	}
//	if ((uint32) virtual_address
//			< kheapStart|| (uint32)virtual_address > KERNEL_HEAP_MAX) {
//		return NULL;
//	}
//
//	//was in dynamic block allocator range
//	if ((uint32) virtual_address >= kheapStart && (uint32) virtual_address < kheapBreak) {
//
//		//remains in dynamic block allocator
//		if (new_size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
//			return realloc_block_FF(virtual_address, new_size);
//		}
//
//		//remove from block allocator range TO page allocator range
//		else {
//			void * isAllocated = kmalloc(new_size);
//
//			if (isAllocated != NULL) {
//				free_block(virtual_address);
//				return isAllocated;
//			} else{
//				return NULL;  //allocation failed
//			}
//		}
//	}
//
//	//In Page Allocator Range
//
//	uint32 *pageTable = NULL;
//	struct FrameInfo *frame_info = get_frame_info(ptr_page_directory,
//			(uint32) virtual_address, &pageTable);
//	uint32 oldSize = frame_info->size;
//
//	uint32 remainingSize;
//
//	if (ROUNDUP(new_size , PAGE_SIZE) == oldSize) {
//		return virtual_address;
//	}
//
//	//increase size
//	if (new_size > oldSize) {
//		new_size = ROUNDUP(new_size, PAGE_SIZE);
//		int freeSpace = 0;
//
//		if ((uint32) virtual_address + new_size > KERNEL_HEAP_MAX) {
//			void * isAllocated = kmalloc(new_size);
//			if (isAllocated != NULL) {
//				kfree(virtual_address);
//				return isAllocated;
//			}
//			return NULL;
//		}
//		uint32 vaAllocate = (uint32) virtual_address + oldSize; //new VA that i will allocate in
//		remainingSize = new_size - oldSize;
//
//		for (uint32 i = vaAllocate; i < vaAllocate + remainingSize; i +=
//				PAGE_SIZE)
//				{
//			uint32 *pageTable = NULL;
//			struct FrameInfo *frame_info = get_frame_info(ptr_page_directory, i,
//					&pageTable);
//
//			if (frame_info != 0) {
//				break;
//			} else {
//				freeSpace += PAGE_SIZE;
//				if (freeSpace == remainingSize) {
//					break;
//				}
//			}
//		}
//
//		if (freeSpace == remainingSize) {
//			//allocate
//			acquire_sleeplock(&k_lock);
//			for (uint32 i = vaAllocate; i < vaAllocate + remainingSize; i +=
//					PAGE_SIZE) {
//				struct FrameInfo *frame_info_ptr = NULL;
//				allocate_frame(&frame_info_ptr);
//				map_frame(ptr_page_directory, frame_info_ptr, i,
//						PERM_PRESENT | PERM_WRITEABLE);
//
//			}
//
//			frame_info->size = new_size;
//			release_sleeplock(&k_lock);
//			return virtual_address;
//		} else {
//			void * isAllocated = kmalloc(new_size);
//
//			if (isAllocated != NULL) {
//				kfree(virtual_address);
//				return isAllocated;
//			}
//			return NULL;
//		}
//	}
//
//	//decrease size
//	else if (new_size < oldSize) {
//
//		if (new_size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
//			//decrease size in blocks
//
//			void * isAllocated = alloc_block_FF(new_size);
//			if (isAllocated != NULL) {
//				kfree(virtual_address);
//				return isAllocated;
//			} else {
//				return NULL;
//			}
//
//		}
//
//		//decrease size in frames
//		new_size = ROUNDUP(new_size, PAGE_SIZE);
//		remainingSize = oldSize - new_size;
//		uint32 vaFree = ((uint32) virtual_address) + new_size;
//
//		acquire_sleeplock(&k_lock);
//
//		uint32 *pageTable = NULL;
//		struct FrameInfo *framefree = get_frame_info(ptr_page_directory, vaFree,
//				&pageTable);
//		framefree->size = remainingSize;
//		kfree((void *) vaFree);
//
//		frame_info->size = new_size;
//		release_sleeplock(&k_lock);
//		return virtual_address;
//	}
//	return NULL;
}

