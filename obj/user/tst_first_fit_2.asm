
obj/user/tst_first_fit_2:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 f4 08 00 00       	call   80092a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <check_block>:
#define USER_TST_UTILITIES_H_
#include <inc/types.h>
#include <inc/stdio.h>

int check_block(void* va, void* expectedVA, uint32 expectedSize, uint8 expectedFlag)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
  80003e:	8b 45 14             	mov    0x14(%ebp),%eax
  800041:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//Check returned va
	if(va != expectedVA)
  800044:	8b 45 08             	mov    0x8(%ebp),%eax
  800047:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80004a:	74 1d                	je     800069 <check_block+0x31>
	{
		cprintf("wrong block address. Expected %x, Actual %x\n", expectedVA, va);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	ff 75 08             	pushl  0x8(%ebp)
  800052:	ff 75 0c             	pushl  0xc(%ebp)
  800055:	68 40 3d 80 00       	push   $0x803d40
  80005a:	e8 cd 0c 00 00       	call   800d2c <cprintf>
  80005f:	83 c4 10             	add    $0x10,%esp
		return 0;
  800062:	b8 00 00 00 00       	mov    $0x0,%eax
  800067:	eb 55                	jmp    8000be <check_block+0x86>
	}
	//Check header & footer
	uint32 header = *((uint32*)va-1);
  800069:	8b 45 08             	mov    0x8(%ebp),%eax
  80006c:	8b 40 fc             	mov    -0x4(%eax),%eax
  80006f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 footer = *((uint32*)(va + expectedSize - 8));
  800072:	8b 45 10             	mov    0x10(%ebp),%eax
  800075:	8d 50 f8             	lea    -0x8(%eax),%edx
  800078:	8b 45 08             	mov    0x8(%ebp),%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8b 00                	mov    (%eax),%eax
  80007f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 expectedData = expectedSize | expectedFlag ;
  800082:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  800086:	0b 45 10             	or     0x10(%ebp),%eax
  800089:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if(header != expectedData || footer != expectedData)
  80008c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80008f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800092:	75 08                	jne    80009c <check_block+0x64>
  800094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800097:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80009a:	74 1d                	je     8000b9 <check_block+0x81>
	{
		cprintf("wrong header/footer data. Expected %d, Actual H:%d F:%d\n", expectedData, header, footer);
  80009c:	ff 75 f0             	pushl  -0x10(%ebp)
  80009f:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8000a5:	68 70 3d 80 00       	push   $0x803d70
  8000aa:	e8 7d 0c 00 00       	call   800d2c <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b7:	eb 05                	jmp    8000be <check_block+0x86>
	}
	return 1;
  8000b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8000be:	c9                   	leave  
  8000bf:	c3                   	ret    

008000c0 <_main>:
short* startVAs[numOfAllocs*allocCntPerSize+1] ;
short* midVAs[numOfAllocs*allocCntPerSize+1] ;
short* endVAs[numOfAllocs*allocCntPerSize+1] ;

