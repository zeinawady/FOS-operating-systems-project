
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 8b 05 00 00       	call   8005c1 <libmain>
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
  800055:	68 c0 39 80 00       	push   $0x8039c0
  80005a:	e8 64 09 00 00       	call   8009c3 <cprintf>
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
  8000a5:	68 f0 39 80 00       	push   $0x8039f0
  8000aa:	e8 14 09 00 00       	call   8009c3 <cprintf>
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
  8000c3:	53                   	push   %ebx
  8000c4:	81 ec a4 00 00 00    	sub    $0xa4,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  8000ca:	a1 40 50 80 00       	mov    0x805040,%eax
  8000cf:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  8000d5:	a1 40 50 80 00       	mov    0x805040,%eax
  8000da:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000e0:	39 c2                	cmp    %eax,%edx
  8000e2:	72 14                	jb     8000f8 <_main+0x38>
			panic("Please increase the WS size");
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	68 29 3a 80 00       	push   $0x803a29
  8000ec:	6a 25                	push   $0x25
  8000ee:	68 45 3a 80 00       	push   $0x803a45
  8000f3:	e8 0e 06 00 00       	call   800706 <_panic>
#endif

	/*=================================================*/


	int eval = 0;
  8000f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	int targetAllocatedSpace = 3*Mega;
  800106:	c7 45 c8 00 00 30 00 	movl   $0x300000,-0x38(%ebp)

	void * va ;
	int idx = 0;
  80010d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	bool chk;
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800114:	e8 7a 1e 00 00       	call   801f93 <sys_pf_calculate_allocated_pages>
  800119:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  80011c:	e8 27 1e 00 00       	call   801f48 <sys_calculate_free_frames>
  800121:	89 45 c0             	mov    %eax,-0x40(%ebp)
	void* expectedVA;
	uint32 actualSize, expectedSize, curTotalSize,roundedTotalSize ;
	//====================================================================//
	/*INITIAL ALLOC Scenario 1: Try to allocate set of blocks with different sizes*/
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 5c 3a 80 00       	push   $0x803a5c
  80012c:	e8 92 08 00 00       	call   8009c3 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800134:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
  80013b:	c7 45 e0 04 00 00 80 	movl   $0x80000004,-0x20(%ebp)
		curTotalSize = sizeof(int);
  800142:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
		for (int i = 0; i < numOfAllocs; ++i)
  800149:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800150:	e9 9e 01 00 00       	jmp    8002f3 <_main+0x233>
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  800155:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80015c:	e9 82 01 00 00       	jmp    8002e3 <_main+0x223>
			{
				actualSize = allocSizes[i] - sizeOfMetaData;
  800161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800164:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80016b:	83 e8 08             	sub    $0x8,%eax
  80016e:	89 45 bc             	mov    %eax,-0x44(%ebp)
				va = startVAs[idx] = malloc(actualSize);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	ff 75 bc             	pushl  -0x44(%ebp)
  800177:	e8 f7 15 00 00       	call   801773 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 c2                	mov    %eax,%edx
  800181:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800184:	89 14 85 a0 50 98 00 	mov    %edx,0x9850a0(,%eax,4)
  80018b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018e:	8b 04 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%eax
  800195:	89 45 b8             	mov    %eax,-0x48(%ebp)
				midVAs[idx] = va + actualSize/2 ;
  800198:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80019b:	d1 e8                	shr    %eax
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a2:	01 c2                	add    %eax,%edx
  8001a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a7:	89 14 85 a0 7c 98 00 	mov    %edx,0x987ca0(,%eax,4)
				endVAs[idx] = va + actualSize - sizeof(short);
  8001ae:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001b1:	8d 50 fe             	lea    -0x2(%eax),%edx
  8001b4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001b7:	01 c2                	add    %eax,%edx
  8001b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bc:	89 14 85 a0 66 98 00 	mov    %edx,0x9866a0(,%eax,4)
				//Check returned va
				expectedVA = (curVA + sizeOfMetaData/2);
  8001c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c6:	83 c0 04             	add    $0x4,%eax
  8001c9:	89 45 b4             	mov    %eax,-0x4c(%ebp)
				expectedSize = allocSizes[i];
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				curTotalSize += allocSizes[i] ;
  8001d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001dc:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  8001e3:	01 45 e4             	add    %eax,-0x1c(%ebp)
				//============================================================
				//Check if the remaining area doesn't fit the DynAllocBlock,
				//so update the curVA & curTotalSize to skip this area
				roundedTotalSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8001e6:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8001ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8001f0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	48                   	dec    %eax
  8001f6:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8001f9:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8001fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800201:	f7 75 b0             	divl   -0x50(%ebp)
  800204:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800207:	29 d0                	sub    %edx,%eax
  800209:	89 45 a8             	mov    %eax,-0x58(%ebp)
				int diff = (roundedTotalSize - curTotalSize) ;
  80020c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80020f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800212:	89 45 a4             	mov    %eax,-0x5c(%ebp)
				if (diff > 0 && diff < (DYN_ALLOC_MIN_BLOCK_SIZE + sizeOfMetaData))
  800215:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  800219:	7e 48                	jle    800263 <_main+0x1a3>
  80021b:	83 7d a4 0f          	cmpl   $0xf,-0x5c(%ebp)
  80021f:	7f 42                	jg     800263 <_main+0x1a3>
				{
//					cprintf("%~\n FRAGMENTATION: curVA = %x diff = %d\n", curVA, diff);
//					cprintf("%~\n Allocated block @ %x with size = %d\n", va, get_block_size(va));

					curVA = ROUNDUP(curVA, PAGE_SIZE)- sizeof(int) /*next alloc will start at END Block (after sbrk)*/;
  800221:	c7 45 a0 00 10 00 00 	movl   $0x1000,-0x60(%ebp)
  800228:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80022b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80022e:	01 d0                	add    %edx,%eax
  800230:	48                   	dec    %eax
  800231:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800234:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800237:	ba 00 00 00 00       	mov    $0x0,%edx
  80023c:	f7 75 a0             	divl   -0x60(%ebp)
  80023f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800242:	29 d0                	sub    %edx,%eax
  800244:	83 e8 04             	sub    $0x4,%eax
  800247:	89 45 e0             	mov    %eax,-0x20(%ebp)
					curTotalSize = roundedTotalSize - sizeof(int) /*exclude END Block*/;
  80024a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80024d:	83 e8 04             	sub    $0x4,%eax
  800250:	89 45 e4             	mov    %eax,-0x1c(%ebp)
					expectedSize += diff - sizeof(int) /*exclude END Block*/;
  800253:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800259:	01 d0                	add    %edx,%eax
  80025b:	83 e8 04             	sub    $0x4,%eax
  80025e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800261:	eb 0d                	jmp    800270 <_main+0x1b0>
				}
				else
				{
					curVA += allocSizes[i] ;
  800263:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800266:	8b 04 85 00 50 80 00 	mov    0x805000(,%eax,4),%eax
  80026d:	01 45 e0             	add    %eax,-0x20(%ebp)
				}
				//============================================================
				if (is_correct)
  800270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800274:	74 37                	je     8002ad <_main+0x1ed>
				{
					if (check_block(va, expectedVA, expectedSize, 1) == 0)
  800276:	6a 01                	push   $0x1
  800278:	ff 75 e8             	pushl  -0x18(%ebp)
  80027b:	ff 75 b4             	pushl  -0x4c(%ebp)
  80027e:	ff 75 b8             	pushl  -0x48(%ebp)
  800281:	e8 b2 fd ff ff       	call   800038 <check_block>
  800286:	83 c4 10             	add    $0x10,%esp
  800289:	85 c0                	test   %eax,%eax
  80028b:	75 20                	jne    8002ad <_main+0x1ed>
					{
						if (is_correct)
  80028d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800291:	74 1a                	je     8002ad <_main+0x1ed>
						{
							is_correct = 0;
  800293:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
							cprintf("alloc_block_xx #1.%d: WRONG ALLOC\n", idx);
  80029a:	83 ec 08             	sub    $0x8,%esp
  80029d:	ff 75 ec             	pushl  -0x14(%ebp)
  8002a0:	68 b8 3a 80 00       	push   $0x803ab8
  8002a5:	e8 19 07 00 00       	call   8009c3 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
						}
					}
				}
				*(startVAs[idx]) = idx ;
  8002ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b0:	8b 14 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%edx
  8002b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ba:	66 89 02             	mov    %ax,(%edx)
				*(midVAs[idx]) = idx ;
  8002bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c0:	8b 14 85 a0 7c 98 00 	mov    0x987ca0(,%eax,4),%edx
  8002c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002ca:	66 89 02             	mov    %ax,(%edx)
				*(endVAs[idx]) = idx ;
  8002cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d0:	8b 14 85 a0 66 98 00 	mov    0x9866a0(,%eax,4),%edx
  8002d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002da:	66 89 02             	mov    %ax,(%edx)
				idx++;
  8002dd:	ff 45 ec             	incl   -0x14(%ebp)
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
		{
			for (int j = 0; j < allocCntPerSize; ++j)
  8002e0:	ff 45 d8             	incl   -0x28(%ebp)
  8002e3:	81 7d d8 c7 00 00 00 	cmpl   $0xc7,-0x28(%ebp)
  8002ea:	0f 8e 71 fe ff ff    	jle    800161 <_main+0xa1>
	cprintf("%~\n1: [BLOCK ALLOCATOR] allocate set of blocks with different sizes [all should fit] [30%]\n") ;
	{
		is_correct = 1;
		void* curVA = (void*) USER_HEAP_START + sizeof(int) /*BEG Block*/ ;
		curTotalSize = sizeof(int);
		for (int i = 0; i < numOfAllocs; ++i)
  8002f0:	ff 45 dc             	incl   -0x24(%ebp)
  8002f3:	83 7d dc 06          	cmpl   $0x6,-0x24(%ebp)
  8002f7:	0f 8e 58 fe ff ff    	jle    800155 <_main+0x95>
				idx++;
			}
			//if (is_correct == 0)
			//break;
		}
		if (is_correct)
  8002fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800301:	74 04                	je     800307 <_main+0x247>
		{
			eval += 30;
  800303:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	//====================================================================//
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
  800307:	83 ec 0c             	sub    $0xc,%esp
  80030a:	68 dc 3a 80 00       	push   $0x803adc
  80030f:	e8 af 06 00 00       	call   8009c3 <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800317:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		for (int i = 0; i < idx; ++i)
  80031e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800325:	eb 5b                	jmp    800382 <_main+0x2c2>
		{
			if (*(startVAs[i]) != i || *(midVAs[i]) != i ||	*(endVAs[i]) != i)
  800327:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80032a:	8b 04 85 a0 50 98 00 	mov    0x9850a0(,%eax,4),%eax
  800331:	66 8b 00             	mov    (%eax),%ax
  800334:	98                   	cwtl   
  800335:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800338:	75 26                	jne    800360 <_main+0x2a0>
  80033a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033d:	8b 04 85 a0 7c 98 00 	mov    0x987ca0(,%eax,4),%eax
  800344:	66 8b 00             	mov    (%eax),%ax
  800347:	98                   	cwtl   
  800348:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80034b:	75 13                	jne    800360 <_main+0x2a0>
  80034d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800350:	8b 04 85 a0 66 98 00 	mov    0x9866a0(,%eax,4),%eax
  800357:	66 8b 00             	mov    (%eax),%ax
  80035a:	98                   	cwtl   
  80035b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80035e:	74 1f                	je     80037f <_main+0x2bf>
			{
				is_correct = 0;
  800360:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800370:	68 18 3b 80 00       	push   $0x803b18
  800375:	e8 49 06 00 00       	call   8009c3 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
				break;
  80037d:	eb 0b                	jmp    80038a <_main+0x2ca>
	/*INITIAL ALLOC Scenario 2: Check stored data inside each allocated block*/
	cprintf("%~\n2: Check stored data inside each allocated block [30%]\n") ;
	{
		is_correct = 1;

		for (int i = 0; i < idx; ++i)
  80037f:	ff 45 d4             	incl   -0x2c(%ebp)
  800382:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800385:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800388:	7c 9d                	jl     800327 <_main+0x267>
				is_correct = 0;
				cprintf("alloc_block_xx #2.%d: WRONG! content of the block is not correct. Expected %d\n",i, i);
				break;
			}
		}
		if (is_correct)
  80038a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80038e:	74 04                	je     800394 <_main+0x2d4>
		{
			eval += 30;
  800390:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
		}
	}

	/*Check page file*/
	cprintf("%~\n3: Check page file size (nothing should be allocated) [10%]\n") ;
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	68 68 3b 80 00       	push   $0x803b68
  80039c:	e8 22 06 00 00       	call   8009c3 <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  8003a4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0)
  8003ab:	e8 e3 1b 00 00       	call   801f93 <sys_pf_calculate_allocated_pages>
  8003b0:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8003b3:	74 17                	je     8003cc <_main+0x30c>
		{
			cprintf("page(s) are allocated in PageFile while not expected to\n");
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	68 a8 3b 80 00       	push   $0x803ba8
  8003bd:	e8 01 06 00 00       	call   8009c3 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8003c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8003cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003d0:	74 04                	je     8003d6 <_main+0x316>
		{
			eval += 10;
  8003d2:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	uint32 expectedAllocatedSize = 0;
  8003d6:	c7 45 98 00 00 00 00 	movl   $0x0,-0x68(%ebp)
//	for (int i = 0; i < numOfAllocs; ++i)
//	{
//		expectedAllocatedSize += allocCntPerSize * allocSizes[i] ;
//	}
//	expectedAllocatedSize = ROUNDUP(expectedAllocatedSize, PAGE_SIZE);
	expectedAllocatedSize = ROUNDUP(curTotalSize, PAGE_SIZE);
  8003dd:	c7 45 94 00 10 00 00 	movl   $0x1000,-0x6c(%ebp)
  8003e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003e7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8003ea:	01 d0                	add    %edx,%eax
  8003ec:	48                   	dec    %eax
  8003ed:	89 45 90             	mov    %eax,-0x70(%ebp)
  8003f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f8:	f7 75 94             	divl   -0x6c(%ebp)
  8003fb:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003fe:	29 d0                	sub    %edx,%eax
  800400:	89 45 98             	mov    %eax,-0x68(%ebp)
	uint32 expectedAllocNumOfPages = expectedAllocatedSize / PAGE_SIZE; 				/*# pages*/
  800403:	8b 45 98             	mov    -0x68(%ebp),%eax
  800406:	c1 e8 0c             	shr    $0xc,%eax
  800409:	89 45 8c             	mov    %eax,-0x74(%ebp)
	uint32 expectedAllocNumOfTables = ROUNDUP(expectedAllocatedSize, PTSIZE) / PTSIZE; 	/*# tables*/
  80040c:	c7 45 88 00 00 40 00 	movl   $0x400000,-0x78(%ebp)
  800413:	8b 55 98             	mov    -0x68(%ebp),%edx
  800416:	8b 45 88             	mov    -0x78(%ebp),%eax
  800419:	01 d0                	add    %edx,%eax
  80041b:	48                   	dec    %eax
  80041c:	89 45 84             	mov    %eax,-0x7c(%ebp)
  80041f:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800422:	ba 00 00 00 00       	mov    $0x0,%edx
  800427:	f7 75 88             	divl   -0x78(%ebp)
  80042a:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80042d:	29 d0                	sub    %edx,%eax
  80042f:	c1 e8 16             	shr    $0x16,%eax
  800432:	89 45 80             	mov    %eax,-0x80(%ebp)
	uint32 expectedAllocNumOfPagesForWS = ROUNDUP(expectedAllocNumOfPages * (sizeof(struct WorkingSetElement) + sizeOfMetaData), PAGE_SIZE) / PAGE_SIZE; 				/*# pages*/
  800435:	c7 85 7c ff ff ff 00 	movl   $0x1000,-0x84(%ebp)
  80043c:	10 00 00 
  80043f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800442:	c1 e0 05             	shl    $0x5,%eax
  800445:	89 c2                	mov    %eax,%edx
  800447:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80044d:	01 d0                	add    %edx,%eax
  80044f:	48                   	dec    %eax
  800450:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800456:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80045c:	ba 00 00 00 00       	mov    $0x0,%edx
  800461:	f7 b5 7c ff ff ff    	divl   -0x84(%ebp)
  800467:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80046d:	29 d0                	sub    %edx,%eax
  80046f:	c1 e8 0c             	shr    $0xc,%eax
  800472:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)

	/*Check memory allocation*/
	cprintf("%~\n4: Check total allocation in RAM (for pages, tables & WS) [10%]\n") ;
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 e4 3b 80 00       	push   $0x803be4
  800480:	e8 3e 05 00 00       	call   8009c3 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800488:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32 expected = expectedAllocNumOfPages + expectedAllocNumOfTables  + expectedAllocNumOfPagesForWS;
  80048f:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800492:	8b 45 80             	mov    -0x80(%ebp),%eax
  800495:	01 c2                	add    %eax,%edx
  800497:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		uint32 actual = (freeFrames - sys_calculate_free_frames()) ;
  8004a5:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8004a8:	e8 9b 1a 00 00       	call   801f48 <sys_calculate_free_frames>
  8004ad:	29 c3                	sub    %eax,%ebx
  8004af:	89 d8                	mov    %ebx,%eax
  8004b1:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		if (expected != actual)
  8004b7:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8004bd:	3b 85 6c ff ff ff    	cmp    -0x94(%ebp),%eax
  8004c3:	74 23                	je     8004e8 <_main+0x428>
		{
			cprintf("number of allocated pages in MEMORY not correct. Expected %d, Actual %d\n", expected, actual);
  8004c5:	83 ec 04             	sub    $0x4,%esp
  8004c8:	ff b5 6c ff ff ff    	pushl  -0x94(%ebp)
  8004ce:	ff b5 70 ff ff ff    	pushl  -0x90(%ebp)
  8004d4:	68 28 3c 80 00       	push   $0x803c28
  8004d9:	e8 e5 04 00 00       	call   8009c3 <cprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  8004e1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  8004e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8004ec:	74 04                	je     8004f2 <_main+0x432>
		{
			eval += 10;
  8004ee:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}
	}

	/*Check WS elements*/
	cprintf("%~\n5: Check content of WS [20%]\n") ;
  8004f2:	83 ec 0c             	sub    $0xc,%esp
  8004f5:	68 74 3c 80 00       	push   $0x803c74
  8004fa:	e8 c4 04 00 00       	call   8009c3 <cprintf>
  8004ff:	83 c4 10             	add    $0x10,%esp
	{
		is_correct = 1;
  800502:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
  800509:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80050c:	c1 e0 02             	shl    $0x2,%eax
  80050f:	83 ec 0c             	sub    $0xc,%esp
  800512:	50                   	push   %eax
  800513:	e8 5b 12 00 00       	call   801773 <malloc>
  800518:	83 c4 10             	add    $0x10,%esp
  80051b:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		int i = 0;
  800521:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  800528:	c7 45 cc 00 00 00 80 	movl   $0x80000000,-0x34(%ebp)
  80052f:	eb 24                	jmp    800555 <_main+0x495>
		{
			expectedVAs[i++] = va;
  800531:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800534:	8d 50 01             	lea    0x1(%eax),%edx
  800537:	89 55 d0             	mov    %edx,-0x30(%ebp)
  80053a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800541:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800547:	01 c2                	add    %eax,%edx
  800549:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80054c:	89 02                	mov    %eax,(%edx)
	cprintf("%~\n5: Check content of WS [20%]\n") ;
	{
		is_correct = 1;
		uint32* expectedVAs = malloc(expectedAllocNumOfPages*sizeof(int));
		int i = 0;
		for (uint32 va = USER_HEAP_START; va < USER_HEAP_START + expectedAllocatedSize; va+=PAGE_SIZE)
  80054e:	81 45 cc 00 10 00 00 	addl   $0x1000,-0x34(%ebp)
  800555:	8b 45 98             	mov    -0x68(%ebp),%eax
  800558:	05 00 00 00 80       	add    $0x80000000,%eax
  80055d:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800560:	77 cf                	ja     800531 <_main+0x471>
		{
			expectedVAs[i++] = va;
		}
		chk = sys_check_WS_list(expectedVAs, expectedAllocNumOfPages, 0, 2);
  800562:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800565:	6a 02                	push   $0x2
  800567:	6a 00                	push   $0x0
  800569:	50                   	push   %eax
  80056a:	ff b5 68 ff ff ff    	pushl  -0x98(%ebp)
  800570:	e8 2e 1e 00 00       	call   8023a3 <sys_check_WS_list>
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
		if (chk != 1)
  80057e:	83 bd 64 ff ff ff 01 	cmpl   $0x1,-0x9c(%ebp)
  800585:	74 17                	je     80059e <_main+0x4de>
		{
			cprintf("malloc: page is not added to WS\n");
  800587:	83 ec 0c             	sub    $0xc,%esp
  80058a:	68 98 3c 80 00       	push   $0x803c98
  80058f:	e8 2f 04 00 00       	call   8009c3 <cprintf>
  800594:	83 c4 10             	add    $0x10,%esp
			is_correct = 0;
  800597:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		}
		if (is_correct)
  80059e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8005a2:	74 04                	je     8005a8 <_main+0x4e8>
		{
			eval += 20;
  8005a4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
		}
	}

	cprintf("%~\ntest malloc (2) [DYNAMIC ALLOCATOR] is finished. Evaluation = %d%\n", eval);
  8005a8:	83 ec 08             	sub    $0x8,%esp
  8005ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ae:	68 bc 3c 80 00       	push   $0x803cbc
  8005b3:	e8 0b 04 00 00       	call   8009c3 <cprintf>
  8005b8:	83 c4 10             	add    $0x10,%esp

	return;
  8005bb:	90                   	nop
}
  8005bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005bf:	c9                   	leave  
  8005c0:	c3                   	ret    

008005c1 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8005c1:	55                   	push   %ebp
  8005c2:	89 e5                	mov    %esp,%ebp
  8005c4:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8005c7:	e8 45 1b 00 00       	call   802111 <sys_getenvindex>
  8005cc:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8005cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005d2:	89 d0                	mov    %edx,%eax
  8005d4:	c1 e0 02             	shl    $0x2,%eax
  8005d7:	01 d0                	add    %edx,%eax
  8005d9:	c1 e0 03             	shl    $0x3,%eax
  8005dc:	01 d0                	add    %edx,%eax
  8005de:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005e5:	01 d0                	add    %edx,%eax
  8005e7:	c1 e0 02             	shl    $0x2,%eax
  8005ea:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005ef:	a3 40 50 80 00       	mov    %eax,0x805040

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005f4:	a1 40 50 80 00       	mov    0x805040,%eax
  8005f9:	8a 40 20             	mov    0x20(%eax),%al
  8005fc:	84 c0                	test   %al,%al
  8005fe:	74 0d                	je     80060d <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800600:	a1 40 50 80 00       	mov    0x805040,%eax
  800605:	83 c0 20             	add    $0x20,%eax
  800608:	a3 20 50 80 00       	mov    %eax,0x805020

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80060d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800611:	7e 0a                	jle    80061d <libmain+0x5c>
		binaryname = argv[0];
  800613:	8b 45 0c             	mov    0xc(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	a3 20 50 80 00       	mov    %eax,0x805020

	// call user main routine
	_main(argc, argv);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	ff 75 0c             	pushl  0xc(%ebp)
  800623:	ff 75 08             	pushl  0x8(%ebp)
  800626:	e8 95 fa ff ff       	call   8000c0 <_main>
  80062b:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80062e:	a1 1c 50 80 00       	mov    0x80501c,%eax
  800633:	85 c0                	test   %eax,%eax
  800635:	0f 84 9f 00 00 00    	je     8006da <libmain+0x119>
	{
		sys_lock_cons();
  80063b:	e8 55 18 00 00       	call   801e95 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800640:	83 ec 0c             	sub    $0xc,%esp
  800643:	68 1c 3d 80 00       	push   $0x803d1c
  800648:	e8 76 03 00 00       	call   8009c3 <cprintf>
  80064d:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800650:	a1 40 50 80 00       	mov    0x805040,%eax
  800655:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80065b:	a1 40 50 80 00       	mov    0x805040,%eax
  800660:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800666:	83 ec 04             	sub    $0x4,%esp
  800669:	52                   	push   %edx
  80066a:	50                   	push   %eax
  80066b:	68 44 3d 80 00       	push   $0x803d44
  800670:	e8 4e 03 00 00       	call   8009c3 <cprintf>
  800675:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800678:	a1 40 50 80 00       	mov    0x805040,%eax
  80067d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800683:	a1 40 50 80 00       	mov    0x805040,%eax
  800688:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80068e:	a1 40 50 80 00       	mov    0x805040,%eax
  800693:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800699:	51                   	push   %ecx
  80069a:	52                   	push   %edx
  80069b:	50                   	push   %eax
  80069c:	68 6c 3d 80 00       	push   $0x803d6c
  8006a1:	e8 1d 03 00 00       	call   8009c3 <cprintf>
  8006a6:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a9:	a1 40 50 80 00       	mov    0x805040,%eax
  8006ae:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8006b4:	83 ec 08             	sub    $0x8,%esp
  8006b7:	50                   	push   %eax
  8006b8:	68 c4 3d 80 00       	push   $0x803dc4
  8006bd:	e8 01 03 00 00       	call   8009c3 <cprintf>
  8006c2:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8006c5:	83 ec 0c             	sub    $0xc,%esp
  8006c8:	68 1c 3d 80 00       	push   $0x803d1c
  8006cd:	e8 f1 02 00 00       	call   8009c3 <cprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8006d5:	e8 d5 17 00 00       	call   801eaf <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8006da:	e8 19 00 00 00       	call   8006f8 <exit>
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006e8:	83 ec 0c             	sub    $0xc,%esp
  8006eb:	6a 00                	push   $0x0
  8006ed:	e8 eb 19 00 00       	call   8020dd <sys_destroy_env>
  8006f2:	83 c4 10             	add    $0x10,%esp
}
  8006f5:	90                   	nop
  8006f6:	c9                   	leave  
  8006f7:	c3                   	ret    

008006f8 <exit>:

void
exit(void)
{
  8006f8:	55                   	push   %ebp
  8006f9:	89 e5                	mov    %esp,%ebp
  8006fb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006fe:	e8 40 1a 00 00       	call   802143 <sys_exit_env>
}
  800703:	90                   	nop
  800704:	c9                   	leave  
  800705:	c3                   	ret    

00800706 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800706:	55                   	push   %ebp
  800707:	89 e5                	mov    %esp,%ebp
  800709:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80070c:	8d 45 10             	lea    0x10(%ebp),%eax
  80070f:	83 c0 04             	add    $0x4,%eax
  800712:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800715:	a1 8c 92 98 00       	mov    0x98928c,%eax
  80071a:	85 c0                	test   %eax,%eax
  80071c:	74 16                	je     800734 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80071e:	a1 8c 92 98 00       	mov    0x98928c,%eax
  800723:	83 ec 08             	sub    $0x8,%esp
  800726:	50                   	push   %eax
  800727:	68 d8 3d 80 00       	push   $0x803dd8
  80072c:	e8 92 02 00 00       	call   8009c3 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800734:	a1 20 50 80 00       	mov    0x805020,%eax
  800739:	ff 75 0c             	pushl  0xc(%ebp)
  80073c:	ff 75 08             	pushl  0x8(%ebp)
  80073f:	50                   	push   %eax
  800740:	68 dd 3d 80 00       	push   $0x803ddd
  800745:	e8 79 02 00 00       	call   8009c3 <cprintf>
  80074a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80074d:	8b 45 10             	mov    0x10(%ebp),%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 f4             	pushl  -0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	e8 fc 01 00 00       	call   800958 <vcprintf>
  80075c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	6a 00                	push   $0x0
  800764:	68 f9 3d 80 00       	push   $0x803df9
  800769:	e8 ea 01 00 00       	call   800958 <vcprintf>
  80076e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800771:	e8 82 ff ff ff       	call   8006f8 <exit>

	// should not return here
	while (1) ;
  800776:	eb fe                	jmp    800776 <_panic+0x70>

00800778 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80077e:	a1 40 50 80 00       	mov    0x805040,%eax
  800783:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800789:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078c:	39 c2                	cmp    %eax,%edx
  80078e:	74 14                	je     8007a4 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800790:	83 ec 04             	sub    $0x4,%esp
  800793:	68 fc 3d 80 00       	push   $0x803dfc
  800798:	6a 26                	push   $0x26
  80079a:	68 48 3e 80 00       	push   $0x803e48
  80079f:	e8 62 ff ff ff       	call   800706 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007b2:	e9 c5 00 00 00       	jmp    80087c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8007b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	01 d0                	add    %edx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	85 c0                	test   %eax,%eax
  8007ca:	75 08                	jne    8007d4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8007cc:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007cf:	e9 a5 00 00 00       	jmp    800879 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8007d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007db:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007e2:	eb 69                	jmp    80084d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8007e9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8007ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007f2:	89 d0                	mov    %edx,%eax
  8007f4:	01 c0                	add    %eax,%eax
  8007f6:	01 d0                	add    %edx,%eax
  8007f8:	c1 e0 03             	shl    $0x3,%eax
  8007fb:	01 c8                	add    %ecx,%eax
  8007fd:	8a 40 04             	mov    0x4(%eax),%al
  800800:	84 c0                	test   %al,%al
  800802:	75 46                	jne    80084a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800804:	a1 40 50 80 00       	mov    0x805040,%eax
  800809:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80080f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800812:	89 d0                	mov    %edx,%eax
  800814:	01 c0                	add    %eax,%eax
  800816:	01 d0                	add    %edx,%eax
  800818:	c1 e0 03             	shl    $0x3,%eax
  80081b:	01 c8                	add    %ecx,%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800822:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800825:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80082a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80082c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	01 c8                	add    %ecx,%eax
  80083b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80083d:	39 c2                	cmp    %eax,%edx
  80083f:	75 09                	jne    80084a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800841:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800848:	eb 15                	jmp    80085f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
  80084d:	a1 40 50 80 00       	mov    0x805040,%eax
  800852:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	39 c2                	cmp    %eax,%edx
  80085d:	77 85                	ja     8007e4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80085f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800863:	75 14                	jne    800879 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800865:	83 ec 04             	sub    $0x4,%esp
  800868:	68 54 3e 80 00       	push   $0x803e54
  80086d:	6a 3a                	push   $0x3a
  80086f:	68 48 3e 80 00       	push   $0x803e48
  800874:	e8 8d fe ff ff       	call   800706 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800879:	ff 45 f0             	incl   -0x10(%ebp)
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800882:	0f 8c 2f ff ff ff    	jl     8007b7 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800888:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800896:	eb 26                	jmp    8008be <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800898:	a1 40 50 80 00       	mov    0x805040,%eax
  80089d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8008a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a6:	89 d0                	mov    %edx,%eax
  8008a8:	01 c0                	add    %eax,%eax
  8008aa:	01 d0                	add    %edx,%eax
  8008ac:	c1 e0 03             	shl    $0x3,%eax
  8008af:	01 c8                	add    %ecx,%eax
  8008b1:	8a 40 04             	mov    0x4(%eax),%al
  8008b4:	3c 01                	cmp    $0x1,%al
  8008b6:	75 03                	jne    8008bb <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8008b8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008bb:	ff 45 e0             	incl   -0x20(%ebp)
  8008be:	a1 40 50 80 00       	mov    0x805040,%eax
  8008c3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8008c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008cc:	39 c2                	cmp    %eax,%edx
  8008ce:	77 c8                	ja     800898 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008d6:	74 14                	je     8008ec <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	68 a8 3e 80 00       	push   $0x803ea8
  8008e0:	6a 44                	push   $0x44
  8008e2:	68 48 3e 80 00       	push   $0x803e48
  8008e7:	e8 1a fe ff ff       	call   800706 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ec:	90                   	nop
  8008ed:	c9                   	leave  
  8008ee:	c3                   	ret    

008008ef <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8008ef:	55                   	push   %ebp
  8008f0:	89 e5                	mov    %esp,%ebp
  8008f2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8008fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800900:	89 0a                	mov    %ecx,(%edx)
  800902:	8b 55 08             	mov    0x8(%ebp),%edx
  800905:	88 d1                	mov    %dl,%cl
  800907:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	3d ff 00 00 00       	cmp    $0xff,%eax
  800918:	75 2c                	jne    800946 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80091a:	a0 80 50 98 00       	mov    0x985080,%al
  80091f:	0f b6 c0             	movzbl %al,%eax
  800922:	8b 55 0c             	mov    0xc(%ebp),%edx
  800925:	8b 12                	mov    (%edx),%edx
  800927:	89 d1                	mov    %edx,%ecx
  800929:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092c:	83 c2 08             	add    $0x8,%edx
  80092f:	83 ec 04             	sub    $0x4,%esp
  800932:	50                   	push   %eax
  800933:	51                   	push   %ecx
  800934:	52                   	push   %edx
  800935:	e8 19 15 00 00       	call   801e53 <sys_cputs>
  80093a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80093d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800946:	8b 45 0c             	mov    0xc(%ebp),%eax
  800949:	8b 40 04             	mov    0x4(%eax),%eax
  80094c:	8d 50 01             	lea    0x1(%eax),%edx
  80094f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800952:	89 50 04             	mov    %edx,0x4(%eax)
}
  800955:	90                   	nop
  800956:	c9                   	leave  
  800957:	c3                   	ret    

00800958 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800961:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800968:	00 00 00 
	b.cnt = 0;
  80096b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800972:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	68 ef 08 80 00       	push   $0x8008ef
  800987:	e8 11 02 00 00       	call   800b9d <vprintfmt>
  80098c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80098f:	a0 80 50 98 00       	mov    0x985080,%al
  800994:	0f b6 c0             	movzbl %al,%eax
  800997:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80099d:	83 ec 04             	sub    $0x4,%esp
  8009a0:	50                   	push   %eax
  8009a1:	52                   	push   %edx
  8009a2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009a8:	83 c0 08             	add    $0x8,%eax
  8009ab:	50                   	push   %eax
  8009ac:	e8 a2 14 00 00       	call   801e53 <sys_cputs>
  8009b1:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009b4:	c6 05 80 50 98 00 00 	movb   $0x0,0x985080
	return b.cnt;
  8009bb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009c1:	c9                   	leave  
  8009c2:	c3                   	ret    

008009c3 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009c9:	c6 05 80 50 98 00 01 	movb   $0x1,0x985080
	va_start(ap, fmt);
  8009d0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8009df:	50                   	push   %eax
  8009e0:	e8 73 ff ff ff       	call   800958 <vcprintf>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ee:	c9                   	leave  
  8009ef:	c3                   	ret    

008009f0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8009f6:	e8 9a 14 00 00       	call   801e95 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8009fb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	83 ec 08             	sub    $0x8,%esp
  800a07:	ff 75 f4             	pushl  -0xc(%ebp)
  800a0a:	50                   	push   %eax
  800a0b:	e8 48 ff ff ff       	call   800958 <vcprintf>
  800a10:	83 c4 10             	add    $0x10,%esp
  800a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800a16:	e8 94 14 00 00       	call   801eaf <sys_unlock_cons>
	return cnt;
  800a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	53                   	push   %ebx
  800a24:	83 ec 14             	sub    $0x14,%esp
  800a27:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a33:	8b 45 18             	mov    0x18(%ebp),%eax
  800a36:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a3e:	77 55                	ja     800a95 <printnum+0x75>
  800a40:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a43:	72 05                	jb     800a4a <printnum+0x2a>
  800a45:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a48:	77 4b                	ja     800a95 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a4a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a4d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a50:	8b 45 18             	mov    0x18(%ebp),%eax
  800a53:	ba 00 00 00 00       	mov    $0x0,%edx
  800a58:	52                   	push   %edx
  800a59:	50                   	push   %eax
  800a5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a60:	e8 ef 2c 00 00       	call   803754 <__udivdi3>
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	83 ec 04             	sub    $0x4,%esp
  800a6b:	ff 75 20             	pushl  0x20(%ebp)
  800a6e:	53                   	push   %ebx
  800a6f:	ff 75 18             	pushl  0x18(%ebp)
  800a72:	52                   	push   %edx
  800a73:	50                   	push   %eax
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	ff 75 08             	pushl  0x8(%ebp)
  800a7a:	e8 a1 ff ff ff       	call   800a20 <printnum>
  800a7f:	83 c4 20             	add    $0x20,%esp
  800a82:	eb 1a                	jmp    800a9e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 20             	pushl  0x20(%ebp)
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	ff d0                	call   *%eax
  800a92:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a95:	ff 4d 1c             	decl   0x1c(%ebp)
  800a98:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a9c:	7f e6                	jg     800a84 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a9e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aa1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	53                   	push   %ebx
  800aad:	51                   	push   %ecx
  800aae:	52                   	push   %edx
  800aaf:	50                   	push   %eax
  800ab0:	e8 af 2d 00 00       	call   803864 <__umoddi3>
  800ab5:	83 c4 10             	add    $0x10,%esp
  800ab8:	05 14 41 80 00       	add    $0x804114,%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	0f be c0             	movsbl %al,%eax
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	50                   	push   %eax
  800ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  800acc:	ff d0                	call   *%eax
  800ace:	83 c4 10             	add    $0x10,%esp
}
  800ad1:	90                   	nop
  800ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad5:	c9                   	leave  
  800ad6:	c3                   	ret    

00800ad7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ada:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ade:	7e 1c                	jle    800afc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 08             	lea    0x8(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 08             	sub    $0x8,%eax
  800af5:	8b 50 04             	mov    0x4(%eax),%edx
  800af8:	8b 00                	mov    (%eax),%eax
  800afa:	eb 40                	jmp    800b3c <getuint+0x65>
	else if (lflag)
  800afc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b00:	74 1e                	je     800b20 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 00                	mov    (%eax),%eax
  800b07:	8d 50 04             	lea    0x4(%eax),%edx
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	89 10                	mov    %edx,(%eax)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 00                	mov    (%eax),%eax
  800b14:	83 e8 04             	sub    $0x4,%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1e:	eb 1c                	jmp    800b3c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8b 00                	mov    (%eax),%eax
  800b25:	8d 50 04             	lea    0x4(%eax),%edx
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 10                	mov    %edx,(%eax)
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 00                	mov    (%eax),%eax
  800b32:	83 e8 04             	sub    $0x4,%eax
  800b35:	8b 00                	mov    (%eax),%eax
  800b37:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b41:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b45:	7e 1c                	jle    800b63 <getint+0x25>
		return va_arg(*ap, long long);
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 00                	mov    (%eax),%eax
  800b4c:	8d 50 08             	lea    0x8(%eax),%edx
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	89 10                	mov    %edx,(%eax)
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	8b 00                	mov    (%eax),%eax
  800b59:	83 e8 08             	sub    $0x8,%eax
  800b5c:	8b 50 04             	mov    0x4(%eax),%edx
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	eb 38                	jmp    800b9b <getint+0x5d>
	else if (lflag)
  800b63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b67:	74 1a                	je     800b83 <getint+0x45>
		return va_arg(*ap, long);
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8b 00                	mov    (%eax),%eax
  800b6e:	8d 50 04             	lea    0x4(%eax),%edx
  800b71:	8b 45 08             	mov    0x8(%ebp),%eax
  800b74:	89 10                	mov    %edx,(%eax)
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	8b 00                	mov    (%eax),%eax
  800b7b:	83 e8 04             	sub    $0x4,%eax
  800b7e:	8b 00                	mov    (%eax),%eax
  800b80:	99                   	cltd   
  800b81:	eb 18                	jmp    800b9b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8b 00                	mov    (%eax),%eax
  800b88:	8d 50 04             	lea    0x4(%eax),%edx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 10                	mov    %edx,(%eax)
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	8b 00                	mov    (%eax),%eax
  800b95:	83 e8 04             	sub    $0x4,%eax
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	99                   	cltd   
}
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ba5:	eb 17                	jmp    800bbe <vprintfmt+0x21>
			if (ch == '\0')
  800ba7:	85 db                	test   %ebx,%ebx
  800ba9:	0f 84 c1 03 00 00    	je     800f70 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800baf:	83 ec 08             	sub    $0x8,%esp
  800bb2:	ff 75 0c             	pushl  0xc(%ebp)
  800bb5:	53                   	push   %ebx
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc1:	8d 50 01             	lea    0x1(%eax),%edx
  800bc4:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc7:	8a 00                	mov    (%eax),%al
  800bc9:	0f b6 d8             	movzbl %al,%ebx
  800bcc:	83 fb 25             	cmp    $0x25,%ebx
  800bcf:	75 d6                	jne    800ba7 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bd1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bd5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bdc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800be3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	8d 50 01             	lea    0x1(%eax),%edx
  800bf7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bfa:	8a 00                	mov    (%eax),%al
  800bfc:	0f b6 d8             	movzbl %al,%ebx
  800bff:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c02:	83 f8 5b             	cmp    $0x5b,%eax
  800c05:	0f 87 3d 03 00 00    	ja     800f48 <vprintfmt+0x3ab>
  800c0b:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
  800c12:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c14:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c18:	eb d7                	jmp    800bf1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c1a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c1e:	eb d1                	jmp    800bf1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c27:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c2a:	89 d0                	mov    %edx,%eax
  800c2c:	c1 e0 02             	shl    $0x2,%eax
  800c2f:	01 d0                	add    %edx,%eax
  800c31:	01 c0                	add    %eax,%eax
  800c33:	01 d8                	add    %ebx,%eax
  800c35:	83 e8 30             	sub    $0x30,%eax
  800c38:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8a 00                	mov    (%eax),%al
  800c40:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c43:	83 fb 2f             	cmp    $0x2f,%ebx
  800c46:	7e 3e                	jle    800c86 <vprintfmt+0xe9>
  800c48:	83 fb 39             	cmp    $0x39,%ebx
  800c4b:	7f 39                	jg     800c86 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c4d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c50:	eb d5                	jmp    800c27 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c52:	8b 45 14             	mov    0x14(%ebp),%eax
  800c55:	83 c0 04             	add    $0x4,%eax
  800c58:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5e:	83 e8 04             	sub    $0x4,%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c66:	eb 1f                	jmp    800c87 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c6c:	79 83                	jns    800bf1 <vprintfmt+0x54>
				width = 0;
  800c6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c75:	e9 77 ff ff ff       	jmp    800bf1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c7a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c81:	e9 6b ff ff ff       	jmp    800bf1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c86:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c87:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8b:	0f 89 60 ff ff ff    	jns    800bf1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c97:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c9e:	e9 4e ff ff ff       	jmp    800bf1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ca3:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ca6:	e9 46 ff ff ff       	jmp    800bf1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 c0 04             	add    $0x4,%eax
  800cb1:	89 45 14             	mov    %eax,0x14(%ebp)
  800cb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cb7:	83 e8 04             	sub    $0x4,%eax
  800cba:	8b 00                	mov    (%eax),%eax
  800cbc:	83 ec 08             	sub    $0x8,%esp
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	50                   	push   %eax
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	ff d0                	call   *%eax
  800cc8:	83 c4 10             	add    $0x10,%esp
			break;
  800ccb:	e9 9b 02 00 00       	jmp    800f6b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cd0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd3:	83 c0 04             	add    $0x4,%eax
  800cd6:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ce1:	85 db                	test   %ebx,%ebx
  800ce3:	79 02                	jns    800ce7 <vprintfmt+0x14a>
				err = -err;
  800ce5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ce7:	83 fb 64             	cmp    $0x64,%ebx
  800cea:	7f 0b                	jg     800cf7 <vprintfmt+0x15a>
  800cec:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  800cf3:	85 f6                	test   %esi,%esi
  800cf5:	75 19                	jne    800d10 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cf7:	53                   	push   %ebx
  800cf8:	68 25 41 80 00       	push   $0x804125
  800cfd:	ff 75 0c             	pushl  0xc(%ebp)
  800d00:	ff 75 08             	pushl  0x8(%ebp)
  800d03:	e8 70 02 00 00       	call   800f78 <printfmt>
  800d08:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d0b:	e9 5b 02 00 00       	jmp    800f6b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d10:	56                   	push   %esi
  800d11:	68 2e 41 80 00       	push   $0x80412e
  800d16:	ff 75 0c             	pushl  0xc(%ebp)
  800d19:	ff 75 08             	pushl  0x8(%ebp)
  800d1c:	e8 57 02 00 00       	call   800f78 <printfmt>
  800d21:	83 c4 10             	add    $0x10,%esp
			break;
  800d24:	e9 42 02 00 00       	jmp    800f6b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d29:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2c:	83 c0 04             	add    $0x4,%eax
  800d2f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d32:	8b 45 14             	mov    0x14(%ebp),%eax
  800d35:	83 e8 04             	sub    $0x4,%eax
  800d38:	8b 30                	mov    (%eax),%esi
  800d3a:	85 f6                	test   %esi,%esi
  800d3c:	75 05                	jne    800d43 <vprintfmt+0x1a6>
				p = "(null)";
  800d3e:	be 31 41 80 00       	mov    $0x804131,%esi
			if (width > 0 && padc != '-')
  800d43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d47:	7e 6d                	jle    800db6 <vprintfmt+0x219>
  800d49:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d4d:	74 67                	je     800db6 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	50                   	push   %eax
  800d56:	56                   	push   %esi
  800d57:	e8 1e 03 00 00       	call   80107a <strnlen>
  800d5c:	83 c4 10             	add    $0x10,%esp
  800d5f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d62:	eb 16                	jmp    800d7a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d64:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	ff 75 0c             	pushl  0xc(%ebp)
  800d6e:	50                   	push   %eax
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	ff d0                	call   *%eax
  800d74:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d77:	ff 4d e4             	decl   -0x1c(%ebp)
  800d7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d7e:	7f e4                	jg     800d64 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d80:	eb 34                	jmp    800db6 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d82:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d86:	74 1c                	je     800da4 <vprintfmt+0x207>
  800d88:	83 fb 1f             	cmp    $0x1f,%ebx
  800d8b:	7e 05                	jle    800d92 <vprintfmt+0x1f5>
  800d8d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d90:	7e 12                	jle    800da4 <vprintfmt+0x207>
					putch('?', putdat);
  800d92:	83 ec 08             	sub    $0x8,%esp
  800d95:	ff 75 0c             	pushl  0xc(%ebp)
  800d98:	6a 3f                	push   $0x3f
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
  800da2:	eb 0f                	jmp    800db3 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800da4:	83 ec 08             	sub    $0x8,%esp
  800da7:	ff 75 0c             	pushl  0xc(%ebp)
  800daa:	53                   	push   %ebx
  800dab:	8b 45 08             	mov    0x8(%ebp),%eax
  800dae:	ff d0                	call   *%eax
  800db0:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800db3:	ff 4d e4             	decl   -0x1c(%ebp)
  800db6:	89 f0                	mov    %esi,%eax
  800db8:	8d 70 01             	lea    0x1(%eax),%esi
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	0f be d8             	movsbl %al,%ebx
  800dc0:	85 db                	test   %ebx,%ebx
  800dc2:	74 24                	je     800de8 <vprintfmt+0x24b>
  800dc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc8:	78 b8                	js     800d82 <vprintfmt+0x1e5>
  800dca:	ff 4d e0             	decl   -0x20(%ebp)
  800dcd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd1:	79 af                	jns    800d82 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd3:	eb 13                	jmp    800de8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 20                	push   $0x20
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de5:	ff 4d e4             	decl   -0x1c(%ebp)
  800de8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dec:	7f e7                	jg     800dd5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dee:	e9 78 01 00 00       	jmp    800f6b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800df3:	83 ec 08             	sub    $0x8,%esp
  800df6:	ff 75 e8             	pushl  -0x18(%ebp)
  800df9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dfc:	50                   	push   %eax
  800dfd:	e8 3c fd ff ff       	call   800b3e <getint>
  800e02:	83 c4 10             	add    $0x10,%esp
  800e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e08:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e11:	85 d2                	test   %edx,%edx
  800e13:	79 23                	jns    800e38 <vprintfmt+0x29b>
				putch('-', putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	6a 2d                	push   $0x2d
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	ff d0                	call   *%eax
  800e22:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e2b:	f7 d8                	neg    %eax
  800e2d:	83 d2 00             	adc    $0x0,%edx
  800e30:	f7 da                	neg    %edx
  800e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e35:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e38:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e3f:	e9 bc 00 00 00       	jmp    800f00 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e44:	83 ec 08             	sub    $0x8,%esp
  800e47:	ff 75 e8             	pushl  -0x18(%ebp)
  800e4a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e4d:	50                   	push   %eax
  800e4e:	e8 84 fc ff ff       	call   800ad7 <getuint>
  800e53:	83 c4 10             	add    $0x10,%esp
  800e56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e59:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e5c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e63:	e9 98 00 00 00       	jmp    800f00 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e68:	83 ec 08             	sub    $0x8,%esp
  800e6b:	ff 75 0c             	pushl  0xc(%ebp)
  800e6e:	6a 58                	push   $0x58
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	ff d0                	call   *%eax
  800e75:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e78:	83 ec 08             	sub    $0x8,%esp
  800e7b:	ff 75 0c             	pushl  0xc(%ebp)
  800e7e:	6a 58                	push   $0x58
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	ff d0                	call   *%eax
  800e85:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e88:	83 ec 08             	sub    $0x8,%esp
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	6a 58                	push   $0x58
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	ff d0                	call   *%eax
  800e95:	83 c4 10             	add    $0x10,%esp
			break;
  800e98:	e9 ce 00 00 00       	jmp    800f6b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800e9d:	83 ec 08             	sub    $0x8,%esp
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	6a 30                	push   $0x30
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	ff d0                	call   *%eax
  800eaa:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ead:	83 ec 08             	sub    $0x8,%esp
  800eb0:	ff 75 0c             	pushl  0xc(%ebp)
  800eb3:	6a 78                	push   $0x78
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 c0 04             	add    $0x4,%eax
  800ec3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec9:	83 e8 04             	sub    $0x4,%eax
  800ecc:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ece:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ed1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ed8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800edf:	eb 1f                	jmp    800f00 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ee1:	83 ec 08             	sub    $0x8,%esp
  800ee4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ee7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eea:	50                   	push   %eax
  800eeb:	e8 e7 fb ff ff       	call   800ad7 <getuint>
  800ef0:	83 c4 10             	add    $0x10,%esp
  800ef3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ef6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ef9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f00:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f07:	83 ec 04             	sub    $0x4,%esp
  800f0a:	52                   	push   %edx
  800f0b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f0e:	50                   	push   %eax
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	ff 75 f0             	pushl  -0x10(%ebp)
  800f15:	ff 75 0c             	pushl  0xc(%ebp)
  800f18:	ff 75 08             	pushl  0x8(%ebp)
  800f1b:	e8 00 fb ff ff       	call   800a20 <printnum>
  800f20:	83 c4 20             	add    $0x20,%esp
			break;
  800f23:	eb 46                	jmp    800f6b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 0c             	pushl  0xc(%ebp)
  800f2b:	53                   	push   %ebx
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	ff d0                	call   *%eax
  800f31:	83 c4 10             	add    $0x10,%esp
			break;
  800f34:	eb 35                	jmp    800f6b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800f36:	c6 05 80 50 98 00 00 	movb   $0x0,0x985080
			break;
  800f3d:	eb 2c                	jmp    800f6b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800f3f:	c6 05 80 50 98 00 01 	movb   $0x1,0x985080
			break;
  800f46:	eb 23                	jmp    800f6b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	ff 75 0c             	pushl  0xc(%ebp)
  800f4e:	6a 25                	push   $0x25
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	ff d0                	call   *%eax
  800f55:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f58:	ff 4d 10             	decl   0x10(%ebp)
  800f5b:	eb 03                	jmp    800f60 <vprintfmt+0x3c3>
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	8b 45 10             	mov    0x10(%ebp),%eax
  800f63:	48                   	dec    %eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 25                	cmp    $0x25,%al
  800f68:	75 f3                	jne    800f5d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800f6a:	90                   	nop
		}
	}
  800f6b:	e9 35 fc ff ff       	jmp    800ba5 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f70:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f71:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    

00800f78 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f81:	83 c0 04             	add    $0x4,%eax
  800f84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f87:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8d:	50                   	push   %eax
  800f8e:	ff 75 0c             	pushl  0xc(%ebp)
  800f91:	ff 75 08             	pushl  0x8(%ebp)
  800f94:	e8 04 fc ff ff       	call   800b9d <vprintfmt>
  800f99:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f9c:	90                   	nop
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8b 40 08             	mov    0x8(%eax),%eax
  800fa8:	8d 50 01             	lea    0x1(%eax),%edx
  800fab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fae:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	8b 10                	mov    (%eax),%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 40 04             	mov    0x4(%eax),%eax
  800fbc:	39 c2                	cmp    %eax,%edx
  800fbe:	73 12                	jae    800fd2 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	8b 00                	mov    (%eax),%eax
  800fc5:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcb:	89 0a                	mov    %ecx,(%edx)
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	88 10                	mov    %dl,(%eax)
}
  800fd2:	90                   	nop
  800fd3:	5d                   	pop    %ebp
  800fd4:	c3                   	ret    

