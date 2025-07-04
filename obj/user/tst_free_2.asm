
obj/user/tst_free_2:     file format elf32-i386


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
  800031:	e8 1c 0f 00 00       	call   800f52 <libmain>
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
  800055:	68 60 43 80 00       	push   $0x804360
  80005a:	e8 f5 12 00 00       	call   801354 <cprintf>
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
  8000a5:	68 90 43 80 00       	push   $0x804390
  8000aa:	e8 a5 12 00 00       	call   801354 <cprintf>
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
  8000c6:	81 ec dc 00 00 00    	sub    $0xdc,%esp
	 * WE COMPARE THE DIFF IN FREE FRAMES BY "AT LEAST" RULE
	 * INSTEAD OF "EQUAL" RULE SINCE IT'S POSSIBLE THAT SOME
	 * PAGES ARE ALLOCATED IN KERNEL DYNAMIC ALLOCATOR sbrk()
	 * (e.g. DURING THE DYNAMIC CREATION OF WS ELEMENT in FH).
	 *********************************************************/
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	6a 01                	push   $0x1
  8000d1:	e8 01 2c 00 00       	call   802cd7 <sys_set_uheap_strategy>
  8000d6:	83 c4 10             	add    $0x10,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000d9:	a1 40 60 80 00       	mov    0x806040,%eax
  8000de:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  8000e4:	a1 40 60 80 00       	mov    0x806040,%eax
  8000e9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000ef:	39 c2                	cmp    %eax,%edx
  8000f1:	72 14                	jb     800107 <_main+0x47>
			panic("Please increase the WS size");
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	68 c9 43 80 00       	push   $0x8043c9
  8000fb:	6a 25                	push   $0x25
  8000fd:	68 e5 43 80 00       	push   $0x8043e5
  800102:	e8 90 0f 00 00       	call   801097 <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	/*=================================================*/

	int eval = 0;
  800107:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	bool is_correct = 1;
  80010e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800115:	c7 45 b8 00 00 30 00 	movl   $0x300000,-0x48(%ebp)

	void * va ;
	int idx = 0;
  80011c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800123:	e8 fc 27 00 00       	call   802924 <sys_pf_calculate_allocated_pages>
  800128:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80012b:	e8 a9 27 00 00       	call   8028d9 <sys_calculate_free_frames>
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
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
  80013d:	68 f8 43 80 00       	push   $0x8043f8
  800142:	e8 0d 12 00 00       	call   801354 <cprintf>
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
  800173:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  80017a:	83 e8 08             	sub    $0x8,%eax
  80017d:	89 45 ac             	mov    %eax,-0x54(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800180:	83 ec 0c             	sub    $0xc,%esp
  800183:	ff 75 ac             	pushl  -0x54(%ebp)
  800186:	e8 79 1f 00 00       	call   802104 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 c2                	mov    %eax,%edx
  800190:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800193:	89 14 85 a0 60 98 00 	mov    %edx,0x9860a0(,%eax,4)
  80019a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80019d:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  8001a4:	89 45 a8             	mov    %eax,-0x58(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  8001a7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001aa:	d1 e8                	shr    %eax
  8001ac:	89 c2                	mov    %eax,%edx
  8001ae:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001b1:	01 c2                	add    %eax,%edx
  8001b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b6:	89 14 85 a0 8c 98 00 	mov    %edx,0x988ca0(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001c0:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001c3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001c6:	01 c2                	add    %eax,%edx
  8001c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cb:	89 14 85 a0 76 98 00 	mov    %edx,0x9876a0(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001d5:	83 c0 04             	add    $0x4,%eax
  8001d8:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				expectedSize = allocSizes[i];
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  8001e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
				curTotalSize += allocSizes[i] ;
  8001e8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001eb:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
  8001f2:	01 45 d4             	add    %eax,-0x2c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001f5:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  8001fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8001ff:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	48                   	dec    %eax
  800205:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800208:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80020b:	ba 00 00 00 00       	mov    $0x0,%edx
  800210:	f7 75 a0             	divl   -0x60(%ebp)
  800213:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800216:	29 d0                	sub    %edx,%eax
  800218:	89 45 98             	mov    %eax,-0x68(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80021b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80021e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800221:	89 45 94             	mov    %eax,-0x6c(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800224:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  800228:	7e 48                	jle    800272 <_main+0x1b2>
  80022a:	83 7d 94 0f          	cmpl   $0xf,-0x6c(%ebp)
  80022e:	7f 42                	jg     800272 <_main+0x1b2>
				{
//					cprintf("%~\n FRAGMENTATION: curVA = %x diff = %d\n", curVA, diff);
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800230:	c7 45 90 00 10 00 00 	movl   $0x1000,-0x70(%ebp)
  800237:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80023a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80023d:	01 d0                	add    %edx,%eax
  80023f:	48                   	dec    %eax
  800240:	89 45 8c             	mov    %eax,-0x74(%ebp)
  800243:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800246:	ba 00 00 00 00       	mov    $0x0,%edx
  80024b:	f7 75 90             	divl   -0x70(%ebp)
  80024e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800251:	29 d0                	sub    %edx,%eax
  800253:	83 e8 04             	sub    $0x4,%eax
  800256:	89 45 d0             	mov    %eax,-0x30(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  800259:	8b 45 98             	mov    -0x68(%ebp),%eax
  80025c:	83 e8 04             	sub    $0x4,%eax
  80025f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  800262:	8b 55 94             	mov    -0x6c(%ebp),%edx
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
  800275:	8b 04 85 00 60 80 00 	mov    0x806000(,%eax,4),%eax
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
  80028a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80028d:	ff 75 a8             	pushl  -0x58(%ebp)
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
  8002ac:	68 50 44 80 00       	push   $0x804450
  8002b1:	6a 68                	push   $0x68
  8002b3:	68 e5 43 80 00       	push   $0x8043e5
  8002b8:	e8 da 0d 00 00       	call   801097 <_panic>
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
  8002dd:	c7 45 88 00 10 00 00 	movl   $0x1000,-0x78(%ebp)
  8002e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8002e7:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	48                   	dec    %eax
  8002ed:	89 45 84             	mov    %eax,-0x7c(%ebp)
  8002f0:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f8:	f7 75 88             	divl   -0x78(%ebp)
  8002fb:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8002fe:	29 d0                	sub    %edx,%eax
  800300:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 remainSize = (roundedTotalSize - curTotalSize) - sizeof(int) /*END block*/;
  800303:	8b 45 98             	mov    -0x68(%ebp),%eax
  800306:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  800309:	83 e8 04             	sub    $0x4,%eax
  80030c:	89 45 80             	mov    %eax,-0x80(%ebp)
	if (remainSize >= (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  80030f:	83 7d 80 0f          	cmpl   $0xf,-0x80(%ebp)
  800313:	76 7b                	jbe    800390 <_main+0x2d0>
	{
		cprintf("Filling the remaining size of %d\n\n", remainSize);
  800315:	83 ec 08             	sub    $0x8,%esp
  800318:	ff 75 80             	pushl  -0x80(%ebp)
  80031b:	68 78 44 80 00       	push   $0x804478
  800320:	e8 2f 10 00 00       	call   801354 <cprintf>
  800325:	83 c4 10             	add    $0x10,%esp
		va = startVAs[idx] = alloc_block(remainSize - sizeOfMetaData, DA_FF);
  800328:	8b 45 80             	mov    -0x80(%ebp),%eax
  80032b:	83 e8 08             	sub    $0x8,%eax
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	6a 01                	push   $0x1
  800333:	50                   	push   %eax
  800334:	e8 54 2b 00 00       	call   802e8d <alloc_block>
  800339:	83 c4 10             	add    $0x10,%esp
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800341:	89 14 85 a0 60 98 00 	mov    %edx,0x9860a0(,%eax,4)
  800348:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80034b:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  800352:	89 45 a8             	mov    %eax,-0x58(%ebp)
		//Check returned va
		expectedVA = curVA + sizeOfMetaData/2;
  800355:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800358:	83 c0 04             	add    $0x4,%eax
  80035b:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (check_block(va, expectedVA, remainSize, 1) == 0)
  80035e:	6a 01                	push   $0x1
  800360:	ff 75 80             	pushl  -0x80(%ebp)
  800363:	ff 75 a4             	pushl  -0x5c(%ebp)
  800366:	ff 75 a8             	pushl  -0x58(%ebp)
  800369:	e8 ca fc ff ff       	call   800038 <check_block>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	85 c0                	test   %eax,%eax
  800373:	75 1b                	jne    800390 <_main+0x2d0>
		{
			is_correct = 0;
  800375:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			panic("alloc_block_xx #PRQ.oo: WRONG ALLOC\n", idx);
  80037c:	ff 75 dc             	pushl  -0x24(%ebp)
  80037f:	68 9c 44 80 00       	push   $0x80449c
  800384:	6a 7f                	push   $0x7f
  800386:	68 e5 43 80 00       	push   $0x8043e5
  80038b:	e8 07 0d 00 00       	call   801097 <_panic>
		}
	}

	freeFrames = sys_calculate_free_frames() ;
  800390:	e8 44 25 00 00       	call   8028d9 <sys_calculate_free_frames>
  800395:	89 45 b0             	mov    %eax,-0x50(%ebp)

	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
  800398:	83 ec 0c             	sub    $0xc,%esp
  80039b:	68 c4 44 80 00       	push   $0x8044c4
  8003a0:	e8 af 0f 00 00       	call   801354 <cprintf>
  8003a5:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a8:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  8003af:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  8003b6:	e9 98 00 00 00       	jmp    800453 <_main+0x393>
		{
			free(startVAs[i*allocCntPerSize]);
  8003bb:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003be:	89 d0                	mov    %edx,%eax
  8003c0:	c1 e0 02             	shl    $0x2,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	c1 e0 03             	shl    $0x3,%eax
  8003d1:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  8003d8:	83 ec 0c             	sub    $0xc,%esp
  8003db:	50                   	push   %eax
  8003dc:	e8 d9 1e 00 00       	call   8022ba <free>
  8003e1:	83 c4 10             	add    $0x10,%esp
			if (check_block(startVAs[i*allocCntPerSize], startVAs[i*allocCntPerSize], allocSizes[i], 0) == 0)
  8003e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003e7:	8b 0c 85 00 60 80 00 	mov    0x806000(,%eax,4),%ecx
  8003ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8003f1:	89 d0                	mov    %edx,%eax
  8003f3:	c1 e0 02             	shl    $0x2,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ff:	01 d0                	add    %edx,%eax
  800401:	c1 e0 03             	shl    $0x3,%eax
  800404:	8b 14 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%edx
  80040b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80040e:	89 d8                	mov    %ebx,%eax
  800410:	c1 e0 02             	shl    $0x2,%eax
  800413:	01 d8                	add    %ebx,%eax
  800415:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
  80041c:	01 d8                	add    %ebx,%eax
  80041e:	c1 e0 03             	shl    $0x3,%eax
  800421:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  800428:	6a 00                	push   $0x0
  80042a:	51                   	push   %ecx
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	e8 06 fc ff ff       	call   800038 <check_block>
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	85 c0                	test   %eax,%eax
  800437:	75 17                	jne    800450 <_main+0x390>
			{
				is_correct = 0;
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #1.1: WRONG FREE!\n");
  800440:	83 ec 0c             	sub    $0xc,%esp
  800443:	68 0c 45 80 00       	push   $0x80450c
  800448:	e8 07 0f 00 00       	call   801354 <cprintf>
  80044d:	83 c4 10             	add    $0x10,%esp
	//====================================================================//
	/*Free set of blocks with different sizes (first block of each size)*/
	cprintf("1: Free set of blocks with different sizes (first block of each size)\n\n") ;
	{
		is_correct = 1;
		for (int i = 0; i < numOfAllocs; ++i)
  800450:	ff 45 c4             	incl   -0x3c(%ebp)
  800453:	83 7d c4 06          	cmpl   $0x6,-0x3c(%ebp)
  800457:	0f 8e 5e ff ff ff    	jle    8003bb <_main+0x2fb>
				cprintf("test_free_2 #1.1: WRONG FREE!\n");
			}
		}

		//Free block before last
		free(startVAs[numOfAllocs*allocCntPerSize - 1]);
  80045d:	a1 7c 76 98 00       	mov    0x98767c,%eax
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	50                   	push   %eax
  800466:	e8 4f 1e 00 00       	call   8022ba <free>
  80046b:	83 c4 10             	add    $0x10,%esp

		if (check_block(startVAs[numOfAllocs*allocCntPerSize - 1], startVAs[numOfAllocs*allocCntPerSize - 1], allocSizes[numOfAllocs-1], 0) == 0)
  80046e:	8b 0d 18 60 80 00    	mov    0x806018,%ecx
  800474:	8b 15 7c 76 98 00    	mov    0x98767c,%edx
  80047a:	a1 7c 76 98 00       	mov    0x98767c,%eax
  80047f:	6a 00                	push   $0x0
  800481:	51                   	push   %ecx
  800482:	52                   	push   %edx
  800483:	50                   	push   %eax
  800484:	e8 af fb ff ff       	call   800038 <check_block>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	85 c0                	test   %eax,%eax
  80048e:	75 17                	jne    8004a7 <_main+0x3e7>
		{
			is_correct = 0;
  800490:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #1.2: WRONG FREE!\n");
  800497:	83 ec 0c             	sub    $0xc,%esp
  80049a:	68 2c 45 80 00       	push   $0x80452c
  80049f:	e8 b0 0e 00 00       	call   801354 <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
		}

		//Reallocate first block
		actualSize = allocSizes[0] - sizeOfMetaData;
  8004a7:	a1 00 60 80 00       	mov    0x806000,%eax
  8004ac:	83 e8 08             	sub    $0x8,%eax
  8004af:	89 45 ac             	mov    %eax,-0x54(%ebp)
		va = malloc(actualSize);
  8004b2:	83 ec 0c             	sub    $0xc,%esp
  8004b5:	ff 75 ac             	pushl  -0x54(%ebp)
  8004b8:	e8 47 1c 00 00       	call   802104 <malloc>
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	89 45 a8             	mov    %eax,-0x58(%ebp)
		//Check returned va
		expectedVA = (void*)(USER_HEAP_START + sizeof(int) + sizeOfMetaData/2);
  8004c3:	c7 45 a4 08 00 00 80 	movl   $0x80000008,-0x5c(%ebp)
		if (check_block(va, expectedVA, allocSizes[0], 1) == 0)
  8004ca:	a1 00 60 80 00       	mov    0x806000,%eax
  8004cf:	6a 01                	push   $0x1
  8004d1:	50                   	push   %eax
  8004d2:	ff 75 a4             	pushl  -0x5c(%ebp)
  8004d5:	ff 75 a8             	pushl  -0x58(%ebp)
  8004d8:	e8 5b fb ff ff       	call   800038 <check_block>
  8004dd:	83 c4 10             	add    $0x10,%esp
  8004e0:	85 c0                	test   %eax,%eax
  8004e2:	75 17                	jne    8004fb <_main+0x43b>
		{
			is_correct = 0;
  8004e4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #1.3: WRONG ALLOCATE AFTER FREE!\n");
  8004eb:	83 ec 0c             	sub    $0xc,%esp
  8004ee:	68 4c 45 80 00       	push   $0x80454c
  8004f3:	e8 5c 0e 00 00       	call   801354 <cprintf>
  8004f8:	83 c4 10             	add    $0x10,%esp
		}

		//Free 2nd block
		free(startVAs[1]);
  8004fb:	a1 a4 60 98 00       	mov    0x9860a4,%eax
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	50                   	push   %eax
  800504:	e8 b1 1d 00 00       	call   8022ba <free>
  800509:	83 c4 10             	add    $0x10,%esp
		if (check_block(startVAs[1],startVAs[1], allocSizes[0], 0) == 0)
  80050c:	8b 0d 00 60 80 00    	mov    0x806000,%ecx
  800512:	8b 15 a4 60 98 00    	mov    0x9860a4,%edx
  800518:	a1 a4 60 98 00       	mov    0x9860a4,%eax
  80051d:	6a 00                	push   $0x0
  80051f:	51                   	push   %ecx
  800520:	52                   	push   %edx
  800521:	50                   	push   %eax
  800522:	e8 11 fb ff ff       	call   800038 <check_block>
  800527:	83 c4 10             	add    $0x10,%esp
  80052a:	85 c0                	test   %eax,%eax
  80052c:	75 17                	jne    800545 <_main+0x485>
		{
			is_correct = 0;
  80052e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #1.4: WRONG FREE!\n");
  800535:	83 ec 0c             	sub    $0xc,%esp
  800538:	68 7c 45 80 00       	push   $0x80457c
  80053d:	e8 12 0e 00 00       	call   801354 <cprintf>
  800542:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  800545:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800549:	74 04                	je     80054f <_main+0x48f>
		{
			eval += 10;
  80054b:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*free Scenario 2: Merge with previous ONLY (AT the tail)*/
	cprintf("2: Free some allocated blocks [Merge with previous ONLY]\n\n") ;
  80054f:	83 ec 0c             	sub    $0xc,%esp
  800552:	68 9c 45 80 00       	push   $0x80459c
  800557:	e8 f8 0d 00 00       	call   801354 <cprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	2.1: at the tail\n\n") ;
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	68 d7 45 80 00       	push   $0x8045d7
  800567:	e8 e8 0d 00 00       	call   801354 <cprintf>
  80056c:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  80056f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		//Free last block (coalesce with previous)
		blockIndex = numOfAllocs*allocCntPerSize;
  800576:	c7 85 7c ff ff ff 78 	movl   $0x578,-0x84(%ebp)
  80057d:	05 00 00 
		free(startVAs[blockIndex]);
  800580:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800586:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  80058d:	83 ec 0c             	sub    $0xc,%esp
  800590:	50                   	push   %eax
  800591:	e8 24 1d 00 00       	call   8022ba <free>
  800596:	83 c4 10             	add    $0x10,%esp
		expectedSize = allocSizes[numOfAllocs-1] + remainSize;
  800599:	8b 15 18 60 80 00    	mov    0x806018,%edx
  80059f:	8b 45 80             	mov    -0x80(%ebp),%eax
  8005a2:	01 d0                	add    %edx,%eax
  8005a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex-1],startVAs[blockIndex-1], expectedSize, 0) == 0)
  8005a7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005ad:	48                   	dec    %eax
  8005ae:	8b 14 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%edx
  8005b5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005bb:	48                   	dec    %eax
  8005bc:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  8005c3:	6a 00                	push   $0x0
  8005c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	e8 69 fa ff ff       	call   800038 <check_block>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	85 c0                	test   %eax,%eax
  8005d4:	75 17                	jne    8005ed <_main+0x52d>
		{
			is_correct = 0;
  8005d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #2.1: WRONG FREE!\n");
  8005dd:	83 ec 0c             	sub    $0xc,%esp
  8005e0:	68 ec 45 80 00       	push   $0x8045ec
  8005e5:	e8 6a 0d 00 00       	call   801354 <cprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 3: Merge with previous ONLY (between 2 blocks)*/
		cprintf("	2.2: between 2 blocks\n\n") ;
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 0b 46 80 00       	push   $0x80460b
  8005f5:	e8 5a 0d 00 00       	call   801354 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
		blockIndex = 2*allocCntPerSize+1 ;
  8005fd:	c7 85 7c ff ff ff 91 	movl   $0x191,-0x84(%ebp)
  800604:	01 00 00 
		free(startVAs[blockIndex]);
  800607:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80060d:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  800614:	83 ec 0c             	sub    $0xc,%esp
  800617:	50                   	push   %eax
  800618:	e8 9d 1c 00 00       	call   8022ba <free>
  80061d:	83 c4 10             	add    $0x10,%esp
		expectedSize = allocSizes[2]+allocSizes[2];
  800620:	8b 15 08 60 80 00    	mov    0x806008,%edx
  800626:	a1 08 60 80 00       	mov    0x806008,%eax
  80062b:	01 d0                	add    %edx,%eax
  80062d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex-1],startVAs[blockIndex-1], expectedSize, 0) == 0)
  800630:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800636:	48                   	dec    %eax
  800637:	8b 14 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%edx
  80063e:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800644:	48                   	dec    %eax
  800645:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  80064c:	6a 00                	push   $0x0
  80064e:	ff 75 d8             	pushl  -0x28(%ebp)
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 e0 f9 ff ff       	call   800038 <check_block>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	85 c0                	test   %eax,%eax
  80065d:	75 17                	jne    800676 <_main+0x5b6>
		{
			is_correct = 0;
  80065f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #2.2: WRONG FREE!\n");
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 24 46 80 00       	push   $0x804624
  80066e:	e8 e1 0c 00 00       	call   801354 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800676:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067a:	74 04                	je     800680 <_main+0x5c0>
		{
			eval += 10;
  80067c:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
	}


	//====================================================================//
	/*free Scenario 4: Merge with next ONLY (AT the head)*/
	cprintf("3: Free some allocated blocks [Merge with next ONLY]\n\n") ;
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	68 44 46 80 00       	push   $0x804644
  800688:	e8 c7 0c 00 00       	call   801354 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	3.1: at the head\n\n") ;
  800690:	83 ec 0c             	sub    $0xc,%esp
  800693:	68 7b 46 80 00       	push   $0x80467b
  800698:	e8 b7 0c 00 00       	call   801354 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8006a0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		blockIndex = 0 ;
  8006a7:	c7 85 7c ff ff ff 00 	movl   $0x0,-0x84(%ebp)
  8006ae:	00 00 00 
		free(startVAs[blockIndex]);
  8006b1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8006b7:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  8006be:	83 ec 0c             	sub    $0xc,%esp
  8006c1:	50                   	push   %eax
  8006c2:	e8 f3 1b 00 00       	call   8022ba <free>
  8006c7:	83 c4 10             	add    $0x10,%esp
		expectedSize = allocSizes[0]+allocSizes[0];
  8006ca:	8b 15 00 60 80 00    	mov    0x806000,%edx
  8006d0:	a1 00 60 80 00       	mov    0x806000,%eax
  8006d5:	01 d0                	add    %edx,%eax
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex],startVAs[blockIndex], expectedSize, 0) == 0)
  8006da:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8006e0:	8b 14 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%edx
  8006e7:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8006ed:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  8006f4:	6a 00                	push   $0x0
  8006f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8006f9:	52                   	push   %edx
  8006fa:	50                   	push   %eax
  8006fb:	e8 38 f9 ff ff       	call   800038 <check_block>
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	85 c0                	test   %eax,%eax
  800705:	75 17                	jne    80071e <_main+0x65e>
		{
			is_correct = 0;
  800707:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #3.1: WRONG FREE!\n");
  80070e:	83 ec 0c             	sub    $0xc,%esp
  800711:	68 90 46 80 00       	push   $0x804690
  800716:	e8 39 0c 00 00       	call   801354 <cprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
		}

		//====================================================================//
		/*free Scenario 5: Merge with next ONLY (between 2 blocks)*/
		cprintf("	3.2: between 2 blocks\n\n") ;
  80071e:	83 ec 0c             	sub    $0xc,%esp
  800721:	68 af 46 80 00       	push   $0x8046af
  800726:	e8 29 0c 00 00       	call   801354 <cprintf>
  80072b:	83 c4 10             	add    $0x10,%esp
		blockIndex = 1*allocCntPerSize - 1 ;
  80072e:	c7 85 7c ff ff ff c7 	movl   $0xc7,-0x84(%ebp)
  800735:	00 00 00 
		free(startVAs[blockIndex]);
  800738:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80073e:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  800745:	83 ec 0c             	sub    $0xc,%esp
  800748:	50                   	push   %eax
  800749:	e8 6c 1b 00 00       	call   8022ba <free>
  80074e:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex]) ;
  800751:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800757:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  80075e:	83 ec 0c             	sub    $0xc,%esp
  800761:	50                   	push   %eax
  800762:	e8 ef 26 00 00       	call   802e56 <get_block_size>
  800767:	83 c4 10             	add    $0x10,%esp
  80076a:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		expectedSize = allocSizes[0]+allocSizes[1];
  800770:	8b 15 00 60 80 00    	mov    0x806000,%edx
  800776:	a1 04 60 80 00       	mov    0x806004,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex],startVAs[blockIndex], expectedSize, 0) == 0)
  800780:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800786:	8b 14 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%edx
  80078d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800793:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  80079a:	6a 00                	push   $0x0
  80079c:	ff 75 d8             	pushl  -0x28(%ebp)
  80079f:	52                   	push   %edx
  8007a0:	50                   	push   %eax
  8007a1:	e8 92 f8 ff ff       	call   800038 <check_block>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	85 c0                	test   %eax,%eax
  8007ab:	75 17                	jne    8007c4 <_main+0x704>
		{
			is_correct = 0;
  8007ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #3.2: WRONG FREE!\n");
  8007b4:	83 ec 0c             	sub    $0xc,%esp
  8007b7:	68 c8 46 80 00       	push   $0x8046c8
  8007bc:	e8 93 0b 00 00       	call   801354 <cprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
		}

		if (is_correct)
  8007c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c8:	74 04                	je     8007ce <_main+0x70e>
		{
			eval += 10;
  8007ca:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}
	//====================================================================//
	/*free Scenario 6: Merge with prev & next */
	cprintf("4: Free some allocated blocks [Merge with previous & next]\n\n") ;
  8007ce:	83 ec 0c             	sub    $0xc,%esp
  8007d1:	68 e8 46 80 00       	push   $0x8046e8
  8007d6:	e8 79 0b 00 00       	call   801354 <cprintf>
  8007db:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8007de:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		blockIndex = 4*allocCntPerSize - 2 ;
  8007e5:	c7 85 7c ff ff ff 1e 	movl   $0x31e,-0x84(%ebp)
  8007ec:	03 00 00 
		free(startVAs[blockIndex]);
  8007ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8007f5:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  8007fc:	83 ec 0c             	sub    $0xc,%esp
  8007ff:	50                   	push   %eax
  800800:	e8 b5 1a 00 00       	call   8022ba <free>
  800805:	83 c4 10             	add    $0x10,%esp

		blockIndex = 4*allocCntPerSize - 1 ;
  800808:	c7 85 7c ff ff ff 1f 	movl   $0x31f,-0x84(%ebp)
  80080f:	03 00 00 
		free(startVAs[blockIndex]);
  800812:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800818:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  80081f:	83 ec 0c             	sub    $0xc,%esp
  800822:	50                   	push   %eax
  800823:	e8 92 1a 00 00       	call   8022ba <free>
  800828:	83 c4 10             	add    $0x10,%esp
		block_size = get_block_size(startVAs[blockIndex-1]) ;
  80082b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800831:	48                   	dec    %eax
  800832:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  800839:	83 ec 0c             	sub    $0xc,%esp
  80083c:	50                   	push   %eax
  80083d:	e8 14 26 00 00       	call   802e56 <get_block_size>
  800842:	83 c4 10             	add    $0x10,%esp
  800845:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		expectedSize = allocSizes[3]+allocSizes[3]+allocSizes[4];
  80084b:	8b 15 0c 60 80 00    	mov    0x80600c,%edx
  800851:	a1 0c 60 80 00       	mov    0x80600c,%eax
  800856:	01 c2                	add    %eax,%edx
  800858:	a1 10 60 80 00       	mov    0x806010,%eax
  80085d:	01 d0                	add    %edx,%eax
  80085f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (check_block(startVAs[blockIndex-1],startVAs[blockIndex-1], expectedSize, 0) == 0)
  800862:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800868:	48                   	dec    %eax
  800869:	8b 14 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%edx
  800870:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800876:	48                   	dec    %eax
  800877:	8b 04 85 a0 60 98 00 	mov    0x9860a0(,%eax,4),%eax
  80087e:	6a 00                	push   $0x0
  800880:	ff 75 d8             	pushl  -0x28(%ebp)
  800883:	52                   	push   %edx
  800884:	50                   	push   %eax
  800885:	e8 ae f7 ff ff       	call   800038 <check_block>
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	85 c0                	test   %eax,%eax
  80088f:	75 17                	jne    8008a8 <_main+0x7e8>
		{
			is_correct = 0;
  800891:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #4: WRONG FREE!\n");
  800898:	83 ec 0c             	sub    $0xc,%esp
  80089b:	68 25 47 80 00       	push   $0x804725
  8008a0:	e8 af 0a 00 00       	call   801354 <cprintf>
  8008a5:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008ac:	74 04                	je     8008b2 <_main+0x7f2>
		{
			eval += 20;
  8008ae:	83 45 e4 14          	addl   $0x14,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*Allocate After Free Scenarios */
	cprintf("5: Allocate After Free [should be placed in coalesced blocks]\n\n") ;
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 44 47 80 00       	push   $0x804744
  8008ba:	e8 95 0a 00 00       	call   801354 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("	5.1: in block coalesces with NEXT\n\n") ;
  8008c2:	83 ec 0c             	sub    $0xc,%esp
  8008c5:	68 84 47 80 00       	push   $0x804784
  8008ca:	e8 85 0a 00 00       	call   801354 <cprintf>
  8008cf:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  8008d2:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		cprintf("	5.1.1: a. at head\n\n") ;
  8008d9:	83 ec 0c             	sub    $0xc,%esp
  8008dc:	68 a9 47 80 00       	push   $0x8047a9
  8008e1:	e8 6e 0a 00 00       	call   801354 <cprintf>
  8008e6:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 4*sizeof(int);
  8008e9:	c7 45 ac 10 00 00 00 	movl   $0x10,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  8008f0:	c7 85 74 ff ff ff 02 	movl   $0x2,-0x8c(%ebp)
  8008f7:	00 00 00 
  8008fa:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8008fd:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800903:	01 d0                	add    %edx,%eax
  800905:	83 c0 07             	add    $0x7,%eax
  800908:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  80090e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800914:	ba 00 00 00 00       	mov    $0x0,%edx
  800919:	f7 b5 74 ff ff ff    	divl   -0x8c(%ebp)
  80091f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800925:	29 d0                	sub    %edx,%eax
  800927:	89 45 d8             	mov    %eax,-0x28(%ebp)
			va = malloc(actualSize);
  80092a:	83 ec 0c             	sub    $0xc,%esp
  80092d:	ff 75 ac             	pushl  -0x54(%ebp)
  800930:	e8 cf 17 00 00       	call   802104 <malloc>
  800935:	83 c4 10             	add    $0x10,%esp
  800938:	89 45 a8             	mov    %eax,-0x58(%ebp)
			//Check returned va
			expectedVA = (void*)(USER_HEAP_START + sizeOfMetaData);
  80093b:	c7 45 a4 08 00 00 80 	movl   $0x80000008,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800942:	6a 01                	push   $0x1
  800944:	ff 75 d8             	pushl  -0x28(%ebp)
  800947:	ff 75 a4             	pushl  -0x5c(%ebp)
  80094a:	ff 75 a8             	pushl  -0x58(%ebp)
  80094d:	e8 e6 f6 ff ff       	call   800038 <check_block>
  800952:	83 c4 10             	add    $0x10,%esp
  800955:	85 c0                	test   %eax,%eax
  800957:	75 17                	jne    800970 <_main+0x8b0>
			{
				is_correct = 0;
  800959:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.1.1: WRONG ALLOCATE AFTER FREE!\n");
  800960:	83 ec 0c             	sub    $0xc,%esp
  800963:	68 c0 47 80 00       	push   $0x8047c0
  800968:	e8 e7 09 00 00       	call   801354 <cprintf>
  80096d:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.2: b. after the prev alloc in 5.1.1\n\n") ;
  800970:	83 ec 0c             	sub    $0xc,%esp
  800973:	68 f0 47 80 00       	push   $0x8047f0
  800978:	e8 d7 09 00 00       	call   801354 <cprintf>
  80097d:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 2*sizeof(int) ;
  800980:	c7 45 ac 08 00 00 00 	movl   $0x8,-0x54(%ebp)
			va = malloc(actualSize);
  800987:	83 ec 0c             	sub    $0xc,%esp
  80098a:	ff 75 ac             	pushl  -0x54(%ebp)
  80098d:	e8 72 17 00 00       	call   802104 <malloc>
  800992:	83 c4 10             	add    $0x10,%esp
  800995:	89 45 a8             	mov    %eax,-0x58(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800998:	c7 85 6c ff ff ff 02 	movl   $0x2,-0x94(%ebp)
  80099f:	00 00 00 
  8009a2:	8b 55 ac             	mov    -0x54(%ebp),%edx
  8009a5:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8009ab:	01 d0                	add    %edx,%eax
  8009ad:	83 c0 07             	add    $0x7,%eax
  8009b0:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  8009b6:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8009bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8009c1:	f7 b5 6c ff ff ff    	divl   -0x94(%ebp)
  8009c7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  8009cd:	29 d0                	sub    %edx,%eax
  8009cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
			//Check returned va
			expectedVA = (void*)(USER_HEAP_START + sizeOfMetaData + 4*sizeof(int) + sizeOfMetaData);
  8009d2:	c7 45 a4 20 00 00 80 	movl   $0x80000020,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  8009d9:	6a 01                	push   $0x1
  8009db:	ff 75 d8             	pushl  -0x28(%ebp)
  8009de:	ff 75 a4             	pushl  -0x5c(%ebp)
  8009e1:	ff 75 a8             	pushl  -0x58(%ebp)
  8009e4:	e8 4f f6 ff ff       	call   800038 <check_block>
  8009e9:	83 c4 10             	add    $0x10,%esp
  8009ec:	85 c0                	test   %eax,%eax
  8009ee:	75 17                	jne    800a07 <_main+0x947>
			{
				is_correct = 0;
  8009f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.1.2: WRONG ALLOCATE AFTER FREE!\n");
  8009f7:	83 ec 0c             	sub    $0xc,%esp
  8009fa:	68 1c 48 80 00       	push   $0x80481c
  8009ff:	e8 50 09 00 00       	call   801354 <cprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
			}
		}
		cprintf("	5.1.3: c. between two blocks [INTERNAL FRAGMENTATION CASE]\n\n") ;
  800a07:	83 ec 0c             	sub    $0xc,%esp
  800a0a:	68 4c 48 80 00       	push   $0x80484c
  800a0f:	e8 40 09 00 00       	call   801354 <cprintf>
  800a14:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 5*sizeof(int); //20B
  800a17:	c7 45 ac 14 00 00 00 	movl   $0x14,-0x54(%ebp)
			expectedSize = allocSizes[0] + allocSizes[1]; //20B + 16B [Internal Fragmentation of 8 Bytes]
  800a1e:	8b 15 00 60 80 00    	mov    0x806000,%edx
  800a24:	a1 04 60 80 00       	mov    0x806004,%eax
  800a29:	01 d0                	add    %edx,%eax
  800a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
			va = malloc(actualSize);
  800a2e:	83 ec 0c             	sub    $0xc,%esp
  800a31:	ff 75 ac             	pushl  -0x54(%ebp)
  800a34:	e8 cb 16 00 00       	call   802104 <malloc>
  800a39:	83 c4 10             	add    $0x10,%esp
  800a3c:	89 45 a8             	mov    %eax,-0x58(%ebp)
			//Check returned va
			expectedVA = startVAs[1*allocCntPerSize - 1];
  800a3f:	a1 bc 63 98 00       	mov    0x9863bc,%eax
  800a44:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800a47:	6a 01                	push   $0x1
  800a49:	ff 75 d8             	pushl  -0x28(%ebp)
  800a4c:	ff 75 a4             	pushl  -0x5c(%ebp)
  800a4f:	ff 75 a8             	pushl  -0x58(%ebp)
  800a52:	e8 e1 f5 ff ff       	call   800038 <check_block>
  800a57:	83 c4 10             	add    $0x10,%esp
  800a5a:	85 c0                	test   %eax,%eax
  800a5c:	75 17                	jne    800a75 <_main+0x9b5>
			{
				is_correct = 0;
  800a5e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.1.3: WRONG ALLOCATE AFTER FREE!\n");
  800a65:	83 ec 0c             	sub    $0xc,%esp
  800a68:	68 8c 48 80 00       	push   $0x80488c
  800a6d:	e8 e2 08 00 00       	call   801354 <cprintf>
  800a72:	83 c4 10             	add    $0x10,%esp
			}
		}
		if (is_correct)
  800a75:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a79:	74 04                	je     800a7f <_main+0x9bf>
		{
			eval += 10;
  800a7b:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}

		cprintf("	5.2: in block coalesces with PREV & NEXT\n\n") ;
  800a7f:	83 ec 0c             	sub    $0xc,%esp
  800a82:	68 bc 48 80 00       	push   $0x8048bc
  800a87:	e8 c8 08 00 00       	call   801354 <cprintf>
  800a8c:	83 c4 10             	add    $0x10,%esp
		is_correct = 1;
  800a8f:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		actualSize = 3*kilo/2;
  800a96:	c7 45 ac 00 06 00 00 	movl   $0x600,-0x54(%ebp)
		expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800a9d:	c7 85 64 ff ff ff 02 	movl   $0x2,-0x9c(%ebp)
  800aa4:	00 00 00 
  800aa7:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800aaa:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800ab0:	01 d0                	add    %edx,%eax
  800ab2:	83 c0 07             	add    $0x7,%eax
  800ab5:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800abb:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800ac1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac6:	f7 b5 64 ff ff ff    	divl   -0x9c(%ebp)
  800acc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800ad2:	29 d0                	sub    %edx,%eax
  800ad4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		va = malloc(actualSize);
  800ad7:	83 ec 0c             	sub    $0xc,%esp
  800ada:	ff 75 ac             	pushl  -0x54(%ebp)
  800add:	e8 22 16 00 00       	call   802104 <malloc>
  800ae2:	83 c4 10             	add    $0x10,%esp
  800ae5:	89 45 a8             	mov    %eax,-0x58(%ebp)
		//Check returned va
		expectedVA = startVAs[4*allocCntPerSize - 2];
  800ae8:	a1 18 6d 98 00       	mov    0x986d18,%eax
  800aed:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800af0:	6a 01                	push   $0x1
  800af2:	ff 75 d8             	pushl  -0x28(%ebp)
  800af5:	ff 75 a4             	pushl  -0x5c(%ebp)
  800af8:	ff 75 a8             	pushl  -0x58(%ebp)
  800afb:	e8 38 f5 ff ff       	call   800038 <check_block>
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	85 c0                	test   %eax,%eax
  800b05:	75 17                	jne    800b1e <_main+0xa5e>
		{
			is_correct = 0;
  800b07:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			cprintf("test_free_2 #5.2: WRONG ALLOCATE AFTER FREE!\n");
  800b0e:	83 ec 0c             	sub    $0xc,%esp
  800b11:	68 e8 48 80 00       	push   $0x8048e8
  800b16:	e8 39 08 00 00       	call   801354 <cprintf>
  800b1b:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800b1e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b22:	74 04                	je     800b28 <_main+0xa68>
		{
			eval += 10;
  800b24:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}

		cprintf("	5.3: in block coalesces with PREV\n\n") ;
  800b28:	83 ec 0c             	sub    $0xc,%esp
  800b2b:	68 18 49 80 00       	push   $0x804918
  800b30:	e8 1f 08 00 00       	call   801354 <cprintf>
  800b35:	83 c4 10             	add    $0x10,%esp
		cprintf("	5.3.1: a. between two blocks\n\n") ;
  800b38:	83 ec 0c             	sub    $0xc,%esp
  800b3b:	68 40 49 80 00       	push   $0x804940
  800b40:	e8 0f 08 00 00       	call   801354 <cprintf>
  800b45:	83 c4 10             	add    $0x10,%esp
		{
			is_correct = 1;
  800b48:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			actualSize = 30*sizeof(char) ;
  800b4f:	c7 45 ac 1e 00 00 00 	movl   $0x1e,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800b56:	c7 85 5c ff ff ff 02 	movl   $0x2,-0xa4(%ebp)
  800b5d:	00 00 00 
  800b60:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800b63:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800b69:	01 d0                	add    %edx,%eax
  800b6b:	83 c0 07             	add    $0x7,%eax
  800b6e:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800b74:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b7f:	f7 b5 5c ff ff ff    	divl   -0xa4(%ebp)
  800b85:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800b8b:	29 d0                	sub    %edx,%eax
  800b8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			va = malloc(actualSize);
  800b90:	83 ec 0c             	sub    $0xc,%esp
  800b93:	ff 75 ac             	pushl  -0x54(%ebp)
  800b96:	e8 69 15 00 00       	call   802104 <malloc>
  800b9b:	83 c4 10             	add    $0x10,%esp
  800b9e:	89 45 a8             	mov    %eax,-0x58(%ebp)
			//Check returned va
			expectedVA = startVAs[2*allocCntPerSize];
  800ba1:	a1 e0 66 98 00       	mov    0x9866e0,%eax
  800ba6:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800ba9:	6a 01                	push   $0x1
  800bab:	ff 75 d8             	pushl  -0x28(%ebp)
  800bae:	ff 75 a4             	pushl  -0x5c(%ebp)
  800bb1:	ff 75 a8             	pushl  -0x58(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <check_block>
  800bb9:	83 c4 10             	add    $0x10,%esp
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	75 17                	jne    800bd7 <_main+0xb17>
			{
				is_correct = 0;
  800bc0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.3.1: WRONG ALLOCATE AFTER FREE!\n");
  800bc7:	83 ec 0c             	sub    $0xc,%esp
  800bca:	68 60 49 80 00       	push   $0x804960
  800bcf:	e8 80 07 00 00       	call   801354 <cprintf>
  800bd4:	83 c4 10             	add    $0x10,%esp
			}
		}
		actualSize = 3*kilo/2 - sizeOfMetaData ;
  800bd7:	c7 45 ac f8 05 00 00 	movl   $0x5f8,-0x54(%ebp)
		expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800bde:	c7 85 54 ff ff ff 02 	movl   $0x2,-0xac(%ebp)
  800be5:	00 00 00 
  800be8:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800beb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800bf1:	01 d0                	add    %edx,%eax
  800bf3:	83 c0 07             	add    $0x7,%eax
  800bf6:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800bfc:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c02:	ba 00 00 00 00       	mov    $0x0,%edx
  800c07:	f7 b5 54 ff ff ff    	divl   -0xac(%ebp)
  800c0d:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800c13:	29 d0                	sub    %edx,%eax
  800c15:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//dummy allocation to consume the 1st 1.5 KB free block
		{
			va = malloc(actualSize);
  800c18:	83 ec 0c             	sub    $0xc,%esp
  800c1b:	ff 75 ac             	pushl  -0x54(%ebp)
  800c1e:	e8 e1 14 00 00       	call   802104 <malloc>
  800c23:	83 c4 10             	add    $0x10,%esp
  800c26:	89 45 a8             	mov    %eax,-0x58(%ebp)
		}
		//dummy allocation to consume the 1st 2 KB free block
		{
			va = malloc(actualSize);
  800c29:	83 ec 0c             	sub    $0xc,%esp
  800c2c:	ff 75 ac             	pushl  -0x54(%ebp)
  800c2f:	e8 d0 14 00 00       	call   802104 <malloc>
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	89 45 a8             	mov    %eax,-0x58(%ebp)
		}

		cprintf("	5.3.2: b. at tail\n\n") ;
  800c3a:	83 ec 0c             	sub    $0xc,%esp
  800c3d:	68 90 49 80 00       	push   $0x804990
  800c42:	e8 0d 07 00 00       	call   801354 <cprintf>
  800c47:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 3*kilo/2 ;
  800c4a:	c7 45 ac 00 06 00 00 	movl   $0x600,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800c51:	c7 85 4c ff ff ff 02 	movl   $0x2,-0xb4(%ebp)
  800c58:	00 00 00 
  800c5b:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800c5e:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800c64:	01 d0                	add    %edx,%eax
  800c66:	83 c0 07             	add    $0x7,%eax
  800c69:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800c6f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c75:	ba 00 00 00 00       	mov    $0x0,%edx
  800c7a:	f7 b5 4c ff ff ff    	divl   -0xb4(%ebp)
  800c80:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c86:	29 d0                	sub    %edx,%eax
  800c88:	89 45 d8             	mov    %eax,-0x28(%ebp)

			print_blocks_list(freeBlocksList);
  800c8b:	83 ec 10             	sub    $0x10,%esp
  800c8e:	89 e0                	mov    %esp,%eax
  800c90:	89 c2                	mov    %eax,%edx
  800c92:	bb 84 60 98 00       	mov    $0x986084,%ebx
  800c97:	b8 04 00 00 00       	mov    $0x4,%eax
  800c9c:	89 d7                	mov    %edx,%edi
  800c9e:	89 de                	mov    %ebx,%esi
  800ca0:	89 c1                	mov    %eax,%ecx
  800ca2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ca4:	e8 73 22 00 00       	call   802f1c <print_blocks_list>
  800ca9:	83 c4 10             	add    $0x10,%esp

			va = malloc(actualSize);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	ff 75 ac             	pushl  -0x54(%ebp)
  800cb2:	e8 4d 14 00 00       	call   802104 <malloc>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 a8             	mov    %eax,-0x58(%ebp)

			//Check returned va
			expectedVA = startVAs[numOfAllocs*allocCntPerSize-1];
  800cbd:	a1 7c 76 98 00       	mov    0x98767c,%eax
  800cc2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800cc5:	6a 01                	push   $0x1
  800cc7:	ff 75 d8             	pushl  -0x28(%ebp)
  800cca:	ff 75 a4             	pushl  -0x5c(%ebp)
  800ccd:	ff 75 a8             	pushl  -0x58(%ebp)
  800cd0:	e8 63 f3 ff ff       	call   800038 <check_block>
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	85 c0                	test   %eax,%eax
  800cda:	75 17                	jne    800cf3 <_main+0xc33>
			{
				is_correct = 0;
  800cdc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.3.2: WRONG ALLOCATE AFTER FREE!\n");
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	68 a8 49 80 00       	push   $0x8049a8
  800ceb:	e8 64 06 00 00       	call   801354 <cprintf>
  800cf0:	83 c4 10             	add    $0x10,%esp
			}
		}

		cprintf("	5.3.3: c. after the prev allocated block in 5.3.2\n\n") ;
  800cf3:	83 ec 0c             	sub    $0xc,%esp
  800cf6:	68 d8 49 80 00       	push   $0x8049d8
  800cfb:	e8 54 06 00 00       	call   801354 <cprintf>
  800d00:	83 c4 10             	add    $0x10,%esp
		{
			actualSize = 3*kilo/2 ;
  800d03:	c7 45 ac 00 06 00 00 	movl   $0x600,-0x54(%ebp)
			expectedSize = ROUNDUP(actualSize + sizeOfMetaData, 2);
  800d0a:	c7 85 44 ff ff ff 02 	movl   $0x2,-0xbc(%ebp)
  800d11:	00 00 00 
  800d14:	8b 55 ac             	mov    -0x54(%ebp),%edx
  800d17:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d1d:	01 d0                	add    %edx,%eax
  800d1f:	83 c0 07             	add    $0x7,%eax
  800d22:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800d28:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d33:	f7 b5 44 ff ff ff    	divl   -0xbc(%ebp)
  800d39:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d3f:	29 d0                	sub    %edx,%eax
  800d41:	89 45 d8             	mov    %eax,-0x28(%ebp)

			va = malloc(actualSize);
  800d44:	83 ec 0c             	sub    $0xc,%esp
  800d47:	ff 75 ac             	pushl  -0x54(%ebp)
  800d4a:	e8 b5 13 00 00       	call   802104 <malloc>
  800d4f:	83 c4 10             	add    $0x10,%esp
  800d52:	89 45 a8             	mov    %eax,-0x58(%ebp)

			//Check returned va
			expectedVA = (void*)startVAs[numOfAllocs*allocCntPerSize-1] + 3*kilo/2 + sizeOfMetaData;
  800d55:	a1 7c 76 98 00       	mov    0x98767c,%eax
  800d5a:	05 08 06 00 00       	add    $0x608,%eax
  800d5f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800d62:	6a 01                	push   $0x1
  800d64:	ff 75 d8             	pushl  -0x28(%ebp)
  800d67:	ff 75 a4             	pushl  -0x5c(%ebp)
  800d6a:	ff 75 a8             	pushl  -0x58(%ebp)
  800d6d:	e8 c6 f2 ff ff       	call   800038 <check_block>
  800d72:	83 c4 10             	add    $0x10,%esp
  800d75:	85 c0                	test   %eax,%eax
  800d77:	75 17                	jne    800d90 <_main+0xcd0>
			{
				is_correct = 0;
  800d79:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				cprintf("test_free_2 #5.3.3: WRONG ALLOCATE AFTER FREE!\n");
  800d80:	83 ec 0c             	sub    $0xc,%esp
  800d83:	68 10 4a 80 00       	push   $0x804a10
  800d88:	e8 c7 05 00 00       	call   801354 <cprintf>
  800d8d:	83 c4 10             	add    $0x10,%esp
			}
		}
		if (is_correct)
  800d90:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d94:	74 04                	je     800d9a <_main+0xcda>
		{
			eval += 10;
  800d96:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	//====================================================================//
	/*Check memory allocation*/
	cprintf("6: Check memory allocation [should not be changed due to free]\n\n") ;
  800d9a:	83 ec 0c             	sub    $0xc,%esp
  800d9d:	68 40 4a 80 00       	push   $0x804a40
  800da2:	e8 ad 05 00 00       	call   801354 <cprintf>
  800da7:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800daa:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 0)
  800db1:	e8 23 1b 00 00       	call   8028d9 <sys_calculate_free_frames>
  800db6:	89 c2                	mov    %eax,%edx
  800db8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	74 17                	je     800dd6 <_main+0xd16>
		{
			cprintf("test_free_2 #6: number of allocated pages in MEMORY is changed due to free() while it's not supposed to!\n");
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	68 84 4a 80 00       	push   $0x804a84
  800dc7:	e8 88 05 00 00       	call   801354 <cprintf>
  800dcc:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800dcf:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		}
		if (is_correct)
  800dd6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dda:	74 04                	je     800de0 <_main+0xd20>
		{
			eval += 10;
  800ddc:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	uint32 expectedAllocatedSize = curTotalSize;
  800de0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800de3:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
//	for (int i = 0; i < numOfAllocs; ++i)
//	{
//		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
//	}
	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
  800de9:	c7 85 38 ff ff ff 00 	movl   $0x1000,-0xc8(%ebp)
  800df0:	10 00 00 
  800df3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800df9:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	48                   	dec    %eax
  800e02:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800e08:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800e0e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e13:	f7 b5 38 ff ff ff    	divl   -0xc8(%ebp)
  800e19:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800e1f:	29 d0                	sub    %edx,%eax
  800e21:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800e27:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800e2d:	c1 e8 0c             	shr    $0xc,%eax
  800e30:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  800e36:	c7 85 2c ff ff ff 00 	movl   $0x400000,-0xd4(%ebp)
  800e3d:	00 40 00 
  800e40:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800e46:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	48                   	dec    %eax
  800e4f:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  800e55:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e60:	f7 b5 2c ff ff ff    	divl   -0xd4(%ebp)
  800e66:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  800e6c:	29 d0                	sub    %edx,%eax
  800e6e:	c1 e8 16             	shr    $0x16,%eax
  800e71:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)

	//====================================================================//
	/*Check WS elements*/
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
  800e77:	83 ec 0c             	sub    $0xc,%esp
  800e7a:	68 f0 4a 80 00       	push   $0x804af0
  800e7f:	e8 d0 04 00 00       	call   801354 <cprintf>
  800e84:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800e87:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800e8e:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800e94:	c1 e0 02             	shl    $0x2,%eax
  800e97:	83 ec 0c             	sub    $0xc,%esp
  800e9a:	50                   	push   %eax
  800e9b:	e8 64 12 00 00       	call   802104 <malloc>
  800ea0:	83 c4 10             	add    $0x10,%esp
  800ea3:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
		int i = 0;
  800ea9:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800eb0:	c7 45 bc 00 00 00 80 	movl   $0x80000000,-0x44(%ebp)
  800eb7:	eb 24                	jmp    800edd <_main+0xe1d>
		{
			expectedVAs[i++] = va;
  800eb9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ebc:	8d 50 01             	lea    0x1(%eax),%edx
  800ebf:	89 55 c0             	mov    %edx,-0x40(%ebp)
  800ec2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ec9:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800ecf:	01 c2                	add    %eax,%edx
  800ed1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800ed4:	89 02                	mov    %eax,(%edx)
	cprintf("7: Check WS Elements [should not be changed due to free]\n\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800ed6:	81 45 bc 00 10 00 00 	addl   $0x1000,-0x44(%ebp)
  800edd:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ee3:	05 00 00 00 80       	add    $0x80000000,%eax
  800ee8:	3b 45 bc             	cmp    -0x44(%ebp),%eax
  800eeb:	77 cc                	ja     800eb9 <_main+0xdf9>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  800eed:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  800ef3:	6a 02                	push   $0x2
  800ef5:	6a 00                	push   $0x0
  800ef7:	50                   	push   %eax
  800ef8:	ff b5 20 ff ff ff    	pushl  -0xe0(%ebp)
  800efe:	e8 31 1e 00 00       	call   802d34 <sys_check_WS_list>
  800f03:	83 c4 10             	add    $0x10,%esp
  800f06:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
		if (chk != 1)
  800f0c:	83 bd 1c ff ff ff 01 	cmpl   $0x1,-0xe4(%ebp)
  800f13:	74 17                	je     800f2c <_main+0xe6c>
		{
			cprintf("test_free_2 #7: page is either not added to WS or removed from it\n");
  800f15:	83 ec 0c             	sub    $0xc,%esp
  800f18:	68 2c 4b 80 00       	push   $0x804b2c
  800f1d:	e8 32 04 00 00       	call   801354 <cprintf>
  800f22:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800f25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		}
		if (is_correct)
  800f2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f30:	74 04                	je     800f36 <_main+0xe76>
		{
			eval += 10;
  800f32:	83 45 e4 0a          	addl   $0xa,-0x1c(%ebp)
		}
	}

	cprintf("%~test free() with FIRST FIT completed [DYNAMIC ALLOCATOR]. Evaluation = %d%\n", eval);
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f3c:	68 70 4b 80 00       	push   $0x804b70
  800f41:	e8 0e 04 00 00       	call   801354 <cprintf>
  800f46:	83 c4 10             	add    $0x10,%esp

	return;
  800f49:	90                   	nop
}
  800f4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4d:	5b                   	pop    %ebx
  800f4e:	5e                   	pop    %esi
  800f4f:	5f                   	pop    %edi
  800f50:	5d                   	pop    %ebp
  800f51:	c3                   	ret    

00800f52 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800f52:	55                   	push   %ebp
  800f53:	89 e5                	mov    %esp,%ebp
  800f55:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800f58:	e8 45 1b 00 00       	call   802aa2 <sys_getenvindex>
  800f5d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f63:	89 d0                	mov    %edx,%eax
  800f65:	c1 e0 02             	shl    $0x2,%eax
  800f68:	01 d0                	add    %edx,%eax
  800f6a:	c1 e0 03             	shl    $0x3,%eax
  800f6d:	01 d0                	add    %edx,%eax
  800f6f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800f76:	01 d0                	add    %edx,%eax
  800f78:	c1 e0 02             	shl    $0x2,%eax
  800f7b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800f80:	a3 40 60 80 00       	mov    %eax,0x806040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800f85:	a1 40 60 80 00       	mov    0x806040,%eax
  800f8a:	8a 40 20             	mov    0x20(%eax),%al
  800f8d:	84 c0                	test   %al,%al
  800f8f:	74 0d                	je     800f9e <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800f91:	a1 40 60 80 00       	mov    0x806040,%eax
  800f96:	83 c0 20             	add    $0x20,%eax
  800f99:	a3 20 60 80 00       	mov    %eax,0x806020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800f9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa2:	7e 0a                	jle    800fae <libmain+0x5c>
		binaryname = argv[0];
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	8b 00                	mov    (%eax),%eax
  800fa9:	a3 20 60 80 00       	mov    %eax,0x806020

	// call user main routine
	_main(argc, argv);
  800fae:	83 ec 08             	sub    $0x8,%esp
  800fb1:	ff 75 0c             	pushl  0xc(%ebp)
  800fb4:	ff 75 08             	pushl  0x8(%ebp)
  800fb7:	e8 04 f1 ff ff       	call   8000c0 <_main>
  800fbc:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800fbf:	a1 1c 60 80 00       	mov    0x80601c,%eax
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	0f 84 9f 00 00 00    	je     80106b <libmain+0x119>
	{
		sys_lock_cons();
  800fcc:	e8 55 18 00 00       	call   802826 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800fd1:	83 ec 0c             	sub    $0xc,%esp
  800fd4:	68 d8 4b 80 00       	push   $0x804bd8
  800fd9:	e8 76 03 00 00       	call   801354 <cprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800fe1:	a1 40 60 80 00       	mov    0x806040,%eax
  800fe6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800fec:	a1 40 60 80 00       	mov    0x806040,%eax
  800ff1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800ff7:	83 ec 04             	sub    $0x4,%esp
  800ffa:	52                   	push   %edx
  800ffb:	50                   	push   %eax
  800ffc:	68 00 4c 80 00       	push   $0x804c00
  801001:	e8 4e 03 00 00       	call   801354 <cprintf>
  801006:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801009:	a1 40 60 80 00       	mov    0x806040,%eax
  80100e:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801014:	a1 40 60 80 00       	mov    0x806040,%eax
  801019:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80101f:	a1 40 60 80 00       	mov    0x806040,%eax
  801024:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80102a:	51                   	push   %ecx
  80102b:	52                   	push   %edx
  80102c:	50                   	push   %eax
  80102d:	68 28 4c 80 00       	push   $0x804c28
  801032:	e8 1d 03 00 00       	call   801354 <cprintf>
  801037:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80103a:	a1 40 60 80 00       	mov    0x806040,%eax
  80103f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  801045:	83 ec 08             	sub    $0x8,%esp
  801048:	50                   	push   %eax
  801049:	68 80 4c 80 00       	push   $0x804c80
  80104e:	e8 01 03 00 00       	call   801354 <cprintf>
  801053:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	68 d8 4b 80 00       	push   $0x804bd8
  80105e:	e8 f1 02 00 00       	call   801354 <cprintf>
  801063:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  801066:	e8 d5 17 00 00       	call   802840 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80106b:	e8 19 00 00 00       	call   801089 <exit>
}
  801070:	90                   	nop
  801071:	c9                   	leave  
  801072:	c3                   	ret    

00801073 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
  801076:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801079:	83 ec 0c             	sub    $0xc,%esp
  80107c:	6a 00                	push   $0x0
  80107e:	e8 eb 19 00 00       	call   802a6e <sys_destroy_env>
  801083:	83 c4 10             	add    $0x10,%esp
}
  801086:	90                   	nop
  801087:	c9                   	leave  
  801088:	c3                   	ret    

00801089 <exit>:

void
exit(void)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80108f:	e8 40 1a 00 00       	call   802ad4 <sys_exit_env>
}
  801094:	90                   	nop
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80109d:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a0:	83 c0 04             	add    $0x4,%eax
  8010a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8010a6:	a1 8c a2 98 00       	mov    0x98a28c,%eax
  8010ab:	85 c0                	test   %eax,%eax
  8010ad:	74 16                	je     8010c5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8010af:	a1 8c a2 98 00       	mov    0x98a28c,%eax
  8010b4:	83 ec 08             	sub    $0x8,%esp
  8010b7:	50                   	push   %eax
  8010b8:	68 94 4c 80 00       	push   $0x804c94
  8010bd:	e8 92 02 00 00       	call   801354 <cprintf>
  8010c2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8010c5:	a1 20 60 80 00       	mov    0x806020,%eax
  8010ca:	ff 75 0c             	pushl  0xc(%ebp)
  8010cd:	ff 75 08             	pushl  0x8(%ebp)
  8010d0:	50                   	push   %eax
  8010d1:	68 99 4c 80 00       	push   $0x804c99
  8010d6:	e8 79 02 00 00       	call   801354 <cprintf>
  8010db:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8010de:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e1:	83 ec 08             	sub    $0x8,%esp
  8010e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8010e7:	50                   	push   %eax
  8010e8:	e8 fc 01 00 00       	call   8012e9 <vcprintf>
  8010ed:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8010f0:	83 ec 08             	sub    $0x8,%esp
  8010f3:	6a 00                	push   $0x0
  8010f5:	68 b5 4c 80 00       	push   $0x804cb5
  8010fa:	e8 ea 01 00 00       	call   8012e9 <vcprintf>
  8010ff:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801102:	e8 82 ff ff ff       	call   801089 <exit>

	// should not return here
	while (1) ;
  801107:	eb fe                	jmp    801107 <_panic+0x70>

00801109 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
  80110c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80110f:	a1 40 60 80 00       	mov    0x806040,%eax
  801114:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80111a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111d:	39 c2                	cmp    %eax,%edx
  80111f:	74 14                	je     801135 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801121:	83 ec 04             	sub    $0x4,%esp
  801124:	68 b8 4c 80 00       	push   $0x804cb8
  801129:	6a 26                	push   $0x26
  80112b:	68 04 4d 80 00       	push   $0x804d04
  801130:	e8 62 ff ff ff       	call   801097 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801135:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80113c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801143:	e9 c5 00 00 00       	jmp    80120d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80114b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	01 d0                	add    %edx,%eax
  801157:	8b 00                	mov    (%eax),%eax
  801159:	85 c0                	test   %eax,%eax
  80115b:	75 08                	jne    801165 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80115d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801160:	e9 a5 00 00 00       	jmp    80120a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801165:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80116c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801173:	eb 69                	jmp    8011de <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801175:	a1 40 60 80 00       	mov    0x806040,%eax
  80117a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801180:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801183:	89 d0                	mov    %edx,%eax
  801185:	01 c0                	add    %eax,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	c1 e0 03             	shl    $0x3,%eax
  80118c:	01 c8                	add    %ecx,%eax
  80118e:	8a 40 04             	mov    0x4(%eax),%al
  801191:	84 c0                	test   %al,%al
  801193:	75 46                	jne    8011db <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801195:	a1 40 60 80 00       	mov    0x806040,%eax
  80119a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8011a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8011a3:	89 d0                	mov    %edx,%eax
  8011a5:	01 c0                	add    %eax,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	c1 e0 03             	shl    $0x3,%eax
  8011ac:	01 c8                	add    %ecx,%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011bb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8011bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8011ce:	39 c2                	cmp    %eax,%edx
  8011d0:	75 09                	jne    8011db <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8011d2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8011d9:	eb 15                	jmp    8011f0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8011db:	ff 45 e8             	incl   -0x18(%ebp)
  8011de:	a1 40 60 80 00       	mov    0x806040,%eax
  8011e3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8011e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8011ec:	39 c2                	cmp    %eax,%edx
  8011ee:	77 85                	ja     801175 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8011f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011f4:	75 14                	jne    80120a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8011f6:	83 ec 04             	sub    $0x4,%esp
  8011f9:	68 10 4d 80 00       	push   $0x804d10
  8011fe:	6a 3a                	push   $0x3a
  801200:	68 04 4d 80 00       	push   $0x804d04
  801205:	e8 8d fe ff ff       	call   801097 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80120a:	ff 45 f0             	incl   -0x10(%ebp)
  80120d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801210:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801213:	0f 8c 2f ff ff ff    	jl     801148 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801219:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801220:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801227:	eb 26                	jmp    80124f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801229:	a1 40 60 80 00       	mov    0x806040,%eax
  80122e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801234:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	01 c0                	add    %eax,%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c1 e0 03             	shl    $0x3,%eax
  801240:	01 c8                	add    %ecx,%eax
  801242:	8a 40 04             	mov    0x4(%eax),%al
  801245:	3c 01                	cmp    $0x1,%al
  801247:	75 03                	jne    80124c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801249:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80124c:	ff 45 e0             	incl   -0x20(%ebp)
  80124f:	a1 40 60 80 00       	mov    0x806040,%eax
  801254:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80125a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80125d:	39 c2                	cmp    %eax,%edx
  80125f:	77 c8                	ja     801229 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801264:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801267:	74 14                	je     80127d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801269:	83 ec 04             	sub    $0x4,%esp
  80126c:	68 64 4d 80 00       	push   $0x804d64
  801271:	6a 44                	push   $0x44
  801273:	68 04 4d 80 00       	push   $0x804d04
  801278:	e8 1a fe ff ff       	call   801097 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80127d:	90                   	nop
  80127e:	c9                   	leave  
  80127f:	c3                   	ret    

00801280 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	8b 00                	mov    (%eax),%eax
  80128b:	8d 48 01             	lea    0x1(%eax),%ecx
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	89 0a                	mov    %ecx,(%edx)
  801293:	8b 55 08             	mov    0x8(%ebp),%edx
  801296:	88 d1                	mov    %dl,%cl
  801298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80129f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8012a9:	75 2c                	jne    8012d7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8012ab:	a0 80 60 98 00       	mov    0x986080,%al
  8012b0:	0f b6 c0             	movzbl %al,%eax
  8012b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b6:	8b 12                	mov    (%edx),%edx
  8012b8:	89 d1                	mov    %edx,%ecx
  8012ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012bd:	83 c2 08             	add    $0x8,%edx
  8012c0:	83 ec 04             	sub    $0x4,%esp
  8012c3:	50                   	push   %eax
  8012c4:	51                   	push   %ecx
  8012c5:	52                   	push   %edx
  8012c6:	e8 19 15 00 00       	call   8027e4 <sys_cputs>
  8012cb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8012ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8012d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012da:	8b 40 04             	mov    0x4(%eax),%eax
  8012dd:	8d 50 01             	lea    0x1(%eax),%edx
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8012e6:	90                   	nop
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8012f2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8012f9:	00 00 00 
	b.cnt = 0;
  8012fc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801303:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801306:	ff 75 0c             	pushl  0xc(%ebp)
  801309:	ff 75 08             	pushl  0x8(%ebp)
  80130c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801312:	50                   	push   %eax
  801313:	68 80 12 80 00       	push   $0x801280
  801318:	e8 11 02 00 00       	call   80152e <vprintfmt>
  80131d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801320:	a0 80 60 98 00       	mov    0x986080,%al
  801325:	0f b6 c0             	movzbl %al,%eax
  801328:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80132e:	83 ec 04             	sub    $0x4,%esp
  801331:	50                   	push   %eax
  801332:	52                   	push   %edx
  801333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801339:	83 c0 08             	add    $0x8,%eax
  80133c:	50                   	push   %eax
  80133d:	e8 a2 14 00 00       	call   8027e4 <sys_cputs>
  801342:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801345:	c6 05 80 60 98 00 00 	movb   $0x0,0x986080
	return b.cnt;
  80134c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80135a:	c6 05 80 60 98 00 01 	movb   $0x1,0x986080
	va_start(ap, fmt);
  801361:	8d 45 0c             	lea    0xc(%ebp),%eax
  801364:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	83 ec 08             	sub    $0x8,%esp
  80136d:	ff 75 f4             	pushl  -0xc(%ebp)
  801370:	50                   	push   %eax
  801371:	e8 73 ff ff ff       	call   8012e9 <vcprintf>
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80137c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
  801384:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801387:	e8 9a 14 00 00       	call   802826 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80138c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80138f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	83 ec 08             	sub    $0x8,%esp
  801398:	ff 75 f4             	pushl  -0xc(%ebp)
  80139b:	50                   	push   %eax
  80139c:	e8 48 ff ff ff       	call   8012e9 <vcprintf>
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8013a7:	e8 94 14 00 00       	call   802840 <sys_unlock_cons>
	return cnt;
  8013ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	53                   	push   %ebx
  8013b5:	83 ec 14             	sub    $0x14,%esp
  8013b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013be:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8013c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8013c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8013cf:	77 55                	ja     801426 <printnum+0x75>
  8013d1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8013d4:	72 05                	jb     8013db <printnum+0x2a>
  8013d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013d9:	77 4b                	ja     801426 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8013db:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8013de:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8013e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8013e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e9:	52                   	push   %edx
  8013ea:	50                   	push   %eax
  8013eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8013ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8013f1:	e8 f2 2c 00 00       	call   8040e8 <__udivdi3>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	83 ec 04             	sub    $0x4,%esp
  8013fc:	ff 75 20             	pushl  0x20(%ebp)
  8013ff:	53                   	push   %ebx
  801400:	ff 75 18             	pushl  0x18(%ebp)
  801403:	52                   	push   %edx
  801404:	50                   	push   %eax
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	ff 75 08             	pushl  0x8(%ebp)
  80140b:	e8 a1 ff ff ff       	call   8013b1 <printnum>
  801410:	83 c4 20             	add    $0x20,%esp
  801413:	eb 1a                	jmp    80142f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	ff 75 20             	pushl  0x20(%ebp)
  80141e:	8b 45 08             	mov    0x8(%ebp),%eax
  801421:	ff d0                	call   *%eax
  801423:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801426:	ff 4d 1c             	decl   0x1c(%ebp)
  801429:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80142d:	7f e6                	jg     801415 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80142f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801432:	bb 00 00 00 00       	mov    $0x0,%ebx
  801437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143d:	53                   	push   %ebx
  80143e:	51                   	push   %ecx
  80143f:	52                   	push   %edx
  801440:	50                   	push   %eax
  801441:	e8 b2 2d 00 00       	call   8041f8 <__umoddi3>
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	05 d4 4f 80 00       	add    $0x804fd4,%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	ff 75 0c             	pushl  0xc(%ebp)
  801459:	50                   	push   %eax
  80145a:	8b 45 08             	mov    0x8(%ebp),%eax
  80145d:	ff d0                	call   *%eax
  80145f:	83 c4 10             	add    $0x10,%esp
}
  801462:	90                   	nop
  801463:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801466:	c9                   	leave  
  801467:	c3                   	ret    

00801468 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801468:	55                   	push   %ebp
  801469:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80146b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80146f:	7e 1c                	jle    80148d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8b 00                	mov    (%eax),%eax
  801476:	8d 50 08             	lea    0x8(%eax),%edx
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	89 10                	mov    %edx,(%eax)
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8b 00                	mov    (%eax),%eax
  801483:	83 e8 08             	sub    $0x8,%eax
  801486:	8b 50 04             	mov    0x4(%eax),%edx
  801489:	8b 00                	mov    (%eax),%eax
  80148b:	eb 40                	jmp    8014cd <getuint+0x65>
	else if (lflag)
  80148d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801491:	74 1e                	je     8014b1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8b 00                	mov    (%eax),%eax
  801498:	8d 50 04             	lea    0x4(%eax),%edx
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	89 10                	mov    %edx,(%eax)
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8b 00                	mov    (%eax),%eax
  8014a5:	83 e8 04             	sub    $0x4,%eax
  8014a8:	8b 00                	mov    (%eax),%eax
  8014aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014af:	eb 1c                	jmp    8014cd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8b 00                	mov    (%eax),%eax
  8014b6:	8d 50 04             	lea    0x4(%eax),%edx
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	89 10                	mov    %edx,(%eax)
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	8b 00                	mov    (%eax),%eax
  8014c3:	83 e8 04             	sub    $0x4,%eax
  8014c6:	8b 00                	mov    (%eax),%eax
  8014c8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8014cd:	5d                   	pop    %ebp
  8014ce:	c3                   	ret    

008014cf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8014d2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8014d6:	7e 1c                	jle    8014f4 <getint+0x25>
		return va_arg(*ap, long long);
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8b 00                	mov    (%eax),%eax
  8014dd:	8d 50 08             	lea    0x8(%eax),%edx
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	89 10                	mov    %edx,(%eax)
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8b 00                	mov    (%eax),%eax
  8014ea:	83 e8 08             	sub    $0x8,%eax
  8014ed:	8b 50 04             	mov    0x4(%eax),%edx
  8014f0:	8b 00                	mov    (%eax),%eax
  8014f2:	eb 38                	jmp    80152c <getint+0x5d>
	else if (lflag)
  8014f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f8:	74 1a                	je     801514 <getint+0x45>
		return va_arg(*ap, long);
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8b 00                	mov    (%eax),%eax
  8014ff:	8d 50 04             	lea    0x4(%eax),%edx
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	89 10                	mov    %edx,(%eax)
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	83 e8 04             	sub    $0x4,%eax
  80150f:	8b 00                	mov    (%eax),%eax
  801511:	99                   	cltd   
  801512:	eb 18                	jmp    80152c <getint+0x5d>
	else
		return va_arg(*ap, int);
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8b 00                	mov    (%eax),%eax
  801519:	8d 50 04             	lea    0x4(%eax),%edx
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	89 10                	mov    %edx,(%eax)
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8b 00                	mov    (%eax),%eax
  801526:	83 e8 04             	sub    $0x4,%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	99                   	cltd   
}
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    