void _main(void)
{
  8000c0:	55                   	push   %ebp
  8000c1:	89 e5                	mov    %esp,%ebp
  8000c3:	57                   	push   %edi
  8000c4:	56                   	push   %esi
  8000c5:	53                   	push   %ebx
  8000c6:	81 ec ec 00 00 00    	sub    $0xec,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 01                	push   $0x1
  8000d1:	e8 d9 25 00 00       	call   8026af <sys_set_uheap_strategy>
  8000d6:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8000de:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  8000e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8000e9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000ef:	39 c2                	cmp    %eax,%edx
  8000f1:	72 14                	jb     800107 <_main+0x47>
			panic("Please increase the WS size");
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	68 a9 3d 80 00       	push   $0x803da9
  8000fb:	6a 26                	push   $0x26
  8000fd:	68 c5 3d 80 00       	push   $0x803dc5
  800102:	e8 68 09 00 00       	call   800a6f <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	/*=================================================*/

	int eval = 0;
  800107:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	bool is_correct = 1;
  80010e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800115:	c7 45 b4 00 00 30 00 	movl   $0x300000,-0x4c(%ebp)

	void * va ;
	int idx = 0;
  80011c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800123:	e8 d4 21 00 00       	call   8022fc <sys_pf_calculate_allocated_pages>
  800128:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 81 21 00 00       	call   8022b1 <sys_calculate_free_frames>
  800130:	89 45 ac             	mov    %eax,-0x54(%ebp)
	uint32 actualSize, block_size, blockIndex;
	int8 block_status;
	void* expectedVA;
	uint32 expectedSize, curTotalSize,roundedTotalSize ;

	void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
  800133:	c7 45 d0 04 00 00 80 	movl   $0x80000004,-0x30(%ebp)
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	68 dc 3d 80 00       	push   $0x803ddc
  800142:	e8 e5 0b 00 00       	call   800d2c <cprintf>
  800147:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80014a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		curTotalSize = sizeof(int);
  800151:	c7 45 d4 04 00 00 00 	movl   $0x4,-0x2c(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  800158:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  80015f:	e9 6f 01 00 00       	jmp    8002d3 <_main+0x213>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  800164:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80016b:	e9 53 01 00 00       	jmp    8002c3 <_main+0x203>
			{
				actualSize = allocSizes[i] - sizeOfMetaData;
  800170:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800173:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80017a:	83 e8 08             	sub    $0x8,%eax
  80017d:	89 45 a8             	mov    %eax,-0x58(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	ff 75 a8             	pushl  -0x58(%ebp)
  800186:	e8 51 19 00 00       	call   801adc <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 c2                	mov    %eax,%edx
  800190:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800193:	89 14 85 a0 50 98 00 	mov    %edx,0x9850a0(,%eax,4)
  80019a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80019d:	8b 04 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%eax
  8001a4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  8001a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001aa:	d1 e8                	shr    %eax
  8001ac:	89 c2                	mov    %eax,%edx
  8001ae:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001b1:	01 c2                	add    %eax,%edx
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	89 14 85 a0 7c 98 00 	mov    %edx,0x987ca0(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001bd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001c0:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001c6:	01 c2                	add    %eax,%edx
  8001c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cb:	89 14 85 a0 66 98 00 	mov    %edx,0x9866a0(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001d5:	83 c0 04             	add    $0x4,%eax
  8001d8:	89 45 a0             	mov    %eax,-0x60(%ebp)
				expectedSize = allocSizes[i];
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
				curTotalSize += allocSizes[i] ;
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001f2:	01 45 d4             	add    %eax,-0x2c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001f5:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  8001fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8001ff:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	48                   	dec    %eax
  800205:	89 45 98             	mov    %eax,-0x68(%ebp)
  800208:	8b 45 98             	mov    -0x68(%ebp),%eax
  80020b:	ba 00 00 00 00       	mov    $0x0,%edx
  800210:	f7 75 9c             	divl   -0x64(%ebp)
  800213:	8b 45 98             	mov    -0x68(%ebp),%eax
  800216:	29 d0                	sub    %edx,%eax
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800221:	89 45 90             	mov    %eax,-0x70(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800224:	83 7d 90 00          	cmpl   $0x0,-0x70(%ebp)
  800228:	7e 48                	jle    800272 <_main+0x1b2>
  80022a:	83 7d 90 0f          	cmpl   $0xf,-0x70(%ebp)
  80022e:	7f 42                	jg     800272 <_main+0x1b2>
				{
//					cprintf("%~\n FRAGMENTATION: curVA = %x diff = %d\n", curVA, diff);
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800230:	c7 45 8c 00 10 00 00 	movl   $0x1000,-0x74(%ebp)
  800237:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80023a:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80023d:	01 d0                	add    %edx,%eax
  80023f:	48                   	dec    %eax
  800240:	89 45 88             	mov    %eax,-0x78(%ebp)
  800243:	8b 45 88             	mov    -0x78(%ebp),%eax
  800246:	ba 00 00 00 00       	mov    $0x0,%edx
  80024b:	f7 75 8c             	divl   -0x74(%ebp)
  80024e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800251:	29 d0                	sub    %edx,%eax
  800253:	83 e8 04             	sub    $0x4,%eax
  800256:	89 45 d0             	mov    %eax,-0x30(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  800259:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80025c:	83 e8 04             	sub    $0x4,%eax
  80025f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  800262:	8b 55 90             	mov    -0x70(%ebp),%edx
  800265:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800268:	01 d0                	add    %edx,%eax
  80026a:	83 e8 04             	sub    $0x4,%eax
  80026d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800270:	eb 0d                	jmp    80027f <_main+0x1bf>
				}
				else
				{
					curVA += allocSizes[i] ;
  800272:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800275:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80027c:	01 45 d0             	add    %eax,-0x30(%ebp)
				}
				//============================================================
				if (is_correct)
  80027f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800283:	74 38                	je     8002bd <_main+0x1fd>
				{
					if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800285:	6a 01                	push   $0x1
  800287:	ff 75 d8             	pushl  -0x28(%ebp)
  80028a:	ff 75 a0             	pushl  -0x60(%ebp)
  80028d:	ff 75 a4             	pushl  -0x5c(%ebp)
  800290:	e8 a3 fd ff ff       	call   800038 <check_block>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	85 c0                	test   %eax,%eax
  80029a:	75 21                	jne    8002bd <_main+0x1fd>
					{
						if (is_correct)
  80029c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002a0:	74 1b                	je     8002bd <_main+0x1fd>
						{
							is_correct = 0;
  8002a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
							panic("alloc_block_xx #PRQ.%d: WRONG ALLOC\n", idx);
  8002a9:	ff 75 dc             	pushl  -0x24(%ebp)
  8002ac:	68 34 3e 80 00       	push   $0x803e34
  8002b1:	6a 69                	push   $0x69
  8002b3:	68 c5 3d 80 00       	push   $0x803dc5
  8002b8:	e8 b2 07 00 00       	call   800a6f <_panic>
						}
					}
				}
				idx++;
  8002bd:	ff 45 dc             	incl   -0x24(%ebp)
	{
		is_correct = 1;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8002c0:	ff 45 c8             	incl   -0x38(%ebp)
  8002c3:	81 7d c8 c7 00 00 00 	cmpl   $0xc7,-0x38(%ebp)
  8002ca:	0f 8e a0 fe ff ff    	jle    800170 <_main+0xb0>
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("PREREQUISITE#1: Try to allocate set of blocks with different sizes [all should fit]\n\n") ;
	{
		is_correct = 1;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
  8002d0:	ff 45 cc             	incl   -0x34(%ebp)
  8002d3:	83 7d cc 06          	cmpl   $0x6,-0x34(%ebp)
  8002d7:	0f 8e 87 fe ff ff    	jle    800164 <_main+0xa4>
			//if (is_correct == 0)
			//break;
		}
	}
	/* Fill the remaining space at the end of the DA*/
	roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8002dd:	c7 45 84 00 10 00 00 	movl   $0x1000,-0x7c(%ebp)
  8002e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8002e7:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	48                   	dec    %eax
  8002ed:	89 45 80             	mov    %eax,-0x80(%ebp)
  8002f0:	8b 45 80             	mov    -0x80(%ebp),%eax
  8002f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f8:	f7 75 84             	divl   -0x7c(%ebp)
  8002fb:	8b 45 80             	mov    -0x80(%ebp),%eax
  8002fe:	29 d0                	sub    %edx,%eax
  800300:	89 45 94             	mov    %eax,-0x6c(%ebp)
	uint32 remainSize = (roundedTotalSize - curTotalSize) - sizeof(int) /*END block*/;
  800303:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800306:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800309:	83 e8 04             	sub    $0x4,%eax
  80030c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	if (remainSize >= (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800312:	83 bd 7c ff ff ff 0f 	cmpl   $0xf,-0x84(%ebp)
  800319:	0f 86 87 00 00 00    	jbe    8003a6 <_main+0x2e6>
	{
		cprintf("Filling the remaining size of %d\n\n", remainSize);
  80031f:	83 ec 08             	sub    $0x8,%esp
  800322:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  800328:	68 5c 3e 80 00       	push   $0x803e5c
  80032d:	e8 fa 09 00 00       	call   800d2c <cprintf>
  800332:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800335:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80033b:	83 e8 08             	sub    $0x8,%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	6a 01                	push   $0x1
  800343:	50                   	push   %eax
  800344:	e8 1c 25 00 00       	call   802865 <alloc_block>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	89 c2                	mov    %eax,%edx
  80034e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800351:	89 14 85 a0 50 98 00 	mov    %edx,0x9850a0(,%eax,4)
  800358:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80035b:	8b 04 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%eax
  800362:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		//Check returned va
		expectedVA = curVA + sizeOfMetaData/2;
  800365:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800368:	83 c0 04             	add    $0x4,%eax
  80036b:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (check_block(va, expectedVA, remainSize, 1) == 0)
  80036e:	6a 01                	push   $0x1
  800370:	ff b5 7c ff ff ff    	pushl  -0x84(%ebp)
  800376:	ff 75 a0             	pushl  -0x60(%ebp)
  800379:	ff 75 a4             	pushl  -0x5c(%ebp)
  80037c:	e8 b7 fc ff ff       	call   800038 <check_block>
  800381:	83 c4 10             	add    $0x10,%esp
  800384:	85 c0                	test   %eax,%eax
  800386:	75 1e                	jne    8003a6 <_main+0x2e6>
		{
			is_correct = 0;
  800388:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			panic("alloc_block_xx #PRQ.oo: WRONG ALLOC\n", idx);
  80038f:	ff 75 dc             	pushl  -0x24(%ebp)
  800392:	68 80 3e 80 00       	push   $0x803e80
  800397:	68 80 00 00 00       	push   $0x80
  80039c:	68 c5 3d 80 00       	push   $0x803dc5
  8003a1:	e8 c9 06 00 00       	call   800a6f <_panic>
		}
	}

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  8003a6:	83 ec 0c             	sub    $0xc,%esp
  8003a9:	68 a8 3e 80 00       	push   $0x803ea8
  8003ae:	e8 79 09 00 00       	call   800d2c <cprintf>
  8003b3:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003b6:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  8003bd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  8003c4:	e9 98 00 00 00       	jmp    800461 <_main+0x3a1>
		{
			free(startVAs[i*allocCntPerSize]);
  8003c9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003cc:	89 d0                	mov    %edx,%eax
  8003ce:	c1 e0 02             	shl    $0x2,%eax
  8003d1:	01 d0                	add    %edx,%eax
  8003d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003da:	01 d0                	add    %edx,%eax
  8003dc:	c1 e0 03             	shl    $0x3,%eax
  8003df:	8b 04 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%eax
  8003e6:	83 ec 0c             	sub    $0xc,%esp
  8003e9:	50                   	push   %eax
  8003ea:	e8 a3 18 00 00       	call   801c92 <free>
  8003ef:	83 c4 10             	add    $0x10,%esp
			if (check_block(startVAs[i*allocCntPerSize], startVAs[i*allocCntPerSize], allocSizes[i], 0) == 0)
  8003f2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003f5:	8b 0c 85 00 50 80 00 	mov    0x805000(,%eax,4),%ecx
  8003fc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003ff:	89 d0                	mov    %edx,%eax
  800401:	c1 e0 02             	shl    $0x2,%eax
  800404:	01 d0                	add    %edx,%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	01 d0                	add    %edx,%eax
  80040f:	c1 e0 03             	shl    $0x3,%eax
  800412:	8b 14 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%edx
  800419:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80041c:	89 d8                	mov    %ebx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d8                	add    %ebx,%eax
  800423:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  80042a:	01 d8                	add    %ebx,%eax
  80042c:	c1 e0 03             	shl    $0x3,%eax
  80042f:	8b 04 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%eax
  800436:	6a 00                	push   $0x0
  800438:	51                   	push   %ecx
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	e8 f8 fb ff ff       	call   800038 <check_block>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	85 c0                	test   %eax,%eax
  800445:	75 17                	jne    80045e <_main+0x39e>
			{
				is_correct = 0;
  800447:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_ff_2 #1.1: WRONG FREE!\n");
  80044e:	83 ec 0c             	sub    $0xc,%esp
  800451:	68 f0 3e 80 00       	push   $0x803ef0
  800456:	e8 d1 08 00 00       	call   800d2c <cprintf>
  80045b:	83 c4 10             	add    $0x10,%esp
	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		is_correct = 1;
		for (int i = 0; i < numOfAllocs; ++i)
  80045e:	ff 45 c4             	incl   -0x3c(%ebp)
  800461:	83 7d c4 06          	cmpl   $0x6,-0x3c(%ebp)
  800465:	0f 8e 5e ff ff ff    	jle    8003c9 <_main+0x309>
	short* tstMidVAs[numOfFFTests+1] ;
	short* tstEndVAs[numOfFFTests+1] ;

	//====================================================================//
	/*FF ALLOC Scenario 2: Try to allocate blocks with sizes smaller than existing free blocks*/
	cprintf("2: Try to allocate set of blocks with different sizes smaller than existing free blocks\n\n") ;
  80046b:	83 ec 0c             	sub    $0xc,%esp
  80046e:	68 10 3f 80 00       	push   $0x803f10
  800473:	e8 b4 08 00 00       	call   800d2c <cprintf>
  800478:	83 c4 10             	add    $0x10,%esp

	uint32 testSizes[numOfFFTests] =
  80047b:	8d 85 2c ff ff ff    	lea    -0xd4(%ebp),%eax
  800481:	bb d4 42 80 00       	mov    $0x8042d4,%ebx
  800486:	ba 03 00 00 00       	mov    $0x3,%edx
  80048b:	89 c7                	mov    %eax,%edi
  80048d:	89 de                	mov    %ebx,%esi
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	{
			kilo/4,								//expected to be allocated in 4th free block
			8*sizeof(char) + sizeOfMetaData, 	//expected to be allocated in 1st free block
			kilo/8,								//expected to be allocated in remaining of 4th free block
	} ;
	uint32 expectedSizes[numOfFFTests] =
  800493:	c7 85 20 ff ff ff 00 	movl   $0x100,-0xe0(%ebp)
  80049a:	01 00 00 
	{
			kilo/4,					//expected to be allocated in 4th free block
			allocSizes[0], 			//INTERNAL FRAGMENTATION CASE in 1st Block
  80049d:	a1 00 50 80 00       	mov    0x805000,%eax
	{
			kilo/4,								//expected to be allocated in 4th free block
			8*sizeof(char) + sizeOfMetaData, 	//expected to be allocated in 1st free block
			kilo/8,								//expected to be allocated in remaining of 4th free block
	} ;
	uint32 expectedSizes[numOfFFTests] =
  8004a2:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  8004a8:	c7 85 28 ff ff ff 80 	movl   $0x80,-0xd8(%ebp)
  8004af:	00 00 00 
	{
			kilo/4,					//expected to be allocated in 4th free block
			allocSizes[0], 			//INTERNAL FRAGMENTATION CASE in 1st Block
			kilo/8,					//expected to be allocated in remaining of 4th free block
	} ;
	uint32 startOf1stFreeBlock = (uint32)startVAs[0*allocCntPerSize];
  8004b2:	a1 a0 50 98 00       	mov    0x9850a0,%eax
  8004b7:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];
  8004bd:	a1 00 5a 98 00       	mov    0x985a00,%eax
  8004c2:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	{
		is_correct = 1;
  8004c8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		uint32 expectedVAs[numOfFFTests] =
  8004cf:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004d5:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  8004db:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004e1:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
  8004e7:	8b 95 2c ff ff ff    	mov    -0xd4(%ebp),%edx
  8004ed:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8004f3:	01 d0                	add    %edx,%eax
	uint32 startOf4thFreeBlock = (uint32)startVAs[3*allocCntPerSize];

	{
		is_correct = 1;

		uint32 expectedVAs[numOfFFTests] =
  8004f5:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  8004fb:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800502:	e9 ef 00 00 00       	jmp    8005f6 <_main+0x536>
		{
			actualSize = testSizes[i] - sizeOfMetaData;
  800507:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80050a:	8b 84 85 2c ff ff ff 	mov    -0xd4(%ebp,%eax,4),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	89 45 a8             	mov    %eax,-0x58(%ebp)
			va = tstStartVAs[i] = malloc(actualSize);
  800517:	83 ec 0c             	sub    $0xc,%esp
  80051a:	ff 75 a8             	pushl  -0x58(%ebp)
  80051d:	e8 ba 15 00 00       	call   801adc <malloc>
  800522:	83 c4 10             	add    $0x10,%esp
  800525:	89 c2                	mov    %eax,%edx
  800527:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80052a:	89 94 85 58 ff ff ff 	mov    %edx,-0xa8(%ebp,%eax,4)
  800531:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800534:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  80053b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			tstMidVAs[i] = va + actualSize/2 ;
  80053e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800541:	d1 e8                	shr    %eax
  800543:	89 c2                	mov    %eax,%edx
  800545:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800548:	01 c2                	add    %eax,%edx
  80054a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80054d:	89 94 85 48 ff ff ff 	mov    %edx,-0xb8(%ebp,%eax,4)
			tstEndVAs[i] = va + actualSize - sizeof(short);
  800554:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800557:	8d 50 fe             	lea    -0x2(%eax),%edx
  80055a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80055d:	01 c2                	add    %eax,%edx
  80055f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800562:	89 94 85 38 ff ff ff 	mov    %edx,-0xc8(%ebp,%eax,4)
			//Check returned va
			if (check_block(tstStartVAs[i], (void*) expectedVAs[i], expectedSizes[i], 1) == 0)
  800569:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80056c:	8b 94 85 20 ff ff ff 	mov    -0xe0(%ebp,%eax,4),%edx
  800573:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800576:	8b 84 85 14 ff ff ff 	mov    -0xec(%ebp,%eax,4),%eax
  80057d:	89 c1                	mov    %eax,%ecx
  80057f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800582:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  800589:	6a 01                	push   $0x1
  80058b:	52                   	push   %edx
  80058c:	51                   	push   %ecx
  80058d:	50                   	push   %eax
  80058e:	e8 a5 fa ff ff       	call   800038 <check_block>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	85 c0                	test   %eax,%eax
  800598:	75 1a                	jne    8005b4 <_main+0x4f4>
			{
				is_correct = 0;
  80059a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_ff_2 #2.%d: WRONG ALLOCATE AFTER FREE!\n", i);
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	ff 75 c0             	pushl  -0x40(%ebp)
  8005a7:	68 6c 3f 80 00       	push   $0x803f6c
  8005ac:	e8 7b 07 00 00       	call   800d2c <cprintf>
  8005b1:	83 c4 10             	add    $0x10,%esp
			}
			*(tstStartVAs[i]) = 353 + i;
  8005b4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005b7:	8b 94 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%edx
  8005be:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005c1:	05 61 01 00 00       	add    $0x161,%eax
  8005c6:	66 89 02             	mov    %ax,(%edx)
			*(tstMidVAs[i]) = 353 + i;
  8005c9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005cc:	8b 94 85 48 ff ff ff 	mov    -0xb8(%ebp,%eax,4),%edx
  8005d3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005d6:	05 61 01 00 00       	add    $0x161,%eax
  8005db:	66 89 02             	mov    %ax,(%edx)
			*(tstEndVAs[i]) = 353 + i;
  8005de:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005e1:	8b 94 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%edx
  8005e8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8005eb:	05 61 01 00 00       	add    $0x161,%eax
  8005f0:	66 89 02             	mov    %ax,(%edx)
		{
				startOf4thFreeBlock,
				startOf1stFreeBlock,
				startOf4thFreeBlock + testSizes[0]
		};
		for (int i = 0; i < numOfFFTests; ++i)
  8005f3:	ff 45 c0             	incl   -0x40(%ebp)
  8005f6:	83 7d c0 02          	cmpl   $0x2,-0x40(%ebp)
  8005fa:	0f 8e 07 ff ff ff    	jle    800507 <_main+0x447>
			*(tstStartVAs[i]) = 353 + i;
			*(tstMidVAs[i]) = 353 + i;
			*(tstEndVAs[i]) = 353 + i;
		}
		//Check stored sizes
		if(get_block_size(tstStartVAs[1]) != allocSizes[0])
  800600:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800606:	83 ec 0c             	sub    $0xc,%esp
  800609:	50                   	push   %eax
  80060a:	e8 1f 22 00 00       	call   80282e <get_block_size>
  80060f:	83 c4 10             	add    $0x10,%esp
  800612:	89 c2                	mov    %eax,%edx
  800614:	a1 00 50 80 00       	mov    0x805000,%eax
  800619:	39 c2                	cmp    %eax,%edx
  80061b:	74 17                	je     800634 <_main+0x574>
		{
			is_correct = 0;
  80061d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_ff_2 #2.3: WRONG FF ALLOC - make sure if the remaining free space doesn’t fit a dynamic allocator block, then this area should be added to the allocated area and counted as internal fragmentation\n");
  800624:	83 ec 0c             	sub    $0xc,%esp
  800627:	68 9c 3f 80 00       	push   $0x803f9c
  80062c:	e8 fb 06 00 00       	call   800d2c <cprintf>
  800631:	83 c4 10             	add    $0x10,%esp
			//break;
		}
		if (is_correct)
  800634:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800638:	74 04                	je     80063e <_main+0x57e>
		{
			eval += 30;
  80063a:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 3: Try to allocate a block with a size equal to the size of the first existing free block*/
	cprintf("3: Try to allocate a block with equal to the first existing free block\n\n") ;
  80063e:	83 ec 0c             	sub    $0xc,%esp
  800641:	68 68 40 80 00       	push   $0x804068
  800646:	e8 e1 06 00 00       	call   800d2c <cprintf>
  80064b:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80064e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		actualSize = kilo/8 - sizeOfMetaData; 	//expected to be allocated in remaining of 4th free block
  800655:	c7 45 a8 78 00 00 00 	movl   $0x78,-0x58(%ebp)
		expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  80065c:	c7 85 70 ff ff ff 02 	movl   $0x2,-0x90(%ebp)
  800663:	00 00 00 
  800666:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800669:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	83 c0 07             	add    $0x7,%eax
  800674:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  80067a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	f7 b5 70 ff ff ff    	divl   -0x90(%ebp)
  80068b:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800691:	29 d0                	sub    %edx,%eax
  800693:	89 45 d8             	mov    %eax,-0x28(%ebp)
		va = tstStartVAs[numOfFFTests] = malloc(actualSize);
  800696:	83 ec 0c             	sub    $0xc,%esp
  800699:	ff 75 a8             	pushl  -0x58(%ebp)
  80069c:	e8 3b 14 00 00       	call   801adc <malloc>
  8006a1:	83 c4 10             	add    $0x10,%esp
  8006a4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  8006aa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006b0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		tstMidVAs[numOfFFTests] = va + actualSize/2 ;
  8006b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8006b6:	d1 e8                	shr    %eax
  8006b8:	89 c2                	mov    %eax,%edx
  8006ba:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006bd:	01 d0                	add    %edx,%eax
  8006bf:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		tstEndVAs[numOfFFTests] = va + actualSize - sizeof(short);
  8006c5:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8006c8:	8d 50 fe             	lea    -0x2(%eax),%edx
  8006cb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8006ce:	01 d0                	add    %edx,%eax
  8006d0:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		//Check returned va
		expectedVA = (void*)(startOf4thFreeBlock + testSizes[0] + testSizes[2]) ;
  8006d6:	8b 95 2c ff ff ff    	mov    -0xd4(%ebp),%edx
  8006dc:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e2:	01 c2                	add    %eax,%edx
  8006e4:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  8006ea:	01 d0                	add    %edx,%eax
  8006ec:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (check_block(tstStartVAs[numOfFFTests], expectedVA, expectedSize, 1) == 0)
  8006ef:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8006f5:	6a 01                	push   $0x1
  8006f7:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fa:	ff 75 a0             	pushl  -0x60(%ebp)
  8006fd:	50                   	push   %eax
  8006fe:	e8 35 f9 ff ff       	call   800038 <check_block>
  800703:	83 c4 10             	add    $0x10,%esp
  800706:	85 c0                	test   %eax,%eax
  800708:	75 17                	jne    800721 <_main+0x661>
		{
			is_correct = 0;
  80070a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_ff_2 #3: WRONG ALLOCATE AFTER FREE!\n");
  800711:	83 ec 0c             	sub    $0xc,%esp
  800714:	68 b4 40 80 00       	push   $0x8040b4
  800719:	e8 0e 06 00 00       	call   800d2c <cprintf>
  80071e:	83 c4 10             	add    $0x10,%esp
		}
		*(tstStartVAs[numOfFFTests]) = 353 + numOfFFTests;
  800721:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800727:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstMidVAs[numOfFFTests]) = 353 + numOfFFTests;
  80072c:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800732:	66 c7 00 64 01       	movw   $0x164,(%eax)
		*(tstEndVAs[numOfFFTests]) = 353 + numOfFFTests;
  800737:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  80073d:	66 c7 00 64 01       	movw   $0x164,(%eax)

		if (is_correct)
  800742:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800746:	74 04                	je     80074c <_main+0x68c>
		{
			eval += 30;
  800748:	83 45 e4 1e          	addl   $0x1e,-0x1c(%ebp)
		}
	}
	//====================================================================//
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
  80074c:	83 ec 0c             	sub    $0xc,%esp
  80074f:	68 e0 40 80 00       	push   $0x8040e0
  800754:	e8 d3 05 00 00       	call   800d2c <cprintf>
  800759:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80075c:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)

		for (int i = 0; i <= numOfFFTests; ++i)
  800763:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
  80076a:	e9 ab 00 00 00       	jmp    80081a <_main+0x75a>
		{
			//cprintf("startVA = %x, mid = %x, last = %x\n", tstStartVAs[i], tstMidVAs[i], tstEndVAs[i]);
			if (*(tstStartVAs[i]) != (353+i) || *(tstMidVAs[i]) != (353+i) || *(tstEndVAs[i]) != (353+i) )
  80076f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800772:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  800779:	66 8b 00             	mov    (%eax),%ax
  80077c:	98                   	cwtl   
  80077d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800780:	81 c2 61 01 00 00    	add    $0x161,%edx
  800786:	39 d0                	cmp    %edx,%eax
  800788:	75 36                	jne    8007c0 <_main+0x700>
  80078a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80078d:	8b 84 85 48 ff ff ff 	mov    -0xb8(%ebp,%eax,4),%eax
  800794:	66 8b 00             	mov    (%eax),%ax
  800797:	98                   	cwtl   
  800798:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80079b:	81 c2 61 01 00 00    	add    $0x161,%edx
  8007a1:	39 d0                	cmp    %edx,%eax
  8007a3:	75 1b                	jne    8007c0 <_main+0x700>
  8007a5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007a8:	8b 84 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%eax
  8007af:	66 8b 00             	mov    (%eax),%ax
  8007b2:	98                   	cwtl   
  8007b3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8007b6:	81 c2 61 01 00 00    	add    $0x161,%edx
  8007bc:	39 d0                	cmp    %edx,%eax
  8007be:	74 57                	je     800817 <_main+0x757>
			{
				is_correct = 0;
  8007c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc #4.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
  8007c7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007ca:	8b 84 85 38 ff ff ff 	mov    -0xc8(%ebp,%eax,4),%eax
  8007d1:	66 8b 00             	mov    (%eax),%ax
  8007d4:	0f bf c8             	movswl %ax,%ecx
  8007d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007da:	8b 84 85 48 ff ff ff 	mov    -0xb8(%ebp,%eax,4),%eax
  8007e1:	66 8b 00             	mov    (%eax),%ax
  8007e4:	0f bf d0             	movswl %ax,%edx
  8007e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8007ea:	8b 84 85 58 ff ff ff 	mov    -0xa8(%ebp,%eax,4),%eax
  8007f1:	66 8b 00             	mov    (%eax),%ax
  8007f4:	98                   	cwtl   
  8007f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8007f8:	81 c3 61 01 00 00    	add    $0x161,%ebx
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	51                   	push   %ecx
  800802:	52                   	push   %edx
  800803:	50                   	push   %eax
  800804:	53                   	push   %ebx
  800805:	ff 75 bc             	pushl  -0x44(%ebp)
  800808:	68 14 41 80 00       	push   $0x804114
  80080d:	e8 1a 05 00 00       	call   800d2c <cprintf>
  800812:	83 c4 20             	add    $0x20,%esp
				break;
  800815:	eb 0d                	jmp    800824 <_main+0x764>
	/*FF ALLOC Scenario 4: Check stored data inside each allocated block*/
	cprintf("4: Check stored data inside each allocated block\n\n") ;
	{
		is_correct = 1;

		for (int i = 0; i <= numOfFFTests; ++i)
  800817:	ff 45 bc             	incl   -0x44(%ebp)
  80081a:	83 7d bc 03          	cmpl   $0x3,-0x44(%ebp)
  80081e:	0f 8e 4b ff ff ff    	jle    80076f <_main+0x6af>
				cprintf("malloc #4.%d: WRONG! content of the block is not correct. Expected=%d, val1=%d, val2=%d, val3=%d\n",i, (353+i), *(tstStartVAs[i]), *(tstMidVAs[i]), *(tstEndVAs[i]));
				break;
			}
		}

		if (is_correct)
  800824:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800828:	74 04                	je     80082e <_main+0x76e>
		{
			eval += 20;
  80082a:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*FF ALLOC Scenario 5: Test a Non-Granted Request */
	cprintf("5: Test a Non-Granted Request\n\n") ;
  80082e:	83 ec 0c             	sub    $0xc,%esp
  800831:	68 78 41 80 00       	push   $0x804178
  800836:	e8 f1 04 00 00       	call   800d2c <cprintf>
  80083b:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  80083e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		actualSize = 2*kilo - sizeOfMetaData;
  800845:	c7 45 a8 f8 07 00 00 	movl   $0x7f8,-0x58(%ebp)

		//Fill the 7th free block
		va = malloc(actualSize);
  80084c:	83 ec 0c             	sub    $0xc,%esp
  80084f:	ff 75 a8             	pushl  -0x58(%ebp)
  800852:	e8 85 12 00 00       	call   801adc <malloc>
  800857:	83 c4 10             	add    $0x10,%esp
  80085a:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
  80085d:	83 ec 0c             	sub    $0xc,%esp
  800860:	6a 00                	push   $0x0
  800862:	e8 5f 12 00 00       	call   801ac6 <sbrk>
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	ba 00 00 00 82       	mov    $0x82000000,%edx
  80086f:	29 c2                	sub    %eax,%edx
  800871:	89 d0                	mov    %edx,%eax
  800873:	c1 e8 0c             	shr    $0xc,%eax
  800876:	01 c0                	add    %eax,%eax
  800878:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  80087e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  800885:	eb 33                	jmp    8008ba <_main+0x7fa>
		{
			va = malloc(actualSize);
  800887:	83 ec 0c             	sub    $0xc,%esp
  80088a:	ff 75 a8             	pushl  -0x58(%ebp)
  80088d:	e8 4a 12 00 00       	call   801adc <malloc>
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if(va == NULL)
  800898:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  80089c:	75 19                	jne    8008b7 <_main+0x7f7>
			{
				is_correct = 0;
  80089e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("malloc() #5.%d: WRONG FF ALLOC - alloc_block_FF return NULL address while it's expected to return correct one.\n");
  8008a5:	83 ec 0c             	sub    $0xc,%esp
  8008a8:	68 98 41 80 00       	push   $0x804198
  8008ad:	e8 7a 04 00 00       	call   800d2c <cprintf>
  8008b2:	83 c4 10             	add    $0x10,%esp
				break;
  8008b5:	eb 0e                	jmp    8008c5 <_main+0x805>
		//Fill the 7th free block
		va = malloc(actualSize);

		//Fill the remaining area
		uint32 numOfRem2KBAllocs = ((USER_HEAP_START + DYN_ALLOC_MAX_SIZE - (uint32)sbrk(0)) / PAGE_SIZE) * 2;
		for (int i = 0; i < numOfRem2KBAllocs; ++i)
  8008b7:	ff 45 b8             	incl   -0x48(%ebp)
  8008ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8008bd:	3b 85 68 ff ff ff    	cmp    -0x98(%ebp),%eax
  8008c3:	72 c2                	jb     800887 <_main+0x7c7>
				break;
			}
		}

		//Test two more allocs
		va = malloc(actualSize);
  8008c5:	83 ec 0c             	sub    $0xc,%esp
  8008c8:	ff 75 a8             	pushl  -0x58(%ebp)
  8008cb:	e8 0c 12 00 00       	call   801adc <malloc>
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		va = malloc(actualSize);
  8008d6:	83 ec 0c             	sub    $0xc,%esp
  8008d9:	ff 75 a8             	pushl  -0x58(%ebp)
  8008dc:	e8 fb 11 00 00       	call   801adc <malloc>
  8008e1:	83 c4 10             	add    $0x10,%esp
  8008e4:	89 45 a4             	mov    %eax,-0x5c(%ebp)

		if(va != NULL)
  8008e7:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  8008eb:	74 17                	je     800904 <_main+0x844>
		{
			is_correct = 0;
  8008ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("malloc() #6: WRONG FF ALLOC - alloc_block_FF return an address while it's expected to return NULL since it reaches the hard limit.\n");
  8008f4:	83 ec 0c             	sub    $0xc,%esp
  8008f7:	68 08 42 80 00       	push   $0x804208
  8008fc:	e8 2b 04 00 00       	call   800d2c <cprintf>
  800901:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800904:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800908:	74 04                	je     80090e <_main+0x84e>
		{
			eval += 20;
  80090a:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}
	cprintf("test FIRST FIT (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	ff 75 e4             	pushl  -0x1c(%ebp)
  800914:	68 8c 42 80 00       	push   $0x80428c
  800919:	e8 0e 04 00 00       	call   800d2c <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp

	return;
  800921:	90                   	nop
}
  800922:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800925:	5b                   	pop    %ebx
  800926:	5e                   	pop    %esi
  800927:	5f                   	pop    %edi
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800930:	e8 45 1b 00 00       	call   80247a <sys_getenvindex>
  800935:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800938:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80093b:	89 d0                	mov    %edx,%eax
  80093d:	c1 e0 02             	shl    $0x2,%eax
  800940:	01 d0                	add    %edx,%eax
  800942:	c1 e0 03             	shl    $0x3,%eax
  800945:	01 d0                	add    %edx,%eax
  800947:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80094e:	01 d0                	add    %edx,%eax
  800950:	c1 e0 02             	shl    $0x2,%eax
  800953:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800958:	a3 40 50 80 00       	mov    %eax,0x805040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80095d:	a1 40 50 80 00       	mov    0x805040,%eax
  800962:	8a 40 20             	mov    0x20(%eax),%al
  800965:	84 c0                	test   %al,%al
  800967:	74 0d                	je     800976 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800969:	a1 40 50 80 00       	mov    0x805040,%eax
  80096e:	83 c0 20             	add    $0x20,%eax
  800971:	a3 20 50 80 00       	mov    %eax,0x805020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800976:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80097a:	7e 0a                	jle    800986 <libmain+0x5c>
		binaryname = argv[0];
  80097c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097f:	8b 00                	mov    (%eax),%eax
  800981:	a3 20 50 80 00       	mov    %eax,0x805020

	// call user main routine
	_main(argc, argv);
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	ff 75 08             	pushl  0x8(%ebp)
  80098f:	e8 2c f7 ff ff       	call   8000c0 <_main>
  800994:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800997:	a1 1c 50 80 00       	mov    0x80501c,%eax
  80099c:	85 c0                	test   %eax,%eax
  80099e:	0f 84 9f 00 00 00    	je     800a43 <libmain+0x119>
	{
		sys_lock_cons();
  8009a4:	e8 55 18 00 00       	call   8021fe <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8009a9:	83 ec 0c             	sub    $0xc,%esp
  8009ac:	68 f8 42 80 00       	push   $0x8042f8
  8009b1:	e8 76 03 00 00       	call   800d2c <cprintf>
  8009b6:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009b9:	a1 40 50 80 00       	mov    0x805040,%eax
  8009be:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8009c4:	a1 40 50 80 00       	mov    0x805040,%eax
  8009c9:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8009cf:	83 ec 04             	sub    $0x4,%esp
  8009d2:	52                   	push   %edx
  8009d3:	50                   	push   %eax
  8009d4:	68 20 43 80 00       	push   $0x804320
  8009d9:	e8 4e 03 00 00       	call   800d2c <cprintf>
  8009de:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8009e1:	a1 40 50 80 00       	mov    0x805040,%eax
  8009e6:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8009ec:	a1 40 50 80 00       	mov    0x805040,%eax
  8009f1:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8009f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8009fc:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800a02:	51                   	push   %ecx
  800a03:	52                   	push   %edx
  800a04:	50                   	push   %eax
  800a05:	68 48 43 80 00       	push   $0x804348
  800a0a:	e8 1d 03 00 00       	call   800d2c <cprintf>
  800a0f:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a12:	a1 40 50 80 00       	mov    0x805040,%eax
  800a17:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	50                   	push   %eax
  800a21:	68 a0 43 80 00       	push   $0x8043a0
  800a26:	e8 01 03 00 00       	call   800d2c <cprintf>
  800a2b:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800a2e:	83 ec 0c             	sub    $0xc,%esp
  800a31:	68 f8 42 80 00       	push   $0x8042f8
  800a36:	e8 f1 02 00 00       	call   800d2c <cprintf>
  800a3b:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800a3e:	e8 d5 17 00 00       	call   802218 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800a43:	e8 19 00 00 00       	call   800a61 <exit>
}
  800a48:	90                   	nop
  800a49:	c9                   	leave  
  800a4a:	c3                   	ret    

00800a4b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a4b:	55                   	push   %ebp
  800a4c:	89 e5                	mov    %esp,%ebp
  800a4e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a51:	83 ec 0c             	sub    $0xc,%esp
  800a54:	6a 00                	push   $0x0
  800a56:	e8 eb 19 00 00       	call   802446 <sys_destroy_env>
  800a5b:	83 c4 10             	add    $0x10,%esp
}
  800a5e:	90                   	nop
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <exit>:

void
exit(void)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a67:	e8 40 1a 00 00       	call   8024ac <sys_exit_env>
}
  800a6c:	90                   	nop
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a75:	8d 45 10             	lea    0x10(%ebp),%eax
  800a78:	83 c0 04             	add    $0x4,%eax
  800a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a7e:	a1 8c 92 98 00       	mov    0x98928c,%eax
  800a83:	85 c0                	test   %eax,%eax
  800a85:	74 16                	je     800a9d <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a87:	a1 8c 92 98 00       	mov    0x98928c,%eax
  800a8c:	83 ec 08             	sub    $0x8,%esp
  800a8f:	50                   	push   %eax
  800a90:	68 b4 43 80 00       	push   $0x8043b4
  800a95:	e8 92 02 00 00       	call   800d2c <cprintf>
  800a9a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	ff 75 08             	pushl  0x8(%ebp)
  800aa8:	50                   	push   %eax
  800aa9:	68 b9 43 80 00       	push   $0x8043b9
  800aae:	e8 79 02 00 00       	call   800d2c <cprintf>
  800ab3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	83 ec 08             	sub    $0x8,%esp
  800abc:	ff 75 f4             	pushl  -0xc(%ebp)
  800abf:	50                   	push   %eax
  800ac0:	e8 fc 01 00 00       	call   800cc1 <vcprintf>
  800ac5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	6a 00                	push   $0x0
  800acd:	68 d5 43 80 00       	push   $0x8043d5
  800ad2:	e8 ea 01 00 00       	call   800cc1 <vcprintf>
  800ad7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800ada:	e8 82 ff ff ff       	call   800a61 <exit>

	// should not return here
	while (1) ;
  800adf:	eb fe                	jmp    800adf <_panic+0x70>

00800ae1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800ae7:	a1 40 50 80 00       	mov    0x805040,%eax
  800aec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	39 c2                	cmp    %eax,%edx
  800af7:	74 14                	je     800b0d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800af9:	83 ec 04             	sub    $0x4,%esp
  800afc:	68 d8 43 80 00       	push   $0x8043d8
  800b01:	6a 26                	push   $0x26
  800b03:	68 24 44 80 00       	push   $0x804424
  800b08:	e8 62 ff ff ff       	call   800a6f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b14:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b1b:	e9 c5 00 00 00       	jmp    800be5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	01 d0                	add    %edx,%eax
  800b2f:	8b 00                	mov    (%eax),%eax
  800b31:	85 c0                	test   %eax,%eax
  800b33:	75 08                	jne    800b3d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800b35:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b38:	e9 a5 00 00 00       	jmp    800be2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800b3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b44:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b4b:	eb 69                	jmp    800bb6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b4d:	a1 40 50 80 00       	mov    0x805040,%eax
  800b52:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800b58:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b5b:	89 d0                	mov    %edx,%eax
  800b5d:	01 c0                	add    %eax,%eax
  800b5f:	01 d0                	add    %edx,%eax
  800b61:	c1 e0 03             	shl    $0x3,%eax
  800b64:	01 c8                	add    %ecx,%eax
  800b66:	8a 40 04             	mov    0x4(%eax),%al
  800b69:	84 c0                	test   %al,%al
  800b6b:	75 46                	jne    800bb3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b6d:	a1 40 50 80 00       	mov    0x805040,%eax
  800b72:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800b78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b7b:	89 d0                	mov    %edx,%eax
  800b7d:	01 c0                	add    %eax,%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	c1 e0 03             	shl    $0x3,%eax
  800b84:	01 c8                	add    %ecx,%eax
  800b86:	8b 00                	mov    (%eax),%eax
  800b88:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b8b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b8e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b93:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	01 c8                	add    %ecx,%eax
  800ba4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ba6:	39 c2                	cmp    %eax,%edx
  800ba8:	75 09                	jne    800bb3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800baa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bb1:	eb 15                	jmp    800bc8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bb3:	ff 45 e8             	incl   -0x18(%ebp)
  800bb6:	a1 40 50 80 00       	mov    0x805040,%eax
  800bbb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800bc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800bc4:	39 c2                	cmp    %eax,%edx
  800bc6:	77 85                	ja     800b4d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800bc8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bcc:	75 14                	jne    800be2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800bce:	83 ec 04             	sub    $0x4,%esp
  800bd1:	68 30 44 80 00       	push   $0x804430
  800bd6:	6a 3a                	push   $0x3a
  800bd8:	68 24 44 80 00       	push   $0x804424
  800bdd:	e8 8d fe ff ff       	call   800a6f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800be2:	ff 45 f0             	incl   -0x10(%ebp)
  800be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800beb:	0f 8c 2f ff ff ff    	jl     800b20 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800bf1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bf8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800bff:	eb 26                	jmp    800c27 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c01:	a1 40 50 80 00       	mov    0x805040,%eax
  800c06:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800c0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c0f:	89 d0                	mov    %edx,%eax
  800c11:	01 c0                	add    %eax,%eax
  800c13:	01 d0                	add    %edx,%eax
  800c15:	c1 e0 03             	shl    $0x3,%eax
  800c18:	01 c8                	add    %ecx,%eax
  800c1a:	8a 40 04             	mov    0x4(%eax),%al
  800c1d:	3c 01                	cmp    $0x1,%al
  800c1f:	75 03                	jne    800c24 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800c21:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c24:	ff 45 e0             	incl   -0x20(%ebp)
  800c27:	a1 40 50 80 00       	mov    0x805040,%eax
  800c2c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800c32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c35:	39 c2                	cmp    %eax,%edx
  800c37:	77 c8                	ja     800c01 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c3c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c3f:	74 14                	je     800c55 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800c41:	83 ec 04             	sub    $0x4,%esp
  800c44:	68 84 44 80 00       	push   $0x804484
  800c49:	6a 44                	push   $0x44
  800c4b:	68 24 44 80 00       	push   $0x804424
  800c50:	e8 1a fe ff ff       	call   800a6f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c55:	90                   	nop
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	8d 48 01             	lea    0x1(%eax),%ecx
  800c66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c69:	89 0a                	mov    %ecx,(%edx)
  800c6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6e:	88 d1                	mov    %dl,%cl
  800c70:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c73:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c81:	75 2c                	jne    800caf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c83:	a0 80 50 98 00       	mov    0x985080,%al
  800c88:	0f b6 c0             	movzbl %al,%eax
  800c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8e:	8b 12                	mov    (%edx),%edx
  800c90:	89 d1                	mov    %edx,%ecx
  800c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c95:	83 c2 08             	add    $0x8,%edx
  800c98:	83 ec 04             	sub    $0x4,%esp
  800c9b:	50                   	push   %eax
  800c9c:	51                   	push   %ecx
  800c9d:	52                   	push   %edx
  800c9e:	e8 19 15 00 00       	call   8021bc <sys_cputs>
  800ca3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800caf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb2:	8b 40 04             	mov    0x4(%eax),%eax
  800cb5:	8d 50 01             	lea    0x1(%eax),%edx
  800cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbb:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cbe:	90                   	nop
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800cca:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800cd1:	00 00 00 
	b.cnt = 0;
  800cd4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800cdb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800cde:	ff 75 0c             	pushl  0xc(%ebp)
  800ce1:	ff 75 08             	pushl  0x8(%ebp)
  800ce4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cea:	50                   	push   %eax
  800ceb:	68 58 0c 80 00       	push   $0x800c58
  800cf0:	e8 11 02 00 00       	call   800f06 <vprintfmt>
  800cf5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800cf8:	a0 80 50 98 00       	mov    0x985080,%al
  800cfd:	0f b6 c0             	movzbl %al,%eax
  800d00:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d06:	83 ec 04             	sub    $0x4,%esp
  800d09:	50                   	push   %eax
  800d0a:	52                   	push   %edx
  800d0b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d11:	83 c0 08             	add    $0x8,%eax
  800d14:	50                   	push   %eax
  800d15:	e8 a2 14 00 00       	call   8021bc <sys_cputs>
  800d1a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d1d:	c6 05 80 50 98 00 00 	movb   $0x0,0x985080
	return b.cnt;
  800d24:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d2a:	c9                   	leave  
  800d2b:	c3                   	ret    

00800d2c <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d32:	c6 05 80 50 98 00 01 	movb   $0x1,0x985080
	va_start(ap, fmt);
  800d39:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	83 ec 08             	sub    $0x8,%esp
  800d45:	ff 75 f4             	pushl  -0xc(%ebp)
  800d48:	50                   	push   %eax
  800d49:	e8 73 ff ff ff       	call   800cc1 <vcprintf>
  800d4e:	83 c4 10             	add    $0x10,%esp
  800d51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    

00800d59 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800d5f:	e8 9a 14 00 00       	call   8021fe <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800d64:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	83 ec 08             	sub    $0x8,%esp
  800d70:	ff 75 f4             	pushl  -0xc(%ebp)
  800d73:	50                   	push   %eax
  800d74:	e8 48 ff ff ff       	call   800cc1 <vcprintf>
  800d79:	83 c4 10             	add    $0x10,%esp
  800d7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800d7f:	e8 94 14 00 00       	call   802218 <sys_unlock_cons>
	return cnt;
  800d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d87:	c9                   	leave  
  800d88:	c3                   	ret    

00800d89 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d89:	55                   	push   %ebp
  800d8a:	89 e5                	mov    %esp,%ebp
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 14             	sub    $0x14,%esp
  800d90:	8b 45 10             	mov    0x10(%ebp),%eax
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	8b 45 14             	mov    0x14(%ebp),%eax
  800d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d9c:	8b 45 18             	mov    0x18(%ebp),%eax
  800d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800da4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800da7:	77 55                	ja     800dfe <printnum+0x75>
  800da9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800dac:	72 05                	jb     800db3 <printnum+0x2a>
  800dae:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800db1:	77 4b                	ja     800dfe <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800db3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800db6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800db9:	8b 45 18             	mov    0x18(%ebp),%eax
  800dbc:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc1:	52                   	push   %edx
  800dc2:	50                   	push   %eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	ff 75 f0             	pushl  -0x10(%ebp)
  800dc9:	e8 f2 2c 00 00       	call   803ac0 <__udivdi3>
  800dce:	83 c4 10             	add    $0x10,%esp
  800dd1:	83 ec 04             	sub    $0x4,%esp
  800dd4:	ff 75 20             	pushl  0x20(%ebp)
  800dd7:	53                   	push   %ebx
  800dd8:	ff 75 18             	pushl  0x18(%ebp)
  800ddb:	52                   	push   %edx
  800ddc:	50                   	push   %eax
  800ddd:	ff 75 0c             	pushl  0xc(%ebp)
  800de0:	ff 75 08             	pushl  0x8(%ebp)
  800de3:	e8 a1 ff ff ff       	call   800d89 <printnum>
  800de8:	83 c4 20             	add    $0x20,%esp
  800deb:	eb 1a                	jmp    800e07 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ded:	83 ec 08             	sub    $0x8,%esp
  800df0:	ff 75 0c             	pushl  0xc(%ebp)
  800df3:	ff 75 20             	pushl  0x20(%ebp)
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	ff d0                	call   *%eax
  800dfb:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800dfe:	ff 4d 1c             	decl   0x1c(%ebp)
  800e01:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e05:	7f e6                	jg     800ded <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e07:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e15:	53                   	push   %ebx
  800e16:	51                   	push   %ecx
  800e17:	52                   	push   %edx
  800e18:	50                   	push   %eax
  800e19:	e8 b2 2d 00 00       	call   803bd0 <__umoddi3>
  800e1e:	83 c4 10             	add    $0x10,%esp
  800e21:	05 f4 46 80 00       	add    $0x8046f4,%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	0f be c0             	movsbl %al,%eax
  800e2b:	83 ec 08             	sub    $0x8,%esp
  800e2e:	ff 75 0c             	pushl  0xc(%ebp)
  800e31:	50                   	push   %eax
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	ff d0                	call   *%eax
  800e37:	83 c4 10             	add    $0x10,%esp
}
  800e3a:	90                   	nop
  800e3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e3e:	c9                   	leave  
  800e3f:	c3                   	ret    

00800e40 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e43:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e47:	7e 1c                	jle    800e65 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8b 00                	mov    (%eax),%eax
  800e4e:	8d 50 08             	lea    0x8(%eax),%edx
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	89 10                	mov    %edx,(%eax)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8b 00                	mov    (%eax),%eax
  800e5b:	83 e8 08             	sub    $0x8,%eax
  800e5e:	8b 50 04             	mov    0x4(%eax),%edx
  800e61:	8b 00                	mov    (%eax),%eax
  800e63:	eb 40                	jmp    800ea5 <getuint+0x65>
	else if (lflag)
  800e65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e69:	74 1e                	je     800e89 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	8b 00                	mov    (%eax),%eax
  800e70:	8d 50 04             	lea    0x4(%eax),%edx
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	89 10                	mov    %edx,(%eax)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8b 00                	mov    (%eax),%eax
  800e7d:	83 e8 04             	sub    $0x4,%eax
  800e80:	8b 00                	mov    (%eax),%eax
  800e82:	ba 00 00 00 00       	mov    $0x0,%edx
  800e87:	eb 1c                	jmp    800ea5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	8d 50 04             	lea    0x4(%eax),%edx
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 10                	mov    %edx,(%eax)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8b 00                	mov    (%eax),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800eaa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800eae:	7e 1c                	jle    800ecc <getint+0x25>
		return va_arg(*ap, long long);
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8b 00                	mov    (%eax),%eax
  800eb5:	8d 50 08             	lea    0x8(%eax),%edx
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	89 10                	mov    %edx,(%eax)
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	8b 00                	mov    (%eax),%eax
  800ec2:	83 e8 08             	sub    $0x8,%eax
  800ec5:	8b 50 04             	mov    0x4(%eax),%edx
  800ec8:	8b 00                	mov    (%eax),%eax
  800eca:	eb 38                	jmp    800f04 <getint+0x5d>
	else if (lflag)
  800ecc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed0:	74 1a                	je     800eec <getint+0x45>
		return va_arg(*ap, long);
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8b 00                	mov    (%eax),%eax
  800ed7:	8d 50 04             	lea    0x4(%eax),%edx
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	89 10                	mov    %edx,(%eax)
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8b 00                	mov    (%eax),%eax
  800ee4:	83 e8 04             	sub    $0x4,%eax
  800ee7:	8b 00                	mov    (%eax),%eax
  800ee9:	99                   	cltd   
  800eea:	eb 18                	jmp    800f04 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	8b 00                	mov    (%eax),%eax
  800ef1:	8d 50 04             	lea    0x4(%eax),%edx
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	89 10                	mov    %edx,(%eax)
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	8b 00                	mov    (%eax),%eax
  800efe:	83 e8 04             	sub    $0x4,%eax
  800f01:	8b 00                	mov    (%eax),%eax
  800f03:	99                   	cltd   
}
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f0e:	eb 17                	jmp    800f27 <vprintfmt+0x21>
			if (ch == '\0')
  800f10:	85 db                	test   %ebx,%ebx
  800f12:	0f 84 c1 03 00 00    	je     8012d9 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800f18:	83 ec 08             	sub    $0x8,%esp
  800f1b:	ff 75 0c             	pushl  0xc(%ebp)
  800f1e:	53                   	push   %ebx
  800f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f22:	ff d0                	call   *%eax
  800f24:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	8d 50 01             	lea    0x1(%eax),%edx
  800f2d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	0f b6 d8             	movzbl %al,%ebx
  800f35:	83 fb 25             	cmp    $0x25,%ebx
  800f38:	75 d6                	jne    800f10 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f3a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f3e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f45:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f4c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f53:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	8d 50 01             	lea    0x1(%eax),%edx
  800f60:	89 55 10             	mov    %edx,0x10(%ebp)
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	0f b6 d8             	movzbl %al,%ebx
  800f68:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f6b:	83 f8 5b             	cmp    $0x5b,%eax
  800f6e:	0f 87 3d 03 00 00    	ja     8012b1 <vprintfmt+0x3ab>
  800f74:	8b 04 85 18 47 80 00 	mov    0x804718(,%eax,4),%eax
  800f7b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f7d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f81:	eb d7                	jmp    800f5a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f83:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f87:	eb d1                	jmp    800f5a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f89:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f90:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f93:	89 d0                	mov    %edx,%eax
  800f95:	c1 e0 02             	shl    $0x2,%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	01 c0                	add    %eax,%eax
  800f9c:	01 d8                	add    %ebx,%eax
  800f9e:	83 e8 30             	sub    $0x30,%eax
  800fa1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fac:	83 fb 2f             	cmp    $0x2f,%ebx
  800faf:	7e 3e                	jle    800fef <vprintfmt+0xe9>
  800fb1:	83 fb 39             	cmp    $0x39,%ebx
  800fb4:	7f 39                	jg     800fef <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fb6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fb9:	eb d5                	jmp    800f90 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800fbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbe:	83 c0 04             	add    $0x4,%eax
  800fc1:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc7:	83 e8 04             	sub    $0x4,%eax
  800fca:	8b 00                	mov    (%eax),%eax
  800fcc:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800fcf:	eb 1f                	jmp    800ff0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800fd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd5:	79 83                	jns    800f5a <vprintfmt+0x54>
				width = 0;
  800fd7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800fde:	e9 77 ff ff ff       	jmp    800f5a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800fe3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800fea:	e9 6b ff ff ff       	jmp    800f5a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800fef:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ff0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff4:	0f 89 60 ff ff ff    	jns    800f5a <vprintfmt+0x54>
				width = precision, precision = -1;
  800ffa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ffd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801000:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801007:	e9 4e ff ff ff       	jmp    800f5a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80100c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80100f:	e9 46 ff ff ff       	jmp    800f5a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801014:	8b 45 14             	mov    0x14(%ebp),%eax
  801017:	83 c0 04             	add    $0x4,%eax
  80101a:	89 45 14             	mov    %eax,0x14(%ebp)
  80101d:	8b 45 14             	mov    0x14(%ebp),%eax
  801020:	83 e8 04             	sub    $0x4,%eax
  801023:	8b 00                	mov    (%eax),%eax
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	50                   	push   %eax
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	ff d0                	call   *%eax
  801031:	83 c4 10             	add    $0x10,%esp
			break;
  801034:	e9 9b 02 00 00       	jmp    8012d4 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801039:	8b 45 14             	mov    0x14(%ebp),%eax
  80103c:	83 c0 04             	add    $0x4,%eax
  80103f:	89 45 14             	mov    %eax,0x14(%ebp)
  801042:	8b 45 14             	mov    0x14(%ebp),%eax
  801045:	83 e8 04             	sub    $0x4,%eax
  801048:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80104a:	85 db                	test   %ebx,%ebx
  80104c:	79 02                	jns    801050 <vprintfmt+0x14a>
				err = -err;
  80104e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801050:	83 fb 64             	cmp    $0x64,%ebx
  801053:	7f 0b                	jg     801060 <vprintfmt+0x15a>
  801055:	8b 34 9d 60 45 80 00 	mov    0x804560(,%ebx,4),%esi
  80105c:	85 f6                	test   %esi,%esi
  80105e:	75 19                	jne    801079 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801060:	53                   	push   %ebx
  801061:	68 05 47 80 00       	push   $0x804705
  801066:	ff 75 0c             	pushl  0xc(%ebp)
  801069:	ff 75 08             	pushl  0x8(%ebp)
  80106c:	e8 70 02 00 00       	call   8012e1 <printfmt>
  801071:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801074:	e9 5b 02 00 00       	jmp    8012d4 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801079:	56                   	push   %esi
  80107a:	68 0e 47 80 00       	push   $0x80470e
  80107f:	ff 75 0c             	pushl  0xc(%ebp)
  801082:	ff 75 08             	pushl  0x8(%ebp)
  801085:	e8 57 02 00 00       	call   8012e1 <printfmt>
  80108a:	83 c4 10             	add    $0x10,%esp
			break;
  80108d:	e9 42 02 00 00       	jmp    8012d4 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801092:	8b 45 14             	mov    0x14(%ebp),%eax
  801095:	83 c0 04             	add    $0x4,%eax
  801098:	89 45 14             	mov    %eax,0x14(%ebp)
  80109b:	8b 45 14             	mov    0x14(%ebp),%eax
  80109e:	83 e8 04             	sub    $0x4,%eax
  8010a1:	8b 30                	mov    (%eax),%esi
  8010a3:	85 f6                	test   %esi,%esi
  8010a5:	75 05                	jne    8010ac <vprintfmt+0x1a6>
				p = "(null)";
  8010a7:	be 11 47 80 00       	mov    $0x804711,%esi
			if (width > 0 && padc != '-')
  8010ac:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010b0:	7e 6d                	jle    80111f <vprintfmt+0x219>
  8010b2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010b6:	74 67                	je     80111f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010bb:	83 ec 08             	sub    $0x8,%esp
  8010be:	50                   	push   %eax
  8010bf:	56                   	push   %esi
  8010c0:	e8 1e 03 00 00       	call   8013e3 <strnlen>
  8010c5:	83 c4 10             	add    $0x10,%esp
  8010c8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8010cb:	eb 16                	jmp    8010e3 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8010cd:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8010d1:	83 ec 08             	sub    $0x8,%esp
  8010d4:	ff 75 0c             	pushl  0xc(%ebp)
  8010d7:	50                   	push   %eax
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	ff d0                	call   *%eax
  8010dd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010e0:	ff 4d e4             	decl   -0x1c(%ebp)
  8010e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010e7:	7f e4                	jg     8010cd <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010e9:	eb 34                	jmp    80111f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8010eb:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8010ef:	74 1c                	je     80110d <vprintfmt+0x207>
  8010f1:	83 fb 1f             	cmp    $0x1f,%ebx
  8010f4:	7e 05                	jle    8010fb <vprintfmt+0x1f5>
  8010f6:	83 fb 7e             	cmp    $0x7e,%ebx
  8010f9:	7e 12                	jle    80110d <vprintfmt+0x207>
					putch('?', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 3f                	push   $0x3f
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
  80110b:	eb 0f                	jmp    80111c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80110d:	83 ec 08             	sub    $0x8,%esp
  801110:	ff 75 0c             	pushl  0xc(%ebp)
  801113:	53                   	push   %ebx
  801114:	8b 45 08             	mov    0x8(%ebp),%eax
  801117:	ff d0                	call   *%eax
  801119:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80111c:	ff 4d e4             	decl   -0x1c(%ebp)
  80111f:	89 f0                	mov    %esi,%eax
  801121:	8d 70 01             	lea    0x1(%eax),%esi
  801124:	8a 00                	mov    (%eax),%al
  801126:	0f be d8             	movsbl %al,%ebx
  801129:	85 db                	test   %ebx,%ebx
  80112b:	74 24                	je     801151 <vprintfmt+0x24b>
  80112d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801131:	78 b8                	js     8010eb <vprintfmt+0x1e5>
  801133:	ff 4d e0             	decl   -0x20(%ebp)
  801136:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80113a:	79 af                	jns    8010eb <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80113c:	eb 13                	jmp    801151 <vprintfmt+0x24b>
				putch(' ', putdat);
  80113e:	83 ec 08             	sub    $0x8,%esp
  801141:	ff 75 0c             	pushl  0xc(%ebp)
  801144:	6a 20                	push   $0x20
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	ff d0                	call   *%eax
  80114b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80114e:	ff 4d e4             	decl   -0x1c(%ebp)
  801151:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801155:	7f e7                	jg     80113e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801157:	e9 78 01 00 00       	jmp    8012d4 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	ff 75 e8             	pushl  -0x18(%ebp)
  801162:	8d 45 14             	lea    0x14(%ebp),%eax
  801165:	50                   	push   %eax
  801166:	e8 3c fd ff ff       	call   800ea7 <getint>
  80116b:	83 c4 10             	add    $0x10,%esp
  80116e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801171:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801177:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80117a:	85 d2                	test   %edx,%edx
  80117c:	79 23                	jns    8011a1 <vprintfmt+0x29b>
				putch('-', putdat);
  80117e:	83 ec 08             	sub    $0x8,%esp
  801181:	ff 75 0c             	pushl  0xc(%ebp)
  801184:	6a 2d                	push   $0x2d
  801186:	8b 45 08             	mov    0x8(%ebp),%eax
  801189:	ff d0                	call   *%eax
  80118b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80118e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801191:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801194:	f7 d8                	neg    %eax
  801196:	83 d2 00             	adc    $0x0,%edx
  801199:	f7 da                	neg    %edx
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80119e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011a1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011a8:	e9 bc 00 00 00       	jmp    801269 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011ad:	83 ec 08             	sub    $0x8,%esp
  8011b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8011b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8011b6:	50                   	push   %eax
  8011b7:	e8 84 fc ff ff       	call   800e40 <getuint>
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8011c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011cc:	e9 98 00 00 00       	jmp    801269 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	ff 75 0c             	pushl  0xc(%ebp)
  8011d7:	6a 58                	push   $0x58
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	ff d0                	call   *%eax
  8011de:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	6a 58                	push   $0x58
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	ff d0                	call   *%eax
  8011ee:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	6a 58                	push   $0x58
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	ff d0                	call   *%eax
  8011fe:	83 c4 10             	add    $0x10,%esp
			break;
  801201:	e9 ce 00 00 00       	jmp    8012d4 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801206:	83 ec 08             	sub    $0x8,%esp
  801209:	ff 75 0c             	pushl  0xc(%ebp)
  80120c:	6a 30                	push   $0x30
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	ff d0                	call   *%eax
  801213:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	ff 75 0c             	pushl  0xc(%ebp)
  80121c:	6a 78                	push   $0x78
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	ff d0                	call   *%eax
  801223:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801226:	8b 45 14             	mov    0x14(%ebp),%eax
  801229:	83 c0 04             	add    $0x4,%eax
  80122c:	89 45 14             	mov    %eax,0x14(%ebp)
  80122f:	8b 45 14             	mov    0x14(%ebp),%eax
  801232:	83 e8 04             	sub    $0x4,%eax
  801235:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801241:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801248:	eb 1f                	jmp    801269 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80124a:	83 ec 08             	sub    $0x8,%esp
  80124d:	ff 75 e8             	pushl  -0x18(%ebp)
  801250:	8d 45 14             	lea    0x14(%ebp),%eax
  801253:	50                   	push   %eax
  801254:	e8 e7 fb ff ff       	call   800e40 <getuint>
  801259:	83 c4 10             	add    $0x10,%esp
  80125c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80125f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801262:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801269:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80126d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801270:	83 ec 04             	sub    $0x4,%esp
  801273:	52                   	push   %edx
  801274:	ff 75 e4             	pushl  -0x1c(%ebp)
  801277:	50                   	push   %eax
  801278:	ff 75 f4             	pushl  -0xc(%ebp)
  80127b:	ff 75 f0             	pushl  -0x10(%ebp)
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	ff 75 08             	pushl  0x8(%ebp)
  801284:	e8 00 fb ff ff       	call   800d89 <printnum>
  801289:	83 c4 20             	add    $0x20,%esp
			break;
  80128c:	eb 46                	jmp    8012d4 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80128e:	83 ec 08             	sub    $0x8,%esp
  801291:	ff 75 0c             	pushl  0xc(%ebp)
  801294:	53                   	push   %ebx
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	ff d0                	call   *%eax
  80129a:	83 c4 10             	add    $0x10,%esp
			break;
  80129d:	eb 35                	jmp    8012d4 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80129f:	c6 05 80 50 98 00 00 	movb   $0x0,0x985080
			break;
  8012a6:	eb 2c                	jmp    8012d4 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8012a8:	c6 05 80 50 98 00 01 	movb   $0x1,0x985080
			break;
  8012af:	eb 23                	jmp    8012d4 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012b1:	83 ec 08             	sub    $0x8,%esp
  8012b4:	ff 75 0c             	pushl  0xc(%ebp)
  8012b7:	6a 25                	push   $0x25
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	ff d0                	call   *%eax
  8012be:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012c1:	ff 4d 10             	decl   0x10(%ebp)
  8012c4:	eb 03                	jmp    8012c9 <vprintfmt+0x3c3>
  8012c6:	ff 4d 10             	decl   0x10(%ebp)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	48                   	dec    %eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 25                	cmp    $0x25,%al
  8012d1:	75 f3                	jne    8012c6 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8012d3:	90                   	nop
		}
	}
  8012d4:	e9 35 fc ff ff       	jmp    800f0e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012d9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5e                   	pop    %esi
  8012df:	5d                   	pop    %ebp
  8012e0:	c3                   	ret    

008012e1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8012ea:	83 c0 04             	add    $0x4,%eax
  8012ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8012f6:	50                   	push   %eax
  8012f7:	ff 75 0c             	pushl  0xc(%ebp)
  8012fa:	ff 75 08             	pushl  0x8(%ebp)
  8012fd:	e8 04 fc ff ff       	call   800f06 <vprintfmt>
  801302:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801305:	90                   	nop
  801306:	c9                   	leave  
  801307:	c3                   	ret    

00801308 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80130b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130e:	8b 40 08             	mov    0x8(%eax),%eax
  801311:	8d 50 01             	lea    0x1(%eax),%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8b 10                	mov    (%eax),%edx
  80131f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801322:	8b 40 04             	mov    0x4(%eax),%eax
  801325:	39 c2                	cmp    %eax,%edx
  801327:	73 12                	jae    80133b <sprintputch+0x33>
		*b->buf++ = ch;
  801329:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	8d 48 01             	lea    0x1(%eax),%ecx
  801331:	8b 55 0c             	mov    0xc(%ebp),%edx
  801334:	89 0a                	mov    %ecx,(%edx)
  801336:	8b 55 08             	mov    0x8(%ebp),%edx
  801339:	88 10                	mov    %dl,(%eax)
}
  80133b:	90                   	nop
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
  801347:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80134a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80135f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801363:	74 06                	je     80136b <vsnprintf+0x2d>
  801365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801369:	7f 07                	jg     801372 <vsnprintf+0x34>
		return -E_INVAL;
  80136b:	b8 03 00 00 00       	mov    $0x3,%eax
  801370:	eb 20                	jmp    801392 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801372:	ff 75 14             	pushl  0x14(%ebp)
  801375:	ff 75 10             	pushl  0x10(%ebp)
  801378:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80137b:	50                   	push   %eax
  80137c:	68 08 13 80 00       	push   $0x801308
  801381:	e8 80 fb ff ff       	call   800f06 <vprintfmt>
  801386:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80138f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80139a:	8d 45 10             	lea    0x10(%ebp),%eax
  80139d:	83 c0 04             	add    $0x4,%eax
  8013a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8013a9:	50                   	push   %eax
  8013aa:	ff 75 0c             	pushl  0xc(%ebp)
  8013ad:	ff 75 08             	pushl  0x8(%ebp)
  8013b0:	e8 89 ff ff ff       	call   80133e <vsnprintf>
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013cd:	eb 06                	jmp    8013d5 <strlen+0x15>
		n++;
  8013cf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d2:	ff 45 08             	incl   0x8(%ebp)
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	8a 00                	mov    (%eax),%al
  8013da:	84 c0                	test   %al,%al
  8013dc:	75 f1                	jne    8013cf <strlen+0xf>
		n++;
	return n;
  8013de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013e1:	c9                   	leave  
  8013e2:	c3                   	ret    

008013e3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f0:	eb 09                	jmp    8013fb <strnlen+0x18>
		n++;
  8013f2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f5:	ff 45 08             	incl   0x8(%ebp)
  8013f8:	ff 4d 0c             	decl   0xc(%ebp)
  8013fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8013ff:	74 09                	je     80140a <strnlen+0x27>
  801401:	8b 45 08             	mov    0x8(%ebp),%eax
  801404:	8a 00                	mov    (%eax),%al
  801406:	84 c0                	test   %al,%al
  801408:	75 e8                	jne    8013f2 <strnlen+0xf>
		n++;
	return n;
  80140a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80140d:	c9                   	leave  
  80140e:	c3                   	ret    

0080140f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80141b:	90                   	nop
  80141c:	8b 45 08             	mov    0x8(%ebp),%eax
  80141f:	8d 50 01             	lea    0x1(%eax),%edx
  801422:	89 55 08             	mov    %edx,0x8(%ebp)
  801425:	8b 55 0c             	mov    0xc(%ebp),%edx
  801428:	8d 4a 01             	lea    0x1(%edx),%ecx
  80142b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80142e:	8a 12                	mov    (%edx),%dl
  801430:	88 10                	mov    %dl,(%eax)
  801432:	8a 00                	mov    (%eax),%al
  801434:	84 c0                	test   %al,%al
  801436:	75 e4                	jne    80141c <strcpy+0xd>
		/* do nothing */;
	return ret;
  801438:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801443:	8b 45 08             	mov    0x8(%ebp),%eax
  801446:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801450:	eb 1f                	jmp    801471 <strncpy+0x34>
		*dst++ = *src;
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8d 50 01             	lea    0x1(%eax),%edx
  801458:	89 55 08             	mov    %edx,0x8(%ebp)
  80145b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80145e:	8a 12                	mov    (%edx),%dl
  801460:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
  801465:	8a 00                	mov    (%eax),%al
  801467:	84 c0                	test   %al,%al
  801469:	74 03                	je     80146e <strncpy+0x31>
			src++;
  80146b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80146e:	ff 45 fc             	incl   -0x4(%ebp)
  801471:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801474:	3b 45 10             	cmp    0x10(%ebp),%eax
  801477:	72 d9                	jb     801452 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801479:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801484:	8b 45 08             	mov    0x8(%ebp),%eax
  801487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80148a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148e:	74 30                	je     8014c0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801490:	eb 16                	jmp    8014a8 <strlcpy+0x2a>
			*dst++ = *src++;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8d 50 01             	lea    0x1(%eax),%edx
  801498:	89 55 08             	mov    %edx,0x8(%ebp)
  80149b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149e:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014a4:	8a 12                	mov    (%edx),%dl
  8014a6:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014a8:	ff 4d 10             	decl   0x10(%ebp)
  8014ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014af:	74 09                	je     8014ba <strlcpy+0x3c>
  8014b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	84 c0                	test   %al,%al
  8014b8:	75 d8                	jne    801492 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c6:	29 c2                	sub    %eax,%edx
  8014c8:	89 d0                	mov    %edx,%eax
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014cf:	eb 06                	jmp    8014d7 <strcmp+0xb>
		p++, q++;
  8014d1:	ff 45 08             	incl   0x8(%ebp)
  8014d4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	8a 00                	mov    (%eax),%al
  8014dc:	84 c0                	test   %al,%al
  8014de:	74 0e                	je     8014ee <strcmp+0x22>
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	8a 10                	mov    (%eax),%dl
  8014e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	38 c2                	cmp    %al,%dl
  8014ec:	74 e3                	je     8014d1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f b6 d0             	movzbl %al,%edx
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	8a 00                	mov    (%eax),%al
  8014fb:	0f b6 c0             	movzbl %al,%eax
  8014fe:	29 c2                	sub    %eax,%edx
  801500:	89 d0                	mov    %edx,%eax
}
  801502:	5d                   	pop    %ebp
  801503:	c3                   	ret    

00801504 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801507:	eb 09                	jmp    801512 <strncmp+0xe>
		n--, p++, q++;
  801509:	ff 4d 10             	decl   0x10(%ebp)
  80150c:	ff 45 08             	incl   0x8(%ebp)
  80150f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801512:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801516:	74 17                	je     80152f <strncmp+0x2b>
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	84 c0                	test   %al,%al
  80151f:	74 0e                	je     80152f <strncmp+0x2b>
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8a 10                	mov    (%eax),%dl
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	38 c2                	cmp    %al,%dl
  80152d:	74 da                	je     801509 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80152f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801533:	75 07                	jne    80153c <strncmp+0x38>
		return 0;
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	eb 14                	jmp    801550 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	8a 00                	mov    (%eax),%al
  801541:	0f b6 d0             	movzbl %al,%edx
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	8a 00                	mov    (%eax),%al
  801549:	0f b6 c0             	movzbl %al,%eax
  80154c:	29 c2                	sub    %eax,%edx
  80154e:	89 d0                	mov    %edx,%eax
}
  801550:	5d                   	pop    %ebp
  801551:	c3                   	ret    

00801552 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 04             	sub    $0x4,%esp
  801558:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80155e:	eb 12                	jmp    801572 <strchr+0x20>
		if (*s == c)
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	8a 00                	mov    (%eax),%al
  801565:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801568:	75 05                	jne    80156f <strchr+0x1d>
			return (char *) s;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	eb 11                	jmp    801580 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80156f:	ff 45 08             	incl   0x8(%ebp)
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	8a 00                	mov    (%eax),%al
  801577:	84 c0                	test   %al,%al
  801579:	75 e5                	jne    801560 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	83 ec 04             	sub    $0x4,%esp
  801588:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80158e:	eb 0d                	jmp    80159d <strfind+0x1b>
		if (*s == c)
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801598:	74 0e                	je     8015a8 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80159a:	ff 45 08             	incl   0x8(%ebp)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	84 c0                	test   %al,%al
  8015a4:	75 ea                	jne    801590 <strfind+0xe>
  8015a6:	eb 01                	jmp    8015a9 <strfind+0x27>
		if (*s == c)
			break;
  8015a8:	90                   	nop
	return (char *) s;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015c0:	eb 0e                	jmp    8015d0 <memset+0x22>
		*p++ = c;
  8015c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c5:	8d 50 01             	lea    0x1(%eax),%edx
  8015c8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ce:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015d0:	ff 4d f8             	decl   -0x8(%ebp)
  8015d3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015d7:	79 e9                	jns    8015c2 <memset+0x14>
		*p++ = c;

	return v;
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015dc:	c9                   	leave  
  8015dd:	c3                   	ret    

008015de <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015de:	55                   	push   %ebp
  8015df:	89 e5                	mov    %esp,%ebp
  8015e1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015f0:	eb 16                	jmp    801608 <memcpy+0x2a>
		*d++ = *s++;
  8015f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f5:	8d 50 01             	lea    0x1(%eax),%edx
  8015f8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015fe:	8d 4a 01             	lea    0x1(%edx),%ecx
  801601:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801604:	8a 12                	mov    (%edx),%dl
  801606:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801608:	8b 45 10             	mov    0x10(%ebp),%eax
  80160b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80160e:	89 55 10             	mov    %edx,0x10(%ebp)
  801611:	85 c0                	test   %eax,%eax
  801613:	75 dd                	jne    8015f2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801615:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80162c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801632:	73 50                	jae    801684 <memmove+0x6a>
  801634:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	01 d0                	add    %edx,%eax
  80163c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80163f:	76 43                	jbe    801684 <memmove+0x6a>
		s += n;
  801641:	8b 45 10             	mov    0x10(%ebp),%eax
  801644:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801647:	8b 45 10             	mov    0x10(%ebp),%eax
  80164a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80164d:	eb 10                	jmp    80165f <memmove+0x45>
			*--d = *--s;
  80164f:	ff 4d f8             	decl   -0x8(%ebp)
  801652:	ff 4d fc             	decl   -0x4(%ebp)
  801655:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801658:	8a 10                	mov    (%eax),%dl
  80165a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80165f:	8b 45 10             	mov    0x10(%ebp),%eax
  801662:	8d 50 ff             	lea    -0x1(%eax),%edx
  801665:	89 55 10             	mov    %edx,0x10(%ebp)
  801668:	85 c0                	test   %eax,%eax
  80166a:	75 e3                	jne    80164f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80166c:	eb 23                	jmp    801691 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80166e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801671:	8d 50 01             	lea    0x1(%eax),%edx
  801674:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801677:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801680:	8a 12                	mov    (%edx),%dl
  801682:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168a:	89 55 10             	mov    %edx,0x10(%ebp)
  80168d:	85 c0                	test   %eax,%eax
  80168f:	75 dd                	jne    80166e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a5:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016a8:	eb 2a                	jmp    8016d4 <memcmp+0x3e>
		if (*s1 != *s2)
  8016aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ad:	8a 10                	mov    (%eax),%dl
  8016af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	38 c2                	cmp    %al,%dl
  8016b6:	74 16                	je     8016ce <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f b6 d0             	movzbl %al,%edx
  8016c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	0f b6 c0             	movzbl %al,%eax
  8016c8:	29 c2                	sub    %eax,%edx
  8016ca:	89 d0                	mov    %edx,%eax
  8016cc:	eb 18                	jmp    8016e6 <memcmp+0x50>
		s1++, s2++;
  8016ce:	ff 45 fc             	incl   -0x4(%ebp)
  8016d1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016da:	89 55 10             	mov    %edx,0x10(%ebp)
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	75 c9                	jne    8016aa <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f4:	01 d0                	add    %edx,%eax
  8016f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8016f9:	eb 15                	jmp    801710 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	0f b6 d0             	movzbl %al,%edx
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	0f b6 c0             	movzbl %al,%eax
  801709:	39 c2                	cmp    %eax,%edx
  80170b:	74 0d                	je     80171a <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80170d:	ff 45 08             	incl   0x8(%ebp)
  801710:	8b 45 08             	mov    0x8(%ebp),%eax
  801713:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801716:	72 e3                	jb     8016fb <memfind+0x13>
  801718:	eb 01                	jmp    80171b <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80171a:	90                   	nop
	return (void *) s;
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801726:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80172d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801734:	eb 03                	jmp    801739 <strtol+0x19>
		s++;
  801736:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	3c 20                	cmp    $0x20,%al
  801740:	74 f4                	je     801736 <strtol+0x16>
  801742:	8b 45 08             	mov    0x8(%ebp),%eax
  801745:	8a 00                	mov    (%eax),%al
  801747:	3c 09                	cmp    $0x9,%al
  801749:	74 eb                	je     801736 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80174b:	8b 45 08             	mov    0x8(%ebp),%eax
  80174e:	8a 00                	mov    (%eax),%al
  801750:	3c 2b                	cmp    $0x2b,%al
  801752:	75 05                	jne    801759 <strtol+0x39>
		s++;
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	eb 13                	jmp    80176c <strtol+0x4c>
	else if (*s == '-')
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	3c 2d                	cmp    $0x2d,%al
  801760:	75 0a                	jne    80176c <strtol+0x4c>
		s++, neg = 1;
  801762:	ff 45 08             	incl   0x8(%ebp)
  801765:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80176c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801770:	74 06                	je     801778 <strtol+0x58>
  801772:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801776:	75 20                	jne    801798 <strtol+0x78>
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	3c 30                	cmp    $0x30,%al
  80177f:	75 17                	jne    801798 <strtol+0x78>
  801781:	8b 45 08             	mov    0x8(%ebp),%eax
  801784:	40                   	inc    %eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	3c 78                	cmp    $0x78,%al
  801789:	75 0d                	jne    801798 <strtol+0x78>
		s += 2, base = 16;
  80178b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80178f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801796:	eb 28                	jmp    8017c0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801798:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80179c:	75 15                	jne    8017b3 <strtol+0x93>
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 30                	cmp    $0x30,%al
  8017a5:	75 0c                	jne    8017b3 <strtol+0x93>
		s++, base = 8;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017b1:	eb 0d                	jmp    8017c0 <strtol+0xa0>
	else if (base == 0)
  8017b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b7:	75 07                	jne    8017c0 <strtol+0xa0>
		base = 10;
  8017b9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c3:	8a 00                	mov    (%eax),%al
  8017c5:	3c 2f                	cmp    $0x2f,%al
  8017c7:	7e 19                	jle    8017e2 <strtol+0xc2>
  8017c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cc:	8a 00                	mov    (%eax),%al
  8017ce:	3c 39                	cmp    $0x39,%al
  8017d0:	7f 10                	jg     8017e2 <strtol+0xc2>
			dig = *s - '0';
  8017d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d5:	8a 00                	mov    (%eax),%al
  8017d7:	0f be c0             	movsbl %al,%eax
  8017da:	83 e8 30             	sub    $0x30,%eax
  8017dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017e0:	eb 42                	jmp    801824 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 60                	cmp    $0x60,%al
  8017e9:	7e 19                	jle    801804 <strtol+0xe4>
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	3c 7a                	cmp    $0x7a,%al
  8017f2:	7f 10                	jg     801804 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	8a 00                	mov    (%eax),%al
  8017f9:	0f be c0             	movsbl %al,%eax
  8017fc:	83 e8 57             	sub    $0x57,%eax
  8017ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801802:	eb 20                	jmp    801824 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 40                	cmp    $0x40,%al
  80180b:	7e 39                	jle    801846 <strtol+0x126>
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	3c 5a                	cmp    $0x5a,%al
  801814:	7f 30                	jg     801846 <strtol+0x126>
			dig = *s - 'A' + 10;
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	8a 00                	mov    (%eax),%al
  80181b:	0f be c0             	movsbl %al,%eax
  80181e:	83 e8 37             	sub    $0x37,%eax
  801821:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801827:	3b 45 10             	cmp    0x10(%ebp),%eax
  80182a:	7d 19                	jge    801845 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80182c:	ff 45 08             	incl   0x8(%ebp)
  80182f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801832:	0f af 45 10          	imul   0x10(%ebp),%eax
  801836:	89 c2                	mov    %eax,%edx
  801838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183b:	01 d0                	add    %edx,%eax
  80183d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801840:	e9 7b ff ff ff       	jmp    8017c0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801845:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801846:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80184a:	74 08                	je     801854 <strtol+0x134>
		*endptr = (char *) s;
  80184c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80184f:	8b 55 08             	mov    0x8(%ebp),%edx
  801852:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801854:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801858:	74 07                	je     801861 <strtol+0x141>
  80185a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185d:	f7 d8                	neg    %eax
  80185f:	eb 03                	jmp    801864 <strtol+0x144>
  801861:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <ltostr>:

void
ltostr(long value, char *str)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80186c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801873:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80187a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80187e:	79 13                	jns    801893 <ltostr+0x2d>
	{
		neg = 1;
  801880:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80188a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80188d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801890:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80189b:	99                   	cltd   
  80189c:	f7 f9                	idiv   %ecx
  80189e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018a4:	8d 50 01             	lea    0x1(%eax),%edx
  8018a7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018aa:	89 c2                	mov    %eax,%edx
  8018ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018af:	01 d0                	add    %edx,%eax
  8018b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018b4:	83 c2 30             	add    $0x30,%edx
  8018b7:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018c1:	f7 e9                	imul   %ecx
  8018c3:	c1 fa 02             	sar    $0x2,%edx
  8018c6:	89 c8                	mov    %ecx,%eax
  8018c8:	c1 f8 1f             	sar    $0x1f,%eax
  8018cb:	29 c2                	sub    %eax,%edx
  8018cd:	89 d0                	mov    %edx,%eax
  8018cf:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8018d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d6:	75 bb                	jne    801893 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8018d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8018df:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018e2:	48                   	dec    %eax
  8018e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8018e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ea:	74 3d                	je     801929 <ltostr+0xc3>
		start = 1 ;
  8018ec:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8018f3:	eb 34                	jmp    801929 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8018f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	8a 00                	mov    (%eax),%al
  8018ff:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801902:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801905:	8b 45 0c             	mov    0xc(%ebp),%eax
  801908:	01 c2                	add    %eax,%edx
  80190a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80190d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801910:	01 c8                	add    %ecx,%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801916:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801919:	8b 45 0c             	mov    0xc(%ebp),%eax
  80191c:	01 c2                	add    %eax,%edx
  80191e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801921:	88 02                	mov    %al,(%edx)
		start++ ;
  801923:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801926:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80192f:	7c c4                	jl     8018f5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801931:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801934:	8b 45 0c             	mov    0xc(%ebp),%eax
  801937:	01 d0                	add    %edx,%eax
  801939:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80193c:	90                   	nop
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	e8 73 fa ff ff       	call   8013c0 <strlen>
  80194d:	83 c4 04             	add    $0x4,%esp
  801950:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	e8 65 fa ff ff       	call   8013c0 <strlen>
  80195b:	83 c4 04             	add    $0x4,%esp
  80195e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801961:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801968:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80196f:	eb 17                	jmp    801988 <strcconcat+0x49>
		final[s] = str1[s] ;
  801971:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801974:	8b 45 10             	mov    0x10(%ebp),%eax
  801977:	01 c2                	add    %eax,%edx
  801979:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	01 c8                	add    %ecx,%eax
  801981:	8a 00                	mov    (%eax),%al
  801983:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801985:	ff 45 fc             	incl   -0x4(%ebp)
  801988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80198b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80198e:	7c e1                	jl     801971 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801990:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801997:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80199e:	eb 1f                	jmp    8019bf <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019a3:	8d 50 01             	lea    0x1(%eax),%edx
  8019a6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019a9:	89 c2                	mov    %eax,%edx
  8019ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ae:	01 c2                	add    %eax,%edx
  8019b0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b6:	01 c8                	add    %ecx,%eax
  8019b8:	8a 00                	mov    (%eax),%al
  8019ba:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019bc:	ff 45 f8             	incl   -0x8(%ebp)
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019c5:	7c d9                	jl     8019a0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019c7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	c6 00 00             	movb   $0x0,(%eax)
}
  8019d2:	90                   	nop
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8019d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8019db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8019e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e4:	8b 00                	mov    (%eax),%eax
  8019e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f0:	01 d0                	add    %edx,%eax
  8019f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019f8:	eb 0c                	jmp    801a06 <strsplit+0x31>
			*string++ = 0;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 08             	mov    %edx,0x8(%ebp)
  801a03:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	8a 00                	mov    (%eax),%al
  801a0b:	84 c0                	test   %al,%al
  801a0d:	74 18                	je     801a27 <strsplit+0x52>
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	8a 00                	mov    (%eax),%al
  801a14:	0f be c0             	movsbl %al,%eax
  801a17:	50                   	push   %eax
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	e8 32 fb ff ff       	call   801552 <strchr>
  801a20:	83 c4 08             	add    $0x8,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	75 d3                	jne    8019fa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	84 c0                	test   %al,%al
  801a2e:	74 5a                	je     801a8a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a30:	8b 45 14             	mov    0x14(%ebp),%eax
  801a33:	8b 00                	mov    (%eax),%eax
  801a35:	83 f8 0f             	cmp    $0xf,%eax
  801a38:	75 07                	jne    801a41 <strsplit+0x6c>
		{
			return 0;
  801a3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3f:	eb 66                	jmp    801aa7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a41:	8b 45 14             	mov    0x14(%ebp),%eax
  801a44:	8b 00                	mov    (%eax),%eax
  801a46:	8d 48 01             	lea    0x1(%eax),%ecx
  801a49:	8b 55 14             	mov    0x14(%ebp),%edx
  801a4c:	89 0a                	mov    %ecx,(%edx)
  801a4e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a55:	8b 45 10             	mov    0x10(%ebp),%eax
  801a58:	01 c2                	add    %eax,%edx
  801a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a5f:	eb 03                	jmp    801a64 <strsplit+0x8f>
			string++;
  801a61:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	8a 00                	mov    (%eax),%al
  801a69:	84 c0                	test   %al,%al
  801a6b:	74 8b                	je     8019f8 <strsplit+0x23>
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8a 00                	mov    (%eax),%al
  801a72:	0f be c0             	movsbl %al,%eax
  801a75:	50                   	push   %eax
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	e8 d4 fa ff ff       	call   801552 <strchr>
  801a7e:	83 c4 08             	add    $0x8,%esp
  801a81:	85 c0                	test   %eax,%eax
  801a83:	74 dc                	je     801a61 <strsplit+0x8c>
			string++;
	}
  801a85:	e9 6e ff ff ff       	jmp    8019f8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a8a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a8b:	8b 45 14             	mov    0x14(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	01 d0                	add    %edx,%eax
  801a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801aa2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	68 88 48 80 00       	push   $0x804888
  801ab7:	68 3f 01 00 00       	push   $0x13f
  801abc:	68 aa 48 80 00       	push   $0x8048aa
  801ac1:	e8 a9 ef ff ff       	call   800a6f <_panic>

00801ac6 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
  801ac9:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	ff 75 08             	pushl  0x8(%ebp)
  801ad2:	e8 90 0c 00 00       	call   802767 <sys_sbrk>
  801ad7:	83 c4 10             	add    $0x10,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801ae2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ae6:	75 0a                	jne    801af2 <malloc+0x16>
		return NULL;
  801ae8:	b8 00 00 00 00       	mov    $0x0,%eax
  801aed:	e9 9e 01 00 00       	jmp    801c90 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801af2:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801af9:	77 2c                	ja     801b27 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801afb:	e8 eb 0a 00 00       	call   8025eb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b00:	85 c0                	test   %eax,%eax
  801b02:	74 19                	je     801b1d <malloc+0x41>

			void * block = alloc_block_FF(size);
  801b04:	83 ec 0c             	sub    $0xc,%esp
  801b07:	ff 75 08             	pushl  0x8(%ebp)
  801b0a:	e8 85 11 00 00       	call   802c94 <alloc_block_FF>
  801b0f:	83 c4 10             	add    $0x10,%esp
  801b12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b18:	e9 73 01 00 00       	jmp    801c90 <malloc+0x1b4>
		} else {
			return NULL;
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b22:	e9 69 01 00 00       	jmp    801c90 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801b27:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b34:	01 d0                	add    %edx,%eax
  801b36:	48                   	dec    %eax
  801b37:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b3a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b42:	f7 75 e0             	divl   -0x20(%ebp)
  801b45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b48:	29 d0                	sub    %edx,%eax
  801b4a:	c1 e8 0c             	shr    $0xc,%eax
  801b4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801b57:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801b5e:	a1 40 50 80 00       	mov    0x805040,%eax
  801b63:	8b 40 7c             	mov    0x7c(%eax),%eax
  801b66:	05 00 10 00 00       	add    $0x1000,%eax
  801b6b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801b6e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801b73:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801b76:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801b79:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801b80:	8b 55 08             	mov    0x8(%ebp),%edx
  801b83:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b86:	01 d0                	add    %edx,%eax
  801b88:	48                   	dec    %eax
  801b89:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801b8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b8f:	ba 00 00 00 00       	mov    $0x0,%edx
  801b94:	f7 75 cc             	divl   -0x34(%ebp)
  801b97:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b9a:	29 d0                	sub    %edx,%eax
  801b9c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801b9f:	76 0a                	jbe    801bab <malloc+0xcf>
		return NULL;
  801ba1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba6:	e9 e5 00 00 00       	jmp    801c90 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801bab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bb1:	eb 48                	jmp    801bfb <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801bb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801bb9:	c1 e8 0c             	shr    $0xc,%eax
  801bbc:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801bbf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801bc2:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801bc9:	85 c0                	test   %eax,%eax
  801bcb:	75 11                	jne    801bde <malloc+0x102>
			freePagesCount++;
  801bcd:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801bd0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801bd4:	75 16                	jne    801bec <malloc+0x110>
				start = i;
  801bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bdc:	eb 0e                	jmp    801bec <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801bde:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801be5:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bef:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801bf2:	74 12                	je     801c06 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801bf4:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801bfb:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801c02:	76 af                	jbe    801bb3 <malloc+0xd7>
  801c04:	eb 01                	jmp    801c07 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801c06:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801c07:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c0b:	74 08                	je     801c15 <malloc+0x139>
  801c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c10:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c13:	74 07                	je     801c1c <malloc+0x140>
		return NULL;
  801c15:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1a:	eb 74                	jmp    801c90 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c22:	c1 e8 0c             	shr    $0xc,%eax
  801c25:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801c28:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c2b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c2e:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c35:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c38:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c3b:	eb 11                	jmp    801c4e <malloc+0x172>
		markedPages[i] = 1;
  801c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c40:	c7 04 85 60 50 90 00 	movl   $0x1,0x905060(,%eax,4)
  801c47:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c4b:	ff 45 e8             	incl   -0x18(%ebp)
  801c4e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801c51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c54:	01 d0                	add    %edx,%eax
  801c56:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c59:	77 e2                	ja     801c3d <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801c5b:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801c62:	8b 55 08             	mov    0x8(%ebp),%edx
  801c65:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801c68:	01 d0                	add    %edx,%eax
  801c6a:	48                   	dec    %eax
  801c6b:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801c6e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c71:	ba 00 00 00 00       	mov    $0x0,%edx
  801c76:	f7 75 bc             	divl   -0x44(%ebp)
  801c79:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801c7c:	29 d0                	sub    %edx,%eax
  801c7e:	83 ec 08             	sub    $0x8,%esp
  801c81:	50                   	push   %eax
  801c82:	ff 75 f0             	pushl  -0x10(%ebp)
  801c85:	e8 14 0b 00 00       	call   80279e <sys_allocate_user_mem>
  801c8a:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
  801c95:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801c98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c9c:	0f 84 ee 00 00 00    	je     801d90 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801ca2:	a1 40 50 80 00       	mov    0x805040,%eax
  801ca7:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801caa:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cad:	77 09                	ja     801cb8 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801caf:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801cb6:	76 14                	jbe    801ccc <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801cb8:	83 ec 04             	sub    $0x4,%esp
  801cbb:	68 b8 48 80 00       	push   $0x8048b8
  801cc0:	6a 68                	push   $0x68
  801cc2:	68 d2 48 80 00       	push   $0x8048d2
  801cc7:	e8 a3 ed ff ff       	call   800a6f <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801ccc:	a1 40 50 80 00       	mov    0x805040,%eax
  801cd1:	8b 40 74             	mov    0x74(%eax),%eax
  801cd4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cd7:	77 20                	ja     801cf9 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801cd9:	a1 40 50 80 00       	mov    0x805040,%eax
  801cde:	8b 40 78             	mov    0x78(%eax),%eax
  801ce1:	3b 45 08             	cmp    0x8(%ebp),%eax
  801ce4:	76 13                	jbe    801cf9 <free+0x67>
		free_block(virtual_address);
  801ce6:	83 ec 0c             	sub    $0xc,%esp
  801ce9:	ff 75 08             	pushl  0x8(%ebp)
  801cec:	e8 6c 16 00 00       	call   80335d <free_block>
  801cf1:	83 c4 10             	add    $0x10,%esp
		return;
  801cf4:	e9 98 00 00 00       	jmp    801d91 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  801cfc:	a1 40 50 80 00       	mov    0x805040,%eax
  801d01:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d04:	29 c2                	sub    %eax,%edx
  801d06:	89 d0                	mov    %edx,%eax
  801d08:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801d0d:	c1 e8 0c             	shr    $0xc,%eax
  801d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d1a:	eb 16                	jmp    801d32 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d22:	01 d0                	add    %edx,%eax
  801d24:	c7 04 85 60 50 90 00 	movl   $0x0,0x905060(,%eax,4)
  801d2b:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d2f:	ff 45 f4             	incl   -0xc(%ebp)
  801d32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d35:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801d3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d3f:	7f db                	jg     801d1c <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d44:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  801d4b:	c1 e0 0c             	shl    $0xc,%eax
  801d4e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d57:	eb 1a                	jmp    801d73 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801d59:	83 ec 08             	sub    $0x8,%esp
  801d5c:	68 00 10 00 00       	push   $0x1000
  801d61:	ff 75 f0             	pushl  -0x10(%ebp)
  801d64:	e8 19 0a 00 00       	call   802782 <sys_free_user_mem>
  801d69:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801d6c:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801d73:	8b 55 08             	mov    0x8(%ebp),%edx
  801d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d79:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801d7b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d7e:	77 d9                	ja     801d59 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d83:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801d8a:	00 00 00 00 
  801d8e:	eb 01                	jmp    801d91 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801d90:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 58             	sub    $0x58,%esp
  801d99:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9c:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801d9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801da3:	75 0a                	jne    801daf <smalloc+0x1c>
		return NULL;
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
  801daa:	e9 7d 01 00 00       	jmp    801f2c <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801daf:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dbc:	01 d0                	add    %edx,%eax
  801dbe:	48                   	dec    %eax
  801dbf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801dc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dca:	f7 75 e4             	divl   -0x1c(%ebp)
  801dcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dd0:	29 d0                	sub    %edx,%eax
  801dd2:	c1 e8 0c             	shr    $0xc,%eax
  801dd5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801dd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801ddf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801de6:	a1 40 50 80 00       	mov    0x805040,%eax
  801deb:	8b 40 7c             	mov    0x7c(%eax),%eax
  801dee:	05 00 10 00 00       	add    $0x1000,%eax
  801df3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801df6:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801dfb:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801dfe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801e01:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e0e:	01 d0                	add    %edx,%eax
  801e10:	48                   	dec    %eax
  801e11:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e14:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e17:	ba 00 00 00 00       	mov    $0x0,%edx
  801e1c:	f7 75 d0             	divl   -0x30(%ebp)
  801e1f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e22:	29 d0                	sub    %edx,%eax
  801e24:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e27:	76 0a                	jbe    801e33 <smalloc+0xa0>
		return NULL;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	e9 f9 00 00 00       	jmp    801f2c <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801e33:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e36:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e39:	eb 48                	jmp    801e83 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3e:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801e41:	c1 e8 0c             	shr    $0xc,%eax
  801e44:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801e47:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e4a:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801e51:	85 c0                	test   %eax,%eax
  801e53:	75 11                	jne    801e66 <smalloc+0xd3>
			freePagesCount++;
  801e55:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801e58:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e5c:	75 16                	jne    801e74 <smalloc+0xe1>
				start = s;
  801e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e64:	eb 0e                	jmp    801e74 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801e66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801e6d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e7a:	74 12                	je     801e8e <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801e7c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801e83:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801e8a:	76 af                	jbe    801e3b <smalloc+0xa8>
  801e8c:	eb 01                	jmp    801e8f <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801e8e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801e8f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801e93:	74 08                	je     801e9d <smalloc+0x10a>
  801e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e98:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801e9b:	74 0a                	je     801ea7 <smalloc+0x114>
		return NULL;
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	e9 85 00 00 00       	jmp    801f2c <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eaa:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ead:	c1 e8 0c             	shr    $0xc,%eax
  801eb0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801eb3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801eb6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801eb9:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801ec0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ec3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ec6:	eb 11                	jmp    801ed9 <smalloc+0x146>
		markedPages[s] = 1;
  801ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ecb:	c7 04 85 60 50 90 00 	movl   $0x1,0x905060(,%eax,4)
  801ed2:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801ed6:	ff 45 e8             	incl   -0x18(%ebp)
  801ed9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801edc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801edf:	01 d0                	add    %edx,%eax
  801ee1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801ee4:	77 e2                	ja     801ec8 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801ee6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ee9:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801eed:	52                   	push   %edx
  801eee:	50                   	push   %eax
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	e8 8f 04 00 00       	call   802389 <sys_createSharedObject>
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801f00:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801f04:	78 12                	js     801f18 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801f06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f09:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801f0c:	89 14 85 60 50 88 00 	mov    %edx,0x885060(,%eax,4)
		return (void*) start;
  801f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f16:	eb 14                	jmp    801f2c <smalloc+0x199>
	}
	free((void*) start);
  801f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	50                   	push   %eax
  801f1f:	e8 6e fd ff ff       	call   801c92 <free>
  801f24:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2c:	c9                   	leave  
  801f2d:	c3                   	ret    

00801f2e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801f34:	83 ec 08             	sub    $0x8,%esp
  801f37:	ff 75 0c             	pushl  0xc(%ebp)
  801f3a:	ff 75 08             	pushl  0x8(%ebp)
  801f3d:	e8 71 04 00 00       	call   8023b3 <sys_getSizeOfSharedObject>
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801f48:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801f4f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f55:	01 d0                	add    %edx,%eax
  801f57:	48                   	dec    %eax
  801f58:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f63:	f7 75 e0             	divl   -0x20(%ebp)
  801f66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f69:	29 d0                	sub    %edx,%eax
  801f6b:	c1 e8 0c             	shr    $0xc,%eax
  801f6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801f78:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801f7f:	a1 40 50 80 00       	mov    0x805040,%eax
  801f84:	8b 40 7c             	mov    0x7c(%eax),%eax
  801f87:	05 00 10 00 00       	add    $0x1000,%eax
  801f8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801f8f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801f94:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f97:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801f9a:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801fa1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fa7:	01 d0                	add    %edx,%eax
  801fa9:	48                   	dec    %eax
  801faa:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801fad:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fb0:	ba 00 00 00 00       	mov    $0x0,%edx
  801fb5:	f7 75 cc             	divl   -0x34(%ebp)
  801fb8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801fbb:	29 d0                	sub    %edx,%eax
  801fbd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801fc0:	76 0a                	jbe    801fcc <sget+0x9e>
		return NULL;
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc7:	e9 f7 00 00 00       	jmp    8020c3 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801fcc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fd2:	eb 48                	jmp    80201c <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd7:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fda:	c1 e8 0c             	shr    $0xc,%eax
  801fdd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801fe0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fe3:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801fea:	85 c0                	test   %eax,%eax
  801fec:	75 11                	jne    801fff <sget+0xd1>
			free_Pages_Count++;
  801fee:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801ff1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ff5:	75 16                	jne    80200d <sget+0xdf>
				start = s;
  801ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ffd:	eb 0e                	jmp    80200d <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801fff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802006:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802013:	74 12                	je     802027 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802015:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80201c:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802023:	76 af                	jbe    801fd4 <sget+0xa6>
  802025:	eb 01                	jmp    802028 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802027:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802028:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80202c:	74 08                	je     802036 <sget+0x108>
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802034:	74 0a                	je     802040 <sget+0x112>
		return NULL;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	e9 83 00 00 00       	jmp    8020c3 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802046:	c1 e8 0c             	shr    $0xc,%eax
  802049:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80204c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80204f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802052:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802059:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80205c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80205f:	eb 11                	jmp    802072 <sget+0x144>
		markedPages[k] = 1;
  802061:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802064:	c7 04 85 60 50 90 00 	movl   $0x1,0x905060(,%eax,4)
  80206b:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80206f:	ff 45 e8             	incl   -0x18(%ebp)
  802072:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802075:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802078:	01 d0                	add    %edx,%eax
  80207a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80207d:	77 e2                	ja     802061 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802082:	83 ec 04             	sub    $0x4,%esp
  802085:	50                   	push   %eax
  802086:	ff 75 0c             	pushl  0xc(%ebp)
  802089:	ff 75 08             	pushl  0x8(%ebp)
  80208c:	e8 3f 03 00 00       	call   8023d0 <sys_getSharedObject>
  802091:	83 c4 10             	add    $0x10,%esp
  802094:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802097:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  80209b:	78 12                	js     8020af <sget+0x181>
		shardIDs[startPage] = ss;
  80209d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020a0:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8020a3:	89 14 85 60 50 88 00 	mov    %edx,0x885060(,%eax,4)
		return (void*) start;
  8020aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ad:	eb 14                	jmp    8020c3 <sget+0x195>
	}
	free((void*) start);
  8020af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b2:	83 ec 0c             	sub    $0xc,%esp
  8020b5:	50                   	push   %eax
  8020b6:	e8 d7 fb ff ff       	call   801c92 <free>
  8020bb:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8020be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8020cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8020ce:	a1 40 50 80 00       	mov    0x805040,%eax
  8020d3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8020d6:	29 c2                	sub    %eax,%edx
  8020d8:	89 d0                	mov    %edx,%eax
  8020da:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8020df:	c1 e8 0c             	shr    $0xc,%eax
  8020e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8020e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e8:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  8020ef:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8020f2:	83 ec 08             	sub    $0x8,%esp
  8020f5:	ff 75 08             	pushl  0x8(%ebp)
  8020f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8020fb:	e8 ef 02 00 00       	call   8023ef <sys_freeSharedObject>
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  802106:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80210a:	75 0e                	jne    80211a <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	c7 04 85 60 50 88 00 	movl   $0xffffffff,0x885060(,%eax,4)
  802116:	ff ff ff ff 
	}

}
  80211a:	90                   	nop
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
  802120:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802123:	83 ec 04             	sub    $0x4,%esp
  802126:	68 e0 48 80 00       	push   $0x8048e0
  80212b:	68 19 01 00 00       	push   $0x119
  802130:	68 d2 48 80 00       	push   $0x8048d2
  802135:	e8 35 e9 ff ff       	call   800a6f <_panic>

0080213a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 06 49 80 00       	push   $0x804906
  802148:	68 23 01 00 00       	push   $0x123
  80214d:	68 d2 48 80 00       	push   $0x8048d2
  802152:	e8 18 e9 ff ff       	call   800a6f <_panic>

00802157 <shrink>:

}
void shrink(uint32 newSize) {
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
  80215a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	68 06 49 80 00       	push   $0x804906
  802165:	68 27 01 00 00       	push   $0x127
  80216a:	68 d2 48 80 00       	push   $0x8048d2
  80216f:	e8 fb e8 ff ff       	call   800a6f <_panic>

00802174 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80217a:	83 ec 04             	sub    $0x4,%esp
  80217d:	68 06 49 80 00       	push   $0x804906
  802182:	68 2b 01 00 00       	push   $0x12b
  802187:	68 d2 48 80 00       	push   $0x8048d2
  80218c:	e8 de e8 ff ff       	call   800a6f <_panic>

00802191 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	57                   	push   %edi
  802195:	56                   	push   %esi
  802196:	53                   	push   %ebx
  802197:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021a9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021ac:	cd 30                	int    $0x30
  8021ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8021b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    

008021bc <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8021c8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	52                   	push   %edx
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	50                   	push   %eax
  8021d8:	6a 00                	push   $0x0
  8021da:	e8 b2 ff ff ff       	call   802191 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	90                   	nop
  8021e3:	c9                   	leave  
  8021e4:	c3                   	ret    

008021e5 <sys_cgetc>:

int sys_cgetc(void) {
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 02                	push   $0x2
  8021f4:	e8 98 ff ff ff       	call   802191 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_lock_cons>:

void sys_lock_cons(void) {
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 03                	push   $0x3
  80220d:	e8 7f ff ff ff       	call   802191 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	90                   	nop
  802216:	c9                   	leave  
  802217:	c3                   	ret    

00802218 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 04                	push   $0x4
  802227:	e8 65 ff ff ff       	call   802191 <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802235:	8b 55 0c             	mov    0xc(%ebp),%edx
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	52                   	push   %edx
  802242:	50                   	push   %eax
  802243:	6a 08                	push   $0x8
  802245:	e8 47 ff ff ff       	call   802191 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	56                   	push   %esi
  802253:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802254:	8b 75 18             	mov    0x18(%ebp),%esi
  802257:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	56                   	push   %esi
  802264:	53                   	push   %ebx
  802265:	51                   	push   %ecx
  802266:	52                   	push   %edx
  802267:	50                   	push   %eax
  802268:	6a 09                	push   $0x9
  80226a:	e8 22 ff ff ff       	call   802191 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802272:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802275:	5b                   	pop    %ebx
  802276:	5e                   	pop    %esi
  802277:	5d                   	pop    %ebp
  802278:	c3                   	ret    

00802279 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80227c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	52                   	push   %edx
  802289:	50                   	push   %eax
  80228a:	6a 0a                	push   $0xa
  80228c:	e8 00 ff ff ff       	call   802191 <syscall>
  802291:	83 c4 18             	add    $0x18,%esp
}
  802294:	c9                   	leave  
  802295:	c3                   	ret    

00802296 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	ff 75 0c             	pushl  0xc(%ebp)
  8022a2:	ff 75 08             	pushl  0x8(%ebp)
  8022a5:	6a 0b                	push   $0xb
  8022a7:	e8 e5 fe ff ff       	call   802191 <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 0c                	push   $0xc
  8022c0:	e8 cc fe ff ff       	call   802191 <syscall>
  8022c5:	83 c4 18             	add    $0x18,%esp
}
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 0d                	push   $0xd
  8022d9:	e8 b3 fe ff ff       	call   802191 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
}
  8022e1:	c9                   	leave  
  8022e2:	c3                   	ret    

008022e3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8022e3:	55                   	push   %ebp
  8022e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 0e                	push   $0xe
  8022f2:	e8 9a fe ff ff       	call   802191 <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	c9                   	leave  
  8022fb:	c3                   	ret    

008022fc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 0f                	push   $0xf
  80230b:	e8 81 fe ff ff       	call   802191 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	ff 75 08             	pushl  0x8(%ebp)
  802323:	6a 10                	push   $0x10
  802325:	e8 67 fe ff ff       	call   802191 <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_scarce_memory>:

void sys_scarce_memory() {
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 11                	push   $0x11
  80233e:	e8 4e fe ff ff       	call   802191 <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
}
  802346:	90                   	nop
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_cputc>:

void sys_cputc(const char c) {
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 04             	sub    $0x4,%esp
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802355:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	50                   	push   %eax
  802362:	6a 01                	push   $0x1
  802364:	e8 28 fe ff ff       	call   802191 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	90                   	nop
  80236d:	c9                   	leave  
  80236e:	c3                   	ret    

0080236f <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  80236f:	55                   	push   %ebp
  802370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 14                	push   $0x14
  80237e:	e8 0e fe ff ff       	call   802191 <syscall>
  802383:	83 c4 18             	add    $0x18,%esp
}
  802386:	90                   	nop
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	8b 45 10             	mov    0x10(%ebp),%eax
  802392:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  802395:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802398:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	6a 00                	push   $0x0
  8023a1:	51                   	push   %ecx
  8023a2:	52                   	push   %edx
  8023a3:	ff 75 0c             	pushl  0xc(%ebp)
  8023a6:	50                   	push   %eax
  8023a7:	6a 15                	push   $0x15
  8023a9:	e8 e3 fd ff ff       	call   802191 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8023b1:	c9                   	leave  
  8023b2:	c3                   	ret    

008023b3 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8023b3:	55                   	push   %ebp
  8023b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8023b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	52                   	push   %edx
  8023c3:	50                   	push   %eax
  8023c4:	6a 16                	push   $0x16
  8023c6:	e8 c6 fd ff ff       	call   802191 <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8023d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	51                   	push   %ecx
  8023e1:	52                   	push   %edx
  8023e2:	50                   	push   %eax
  8023e3:	6a 17                	push   $0x17
  8023e5:	e8 a7 fd ff ff       	call   802191 <syscall>
  8023ea:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8023f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	52                   	push   %edx
  8023ff:	50                   	push   %eax
  802400:	6a 18                	push   $0x18
  802402:	e8 8a fd ff ff       	call   802191 <syscall>
  802407:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  80240f:	8b 45 08             	mov    0x8(%ebp),%eax
  802412:	6a 00                	push   $0x0
  802414:	ff 75 14             	pushl  0x14(%ebp)
  802417:	ff 75 10             	pushl  0x10(%ebp)
  80241a:	ff 75 0c             	pushl  0xc(%ebp)
  80241d:	50                   	push   %eax
  80241e:	6a 19                	push   $0x19
  802420:	e8 6c fd ff ff       	call   802191 <syscall>
  802425:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <sys_run_env>:

void sys_run_env(int32 envId) {
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	50                   	push   %eax
  802439:	6a 1a                	push   $0x1a
  80243b:	e8 51 fd ff ff       	call   802191 <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
}
  802443:	90                   	nop
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	50                   	push   %eax
  802455:	6a 1b                	push   $0x1b
  802457:	e8 35 fd ff ff       	call   802191 <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
}
  80245f:	c9                   	leave  
  802460:	c3                   	ret    

00802461 <sys_getenvid>:

int32 sys_getenvid(void) {
  802461:	55                   	push   %ebp
  802462:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 05                	push   $0x5
  802470:	e8 1c fd ff ff       	call   802191 <syscall>
  802475:	83 c4 18             	add    $0x18,%esp
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 06                	push   $0x6
  802489:	e8 03 fd ff ff       	call   802191 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
}
  802491:	c9                   	leave  
  802492:	c3                   	ret    

00802493 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802493:	55                   	push   %ebp
  802494:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 07                	push   $0x7
  8024a2:	e8 ea fc ff ff       	call   802191 <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_exit_env>:

void sys_exit_env(void) {
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 1c                	push   $0x1c
  8024bb:	e8 d1 fc ff ff       	call   802191 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
}
  8024c3:	90                   	nop
  8024c4:	c9                   	leave  
  8024c5:	c3                   	ret    

008024c6 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8024c6:	55                   	push   %ebp
  8024c7:	89 e5                	mov    %esp,%ebp
  8024c9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8024cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024cf:	8d 50 04             	lea    0x4(%eax),%edx
  8024d2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	52                   	push   %edx
  8024dc:	50                   	push   %eax
  8024dd:	6a 1d                	push   $0x1d
  8024df:	e8 ad fc ff ff       	call   802191 <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8024e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f0:	89 01                	mov    %eax,(%ecx)
  8024f2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	c9                   	leave  
  8024f9:	c2 04 00             	ret    $0x4

008024fc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	ff 75 10             	pushl  0x10(%ebp)
  802506:	ff 75 0c             	pushl  0xc(%ebp)
  802509:	ff 75 08             	pushl  0x8(%ebp)
  80250c:	6a 13                	push   $0x13
  80250e:	e8 7e fc ff ff       	call   802191 <syscall>
  802513:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802516:	90                   	nop
}
  802517:	c9                   	leave  
  802518:	c3                   	ret    

00802519 <sys_rcr2>:
uint32 sys_rcr2() {
  802519:	55                   	push   %ebp
  80251a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 1e                	push   $0x1e
  802528:	e8 64 fc ff ff       	call   802191 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 04             	sub    $0x4,%esp
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80253e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	50                   	push   %eax
  80254b:	6a 1f                	push   $0x1f
  80254d:	e8 3f fc ff ff       	call   802191 <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
	return;
  802555:	90                   	nop
}
  802556:	c9                   	leave  
  802557:	c3                   	ret    

00802558 <rsttst>:
void rsttst() {
  802558:	55                   	push   %ebp
  802559:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 21                	push   $0x21
  802567:	e8 25 fc ff ff       	call   802191 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
	return;
  80256f:	90                   	nop
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	8b 45 14             	mov    0x14(%ebp),%eax
  80257b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80257e:	8b 55 18             	mov    0x18(%ebp),%edx
  802581:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802585:	52                   	push   %edx
  802586:	50                   	push   %eax
  802587:	ff 75 10             	pushl  0x10(%ebp)
  80258a:	ff 75 0c             	pushl  0xc(%ebp)
  80258d:	ff 75 08             	pushl  0x8(%ebp)
  802590:	6a 20                	push   $0x20
  802592:	e8 fa fb ff ff       	call   802191 <syscall>
  802597:	83 c4 18             	add    $0x18,%esp
	return;
  80259a:	90                   	nop
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <chktst>:
void chktst(uint32 n) {
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	ff 75 08             	pushl  0x8(%ebp)
  8025ab:	6a 22                	push   $0x22
  8025ad:	e8 df fb ff ff       	call   802191 <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
	return;
  8025b5:	90                   	nop
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <inctst>:

void inctst() {
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 23                	push   $0x23
  8025c7:	e8 c5 fb ff ff       	call   802191 <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
	return;
  8025cf:	90                   	nop
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <gettst>:
uint32 gettst() {
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 24                	push   $0x24
  8025e1:	e8 ab fb ff ff       	call   802191 <syscall>
  8025e6:	83 c4 18             	add    $0x18,%esp
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 25                	push   $0x25
  8025fd:	e8 8f fb ff ff       	call   802191 <syscall>
  802602:	83 c4 18             	add    $0x18,%esp
  802605:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802608:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80260c:	75 07                	jne    802615 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80260e:	b8 01 00 00 00       	mov    $0x1,%eax
  802613:	eb 05                	jmp    80261a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802615:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 25                	push   $0x25
  80262e:	e8 5e fb ff ff       	call   802191 <syscall>
  802633:	83 c4 18             	add    $0x18,%esp
  802636:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802639:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80263d:	75 07                	jne    802646 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80263f:	b8 01 00 00 00       	mov    $0x1,%eax
  802644:	eb 05                	jmp    80264b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802646:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 25                	push   $0x25
  80265f:	e8 2d fb ff ff       	call   802191 <syscall>
  802664:	83 c4 18             	add    $0x18,%esp
  802667:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80266a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80266e:	75 07                	jne    802677 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802670:	b8 01 00 00 00       	mov    $0x1,%eax
  802675:	eb 05                	jmp    80267c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802677:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267c:	c9                   	leave  
  80267d:	c3                   	ret    

0080267e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80267e:	55                   	push   %ebp
  80267f:	89 e5                	mov    %esp,%ebp
  802681:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 25                	push   $0x25
  802690:	e8 fc fa ff ff       	call   802191 <syscall>
  802695:	83 c4 18             	add    $0x18,%esp
  802698:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80269b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80269f:	75 07                	jne    8026a8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a6:	eb 05                	jmp    8026ad <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ad:	c9                   	leave  
  8026ae:	c3                   	ret    

008026af <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026b2:	6a 00                	push   $0x0
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	ff 75 08             	pushl  0x8(%ebp)
  8026bd:	6a 26                	push   $0x26
  8026bf:	e8 cd fa ff ff       	call   802191 <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
	return;
  8026c7:	90                   	nop
}
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8026ce:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026da:	6a 00                	push   $0x0
  8026dc:	53                   	push   %ebx
  8026dd:	51                   	push   %ecx
  8026de:	52                   	push   %edx
  8026df:	50                   	push   %eax
  8026e0:	6a 27                	push   $0x27
  8026e2:	e8 aa fa ff ff       	call   802191 <syscall>
  8026e7:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8026ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026ed:	c9                   	leave  
  8026ee:	c3                   	ret    

008026ef <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8026ef:	55                   	push   %ebp
  8026f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8026f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	52                   	push   %edx
  8026ff:	50                   	push   %eax
  802700:	6a 28                	push   $0x28
  802702:	e8 8a fa ff ff       	call   802191 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80270a:	c9                   	leave  
  80270b:	c3                   	ret    

0080270c <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  80270f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802712:	8b 55 0c             	mov    0xc(%ebp),%edx
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	6a 00                	push   $0x0
  80271a:	51                   	push   %ecx
  80271b:	ff 75 10             	pushl  0x10(%ebp)
  80271e:	52                   	push   %edx
  80271f:	50                   	push   %eax
  802720:	6a 29                	push   $0x29
  802722:	e8 6a fa ff ff       	call   802191 <syscall>
  802727:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80272a:	c9                   	leave  
  80272b:	c3                   	ret    

0080272c <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80272f:	6a 00                	push   $0x0
  802731:	6a 00                	push   $0x0
  802733:	ff 75 10             	pushl  0x10(%ebp)
  802736:	ff 75 0c             	pushl  0xc(%ebp)
  802739:	ff 75 08             	pushl  0x8(%ebp)
  80273c:	6a 12                	push   $0x12
  80273e:	e8 4e fa ff ff       	call   802191 <syscall>
  802743:	83 c4 18             	add    $0x18,%esp
	return;
  802746:	90                   	nop
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80274c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80274f:	8b 45 08             	mov    0x8(%ebp),%eax
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	52                   	push   %edx
  802759:	50                   	push   %eax
  80275a:	6a 2a                	push   $0x2a
  80275c:	e8 30 fa ff ff       	call   802191 <syscall>
  802761:	83 c4 18             	add    $0x18,%esp
	return;
  802764:	90                   	nop
}
  802765:	c9                   	leave  
  802766:	c3                   	ret    

00802767 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802767:	55                   	push   %ebp
  802768:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	6a 00                	push   $0x0
  80276f:	6a 00                	push   $0x0
  802771:	6a 00                	push   $0x0
  802773:	6a 00                	push   $0x0
  802775:	50                   	push   %eax
  802776:	6a 2b                	push   $0x2b
  802778:	e8 14 fa ff ff       	call   802191 <syscall>
  80277d:	83 c4 18             	add    $0x18,%esp
}
  802780:	c9                   	leave  
  802781:	c3                   	ret    

00802782 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	ff 75 0c             	pushl  0xc(%ebp)
  80278e:	ff 75 08             	pushl  0x8(%ebp)
  802791:	6a 2c                	push   $0x2c
  802793:	e8 f9 f9 ff ff       	call   802191 <syscall>
  802798:	83 c4 18             	add    $0x18,%esp
	return;
  80279b:	90                   	nop
}
  80279c:	c9                   	leave  
  80279d:	c3                   	ret    

0080279e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 00                	push   $0x0
  8027a5:	6a 00                	push   $0x0
  8027a7:	ff 75 0c             	pushl  0xc(%ebp)
  8027aa:	ff 75 08             	pushl  0x8(%ebp)
  8027ad:	6a 2d                	push   $0x2d
  8027af:	e8 dd f9 ff ff       	call   802191 <syscall>
  8027b4:	83 c4 18             	add    $0x18,%esp
	return;
  8027b7:	90                   	nop
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	6a 00                	push   $0x0
  8027c2:	6a 00                	push   $0x0
  8027c4:	6a 00                	push   $0x0
  8027c6:	6a 00                	push   $0x0
  8027c8:	50                   	push   %eax
  8027c9:	6a 2f                	push   $0x2f
  8027cb:	e8 c1 f9 ff ff       	call   802191 <syscall>
  8027d0:	83 c4 18             	add    $0x18,%esp
	return;
  8027d3:	90                   	nop
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8027d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	6a 00                	push   $0x0
  8027e1:	6a 00                	push   $0x0
  8027e3:	6a 00                	push   $0x0
  8027e5:	52                   	push   %edx
  8027e6:	50                   	push   %eax
  8027e7:	6a 30                	push   $0x30
  8027e9:	e8 a3 f9 ff ff       	call   802191 <syscall>
  8027ee:	83 c4 18             	add    $0x18,%esp
	return;
  8027f1:	90                   	nop
}
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	6a 00                	push   $0x0
  802800:	6a 00                	push   $0x0
  802802:	50                   	push   %eax
  802803:	6a 31                	push   $0x31
  802805:	e8 87 f9 ff ff       	call   802191 <syscall>
  80280a:	83 c4 18             	add    $0x18,%esp
	return;
  80280d:	90                   	nop
}
  80280e:	c9                   	leave  
  80280f:	c3                   	ret    