00800fd5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ffa:	74 06                	je     801002 <vsnprintf+0x2d>
  800ffc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801000:	7f 07                	jg     801009 <vsnprintf+0x34>
		return -E_INVAL;
  801002:	b8 03 00 00 00       	mov    $0x3,%eax
  801007:	eb 20                	jmp    801029 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801009:	ff 75 14             	pushl  0x14(%ebp)
  80100c:	ff 75 10             	pushl  0x10(%ebp)
  80100f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801012:	50                   	push   %eax
  801013:	68 9f 0f 80 00       	push   $0x800f9f
  801018:	e8 80 fb ff ff       	call   800b9d <vprintfmt>
  80101d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801020:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801023:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801026:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801029:	c9                   	leave  
  80102a:	c3                   	ret    

0080102b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801031:	8d 45 10             	lea    0x10(%ebp),%eax
  801034:	83 c0 04             	add    $0x4,%eax
  801037:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	ff 75 f4             	pushl  -0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	ff 75 0c             	pushl  0xc(%ebp)
  801044:	ff 75 08             	pushl  0x8(%ebp)
  801047:	e8 89 ff ff ff       	call   800fd5 <vsnprintf>
  80104c:	83 c4 10             	add    $0x10,%esp
  80104f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801052:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801055:	c9                   	leave  
  801056:	c3                   	ret    