0080152e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	56                   	push   %esi
  801532:	53                   	push   %ebx
  801533:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801536:	eb 17                	jmp    80154f <vprintfmt+0x21>
			if (ch == '\0')
  801538:	85 db                	test   %ebx,%ebx
  80153a:	0f 84 c1 03 00 00    	je     801901 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	ff 75 0c             	pushl  0xc(%ebp)
  801546:	53                   	push   %ebx
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	ff d0                	call   *%eax
  80154c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80154f:	8b 45 10             	mov    0x10(%ebp),%eax
  801552:	8d 50 01             	lea    0x1(%eax),%edx
  801555:	89 55 10             	mov    %edx,0x10(%ebp)
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d8             	movzbl %al,%ebx
  80155d:	83 fb 25             	cmp    $0x25,%ebx
  801560:	75 d6                	jne    801538 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801562:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801566:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80156d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801574:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80157b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801582:	8b 45 10             	mov    0x10(%ebp),%eax
  801585:	8d 50 01             	lea    0x1(%eax),%edx
  801588:	89 55 10             	mov    %edx,0x10(%ebp)
  80158b:	8a 00                	mov    (%eax),%al
  80158d:	0f b6 d8             	movzbl %al,%ebx
  801590:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801593:	83 f8 5b             	cmp    $0x5b,%eax
  801596:	0f 87 3d 03 00 00    	ja     8018d9 <vprintfmt+0x3ab>
  80159c:	8b 04 85 f8 4f 80 00 	mov    0x804ff8(,%eax,4),%eax
  8015a3:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8015a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8015a9:	eb d7                	jmp    801582 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8015ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8015af:	eb d1                	jmp    801582 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8015b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015bb:	89 d0                	mov    %edx,%eax
  8015bd:	c1 e0 02             	shl    $0x2,%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	01 c0                	add    %eax,%eax
  8015c4:	01 d8                	add    %ebx,%eax
  8015c6:	83 e8 30             	sub    $0x30,%eax
  8015c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8015cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cf:	8a 00                	mov    (%eax),%al
  8015d1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8015d4:	83 fb 2f             	cmp    $0x2f,%ebx
  8015d7:	7e 3e                	jle    801617 <vprintfmt+0xe9>
  8015d9:	83 fb 39             	cmp    $0x39,%ebx
  8015dc:	7f 39                	jg     801617 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8015de:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8015e1:	eb d5                	jmp    8015b8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8015e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e6:	83 c0 04             	add    $0x4,%eax
  8015e9:	89 45 14             	mov    %eax,0x14(%ebp)
  8015ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ef:	83 e8 04             	sub    $0x4,%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8015f7:	eb 1f                	jmp    801618 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8015f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015fd:	79 83                	jns    801582 <vprintfmt+0x54>
				width = 0;
  8015ff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801606:	e9 77 ff ff ff       	jmp    801582 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80160b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801612:	e9 6b ff ff ff       	jmp    801582 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801617:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80161c:	0f 89 60 ff ff ff    	jns    801582 <vprintfmt+0x54>
				width = precision, precision = -1;
  801622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801625:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801628:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80162f:	e9 4e ff ff ff       	jmp    801582 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801634:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801637:	e9 46 ff ff ff       	jmp    801582 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	83 c0 04             	add    $0x4,%eax
  801642:	89 45 14             	mov    %eax,0x14(%ebp)
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	83 e8 04             	sub    $0x4,%eax
  80164b:	8b 00                	mov    (%eax),%eax
  80164d:	83 ec 08             	sub    $0x8,%esp
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	50                   	push   %eax
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	ff d0                	call   *%eax
  801659:	83 c4 10             	add    $0x10,%esp
			break;
  80165c:	e9 9b 02 00 00       	jmp    8018fc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801661:	8b 45 14             	mov    0x14(%ebp),%eax
  801664:	83 c0 04             	add    $0x4,%eax
  801667:	89 45 14             	mov    %eax,0x14(%ebp)
  80166a:	8b 45 14             	mov    0x14(%ebp),%eax
  80166d:	83 e8 04             	sub    $0x4,%eax
  801670:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801672:	85 db                	test   %ebx,%ebx
  801674:	79 02                	jns    801678 <vprintfmt+0x14a>
				err = -err;
  801676:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801678:	83 fb 64             	cmp    $0x64,%ebx
  80167b:	7f 0b                	jg     801688 <vprintfmt+0x15a>
  80167d:	8b 34 9d 40 4e 80 00 	mov    0x804e40(,%ebx,4),%esi
  801684:	85 f6                	test   %esi,%esi
  801686:	75 19                	jne    8016a1 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801688:	53                   	push   %ebx
  801689:	68 e5 4f 80 00       	push   $0x804fe5
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	e8 70 02 00 00       	call   801909 <printfmt>
  801699:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80169c:	e9 5b 02 00 00       	jmp    8018fc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8016a1:	56                   	push   %esi
  8016a2:	68 ee 4f 80 00       	push   $0x804fee
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	ff 75 08             	pushl  0x8(%ebp)
  8016ad:	e8 57 02 00 00       	call   801909 <printfmt>
  8016b2:	83 c4 10             	add    $0x10,%esp
			break;
  8016b5:	e9 42 02 00 00       	jmp    8018fc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8016ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bd:	83 c0 04             	add    $0x4,%eax
  8016c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8016c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c6:	83 e8 04             	sub    $0x4,%eax
  8016c9:	8b 30                	mov    (%eax),%esi
  8016cb:	85 f6                	test   %esi,%esi
  8016cd:	75 05                	jne    8016d4 <vprintfmt+0x1a6>
				p = "(null)";
  8016cf:	be f1 4f 80 00       	mov    $0x804ff1,%esi
			if (width > 0 && padc != '-')
  8016d4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016d8:	7e 6d                	jle    801747 <vprintfmt+0x219>
  8016da:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8016de:	74 67                	je     801747 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8016e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	50                   	push   %eax
  8016e7:	56                   	push   %esi
  8016e8:	e8 1e 03 00 00       	call   801a0b <strnlen>
  8016ed:	83 c4 10             	add    $0x10,%esp
  8016f0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8016f3:	eb 16                	jmp    80170b <vprintfmt+0x1dd>
					putch(padc, putdat);
  8016f5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8016f9:	83 ec 08             	sub    $0x8,%esp
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	50                   	push   %eax
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	ff d0                	call   *%eax
  801705:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801708:	ff 4d e4             	decl   -0x1c(%ebp)
  80170b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80170f:	7f e4                	jg     8016f5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801711:	eb 34                	jmp    801747 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801713:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801717:	74 1c                	je     801735 <vprintfmt+0x207>
  801719:	83 fb 1f             	cmp    $0x1f,%ebx
  80171c:	7e 05                	jle    801723 <vprintfmt+0x1f5>
  80171e:	83 fb 7e             	cmp    $0x7e,%ebx
  801721:	7e 12                	jle    801735 <vprintfmt+0x207>
					putch('?', putdat);
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	6a 3f                	push   $0x3f
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	ff d0                	call   *%eax
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	eb 0f                	jmp    801744 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801735:	83 ec 08             	sub    $0x8,%esp
  801738:	ff 75 0c             	pushl  0xc(%ebp)
  80173b:	53                   	push   %ebx
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	ff d0                	call   *%eax
  801741:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801744:	ff 4d e4             	decl   -0x1c(%ebp)
  801747:	89 f0                	mov    %esi,%eax
  801749:	8d 70 01             	lea    0x1(%eax),%esi
  80174c:	8a 00                	mov    (%eax),%al
  80174e:	0f be d8             	movsbl %al,%ebx
  801751:	85 db                	test   %ebx,%ebx
  801753:	74 24                	je     801779 <vprintfmt+0x24b>
  801755:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801759:	78 b8                	js     801713 <vprintfmt+0x1e5>
  80175b:	ff 4d e0             	decl   -0x20(%ebp)
  80175e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801762:	79 af                	jns    801713 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801764:	eb 13                	jmp    801779 <vprintfmt+0x24b>
				putch(' ', putdat);
  801766:	83 ec 08             	sub    $0x8,%esp
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	6a 20                	push   $0x20
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	ff d0                	call   *%eax
  801773:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801776:	ff 4d e4             	decl   -0x1c(%ebp)
  801779:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80177d:	7f e7                	jg     801766 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80177f:	e9 78 01 00 00       	jmp    8018fc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801784:	83 ec 08             	sub    $0x8,%esp
  801787:	ff 75 e8             	pushl  -0x18(%ebp)
  80178a:	8d 45 14             	lea    0x14(%ebp),%eax
  80178d:	50                   	push   %eax
  80178e:	e8 3c fd ff ff       	call   8014cf <getint>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801799:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80179c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a2:	85 d2                	test   %edx,%edx
  8017a4:	79 23                	jns    8017c9 <vprintfmt+0x29b>
				putch('-', putdat);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	6a 2d                	push   $0x2d
  8017ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b1:	ff d0                	call   *%eax
  8017b3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8017b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017bc:	f7 d8                	neg    %eax
  8017be:	83 d2 00             	adc    $0x0,%edx
  8017c1:	f7 da                	neg    %edx
  8017c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8017c9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8017d0:	e9 bc 00 00 00       	jmp    801891 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8017d5:	83 ec 08             	sub    $0x8,%esp
  8017d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8017db:	8d 45 14             	lea    0x14(%ebp),%eax
  8017de:	50                   	push   %eax
  8017df:	e8 84 fc ff ff       	call   801468 <getuint>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8017ed:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8017f4:	e9 98 00 00 00       	jmp    801891 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	ff 75 0c             	pushl  0xc(%ebp)
  8017ff:	6a 58                	push   $0x58
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	ff d0                	call   *%eax
  801806:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801809:	83 ec 08             	sub    $0x8,%esp
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	6a 58                	push   $0x58
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	ff d0                	call   *%eax
  801816:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	ff 75 0c             	pushl  0xc(%ebp)
  80181f:	6a 58                	push   $0x58
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	ff d0                	call   *%eax
  801826:	83 c4 10             	add    $0x10,%esp
			break;
  801829:	e9 ce 00 00 00       	jmp    8018fc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80182e:	83 ec 08             	sub    $0x8,%esp
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	6a 30                	push   $0x30
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	ff d0                	call   *%eax
  80183b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	ff 75 0c             	pushl  0xc(%ebp)
  801844:	6a 78                	push   $0x78
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	ff d0                	call   *%eax
  80184b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80184e:	8b 45 14             	mov    0x14(%ebp),%eax
  801851:	83 c0 04             	add    $0x4,%eax
  801854:	89 45 14             	mov    %eax,0x14(%ebp)
  801857:	8b 45 14             	mov    0x14(%ebp),%eax
  80185a:	83 e8 04             	sub    $0x4,%eax
  80185d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80185f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801862:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801869:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801870:	eb 1f                	jmp    801891 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801872:	83 ec 08             	sub    $0x8,%esp
  801875:	ff 75 e8             	pushl  -0x18(%ebp)
  801878:	8d 45 14             	lea    0x14(%ebp),%eax
  80187b:	50                   	push   %eax
  80187c:	e8 e7 fb ff ff       	call   801468 <getuint>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801887:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80188a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801891:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801895:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801898:	83 ec 04             	sub    $0x4,%esp
  80189b:	52                   	push   %edx
  80189c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80189f:	50                   	push   %eax
  8018a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8018a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a6:	ff 75 0c             	pushl  0xc(%ebp)
  8018a9:	ff 75 08             	pushl  0x8(%ebp)
  8018ac:	e8 00 fb ff ff       	call   8013b1 <printnum>
  8018b1:	83 c4 20             	add    $0x20,%esp
			break;
  8018b4:	eb 46                	jmp    8018fc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8018b6:	83 ec 08             	sub    $0x8,%esp
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	53                   	push   %ebx
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	ff d0                	call   *%eax
  8018c2:	83 c4 10             	add    $0x10,%esp
			break;
  8018c5:	eb 35                	jmp    8018fc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8018c7:	c6 05 80 60 98 00 00 	movb   $0x0,0x986080
			break;
  8018ce:	eb 2c                	jmp    8018fc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8018d0:	c6 05 80 60 98 00 01 	movb   $0x1,0x986080
			break;
  8018d7:	eb 23                	jmp    8018fc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8018d9:	83 ec 08             	sub    $0x8,%esp
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	6a 25                	push   $0x25
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	ff d0                	call   *%eax
  8018e6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018e9:	ff 4d 10             	decl   0x10(%ebp)
  8018ec:	eb 03                	jmp    8018f1 <vprintfmt+0x3c3>
  8018ee:	ff 4d 10             	decl   0x10(%ebp)
  8018f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f4:	48                   	dec    %eax
  8018f5:	8a 00                	mov    (%eax),%al
  8018f7:	3c 25                	cmp    $0x25,%al
  8018f9:	75 f3                	jne    8018ee <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8018fb:	90                   	nop
		}
	}
  8018fc:	e9 35 fc ff ff       	jmp    801536 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801901:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801902:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801905:	5b                   	pop    %ebx
  801906:	5e                   	pop    %esi
  801907:	5d                   	pop    %ebp
  801908:	c3                   	ret    