00802810 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802813:	8b 55 0c             	mov    0xc(%ebp),%edx
  802816:	8b 45 08             	mov    0x8(%ebp),%eax
  802819:	6a 00                	push   $0x0
  80281b:	6a 00                	push   $0x0
  80281d:	6a 00                	push   $0x0
  80281f:	52                   	push   %edx
  802820:	50                   	push   %eax
  802821:	6a 2e                	push   $0x2e
  802823:	e8 69 f9 ff ff       	call   802191 <syscall>
  802828:	83 c4 18             	add    $0x18,%esp
    return;
  80282b:	90                   	nop
}
  80282c:	c9                   	leave  
  80282d:	c3                   	ret    

0080282e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802834:	8b 45 08             	mov    0x8(%ebp),%eax
  802837:	83 e8 04             	sub    $0x4,%eax
  80283a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80283d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802840:	8b 00                	mov    (%eax),%eax
  802842:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802845:	c9                   	leave  
  802846:	c3                   	ret    

00802847 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802847:	55                   	push   %ebp
  802848:	89 e5                	mov    %esp,%ebp
  80284a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80284d:	8b 45 08             	mov    0x8(%ebp),%eax
  802850:	83 e8 04             	sub    $0x4,%eax
  802853:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	83 e0 01             	and    $0x1,%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	0f 94 c0             	sete   %al
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  80286b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802872:	8b 45 0c             	mov    0xc(%ebp),%eax
  802875:	83 f8 02             	cmp    $0x2,%eax
  802878:	74 2b                	je     8028a5 <alloc_block+0x40>
  80287a:	83 f8 02             	cmp    $0x2,%eax
  80287d:	7f 07                	jg     802886 <alloc_block+0x21>
  80287f:	83 f8 01             	cmp    $0x1,%eax
  802882:	74 0e                	je     802892 <alloc_block+0x2d>
  802884:	eb 58                	jmp    8028de <alloc_block+0x79>
  802886:	83 f8 03             	cmp    $0x3,%eax
  802889:	74 2d                	je     8028b8 <alloc_block+0x53>
  80288b:	83 f8 04             	cmp    $0x4,%eax
  80288e:	74 3b                	je     8028cb <alloc_block+0x66>
  802890:	eb 4c                	jmp    8028de <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802892:	83 ec 0c             	sub    $0xc,%esp
  802895:	ff 75 08             	pushl  0x8(%ebp)
  802898:	e8 f7 03 00 00       	call   802c94 <alloc_block_FF>
  80289d:	83 c4 10             	add    $0x10,%esp
  8028a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028a3:	eb 4a                	jmp    8028ef <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8028a5:	83 ec 0c             	sub    $0xc,%esp
  8028a8:	ff 75 08             	pushl  0x8(%ebp)
  8028ab:	e8 f0 11 00 00       	call   803aa0 <alloc_block_NF>
  8028b0:	83 c4 10             	add    $0x10,%esp
  8028b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028b6:	eb 37                	jmp    8028ef <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8028b8:	83 ec 0c             	sub    $0xc,%esp
  8028bb:	ff 75 08             	pushl  0x8(%ebp)
  8028be:	e8 08 08 00 00       	call   8030cb <alloc_block_BF>
  8028c3:	83 c4 10             	add    $0x10,%esp
  8028c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028c9:	eb 24                	jmp    8028ef <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8028cb:	83 ec 0c             	sub    $0xc,%esp
  8028ce:	ff 75 08             	pushl  0x8(%ebp)
  8028d1:	e8 ad 11 00 00       	call   803a83 <alloc_block_WF>
  8028d6:	83 c4 10             	add    $0x10,%esp
  8028d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8028dc:	eb 11                	jmp    8028ef <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8028de:	83 ec 0c             	sub    $0xc,%esp
  8028e1:	68 18 49 80 00       	push   $0x804918
  8028e6:	e8 41 e4 ff ff       	call   800d2c <cprintf>
  8028eb:	83 c4 10             	add    $0x10,%esp
		break;
  8028ee:	90                   	nop
	}
	return va;
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8028f2:	c9                   	leave  
  8028f3:	c3                   	ret    