00801057 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801064:	eb 06                	jmp    80106c <strlen+0x15>
		n++;
  801066:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801069:	ff 45 08             	incl   0x8(%ebp)
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	84 c0                	test   %al,%al
  801073:	75 f1                	jne    801066 <strlen+0xf>
		n++;
	return n;
  801075:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801080:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801087:	eb 09                	jmp    801092 <strnlen+0x18>
		n++;
  801089:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80108c:	ff 45 08             	incl   0x8(%ebp)
  80108f:	ff 4d 0c             	decl   0xc(%ebp)
  801092:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801096:	74 09                	je     8010a1 <strnlen+0x27>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	84 c0                	test   %al,%al
  80109f:	75 e8                	jne    801089 <strnlen+0xf>
		n++;
	return n;
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a4:	c9                   	leave  
  8010a5:	c3                   	ret    

008010a6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
  8010a9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010b2:	90                   	nop
  8010b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b6:	8d 50 01             	lea    0x1(%eax),%edx
  8010b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8010bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c5:	8a 12                	mov    (%edx),%dl
  8010c7:	88 10                	mov    %dl,(%eax)
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	84 c0                	test   %al,%al
  8010cd:	75 e4                	jne    8010b3 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010d2:	c9                   	leave  
  8010d3:	c3                   	ret    

008010d4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e7:	eb 1f                	jmp    801108 <strncpy+0x34>
		*dst++ = *src;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8a 12                	mov    (%edx),%dl
  8010f7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	84 c0                	test   %al,%al
  801100:	74 03                	je     801105 <strncpy+0x31>
			src++;
  801102:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801105:	ff 45 fc             	incl   -0x4(%ebp)
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	72 d9                	jb     8010e9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801110:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801121:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801125:	74 30                	je     801157 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801127:	eb 16                	jmp    80113f <strlcpy+0x2a>
			*dst++ = *src++;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8d 50 01             	lea    0x1(%eax),%edx
  80112f:	89 55 08             	mov    %edx,0x8(%ebp)
  801132:	8b 55 0c             	mov    0xc(%ebp),%edx
  801135:	8d 4a 01             	lea    0x1(%edx),%ecx
  801138:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113b:	8a 12                	mov    (%edx),%dl
  80113d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113f:	ff 4d 10             	decl   0x10(%ebp)
  801142:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801146:	74 09                	je     801151 <strlcpy+0x3c>
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	84 c0                	test   %al,%al
  80114f:	75 d8                	jne    801129 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801157:	8b 55 08             	mov    0x8(%ebp),%edx
  80115a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115d:	29 c2                	sub    %eax,%edx
  80115f:	89 d0                	mov    %edx,%eax
}
  801161:	c9                   	leave  
  801162:	c3                   	ret    

00801163 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801166:	eb 06                	jmp    80116e <strcmp+0xb>
		p++, q++;
  801168:	ff 45 08             	incl   0x8(%ebp)
  80116b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	84 c0                	test   %al,%al
  801175:	74 0e                	je     801185 <strcmp+0x22>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 10                	mov    (%eax),%dl
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	8a 00                	mov    (%eax),%al
  801181:	38 c2                	cmp    %al,%dl
  801183:	74 e3                	je     801168 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	0f b6 d0             	movzbl %al,%edx
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	0f b6 c0             	movzbl %al,%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119e:	eb 09                	jmp    8011a9 <strncmp+0xe>
		n--, p++, q++;
  8011a0:	ff 4d 10             	decl   0x10(%ebp)
  8011a3:	ff 45 08             	incl   0x8(%ebp)
  8011a6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ad:	74 17                	je     8011c6 <strncmp+0x2b>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	84 c0                	test   %al,%al
  8011b6:	74 0e                	je     8011c6 <strncmp+0x2b>
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 10                	mov    (%eax),%dl
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	38 c2                	cmp    %al,%dl
  8011c4:	74 da                	je     8011a0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ca:	75 07                	jne    8011d3 <strncmp+0x38>
		return 0;
  8011cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8011d1:	eb 14                	jmp    8011e7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d6:	8a 00                	mov    (%eax),%al
  8011d8:	0f b6 d0             	movzbl %al,%edx
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	8a 00                	mov    (%eax),%al
  8011e0:	0f b6 c0             	movzbl %al,%eax
  8011e3:	29 c2                	sub    %eax,%edx
  8011e5:	89 d0                	mov    %edx,%eax
}
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 04             	sub    $0x4,%esp
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f5:	eb 12                	jmp    801209 <strchr+0x20>
		if (*s == c)
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ff:	75 05                	jne    801206 <strchr+0x1d>
			return (char *) s;
  801201:	8b 45 08             	mov    0x8(%ebp),%eax
  801204:	eb 11                	jmp    801217 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801206:	ff 45 08             	incl   0x8(%ebp)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	75 e5                	jne    8011f7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801212:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801217:	c9                   	leave  
  801218:	c3                   	ret    