00801909 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80190f:	8d 45 10             	lea    0x10(%ebp),%eax
  801912:	83 c0 04             	add    $0x4,%eax
  801915:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801918:	8b 45 10             	mov    0x10(%ebp),%eax
  80191b:	ff 75 f4             	pushl  -0xc(%ebp)
  80191e:	50                   	push   %eax
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	e8 04 fc ff ff       	call   80152e <vprintfmt>
  80192a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80192d:	90                   	nop
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801933:	8b 45 0c             	mov    0xc(%ebp),%eax
  801936:	8b 40 08             	mov    0x8(%eax),%eax
  801939:	8d 50 01             	lea    0x1(%eax),%edx
  80193c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801942:	8b 45 0c             	mov    0xc(%ebp),%eax
  801945:	8b 10                	mov    (%eax),%edx
  801947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80194a:	8b 40 04             	mov    0x4(%eax),%eax
  80194d:	39 c2                	cmp    %eax,%edx
  80194f:	73 12                	jae    801963 <sprintputch+0x33>
		*b->buf++ = ch;
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	8b 00                	mov    (%eax),%eax
  801956:	8d 48 01             	lea    0x1(%eax),%ecx
  801959:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195c:	89 0a                	mov    %ecx,(%edx)
  80195e:	8b 55 08             	mov    0x8(%ebp),%edx
  801961:	88 10                	mov    %dl,(%eax)
}
  801963:	90                   	nop
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80196c:	8b 45 08             	mov    0x8(%ebp),%eax
  80196f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801972:	8b 45 0c             	mov    0xc(%ebp),%eax
  801975:	8d 50 ff             	lea    -0x1(%eax),%edx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	01 d0                	add    %edx,%eax
  80197d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801980:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801987:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80198b:	74 06                	je     801993 <vsnprintf+0x2d>
  80198d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801991:	7f 07                	jg     80199a <vsnprintf+0x34>
		return -E_INVAL;
  801993:	b8 03 00 00 00       	mov    $0x3,%eax
  801998:	eb 20                	jmp    8019ba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80199a:	ff 75 14             	pushl  0x14(%ebp)
  80199d:	ff 75 10             	pushl  0x10(%ebp)
  8019a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8019a3:	50                   	push   %eax
  8019a4:	68 30 19 80 00       	push   $0x801930
  8019a9:	e8 80 fb ff ff       	call   80152e <vprintfmt>
  8019ae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8019b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
  8019bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8019c2:	8d 45 10             	lea    0x10(%ebp),%eax
  8019c5:	83 c0 04             	add    $0x4,%eax
  8019c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8019cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d1:	50                   	push   %eax
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	e8 89 ff ff ff       	call   801966 <vsnprintf>
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8019e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8019ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019f5:	eb 06                	jmp    8019fd <strlen+0x15>
		n++;
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8019fa:	ff 45 08             	incl   0x8(%ebp)
  8019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801a00:	8a 00                	mov    (%eax),%al
  801a02:	84 c0                	test   %al,%al
  801a04:	75 f1                	jne    8019f7 <strlen+0xf>
		n++;
	return n;
  801a06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a18:	eb 09                	jmp    801a23 <strnlen+0x18>
		n++;
  801a1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801a1d:	ff 45 08             	incl   0x8(%ebp)
  801a20:	ff 4d 0c             	decl   0xc(%ebp)
  801a23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a27:	74 09                	je     801a32 <strnlen+0x27>
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	8a 00                	mov    (%eax),%al
  801a2e:	84 c0                	test   %al,%al
  801a30:	75 e8                	jne    801a1a <strnlen+0xf>
		n++;
	return n;
  801a32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801a43:	90                   	nop
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	8d 50 01             	lea    0x1(%eax),%edx
  801a4a:	89 55 08             	mov    %edx,0x8(%ebp)
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801a56:	8a 12                	mov    (%edx),%dl
  801a58:	88 10                	mov    %dl,(%eax)
  801a5a:	8a 00                	mov    (%eax),%al
  801a5c:	84 c0                	test   %al,%al
  801a5e:	75 e4                	jne    801a44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801a60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801a71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a78:	eb 1f                	jmp    801a99 <strncpy+0x34>
		*dst++ = *src;
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8d 50 01             	lea    0x1(%eax),%edx
  801a80:	89 55 08             	mov    %edx,0x8(%ebp)
  801a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a86:	8a 12                	mov    (%edx),%dl
  801a88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8d:	8a 00                	mov    (%eax),%al
  801a8f:	84 c0                	test   %al,%al
  801a91:	74 03                	je     801a96 <strncpy+0x31>
			src++;
  801a93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a96:	ff 45 fc             	incl   -0x4(%ebp)
  801a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a9f:	72 d9                	jb     801a7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801ab2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ab6:	74 30                	je     801ae8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801ab8:	eb 16                	jmp    801ad0 <strlcpy+0x2a>
			*dst++ = *src++;
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	8d 50 01             	lea    0x1(%eax),%edx
  801ac0:	89 55 08             	mov    %edx,0x8(%ebp)
  801ac3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac6:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ac9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801acc:	8a 12                	mov    (%edx),%dl
  801ace:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801ad0:	ff 4d 10             	decl   0x10(%ebp)
  801ad3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad7:	74 09                	je     801ae2 <strlcpy+0x3c>
  801ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adc:	8a 00                	mov    (%eax),%al
  801ade:	84 c0                	test   %al,%al
  801ae0:	75 d8                	jne    801aba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801ae8:	8b 55 08             	mov    0x8(%ebp),%edx
  801aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801aee:	29 c2                	sub    %eax,%edx
  801af0:	89 d0                	mov    %edx,%eax
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801af7:	eb 06                	jmp    801aff <strcmp+0xb>
		p++, q++;
  801af9:	ff 45 08             	incl   0x8(%ebp)
  801afc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	8a 00                	mov    (%eax),%al
  801b04:	84 c0                	test   %al,%al
  801b06:	74 0e                	je     801b16 <strcmp+0x22>
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	8a 10                	mov    (%eax),%dl
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	8a 00                	mov    (%eax),%al
  801b12:	38 c2                	cmp    %al,%dl
  801b14:	74 e3                	je     801af9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	0f b6 d0             	movzbl %al,%edx
  801b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b21:	8a 00                	mov    (%eax),%al
  801b23:	0f b6 c0             	movzbl %al,%eax
  801b26:	29 c2                	sub    %eax,%edx
  801b28:	89 d0                	mov    %edx,%eax
}
  801b2a:	5d                   	pop    %ebp
  801b2b:	c3                   	ret    