008028f4 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8028f4:	55                   	push   %ebp
  8028f5:	89 e5                	mov    %esp,%ebp
  8028f7:	53                   	push   %ebx
  8028f8:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8028fb:	83 ec 0c             	sub    $0xc,%esp
  8028fe:	68 38 49 80 00       	push   $0x804938
  802903:	e8 24 e4 ff ff       	call   800d2c <cprintf>
  802908:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80290b:	83 ec 0c             	sub    $0xc,%esp
  80290e:	68 63 49 80 00       	push   $0x804963
  802913:	e8 14 e4 ff ff       	call   800d2c <cprintf>
  802918:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802921:	eb 37                	jmp    80295a <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802923:	83 ec 0c             	sub    $0xc,%esp
  802926:	ff 75 f4             	pushl  -0xc(%ebp)
  802929:	e8 19 ff ff ff       	call   802847 <is_free_block>
  80292e:	83 c4 10             	add    $0x10,%esp
  802931:	0f be d8             	movsbl %al,%ebx
  802934:	83 ec 0c             	sub    $0xc,%esp
  802937:	ff 75 f4             	pushl  -0xc(%ebp)
  80293a:	e8 ef fe ff ff       	call   80282e <get_block_size>
  80293f:	83 c4 10             	add    $0x10,%esp
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	53                   	push   %ebx
  802946:	50                   	push   %eax
  802947:	68 7b 49 80 00       	push   $0x80497b
  80294c:	e8 db e3 ff ff       	call   800d2c <cprintf>
  802951:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802954:	8b 45 10             	mov    0x10(%ebp),%eax
  802957:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80295a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295e:	74 07                	je     802967 <print_blocks_list+0x73>
  802960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	eb 05                	jmp    80296c <print_blocks_list+0x78>
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
  80296c:	89 45 10             	mov    %eax,0x10(%ebp)
  80296f:	8b 45 10             	mov    0x10(%ebp),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	75 ad                	jne    802923 <print_blocks_list+0x2f>
  802976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297a:	75 a7                	jne    802923 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	68 38 49 80 00       	push   $0x804938
  802984:	e8 a3 e3 ff ff       	call   800d2c <cprintf>
  802989:	83 c4 10             	add    $0x10,%esp

}
  80298c:	90                   	nop
  80298d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802990:	c9                   	leave  
  802991:	c3                   	ret    

