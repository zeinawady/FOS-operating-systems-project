/*
 * dynamic_allocator.c
 *
 *  Created on: Sep 21, 2023
 *      Author: HP
 */
#include <inc/assert.h>
#include <inc/string.h>
#include <inc/queue.h>
#include "../inc/dynamic_allocator.h"

//==================================================================================//
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
	return (*curBlkMetaData) & ~(0x1);
}

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
	return (~(*curBlkMetaData) & 0x1) ;
}

//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
	void *va = NULL;
	switch (ALLOC_STRATEGY)
	{
	case DA_FF:
		va = alloc_block_FF(size);
		break;
	case DA_NF:
		va = alloc_block_NF(size);
		break;
	case DA_BF:
		va = alloc_block_BF(size);
		break;
	case DA_WF:
		va = alloc_block_WF(size);
		break;
	default:
		cprintf("Invalid allocation strategy\n");
		break;
	}
	return va;
}

//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");

}
//
////********************************************************************************//
////********************************************************************************//

//==================================================================================//
//============================ REQUIRED FUNCTIONS ==================================//
//==================================================================================//

bool is_initialized = 0;

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
		is_initialized = 1;
	}
	//==================================================================================
	//==================================================================================

	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
		set_block_data(block,blockSize,0);

		block->prev_next_info.le_next = NULL;
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
	{
		totalSize++;
	}

	uint32* header = (uint32 *)((uint32*)va-1);
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
	uint32* footer = (uint32*) (va + totalSize - 8);
	*footer = (totalSize & ~1) | (isAllocated & 1);
}
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
	if(LIST_EMPTY(&freeBlocksList))
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
}
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
		if (!is_initialized)
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
			uint32 da_break = (uint32)sbrk(0);
			initialize_dynamic_allocator(da_start, da_break - da_start);
		}
	}
	//==================================================================================
	//==================================================================================

	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
	{
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
		if(blockSize >= totalSize)
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
				set_block_data(remainingFreeBlock, remainingSize, 0);
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
				return (void*)((uint32*)block);
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
				return (void*)((uint32*)block);
			}
		}
	}

//	uint32 da_start = (uint32)sbrk(ROUNDUP(totalSize, PAGE_SIZE)/PAGE_SIZE);
//	uint32 da_break = (uint32)sbrk(0);

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
	if (oldBreak == (void*)-1) {
		return NULL;
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
	*endBlk = 0 | 1;

	uint32 *footerLast = ((uint32*)oldBreak - 2);
	uint32 lastSize = (*footerLast) & ~(0x1);
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
	uint32 isLastFree = is_free_block(laskBlk);
	if(isLastFree)
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
}
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
	{
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
	{
		uint32 blockSize = get_block_size(block);
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
		{
			minBlk = block;
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
	{
		void *newBlock = sbrk(totalSize);
		if (newBlock == (void*)-1) {
			return NULL;
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
		set_block_data(remainingFreeBlock, remainingSize, 0);
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
		return (void*)((uint32*)minBlk);
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
		return (void*)((uint32*)minBlk);
	}
	return NULL;
}
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
	}

	uint32 freeSize = get_block_size(va);

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
	uint32 pSize = (*footerPrev) & ~(0x1);
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
	uint32 isPrevFree = is_free_block(prevBlk);

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
		uint32 nextSize = get_block_size(nextBlk);
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
	{
		return NULL;
	}

	if(new_size == 0)
	{
		free_block(va);
		return NULL;
	}

	if(va == NULL)
	{
		return alloc_block_FF(new_size);
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
	{
		new_size++;
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
	{
		new_size = 8;
	}

	new_size += 8; // adds its footer and header size

	uint32 actualSize = get_block_size(va);

	if(actualSize == new_size)
	{
		// don't change any thing
		return va;
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
	uint32 isNextFree = is_free_block(nextBlk);
	uint32 nextSize = get_block_size(nextBlk);
	// increase the size of block
	if(new_size > actualSize)
	{
		if(isNextFree)
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
				return va;
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
					LIST_REMOVE(&freeBlocksList,nextBlk);
					return va;
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
					insert_sorted_in_freeList(nextBlk);
					return va;
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
	}
	else if(new_size < actualSize) // to shrink block
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
		{
			// don't change its size
			return va;
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
			set_block_data(remainingBlk,remainingSize,0);

			if(isNextFree)
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
				LIST_REMOVE(&freeBlocksList,nextBlk);
			}
			insert_sorted_in_freeList(remainingBlk);
			return mainBlk;
		}
	}
	return NULL;
}
/*********************************************************************************************/
/*********************************************************************************************/
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
	panic("alloc_block_WF is not implemented yet");
	return NULL;
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
	panic("alloc_block_NF is not implemented yet");
	return NULL;
}