00801b2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801b2f:	eb 09                	jmp    801b3a <strncmp+0xe>
		n--, p++, q++;
  801b31:	ff 4d 10             	decl   0x10(%ebp)
  801b34:	ff 45 08             	incl   0x8(%ebp)
  801b37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801b3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b3e:	74 17                	je     801b57 <strncmp+0x2b>
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	8a 00                	mov    (%eax),%al
  801b45:	84 c0                	test   %al,%al
  801b47:	74 0e                	je     801b57 <strncmp+0x2b>
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	8a 10                	mov    (%eax),%dl
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	8a 00                	mov    (%eax),%al
  801b53:	38 c2                	cmp    %al,%dl
  801b55:	74 da                	je     801b31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801b57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b5b:	75 07                	jne    801b64 <strncmp+0x38>
		return 0;
  801b5d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b62:	eb 14                	jmp    801b78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	0f b6 d0             	movzbl %al,%edx
  801b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6f:	8a 00                	mov    (%eax),%al
  801b71:	0f b6 c0             	movzbl %al,%eax
  801b74:	29 c2                	sub    %eax,%edx
  801b76:	89 d0                	mov    %edx,%eax
}
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    

00801b7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801b86:	eb 12                	jmp    801b9a <strchr+0x20>
		if (*s == c)
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	8a 00                	mov    (%eax),%al
  801b8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801b90:	75 05                	jne    801b97 <strchr+0x1d>
			return (char *) s;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	eb 11                	jmp    801ba8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b97:	ff 45 08             	incl   0x8(%ebp)
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	84 c0                	test   %al,%al
  801ba1:	75 e5                	jne    801b88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801ba3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	83 ec 04             	sub    $0x4,%esp
  801bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801bb6:	eb 0d                	jmp    801bc5 <strfind+0x1b>
		if (*s == c)
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	8a 00                	mov    (%eax),%al
  801bbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801bc0:	74 0e                	je     801bd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801bc2:	ff 45 08             	incl   0x8(%ebp)
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	8a 00                	mov    (%eax),%al
  801bca:	84 c0                	test   %al,%al
  801bcc:	75 ea                	jne    801bb8 <strfind+0xe>
  801bce:	eb 01                	jmp    801bd1 <strfind+0x27>
		if (*s == c)
			break;
  801bd0:	90                   	nop
	return (char *) s;
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801be2:	8b 45 10             	mov    0x10(%ebp),%eax
  801be5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801be8:	eb 0e                	jmp    801bf8 <memset+0x22>
		*p++ = c;
  801bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bed:	8d 50 01             	lea    0x1(%eax),%edx
  801bf0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801bf8:	ff 4d f8             	decl   -0x8(%ebp)
  801bfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801bff:	79 e9                	jns    801bea <memset+0x14>
		*p++ = c;

	return v;
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801c18:	eb 16                	jmp    801c30 <memcpy+0x2a>
		*d++ = *s++;
  801c1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1d:	8d 50 01             	lea    0x1(%eax),%edx
  801c20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c26:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801c2c:	8a 12                	mov    (%edx),%dl
  801c2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801c30:	8b 45 10             	mov    0x10(%ebp),%eax
  801c33:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c36:	89 55 10             	mov    %edx,0x10(%ebp)
  801c39:	85 c0                	test   %eax,%eax
  801c3b:	75 dd                	jne    801c1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c5a:	73 50                	jae    801cac <memmove+0x6a>
  801c5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c62:	01 d0                	add    %edx,%eax
  801c64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801c67:	76 43                	jbe    801cac <memmove+0x6a>
		s += n;
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801c6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801c75:	eb 10                	jmp    801c87 <memmove+0x45>
			*--d = *--s;
  801c77:	ff 4d f8             	decl   -0x8(%ebp)
  801c7a:	ff 4d fc             	decl   -0x4(%ebp)
  801c7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c80:	8a 10                	mov    (%eax),%dl
  801c82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801c87:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801c8d:	89 55 10             	mov    %edx,0x10(%ebp)
  801c90:	85 c0                	test   %eax,%eax
  801c92:	75 e3                	jne    801c77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801c94:	eb 23                	jmp    801cb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801c96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c99:	8d 50 01             	lea    0x1(%eax),%edx
  801c9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801c9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ca5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ca8:	8a 12                	mov    (%edx),%dl
  801caa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801cac:	8b 45 10             	mov    0x10(%ebp),%eax
  801caf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cb2:	89 55 10             	mov    %edx,0x10(%ebp)
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	75 dd                	jne    801c96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801cd0:	eb 2a                	jmp    801cfc <memcmp+0x3e>
		if (*s1 != *s2)
  801cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cd5:	8a 10                	mov    (%eax),%dl
  801cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cda:	8a 00                	mov    (%eax),%al
  801cdc:	38 c2                	cmp    %al,%dl
  801cde:	74 16                	je     801cf6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801ce0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ce3:	8a 00                	mov    (%eax),%al
  801ce5:	0f b6 d0             	movzbl %al,%edx
  801ce8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ceb:	8a 00                	mov    (%eax),%al
  801ced:	0f b6 c0             	movzbl %al,%eax
  801cf0:	29 c2                	sub    %eax,%edx
  801cf2:	89 d0                	mov    %edx,%eax
  801cf4:	eb 18                	jmp    801d0e <memcmp+0x50>
		s1++, s2++;
  801cf6:	ff 45 fc             	incl   -0x4(%ebp)
  801cf9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801cfc:	8b 45 10             	mov    0x10(%ebp),%eax
  801cff:	8d 50 ff             	lea    -0x1(%eax),%edx
  801d02:	89 55 10             	mov    %edx,0x10(%ebp)
  801d05:	85 c0                	test   %eax,%eax
  801d07:	75 c9                	jne    801cd2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801d16:	8b 55 08             	mov    0x8(%ebp),%edx
  801d19:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1c:	01 d0                	add    %edx,%eax
  801d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801d21:	eb 15                	jmp    801d38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	8a 00                	mov    (%eax),%al
  801d28:	0f b6 d0             	movzbl %al,%edx
  801d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2e:	0f b6 c0             	movzbl %al,%eax
  801d31:	39 c2                	cmp    %eax,%edx
  801d33:	74 0d                	je     801d42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801d35:	ff 45 08             	incl   0x8(%ebp)
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801d3e:	72 e3                	jb     801d23 <memfind+0x13>
  801d40:	eb 01                	jmp    801d43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801d42:	90                   	nop
	return (void *) s;
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801d4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801d55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d5c:	eb 03                	jmp    801d61 <strtol+0x19>
		s++;
  801d5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	8a 00                	mov    (%eax),%al
  801d66:	3c 20                	cmp    $0x20,%al
  801d68:	74 f4                	je     801d5e <strtol+0x16>
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	8a 00                	mov    (%eax),%al
  801d6f:	3c 09                	cmp    $0x9,%al
  801d71:	74 eb                	je     801d5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	8a 00                	mov    (%eax),%al
  801d78:	3c 2b                	cmp    $0x2b,%al
  801d7a:	75 05                	jne    801d81 <strtol+0x39>
		s++;
  801d7c:	ff 45 08             	incl   0x8(%ebp)
  801d7f:	eb 13                	jmp    801d94 <strtol+0x4c>
	else if (*s == '-')
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	8a 00                	mov    (%eax),%al
  801d86:	3c 2d                	cmp    $0x2d,%al
  801d88:	75 0a                	jne    801d94 <strtol+0x4c>
		s++, neg = 1;
  801d8a:	ff 45 08             	incl   0x8(%ebp)
  801d8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801d94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d98:	74 06                	je     801da0 <strtol+0x58>
  801d9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801d9e:	75 20                	jne    801dc0 <strtol+0x78>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	3c 30                	cmp    $0x30,%al
  801da7:	75 17                	jne    801dc0 <strtol+0x78>
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	40                   	inc    %eax
  801dad:	8a 00                	mov    (%eax),%al
  801daf:	3c 78                	cmp    $0x78,%al
  801db1:	75 0d                	jne    801dc0 <strtol+0x78>
		s += 2, base = 16;
  801db3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801db7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801dbe:	eb 28                	jmp    801de8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801dc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801dc4:	75 15                	jne    801ddb <strtol+0x93>
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	8a 00                	mov    (%eax),%al
  801dcb:	3c 30                	cmp    $0x30,%al
  801dcd:	75 0c                	jne    801ddb <strtol+0x93>
		s++, base = 8;
  801dcf:	ff 45 08             	incl   0x8(%ebp)
  801dd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801dd9:	eb 0d                	jmp    801de8 <strtol+0xa0>
	else if (base == 0)
  801ddb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ddf:	75 07                	jne    801de8 <strtol+0xa0>
		base = 10;
  801de1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	8a 00                	mov    (%eax),%al
  801ded:	3c 2f                	cmp    $0x2f,%al
  801def:	7e 19                	jle    801e0a <strtol+0xc2>
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8a 00                	mov    (%eax),%al
  801df6:	3c 39                	cmp    $0x39,%al
  801df8:	7f 10                	jg     801e0a <strtol+0xc2>
			dig = *s - '0';
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	8a 00                	mov    (%eax),%al
  801dff:	0f be c0             	movsbl %al,%eax
  801e02:	83 e8 30             	sub    $0x30,%eax
  801e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e08:	eb 42                	jmp    801e4c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	8a 00                	mov    (%eax),%al
  801e0f:	3c 60                	cmp    $0x60,%al
  801e11:	7e 19                	jle    801e2c <strtol+0xe4>
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	8a 00                	mov    (%eax),%al
  801e18:	3c 7a                	cmp    $0x7a,%al
  801e1a:	7f 10                	jg     801e2c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	8a 00                	mov    (%eax),%al
  801e21:	0f be c0             	movsbl %al,%eax
  801e24:	83 e8 57             	sub    $0x57,%eax
  801e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2a:	eb 20                	jmp    801e4c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	8a 00                	mov    (%eax),%al
  801e31:	3c 40                	cmp    $0x40,%al
  801e33:	7e 39                	jle    801e6e <strtol+0x126>
  801e35:	8b 45 08             	mov    0x8(%ebp),%eax
  801e38:	8a 00                	mov    (%eax),%al
  801e3a:	3c 5a                	cmp    $0x5a,%al
  801e3c:	7f 30                	jg     801e6e <strtol+0x126>
			dig = *s - 'A' + 10;
  801e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e41:	8a 00                	mov    (%eax),%al
  801e43:	0f be c0             	movsbl %al,%eax
  801e46:	83 e8 37             	sub    $0x37,%eax
  801e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e52:	7d 19                	jge    801e6d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801e54:	ff 45 08             	incl   0x8(%ebp)
  801e57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801e5e:	89 c2                	mov    %eax,%edx
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	01 d0                	add    %edx,%eax
  801e65:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801e68:	e9 7b ff ff ff       	jmp    801de8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801e6d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801e6e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e72:	74 08                	je     801e7c <strtol+0x134>
		*endptr = (char *) s;
  801e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e77:	8b 55 08             	mov    0x8(%ebp),%edx
  801e7a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801e7c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801e80:	74 07                	je     801e89 <strtol+0x141>
  801e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e85:	f7 d8                	neg    %eax
  801e87:	eb 03                	jmp    801e8c <strtol+0x144>
  801e89:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <ltostr>:

void
ltostr(long value, char *str)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801e94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801e9b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea6:	79 13                	jns    801ebb <ltostr+0x2d>
	{
		neg = 1;
  801ea8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801eb5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801eb8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801ec3:	99                   	cltd   
  801ec4:	f7 f9                	idiv   %ecx
  801ec6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801ec9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ecc:	8d 50 01             	lea    0x1(%eax),%edx
  801ecf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ed2:	89 c2                	mov    %eax,%edx
  801ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed7:	01 d0                	add    %edx,%eax
  801ed9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801edc:	83 c2 30             	add    $0x30,%edx
  801edf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ee1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ee9:	f7 e9                	imul   %ecx
  801eeb:	c1 fa 02             	sar    $0x2,%edx
  801eee:	89 c8                	mov    %ecx,%eax
  801ef0:	c1 f8 1f             	sar    $0x1f,%eax
  801ef3:	29 c2                	sub    %eax,%edx
  801ef5:	89 d0                	mov    %edx,%eax
  801ef7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801efa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801efe:	75 bb                	jne    801ebb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801f00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f0a:	48                   	dec    %eax
  801f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801f0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801f12:	74 3d                	je     801f51 <ltostr+0xc3>
		start = 1 ;
  801f14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801f1b:	eb 34                	jmp    801f51 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801f1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f23:	01 d0                	add    %edx,%eax
  801f25:	8a 00                	mov    (%eax),%al
  801f27:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801f2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f30:	01 c2                	add    %eax,%edx
  801f32:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f38:	01 c8                	add    %ecx,%eax
  801f3a:	8a 00                	mov    (%eax),%al
  801f3c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801f3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f44:	01 c2                	add    %eax,%edx
  801f46:	8a 45 eb             	mov    -0x15(%ebp),%al
  801f49:	88 02                	mov    %al,(%edx)
		start++ ;
  801f4b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801f4e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801f57:	7c c4                	jl     801f1d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801f59:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5f:	01 d0                	add    %edx,%eax
  801f61:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801f64:	90                   	nop
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	e8 73 fa ff ff       	call   8019e8 <strlen>
  801f75:	83 c4 04             	add    $0x4,%esp
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801f7b:	ff 75 0c             	pushl  0xc(%ebp)
  801f7e:	e8 65 fa ff ff       	call   8019e8 <strlen>
  801f83:	83 c4 04             	add    $0x4,%esp
  801f86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801f89:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801f90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f97:	eb 17                	jmp    801fb0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801f99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9f:	01 c2                	add    %eax,%edx
  801fa1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	01 c8                	add    %ecx,%eax
  801fa9:	8a 00                	mov    (%eax),%al
  801fab:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801fad:	ff 45 fc             	incl   -0x4(%ebp)
  801fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801fb6:	7c e1                	jl     801f99 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801fbf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801fc6:	eb 1f                	jmp    801fe7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	8d 50 01             	lea    0x1(%eax),%edx
  801fce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801fd1:	89 c2                	mov    %eax,%edx
  801fd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd6:	01 c2                	add    %eax,%edx
  801fd8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801fdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fde:	01 c8                	add    %ecx,%eax
  801fe0:	8a 00                	mov    (%eax),%al
  801fe2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801fe4:	ff 45 f8             	incl   -0x8(%ebp)
  801fe7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801fea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801fed:	7c d9                	jl     801fc8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801fef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff5:	01 d0                	add    %edx,%eax
  801ff7:	c6 00 00             	movb   $0x0,(%eax)
}
  801ffa:	90                   	nop
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802000:	8b 45 14             	mov    0x14(%ebp),%eax
  802003:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802009:	8b 45 14             	mov    0x14(%ebp),%eax
  80200c:	8b 00                	mov    (%eax),%eax
  80200e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802015:	8b 45 10             	mov    0x10(%ebp),%eax
  802018:	01 d0                	add    %edx,%eax
  80201a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802020:	eb 0c                	jmp    80202e <strsplit+0x31>
			*string++ = 0;
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	8d 50 01             	lea    0x1(%eax),%edx
  802028:	89 55 08             	mov    %edx,0x8(%ebp)
  80202b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	8a 00                	mov    (%eax),%al
  802033:	84 c0                	test   %al,%al
  802035:	74 18                	je     80204f <strsplit+0x52>
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	8a 00                	mov    (%eax),%al
  80203c:	0f be c0             	movsbl %al,%eax
  80203f:	50                   	push   %eax
  802040:	ff 75 0c             	pushl  0xc(%ebp)
  802043:	e8 32 fb ff ff       	call   801b7a <strchr>
  802048:	83 c4 08             	add    $0x8,%esp
  80204b:	85 c0                	test   %eax,%eax
  80204d:	75 d3                	jne    802022 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80204f:	8b 45 08             	mov    0x8(%ebp),%eax
  802052:	8a 00                	mov    (%eax),%al
  802054:	84 c0                	test   %al,%al
  802056:	74 5a                	je     8020b2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802058:	8b 45 14             	mov    0x14(%ebp),%eax
  80205b:	8b 00                	mov    (%eax),%eax
  80205d:	83 f8 0f             	cmp    $0xf,%eax
  802060:	75 07                	jne    802069 <strsplit+0x6c>
		{
			return 0;
  802062:	b8 00 00 00 00       	mov    $0x0,%eax
  802067:	eb 66                	jmp    8020cf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802069:	8b 45 14             	mov    0x14(%ebp),%eax
  80206c:	8b 00                	mov    (%eax),%eax
  80206e:	8d 48 01             	lea    0x1(%eax),%ecx
  802071:	8b 55 14             	mov    0x14(%ebp),%edx
  802074:	89 0a                	mov    %ecx,(%edx)
  802076:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80207d:	8b 45 10             	mov    0x10(%ebp),%eax
  802080:	01 c2                	add    %eax,%edx
  802082:	8b 45 08             	mov    0x8(%ebp),%eax
  802085:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802087:	eb 03                	jmp    80208c <strsplit+0x8f>
			string++;
  802089:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	8a 00                	mov    (%eax),%al
  802091:	84 c0                	test   %al,%al
  802093:	74 8b                	je     802020 <strsplit+0x23>
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8a 00                	mov    (%eax),%al
  80209a:	0f be c0             	movsbl %al,%eax
  80209d:	50                   	push   %eax
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	e8 d4 fa ff ff       	call   801b7a <strchr>
  8020a6:	83 c4 08             	add    $0x8,%esp
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	74 dc                	je     802089 <strsplit+0x8c>
			string++;
	}
  8020ad:	e9 6e ff ff ff       	jmp    802020 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8020b2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8020b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8020bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c2:	01 d0                	add    %edx,%eax
  8020c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8020ca:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 68 51 80 00       	push   $0x805168
  8020df:	68 3f 01 00 00       	push   $0x13f
  8020e4:	68 8a 51 80 00       	push   $0x80518a
  8020e9:	e8 a9 ef ff ff       	call   801097 <_panic>

008020ee <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8020f4:	83 ec 0c             	sub    $0xc,%esp
  8020f7:	ff 75 08             	pushl  0x8(%ebp)
  8020fa:	e8 90 0c 00 00       	call   802d8f <sys_sbrk>
  8020ff:	83 c4 10             	add    $0x10,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80210a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80210e:	75 0a                	jne    80211a <malloc+0x16>
		return NULL;
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
  802115:	e9 9e 01 00 00       	jmp    8022b8 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80211a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802121:	77 2c                	ja     80214f <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  802123:	e8 eb 0a 00 00       	call   802c13 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802128:	85 c0                	test   %eax,%eax
  80212a:	74 19                	je     802145 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80212c:	83 ec 0c             	sub    $0xc,%esp
  80212f:	ff 75 08             	pushl  0x8(%ebp)
  802132:	e8 85 11 00 00       	call   8032bc <alloc_block_FF>
  802137:	83 c4 10             	add    $0x10,%esp
  80213a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80213d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802140:	e9 73 01 00 00       	jmp    8022b8 <malloc+0x1b4>
		} else {
			return NULL;
  802145:	b8 00 00 00 00       	mov    $0x0,%eax
  80214a:	e9 69 01 00 00       	jmp    8022b8 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80214f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802156:	8b 55 08             	mov    0x8(%ebp),%edx
  802159:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80215c:	01 d0                	add    %edx,%eax
  80215e:	48                   	dec    %eax
  80215f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802162:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802165:	ba 00 00 00 00       	mov    $0x0,%edx
  80216a:	f7 75 e0             	divl   -0x20(%ebp)
  80216d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802170:	29 d0                	sub    %edx,%eax
  802172:	c1 e8 0c             	shr    $0xc,%eax
  802175:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  802178:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80217f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  802186:	a1 40 60 80 00       	mov    0x806040,%eax
  80218b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80218e:	05 00 10 00 00       	add    $0x1000,%eax
  802193:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  802196:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80219b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80219e:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8021a1:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8021a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8021ae:	01 d0                	add    %edx,%eax
  8021b0:	48                   	dec    %eax
  8021b1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8021b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8021bc:	f7 75 cc             	divl   -0x34(%ebp)
  8021bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8021c2:	29 d0                	sub    %edx,%eax
  8021c4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8021c7:	76 0a                	jbe    8021d3 <malloc+0xcf>
		return NULL;
  8021c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ce:	e9 e5 00 00 00       	jmp    8022b8 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8021d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8021d9:	eb 48                	jmp    802223 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8021db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021de:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8021e1:	c1 e8 0c             	shr    $0xc,%eax
  8021e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8021e7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8021ea:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	75 11                	jne    802206 <malloc+0x102>
			freePagesCount++;
  8021f5:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8021f8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8021fc:	75 16                	jne    802214 <malloc+0x110>
				start = i;
  8021fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802201:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802204:	eb 0e                	jmp    802214 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  802206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80220d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  802214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802217:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80221a:	74 12                	je     80222e <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80221c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802223:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80222a:	76 af                	jbe    8021db <malloc+0xd7>
  80222c:	eb 01                	jmp    80222f <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80222e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80222f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802233:	74 08                	je     80223d <malloc+0x139>
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80223b:	74 07                	je     802244 <malloc+0x140>
		return NULL;
  80223d:	b8 00 00 00 00       	mov    $0x0,%eax
  802242:	eb 74                	jmp    8022b8 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802247:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80224a:	c1 e8 0c             	shr    $0xc,%eax
  80224d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  802250:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802253:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802256:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80225d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802260:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802263:	eb 11                	jmp    802276 <malloc+0x172>
		markedPages[i] = 1;
  802265:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802268:	c7 04 85 60 60 90 00 	movl   $0x1,0x906060(,%eax,4)
  80226f:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802273:	ff 45 e8             	incl   -0x18(%ebp)
  802276:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802279:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80227c:	01 d0                	add    %edx,%eax
  80227e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802281:	77 e2                	ja     802265 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  802283:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80228a:	8b 55 08             	mov    0x8(%ebp),%edx
  80228d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802290:	01 d0                	add    %edx,%eax
  802292:	48                   	dec    %eax
  802293:	89 45 b8             	mov    %eax,-0x48(%ebp)
  802296:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802299:	ba 00 00 00 00       	mov    $0x0,%edx
  80229e:	f7 75 bc             	divl   -0x44(%ebp)
  8022a1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8022a4:	29 d0                	sub    %edx,%eax
  8022a6:	83 ec 08             	sub    $0x8,%esp
  8022a9:	50                   	push   %eax
  8022aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8022ad:	e8 14 0b 00 00       	call   802dc6 <sys_allocate_user_mem>
  8022b2:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8022b5:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8022b8:	c9                   	leave  
  8022b9:	c3                   	ret    

008022ba <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8022c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c4:	0f 84 ee 00 00 00    	je     8023b8 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8022ca:	a1 40 60 80 00       	mov    0x806040,%eax
  8022cf:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8022d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d5:	77 09                	ja     8022e0 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8022d7:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8022de:	76 14                	jbe    8022f4 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	68 98 51 80 00       	push   $0x805198
  8022e8:	6a 68                	push   $0x68
  8022ea:	68 b2 51 80 00       	push   $0x8051b2
  8022ef:	e8 a3 ed ff ff       	call   801097 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8022f4:	a1 40 60 80 00       	mov    0x806040,%eax
  8022f9:	8b 40 74             	mov    0x74(%eax),%eax
  8022fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ff:	77 20                	ja     802321 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  802301:	a1 40 60 80 00       	mov    0x806040,%eax
  802306:	8b 40 78             	mov    0x78(%eax),%eax
  802309:	3b 45 08             	cmp    0x8(%ebp),%eax
  80230c:	76 13                	jbe    802321 <free+0x67>
		free_block(virtual_address);
  80230e:	83 ec 0c             	sub    $0xc,%esp
  802311:	ff 75 08             	pushl  0x8(%ebp)
  802314:	e8 6c 16 00 00       	call   803985 <free_block>
  802319:	83 c4 10             	add    $0x10,%esp
		return;
  80231c:	e9 98 00 00 00       	jmp    8023b9 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
  802324:	a1 40 60 80 00       	mov    0x806040,%eax
  802329:	8b 40 7c             	mov    0x7c(%eax),%eax
  80232c:	29 c2                	sub    %eax,%edx
  80232e:	89 d0                	mov    %edx,%eax
  802330:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  802335:	c1 e8 0c             	shr    $0xc,%eax
  802338:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80233b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802342:	eb 16                	jmp    80235a <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234a:	01 d0                	add    %edx,%eax
  80234c:	c7 04 85 60 60 90 00 	movl   $0x0,0x906060(,%eax,4)
  802353:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  802357:	ff 45 f4             	incl   -0xc(%ebp)
  80235a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235d:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802364:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802367:	7f db                	jg     802344 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  802369:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80236c:	8b 04 85 60 60 80 00 	mov    0x806060(,%eax,4),%eax
  802373:	c1 e0 0c             	shl    $0xc,%eax
  802376:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80237f:	eb 1a                	jmp    80239b <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  802381:	83 ec 08             	sub    $0x8,%esp
  802384:	68 00 10 00 00       	push   $0x1000
  802389:	ff 75 f0             	pushl  -0x10(%ebp)
  80238c:	e8 19 0a 00 00       	call   802daa <sys_free_user_mem>
  802391:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  802394:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
  80239e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023a1:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8023a3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8023a6:	77 d9                	ja     802381 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8023a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ab:	c7 04 85 60 60 80 00 	movl   $0x0,0x806060(,%eax,4)
  8023b2:	00 00 00 00 
  8023b6:	eb 01                	jmp    8023b9 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8023b8:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
  8023be:	83 ec 58             	sub    $0x58,%esp
  8023c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c4:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8023c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023cb:	75 0a                	jne    8023d7 <smalloc+0x1c>
		return NULL;
  8023cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d2:	e9 7d 01 00 00       	jmp    802554 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8023d7:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8023de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e4:	01 d0                	add    %edx,%eax
  8023e6:	48                   	dec    %eax
  8023e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8023ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8023f2:	f7 75 e4             	divl   -0x1c(%ebp)
  8023f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023f8:	29 d0                	sub    %edx,%eax
  8023fa:	c1 e8 0c             	shr    $0xc,%eax
  8023fd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  802400:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802407:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80240e:	a1 40 60 80 00       	mov    0x806040,%eax
  802413:	8b 40 7c             	mov    0x7c(%eax),%eax
  802416:	05 00 10 00 00       	add    $0x1000,%eax
  80241b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80241e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802423:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802426:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802429:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802430:	8b 55 0c             	mov    0xc(%ebp),%edx
  802433:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802436:	01 d0                	add    %edx,%eax
  802438:	48                   	dec    %eax
  802439:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80243c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80243f:	ba 00 00 00 00       	mov    $0x0,%edx
  802444:	f7 75 d0             	divl   -0x30(%ebp)
  802447:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80244a:	29 d0                	sub    %edx,%eax
  80244c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80244f:	76 0a                	jbe    80245b <smalloc+0xa0>
		return NULL;
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
  802456:	e9 f9 00 00 00       	jmp    802554 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80245b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80245e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802461:	eb 48                	jmp    8024ab <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802463:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802466:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802469:	c1 e8 0c             	shr    $0xc,%eax
  80246c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80246f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802472:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 11                	jne    80248e <smalloc+0xd3>
			freePagesCount++;
  80247d:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802480:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802484:	75 16                	jne    80249c <smalloc+0xe1>
				start = s;
  802486:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802489:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80248c:	eb 0e                	jmp    80249c <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80248e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802495:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8024a2:	74 12                	je     8024b6 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8024a4:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8024ab:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8024b2:	76 af                	jbe    802463 <smalloc+0xa8>
  8024b4:	eb 01                	jmp    8024b7 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8024b6:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8024b7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8024bb:	74 08                	je     8024c5 <smalloc+0x10a>
  8024bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8024c3:	74 0a                	je     8024cf <smalloc+0x114>
		return NULL;
  8024c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ca:	e9 85 00 00 00       	jmp    802554 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8024cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8024d5:	c1 e8 0c             	shr    $0xc,%eax
  8024d8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8024db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8024de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024e1:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8024e8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8024eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024ee:	eb 11                	jmp    802501 <smalloc+0x146>
		markedPages[s] = 1;
  8024f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f3:	c7 04 85 60 60 90 00 	movl   $0x1,0x906060(,%eax,4)
  8024fa:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8024fe:	ff 45 e8             	incl   -0x18(%ebp)
  802501:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802504:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802507:	01 d0                	add    %edx,%eax
  802509:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80250c:	77 e2                	ja     8024f0 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  80250e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802511:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  802515:	52                   	push   %edx
  802516:	50                   	push   %eax
  802517:	ff 75 0c             	pushl  0xc(%ebp)
  80251a:	ff 75 08             	pushl  0x8(%ebp)
  80251d:	e8 8f 04 00 00       	call   8029b1 <sys_createSharedObject>
  802522:	83 c4 10             	add    $0x10,%esp
  802525:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  802528:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80252c:	78 12                	js     802540 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80252e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802531:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802534:	89 14 85 60 60 88 00 	mov    %edx,0x886060(,%eax,4)
		return (void*) start;
  80253b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253e:	eb 14                	jmp    802554 <smalloc+0x199>
	}
	free((void*) start);
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	83 ec 0c             	sub    $0xc,%esp
  802546:	50                   	push   %eax
  802547:	e8 6e fd ff ff       	call   8022ba <free>
  80254c:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80254f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80255c:	83 ec 08             	sub    $0x8,%esp
  80255f:	ff 75 0c             	pushl  0xc(%ebp)
  802562:	ff 75 08             	pushl  0x8(%ebp)
  802565:	e8 71 04 00 00       	call   8029db <sys_getSizeOfSharedObject>
  80256a:	83 c4 10             	add    $0x10,%esp
  80256d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802570:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802577:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80257a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80257d:	01 d0                	add    %edx,%eax
  80257f:	48                   	dec    %eax
  802580:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802583:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802586:	ba 00 00 00 00       	mov    $0x0,%edx
  80258b:	f7 75 e0             	divl   -0x20(%ebp)
  80258e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802591:	29 d0                	sub    %edx,%eax
  802593:	c1 e8 0c             	shr    $0xc,%eax
  802596:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8025a0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8025a7:	a1 40 60 80 00       	mov    0x806040,%eax
  8025ac:	8b 40 7c             	mov    0x7c(%eax),%eax
  8025af:	05 00 10 00 00       	add    $0x1000,%eax
  8025b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8025b7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8025bc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8025bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8025c2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8025c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025cf:	01 d0                	add    %edx,%eax
  8025d1:	48                   	dec    %eax
  8025d2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8025d5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025dd:	f7 75 cc             	divl   -0x34(%ebp)
  8025e0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8025e3:	29 d0                	sub    %edx,%eax
  8025e5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8025e8:	76 0a                	jbe    8025f4 <sget+0x9e>
		return NULL;
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ef:	e9 f7 00 00 00       	jmp    8026eb <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8025f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8025fa:	eb 48                	jmp    802644 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8025fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ff:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802602:	c1 e8 0c             	shr    $0xc,%eax
  802605:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  802608:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80260b:	8b 04 85 60 60 90 00 	mov    0x906060(,%eax,4),%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	75 11                	jne    802627 <sget+0xd1>
			free_Pages_Count++;
  802616:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802619:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80261d:	75 16                	jne    802635 <sget+0xdf>
				start = s;
  80261f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802622:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802625:	eb 0e                	jmp    802635 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802627:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80262e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80263b:	74 12                	je     80264f <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80263d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802644:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80264b:	76 af                	jbe    8025fc <sget+0xa6>
  80264d:	eb 01                	jmp    802650 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80264f:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802650:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802654:	74 08                	je     80265e <sget+0x108>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80265c:	74 0a                	je     802668 <sget+0x112>
		return NULL;
  80265e:	b8 00 00 00 00       	mov    $0x0,%eax
  802663:	e9 83 00 00 00       	jmp    8026eb <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80266e:	c1 e8 0c             	shr    $0xc,%eax
  802671:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802674:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802677:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80267a:	89 14 85 60 60 80 00 	mov    %edx,0x806060(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802681:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802684:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802687:	eb 11                	jmp    80269a <sget+0x144>
		markedPages[k] = 1;
  802689:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268c:	c7 04 85 60 60 90 00 	movl   $0x1,0x906060(,%eax,4)
  802693:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802697:	ff 45 e8             	incl   -0x18(%ebp)
  80269a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80269d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8026a0:	01 d0                	add    %edx,%eax
  8026a2:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026a5:	77 e2                	ja     802689 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8026a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026aa:	83 ec 04             	sub    $0x4,%esp
  8026ad:	50                   	push   %eax
  8026ae:	ff 75 0c             	pushl  0xc(%ebp)
  8026b1:	ff 75 08             	pushl  0x8(%ebp)
  8026b4:	e8 3f 03 00 00       	call   8029f8 <sys_getSharedObject>
  8026b9:	83 c4 10             	add    $0x10,%esp
  8026bc:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8026bf:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8026c3:	78 12                	js     8026d7 <sget+0x181>
		shardIDs[startPage] = ss;
  8026c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8026c8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8026cb:	89 14 85 60 60 88 00 	mov    %edx,0x886060(,%eax,4)
		return (void*) start;
  8026d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d5:	eb 14                	jmp    8026eb <sget+0x195>
	}
	free((void*) start);
  8026d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	50                   	push   %eax
  8026de:	e8 d7 fb ff ff       	call   8022ba <free>
  8026e3:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8026f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f6:	a1 40 60 80 00       	mov    0x806040,%eax
  8026fb:	8b 40 7c             	mov    0x7c(%eax),%eax
  8026fe:	29 c2                	sub    %eax,%edx
  802700:	89 d0                	mov    %edx,%eax
  802702:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  802707:	c1 e8 0c             	shr    $0xc,%eax
  80270a:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 04 85 60 60 88 00 	mov    0x886060(,%eax,4),%eax
  802717:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80271a:	83 ec 08             	sub    $0x8,%esp
  80271d:	ff 75 08             	pushl  0x8(%ebp)
  802720:	ff 75 f0             	pushl  -0x10(%ebp)
  802723:	e8 ef 02 00 00       	call   802a17 <sys_freeSharedObject>
  802728:	83 c4 10             	add    $0x10,%esp
  80272b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80272e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802732:	75 0e                	jne    802742 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	c7 04 85 60 60 88 00 	movl   $0xffffffff,0x886060(,%eax,4)
  80273e:	ff ff ff ff 
	}

}
  802742:	90                   	nop
  802743:	c9                   	leave  
  802744:	c3                   	ret    