00802992 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802992:	55                   	push   %ebp
  802993:	89 e5                	mov    %esp,%ebp
  802995:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802998:	8b 45 0c             	mov    0xc(%ebp),%eax
  80299b:	83 e0 01             	and    $0x1,%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	74 03                	je     8029a5 <initialize_dynamic_allocator+0x13>
  8029a2:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8029a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8029a9:	0f 84 f8 00 00 00    	je     802aa7 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8029af:	c7 05 60 50 98 00 01 	movl   $0x1,0x985060
  8029b6:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8029b9:	a1 60 50 98 00       	mov    0x985060,%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	0f 84 e2 00 00 00    	je     802aa8 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8029d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029db:	01 d0                	add    %edx,%eax
  8029dd:	83 e8 04             	sub    $0x4,%eax
  8029e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	83 c0 08             	add    $0x8,%eax
  8029f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8029f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f8:	83 e8 08             	sub    $0x8,%eax
  8029fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	6a 00                	push   $0x0
  802a03:	ff 75 e8             	pushl  -0x18(%ebp)
  802a06:	ff 75 ec             	pushl  -0x14(%ebp)
  802a09:	e8 9c 00 00 00       	call   802aaa <set_block_data>
  802a0e:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802a24:	c7 05 84 50 98 00 00 	movl   $0x0,0x985084
  802a2b:	00 00 00 
  802a2e:	c7 05 88 50 98 00 00 	movl   $0x0,0x985088
  802a35:	00 00 00 
  802a38:	c7 05 90 50 98 00 00 	movl   $0x0,0x985090
  802a3f:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802a42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a46:	75 17                	jne    802a5f <initialize_dynamic_allocator+0xcd>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 94 49 80 00       	push   $0x804994
  802a50:	68 80 00 00 00       	push   $0x80
  802a55:	68 b7 49 80 00       	push   $0x8049b7
  802a5a:	e8 10 e0 ff ff       	call   800a6f <_panic>
  802a5f:	8b 15 84 50 98 00    	mov    0x985084,%edx
  802a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 0d                	je     802a80 <initialize_dynamic_allocator+0xee>
  802a73:	a1 84 50 98 00       	mov    0x985084,%eax
  802a78:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	eb 08                	jmp    802a88 <initialize_dynamic_allocator+0xf6>
  802a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a83:	a3 88 50 98 00       	mov    %eax,0x985088
  802a88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8b:	a3 84 50 98 00       	mov    %eax,0x985084
  802a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9a:	a1 90 50 98 00       	mov    0x985090,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 90 50 98 00       	mov    %eax,0x985090
  802aa5:	eb 01                	jmp    802aa8 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802aa7:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802aa8:	c9                   	leave  
  802aa9:	c3                   	ret    