00801219 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 04             	sub    $0x4,%esp
  80121f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801222:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801225:	eb 0d                	jmp    801234 <strfind+0x1b>
		if (*s == c)
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122f:	74 0e                	je     80123f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801231:	ff 45 08             	incl   0x8(%ebp)
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	84 c0                	test   %al,%al
  80123b:	75 ea                	jne    801227 <strfind+0xe>
  80123d:	eb 01                	jmp    801240 <strfind+0x27>
		if (*s == c)
			break;
  80123f:	90                   	nop
	return (char *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801251:	8b 45 10             	mov    0x10(%ebp),%eax
  801254:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801257:	eb 0e                	jmp    801267 <memset+0x22>
		*p++ = c;
  801259:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125c:	8d 50 01             	lea    0x1(%eax),%edx
  80125f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801262:	8b 55 0c             	mov    0xc(%ebp),%edx
  801265:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801267:	ff 4d f8             	decl   -0x8(%ebp)
  80126a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126e:	79 e9                	jns    801259 <memset+0x14>
		*p++ = c;

	return v;
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801287:	eb 16                	jmp    80129f <memcpy+0x2a>
		*d++ = *s++;
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	8d 50 01             	lea    0x1(%eax),%edx
  80128f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801292:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801295:	8d 4a 01             	lea    0x1(%edx),%ecx
  801298:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80129b:	8a 12                	mov    (%edx),%dl
  80129d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a8:	85 c0                	test   %eax,%eax
  8012aa:	75 dd                	jne    801289 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c9:	73 50                	jae    80131b <memmove+0x6a>
  8012cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d1:	01 d0                	add    %edx,%eax
  8012d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d6:	76 43                	jbe    80131b <memmove+0x6a>
		s += n;
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e4:	eb 10                	jmp    8012f6 <memmove+0x45>
			*--d = *--s;
  8012e6:	ff 4d f8             	decl   -0x8(%ebp)
  8012e9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	8a 10                	mov    (%eax),%dl
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ff:	85 c0                	test   %eax,%eax
  801301:	75 e3                	jne    8012e6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801303:	eb 23                	jmp    801328 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8d 50 01             	lea    0x1(%eax),%edx
  80130b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801311:	8d 4a 01             	lea    0x1(%edx),%ecx
  801314:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801317:	8a 12                	mov    (%edx),%dl
  801319:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80131b:	8b 45 10             	mov    0x10(%ebp),%eax
  80131e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801321:	89 55 10             	mov    %edx,0x10(%ebp)
  801324:	85 c0                	test   %eax,%eax
  801326:	75 dd                	jne    801305 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801333:	8b 45 08             	mov    0x8(%ebp),%eax
  801336:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133f:	eb 2a                	jmp    80136b <memcmp+0x3e>
		if (*s1 != *s2)
  801341:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801344:	8a 10                	mov    (%eax),%dl
  801346:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	38 c2                	cmp    %al,%dl
  80134d:	74 16                	je     801365 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801352:	8a 00                	mov    (%eax),%al
  801354:	0f b6 d0             	movzbl %al,%edx
  801357:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 c0             	movzbl %al,%eax
  80135f:	29 c2                	sub    %eax,%edx
  801361:	89 d0                	mov    %edx,%eax
  801363:	eb 18                	jmp    80137d <memcmp+0x50>
		s1++, s2++;
  801365:	ff 45 fc             	incl   -0x4(%ebp)
  801368:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801371:	89 55 10             	mov    %edx,0x10(%ebp)
  801374:	85 c0                	test   %eax,%eax
  801376:	75 c9                	jne    801341 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801378:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137d:	c9                   	leave  
  80137e:	c3                   	ret    

0080137f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137f:	55                   	push   %ebp
  801380:	89 e5                	mov    %esp,%ebp
  801382:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801385:	8b 55 08             	mov    0x8(%ebp),%edx
  801388:	8b 45 10             	mov    0x10(%ebp),%eax
  80138b:	01 d0                	add    %edx,%eax
  80138d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801390:	eb 15                	jmp    8013a7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f b6 d0             	movzbl %al,%edx
  80139a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	39 c2                	cmp    %eax,%edx
  8013a2:	74 0d                	je     8013b1 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a4:	ff 45 08             	incl   0x8(%ebp)
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013ad:	72 e3                	jb     801392 <memfind+0x13>
  8013af:	eb 01                	jmp    8013b2 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013b1:	90                   	nop
	return (void *) s;
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cb:	eb 03                	jmp    8013d0 <strtol+0x19>
		s++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8a 00                	mov    (%eax),%al
  8013d5:	3c 20                	cmp    $0x20,%al
  8013d7:	74 f4                	je     8013cd <strtol+0x16>
  8013d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 09                	cmp    $0x9,%al
  8013e0:	74 eb                	je     8013cd <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3c 2b                	cmp    $0x2b,%al
  8013e9:	75 05                	jne    8013f0 <strtol+0x39>
		s++;
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	eb 13                	jmp    801403 <strtol+0x4c>
	else if (*s == '-')
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	8a 00                	mov    (%eax),%al
  8013f5:	3c 2d                	cmp    $0x2d,%al
  8013f7:	75 0a                	jne    801403 <strtol+0x4c>
		s++, neg = 1;
  8013f9:	ff 45 08             	incl   0x8(%ebp)
  8013fc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801403:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801407:	74 06                	je     80140f <strtol+0x58>
  801409:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140d:	75 20                	jne    80142f <strtol+0x78>
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	3c 30                	cmp    $0x30,%al
  801416:	75 17                	jne    80142f <strtol+0x78>
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	40                   	inc    %eax
  80141c:	8a 00                	mov    (%eax),%al
  80141e:	3c 78                	cmp    $0x78,%al
  801420:	75 0d                	jne    80142f <strtol+0x78>
		s += 2, base = 16;
  801422:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801426:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142d:	eb 28                	jmp    801457 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801433:	75 15                	jne    80144a <strtol+0x93>
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8a 00                	mov    (%eax),%al
  80143a:	3c 30                	cmp    $0x30,%al
  80143c:	75 0c                	jne    80144a <strtol+0x93>
		s++, base = 8;
  80143e:	ff 45 08             	incl   0x8(%ebp)
  801441:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801448:	eb 0d                	jmp    801457 <strtol+0xa0>
	else if (base == 0)
  80144a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144e:	75 07                	jne    801457 <strtol+0xa0>
		base = 10;
  801450:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	3c 2f                	cmp    $0x2f,%al
  80145e:	7e 19                	jle    801479 <strtol+0xc2>
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8a 00                	mov    (%eax),%al
  801465:	3c 39                	cmp    $0x39,%al
  801467:	7f 10                	jg     801479 <strtol+0xc2>
			dig = *s - '0';
  801469:	8b 45 08             	mov    0x8(%ebp),%eax
  80146c:	8a 00                	mov    (%eax),%al
  80146e:	0f be c0             	movsbl %al,%eax
  801471:	83 e8 30             	sub    $0x30,%eax
  801474:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801477:	eb 42                	jmp    8014bb <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801479:	8b 45 08             	mov    0x8(%ebp),%eax
  80147c:	8a 00                	mov    (%eax),%al
  80147e:	3c 60                	cmp    $0x60,%al
  801480:	7e 19                	jle    80149b <strtol+0xe4>
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	3c 7a                	cmp    $0x7a,%al
  801489:	7f 10                	jg     80149b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	83 e8 57             	sub    $0x57,%eax
  801496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801499:	eb 20                	jmp    8014bb <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	3c 40                	cmp    $0x40,%al
  8014a2:	7e 39                	jle    8014dd <strtol+0x126>
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	3c 5a                	cmp    $0x5a,%al
  8014ab:	7f 30                	jg     8014dd <strtol+0x126>
			dig = *s - 'A' + 10;
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8a 00                	mov    (%eax),%al
  8014b2:	0f be c0             	movsbl %al,%eax
  8014b5:	83 e8 37             	sub    $0x37,%eax
  8014b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014be:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014c1:	7d 19                	jge    8014dc <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c3:	ff 45 08             	incl   0x8(%ebp)
  8014c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c9:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014cd:	89 c2                	mov    %eax,%edx
  8014cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d2:	01 d0                	add    %edx,%eax
  8014d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d7:	e9 7b ff ff ff       	jmp    801457 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014dc:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014e1:	74 08                	je     8014eb <strtol+0x134>
		*endptr = (char *) s;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ef:	74 07                	je     8014f8 <strtol+0x141>
  8014f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f4:	f7 d8                	neg    %eax
  8014f6:	eb 03                	jmp    8014fb <strtol+0x144>
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014fb:	c9                   	leave  
  8014fc:	c3                   	ret    

008014fd <ltostr>:

void
ltostr(long value, char *str)
{
  8014fd:	55                   	push   %ebp
  8014fe:	89 e5                	mov    %esp,%ebp
  801500:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801503:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80150a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801511:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801515:	79 13                	jns    80152a <ltostr+0x2d>
	{
		neg = 1;
  801517:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801521:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801524:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801527:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801532:	99                   	cltd   
  801533:	f7 f9                	idiv   %ecx
  801535:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801538:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80153b:	8d 50 01             	lea    0x1(%eax),%edx
  80153e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801541:	89 c2                	mov    %eax,%edx
  801543:	8b 45 0c             	mov    0xc(%ebp),%eax
  801546:	01 d0                	add    %edx,%eax
  801548:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80154b:	83 c2 30             	add    $0x30,%edx
  80154e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801550:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801553:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801558:	f7 e9                	imul   %ecx
  80155a:	c1 fa 02             	sar    $0x2,%edx
  80155d:	89 c8                	mov    %ecx,%eax
  80155f:	c1 f8 1f             	sar    $0x1f,%eax
  801562:	29 c2                	sub    %eax,%edx
  801564:	89 d0                	mov    %edx,%eax
  801566:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801569:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80156d:	75 bb                	jne    80152a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80156f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801576:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801579:	48                   	dec    %eax
  80157a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80157d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801581:	74 3d                	je     8015c0 <ltostr+0xc3>
		start = 1 ;
  801583:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80158a:	eb 34                	jmp    8015c0 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80158c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 d0                	add    %edx,%eax
  801594:	8a 00                	mov    (%eax),%al
  801596:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801599:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	01 c2                	add    %eax,%edx
  8015a1:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a7:	01 c8                	add    %ecx,%eax
  8015a9:	8a 00                	mov    (%eax),%al
  8015ab:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b3:	01 c2                	add    %eax,%edx
  8015b5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015b8:	88 02                	mov    %al,(%edx)
		start++ ;
  8015ba:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015bd:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c6:	7c c4                	jl     80158c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ce:	01 d0                	add    %edx,%eax
  8015d0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015d3:	90                   	nop
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015dc:	ff 75 08             	pushl  0x8(%ebp)
  8015df:	e8 73 fa ff ff       	call   801057 <strlen>
  8015e4:	83 c4 04             	add    $0x4,%esp
  8015e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015ea:	ff 75 0c             	pushl  0xc(%ebp)
  8015ed:	e8 65 fa ff ff       	call   801057 <strlen>
  8015f2:	83 c4 04             	add    $0x4,%esp
  8015f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801606:	eb 17                	jmp    80161f <strcconcat+0x49>
		final[s] = str1[s] ;
  801608:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160b:	8b 45 10             	mov    0x10(%ebp),%eax
  80160e:	01 c2                	add    %eax,%edx
  801610:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	01 c8                	add    %ecx,%eax
  801618:	8a 00                	mov    (%eax),%al
  80161a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80161c:	ff 45 fc             	incl   -0x4(%ebp)
  80161f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801622:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801625:	7c e1                	jl     801608 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801627:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80162e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801635:	eb 1f                	jmp    801656 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801637:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163a:	8d 50 01             	lea    0x1(%eax),%edx
  80163d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801640:	89 c2                	mov    %eax,%edx
  801642:	8b 45 10             	mov    0x10(%ebp),%eax
  801645:	01 c2                	add    %eax,%edx
  801647:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	01 c8                	add    %ecx,%eax
  80164f:	8a 00                	mov    (%eax),%al
  801651:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801653:	ff 45 f8             	incl   -0x8(%ebp)
  801656:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801659:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165c:	7c d9                	jl     801637 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80165e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801661:	8b 45 10             	mov    0x10(%ebp),%eax
  801664:	01 d0                	add    %edx,%eax
  801666:	c6 00 00             	movb   $0x0,(%eax)
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80166f:	8b 45 14             	mov    0x14(%ebp),%eax
  801672:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801684:	8b 45 10             	mov    0x10(%ebp),%eax
  801687:	01 d0                	add    %edx,%eax
  801689:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80168f:	eb 0c                	jmp    80169d <strsplit+0x31>
			*string++ = 0;
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8d 50 01             	lea    0x1(%eax),%edx
  801697:	89 55 08             	mov    %edx,0x8(%ebp)
  80169a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 18                	je     8016be <strsplit+0x52>
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	0f be c0             	movsbl %al,%eax
  8016ae:	50                   	push   %eax
  8016af:	ff 75 0c             	pushl  0xc(%ebp)
  8016b2:	e8 32 fb ff ff       	call   8011e9 <strchr>
  8016b7:	83 c4 08             	add    $0x8,%esp
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	75 d3                	jne    801691 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	8a 00                	mov    (%eax),%al
  8016c3:	84 c0                	test   %al,%al
  8016c5:	74 5a                	je     801721 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ca:	8b 00                	mov    (%eax),%eax
  8016cc:	83 f8 0f             	cmp    $0xf,%eax
  8016cf:	75 07                	jne    8016d8 <strsplit+0x6c>
		{
			return 0;
  8016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d6:	eb 66                	jmp    80173e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016db:	8b 00                	mov    (%eax),%eax
  8016dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8016e0:	8b 55 14             	mov    0x14(%ebp),%edx
  8016e3:	89 0a                	mov    %ecx,(%edx)
  8016e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ef:	01 c2                	add    %eax,%edx
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f6:	eb 03                	jmp    8016fb <strsplit+0x8f>
			string++;
  8016f8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	8a 00                	mov    (%eax),%al
  801700:	84 c0                	test   %al,%al
  801702:	74 8b                	je     80168f <strsplit+0x23>
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	8a 00                	mov    (%eax),%al
  801709:	0f be c0             	movsbl %al,%eax
  80170c:	50                   	push   %eax
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	e8 d4 fa ff ff       	call   8011e9 <strchr>
  801715:	83 c4 08             	add    $0x8,%esp
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 dc                	je     8016f8 <strsplit+0x8c>
			string++;
	}
  80171c:	e9 6e ff ff ff       	jmp    80168f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801721:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801722:	8b 45 14             	mov    0x14(%ebp),%eax
  801725:	8b 00                	mov    (%eax),%eax
  801727:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80172e:	8b 45 10             	mov    0x10(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801739:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801746:	83 ec 04             	sub    $0x4,%esp
  801749:	68 a8 42 80 00       	push   $0x8042a8
  80174e:	68 3f 01 00 00       	push   $0x13f
  801753:	68 ca 42 80 00       	push   $0x8042ca
  801758:	e8 a9 ef ff ff       	call   800706 <_panic>

0080175d <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	ff 75 08             	pushl  0x8(%ebp)
  801769:	e8 90 0c 00 00       	call   8023fe <sys_sbrk>
  80176e:	83 c4 10             	add    $0x10,%esp
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801779:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177d:	75 0a                	jne    801789 <malloc+0x16>
		return NULL;
  80177f:	b8 00 00 00 00       	mov    $0x0,%eax
  801784:	e9 9e 01 00 00       	jmp    801927 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801789:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801790:	77 2c                	ja     8017be <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801792:	e8 eb 0a 00 00       	call   802282 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801797:	85 c0                	test   %eax,%eax
  801799:	74 19                	je     8017b4 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	ff 75 08             	pushl  0x8(%ebp)
  8017a1:	e8 85 11 00 00       	call   80292b <alloc_block_FF>
  8017a6:	83 c4 10             	add    $0x10,%esp
  8017a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8017ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017af:	e9 73 01 00 00       	jmp    801927 <malloc+0x1b4>
		} else {
			return NULL;
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b9:	e9 69 01 00 00       	jmp    801927 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8017be:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8017c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017cb:	01 d0                	add    %edx,%eax
  8017cd:	48                   	dec    %eax
  8017ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	f7 75 e0             	divl   -0x20(%ebp)
  8017dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017df:	29 d0                	sub    %edx,%eax
  8017e1:	c1 e8 0c             	shr    $0xc,%eax
  8017e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8017e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8017ee:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8017f5:	a1 40 50 80 00       	mov    0x805040,%eax
  8017fa:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017fd:	05 00 10 00 00       	add    $0x1000,%eax
  801802:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801805:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80180a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80180d:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801810:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801817:	8b 55 08             	mov    0x8(%ebp),%edx
  80181a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80181d:	01 d0                	add    %edx,%eax
  80181f:	48                   	dec    %eax
  801820:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801823:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801826:	ba 00 00 00 00       	mov    $0x0,%edx
  80182b:	f7 75 cc             	divl   -0x34(%ebp)
  80182e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801831:	29 d0                	sub    %edx,%eax
  801833:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801836:	76 0a                	jbe    801842 <malloc+0xcf>
		return NULL;
  801838:	b8 00 00 00 00       	mov    $0x0,%eax
  80183d:	e9 e5 00 00 00       	jmp    801927 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801845:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801848:	eb 48                	jmp    801892 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80184a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801850:	c1 e8 0c             	shr    $0xc,%eax
  801853:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801856:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801859:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801860:	85 c0                	test   %eax,%eax
  801862:	75 11                	jne    801875 <malloc+0x102>
			freePagesCount++;
  801864:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801867:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80186b:	75 16                	jne    801883 <malloc+0x110>
				start = i;
  80186d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801870:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801873:	eb 0e                	jmp    801883 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801875:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80187c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801886:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801889:	74 12                	je     80189d <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80188b:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801892:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801899:	76 af                	jbe    80184a <malloc+0xd7>
  80189b:	eb 01                	jmp    80189e <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80189d:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80189e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8018a2:	74 08                	je     8018ac <malloc+0x139>
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8018aa:	74 07                	je     8018b3 <malloc+0x140>
		return NULL;
  8018ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b1:	eb 74                	jmp    801927 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8018b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b6:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8018b9:	c1 e8 0c             	shr    $0xc,%eax
  8018bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8018bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018c2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018c5:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8018cc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018d2:	eb 11                	jmp    8018e5 <malloc+0x172>
		markedPages[i] = 1;
  8018d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d7:	c7 04 85 60 50 90 00 	movl   $0x1,0x905060(,%eax,4)
  8018de:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8018e2:	ff 45 e8             	incl   -0x18(%ebp)
  8018e5:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8018e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018eb:	01 d0                	add    %edx,%eax
  8018ed:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8018f0:	77 e2                	ja     8018d4 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8018f2:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8018f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8018ff:	01 d0                	add    %edx,%eax
  801901:	48                   	dec    %eax
  801902:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801905:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801908:	ba 00 00 00 00       	mov    $0x0,%edx
  80190d:	f7 75 bc             	divl   -0x44(%ebp)
  801910:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801913:	29 d0                	sub    %edx,%eax
  801915:	83 ec 08             	sub    $0x8,%esp
  801918:	50                   	push   %eax
  801919:	ff 75 f0             	pushl  -0x10(%ebp)
  80191c:	e8 14 0b 00 00       	call   802435 <sys_allocate_user_mem>
  801921:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801927:	c9                   	leave  
  801928:	c3                   	ret    

00801929 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801929:	55                   	push   %ebp
  80192a:	89 e5                	mov    %esp,%ebp
  80192c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  80192f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801933:	0f 84 ee 00 00 00    	je     801a27 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801939:	a1 40 50 80 00       	mov    0x805040,%eax
  80193e:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801941:	3b 45 08             	cmp    0x8(%ebp),%eax
  801944:	77 09                	ja     80194f <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801946:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  80194d:	76 14                	jbe    801963 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	68 d8 42 80 00       	push   $0x8042d8
  801957:	6a 68                	push   $0x68
  801959:	68 f2 42 80 00       	push   $0x8042f2
  80195e:	e8 a3 ed ff ff       	call   800706 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801963:	a1 40 50 80 00       	mov    0x805040,%eax
  801968:	8b 40 74             	mov    0x74(%eax),%eax
  80196b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80196e:	77 20                	ja     801990 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801970:	a1 40 50 80 00       	mov    0x805040,%eax
  801975:	8b 40 78             	mov    0x78(%eax),%eax
  801978:	3b 45 08             	cmp    0x8(%ebp),%eax
  80197b:	76 13                	jbe    801990 <free+0x67>
		free_block(virtual_address);
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	e8 6c 16 00 00       	call   802ff4 <free_block>
  801988:	83 c4 10             	add    $0x10,%esp
		return;
  80198b:	e9 98 00 00 00       	jmp    801a28 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801990:	8b 55 08             	mov    0x8(%ebp),%edx
  801993:	a1 40 50 80 00       	mov    0x805040,%eax
  801998:	8b 40 7c             	mov    0x7c(%eax),%eax
  80199b:	29 c2                	sub    %eax,%edx
  80199d:	89 d0                	mov    %edx,%eax
  80199f:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8019a4:	c1 e8 0c             	shr    $0xc,%eax
  8019a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8019aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8019b1:	eb 16                	jmp    8019c9 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8019b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b9:	01 d0                	add    %edx,%eax
  8019bb:	c7 04 85 60 50 90 00 	movl   $0x0,0x905060(,%eax,4)
  8019c2:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8019c6:	ff 45 f4             	incl   -0xc(%ebp)
  8019c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019cc:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8019d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019d6:	7f db                	jg     8019b3 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8019d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019db:	8b 04 85 60 50 80 00 	mov    0x805060(,%eax,4),%eax
  8019e2:	c1 e0 0c             	shl    $0xc,%eax
  8019e5:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019ee:	eb 1a                	jmp    801a0a <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8019f0:	83 ec 08             	sub    $0x8,%esp
  8019f3:	68 00 10 00 00       	push   $0x1000
  8019f8:	ff 75 f0             	pushl  -0x10(%ebp)
  8019fb:	e8 19 0a 00 00       	call   802419 <sys_free_user_mem>
  801a00:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801a03:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a10:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801a12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a15:	77 d9                	ja     8019f0 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1a:	c7 04 85 60 50 80 00 	movl   $0x0,0x805060(,%eax,4)
  801a21:	00 00 00 00 
  801a25:	eb 01                	jmp    801a28 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801a27:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 58             	sub    $0x58,%esp
  801a30:	8b 45 10             	mov    0x10(%ebp),%eax
  801a33:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801a36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a3a:	75 0a                	jne    801a46 <smalloc+0x1c>
		return NULL;
  801a3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a41:	e9 7d 01 00 00       	jmp    801bc3 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801a46:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a53:	01 d0                	add    %edx,%eax
  801a55:	48                   	dec    %eax
  801a56:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801a61:	f7 75 e4             	divl   -0x1c(%ebp)
  801a64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a67:	29 d0                	sub    %edx,%eax
  801a69:	c1 e8 0c             	shr    $0xc,%eax
  801a6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801a6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801a76:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801a7d:	a1 40 50 80 00       	mov    0x805040,%eax
  801a82:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a85:	05 00 10 00 00       	add    $0x1000,%eax
  801a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801a8d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801a92:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801a95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801a98:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	48                   	dec    %eax
  801aa8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801aab:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801aae:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab3:	f7 75 d0             	divl   -0x30(%ebp)
  801ab6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ab9:	29 d0                	sub    %edx,%eax
  801abb:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801abe:	76 0a                	jbe    801aca <smalloc+0xa0>
		return NULL;
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac5:	e9 f9 00 00 00       	jmp    801bc3 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801aca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801acd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ad0:	eb 48                	jmp    801b1a <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ad5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ad8:	c1 e8 0c             	shr    $0xc,%eax
  801adb:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801ade:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ae1:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	75 11                	jne    801afd <smalloc+0xd3>
			freePagesCount++;
  801aec:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801aef:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801af3:	75 16                	jne    801b0b <smalloc+0xe1>
				start = s;
  801af5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801afb:	eb 0e                	jmp    801b0b <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801afd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801b04:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801b11:	74 12                	je     801b25 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801b13:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801b1a:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801b21:	76 af                	jbe    801ad2 <smalloc+0xa8>
  801b23:	eb 01                	jmp    801b26 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801b25:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801b26:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801b2a:	74 08                	je     801b34 <smalloc+0x10a>
  801b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801b32:	74 0a                	je     801b3e <smalloc+0x114>
		return NULL;
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax
  801b39:	e9 85 00 00 00       	jmp    801bc3 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b41:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801b44:	c1 e8 0c             	shr    $0xc,%eax
  801b47:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801b4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801b4d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b50:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801b57:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801b5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b5d:	eb 11                	jmp    801b70 <smalloc+0x146>
		markedPages[s] = 1;
  801b5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b62:	c7 04 85 60 50 90 00 	movl   $0x1,0x905060(,%eax,4)
  801b69:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801b6d:	ff 45 e8             	incl   -0x18(%ebp)
  801b70:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801b73:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b76:	01 d0                	add    %edx,%eax
  801b78:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801b7b:	77 e2                	ja     801b5f <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801b7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b80:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801b84:	52                   	push   %edx
  801b85:	50                   	push   %eax
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	ff 75 08             	pushl  0x8(%ebp)
  801b8c:	e8 8f 04 00 00       	call   802020 <sys_createSharedObject>
  801b91:	83 c4 10             	add    $0x10,%esp
  801b94:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801b97:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801b9b:	78 12                	js     801baf <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801b9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ba0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801ba3:	89 14 85 60 50 88 00 	mov    %edx,0x885060(,%eax,4)
		return (void*) start;
  801baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bad:	eb 14                	jmp    801bc3 <smalloc+0x199>
	}
	free((void*) start);
  801baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb2:	83 ec 0c             	sub    $0xc,%esp
  801bb5:	50                   	push   %eax
  801bb6:	e8 6e fd ff ff       	call   801929 <free>
  801bbb:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801bcb:	83 ec 08             	sub    $0x8,%esp
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	e8 71 04 00 00       	call   80204a <sys_getSizeOfSharedObject>
  801bd9:	83 c4 10             	add    $0x10,%esp
  801bdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801bdf:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801be6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bec:	01 d0                	add    %edx,%eax
  801bee:	48                   	dec    %eax
  801bef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801bf2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bf5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfa:	f7 75 e0             	divl   -0x20(%ebp)
  801bfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c00:	29 d0                	sub    %edx,%eax
  801c02:	c1 e8 0c             	shr    $0xc,%eax
  801c05:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801c0f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801c16:	a1 40 50 80 00       	mov    0x805040,%eax
  801c1b:	8b 40 7c             	mov    0x7c(%eax),%eax
  801c1e:	05 00 10 00 00       	add    $0x1000,%eax
  801c23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801c26:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801c2b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c2e:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801c31:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801c38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c3b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c3e:	01 d0                	add    %edx,%eax
  801c40:	48                   	dec    %eax
  801c41:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c44:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c47:	ba 00 00 00 00       	mov    $0x0,%edx
  801c4c:	f7 75 cc             	divl   -0x34(%ebp)
  801c4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c52:	29 d0                	sub    %edx,%eax
  801c54:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c57:	76 0a                	jbe    801c63 <sget+0x9e>
		return NULL;
  801c59:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5e:	e9 f7 00 00 00       	jmp    801d5a <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801c63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c66:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c69:	eb 48                	jmp    801cb3 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  801c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c6e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c71:	c1 e8 0c             	shr    $0xc,%eax
  801c74:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801c77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c7a:	8b 04 85 60 50 90 00 	mov    0x905060(,%eax,4),%eax
  801c81:	85 c0                	test   %eax,%eax
  801c83:	75 11                	jne    801c96 <sget+0xd1>
			free_Pages_Count++;
  801c85:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801c88:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c8c:	75 16                	jne    801ca4 <sget+0xdf>
				start = s;
  801c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c94:	eb 0e                	jmp    801ca4 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801c9d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801caa:	74 12                	je     801cbe <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801cac:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801cb3:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801cba:	76 af                	jbe    801c6b <sget+0xa6>
  801cbc:	eb 01                	jmp    801cbf <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801cbe:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801cbf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cc3:	74 08                	je     801ccd <sget+0x108>
  801cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801ccb:	74 0a                	je     801cd7 <sget+0x112>
		return NULL;
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd2:	e9 83 00 00 00       	jmp    801d5a <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cda:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801cdd:	c1 e8 0c             	shr    $0xc,%eax
  801ce0:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801ce3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ce6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ce9:	89 14 85 60 50 80 00 	mov    %edx,0x805060(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801cf0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cf3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801cf6:	eb 11                	jmp    801d09 <sget+0x144>
		markedPages[k] = 1;
  801cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cfb:	c7 04 85 60 50 90 00 	movl   $0x1,0x905060(,%eax,4)
  801d02:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801d06:	ff 45 e8             	incl   -0x18(%ebp)
  801d09:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801d0c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d14:	77 e2                	ja     801cf8 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d19:	83 ec 04             	sub    $0x4,%esp
  801d1c:	50                   	push   %eax
  801d1d:	ff 75 0c             	pushl  0xc(%ebp)
  801d20:	ff 75 08             	pushl  0x8(%ebp)
  801d23:	e8 3f 03 00 00       	call   802067 <sys_getSharedObject>
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801d2e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801d32:	78 12                	js     801d46 <sget+0x181>
		shardIDs[startPage] = ss;
  801d34:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d37:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d3a:	89 14 85 60 50 88 00 	mov    %edx,0x885060(,%eax,4)
		return (void*) start;
  801d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d44:	eb 14                	jmp    801d5a <sget+0x195>
	}
	free((void*) start);
  801d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d49:	83 ec 0c             	sub    $0xc,%esp
  801d4c:	50                   	push   %eax
  801d4d:	e8 d7 fb ff ff       	call   801929 <free>
  801d52:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801d62:	8b 55 08             	mov    0x8(%ebp),%edx
  801d65:	a1 40 50 80 00       	mov    0x805040,%eax
  801d6a:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d6d:	29 c2                	sub    %eax,%edx
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801d76:	c1 e8 0c             	shr    $0xc,%eax
  801d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7f:	8b 04 85 60 50 88 00 	mov    0x885060(,%eax,4),%eax
  801d86:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801d89:	83 ec 08             	sub    $0x8,%esp
  801d8c:	ff 75 08             	pushl  0x8(%ebp)
  801d8f:	ff 75 f0             	pushl  -0x10(%ebp)
  801d92:	e8 ef 02 00 00       	call   802086 <sys_freeSharedObject>
  801d97:	83 c4 10             	add    $0x10,%esp
  801d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801d9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801da1:	75 0e                	jne    801db1 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da6:	c7 04 85 60 50 88 00 	movl   $0xffffffff,0x885060(,%eax,4)
  801dad:	ff ff ff ff 
	}

}
  801db1:	90                   	nop
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	68 00 43 80 00       	push   $0x804300
  801dc2:	68 19 01 00 00       	push   $0x119
  801dc7:	68 f2 42 80 00       	push   $0x8042f2
  801dcc:	e8 35 e9 ff ff       	call   800706 <_panic>

00801dd1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dd7:	83 ec 04             	sub    $0x4,%esp
  801dda:	68 26 43 80 00       	push   $0x804326
  801ddf:	68 23 01 00 00       	push   $0x123
  801de4:	68 f2 42 80 00       	push   $0x8042f2
  801de9:	e8 18 e9 ff ff       	call   800706 <_panic>

00801dee <shrink>:

}
void shrink(uint32 newSize) {
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
  801df1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801df4:	83 ec 04             	sub    $0x4,%esp
  801df7:	68 26 43 80 00       	push   $0x804326
  801dfc:	68 27 01 00 00       	push   $0x127
  801e01:	68 f2 42 80 00       	push   $0x8042f2
  801e06:	e8 fb e8 ff ff       	call   800706 <_panic>

00801e0b <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
  801e0e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e11:	83 ec 04             	sub    $0x4,%esp
  801e14:	68 26 43 80 00       	push   $0x804326
  801e19:	68 2b 01 00 00       	push   $0x12b
  801e1e:	68 f2 42 80 00       	push   $0x8042f2
  801e23:	e8 de e8 ff ff       	call   800706 <_panic>

00801e28 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	57                   	push   %edi
  801e2c:	56                   	push   %esi
  801e2d:	53                   	push   %ebx
  801e2e:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e40:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e43:	cd 30                	int    $0x30
  801e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e4b:	83 c4 10             	add    $0x10,%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5e                   	pop    %esi
  801e50:	5f                   	pop    %edi
  801e51:	5d                   	pop    %ebp
  801e52:	c3                   	ret    

00801e53 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 04             	sub    $0x4,%esp
  801e59:	8b 45 10             	mov    0x10(%ebp),%eax
  801e5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801e5f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	52                   	push   %edx
  801e6b:	ff 75 0c             	pushl  0xc(%ebp)
  801e6e:	50                   	push   %eax
  801e6f:	6a 00                	push   $0x0
  801e71:	e8 b2 ff ff ff       	call   801e28 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
}
  801e79:	90                   	nop
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_cgetc>:

int sys_cgetc(void) {
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 02                	push   $0x2
  801e8b:	e8 98 ff ff ff       	call   801e28 <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_lock_cons>:

void sys_lock_cons(void) {
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 03                	push   $0x3
  801ea4:	e8 7f ff ff ff       	call   801e28 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
}
  801eac:	90                   	nop
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 04                	push   $0x4
  801ebe:	e8 65 ff ff ff       	call   801e28 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	90                   	nop
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	52                   	push   %edx
  801ed9:	50                   	push   %eax
  801eda:	6a 08                	push   $0x8
  801edc:	e8 47 ff ff ff       	call   801e28 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	56                   	push   %esi
  801eea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801eeb:	8b 75 18             	mov    0x18(%ebp),%esi
  801eee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  801efa:	56                   	push   %esi
  801efb:	53                   	push   %ebx
  801efc:	51                   	push   %ecx
  801efd:	52                   	push   %edx
  801efe:	50                   	push   %eax
  801eff:	6a 09                	push   $0x9
  801f01:	e8 22 ff ff ff       	call   801e28 <syscall>
  801f06:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801f09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f0c:	5b                   	pop    %ebx
  801f0d:	5e                   	pop    %esi
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    

00801f10 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	52                   	push   %edx
  801f20:	50                   	push   %eax
  801f21:	6a 0a                	push   $0xa
  801f23:	e8 00 ff ff ff       	call   801e28 <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	ff 75 0c             	pushl  0xc(%ebp)
  801f39:	ff 75 08             	pushl  0x8(%ebp)
  801f3c:	6a 0b                	push   $0xb
  801f3e:	e8 e5 fe ff ff       	call   801e28 <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 0c                	push   $0xc
  801f57:	e8 cc fe ff ff       	call   801e28 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 0d                	push   $0xd
  801f70:	e8 b3 fe ff ff       	call   801e28 <syscall>
  801f75:	83 c4 18             	add    $0x18,%esp
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 0e                	push   $0xe
  801f89:	e8 9a fe ff ff       	call   801e28 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 0f                	push   $0xf
  801fa2:	e8 81 fe ff ff       	call   801e28 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	ff 75 08             	pushl  0x8(%ebp)
  801fba:	6a 10                	push   $0x10
  801fbc:	e8 67 fe ff ff       	call   801e28 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_scarce_memory>:

void sys_scarce_memory() {
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 11                	push   $0x11
  801fd5:	e8 4e fe ff ff       	call   801e28 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	90                   	nop
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_cputc>:

void sys_cputc(const char c) {
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 04             	sub    $0x4,%esp
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	50                   	push   %eax
  801ff9:	6a 01                	push   $0x1
  801ffb:	e8 28 fe ff ff       	call   801e28 <syscall>
  802000:	83 c4 18             	add    $0x18,%esp
}
  802003:	90                   	nop
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 14                	push   $0x14
  802015:	e8 0e fe ff ff       	call   801e28 <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
}
  80201d:	90                   	nop
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	8b 45 10             	mov    0x10(%ebp),%eax
  802029:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80202c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80202f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	6a 00                	push   $0x0
  802038:	51                   	push   %ecx
  802039:	52                   	push   %edx
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	50                   	push   %eax
  80203e:	6a 15                	push   $0x15
  802040:	e8 e3 fd ff ff       	call   801e28 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 16                	push   $0x16
  80205d:	e8 c6 fd ff ff       	call   801e28 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80206a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	51                   	push   %ecx
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 17                	push   $0x17
  80207c:	e8 a7 fd ff ff       	call   801e28 <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	52                   	push   %edx
  802096:	50                   	push   %eax
  802097:	6a 18                	push   $0x18
  802099:	e8 8a fd ff ff       	call   801e28 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	ff 75 14             	pushl  0x14(%ebp)
  8020ae:	ff 75 10             	pushl  0x10(%ebp)
  8020b1:	ff 75 0c             	pushl  0xc(%ebp)
  8020b4:	50                   	push   %eax
  8020b5:	6a 19                	push   $0x19
  8020b7:	e8 6c fd ff ff       	call   801e28 <syscall>
  8020bc:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <sys_run_env>:

void sys_run_env(int32 envId) {
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	50                   	push   %eax
  8020d0:	6a 1a                	push   $0x1a
  8020d2:	e8 51 fd ff ff       	call   801e28 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	90                   	nop
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	50                   	push   %eax
  8020ec:	6a 1b                	push   $0x1b
  8020ee:	e8 35 fd ff ff       	call   801e28 <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_getenvid>:

int32 sys_getenvid(void) {
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 05                	push   $0x5
  802107:	e8 1c fd ff ff       	call   801e28 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 06                	push   $0x6
  802120:	e8 03 fd ff ff       	call   801e28 <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 07                	push   $0x7
  802139:	e8 ea fc ff ff       	call   801e28 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_exit_env>:

void sys_exit_env(void) {
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 1c                	push   $0x1c
  802152:	e8 d1 fc ff ff       	call   801e28 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	90                   	nop
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
  802160:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802163:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802166:	8d 50 04             	lea    0x4(%eax),%edx
  802169:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	52                   	push   %edx
  802173:	50                   	push   %eax
  802174:	6a 1d                	push   $0x1d
  802176:	e8 ad fc ff ff       	call   801e28 <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80217e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802184:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802187:	89 01                	mov    %eax,(%ecx)
  802189:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	c9                   	leave  
  802190:	c2 04 00             	ret    $0x4

00802193 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	ff 75 10             	pushl  0x10(%ebp)
  80219d:	ff 75 0c             	pushl  0xc(%ebp)
  8021a0:	ff 75 08             	pushl  0x8(%ebp)
  8021a3:	6a 13                	push   $0x13
  8021a5:	e8 7e fc ff ff       	call   801e28 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8021ad:	90                   	nop
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_rcr2>:
uint32 sys_rcr2() {
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 1e                	push   $0x1e
  8021bf:	e8 64 fc ff ff       	call   801e28 <syscall>
  8021c4:	83 c4 18             	add    $0x18,%esp
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021d5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	50                   	push   %eax
  8021e2:	6a 1f                	push   $0x1f
  8021e4:	e8 3f fc ff ff       	call   801e28 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
	return;
  8021ec:	90                   	nop
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <rsttst>:
void rsttst() {
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 21                	push   $0x21
  8021fe:	e8 25 fc ff ff       	call   801e28 <syscall>
  802203:	83 c4 18             	add    $0x18,%esp
	return;
  802206:	90                   	nop
}
  802207:	c9                   	leave  
  802208:	c3                   	ret    

00802209 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802209:	55                   	push   %ebp
  80220a:	89 e5                	mov    %esp,%ebp
  80220c:	83 ec 04             	sub    $0x4,%esp
  80220f:	8b 45 14             	mov    0x14(%ebp),%eax
  802212:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802215:	8b 55 18             	mov    0x18(%ebp),%edx
  802218:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80221c:	52                   	push   %edx
  80221d:	50                   	push   %eax
  80221e:	ff 75 10             	pushl  0x10(%ebp)
  802221:	ff 75 0c             	pushl  0xc(%ebp)
  802224:	ff 75 08             	pushl  0x8(%ebp)
  802227:	6a 20                	push   $0x20
  802229:	e8 fa fb ff ff       	call   801e28 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
	return;
  802231:	90                   	nop
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <chktst>:
void chktst(uint32 n) {
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	ff 75 08             	pushl  0x8(%ebp)
  802242:	6a 22                	push   $0x22
  802244:	e8 df fb ff ff       	call   801e28 <syscall>
  802249:	83 c4 18             	add    $0x18,%esp
	return;
  80224c:	90                   	nop
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <inctst>:

void inctst() {
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 23                	push   $0x23
  80225e:	e8 c5 fb ff ff       	call   801e28 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
	return;
  802266:	90                   	nop
}
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <gettst>:
uint32 gettst() {
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 24                	push   $0x24
  802278:	e8 ab fb ff ff       	call   801e28 <syscall>
  80227d:	83 c4 18             	add    $0x18,%esp
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
  802285:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 25                	push   $0x25
  802294:	e8 8f fb ff ff       	call   801e28 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
  80229c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80229f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022a3:	75 07                	jne    8022ac <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022aa:	eb 05                	jmp    8022b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
  8022b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 25                	push   $0x25
  8022c5:	e8 5e fb ff ff       	call   801e28 <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
  8022cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022d0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022d4:	75 07                	jne    8022dd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022db:	eb 05                	jmp    8022e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 25                	push   $0x25
  8022f6:	e8 2d fb ff ff       	call   801e28 <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
  8022fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802301:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802305:	75 07                	jne    80230e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802307:	b8 01 00 00 00       	mov    $0x1,%eax
  80230c:	eb 05                	jmp    802313 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80230e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
  802318:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 25                	push   $0x25
  802327:	e8 fc fa ff ff       	call   801e28 <syscall>
  80232c:	83 c4 18             	add    $0x18,%esp
  80232f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802332:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802336:	75 07                	jne    80233f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802338:	b8 01 00 00 00       	mov    $0x1,%eax
  80233d:	eb 05                	jmp    802344 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80233f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	ff 75 08             	pushl  0x8(%ebp)
  802354:	6a 26                	push   $0x26
  802356:	e8 cd fa ff ff       	call   801e28 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
	return;
  80235e:	90                   	nop
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
  802364:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802365:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	6a 00                	push   $0x0
  802373:	53                   	push   %ebx
  802374:	51                   	push   %ecx
  802375:	52                   	push   %edx
  802376:	50                   	push   %eax
  802377:	6a 27                	push   $0x27
  802379:	e8 aa fa ff ff       	call   801e28 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802381:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	52                   	push   %edx
  802396:	50                   	push   %eax
  802397:	6a 28                	push   $0x28
  802399:	e8 8a fa ff ff       	call   801e28 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8023a6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	6a 00                	push   $0x0
  8023b1:	51                   	push   %ecx
  8023b2:	ff 75 10             	pushl  0x10(%ebp)
  8023b5:	52                   	push   %edx
  8023b6:	50                   	push   %eax
  8023b7:	6a 29                	push   $0x29
  8023b9:	e8 6a fa ff ff       	call   801e28 <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	ff 75 10             	pushl  0x10(%ebp)
  8023cd:	ff 75 0c             	pushl  0xc(%ebp)
  8023d0:	ff 75 08             	pushl  0x8(%ebp)
  8023d3:	6a 12                	push   $0x12
  8023d5:	e8 4e fa ff ff       	call   801e28 <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
	return;
  8023dd:	90                   	nop
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8023e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	52                   	push   %edx
  8023f0:	50                   	push   %eax
  8023f1:	6a 2a                	push   $0x2a
  8023f3:	e8 30 fa ff ff       	call   801e28 <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
	return;
  8023fb:	90                   	nop
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802401:	8b 45 08             	mov    0x8(%ebp),%eax
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	50                   	push   %eax
  80240d:	6a 2b                	push   $0x2b
  80240f:	e8 14 fa ff ff       	call   801e28 <syscall>
  802414:	83 c4 18             	add    $0x18,%esp
}
  802417:	c9                   	leave  
  802418:	c3                   	ret    

00802419 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802419:	55                   	push   %ebp
  80241a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	ff 75 0c             	pushl  0xc(%ebp)
  802425:	ff 75 08             	pushl  0x8(%ebp)
  802428:	6a 2c                	push   $0x2c
  80242a:	e8 f9 f9 ff ff       	call   801e28 <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
	return;
  802432:	90                   	nop
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	ff 75 0c             	pushl  0xc(%ebp)
  802441:	ff 75 08             	pushl  0x8(%ebp)
  802444:	6a 2d                	push   $0x2d
  802446:	e8 dd f9 ff ff       	call   801e28 <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
	return;
  80244e:	90                   	nop
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802454:	8b 45 08             	mov    0x8(%ebp),%eax
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	50                   	push   %eax
  802460:	6a 2f                	push   $0x2f
  802462:	e8 c1 f9 ff ff       	call   801e28 <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
	return;
  80246a:	90                   	nop
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802470:	8b 55 0c             	mov    0xc(%ebp),%edx
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	52                   	push   %edx
  80247d:	50                   	push   %eax
  80247e:	6a 30                	push   $0x30
  802480:	e8 a3 f9 ff ff       	call   801e28 <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
	return;
  802488:	90                   	nop
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	50                   	push   %eax
  80249a:	6a 31                	push   $0x31
  80249c:	e8 87 f9 ff ff       	call   801e28 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
	return;
  8024a4:	90                   	nop
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8024aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	52                   	push   %edx
  8024b7:	50                   	push   %eax
  8024b8:	6a 2e                	push   $0x2e
  8024ba:	e8 69 f9 ff ff       	call   801e28 <syscall>
  8024bf:	83 c4 18             	add    $0x18,%esp
    return;
  8024c2:	90                   	nop
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	83 e8 04             	sub    $0x4,%eax
  8024d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8024d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8024dc:	c9                   	leave  
  8024dd:	c3                   	ret    

008024de <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	83 e8 04             	sub    $0x4,%eax
  8024ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8024ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024f0:	8b 00                	mov    (%eax),%eax
  8024f2:	83 e0 01             	and    $0x1,%eax
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	0f 94 c0             	sete   %al
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
  8024ff:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802502:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  802509:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250c:	83 f8 02             	cmp    $0x2,%eax
  80250f:	74 2b                	je     80253c <alloc_block+0x40>
  802511:	83 f8 02             	cmp    $0x2,%eax
  802514:	7f 07                	jg     80251d <alloc_block+0x21>
  802516:	83 f8 01             	cmp    $0x1,%eax
  802519:	74 0e                	je     802529 <alloc_block+0x2d>
  80251b:	eb 58                	jmp    802575 <alloc_block+0x79>
  80251d:	83 f8 03             	cmp    $0x3,%eax
  802520:	74 2d                	je     80254f <alloc_block+0x53>
  802522:	83 f8 04             	cmp    $0x4,%eax
  802525:	74 3b                	je     802562 <alloc_block+0x66>
  802527:	eb 4c                	jmp    802575 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  802529:	83 ec 0c             	sub    $0xc,%esp
  80252c:	ff 75 08             	pushl  0x8(%ebp)
  80252f:	e8 f7 03 00 00       	call   80292b <alloc_block_FF>
  802534:	83 c4 10             	add    $0x10,%esp
  802537:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80253a:	eb 4a                	jmp    802586 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80253c:	83 ec 0c             	sub    $0xc,%esp
  80253f:	ff 75 08             	pushl  0x8(%ebp)
  802542:	e8 f0 11 00 00       	call   803737 <alloc_block_NF>
  802547:	83 c4 10             	add    $0x10,%esp
  80254a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80254d:	eb 37                	jmp    802586 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  80254f:	83 ec 0c             	sub    $0xc,%esp
  802552:	ff 75 08             	pushl  0x8(%ebp)
  802555:	e8 08 08 00 00       	call   802d62 <alloc_block_BF>
  80255a:	83 c4 10             	add    $0x10,%esp
  80255d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802560:	eb 24                	jmp    802586 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802562:	83 ec 0c             	sub    $0xc,%esp
  802565:	ff 75 08             	pushl  0x8(%ebp)
  802568:	e8 ad 11 00 00       	call   80371a <alloc_block_WF>
  80256d:	83 c4 10             	add    $0x10,%esp
  802570:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802573:	eb 11                	jmp    802586 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802575:	83 ec 0c             	sub    $0xc,%esp
  802578:	68 38 43 80 00       	push   $0x804338
  80257d:	e8 41 e4 ff ff       	call   8009c3 <cprintf>
  802582:	83 c4 10             	add    $0x10,%esp
		break;
  802585:	90                   	nop
	}
	return va;
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802589:	c9                   	leave  
  80258a:	c3                   	ret    

0080258b <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	53                   	push   %ebx
  80258f:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802592:	83 ec 0c             	sub    $0xc,%esp
  802595:	68 58 43 80 00       	push   $0x804358
  80259a:	e8 24 e4 ff ff       	call   8009c3 <cprintf>
  80259f:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8025a2:	83 ec 0c             	sub    $0xc,%esp
  8025a5:	68 83 43 80 00       	push   $0x804383
  8025aa:	e8 14 e4 ff ff       	call   8009c3 <cprintf>
  8025af:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8025b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b8:	eb 37                	jmp    8025f1 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8025ba:	83 ec 0c             	sub    $0xc,%esp
  8025bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8025c0:	e8 19 ff ff ff       	call   8024de <is_free_block>
  8025c5:	83 c4 10             	add    $0x10,%esp
  8025c8:	0f be d8             	movsbl %al,%ebx
  8025cb:	83 ec 0c             	sub    $0xc,%esp
  8025ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8025d1:	e8 ef fe ff ff       	call   8024c5 <get_block_size>
  8025d6:	83 c4 10             	add    $0x10,%esp
  8025d9:	83 ec 04             	sub    $0x4,%esp
  8025dc:	53                   	push   %ebx
  8025dd:	50                   	push   %eax
  8025de:	68 9b 43 80 00       	push   $0x80439b
  8025e3:	e8 db e3 ff ff       	call   8009c3 <cprintf>
  8025e8:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8025eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	74 07                	je     8025fe <print_blocks_list+0x73>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <print_blocks_list+0x78>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	89 45 10             	mov    %eax,0x10(%ebp)
  802606:	8b 45 10             	mov    0x10(%ebp),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	75 ad                	jne    8025ba <print_blocks_list+0x2f>
  80260d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802611:	75 a7                	jne    8025ba <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802613:	83 ec 0c             	sub    $0xc,%esp
  802616:	68 58 43 80 00       	push   $0x804358
  80261b:	e8 a3 e3 ff ff       	call   8009c3 <cprintf>
  802620:	83 c4 10             	add    $0x10,%esp

}
  802623:	90                   	nop
  802624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802627:	c9                   	leave  
  802628:	c3                   	ret    

00802629 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  802629:	55                   	push   %ebp
  80262a:	89 e5                	mov    %esp,%ebp
  80262c:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  80262f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802632:	83 e0 01             	and    $0x1,%eax
  802635:	85 c0                	test   %eax,%eax
  802637:	74 03                	je     80263c <initialize_dynamic_allocator+0x13>
  802639:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80263c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802640:	0f 84 f8 00 00 00    	je     80273e <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802646:	c7 05 60 50 98 00 01 	movl   $0x1,0x985060
  80264d:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802650:	a1 60 50 98 00       	mov    0x985060,%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	0f 84 e2 00 00 00    	je     80273f <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80266c:	8b 55 08             	mov    0x8(%ebp),%edx
  80266f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802672:	01 d0                	add    %edx,%eax
  802674:	83 e8 04             	sub    $0x4,%eax
  802677:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	83 c0 08             	add    $0x8,%eax
  802689:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80268c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80268f:	83 e8 08             	sub    $0x8,%eax
  802692:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802695:	83 ec 04             	sub    $0x4,%esp
  802698:	6a 00                	push   $0x0
  80269a:	ff 75 e8             	pushl  -0x18(%ebp)
  80269d:	ff 75 ec             	pushl  -0x14(%ebp)
  8026a0:	e8 9c 00 00 00       	call   802741 <set_block_data>
  8026a5:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8026a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8026b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8026bb:	c7 05 84 50 98 00 00 	movl   $0x0,0x985084
  8026c2:	00 00 00 
  8026c5:	c7 05 88 50 98 00 00 	movl   $0x0,0x985088
  8026cc:	00 00 00 
  8026cf:	c7 05 90 50 98 00 00 	movl   $0x0,0x985090
  8026d6:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8026d9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026dd:	75 17                	jne    8026f6 <initialize_dynamic_allocator+0xcd>
  8026df:	83 ec 04             	sub    $0x4,%esp
  8026e2:	68 b4 43 80 00       	push   $0x8043b4
  8026e7:	68 80 00 00 00       	push   $0x80
  8026ec:	68 d7 43 80 00       	push   $0x8043d7
  8026f1:	e8 10 e0 ff ff       	call   800706 <_panic>
  8026f6:	8b 15 84 50 98 00    	mov    0x985084,%edx
  8026fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ff:	89 10                	mov    %edx,(%eax)
  802701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802704:	8b 00                	mov    (%eax),%eax
  802706:	85 c0                	test   %eax,%eax
  802708:	74 0d                	je     802717 <initialize_dynamic_allocator+0xee>
  80270a:	a1 84 50 98 00       	mov    0x985084,%eax
  80270f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802712:	89 50 04             	mov    %edx,0x4(%eax)
  802715:	eb 08                	jmp    80271f <initialize_dynamic_allocator+0xf6>
  802717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271a:	a3 88 50 98 00       	mov    %eax,0x985088
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	a3 84 50 98 00       	mov    %eax,0x985084
  802727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802731:	a1 90 50 98 00       	mov    0x985090,%eax
  802736:	40                   	inc    %eax
  802737:	a3 90 50 98 00       	mov    %eax,0x985090
  80273c:	eb 01                	jmp    80273f <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80273e:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  80273f:	c9                   	leave  
  802740:	c3                   	ret    

00802741 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274a:	83 e0 01             	and    $0x1,%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	74 03                	je     802754 <set_block_data+0x13>
	{
		totalSize++;
  802751:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802754:	8b 45 08             	mov    0x8(%ebp),%eax
  802757:	83 e8 04             	sub    $0x4,%eax
  80275a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  80275d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802760:	83 e0 fe             	and    $0xfffffffe,%eax
  802763:	89 c2                	mov    %eax,%edx
  802765:	8b 45 10             	mov    0x10(%ebp),%eax
  802768:	83 e0 01             	and    $0x1,%eax
  80276b:	09 c2                	or     %eax,%edx
  80276d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802770:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802772:	8b 45 0c             	mov    0xc(%ebp),%eax
  802775:	8d 50 f8             	lea    -0x8(%eax),%edx
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	01 d0                	add    %edx,%eax
  80277d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802780:	8b 45 0c             	mov    0xc(%ebp),%eax
  802783:	83 e0 fe             	and    $0xfffffffe,%eax
  802786:	89 c2                	mov    %eax,%edx
  802788:	8b 45 10             	mov    0x10(%ebp),%eax
  80278b:	83 e0 01             	and    $0x1,%eax
  80278e:	09 c2                	or     %eax,%edx
  802790:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802793:	89 10                	mov    %edx,(%eax)
}
  802795:	90                   	nop
  802796:	c9                   	leave  
  802797:	c3                   	ret    

00802798 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802798:	55                   	push   %ebp
  802799:	89 e5                	mov    %esp,%ebp
  80279b:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80279e:	a1 84 50 98 00       	mov    0x985084,%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	75 68                	jne    80280f <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8027a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ab:	75 17                	jne    8027c4 <insert_sorted_in_freeList+0x2c>
  8027ad:	83 ec 04             	sub    $0x4,%esp
  8027b0:	68 b4 43 80 00       	push   $0x8043b4
  8027b5:	68 9d 00 00 00       	push   $0x9d
  8027ba:	68 d7 43 80 00       	push   $0x8043d7
  8027bf:	e8 42 df ff ff       	call   800706 <_panic>
  8027c4:	8b 15 84 50 98 00    	mov    0x985084,%edx
  8027ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cd:	89 10                	mov    %edx,(%eax)
  8027cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 0d                	je     8027e5 <insert_sorted_in_freeList+0x4d>
  8027d8:	a1 84 50 98 00       	mov    0x985084,%eax
  8027dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e0:	89 50 04             	mov    %edx,0x4(%eax)
  8027e3:	eb 08                	jmp    8027ed <insert_sorted_in_freeList+0x55>
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	a3 88 50 98 00       	mov    %eax,0x985088
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	a3 84 50 98 00       	mov    %eax,0x985084
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ff:	a1 90 50 98 00       	mov    0x985090,%eax
  802804:	40                   	inc    %eax
  802805:	a3 90 50 98 00       	mov    %eax,0x985090
		return;
  80280a:	e9 1a 01 00 00       	jmp    802929 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80280f:	a1 84 50 98 00       	mov    0x985084,%eax
  802814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802817:	eb 7f                	jmp    802898 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281f:	76 6f                	jbe    802890 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802821:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802825:	74 06                	je     80282d <insert_sorted_in_freeList+0x95>
  802827:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282b:	75 17                	jne    802844 <insert_sorted_in_freeList+0xac>
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	68 f0 43 80 00       	push   $0x8043f0
  802835:	68 a6 00 00 00       	push   $0xa6
  80283a:	68 d7 43 80 00       	push   $0x8043d7
  80283f:	e8 c2 de ff ff       	call   800706 <_panic>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 50 04             	mov    0x4(%eax),%edx
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802856:	89 10                	mov    %edx,(%eax)
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	85 c0                	test   %eax,%eax
  802860:	74 0d                	je     80286f <insert_sorted_in_freeList+0xd7>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	8b 55 08             	mov    0x8(%ebp),%edx
  80286b:	89 10                	mov    %edx,(%eax)
  80286d:	eb 08                	jmp    802877 <insert_sorted_in_freeList+0xdf>
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	a3 84 50 98 00       	mov    %eax,0x985084
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 55 08             	mov    0x8(%ebp),%edx
  80287d:	89 50 04             	mov    %edx,0x4(%eax)
  802880:	a1 90 50 98 00       	mov    0x985090,%eax
  802885:	40                   	inc    %eax
  802886:	a3 90 50 98 00       	mov    %eax,0x985090
			return;
  80288b:	e9 99 00 00 00       	jmp    802929 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802890:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802895:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802898:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289c:	74 07                	je     8028a5 <insert_sorted_in_freeList+0x10d>
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	eb 05                	jmp    8028aa <insert_sorted_in_freeList+0x112>
  8028a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8028aa:	a3 8c 50 98 00       	mov    %eax,0x98508c
  8028af:	a1 8c 50 98 00       	mov    0x98508c,%eax
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	0f 85 5d ff ff ff    	jne    802819 <insert_sorted_in_freeList+0x81>
  8028bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c0:	0f 85 53 ff ff ff    	jne    802819 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8028c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ca:	75 17                	jne    8028e3 <insert_sorted_in_freeList+0x14b>
  8028cc:	83 ec 04             	sub    $0x4,%esp
  8028cf:	68 28 44 80 00       	push   $0x804428
  8028d4:	68 ab 00 00 00       	push   $0xab
  8028d9:	68 d7 43 80 00       	push   $0x8043d7
  8028de:	e8 23 de ff ff       	call   800706 <_panic>
  8028e3:	8b 15 88 50 98 00    	mov    0x985088,%edx
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	89 50 04             	mov    %edx,0x4(%eax)
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0c                	je     802905 <insert_sorted_in_freeList+0x16d>
  8028f9:	a1 88 50 98 00       	mov    0x985088,%eax
  8028fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 08                	jmp    80290d <insert_sorted_in_freeList+0x175>
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	a3 84 50 98 00       	mov    %eax,0x985084
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	a3 88 50 98 00       	mov    %eax,0x985088
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291e:	a1 90 50 98 00       	mov    0x985090,%eax
  802923:	40                   	inc    %eax
  802924:	a3 90 50 98 00       	mov    %eax,0x985090
}
  802929:	c9                   	leave  
  80292a:	c3                   	ret    

0080292b <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80292b:	55                   	push   %ebp
  80292c:	89 e5                	mov    %esp,%ebp
  80292e:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	83 e0 01             	and    $0x1,%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	74 03                	je     80293e <alloc_block_FF+0x13>
  80293b:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80293e:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802942:	77 07                	ja     80294b <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802944:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80294b:	a1 60 50 98 00       	mov    0x985060,%eax
  802950:	85 c0                	test   %eax,%eax
  802952:	75 63                	jne    8029b7 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	83 c0 10             	add    $0x10,%eax
  80295a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80295d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802964:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80296a:	01 d0                	add    %edx,%eax
  80296c:	48                   	dec    %eax
  80296d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802970:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802973:	ba 00 00 00 00       	mov    $0x0,%edx
  802978:	f7 75 ec             	divl   -0x14(%ebp)
  80297b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297e:	29 d0                	sub    %edx,%eax
  802980:	c1 e8 0c             	shr    $0xc,%eax
  802983:	83 ec 0c             	sub    $0xc,%esp
  802986:	50                   	push   %eax
  802987:	e8 d1 ed ff ff       	call   80175d <sbrk>
  80298c:	83 c4 10             	add    $0x10,%esp
  80298f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802992:	83 ec 0c             	sub    $0xc,%esp
  802995:	6a 00                	push   $0x0
  802997:	e8 c1 ed ff ff       	call   80175d <sbrk>
  80299c:	83 c4 10             	add    $0x10,%esp
  80299f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8029a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8029a8:	83 ec 08             	sub    $0x8,%esp
  8029ab:	50                   	push   %eax
  8029ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8029af:	e8 75 fc ff ff       	call   802629 <initialize_dynamic_allocator>
  8029b4:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8029b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029bb:	75 0a                	jne    8029c7 <alloc_block_FF+0x9c>
	{
		return NULL;
  8029bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c2:	e9 99 03 00 00       	jmp    802d60 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	83 c0 08             	add    $0x8,%eax
  8029cd:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8029d0:	a1 84 50 98 00       	mov    0x985084,%eax
  8029d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029d8:	e9 03 02 00 00       	jmp    802be0 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8029dd:	83 ec 0c             	sub    $0xc,%esp
  8029e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8029e3:	e8 dd fa ff ff       	call   8024c5 <get_block_size>
  8029e8:	83 c4 10             	add    $0x10,%esp
  8029eb:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8029ee:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8029f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8029f4:	0f 82 de 01 00 00    	jb     802bd8 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8029fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8029fd:	83 c0 10             	add    $0x10,%eax
  802a00:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802a03:	0f 87 32 01 00 00    	ja     802b3b <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802a09:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802a0c:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802a0f:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a15:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802a1d:	83 ec 04             	sub    $0x4,%esp
  802a20:	6a 00                	push   $0x0
  802a22:	ff 75 98             	pushl  -0x68(%ebp)
  802a25:	ff 75 94             	pushl  -0x6c(%ebp)
  802a28:	e8 14 fd ff ff       	call   802741 <set_block_data>
  802a2d:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802a30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a34:	74 06                	je     802a3c <alloc_block_FF+0x111>
  802a36:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802a3a:	75 17                	jne    802a53 <alloc_block_FF+0x128>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 4c 44 80 00       	push   $0x80444c
  802a44:	68 de 00 00 00       	push   $0xde
  802a49:	68 d7 43 80 00       	push   $0x8043d7
  802a4e:	e8 b3 dc ff ff       	call   800706 <_panic>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 10                	mov    (%eax),%edx
  802a58:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802a5b:	89 10                	mov    %edx,(%eax)
  802a5d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	74 0b                	je     802a71 <alloc_block_FF+0x146>
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802a6e:	89 50 04             	mov    %edx,0x4(%eax)
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802a77:	89 10                	mov    %edx,(%eax)
  802a79:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7f:	89 50 04             	mov    %edx,0x4(%eax)
  802a82:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	75 08                	jne    802a93 <alloc_block_FF+0x168>
  802a8b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802a8e:	a3 88 50 98 00       	mov    %eax,0x985088
  802a93:	a1 90 50 98 00       	mov    0x985090,%eax
  802a98:	40                   	inc    %eax
  802a99:	a3 90 50 98 00       	mov    %eax,0x985090

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802a9e:	83 ec 04             	sub    $0x4,%esp
  802aa1:	6a 01                	push   $0x1
  802aa3:	ff 75 dc             	pushl  -0x24(%ebp)
  802aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  802aa9:	e8 93 fc ff ff       	call   802741 <set_block_data>
  802aae:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802ab1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab5:	75 17                	jne    802ace <alloc_block_FF+0x1a3>
  802ab7:	83 ec 04             	sub    $0x4,%esp
  802aba:	68 80 44 80 00       	push   $0x804480
  802abf:	68 e3 00 00 00       	push   $0xe3
  802ac4:	68 d7 43 80 00       	push   $0x8043d7
  802ac9:	e8 38 dc ff ff       	call   800706 <_panic>
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 00                	mov    (%eax),%eax
  802ad3:	85 c0                	test   %eax,%eax
  802ad5:	74 10                	je     802ae7 <alloc_block_FF+0x1bc>
  802ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adf:	8b 52 04             	mov    0x4(%edx),%edx
  802ae2:	89 50 04             	mov    %edx,0x4(%eax)
  802ae5:	eb 0b                	jmp    802af2 <alloc_block_FF+0x1c7>
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 40 04             	mov    0x4(%eax),%eax
  802aed:	a3 88 50 98 00       	mov    %eax,0x985088
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 40 04             	mov    0x4(%eax),%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	74 0f                	je     802b0b <alloc_block_FF+0x1e0>
  802afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aff:	8b 40 04             	mov    0x4(%eax),%eax
  802b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b05:	8b 12                	mov    (%edx),%edx
  802b07:	89 10                	mov    %edx,(%eax)
  802b09:	eb 0a                	jmp    802b15 <alloc_block_FF+0x1ea>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	a3 84 50 98 00       	mov    %eax,0x985084
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b28:	a1 90 50 98 00       	mov    0x985090,%eax
  802b2d:	48                   	dec    %eax
  802b2e:	a3 90 50 98 00       	mov    %eax,0x985090
				return (void*)((uint32*)block);
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	e9 25 02 00 00       	jmp    802d60 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802b3b:	83 ec 04             	sub    $0x4,%esp
  802b3e:	6a 01                	push   $0x1
  802b40:	ff 75 9c             	pushl  -0x64(%ebp)
  802b43:	ff 75 f4             	pushl  -0xc(%ebp)
  802b46:	e8 f6 fb ff ff       	call   802741 <set_block_data>
  802b4b:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802b4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b52:	75 17                	jne    802b6b <alloc_block_FF+0x240>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 80 44 80 00       	push   $0x804480
  802b5c:	68 eb 00 00 00       	push   $0xeb
  802b61:	68 d7 43 80 00       	push   $0x8043d7
  802b66:	e8 9b db ff ff       	call   800706 <_panic>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	85 c0                	test   %eax,%eax
  802b72:	74 10                	je     802b84 <alloc_block_FF+0x259>
  802b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7c:	8b 52 04             	mov    0x4(%edx),%edx
  802b7f:	89 50 04             	mov    %edx,0x4(%eax)
  802b82:	eb 0b                	jmp    802b8f <alloc_block_FF+0x264>
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	a3 88 50 98 00       	mov    %eax,0x985088
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 40 04             	mov    0x4(%eax),%eax
  802b95:	85 c0                	test   %eax,%eax
  802b97:	74 0f                	je     802ba8 <alloc_block_FF+0x27d>
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 04             	mov    0x4(%eax),%eax
  802b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba2:	8b 12                	mov    (%edx),%edx
  802ba4:	89 10                	mov    %edx,(%eax)
  802ba6:	eb 0a                	jmp    802bb2 <alloc_block_FF+0x287>
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	a3 84 50 98 00       	mov    %eax,0x985084
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc5:	a1 90 50 98 00       	mov    0x985090,%eax
  802bca:	48                   	dec    %eax
  802bcb:	a3 90 50 98 00       	mov    %eax,0x985090
				return (void*)((uint32*)block);
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	e9 88 01 00 00       	jmp    802d60 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802bd8:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be4:	74 07                	je     802bed <alloc_block_FF+0x2c2>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	eb 05                	jmp    802bf2 <alloc_block_FF+0x2c7>
  802bed:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf2:	a3 8c 50 98 00       	mov    %eax,0x98508c
  802bf7:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	0f 85 d9 fd ff ff    	jne    8029dd <alloc_block_FF+0xb2>
  802c04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c08:	0f 85 cf fd ff ff    	jne    8029dd <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802c0e:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802c15:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c1b:	01 d0                	add    %edx,%eax
  802c1d:	48                   	dec    %eax
  802c1e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802c21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c24:	ba 00 00 00 00       	mov    $0x0,%edx
  802c29:	f7 75 d8             	divl   -0x28(%ebp)
  802c2c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802c2f:	29 d0                	sub    %edx,%eax
  802c31:	c1 e8 0c             	shr    $0xc,%eax
  802c34:	83 ec 0c             	sub    $0xc,%esp
  802c37:	50                   	push   %eax
  802c38:	e8 20 eb ff ff       	call   80175d <sbrk>
  802c3d:	83 c4 10             	add    $0x10,%esp
  802c40:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802c43:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802c47:	75 0a                	jne    802c53 <alloc_block_FF+0x328>
		return NULL;
  802c49:	b8 00 00 00 00       	mov    $0x0,%eax
  802c4e:	e9 0d 01 00 00       	jmp    802d60 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802c53:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c56:	83 e8 04             	sub    $0x4,%eax
  802c59:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802c5c:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802c63:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c66:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802c69:	01 d0                	add    %edx,%eax
  802c6b:	48                   	dec    %eax
  802c6c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802c6f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c72:	ba 00 00 00 00       	mov    $0x0,%edx
  802c77:	f7 75 c8             	divl   -0x38(%ebp)
  802c7a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c7d:	29 d0                	sub    %edx,%eax
  802c7f:	c1 e8 02             	shr    $0x2,%eax
  802c82:	c1 e0 02             	shl    $0x2,%eax
  802c85:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802c88:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802c8b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802c91:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c94:	83 e8 08             	sub    $0x8,%eax
  802c97:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802c9a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802c9d:	8b 00                	mov    (%eax),%eax
  802c9f:	83 e0 fe             	and    $0xfffffffe,%eax
  802ca2:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802ca5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802ca8:	f7 d8                	neg    %eax
  802caa:	89 c2                	mov    %eax,%edx
  802cac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802caf:	01 d0                	add    %edx,%eax
  802cb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802cb4:	83 ec 0c             	sub    $0xc,%esp
  802cb7:	ff 75 b8             	pushl  -0x48(%ebp)
  802cba:	e8 1f f8 ff ff       	call   8024de <is_free_block>
  802cbf:	83 c4 10             	add    $0x10,%esp
  802cc2:	0f be c0             	movsbl %al,%eax
  802cc5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802cc8:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802ccc:	74 42                	je     802d10 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802cce:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802cd5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cd8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802cdb:	01 d0                	add    %edx,%eax
  802cdd:	48                   	dec    %eax
  802cde:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802ce1:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce9:	f7 75 b0             	divl   -0x50(%ebp)
  802cec:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802cef:	29 d0                	sub    %edx,%eax
  802cf1:	89 c2                	mov    %eax,%edx
  802cf3:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802cf6:	01 d0                	add    %edx,%eax
  802cf8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802cfb:	83 ec 04             	sub    $0x4,%esp
  802cfe:	6a 00                	push   $0x0
  802d00:	ff 75 a8             	pushl  -0x58(%ebp)
  802d03:	ff 75 b8             	pushl  -0x48(%ebp)
  802d06:	e8 36 fa ff ff       	call   802741 <set_block_data>
  802d0b:	83 c4 10             	add    $0x10,%esp
  802d0e:	eb 42                	jmp    802d52 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802d10:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802d17:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d1a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802d1d:	01 d0                	add    %edx,%eax
  802d1f:	48                   	dec    %eax
  802d20:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802d23:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802d26:	ba 00 00 00 00       	mov    $0x0,%edx
  802d2b:	f7 75 a4             	divl   -0x5c(%ebp)
  802d2e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802d31:	29 d0                	sub    %edx,%eax
  802d33:	83 ec 04             	sub    $0x4,%esp
  802d36:	6a 00                	push   $0x0
  802d38:	50                   	push   %eax
  802d39:	ff 75 d0             	pushl  -0x30(%ebp)
  802d3c:	e8 00 fa ff ff       	call   802741 <set_block_data>
  802d41:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802d44:	83 ec 0c             	sub    $0xc,%esp
  802d47:	ff 75 d0             	pushl  -0x30(%ebp)
  802d4a:	e8 49 fa ff ff       	call   802798 <insert_sorted_in_freeList>
  802d4f:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802d52:	83 ec 0c             	sub    $0xc,%esp
  802d55:	ff 75 08             	pushl  0x8(%ebp)
  802d58:	e8 ce fb ff ff       	call   80292b <alloc_block_FF>
  802d5d:	83 c4 10             	add    $0x10,%esp
}
  802d60:	c9                   	leave  
  802d61:	c3                   	ret    

00802d62 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802d62:	55                   	push   %ebp
  802d63:	89 e5                	mov    %esp,%ebp
  802d65:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802d68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6c:	75 0a                	jne    802d78 <alloc_block_BF+0x16>
	{
		return NULL;
  802d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802d73:	e9 7a 02 00 00       	jmp    802ff2 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	83 c0 08             	add    $0x8,%eax
  802d7e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802d81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802d88:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802d8f:	a1 84 50 98 00       	mov    0x985084,%eax
  802d94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d97:	eb 32                	jmp    802dcb <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802d99:	ff 75 ec             	pushl  -0x14(%ebp)
  802d9c:	e8 24 f7 ff ff       	call   8024c5 <get_block_size>
  802da1:	83 c4 04             	add    $0x4,%esp
  802da4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802daa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802dad:	72 14                	jb     802dc3 <alloc_block_BF+0x61>
  802daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802db2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802db5:	73 0c                	jae    802dc3 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802dbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802dc3:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802dc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dcf:	74 07                	je     802dd8 <alloc_block_BF+0x76>
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	8b 00                	mov    (%eax),%eax
  802dd6:	eb 05                	jmp    802ddd <alloc_block_BF+0x7b>
  802dd8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddd:	a3 8c 50 98 00       	mov    %eax,0x98508c
  802de2:	a1 8c 50 98 00       	mov    0x98508c,%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	75 ae                	jne    802d99 <alloc_block_BF+0x37>
  802deb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802def:	75 a8                	jne    802d99 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802df1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df5:	75 22                	jne    802e19 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802df7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfa:	83 ec 0c             	sub    $0xc,%esp
  802dfd:	50                   	push   %eax
  802dfe:	e8 5a e9 ff ff       	call   80175d <sbrk>
  802e03:	83 c4 10             	add    $0x10,%esp
  802e06:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802e09:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802e0d:	75 0a                	jne    802e19 <alloc_block_BF+0xb7>
			return NULL;
  802e0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e14:	e9 d9 01 00 00       	jmp    802ff2 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802e19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1c:	83 c0 10             	add    $0x10,%eax
  802e1f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e22:	0f 87 32 01 00 00    	ja     802f5a <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e2e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e37:	01 d0                	add    %edx,%eax
  802e39:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802e3c:	83 ec 04             	sub    $0x4,%esp
  802e3f:	6a 00                	push   $0x0
  802e41:	ff 75 dc             	pushl  -0x24(%ebp)
  802e44:	ff 75 d8             	pushl  -0x28(%ebp)
  802e47:	e8 f5 f8 ff ff       	call   802741 <set_block_data>
  802e4c:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e53:	74 06                	je     802e5b <alloc_block_BF+0xf9>
  802e55:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802e59:	75 17                	jne    802e72 <alloc_block_BF+0x110>
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 4c 44 80 00       	push   $0x80444c
  802e63:	68 49 01 00 00       	push   $0x149
  802e68:	68 d7 43 80 00       	push   $0x8043d7
  802e6d:	e8 94 d8 ff ff       	call   800706 <_panic>
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 10                	mov    (%eax),%edx
  802e77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e7f:	8b 00                	mov    (%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 0b                	je     802e90 <alloc_block_BF+0x12e>
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 00                	mov    (%eax),%eax
  802e8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e8d:	89 50 04             	mov    %edx,0x4(%eax)
  802e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e93:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ea1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	85 c0                	test   %eax,%eax
  802ea8:	75 08                	jne    802eb2 <alloc_block_BF+0x150>
  802eaa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ead:	a3 88 50 98 00       	mov    %eax,0x985088
  802eb2:	a1 90 50 98 00       	mov    0x985090,%eax
  802eb7:	40                   	inc    %eax
  802eb8:	a3 90 50 98 00       	mov    %eax,0x985090

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	6a 01                	push   $0x1
  802ec2:	ff 75 e8             	pushl  -0x18(%ebp)
  802ec5:	ff 75 f4             	pushl  -0xc(%ebp)
  802ec8:	e8 74 f8 ff ff       	call   802741 <set_block_data>
  802ecd:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802ed0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed4:	75 17                	jne    802eed <alloc_block_BF+0x18b>
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	68 80 44 80 00       	push   $0x804480
  802ede:	68 4e 01 00 00       	push   $0x14e
  802ee3:	68 d7 43 80 00       	push   $0x8043d7
  802ee8:	e8 19 d8 ff ff       	call   800706 <_panic>
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 10                	je     802f06 <alloc_block_BF+0x1a4>
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efe:	8b 52 04             	mov    0x4(%edx),%edx
  802f01:	89 50 04             	mov    %edx,0x4(%eax)
  802f04:	eb 0b                	jmp    802f11 <alloc_block_BF+0x1af>
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	a3 88 50 98 00       	mov    %eax,0x985088
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 04             	mov    0x4(%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 0f                	je     802f2a <alloc_block_BF+0x1c8>
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 04             	mov    0x4(%eax),%eax
  802f21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f24:	8b 12                	mov    (%edx),%edx
  802f26:	89 10                	mov    %edx,(%eax)
  802f28:	eb 0a                	jmp    802f34 <alloc_block_BF+0x1d2>
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	a3 84 50 98 00       	mov    %eax,0x985084
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f47:	a1 90 50 98 00       	mov    0x985090,%eax
  802f4c:	48                   	dec    %eax
  802f4d:	a3 90 50 98 00       	mov    %eax,0x985090
		return (void*)((uint32*)minBlk);
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	e9 98 00 00 00       	jmp    802ff2 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	6a 01                	push   $0x1
  802f5f:	ff 75 f0             	pushl  -0x10(%ebp)
  802f62:	ff 75 f4             	pushl  -0xc(%ebp)
  802f65:	e8 d7 f7 ff ff       	call   802741 <set_block_data>
  802f6a:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802f6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f71:	75 17                	jne    802f8a <alloc_block_BF+0x228>
  802f73:	83 ec 04             	sub    $0x4,%esp
  802f76:	68 80 44 80 00       	push   $0x804480
  802f7b:	68 56 01 00 00       	push   $0x156
  802f80:	68 d7 43 80 00       	push   $0x8043d7
  802f85:	e8 7c d7 ff ff       	call   800706 <_panic>
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 10                	je     802fa3 <alloc_block_BF+0x241>
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	8b 00                	mov    (%eax),%eax
  802f98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9b:	8b 52 04             	mov    0x4(%edx),%edx
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	eb 0b                	jmp    802fae <alloc_block_BF+0x24c>
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	8b 40 04             	mov    0x4(%eax),%eax
  802fa9:	a3 88 50 98 00       	mov    %eax,0x985088
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	8b 40 04             	mov    0x4(%eax),%eax
  802fb4:	85 c0                	test   %eax,%eax
  802fb6:	74 0f                	je     802fc7 <alloc_block_BF+0x265>
  802fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbb:	8b 40 04             	mov    0x4(%eax),%eax
  802fbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc1:	8b 12                	mov    (%edx),%edx
  802fc3:	89 10                	mov    %edx,(%eax)
  802fc5:	eb 0a                	jmp    802fd1 <alloc_block_BF+0x26f>
  802fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fca:	8b 00                	mov    (%eax),%eax
  802fcc:	a3 84 50 98 00       	mov    %eax,0x985084
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe4:	a1 90 50 98 00       	mov    0x985090,%eax
  802fe9:	48                   	dec    %eax
  802fea:	a3 90 50 98 00       	mov    %eax,0x985090
		return (void*)((uint32*)minBlk);
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802ff2:	c9                   	leave  
  802ff3:	c3                   	ret    

00802ff4 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802ff4:	55                   	push   %ebp
  802ff5:	89 e5                	mov    %esp,%ebp
  802ff7:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802ffa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ffe:	0f 84 6a 02 00 00    	je     80326e <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803004:	ff 75 08             	pushl  0x8(%ebp)
  803007:	e8 b9 f4 ff ff       	call   8024c5 <get_block_size>
  80300c:	83 c4 04             	add    $0x4,%esp
  80300f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803012:	8b 45 08             	mov    0x8(%ebp),%eax
  803015:	83 e8 08             	sub    $0x8,%eax
  803018:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  80301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	83 e0 fe             	and    $0xfffffffe,%eax
  803023:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	f7 d8                	neg    %eax
  80302b:	89 c2                	mov    %eax,%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	01 d0                	add    %edx,%eax
  803032:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803035:	ff 75 e8             	pushl  -0x18(%ebp)
  803038:	e8 a1 f4 ff ff       	call   8024de <is_free_block>
  80303d:	83 c4 04             	add    $0x4,%esp
  803040:	0f be c0             	movsbl %al,%eax
  803043:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803046:	8b 55 08             	mov    0x8(%ebp),%edx
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	01 d0                	add    %edx,%eax
  80304e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803051:	ff 75 e0             	pushl  -0x20(%ebp)
  803054:	e8 85 f4 ff ff       	call   8024de <is_free_block>
  803059:	83 c4 04             	add    $0x4,%esp
  80305c:	0f be c0             	movsbl %al,%eax
  80305f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803062:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803066:	75 34                	jne    80309c <free_block+0xa8>
  803068:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80306c:	75 2e                	jne    80309c <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  80306e:	ff 75 e8             	pushl  -0x18(%ebp)
  803071:	e8 4f f4 ff ff       	call   8024c5 <get_block_size>
  803076:	83 c4 04             	add    $0x4,%esp
  803079:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  80307c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803082:	01 d0                	add    %edx,%eax
  803084:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803087:	6a 00                	push   $0x0
  803089:	ff 75 d4             	pushl  -0x2c(%ebp)
  80308c:	ff 75 e8             	pushl  -0x18(%ebp)
  80308f:	e8 ad f6 ff ff       	call   802741 <set_block_data>
  803094:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803097:	e9 d3 01 00 00       	jmp    80326f <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80309c:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  8030a0:	0f 85 c8 00 00 00    	jne    80316e <free_block+0x17a>
  8030a6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030aa:	0f 85 be 00 00 00    	jne    80316e <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  8030b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8030b3:	e8 0d f4 ff ff       	call   8024c5 <get_block_size>
  8030b8:	83 c4 04             	add    $0x4,%esp
  8030bb:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  8030be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8030c4:	01 d0                	add    %edx,%eax
  8030c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  8030c9:	6a 00                	push   $0x0
  8030cb:	ff 75 cc             	pushl  -0x34(%ebp)
  8030ce:	ff 75 08             	pushl  0x8(%ebp)
  8030d1:	e8 6b f6 ff ff       	call   802741 <set_block_data>
  8030d6:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  8030d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8030dd:	75 17                	jne    8030f6 <free_block+0x102>
  8030df:	83 ec 04             	sub    $0x4,%esp
  8030e2:	68 80 44 80 00       	push   $0x804480
  8030e7:	68 87 01 00 00       	push   $0x187
  8030ec:	68 d7 43 80 00       	push   $0x8043d7
  8030f1:	e8 10 d6 ff ff       	call   800706 <_panic>
  8030f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f9:	8b 00                	mov    (%eax),%eax
  8030fb:	85 c0                	test   %eax,%eax
  8030fd:	74 10                	je     80310f <free_block+0x11b>
  8030ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803107:	8b 52 04             	mov    0x4(%edx),%edx
  80310a:	89 50 04             	mov    %edx,0x4(%eax)
  80310d:	eb 0b                	jmp    80311a <free_block+0x126>
  80310f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803112:	8b 40 04             	mov    0x4(%eax),%eax
  803115:	a3 88 50 98 00       	mov    %eax,0x985088
  80311a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311d:	8b 40 04             	mov    0x4(%eax),%eax
  803120:	85 c0                	test   %eax,%eax
  803122:	74 0f                	je     803133 <free_block+0x13f>
  803124:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803127:	8b 40 04             	mov    0x4(%eax),%eax
  80312a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80312d:	8b 12                	mov    (%edx),%edx
  80312f:	89 10                	mov    %edx,(%eax)
  803131:	eb 0a                	jmp    80313d <free_block+0x149>
  803133:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	a3 84 50 98 00       	mov    %eax,0x985084
  80313d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803146:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803149:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803150:	a1 90 50 98 00       	mov    0x985090,%eax
  803155:	48                   	dec    %eax
  803156:	a3 90 50 98 00       	mov    %eax,0x985090
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80315b:	83 ec 0c             	sub    $0xc,%esp
  80315e:	ff 75 08             	pushl  0x8(%ebp)
  803161:	e8 32 f6 ff ff       	call   802798 <insert_sorted_in_freeList>
  803166:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803169:	e9 01 01 00 00       	jmp    80326f <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  80316e:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803172:	0f 85 d3 00 00 00    	jne    80324b <free_block+0x257>
  803178:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80317c:	0f 85 c9 00 00 00    	jne    80324b <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803182:	83 ec 0c             	sub    $0xc,%esp
  803185:	ff 75 e8             	pushl  -0x18(%ebp)
  803188:	e8 38 f3 ff ff       	call   8024c5 <get_block_size>
  80318d:	83 c4 10             	add    $0x10,%esp
  803190:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803193:	83 ec 0c             	sub    $0xc,%esp
  803196:	ff 75 e0             	pushl  -0x20(%ebp)
  803199:	e8 27 f3 ff ff       	call   8024c5 <get_block_size>
  80319e:	83 c4 10             	add    $0x10,%esp
  8031a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  8031a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8031aa:	01 c2                	add    %eax,%edx
  8031ac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8031af:	01 d0                	add    %edx,%eax
  8031b1:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  8031b4:	83 ec 04             	sub    $0x4,%esp
  8031b7:	6a 00                	push   $0x0
  8031b9:	ff 75 c0             	pushl  -0x40(%ebp)
  8031bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8031bf:	e8 7d f5 ff ff       	call   802741 <set_block_data>
  8031c4:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  8031c7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8031cb:	75 17                	jne    8031e4 <free_block+0x1f0>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 80 44 80 00       	push   $0x804480
  8031d5:	68 94 01 00 00       	push   $0x194
  8031da:	68 d7 43 80 00       	push   $0x8043d7
  8031df:	e8 22 d5 ff ff       	call   800706 <_panic>
  8031e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 10                	je     8031fd <free_block+0x209>
  8031ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031f5:	8b 52 04             	mov    0x4(%edx),%edx
  8031f8:	89 50 04             	mov    %edx,0x4(%eax)
  8031fb:	eb 0b                	jmp    803208 <free_block+0x214>
  8031fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	a3 88 50 98 00       	mov    %eax,0x985088
  803208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0f                	je     803221 <free_block+0x22d>
  803212:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80321b:	8b 12                	mov    (%edx),%edx
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	eb 0a                	jmp    80322b <free_block+0x237>
  803221:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	a3 84 50 98 00       	mov    %eax,0x985084
  80322b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80322e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803234:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803237:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323e:	a1 90 50 98 00       	mov    0x985090,%eax
  803243:	48                   	dec    %eax
  803244:	a3 90 50 98 00       	mov    %eax,0x985090
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803249:	eb 24                	jmp    80326f <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  80324b:	83 ec 04             	sub    $0x4,%esp
  80324e:	6a 00                	push   $0x0
  803250:	ff 75 f4             	pushl  -0xc(%ebp)
  803253:	ff 75 08             	pushl  0x8(%ebp)
  803256:	e8 e6 f4 ff ff       	call   802741 <set_block_data>
  80325b:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80325e:	83 ec 0c             	sub    $0xc,%esp
  803261:	ff 75 08             	pushl  0x8(%ebp)
  803264:	e8 2f f5 ff ff       	call   802798 <insert_sorted_in_freeList>
  803269:	83 c4 10             	add    $0x10,%esp
  80326c:	eb 01                	jmp    80326f <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  80326e:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  80326f:	c9                   	leave  
  803270:	c3                   	ret    

00803271 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803271:	55                   	push   %ebp
  803272:	89 e5                	mov    %esp,%ebp
  803274:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327b:	75 10                	jne    80328d <realloc_block_FF+0x1c>
  80327d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803281:	75 0a                	jne    80328d <realloc_block_FF+0x1c>
	{
		return NULL;
  803283:	b8 00 00 00 00       	mov    $0x0,%eax
  803288:	e9 8b 04 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  80328d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803291:	75 18                	jne    8032ab <realloc_block_FF+0x3a>
	{
		free_block(va);
  803293:	83 ec 0c             	sub    $0xc,%esp
  803296:	ff 75 08             	pushl  0x8(%ebp)
  803299:	e8 56 fd ff ff       	call   802ff4 <free_block>
  80329e:	83 c4 10             	add    $0x10,%esp
		return NULL;
  8032a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8032a6:	e9 6d 04 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  8032ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032af:	75 13                	jne    8032c4 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  8032b1:	83 ec 0c             	sub    $0xc,%esp
  8032b4:	ff 75 0c             	pushl  0xc(%ebp)
  8032b7:	e8 6f f6 ff ff       	call   80292b <alloc_block_FF>
  8032bc:	83 c4 10             	add    $0x10,%esp
  8032bf:	e9 54 04 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  8032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c7:	83 e0 01             	and    $0x1,%eax
  8032ca:	85 c0                	test   %eax,%eax
  8032cc:	74 03                	je     8032d1 <realloc_block_FF+0x60>
	{
		new_size++;
  8032ce:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  8032d1:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8032d5:	77 07                	ja     8032de <realloc_block_FF+0x6d>
	{
		new_size = 8;
  8032d7:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  8032de:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  8032e2:	83 ec 0c             	sub    $0xc,%esp
  8032e5:	ff 75 08             	pushl  0x8(%ebp)
  8032e8:	e8 d8 f1 ff ff       	call   8024c5 <get_block_size>
  8032ed:	83 c4 10             	add    $0x10,%esp
  8032f0:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032f9:	75 08                	jne    803303 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	e9 15 04 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803303:	8b 55 08             	mov    0x8(%ebp),%edx
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	01 d0                	add    %edx,%eax
  80330b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80330e:	83 ec 0c             	sub    $0xc,%esp
  803311:	ff 75 f0             	pushl  -0x10(%ebp)
  803314:	e8 c5 f1 ff ff       	call   8024de <is_free_block>
  803319:	83 c4 10             	add    $0x10,%esp
  80331c:	0f be c0             	movsbl %al,%eax
  80331f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803322:	83 ec 0c             	sub    $0xc,%esp
  803325:	ff 75 f0             	pushl  -0x10(%ebp)
  803328:	e8 98 f1 ff ff       	call   8024c5 <get_block_size>
  80332d:	83 c4 10             	add    $0x10,%esp
  803330:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803333:	8b 45 0c             	mov    0xc(%ebp),%eax
  803336:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803339:	0f 86 a7 02 00 00    	jbe    8035e6 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  80333f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803343:	0f 84 86 02 00 00    	je     8035cf <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803349:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	01 d0                	add    %edx,%eax
  803351:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803354:	0f 85 b2 00 00 00    	jne    80340c <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80335a:	83 ec 0c             	sub    $0xc,%esp
  80335d:	ff 75 08             	pushl  0x8(%ebp)
  803360:	e8 79 f1 ff ff       	call   8024de <is_free_block>
  803365:	83 c4 10             	add    $0x10,%esp
  803368:	84 c0                	test   %al,%al
  80336a:	0f 94 c0             	sete   %al
  80336d:	0f b6 c0             	movzbl %al,%eax
  803370:	83 ec 04             	sub    $0x4,%esp
  803373:	50                   	push   %eax
  803374:	ff 75 0c             	pushl  0xc(%ebp)
  803377:	ff 75 08             	pushl  0x8(%ebp)
  80337a:	e8 c2 f3 ff ff       	call   802741 <set_block_data>
  80337f:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803386:	75 17                	jne    80339f <realloc_block_FF+0x12e>
  803388:	83 ec 04             	sub    $0x4,%esp
  80338b:	68 80 44 80 00       	push   $0x804480
  803390:	68 db 01 00 00       	push   $0x1db
  803395:	68 d7 43 80 00       	push   $0x8043d7
  80339a:	e8 67 d3 ff ff       	call   800706 <_panic>
  80339f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033a2:	8b 00                	mov    (%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 10                	je     8033b8 <realloc_block_FF+0x147>
  8033a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ab:	8b 00                	mov    (%eax),%eax
  8033ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033b0:	8b 52 04             	mov    0x4(%edx),%edx
  8033b3:	89 50 04             	mov    %edx,0x4(%eax)
  8033b6:	eb 0b                	jmp    8033c3 <realloc_block_FF+0x152>
  8033b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	a3 88 50 98 00       	mov    %eax,0x985088
  8033c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c6:	8b 40 04             	mov    0x4(%eax),%eax
  8033c9:	85 c0                	test   %eax,%eax
  8033cb:	74 0f                	je     8033dc <realloc_block_FF+0x16b>
  8033cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d0:	8b 40 04             	mov    0x4(%eax),%eax
  8033d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033d6:	8b 12                	mov    (%edx),%edx
  8033d8:	89 10                	mov    %edx,(%eax)
  8033da:	eb 0a                	jmp    8033e6 <realloc_block_FF+0x175>
  8033dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	a3 84 50 98 00       	mov    %eax,0x985084
  8033e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f9:	a1 90 50 98 00       	mov    0x985090,%eax
  8033fe:	48                   	dec    %eax
  8033ff:	a3 90 50 98 00       	mov    %eax,0x985090
				return va;
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	e9 0c 03 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80340c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	01 d0                	add    %edx,%eax
  803414:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803417:	0f 86 b2 01 00 00    	jbe    8035cf <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  80341d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803420:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803423:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803426:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803429:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80342c:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  80342f:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803433:	0f 87 b8 00 00 00    	ja     8034f1 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803439:	83 ec 0c             	sub    $0xc,%esp
  80343c:	ff 75 08             	pushl  0x8(%ebp)
  80343f:	e8 9a f0 ff ff       	call   8024de <is_free_block>
  803444:	83 c4 10             	add    $0x10,%esp
  803447:	84 c0                	test   %al,%al
  803449:	0f 94 c0             	sete   %al
  80344c:	0f b6 c0             	movzbl %al,%eax
  80344f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803452:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803455:	01 ca                	add    %ecx,%edx
  803457:	83 ec 04             	sub    $0x4,%esp
  80345a:	50                   	push   %eax
  80345b:	52                   	push   %edx
  80345c:	ff 75 08             	pushl  0x8(%ebp)
  80345f:	e8 dd f2 ff ff       	call   802741 <set_block_data>
  803464:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80346b:	75 17                	jne    803484 <realloc_block_FF+0x213>
  80346d:	83 ec 04             	sub    $0x4,%esp
  803470:	68 80 44 80 00       	push   $0x804480
  803475:	68 e8 01 00 00       	push   $0x1e8
  80347a:	68 d7 43 80 00       	push   $0x8043d7
  80347f:	e8 82 d2 ff ff       	call   800706 <_panic>
  803484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803487:	8b 00                	mov    (%eax),%eax
  803489:	85 c0                	test   %eax,%eax
  80348b:	74 10                	je     80349d <realloc_block_FF+0x22c>
  80348d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803490:	8b 00                	mov    (%eax),%eax
  803492:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803495:	8b 52 04             	mov    0x4(%edx),%edx
  803498:	89 50 04             	mov    %edx,0x4(%eax)
  80349b:	eb 0b                	jmp    8034a8 <realloc_block_FF+0x237>
  80349d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a0:	8b 40 04             	mov    0x4(%eax),%eax
  8034a3:	a3 88 50 98 00       	mov    %eax,0x985088
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	8b 40 04             	mov    0x4(%eax),%eax
  8034ae:	85 c0                	test   %eax,%eax
  8034b0:	74 0f                	je     8034c1 <realloc_block_FF+0x250>
  8034b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b5:	8b 40 04             	mov    0x4(%eax),%eax
  8034b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034bb:	8b 12                	mov    (%edx),%edx
  8034bd:	89 10                	mov    %edx,(%eax)
  8034bf:	eb 0a                	jmp    8034cb <realloc_block_FF+0x25a>
  8034c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034c4:	8b 00                	mov    (%eax),%eax
  8034c6:	a3 84 50 98 00       	mov    %eax,0x985084
  8034cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034de:	a1 90 50 98 00       	mov    0x985090,%eax
  8034e3:	48                   	dec    %eax
  8034e4:	a3 90 50 98 00       	mov    %eax,0x985090
					return va;
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	e9 27 02 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8034f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8034f5:	75 17                	jne    80350e <realloc_block_FF+0x29d>
  8034f7:	83 ec 04             	sub    $0x4,%esp
  8034fa:	68 80 44 80 00       	push   $0x804480
  8034ff:	68 ed 01 00 00       	push   $0x1ed
  803504:	68 d7 43 80 00       	push   $0x8043d7
  803509:	e8 f8 d1 ff ff       	call   800706 <_panic>
  80350e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803511:	8b 00                	mov    (%eax),%eax
  803513:	85 c0                	test   %eax,%eax
  803515:	74 10                	je     803527 <realloc_block_FF+0x2b6>
  803517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80351a:	8b 00                	mov    (%eax),%eax
  80351c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80351f:	8b 52 04             	mov    0x4(%edx),%edx
  803522:	89 50 04             	mov    %edx,0x4(%eax)
  803525:	eb 0b                	jmp    803532 <realloc_block_FF+0x2c1>
  803527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80352a:	8b 40 04             	mov    0x4(%eax),%eax
  80352d:	a3 88 50 98 00       	mov    %eax,0x985088
  803532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803535:	8b 40 04             	mov    0x4(%eax),%eax
  803538:	85 c0                	test   %eax,%eax
  80353a:	74 0f                	je     80354b <realloc_block_FF+0x2da>
  80353c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80353f:	8b 40 04             	mov    0x4(%eax),%eax
  803542:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803545:	8b 12                	mov    (%edx),%edx
  803547:	89 10                	mov    %edx,(%eax)
  803549:	eb 0a                	jmp    803555 <realloc_block_FF+0x2e4>
  80354b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80354e:	8b 00                	mov    (%eax),%eax
  803550:	a3 84 50 98 00       	mov    %eax,0x985084
  803555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803558:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80355e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803568:	a1 90 50 98 00       	mov    0x985090,%eax
  80356d:	48                   	dec    %eax
  80356e:	a3 90 50 98 00       	mov    %eax,0x985090
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803573:	8b 55 08             	mov    0x8(%ebp),%edx
  803576:	8b 45 0c             	mov    0xc(%ebp),%eax
  803579:	01 d0                	add    %edx,%eax
  80357b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  80357e:	83 ec 04             	sub    $0x4,%esp
  803581:	6a 00                	push   $0x0
  803583:	ff 75 e0             	pushl  -0x20(%ebp)
  803586:	ff 75 f0             	pushl  -0x10(%ebp)
  803589:	e8 b3 f1 ff ff       	call   802741 <set_block_data>
  80358e:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803591:	83 ec 0c             	sub    $0xc,%esp
  803594:	ff 75 08             	pushl  0x8(%ebp)
  803597:	e8 42 ef ff ff       	call   8024de <is_free_block>
  80359c:	83 c4 10             	add    $0x10,%esp
  80359f:	84 c0                	test   %al,%al
  8035a1:	0f 94 c0             	sete   %al
  8035a4:	0f b6 c0             	movzbl %al,%eax
  8035a7:	83 ec 04             	sub    $0x4,%esp
  8035aa:	50                   	push   %eax
  8035ab:	ff 75 0c             	pushl  0xc(%ebp)
  8035ae:	ff 75 08             	pushl  0x8(%ebp)
  8035b1:	e8 8b f1 ff ff       	call   802741 <set_block_data>
  8035b6:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8035b9:	83 ec 0c             	sub    $0xc,%esp
  8035bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8035bf:	e8 d4 f1 ff ff       	call   802798 <insert_sorted_in_freeList>
  8035c4:	83 c4 10             	add    $0x10,%esp
					return va;
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	e9 49 01 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8035cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035d2:	83 e8 08             	sub    $0x8,%eax
  8035d5:	83 ec 0c             	sub    $0xc,%esp
  8035d8:	50                   	push   %eax
  8035d9:	e8 4d f3 ff ff       	call   80292b <alloc_block_FF>
  8035de:	83 c4 10             	add    $0x10,%esp
  8035e1:	e9 32 01 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8035e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035e9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8035ec:	0f 83 21 01 00 00    	jae    803713 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8035f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f5:	2b 45 0c             	sub    0xc(%ebp),%eax
  8035f8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8035fb:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8035ff:	77 0e                	ja     80360f <realloc_block_FF+0x39e>
  803601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803605:	75 08                	jne    80360f <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803607:	8b 45 08             	mov    0x8(%ebp),%eax
  80360a:	e9 09 01 00 00       	jmp    803718 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803615:	83 ec 0c             	sub    $0xc,%esp
  803618:	ff 75 08             	pushl  0x8(%ebp)
  80361b:	e8 be ee ff ff       	call   8024de <is_free_block>
  803620:	83 c4 10             	add    $0x10,%esp
  803623:	84 c0                	test   %al,%al
  803625:	0f 94 c0             	sete   %al
  803628:	0f b6 c0             	movzbl %al,%eax
  80362b:	83 ec 04             	sub    $0x4,%esp
  80362e:	50                   	push   %eax
  80362f:	ff 75 0c             	pushl  0xc(%ebp)
  803632:	ff 75 d8             	pushl  -0x28(%ebp)
  803635:	e8 07 f1 ff ff       	call   802741 <set_block_data>
  80363a:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80363d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803640:	8b 45 0c             	mov    0xc(%ebp),%eax
  803643:	01 d0                	add    %edx,%eax
  803645:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803648:	83 ec 04             	sub    $0x4,%esp
  80364b:	6a 00                	push   $0x0
  80364d:	ff 75 dc             	pushl  -0x24(%ebp)
  803650:	ff 75 d4             	pushl  -0x2c(%ebp)
  803653:	e8 e9 f0 ff ff       	call   802741 <set_block_data>
  803658:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80365b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80365f:	0f 84 9b 00 00 00    	je     803700 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803665:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366b:	01 d0                	add    %edx,%eax
  80366d:	83 ec 04             	sub    $0x4,%esp
  803670:	6a 00                	push   $0x0
  803672:	50                   	push   %eax
  803673:	ff 75 d4             	pushl  -0x2c(%ebp)
  803676:	e8 c6 f0 ff ff       	call   802741 <set_block_data>
  80367b:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80367e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803682:	75 17                	jne    80369b <realloc_block_FF+0x42a>
  803684:	83 ec 04             	sub    $0x4,%esp
  803687:	68 80 44 80 00       	push   $0x804480
  80368c:	68 10 02 00 00       	push   $0x210
  803691:	68 d7 43 80 00       	push   $0x8043d7
  803696:	e8 6b d0 ff ff       	call   800706 <_panic>
  80369b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80369e:	8b 00                	mov    (%eax),%eax
  8036a0:	85 c0                	test   %eax,%eax
  8036a2:	74 10                	je     8036b4 <realloc_block_FF+0x443>
  8036a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036ac:	8b 52 04             	mov    0x4(%edx),%edx
  8036af:	89 50 04             	mov    %edx,0x4(%eax)
  8036b2:	eb 0b                	jmp    8036bf <realloc_block_FF+0x44e>
  8036b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036b7:	8b 40 04             	mov    0x4(%eax),%eax
  8036ba:	a3 88 50 98 00       	mov    %eax,0x985088
  8036bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036c2:	8b 40 04             	mov    0x4(%eax),%eax
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	74 0f                	je     8036d8 <realloc_block_FF+0x467>
  8036c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036cc:	8b 40 04             	mov    0x4(%eax),%eax
  8036cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8036d2:	8b 12                	mov    (%edx),%edx
  8036d4:	89 10                	mov    %edx,(%eax)
  8036d6:	eb 0a                	jmp    8036e2 <realloc_block_FF+0x471>
  8036d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036db:	8b 00                	mov    (%eax),%eax
  8036dd:	a3 84 50 98 00       	mov    %eax,0x985084
  8036e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8036ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f5:	a1 90 50 98 00       	mov    0x985090,%eax
  8036fa:	48                   	dec    %eax
  8036fb:	a3 90 50 98 00       	mov    %eax,0x985090
			}
			insert_sorted_in_freeList(remainingBlk);
  803700:	83 ec 0c             	sub    $0xc,%esp
  803703:	ff 75 d4             	pushl  -0x2c(%ebp)
  803706:	e8 8d f0 ff ff       	call   802798 <insert_sorted_in_freeList>
  80370b:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80370e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803711:	eb 05                	jmp    803718 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803718:	c9                   	leave  
  803719:	c3                   	ret    

0080371a <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80371a:	55                   	push   %ebp
  80371b:	89 e5                	mov    %esp,%ebp
  80371d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803720:	83 ec 04             	sub    $0x4,%esp
  803723:	68 a0 44 80 00       	push   $0x8044a0
  803728:	68 20 02 00 00       	push   $0x220
  80372d:	68 d7 43 80 00       	push   $0x8043d7
  803732:	e8 cf cf ff ff       	call   800706 <_panic>

00803737 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803737:	55                   	push   %ebp
  803738:	89 e5                	mov    %esp,%ebp
  80373a:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	68 c8 44 80 00       	push   $0x8044c8
  803745:	68 28 02 00 00       	push   $0x228
  80374a:	68 d7 43 80 00       	push   $0x8043d7
  80374f:	e8 b2 cf ff ff       	call   800706 <_panic>

00803754 <__udivdi3>:
  803754:	55                   	push   %ebp
  803755:	57                   	push   %edi
  803756:	56                   	push   %esi
  803757:	53                   	push   %ebx
  803758:	83 ec 1c             	sub    $0x1c,%esp
  80375b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80375f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803763:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803767:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80376b:	89 ca                	mov    %ecx,%edx
  80376d:	89 f8                	mov    %edi,%eax
  80376f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803773:	85 f6                	test   %esi,%esi
  803775:	75 2d                	jne    8037a4 <__udivdi3+0x50>
  803777:	39 cf                	cmp    %ecx,%edi
  803779:	77 65                	ja     8037e0 <__udivdi3+0x8c>
  80377b:	89 fd                	mov    %edi,%ebp
  80377d:	85 ff                	test   %edi,%edi
  80377f:	75 0b                	jne    80378c <__udivdi3+0x38>
  803781:	b8 01 00 00 00       	mov    $0x1,%eax
  803786:	31 d2                	xor    %edx,%edx
  803788:	f7 f7                	div    %edi
  80378a:	89 c5                	mov    %eax,%ebp
  80378c:	31 d2                	xor    %edx,%edx
  80378e:	89 c8                	mov    %ecx,%eax
  803790:	f7 f5                	div    %ebp
  803792:	89 c1                	mov    %eax,%ecx
  803794:	89 d8                	mov    %ebx,%eax
  803796:	f7 f5                	div    %ebp
  803798:	89 cf                	mov    %ecx,%edi
  80379a:	89 fa                	mov    %edi,%edx
  80379c:	83 c4 1c             	add    $0x1c,%esp
  80379f:	5b                   	pop    %ebx
  8037a0:	5e                   	pop    %esi
  8037a1:	5f                   	pop    %edi
  8037a2:	5d                   	pop    %ebp
  8037a3:	c3                   	ret    
  8037a4:	39 ce                	cmp    %ecx,%esi
  8037a6:	77 28                	ja     8037d0 <__udivdi3+0x7c>
  8037a8:	0f bd fe             	bsr    %esi,%edi
  8037ab:	83 f7 1f             	xor    $0x1f,%edi
  8037ae:	75 40                	jne    8037f0 <__udivdi3+0x9c>
  8037b0:	39 ce                	cmp    %ecx,%esi
  8037b2:	72 0a                	jb     8037be <__udivdi3+0x6a>
  8037b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037b8:	0f 87 9e 00 00 00    	ja     80385c <__udivdi3+0x108>
  8037be:	b8 01 00 00 00       	mov    $0x1,%eax
  8037c3:	89 fa                	mov    %edi,%edx
  8037c5:	83 c4 1c             	add    $0x1c,%esp
  8037c8:	5b                   	pop    %ebx
  8037c9:	5e                   	pop    %esi
  8037ca:	5f                   	pop    %edi
  8037cb:	5d                   	pop    %ebp
  8037cc:	c3                   	ret    
  8037cd:	8d 76 00             	lea    0x0(%esi),%esi
  8037d0:	31 ff                	xor    %edi,%edi
  8037d2:	31 c0                	xor    %eax,%eax
  8037d4:	89 fa                	mov    %edi,%edx
  8037d6:	83 c4 1c             	add    $0x1c,%esp
  8037d9:	5b                   	pop    %ebx
  8037da:	5e                   	pop    %esi
  8037db:	5f                   	pop    %edi
  8037dc:	5d                   	pop    %ebp
  8037dd:	c3                   	ret    
  8037de:	66 90                	xchg   %ax,%ax
  8037e0:	89 d8                	mov    %ebx,%eax
  8037e2:	f7 f7                	div    %edi
  8037e4:	31 ff                	xor    %edi,%edi
  8037e6:	89 fa                	mov    %edi,%edx
  8037e8:	83 c4 1c             	add    $0x1c,%esp
  8037eb:	5b                   	pop    %ebx
  8037ec:	5e                   	pop    %esi
  8037ed:	5f                   	pop    %edi
  8037ee:	5d                   	pop    %ebp
  8037ef:	c3                   	ret    
  8037f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037f5:	89 eb                	mov    %ebp,%ebx
  8037f7:	29 fb                	sub    %edi,%ebx
  8037f9:	89 f9                	mov    %edi,%ecx
  8037fb:	d3 e6                	shl    %cl,%esi
  8037fd:	89 c5                	mov    %eax,%ebp
  8037ff:	88 d9                	mov    %bl,%cl
  803801:	d3 ed                	shr    %cl,%ebp
  803803:	89 e9                	mov    %ebp,%ecx
  803805:	09 f1                	or     %esi,%ecx
  803807:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80380b:	89 f9                	mov    %edi,%ecx
  80380d:	d3 e0                	shl    %cl,%eax
  80380f:	89 c5                	mov    %eax,%ebp
  803811:	89 d6                	mov    %edx,%esi
  803813:	88 d9                	mov    %bl,%cl
  803815:	d3 ee                	shr    %cl,%esi
  803817:	89 f9                	mov    %edi,%ecx
  803819:	d3 e2                	shl    %cl,%edx
  80381b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80381f:	88 d9                	mov    %bl,%cl
  803821:	d3 e8                	shr    %cl,%eax
  803823:	09 c2                	or     %eax,%edx
  803825:	89 d0                	mov    %edx,%eax
  803827:	89 f2                	mov    %esi,%edx
  803829:	f7 74 24 0c          	divl   0xc(%esp)
  80382d:	89 d6                	mov    %edx,%esi
  80382f:	89 c3                	mov    %eax,%ebx
  803831:	f7 e5                	mul    %ebp
  803833:	39 d6                	cmp    %edx,%esi
  803835:	72 19                	jb     803850 <__udivdi3+0xfc>
  803837:	74 0b                	je     803844 <__udivdi3+0xf0>
  803839:	89 d8                	mov    %ebx,%eax
  80383b:	31 ff                	xor    %edi,%edi
  80383d:	e9 58 ff ff ff       	jmp    80379a <__udivdi3+0x46>
  803842:	66 90                	xchg   %ax,%ax
  803844:	8b 54 24 08          	mov    0x8(%esp),%edx
  803848:	89 f9                	mov    %edi,%ecx
  80384a:	d3 e2                	shl    %cl,%edx
  80384c:	39 c2                	cmp    %eax,%edx
  80384e:	73 e9                	jae    803839 <__udivdi3+0xe5>
  803850:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803853:	31 ff                	xor    %edi,%edi
  803855:	e9 40 ff ff ff       	jmp    80379a <__udivdi3+0x46>
  80385a:	66 90                	xchg   %ax,%ax
  80385c:	31 c0                	xor    %eax,%eax
  80385e:	e9 37 ff ff ff       	jmp    80379a <__udivdi3+0x46>
  803863:	90                   	nop

00803864 <__umoddi3>:
  803864:	55                   	push   %ebp
  803865:	57                   	push   %edi
  803866:	56                   	push   %esi
  803867:	53                   	push   %ebx
  803868:	83 ec 1c             	sub    $0x1c,%esp
  80386b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80386f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803873:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803877:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80387b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80387f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803883:	89 f3                	mov    %esi,%ebx
  803885:	89 fa                	mov    %edi,%edx
  803887:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80388b:	89 34 24             	mov    %esi,(%esp)
  80388e:	85 c0                	test   %eax,%eax
  803890:	75 1a                	jne    8038ac <__umoddi3+0x48>
  803892:	39 f7                	cmp    %esi,%edi
  803894:	0f 86 a2 00 00 00    	jbe    80393c <__umoddi3+0xd8>
  80389a:	89 c8                	mov    %ecx,%eax
  80389c:	89 f2                	mov    %esi,%edx
  80389e:	f7 f7                	div    %edi
  8038a0:	89 d0                	mov    %edx,%eax
  8038a2:	31 d2                	xor    %edx,%edx
  8038a4:	83 c4 1c             	add    $0x1c,%esp
  8038a7:	5b                   	pop    %ebx
  8038a8:	5e                   	pop    %esi
  8038a9:	5f                   	pop    %edi
  8038aa:	5d                   	pop    %ebp
  8038ab:	c3                   	ret    
  8038ac:	39 f0                	cmp    %esi,%eax
  8038ae:	0f 87 ac 00 00 00    	ja     803960 <__umoddi3+0xfc>
  8038b4:	0f bd e8             	bsr    %eax,%ebp
  8038b7:	83 f5 1f             	xor    $0x1f,%ebp
  8038ba:	0f 84 ac 00 00 00    	je     80396c <__umoddi3+0x108>
  8038c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8038c5:	29 ef                	sub    %ebp,%edi
  8038c7:	89 fe                	mov    %edi,%esi
  8038c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038cd:	89 e9                	mov    %ebp,%ecx
  8038cf:	d3 e0                	shl    %cl,%eax
  8038d1:	89 d7                	mov    %edx,%edi
  8038d3:	89 f1                	mov    %esi,%ecx
  8038d5:	d3 ef                	shr    %cl,%edi
  8038d7:	09 c7                	or     %eax,%edi
  8038d9:	89 e9                	mov    %ebp,%ecx
  8038db:	d3 e2                	shl    %cl,%edx
  8038dd:	89 14 24             	mov    %edx,(%esp)
  8038e0:	89 d8                	mov    %ebx,%eax
  8038e2:	d3 e0                	shl    %cl,%eax
  8038e4:	89 c2                	mov    %eax,%edx
  8038e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ea:	d3 e0                	shl    %cl,%eax
  8038ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f4:	89 f1                	mov    %esi,%ecx
  8038f6:	d3 e8                	shr    %cl,%eax
  8038f8:	09 d0                	or     %edx,%eax
  8038fa:	d3 eb                	shr    %cl,%ebx
  8038fc:	89 da                	mov    %ebx,%edx
  8038fe:	f7 f7                	div    %edi
  803900:	89 d3                	mov    %edx,%ebx
  803902:	f7 24 24             	mull   (%esp)
  803905:	89 c6                	mov    %eax,%esi
  803907:	89 d1                	mov    %edx,%ecx
  803909:	39 d3                	cmp    %edx,%ebx
  80390b:	0f 82 87 00 00 00    	jb     803998 <__umoddi3+0x134>
  803911:	0f 84 91 00 00 00    	je     8039a8 <__umoddi3+0x144>
  803917:	8b 54 24 04          	mov    0x4(%esp),%edx
  80391b:	29 f2                	sub    %esi,%edx
  80391d:	19 cb                	sbb    %ecx,%ebx
  80391f:	89 d8                	mov    %ebx,%eax
  803921:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803925:	d3 e0                	shl    %cl,%eax
  803927:	89 e9                	mov    %ebp,%ecx
  803929:	d3 ea                	shr    %cl,%edx
  80392b:	09 d0                	or     %edx,%eax
  80392d:	89 e9                	mov    %ebp,%ecx
  80392f:	d3 eb                	shr    %cl,%ebx
  803931:	89 da                	mov    %ebx,%edx
  803933:	83 c4 1c             	add    $0x1c,%esp
  803936:	5b                   	pop    %ebx
  803937:	5e                   	pop    %esi
  803938:	5f                   	pop    %edi
  803939:	5d                   	pop    %ebp
  80393a:	c3                   	ret    
  80393b:	90                   	nop
  80393c:	89 fd                	mov    %edi,%ebp
  80393e:	85 ff                	test   %edi,%edi
  803940:	75 0b                	jne    80394d <__umoddi3+0xe9>
  803942:	b8 01 00 00 00       	mov    $0x1,%eax
  803947:	31 d2                	xor    %edx,%edx
  803949:	f7 f7                	div    %edi
  80394b:	89 c5                	mov    %eax,%ebp
  80394d:	89 f0                	mov    %esi,%eax
  80394f:	31 d2                	xor    %edx,%edx
  803951:	f7 f5                	div    %ebp
  803953:	89 c8                	mov    %ecx,%eax
  803955:	f7 f5                	div    %ebp
  803957:	89 d0                	mov    %edx,%eax
  803959:	e9 44 ff ff ff       	jmp    8038a2 <__umoddi3+0x3e>
  80395e:	66 90                	xchg   %ax,%ax
  803960:	89 c8                	mov    %ecx,%eax
  803962:	89 f2                	mov    %esi,%edx
  803964:	83 c4 1c             	add    $0x1c,%esp
  803967:	5b                   	pop    %ebx
  803968:	5e                   	pop    %esi
  803969:	5f                   	pop    %edi
  80396a:	5d                   	pop    %ebp
  80396b:	c3                   	ret    
  80396c:	3b 04 24             	cmp    (%esp),%eax
  80396f:	72 06                	jb     803977 <__umoddi3+0x113>
  803971:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803975:	77 0f                	ja     803986 <__umoddi3+0x122>
  803977:	89 f2                	mov    %esi,%edx
  803979:	29 f9                	sub    %edi,%ecx
  80397b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80397f:	89 14 24             	mov    %edx,(%esp)
  803982:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803986:	8b 44 24 04          	mov    0x4(%esp),%eax
  80398a:	8b 14 24             	mov    (%esp),%edx
  80398d:	83 c4 1c             	add    $0x1c,%esp
  803990:	5b                   	pop    %ebx
  803991:	5e                   	pop    %esi
  803992:	5f                   	pop    %edi
  803993:	5d                   	pop    %ebp
  803994:	c3                   	ret    
  803995:	8d 76 00             	lea    0x0(%esi),%esi
  803998:	2b 04 24             	sub    (%esp),%eax
  80399b:	19 fa                	sbb    %edi,%edx
  80399d:	89 d1                	mov    %edx,%ecx
  80399f:	89 c6                	mov    %eax,%esi
  8039a1:	e9 71 ff ff ff       	jmp    803917 <__umoddi3+0xb3>
  8039a6:	66 90                	xchg   %ax,%ax
  8039a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039ac:	72 ea                	jb     803998 <__umoddi3+0x134>
  8039ae:	89 d9                	mov    %ebx,%ecx
  8039b0:	e9 62 ff ff ff       	jmp    803917 <__umoddi3+0xb3>