00802745 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80274b:	83 ec 04             	sub    $0x4,%esp
  80274e:	68 c0 51 80 00       	push   $0x8051c0
  802753:	68 19 01 00 00       	push   $0x119
  802758:	68 b2 51 80 00       	push   $0x8051b2
  80275d:	e8 35 e9 ff ff       	call   801097 <_panic>

00802762 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802768:	83 ec 04             	sub    $0x4,%esp
  80276b:	68 e6 51 80 00       	push   $0x8051e6
  802770:	68 23 01 00 00       	push   $0x123
  802775:	68 b2 51 80 00       	push   $0x8051b2
  80277a:	e8 18 e9 ff ff       	call   801097 <_panic>

0080277f <shrink>:

}
void shrink(uint32 newSize) {
  80277f:	55                   	push   %ebp
  802780:	89 e5                	mov    %esp,%ebp
  802782:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	68 e6 51 80 00       	push   $0x8051e6
  80278d:	68 27 01 00 00       	push   $0x127
  802792:	68 b2 51 80 00       	push   $0x8051b2
  802797:	e8 fb e8 ff ff       	call   801097 <_panic>

0080279c <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80279c:	55                   	push   %ebp
  80279d:	89 e5                	mov    %esp,%ebp
  80279f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	68 e6 51 80 00       	push   $0x8051e6
  8027aa:	68 2b 01 00 00       	push   $0x12b
  8027af:	68 b2 51 80 00       	push   $0x8051b2
  8027b4:	e8 de e8 ff ff       	call   801097 <_panic>

008027b9 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
  8027bc:	57                   	push   %edi
  8027bd:	56                   	push   %esi
  8027be:	53                   	push   %ebx
  8027bf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027ce:	8b 7d 18             	mov    0x18(%ebp),%edi
  8027d1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8027d4:	cd 30                	int    $0x30
  8027d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8027dc:	83 c4 10             	add    $0x10,%esp
  8027df:	5b                   	pop    %ebx
  8027e0:	5e                   	pop    %esi
  8027e1:	5f                   	pop    %edi
  8027e2:	5d                   	pop    %ebp
  8027e3:	c3                   	ret    

008027e4 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8027e4:	55                   	push   %ebp
  8027e5:	89 e5                	mov    %esp,%ebp
  8027e7:	83 ec 04             	sub    $0x4,%esp
  8027ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8027f0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	52                   	push   %edx
  8027fc:	ff 75 0c             	pushl  0xc(%ebp)
  8027ff:	50                   	push   %eax
  802800:	6a 00                	push   $0x0
  802802:	e8 b2 ff ff ff       	call   8027b9 <syscall>
  802807:	83 c4 18             	add    $0x18,%esp
}
  80280a:	90                   	nop
  80280b:	c9                   	leave  
  80280c:	c3                   	ret    

0080280d <sys_cgetc>:

int sys_cgetc(void) {
  80280d:	55                   	push   %ebp
  80280e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802810:	6a 00                	push   $0x0
  802812:	6a 00                	push   $0x0
  802814:	6a 00                	push   $0x0
  802816:	6a 00                	push   $0x0
  802818:	6a 00                	push   $0x0
  80281a:	6a 02                	push   $0x2
  80281c:	e8 98 ff ff ff       	call   8027b9 <syscall>
  802821:	83 c4 18             	add    $0x18,%esp
}
  802824:	c9                   	leave  
  802825:	c3                   	ret    

00802826 <sys_lock_cons>:

void sys_lock_cons(void) {
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802829:	6a 00                	push   $0x0
  80282b:	6a 00                	push   $0x0
  80282d:	6a 00                	push   $0x0
  80282f:	6a 00                	push   $0x0
  802831:	6a 00                	push   $0x0
  802833:	6a 03                	push   $0x3
  802835:	e8 7f ff ff ff       	call   8027b9 <syscall>
  80283a:	83 c4 18             	add    $0x18,%esp
}
  80283d:	90                   	nop
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    

00802840 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802843:	6a 00                	push   $0x0
  802845:	6a 00                	push   $0x0
  802847:	6a 00                	push   $0x0
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 04                	push   $0x4
  80284f:	e8 65 ff ff ff       	call   8027b9 <syscall>
  802854:	83 c4 18             	add    $0x18,%esp
}
  802857:	90                   	nop
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80285d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	6a 00                	push   $0x0
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	52                   	push   %edx
  80286a:	50                   	push   %eax
  80286b:	6a 08                	push   $0x8
  80286d:	e8 47 ff ff ff       	call   8027b9 <syscall>
  802872:	83 c4 18             	add    $0x18,%esp
}
  802875:	c9                   	leave  
  802876:	c3                   	ret    

00802877 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802877:	55                   	push   %ebp
  802878:	89 e5                	mov    %esp,%ebp
  80287a:	56                   	push   %esi
  80287b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80287c:	8b 75 18             	mov    0x18(%ebp),%esi
  80287f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802882:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802885:	8b 55 0c             	mov    0xc(%ebp),%edx
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	56                   	push   %esi
  80288c:	53                   	push   %ebx
  80288d:	51                   	push   %ecx
  80288e:	52                   	push   %edx
  80288f:	50                   	push   %eax
  802890:	6a 09                	push   $0x9
  802892:	e8 22 ff ff ff       	call   8027b9 <syscall>
  802897:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80289a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80289d:	5b                   	pop    %ebx
  80289e:	5e                   	pop    %esi
  80289f:	5d                   	pop    %ebp
  8028a0:	c3                   	ret    

008028a1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8028a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	6a 00                	push   $0x0
  8028ac:	6a 00                	push   $0x0
  8028ae:	6a 00                	push   $0x0
  8028b0:	52                   	push   %edx
  8028b1:	50                   	push   %eax
  8028b2:	6a 0a                	push   $0xa
  8028b4:	e8 00 ff ff ff       	call   8027b9 <syscall>
  8028b9:	83 c4 18             	add    $0x18,%esp
}
  8028bc:	c9                   	leave  
  8028bd:	c3                   	ret    

008028be <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8028be:	55                   	push   %ebp
  8028bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8028c1:	6a 00                	push   $0x0
  8028c3:	6a 00                	push   $0x0
  8028c5:	6a 00                	push   $0x0
  8028c7:	ff 75 0c             	pushl  0xc(%ebp)
  8028ca:	ff 75 08             	pushl  0x8(%ebp)
  8028cd:	6a 0b                	push   $0xb
  8028cf:	e8 e5 fe ff ff       	call   8027b9 <syscall>
  8028d4:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8028dc:	6a 00                	push   $0x0
  8028de:	6a 00                	push   $0x0
  8028e0:	6a 00                	push   $0x0
  8028e2:	6a 00                	push   $0x0
  8028e4:	6a 00                	push   $0x0
  8028e6:	6a 0c                	push   $0xc
  8028e8:	e8 cc fe ff ff       	call   8027b9 <syscall>
  8028ed:	83 c4 18             	add    $0x18,%esp
}
  8028f0:	c9                   	leave  
  8028f1:	c3                   	ret    

008028f2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8028f2:	55                   	push   %ebp
  8028f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8028f5:	6a 00                	push   $0x0
  8028f7:	6a 00                	push   $0x0
  8028f9:	6a 00                	push   $0x0
  8028fb:	6a 00                	push   $0x0
  8028fd:	6a 00                	push   $0x0
  8028ff:	6a 0d                	push   $0xd
  802901:	e8 b3 fe ff ff       	call   8027b9 <syscall>
  802906:	83 c4 18             	add    $0x18,%esp
}
  802909:	c9                   	leave  
  80290a:	c3                   	ret    

0080290b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80290b:	55                   	push   %ebp
  80290c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80290e:	6a 00                	push   $0x0
  802910:	6a 00                	push   $0x0
  802912:	6a 00                	push   $0x0
  802914:	6a 00                	push   $0x0
  802916:	6a 00                	push   $0x0
  802918:	6a 0e                	push   $0xe
  80291a:	e8 9a fe ff ff       	call   8027b9 <syscall>
  80291f:	83 c4 18             	add    $0x18,%esp
}
  802922:	c9                   	leave  
  802923:	c3                   	ret    

00802924 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802927:	6a 00                	push   $0x0
  802929:	6a 00                	push   $0x0
  80292b:	6a 00                	push   $0x0
  80292d:	6a 00                	push   $0x0
  80292f:	6a 00                	push   $0x0
  802931:	6a 0f                	push   $0xf
  802933:	e8 81 fe ff ff       	call   8027b9 <syscall>
  802938:	83 c4 18             	add    $0x18,%esp
}
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802940:	6a 00                	push   $0x0
  802942:	6a 00                	push   $0x0
  802944:	6a 00                	push   $0x0
  802946:	6a 00                	push   $0x0
  802948:	ff 75 08             	pushl  0x8(%ebp)
  80294b:	6a 10                	push   $0x10
  80294d:	e8 67 fe ff ff       	call   8027b9 <syscall>
  802952:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802955:	c9                   	leave  
  802956:	c3                   	ret    

00802957 <sys_scarce_memory>:

void sys_scarce_memory() {
  802957:	55                   	push   %ebp
  802958:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80295a:	6a 00                	push   $0x0
  80295c:	6a 00                	push   $0x0
  80295e:	6a 00                	push   $0x0
  802960:	6a 00                	push   $0x0
  802962:	6a 00                	push   $0x0
  802964:	6a 11                	push   $0x11
  802966:	e8 4e fe ff ff       	call   8027b9 <syscall>
  80296b:	83 c4 18             	add    $0x18,%esp
}
  80296e:	90                   	nop
  80296f:	c9                   	leave  
  802970:	c3                   	ret    

00802971 <sys_cputc>:

void sys_cputc(const char c) {
  802971:	55                   	push   %ebp
  802972:	89 e5                	mov    %esp,%ebp
  802974:	83 ec 04             	sub    $0x4,%esp
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80297d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802981:	6a 00                	push   $0x0
  802983:	6a 00                	push   $0x0
  802985:	6a 00                	push   $0x0
  802987:	6a 00                	push   $0x0
  802989:	50                   	push   %eax
  80298a:	6a 01                	push   $0x1
  80298c:	e8 28 fe ff ff       	call   8027b9 <syscall>
  802991:	83 c4 18             	add    $0x18,%esp
}
  802994:	90                   	nop
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802997:	55                   	push   %ebp
  802998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80299a:	6a 00                	push   $0x0
  80299c:	6a 00                	push   $0x0
  80299e:	6a 00                	push   $0x0
  8029a0:	6a 00                	push   $0x0
  8029a2:	6a 00                	push   $0x0
  8029a4:	6a 14                	push   $0x14
  8029a6:	e8 0e fe ff ff       	call   8027b9 <syscall>
  8029ab:	83 c4 18             	add    $0x18,%esp
}
  8029ae:	90                   	nop
  8029af:	c9                   	leave  
  8029b0:	c3                   	ret    

008029b1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8029b1:	55                   	push   %ebp
  8029b2:	89 e5                	mov    %esp,%ebp
  8029b4:	83 ec 04             	sub    $0x4,%esp
  8029b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8029bd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8029c0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	6a 00                	push   $0x0
  8029c9:	51                   	push   %ecx
  8029ca:	52                   	push   %edx
  8029cb:	ff 75 0c             	pushl  0xc(%ebp)
  8029ce:	50                   	push   %eax
  8029cf:	6a 15                	push   $0x15
  8029d1:	e8 e3 fd ff ff       	call   8027b9 <syscall>
  8029d6:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8029de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	6a 00                	push   $0x0
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 00                	push   $0x0
  8029ea:	52                   	push   %edx
  8029eb:	50                   	push   %eax
  8029ec:	6a 16                	push   $0x16
  8029ee:	e8 c6 fd ff ff       	call   8027b9 <syscall>
  8029f3:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8029f6:	c9                   	leave  
  8029f7:	c3                   	ret    

008029f8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8029f8:	55                   	push   %ebp
  8029f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8029fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8029fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	6a 00                	push   $0x0
  802a06:	6a 00                	push   $0x0
  802a08:	51                   	push   %ecx
  802a09:	52                   	push   %edx
  802a0a:	50                   	push   %eax
  802a0b:	6a 17                	push   $0x17
  802a0d:	e8 a7 fd ff ff       	call   8027b9 <syscall>
  802a12:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802a15:	c9                   	leave  
  802a16:	c3                   	ret    

00802a17 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802a17:	55                   	push   %ebp
  802a18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	6a 00                	push   $0x0
  802a22:	6a 00                	push   $0x0
  802a24:	6a 00                	push   $0x0
  802a26:	52                   	push   %edx
  802a27:	50                   	push   %eax
  802a28:	6a 18                	push   $0x18
  802a2a:	e8 8a fd ff ff       	call   8027b9 <syscall>
  802a2f:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802a32:	c9                   	leave  
  802a33:	c3                   	ret    

00802a34 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802a34:	55                   	push   %ebp
  802a35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	6a 00                	push   $0x0
  802a3c:	ff 75 14             	pushl  0x14(%ebp)
  802a3f:	ff 75 10             	pushl  0x10(%ebp)
  802a42:	ff 75 0c             	pushl  0xc(%ebp)
  802a45:	50                   	push   %eax
  802a46:	6a 19                	push   $0x19
  802a48:	e8 6c fd ff ff       	call   8027b9 <syscall>
  802a4d:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802a50:	c9                   	leave  
  802a51:	c3                   	ret    

00802a52 <sys_run_env>:

void sys_run_env(int32 envId) {
  802a52:	55                   	push   %ebp
  802a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	6a 00                	push   $0x0
  802a5a:	6a 00                	push   $0x0
  802a5c:	6a 00                	push   $0x0
  802a5e:	6a 00                	push   $0x0
  802a60:	50                   	push   %eax
  802a61:	6a 1a                	push   $0x1a
  802a63:	e8 51 fd ff ff       	call   8027b9 <syscall>
  802a68:	83 c4 18             	add    $0x18,%esp
}
  802a6b:	90                   	nop
  802a6c:	c9                   	leave  
  802a6d:	c3                   	ret    

00802a6e <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	6a 00                	push   $0x0
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	50                   	push   %eax
  802a7d:	6a 1b                	push   $0x1b
  802a7f:	e8 35 fd ff ff       	call   8027b9 <syscall>
  802a84:	83 c4 18             	add    $0x18,%esp
}
  802a87:	c9                   	leave  
  802a88:	c3                   	ret    

00802a89 <sys_getenvid>:

int32 sys_getenvid(void) {
  802a89:	55                   	push   %ebp
  802a8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802a8c:	6a 00                	push   $0x0
  802a8e:	6a 00                	push   $0x0
  802a90:	6a 00                	push   $0x0
  802a92:	6a 00                	push   $0x0
  802a94:	6a 00                	push   $0x0
  802a96:	6a 05                	push   $0x5
  802a98:	e8 1c fd ff ff       	call   8027b9 <syscall>
  802a9d:	83 c4 18             	add    $0x18,%esp
}
  802aa0:	c9                   	leave  
  802aa1:	c3                   	ret    

00802aa2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802aa2:	55                   	push   %ebp
  802aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 00                	push   $0x0
  802aa9:	6a 00                	push   $0x0
  802aab:	6a 00                	push   $0x0
  802aad:	6a 00                	push   $0x0
  802aaf:	6a 06                	push   $0x6
  802ab1:	e8 03 fd ff ff       	call   8027b9 <syscall>
  802ab6:	83 c4 18             	add    $0x18,%esp
}
  802ab9:	c9                   	leave  
  802aba:	c3                   	ret    

00802abb <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802abb:	55                   	push   %ebp
  802abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802abe:	6a 00                	push   $0x0
  802ac0:	6a 00                	push   $0x0
  802ac2:	6a 00                	push   $0x0
  802ac4:	6a 00                	push   $0x0
  802ac6:	6a 00                	push   $0x0
  802ac8:	6a 07                	push   $0x7
  802aca:	e8 ea fc ff ff       	call   8027b9 <syscall>
  802acf:	83 c4 18             	add    $0x18,%esp
}
  802ad2:	c9                   	leave  
  802ad3:	c3                   	ret    

00802ad4 <sys_exit_env>:

void sys_exit_env(void) {
  802ad4:	55                   	push   %ebp
  802ad5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802ad7:	6a 00                	push   $0x0
  802ad9:	6a 00                	push   $0x0
  802adb:	6a 00                	push   $0x0
  802add:	6a 00                	push   $0x0
  802adf:	6a 00                	push   $0x0
  802ae1:	6a 1c                	push   $0x1c
  802ae3:	e8 d1 fc ff ff       	call   8027b9 <syscall>
  802ae8:	83 c4 18             	add    $0x18,%esp
}
  802aeb:	90                   	nop
  802aec:	c9                   	leave  
  802aed:	c3                   	ret    

00802aee <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  802aee:	55                   	push   %ebp
  802aef:	89 e5                	mov    %esp,%ebp
  802af1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802af4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802af7:	8d 50 04             	lea    0x4(%eax),%edx
  802afa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802afd:	6a 00                	push   $0x0
  802aff:	6a 00                	push   $0x0
  802b01:	6a 00                	push   $0x0
  802b03:	52                   	push   %edx
  802b04:	50                   	push   %eax
  802b05:	6a 1d                	push   $0x1d
  802b07:	e8 ad fc ff ff       	call   8027b9 <syscall>
  802b0c:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  802b0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802b15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802b18:	89 01                	mov    %eax,(%ecx)
  802b1a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	c9                   	leave  
  802b21:	c2 04 00             	ret    $0x4

00802b24 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802b24:	55                   	push   %ebp
  802b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802b27:	6a 00                	push   $0x0
  802b29:	6a 00                	push   $0x0
  802b2b:	ff 75 10             	pushl  0x10(%ebp)
  802b2e:	ff 75 0c             	pushl  0xc(%ebp)
  802b31:	ff 75 08             	pushl  0x8(%ebp)
  802b34:	6a 13                	push   $0x13
  802b36:	e8 7e fc ff ff       	call   8027b9 <syscall>
  802b3b:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802b3e:	90                   	nop
}
  802b3f:	c9                   	leave  
  802b40:	c3                   	ret    

00802b41 <sys_rcr2>:
uint32 sys_rcr2() {
  802b41:	55                   	push   %ebp
  802b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802b44:	6a 00                	push   $0x0
  802b46:	6a 00                	push   $0x0
  802b48:	6a 00                	push   $0x0
  802b4a:	6a 00                	push   $0x0
  802b4c:	6a 00                	push   $0x0
  802b4e:	6a 1e                	push   $0x1e
  802b50:	e8 64 fc ff ff       	call   8027b9 <syscall>
  802b55:	83 c4 18             	add    $0x18,%esp
}
  802b58:	c9                   	leave  
  802b59:	c3                   	ret    

00802b5a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802b5a:	55                   	push   %ebp
  802b5b:	89 e5                	mov    %esp,%ebp
  802b5d:	83 ec 04             	sub    $0x4,%esp
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802b66:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	6a 00                	push   $0x0
  802b70:	6a 00                	push   $0x0
  802b72:	50                   	push   %eax
  802b73:	6a 1f                	push   $0x1f
  802b75:	e8 3f fc ff ff       	call   8027b9 <syscall>
  802b7a:	83 c4 18             	add    $0x18,%esp
	return;
  802b7d:	90                   	nop
}
  802b7e:	c9                   	leave  
  802b7f:	c3                   	ret    

00802b80 <rsttst>:
void rsttst() {
  802b80:	55                   	push   %ebp
  802b81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802b83:	6a 00                	push   $0x0
  802b85:	6a 00                	push   $0x0
  802b87:	6a 00                	push   $0x0
  802b89:	6a 00                	push   $0x0
  802b8b:	6a 00                	push   $0x0
  802b8d:	6a 21                	push   $0x21
  802b8f:	e8 25 fc ff ff       	call   8027b9 <syscall>
  802b94:	83 c4 18             	add    $0x18,%esp
	return;
  802b97:	90                   	nop
}
  802b98:	c9                   	leave  
  802b99:	c3                   	ret    

00802b9a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802b9a:	55                   	push   %ebp
  802b9b:	89 e5                	mov    %esp,%ebp
  802b9d:	83 ec 04             	sub    $0x4,%esp
  802ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  802ba3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802ba6:	8b 55 18             	mov    0x18(%ebp),%edx
  802ba9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802bad:	52                   	push   %edx
  802bae:	50                   	push   %eax
  802baf:	ff 75 10             	pushl  0x10(%ebp)
  802bb2:	ff 75 0c             	pushl  0xc(%ebp)
  802bb5:	ff 75 08             	pushl  0x8(%ebp)
  802bb8:	6a 20                	push   $0x20
  802bba:	e8 fa fb ff ff       	call   8027b9 <syscall>
  802bbf:	83 c4 18             	add    $0x18,%esp
	return;
  802bc2:	90                   	nop
}
  802bc3:	c9                   	leave  
  802bc4:	c3                   	ret    

00802bc5 <chktst>:
void chktst(uint32 n) {
  802bc5:	55                   	push   %ebp
  802bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802bc8:	6a 00                	push   $0x0
  802bca:	6a 00                	push   $0x0
  802bcc:	6a 00                	push   $0x0
  802bce:	6a 00                	push   $0x0
  802bd0:	ff 75 08             	pushl  0x8(%ebp)
  802bd3:	6a 22                	push   $0x22
  802bd5:	e8 df fb ff ff       	call   8027b9 <syscall>
  802bda:	83 c4 18             	add    $0x18,%esp
	return;
  802bdd:	90                   	nop
}
  802bde:	c9                   	leave  
  802bdf:	c3                   	ret    

00802be0 <inctst>:

void inctst() {
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802be3:	6a 00                	push   $0x0
  802be5:	6a 00                	push   $0x0
  802be7:	6a 00                	push   $0x0
  802be9:	6a 00                	push   $0x0
  802beb:	6a 00                	push   $0x0
  802bed:	6a 23                	push   $0x23
  802bef:	e8 c5 fb ff ff       	call   8027b9 <syscall>
  802bf4:	83 c4 18             	add    $0x18,%esp
	return;
  802bf7:	90                   	nop
}
  802bf8:	c9                   	leave  
  802bf9:	c3                   	ret    

00802bfa <gettst>:
uint32 gettst() {
  802bfa:	55                   	push   %ebp
  802bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802bfd:	6a 00                	push   $0x0
  802bff:	6a 00                	push   $0x0
  802c01:	6a 00                	push   $0x0
  802c03:	6a 00                	push   $0x0
  802c05:	6a 00                	push   $0x0
  802c07:	6a 24                	push   $0x24
  802c09:	e8 ab fb ff ff       	call   8027b9 <syscall>
  802c0e:	83 c4 18             	add    $0x18,%esp
}
  802c11:	c9                   	leave  
  802c12:	c3                   	ret    

00802c13 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802c13:	55                   	push   %ebp
  802c14:	89 e5                	mov    %esp,%ebp
  802c16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c19:	6a 00                	push   $0x0
  802c1b:	6a 00                	push   $0x0
  802c1d:	6a 00                	push   $0x0
  802c1f:	6a 00                	push   $0x0
  802c21:	6a 00                	push   $0x0
  802c23:	6a 25                	push   $0x25
  802c25:	e8 8f fb ff ff       	call   8027b9 <syscall>
  802c2a:	83 c4 18             	add    $0x18,%esp
  802c2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802c30:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802c34:	75 07                	jne    802c3d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802c36:	b8 01 00 00 00       	mov    $0x1,%eax
  802c3b:	eb 05                	jmp    802c42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802c3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c42:	c9                   	leave  
  802c43:	c3                   	ret    