00802aaa <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802aaa:	55                   	push   %ebp
  802aab:	89 e5                	mov    %esp,%ebp
  802aad:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab3:	83 e0 01             	and    $0x1,%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	74 03                	je     802abd <set_block_data+0x13>
	{
		totalSize++;
  802aba:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	83 e8 04             	sub    $0x4,%eax
  802ac3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac9:	83 e0 fe             	and    $0xfffffffe,%eax
  802acc:	89 c2                	mov    %eax,%edx
  802ace:	8b 45 10             	mov    0x10(%ebp),%eax
  802ad1:	83 e0 01             	and    $0x1,%eax
  802ad4:	09 c2                	or     %eax,%edx
  802ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ad9:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802adb:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ade:	8d 50 f8             	lea    -0x8(%eax),%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	01 d0                	add    %edx,%eax
  802ae6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802aec:	83 e0 fe             	and    $0xfffffffe,%eax
  802aef:	89 c2                	mov    %eax,%edx
  802af1:	8b 45 10             	mov    0x10(%ebp),%eax
  802af4:	83 e0 01             	and    $0x1,%eax
  802af7:	09 c2                	or     %eax,%edx
  802af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802afc:	89 10                	mov    %edx,(%eax)
}
  802afe:	90                   	nop
  802aff:	c9                   	leave  
  802b00:	c3                   	ret    

00802b01 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802b01:	55                   	push   %ebp
  802b02:	89 e5                	mov    %esp,%ebp
  802b04:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802b07:	a1 84 50 98 00       	mov    0x985084,%eax
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	75 68                	jne    802b78 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802b10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b14:	75 17                	jne    802b2d <insert_sorted_in_freeList+0x2c>
  802b16:	83 ec 04             	sub    $0x4,%esp
  802b19:	68 94 49 80 00       	push   $0x804994
  802b1e:	68 9d 00 00 00       	push   $0x9d
  802b23:	68 b7 49 80 00       	push   $0x8049b7
  802b28:	e8 42 df ff ff       	call   800a6f <_panic>
  802b2d:	8b 15 84 50 98 00    	mov    0x985084,%edx
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	89 10                	mov    %edx,(%eax)
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 00                	mov    (%eax),%eax
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	74 0d                	je     802b4e <insert_sorted_in_freeList+0x4d>
  802b41:	a1 84 50 98 00       	mov    0x985084,%eax
  802b46:	8b 55 08             	mov    0x8(%ebp),%edx
  802b49:	89 50 04             	mov    %edx,0x4(%eax)
  802b4c:	eb 08                	jmp    802b56 <insert_sorted_in_freeList+0x55>
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	a3 88 50 98 00       	mov    %eax,0x985088
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	a3 84 50 98 00       	mov    %eax,0x985084
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b68:	a1 90 50 98 00       	mov    0x985090,%eax
  802b6d:	40                   	inc    %eax
  802b6e:	a3 90 50 98 00       	mov    %eax,0x985090
		return;
  802b73:	e9 1a 01 00 00       	jmp    802c92 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802b78:	a1 84 50 98 00       	mov    0x985084,%eax
  802b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b80:	eb 7f                	jmp    802c01 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b88:	76 6f                	jbe    802bf9 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b8e:	74 06                	je     802b96 <insert_sorted_in_freeList+0x95>
  802b90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b94:	75 17                	jne    802bad <insert_sorted_in_freeList+0xac>
  802b96:	83 ec 04             	sub    $0x4,%esp
  802b99:	68 d0 49 80 00       	push   $0x8049d0
  802b9e:	68 a6 00 00 00       	push   $0xa6
  802ba3:	68 b7 49 80 00       	push   $0x8049b7
  802ba8:	e8 c2 de ff ff       	call   800a6f <_panic>
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 50 04             	mov    0x4(%eax),%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	89 50 04             	mov    %edx,0x4(%eax)
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbf:	89 10                	mov    %edx,(%eax)
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 40 04             	mov    0x4(%eax),%eax
  802bc7:	85 c0                	test   %eax,%eax
  802bc9:	74 0d                	je     802bd8 <insert_sorted_in_freeList+0xd7>
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 40 04             	mov    0x4(%eax),%eax
  802bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd4:	89 10                	mov    %edx,(%eax)
  802bd6:	eb 08                	jmp    802be0 <insert_sorted_in_freeList+0xdf>
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	a3 84 50 98 00       	mov    %eax,0x985084
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	8b 55 08             	mov    0x8(%ebp),%edx
  802be6:	89 50 04             	mov    %edx,0x4(%eax)
  802be9:	a1 90 50 98 00       	mov    0x985090,%eax
  802bee:	40                   	inc    %eax
  802bef:	a3 90 50 98 00       	mov    %eax,0x985090
			return;
  802bf4:	e9 99 00 00 00       	jmp    802c92 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802bf9:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c05:	74 07                	je     802c0e <insert_sorted_in_freeList+0x10d>
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	eb 05                	jmp    802c13 <insert_sorted_in_freeList+0x112>
  802c0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802c13:	a3 8c 50 98 00       	mov    %eax,0x98508c
  802c18:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802c1d:	85 c0                	test   %eax,%eax
  802c1f:	0f 85 5d ff ff ff    	jne    802b82 <insert_sorted_in_freeList+0x81>
  802c25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c29:	0f 85 53 ff ff ff    	jne    802b82 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802c2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c33:	75 17                	jne    802c4c <insert_sorted_in_freeList+0x14b>
  802c35:	83 ec 04             	sub    $0x4,%esp
  802c38:	68 08 4a 80 00       	push   $0x804a08
  802c3d:	68 ab 00 00 00       	push   $0xab
  802c42:	68 b7 49 80 00       	push   $0x8049b7
  802c47:	e8 23 de ff ff       	call   800a6f <_panic>
  802c4c:	8b 15 88 50 98 00    	mov    0x985088,%edx
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5b:	8b 40 04             	mov    0x4(%eax),%eax
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	74 0c                	je     802c6e <insert_sorted_in_freeList+0x16d>
  802c62:	a1 88 50 98 00       	mov    0x985088,%eax
  802c67:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	eb 08                	jmp    802c76 <insert_sorted_in_freeList+0x175>
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 84 50 98 00       	mov    %eax,0x985084
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	a3 88 50 98 00       	mov    %eax,0x985088
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c87:	a1 90 50 98 00       	mov    0x985090,%eax
  802c8c:	40                   	inc    %eax
  802c8d:	a3 90 50 98 00       	mov    %eax,0x985090
}
  802c92:	c9                   	leave  
  802c93:	c3                   	ret    

00802c94 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  802c94:	55                   	push   %ebp
  802c95:	89 e5                	mov    %esp,%ebp
  802c97:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	83 e0 01             	and    $0x1,%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 03                	je     802ca7 <alloc_block_FF+0x13>
  802ca4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802ca7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802cab:	77 07                	ja     802cb4 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802cad:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802cb4:	a1 60 50 98 00       	mov    0x985060,%eax
  802cb9:	85 c0                	test   %eax,%eax
  802cbb:	75 63                	jne    802d20 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	83 c0 10             	add    $0x10,%eax
  802cc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802cc6:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802ccd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd3:	01 d0                	add    %edx,%eax
  802cd5:	48                   	dec    %eax
  802cd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdc:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce1:	f7 75 ec             	divl   -0x14(%ebp)
  802ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce7:	29 d0                	sub    %edx,%eax
  802ce9:	c1 e8 0c             	shr    $0xc,%eax
  802cec:	83 ec 0c             	sub    $0xc,%esp
  802cef:	50                   	push   %eax
  802cf0:	e8 d1 ed ff ff       	call   801ac6 <sbrk>
  802cf5:	83 c4 10             	add    $0x10,%esp
  802cf8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802cfb:	83 ec 0c             	sub    $0xc,%esp
  802cfe:	6a 00                	push   $0x0
  802d00:	e8 c1 ed ff ff       	call   801ac6 <sbrk>
  802d05:	83 c4 10             	add    $0x10,%esp
  802d08:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802d11:	83 ec 08             	sub    $0x8,%esp
  802d14:	50                   	push   %eax
  802d15:	ff 75 e4             	pushl  -0x1c(%ebp)
  802d18:	e8 75 fc ff ff       	call   802992 <initialize_dynamic_allocator>
  802d1d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802d20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d24:	75 0a                	jne    802d30 <alloc_block_FF+0x9c>
	{
		return NULL;
  802d26:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2b:	e9 99 03 00 00       	jmp    8030c9 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	83 c0 08             	add    $0x8,%eax
  802d36:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802d39:	a1 84 50 98 00       	mov    0x985084,%eax
  802d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d41:	e9 03 02 00 00       	jmp    802f49 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802d46:	83 ec 0c             	sub    $0xc,%esp
  802d49:	ff 75 f4             	pushl  -0xc(%ebp)
  802d4c:	e8 dd fa ff ff       	call   80282e <get_block_size>
  802d51:	83 c4 10             	add    $0x10,%esp
  802d54:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802d57:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802d5a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802d5d:	0f 82 de 01 00 00    	jb     802f41 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802d63:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d66:	83 c0 10             	add    $0x10,%eax
  802d69:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802d6c:	0f 87 32 01 00 00    	ja     802ea4 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802d72:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802d75:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802d78:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802d81:	01 d0                	add    %edx,%eax
  802d83:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802d86:	83 ec 04             	sub    $0x4,%esp
  802d89:	6a 00                	push   $0x0
  802d8b:	ff 75 98             	pushl  -0x68(%ebp)
  802d8e:	ff 75 94             	pushl  -0x6c(%ebp)
  802d91:	e8 14 fd ff ff       	call   802aaa <set_block_data>
  802d96:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802d99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9d:	74 06                	je     802da5 <alloc_block_FF+0x111>
  802d9f:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802da3:	75 17                	jne    802dbc <alloc_block_FF+0x128>
  802da5:	83 ec 04             	sub    $0x4,%esp
  802da8:	68 2c 4a 80 00       	push   $0x804a2c
  802dad:	68 de 00 00 00       	push   $0xde
  802db2:	68 b7 49 80 00       	push   $0x8049b7
  802db7:	e8 b3 dc ff ff       	call   800a6f <_panic>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 10                	mov    (%eax),%edx
  802dc1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802dc4:	89 10                	mov    %edx,(%eax)
  802dc6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802dc9:	8b 00                	mov    (%eax),%eax
  802dcb:	85 c0                	test   %eax,%eax
  802dcd:	74 0b                	je     802dda <alloc_block_FF+0x146>
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 00                	mov    (%eax),%eax
  802dd4:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802de0:	89 10                	mov    %edx,(%eax)
  802de2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802de5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de8:	89 50 04             	mov    %edx,0x4(%eax)
  802deb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	75 08                	jne    802dfc <alloc_block_FF+0x168>
  802df4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802df7:	a3 88 50 98 00       	mov    %eax,0x985088
  802dfc:	a1 90 50 98 00       	mov    0x985090,%eax
  802e01:	40                   	inc    %eax
  802e02:	a3 90 50 98 00       	mov    %eax,0x985090

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802e07:	83 ec 04             	sub    $0x4,%esp
  802e0a:	6a 01                	push   $0x1
  802e0c:	ff 75 dc             	pushl  -0x24(%ebp)
  802e0f:	ff 75 f4             	pushl  -0xc(%ebp)
  802e12:	e8 93 fc ff ff       	call   802aaa <set_block_data>
  802e17:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802e1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1e:	75 17                	jne    802e37 <alloc_block_FF+0x1a3>
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	68 60 4a 80 00       	push   $0x804a60
  802e28:	68 e3 00 00 00       	push   $0xe3
  802e2d:	68 b7 49 80 00       	push   $0x8049b7
  802e32:	e8 38 dc ff ff       	call   800a6f <_panic>
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	74 10                	je     802e50 <alloc_block_FF+0x1bc>
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e48:	8b 52 04             	mov    0x4(%edx),%edx
  802e4b:	89 50 04             	mov    %edx,0x4(%eax)
  802e4e:	eb 0b                	jmp    802e5b <alloc_block_FF+0x1c7>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	a3 88 50 98 00       	mov    %eax,0x985088
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 40 04             	mov    0x4(%eax),%eax
  802e61:	85 c0                	test   %eax,%eax
  802e63:	74 0f                	je     802e74 <alloc_block_FF+0x1e0>
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6e:	8b 12                	mov    (%edx),%edx
  802e70:	89 10                	mov    %edx,(%eax)
  802e72:	eb 0a                	jmp    802e7e <alloc_block_FF+0x1ea>
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	a3 84 50 98 00       	mov    %eax,0x985084
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e91:	a1 90 50 98 00       	mov    0x985090,%eax
  802e96:	48                   	dec    %eax
  802e97:	a3 90 50 98 00       	mov    %eax,0x985090
				return (void*)((uint32*)block);
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	e9 25 02 00 00       	jmp    8030c9 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802ea4:	83 ec 04             	sub    $0x4,%esp
  802ea7:	6a 01                	push   $0x1
  802ea9:	ff 75 9c             	pushl  -0x64(%ebp)
  802eac:	ff 75 f4             	pushl  -0xc(%ebp)
  802eaf:	e8 f6 fb ff ff       	call   802aaa <set_block_data>
  802eb4:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebb:	75 17                	jne    802ed4 <alloc_block_FF+0x240>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 60 4a 80 00       	push   $0x804a60
  802ec5:	68 eb 00 00 00       	push   $0xeb
  802eca:	68 b7 49 80 00       	push   $0x8049b7
  802ecf:	e8 9b db ff ff       	call   800a6f <_panic>
  802ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed7:	8b 00                	mov    (%eax),%eax
  802ed9:	85 c0                	test   %eax,%eax
  802edb:	74 10                	je     802eed <alloc_block_FF+0x259>
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee5:	8b 52 04             	mov    0x4(%edx),%edx
  802ee8:	89 50 04             	mov    %edx,0x4(%eax)
  802eeb:	eb 0b                	jmp    802ef8 <alloc_block_FF+0x264>
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 40 04             	mov    0x4(%eax),%eax
  802ef3:	a3 88 50 98 00       	mov    %eax,0x985088
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 40 04             	mov    0x4(%eax),%eax
  802efe:	85 c0                	test   %eax,%eax
  802f00:	74 0f                	je     802f11 <alloc_block_FF+0x27d>
  802f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f05:	8b 40 04             	mov    0x4(%eax),%eax
  802f08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0b:	8b 12                	mov    (%edx),%edx
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	eb 0a                	jmp    802f1b <alloc_block_FF+0x287>
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	a3 84 50 98 00       	mov    %eax,0x985084
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2e:	a1 90 50 98 00       	mov    0x985090,%eax
  802f33:	48                   	dec    %eax
  802f34:	a3 90 50 98 00       	mov    %eax,0x985090
				return (void*)((uint32*)block);
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	e9 88 01 00 00       	jmp    8030c9 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802f41:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4d:	74 07                	je     802f56 <alloc_block_FF+0x2c2>
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	eb 05                	jmp    802f5b <alloc_block_FF+0x2c7>
  802f56:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5b:	a3 8c 50 98 00       	mov    %eax,0x98508c
  802f60:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	0f 85 d9 fd ff ff    	jne    802d46 <alloc_block_FF+0xb2>
  802f6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f71:	0f 85 cf fd ff ff    	jne    802d46 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802f77:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802f7e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802f81:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f84:	01 d0                	add    %edx,%eax
  802f86:	48                   	dec    %eax
  802f87:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802f8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f8d:	ba 00 00 00 00       	mov    $0x0,%edx
  802f92:	f7 75 d8             	divl   -0x28(%ebp)
  802f95:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802f98:	29 d0                	sub    %edx,%eax
  802f9a:	c1 e8 0c             	shr    $0xc,%eax
  802f9d:	83 ec 0c             	sub    $0xc,%esp
  802fa0:	50                   	push   %eax
  802fa1:	e8 20 eb ff ff       	call   801ac6 <sbrk>
  802fa6:	83 c4 10             	add    $0x10,%esp
  802fa9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802fac:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802fb0:	75 0a                	jne    802fbc <alloc_block_FF+0x328>
		return NULL;
  802fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb7:	e9 0d 01 00 00       	jmp    8030c9 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802fbc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802fbf:	83 e8 04             	sub    $0x4,%eax
  802fc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802fc5:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802fcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802fcf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802fd2:	01 d0                	add    %edx,%eax
  802fd4:	48                   	dec    %eax
  802fd5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802fd8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fdb:	ba 00 00 00 00       	mov    $0x0,%edx
  802fe0:	f7 75 c8             	divl   -0x38(%ebp)
  802fe3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802fe6:	29 d0                	sub    %edx,%eax
  802fe8:	c1 e8 02             	shr    $0x2,%eax
  802feb:	c1 e0 02             	shl    $0x2,%eax
  802fee:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802ff1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ff4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802ffa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802ffd:	83 e8 08             	sub    $0x8,%eax
  803000:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  803003:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	83 e0 fe             	and    $0xfffffffe,%eax
  80300b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  80300e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803011:	f7 d8                	neg    %eax
  803013:	89 c2                	mov    %eax,%edx
  803015:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803018:	01 d0                	add    %edx,%eax
  80301a:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  80301d:	83 ec 0c             	sub    $0xc,%esp
  803020:	ff 75 b8             	pushl  -0x48(%ebp)
  803023:	e8 1f f8 ff ff       	call   802847 <is_free_block>
  803028:	83 c4 10             	add    $0x10,%esp
  80302b:	0f be c0             	movsbl %al,%eax
  80302e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803031:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  803035:	74 42                	je     803079 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  803037:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80303e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803041:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803044:	01 d0                	add    %edx,%eax
  803046:	48                   	dec    %eax
  803047:	89 45 ac             	mov    %eax,-0x54(%ebp)
  80304a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80304d:	ba 00 00 00 00       	mov    $0x0,%edx
  803052:	f7 75 b0             	divl   -0x50(%ebp)
  803055:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803058:	29 d0                	sub    %edx,%eax
  80305a:	89 c2                	mov    %eax,%edx
  80305c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80305f:	01 d0                	add    %edx,%eax
  803061:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803064:	83 ec 04             	sub    $0x4,%esp
  803067:	6a 00                	push   $0x0
  803069:	ff 75 a8             	pushl  -0x58(%ebp)
  80306c:	ff 75 b8             	pushl  -0x48(%ebp)
  80306f:	e8 36 fa ff ff       	call   802aaa <set_block_data>
  803074:	83 c4 10             	add    $0x10,%esp
  803077:	eb 42                	jmp    8030bb <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803079:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  803080:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803083:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803086:	01 d0                	add    %edx,%eax
  803088:	48                   	dec    %eax
  803089:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80308c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80308f:	ba 00 00 00 00       	mov    $0x0,%edx
  803094:	f7 75 a4             	divl   -0x5c(%ebp)
  803097:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80309a:	29 d0                	sub    %edx,%eax
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	6a 00                	push   $0x0
  8030a1:	50                   	push   %eax
  8030a2:	ff 75 d0             	pushl  -0x30(%ebp)
  8030a5:	e8 00 fa ff ff       	call   802aaa <set_block_data>
  8030aa:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8030ad:	83 ec 0c             	sub    $0xc,%esp
  8030b0:	ff 75 d0             	pushl  -0x30(%ebp)
  8030b3:	e8 49 fa ff ff       	call   802b01 <insert_sorted_in_freeList>
  8030b8:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8030bb:	83 ec 0c             	sub    $0xc,%esp
  8030be:	ff 75 08             	pushl  0x8(%ebp)
  8030c1:	e8 ce fb ff ff       	call   802c94 <alloc_block_FF>
  8030c6:	83 c4 10             	add    $0x10,%esp
}
  8030c9:	c9                   	leave  
  8030ca:	c3                   	ret    

008030cb <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8030cb:	55                   	push   %ebp
  8030cc:	89 e5                	mov    %esp,%ebp
  8030ce:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8030d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d5:	75 0a                	jne    8030e1 <alloc_block_BF+0x16>
	{
		return NULL;
  8030d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030dc:	e9 7a 02 00 00       	jmp    80335b <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8030e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e4:	83 c0 08             	add    $0x8,%eax
  8030e7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8030ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8030f1:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8030f8:	a1 84 50 98 00       	mov    0x985084,%eax
  8030fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803100:	eb 32                	jmp    803134 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803102:	ff 75 ec             	pushl  -0x14(%ebp)
  803105:	e8 24 f7 ff ff       	call   80282e <get_block_size>
  80310a:	83 c4 04             	add    $0x4,%esp
  80310d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803110:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803113:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803116:	72 14                	jb     80312c <alloc_block_BF+0x61>
  803118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80311b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80311e:	73 0c                	jae    80312c <alloc_block_BF+0x61>
		{
			minBlk = block;
  803120:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803123:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803129:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80312c:	a1 8c 50 98 00       	mov    0x98508c,%eax
  803131:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803134:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803138:	74 07                	je     803141 <alloc_block_BF+0x76>
  80313a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313d:	8b 00                	mov    (%eax),%eax
  80313f:	eb 05                	jmp    803146 <alloc_block_BF+0x7b>
  803141:	b8 00 00 00 00       	mov    $0x0,%eax
  803146:	a3 8c 50 98 00       	mov    %eax,0x98508c
  80314b:	a1 8c 50 98 00       	mov    0x98508c,%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	75 ae                	jne    803102 <alloc_block_BF+0x37>
  803154:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803158:	75 a8                	jne    803102 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  80315a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315e:	75 22                	jne    803182 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803160:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803163:	83 ec 0c             	sub    $0xc,%esp
  803166:	50                   	push   %eax
  803167:	e8 5a e9 ff ff       	call   801ac6 <sbrk>
  80316c:	83 c4 10             	add    $0x10,%esp
  80316f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803172:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803176:	75 0a                	jne    803182 <alloc_block_BF+0xb7>
			return NULL;
  803178:	b8 00 00 00 00       	mov    $0x0,%eax
  80317d:	e9 d9 01 00 00       	jmp    80335b <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803182:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803185:	83 c0 10             	add    $0x10,%eax
  803188:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80318b:	0f 87 32 01 00 00    	ja     8032c3 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  803191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803194:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803197:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  80319a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031a0:	01 d0                	add    %edx,%eax
  8031a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	6a 00                	push   $0x0
  8031aa:	ff 75 dc             	pushl  -0x24(%ebp)
  8031ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8031b0:	e8 f5 f8 ff ff       	call   802aaa <set_block_data>
  8031b5:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8031b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031bc:	74 06                	je     8031c4 <alloc_block_BF+0xf9>
  8031be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8031c2:	75 17                	jne    8031db <alloc_block_BF+0x110>
  8031c4:	83 ec 04             	sub    $0x4,%esp
  8031c7:	68 2c 4a 80 00       	push   $0x804a2c
  8031cc:	68 49 01 00 00       	push   $0x149
  8031d1:	68 b7 49 80 00       	push   $0x8049b7
  8031d6:	e8 94 d8 ff ff       	call   800a6f <_panic>
  8031db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031de:	8b 10                	mov    (%eax),%edx
  8031e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031e3:	89 10                	mov    %edx,(%eax)
  8031e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8031e8:	8b 00                	mov    (%eax),%eax
  8031ea:	85 c0                	test   %eax,%eax
  8031ec:	74 0b                	je     8031f9 <alloc_block_BF+0x12e>
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031f6:	89 50 04             	mov    %edx,0x4(%eax)
  8031f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031ff:	89 10                	mov    %edx,(%eax)
  803201:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803204:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803207:	89 50 04             	mov    %edx,0x4(%eax)
  80320a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80320d:	8b 00                	mov    (%eax),%eax
  80320f:	85 c0                	test   %eax,%eax
  803211:	75 08                	jne    80321b <alloc_block_BF+0x150>
  803213:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803216:	a3 88 50 98 00       	mov    %eax,0x985088
  80321b:	a1 90 50 98 00       	mov    0x985090,%eax
  803220:	40                   	inc    %eax
  803221:	a3 90 50 98 00       	mov    %eax,0x985090

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803226:	83 ec 04             	sub    $0x4,%esp
  803229:	6a 01                	push   $0x1
  80322b:	ff 75 e8             	pushl  -0x18(%ebp)
  80322e:	ff 75 f4             	pushl  -0xc(%ebp)
  803231:	e8 74 f8 ff ff       	call   802aaa <set_block_data>
  803236:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803239:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80323d:	75 17                	jne    803256 <alloc_block_BF+0x18b>
  80323f:	83 ec 04             	sub    $0x4,%esp
  803242:	68 60 4a 80 00       	push   $0x804a60
  803247:	68 4e 01 00 00       	push   $0x14e
  80324c:	68 b7 49 80 00       	push   $0x8049b7
  803251:	e8 19 d8 ff ff       	call   800a6f <_panic>
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 00                	mov    (%eax),%eax
  80325b:	85 c0                	test   %eax,%eax
  80325d:	74 10                	je     80326f <alloc_block_BF+0x1a4>
  80325f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803262:	8b 00                	mov    (%eax),%eax
  803264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803267:	8b 52 04             	mov    0x4(%edx),%edx
  80326a:	89 50 04             	mov    %edx,0x4(%eax)
  80326d:	eb 0b                	jmp    80327a <alloc_block_BF+0x1af>
  80326f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803272:	8b 40 04             	mov    0x4(%eax),%eax
  803275:	a3 88 50 98 00       	mov    %eax,0x985088
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 0f                	je     803293 <alloc_block_BF+0x1c8>
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 40 04             	mov    0x4(%eax),%eax
  80328a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80328d:	8b 12                	mov    (%edx),%edx
  80328f:	89 10                	mov    %edx,(%eax)
  803291:	eb 0a                	jmp    80329d <alloc_block_BF+0x1d2>
  803293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803296:	8b 00                	mov    (%eax),%eax
  803298:	a3 84 50 98 00       	mov    %eax,0x985084
  80329d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032b0:	a1 90 50 98 00       	mov    0x985090,%eax
  8032b5:	48                   	dec    %eax
  8032b6:	a3 90 50 98 00       	mov    %eax,0x985090
		return (void*)((uint32*)minBlk);
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	e9 98 00 00 00       	jmp    80335b <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8032c3:	83 ec 04             	sub    $0x4,%esp
  8032c6:	6a 01                	push   $0x1
  8032c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8032cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8032ce:	e8 d7 f7 ff ff       	call   802aaa <set_block_data>
  8032d3:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8032d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032da:	75 17                	jne    8032f3 <alloc_block_BF+0x228>
  8032dc:	83 ec 04             	sub    $0x4,%esp
  8032df:	68 60 4a 80 00       	push   $0x804a60
  8032e4:	68 56 01 00 00       	push   $0x156
  8032e9:	68 b7 49 80 00       	push   $0x8049b7
  8032ee:	e8 7c d7 ff ff       	call   800a6f <_panic>
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	74 10                	je     80330c <alloc_block_BF+0x241>
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 00                	mov    (%eax),%eax
  803301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803304:	8b 52 04             	mov    0x4(%edx),%edx
  803307:	89 50 04             	mov    %edx,0x4(%eax)
  80330a:	eb 0b                	jmp    803317 <alloc_block_BF+0x24c>
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 04             	mov    0x4(%eax),%eax
  803312:	a3 88 50 98 00       	mov    %eax,0x985088
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	8b 40 04             	mov    0x4(%eax),%eax
  80331d:	85 c0                	test   %eax,%eax
  80331f:	74 0f                	je     803330 <alloc_block_BF+0x265>
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 40 04             	mov    0x4(%eax),%eax
  803327:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80332a:	8b 12                	mov    (%edx),%edx
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	eb 0a                	jmp    80333a <alloc_block_BF+0x26f>
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	8b 00                	mov    (%eax),%eax
  803335:	a3 84 50 98 00       	mov    %eax,0x985084
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334d:	a1 90 50 98 00       	mov    0x985090,%eax
  803352:	48                   	dec    %eax
  803353:	a3 90 50 98 00       	mov    %eax,0x985090
		return (void*)((uint32*)minBlk);
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  80335b:	c9                   	leave  
  80335c:	c3                   	ret    

0080335d <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  80335d:	55                   	push   %ebp
  80335e:	89 e5                	mov    %esp,%ebp
  803360:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803363:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803367:	0f 84 6a 02 00 00    	je     8035d7 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  80336d:	ff 75 08             	pushl  0x8(%ebp)
  803370:	e8 b9 f4 ff ff       	call   80282e <get_block_size>
  803375:	83 c4 04             	add    $0x4,%esp
  803378:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	83 e8 08             	sub    $0x8,%eax
  803381:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	83 e0 fe             	and    $0xfffffffe,%eax
  80338c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  80338f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803392:	f7 d8                	neg    %eax
  803394:	89 c2                	mov    %eax,%edx
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	01 d0                	add    %edx,%eax
  80339b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  80339e:	ff 75 e8             	pushl  -0x18(%ebp)
  8033a1:	e8 a1 f4 ff ff       	call   802847 <is_free_block>
  8033a6:	83 c4 04             	add    $0x4,%esp
  8033a9:	0f be c0             	movsbl %al,%eax
  8033ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8033af:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b5:	01 d0                	add    %edx,%eax
  8033b7:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8033ba:	ff 75 e0             	pushl  -0x20(%ebp)
  8033bd:	e8 85 f4 ff ff       	call   802847 <is_free_block>
  8033c2:	83 c4 04             	add    $0x4,%esp
  8033c5:	0f be c0             	movsbl %al,%eax
  8033c8:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8033cb:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8033cf:	75 34                	jne    803405 <free_block+0xa8>
  8033d1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8033d5:	75 2e                	jne    803405 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8033d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8033da:	e8 4f f4 ff ff       	call   80282e <get_block_size>
  8033df:	83 c4 04             	add    $0x4,%esp
  8033e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  8033e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033eb:	01 d0                	add    %edx,%eax
  8033ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  8033f0:	6a 00                	push   $0x0
  8033f2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8033f8:	e8 ad f6 ff ff       	call   802aaa <set_block_data>
  8033fd:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803400:	e9 d3 01 00 00       	jmp    8035d8 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803405:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803409:	0f 85 c8 00 00 00    	jne    8034d7 <free_block+0x17a>
  80340f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803413:	0f 85 be 00 00 00    	jne    8034d7 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803419:	ff 75 e0             	pushl  -0x20(%ebp)
  80341c:	e8 0d f4 ff ff       	call   80282e <get_block_size>
  803421:	83 c4 04             	add    $0x4,%esp
  803424:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80342d:	01 d0                	add    %edx,%eax
  80342f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803432:	6a 00                	push   $0x0
  803434:	ff 75 cc             	pushl  -0x34(%ebp)
  803437:	ff 75 08             	pushl  0x8(%ebp)
  80343a:	e8 6b f6 ff ff       	call   802aaa <set_block_data>
  80343f:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803442:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803446:	75 17                	jne    80345f <free_block+0x102>
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	68 60 4a 80 00       	push   $0x804a60
  803450:	68 87 01 00 00       	push   $0x187
  803455:	68 b7 49 80 00       	push   $0x8049b7
  80345a:	e8 10 d6 ff ff       	call   800a6f <_panic>
  80345f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 10                	je     803478 <free_block+0x11b>
  803468:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803470:	8b 52 04             	mov    0x4(%edx),%edx
  803473:	89 50 04             	mov    %edx,0x4(%eax)
  803476:	eb 0b                	jmp    803483 <free_block+0x126>
  803478:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80347b:	8b 40 04             	mov    0x4(%eax),%eax
  80347e:	a3 88 50 98 00       	mov    %eax,0x985088
  803483:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803486:	8b 40 04             	mov    0x4(%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 0f                	je     80349c <free_block+0x13f>
  80348d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803496:	8b 12                	mov    (%edx),%edx
  803498:	89 10                	mov    %edx,(%eax)
  80349a:	eb 0a                	jmp    8034a6 <free_block+0x149>
  80349c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	a3 84 50 98 00       	mov    %eax,0x985084
  8034a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b9:	a1 90 50 98 00       	mov    0x985090,%eax
  8034be:	48                   	dec    %eax
  8034bf:	a3 90 50 98 00       	mov    %eax,0x985090
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8034c4:	83 ec 0c             	sub    $0xc,%esp
  8034c7:	ff 75 08             	pushl  0x8(%ebp)
  8034ca:	e8 32 f6 ff ff       	call   802b01 <insert_sorted_in_freeList>
  8034cf:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  8034d2:	e9 01 01 00 00       	jmp    8035d8 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  8034d7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8034db:	0f 85 d3 00 00 00    	jne    8035b4 <free_block+0x257>
  8034e1:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8034e5:	0f 85 c9 00 00 00    	jne    8035b4 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  8034eb:	83 ec 0c             	sub    $0xc,%esp
  8034ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8034f1:	e8 38 f3 ff ff       	call   80282e <get_block_size>
  8034f6:	83 c4 10             	add    $0x10,%esp
  8034f9:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  8034fc:	83 ec 0c             	sub    $0xc,%esp
  8034ff:	ff 75 e0             	pushl  -0x20(%ebp)
  803502:	e8 27 f3 ff ff       	call   80282e <get_block_size>
  803507:	83 c4 10             	add    $0x10,%esp
  80350a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  80350d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803510:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803513:	01 c2                	add    %eax,%edx
  803515:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803518:	01 d0                	add    %edx,%eax
  80351a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  80351d:	83 ec 04             	sub    $0x4,%esp
  803520:	6a 00                	push   $0x0
  803522:	ff 75 c0             	pushl  -0x40(%ebp)
  803525:	ff 75 e8             	pushl  -0x18(%ebp)
  803528:	e8 7d f5 ff ff       	call   802aaa <set_block_data>
  80352d:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803530:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803534:	75 17                	jne    80354d <free_block+0x1f0>
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	68 60 4a 80 00       	push   $0x804a60
  80353e:	68 94 01 00 00       	push   $0x194
  803543:	68 b7 49 80 00       	push   $0x8049b7
  803548:	e8 22 d5 ff ff       	call   800a6f <_panic>
  80354d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	85 c0                	test   %eax,%eax
  803554:	74 10                	je     803566 <free_block+0x209>
  803556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803559:	8b 00                	mov    (%eax),%eax
  80355b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80355e:	8b 52 04             	mov    0x4(%edx),%edx
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	eb 0b                	jmp    803571 <free_block+0x214>
  803566:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803569:	8b 40 04             	mov    0x4(%eax),%eax
  80356c:	a3 88 50 98 00       	mov    %eax,0x985088
  803571:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803574:	8b 40 04             	mov    0x4(%eax),%eax
  803577:	85 c0                	test   %eax,%eax
  803579:	74 0f                	je     80358a <free_block+0x22d>
  80357b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80357e:	8b 40 04             	mov    0x4(%eax),%eax
  803581:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803584:	8b 12                	mov    (%edx),%edx
  803586:	89 10                	mov    %edx,(%eax)
  803588:	eb 0a                	jmp    803594 <free_block+0x237>
  80358a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	a3 84 50 98 00       	mov    %eax,0x985084
  803594:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803597:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8035a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a7:	a1 90 50 98 00       	mov    0x985090,%eax
  8035ac:	48                   	dec    %eax
  8035ad:	a3 90 50 98 00       	mov    %eax,0x985090
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  8035b2:	eb 24                	jmp    8035d8 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  8035b4:	83 ec 04             	sub    $0x4,%esp
  8035b7:	6a 00                	push   $0x0
  8035b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8035bc:	ff 75 08             	pushl  0x8(%ebp)
  8035bf:	e8 e6 f4 ff ff       	call   802aaa <set_block_data>
  8035c4:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  8035c7:	83 ec 0c             	sub    $0xc,%esp
  8035ca:	ff 75 08             	pushl  0x8(%ebp)
  8035cd:	e8 2f f5 ff ff       	call   802b01 <insert_sorted_in_freeList>
  8035d2:	83 c4 10             	add    $0x10,%esp
  8035d5:	eb 01                	jmp    8035d8 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  8035d7:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  8035d8:	c9                   	leave  
  8035d9:	c3                   	ret    

008035da <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  8035da:	55                   	push   %ebp
  8035db:	89 e5                	mov    %esp,%ebp
  8035dd:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  8035e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e4:	75 10                	jne    8035f6 <realloc_block_FF+0x1c>
  8035e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035ea:	75 0a                	jne    8035f6 <realloc_block_FF+0x1c>
	{
		return NULL;
  8035ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f1:	e9 8b 04 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  8035f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8035fa:	75 18                	jne    803614 <realloc_block_FF+0x3a>
	{
		free_block(va);
  8035fc:	83 ec 0c             	sub    $0xc,%esp
  8035ff:	ff 75 08             	pushl  0x8(%ebp)
  803602:	e8 56 fd ff ff       	call   80335d <free_block>
  803607:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80360a:	b8 00 00 00 00       	mov    $0x0,%eax
  80360f:	e9 6d 04 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803614:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803618:	75 13                	jne    80362d <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  80361a:	83 ec 0c             	sub    $0xc,%esp
  80361d:	ff 75 0c             	pushl  0xc(%ebp)
  803620:	e8 6f f6 ff ff       	call   802c94 <alloc_block_FF>
  803625:	83 c4 10             	add    $0x10,%esp
  803628:	e9 54 04 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  80362d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803630:	83 e0 01             	and    $0x1,%eax
  803633:	85 c0                	test   %eax,%eax
  803635:	74 03                	je     80363a <realloc_block_FF+0x60>
	{
		new_size++;
  803637:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  80363a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80363e:	77 07                	ja     803647 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803640:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803647:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80364b:	83 ec 0c             	sub    $0xc,%esp
  80364e:	ff 75 08             	pushl  0x8(%ebp)
  803651:	e8 d8 f1 ff ff       	call   80282e <get_block_size>
  803656:	83 c4 10             	add    $0x10,%esp
  803659:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  80365c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803662:	75 08                	jne    80366c <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803664:	8b 45 08             	mov    0x8(%ebp),%eax
  803667:	e9 15 04 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  80366c:	8b 55 08             	mov    0x8(%ebp),%edx
  80366f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803672:	01 d0                	add    %edx,%eax
  803674:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803677:	83 ec 0c             	sub    $0xc,%esp
  80367a:	ff 75 f0             	pushl  -0x10(%ebp)
  80367d:	e8 c5 f1 ff ff       	call   802847 <is_free_block>
  803682:	83 c4 10             	add    $0x10,%esp
  803685:	0f be c0             	movsbl %al,%eax
  803688:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  80368b:	83 ec 0c             	sub    $0xc,%esp
  80368e:	ff 75 f0             	pushl  -0x10(%ebp)
  803691:	e8 98 f1 ff ff       	call   80282e <get_block_size>
  803696:	83 c4 10             	add    $0x10,%esp
  803699:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  80369c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80369f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036a2:	0f 86 a7 02 00 00    	jbe    80394f <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8036a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036ac:	0f 84 86 02 00 00    	je     803938 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8036b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	01 d0                	add    %edx,%eax
  8036ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8036bd:	0f 85 b2 00 00 00    	jne    803775 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8036c3:	83 ec 0c             	sub    $0xc,%esp
  8036c6:	ff 75 08             	pushl  0x8(%ebp)
  8036c9:	e8 79 f1 ff ff       	call   802847 <is_free_block>
  8036ce:	83 c4 10             	add    $0x10,%esp
  8036d1:	84 c0                	test   %al,%al
  8036d3:	0f 94 c0             	sete   %al
  8036d6:	0f b6 c0             	movzbl %al,%eax
  8036d9:	83 ec 04             	sub    $0x4,%esp
  8036dc:	50                   	push   %eax
  8036dd:	ff 75 0c             	pushl  0xc(%ebp)
  8036e0:	ff 75 08             	pushl  0x8(%ebp)
  8036e3:	e8 c2 f3 ff ff       	call   802aaa <set_block_data>
  8036e8:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8036eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8036ef:	75 17                	jne    803708 <realloc_block_FF+0x12e>
  8036f1:	83 ec 04             	sub    $0x4,%esp
  8036f4:	68 60 4a 80 00       	push   $0x804a60
  8036f9:	68 db 01 00 00       	push   $0x1db
  8036fe:	68 b7 49 80 00       	push   $0x8049b7
  803703:	e8 67 d3 ff ff       	call   800a6f <_panic>
  803708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80370b:	8b 00                	mov    (%eax),%eax
  80370d:	85 c0                	test   %eax,%eax
  80370f:	74 10                	je     803721 <realloc_block_FF+0x147>
  803711:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803714:	8b 00                	mov    (%eax),%eax
  803716:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803719:	8b 52 04             	mov    0x4(%edx),%edx
  80371c:	89 50 04             	mov    %edx,0x4(%eax)
  80371f:	eb 0b                	jmp    80372c <realloc_block_FF+0x152>
  803721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803724:	8b 40 04             	mov    0x4(%eax),%eax
  803727:	a3 88 50 98 00       	mov    %eax,0x985088
  80372c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80372f:	8b 40 04             	mov    0x4(%eax),%eax
  803732:	85 c0                	test   %eax,%eax
  803734:	74 0f                	je     803745 <realloc_block_FF+0x16b>
  803736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803739:	8b 40 04             	mov    0x4(%eax),%eax
  80373c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80373f:	8b 12                	mov    (%edx),%edx
  803741:	89 10                	mov    %edx,(%eax)
  803743:	eb 0a                	jmp    80374f <realloc_block_FF+0x175>
  803745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803748:	8b 00                	mov    (%eax),%eax
  80374a:	a3 84 50 98 00       	mov    %eax,0x985084
  80374f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803752:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803758:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80375b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803762:	a1 90 50 98 00       	mov    0x985090,%eax
  803767:	48                   	dec    %eax
  803768:	a3 90 50 98 00       	mov    %eax,0x985090
				return va;
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	e9 0c 03 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803775:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377b:	01 d0                	add    %edx,%eax
  80377d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803780:	0f 86 b2 01 00 00    	jbe    803938 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803786:	8b 45 0c             	mov    0xc(%ebp),%eax
  803789:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80378c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  80378f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803792:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803795:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803798:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  80379c:	0f 87 b8 00 00 00    	ja     80385a <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8037a2:	83 ec 0c             	sub    $0xc,%esp
  8037a5:	ff 75 08             	pushl  0x8(%ebp)
  8037a8:	e8 9a f0 ff ff       	call   802847 <is_free_block>
  8037ad:	83 c4 10             	add    $0x10,%esp
  8037b0:	84 c0                	test   %al,%al
  8037b2:	0f 94 c0             	sete   %al
  8037b5:	0f b6 c0             	movzbl %al,%eax
  8037b8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8037bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037be:	01 ca                	add    %ecx,%edx
  8037c0:	83 ec 04             	sub    $0x4,%esp
  8037c3:	50                   	push   %eax
  8037c4:	52                   	push   %edx
  8037c5:	ff 75 08             	pushl  0x8(%ebp)
  8037c8:	e8 dd f2 ff ff       	call   802aaa <set_block_data>
  8037cd:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8037d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8037d4:	75 17                	jne    8037ed <realloc_block_FF+0x213>
  8037d6:	83 ec 04             	sub    $0x4,%esp
  8037d9:	68 60 4a 80 00       	push   $0x804a60
  8037de:	68 e8 01 00 00       	push   $0x1e8
  8037e3:	68 b7 49 80 00       	push   $0x8049b7
  8037e8:	e8 82 d2 ff ff       	call   800a6f <_panic>
  8037ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f0:	8b 00                	mov    (%eax),%eax
  8037f2:	85 c0                	test   %eax,%eax
  8037f4:	74 10                	je     803806 <realloc_block_FF+0x22c>
  8037f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037f9:	8b 00                	mov    (%eax),%eax
  8037fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8037fe:	8b 52 04             	mov    0x4(%edx),%edx
  803801:	89 50 04             	mov    %edx,0x4(%eax)
  803804:	eb 0b                	jmp    803811 <realloc_block_FF+0x237>
  803806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803809:	8b 40 04             	mov    0x4(%eax),%eax
  80380c:	a3 88 50 98 00       	mov    %eax,0x985088
  803811:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803814:	8b 40 04             	mov    0x4(%eax),%eax
  803817:	85 c0                	test   %eax,%eax
  803819:	74 0f                	je     80382a <realloc_block_FF+0x250>
  80381b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80381e:	8b 40 04             	mov    0x4(%eax),%eax
  803821:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803824:	8b 12                	mov    (%edx),%edx
  803826:	89 10                	mov    %edx,(%eax)
  803828:	eb 0a                	jmp    803834 <realloc_block_FF+0x25a>
  80382a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	a3 84 50 98 00       	mov    %eax,0x985084
  803834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80383d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803840:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803847:	a1 90 50 98 00       	mov    0x985090,%eax
  80384c:	48                   	dec    %eax
  80384d:	a3 90 50 98 00       	mov    %eax,0x985090
					return va;
  803852:	8b 45 08             	mov    0x8(%ebp),%eax
  803855:	e9 27 02 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80385a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80385e:	75 17                	jne    803877 <realloc_block_FF+0x29d>
  803860:	83 ec 04             	sub    $0x4,%esp
  803863:	68 60 4a 80 00       	push   $0x804a60
  803868:	68 ed 01 00 00       	push   $0x1ed
  80386d:	68 b7 49 80 00       	push   $0x8049b7
  803872:	e8 f8 d1 ff ff       	call   800a6f <_panic>
  803877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80387a:	8b 00                	mov    (%eax),%eax
  80387c:	85 c0                	test   %eax,%eax
  80387e:	74 10                	je     803890 <realloc_block_FF+0x2b6>
  803880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803883:	8b 00                	mov    (%eax),%eax
  803885:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803888:	8b 52 04             	mov    0x4(%edx),%edx
  80388b:	89 50 04             	mov    %edx,0x4(%eax)
  80388e:	eb 0b                	jmp    80389b <realloc_block_FF+0x2c1>
  803890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803893:	8b 40 04             	mov    0x4(%eax),%eax
  803896:	a3 88 50 98 00       	mov    %eax,0x985088
  80389b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80389e:	8b 40 04             	mov    0x4(%eax),%eax
  8038a1:	85 c0                	test   %eax,%eax
  8038a3:	74 0f                	je     8038b4 <realloc_block_FF+0x2da>
  8038a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038a8:	8b 40 04             	mov    0x4(%eax),%eax
  8038ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8038ae:	8b 12                	mov    (%edx),%edx
  8038b0:	89 10                	mov    %edx,(%eax)
  8038b2:	eb 0a                	jmp    8038be <realloc_block_FF+0x2e4>
  8038b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038b7:	8b 00                	mov    (%eax),%eax
  8038b9:	a3 84 50 98 00       	mov    %eax,0x985084
  8038be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8038ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d1:	a1 90 50 98 00       	mov    0x985090,%eax
  8038d6:	48                   	dec    %eax
  8038d7:	a3 90 50 98 00       	mov    %eax,0x985090
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8038dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8038df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038e2:	01 d0                	add    %edx,%eax
  8038e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8038e7:	83 ec 04             	sub    $0x4,%esp
  8038ea:	6a 00                	push   $0x0
  8038ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8038ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8038f2:	e8 b3 f1 ff ff       	call   802aaa <set_block_data>
  8038f7:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8038fa:	83 ec 0c             	sub    $0xc,%esp
  8038fd:	ff 75 08             	pushl  0x8(%ebp)
  803900:	e8 42 ef ff ff       	call   802847 <is_free_block>
  803905:	83 c4 10             	add    $0x10,%esp
  803908:	84 c0                	test   %al,%al
  80390a:	0f 94 c0             	sete   %al
  80390d:	0f b6 c0             	movzbl %al,%eax
  803910:	83 ec 04             	sub    $0x4,%esp
  803913:	50                   	push   %eax
  803914:	ff 75 0c             	pushl  0xc(%ebp)
  803917:	ff 75 08             	pushl  0x8(%ebp)
  80391a:	e8 8b f1 ff ff       	call   802aaa <set_block_data>
  80391f:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803922:	83 ec 0c             	sub    $0xc,%esp
  803925:	ff 75 f0             	pushl  -0x10(%ebp)
  803928:	e8 d4 f1 ff ff       	call   802b01 <insert_sorted_in_freeList>
  80392d:	83 c4 10             	add    $0x10,%esp
					return va;
  803930:	8b 45 08             	mov    0x8(%ebp),%eax
  803933:	e9 49 01 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803938:	8b 45 0c             	mov    0xc(%ebp),%eax
  80393b:	83 e8 08             	sub    $0x8,%eax
  80393e:	83 ec 0c             	sub    $0xc,%esp
  803941:	50                   	push   %eax
  803942:	e8 4d f3 ff ff       	call   802c94 <alloc_block_FF>
  803947:	83 c4 10             	add    $0x10,%esp
  80394a:	e9 32 01 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80394f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803952:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803955:	0f 83 21 01 00 00    	jae    803a7c <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  80395b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395e:	2b 45 0c             	sub    0xc(%ebp),%eax
  803961:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803964:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803968:	77 0e                	ja     803978 <realloc_block_FF+0x39e>
  80396a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80396e:	75 08                	jne    803978 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803970:	8b 45 08             	mov    0x8(%ebp),%eax
  803973:	e9 09 01 00 00       	jmp    803a81 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803978:	8b 45 08             	mov    0x8(%ebp),%eax
  80397b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80397e:	83 ec 0c             	sub    $0xc,%esp
  803981:	ff 75 08             	pushl  0x8(%ebp)
  803984:	e8 be ee ff ff       	call   802847 <is_free_block>
  803989:	83 c4 10             	add    $0x10,%esp
  80398c:	84 c0                	test   %al,%al
  80398e:	0f 94 c0             	sete   %al
  803991:	0f b6 c0             	movzbl %al,%eax
  803994:	83 ec 04             	sub    $0x4,%esp
  803997:	50                   	push   %eax
  803998:	ff 75 0c             	pushl  0xc(%ebp)
  80399b:	ff 75 d8             	pushl  -0x28(%ebp)
  80399e:	e8 07 f1 ff ff       	call   802aaa <set_block_data>
  8039a3:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8039a6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039ac:	01 d0                	add    %edx,%eax
  8039ae:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8039b1:	83 ec 04             	sub    $0x4,%esp
  8039b4:	6a 00                	push   $0x0
  8039b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8039b9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039bc:	e8 e9 f0 ff ff       	call   802aaa <set_block_data>
  8039c1:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8039c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8039c8:	0f 84 9b 00 00 00    	je     803a69 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8039ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8039d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039d4:	01 d0                	add    %edx,%eax
  8039d6:	83 ec 04             	sub    $0x4,%esp
  8039d9:	6a 00                	push   $0x0
  8039db:	50                   	push   %eax
  8039dc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8039df:	e8 c6 f0 ff ff       	call   802aaa <set_block_data>
  8039e4:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8039e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8039eb:	75 17                	jne    803a04 <realloc_block_FF+0x42a>
  8039ed:	83 ec 04             	sub    $0x4,%esp
  8039f0:	68 60 4a 80 00       	push   $0x804a60
  8039f5:	68 10 02 00 00       	push   $0x210
  8039fa:	68 b7 49 80 00       	push   $0x8049b7
  8039ff:	e8 6b d0 ff ff       	call   800a6f <_panic>
  803a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a07:	8b 00                	mov    (%eax),%eax
  803a09:	85 c0                	test   %eax,%eax
  803a0b:	74 10                	je     803a1d <realloc_block_FF+0x443>
  803a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a10:	8b 00                	mov    (%eax),%eax
  803a12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a15:	8b 52 04             	mov    0x4(%edx),%edx
  803a18:	89 50 04             	mov    %edx,0x4(%eax)
  803a1b:	eb 0b                	jmp    803a28 <realloc_block_FF+0x44e>
  803a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a20:	8b 40 04             	mov    0x4(%eax),%eax
  803a23:	a3 88 50 98 00       	mov    %eax,0x985088
  803a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a2b:	8b 40 04             	mov    0x4(%eax),%eax
  803a2e:	85 c0                	test   %eax,%eax
  803a30:	74 0f                	je     803a41 <realloc_block_FF+0x467>
  803a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a35:	8b 40 04             	mov    0x4(%eax),%eax
  803a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a3b:	8b 12                	mov    (%edx),%edx
  803a3d:	89 10                	mov    %edx,(%eax)
  803a3f:	eb 0a                	jmp    803a4b <realloc_block_FF+0x471>
  803a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a44:	8b 00                	mov    (%eax),%eax
  803a46:	a3 84 50 98 00       	mov    %eax,0x985084
  803a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a5e:	a1 90 50 98 00       	mov    0x985090,%eax
  803a63:	48                   	dec    %eax
  803a64:	a3 90 50 98 00       	mov    %eax,0x985090
			}
			insert_sorted_in_freeList(remainingBlk);
  803a69:	83 ec 0c             	sub    $0xc,%esp
  803a6c:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a6f:	e8 8d f0 ff ff       	call   802b01 <insert_sorted_in_freeList>
  803a74:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803a77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a7a:	eb 05                	jmp    803a81 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803a7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803a81:	c9                   	leave  
  803a82:	c3                   	ret    

00803a83 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  803a83:	55                   	push   %ebp
  803a84:	89 e5                	mov    %esp,%ebp
  803a86:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803a89:	83 ec 04             	sub    $0x4,%esp
  803a8c:	68 80 4a 80 00       	push   $0x804a80
  803a91:	68 20 02 00 00       	push   $0x220
  803a96:	68 b7 49 80 00       	push   $0x8049b7
  803a9b:	e8 cf cf ff ff       	call   800a6f <_panic>

00803aa0 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803aa0:	55                   	push   %ebp
  803aa1:	89 e5                	mov    %esp,%ebp
  803aa3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803aa6:	83 ec 04             	sub    $0x4,%esp
  803aa9:	68 a8 4a 80 00       	push   $0x804aa8
  803aae:	68 28 02 00 00       	push   $0x228
  803ab3:	68 b7 49 80 00       	push   $0x8049b7
  803ab8:	e8 b2 cf ff ff       	call   800a6f <_panic>
  803abd:	66 90                	xchg   %ax,%ax
  803abf:	90                   	nop

00803ac0 <__udivdi3>:
  803ac0:	55                   	push   %ebp
  803ac1:	57                   	push   %edi
  803ac2:	56                   	push   %esi
  803ac3:	53                   	push   %ebx
  803ac4:	83 ec 1c             	sub    $0x1c,%esp
  803ac7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803acb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803acf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803ad3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803ad7:	89 ca                	mov    %ecx,%edx
  803ad9:	89 f8                	mov    %edi,%eax
  803adb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803adf:	85 f6                	test   %esi,%esi
  803ae1:	75 2d                	jne    803b10 <__udivdi3+0x50>
  803ae3:	39 cf                	cmp    %ecx,%edi
  803ae5:	77 65                	ja     803b4c <__udivdi3+0x8c>
  803ae7:	89 fd                	mov    %edi,%ebp
  803ae9:	85 ff                	test   %edi,%edi
  803aeb:	75 0b                	jne    803af8 <__udivdi3+0x38>
  803aed:	b8 01 00 00 00       	mov    $0x1,%eax
  803af2:	31 d2                	xor    %edx,%edx
  803af4:	f7 f7                	div    %edi
  803af6:	89 c5                	mov    %eax,%ebp
  803af8:	31 d2                	xor    %edx,%edx
  803afa:	89 c8                	mov    %ecx,%eax
  803afc:	f7 f5                	div    %ebp
  803afe:	89 c1                	mov    %eax,%ecx
  803b00:	89 d8                	mov    %ebx,%eax
  803b02:	f7 f5                	div    %ebp
  803b04:	89 cf                	mov    %ecx,%edi
  803b06:	89 fa                	mov    %edi,%edx
  803b08:	83 c4 1c             	add    $0x1c,%esp
  803b0b:	5b                   	pop    %ebx
  803b0c:	5e                   	pop    %esi
  803b0d:	5f                   	pop    %edi
  803b0e:	5d                   	pop    %ebp
  803b0f:	c3                   	ret    
  803b10:	39 ce                	cmp    %ecx,%esi
  803b12:	77 28                	ja     803b3c <__udivdi3+0x7c>
  803b14:	0f bd fe             	bsr    %esi,%edi
  803b17:	83 f7 1f             	xor    $0x1f,%edi
  803b1a:	75 40                	jne    803b5c <__udivdi3+0x9c>
  803b1c:	39 ce                	cmp    %ecx,%esi
  803b1e:	72 0a                	jb     803b2a <__udivdi3+0x6a>
  803b20:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b24:	0f 87 9e 00 00 00    	ja     803bc8 <__udivdi3+0x108>
  803b2a:	b8 01 00 00 00       	mov    $0x1,%eax
  803b2f:	89 fa                	mov    %edi,%edx
  803b31:	83 c4 1c             	add    $0x1c,%esp
  803b34:	5b                   	pop    %ebx
  803b35:	5e                   	pop    %esi
  803b36:	5f                   	pop    %edi
  803b37:	5d                   	pop    %ebp
  803b38:	c3                   	ret    
  803b39:	8d 76 00             	lea    0x0(%esi),%esi
  803b3c:	31 ff                	xor    %edi,%edi
  803b3e:	31 c0                	xor    %eax,%eax
  803b40:	89 fa                	mov    %edi,%edx
  803b42:	83 c4 1c             	add    $0x1c,%esp
  803b45:	5b                   	pop    %ebx
  803b46:	5e                   	pop    %esi
  803b47:	5f                   	pop    %edi
  803b48:	5d                   	pop    %ebp
  803b49:	c3                   	ret    
  803b4a:	66 90                	xchg   %ax,%ax
  803b4c:	89 d8                	mov    %ebx,%eax
  803b4e:	f7 f7                	div    %edi
  803b50:	31 ff                	xor    %edi,%edi
  803b52:	89 fa                	mov    %edi,%edx
  803b54:	83 c4 1c             	add    $0x1c,%esp
  803b57:	5b                   	pop    %ebx
  803b58:	5e                   	pop    %esi
  803b59:	5f                   	pop    %edi
  803b5a:	5d                   	pop    %ebp
  803b5b:	c3                   	ret    
  803b5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b61:	89 eb                	mov    %ebp,%ebx
  803b63:	29 fb                	sub    %edi,%ebx
  803b65:	89 f9                	mov    %edi,%ecx
  803b67:	d3 e6                	shl    %cl,%esi
  803b69:	89 c5                	mov    %eax,%ebp
  803b6b:	88 d9                	mov    %bl,%cl
  803b6d:	d3 ed                	shr    %cl,%ebp
  803b6f:	89 e9                	mov    %ebp,%ecx
  803b71:	09 f1                	or     %esi,%ecx
  803b73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b77:	89 f9                	mov    %edi,%ecx
  803b79:	d3 e0                	shl    %cl,%eax
  803b7b:	89 c5                	mov    %eax,%ebp
  803b7d:	89 d6                	mov    %edx,%esi
  803b7f:	88 d9                	mov    %bl,%cl
  803b81:	d3 ee                	shr    %cl,%esi
  803b83:	89 f9                	mov    %edi,%ecx
  803b85:	d3 e2                	shl    %cl,%edx
  803b87:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b8b:	88 d9                	mov    %bl,%cl
  803b8d:	d3 e8                	shr    %cl,%eax
  803b8f:	09 c2                	or     %eax,%edx
  803b91:	89 d0                	mov    %edx,%eax
  803b93:	89 f2                	mov    %esi,%edx
  803b95:	f7 74 24 0c          	divl   0xc(%esp)
  803b99:	89 d6                	mov    %edx,%esi
  803b9b:	89 c3                	mov    %eax,%ebx
  803b9d:	f7 e5                	mul    %ebp
  803b9f:	39 d6                	cmp    %edx,%esi
  803ba1:	72 19                	jb     803bbc <__udivdi3+0xfc>
  803ba3:	74 0b                	je     803bb0 <__udivdi3+0xf0>
  803ba5:	89 d8                	mov    %ebx,%eax
  803ba7:	31 ff                	xor    %edi,%edi
  803ba9:	e9 58 ff ff ff       	jmp    803b06 <__udivdi3+0x46>
  803bae:	66 90                	xchg   %ax,%ax
  803bb0:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bb4:	89 f9                	mov    %edi,%ecx
  803bb6:	d3 e2                	shl    %cl,%edx
  803bb8:	39 c2                	cmp    %eax,%edx
  803bba:	73 e9                	jae    803ba5 <__udivdi3+0xe5>
  803bbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bbf:	31 ff                	xor    %edi,%edi
  803bc1:	e9 40 ff ff ff       	jmp    803b06 <__udivdi3+0x46>
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	31 c0                	xor    %eax,%eax
  803bca:	e9 37 ff ff ff       	jmp    803b06 <__udivdi3+0x46>
  803bcf:	90                   	nop

00803bd0 <__umoddi3>:
  803bd0:	55                   	push   %ebp
  803bd1:	57                   	push   %edi
  803bd2:	56                   	push   %esi
  803bd3:	53                   	push   %ebx
  803bd4:	83 ec 1c             	sub    $0x1c,%esp
  803bd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bdb:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bdf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803be3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803be7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803beb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803bef:	89 f3                	mov    %esi,%ebx
  803bf1:	89 fa                	mov    %edi,%edx
  803bf3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803bf7:	89 34 24             	mov    %esi,(%esp)
  803bfa:	85 c0                	test   %eax,%eax
  803bfc:	75 1a                	jne    803c18 <__umoddi3+0x48>
  803bfe:	39 f7                	cmp    %esi,%edi
  803c00:	0f 86 a2 00 00 00    	jbe    803ca8 <__umoddi3+0xd8>
  803c06:	89 c8                	mov    %ecx,%eax
  803c08:	89 f2                	mov    %esi,%edx
  803c0a:	f7 f7                	div    %edi
  803c0c:	89 d0                	mov    %edx,%eax
  803c0e:	31 d2                	xor    %edx,%edx
  803c10:	83 c4 1c             	add    $0x1c,%esp
  803c13:	5b                   	pop    %ebx
  803c14:	5e                   	pop    %esi
  803c15:	5f                   	pop    %edi
  803c16:	5d                   	pop    %ebp
  803c17:	c3                   	ret    
  803c18:	39 f0                	cmp    %esi,%eax
  803c1a:	0f 87 ac 00 00 00    	ja     803ccc <__umoddi3+0xfc>
  803c20:	0f bd e8             	bsr    %eax,%ebp
  803c23:	83 f5 1f             	xor    $0x1f,%ebp
  803c26:	0f 84 ac 00 00 00    	je     803cd8 <__umoddi3+0x108>
  803c2c:	bf 20 00 00 00       	mov    $0x20,%edi
  803c31:	29 ef                	sub    %ebp,%edi
  803c33:	89 fe                	mov    %edi,%esi
  803c35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c39:	89 e9                	mov    %ebp,%ecx
  803c3b:	d3 e0                	shl    %cl,%eax
  803c3d:	89 d7                	mov    %edx,%edi
  803c3f:	89 f1                	mov    %esi,%ecx
  803c41:	d3 ef                	shr    %cl,%edi
  803c43:	09 c7                	or     %eax,%edi
  803c45:	89 e9                	mov    %ebp,%ecx
  803c47:	d3 e2                	shl    %cl,%edx
  803c49:	89 14 24             	mov    %edx,(%esp)
  803c4c:	89 d8                	mov    %ebx,%eax
  803c4e:	d3 e0                	shl    %cl,%eax
  803c50:	89 c2                	mov    %eax,%edx
  803c52:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c56:	d3 e0                	shl    %cl,%eax
  803c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c60:	89 f1                	mov    %esi,%ecx
  803c62:	d3 e8                	shr    %cl,%eax
  803c64:	09 d0                	or     %edx,%eax
  803c66:	d3 eb                	shr    %cl,%ebx
  803c68:	89 da                	mov    %ebx,%edx
  803c6a:	f7 f7                	div    %edi
  803c6c:	89 d3                	mov    %edx,%ebx
  803c6e:	f7 24 24             	mull   (%esp)
  803c71:	89 c6                	mov    %eax,%esi
  803c73:	89 d1                	mov    %edx,%ecx
  803c75:	39 d3                	cmp    %edx,%ebx
  803c77:	0f 82 87 00 00 00    	jb     803d04 <__umoddi3+0x134>
  803c7d:	0f 84 91 00 00 00    	je     803d14 <__umoddi3+0x144>
  803c83:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c87:	29 f2                	sub    %esi,%edx
  803c89:	19 cb                	sbb    %ecx,%ebx
  803c8b:	89 d8                	mov    %ebx,%eax
  803c8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803c91:	d3 e0                	shl    %cl,%eax
  803c93:	89 e9                	mov    %ebp,%ecx
  803c95:	d3 ea                	shr    %cl,%edx
  803c97:	09 d0                	or     %edx,%eax
  803c99:	89 e9                	mov    %ebp,%ecx
  803c9b:	d3 eb                	shr    %cl,%ebx
  803c9d:	89 da                	mov    %ebx,%edx
  803c9f:	83 c4 1c             	add    $0x1c,%esp
  803ca2:	5b                   	pop    %ebx
  803ca3:	5e                   	pop    %esi
  803ca4:	5f                   	pop    %edi
  803ca5:	5d                   	pop    %ebp
  803ca6:	c3                   	ret    
  803ca7:	90                   	nop
  803ca8:	89 fd                	mov    %edi,%ebp
  803caa:	85 ff                	test   %edi,%edi
  803cac:	75 0b                	jne    803cb9 <__umoddi3+0xe9>
  803cae:	b8 01 00 00 00       	mov    $0x1,%eax
  803cb3:	31 d2                	xor    %edx,%edx
  803cb5:	f7 f7                	div    %edi
  803cb7:	89 c5                	mov    %eax,%ebp
  803cb9:	89 f0                	mov    %esi,%eax
  803cbb:	31 d2                	xor    %edx,%edx
  803cbd:	f7 f5                	div    %ebp
  803cbf:	89 c8                	mov    %ecx,%eax
  803cc1:	f7 f5                	div    %ebp
  803cc3:	89 d0                	mov    %edx,%eax
  803cc5:	e9 44 ff ff ff       	jmp    803c0e <__umoddi3+0x3e>
  803cca:	66 90                	xchg   %ax,%ax
  803ccc:	89 c8                	mov    %ecx,%eax
  803cce:	89 f2                	mov    %esi,%edx
  803cd0:	83 c4 1c             	add    $0x1c,%esp
  803cd3:	5b                   	pop    %ebx
  803cd4:	5e                   	pop    %esi
  803cd5:	5f                   	pop    %edi
  803cd6:	5d                   	pop    %ebp
  803cd7:	c3                   	ret    
  803cd8:	3b 04 24             	cmp    (%esp),%eax
  803cdb:	72 06                	jb     803ce3 <__umoddi3+0x113>
  803cdd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ce1:	77 0f                	ja     803cf2 <__umoddi3+0x122>
  803ce3:	89 f2                	mov    %esi,%edx
  803ce5:	29 f9                	sub    %edi,%ecx
  803ce7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ceb:	89 14 24             	mov    %edx,(%esp)
  803cee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803cf2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803cf6:	8b 14 24             	mov    (%esp),%edx
  803cf9:	83 c4 1c             	add    $0x1c,%esp
  803cfc:	5b                   	pop    %ebx
  803cfd:	5e                   	pop    %esi
  803cfe:	5f                   	pop    %edi
  803cff:	5d                   	pop    %ebp
  803d00:	c3                   	ret    
  803d01:	8d 76 00             	lea    0x0(%esi),%esi
  803d04:	2b 04 24             	sub    (%esp),%eax
  803d07:	19 fa                	sbb    %edi,%edx
  803d09:	89 d1                	mov    %edx,%ecx
  803d0b:	89 c6                	mov    %eax,%esi
  803d0d:	e9 71 ff ff ff       	jmp    803c83 <__umoddi3+0xb3>
  803d12:	66 90                	xchg   %ax,%ax
  803d14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d18:	72 ea                	jb     803d04 <__umoddi3+0x134>
  803d1a:	89 d9                	mov    %ebx,%ecx
  803d1c:	e9 62 ff ff ff       	jmp    803c83 <__umoddi3+0xb3>