00802c44 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c4a:	6a 00                	push   $0x0
  802c4c:	6a 00                	push   $0x0
  802c4e:	6a 00                	push   $0x0
  802c50:	6a 00                	push   $0x0
  802c52:	6a 00                	push   $0x0
  802c54:	6a 25                	push   $0x25
  802c56:	e8 5e fb ff ff       	call   8027b9 <syscall>
  802c5b:	83 c4 18             	add    $0x18,%esp
  802c5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802c61:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802c65:	75 07                	jne    802c6e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802c67:	b8 01 00 00 00       	mov    $0x1,%eax
  802c6c:	eb 05                	jmp    802c73 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802c6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c73:	c9                   	leave  
  802c74:	c3                   	ret    

00802c75 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802c75:	55                   	push   %ebp
  802c76:	89 e5                	mov    %esp,%ebp
  802c78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 00                	push   $0x0
  802c7f:	6a 00                	push   $0x0
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	6a 25                	push   $0x25
  802c87:	e8 2d fb ff ff       	call   8027b9 <syscall>
  802c8c:	83 c4 18             	add    $0x18,%esp
  802c8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802c92:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802c96:	75 07                	jne    802c9f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802c98:	b8 01 00 00 00       	mov    $0x1,%eax
  802c9d:	eb 05                	jmp    802ca4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ca4:	c9                   	leave  
  802ca5:	c3                   	ret    

00802ca6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802ca6:	55                   	push   %ebp
  802ca7:	89 e5                	mov    %esp,%ebp
  802ca9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802cac:	6a 00                	push   $0x0
  802cae:	6a 00                	push   $0x0
  802cb0:	6a 00                	push   $0x0
  802cb2:	6a 00                	push   $0x0
  802cb4:	6a 00                	push   $0x0
  802cb6:	6a 25                	push   $0x25
  802cb8:	e8 fc fa ff ff       	call   8027b9 <syscall>
  802cbd:	83 c4 18             	add    $0x18,%esp
  802cc0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802cc3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802cc7:	75 07                	jne    802cd0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802cc9:	b8 01 00 00 00       	mov    $0x1,%eax
  802cce:	eb 05                	jmp    802cd5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cd5:	c9                   	leave  
  802cd6:	c3                   	ret    

00802cd7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802cd7:	55                   	push   %ebp
  802cd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802cda:	6a 00                	push   $0x0
  802cdc:	6a 00                	push   $0x0
  802cde:	6a 00                	push   $0x0
  802ce0:	6a 00                	push   $0x0
  802ce2:	ff 75 08             	pushl  0x8(%ebp)
  802ce5:	6a 26                	push   $0x26
  802ce7:	e8 cd fa ff ff       	call   8027b9 <syscall>
  802cec:	83 c4 18             	add    $0x18,%esp
	return;
  802cef:	90                   	nop
}
  802cf0:	c9                   	leave  
  802cf1:	c3                   	ret    

00802cf2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802cf2:	55                   	push   %ebp
  802cf3:	89 e5                	mov    %esp,%ebp
  802cf5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802cf6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802cf9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	6a 00                	push   $0x0
  802d04:	53                   	push   %ebx
  802d05:	51                   	push   %ecx
  802d06:	52                   	push   %edx
  802d07:	50                   	push   %eax
  802d08:	6a 27                	push   $0x27
  802d0a:	e8 aa fa ff ff       	call   8027b9 <syscall>
  802d0f:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802d12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802d15:	c9                   	leave  
  802d16:	c3                   	ret    

00802d17 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802d17:	55                   	push   %ebp
  802d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d20:	6a 00                	push   $0x0
  802d22:	6a 00                	push   $0x0
  802d24:	6a 00                	push   $0x0
  802d26:	52                   	push   %edx
  802d27:	50                   	push   %eax
  802d28:	6a 28                	push   $0x28
  802d2a:	e8 8a fa ff ff       	call   8027b9 <syscall>
  802d2f:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802d32:	c9                   	leave  
  802d33:	c3                   	ret    

00802d34 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802d34:	55                   	push   %ebp
  802d35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802d37:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	6a 00                	push   $0x0
  802d42:	51                   	push   %ecx
  802d43:	ff 75 10             	pushl  0x10(%ebp)
  802d46:	52                   	push   %edx
  802d47:	50                   	push   %eax
  802d48:	6a 29                	push   $0x29
  802d4a:	e8 6a fa ff ff       	call   8027b9 <syscall>
  802d4f:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802d52:	c9                   	leave  
  802d53:	c3                   	ret    

00802d54 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802d54:	55                   	push   %ebp
  802d55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d57:	6a 00                	push   $0x0
  802d59:	6a 00                	push   $0x0
  802d5b:	ff 75 10             	pushl  0x10(%ebp)
  802d5e:	ff 75 0c             	pushl  0xc(%ebp)
  802d61:	ff 75 08             	pushl  0x8(%ebp)
  802d64:	6a 12                	push   $0x12
  802d66:	e8 4e fa ff ff       	call   8027b9 <syscall>
  802d6b:	83 c4 18             	add    $0x18,%esp
	return;
  802d6e:	90                   	nop
}
  802d6f:	c9                   	leave  
  802d70:	c3                   	ret    

00802d71 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802d71:	55                   	push   %ebp
  802d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 00                	push   $0x0
  802d80:	52                   	push   %edx
  802d81:	50                   	push   %eax
  802d82:	6a 2a                	push   $0x2a
  802d84:	e8 30 fa ff ff       	call   8027b9 <syscall>
  802d89:	83 c4 18             	add    $0x18,%esp
	return;
  802d8c:	90                   	nop
}
  802d8d:	c9                   	leave  
  802d8e:	c3                   	ret    

00802d8f <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802d8f:	55                   	push   %ebp
  802d90:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	6a 00                	push   $0x0
  802d97:	6a 00                	push   $0x0
  802d99:	6a 00                	push   $0x0
  802d9b:	6a 00                	push   $0x0
  802d9d:	50                   	push   %eax
  802d9e:	6a 2b                	push   $0x2b
  802da0:	e8 14 fa ff ff       	call   8027b9 <syscall>
  802da5:	83 c4 18             	add    $0x18,%esp
}
  802da8:	c9                   	leave  
  802da9:	c3                   	ret    

00802daa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802daa:	55                   	push   %ebp
  802dab:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802dad:	6a 00                	push   $0x0
  802daf:	6a 00                	push   $0x0
  802db1:	6a 00                	push   $0x0
  802db3:	ff 75 0c             	pushl  0xc(%ebp)
  802db6:	ff 75 08             	pushl  0x8(%ebp)
  802db9:	6a 2c                	push   $0x2c
  802dbb:	e8 f9 f9 ff ff       	call   8027b9 <syscall>
  802dc0:	83 c4 18             	add    $0x18,%esp
	return;
  802dc3:	90                   	nop
}
  802dc4:	c9                   	leave  
  802dc5:	c3                   	ret    

00802dc6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802dc9:	6a 00                	push   $0x0
  802dcb:	6a 00                	push   $0x0
  802dcd:	6a 00                	push   $0x0
  802dcf:	ff 75 0c             	pushl  0xc(%ebp)
  802dd2:	ff 75 08             	pushl  0x8(%ebp)
  802dd5:	6a 2d                	push   $0x2d
  802dd7:	e8 dd f9 ff ff       	call   8027b9 <syscall>
  802ddc:	83 c4 18             	add    $0x18,%esp
	return;
  802ddf:	90                   	nop
}
  802de0:	c9                   	leave  
  802de1:	c3                   	ret    

00802de2 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802de2:	55                   	push   %ebp
  802de3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 00                	push   $0x0
  802df0:	50                   	push   %eax
  802df1:	6a 2f                	push   $0x2f
  802df3:	e8 c1 f9 ff ff       	call   8027b9 <syscall>
  802df8:	83 c4 18             	add    $0x18,%esp
	return;
  802dfb:	90                   	nop
}
  802dfc:	c9                   	leave  
  802dfd:	c3                   	ret    

00802dfe <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802dfe:	55                   	push   %ebp
  802dff:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	6a 00                	push   $0x0
  802e09:	6a 00                	push   $0x0
  802e0b:	6a 00                	push   $0x0
  802e0d:	52                   	push   %edx
  802e0e:	50                   	push   %eax
  802e0f:	6a 30                	push   $0x30
  802e11:	e8 a3 f9 ff ff       	call   8027b9 <syscall>
  802e16:	83 c4 18             	add    $0x18,%esp
	return;
  802e19:	90                   	nop
}
  802e1a:	c9                   	leave  
  802e1b:	c3                   	ret    

00802e1c <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802e1c:	55                   	push   %ebp
  802e1d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	6a 00                	push   $0x0
  802e24:	6a 00                	push   $0x0
  802e26:	6a 00                	push   $0x0
  802e28:	6a 00                	push   $0x0
  802e2a:	50                   	push   %eax
  802e2b:	6a 31                	push   $0x31
  802e2d:	e8 87 f9 ff ff       	call   8027b9 <syscall>
  802e32:	83 c4 18             	add    $0x18,%esp
	return;
  802e35:	90                   	nop
}
  802e36:	c9                   	leave  
  802e37:	c3                   	ret    

00802e38 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802e38:	55                   	push   %ebp
  802e39:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	6a 00                	push   $0x0
  802e47:	52                   	push   %edx
  802e48:	50                   	push   %eax
  802e49:	6a 2e                	push   $0x2e
  802e4b:	e8 69 f9 ff ff       	call   8027b9 <syscall>
  802e50:	83 c4 18             	add    $0x18,%esp
    return;
  802e53:	90                   	nop
}
  802e54:	c9                   	leave  
  802e55:	c3                   	ret    

00802e56 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802e56:	55                   	push   %ebp
  802e57:	89 e5                	mov    %esp,%ebp
  802e59:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	83 e8 04             	sub    $0x4,%eax
  802e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e68:	8b 00                	mov    (%eax),%eax
  802e6a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802e6d:	c9                   	leave  
  802e6e:	c3                   	ret    

00802e6f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802e6f:	55                   	push   %ebp
  802e70:	89 e5                	mov    %esp,%ebp
  802e72:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	83 e8 04             	sub    $0x4,%eax
  802e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	83 e0 01             	and    $0x1,%eax
  802e86:	85 c0                	test   %eax,%eax
  802e88:	0f 94 c0             	sete   %al
}
  802e8b:	c9                   	leave  
  802e8c:	c3                   	ret    

00802e8d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802e8d:	55                   	push   %ebp
  802e8e:	89 e5                	mov    %esp,%ebp
  802e90:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802e93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e9d:	83 f8 02             	cmp    $0x2,%eax
  802ea0:	74 2b                	je     802ecd <alloc_block+0x40>
  802ea2:	83 f8 02             	cmp    $0x2,%eax
  802ea5:	7f 07                	jg     802eae <alloc_block+0x21>
  802ea7:	83 f8 01             	cmp    $0x1,%eax
  802eaa:	74 0e                	je     802eba <alloc_block+0x2d>
  802eac:	eb 58                	jmp    802f06 <alloc_block+0x79>
  802eae:	83 f8 03             	cmp    $0x3,%eax
  802eb1:	74 2d                	je     802ee0 <alloc_block+0x53>
  802eb3:	83 f8 04             	cmp    $0x4,%eax
  802eb6:	74 3b                	je     802ef3 <alloc_block+0x66>
  802eb8:	eb 4c                	jmp    802f06 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802eba:	83 ec 0c             	sub    $0xc,%esp
  802ebd:	ff 75 08             	pushl  0x8(%ebp)
  802ec0:	e8 f7 03 00 00       	call   8032bc <alloc_block_FF>
  802ec5:	83 c4 10             	add    $0x10,%esp
  802ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ecb:	eb 4a                	jmp    802f17 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802ecd:	83 ec 0c             	sub    $0xc,%esp
  802ed0:	ff 75 08             	pushl  0x8(%ebp)
  802ed3:	e8 f0 11 00 00       	call   8040c8 <alloc_block_NF>
  802ed8:	83 c4 10             	add    $0x10,%esp
  802edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ede:	eb 37                	jmp    802f17 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802ee0:	83 ec 0c             	sub    $0xc,%esp
  802ee3:	ff 75 08             	pushl  0x8(%ebp)
  802ee6:	e8 08 08 00 00       	call   8036f3 <alloc_block_BF>
  802eeb:	83 c4 10             	add    $0x10,%esp
  802eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802ef1:	eb 24                	jmp    802f17 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802ef3:	83 ec 0c             	sub    $0xc,%esp
  802ef6:	ff 75 08             	pushl  0x8(%ebp)
  802ef9:	e8 ad 11 00 00       	call   8040ab <alloc_block_WF>
  802efe:	83 c4 10             	add    $0x10,%esp
  802f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802f04:	eb 11                	jmp    802f17 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802f06:	83 ec 0c             	sub    $0xc,%esp
  802f09:	68 f8 51 80 00       	push   $0x8051f8
  802f0e:	e8 41 e4 ff ff       	call   801354 <cprintf>
  802f13:	83 c4 10             	add    $0x10,%esp
		break;
  802f16:	90                   	nop
	}
	return va;
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802f1a:	c9                   	leave  
  802f1b:	c3                   	ret    

00802f1c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802f1c:	55                   	push   %ebp
  802f1d:	89 e5                	mov    %esp,%ebp
  802f1f:	53                   	push   %ebx
  802f20:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802f23:	83 ec 0c             	sub    $0xc,%esp
  802f26:	68 18 52 80 00       	push   $0x805218
  802f2b:	e8 24 e4 ff ff       	call   801354 <cprintf>
  802f30:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802f33:	83 ec 0c             	sub    $0xc,%esp
  802f36:	68 43 52 80 00       	push   $0x805243
  802f3b:	e8 14 e4 ff ff       	call   801354 <cprintf>
  802f40:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f49:	eb 37                	jmp    802f82 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802f4b:	83 ec 0c             	sub    $0xc,%esp
  802f4e:	ff 75 f4             	pushl  -0xc(%ebp)
  802f51:	e8 19 ff ff ff       	call   802e6f <is_free_block>
  802f56:	83 c4 10             	add    $0x10,%esp
  802f59:	0f be d8             	movsbl %al,%ebx
  802f5c:	83 ec 0c             	sub    $0xc,%esp
  802f5f:	ff 75 f4             	pushl  -0xc(%ebp)
  802f62:	e8 ef fe ff ff       	call   802e56 <get_block_size>
  802f67:	83 c4 10             	add    $0x10,%esp
  802f6a:	83 ec 04             	sub    $0x4,%esp
  802f6d:	53                   	push   %ebx
  802f6e:	50                   	push   %eax
  802f6f:	68 5b 52 80 00       	push   $0x80525b
  802f74:	e8 db e3 ff ff       	call   801354 <cprintf>
  802f79:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  802f7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f86:	74 07                	je     802f8f <print_blocks_list+0x73>
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	eb 05                	jmp    802f94 <print_blocks_list+0x78>
  802f8f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f94:	89 45 10             	mov    %eax,0x10(%ebp)
  802f97:	8b 45 10             	mov    0x10(%ebp),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	75 ad                	jne    802f4b <print_blocks_list+0x2f>
  802f9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa2:	75 a7                	jne    802f4b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802fa4:	83 ec 0c             	sub    $0xc,%esp
  802fa7:	68 18 52 80 00       	push   $0x805218
  802fac:	e8 a3 e3 ff ff       	call   801354 <cprintf>
  802fb1:	83 c4 10             	add    $0x10,%esp

}
  802fb4:	90                   	nop
  802fb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802fb8:	c9                   	leave  
  802fb9:	c3                   	ret    

00802fba <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802fba:	55                   	push   %ebp
  802fbb:	89 e5                	mov    %esp,%ebp
  802fbd:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc3:	83 e0 01             	and    $0x1,%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 03                	je     802fcd <initialize_dynamic_allocator+0x13>
  802fca:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802fcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fd1:	0f 84 f8 00 00 00    	je     8030cf <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802fd7:	c7 05 60 60 98 00 01 	movl   $0x1,0x986060
  802fde:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802fe1:	a1 60 60 98 00       	mov    0x986060,%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	0f 84 e2 00 00 00    	je     8030d0 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  803000:	8b 45 0c             	mov    0xc(%ebp),%eax
  803003:	01 d0                	add    %edx,%eax
  803005:	83 e8 04             	sub    $0x4,%eax
  803008:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	83 c0 08             	add    $0x8,%eax
  80301a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80301d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803020:	83 e8 08             	sub    $0x8,%eax
  803023:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	6a 00                	push   $0x0
  80302b:	ff 75 e8             	pushl  -0x18(%ebp)
  80302e:	ff 75 ec             	pushl  -0x14(%ebp)
  803031:	e8 9c 00 00 00       	call   8030d2 <set_block_data>
  803036:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  803039:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  803042:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80304c:	c7 05 84 60 98 00 00 	movl   $0x0,0x986084
  803053:	00 00 00 
  803056:	c7 05 88 60 98 00 00 	movl   $0x0,0x986088
  80305d:	00 00 00 
  803060:	c7 05 90 60 98 00 00 	movl   $0x0,0x986090
  803067:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80306a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80306e:	75 17                	jne    803087 <initialize_dynamic_allocator+0xcd>
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	68 74 52 80 00       	push   $0x805274
  803078:	68 80 00 00 00       	push   $0x80
  80307d:	68 97 52 80 00       	push   $0x805297
  803082:	e8 10 e0 ff ff       	call   801097 <_panic>
  803087:	8b 15 84 60 98 00    	mov    0x986084,%edx
  80308d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803090:	89 10                	mov    %edx,(%eax)
  803092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 0d                	je     8030a8 <initialize_dynamic_allocator+0xee>
  80309b:	a1 84 60 98 00       	mov    0x986084,%eax
  8030a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a3:	89 50 04             	mov    %edx,0x4(%eax)
  8030a6:	eb 08                	jmp    8030b0 <initialize_dynamic_allocator+0xf6>
  8030a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ab:	a3 88 60 98 00       	mov    %eax,0x986088
  8030b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b3:	a3 84 60 98 00       	mov    %eax,0x986084
  8030b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c2:	a1 90 60 98 00       	mov    0x986090,%eax
  8030c7:	40                   	inc    %eax
  8030c8:	a3 90 60 98 00       	mov    %eax,0x986090
  8030cd:	eb 01                	jmp    8030d0 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8030cf:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8030d0:	c9                   	leave  
  8030d1:	c3                   	ret    

008030d2 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8030d2:	55                   	push   %ebp
  8030d3:	89 e5                	mov    %esp,%ebp
  8030d5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8030d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030db:	83 e0 01             	and    $0x1,%eax
  8030de:	85 c0                	test   %eax,%eax
  8030e0:	74 03                	je     8030e5 <set_block_data+0x13>
	{
		totalSize++;
  8030e2:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	83 e8 04             	sub    $0x4,%eax
  8030eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8030ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030f1:	83 e0 fe             	and    $0xfffffffe,%eax
  8030f4:	89 c2                	mov    %eax,%edx
  8030f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8030f9:	83 e0 01             	and    $0x1,%eax
  8030fc:	09 c2                	or     %eax,%edx
  8030fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803101:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  803103:	8b 45 0c             	mov    0xc(%ebp),%eax
  803106:	8d 50 f8             	lea    -0x8(%eax),%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	01 d0                	add    %edx,%eax
  80310e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  803111:	8b 45 0c             	mov    0xc(%ebp),%eax
  803114:	83 e0 fe             	and    $0xfffffffe,%eax
  803117:	89 c2                	mov    %eax,%edx
  803119:	8b 45 10             	mov    0x10(%ebp),%eax
  80311c:	83 e0 01             	and    $0x1,%eax
  80311f:	09 c2                	or     %eax,%edx
  803121:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803124:	89 10                	mov    %edx,(%eax)
}
  803126:	90                   	nop
  803127:	c9                   	leave  
  803128:	c3                   	ret    

00803129 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  803129:	55                   	push   %ebp
  80312a:	89 e5                	mov    %esp,%ebp
  80312c:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80312f:	a1 84 60 98 00       	mov    0x986084,%eax
  803134:	85 c0                	test   %eax,%eax
  803136:	75 68                	jne    8031a0 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  803138:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313c:	75 17                	jne    803155 <insert_sorted_in_freeList+0x2c>
  80313e:	83 ec 04             	sub    $0x4,%esp
  803141:	68 74 52 80 00       	push   $0x805274
  803146:	68 9d 00 00 00       	push   $0x9d
  80314b:	68 97 52 80 00       	push   $0x805297
  803150:	e8 42 df ff ff       	call   801097 <_panic>
  803155:	8b 15 84 60 98 00    	mov    0x986084,%edx
  80315b:	8b 45 08             	mov    0x8(%ebp),%eax
  80315e:	89 10                	mov    %edx,(%eax)
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 00                	mov    (%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0d                	je     803176 <insert_sorted_in_freeList+0x4d>
  803169:	a1 84 60 98 00       	mov    0x986084,%eax
  80316e:	8b 55 08             	mov    0x8(%ebp),%edx
  803171:	89 50 04             	mov    %edx,0x4(%eax)
  803174:	eb 08                	jmp    80317e <insert_sorted_in_freeList+0x55>
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 88 60 98 00       	mov    %eax,0x986088
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	a3 84 60 98 00       	mov    %eax,0x986084
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803190:	a1 90 60 98 00       	mov    0x986090,%eax
  803195:	40                   	inc    %eax
  803196:	a3 90 60 98 00       	mov    %eax,0x986090
		return;
  80319b:	e9 1a 01 00 00       	jmp    8032ba <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8031a0:	a1 84 60 98 00       	mov    0x986084,%eax
  8031a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a8:	eb 7f                	jmp    803229 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031b0:	76 6f                	jbe    803221 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031b6:	74 06                	je     8031be <insert_sorted_in_freeList+0x95>
  8031b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031bc:	75 17                	jne    8031d5 <insert_sorted_in_freeList+0xac>
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	68 b0 52 80 00       	push   $0x8052b0
  8031c6:	68 a6 00 00 00       	push   $0xa6
  8031cb:	68 97 52 80 00       	push   $0x805297
  8031d0:	e8 c2 de ff ff       	call   801097 <_panic>
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	8b 50 04             	mov    0x4(%eax),%edx
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	89 50 04             	mov    %edx,0x4(%eax)
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031e7:	89 10                	mov    %edx,(%eax)
  8031e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ec:	8b 40 04             	mov    0x4(%eax),%eax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	74 0d                	je     803200 <insert_sorted_in_freeList+0xd7>
  8031f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f6:	8b 40 04             	mov    0x4(%eax),%eax
  8031f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031fc:	89 10                	mov    %edx,(%eax)
  8031fe:	eb 08                	jmp    803208 <insert_sorted_in_freeList+0xdf>
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	a3 84 60 98 00       	mov    %eax,0x986084
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 55 08             	mov    0x8(%ebp),%edx
  80320e:	89 50 04             	mov    %edx,0x4(%eax)
  803211:	a1 90 60 98 00       	mov    0x986090,%eax
  803216:	40                   	inc    %eax
  803217:	a3 90 60 98 00       	mov    %eax,0x986090
			return;
  80321c:	e9 99 00 00 00       	jmp    8032ba <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803221:	a1 8c 60 98 00       	mov    0x98608c,%eax
  803226:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803229:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80322d:	74 07                	je     803236 <insert_sorted_in_freeList+0x10d>
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	8b 00                	mov    (%eax),%eax
  803234:	eb 05                	jmp    80323b <insert_sorted_in_freeList+0x112>
  803236:	b8 00 00 00 00       	mov    $0x0,%eax
  80323b:	a3 8c 60 98 00       	mov    %eax,0x98608c
  803240:	a1 8c 60 98 00       	mov    0x98608c,%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	0f 85 5d ff ff ff    	jne    8031aa <insert_sorted_in_freeList+0x81>
  80324d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803251:	0f 85 53 ff ff ff    	jne    8031aa <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  803257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80325b:	75 17                	jne    803274 <insert_sorted_in_freeList+0x14b>
  80325d:	83 ec 04             	sub    $0x4,%esp
  803260:	68 e8 52 80 00       	push   $0x8052e8
  803265:	68 ab 00 00 00       	push   $0xab
  80326a:	68 97 52 80 00       	push   $0x805297
  80326f:	e8 23 de ff ff       	call   801097 <_panic>
  803274:	8b 15 88 60 98 00    	mov    0x986088,%edx
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	89 50 04             	mov    %edx,0x4(%eax)
  803280:	8b 45 08             	mov    0x8(%ebp),%eax
  803283:	8b 40 04             	mov    0x4(%eax),%eax
  803286:	85 c0                	test   %eax,%eax
  803288:	74 0c                	je     803296 <insert_sorted_in_freeList+0x16d>
  80328a:	a1 88 60 98 00       	mov    0x986088,%eax
  80328f:	8b 55 08             	mov    0x8(%ebp),%edx
  803292:	89 10                	mov    %edx,(%eax)
  803294:	eb 08                	jmp    80329e <insert_sorted_in_freeList+0x175>
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	a3 84 60 98 00       	mov    %eax,0x986084
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	a3 88 60 98 00       	mov    %eax,0x986088
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032af:	a1 90 60 98 00       	mov    0x986090,%eax
  8032b4:	40                   	inc    %eax
  8032b5:	a3 90 60 98 00       	mov    %eax,0x986090
}
  8032ba:	c9                   	leave  
  8032bb:	c3                   	ret    

008032bc <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8032bc:	55                   	push   %ebp
  8032bd:	89 e5                	mov    %esp,%ebp
  8032bf:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	83 e0 01             	and    $0x1,%eax
  8032c8:	85 c0                	test   %eax,%eax
  8032ca:	74 03                	je     8032cf <alloc_block_FF+0x13>
  8032cc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8032cf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8032d3:	77 07                	ja     8032dc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8032d5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8032dc:	a1 60 60 98 00       	mov    0x986060,%eax
  8032e1:	85 c0                	test   %eax,%eax
  8032e3:	75 63                	jne    803348 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	83 c0 10             	add    $0x10,%eax
  8032eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8032ee:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8032f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032fb:	01 d0                	add    %edx,%eax
  8032fd:	48                   	dec    %eax
  8032fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803304:	ba 00 00 00 00       	mov    $0x0,%edx
  803309:	f7 75 ec             	divl   -0x14(%ebp)
  80330c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330f:	29 d0                	sub    %edx,%eax
  803311:	c1 e8 0c             	shr    $0xc,%eax
  803314:	83 ec 0c             	sub    $0xc,%esp
  803317:	50                   	push   %eax
  803318:	e8 d1 ed ff ff       	call   8020ee <sbrk>
  80331d:	83 c4 10             	add    $0x10,%esp
  803320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803323:	83 ec 0c             	sub    $0xc,%esp
  803326:	6a 00                	push   $0x0
  803328:	e8 c1 ed ff ff       	call   8020ee <sbrk>
  80332d:	83 c4 10             	add    $0x10,%esp
  803330:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803333:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803336:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803339:	83 ec 08             	sub    $0x8,%esp
  80333c:	50                   	push   %eax
  80333d:	ff 75 e4             	pushl  -0x1c(%ebp)
  803340:	e8 75 fc ff ff       	call   802fba <initialize_dynamic_allocator>
  803345:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  803348:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334c:	75 0a                	jne    803358 <alloc_block_FF+0x9c>
	{
		return NULL;
  80334e:	b8 00 00 00 00       	mov    $0x0,%eax
  803353:	e9 99 03 00 00       	jmp    8036f1 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	83 c0 08             	add    $0x8,%eax
  80335e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803361:	a1 84 60 98 00       	mov    0x986084,%eax
  803366:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803369:	e9 03 02 00 00       	jmp    803571 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  80336e:	83 ec 0c             	sub    $0xc,%esp
  803371:	ff 75 f4             	pushl  -0xc(%ebp)
  803374:	e8 dd fa ff ff       	call   802e56 <get_block_size>
  803379:	83 c4 10             	add    $0x10,%esp
  80337c:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  80337f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  803382:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803385:	0f 82 de 01 00 00    	jb     803569 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80338b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80338e:	83 c0 10             	add    $0x10,%eax
  803391:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  803394:	0f 87 32 01 00 00    	ja     8034cc <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80339a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80339d:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8033a0:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8033a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8033a9:	01 d0                	add    %edx,%eax
  8033ab:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8033ae:	83 ec 04             	sub    $0x4,%esp
  8033b1:	6a 00                	push   $0x0
  8033b3:	ff 75 98             	pushl  -0x68(%ebp)
  8033b6:	ff 75 94             	pushl  -0x6c(%ebp)
  8033b9:	e8 14 fd ff ff       	call   8030d2 <set_block_data>
  8033be:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8033c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033c5:	74 06                	je     8033cd <alloc_block_FF+0x111>
  8033c7:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8033cb:	75 17                	jne    8033e4 <alloc_block_FF+0x128>
  8033cd:	83 ec 04             	sub    $0x4,%esp
  8033d0:	68 0c 53 80 00       	push   $0x80530c
  8033d5:	68 de 00 00 00       	push   $0xde
  8033da:	68 97 52 80 00       	push   $0x805297
  8033df:	e8 b3 dc ff ff       	call   801097 <_panic>
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	8b 10                	mov    (%eax),%edx
  8033e9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8033ec:	89 10                	mov    %edx,(%eax)
  8033ee:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8033f1:	8b 00                	mov    (%eax),%eax
  8033f3:	85 c0                	test   %eax,%eax
  8033f5:	74 0b                	je     803402 <alloc_block_FF+0x146>
  8033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fa:	8b 00                	mov    (%eax),%eax
  8033fc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8033ff:	89 50 04             	mov    %edx,0x4(%eax)
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	8b 55 94             	mov    -0x6c(%ebp),%edx
  803408:	89 10                	mov    %edx,(%eax)
  80340a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80340d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803410:	89 50 04             	mov    %edx,0x4(%eax)
  803413:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803416:	8b 00                	mov    (%eax),%eax
  803418:	85 c0                	test   %eax,%eax
  80341a:	75 08                	jne    803424 <alloc_block_FF+0x168>
  80341c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80341f:	a3 88 60 98 00       	mov    %eax,0x986088
  803424:	a1 90 60 98 00       	mov    0x986090,%eax
  803429:	40                   	inc    %eax
  80342a:	a3 90 60 98 00       	mov    %eax,0x986090

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  80342f:	83 ec 04             	sub    $0x4,%esp
  803432:	6a 01                	push   $0x1
  803434:	ff 75 dc             	pushl  -0x24(%ebp)
  803437:	ff 75 f4             	pushl  -0xc(%ebp)
  80343a:	e8 93 fc ff ff       	call   8030d2 <set_block_data>
  80343f:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803446:	75 17                	jne    80345f <alloc_block_FF+0x1a3>
  803448:	83 ec 04             	sub    $0x4,%esp
  80344b:	68 40 53 80 00       	push   $0x805340
  803450:	68 e3 00 00 00       	push   $0xe3
  803455:	68 97 52 80 00       	push   $0x805297
  80345a:	e8 38 dc ff ff       	call   801097 <_panic>
  80345f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803462:	8b 00                	mov    (%eax),%eax
  803464:	85 c0                	test   %eax,%eax
  803466:	74 10                	je     803478 <alloc_block_FF+0x1bc>
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 00                	mov    (%eax),%eax
  80346d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803470:	8b 52 04             	mov    0x4(%edx),%edx
  803473:	89 50 04             	mov    %edx,0x4(%eax)
  803476:	eb 0b                	jmp    803483 <alloc_block_FF+0x1c7>
  803478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347b:	8b 40 04             	mov    0x4(%eax),%eax
  80347e:	a3 88 60 98 00       	mov    %eax,0x986088
  803483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803486:	8b 40 04             	mov    0x4(%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 0f                	je     80349c <alloc_block_FF+0x1e0>
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803496:	8b 12                	mov    (%edx),%edx
  803498:	89 10                	mov    %edx,(%eax)
  80349a:	eb 0a                	jmp    8034a6 <alloc_block_FF+0x1ea>
  80349c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	a3 84 60 98 00       	mov    %eax,0x986084
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b9:	a1 90 60 98 00       	mov    0x986090,%eax
  8034be:	48                   	dec    %eax
  8034bf:	a3 90 60 98 00       	mov    %eax,0x986090
				return (void*)((uint32*)block);
  8034c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c7:	e9 25 02 00 00       	jmp    8036f1 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8034cc:	83 ec 04             	sub    $0x4,%esp
  8034cf:	6a 01                	push   $0x1
  8034d1:	ff 75 9c             	pushl  -0x64(%ebp)
  8034d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8034d7:	e8 f6 fb ff ff       	call   8030d2 <set_block_data>
  8034dc:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8034df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e3:	75 17                	jne    8034fc <alloc_block_FF+0x240>
  8034e5:	83 ec 04             	sub    $0x4,%esp
  8034e8:	68 40 53 80 00       	push   $0x805340
  8034ed:	68 eb 00 00 00       	push   $0xeb
  8034f2:	68 97 52 80 00       	push   $0x805297
  8034f7:	e8 9b db ff ff       	call   801097 <_panic>
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	8b 00                	mov    (%eax),%eax
  803501:	85 c0                	test   %eax,%eax
  803503:	74 10                	je     803515 <alloc_block_FF+0x259>
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	8b 00                	mov    (%eax),%eax
  80350a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80350d:	8b 52 04             	mov    0x4(%edx),%edx
  803510:	89 50 04             	mov    %edx,0x4(%eax)
  803513:	eb 0b                	jmp    803520 <alloc_block_FF+0x264>
  803515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803518:	8b 40 04             	mov    0x4(%eax),%eax
  80351b:	a3 88 60 98 00       	mov    %eax,0x986088
  803520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803523:	8b 40 04             	mov    0x4(%eax),%eax
  803526:	85 c0                	test   %eax,%eax
  803528:	74 0f                	je     803539 <alloc_block_FF+0x27d>
  80352a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352d:	8b 40 04             	mov    0x4(%eax),%eax
  803530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803533:	8b 12                	mov    (%edx),%edx
  803535:	89 10                	mov    %edx,(%eax)
  803537:	eb 0a                	jmp    803543 <alloc_block_FF+0x287>
  803539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353c:	8b 00                	mov    (%eax),%eax
  80353e:	a3 84 60 98 00       	mov    %eax,0x986084
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80354c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803556:	a1 90 60 98 00       	mov    0x986090,%eax
  80355b:	48                   	dec    %eax
  80355c:	a3 90 60 98 00       	mov    %eax,0x986090
				return (void*)((uint32*)block);
  803561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803564:	e9 88 01 00 00       	jmp    8036f1 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803569:	a1 8c 60 98 00       	mov    0x98608c,%eax
  80356e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803575:	74 07                	je     80357e <alloc_block_FF+0x2c2>
  803577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	eb 05                	jmp    803583 <alloc_block_FF+0x2c7>
  80357e:	b8 00 00 00 00       	mov    $0x0,%eax
  803583:	a3 8c 60 98 00       	mov    %eax,0x98608c
  803588:	a1 8c 60 98 00       	mov    0x98608c,%eax
  80358d:	85 c0                	test   %eax,%eax
  80358f:	0f 85 d9 fd ff ff    	jne    80336e <alloc_block_FF+0xb2>
  803595:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803599:	0f 85 cf fd ff ff    	jne    80336e <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80359f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8035a6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8035ac:	01 d0                	add    %edx,%eax
  8035ae:	48                   	dec    %eax
  8035af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8035b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8035ba:	f7 75 d8             	divl   -0x28(%ebp)
  8035bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8035c0:	29 d0                	sub    %edx,%eax
  8035c2:	c1 e8 0c             	shr    $0xc,%eax
  8035c5:	83 ec 0c             	sub    $0xc,%esp
  8035c8:	50                   	push   %eax
  8035c9:	e8 20 eb ff ff       	call   8020ee <sbrk>
  8035ce:	83 c4 10             	add    $0x10,%esp
  8035d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8035d4:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8035d8:	75 0a                	jne    8035e4 <alloc_block_FF+0x328>
		return NULL;
  8035da:	b8 00 00 00 00       	mov    $0x0,%eax
  8035df:	e9 0d 01 00 00       	jmp    8036f1 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8035e4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8035e7:	83 e8 04             	sub    $0x4,%eax
  8035ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8035ed:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8035f4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8035f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8035fa:	01 d0                	add    %edx,%eax
  8035fc:	48                   	dec    %eax
  8035fd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  803600:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803603:	ba 00 00 00 00       	mov    $0x0,%edx
  803608:	f7 75 c8             	divl   -0x38(%ebp)
  80360b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80360e:	29 d0                	sub    %edx,%eax
  803610:	c1 e8 02             	shr    $0x2,%eax
  803613:	c1 e0 02             	shl    $0x2,%eax
  803616:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803619:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80361c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  803622:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803625:	83 e8 08             	sub    $0x8,%eax
  803628:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80362b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	83 e0 fe             	and    $0xfffffffe,%eax
  803633:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803636:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803639:	f7 d8                	neg    %eax
  80363b:	89 c2                	mov    %eax,%edx
  80363d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803640:	01 d0                	add    %edx,%eax
  803642:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803645:	83 ec 0c             	sub    $0xc,%esp
  803648:	ff 75 b8             	pushl  -0x48(%ebp)
  80364b:	e8 1f f8 ff ff       	call   802e6f <is_free_block>
  803650:	83 c4 10             	add    $0x10,%esp
  803653:	0f be c0             	movsbl %al,%eax
  803656:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803659:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80365d:	74 42                	je     8036a1 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80365f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803666:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803669:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80366c:	01 d0                	add    %edx,%eax
  80366e:	48                   	dec    %eax
  80366f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803672:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803675:	ba 00 00 00 00       	mov    $0x0,%edx
  80367a:	f7 75 b0             	divl   -0x50(%ebp)
  80367d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803680:	29 d0                	sub    %edx,%eax
  803682:	89 c2                	mov    %eax,%edx
  803684:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803687:	01 d0                	add    %edx,%eax
  803689:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80368c:	83 ec 04             	sub    $0x4,%esp
  80368f:	6a 00                	push   $0x0
  803691:	ff 75 a8             	pushl  -0x58(%ebp)
  803694:	ff 75 b8             	pushl  -0x48(%ebp)
  803697:	e8 36 fa ff ff       	call   8030d2 <set_block_data>
  80369c:	83 c4 10             	add    $0x10,%esp
  80369f:	eb 42                	jmp    8036e3 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8036a1:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8036a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8036ab:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8036ae:	01 d0                	add    %edx,%eax
  8036b0:	48                   	dec    %eax
  8036b1:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8036b4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8036b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8036bc:	f7 75 a4             	divl   -0x5c(%ebp)
  8036bf:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8036c2:	29 d0                	sub    %edx,%eax
  8036c4:	83 ec 04             	sub    $0x4,%esp
  8036c7:	6a 00                	push   $0x0
  8036c9:	50                   	push   %eax
  8036ca:	ff 75 d0             	pushl  -0x30(%ebp)
  8036cd:	e8 00 fa ff ff       	call   8030d2 <set_block_data>
  8036d2:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8036d5:	83 ec 0c             	sub    $0xc,%esp
  8036d8:	ff 75 d0             	pushl  -0x30(%ebp)
  8036db:	e8 49 fa ff ff       	call   803129 <insert_sorted_in_freeList>
  8036e0:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8036e3:	83 ec 0c             	sub    $0xc,%esp
  8036e6:	ff 75 08             	pushl  0x8(%ebp)
  8036e9:	e8 ce fb ff ff       	call   8032bc <alloc_block_FF>
  8036ee:	83 c4 10             	add    $0x10,%esp
}
  8036f1:	c9                   	leave  
  8036f2:	c3                   	ret    

008036f3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8036f3:	55                   	push   %ebp
  8036f4:	89 e5                	mov    %esp,%ebp
  8036f6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8036f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036fd:	75 0a                	jne    803709 <alloc_block_BF+0x16>
	{
		return NULL;
  8036ff:	b8 00 00 00 00       	mov    $0x0,%eax
  803704:	e9 7a 02 00 00       	jmp    803983 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	83 c0 08             	add    $0x8,%eax
  80370f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  803712:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803719:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803720:	a1 84 60 98 00       	mov    0x986084,%eax
  803725:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803728:	eb 32                	jmp    80375c <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  80372a:	ff 75 ec             	pushl  -0x14(%ebp)
  80372d:	e8 24 f7 ff ff       	call   802e56 <get_block_size>
  803732:	83 c4 04             	add    $0x4,%esp
  803735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80373b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80373e:	72 14                	jb     803754 <alloc_block_BF+0x61>
  803740:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803743:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803746:	73 0c                	jae    803754 <alloc_block_BF+0x61>
		{
			minBlk = block;
  803748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80374b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80374e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803751:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803754:	a1 8c 60 98 00       	mov    0x98608c,%eax
  803759:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80375c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803760:	74 07                	je     803769 <alloc_block_BF+0x76>
  803762:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803765:	8b 00                	mov    (%eax),%eax
  803767:	eb 05                	jmp    80376e <alloc_block_BF+0x7b>
  803769:	b8 00 00 00 00       	mov    $0x0,%eax
  80376e:	a3 8c 60 98 00       	mov    %eax,0x98608c
  803773:	a1 8c 60 98 00       	mov    0x98608c,%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	75 ae                	jne    80372a <alloc_block_BF+0x37>
  80377c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803780:	75 a8                	jne    80372a <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803786:	75 22                	jne    8037aa <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803788:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80378b:	83 ec 0c             	sub    $0xc,%esp
  80378e:	50                   	push   %eax
  80378f:	e8 5a e9 ff ff       	call   8020ee <sbrk>
  803794:	83 c4 10             	add    $0x10,%esp
  803797:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80379a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80379e:	75 0a                	jne    8037aa <alloc_block_BF+0xb7>
			return NULL;
  8037a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8037a5:	e9 d9 01 00 00       	jmp    803983 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8037aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ad:	83 c0 10             	add    $0x10,%eax
  8037b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8037b3:	0f 87 32 01 00 00    	ja     8038eb <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8037b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8037bf:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8037c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c8:	01 d0                	add    %edx,%eax
  8037ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8037cd:	83 ec 04             	sub    $0x4,%esp
  8037d0:	6a 00                	push   $0x0
  8037d2:	ff 75 dc             	pushl  -0x24(%ebp)
  8037d5:	ff 75 d8             	pushl  -0x28(%ebp)
  8037d8:	e8 f5 f8 ff ff       	call   8030d2 <set_block_data>
  8037dd:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8037e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e4:	74 06                	je     8037ec <alloc_block_BF+0xf9>
  8037e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8037ea:	75 17                	jne    803803 <alloc_block_BF+0x110>
  8037ec:	83 ec 04             	sub    $0x4,%esp
  8037ef:	68 0c 53 80 00       	push   $0x80530c
  8037f4:	68 49 01 00 00       	push   $0x149
  8037f9:	68 97 52 80 00       	push   $0x805297
  8037fe:	e8 94 d8 ff ff       	call   801097 <_panic>
  803803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803806:	8b 10                	mov    (%eax),%edx
  803808:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80380b:	89 10                	mov    %edx,(%eax)
  80380d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803810:	8b 00                	mov    (%eax),%eax
  803812:	85 c0                	test   %eax,%eax
  803814:	74 0b                	je     803821 <alloc_block_BF+0x12e>
  803816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803819:	8b 00                	mov    (%eax),%eax
  80381b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80381e:	89 50 04             	mov    %edx,0x4(%eax)
  803821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803824:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803827:	89 10                	mov    %edx,(%eax)
  803829:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80382c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80382f:	89 50 04             	mov    %edx,0x4(%eax)
  803832:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803835:	8b 00                	mov    (%eax),%eax
  803837:	85 c0                	test   %eax,%eax
  803839:	75 08                	jne    803843 <alloc_block_BF+0x150>
  80383b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80383e:	a3 88 60 98 00       	mov    %eax,0x986088
  803843:	a1 90 60 98 00       	mov    0x986090,%eax
  803848:	40                   	inc    %eax
  803849:	a3 90 60 98 00       	mov    %eax,0x986090

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  80384e:	83 ec 04             	sub    $0x4,%esp
  803851:	6a 01                	push   $0x1
  803853:	ff 75 e8             	pushl  -0x18(%ebp)
  803856:	ff 75 f4             	pushl  -0xc(%ebp)
  803859:	e8 74 f8 ff ff       	call   8030d2 <set_block_data>
  80385e:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803861:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803865:	75 17                	jne    80387e <alloc_block_BF+0x18b>
  803867:	83 ec 04             	sub    $0x4,%esp
  80386a:	68 40 53 80 00       	push   $0x805340
  80386f:	68 4e 01 00 00       	push   $0x14e
  803874:	68 97 52 80 00       	push   $0x805297
  803879:	e8 19 d8 ff ff       	call   801097 <_panic>
  80387e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803881:	8b 00                	mov    (%eax),%eax
  803883:	85 c0                	test   %eax,%eax
  803885:	74 10                	je     803897 <alloc_block_BF+0x1a4>
  803887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388a:	8b 00                	mov    (%eax),%eax
  80388c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80388f:	8b 52 04             	mov    0x4(%edx),%edx
  803892:	89 50 04             	mov    %edx,0x4(%eax)
  803895:	eb 0b                	jmp    8038a2 <alloc_block_BF+0x1af>
  803897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389a:	8b 40 04             	mov    0x4(%eax),%eax
  80389d:	a3 88 60 98 00       	mov    %eax,0x986088
  8038a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a5:	8b 40 04             	mov    0x4(%eax),%eax
  8038a8:	85 c0                	test   %eax,%eax
  8038aa:	74 0f                	je     8038bb <alloc_block_BF+0x1c8>
  8038ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038af:	8b 40 04             	mov    0x4(%eax),%eax
  8038b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8038b5:	8b 12                	mov    (%edx),%edx
  8038b7:	89 10                	mov    %edx,(%eax)
  8038b9:	eb 0a                	jmp    8038c5 <alloc_block_BF+0x1d2>
  8038bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038be:	8b 00                	mov    (%eax),%eax
  8038c0:	a3 84 60 98 00       	mov    %eax,0x986084
  8038c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038d8:	a1 90 60 98 00       	mov    0x986090,%eax
  8038dd:	48                   	dec    %eax
  8038de:	a3 90 60 98 00       	mov    %eax,0x986090
		return (void*)((uint32*)minBlk);
  8038e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038e6:	e9 98 00 00 00       	jmp    803983 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  8038eb:	83 ec 04             	sub    $0x4,%esp
  8038ee:	6a 01                	push   $0x1
  8038f0:	ff 75 f0             	pushl  -0x10(%ebp)
  8038f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8038f6:	e8 d7 f7 ff ff       	call   8030d2 <set_block_data>
  8038fb:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8038fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803902:	75 17                	jne    80391b <alloc_block_BF+0x228>
  803904:	83 ec 04             	sub    $0x4,%esp
  803907:	68 40 53 80 00       	push   $0x805340
  80390c:	68 56 01 00 00       	push   $0x156
  803911:	68 97 52 80 00       	push   $0x805297
  803916:	e8 7c d7 ff ff       	call   801097 <_panic>
  80391b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80391e:	8b 00                	mov    (%eax),%eax
  803920:	85 c0                	test   %eax,%eax
  803922:	74 10                	je     803934 <alloc_block_BF+0x241>
  803924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803927:	8b 00                	mov    (%eax),%eax
  803929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80392c:	8b 52 04             	mov    0x4(%edx),%edx
  80392f:	89 50 04             	mov    %edx,0x4(%eax)
  803932:	eb 0b                	jmp    80393f <alloc_block_BF+0x24c>
  803934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803937:	8b 40 04             	mov    0x4(%eax),%eax
  80393a:	a3 88 60 98 00       	mov    %eax,0x986088
  80393f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803942:	8b 40 04             	mov    0x4(%eax),%eax
  803945:	85 c0                	test   %eax,%eax
  803947:	74 0f                	je     803958 <alloc_block_BF+0x265>
  803949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394c:	8b 40 04             	mov    0x4(%eax),%eax
  80394f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803952:	8b 12                	mov    (%edx),%edx
  803954:	89 10                	mov    %edx,(%eax)
  803956:	eb 0a                	jmp    803962 <alloc_block_BF+0x26f>
  803958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395b:	8b 00                	mov    (%eax),%eax
  80395d:	a3 84 60 98 00       	mov    %eax,0x986084
  803962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803965:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80396b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803975:	a1 90 60 98 00       	mov    0x986090,%eax
  80397a:	48                   	dec    %eax
  80397b:	a3 90 60 98 00       	mov    %eax,0x986090
		return (void*)((uint32*)minBlk);
  803980:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803983:	c9                   	leave  
  803984:	c3                   	ret    

00803985 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803985:	55                   	push   %ebp
  803986:	89 e5                	mov    %esp,%ebp
  803988:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  80398b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80398f:	0f 84 6a 02 00 00    	je     803bff <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803995:	ff 75 08             	pushl  0x8(%ebp)
  803998:	e8 b9 f4 ff ff       	call   802e56 <get_block_size>
  80399d:	83 c4 04             	add    $0x4,%esp
  8039a0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8039a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a6:	83 e8 08             	sub    $0x8,%eax
  8039a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8039ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039af:	8b 00                	mov    (%eax),%eax
  8039b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8039b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8039b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8039ba:	f7 d8                	neg    %eax
  8039bc:	89 c2                	mov    %eax,%edx
  8039be:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c1:	01 d0                	add    %edx,%eax
  8039c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8039c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8039c9:	e8 a1 f4 ff ff       	call   802e6f <is_free_block>
  8039ce:	83 c4 04             	add    $0x4,%esp
  8039d1:	0f be c0             	movsbl %al,%eax
  8039d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8039d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8039da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039dd:	01 d0                	add    %edx,%eax
  8039df:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8039e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8039e5:	e8 85 f4 ff ff       	call   802e6f <is_free_block>
  8039ea:	83 c4 04             	add    $0x4,%esp
  8039ed:	0f be c0             	movsbl %al,%eax
  8039f0:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  8039f3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8039f7:	75 34                	jne    803a2d <free_block+0xa8>
  8039f9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8039fd:	75 2e                	jne    803a2d <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  8039ff:	ff 75 e8             	pushl  -0x18(%ebp)
  803a02:	e8 4f f4 ff ff       	call   802e56 <get_block_size>
  803a07:	83 c4 04             	add    $0x4,%esp
  803a0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  803a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803a13:	01 d0                	add    %edx,%eax
  803a15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803a18:	6a 00                	push   $0x0
  803a1a:	ff 75 d4             	pushl  -0x2c(%ebp)
  803a1d:	ff 75 e8             	pushl  -0x18(%ebp)
  803a20:	e8 ad f6 ff ff       	call   8030d2 <set_block_data>
  803a25:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803a28:	e9 d3 01 00 00       	jmp    803c00 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803a2d:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803a31:	0f 85 c8 00 00 00    	jne    803aff <free_block+0x17a>
  803a37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803a3b:	0f 85 be 00 00 00    	jne    803aff <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803a41:	ff 75 e0             	pushl  -0x20(%ebp)
  803a44:	e8 0d f4 ff ff       	call   802e56 <get_block_size>
  803a49:	83 c4 04             	add    $0x4,%esp
  803a4c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803a55:	01 d0                	add    %edx,%eax
  803a57:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803a5a:	6a 00                	push   $0x0
  803a5c:	ff 75 cc             	pushl  -0x34(%ebp)
  803a5f:	ff 75 08             	pushl  0x8(%ebp)
  803a62:	e8 6b f6 ff ff       	call   8030d2 <set_block_data>
  803a67:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803a6a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803a6e:	75 17                	jne    803a87 <free_block+0x102>
  803a70:	83 ec 04             	sub    $0x4,%esp
  803a73:	68 40 53 80 00       	push   $0x805340
  803a78:	68 87 01 00 00       	push   $0x187
  803a7d:	68 97 52 80 00       	push   $0x805297
  803a82:	e8 10 d6 ff ff       	call   801097 <_panic>
  803a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a8a:	8b 00                	mov    (%eax),%eax
  803a8c:	85 c0                	test   %eax,%eax
  803a8e:	74 10                	je     803aa0 <free_block+0x11b>
  803a90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a93:	8b 00                	mov    (%eax),%eax
  803a95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a98:	8b 52 04             	mov    0x4(%edx),%edx
  803a9b:	89 50 04             	mov    %edx,0x4(%eax)
  803a9e:	eb 0b                	jmp    803aab <free_block+0x126>
  803aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aa3:	8b 40 04             	mov    0x4(%eax),%eax
  803aa6:	a3 88 60 98 00       	mov    %eax,0x986088
  803aab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803aae:	8b 40 04             	mov    0x4(%eax),%eax
  803ab1:	85 c0                	test   %eax,%eax
  803ab3:	74 0f                	je     803ac4 <free_block+0x13f>
  803ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab8:	8b 40 04             	mov    0x4(%eax),%eax
  803abb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803abe:	8b 12                	mov    (%edx),%edx
  803ac0:	89 10                	mov    %edx,(%eax)
  803ac2:	eb 0a                	jmp    803ace <free_block+0x149>
  803ac4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ac7:	8b 00                	mov    (%eax),%eax
  803ac9:	a3 84 60 98 00       	mov    %eax,0x986084
  803ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ad1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803ad7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ada:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ae1:	a1 90 60 98 00       	mov    0x986090,%eax
  803ae6:	48                   	dec    %eax
  803ae7:	a3 90 60 98 00       	mov    %eax,0x986090
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803aec:	83 ec 0c             	sub    $0xc,%esp
  803aef:	ff 75 08             	pushl  0x8(%ebp)
  803af2:	e8 32 f6 ff ff       	call   803129 <insert_sorted_in_freeList>
  803af7:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803afa:	e9 01 01 00 00       	jmp    803c00 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803aff:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803b03:	0f 85 d3 00 00 00    	jne    803bdc <free_block+0x257>
  803b09:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803b0d:	0f 85 c9 00 00 00    	jne    803bdc <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803b13:	83 ec 0c             	sub    $0xc,%esp
  803b16:	ff 75 e8             	pushl  -0x18(%ebp)
  803b19:	e8 38 f3 ff ff       	call   802e56 <get_block_size>
  803b1e:	83 c4 10             	add    $0x10,%esp
  803b21:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803b24:	83 ec 0c             	sub    $0xc,%esp
  803b27:	ff 75 e0             	pushl  -0x20(%ebp)
  803b2a:	e8 27 f3 ff ff       	call   802e56 <get_block_size>
  803b2f:	83 c4 10             	add    $0x10,%esp
  803b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b38:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803b3b:	01 c2                	add    %eax,%edx
  803b3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803b40:	01 d0                	add    %edx,%eax
  803b42:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803b45:	83 ec 04             	sub    $0x4,%esp
  803b48:	6a 00                	push   $0x0
  803b4a:	ff 75 c0             	pushl  -0x40(%ebp)
  803b4d:	ff 75 e8             	pushl  -0x18(%ebp)
  803b50:	e8 7d f5 ff ff       	call   8030d2 <set_block_data>
  803b55:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803b58:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803b5c:	75 17                	jne    803b75 <free_block+0x1f0>
  803b5e:	83 ec 04             	sub    $0x4,%esp
  803b61:	68 40 53 80 00       	push   $0x805340
  803b66:	68 94 01 00 00       	push   $0x194
  803b6b:	68 97 52 80 00       	push   $0x805297
  803b70:	e8 22 d5 ff ff       	call   801097 <_panic>
  803b75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b78:	8b 00                	mov    (%eax),%eax
  803b7a:	85 c0                	test   %eax,%eax
  803b7c:	74 10                	je     803b8e <free_block+0x209>
  803b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803b86:	8b 52 04             	mov    0x4(%edx),%edx
  803b89:	89 50 04             	mov    %edx,0x4(%eax)
  803b8c:	eb 0b                	jmp    803b99 <free_block+0x214>
  803b8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b91:	8b 40 04             	mov    0x4(%eax),%eax
  803b94:	a3 88 60 98 00       	mov    %eax,0x986088
  803b99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803b9c:	8b 40 04             	mov    0x4(%eax),%eax
  803b9f:	85 c0                	test   %eax,%eax
  803ba1:	74 0f                	je     803bb2 <free_block+0x22d>
  803ba3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ba6:	8b 40 04             	mov    0x4(%eax),%eax
  803ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803bac:	8b 12                	mov    (%edx),%edx
  803bae:	89 10                	mov    %edx,(%eax)
  803bb0:	eb 0a                	jmp    803bbc <free_block+0x237>
  803bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bb5:	8b 00                	mov    (%eax),%eax
  803bb7:	a3 84 60 98 00       	mov    %eax,0x986084
  803bbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bcf:	a1 90 60 98 00       	mov    0x986090,%eax
  803bd4:	48                   	dec    %eax
  803bd5:	a3 90 60 98 00       	mov    %eax,0x986090
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803bda:	eb 24                	jmp    803c00 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803bdc:	83 ec 04             	sub    $0x4,%esp
  803bdf:	6a 00                	push   $0x0
  803be1:	ff 75 f4             	pushl  -0xc(%ebp)
  803be4:	ff 75 08             	pushl  0x8(%ebp)
  803be7:	e8 e6 f4 ff ff       	call   8030d2 <set_block_data>
  803bec:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803bef:	83 ec 0c             	sub    $0xc,%esp
  803bf2:	ff 75 08             	pushl  0x8(%ebp)
  803bf5:	e8 2f f5 ff ff       	call   803129 <insert_sorted_in_freeList>
  803bfa:	83 c4 10             	add    $0x10,%esp
  803bfd:	eb 01                	jmp    803c00 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803bff:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803c00:	c9                   	leave  
  803c01:	c3                   	ret    

00803c02 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803c02:	55                   	push   %ebp
  803c03:	89 e5                	mov    %esp,%ebp
  803c05:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803c08:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c0c:	75 10                	jne    803c1e <realloc_block_FF+0x1c>
  803c0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c12:	75 0a                	jne    803c1e <realloc_block_FF+0x1c>
	{
		return NULL;
  803c14:	b8 00 00 00 00       	mov    $0x0,%eax
  803c19:	e9 8b 04 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803c1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803c22:	75 18                	jne    803c3c <realloc_block_FF+0x3a>
	{
		free_block(va);
  803c24:	83 ec 0c             	sub    $0xc,%esp
  803c27:	ff 75 08             	pushl  0x8(%ebp)
  803c2a:	e8 56 fd ff ff       	call   803985 <free_block>
  803c2f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803c32:	b8 00 00 00 00       	mov    $0x0,%eax
  803c37:	e9 6d 04 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c40:	75 13                	jne    803c55 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803c42:	83 ec 0c             	sub    $0xc,%esp
  803c45:	ff 75 0c             	pushl  0xc(%ebp)
  803c48:	e8 6f f6 ff ff       	call   8032bc <alloc_block_FF>
  803c4d:	83 c4 10             	add    $0x10,%esp
  803c50:	e9 54 04 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c58:	83 e0 01             	and    $0x1,%eax
  803c5b:	85 c0                	test   %eax,%eax
  803c5d:	74 03                	je     803c62 <realloc_block_FF+0x60>
	{
		new_size++;
  803c5f:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803c62:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803c66:	77 07                	ja     803c6f <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803c68:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803c6f:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803c73:	83 ec 0c             	sub    $0xc,%esp
  803c76:	ff 75 08             	pushl  0x8(%ebp)
  803c79:	e8 d8 f1 ff ff       	call   802e56 <get_block_size>
  803c7e:	83 c4 10             	add    $0x10,%esp
  803c81:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c87:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803c8a:	75 08                	jne    803c94 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8f:	e9 15 04 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803c94:	8b 55 08             	mov    0x8(%ebp),%edx
  803c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9a:	01 d0                	add    %edx,%eax
  803c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803c9f:	83 ec 0c             	sub    $0xc,%esp
  803ca2:	ff 75 f0             	pushl  -0x10(%ebp)
  803ca5:	e8 c5 f1 ff ff       	call   802e6f <is_free_block>
  803caa:	83 c4 10             	add    $0x10,%esp
  803cad:	0f be c0             	movsbl %al,%eax
  803cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803cb3:	83 ec 0c             	sub    $0xc,%esp
  803cb6:	ff 75 f0             	pushl  -0x10(%ebp)
  803cb9:	e8 98 f1 ff ff       	call   802e56 <get_block_size>
  803cbe:	83 c4 10             	add    $0x10,%esp
  803cc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  803cc7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803cca:	0f 86 a7 02 00 00    	jbe    803f77 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803cd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cd4:	0f 84 86 02 00 00    	je     803f60 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803cda:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ce0:	01 d0                	add    %edx,%eax
  803ce2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803ce5:	0f 85 b2 00 00 00    	jne    803d9d <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803ceb:	83 ec 0c             	sub    $0xc,%esp
  803cee:	ff 75 08             	pushl  0x8(%ebp)
  803cf1:	e8 79 f1 ff ff       	call   802e6f <is_free_block>
  803cf6:	83 c4 10             	add    $0x10,%esp
  803cf9:	84 c0                	test   %al,%al
  803cfb:	0f 94 c0             	sete   %al
  803cfe:	0f b6 c0             	movzbl %al,%eax
  803d01:	83 ec 04             	sub    $0x4,%esp
  803d04:	50                   	push   %eax
  803d05:	ff 75 0c             	pushl  0xc(%ebp)
  803d08:	ff 75 08             	pushl  0x8(%ebp)
  803d0b:	e8 c2 f3 ff ff       	call   8030d2 <set_block_data>
  803d10:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803d13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803d17:	75 17                	jne    803d30 <realloc_block_FF+0x12e>
  803d19:	83 ec 04             	sub    $0x4,%esp
  803d1c:	68 40 53 80 00       	push   $0x805340
  803d21:	68 db 01 00 00       	push   $0x1db
  803d26:	68 97 52 80 00       	push   $0x805297
  803d2b:	e8 67 d3 ff ff       	call   801097 <_panic>
  803d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d33:	8b 00                	mov    (%eax),%eax
  803d35:	85 c0                	test   %eax,%eax
  803d37:	74 10                	je     803d49 <realloc_block_FF+0x147>
  803d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d3c:	8b 00                	mov    (%eax),%eax
  803d3e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d41:	8b 52 04             	mov    0x4(%edx),%edx
  803d44:	89 50 04             	mov    %edx,0x4(%eax)
  803d47:	eb 0b                	jmp    803d54 <realloc_block_FF+0x152>
  803d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d4c:	8b 40 04             	mov    0x4(%eax),%eax
  803d4f:	a3 88 60 98 00       	mov    %eax,0x986088
  803d54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d57:	8b 40 04             	mov    0x4(%eax),%eax
  803d5a:	85 c0                	test   %eax,%eax
  803d5c:	74 0f                	je     803d6d <realloc_block_FF+0x16b>
  803d5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d61:	8b 40 04             	mov    0x4(%eax),%eax
  803d64:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803d67:	8b 12                	mov    (%edx),%edx
  803d69:	89 10                	mov    %edx,(%eax)
  803d6b:	eb 0a                	jmp    803d77 <realloc_block_FF+0x175>
  803d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d70:	8b 00                	mov    (%eax),%eax
  803d72:	a3 84 60 98 00       	mov    %eax,0x986084
  803d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d8a:	a1 90 60 98 00       	mov    0x986090,%eax
  803d8f:	48                   	dec    %eax
  803d90:	a3 90 60 98 00       	mov    %eax,0x986090
				return va;
  803d95:	8b 45 08             	mov    0x8(%ebp),%eax
  803d98:	e9 0c 03 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803d9d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da3:	01 d0                	add    %edx,%eax
  803da5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803da8:	0f 86 b2 01 00 00    	jbe    803f60 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  803db1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803db4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803dba:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803dbd:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803dc0:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803dc4:	0f 87 b8 00 00 00    	ja     803e82 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803dca:	83 ec 0c             	sub    $0xc,%esp
  803dcd:	ff 75 08             	pushl  0x8(%ebp)
  803dd0:	e8 9a f0 ff ff       	call   802e6f <is_free_block>
  803dd5:	83 c4 10             	add    $0x10,%esp
  803dd8:	84 c0                	test   %al,%al
  803dda:	0f 94 c0             	sete   %al
  803ddd:	0f b6 c0             	movzbl %al,%eax
  803de0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803de3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803de6:	01 ca                	add    %ecx,%edx
  803de8:	83 ec 04             	sub    $0x4,%esp
  803deb:	50                   	push   %eax
  803dec:	52                   	push   %edx
  803ded:	ff 75 08             	pushl  0x8(%ebp)
  803df0:	e8 dd f2 ff ff       	call   8030d2 <set_block_data>
  803df5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803df8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803dfc:	75 17                	jne    803e15 <realloc_block_FF+0x213>
  803dfe:	83 ec 04             	sub    $0x4,%esp
  803e01:	68 40 53 80 00       	push   $0x805340
  803e06:	68 e8 01 00 00       	push   $0x1e8
  803e0b:	68 97 52 80 00       	push   $0x805297
  803e10:	e8 82 d2 ff ff       	call   801097 <_panic>
  803e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e18:	8b 00                	mov    (%eax),%eax
  803e1a:	85 c0                	test   %eax,%eax
  803e1c:	74 10                	je     803e2e <realloc_block_FF+0x22c>
  803e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e21:	8b 00                	mov    (%eax),%eax
  803e23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e26:	8b 52 04             	mov    0x4(%edx),%edx
  803e29:	89 50 04             	mov    %edx,0x4(%eax)
  803e2c:	eb 0b                	jmp    803e39 <realloc_block_FF+0x237>
  803e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e31:	8b 40 04             	mov    0x4(%eax),%eax
  803e34:	a3 88 60 98 00       	mov    %eax,0x986088
  803e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e3c:	8b 40 04             	mov    0x4(%eax),%eax
  803e3f:	85 c0                	test   %eax,%eax
  803e41:	74 0f                	je     803e52 <realloc_block_FF+0x250>
  803e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e46:	8b 40 04             	mov    0x4(%eax),%eax
  803e49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803e4c:	8b 12                	mov    (%edx),%edx
  803e4e:	89 10                	mov    %edx,(%eax)
  803e50:	eb 0a                	jmp    803e5c <realloc_block_FF+0x25a>
  803e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e55:	8b 00                	mov    (%eax),%eax
  803e57:	a3 84 60 98 00       	mov    %eax,0x986084
  803e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e6f:	a1 90 60 98 00       	mov    0x986090,%eax
  803e74:	48                   	dec    %eax
  803e75:	a3 90 60 98 00       	mov    %eax,0x986090
					return va;
  803e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7d:	e9 27 02 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803e86:	75 17                	jne    803e9f <realloc_block_FF+0x29d>
  803e88:	83 ec 04             	sub    $0x4,%esp
  803e8b:	68 40 53 80 00       	push   $0x805340
  803e90:	68 ed 01 00 00       	push   $0x1ed
  803e95:	68 97 52 80 00       	push   $0x805297
  803e9a:	e8 f8 d1 ff ff       	call   801097 <_panic>
  803e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ea2:	8b 00                	mov    (%eax),%eax
  803ea4:	85 c0                	test   %eax,%eax
  803ea6:	74 10                	je     803eb8 <realloc_block_FF+0x2b6>
  803ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803eab:	8b 00                	mov    (%eax),%eax
  803ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803eb0:	8b 52 04             	mov    0x4(%edx),%edx
  803eb3:	89 50 04             	mov    %edx,0x4(%eax)
  803eb6:	eb 0b                	jmp    803ec3 <realloc_block_FF+0x2c1>
  803eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ebb:	8b 40 04             	mov    0x4(%eax),%eax
  803ebe:	a3 88 60 98 00       	mov    %eax,0x986088
  803ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ec6:	8b 40 04             	mov    0x4(%eax),%eax
  803ec9:	85 c0                	test   %eax,%eax
  803ecb:	74 0f                	je     803edc <realloc_block_FF+0x2da>
  803ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ed0:	8b 40 04             	mov    0x4(%eax),%eax
  803ed3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ed6:	8b 12                	mov    (%edx),%edx
  803ed8:	89 10                	mov    %edx,(%eax)
  803eda:	eb 0a                	jmp    803ee6 <realloc_block_FF+0x2e4>
  803edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803edf:	8b 00                	mov    (%eax),%eax
  803ee1:	a3 84 60 98 00       	mov    %eax,0x986084
  803ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ef9:	a1 90 60 98 00       	mov    0x986090,%eax
  803efe:	48                   	dec    %eax
  803eff:	a3 90 60 98 00       	mov    %eax,0x986090
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803f04:	8b 55 08             	mov    0x8(%ebp),%edx
  803f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f0a:	01 d0                	add    %edx,%eax
  803f0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803f0f:	83 ec 04             	sub    $0x4,%esp
  803f12:	6a 00                	push   $0x0
  803f14:	ff 75 e0             	pushl  -0x20(%ebp)
  803f17:	ff 75 f0             	pushl  -0x10(%ebp)
  803f1a:	e8 b3 f1 ff ff       	call   8030d2 <set_block_data>
  803f1f:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803f22:	83 ec 0c             	sub    $0xc,%esp
  803f25:	ff 75 08             	pushl  0x8(%ebp)
  803f28:	e8 42 ef ff ff       	call   802e6f <is_free_block>
  803f2d:	83 c4 10             	add    $0x10,%esp
  803f30:	84 c0                	test   %al,%al
  803f32:	0f 94 c0             	sete   %al
  803f35:	0f b6 c0             	movzbl %al,%eax
  803f38:	83 ec 04             	sub    $0x4,%esp
  803f3b:	50                   	push   %eax
  803f3c:	ff 75 0c             	pushl  0xc(%ebp)
  803f3f:	ff 75 08             	pushl  0x8(%ebp)
  803f42:	e8 8b f1 ff ff       	call   8030d2 <set_block_data>
  803f47:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803f4a:	83 ec 0c             	sub    $0xc,%esp
  803f4d:	ff 75 f0             	pushl  -0x10(%ebp)
  803f50:	e8 d4 f1 ff ff       	call   803129 <insert_sorted_in_freeList>
  803f55:	83 c4 10             	add    $0x10,%esp
					return va;
  803f58:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5b:	e9 49 01 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f63:	83 e8 08             	sub    $0x8,%eax
  803f66:	83 ec 0c             	sub    $0xc,%esp
  803f69:	50                   	push   %eax
  803f6a:	e8 4d f3 ff ff       	call   8032bc <alloc_block_FF>
  803f6f:	83 c4 10             	add    $0x10,%esp
  803f72:	e9 32 01 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f7a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803f7d:	0f 83 21 01 00 00    	jae    8040a4 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f86:	2b 45 0c             	sub    0xc(%ebp),%eax
  803f89:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803f8c:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803f90:	77 0e                	ja     803fa0 <realloc_block_FF+0x39e>
  803f92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803f96:	75 08                	jne    803fa0 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803f98:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9b:	e9 09 01 00 00       	jmp    8040a9 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa3:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803fa6:	83 ec 0c             	sub    $0xc,%esp
  803fa9:	ff 75 08             	pushl  0x8(%ebp)
  803fac:	e8 be ee ff ff       	call   802e6f <is_free_block>
  803fb1:	83 c4 10             	add    $0x10,%esp
  803fb4:	84 c0                	test   %al,%al
  803fb6:	0f 94 c0             	sete   %al
  803fb9:	0f b6 c0             	movzbl %al,%eax
  803fbc:	83 ec 04             	sub    $0x4,%esp
  803fbf:	50                   	push   %eax
  803fc0:	ff 75 0c             	pushl  0xc(%ebp)
  803fc3:	ff 75 d8             	pushl  -0x28(%ebp)
  803fc6:	e8 07 f1 ff ff       	call   8030d2 <set_block_data>
  803fcb:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803fce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fd4:	01 d0                	add    %edx,%eax
  803fd6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803fd9:	83 ec 04             	sub    $0x4,%esp
  803fdc:	6a 00                	push   $0x0
  803fde:	ff 75 dc             	pushl  -0x24(%ebp)
  803fe1:	ff 75 d4             	pushl  -0x2c(%ebp)
  803fe4:	e8 e9 f0 ff ff       	call   8030d2 <set_block_data>
  803fe9:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803fec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ff0:	0f 84 9b 00 00 00    	je     804091 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803ff6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803ffc:	01 d0                	add    %edx,%eax
  803ffe:	83 ec 04             	sub    $0x4,%esp
  804001:	6a 00                	push   $0x0
  804003:	50                   	push   %eax
  804004:	ff 75 d4             	pushl  -0x2c(%ebp)
  804007:	e8 c6 f0 ff ff       	call   8030d2 <set_block_data>
  80400c:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80400f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804013:	75 17                	jne    80402c <realloc_block_FF+0x42a>
  804015:	83 ec 04             	sub    $0x4,%esp
  804018:	68 40 53 80 00       	push   $0x805340
  80401d:	68 10 02 00 00       	push   $0x210
  804022:	68 97 52 80 00       	push   $0x805297
  804027:	e8 6b d0 ff ff       	call   801097 <_panic>
  80402c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80402f:	8b 00                	mov    (%eax),%eax
  804031:	85 c0                	test   %eax,%eax
  804033:	74 10                	je     804045 <realloc_block_FF+0x443>
  804035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804038:	8b 00                	mov    (%eax),%eax
  80403a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80403d:	8b 52 04             	mov    0x4(%edx),%edx
  804040:	89 50 04             	mov    %edx,0x4(%eax)
  804043:	eb 0b                	jmp    804050 <realloc_block_FF+0x44e>
  804045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804048:	8b 40 04             	mov    0x4(%eax),%eax
  80404b:	a3 88 60 98 00       	mov    %eax,0x986088
  804050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804053:	8b 40 04             	mov    0x4(%eax),%eax
  804056:	85 c0                	test   %eax,%eax
  804058:	74 0f                	je     804069 <realloc_block_FF+0x467>
  80405a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80405d:	8b 40 04             	mov    0x4(%eax),%eax
  804060:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804063:	8b 12                	mov    (%edx),%edx
  804065:	89 10                	mov    %edx,(%eax)
  804067:	eb 0a                	jmp    804073 <realloc_block_FF+0x471>
  804069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80406c:	8b 00                	mov    (%eax),%eax
  80406e:	a3 84 60 98 00       	mov    %eax,0x986084
  804073:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80407c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80407f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804086:	a1 90 60 98 00       	mov    0x986090,%eax
  80408b:	48                   	dec    %eax
  80408c:	a3 90 60 98 00       	mov    %eax,0x986090
			}
			insert_sorted_in_freeList(remainingBlk);
  804091:	83 ec 0c             	sub    $0xc,%esp
  804094:	ff 75 d4             	pushl  -0x2c(%ebp)
  804097:	e8 8d f0 ff ff       	call   803129 <insert_sorted_in_freeList>
  80409c:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80409f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8040a2:	eb 05                	jmp    8040a9 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8040a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8040a9:	c9                   	leave  
  8040aa:	c3                   	ret    

008040ab <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8040ab:	55                   	push   %ebp
  8040ac:	89 e5                	mov    %esp,%ebp
  8040ae:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8040b1:	83 ec 04             	sub    $0x4,%esp
  8040b4:	68 60 53 80 00       	push   $0x805360
  8040b9:	68 20 02 00 00       	push   $0x220
  8040be:	68 97 52 80 00       	push   $0x805297
  8040c3:	e8 cf cf ff ff       	call   801097 <_panic>

008040c8 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8040c8:	55                   	push   %ebp
  8040c9:	89 e5                	mov    %esp,%ebp
  8040cb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8040ce:	83 ec 04             	sub    $0x4,%esp
  8040d1:	68 88 53 80 00       	push   $0x805388
  8040d6:	68 28 02 00 00       	push   $0x228
  8040db:	68 97 52 80 00       	push   $0x805297
  8040e0:	e8 b2 cf ff ff       	call   801097 <_panic>
  8040e5:	66 90                	xchg   %ax,%ax
  8040e7:	90                   	nop

008040e8 <__udivdi3>:
  8040e8:	55                   	push   %ebp
  8040e9:	57                   	push   %edi
  8040ea:	56                   	push   %esi
  8040eb:	53                   	push   %ebx
  8040ec:	83 ec 1c             	sub    $0x1c,%esp
  8040ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8040f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8040f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8040fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8040ff:	89 ca                	mov    %ecx,%edx
  804101:	89 f8                	mov    %edi,%eax
  804103:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804107:	85 f6                	test   %esi,%esi
  804109:	75 2d                	jne    804138 <__udivdi3+0x50>
  80410b:	39 cf                	cmp    %ecx,%edi
  80410d:	77 65                	ja     804174 <__udivdi3+0x8c>
  80410f:	89 fd                	mov    %edi,%ebp
  804111:	85 ff                	test   %edi,%edi
  804113:	75 0b                	jne    804120 <__udivdi3+0x38>
  804115:	b8 01 00 00 00       	mov    $0x1,%eax
  80411a:	31 d2                	xor    %edx,%edx
  80411c:	f7 f7                	div    %edi
  80411e:	89 c5                	mov    %eax,%ebp
  804120:	31 d2                	xor    %edx,%edx
  804122:	89 c8                	mov    %ecx,%eax
  804124:	f7 f5                	div    %ebp
  804126:	89 c1                	mov    %eax,%ecx
  804128:	89 d8                	mov    %ebx,%eax
  80412a:	f7 f5                	div    %ebp
  80412c:	89 cf                	mov    %ecx,%edi
  80412e:	89 fa                	mov    %edi,%edx
  804130:	83 c4 1c             	add    $0x1c,%esp
  804133:	5b                   	pop    %ebx
  804134:	5e                   	pop    %esi
  804135:	5f                   	pop    %edi
  804136:	5d                   	pop    %ebp
  804137:	c3                   	ret    
  804138:	39 ce                	cmp    %ecx,%esi
  80413a:	77 28                	ja     804164 <__udivdi3+0x7c>
  80413c:	0f bd fe             	bsr    %esi,%edi
  80413f:	83 f7 1f             	xor    $0x1f,%edi
  804142:	75 40                	jne    804184 <__udivdi3+0x9c>
  804144:	39 ce                	cmp    %ecx,%esi
  804146:	72 0a                	jb     804152 <__udivdi3+0x6a>
  804148:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80414c:	0f 87 9e 00 00 00    	ja     8041f0 <__udivdi3+0x108>
  804152:	b8 01 00 00 00       	mov    $0x1,%eax
  804157:	89 fa                	mov    %edi,%edx
  804159:	83 c4 1c             	add    $0x1c,%esp
  80415c:	5b                   	pop    %ebx
  80415d:	5e                   	pop    %esi
  80415e:	5f                   	pop    %edi
  80415f:	5d                   	pop    %ebp
  804160:	c3                   	ret    
  804161:	8d 76 00             	lea    0x0(%esi),%esi
  804164:	31 ff                	xor    %edi,%edi
  804166:	31 c0                	xor    %eax,%eax
  804168:	89 fa                	mov    %edi,%edx
  80416a:	83 c4 1c             	add    $0x1c,%esp
  80416d:	5b                   	pop    %ebx
  80416e:	5e                   	pop    %esi
  80416f:	5f                   	pop    %edi
  804170:	5d                   	pop    %ebp
  804171:	c3                   	ret    
  804172:	66 90                	xchg   %ax,%ax
  804174:	89 d8                	mov    %ebx,%eax
  804176:	f7 f7                	div    %edi
  804178:	31 ff                	xor    %edi,%edi
  80417a:	89 fa                	mov    %edi,%edx
  80417c:	83 c4 1c             	add    $0x1c,%esp
  80417f:	5b                   	pop    %ebx
  804180:	5e                   	pop    %esi
  804181:	5f                   	pop    %edi
  804182:	5d                   	pop    %ebp
  804183:	c3                   	ret    
  804184:	bd 20 00 00 00       	mov    $0x20,%ebp
  804189:	89 eb                	mov    %ebp,%ebx
  80418b:	29 fb                	sub    %edi,%ebx
  80418d:	89 f9                	mov    %edi,%ecx
  80418f:	d3 e6                	shl    %cl,%esi
  804191:	89 c5                	mov    %eax,%ebp
  804193:	88 d9                	mov    %bl,%cl
  804195:	d3 ed                	shr    %cl,%ebp
  804197:	89 e9                	mov    %ebp,%ecx
  804199:	09 f1                	or     %esi,%ecx
  80419b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80419f:	89 f9                	mov    %edi,%ecx
  8041a1:	d3 e0                	shl    %cl,%eax
  8041a3:	89 c5                	mov    %eax,%ebp
  8041a5:	89 d6                	mov    %edx,%esi
  8041a7:	88 d9                	mov    %bl,%cl
  8041a9:	d3 ee                	shr    %cl,%esi
  8041ab:	89 f9                	mov    %edi,%ecx
  8041ad:	d3 e2                	shl    %cl,%edx
  8041af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8041b3:	88 d9                	mov    %bl,%cl
  8041b5:	d3 e8                	shr    %cl,%eax
  8041b7:	09 c2                	or     %eax,%edx
  8041b9:	89 d0                	mov    %edx,%eax
  8041bb:	89 f2                	mov    %esi,%edx
  8041bd:	f7 74 24 0c          	divl   0xc(%esp)
  8041c1:	89 d6                	mov    %edx,%esi
  8041c3:	89 c3                	mov    %eax,%ebx
  8041c5:	f7 e5                	mul    %ebp
  8041c7:	39 d6                	cmp    %edx,%esi
  8041c9:	72 19                	jb     8041e4 <__udivdi3+0xfc>
  8041cb:	74 0b                	je     8041d8 <__udivdi3+0xf0>
  8041cd:	89 d8                	mov    %ebx,%eax
  8041cf:	31 ff                	xor    %edi,%edi
  8041d1:	e9 58 ff ff ff       	jmp    80412e <__udivdi3+0x46>
  8041d6:	66 90                	xchg   %ax,%ax
  8041d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8041dc:	89 f9                	mov    %edi,%ecx
  8041de:	d3 e2                	shl    %cl,%edx
  8041e0:	39 c2                	cmp    %eax,%edx
  8041e2:	73 e9                	jae    8041cd <__udivdi3+0xe5>
  8041e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8041e7:	31 ff                	xor    %edi,%edi
  8041e9:	e9 40 ff ff ff       	jmp    80412e <__udivdi3+0x46>
  8041ee:	66 90                	xchg   %ax,%ax
  8041f0:	31 c0                	xor    %eax,%eax
  8041f2:	e9 37 ff ff ff       	jmp    80412e <__udivdi3+0x46>
  8041f7:	90                   	nop

008041f8 <__umoddi3>:
  8041f8:	55                   	push   %ebp
  8041f9:	57                   	push   %edi
  8041fa:	56                   	push   %esi
  8041fb:	53                   	push   %ebx
  8041fc:	83 ec 1c             	sub    $0x1c,%esp
  8041ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804203:	8b 74 24 34          	mov    0x34(%esp),%esi
  804207:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80420b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80420f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804213:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804217:	89 f3                	mov    %esi,%ebx
  804219:	89 fa                	mov    %edi,%edx
  80421b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80421f:	89 34 24             	mov    %esi,(%esp)
  804222:	85 c0                	test   %eax,%eax
  804224:	75 1a                	jne    804240 <__umoddi3+0x48>
  804226:	39 f7                	cmp    %esi,%edi
  804228:	0f 86 a2 00 00 00    	jbe    8042d0 <__umoddi3+0xd8>
  80422e:	89 c8                	mov    %ecx,%eax
  804230:	89 f2                	mov    %esi,%edx
  804232:	f7 f7                	div    %edi
  804234:	89 d0                	mov    %edx,%eax
  804236:	31 d2                	xor    %edx,%edx
  804238:	83 c4 1c             	add    $0x1c,%esp
  80423b:	5b                   	pop    %ebx
  80423c:	5e                   	pop    %esi
  80423d:	5f                   	pop    %edi
  80423e:	5d                   	pop    %ebp
  80423f:	c3                   	ret    
  804240:	39 f0                	cmp    %esi,%eax
  804242:	0f 87 ac 00 00 00    	ja     8042f4 <__umoddi3+0xfc>
  804248:	0f bd e8             	bsr    %eax,%ebp
  80424b:	83 f5 1f             	xor    $0x1f,%ebp
  80424e:	0f 84 ac 00 00 00    	je     804300 <__umoddi3+0x108>
  804254:	bf 20 00 00 00       	mov    $0x20,%edi
  804259:	29 ef                	sub    %ebp,%edi
  80425b:	89 fe                	mov    %edi,%esi
  80425d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804261:	89 e9                	mov    %ebp,%ecx
  804263:	d3 e0                	shl    %cl,%eax
  804265:	89 d7                	mov    %edx,%edi
  804267:	89 f1                	mov    %esi,%ecx
  804269:	d3 ef                	shr    %cl,%edi
  80426b:	09 c7                	or     %eax,%edi
  80426d:	89 e9                	mov    %ebp,%ecx
  80426f:	d3 e2                	shl    %cl,%edx
  804271:	89 14 24             	mov    %edx,(%esp)
  804274:	89 d8                	mov    %ebx,%eax
  804276:	d3 e0                	shl    %cl,%eax
  804278:	89 c2                	mov    %eax,%edx
  80427a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80427e:	d3 e0                	shl    %cl,%eax
  804280:	89 44 24 04          	mov    %eax,0x4(%esp)
  804284:	8b 44 24 08          	mov    0x8(%esp),%eax
  804288:	89 f1                	mov    %esi,%ecx
  80428a:	d3 e8                	shr    %cl,%eax
  80428c:	09 d0                	or     %edx,%eax
  80428e:	d3 eb                	shr    %cl,%ebx
  804290:	89 da                	mov    %ebx,%edx
  804292:	f7 f7                	div    %edi
  804294:	89 d3                	mov    %edx,%ebx
  804296:	f7 24 24             	mull   (%esp)
  804299:	89 c6                	mov    %eax,%esi
  80429b:	89 d1                	mov    %edx,%ecx
  80429d:	39 d3                	cmp    %edx,%ebx
  80429f:	0f 82 87 00 00 00    	jb     80432c <__umoddi3+0x134>
  8042a5:	0f 84 91 00 00 00    	je     80433c <__umoddi3+0x144>
  8042ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8042af:	29 f2                	sub    %esi,%edx
  8042b1:	19 cb                	sbb    %ecx,%ebx
  8042b3:	89 d8                	mov    %ebx,%eax
  8042b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8042b9:	d3 e0                	shl    %cl,%eax
  8042bb:	89 e9                	mov    %ebp,%ecx
  8042bd:	d3 ea                	shr    %cl,%edx
  8042bf:	09 d0                	or     %edx,%eax
  8042c1:	89 e9                	mov    %ebp,%ecx
  8042c3:	d3 eb                	shr    %cl,%ebx
  8042c5:	89 da                	mov    %ebx,%edx
  8042c7:	83 c4 1c             	add    $0x1c,%esp
  8042ca:	5b                   	pop    %ebx
  8042cb:	5e                   	pop    %esi
  8042cc:	5f                   	pop    %edi
  8042cd:	5d                   	pop    %ebp
  8042ce:	c3                   	ret    
  8042cf:	90                   	nop
  8042d0:	89 fd                	mov    %edi,%ebp
  8042d2:	85 ff                	test   %edi,%edi
  8042d4:	75 0b                	jne    8042e1 <__umoddi3+0xe9>
  8042d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8042db:	31 d2                	xor    %edx,%edx
  8042dd:	f7 f7                	div    %edi
  8042df:	89 c5                	mov    %eax,%ebp
  8042e1:	89 f0                	mov    %esi,%eax
  8042e3:	31 d2                	xor    %edx,%edx
  8042e5:	f7 f5                	div    %ebp
  8042e7:	89 c8                	mov    %ecx,%eax
  8042e9:	f7 f5                	div    %ebp
  8042eb:	89 d0                	mov    %edx,%eax
  8042ed:	e9 44 ff ff ff       	jmp    804236 <__umoddi3+0x3e>
  8042f2:	66 90                	xchg   %ax,%ax
  8042f4:	89 c8                	mov    %ecx,%eax
  8042f6:	89 f2                	mov    %esi,%edx
  8042f8:	83 c4 1c             	add    $0x1c,%esp
  8042fb:	5b                   	pop    %ebx
  8042fc:	5e                   	pop    %esi
  8042fd:	5f                   	pop    %edi
  8042fe:	5d                   	pop    %ebp
  8042ff:	c3                   	ret    
  804300:	3b 04 24             	cmp    (%esp),%eax
  804303:	72 06                	jb     80430b <__umoddi3+0x113>
  804305:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804309:	77 0f                	ja     80431a <__umoddi3+0x122>
  80430b:	89 f2                	mov    %esi,%edx
  80430d:	29 f9                	sub    %edi,%ecx
  80430f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804313:	89 14 24             	mov    %edx,(%esp)
  804316:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80431a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80431e:	8b 14 24             	mov    (%esp),%edx
  804321:	83 c4 1c             	add    $0x1c,%esp
  804324:	5b                   	pop    %ebx
  804325:	5e                   	pop    %esi
  804326:	5f                   	pop    %edi
  804327:	5d                   	pop    %ebp
  804328:	c3                   	ret    
  804329:	8d 76 00             	lea    0x0(%esi),%esi
  80432c:	2b 04 24             	sub    (%esp),%eax
  80432f:	19 fa                	sbb    %edi,%edx
  804331:	89 d1                	mov    %edx,%ecx
  804333:	89 c6                	mov    %eax,%esi
  804335:	e9 71 ff ff ff       	jmp    8042ab <__umoddi3+0xb3>
  80433a:	66 90                	xchg   %ax,%ax
  80433c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804340:	72 ea                	jb     80432c <__umoddi3+0x134>
  804342:	89 d9                	mov    %ebx,%ecx
  804344:	e9 62 ff ff ff       	jmp    8042ab <__umoddi3+0xb3>
