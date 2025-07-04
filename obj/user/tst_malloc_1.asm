
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 d1 10 00 00       	call   801107 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <inRange>:
	char a;
	short b;
	int c;
};
int inRange(int val, int min, int max)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
	return (val >= min && val <= max) ? 1 : 0;
  80003b:	8b 45 08             	mov    0x8(%ebp),%eax
  80003e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800041:	7c 0f                	jl     800052 <inRange+0x1a>
  800043:	8b 45 08             	mov    0x8(%ebp),%eax
  800046:	3b 45 10             	cmp    0x10(%ebp),%eax
  800049:	7f 07                	jg     800052 <inRange+0x1a>
  80004b:	b8 01 00 00 00       	mov    $0x1,%eax
  800050:	eb 05                	jmp    800057 <inRange+0x1f>
  800052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800057:	5d                   	pop    %ebp
  800058:	c3                   	ret    

00800059 <_main>:
void _main(void)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	53                   	push   %ebx
  80005e:	81 ec 30 01 00 00    	sub    $0x130,%esp

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800064:	a1 20 60 80 00       	mov    0x806020,%eax
  800069:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80006f:	a1 20 60 80 00       	mov    0x806020,%eax
  800074:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 00 45 80 00       	push   $0x804500
  800086:	6a 1f                	push   $0x1f
  800088:	68 1c 45 80 00       	push   $0x80451c
  80008d:	e8 ba 11 00 00       	call   80124c <_panic>
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	//cprintf("2\n");
	int eval = 0;
  800092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  800099:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  8000a0:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int Mega = 1024*1024;
  8000a7:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000ae:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	char minByte = 1<<7;
  8000b5:	c6 45 e3 80          	movb   $0x80,-0x1d(%ebp)
	char maxByte = 0x7F;
  8000b9:	c6 45 e2 7f          	movb   $0x7f,-0x1e(%ebp)
	short minShort = 1<<15 ;
  8000bd:	66 c7 45 e0 00 80    	movw   $0x8000,-0x20(%ebp)
	short maxShort = 0x7FFF;
  8000c3:	66 c7 45 de ff 7f    	movw   $0x7fff,-0x22(%ebp)
	int minInt = 1<<31 ;
  8000c9:	c7 45 d8 00 00 00 80 	movl   $0x80000000,-0x28(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d0:	c7 45 d4 ff ff ff 7f 	movl   $0x7fffffff,-0x2c(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 b2 29 00 00       	call   802a8e <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, found;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them [70%]\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 30 45 80 00       	push   $0x804530
  8000e7:	e8 1d 14 00 00       	call   801509 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 04 ff ff ff    	lea    -0xfc(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 86 29 00 00       	call   802a8e <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 c9 29 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 95 21 00 00       	call   8022b9 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 90 45 80 00       	push   $0x804590
  800147:	e8 bd 13 00 00       	call   801509 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 30 29 00 00       	call   802a8e <sys_calculate_free_frames>
  80015e:	29 c3                	sub    %eax,%ebx
  800160:	89 d8                	mov    %ebx,%eax
  800162:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800165:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800168:	83 c0 02             	add    $0x2,%eax
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	50                   	push   %eax
  80016f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800172:	ff 75 c0             	pushl  -0x40(%ebp)
  800175:	e8 be fe ff ff       	call   800038 <inRange>
  80017a:	83 c4 10             	add    $0x10,%esp
  80017d:	85 c0                	test   %eax,%eax
  80017f:	75 21                	jne    8001a2 <_main+0x149>
			{is_correct = 0; cprintf("1 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800181:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800188:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80018b:	83 c0 02             	add    $0x2,%eax
  80018e:	ff 75 c0             	pushl  -0x40(%ebp)
  800191:	50                   	push   %eax
  800192:	ff 75 c4             	pushl  -0x3c(%ebp)
  800195:	68 c4 45 80 00       	push   $0x8045c4
  80019a:	e8 6a 13 00 00       	call   801509 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 32 29 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 34 46 80 00       	push   $0x804634
  8001bb:	e8 49 13 00 00       	call   801509 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 c6 28 00 00       	call   802a8e <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8001dd:	89 45 b8             	mov    %eax,-0x48(%ebp)
			byteArr[0] = minByte ;
  8001e0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001e3:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8001e6:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  8001e8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8001eb:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001ee:	01 c2                	add    %eax,%edx
  8001f0:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8001f3:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  8001f5:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8001fc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8001ff:	e8 8a 28 00 00       	call   802a8e <sys_calculate_free_frames>
  800204:	29 c3                	sub    %eax,%ebx
  800206:	89 d8                	mov    %ebx,%eax
  800208:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80020b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80020e:	83 c0 02             	add    $0x2,%eax
  800211:	83 ec 04             	sub    $0x4,%esp
  800214:	50                   	push   %eax
  800215:	ff 75 c4             	pushl  -0x3c(%ebp)
  800218:	ff 75 c0             	pushl  -0x40(%ebp)
  80021b:	e8 18 fe ff ff       	call   800038 <inRange>
  800220:	83 c4 10             	add    $0x10,%esp
  800223:	85 c0                	test   %eax,%eax
  800225:	75 1d                	jne    800244 <_main+0x1eb>
			{ is_correct = 0; cprintf("1 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800227:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	ff 75 c0             	pushl  -0x40(%ebp)
  800234:	ff 75 c4             	pushl  -0x3c(%ebp)
  800237:	68 68 46 80 00       	push   $0x804668
  80023c:	e8 c8 12 00 00       	call   801509 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 fc fe ff ff    	lea    -0x104(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 66 2c 00 00       	call   802ee9 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 e8 46 80 00       	push   $0x8046e8
  80029e:	e8 66 12 00 00       	call   801509 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("4\n");
		if (is_correct)
  8002a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8002aa:	74 04                	je     8002b0 <_main+0x257>
		{
			eval += 10;
  8002ac:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8002b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002b7:	e8 d2 27 00 00       	call   802a8e <sys_calculate_free_frames>
  8002bc:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002bf:	e8 15 28 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  8002c4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ca:	01 c0                	add    %eax,%eax
  8002cc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002cf:	83 ec 0c             	sub    $0xc,%esp
  8002d2:	50                   	push   %eax
  8002d3:	e8 e1 1f 00 00       	call   8022b9 <malloc>
  8002d8:	83 c4 10             	add    $0x10,%esp
  8002db:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002e1:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  8002e7:	89 c2                	mov    %eax,%edx
  8002e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	89 c1                	mov    %eax,%ecx
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	01 c8                	add    %ecx,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 17                	je     800310 <_main+0x2b7>
  8002f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800300:	83 ec 0c             	sub    $0xc,%esp
  800303:	68 0c 47 80 00       	push   $0x80470c
  800308:	e8 fc 11 00 00       	call   801509 <cprintf>
  80030d:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  800310:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800317:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80031a:	e8 6f 27 00 00       	call   802a8e <sys_calculate_free_frames>
  80031f:	29 c3                	sub    %eax,%ebx
  800321:	89 d8                	mov    %ebx,%eax
  800323:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800326:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800329:	83 c0 02             	add    $0x2,%eax
  80032c:	83 ec 04             	sub    $0x4,%esp
  80032f:	50                   	push   %eax
  800330:	ff 75 c4             	pushl  -0x3c(%ebp)
  800333:	ff 75 c0             	pushl  -0x40(%ebp)
  800336:	e8 fd fc ff ff       	call   800038 <inRange>
  80033b:	83 c4 10             	add    $0x10,%esp
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 21                	jne    800363 <_main+0x30a>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800342:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800349:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80034c:	83 c0 02             	add    $0x2,%eax
  80034f:	ff 75 c0             	pushl  -0x40(%ebp)
  800352:	50                   	push   %eax
  800353:	ff 75 c4             	pushl  -0x3c(%ebp)
  800356:	68 40 47 80 00       	push   $0x804740
  80035b:	e8 a9 11 00 00       	call   801509 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800363:	e8 71 27 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800368:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80036b:	74 17                	je     800384 <_main+0x32b>
  80036d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800374:	83 ec 0c             	sub    $0xc,%esp
  800377:	68 b0 47 80 00       	push   $0x8047b0
  80037c:	e8 88 11 00 00       	call   801509 <cprintf>
  800381:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800384:	e8 05 27 00 00       	call   802a8e <sys_calculate_free_frames>
  800389:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80038c:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  800392:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800395:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80039d:	d1 e8                	shr    %eax
  80039f:	48                   	dec    %eax
  8003a0:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  8003a3:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8003a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003a9:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  8003ac:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	89 c2                	mov    %eax,%edx
  8003b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003b6:	01 c2                	add    %eax,%edx
  8003b8:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003bc:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003bf:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003c6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003c9:	e8 c0 26 00 00       	call   802a8e <sys_calculate_free_frames>
  8003ce:	29 c3                	sub    %eax,%ebx
  8003d0:	89 d8                	mov    %ebx,%eax
  8003d2:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003d8:	83 c0 02             	add    $0x2,%eax
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	50                   	push   %eax
  8003df:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003e2:	ff 75 c0             	pushl  -0x40(%ebp)
  8003e5:	e8 4e fc ff ff       	call   800038 <inRange>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	85 c0                	test   %eax,%eax
  8003ef:	75 1d                	jne    80040e <_main+0x3b5>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003f8:	83 ec 04             	sub    $0x4,%esp
  8003fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8003fe:	ff 75 c4             	pushl  -0x3c(%ebp)
  800401:	68 e4 47 80 00       	push   $0x8047e4
  800406:	e8 fe 10 00 00       	call   801509 <cprintf>
  80040b:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  80040e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800411:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800414:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800417:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041c:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
  800422:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800425:	01 c0                	add    %eax,%eax
  800427:	89 c2                	mov    %eax,%edx
  800429:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800431:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800439:	89 85 f8 fe ff ff    	mov    %eax,-0x108(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80043f:	6a 02                	push   $0x2
  800441:	6a 00                	push   $0x0
  800443:	6a 02                	push   $0x2
  800445:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80044b:	50                   	push   %eax
  80044c:	e8 98 2a 00 00       	call   802ee9 <sys_check_WS_list>
  800451:	83 c4 10             	add    $0x10,%esp
  800454:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800457:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80045b:	74 17                	je     800474 <_main+0x41b>
  80045d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800464:	83 ec 0c             	sub    $0xc,%esp
  800467:	68 64 48 80 00       	push   $0x804864
  80046c:	e8 98 10 00 00       	call   801509 <cprintf>
  800471:	83 c4 10             	add    $0x10,%esp
		}
		//cprintf("5\n");
		if (is_correct)
  800474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800478:	74 04                	je     80047e <_main+0x425>
		{
			eval += 10;
  80047a:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80047e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800485:	e8 4f 26 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  80048a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80048d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800490:	89 c2                	mov    %eax,%edx
  800492:	01 d2                	add    %edx,%edx
  800494:	01 d0                	add    %edx,%eax
  800496:	83 ec 0c             	sub    $0xc,%esp
  800499:	50                   	push   %eax
  80049a:	e8 1a 1e 00 00       	call   8022b9 <malloc>
  80049f:	83 c4 10             	add    $0x10,%esp
  8004a2:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  8004a8:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8004ae:	89 c2                	mov    %eax,%edx
  8004b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b3:	c1 e0 02             	shl    $0x2,%eax
  8004b6:	89 c1                	mov    %eax,%ecx
  8004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004bb:	01 c8                	add    %ecx,%eax
  8004bd:	39 c2                	cmp    %eax,%edx
  8004bf:	74 17                	je     8004d8 <_main+0x47f>
  8004c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004c8:	83 ec 0c             	sub    $0xc,%esp
  8004cb:	68 88 48 80 00       	push   $0x804888
  8004d0:	e8 34 10 00 00       	call   801509 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004d8:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004df:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e2:	e8 a7 25 00 00       	call   802a8e <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f1:	83 c0 02             	add    $0x2,%eax
  8004f4:	83 ec 04             	sub    $0x4,%esp
  8004f7:	50                   	push   %eax
  8004f8:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fb:	ff 75 c0             	pushl  -0x40(%ebp)
  8004fe:	e8 35 fb ff ff       	call   800038 <inRange>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	85 c0                	test   %eax,%eax
  800508:	75 21                	jne    80052b <_main+0x4d2>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80050a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800511:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800514:	83 c0 02             	add    $0x2,%eax
  800517:	ff 75 c0             	pushl  -0x40(%ebp)
  80051a:	50                   	push   %eax
  80051b:	ff 75 c4             	pushl  -0x3c(%ebp)
  80051e:	68 bc 48 80 00       	push   $0x8048bc
  800523:	e8 e1 0f 00 00       	call   801509 <cprintf>
  800528:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  80052b:	e8 a9 25 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800530:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800533:	74 17                	je     80054c <_main+0x4f3>
  800535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80053c:	83 ec 0c             	sub    $0xc,%esp
  80053f:	68 2c 49 80 00       	push   $0x80492c
  800544:	e8 c0 0f 00 00       	call   801509 <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80054c:	e8 3d 25 00 00       	call   802a8e <sys_calculate_free_frames>
  800551:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800554:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  80055a:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80055d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800560:	01 c0                	add    %eax,%eax
  800562:	c1 e8 02             	shr    $0x2,%eax
  800565:	48                   	dec    %eax
  800566:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800569:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056f:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  800571:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800574:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057b:	8b 45 98             	mov    -0x68(%ebp),%eax
  80057e:	01 c2                	add    %eax,%edx
  800580:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800583:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800585:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80058c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80058f:	e8 fa 24 00 00       	call   802a8e <sys_calculate_free_frames>
  800594:	29 c3                	sub    %eax,%ebx
  800596:	89 d8                	mov    %ebx,%eax
  800598:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80059b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80059e:	83 c0 02             	add    $0x2,%eax
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	50                   	push   %eax
  8005a5:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a8:	ff 75 c0             	pushl  -0x40(%ebp)
  8005ab:	e8 88 fa ff ff       	call   800038 <inRange>
  8005b0:	83 c4 10             	add    $0x10,%esp
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	75 1d                	jne    8005d4 <_main+0x57b>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8005b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005be:	83 ec 04             	sub    $0x4,%esp
  8005c1:	ff 75 c0             	pushl  -0x40(%ebp)
  8005c4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005c7:	68 60 49 80 00       	push   $0x804960
  8005cc:	e8 38 0f 00 00       	call   801509 <cprintf>
  8005d1:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005d4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d7:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005da:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e2:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  8005e8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005f2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005fa:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800602:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800608:	6a 02                	push   $0x2
  80060a:	6a 00                	push   $0x0
  80060c:	6a 02                	push   $0x2
  80060e:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
  800614:	50                   	push   %eax
  800615:	e8 cf 28 00 00       	call   802ee9 <sys_check_WS_list>
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  800620:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800624:	74 17                	je     80063d <_main+0x5e4>
  800626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80062d:	83 ec 0c             	sub    $0xc,%esp
  800630:	68 e0 49 80 00       	push   $0x8049e0
  800635:	e8 cf 0e 00 00       	call   801509 <cprintf>
  80063a:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80063d:	e8 97 24 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800642:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800645:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800648:	89 c2                	mov    %eax,%edx
  80064a:	01 d2                	add    %edx,%edx
  80064c:	01 d0                	add    %edx,%eax
  80064e:	83 ec 0c             	sub    $0xc,%esp
  800651:	50                   	push   %eax
  800652:	e8 62 1c 00 00       	call   8022b9 <malloc>
  800657:	83 c4 10             	add    $0x10,%esp
  80065a:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  800660:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80066b:	c1 e0 02             	shl    $0x2,%eax
  80066e:	89 c1                	mov    %eax,%ecx
  800670:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800673:	c1 e0 02             	shl    $0x2,%eax
  800676:	01 c1                	add    %eax,%ecx
  800678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80067b:	01 c8                	add    %ecx,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x63f>
  800681:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800688:	83 ec 0c             	sub    $0xc,%esp
  80068b:	68 04 4a 80 00       	push   $0x804a04
  800690:	e8 74 0e 00 00       	call   801509 <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800698:	e8 3c 24 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  80069d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8006a0:	74 17                	je     8006b9 <_main+0x660>
  8006a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006a9:	83 ec 0c             	sub    $0xc,%esp
  8006ac:	68 38 4a 80 00       	push   $0x804a38
  8006b1:	e8 53 0e 00 00       	call   801509 <cprintf>
  8006b6:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8006b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8006bd:	74 04                	je     8006c3 <_main+0x66a>
		{
			eval += 10;
  8006bf:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8006c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8006ca:	e8 bf 23 00 00       	call   802a8e <sys_calculate_free_frames>
  8006cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006d2:	e8 02 24 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  8006d7:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006dd:	89 d0                	mov    %edx,%eax
  8006df:	01 c0                	add    %eax,%eax
  8006e1:	01 d0                	add    %edx,%eax
  8006e3:	01 c0                	add    %eax,%eax
  8006e5:	01 d0                	add    %edx,%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 c9 1b 00 00       	call   8022b9 <malloc>
  8006f0:	83 c4 10             	add    $0x10,%esp
  8006f3:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006f9:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8006ff:	89 c2                	mov    %eax,%edx
  800701:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800704:	c1 e0 02             	shl    $0x2,%eax
  800707:	89 c1                	mov    %eax,%ecx
  800709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80070c:	c1 e0 03             	shl    $0x3,%eax
  80070f:	01 c1                	add    %eax,%ecx
  800711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800714:	01 c8                	add    %ecx,%eax
  800716:	39 c2                	cmp    %eax,%edx
  800718:	74 17                	je     800731 <_main+0x6d8>
  80071a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800721:	83 ec 0c             	sub    $0xc,%esp
  800724:	68 6c 4a 80 00       	push   $0x804a6c
  800729:	e8 db 0d 00 00       	call   801509 <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800731:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800738:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80073b:	e8 4e 23 00 00       	call   802a8e <sys_calculate_free_frames>
  800740:	29 c3                	sub    %eax,%ebx
  800742:	89 d8                	mov    %ebx,%eax
  800744:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800747:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80074a:	83 c0 02             	add    $0x2,%eax
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	50                   	push   %eax
  800751:	ff 75 c4             	pushl  -0x3c(%ebp)
  800754:	ff 75 c0             	pushl  -0x40(%ebp)
  800757:	e8 dc f8 ff ff       	call   800038 <inRange>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 21                	jne    800784 <_main+0x72b>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80076a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80076d:	83 c0 02             	add    $0x2,%eax
  800770:	ff 75 c0             	pushl  -0x40(%ebp)
  800773:	50                   	push   %eax
  800774:	ff 75 c4             	pushl  -0x3c(%ebp)
  800777:	68 a0 4a 80 00       	push   $0x804aa0
  80077c:	e8 88 0d 00 00       	call   801509 <cprintf>
  800781:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800784:	e8 50 23 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800789:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80078c:	74 17                	je     8007a5 <_main+0x74c>
  80078e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	68 10 4b 80 00       	push   $0x804b10
  80079d:	e8 67 0d 00 00       	call   801509 <cprintf>
  8007a2:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8007a5:	e8 e4 22 00 00       	call   802a8e <sys_calculate_free_frames>
  8007aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  8007ad:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8007b3:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8007b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007b9:	89 d0                	mov    %edx,%eax
  8007bb:	01 c0                	add    %eax,%eax
  8007bd:	01 d0                	add    %edx,%eax
  8007bf:	01 c0                	add    %eax,%eax
  8007c1:	01 d0                	add    %edx,%eax
  8007c3:	c1 e8 03             	shr    $0x3,%eax
  8007c6:	48                   	dec    %eax
  8007c7:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8007ca:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007cd:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  8007d0:	88 10                	mov    %dl,(%eax)
  8007d2:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007d8:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007df:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007e2:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007e5:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007ef:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007f2:	01 c2                	add    %eax,%edx
  8007f4:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007f7:	88 02                	mov    %al,(%edx)
  8007f9:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800803:	8b 45 88             	mov    -0x78(%ebp),%eax
  800806:	01 c2                	add    %eax,%edx
  800808:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  80080c:	66 89 42 02          	mov    %ax,0x2(%edx)
  800810:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800813:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80081a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80081d:	01 c2                	add    %eax,%edx
  80081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800822:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  800825:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80082c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80082f:	e8 5a 22 00 00       	call   802a8e <sys_calculate_free_frames>
  800834:	29 c3                	sub    %eax,%ebx
  800836:	89 d8                	mov    %ebx,%eax
  800838:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80083b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80083e:	83 c0 02             	add    $0x2,%eax
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	50                   	push   %eax
  800845:	ff 75 c4             	pushl  -0x3c(%ebp)
  800848:	ff 75 c0             	pushl  -0x40(%ebp)
  80084b:	e8 e8 f7 ff ff       	call   800038 <inRange>
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	85 c0                	test   %eax,%eax
  800855:	75 1d                	jne    800874 <_main+0x81b>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800857:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80085e:	83 ec 04             	sub    $0x4,%esp
  800861:	ff 75 c0             	pushl  -0x40(%ebp)
  800864:	ff 75 c4             	pushl  -0x3c(%ebp)
  800867:	68 44 4b 80 00       	push   $0x804b44
  80086c:	e8 98 0c 00 00       	call   801509 <cprintf>
  800871:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800874:	8b 45 88             	mov    -0x78(%ebp),%eax
  800877:	89 45 80             	mov    %eax,-0x80(%ebp)
  80087a:	8b 45 80             	mov    -0x80(%ebp),%eax
  80087d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800882:	89 85 e4 fe ff ff    	mov    %eax,-0x11c(%ebp)
  800888:	8b 45 84             	mov    -0x7c(%ebp),%eax
  80088b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800892:	8b 45 88             	mov    -0x78(%ebp),%eax
  800895:	01 d0                	add    %edx,%eax
  800897:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80089d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8008a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a8:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8008ae:	6a 02                	push   $0x2
  8008b0:	6a 00                	push   $0x0
  8008b2:	6a 02                	push   $0x2
  8008b4:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
  8008ba:	50                   	push   %eax
  8008bb:	e8 29 26 00 00       	call   802ee9 <sys_check_WS_list>
  8008c0:	83 c4 10             	add    $0x10,%esp
  8008c3:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  8008c6:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  8008ca:	74 17                	je     8008e3 <_main+0x88a>
  8008cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008d3:	83 ec 0c             	sub    $0xc,%esp
  8008d6:	68 c4 4b 80 00       	push   $0x804bc4
  8008db:	e8 29 0c 00 00       	call   801509 <cprintf>
  8008e0:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8008e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8008e7:	74 04                	je     8008ed <_main+0x894>
		{
			eval += 10;
  8008e9:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8008ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008f4:	e8 95 21 00 00       	call   802a8e <sys_calculate_free_frames>
  8008f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008fc:	e8 d8 21 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800901:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  800904:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800907:	89 c2                	mov    %eax,%edx
  800909:	01 d2                	add    %edx,%edx
  80090b:	01 d0                	add    %edx,%eax
  80090d:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800910:	83 ec 0c             	sub    $0xc,%esp
  800913:	50                   	push   %eax
  800914:	e8 a0 19 00 00       	call   8022b9 <malloc>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  800922:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  800928:	89 c2                	mov    %eax,%edx
  80092a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80092d:	c1 e0 02             	shl    $0x2,%eax
  800930:	89 c1                	mov    %eax,%ecx
  800932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800935:	c1 e0 04             	shl    $0x4,%eax
  800938:	01 c1                	add    %eax,%ecx
  80093a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093d:	01 c8                	add    %ecx,%eax
  80093f:	39 c2                	cmp    %eax,%edx
  800941:	74 17                	je     80095a <_main+0x901>
  800943:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094a:	83 ec 0c             	sub    $0xc,%esp
  80094d:	68 e8 4b 80 00       	push   $0x804be8
  800952:	e8 b2 0b 00 00       	call   801509 <cprintf>
  800957:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  80095a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800961:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800964:	e8 25 21 00 00       	call   802a8e <sys_calculate_free_frames>
  800969:	29 c3                	sub    %eax,%ebx
  80096b:	89 d8                	mov    %ebx,%eax
  80096d:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800970:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800973:	83 c0 02             	add    $0x2,%eax
  800976:	83 ec 04             	sub    $0x4,%esp
  800979:	50                   	push   %eax
  80097a:	ff 75 c4             	pushl  -0x3c(%ebp)
  80097d:	ff 75 c0             	pushl  -0x40(%ebp)
  800980:	e8 b3 f6 ff ff       	call   800038 <inRange>
  800985:	83 c4 10             	add    $0x10,%esp
  800988:	85 c0                	test   %eax,%eax
  80098a:	75 21                	jne    8009ad <_main+0x954>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  80098c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800993:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800996:	83 c0 02             	add    $0x2,%eax
  800999:	ff 75 c0             	pushl  -0x40(%ebp)
  80099c:	50                   	push   %eax
  80099d:	ff 75 c4             	pushl  -0x3c(%ebp)
  8009a0:	68 1c 4c 80 00       	push   $0x804c1c
  8009a5:	e8 5f 0b 00 00       	call   801509 <cprintf>
  8009aa:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  8009ad:	e8 27 21 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  8009b2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8009b5:	74 17                	je     8009ce <_main+0x975>
  8009b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009be:	83 ec 0c             	sub    $0xc,%esp
  8009c1:	68 8c 4c 80 00       	push   $0x804c8c
  8009c6:	e8 3e 0b 00 00       	call   801509 <cprintf>
  8009cb:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8009ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8009d2:	74 04                	je     8009d8 <_main+0x97f>
		{
			eval += 10;
  8009d4:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8009d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8009df:	e8 aa 20 00 00       	call   802a8e <sys_calculate_free_frames>
  8009e4:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8009e7:	e8 ed 20 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  8009ec:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  8009ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f2:	89 d0                	mov    %edx,%eax
  8009f4:	01 c0                	add    %eax,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009fd:	83 ec 0c             	sub    $0xc,%esp
  800a00:	50                   	push   %eax
  800a01:	e8 b3 18 00 00       	call   8022b9 <malloc>
  800a06:	83 c4 10             	add    $0x10,%esp
  800a09:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  800a0f:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800a15:	89 c1                	mov    %eax,%ecx
  800a17:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a1a:	89 d0                	mov    %edx,%eax
  800a1c:	01 c0                	add    %eax,%eax
  800a1e:	01 d0                	add    %edx,%eax
  800a20:	01 c0                	add    %eax,%eax
  800a22:	01 d0                	add    %edx,%eax
  800a24:	89 c2                	mov    %eax,%edx
  800a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a29:	c1 e0 04             	shl    $0x4,%eax
  800a2c:	01 c2                	add    %eax,%edx
  800a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	39 c1                	cmp    %eax,%ecx
  800a35:	74 17                	je     800a4e <_main+0x9f5>
  800a37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a3e:	83 ec 0c             	sub    $0xc,%esp
  800a41:	68 c0 4c 80 00       	push   $0x804cc0
  800a46:	e8 be 0a 00 00       	call   801509 <cprintf>
  800a4b:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  800a4e:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a55:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a58:	e8 31 20 00 00       	call   802a8e <sys_calculate_free_frames>
  800a5d:	29 c3                	sub    %eax,%ebx
  800a5f:	89 d8                	mov    %ebx,%eax
  800a61:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a64:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a67:	83 c0 02             	add    $0x2,%eax
  800a6a:	83 ec 04             	sub    $0x4,%esp
  800a6d:	50                   	push   %eax
  800a6e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a71:	ff 75 c0             	pushl  -0x40(%ebp)
  800a74:	e8 bf f5 ff ff       	call   800038 <inRange>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	75 21                	jne    800aa1 <_main+0xa48>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a87:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a8a:	83 c0 02             	add    $0x2,%eax
  800a8d:	ff 75 c0             	pushl  -0x40(%ebp)
  800a90:	50                   	push   %eax
  800a91:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a94:	68 f4 4c 80 00       	push   $0x804cf4
  800a99:	e8 6b 0a 00 00       	call   801509 <cprintf>
  800a9e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800aa1:	e8 33 20 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800aa6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800aa9:	74 17                	je     800ac2 <_main+0xa69>
  800aab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	68 64 4d 80 00       	push   $0x804d64
  800aba:	e8 4a 0a 00 00       	call   801509 <cprintf>
  800abf:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800ac2:	e8 c7 1f 00 00       	call   802a8e <sys_calculate_free_frames>
  800ac7:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800aca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800acd:	89 d0                	mov    %edx,%eax
  800acf:	01 c0                	add    %eax,%eax
  800ad1:	01 d0                	add    %edx,%eax
  800ad3:	01 c0                	add    %eax,%eax
  800ad5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800ad8:	48                   	dec    %eax
  800ad9:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800adf:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  800ae5:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800aeb:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800af1:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800af4:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800af6:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800afc:	89 c2                	mov    %eax,%edx
  800afe:	c1 ea 1f             	shr    $0x1f,%edx
  800b01:	01 d0                	add    %edx,%eax
  800b03:	d1 f8                	sar    %eax
  800b05:	89 c2                	mov    %eax,%edx
  800b07:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b0d:	01 c2                	add    %eax,%edx
  800b0f:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b12:	88 c1                	mov    %al,%cl
  800b14:	c0 e9 07             	shr    $0x7,%cl
  800b17:	01 c8                	add    %ecx,%eax
  800b19:	d0 f8                	sar    %al
  800b1b:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800b1d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b23:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b29:	01 c2                	add    %eax,%edx
  800b2b:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800b2e:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800b30:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800b37:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b3a:	e8 4f 1f 00 00       	call   802a8e <sys_calculate_free_frames>
  800b3f:	29 c3                	sub    %eax,%ebx
  800b41:	89 d8                	mov    %ebx,%eax
  800b43:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800b46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800b49:	83 c0 02             	add    $0x2,%eax
  800b4c:	83 ec 04             	sub    $0x4,%esp
  800b4f:	50                   	push   %eax
  800b50:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b53:	ff 75 c0             	pushl  -0x40(%ebp)
  800b56:	e8 dd f4 ff ff       	call   800038 <inRange>
  800b5b:	83 c4 10             	add    $0x10,%esp
  800b5e:	85 c0                	test   %eax,%eax
  800b60:	75 1d                	jne    800b7f <_main+0xb26>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	ff 75 c0             	pushl  -0x40(%ebp)
  800b6f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b72:	68 98 4d 80 00       	push   $0x804d98
  800b77:	e8 8d 09 00 00       	call   801509 <cprintf>
  800b7c:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b7f:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b85:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b8b:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
  800b9c:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800ba2:	89 c2                	mov    %eax,%edx
  800ba4:	c1 ea 1f             	shr    $0x1f,%edx
  800ba7:	01 d0                	add    %edx,%eax
  800ba9:	d1 f8                	sar    %eax
  800bab:	89 c2                	mov    %eax,%edx
  800bad:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bb3:	01 d0                	add    %edx,%eax
  800bb5:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800bbb:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800bc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bc6:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)
  800bcc:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800bd2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800bd8:	01 d0                	add    %edx,%eax
  800bda:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800be0:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800be6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800beb:	89 85 e0 fe ff ff    	mov    %eax,-0x120(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800bf1:	6a 02                	push   $0x2
  800bf3:	6a 00                	push   $0x0
  800bf5:	6a 03                	push   $0x3
  800bf7:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  800bfd:	50                   	push   %eax
  800bfe:	e8 e6 22 00 00       	call   802ee9 <sys_check_WS_list>
  800c03:	83 c4 10             	add    $0x10,%esp
  800c06:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800c09:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800c0d:	74 17                	je     800c26 <_main+0xbcd>
  800c0f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	68 18 4e 80 00       	push   $0x804e18
  800c1e:	e8 e6 08 00 00       	call   801509 <cprintf>
  800c23:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c2a:	74 04                	je     800c30 <_main+0xbd7>
		{
			eval += 10;
  800c2c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800c30:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800c37:	e8 52 1e 00 00       	call   802a8e <sys_calculate_free_frames>
  800c3c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c3f:	e8 95 1e 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800c44:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800c47:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c4a:	89 d0                	mov    %edx,%eax
  800c4c:	01 c0                	add    %eax,%eax
  800c4e:	01 d0                	add    %edx,%eax
  800c50:	01 c0                	add    %eax,%eax
  800c52:	01 d0                	add    %edx,%eax
  800c54:	01 c0                	add    %eax,%eax
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	e8 5a 16 00 00       	call   8022b9 <malloc>
  800c5f:	83 c4 10             	add    $0x10,%esp
  800c62:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c68:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800c6e:	89 c1                	mov    %eax,%ecx
  800c70:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c73:	89 d0                	mov    %edx,%eax
  800c75:	01 c0                	add    %eax,%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	c1 e0 02             	shl    $0x2,%eax
  800c7c:	01 d0                	add    %edx,%eax
  800c7e:	89 c2                	mov    %eax,%edx
  800c80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c83:	c1 e0 04             	shl    $0x4,%eax
  800c86:	01 c2                	add    %eax,%edx
  800c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c8b:	01 d0                	add    %edx,%eax
  800c8d:	39 c1                	cmp    %eax,%ecx
  800c8f:	74 17                	je     800ca8 <_main+0xc4f>
  800c91:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	68 3c 4e 80 00       	push   $0x804e3c
  800ca0:	e8 64 08 00 00       	call   801509 <cprintf>
  800ca5:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800ca8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800caf:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800cb2:	e8 d7 1d 00 00       	call   802a8e <sys_calculate_free_frames>
  800cb7:	29 c3                	sub    %eax,%ebx
  800cb9:	89 d8                	mov    %ebx,%eax
  800cbb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800cbe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800cc1:	83 c0 02             	add    $0x2,%eax
  800cc4:	83 ec 04             	sub    $0x4,%esp
  800cc7:	50                   	push   %eax
  800cc8:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ccb:	ff 75 c0             	pushl  -0x40(%ebp)
  800cce:	e8 65 f3 ff ff       	call   800038 <inRange>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	75 21                	jne    800cfb <_main+0xca2>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ce1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800ce4:	83 c0 02             	add    $0x2,%eax
  800ce7:	ff 75 c0             	pushl  -0x40(%ebp)
  800cea:	50                   	push   %eax
  800ceb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800cee:	68 70 4e 80 00       	push   $0x804e70
  800cf3:	e8 11 08 00 00       	call   801509 <cprintf>
  800cf8:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800cfb:	e8 d9 1d 00 00       	call   802ad9 <sys_pf_calculate_allocated_pages>
  800d00:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800d03:	74 17                	je     800d1c <_main+0xcc3>
  800d05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d0c:	83 ec 0c             	sub    $0xc,%esp
  800d0f:	68 e0 4e 80 00       	push   $0x804ee0
  800d14:	e8 f0 07 00 00       	call   801509 <cprintf>
  800d19:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800d1c:	e8 6d 1d 00 00       	call   802a8e <sys_calculate_free_frames>
  800d21:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800d24:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  800d2a:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d33:	89 d0                	mov    %edx,%eax
  800d35:	01 c0                	add    %eax,%eax
  800d37:	01 d0                	add    %edx,%eax
  800d39:	01 c0                	add    %eax,%eax
  800d3b:	01 d0                	add    %edx,%eax
  800d3d:	01 c0                	add    %eax,%eax
  800d3f:	d1 e8                	shr    %eax
  800d41:	48                   	dec    %eax
  800d42:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800d48:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d51:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800d54:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d5a:	89 c2                	mov    %eax,%edx
  800d5c:	c1 ea 1f             	shr    $0x1f,%edx
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	d1 f8                	sar    %eax
  800d63:	01 c0                	add    %eax,%eax
  800d65:	89 c2                	mov    %eax,%edx
  800d67:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d6d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d70:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d74:	89 c2                	mov    %eax,%edx
  800d76:	66 c1 ea 0f          	shr    $0xf,%dx
  800d7a:	01 d0                	add    %edx,%eax
  800d7c:	66 d1 f8             	sar    %ax
  800d7f:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d82:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d88:	01 c0                	add    %eax,%eax
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d92:	01 c2                	add    %eax,%edx
  800d94:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d98:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d9b:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800da2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800da5:	e8 e4 1c 00 00       	call   802a8e <sys_calculate_free_frames>
  800daa:	29 c3                	sub    %eax,%ebx
  800dac:	89 d8                	mov    %ebx,%eax
  800dae:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800db1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800db4:	83 c0 02             	add    $0x2,%eax
  800db7:	83 ec 04             	sub    $0x4,%esp
  800dba:	50                   	push   %eax
  800dbb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800dbe:	ff 75 c0             	pushl  -0x40(%ebp)
  800dc1:	e8 72 f2 ff ff       	call   800038 <inRange>
  800dc6:	83 c4 10             	add    $0x10,%esp
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	75 1d                	jne    800dea <_main+0xd91>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800dcd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dd4:	83 ec 04             	sub    $0x4,%esp
  800dd7:	ff 75 c0             	pushl  -0x40(%ebp)
  800dda:	ff 75 c4             	pushl  -0x3c(%ebp)
  800ddd:	68 14 4f 80 00       	push   $0x804f14
  800de2:	e8 22 07 00 00       	call   801509 <cprintf>
  800de7:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800dea:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800df0:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800df6:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e01:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
  800e07:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	c1 ea 1f             	shr    $0x1f,%edx
  800e12:	01 d0                	add    %edx,%eax
  800e14:	d1 f8                	sar    %eax
  800e16:	01 c0                	add    %eax,%eax
  800e18:	89 c2                	mov    %eax,%edx
  800e1a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e20:	01 d0                	add    %edx,%eax
  800e22:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800e28:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800e2e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e33:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
  800e39:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800e3f:	01 c0                	add    %eax,%eax
  800e41:	89 c2                	mov    %eax,%edx
  800e43:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800e49:	01 d0                	add    %edx,%eax
  800e4b:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800e51:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800e57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e5c:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800e62:	6a 02                	push   $0x2
  800e64:	6a 00                	push   $0x0
  800e66:	6a 03                	push   $0x3
  800e68:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800e6e:	50                   	push   %eax
  800e6f:	e8 75 20 00 00       	call   802ee9 <sys_check_WS_list>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e7a:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e7e:	74 17                	je     800e97 <_main+0xe3e>
  800e80:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	68 94 4f 80 00       	push   $0x804f94
  800e8f:	e8 75 06 00 00       	call   801509 <cprintf>
  800e94:	83 c4 10             	add    $0x10,%esp
		}
	}
	if (is_correct)
  800e97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e9b:	74 04                	je     800ea1 <_main+0xe48>
	{
		eval += 10;
  800e9d:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
	}
	is_correct = 1;
  800ea1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Check that the values are successfully stored
	cprintf("\n%~[2] Check that the values are successfully stored [30%]\n");
  800ea8:	83 ec 0c             	sub    $0xc,%esp
  800eab:	68 b8 4f 80 00       	push   $0x804fb8
  800eb0:	e8 54 06 00 00       	call   801509 <cprintf>
  800eb5:	83 c4 10             	add    $0x10,%esp
	{
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) { is_correct = 0; cprintf("9 Wrong allocation: stored values are wrongly changed!\n");}
  800eb8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800ec0:	75 0f                	jne    800ed1 <_main+0xe78>
  800ec2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ec5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ec8:	01 d0                	add    %edx,%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800ecf:	74 17                	je     800ee8 <_main+0xe8f>
  800ed1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	68 f4 4f 80 00       	push   $0x804ff4
  800ee0:	e8 24 06 00 00       	call   801509 <cprintf>
  800ee5:	83 c4 10             	add    $0x10,%esp
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) { is_correct = 0; cprintf("10 Wrong allocation: stored values are wrongly changed!\n");}
  800ee8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800eeb:	66 8b 00             	mov    (%eax),%ax
  800eee:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800ef2:	75 15                	jne    800f09 <_main+0xeb0>
  800ef4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800ef7:	01 c0                	add    %eax,%eax
  800ef9:	89 c2                	mov    %eax,%edx
  800efb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800efe:	01 d0                	add    %edx,%eax
  800f00:	66 8b 00             	mov    (%eax),%ax
  800f03:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800f07:	74 17                	je     800f20 <_main+0xec7>
  800f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f10:	83 ec 0c             	sub    $0xc,%esp
  800f13:	68 2c 50 80 00       	push   $0x80502c
  800f18:	e8 ec 05 00 00       	call   801509 <cprintf>
  800f1d:	83 c4 10             	add    $0x10,%esp
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) { is_correct = 0; cprintf("11 Wrong allocation: stored values are wrongly changed!\n");}
  800f20:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f23:	8b 00                	mov    (%eax),%eax
  800f25:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800f28:	75 16                	jne    800f40 <_main+0xee7>
  800f2a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800f2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f34:	8b 45 98             	mov    -0x68(%ebp),%eax
  800f37:	01 d0                	add    %edx,%eax
  800f39:	8b 00                	mov    (%eax),%eax
  800f3b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800f3e:	74 17                	je     800f57 <_main+0xefe>
  800f40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f47:	83 ec 0c             	sub    $0xc,%esp
  800f4a:	68 68 50 80 00       	push   $0x805068
  800f4f:	e8 b5 05 00 00       	call   801509 <cprintf>
  800f54:	83 c4 10             	add    $0x10,%esp

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	{ is_correct = 0; cprintf("12 Wrong allocation: stored values are wrongly changed!\n");}
  800f57:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  800f5f:	75 16                	jne    800f77 <_main+0xf1e>
  800f61:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f64:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800f6b:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f6e:	01 d0                	add    %edx,%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  800f75:	74 17                	je     800f8e <_main+0xf35>
  800f77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f7e:	83 ec 0c             	sub    $0xc,%esp
  800f81:	68 a4 50 80 00       	push   $0x8050a4
  800f86:	e8 7e 05 00 00       	call   801509 <cprintf>
  800f8b:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	{ is_correct = 0; cprintf("13 Wrong allocation: stored values are wrongly changed!\n");}
  800f8e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800f91:	66 8b 40 02          	mov    0x2(%eax),%ax
  800f95:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  800f99:	75 19                	jne    800fb4 <_main+0xf5b>
  800f9b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fa5:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fa8:	01 d0                	add    %edx,%eax
  800faa:	66 8b 40 02          	mov    0x2(%eax),%ax
  800fae:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  800fb2:	74 17                	je     800fcb <_main+0xf72>
  800fb4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fbb:	83 ec 0c             	sub    $0xc,%esp
  800fbe:	68 e0 50 80 00       	push   $0x8050e0
  800fc3:	e8 41 05 00 00       	call   801509 <cprintf>
  800fc8:	83 c4 10             	add    $0x10,%esp
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	{ is_correct = 0; cprintf("14 Wrong allocation: stored values are wrongly changed!\n");}
  800fcb:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fce:	8b 40 04             	mov    0x4(%eax),%eax
  800fd1:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800fd4:	75 17                	jne    800fed <_main+0xf94>
  800fd6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800fd9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800fe0:	8b 45 88             	mov    -0x78(%ebp),%eax
  800fe3:	01 d0                	add    %edx,%eax
  800fe5:	8b 40 04             	mov    0x4(%eax),%eax
  800fe8:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800feb:	74 17                	je     801004 <_main+0xfab>
  800fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ff4:	83 ec 0c             	sub    $0xc,%esp
  800ff7:	68 1c 51 80 00       	push   $0x80511c
  800ffc:	e8 08 05 00 00       	call   801509 <cprintf>
  801001:	83 c4 10             	add    $0x10,%esp

		if (byteArr2[0]  != minByte  || byteArr2[lastIndexOfByte2/2]   != maxByte/2 	|| byteArr2[lastIndexOfByte2] 	!= maxByte) { is_correct = 0; cprintf("15 Wrong allocation: stored values are wrongly changed!\n");}
  801004:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3a 45 e3             	cmp    -0x1d(%ebp),%al
  80100f:	75 40                	jne    801051 <_main+0xff8>
  801011:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  801017:	89 c2                	mov    %eax,%edx
  801019:	c1 ea 1f             	shr    $0x1f,%edx
  80101c:	01 d0                	add    %edx,%eax
  80101e:	d1 f8                	sar    %eax
  801020:	89 c2                	mov    %eax,%edx
  801022:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	8a 10                	mov    (%eax),%dl
  80102c:	8a 45 e2             	mov    -0x1e(%ebp),%al
  80102f:	88 c1                	mov    %al,%cl
  801031:	c0 e9 07             	shr    $0x7,%cl
  801034:	01 c8                	add    %ecx,%eax
  801036:	d0 f8                	sar    %al
  801038:	38 c2                	cmp    %al,%dl
  80103a:	75 15                	jne    801051 <_main+0xff8>
  80103c:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801042:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801048:	01 d0                	add    %edx,%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	3a 45 e2             	cmp    -0x1e(%ebp),%al
  80104f:	74 17                	je     801068 <_main+0x100f>
  801051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801058:	83 ec 0c             	sub    $0xc,%esp
  80105b:	68 58 51 80 00       	push   $0x805158
  801060:	e8 a4 04 00 00       	call   801509 <cprintf>
  801065:	83 c4 10             	add    $0x10,%esp
		if (shortArr2[0] != minShort || shortArr2[lastIndexOfShort2/2] != maxShort/2 || shortArr2[lastIndexOfShort2] 	!= maxShort) { is_correct = 0; cprintf("16 Wrong allocation: stored values are wrongly changed!\n");}
  801068:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80106e:	66 8b 00             	mov    (%eax),%ax
  801071:	66 3b 45 e0          	cmp    -0x20(%ebp),%ax
  801075:	75 4d                	jne    8010c4 <_main+0x106b>
  801077:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	c1 ea 1f             	shr    $0x1f,%edx
  801082:	01 d0                	add    %edx,%eax
  801084:	d1 f8                	sar    %eax
  801086:	01 c0                	add    %eax,%eax
  801088:	89 c2                	mov    %eax,%edx
  80108a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801090:	01 d0                	add    %edx,%eax
  801092:	66 8b 10             	mov    (%eax),%dx
  801095:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  801099:	89 c1                	mov    %eax,%ecx
  80109b:	66 c1 e9 0f          	shr    $0xf,%cx
  80109f:	01 c8                	add    %ecx,%eax
  8010a1:	66 d1 f8             	sar    %ax
  8010a4:	66 39 c2             	cmp    %ax,%dx
  8010a7:	75 1b                	jne    8010c4 <_main+0x106b>
  8010a9:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8010af:	01 c0                	add    %eax,%eax
  8010b1:	89 c2                	mov    %eax,%edx
  8010b3:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8010b9:	01 d0                	add    %edx,%eax
  8010bb:	66 8b 00             	mov    (%eax),%ax
  8010be:	66 3b 45 de          	cmp    -0x22(%ebp),%ax
  8010c2:	74 17                	je     8010db <_main+0x1082>
  8010c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010cb:	83 ec 0c             	sub    $0xc,%esp
  8010ce:	68 94 51 80 00       	push   $0x805194
  8010d3:	e8 31 04 00 00       	call   801509 <cprintf>
  8010d8:	83 c4 10             	add    $0x10,%esp

	}
	if (is_correct)
  8010db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010df:	74 04                	je     8010e5 <_main+0x108c>
	{
		eval += 30;
  8010e1:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}

	is_correct = 1;
  8010e5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	cprintf("%~\nTest malloc (1) [PAGE ALLOCATOR] completed. Eval = %d\n", eval);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f2:	68 d0 51 80 00       	push   $0x8051d0
  8010f7:	e8 0d 04 00 00       	call   801509 <cprintf>
  8010fc:	83 c4 10             	add    $0x10,%esp

	return;
  8010ff:	90                   	nop
}
  801100:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801103:	5b                   	pop    %ebx
  801104:	5f                   	pop    %edi
  801105:	5d                   	pop    %ebp
  801106:	c3                   	ret    

00801107 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  801107:	55                   	push   %ebp
  801108:	89 e5                	mov    %esp,%ebp
  80110a:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80110d:	e8 45 1b 00 00       	call   802c57 <sys_getenvindex>
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  801115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801118:	89 d0                	mov    %edx,%eax
  80111a:	c1 e0 02             	shl    $0x2,%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	c1 e0 03             	shl    $0x3,%eax
  801122:	01 d0                	add    %edx,%eax
  801124:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c1 e0 02             	shl    $0x2,%eax
  801130:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801135:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80113a:	a1 20 60 80 00       	mov    0x806020,%eax
  80113f:	8a 40 20             	mov    0x20(%eax),%al
  801142:	84 c0                	test   %al,%al
  801144:	74 0d                	je     801153 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  801146:	a1 20 60 80 00       	mov    0x806020,%eax
  80114b:	83 c0 20             	add    $0x20,%eax
  80114e:	a3 04 60 80 00       	mov    %eax,0x806004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801153:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801157:	7e 0a                	jle    801163 <libmain+0x5c>
		binaryname = argv[0];
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	8b 00                	mov    (%eax),%eax
  80115e:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	_main(argc, argv);
  801163:	83 ec 08             	sub    $0x8,%esp
  801166:	ff 75 0c             	pushl  0xc(%ebp)
  801169:	ff 75 08             	pushl  0x8(%ebp)
  80116c:	e8 e8 ee ff ff       	call   800059 <_main>
  801171:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801174:	a1 00 60 80 00       	mov    0x806000,%eax
  801179:	85 c0                	test   %eax,%eax
  80117b:	0f 84 9f 00 00 00    	je     801220 <libmain+0x119>
	{
		sys_lock_cons();
  801181:	e8 55 18 00 00       	call   8029db <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801186:	83 ec 0c             	sub    $0xc,%esp
  801189:	68 24 52 80 00       	push   $0x805224
  80118e:	e8 76 03 00 00       	call   801509 <cprintf>
  801193:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801196:	a1 20 60 80 00       	mov    0x806020,%eax
  80119b:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8011a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8011a6:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	52                   	push   %edx
  8011b0:	50                   	push   %eax
  8011b1:	68 4c 52 80 00       	push   $0x80524c
  8011b6:	e8 4e 03 00 00       	call   801509 <cprintf>
  8011bb:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8011be:	a1 20 60 80 00       	mov    0x806020,%eax
  8011c3:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8011c9:	a1 20 60 80 00       	mov    0x806020,%eax
  8011ce:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8011d4:	a1 20 60 80 00       	mov    0x806020,%eax
  8011d9:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8011df:	51                   	push   %ecx
  8011e0:	52                   	push   %edx
  8011e1:	50                   	push   %eax
  8011e2:	68 74 52 80 00       	push   $0x805274
  8011e7:	e8 1d 03 00 00       	call   801509 <cprintf>
  8011ec:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8011ef:	a1 20 60 80 00       	mov    0x806020,%eax
  8011f4:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	50                   	push   %eax
  8011fe:	68 cc 52 80 00       	push   $0x8052cc
  801203:	e8 01 03 00 00       	call   801509 <cprintf>
  801208:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80120b:	83 ec 0c             	sub    $0xc,%esp
  80120e:	68 24 52 80 00       	push   $0x805224
  801213:	e8 f1 02 00 00       	call   801509 <cprintf>
  801218:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80121b:	e8 d5 17 00 00       	call   8029f5 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  801220:	e8 19 00 00 00       	call   80123e <exit>
}
  801225:	90                   	nop
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	6a 00                	push   $0x0
  801233:	e8 eb 19 00 00       	call   802c23 <sys_destroy_env>
  801238:	83 c4 10             	add    $0x10,%esp
}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <exit>:

void
exit(void)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801244:	e8 40 1a 00 00       	call   802c89 <sys_exit_env>
}
  801249:	90                   	nop
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801252:	8d 45 10             	lea    0x10(%ebp),%eax
  801255:	83 c0 04             	add    $0x4,%eax
  801258:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80125b:	a1 60 60 98 00       	mov    0x986060,%eax
  801260:	85 c0                	test   %eax,%eax
  801262:	74 16                	je     80127a <_panic+0x2e>
		cprintf("%s: ", argv0);
  801264:	a1 60 60 98 00       	mov    0x986060,%eax
  801269:	83 ec 08             	sub    $0x8,%esp
  80126c:	50                   	push   %eax
  80126d:	68 e0 52 80 00       	push   $0x8052e0
  801272:	e8 92 02 00 00       	call   801509 <cprintf>
  801277:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80127a:	a1 04 60 80 00       	mov    0x806004,%eax
  80127f:	ff 75 0c             	pushl  0xc(%ebp)
  801282:	ff 75 08             	pushl  0x8(%ebp)
  801285:	50                   	push   %eax
  801286:	68 e5 52 80 00       	push   $0x8052e5
  80128b:	e8 79 02 00 00       	call   801509 <cprintf>
  801290:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801293:	8b 45 10             	mov    0x10(%ebp),%eax
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	ff 75 f4             	pushl  -0xc(%ebp)
  80129c:	50                   	push   %eax
  80129d:	e8 fc 01 00 00       	call   80149e <vcprintf>
  8012a2:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8012a5:	83 ec 08             	sub    $0x8,%esp
  8012a8:	6a 00                	push   $0x0
  8012aa:	68 01 53 80 00       	push   $0x805301
  8012af:	e8 ea 01 00 00       	call   80149e <vcprintf>
  8012b4:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8012b7:	e8 82 ff ff ff       	call   80123e <exit>

	// should not return here
	while (1) ;
  8012bc:	eb fe                	jmp    8012bc <_panic+0x70>

008012be <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8012c4:	a1 20 60 80 00       	mov    0x806020,%eax
  8012c9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8012cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d2:	39 c2                	cmp    %eax,%edx
  8012d4:	74 14                	je     8012ea <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	68 04 53 80 00       	push   $0x805304
  8012de:	6a 26                	push   $0x26
  8012e0:	68 50 53 80 00       	push   $0x805350
  8012e5:	e8 62 ff ff ff       	call   80124c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8012ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8012f1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012f8:	e9 c5 00 00 00       	jmp    8013c2 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8012fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801300:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	01 d0                	add    %edx,%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	85 c0                	test   %eax,%eax
  801310:	75 08                	jne    80131a <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801312:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801315:	e9 a5 00 00 00       	jmp    8013bf <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80131a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801321:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801328:	eb 69                	jmp    801393 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80132a:	a1 20 60 80 00       	mov    0x806020,%eax
  80132f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801335:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801338:	89 d0                	mov    %edx,%eax
  80133a:	01 c0                	add    %eax,%eax
  80133c:	01 d0                	add    %edx,%eax
  80133e:	c1 e0 03             	shl    $0x3,%eax
  801341:	01 c8                	add    %ecx,%eax
  801343:	8a 40 04             	mov    0x4(%eax),%al
  801346:	84 c0                	test   %al,%al
  801348:	75 46                	jne    801390 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80134a:	a1 20 60 80 00       	mov    0x806020,%eax
  80134f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801355:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801358:	89 d0                	mov    %edx,%eax
  80135a:	01 c0                	add    %eax,%eax
  80135c:	01 d0                	add    %edx,%eax
  80135e:	c1 e0 03             	shl    $0x3,%eax
  801361:	01 c8                	add    %ecx,%eax
  801363:	8b 00                	mov    (%eax),%eax
  801365:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801368:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80136b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801370:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801375:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80137c:	8b 45 08             	mov    0x8(%ebp),%eax
  80137f:	01 c8                	add    %ecx,%eax
  801381:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801383:	39 c2                	cmp    %eax,%edx
  801385:	75 09                	jne    801390 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801387:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80138e:	eb 15                	jmp    8013a5 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801390:	ff 45 e8             	incl   -0x18(%ebp)
  801393:	a1 20 60 80 00       	mov    0x806020,%eax
  801398:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80139e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013a1:	39 c2                	cmp    %eax,%edx
  8013a3:	77 85                	ja     80132a <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8013a5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8013a9:	75 14                	jne    8013bf <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	68 5c 53 80 00       	push   $0x80535c
  8013b3:	6a 3a                	push   $0x3a
  8013b5:	68 50 53 80 00       	push   $0x805350
  8013ba:	e8 8d fe ff ff       	call   80124c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8013bf:	ff 45 f0             	incl   -0x10(%ebp)
  8013c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8013c8:	0f 8c 2f ff ff ff    	jl     8012fd <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8013ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8013d5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013dc:	eb 26                	jmp    801404 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8013de:	a1 20 60 80 00       	mov    0x806020,%eax
  8013e3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8013e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013ec:	89 d0                	mov    %edx,%eax
  8013ee:	01 c0                	add    %eax,%eax
  8013f0:	01 d0                	add    %edx,%eax
  8013f2:	c1 e0 03             	shl    $0x3,%eax
  8013f5:	01 c8                	add    %ecx,%eax
  8013f7:	8a 40 04             	mov    0x4(%eax),%al
  8013fa:	3c 01                	cmp    $0x1,%al
  8013fc:	75 03                	jne    801401 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8013fe:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801401:	ff 45 e0             	incl   -0x20(%ebp)
  801404:	a1 20 60 80 00       	mov    0x806020,%eax
  801409:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	39 c2                	cmp    %eax,%edx
  801414:	77 c8                	ja     8013de <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801419:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80141c:	74 14                	je     801432 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	68 b0 53 80 00       	push   $0x8053b0
  801426:	6a 44                	push   $0x44
  801428:	68 50 53 80 00       	push   $0x805350
  80142d:	e8 1a fe ff ff       	call   80124c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801432:	90                   	nop
  801433:	c9                   	leave  
  801434:	c3                   	ret    

00801435 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80143b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143e:	8b 00                	mov    (%eax),%eax
  801440:	8d 48 01             	lea    0x1(%eax),%ecx
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	89 0a                	mov    %ecx,(%edx)
  801448:	8b 55 08             	mov    0x8(%ebp),%edx
  80144b:	88 d1                	mov    %dl,%cl
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	8b 00                	mov    (%eax),%eax
  801459:	3d ff 00 00 00       	cmp    $0xff,%eax
  80145e:	75 2c                	jne    80148c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801460:	a0 44 60 98 00       	mov    0x986044,%al
  801465:	0f b6 c0             	movzbl %al,%eax
  801468:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146b:	8b 12                	mov    (%edx),%edx
  80146d:	89 d1                	mov    %edx,%ecx
  80146f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801472:	83 c2 08             	add    $0x8,%edx
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	50                   	push   %eax
  801479:	51                   	push   %ecx
  80147a:	52                   	push   %edx
  80147b:	e8 19 15 00 00       	call   802999 <sys_cputs>
  801480:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801483:	8b 45 0c             	mov    0xc(%ebp),%eax
  801486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80148c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148f:	8b 40 04             	mov    0x4(%eax),%eax
  801492:	8d 50 01             	lea    0x1(%eax),%edx
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	89 50 04             	mov    %edx,0x4(%eax)
}
  80149b:	90                   	nop
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8014a7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014ae:	00 00 00 
	b.cnt = 0;
  8014b1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8014b8:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	ff 75 08             	pushl  0x8(%ebp)
  8014c1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014c7:	50                   	push   %eax
  8014c8:	68 35 14 80 00       	push   $0x801435
  8014cd:	e8 11 02 00 00       	call   8016e3 <vprintfmt>
  8014d2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8014d5:	a0 44 60 98 00       	mov    0x986044,%al
  8014da:	0f b6 c0             	movzbl %al,%eax
  8014dd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	50                   	push   %eax
  8014e7:	52                   	push   %edx
  8014e8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8014ee:	83 c0 08             	add    $0x8,%eax
  8014f1:	50                   	push   %eax
  8014f2:	e8 a2 14 00 00       	call   802999 <sys_cputs>
  8014f7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8014fa:	c6 05 44 60 98 00 00 	movb   $0x0,0x986044
	return b.cnt;
  801501:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80150f:	c6 05 44 60 98 00 01 	movb   $0x1,0x986044
	va_start(ap, fmt);
  801516:	8d 45 0c             	lea    0xc(%ebp),%eax
  801519:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	83 ec 08             	sub    $0x8,%esp
  801522:	ff 75 f4             	pushl  -0xc(%ebp)
  801525:	50                   	push   %eax
  801526:	e8 73 ff ff ff       	call   80149e <vcprintf>
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801531:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80153c:	e8 9a 14 00 00       	call   8029db <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801541:	8d 45 0c             	lea    0xc(%ebp),%eax
  801544:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	ff 75 f4             	pushl  -0xc(%ebp)
  801550:	50                   	push   %eax
  801551:	e8 48 ff ff ff       	call   80149e <vcprintf>
  801556:	83 c4 10             	add    $0x10,%esp
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80155c:	e8 94 14 00 00       	call   8029f5 <sys_unlock_cons>
	return cnt;
  801561:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	53                   	push   %ebx
  80156a:	83 ec 14             	sub    $0x14,%esp
  80156d:	8b 45 10             	mov    0x10(%ebp),%eax
  801570:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801573:	8b 45 14             	mov    0x14(%ebp),%eax
  801576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801579:	8b 45 18             	mov    0x18(%ebp),%eax
  80157c:	ba 00 00 00 00       	mov    $0x0,%edx
  801581:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801584:	77 55                	ja     8015db <printnum+0x75>
  801586:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801589:	72 05                	jb     801590 <printnum+0x2a>
  80158b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80158e:	77 4b                	ja     8015db <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801590:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801593:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801596:	8b 45 18             	mov    0x18(%ebp),%eax
  801599:	ba 00 00 00 00       	mov    $0x0,%edx
  80159e:	52                   	push   %edx
  80159f:	50                   	push   %eax
  8015a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a6:	e8 f1 2c 00 00       	call   80429c <__udivdi3>
  8015ab:	83 c4 10             	add    $0x10,%esp
  8015ae:	83 ec 04             	sub    $0x4,%esp
  8015b1:	ff 75 20             	pushl  0x20(%ebp)
  8015b4:	53                   	push   %ebx
  8015b5:	ff 75 18             	pushl  0x18(%ebp)
  8015b8:	52                   	push   %edx
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	ff 75 08             	pushl  0x8(%ebp)
  8015c0:	e8 a1 ff ff ff       	call   801566 <printnum>
  8015c5:	83 c4 20             	add    $0x20,%esp
  8015c8:	eb 1a                	jmp    8015e4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	ff 75 0c             	pushl  0xc(%ebp)
  8015d0:	ff 75 20             	pushl  0x20(%ebp)
  8015d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d6:	ff d0                	call   *%eax
  8015d8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8015db:	ff 4d 1c             	decl   0x1c(%ebp)
  8015de:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8015e2:	7f e6                	jg     8015ca <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8015e4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8015e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f2:	53                   	push   %ebx
  8015f3:	51                   	push   %ecx
  8015f4:	52                   	push   %edx
  8015f5:	50                   	push   %eax
  8015f6:	e8 b1 2d 00 00       	call   8043ac <__umoddi3>
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	05 14 56 80 00       	add    $0x805614,%eax
  801603:	8a 00                	mov    (%eax),%al
  801605:	0f be c0             	movsbl %al,%eax
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	ff 75 0c             	pushl  0xc(%ebp)
  80160e:	50                   	push   %eax
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
  801612:	ff d0                	call   *%eax
  801614:	83 c4 10             	add    $0x10,%esp
}
  801617:	90                   	nop
  801618:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801620:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801624:	7e 1c                	jle    801642 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	8b 00                	mov    (%eax),%eax
  80162b:	8d 50 08             	lea    0x8(%eax),%edx
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
  801631:	89 10                	mov    %edx,(%eax)
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	8b 00                	mov    (%eax),%eax
  801638:	83 e8 08             	sub    $0x8,%eax
  80163b:	8b 50 04             	mov    0x4(%eax),%edx
  80163e:	8b 00                	mov    (%eax),%eax
  801640:	eb 40                	jmp    801682 <getuint+0x65>
	else if (lflag)
  801642:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801646:	74 1e                	je     801666 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8b 00                	mov    (%eax),%eax
  80164d:	8d 50 04             	lea    0x4(%eax),%edx
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	89 10                	mov    %edx,(%eax)
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8b 00                	mov    (%eax),%eax
  80165a:	83 e8 04             	sub    $0x4,%eax
  80165d:	8b 00                	mov    (%eax),%eax
  80165f:	ba 00 00 00 00       	mov    $0x0,%edx
  801664:	eb 1c                	jmp    801682 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8b 00                	mov    (%eax),%eax
  80166b:	8d 50 04             	lea    0x4(%eax),%edx
  80166e:	8b 45 08             	mov    0x8(%ebp),%eax
  801671:	89 10                	mov    %edx,(%eax)
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8b 00                	mov    (%eax),%eax
  801678:	83 e8 04             	sub    $0x4,%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801682:	5d                   	pop    %ebp
  801683:	c3                   	ret    

00801684 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801687:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80168b:	7e 1c                	jle    8016a9 <getint+0x25>
		return va_arg(*ap, long long);
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8b 00                	mov    (%eax),%eax
  801692:	8d 50 08             	lea    0x8(%eax),%edx
  801695:	8b 45 08             	mov    0x8(%ebp),%eax
  801698:	89 10                	mov    %edx,(%eax)
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8b 00                	mov    (%eax),%eax
  80169f:	83 e8 08             	sub    $0x8,%eax
  8016a2:	8b 50 04             	mov    0x4(%eax),%edx
  8016a5:	8b 00                	mov    (%eax),%eax
  8016a7:	eb 38                	jmp    8016e1 <getint+0x5d>
	else if (lflag)
  8016a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ad:	74 1a                	je     8016c9 <getint+0x45>
		return va_arg(*ap, long);
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8b 00                	mov    (%eax),%eax
  8016b4:	8d 50 04             	lea    0x4(%eax),%edx
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	89 10                	mov    %edx,(%eax)
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8b 00                	mov    (%eax),%eax
  8016c1:	83 e8 04             	sub    $0x4,%eax
  8016c4:	8b 00                	mov    (%eax),%eax
  8016c6:	99                   	cltd   
  8016c7:	eb 18                	jmp    8016e1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	8d 50 04             	lea    0x4(%eax),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	89 10                	mov    %edx,(%eax)
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8b 00                	mov    (%eax),%eax
  8016db:	83 e8 04             	sub    $0x4,%eax
  8016de:	8b 00                	mov    (%eax),%eax
  8016e0:	99                   	cltd   
}
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	56                   	push   %esi
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016eb:	eb 17                	jmp    801704 <vprintfmt+0x21>
			if (ch == '\0')
  8016ed:	85 db                	test   %ebx,%ebx
  8016ef:	0f 84 c1 03 00 00    	je     801ab6 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	53                   	push   %ebx
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	ff d0                	call   *%eax
  801701:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	8d 50 01             	lea    0x1(%eax),%edx
  80170a:	89 55 10             	mov    %edx,0x10(%ebp)
  80170d:	8a 00                	mov    (%eax),%al
  80170f:	0f b6 d8             	movzbl %al,%ebx
  801712:	83 fb 25             	cmp    $0x25,%ebx
  801715:	75 d6                	jne    8016ed <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801717:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80171b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801722:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801729:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801730:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801737:	8b 45 10             	mov    0x10(%ebp),%eax
  80173a:	8d 50 01             	lea    0x1(%eax),%edx
  80173d:	89 55 10             	mov    %edx,0x10(%ebp)
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 d8             	movzbl %al,%ebx
  801745:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801748:	83 f8 5b             	cmp    $0x5b,%eax
  80174b:	0f 87 3d 03 00 00    	ja     801a8e <vprintfmt+0x3ab>
  801751:	8b 04 85 38 56 80 00 	mov    0x805638(,%eax,4),%eax
  801758:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80175a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80175e:	eb d7                	jmp    801737 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801760:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801764:	eb d1                	jmp    801737 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801766:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80176d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801770:	89 d0                	mov    %edx,%eax
  801772:	c1 e0 02             	shl    $0x2,%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	01 c0                	add    %eax,%eax
  801779:	01 d8                	add    %ebx,%eax
  80177b:	83 e8 30             	sub    $0x30,%eax
  80177e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	8a 00                	mov    (%eax),%al
  801786:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801789:	83 fb 2f             	cmp    $0x2f,%ebx
  80178c:	7e 3e                	jle    8017cc <vprintfmt+0xe9>
  80178e:	83 fb 39             	cmp    $0x39,%ebx
  801791:	7f 39                	jg     8017cc <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801793:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801796:	eb d5                	jmp    80176d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801798:	8b 45 14             	mov    0x14(%ebp),%eax
  80179b:	83 c0 04             	add    $0x4,%eax
  80179e:	89 45 14             	mov    %eax,0x14(%ebp)
  8017a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a4:	83 e8 04             	sub    $0x4,%eax
  8017a7:	8b 00                	mov    (%eax),%eax
  8017a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8017ac:	eb 1f                	jmp    8017cd <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8017ae:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017b2:	79 83                	jns    801737 <vprintfmt+0x54>
				width = 0;
  8017b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8017bb:	e9 77 ff ff ff       	jmp    801737 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8017c0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8017c7:	e9 6b ff ff ff       	jmp    801737 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8017cc:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8017cd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017d1:	0f 89 60 ff ff ff    	jns    801737 <vprintfmt+0x54>
				width = precision, precision = -1;
  8017d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017dd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8017e4:	e9 4e ff ff ff       	jmp    801737 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8017e9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8017ec:	e9 46 ff ff ff       	jmp    801737 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8017f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8017f4:	83 c0 04             	add    $0x4,%eax
  8017f7:	89 45 14             	mov    %eax,0x14(%ebp)
  8017fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8017fd:	83 e8 04             	sub    $0x4,%eax
  801800:	8b 00                	mov    (%eax),%eax
  801802:	83 ec 08             	sub    $0x8,%esp
  801805:	ff 75 0c             	pushl  0xc(%ebp)
  801808:	50                   	push   %eax
  801809:	8b 45 08             	mov    0x8(%ebp),%eax
  80180c:	ff d0                	call   *%eax
  80180e:	83 c4 10             	add    $0x10,%esp
			break;
  801811:	e9 9b 02 00 00       	jmp    801ab1 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801816:	8b 45 14             	mov    0x14(%ebp),%eax
  801819:	83 c0 04             	add    $0x4,%eax
  80181c:	89 45 14             	mov    %eax,0x14(%ebp)
  80181f:	8b 45 14             	mov    0x14(%ebp),%eax
  801822:	83 e8 04             	sub    $0x4,%eax
  801825:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801827:	85 db                	test   %ebx,%ebx
  801829:	79 02                	jns    80182d <vprintfmt+0x14a>
				err = -err;
  80182b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80182d:	83 fb 64             	cmp    $0x64,%ebx
  801830:	7f 0b                	jg     80183d <vprintfmt+0x15a>
  801832:	8b 34 9d 80 54 80 00 	mov    0x805480(,%ebx,4),%esi
  801839:	85 f6                	test   %esi,%esi
  80183b:	75 19                	jne    801856 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80183d:	53                   	push   %ebx
  80183e:	68 25 56 80 00       	push   $0x805625
  801843:	ff 75 0c             	pushl  0xc(%ebp)
  801846:	ff 75 08             	pushl  0x8(%ebp)
  801849:	e8 70 02 00 00       	call   801abe <printfmt>
  80184e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801851:	e9 5b 02 00 00       	jmp    801ab1 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801856:	56                   	push   %esi
  801857:	68 2e 56 80 00       	push   $0x80562e
  80185c:	ff 75 0c             	pushl  0xc(%ebp)
  80185f:	ff 75 08             	pushl  0x8(%ebp)
  801862:	e8 57 02 00 00       	call   801abe <printfmt>
  801867:	83 c4 10             	add    $0x10,%esp
			break;
  80186a:	e9 42 02 00 00       	jmp    801ab1 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80186f:	8b 45 14             	mov    0x14(%ebp),%eax
  801872:	83 c0 04             	add    $0x4,%eax
  801875:	89 45 14             	mov    %eax,0x14(%ebp)
  801878:	8b 45 14             	mov    0x14(%ebp),%eax
  80187b:	83 e8 04             	sub    $0x4,%eax
  80187e:	8b 30                	mov    (%eax),%esi
  801880:	85 f6                	test   %esi,%esi
  801882:	75 05                	jne    801889 <vprintfmt+0x1a6>
				p = "(null)";
  801884:	be 31 56 80 00       	mov    $0x805631,%esi
			if (width > 0 && padc != '-')
  801889:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80188d:	7e 6d                	jle    8018fc <vprintfmt+0x219>
  80188f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801893:	74 67                	je     8018fc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801895:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801898:	83 ec 08             	sub    $0x8,%esp
  80189b:	50                   	push   %eax
  80189c:	56                   	push   %esi
  80189d:	e8 1e 03 00 00       	call   801bc0 <strnlen>
  8018a2:	83 c4 10             	add    $0x10,%esp
  8018a5:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8018a8:	eb 16                	jmp    8018c0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8018aa:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8018ae:	83 ec 08             	sub    $0x8,%esp
  8018b1:	ff 75 0c             	pushl  0xc(%ebp)
  8018b4:	50                   	push   %eax
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	ff d0                	call   *%eax
  8018ba:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8018bd:	ff 4d e4             	decl   -0x1c(%ebp)
  8018c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8018c4:	7f e4                	jg     8018aa <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018c6:	eb 34                	jmp    8018fc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8018c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8018cc:	74 1c                	je     8018ea <vprintfmt+0x207>
  8018ce:	83 fb 1f             	cmp    $0x1f,%ebx
  8018d1:	7e 05                	jle    8018d8 <vprintfmt+0x1f5>
  8018d3:	83 fb 7e             	cmp    $0x7e,%ebx
  8018d6:	7e 12                	jle    8018ea <vprintfmt+0x207>
					putch('?', putdat);
  8018d8:	83 ec 08             	sub    $0x8,%esp
  8018db:	ff 75 0c             	pushl  0xc(%ebp)
  8018de:	6a 3f                	push   $0x3f
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	ff d0                	call   *%eax
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	eb 0f                	jmp    8018f9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8018ea:	83 ec 08             	sub    $0x8,%esp
  8018ed:	ff 75 0c             	pushl  0xc(%ebp)
  8018f0:	53                   	push   %ebx
  8018f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f4:	ff d0                	call   *%eax
  8018f6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8018f9:	ff 4d e4             	decl   -0x1c(%ebp)
  8018fc:	89 f0                	mov    %esi,%eax
  8018fe:	8d 70 01             	lea    0x1(%eax),%esi
  801901:	8a 00                	mov    (%eax),%al
  801903:	0f be d8             	movsbl %al,%ebx
  801906:	85 db                	test   %ebx,%ebx
  801908:	74 24                	je     80192e <vprintfmt+0x24b>
  80190a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80190e:	78 b8                	js     8018c8 <vprintfmt+0x1e5>
  801910:	ff 4d e0             	decl   -0x20(%ebp)
  801913:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801917:	79 af                	jns    8018c8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801919:	eb 13                	jmp    80192e <vprintfmt+0x24b>
				putch(' ', putdat);
  80191b:	83 ec 08             	sub    $0x8,%esp
  80191e:	ff 75 0c             	pushl  0xc(%ebp)
  801921:	6a 20                	push   $0x20
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	ff d0                	call   *%eax
  801928:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80192b:	ff 4d e4             	decl   -0x1c(%ebp)
  80192e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801932:	7f e7                	jg     80191b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801934:	e9 78 01 00 00       	jmp    801ab1 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801939:	83 ec 08             	sub    $0x8,%esp
  80193c:	ff 75 e8             	pushl  -0x18(%ebp)
  80193f:	8d 45 14             	lea    0x14(%ebp),%eax
  801942:	50                   	push   %eax
  801943:	e8 3c fd ff ff       	call   801684 <getint>
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80194e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801951:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801957:	85 d2                	test   %edx,%edx
  801959:	79 23                	jns    80197e <vprintfmt+0x29b>
				putch('-', putdat);
  80195b:	83 ec 08             	sub    $0x8,%esp
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	6a 2d                	push   $0x2d
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	ff d0                	call   *%eax
  801968:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80196b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801971:	f7 d8                	neg    %eax
  801973:	83 d2 00             	adc    $0x0,%edx
  801976:	f7 da                	neg    %edx
  801978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80197b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80197e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801985:	e9 bc 00 00 00       	jmp    801a46 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80198a:	83 ec 08             	sub    $0x8,%esp
  80198d:	ff 75 e8             	pushl  -0x18(%ebp)
  801990:	8d 45 14             	lea    0x14(%ebp),%eax
  801993:	50                   	push   %eax
  801994:	e8 84 fc ff ff       	call   80161d <getuint>
  801999:	83 c4 10             	add    $0x10,%esp
  80199c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80199f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8019a2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8019a9:	e9 98 00 00 00       	jmp    801a46 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8019ae:	83 ec 08             	sub    $0x8,%esp
  8019b1:	ff 75 0c             	pushl  0xc(%ebp)
  8019b4:	6a 58                	push   $0x58
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	ff d0                	call   *%eax
  8019bb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8019be:	83 ec 08             	sub    $0x8,%esp
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	6a 58                	push   $0x58
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	ff d0                	call   *%eax
  8019cb:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8019ce:	83 ec 08             	sub    $0x8,%esp
  8019d1:	ff 75 0c             	pushl  0xc(%ebp)
  8019d4:	6a 58                	push   $0x58
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	ff d0                	call   *%eax
  8019db:	83 c4 10             	add    $0x10,%esp
			break;
  8019de:	e9 ce 00 00 00       	jmp    801ab1 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8019e3:	83 ec 08             	sub    $0x8,%esp
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	6a 30                	push   $0x30
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	ff d0                	call   *%eax
  8019f0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8019f3:	83 ec 08             	sub    $0x8,%esp
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	6a 78                	push   $0x78
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	ff d0                	call   *%eax
  801a00:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801a03:	8b 45 14             	mov    0x14(%ebp),%eax
  801a06:	83 c0 04             	add    $0x4,%eax
  801a09:	89 45 14             	mov    %eax,0x14(%ebp)
  801a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a0f:	83 e8 04             	sub    $0x4,%eax
  801a12:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801a14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801a1e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801a25:	eb 1f                	jmp    801a46 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801a27:	83 ec 08             	sub    $0x8,%esp
  801a2a:	ff 75 e8             	pushl  -0x18(%ebp)
  801a2d:	8d 45 14             	lea    0x14(%ebp),%eax
  801a30:	50                   	push   %eax
  801a31:	e8 e7 fb ff ff       	call   80161d <getuint>
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801a3f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801a46:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	52                   	push   %edx
  801a51:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a54:	50                   	push   %eax
  801a55:	ff 75 f4             	pushl  -0xc(%ebp)
  801a58:	ff 75 f0             	pushl  -0x10(%ebp)
  801a5b:	ff 75 0c             	pushl  0xc(%ebp)
  801a5e:	ff 75 08             	pushl  0x8(%ebp)
  801a61:	e8 00 fb ff ff       	call   801566 <printnum>
  801a66:	83 c4 20             	add    $0x20,%esp
			break;
  801a69:	eb 46                	jmp    801ab1 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801a6b:	83 ec 08             	sub    $0x8,%esp
  801a6e:	ff 75 0c             	pushl  0xc(%ebp)
  801a71:	53                   	push   %ebx
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	ff d0                	call   *%eax
  801a77:	83 c4 10             	add    $0x10,%esp
			break;
  801a7a:	eb 35                	jmp    801ab1 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  801a7c:	c6 05 44 60 98 00 00 	movb   $0x0,0x986044
			break;
  801a83:	eb 2c                	jmp    801ab1 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  801a85:	c6 05 44 60 98 00 01 	movb   $0x1,0x986044
			break;
  801a8c:	eb 23                	jmp    801ab1 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801a8e:	83 ec 08             	sub    $0x8,%esp
  801a91:	ff 75 0c             	pushl  0xc(%ebp)
  801a94:	6a 25                	push   $0x25
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	ff d0                	call   *%eax
  801a9b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801a9e:	ff 4d 10             	decl   0x10(%ebp)
  801aa1:	eb 03                	jmp    801aa6 <vprintfmt+0x3c3>
  801aa3:	ff 4d 10             	decl   0x10(%ebp)
  801aa6:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa9:	48                   	dec    %eax
  801aaa:	8a 00                	mov    (%eax),%al
  801aac:	3c 25                	cmp    $0x25,%al
  801aae:	75 f3                	jne    801aa3 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  801ab0:	90                   	nop
		}
	}
  801ab1:	e9 35 fc ff ff       	jmp    8016eb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801ab6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ab7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aba:	5b                   	pop    %ebx
  801abb:	5e                   	pop    %esi
  801abc:	5d                   	pop    %ebp
  801abd:	c3                   	ret    

00801abe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801ac4:	8d 45 10             	lea    0x10(%ebp),%eax
  801ac7:	83 c0 04             	add    $0x4,%eax
  801aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801acd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad3:	50                   	push   %eax
  801ad4:	ff 75 0c             	pushl  0xc(%ebp)
  801ad7:	ff 75 08             	pushl  0x8(%ebp)
  801ada:	e8 04 fc ff ff       	call   8016e3 <vprintfmt>
  801adf:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ae2:	90                   	nop
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aeb:	8b 40 08             	mov    0x8(%eax),%eax
  801aee:	8d 50 01             	lea    0x1(%eax),%edx
  801af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af4:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afa:	8b 10                	mov    (%eax),%edx
  801afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aff:	8b 40 04             	mov    0x4(%eax),%eax
  801b02:	39 c2                	cmp    %eax,%edx
  801b04:	73 12                	jae    801b18 <sprintputch+0x33>
		*b->buf++ = ch;
  801b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b09:	8b 00                	mov    (%eax),%eax
  801b0b:	8d 48 01             	lea    0x1(%eax),%ecx
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	89 0a                	mov    %ecx,(%edx)
  801b13:	8b 55 08             	mov    0x8(%ebp),%edx
  801b16:	88 10                	mov    %dl,(%eax)
}
  801b18:	90                   	nop
  801b19:	5d                   	pop    %ebp
  801b1a:	c3                   	ret    

00801b1b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	01 d0                	add    %edx,%eax
  801b32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801b3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b40:	74 06                	je     801b48 <vsnprintf+0x2d>
  801b42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b46:	7f 07                	jg     801b4f <vsnprintf+0x34>
		return -E_INVAL;
  801b48:	b8 03 00 00 00       	mov    $0x3,%eax
  801b4d:	eb 20                	jmp    801b6f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801b4f:	ff 75 14             	pushl  0x14(%ebp)
  801b52:	ff 75 10             	pushl  0x10(%ebp)
  801b55:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801b58:	50                   	push   %eax
  801b59:	68 e5 1a 80 00       	push   $0x801ae5
  801b5e:	e8 80 fb ff ff       	call   8016e3 <vprintfmt>
  801b63:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801b66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b69:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801b77:	8d 45 10             	lea    0x10(%ebp),%eax
  801b7a:	83 c0 04             	add    $0x4,%eax
  801b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801b80:	8b 45 10             	mov    0x10(%ebp),%eax
  801b83:	ff 75 f4             	pushl  -0xc(%ebp)
  801b86:	50                   	push   %eax
  801b87:	ff 75 0c             	pushl  0xc(%ebp)
  801b8a:	ff 75 08             	pushl  0x8(%ebp)
  801b8d:	e8 89 ff ff ff       	call   801b1b <vsnprintf>
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ba3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801baa:	eb 06                	jmp    801bb2 <strlen+0x15>
		n++;
  801bac:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801baf:	ff 45 08             	incl   0x8(%ebp)
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	8a 00                	mov    (%eax),%al
  801bb7:	84 c0                	test   %al,%al
  801bb9:	75 f1                	jne    801bac <strlen+0xf>
		n++;
	return n;
  801bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801bcd:	eb 09                	jmp    801bd8 <strnlen+0x18>
		n++;
  801bcf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801bd2:	ff 45 08             	incl   0x8(%ebp)
  801bd5:	ff 4d 0c             	decl   0xc(%ebp)
  801bd8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bdc:	74 09                	je     801be7 <strnlen+0x27>
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	8a 00                	mov    (%eax),%al
  801be3:	84 c0                	test   %al,%al
  801be5:	75 e8                	jne    801bcf <strnlen+0xf>
		n++;
	return n;
  801be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801bf8:	90                   	nop
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	8d 50 01             	lea    0x1(%eax),%edx
  801bff:	89 55 08             	mov    %edx,0x8(%ebp)
  801c02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c05:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c08:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c0b:	8a 12                	mov    (%edx),%dl
  801c0d:	88 10                	mov    %dl,(%eax)
  801c0f:	8a 00                	mov    (%eax),%al
  801c11:	84 c0                	test   %al,%al
  801c13:	75 e4                	jne    801bf9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
  801c1d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801c26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801c2d:	eb 1f                	jmp    801c4e <strncpy+0x34>
		*dst++ = *src;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	8d 50 01             	lea    0x1(%eax),%edx
  801c35:	89 55 08             	mov    %edx,0x8(%ebp)
  801c38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3b:	8a 12                	mov    (%edx),%dl
  801c3d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c42:	8a 00                	mov    (%eax),%al
  801c44:	84 c0                	test   %al,%al
  801c46:	74 03                	je     801c4b <strncpy+0x31>
			src++;
  801c48:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801c4b:	ff 45 fc             	incl   -0x4(%ebp)
  801c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801c51:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c54:	72 d9                	jb     801c2f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801c67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c6b:	74 30                	je     801c9d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801c6d:	eb 16                	jmp    801c85 <strlcpy+0x2a>
			*dst++ = *src++;
  801c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c72:	8d 50 01             	lea    0x1(%eax),%edx
  801c75:	89 55 08             	mov    %edx,0x8(%ebp)
  801c78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7b:	8d 4a 01             	lea    0x1(%edx),%ecx
  801c7e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801c81:	8a 12                	mov    (%edx),%dl
  801c83:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801c85:	ff 4d 10             	decl   0x10(%ebp)
  801c88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c8c:	74 09                	je     801c97 <strlcpy+0x3c>
  801c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c91:	8a 00                	mov    (%eax),%al
  801c93:	84 c0                	test   %al,%al
  801c95:	75 d8                	jne    801c6f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ca3:	29 c2                	sub    %eax,%edx
  801ca5:	89 d0                	mov    %edx,%eax
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801cac:	eb 06                	jmp    801cb4 <strcmp+0xb>
		p++, q++;
  801cae:	ff 45 08             	incl   0x8(%ebp)
  801cb1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	8a 00                	mov    (%eax),%al
  801cb9:	84 c0                	test   %al,%al
  801cbb:	74 0e                	je     801ccb <strcmp+0x22>
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	8a 10                	mov    (%eax),%dl
  801cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc5:	8a 00                	mov    (%eax),%al
  801cc7:	38 c2                	cmp    %al,%dl
  801cc9:	74 e3                	je     801cae <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	8a 00                	mov    (%eax),%al
  801cd0:	0f b6 d0             	movzbl %al,%edx
  801cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd6:	8a 00                	mov    (%eax),%al
  801cd8:	0f b6 c0             	movzbl %al,%eax
  801cdb:	29 c2                	sub    %eax,%edx
  801cdd:	89 d0                	mov    %edx,%eax
}
  801cdf:	5d                   	pop    %ebp
  801ce0:	c3                   	ret    

00801ce1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ce4:	eb 09                	jmp    801cef <strncmp+0xe>
		n--, p++, q++;
  801ce6:	ff 4d 10             	decl   0x10(%ebp)
  801ce9:	ff 45 08             	incl   0x8(%ebp)
  801cec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cf3:	74 17                	je     801d0c <strncmp+0x2b>
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	8a 00                	mov    (%eax),%al
  801cfa:	84 c0                	test   %al,%al
  801cfc:	74 0e                	je     801d0c <strncmp+0x2b>
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	8a 10                	mov    (%eax),%dl
  801d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d06:	8a 00                	mov    (%eax),%al
  801d08:	38 c2                	cmp    %al,%dl
  801d0a:	74 da                	je     801ce6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801d0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d10:	75 07                	jne    801d19 <strncmp+0x38>
		return 0;
  801d12:	b8 00 00 00 00       	mov    $0x0,%eax
  801d17:	eb 14                	jmp    801d2d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	8a 00                	mov    (%eax),%al
  801d1e:	0f b6 d0             	movzbl %al,%edx
  801d21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d24:	8a 00                	mov    (%eax),%al
  801d26:	0f b6 c0             	movzbl %al,%eax
  801d29:	29 c2                	sub    %eax,%edx
  801d2b:	89 d0                	mov    %edx,%eax
}
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    

00801d2f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801d2f:	55                   	push   %ebp
  801d30:	89 e5                	mov    %esp,%ebp
  801d32:	83 ec 04             	sub    $0x4,%esp
  801d35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d38:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d3b:	eb 12                	jmp    801d4f <strchr+0x20>
		if (*s == c)
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	8a 00                	mov    (%eax),%al
  801d42:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d45:	75 05                	jne    801d4c <strchr+0x1d>
			return (char *) s;
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	eb 11                	jmp    801d5d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801d4c:	ff 45 08             	incl   0x8(%ebp)
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	8a 00                	mov    (%eax),%al
  801d54:	84 c0                	test   %al,%al
  801d56:	75 e5                	jne    801d3d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 04             	sub    $0x4,%esp
  801d65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d68:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801d6b:	eb 0d                	jmp    801d7a <strfind+0x1b>
		if (*s == c)
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	8a 00                	mov    (%eax),%al
  801d72:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801d75:	74 0e                	je     801d85 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801d77:	ff 45 08             	incl   0x8(%ebp)
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	8a 00                	mov    (%eax),%al
  801d7f:	84 c0                	test   %al,%al
  801d81:	75 ea                	jne    801d6d <strfind+0xe>
  801d83:	eb 01                	jmp    801d86 <strfind+0x27>
		if (*s == c)
			break;
  801d85:	90                   	nop
	return (char *) s;
  801d86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801d91:	8b 45 08             	mov    0x8(%ebp),%eax
  801d94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801d97:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801d9d:	eb 0e                	jmp    801dad <memset+0x22>
		*p++ = c;
  801d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801da2:	8d 50 01             	lea    0x1(%eax),%edx
  801da5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801da8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dab:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801dad:	ff 4d f8             	decl   -0x8(%ebp)
  801db0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801db4:	79 e9                	jns    801d9f <memset+0x14>
		*p++ = c;

	return v;
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801dcd:	eb 16                	jmp    801de5 <memcpy+0x2a>
		*d++ = *s++;
  801dcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dd2:	8d 50 01             	lea    0x1(%eax),%edx
  801dd5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801dd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ddb:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dde:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801de1:	8a 12                	mov    (%edx),%dl
  801de3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801de5:	8b 45 10             	mov    0x10(%ebp),%eax
  801de8:	8d 50 ff             	lea    -0x1(%eax),%edx
  801deb:	89 55 10             	mov    %edx,0x10(%ebp)
  801dee:	85 c0                	test   %eax,%eax
  801df0:	75 dd                	jne    801dcf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e0c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e0f:	73 50                	jae    801e61 <memmove+0x6a>
  801e11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e14:	8b 45 10             	mov    0x10(%ebp),%eax
  801e17:	01 d0                	add    %edx,%eax
  801e19:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801e1c:	76 43                	jbe    801e61 <memmove+0x6a>
		s += n;
  801e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e21:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801e24:	8b 45 10             	mov    0x10(%ebp),%eax
  801e27:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801e2a:	eb 10                	jmp    801e3c <memmove+0x45>
			*--d = *--s;
  801e2c:	ff 4d f8             	decl   -0x8(%ebp)
  801e2f:	ff 4d fc             	decl   -0x4(%ebp)
  801e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e35:	8a 10                	mov    (%eax),%dl
  801e37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e3a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e42:	89 55 10             	mov    %edx,0x10(%ebp)
  801e45:	85 c0                	test   %eax,%eax
  801e47:	75 e3                	jne    801e2c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801e49:	eb 23                	jmp    801e6e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801e4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e4e:	8d 50 01             	lea    0x1(%eax),%edx
  801e51:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801e54:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e57:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e5a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801e5d:	8a 12                	mov    (%edx),%dl
  801e5f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801e61:	8b 45 10             	mov    0x10(%ebp),%eax
  801e64:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e67:	89 55 10             	mov    %edx,0x10(%ebp)
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	75 dd                	jne    801e4b <memmove+0x54>
			*d++ = *s++;

	return dst;
  801e6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e82:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801e85:	eb 2a                	jmp    801eb1 <memcmp+0x3e>
		if (*s1 != *s2)
  801e87:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e8a:	8a 10                	mov    (%eax),%dl
  801e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e8f:	8a 00                	mov    (%eax),%al
  801e91:	38 c2                	cmp    %al,%dl
  801e93:	74 16                	je     801eab <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 d0             	movzbl %al,%edx
  801e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ea0:	8a 00                	mov    (%eax),%al
  801ea2:	0f b6 c0             	movzbl %al,%eax
  801ea5:	29 c2                	sub    %eax,%edx
  801ea7:	89 d0                	mov    %edx,%eax
  801ea9:	eb 18                	jmp    801ec3 <memcmp+0x50>
		s1++, s2++;
  801eab:	ff 45 fc             	incl   -0x4(%ebp)
  801eae:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801eb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  801eb7:	89 55 10             	mov    %edx,0x10(%ebp)
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	75 c9                	jne    801e87 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801ebe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  801ece:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed1:	01 d0                	add    %edx,%eax
  801ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801ed6:	eb 15                	jmp    801eed <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8a 00                	mov    (%eax),%al
  801edd:	0f b6 d0             	movzbl %al,%edx
  801ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee3:	0f b6 c0             	movzbl %al,%eax
  801ee6:	39 c2                	cmp    %eax,%edx
  801ee8:	74 0d                	je     801ef7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801eea:	ff 45 08             	incl   0x8(%ebp)
  801eed:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801ef3:	72 e3                	jb     801ed8 <memfind+0x13>
  801ef5:	eb 01                	jmp    801ef8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801ef7:	90                   	nop
	return (void *) s;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
  801f00:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801f03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801f0a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f11:	eb 03                	jmp    801f16 <strtol+0x19>
		s++;
  801f13:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801f16:	8b 45 08             	mov    0x8(%ebp),%eax
  801f19:	8a 00                	mov    (%eax),%al
  801f1b:	3c 20                	cmp    $0x20,%al
  801f1d:	74 f4                	je     801f13 <strtol+0x16>
  801f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f22:	8a 00                	mov    (%eax),%al
  801f24:	3c 09                	cmp    $0x9,%al
  801f26:	74 eb                	je     801f13 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	8a 00                	mov    (%eax),%al
  801f2d:	3c 2b                	cmp    $0x2b,%al
  801f2f:	75 05                	jne    801f36 <strtol+0x39>
		s++;
  801f31:	ff 45 08             	incl   0x8(%ebp)
  801f34:	eb 13                	jmp    801f49 <strtol+0x4c>
	else if (*s == '-')
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	8a 00                	mov    (%eax),%al
  801f3b:	3c 2d                	cmp    $0x2d,%al
  801f3d:	75 0a                	jne    801f49 <strtol+0x4c>
		s++, neg = 1;
  801f3f:	ff 45 08             	incl   0x8(%ebp)
  801f42:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801f49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f4d:	74 06                	je     801f55 <strtol+0x58>
  801f4f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801f53:	75 20                	jne    801f75 <strtol+0x78>
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	8a 00                	mov    (%eax),%al
  801f5a:	3c 30                	cmp    $0x30,%al
  801f5c:	75 17                	jne    801f75 <strtol+0x78>
  801f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f61:	40                   	inc    %eax
  801f62:	8a 00                	mov    (%eax),%al
  801f64:	3c 78                	cmp    $0x78,%al
  801f66:	75 0d                	jne    801f75 <strtol+0x78>
		s += 2, base = 16;
  801f68:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801f6c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801f73:	eb 28                	jmp    801f9d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801f75:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f79:	75 15                	jne    801f90 <strtol+0x93>
  801f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7e:	8a 00                	mov    (%eax),%al
  801f80:	3c 30                	cmp    $0x30,%al
  801f82:	75 0c                	jne    801f90 <strtol+0x93>
		s++, base = 8;
  801f84:	ff 45 08             	incl   0x8(%ebp)
  801f87:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801f8e:	eb 0d                	jmp    801f9d <strtol+0xa0>
	else if (base == 0)
  801f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f94:	75 07                	jne    801f9d <strtol+0xa0>
		base = 10;
  801f96:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa0:	8a 00                	mov    (%eax),%al
  801fa2:	3c 2f                	cmp    $0x2f,%al
  801fa4:	7e 19                	jle    801fbf <strtol+0xc2>
  801fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa9:	8a 00                	mov    (%eax),%al
  801fab:	3c 39                	cmp    $0x39,%al
  801fad:	7f 10                	jg     801fbf <strtol+0xc2>
			dig = *s - '0';
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	8a 00                	mov    (%eax),%al
  801fb4:	0f be c0             	movsbl %al,%eax
  801fb7:	83 e8 30             	sub    $0x30,%eax
  801fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbd:	eb 42                	jmp    802001 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	8a 00                	mov    (%eax),%al
  801fc4:	3c 60                	cmp    $0x60,%al
  801fc6:	7e 19                	jle    801fe1 <strtol+0xe4>
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	8a 00                	mov    (%eax),%al
  801fcd:	3c 7a                	cmp    $0x7a,%al
  801fcf:	7f 10                	jg     801fe1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd4:	8a 00                	mov    (%eax),%al
  801fd6:	0f be c0             	movsbl %al,%eax
  801fd9:	83 e8 57             	sub    $0x57,%eax
  801fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdf:	eb 20                	jmp    802001 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe4:	8a 00                	mov    (%eax),%al
  801fe6:	3c 40                	cmp    $0x40,%al
  801fe8:	7e 39                	jle    802023 <strtol+0x126>
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8a 00                	mov    (%eax),%al
  801fef:	3c 5a                	cmp    $0x5a,%al
  801ff1:	7f 30                	jg     802023 <strtol+0x126>
			dig = *s - 'A' + 10;
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	0f be c0             	movsbl %al,%eax
  801ffb:	83 e8 37             	sub    $0x37,%eax
  801ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802004:	3b 45 10             	cmp    0x10(%ebp),%eax
  802007:	7d 19                	jge    802022 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802009:	ff 45 08             	incl   0x8(%ebp)
  80200c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80200f:	0f af 45 10          	imul   0x10(%ebp),%eax
  802013:	89 c2                	mov    %eax,%edx
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	01 d0                	add    %edx,%eax
  80201a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80201d:	e9 7b ff ff ff       	jmp    801f9d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  802022:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  802023:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802027:	74 08                	je     802031 <strtol+0x134>
		*endptr = (char *) s;
  802029:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202c:	8b 55 08             	mov    0x8(%ebp),%edx
  80202f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802031:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802035:	74 07                	je     80203e <strtol+0x141>
  802037:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80203a:	f7 d8                	neg    %eax
  80203c:	eb 03                	jmp    802041 <strtol+0x144>
  80203e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <ltostr>:

void
ltostr(long value, char *str)
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802049:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802050:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802057:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80205b:	79 13                	jns    802070 <ltostr+0x2d>
	{
		neg = 1;
  80205d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802064:	8b 45 0c             	mov    0xc(%ebp),%eax
  802067:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80206a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80206d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802078:	99                   	cltd   
  802079:	f7 f9                	idiv   %ecx
  80207b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80207e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802081:	8d 50 01             	lea    0x1(%eax),%edx
  802084:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802087:	89 c2                	mov    %eax,%edx
  802089:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208c:	01 d0                	add    %edx,%eax
  80208e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802091:	83 c2 30             	add    $0x30,%edx
  802094:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802096:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802099:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80209e:	f7 e9                	imul   %ecx
  8020a0:	c1 fa 02             	sar    $0x2,%edx
  8020a3:	89 c8                	mov    %ecx,%eax
  8020a5:	c1 f8 1f             	sar    $0x1f,%eax
  8020a8:	29 c2                	sub    %eax,%edx
  8020aa:	89 d0                	mov    %edx,%eax
  8020ac:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8020af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020b3:	75 bb                	jne    802070 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8020b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8020bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020bf:	48                   	dec    %eax
  8020c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8020c3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c7:	74 3d                	je     802106 <ltostr+0xc3>
		start = 1 ;
  8020c9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8020d0:	eb 34                	jmp    802106 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8020d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d8:	01 d0                	add    %edx,%eax
  8020da:	8a 00                	mov    (%eax),%al
  8020dc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8020df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e5:	01 c2                	add    %eax,%edx
  8020e7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8020ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ed:	01 c8                	add    %ecx,%eax
  8020ef:	8a 00                	mov    (%eax),%al
  8020f1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8020f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8020f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020f9:	01 c2                	add    %eax,%edx
  8020fb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8020fe:	88 02                	mov    %al,(%edx)
		start++ ;
  802100:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  802103:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80210c:	7c c4                	jl     8020d2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80210e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802111:	8b 45 0c             	mov    0xc(%ebp),%eax
  802114:	01 d0                	add    %edx,%eax
  802116:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802119:	90                   	nop
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802122:	ff 75 08             	pushl  0x8(%ebp)
  802125:	e8 73 fa ff ff       	call   801b9d <strlen>
  80212a:	83 c4 04             	add    $0x4,%esp
  80212d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802130:	ff 75 0c             	pushl  0xc(%ebp)
  802133:	e8 65 fa ff ff       	call   801b9d <strlen>
  802138:	83 c4 04             	add    $0x4,%esp
  80213b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80213e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802145:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80214c:	eb 17                	jmp    802165 <strcconcat+0x49>
		final[s] = str1[s] ;
  80214e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802151:	8b 45 10             	mov    0x10(%ebp),%eax
  802154:	01 c2                	add    %eax,%edx
  802156:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	01 c8                	add    %ecx,%eax
  80215e:	8a 00                	mov    (%eax),%al
  802160:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802162:	ff 45 fc             	incl   -0x4(%ebp)
  802165:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802168:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80216b:	7c e1                	jl     80214e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80216d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802174:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80217b:	eb 1f                	jmp    80219c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80217d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802180:	8d 50 01             	lea    0x1(%eax),%edx
  802183:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802186:	89 c2                	mov    %eax,%edx
  802188:	8b 45 10             	mov    0x10(%ebp),%eax
  80218b:	01 c2                	add    %eax,%edx
  80218d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802190:	8b 45 0c             	mov    0xc(%ebp),%eax
  802193:	01 c8                	add    %ecx,%eax
  802195:	8a 00                	mov    (%eax),%al
  802197:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802199:	ff 45 f8             	incl   -0x8(%ebp)
  80219c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80219f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021a2:	7c d9                	jl     80217d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8021a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8021aa:	01 d0                	add    %edx,%eax
  8021ac:	c6 00 00             	movb   $0x0,(%eax)
}
  8021af:	90                   	nop
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8021b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8021be:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c1:	8b 00                	mov    (%eax),%eax
  8021c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8021ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8021cd:	01 d0                	add    %edx,%eax
  8021cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8021d5:	eb 0c                	jmp    8021e3 <strsplit+0x31>
			*string++ = 0;
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	8d 50 01             	lea    0x1(%eax),%edx
  8021dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8021e0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	8a 00                	mov    (%eax),%al
  8021e8:	84 c0                	test   %al,%al
  8021ea:	74 18                	je     802204 <strsplit+0x52>
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	8a 00                	mov    (%eax),%al
  8021f1:	0f be c0             	movsbl %al,%eax
  8021f4:	50                   	push   %eax
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	e8 32 fb ff ff       	call   801d2f <strchr>
  8021fd:	83 c4 08             	add    $0x8,%esp
  802200:	85 c0                	test   %eax,%eax
  802202:	75 d3                	jne    8021d7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	8a 00                	mov    (%eax),%al
  802209:	84 c0                	test   %al,%al
  80220b:	74 5a                	je     802267 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80220d:	8b 45 14             	mov    0x14(%ebp),%eax
  802210:	8b 00                	mov    (%eax),%eax
  802212:	83 f8 0f             	cmp    $0xf,%eax
  802215:	75 07                	jne    80221e <strsplit+0x6c>
		{
			return 0;
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
  80221c:	eb 66                	jmp    802284 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80221e:	8b 45 14             	mov    0x14(%ebp),%eax
  802221:	8b 00                	mov    (%eax),%eax
  802223:	8d 48 01             	lea    0x1(%eax),%ecx
  802226:	8b 55 14             	mov    0x14(%ebp),%edx
  802229:	89 0a                	mov    %ecx,(%edx)
  80222b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802232:	8b 45 10             	mov    0x10(%ebp),%eax
  802235:	01 c2                	add    %eax,%edx
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80223c:	eb 03                	jmp    802241 <strsplit+0x8f>
			string++;
  80223e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	8a 00                	mov    (%eax),%al
  802246:	84 c0                	test   %al,%al
  802248:	74 8b                	je     8021d5 <strsplit+0x23>
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	8a 00                	mov    (%eax),%al
  80224f:	0f be c0             	movsbl %al,%eax
  802252:	50                   	push   %eax
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	e8 d4 fa ff ff       	call   801d2f <strchr>
  80225b:	83 c4 08             	add    $0x8,%esp
  80225e:	85 c0                	test   %eax,%eax
  802260:	74 dc                	je     80223e <strsplit+0x8c>
			string++;
	}
  802262:	e9 6e ff ff ff       	jmp    8021d5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802267:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802268:	8b 45 14             	mov    0x14(%ebp),%eax
  80226b:	8b 00                	mov    (%eax),%eax
  80226d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802274:	8b 45 10             	mov    0x10(%ebp),%eax
  802277:	01 d0                	add    %edx,%eax
  802279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80227f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802284:	c9                   	leave  
  802285:	c3                   	ret    

00802286 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802286:	55                   	push   %ebp
  802287:	89 e5                	mov    %esp,%ebp
  802289:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 a8 57 80 00       	push   $0x8057a8
  802294:	68 3f 01 00 00       	push   $0x13f
  802299:	68 ca 57 80 00       	push   $0x8057ca
  80229e:	e8 a9 ef ff ff       	call   80124c <_panic>

008022a3 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
  8022a6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8022a9:	83 ec 0c             	sub    $0xc,%esp
  8022ac:	ff 75 08             	pushl  0x8(%ebp)
  8022af:	e8 90 0c 00 00       	call   802f44 <sys_sbrk>
  8022b4:	83 c4 10             	add    $0x10,%esp
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8022bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c3:	75 0a                	jne    8022cf <malloc+0x16>
		return NULL;
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ca:	e9 9e 01 00 00       	jmp    80246d <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8022cf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8022d6:	77 2c                	ja     802304 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8022d8:	e8 eb 0a 00 00       	call   802dc8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022dd:	85 c0                	test   %eax,%eax
  8022df:	74 19                	je     8022fa <malloc+0x41>

			void * block = alloc_block_FF(size);
  8022e1:	83 ec 0c             	sub    $0xc,%esp
  8022e4:	ff 75 08             	pushl  0x8(%ebp)
  8022e7:	e8 85 11 00 00       	call   803471 <alloc_block_FF>
  8022ec:	83 c4 10             	add    $0x10,%esp
  8022ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8022f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022f5:	e9 73 01 00 00       	jmp    80246d <malloc+0x1b4>
		} else {
			return NULL;
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	e9 69 01 00 00       	jmp    80246d <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802304:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80230b:	8b 55 08             	mov    0x8(%ebp),%edx
  80230e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802311:	01 d0                	add    %edx,%eax
  802313:	48                   	dec    %eax
  802314:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802317:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80231a:	ba 00 00 00 00       	mov    $0x0,%edx
  80231f:	f7 75 e0             	divl   -0x20(%ebp)
  802322:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802325:	29 d0                	sub    %edx,%eax
  802327:	c1 e8 0c             	shr    $0xc,%eax
  80232a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  80232d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802334:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80233b:	a1 20 60 80 00       	mov    0x806020,%eax
  802340:	8b 40 7c             	mov    0x7c(%eax),%eax
  802343:	05 00 10 00 00       	add    $0x1000,%eax
  802348:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80234b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802350:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802353:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802356:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80235d:	8b 55 08             	mov    0x8(%ebp),%edx
  802360:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802363:	01 d0                	add    %edx,%eax
  802365:	48                   	dec    %eax
  802366:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802369:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80236c:	ba 00 00 00 00       	mov    $0x0,%edx
  802371:	f7 75 cc             	divl   -0x34(%ebp)
  802374:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802377:	29 d0                	sub    %edx,%eax
  802379:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80237c:	76 0a                	jbe    802388 <malloc+0xcf>
		return NULL;
  80237e:	b8 00 00 00 00       	mov    $0x0,%eax
  802383:	e9 e5 00 00 00       	jmp    80246d <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  802388:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80238b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80238e:	eb 48                	jmp    8023d8 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  802390:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802393:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802396:	c1 e8 0c             	shr    $0xc,%eax
  802399:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  80239c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80239f:	8b 04 85 40 60 90 00 	mov    0x906040(,%eax,4),%eax
  8023a6:	85 c0                	test   %eax,%eax
  8023a8:	75 11                	jne    8023bb <malloc+0x102>
			freePagesCount++;
  8023aa:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8023ad:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8023b1:	75 16                	jne    8023c9 <malloc+0x110>
				start = i;
  8023b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023b9:	eb 0e                	jmp    8023c9 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8023bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8023c2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8023cf:	74 12                	je     8023e3 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8023d1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8023d8:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8023df:	76 af                	jbe    802390 <malloc+0xd7>
  8023e1:	eb 01                	jmp    8023e4 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8023e3:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8023e4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8023e8:	74 08                	je     8023f2 <malloc+0x139>
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8023f0:	74 07                	je     8023f9 <malloc+0x140>
		return NULL;
  8023f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f7:	eb 74                	jmp    80246d <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8023ff:	c1 e8 0c             	shr    $0xc,%eax
  802402:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  802405:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802408:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80240b:	89 14 85 40 60 80 00 	mov    %edx,0x806040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802412:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802415:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802418:	eb 11                	jmp    80242b <malloc+0x172>
		markedPages[i] = 1;
  80241a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80241d:	c7 04 85 40 60 90 00 	movl   $0x1,0x906040(,%eax,4)
  802424:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802428:	ff 45 e8             	incl   -0x18(%ebp)
  80242b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80242e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802431:	01 d0                	add    %edx,%eax
  802433:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802436:	77 e2                	ja     80241a <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  802438:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80243f:	8b 55 08             	mov    0x8(%ebp),%edx
  802442:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802445:	01 d0                	add    %edx,%eax
  802447:	48                   	dec    %eax
  802448:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80244b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80244e:	ba 00 00 00 00       	mov    $0x0,%edx
  802453:	f7 75 bc             	divl   -0x44(%ebp)
  802456:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802459:	29 d0                	sub    %edx,%eax
  80245b:	83 ec 08             	sub    $0x8,%esp
  80245e:	50                   	push   %eax
  80245f:	ff 75 f0             	pushl  -0x10(%ebp)
  802462:	e8 14 0b 00 00       	call   802f7b <sys_allocate_user_mem>
  802467:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  802475:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802479:	0f 84 ee 00 00 00    	je     80256d <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80247f:	a1 20 60 80 00       	mov    0x806020,%eax
  802484:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  802487:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248a:	77 09                	ja     802495 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80248c:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  802493:	76 14                	jbe    8024a9 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	68 d8 57 80 00       	push   $0x8057d8
  80249d:	6a 68                	push   $0x68
  80249f:	68 f2 57 80 00       	push   $0x8057f2
  8024a4:	e8 a3 ed ff ff       	call   80124c <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8024a9:	a1 20 60 80 00       	mov    0x806020,%eax
  8024ae:	8b 40 74             	mov    0x74(%eax),%eax
  8024b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b4:	77 20                	ja     8024d6 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8024b6:	a1 20 60 80 00       	mov    0x806020,%eax
  8024bb:	8b 40 78             	mov    0x78(%eax),%eax
  8024be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c1:	76 13                	jbe    8024d6 <free+0x67>
		free_block(virtual_address);
  8024c3:	83 ec 0c             	sub    $0xc,%esp
  8024c6:	ff 75 08             	pushl  0x8(%ebp)
  8024c9:	e8 6c 16 00 00       	call   803b3a <free_block>
  8024ce:	83 c4 10             	add    $0x10,%esp
		return;
  8024d1:	e9 98 00 00 00       	jmp    80256e <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8024d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8024de:	8b 40 7c             	mov    0x7c(%eax),%eax
  8024e1:	29 c2                	sub    %eax,%edx
  8024e3:	89 d0                	mov    %edx,%eax
  8024e5:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8024ea:	c1 e8 0c             	shr    $0xc,%eax
  8024ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8024f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024f7:	eb 16                	jmp    80250f <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8024f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ff:	01 d0                	add    %edx,%eax
  802501:	c7 04 85 40 60 90 00 	movl   $0x0,0x906040(,%eax,4)
  802508:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80250c:	ff 45 f4             	incl   -0xc(%ebp)
  80250f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802512:	8b 04 85 40 60 80 00 	mov    0x806040(,%eax,4),%eax
  802519:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80251c:	7f db                	jg     8024f9 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80251e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802521:	8b 04 85 40 60 80 00 	mov    0x806040(,%eax,4),%eax
  802528:	c1 e0 0c             	shl    $0xc,%eax
  80252b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80252e:	8b 45 08             	mov    0x8(%ebp),%eax
  802531:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802534:	eb 1a                	jmp    802550 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  802536:	83 ec 08             	sub    $0x8,%esp
  802539:	68 00 10 00 00       	push   $0x1000
  80253e:	ff 75 f0             	pushl  -0x10(%ebp)
  802541:	e8 19 0a 00 00       	call   802f5f <sys_free_user_mem>
  802546:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  802549:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802550:	8b 55 08             	mov    0x8(%ebp),%edx
  802553:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802556:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  802558:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80255b:	77 d9                	ja     802536 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80255d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802560:	c7 04 85 40 60 80 00 	movl   $0x0,0x806040(,%eax,4)
  802567:	00 00 00 00 
  80256b:	eb 01                	jmp    80256e <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80256d:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 58             	sub    $0x58,%esp
  802576:	8b 45 10             	mov    0x10(%ebp),%eax
  802579:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80257c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802580:	75 0a                	jne    80258c <smalloc+0x1c>
		return NULL;
  802582:	b8 00 00 00 00       	mov    $0x0,%eax
  802587:	e9 7d 01 00 00       	jmp    802709 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80258c:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  802593:	8b 55 0c             	mov    0xc(%ebp),%edx
  802596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802599:	01 d0                	add    %edx,%eax
  80259b:	48                   	dec    %eax
  80259c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80259f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8025a7:	f7 75 e4             	divl   -0x1c(%ebp)
  8025aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025ad:	29 d0                	sub    %edx,%eax
  8025af:	c1 e8 0c             	shr    $0xc,%eax
  8025b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8025b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8025bc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8025c3:	a1 20 60 80 00       	mov    0x806020,%eax
  8025c8:	8b 40 7c             	mov    0x7c(%eax),%eax
  8025cb:	05 00 10 00 00       	add    $0x1000,%eax
  8025d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8025d3:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8025d8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8025db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8025de:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8025e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8025eb:	01 d0                	add    %edx,%eax
  8025ed:	48                   	dec    %eax
  8025ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8025f1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8025f9:	f7 75 d0             	divl   -0x30(%ebp)
  8025fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8025ff:	29 d0                	sub    %edx,%eax
  802601:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802604:	76 0a                	jbe    802610 <smalloc+0xa0>
		return NULL;
  802606:	b8 00 00 00 00       	mov    $0x0,%eax
  80260b:	e9 f9 00 00 00       	jmp    802709 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802610:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802613:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802616:	eb 48                	jmp    802660 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802618:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80261e:	c1 e8 0c             	shr    $0xc,%eax
  802621:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  802624:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802627:	8b 04 85 40 60 90 00 	mov    0x906040(,%eax,4),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	75 11                	jne    802643 <smalloc+0xd3>
			freePagesCount++;
  802632:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802635:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802639:	75 16                	jne    802651 <smalloc+0xe1>
				start = s;
  80263b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802641:	eb 0e                	jmp    802651 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  802643:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80264a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802657:	74 12                	je     80266b <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802659:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802660:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802667:	76 af                	jbe    802618 <smalloc+0xa8>
  802669:	eb 01                	jmp    80266c <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80266b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80266c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802670:	74 08                	je     80267a <smalloc+0x10a>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802678:	74 0a                	je     802684 <smalloc+0x114>
		return NULL;
  80267a:	b8 00 00 00 00       	mov    $0x0,%eax
  80267f:	e9 85 00 00 00       	jmp    802709 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802687:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80268a:	c1 e8 0c             	shr    $0xc,%eax
  80268d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  802690:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802693:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802696:	89 14 85 40 60 80 00 	mov    %edx,0x806040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80269d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026a3:	eb 11                	jmp    8026b6 <smalloc+0x146>
		markedPages[s] = 1;
  8026a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a8:	c7 04 85 40 60 90 00 	movl   $0x1,0x906040(,%eax,4)
  8026af:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8026b3:	ff 45 e8             	incl   -0x18(%ebp)
  8026b6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8026b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026bc:	01 d0                	add    %edx,%eax
  8026be:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026c1:	77 e2                	ja     8026a5 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8026c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026c6:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8026ca:	52                   	push   %edx
  8026cb:	50                   	push   %eax
  8026cc:	ff 75 0c             	pushl  0xc(%ebp)
  8026cf:	ff 75 08             	pushl  0x8(%ebp)
  8026d2:	e8 8f 04 00 00       	call   802b66 <sys_createSharedObject>
  8026d7:	83 c4 10             	add    $0x10,%esp
  8026da:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8026dd:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8026e1:	78 12                	js     8026f5 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8026e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8026e6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8026e9:	89 14 85 40 60 88 00 	mov    %edx,0x886040(,%eax,4)
		return (void*) start;
  8026f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f3:	eb 14                	jmp    802709 <smalloc+0x199>
	}
	free((void*) start);
  8026f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f8:	83 ec 0c             	sub    $0xc,%esp
  8026fb:	50                   	push   %eax
  8026fc:	e8 6e fd ff ff       	call   80246f <free>
  802701:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802704:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
  80270e:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  802711:	83 ec 08             	sub    $0x8,%esp
  802714:	ff 75 0c             	pushl  0xc(%ebp)
  802717:	ff 75 08             	pushl  0x8(%ebp)
  80271a:	e8 71 04 00 00       	call   802b90 <sys_getSizeOfSharedObject>
  80271f:	83 c4 10             	add    $0x10,%esp
  802722:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802725:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80272c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80272f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802732:	01 d0                	add    %edx,%eax
  802734:	48                   	dec    %eax
  802735:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802738:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80273b:	ba 00 00 00 00       	mov    $0x0,%edx
  802740:	f7 75 e0             	divl   -0x20(%ebp)
  802743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802746:	29 d0                	sub    %edx,%eax
  802748:	c1 e8 0c             	shr    $0xc,%eax
  80274b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80274e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802755:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80275c:	a1 20 60 80 00       	mov    0x806020,%eax
  802761:	8b 40 7c             	mov    0x7c(%eax),%eax
  802764:	05 00 10 00 00       	add    $0x1000,%eax
  802769:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80276c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802771:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802774:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802777:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80277e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802781:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802784:	01 d0                	add    %edx,%eax
  802786:	48                   	dec    %eax
  802787:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80278a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80278d:	ba 00 00 00 00       	mov    $0x0,%edx
  802792:	f7 75 cc             	divl   -0x34(%ebp)
  802795:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802798:	29 d0                	sub    %edx,%eax
  80279a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80279d:	76 0a                	jbe    8027a9 <sget+0x9e>
		return NULL;
  80279f:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a4:	e9 f7 00 00 00       	jmp    8028a0 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8027a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8027af:	eb 48                	jmp    8027f9 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8027b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8027b7:	c1 e8 0c             	shr    $0xc,%eax
  8027ba:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8027bd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027c0:	8b 04 85 40 60 90 00 	mov    0x906040(,%eax,4),%eax
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	75 11                	jne    8027dc <sget+0xd1>
			free_Pages_Count++;
  8027cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8027ce:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8027d2:	75 16                	jne    8027ea <sget+0xdf>
				start = s;
  8027d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027da:	eb 0e                	jmp    8027ea <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8027dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8027e3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8027ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ed:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8027f0:	74 12                	je     802804 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8027f2:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8027f9:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802800:	76 af                	jbe    8027b1 <sget+0xa6>
  802802:	eb 01                	jmp    802805 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802804:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802805:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802809:	74 08                	je     802813 <sget+0x108>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802811:	74 0a                	je     80281d <sget+0x112>
		return NULL;
  802813:	b8 00 00 00 00       	mov    $0x0,%eax
  802818:	e9 83 00 00 00       	jmp    8028a0 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802823:	c1 e8 0c             	shr    $0xc,%eax
  802826:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802829:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80282c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80282f:	89 14 85 40 60 80 00 	mov    %edx,0x806040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802836:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802839:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80283c:	eb 11                	jmp    80284f <sget+0x144>
		markedPages[k] = 1;
  80283e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802841:	c7 04 85 40 60 90 00 	movl   $0x1,0x906040(,%eax,4)
  802848:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80284c:	ff 45 e8             	incl   -0x18(%ebp)
  80284f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802852:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802855:	01 d0                	add    %edx,%eax
  802857:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80285a:	77 e2                	ja     80283e <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	50                   	push   %eax
  802863:	ff 75 0c             	pushl  0xc(%ebp)
  802866:	ff 75 08             	pushl  0x8(%ebp)
  802869:	e8 3f 03 00 00       	call   802bad <sys_getSharedObject>
  80286e:	83 c4 10             	add    $0x10,%esp
  802871:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802874:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802878:	78 12                	js     80288c <sget+0x181>
		shardIDs[startPage] = ss;
  80287a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80287d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802880:	89 14 85 40 60 88 00 	mov    %edx,0x886040(,%eax,4)
		return (void*) start;
  802887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288a:	eb 14                	jmp    8028a0 <sget+0x195>
	}
	free((void*) start);
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	83 ec 0c             	sub    $0xc,%esp
  802892:	50                   	push   %eax
  802893:	e8 d7 fb ff ff       	call   80246f <free>
  802898:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80289b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028a0:	c9                   	leave  
  8028a1:	c3                   	ret    

008028a2 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8028a2:	55                   	push   %ebp
  8028a3:	89 e5                	mov    %esp,%ebp
  8028a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8028a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ab:	a1 20 60 80 00       	mov    0x806020,%eax
  8028b0:	8b 40 7c             	mov    0x7c(%eax),%eax
  8028b3:	29 c2                	sub    %eax,%edx
  8028b5:	89 d0                	mov    %edx,%eax
  8028b7:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8028bc:	c1 e8 0c             	shr    $0xc,%eax
  8028bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 04 85 40 60 88 00 	mov    0x886040(,%eax,4),%eax
  8028cc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8028cf:	83 ec 08             	sub    $0x8,%esp
  8028d2:	ff 75 08             	pushl  0x8(%ebp)
  8028d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8028d8:	e8 ef 02 00 00       	call   802bcc <sys_freeSharedObject>
  8028dd:	83 c4 10             	add    $0x10,%esp
  8028e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8028e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028e7:	75 0e                	jne    8028f7 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	c7 04 85 40 60 88 00 	movl   $0xffffffff,0x886040(,%eax,4)
  8028f3:	ff ff ff ff 
	}

}
  8028f7:	90                   	nop
  8028f8:	c9                   	leave  
  8028f9:	c3                   	ret    

008028fa <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802900:	83 ec 04             	sub    $0x4,%esp
  802903:	68 00 58 80 00       	push   $0x805800
  802908:	68 19 01 00 00       	push   $0x119
  80290d:	68 f2 57 80 00       	push   $0x8057f2
  802912:	e8 35 e9 ff ff       	call   80124c <_panic>

00802917 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802917:	55                   	push   %ebp
  802918:	89 e5                	mov    %esp,%ebp
  80291a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80291d:	83 ec 04             	sub    $0x4,%esp
  802920:	68 26 58 80 00       	push   $0x805826
  802925:	68 23 01 00 00       	push   $0x123
  80292a:	68 f2 57 80 00       	push   $0x8057f2
  80292f:	e8 18 e9 ff ff       	call   80124c <_panic>

00802934 <shrink>:

}
void shrink(uint32 newSize) {
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	68 26 58 80 00       	push   $0x805826
  802942:	68 27 01 00 00       	push   $0x127
  802947:	68 f2 57 80 00       	push   $0x8057f2
  80294c:	e8 fb e8 ff ff       	call   80124c <_panic>

00802951 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802957:	83 ec 04             	sub    $0x4,%esp
  80295a:	68 26 58 80 00       	push   $0x805826
  80295f:	68 2b 01 00 00       	push   $0x12b
  802964:	68 f2 57 80 00       	push   $0x8057f2
  802969:	e8 de e8 ff ff       	call   80124c <_panic>

0080296e <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	57                   	push   %edi
  802972:	56                   	push   %esi
  802973:	53                   	push   %ebx
  802974:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80297d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802980:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802983:	8b 7d 18             	mov    0x18(%ebp),%edi
  802986:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802989:	cd 30                	int    $0x30
  80298b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80298e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802991:	83 c4 10             	add    $0x10,%esp
  802994:	5b                   	pop    %ebx
  802995:	5e                   	pop    %esi
  802996:	5f                   	pop    %edi
  802997:	5d                   	pop    %ebp
  802998:	c3                   	ret    

00802999 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  802999:	55                   	push   %ebp
  80299a:	89 e5                	mov    %esp,%ebp
  80299c:	83 ec 04             	sub    $0x4,%esp
  80299f:	8b 45 10             	mov    0x10(%ebp),%eax
  8029a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8029a5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	6a 00                	push   $0x0
  8029ae:	6a 00                	push   $0x0
  8029b0:	52                   	push   %edx
  8029b1:	ff 75 0c             	pushl  0xc(%ebp)
  8029b4:	50                   	push   %eax
  8029b5:	6a 00                	push   $0x0
  8029b7:	e8 b2 ff ff ff       	call   80296e <syscall>
  8029bc:	83 c4 18             	add    $0x18,%esp
}
  8029bf:	90                   	nop
  8029c0:	c9                   	leave  
  8029c1:	c3                   	ret    

008029c2 <sys_cgetc>:

int sys_cgetc(void) {
  8029c2:	55                   	push   %ebp
  8029c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8029c5:	6a 00                	push   $0x0
  8029c7:	6a 00                	push   $0x0
  8029c9:	6a 00                	push   $0x0
  8029cb:	6a 00                	push   $0x0
  8029cd:	6a 00                	push   $0x0
  8029cf:	6a 02                	push   $0x2
  8029d1:	e8 98 ff ff ff       	call   80296e <syscall>
  8029d6:	83 c4 18             	add    $0x18,%esp
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    

008029db <sys_lock_cons>:

void sys_lock_cons(void) {
  8029db:	55                   	push   %ebp
  8029dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8029de:	6a 00                	push   $0x0
  8029e0:	6a 00                	push   $0x0
  8029e2:	6a 00                	push   $0x0
  8029e4:	6a 00                	push   $0x0
  8029e6:	6a 00                	push   $0x0
  8029e8:	6a 03                	push   $0x3
  8029ea:	e8 7f ff ff ff       	call   80296e <syscall>
  8029ef:	83 c4 18             	add    $0x18,%esp
}
  8029f2:	90                   	nop
  8029f3:	c9                   	leave  
  8029f4:	c3                   	ret    

008029f5 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8029f5:	55                   	push   %ebp
  8029f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8029f8:	6a 00                	push   $0x0
  8029fa:	6a 00                	push   $0x0
  8029fc:	6a 00                	push   $0x0
  8029fe:	6a 00                	push   $0x0
  802a00:	6a 00                	push   $0x0
  802a02:	6a 04                	push   $0x4
  802a04:	e8 65 ff ff ff       	call   80296e <syscall>
  802a09:	83 c4 18             	add    $0x18,%esp
}
  802a0c:	90                   	nop
  802a0d:	c9                   	leave  
  802a0e:	c3                   	ret    

00802a0f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802a0f:	55                   	push   %ebp
  802a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	6a 00                	push   $0x0
  802a1a:	6a 00                	push   $0x0
  802a1c:	6a 00                	push   $0x0
  802a1e:	52                   	push   %edx
  802a1f:	50                   	push   %eax
  802a20:	6a 08                	push   $0x8
  802a22:	e8 47 ff ff ff       	call   80296e <syscall>
  802a27:	83 c4 18             	add    $0x18,%esp
}
  802a2a:	c9                   	leave  
  802a2b:	c3                   	ret    

00802a2c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802a2c:	55                   	push   %ebp
  802a2d:	89 e5                	mov    %esp,%ebp
  802a2f:	56                   	push   %esi
  802a30:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802a31:	8b 75 18             	mov    0x18(%ebp),%esi
  802a34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	56                   	push   %esi
  802a41:	53                   	push   %ebx
  802a42:	51                   	push   %ecx
  802a43:	52                   	push   %edx
  802a44:	50                   	push   %eax
  802a45:	6a 09                	push   $0x9
  802a47:	e8 22 ff ff ff       	call   80296e <syscall>
  802a4c:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802a52:	5b                   	pop    %ebx
  802a53:	5e                   	pop    %esi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    

00802a56 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	6a 00                	push   $0x0
  802a61:	6a 00                	push   $0x0
  802a63:	6a 00                	push   $0x0
  802a65:	52                   	push   %edx
  802a66:	50                   	push   %eax
  802a67:	6a 0a                	push   $0xa
  802a69:	e8 00 ff ff ff       	call   80296e <syscall>
  802a6e:	83 c4 18             	add    $0x18,%esp
}
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  802a76:	6a 00                	push   $0x0
  802a78:	6a 00                	push   $0x0
  802a7a:	6a 00                	push   $0x0
  802a7c:	ff 75 0c             	pushl  0xc(%ebp)
  802a7f:	ff 75 08             	pushl  0x8(%ebp)
  802a82:	6a 0b                	push   $0xb
  802a84:	e8 e5 fe ff ff       	call   80296e <syscall>
  802a89:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  802a8c:	c9                   	leave  
  802a8d:	c3                   	ret    

00802a8e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  802a8e:	55                   	push   %ebp
  802a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802a91:	6a 00                	push   $0x0
  802a93:	6a 00                	push   $0x0
  802a95:	6a 00                	push   $0x0
  802a97:	6a 00                	push   $0x0
  802a99:	6a 00                	push   $0x0
  802a9b:	6a 0c                	push   $0xc
  802a9d:	e8 cc fe ff ff       	call   80296e <syscall>
  802aa2:	83 c4 18             	add    $0x18,%esp
}
  802aa5:	c9                   	leave  
  802aa6:	c3                   	ret    

00802aa7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  802aa7:	55                   	push   %ebp
  802aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802aaa:	6a 00                	push   $0x0
  802aac:	6a 00                	push   $0x0
  802aae:	6a 00                	push   $0x0
  802ab0:	6a 00                	push   $0x0
  802ab2:	6a 00                	push   $0x0
  802ab4:	6a 0d                	push   $0xd
  802ab6:	e8 b3 fe ff ff       	call   80296e <syscall>
  802abb:	83 c4 18             	add    $0x18,%esp
}
  802abe:	c9                   	leave  
  802abf:	c3                   	ret    

00802ac0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802ac3:	6a 00                	push   $0x0
  802ac5:	6a 00                	push   $0x0
  802ac7:	6a 00                	push   $0x0
  802ac9:	6a 00                	push   $0x0
  802acb:	6a 00                	push   $0x0
  802acd:	6a 0e                	push   $0xe
  802acf:	e8 9a fe ff ff       	call   80296e <syscall>
  802ad4:	83 c4 18             	add    $0x18,%esp
}
  802ad7:	c9                   	leave  
  802ad8:	c3                   	ret    

00802ad9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  802ad9:	55                   	push   %ebp
  802ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  802adc:	6a 00                	push   $0x0
  802ade:	6a 00                	push   $0x0
  802ae0:	6a 00                	push   $0x0
  802ae2:	6a 00                	push   $0x0
  802ae4:	6a 00                	push   $0x0
  802ae6:	6a 0f                	push   $0xf
  802ae8:	e8 81 fe ff ff       	call   80296e <syscall>
  802aed:	83 c4 18             	add    $0x18,%esp
}
  802af0:	c9                   	leave  
  802af1:	c3                   	ret    

00802af2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  802af2:	55                   	push   %ebp
  802af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  802af5:	6a 00                	push   $0x0
  802af7:	6a 00                	push   $0x0
  802af9:	6a 00                	push   $0x0
  802afb:	6a 00                	push   $0x0
  802afd:	ff 75 08             	pushl  0x8(%ebp)
  802b00:	6a 10                	push   $0x10
  802b02:	e8 67 fe ff ff       	call   80296e <syscall>
  802b07:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <sys_scarce_memory>:

void sys_scarce_memory() {
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  802b0f:	6a 00                	push   $0x0
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	6a 00                	push   $0x0
  802b19:	6a 11                	push   $0x11
  802b1b:	e8 4e fe ff ff       	call   80296e <syscall>
  802b20:	83 c4 18             	add    $0x18,%esp
}
  802b23:	90                   	nop
  802b24:	c9                   	leave  
  802b25:	c3                   	ret    

00802b26 <sys_cputc>:

void sys_cputc(const char c) {
  802b26:	55                   	push   %ebp
  802b27:	89 e5                	mov    %esp,%ebp
  802b29:	83 ec 04             	sub    $0x4,%esp
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802b32:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	50                   	push   %eax
  802b3f:	6a 01                	push   $0x1
  802b41:	e8 28 fe ff ff       	call   80296e <syscall>
  802b46:	83 c4 18             	add    $0x18,%esp
}
  802b49:	90                   	nop
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 14                	push   $0x14
  802b5b:	e8 0e fe ff ff       	call   80296e <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
}
  802b63:	90                   	nop
  802b64:	c9                   	leave  
  802b65:	c3                   	ret    

00802b66 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	83 ec 04             	sub    $0x4,%esp
  802b6c:	8b 45 10             	mov    0x10(%ebp),%eax
  802b6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  802b72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802b75:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	6a 00                	push   $0x0
  802b7e:	51                   	push   %ecx
  802b7f:	52                   	push   %edx
  802b80:	ff 75 0c             	pushl  0xc(%ebp)
  802b83:	50                   	push   %eax
  802b84:	6a 15                	push   $0x15
  802b86:	e8 e3 fd ff ff       	call   80296e <syscall>
  802b8b:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  802b8e:	c9                   	leave  
  802b8f:	c3                   	ret    

00802b90 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  802b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	6a 00                	push   $0x0
  802b9b:	6a 00                	push   $0x0
  802b9d:	6a 00                	push   $0x0
  802b9f:	52                   	push   %edx
  802ba0:	50                   	push   %eax
  802ba1:	6a 16                	push   $0x16
  802ba3:	e8 c6 fd ff ff       	call   80296e <syscall>
  802ba8:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  802bab:	c9                   	leave  
  802bac:	c3                   	ret    

00802bad <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  802bad:	55                   	push   %ebp
  802bae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  802bb0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	6a 00                	push   $0x0
  802bbb:	6a 00                	push   $0x0
  802bbd:	51                   	push   %ecx
  802bbe:	52                   	push   %edx
  802bbf:	50                   	push   %eax
  802bc0:	6a 17                	push   $0x17
  802bc2:	e8 a7 fd ff ff       	call   80296e <syscall>
  802bc7:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  802bca:	c9                   	leave  
  802bcb:	c3                   	ret    

00802bcc <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  802bcc:	55                   	push   %ebp
  802bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  802bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	6a 00                	push   $0x0
  802bd7:	6a 00                	push   $0x0
  802bd9:	6a 00                	push   $0x0
  802bdb:	52                   	push   %edx
  802bdc:	50                   	push   %eax
  802bdd:	6a 18                	push   $0x18
  802bdf:	e8 8a fd ff ff       	call   80296e <syscall>
  802be4:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  802be7:	c9                   	leave  
  802be8:	c3                   	ret    

00802be9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  802be9:	55                   	push   %ebp
  802bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	6a 00                	push   $0x0
  802bf1:	ff 75 14             	pushl  0x14(%ebp)
  802bf4:	ff 75 10             	pushl  0x10(%ebp)
  802bf7:	ff 75 0c             	pushl  0xc(%ebp)
  802bfa:	50                   	push   %eax
  802bfb:	6a 19                	push   $0x19
  802bfd:	e8 6c fd ff ff       	call   80296e <syscall>
  802c02:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  802c05:	c9                   	leave  
  802c06:	c3                   	ret    

00802c07 <sys_run_env>:

void sys_run_env(int32 envId) {
  802c07:	55                   	push   %ebp
  802c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	6a 00                	push   $0x0
  802c0f:	6a 00                	push   $0x0
  802c11:	6a 00                	push   $0x0
  802c13:	6a 00                	push   $0x0
  802c15:	50                   	push   %eax
  802c16:	6a 1a                	push   $0x1a
  802c18:	e8 51 fd ff ff       	call   80296e <syscall>
  802c1d:	83 c4 18             	add    $0x18,%esp
}
  802c20:	90                   	nop
  802c21:	c9                   	leave  
  802c22:	c3                   	ret    

00802c23 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	6a 00                	push   $0x0
  802c2b:	6a 00                	push   $0x0
  802c2d:	6a 00                	push   $0x0
  802c2f:	6a 00                	push   $0x0
  802c31:	50                   	push   %eax
  802c32:	6a 1b                	push   $0x1b
  802c34:	e8 35 fd ff ff       	call   80296e <syscall>
  802c39:	83 c4 18             	add    $0x18,%esp
}
  802c3c:	c9                   	leave  
  802c3d:	c3                   	ret    

00802c3e <sys_getenvid>:

int32 sys_getenvid(void) {
  802c3e:	55                   	push   %ebp
  802c3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802c41:	6a 00                	push   $0x0
  802c43:	6a 00                	push   $0x0
  802c45:	6a 00                	push   $0x0
  802c47:	6a 00                	push   $0x0
  802c49:	6a 00                	push   $0x0
  802c4b:	6a 05                	push   $0x5
  802c4d:	e8 1c fd ff ff       	call   80296e <syscall>
  802c52:	83 c4 18             	add    $0x18,%esp
}
  802c55:	c9                   	leave  
  802c56:	c3                   	ret    

00802c57 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  802c57:	55                   	push   %ebp
  802c58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802c5a:	6a 00                	push   $0x0
  802c5c:	6a 00                	push   $0x0
  802c5e:	6a 00                	push   $0x0
  802c60:	6a 00                	push   $0x0
  802c62:	6a 00                	push   $0x0
  802c64:	6a 06                	push   $0x6
  802c66:	e8 03 fd ff ff       	call   80296e <syscall>
  802c6b:	83 c4 18             	add    $0x18,%esp
}
  802c6e:	c9                   	leave  
  802c6f:	c3                   	ret    

00802c70 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802c73:	6a 00                	push   $0x0
  802c75:	6a 00                	push   $0x0
  802c77:	6a 00                	push   $0x0
  802c79:	6a 00                	push   $0x0
  802c7b:	6a 00                	push   $0x0
  802c7d:	6a 07                	push   $0x7
  802c7f:	e8 ea fc ff ff       	call   80296e <syscall>
  802c84:	83 c4 18             	add    $0x18,%esp
}
  802c87:	c9                   	leave  
  802c88:	c3                   	ret    

00802c89 <sys_exit_env>:

void sys_exit_env(void) {
  802c89:	55                   	push   %ebp
  802c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802c8c:	6a 00                	push   $0x0
  802c8e:	6a 00                	push   $0x0
  802c90:	6a 00                	push   $0x0
  802c92:	6a 00                	push   $0x0
  802c94:	6a 00                	push   $0x0
  802c96:	6a 1c                	push   $0x1c
  802c98:	e8 d1 fc ff ff       	call   80296e <syscall>
  802c9d:	83 c4 18             	add    $0x18,%esp
}
  802ca0:	90                   	nop
  802ca1:	c9                   	leave  
  802ca2:	c3                   	ret    

00802ca3 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  802ca3:	55                   	push   %ebp
  802ca4:	89 e5                	mov    %esp,%ebp
  802ca6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  802ca9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802cac:	8d 50 04             	lea    0x4(%eax),%edx
  802caf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802cb2:	6a 00                	push   $0x0
  802cb4:	6a 00                	push   $0x0
  802cb6:	6a 00                	push   $0x0
  802cb8:	52                   	push   %edx
  802cb9:	50                   	push   %eax
  802cba:	6a 1d                	push   $0x1d
  802cbc:	e8 ad fc ff ff       	call   80296e <syscall>
  802cc1:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  802cc4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802cca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802ccd:	89 01                	mov    %eax,(%ecx)
  802ccf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	c9                   	leave  
  802cd6:	c2 04 00             	ret    $0x4

00802cd9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  802cd9:	55                   	push   %ebp
  802cda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  802cdc:	6a 00                	push   $0x0
  802cde:	6a 00                	push   $0x0
  802ce0:	ff 75 10             	pushl  0x10(%ebp)
  802ce3:	ff 75 0c             	pushl  0xc(%ebp)
  802ce6:	ff 75 08             	pushl  0x8(%ebp)
  802ce9:	6a 13                	push   $0x13
  802ceb:	e8 7e fc ff ff       	call   80296e <syscall>
  802cf0:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  802cf3:	90                   	nop
}
  802cf4:	c9                   	leave  
  802cf5:	c3                   	ret    

00802cf6 <sys_rcr2>:
uint32 sys_rcr2() {
  802cf6:	55                   	push   %ebp
  802cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802cf9:	6a 00                	push   $0x0
  802cfb:	6a 00                	push   $0x0
  802cfd:	6a 00                	push   $0x0
  802cff:	6a 00                	push   $0x0
  802d01:	6a 00                	push   $0x0
  802d03:	6a 1e                	push   $0x1e
  802d05:	e8 64 fc ff ff       	call   80296e <syscall>
  802d0a:	83 c4 18             	add    $0x18,%esp
}
  802d0d:	c9                   	leave  
  802d0e:	c3                   	ret    

00802d0f <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  802d0f:	55                   	push   %ebp
  802d10:	89 e5                	mov    %esp,%ebp
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802d1b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802d1f:	6a 00                	push   $0x0
  802d21:	6a 00                	push   $0x0
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	50                   	push   %eax
  802d28:	6a 1f                	push   $0x1f
  802d2a:	e8 3f fc ff ff       	call   80296e <syscall>
  802d2f:	83 c4 18             	add    $0x18,%esp
	return;
  802d32:	90                   	nop
}
  802d33:	c9                   	leave  
  802d34:	c3                   	ret    

00802d35 <rsttst>:
void rsttst() {
  802d35:	55                   	push   %ebp
  802d36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802d38:	6a 00                	push   $0x0
  802d3a:	6a 00                	push   $0x0
  802d3c:	6a 00                	push   $0x0
  802d3e:	6a 00                	push   $0x0
  802d40:	6a 00                	push   $0x0
  802d42:	6a 21                	push   $0x21
  802d44:	e8 25 fc ff ff       	call   80296e <syscall>
  802d49:	83 c4 18             	add    $0x18,%esp
	return;
  802d4c:	90                   	nop
}
  802d4d:	c9                   	leave  
  802d4e:	c3                   	ret    

00802d4f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  802d4f:	55                   	push   %ebp
  802d50:	89 e5                	mov    %esp,%ebp
  802d52:	83 ec 04             	sub    $0x4,%esp
  802d55:	8b 45 14             	mov    0x14(%ebp),%eax
  802d58:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802d5b:	8b 55 18             	mov    0x18(%ebp),%edx
  802d5e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802d62:	52                   	push   %edx
  802d63:	50                   	push   %eax
  802d64:	ff 75 10             	pushl  0x10(%ebp)
  802d67:	ff 75 0c             	pushl  0xc(%ebp)
  802d6a:	ff 75 08             	pushl  0x8(%ebp)
  802d6d:	6a 20                	push   $0x20
  802d6f:	e8 fa fb ff ff       	call   80296e <syscall>
  802d74:	83 c4 18             	add    $0x18,%esp
	return;
  802d77:	90                   	nop
}
  802d78:	c9                   	leave  
  802d79:	c3                   	ret    

00802d7a <chktst>:
void chktst(uint32 n) {
  802d7a:	55                   	push   %ebp
  802d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802d7d:	6a 00                	push   $0x0
  802d7f:	6a 00                	push   $0x0
  802d81:	6a 00                	push   $0x0
  802d83:	6a 00                	push   $0x0
  802d85:	ff 75 08             	pushl  0x8(%ebp)
  802d88:	6a 22                	push   $0x22
  802d8a:	e8 df fb ff ff       	call   80296e <syscall>
  802d8f:	83 c4 18             	add    $0x18,%esp
	return;
  802d92:	90                   	nop
}
  802d93:	c9                   	leave  
  802d94:	c3                   	ret    

00802d95 <inctst>:

void inctst() {
  802d95:	55                   	push   %ebp
  802d96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802d98:	6a 00                	push   $0x0
  802d9a:	6a 00                	push   $0x0
  802d9c:	6a 00                	push   $0x0
  802d9e:	6a 00                	push   $0x0
  802da0:	6a 00                	push   $0x0
  802da2:	6a 23                	push   $0x23
  802da4:	e8 c5 fb ff ff       	call   80296e <syscall>
  802da9:	83 c4 18             	add    $0x18,%esp
	return;
  802dac:	90                   	nop
}
  802dad:	c9                   	leave  
  802dae:	c3                   	ret    

00802daf <gettst>:
uint32 gettst() {
  802daf:	55                   	push   %ebp
  802db0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802db2:	6a 00                	push   $0x0
  802db4:	6a 00                	push   $0x0
  802db6:	6a 00                	push   $0x0
  802db8:	6a 00                	push   $0x0
  802dba:	6a 00                	push   $0x0
  802dbc:	6a 24                	push   $0x24
  802dbe:	e8 ab fb ff ff       	call   80296e <syscall>
  802dc3:	83 c4 18             	add    $0x18,%esp
}
  802dc6:	c9                   	leave  
  802dc7:	c3                   	ret    

00802dc8 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  802dc8:	55                   	push   %ebp
  802dc9:	89 e5                	mov    %esp,%ebp
  802dcb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 00                	push   $0x0
  802dd6:	6a 00                	push   $0x0
  802dd8:	6a 25                	push   $0x25
  802dda:	e8 8f fb ff ff       	call   80296e <syscall>
  802ddf:	83 c4 18             	add    $0x18,%esp
  802de2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802de5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802de9:	75 07                	jne    802df2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802deb:	b8 01 00 00 00       	mov    $0x1,%eax
  802df0:	eb 05                	jmp    802df7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df7:	c9                   	leave  
  802df8:	c3                   	ret    

00802df9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  802df9:	55                   	push   %ebp
  802dfa:	89 e5                	mov    %esp,%ebp
  802dfc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 00                	push   $0x0
  802e09:	6a 25                	push   $0x25
  802e0b:	e8 5e fb ff ff       	call   80296e <syscall>
  802e10:	83 c4 18             	add    $0x18,%esp
  802e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802e16:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802e1a:	75 07                	jne    802e23 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802e1c:	b8 01 00 00 00       	mov    $0x1,%eax
  802e21:	eb 05                	jmp    802e28 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802e23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e28:	c9                   	leave  
  802e29:	c3                   	ret    

00802e2a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802e2a:	55                   	push   %ebp
  802e2b:	89 e5                	mov    %esp,%ebp
  802e2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e30:	6a 00                	push   $0x0
  802e32:	6a 00                	push   $0x0
  802e34:	6a 00                	push   $0x0
  802e36:	6a 00                	push   $0x0
  802e38:	6a 00                	push   $0x0
  802e3a:	6a 25                	push   $0x25
  802e3c:	e8 2d fb ff ff       	call   80296e <syscall>
  802e41:	83 c4 18             	add    $0x18,%esp
  802e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802e47:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802e4b:	75 07                	jne    802e54 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802e4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802e52:	eb 05                	jmp    802e59 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802e54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e59:	c9                   	leave  
  802e5a:	c3                   	ret    

00802e5b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
  802e5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802e61:	6a 00                	push   $0x0
  802e63:	6a 00                	push   $0x0
  802e65:	6a 00                	push   $0x0
  802e67:	6a 00                	push   $0x0
  802e69:	6a 00                	push   $0x0
  802e6b:	6a 25                	push   $0x25
  802e6d:	e8 fc fa ff ff       	call   80296e <syscall>
  802e72:	83 c4 18             	add    $0x18,%esp
  802e75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802e78:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802e7c:	75 07                	jne    802e85 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802e7e:	b8 01 00 00 00       	mov    $0x1,%eax
  802e83:	eb 05                	jmp    802e8a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802e85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e8a:	c9                   	leave  
  802e8b:	c3                   	ret    

00802e8c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802e8c:	55                   	push   %ebp
  802e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802e8f:	6a 00                	push   $0x0
  802e91:	6a 00                	push   $0x0
  802e93:	6a 00                	push   $0x0
  802e95:	6a 00                	push   $0x0
  802e97:	ff 75 08             	pushl  0x8(%ebp)
  802e9a:	6a 26                	push   $0x26
  802e9c:	e8 cd fa ff ff       	call   80296e <syscall>
  802ea1:	83 c4 18             	add    $0x18,%esp
	return;
  802ea4:	90                   	nop
}
  802ea5:	c9                   	leave  
  802ea6:	c3                   	ret    

00802ea7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802ea7:	55                   	push   %ebp
  802ea8:	89 e5                	mov    %esp,%ebp
  802eaa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802eab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802eae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	6a 00                	push   $0x0
  802eb9:	53                   	push   %ebx
  802eba:	51                   	push   %ecx
  802ebb:	52                   	push   %edx
  802ebc:	50                   	push   %eax
  802ebd:	6a 27                	push   $0x27
  802ebf:	e8 aa fa ff ff       	call   80296e <syscall>
  802ec4:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  802ec7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802eca:	c9                   	leave  
  802ecb:	c3                   	ret    

00802ecc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  802ecc:	55                   	push   %ebp
  802ecd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  802ecf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	6a 00                	push   $0x0
  802ed7:	6a 00                	push   $0x0
  802ed9:	6a 00                	push   $0x0
  802edb:	52                   	push   %edx
  802edc:	50                   	push   %eax
  802edd:	6a 28                	push   $0x28
  802edf:	e8 8a fa ff ff       	call   80296e <syscall>
  802ee4:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  802ee7:	c9                   	leave  
  802ee8:	c3                   	ret    

00802ee9 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  802ee9:	55                   	push   %ebp
  802eea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  802eec:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	6a 00                	push   $0x0
  802ef7:	51                   	push   %ecx
  802ef8:	ff 75 10             	pushl  0x10(%ebp)
  802efb:	52                   	push   %edx
  802efc:	50                   	push   %eax
  802efd:	6a 29                	push   $0x29
  802eff:	e8 6a fa ff ff       	call   80296e <syscall>
  802f04:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  802f07:	c9                   	leave  
  802f08:	c3                   	ret    

00802f09 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  802f09:	55                   	push   %ebp
  802f0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802f0c:	6a 00                	push   $0x0
  802f0e:	6a 00                	push   $0x0
  802f10:	ff 75 10             	pushl  0x10(%ebp)
  802f13:	ff 75 0c             	pushl  0xc(%ebp)
  802f16:	ff 75 08             	pushl  0x8(%ebp)
  802f19:	6a 12                	push   $0x12
  802f1b:	e8 4e fa ff ff       	call   80296e <syscall>
  802f20:	83 c4 18             	add    $0x18,%esp
	return;
  802f23:	90                   	nop
}
  802f24:	c9                   	leave  
  802f25:	c3                   	ret    

00802f26 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	6a 00                	push   $0x0
  802f31:	6a 00                	push   $0x0
  802f33:	6a 00                	push   $0x0
  802f35:	52                   	push   %edx
  802f36:	50                   	push   %eax
  802f37:	6a 2a                	push   $0x2a
  802f39:	e8 30 fa ff ff       	call   80296e <syscall>
  802f3e:	83 c4 18             	add    $0x18,%esp
	return;
  802f41:	90                   	nop
}
  802f42:	c9                   	leave  
  802f43:	c3                   	ret    

00802f44 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802f44:	55                   	push   %ebp
  802f45:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	50                   	push   %eax
  802f53:	6a 2b                	push   $0x2b
  802f55:	e8 14 fa ff ff       	call   80296e <syscall>
  802f5a:	83 c4 18             	add    $0x18,%esp
}
  802f5d:	c9                   	leave  
  802f5e:	c3                   	ret    

00802f5f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  802f5f:	55                   	push   %ebp
  802f60:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802f62:	6a 00                	push   $0x0
  802f64:	6a 00                	push   $0x0
  802f66:	6a 00                	push   $0x0
  802f68:	ff 75 0c             	pushl  0xc(%ebp)
  802f6b:	ff 75 08             	pushl  0x8(%ebp)
  802f6e:	6a 2c                	push   $0x2c
  802f70:	e8 f9 f9 ff ff       	call   80296e <syscall>
  802f75:	83 c4 18             	add    $0x18,%esp
	return;
  802f78:	90                   	nop
}
  802f79:	c9                   	leave  
  802f7a:	c3                   	ret    

00802f7b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802f7b:	55                   	push   %ebp
  802f7c:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 00                	push   $0x0
  802f84:	ff 75 0c             	pushl  0xc(%ebp)
  802f87:	ff 75 08             	pushl  0x8(%ebp)
  802f8a:	6a 2d                	push   $0x2d
  802f8c:	e8 dd f9 ff ff       	call   80296e <syscall>
  802f91:	83 c4 18             	add    $0x18,%esp
	return;
  802f94:	90                   	nop
}
  802f95:	c9                   	leave  
  802f96:	c3                   	ret    

00802f97 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802f97:	55                   	push   %ebp
  802f98:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 00                	push   $0x0
  802fa1:	6a 00                	push   $0x0
  802fa3:	6a 00                	push   $0x0
  802fa5:	50                   	push   %eax
  802fa6:	6a 2f                	push   $0x2f
  802fa8:	e8 c1 f9 ff ff       	call   80296e <syscall>
  802fad:	83 c4 18             	add    $0x18,%esp
	return;
  802fb0:	90                   	nop
}
  802fb1:	c9                   	leave  
  802fb2:	c3                   	ret    

00802fb3 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  802fb3:	55                   	push   %ebp
  802fb4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802fb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	6a 00                	push   $0x0
  802fbe:	6a 00                	push   $0x0
  802fc0:	6a 00                	push   $0x0
  802fc2:	52                   	push   %edx
  802fc3:	50                   	push   %eax
  802fc4:	6a 30                	push   $0x30
  802fc6:	e8 a3 f9 ff ff       	call   80296e <syscall>
  802fcb:	83 c4 18             	add    $0x18,%esp
	return;
  802fce:	90                   	nop
}
  802fcf:	c9                   	leave  
  802fd0:	c3                   	ret    

00802fd1 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  802fd1:	55                   	push   %ebp
  802fd2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 00                	push   $0x0
  802fdf:	50                   	push   %eax
  802fe0:	6a 31                	push   $0x31
  802fe2:	e8 87 f9 ff ff       	call   80296e <syscall>
  802fe7:	83 c4 18             	add    $0x18,%esp
	return;
  802fea:	90                   	nop
}
  802feb:	c9                   	leave  
  802fec:	c3                   	ret    

00802fed <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802fed:	55                   	push   %ebp
  802fee:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  802ff0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	6a 00                	push   $0x0
  802ff8:	6a 00                	push   $0x0
  802ffa:	6a 00                	push   $0x0
  802ffc:	52                   	push   %edx
  802ffd:	50                   	push   %eax
  802ffe:	6a 2e                	push   $0x2e
  803000:	e8 69 f9 ff ff       	call   80296e <syscall>
  803005:	83 c4 18             	add    $0x18,%esp
    return;
  803008:	90                   	nop
}
  803009:	c9                   	leave  
  80300a:	c3                   	ret    

0080300b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80300b:	55                   	push   %ebp
  80300c:	89 e5                	mov    %esp,%ebp
  80300e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	83 e8 04             	sub    $0x4,%eax
  803017:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80301a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80301d:	8b 00                	mov    (%eax),%eax
  80301f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  803022:	c9                   	leave  
  803023:	c3                   	ret    

00803024 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  803024:	55                   	push   %ebp
  803025:	89 e5                	mov    %esp,%ebp
  803027:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	83 e8 04             	sub    $0x4,%eax
  803030:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  803033:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	83 e0 01             	and    $0x1,%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	0f 94 c0             	sete   %al
}
  803040:	c9                   	leave  
  803041:	c3                   	ret    

00803042 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  803042:	55                   	push   %ebp
  803043:	89 e5                	mov    %esp,%ebp
  803045:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  803048:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80304f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803052:	83 f8 02             	cmp    $0x2,%eax
  803055:	74 2b                	je     803082 <alloc_block+0x40>
  803057:	83 f8 02             	cmp    $0x2,%eax
  80305a:	7f 07                	jg     803063 <alloc_block+0x21>
  80305c:	83 f8 01             	cmp    $0x1,%eax
  80305f:	74 0e                	je     80306f <alloc_block+0x2d>
  803061:	eb 58                	jmp    8030bb <alloc_block+0x79>
  803063:	83 f8 03             	cmp    $0x3,%eax
  803066:	74 2d                	je     803095 <alloc_block+0x53>
  803068:	83 f8 04             	cmp    $0x4,%eax
  80306b:	74 3b                	je     8030a8 <alloc_block+0x66>
  80306d:	eb 4c                	jmp    8030bb <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80306f:	83 ec 0c             	sub    $0xc,%esp
  803072:	ff 75 08             	pushl  0x8(%ebp)
  803075:	e8 f7 03 00 00       	call   803471 <alloc_block_FF>
  80307a:	83 c4 10             	add    $0x10,%esp
  80307d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803080:	eb 4a                	jmp    8030cc <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  803082:	83 ec 0c             	sub    $0xc,%esp
  803085:	ff 75 08             	pushl  0x8(%ebp)
  803088:	e8 f0 11 00 00       	call   80427d <alloc_block_NF>
  80308d:	83 c4 10             	add    $0x10,%esp
  803090:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803093:	eb 37                	jmp    8030cc <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  803095:	83 ec 0c             	sub    $0xc,%esp
  803098:	ff 75 08             	pushl  0x8(%ebp)
  80309b:	e8 08 08 00 00       	call   8038a8 <alloc_block_BF>
  8030a0:	83 c4 10             	add    $0x10,%esp
  8030a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8030a6:	eb 24                	jmp    8030cc <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8030a8:	83 ec 0c             	sub    $0xc,%esp
  8030ab:	ff 75 08             	pushl  0x8(%ebp)
  8030ae:	e8 ad 11 00 00       	call   804260 <alloc_block_WF>
  8030b3:	83 c4 10             	add    $0x10,%esp
  8030b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8030b9:	eb 11                	jmp    8030cc <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8030bb:	83 ec 0c             	sub    $0xc,%esp
  8030be:	68 38 58 80 00       	push   $0x805838
  8030c3:	e8 41 e4 ff ff       	call   801509 <cprintf>
  8030c8:	83 c4 10             	add    $0x10,%esp
		break;
  8030cb:	90                   	nop
	}
	return va;
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8030cf:	c9                   	leave  
  8030d0:	c3                   	ret    

008030d1 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8030d1:	55                   	push   %ebp
  8030d2:	89 e5                	mov    %esp,%ebp
  8030d4:	53                   	push   %ebx
  8030d5:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8030d8:	83 ec 0c             	sub    $0xc,%esp
  8030db:	68 58 58 80 00       	push   $0x805858
  8030e0:	e8 24 e4 ff ff       	call   801509 <cprintf>
  8030e5:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8030e8:	83 ec 0c             	sub    $0xc,%esp
  8030eb:	68 83 58 80 00       	push   $0x805883
  8030f0:	e8 14 e4 ff ff       	call   801509 <cprintf>
  8030f5:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030fe:	eb 37                	jmp    803137 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  803100:	83 ec 0c             	sub    $0xc,%esp
  803103:	ff 75 f4             	pushl  -0xc(%ebp)
  803106:	e8 19 ff ff ff       	call   803024 <is_free_block>
  80310b:	83 c4 10             	add    $0x10,%esp
  80310e:	0f be d8             	movsbl %al,%ebx
  803111:	83 ec 0c             	sub    $0xc,%esp
  803114:	ff 75 f4             	pushl  -0xc(%ebp)
  803117:	e8 ef fe ff ff       	call   80300b <get_block_size>
  80311c:	83 c4 10             	add    $0x10,%esp
  80311f:	83 ec 04             	sub    $0x4,%esp
  803122:	53                   	push   %ebx
  803123:	50                   	push   %eax
  803124:	68 9b 58 80 00       	push   $0x80589b
  803129:	e8 db e3 ff ff       	call   801509 <cprintf>
  80312e:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  803131:	8b 45 10             	mov    0x10(%ebp),%eax
  803134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313b:	74 07                	je     803144 <print_blocks_list+0x73>
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	eb 05                	jmp    803149 <print_blocks_list+0x78>
  803144:	b8 00 00 00 00       	mov    $0x0,%eax
  803149:	89 45 10             	mov    %eax,0x10(%ebp)
  80314c:	8b 45 10             	mov    0x10(%ebp),%eax
  80314f:	85 c0                	test   %eax,%eax
  803151:	75 ad                	jne    803100 <print_blocks_list+0x2f>
  803153:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803157:	75 a7                	jne    803100 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803159:	83 ec 0c             	sub    $0xc,%esp
  80315c:	68 58 58 80 00       	push   $0x805858
  803161:	e8 a3 e3 ff ff       	call   801509 <cprintf>
  803166:	83 c4 10             	add    $0x10,%esp

}
  803169:	90                   	nop
  80316a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80316d:	c9                   	leave  
  80316e:	c3                   	ret    

0080316f <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80316f:	55                   	push   %ebp
  803170:	89 e5                	mov    %esp,%ebp
  803172:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  803175:	8b 45 0c             	mov    0xc(%ebp),%eax
  803178:	83 e0 01             	and    $0x1,%eax
  80317b:	85 c0                	test   %eax,%eax
  80317d:	74 03                	je     803182 <initialize_dynamic_allocator+0x13>
  80317f:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  803182:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803186:	0f 84 f8 00 00 00    	je     803284 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80318c:	c7 05 40 60 98 00 01 	movl   $0x1,0x986040
  803193:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  803196:	a1 40 60 98 00       	mov    0x986040,%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	0f 84 e2 00 00 00    	je     803285 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8031a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ac:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8031b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031b8:	01 d0                	add    %edx,%eax
  8031ba:	83 e8 04             	sub    $0x4,%eax
  8031bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8031c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	83 c0 08             	add    $0x8,%eax
  8031cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8031d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031d5:	83 e8 08             	sub    $0x8,%eax
  8031d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	6a 00                	push   $0x0
  8031e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8031e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8031e6:	e8 9c 00 00 00       	call   803287 <set_block_data>
  8031eb:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8031ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8031f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  803201:	c7 05 48 60 98 00 00 	movl   $0x0,0x986048
  803208:	00 00 00 
  80320b:	c7 05 4c 60 98 00 00 	movl   $0x0,0x98604c
  803212:	00 00 00 
  803215:	c7 05 54 60 98 00 00 	movl   $0x0,0x986054
  80321c:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80321f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803223:	75 17                	jne    80323c <initialize_dynamic_allocator+0xcd>
  803225:	83 ec 04             	sub    $0x4,%esp
  803228:	68 b4 58 80 00       	push   $0x8058b4
  80322d:	68 80 00 00 00       	push   $0x80
  803232:	68 d7 58 80 00       	push   $0x8058d7
  803237:	e8 10 e0 ff ff       	call   80124c <_panic>
  80323c:	8b 15 48 60 98 00    	mov    0x986048,%edx
  803242:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803245:	89 10                	mov    %edx,(%eax)
  803247:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324a:	8b 00                	mov    (%eax),%eax
  80324c:	85 c0                	test   %eax,%eax
  80324e:	74 0d                	je     80325d <initialize_dynamic_allocator+0xee>
  803250:	a1 48 60 98 00       	mov    0x986048,%eax
  803255:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803258:	89 50 04             	mov    %edx,0x4(%eax)
  80325b:	eb 08                	jmp    803265 <initialize_dynamic_allocator+0xf6>
  80325d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803260:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803268:	a3 48 60 98 00       	mov    %eax,0x986048
  80326d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803270:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803277:	a1 54 60 98 00       	mov    0x986054,%eax
  80327c:	40                   	inc    %eax
  80327d:	a3 54 60 98 00       	mov    %eax,0x986054
  803282:	eb 01                	jmp    803285 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  803284:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  803285:	c9                   	leave  
  803286:	c3                   	ret    

00803287 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  803287:	55                   	push   %ebp
  803288:	89 e5                	mov    %esp,%ebp
  80328a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80328d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803290:	83 e0 01             	and    $0x1,%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 03                	je     80329a <set_block_data+0x13>
	{
		totalSize++;
  803297:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	83 e8 04             	sub    $0x4,%eax
  8032a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8032a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a6:	83 e0 fe             	and    $0xfffffffe,%eax
  8032a9:	89 c2                	mov    %eax,%edx
  8032ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8032ae:	83 e0 01             	and    $0x1,%eax
  8032b1:	09 c2                	or     %eax,%edx
  8032b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032b6:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8032b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032bb:	8d 50 f8             	lea    -0x8(%eax),%edx
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	01 d0                	add    %edx,%eax
  8032c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8032c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c9:	83 e0 fe             	and    $0xfffffffe,%eax
  8032cc:	89 c2                	mov    %eax,%edx
  8032ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8032d1:	83 e0 01             	and    $0x1,%eax
  8032d4:	09 c2                	or     %eax,%edx
  8032d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8032d9:	89 10                	mov    %edx,(%eax)
}
  8032db:	90                   	nop
  8032dc:	c9                   	leave  
  8032dd:	c3                   	ret    

008032de <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8032de:	55                   	push   %ebp
  8032df:	89 e5                	mov    %esp,%ebp
  8032e1:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8032e4:	a1 48 60 98 00       	mov    0x986048,%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	75 68                	jne    803355 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8032ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f1:	75 17                	jne    80330a <insert_sorted_in_freeList+0x2c>
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	68 b4 58 80 00       	push   $0x8058b4
  8032fb:	68 9d 00 00 00       	push   $0x9d
  803300:	68 d7 58 80 00       	push   $0x8058d7
  803305:	e8 42 df ff ff       	call   80124c <_panic>
  80330a:	8b 15 48 60 98 00    	mov    0x986048,%edx
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	89 10                	mov    %edx,(%eax)
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	8b 00                	mov    (%eax),%eax
  80331a:	85 c0                	test   %eax,%eax
  80331c:	74 0d                	je     80332b <insert_sorted_in_freeList+0x4d>
  80331e:	a1 48 60 98 00       	mov    0x986048,%eax
  803323:	8b 55 08             	mov    0x8(%ebp),%edx
  803326:	89 50 04             	mov    %edx,0x4(%eax)
  803329:	eb 08                	jmp    803333 <insert_sorted_in_freeList+0x55>
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	a3 48 60 98 00       	mov    %eax,0x986048
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803345:	a1 54 60 98 00       	mov    0x986054,%eax
  80334a:	40                   	inc    %eax
  80334b:	a3 54 60 98 00       	mov    %eax,0x986054
		return;
  803350:	e9 1a 01 00 00       	jmp    80346f <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803355:	a1 48 60 98 00       	mov    0x986048,%eax
  80335a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80335d:	eb 7f                	jmp    8033de <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	3b 45 08             	cmp    0x8(%ebp),%eax
  803365:	76 6f                	jbe    8033d6 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  803367:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80336b:	74 06                	je     803373 <insert_sorted_in_freeList+0x95>
  80336d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803371:	75 17                	jne    80338a <insert_sorted_in_freeList+0xac>
  803373:	83 ec 04             	sub    $0x4,%esp
  803376:	68 f0 58 80 00       	push   $0x8058f0
  80337b:	68 a6 00 00 00       	push   $0xa6
  803380:	68 d7 58 80 00       	push   $0x8058d7
  803385:	e8 c2 de ff ff       	call   80124c <_panic>
  80338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338d:	8b 50 04             	mov    0x4(%eax),%edx
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	89 50 04             	mov    %edx,0x4(%eax)
  803396:	8b 45 08             	mov    0x8(%ebp),%eax
  803399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80339c:	89 10                	mov    %edx,(%eax)
  80339e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a1:	8b 40 04             	mov    0x4(%eax),%eax
  8033a4:	85 c0                	test   %eax,%eax
  8033a6:	74 0d                	je     8033b5 <insert_sorted_in_freeList+0xd7>
  8033a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ab:	8b 40 04             	mov    0x4(%eax),%eax
  8033ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	eb 08                	jmp    8033bd <insert_sorted_in_freeList+0xdf>
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	a3 48 60 98 00       	mov    %eax,0x986048
  8033bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c3:	89 50 04             	mov    %edx,0x4(%eax)
  8033c6:	a1 54 60 98 00       	mov    0x986054,%eax
  8033cb:	40                   	inc    %eax
  8033cc:	a3 54 60 98 00       	mov    %eax,0x986054
			return;
  8033d1:	e9 99 00 00 00       	jmp    80346f <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8033d6:	a1 50 60 98 00       	mov    0x986050,%eax
  8033db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033e2:	74 07                	je     8033eb <insert_sorted_in_freeList+0x10d>
  8033e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e7:	8b 00                	mov    (%eax),%eax
  8033e9:	eb 05                	jmp    8033f0 <insert_sorted_in_freeList+0x112>
  8033eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8033f0:	a3 50 60 98 00       	mov    %eax,0x986050
  8033f5:	a1 50 60 98 00       	mov    0x986050,%eax
  8033fa:	85 c0                	test   %eax,%eax
  8033fc:	0f 85 5d ff ff ff    	jne    80335f <insert_sorted_in_freeList+0x81>
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	0f 85 53 ff ff ff    	jne    80335f <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80340c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803410:	75 17                	jne    803429 <insert_sorted_in_freeList+0x14b>
  803412:	83 ec 04             	sub    $0x4,%esp
  803415:	68 28 59 80 00       	push   $0x805928
  80341a:	68 ab 00 00 00       	push   $0xab
  80341f:	68 d7 58 80 00       	push   $0x8058d7
  803424:	e8 23 de ff ff       	call   80124c <_panic>
  803429:	8b 15 4c 60 98 00    	mov    0x98604c,%edx
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	89 50 04             	mov    %edx,0x4(%eax)
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	8b 40 04             	mov    0x4(%eax),%eax
  80343b:	85 c0                	test   %eax,%eax
  80343d:	74 0c                	je     80344b <insert_sorted_in_freeList+0x16d>
  80343f:	a1 4c 60 98 00       	mov    0x98604c,%eax
  803444:	8b 55 08             	mov    0x8(%ebp),%edx
  803447:	89 10                	mov    %edx,(%eax)
  803449:	eb 08                	jmp    803453 <insert_sorted_in_freeList+0x175>
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	a3 48 60 98 00       	mov    %eax,0x986048
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	a3 4c 60 98 00       	mov    %eax,0x98604c
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803464:	a1 54 60 98 00       	mov    0x986054,%eax
  803469:	40                   	inc    %eax
  80346a:	a3 54 60 98 00       	mov    %eax,0x986054
}
  80346f:	c9                   	leave  
  803470:	c3                   	ret    

00803471 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  803471:	55                   	push   %ebp
  803472:	89 e5                	mov    %esp,%ebp
  803474:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	83 e0 01             	and    $0x1,%eax
  80347d:	85 c0                	test   %eax,%eax
  80347f:	74 03                	je     803484 <alloc_block_FF+0x13>
  803481:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803484:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803488:	77 07                	ja     803491 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80348a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803491:	a1 40 60 98 00       	mov    0x986040,%eax
  803496:	85 c0                	test   %eax,%eax
  803498:	75 63                	jne    8034fd <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	83 c0 10             	add    $0x10,%eax
  8034a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8034a3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8034aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034b0:	01 d0                	add    %edx,%eax
  8034b2:	48                   	dec    %eax
  8034b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8034b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8034be:	f7 75 ec             	divl   -0x14(%ebp)
  8034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c4:	29 d0                	sub    %edx,%eax
  8034c6:	c1 e8 0c             	shr    $0xc,%eax
  8034c9:	83 ec 0c             	sub    $0xc,%esp
  8034cc:	50                   	push   %eax
  8034cd:	e8 d1 ed ff ff       	call   8022a3 <sbrk>
  8034d2:	83 c4 10             	add    $0x10,%esp
  8034d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8034d8:	83 ec 0c             	sub    $0xc,%esp
  8034db:	6a 00                	push   $0x0
  8034dd:	e8 c1 ed ff ff       	call   8022a3 <sbrk>
  8034e2:	83 c4 10             	add    $0x10,%esp
  8034e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8034e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8034eb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8034ee:	83 ec 08             	sub    $0x8,%esp
  8034f1:	50                   	push   %eax
  8034f2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8034f5:	e8 75 fc ff ff       	call   80316f <initialize_dynamic_allocator>
  8034fa:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8034fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803501:	75 0a                	jne    80350d <alloc_block_FF+0x9c>
	{
		return NULL;
  803503:	b8 00 00 00 00       	mov    $0x0,%eax
  803508:	e9 99 03 00 00       	jmp    8038a6 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80350d:	8b 45 08             	mov    0x8(%ebp),%eax
  803510:	83 c0 08             	add    $0x8,%eax
  803513:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803516:	a1 48 60 98 00       	mov    0x986048,%eax
  80351b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80351e:	e9 03 02 00 00       	jmp    803726 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  803523:	83 ec 0c             	sub    $0xc,%esp
  803526:	ff 75 f4             	pushl  -0xc(%ebp)
  803529:	e8 dd fa ff ff       	call   80300b <get_block_size>
  80352e:	83 c4 10             	add    $0x10,%esp
  803531:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  803534:	8b 45 9c             	mov    -0x64(%ebp),%eax
  803537:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80353a:	0f 82 de 01 00 00    	jb     80371e <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  803540:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803543:	83 c0 10             	add    $0x10,%eax
  803546:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  803549:	0f 87 32 01 00 00    	ja     803681 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80354f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  803552:	2b 45 dc             	sub    -0x24(%ebp),%eax
  803555:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  803558:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80355b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80355e:	01 d0                	add    %edx,%eax
  803560:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  803563:	83 ec 04             	sub    $0x4,%esp
  803566:	6a 00                	push   $0x0
  803568:	ff 75 98             	pushl  -0x68(%ebp)
  80356b:	ff 75 94             	pushl  -0x6c(%ebp)
  80356e:	e8 14 fd ff ff       	call   803287 <set_block_data>
  803573:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  803576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80357a:	74 06                	je     803582 <alloc_block_FF+0x111>
  80357c:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  803580:	75 17                	jne    803599 <alloc_block_FF+0x128>
  803582:	83 ec 04             	sub    $0x4,%esp
  803585:	68 4c 59 80 00       	push   $0x80594c
  80358a:	68 de 00 00 00       	push   $0xde
  80358f:	68 d7 58 80 00       	push   $0x8058d7
  803594:	e8 b3 dc ff ff       	call   80124c <_panic>
  803599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359c:	8b 10                	mov    (%eax),%edx
  80359e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8035a1:	89 10                	mov    %edx,(%eax)
  8035a3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8035a6:	8b 00                	mov    (%eax),%eax
  8035a8:	85 c0                	test   %eax,%eax
  8035aa:	74 0b                	je     8035b7 <alloc_block_FF+0x146>
  8035ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035af:	8b 00                	mov    (%eax),%eax
  8035b1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8035b4:	89 50 04             	mov    %edx,0x4(%eax)
  8035b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ba:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8035bd:	89 10                	mov    %edx,(%eax)
  8035bf:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8035c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035c5:	89 50 04             	mov    %edx,0x4(%eax)
  8035c8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	85 c0                	test   %eax,%eax
  8035cf:	75 08                	jne    8035d9 <alloc_block_FF+0x168>
  8035d1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8035d4:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8035d9:	a1 54 60 98 00       	mov    0x986054,%eax
  8035de:	40                   	inc    %eax
  8035df:	a3 54 60 98 00       	mov    %eax,0x986054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8035e4:	83 ec 04             	sub    $0x4,%esp
  8035e7:	6a 01                	push   $0x1
  8035e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8035ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8035ef:	e8 93 fc ff ff       	call   803287 <set_block_data>
  8035f4:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8035f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035fb:	75 17                	jne    803614 <alloc_block_FF+0x1a3>
  8035fd:	83 ec 04             	sub    $0x4,%esp
  803600:	68 80 59 80 00       	push   $0x805980
  803605:	68 e3 00 00 00       	push   $0xe3
  80360a:	68 d7 58 80 00       	push   $0x8058d7
  80360f:	e8 38 dc ff ff       	call   80124c <_panic>
  803614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803617:	8b 00                	mov    (%eax),%eax
  803619:	85 c0                	test   %eax,%eax
  80361b:	74 10                	je     80362d <alloc_block_FF+0x1bc>
  80361d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803620:	8b 00                	mov    (%eax),%eax
  803622:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803625:	8b 52 04             	mov    0x4(%edx),%edx
  803628:	89 50 04             	mov    %edx,0x4(%eax)
  80362b:	eb 0b                	jmp    803638 <alloc_block_FF+0x1c7>
  80362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803630:	8b 40 04             	mov    0x4(%eax),%eax
  803633:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363b:	8b 40 04             	mov    0x4(%eax),%eax
  80363e:	85 c0                	test   %eax,%eax
  803640:	74 0f                	je     803651 <alloc_block_FF+0x1e0>
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 40 04             	mov    0x4(%eax),%eax
  803648:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80364b:	8b 12                	mov    (%edx),%edx
  80364d:	89 10                	mov    %edx,(%eax)
  80364f:	eb 0a                	jmp    80365b <alloc_block_FF+0x1ea>
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	8b 00                	mov    (%eax),%eax
  803656:	a3 48 60 98 00       	mov    %eax,0x986048
  80365b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803667:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366e:	a1 54 60 98 00       	mov    0x986054,%eax
  803673:	48                   	dec    %eax
  803674:	a3 54 60 98 00       	mov    %eax,0x986054
				return (void*)((uint32*)block);
  803679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367c:	e9 25 02 00 00       	jmp    8038a6 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  803681:	83 ec 04             	sub    $0x4,%esp
  803684:	6a 01                	push   $0x1
  803686:	ff 75 9c             	pushl  -0x64(%ebp)
  803689:	ff 75 f4             	pushl  -0xc(%ebp)
  80368c:	e8 f6 fb ff ff       	call   803287 <set_block_data>
  803691:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803698:	75 17                	jne    8036b1 <alloc_block_FF+0x240>
  80369a:	83 ec 04             	sub    $0x4,%esp
  80369d:	68 80 59 80 00       	push   $0x805980
  8036a2:	68 eb 00 00 00       	push   $0xeb
  8036a7:	68 d7 58 80 00       	push   $0x8058d7
  8036ac:	e8 9b db ff ff       	call   80124c <_panic>
  8036b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b4:	8b 00                	mov    (%eax),%eax
  8036b6:	85 c0                	test   %eax,%eax
  8036b8:	74 10                	je     8036ca <alloc_block_FF+0x259>
  8036ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036c2:	8b 52 04             	mov    0x4(%edx),%edx
  8036c5:	89 50 04             	mov    %edx,0x4(%eax)
  8036c8:	eb 0b                	jmp    8036d5 <alloc_block_FF+0x264>
  8036ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cd:	8b 40 04             	mov    0x4(%eax),%eax
  8036d0:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d8:	8b 40 04             	mov    0x4(%eax),%eax
  8036db:	85 c0                	test   %eax,%eax
  8036dd:	74 0f                	je     8036ee <alloc_block_FF+0x27d>
  8036df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e2:	8b 40 04             	mov    0x4(%eax),%eax
  8036e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e8:	8b 12                	mov    (%edx),%edx
  8036ea:	89 10                	mov    %edx,(%eax)
  8036ec:	eb 0a                	jmp    8036f8 <alloc_block_FF+0x287>
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	a3 48 60 98 00       	mov    %eax,0x986048
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370b:	a1 54 60 98 00       	mov    0x986054,%eax
  803710:	48                   	dec    %eax
  803711:	a3 54 60 98 00       	mov    %eax,0x986054
				return (void*)((uint32*)block);
  803716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803719:	e9 88 01 00 00       	jmp    8038a6 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80371e:	a1 50 60 98 00       	mov    0x986050,%eax
  803723:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803726:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80372a:	74 07                	je     803733 <alloc_block_FF+0x2c2>
  80372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372f:	8b 00                	mov    (%eax),%eax
  803731:	eb 05                	jmp    803738 <alloc_block_FF+0x2c7>
  803733:	b8 00 00 00 00       	mov    $0x0,%eax
  803738:	a3 50 60 98 00       	mov    %eax,0x986050
  80373d:	a1 50 60 98 00       	mov    0x986050,%eax
  803742:	85 c0                	test   %eax,%eax
  803744:	0f 85 d9 fd ff ff    	jne    803523 <alloc_block_FF+0xb2>
  80374a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80374e:	0f 85 cf fd ff ff    	jne    803523 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  803754:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80375b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80375e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803761:	01 d0                	add    %edx,%eax
  803763:	48                   	dec    %eax
  803764:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80376a:	ba 00 00 00 00       	mov    $0x0,%edx
  80376f:	f7 75 d8             	divl   -0x28(%ebp)
  803772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803775:	29 d0                	sub    %edx,%eax
  803777:	c1 e8 0c             	shr    $0xc,%eax
  80377a:	83 ec 0c             	sub    $0xc,%esp
  80377d:	50                   	push   %eax
  80377e:	e8 20 eb ff ff       	call   8022a3 <sbrk>
  803783:	83 c4 10             	add    $0x10,%esp
  803786:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  803789:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80378d:	75 0a                	jne    803799 <alloc_block_FF+0x328>
		return NULL;
  80378f:	b8 00 00 00 00       	mov    $0x0,%eax
  803794:	e9 0d 01 00 00       	jmp    8038a6 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  803799:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80379c:	83 e8 04             	sub    $0x4,%eax
  80379f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8037a2:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8037a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8037ac:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8037af:	01 d0                	add    %edx,%eax
  8037b1:	48                   	dec    %eax
  8037b2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8037b5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8037bd:	f7 75 c8             	divl   -0x38(%ebp)
  8037c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8037c3:	29 d0                	sub    %edx,%eax
  8037c5:	c1 e8 02             	shr    $0x2,%eax
  8037c8:	c1 e0 02             	shl    $0x2,%eax
  8037cb:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8037ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8037d1:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8037d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037da:	83 e8 08             	sub    $0x8,%eax
  8037dd:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8037e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8037e3:	8b 00                	mov    (%eax),%eax
  8037e5:	83 e0 fe             	and    $0xfffffffe,%eax
  8037e8:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8037eb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8037ee:	f7 d8                	neg    %eax
  8037f0:	89 c2                	mov    %eax,%edx
  8037f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8037f5:	01 d0                	add    %edx,%eax
  8037f7:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8037fa:	83 ec 0c             	sub    $0xc,%esp
  8037fd:	ff 75 b8             	pushl  -0x48(%ebp)
  803800:	e8 1f f8 ff ff       	call   803024 <is_free_block>
  803805:	83 c4 10             	add    $0x10,%esp
  803808:	0f be c0             	movsbl %al,%eax
  80380b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  80380e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  803812:	74 42                	je     803856 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  803814:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  80381b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80381e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803821:	01 d0                	add    %edx,%eax
  803823:	48                   	dec    %eax
  803824:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803827:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80382a:	ba 00 00 00 00       	mov    $0x0,%edx
  80382f:	f7 75 b0             	divl   -0x50(%ebp)
  803832:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803835:	29 d0                	sub    %edx,%eax
  803837:	89 c2                	mov    %eax,%edx
  803839:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80383c:	01 d0                	add    %edx,%eax
  80383e:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803841:	83 ec 04             	sub    $0x4,%esp
  803844:	6a 00                	push   $0x0
  803846:	ff 75 a8             	pushl  -0x58(%ebp)
  803849:	ff 75 b8             	pushl  -0x48(%ebp)
  80384c:	e8 36 fa ff ff       	call   803287 <set_block_data>
  803851:	83 c4 10             	add    $0x10,%esp
  803854:	eb 42                	jmp    803898 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803856:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  80385d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803860:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803863:	01 d0                	add    %edx,%eax
  803865:	48                   	dec    %eax
  803866:	89 45 a0             	mov    %eax,-0x60(%ebp)
  803869:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80386c:	ba 00 00 00 00       	mov    $0x0,%edx
  803871:	f7 75 a4             	divl   -0x5c(%ebp)
  803874:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803877:	29 d0                	sub    %edx,%eax
  803879:	83 ec 04             	sub    $0x4,%esp
  80387c:	6a 00                	push   $0x0
  80387e:	50                   	push   %eax
  80387f:	ff 75 d0             	pushl  -0x30(%ebp)
  803882:	e8 00 fa ff ff       	call   803287 <set_block_data>
  803887:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  80388a:	83 ec 0c             	sub    $0xc,%esp
  80388d:	ff 75 d0             	pushl  -0x30(%ebp)
  803890:	e8 49 fa ff ff       	call   8032de <insert_sorted_in_freeList>
  803895:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  803898:	83 ec 0c             	sub    $0xc,%esp
  80389b:	ff 75 08             	pushl  0x8(%ebp)
  80389e:	e8 ce fb ff ff       	call   803471 <alloc_block_FF>
  8038a3:	83 c4 10             	add    $0x10,%esp
}
  8038a6:	c9                   	leave  
  8038a7:	c3                   	ret    

008038a8 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8038a8:	55                   	push   %ebp
  8038a9:	89 e5                	mov    %esp,%ebp
  8038ab:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8038ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038b2:	75 0a                	jne    8038be <alloc_block_BF+0x16>
	{
		return NULL;
  8038b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8038b9:	e9 7a 02 00 00       	jmp    803b38 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8038be:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c1:	83 c0 08             	add    $0x8,%eax
  8038c4:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8038c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8038ce:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8038d5:	a1 48 60 98 00       	mov    0x986048,%eax
  8038da:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8038dd:	eb 32                	jmp    803911 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  8038df:	ff 75 ec             	pushl  -0x14(%ebp)
  8038e2:	e8 24 f7 ff ff       	call   80300b <get_block_size>
  8038e7:	83 c4 04             	add    $0x4,%esp
  8038ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  8038ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8038f3:	72 14                	jb     803909 <alloc_block_BF+0x61>
  8038f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8038fb:	73 0c                	jae    803909 <alloc_block_BF+0x61>
		{
			minBlk = block;
  8038fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803900:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803906:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803909:	a1 50 60 98 00       	mov    0x986050,%eax
  80390e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803911:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803915:	74 07                	je     80391e <alloc_block_BF+0x76>
  803917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80391a:	8b 00                	mov    (%eax),%eax
  80391c:	eb 05                	jmp    803923 <alloc_block_BF+0x7b>
  80391e:	b8 00 00 00 00       	mov    $0x0,%eax
  803923:	a3 50 60 98 00       	mov    %eax,0x986050
  803928:	a1 50 60 98 00       	mov    0x986050,%eax
  80392d:	85 c0                	test   %eax,%eax
  80392f:	75 ae                	jne    8038df <alloc_block_BF+0x37>
  803931:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803935:	75 a8                	jne    8038df <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803937:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80393b:	75 22                	jne    80395f <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  80393d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803940:	83 ec 0c             	sub    $0xc,%esp
  803943:	50                   	push   %eax
  803944:	e8 5a e9 ff ff       	call   8022a3 <sbrk>
  803949:	83 c4 10             	add    $0x10,%esp
  80394c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80394f:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803953:	75 0a                	jne    80395f <alloc_block_BF+0xb7>
			return NULL;
  803955:	b8 00 00 00 00       	mov    $0x0,%eax
  80395a:	e9 d9 01 00 00       	jmp    803b38 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80395f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803962:	83 c0 10             	add    $0x10,%eax
  803965:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803968:	0f 87 32 01 00 00    	ja     803aa0 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  80396e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803971:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803974:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  803977:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80397a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397d:	01 d0                	add    %edx,%eax
  80397f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  803982:	83 ec 04             	sub    $0x4,%esp
  803985:	6a 00                	push   $0x0
  803987:	ff 75 dc             	pushl  -0x24(%ebp)
  80398a:	ff 75 d8             	pushl  -0x28(%ebp)
  80398d:	e8 f5 f8 ff ff       	call   803287 <set_block_data>
  803992:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  803995:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803999:	74 06                	je     8039a1 <alloc_block_BF+0xf9>
  80399b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80399f:	75 17                	jne    8039b8 <alloc_block_BF+0x110>
  8039a1:	83 ec 04             	sub    $0x4,%esp
  8039a4:	68 4c 59 80 00       	push   $0x80594c
  8039a9:	68 49 01 00 00       	push   $0x149
  8039ae:	68 d7 58 80 00       	push   $0x8058d7
  8039b3:	e8 94 d8 ff ff       	call   80124c <_panic>
  8039b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039bb:	8b 10                	mov    (%eax),%edx
  8039bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039c0:	89 10                	mov    %edx,(%eax)
  8039c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039c5:	8b 00                	mov    (%eax),%eax
  8039c7:	85 c0                	test   %eax,%eax
  8039c9:	74 0b                	je     8039d6 <alloc_block_BF+0x12e>
  8039cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ce:	8b 00                	mov    (%eax),%eax
  8039d0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039d3:	89 50 04             	mov    %edx,0x4(%eax)
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8039dc:	89 10                	mov    %edx,(%eax)
  8039de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039e4:	89 50 04             	mov    %edx,0x4(%eax)
  8039e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039ea:	8b 00                	mov    (%eax),%eax
  8039ec:	85 c0                	test   %eax,%eax
  8039ee:	75 08                	jne    8039f8 <alloc_block_BF+0x150>
  8039f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8039f3:	a3 4c 60 98 00       	mov    %eax,0x98604c
  8039f8:	a1 54 60 98 00       	mov    0x986054,%eax
  8039fd:	40                   	inc    %eax
  8039fe:	a3 54 60 98 00       	mov    %eax,0x986054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803a03:	83 ec 04             	sub    $0x4,%esp
  803a06:	6a 01                	push   $0x1
  803a08:	ff 75 e8             	pushl  -0x18(%ebp)
  803a0b:	ff 75 f4             	pushl  -0xc(%ebp)
  803a0e:	e8 74 f8 ff ff       	call   803287 <set_block_data>
  803a13:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a1a:	75 17                	jne    803a33 <alloc_block_BF+0x18b>
  803a1c:	83 ec 04             	sub    $0x4,%esp
  803a1f:	68 80 59 80 00       	push   $0x805980
  803a24:	68 4e 01 00 00       	push   $0x14e
  803a29:	68 d7 58 80 00       	push   $0x8058d7
  803a2e:	e8 19 d8 ff ff       	call   80124c <_panic>
  803a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a36:	8b 00                	mov    (%eax),%eax
  803a38:	85 c0                	test   %eax,%eax
  803a3a:	74 10                	je     803a4c <alloc_block_BF+0x1a4>
  803a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a3f:	8b 00                	mov    (%eax),%eax
  803a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a44:	8b 52 04             	mov    0x4(%edx),%edx
  803a47:	89 50 04             	mov    %edx,0x4(%eax)
  803a4a:	eb 0b                	jmp    803a57 <alloc_block_BF+0x1af>
  803a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a4f:	8b 40 04             	mov    0x4(%eax),%eax
  803a52:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a5a:	8b 40 04             	mov    0x4(%eax),%eax
  803a5d:	85 c0                	test   %eax,%eax
  803a5f:	74 0f                	je     803a70 <alloc_block_BF+0x1c8>
  803a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a64:	8b 40 04             	mov    0x4(%eax),%eax
  803a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803a6a:	8b 12                	mov    (%edx),%edx
  803a6c:	89 10                	mov    %edx,(%eax)
  803a6e:	eb 0a                	jmp    803a7a <alloc_block_BF+0x1d2>
  803a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a73:	8b 00                	mov    (%eax),%eax
  803a75:	a3 48 60 98 00       	mov    %eax,0x986048
  803a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a8d:	a1 54 60 98 00       	mov    0x986054,%eax
  803a92:	48                   	dec    %eax
  803a93:	a3 54 60 98 00       	mov    %eax,0x986054
		return (void*)((uint32*)minBlk);
  803a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a9b:	e9 98 00 00 00       	jmp    803b38 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  803aa0:	83 ec 04             	sub    $0x4,%esp
  803aa3:	6a 01                	push   $0x1
  803aa5:	ff 75 f0             	pushl  -0x10(%ebp)
  803aa8:	ff 75 f4             	pushl  -0xc(%ebp)
  803aab:	e8 d7 f7 ff ff       	call   803287 <set_block_data>
  803ab0:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803ab3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ab7:	75 17                	jne    803ad0 <alloc_block_BF+0x228>
  803ab9:	83 ec 04             	sub    $0x4,%esp
  803abc:	68 80 59 80 00       	push   $0x805980
  803ac1:	68 56 01 00 00       	push   $0x156
  803ac6:	68 d7 58 80 00       	push   $0x8058d7
  803acb:	e8 7c d7 ff ff       	call   80124c <_panic>
  803ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ad3:	8b 00                	mov    (%eax),%eax
  803ad5:	85 c0                	test   %eax,%eax
  803ad7:	74 10                	je     803ae9 <alloc_block_BF+0x241>
  803ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803adc:	8b 00                	mov    (%eax),%eax
  803ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ae1:	8b 52 04             	mov    0x4(%edx),%edx
  803ae4:	89 50 04             	mov    %edx,0x4(%eax)
  803ae7:	eb 0b                	jmp    803af4 <alloc_block_BF+0x24c>
  803ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aec:	8b 40 04             	mov    0x4(%eax),%eax
  803aef:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af7:	8b 40 04             	mov    0x4(%eax),%eax
  803afa:	85 c0                	test   %eax,%eax
  803afc:	74 0f                	je     803b0d <alloc_block_BF+0x265>
  803afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b01:	8b 40 04             	mov    0x4(%eax),%eax
  803b04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b07:	8b 12                	mov    (%edx),%edx
  803b09:	89 10                	mov    %edx,(%eax)
  803b0b:	eb 0a                	jmp    803b17 <alloc_block_BF+0x26f>
  803b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b10:	8b 00                	mov    (%eax),%eax
  803b12:	a3 48 60 98 00       	mov    %eax,0x986048
  803b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2a:	a1 54 60 98 00       	mov    0x986054,%eax
  803b2f:	48                   	dec    %eax
  803b30:	a3 54 60 98 00       	mov    %eax,0x986054
		return (void*)((uint32*)minBlk);
  803b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  803b38:	c9                   	leave  
  803b39:	c3                   	ret    

00803b3a <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  803b3a:	55                   	push   %ebp
  803b3b:	89 e5                	mov    %esp,%ebp
  803b3d:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  803b40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b44:	0f 84 6a 02 00 00    	je     803db4 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  803b4a:	ff 75 08             	pushl  0x8(%ebp)
  803b4d:	e8 b9 f4 ff ff       	call   80300b <get_block_size>
  803b52:	83 c4 04             	add    $0x4,%esp
  803b55:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  803b58:	8b 45 08             	mov    0x8(%ebp),%eax
  803b5b:	83 e8 08             	sub    $0x8,%eax
  803b5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  803b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803b64:	8b 00                	mov    (%eax),%eax
  803b66:	83 e0 fe             	and    $0xfffffffe,%eax
  803b69:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  803b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803b6f:	f7 d8                	neg    %eax
  803b71:	89 c2                	mov    %eax,%edx
  803b73:	8b 45 08             	mov    0x8(%ebp),%eax
  803b76:	01 d0                	add    %edx,%eax
  803b78:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  803b7b:	ff 75 e8             	pushl  -0x18(%ebp)
  803b7e:	e8 a1 f4 ff ff       	call   803024 <is_free_block>
  803b83:	83 c4 04             	add    $0x4,%esp
  803b86:	0f be c0             	movsbl %al,%eax
  803b89:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  803b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  803b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b92:	01 d0                	add    %edx,%eax
  803b94:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803b97:	ff 75 e0             	pushl  -0x20(%ebp)
  803b9a:	e8 85 f4 ff ff       	call   803024 <is_free_block>
  803b9f:	83 c4 04             	add    $0x4,%esp
  803ba2:	0f be c0             	movsbl %al,%eax
  803ba5:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  803ba8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803bac:	75 34                	jne    803be2 <free_block+0xa8>
  803bae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803bb2:	75 2e                	jne    803be2 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  803bb4:	ff 75 e8             	pushl  -0x18(%ebp)
  803bb7:	e8 4f f4 ff ff       	call   80300b <get_block_size>
  803bbc:	83 c4 04             	add    $0x4,%esp
  803bbf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  803bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803bc8:	01 d0                	add    %edx,%eax
  803bca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803bcd:	6a 00                	push   $0x0
  803bcf:	ff 75 d4             	pushl  -0x2c(%ebp)
  803bd2:	ff 75 e8             	pushl  -0x18(%ebp)
  803bd5:	e8 ad f6 ff ff       	call   803287 <set_block_data>
  803bda:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803bdd:	e9 d3 01 00 00       	jmp    803db5 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803be2:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803be6:	0f 85 c8 00 00 00    	jne    803cb4 <free_block+0x17a>
  803bec:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bf0:	0f 85 be 00 00 00    	jne    803cb4 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803bf6:	ff 75 e0             	pushl  -0x20(%ebp)
  803bf9:	e8 0d f4 ff ff       	call   80300b <get_block_size>
  803bfe:	83 c4 04             	add    $0x4,%esp
  803c01:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803c04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c07:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803c0a:	01 d0                	add    %edx,%eax
  803c0c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803c0f:	6a 00                	push   $0x0
  803c11:	ff 75 cc             	pushl  -0x34(%ebp)
  803c14:	ff 75 08             	pushl  0x8(%ebp)
  803c17:	e8 6b f6 ff ff       	call   803287 <set_block_data>
  803c1c:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803c1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803c23:	75 17                	jne    803c3c <free_block+0x102>
  803c25:	83 ec 04             	sub    $0x4,%esp
  803c28:	68 80 59 80 00       	push   $0x805980
  803c2d:	68 87 01 00 00       	push   $0x187
  803c32:	68 d7 58 80 00       	push   $0x8058d7
  803c37:	e8 10 d6 ff ff       	call   80124c <_panic>
  803c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c3f:	8b 00                	mov    (%eax),%eax
  803c41:	85 c0                	test   %eax,%eax
  803c43:	74 10                	je     803c55 <free_block+0x11b>
  803c45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c48:	8b 00                	mov    (%eax),%eax
  803c4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c4d:	8b 52 04             	mov    0x4(%edx),%edx
  803c50:	89 50 04             	mov    %edx,0x4(%eax)
  803c53:	eb 0b                	jmp    803c60 <free_block+0x126>
  803c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c58:	8b 40 04             	mov    0x4(%eax),%eax
  803c5b:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c63:	8b 40 04             	mov    0x4(%eax),%eax
  803c66:	85 c0                	test   %eax,%eax
  803c68:	74 0f                	je     803c79 <free_block+0x13f>
  803c6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c6d:	8b 40 04             	mov    0x4(%eax),%eax
  803c70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803c73:	8b 12                	mov    (%edx),%edx
  803c75:	89 10                	mov    %edx,(%eax)
  803c77:	eb 0a                	jmp    803c83 <free_block+0x149>
  803c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c7c:	8b 00                	mov    (%eax),%eax
  803c7e:	a3 48 60 98 00       	mov    %eax,0x986048
  803c83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803c8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c96:	a1 54 60 98 00       	mov    0x986054,%eax
  803c9b:	48                   	dec    %eax
  803c9c:	a3 54 60 98 00       	mov    %eax,0x986054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803ca1:	83 ec 0c             	sub    $0xc,%esp
  803ca4:	ff 75 08             	pushl  0x8(%ebp)
  803ca7:	e8 32 f6 ff ff       	call   8032de <insert_sorted_in_freeList>
  803cac:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803caf:	e9 01 01 00 00       	jmp    803db5 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803cb4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  803cb8:	0f 85 d3 00 00 00    	jne    803d91 <free_block+0x257>
  803cbe:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803cc2:	0f 85 c9 00 00 00    	jne    803d91 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  803cc8:	83 ec 0c             	sub    $0xc,%esp
  803ccb:	ff 75 e8             	pushl  -0x18(%ebp)
  803cce:	e8 38 f3 ff ff       	call   80300b <get_block_size>
  803cd3:	83 c4 10             	add    $0x10,%esp
  803cd6:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  803cd9:	83 ec 0c             	sub    $0xc,%esp
  803cdc:	ff 75 e0             	pushl  -0x20(%ebp)
  803cdf:	e8 27 f3 ff ff       	call   80300b <get_block_size>
  803ce4:	83 c4 10             	add    $0x10,%esp
  803ce7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  803cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ced:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803cf0:	01 c2                	add    %eax,%edx
  803cf2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803cf5:	01 d0                	add    %edx,%eax
  803cf7:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  803cfa:	83 ec 04             	sub    $0x4,%esp
  803cfd:	6a 00                	push   $0x0
  803cff:	ff 75 c0             	pushl  -0x40(%ebp)
  803d02:	ff 75 e8             	pushl  -0x18(%ebp)
  803d05:	e8 7d f5 ff ff       	call   803287 <set_block_data>
  803d0a:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803d0d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803d11:	75 17                	jne    803d2a <free_block+0x1f0>
  803d13:	83 ec 04             	sub    $0x4,%esp
  803d16:	68 80 59 80 00       	push   $0x805980
  803d1b:	68 94 01 00 00       	push   $0x194
  803d20:	68 d7 58 80 00       	push   $0x8058d7
  803d25:	e8 22 d5 ff ff       	call   80124c <_panic>
  803d2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d2d:	8b 00                	mov    (%eax),%eax
  803d2f:	85 c0                	test   %eax,%eax
  803d31:	74 10                	je     803d43 <free_block+0x209>
  803d33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d36:	8b 00                	mov    (%eax),%eax
  803d38:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d3b:	8b 52 04             	mov    0x4(%edx),%edx
  803d3e:	89 50 04             	mov    %edx,0x4(%eax)
  803d41:	eb 0b                	jmp    803d4e <free_block+0x214>
  803d43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d46:	8b 40 04             	mov    0x4(%eax),%eax
  803d49:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d51:	8b 40 04             	mov    0x4(%eax),%eax
  803d54:	85 c0                	test   %eax,%eax
  803d56:	74 0f                	je     803d67 <free_block+0x22d>
  803d58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d5b:	8b 40 04             	mov    0x4(%eax),%eax
  803d5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803d61:	8b 12                	mov    (%edx),%edx
  803d63:	89 10                	mov    %edx,(%eax)
  803d65:	eb 0a                	jmp    803d71 <free_block+0x237>
  803d67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d6a:	8b 00                	mov    (%eax),%eax
  803d6c:	a3 48 60 98 00       	mov    %eax,0x986048
  803d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803d7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803d7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d84:	a1 54 60 98 00       	mov    0x986054,%eax
  803d89:	48                   	dec    %eax
  803d8a:	a3 54 60 98 00       	mov    %eax,0x986054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803d8f:	eb 24                	jmp    803db5 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803d91:	83 ec 04             	sub    $0x4,%esp
  803d94:	6a 00                	push   $0x0
  803d96:	ff 75 f4             	pushl  -0xc(%ebp)
  803d99:	ff 75 08             	pushl  0x8(%ebp)
  803d9c:	e8 e6 f4 ff ff       	call   803287 <set_block_data>
  803da1:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803da4:	83 ec 0c             	sub    $0xc,%esp
  803da7:	ff 75 08             	pushl  0x8(%ebp)
  803daa:	e8 2f f5 ff ff       	call   8032de <insert_sorted_in_freeList>
  803daf:	83 c4 10             	add    $0x10,%esp
  803db2:	eb 01                	jmp    803db5 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803db4:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803db5:	c9                   	leave  
  803db6:	c3                   	ret    

00803db7 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803db7:	55                   	push   %ebp
  803db8:	89 e5                	mov    %esp,%ebp
  803dba:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803dbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803dc1:	75 10                	jne    803dd3 <realloc_block_FF+0x1c>
  803dc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803dc7:	75 0a                	jne    803dd3 <realloc_block_FF+0x1c>
	{
		return NULL;
  803dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  803dce:	e9 8b 04 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803dd3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803dd7:	75 18                	jne    803df1 <realloc_block_FF+0x3a>
	{
		free_block(va);
  803dd9:	83 ec 0c             	sub    $0xc,%esp
  803ddc:	ff 75 08             	pushl  0x8(%ebp)
  803ddf:	e8 56 fd ff ff       	call   803b3a <free_block>
  803de4:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803de7:	b8 00 00 00 00       	mov    $0x0,%eax
  803dec:	e9 6d 04 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803df1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803df5:	75 13                	jne    803e0a <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803df7:	83 ec 0c             	sub    $0xc,%esp
  803dfa:	ff 75 0c             	pushl  0xc(%ebp)
  803dfd:	e8 6f f6 ff ff       	call   803471 <alloc_block_FF>
  803e02:	83 c4 10             	add    $0x10,%esp
  803e05:	e9 54 04 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e0d:	83 e0 01             	and    $0x1,%eax
  803e10:	85 c0                	test   %eax,%eax
  803e12:	74 03                	je     803e17 <realloc_block_FF+0x60>
	{
		new_size++;
  803e14:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803e17:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  803e1b:	77 07                	ja     803e24 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803e1d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803e24:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803e28:	83 ec 0c             	sub    $0xc,%esp
  803e2b:	ff 75 08             	pushl  0x8(%ebp)
  803e2e:	e8 d8 f1 ff ff       	call   80300b <get_block_size>
  803e33:	83 c4 10             	add    $0x10,%esp
  803e36:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803e3f:	75 08                	jne    803e49 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803e41:	8b 45 08             	mov    0x8(%ebp),%eax
  803e44:	e9 15 04 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803e49:	8b 55 08             	mov    0x8(%ebp),%edx
  803e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e4f:	01 d0                	add    %edx,%eax
  803e51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803e54:	83 ec 0c             	sub    $0xc,%esp
  803e57:	ff 75 f0             	pushl  -0x10(%ebp)
  803e5a:	e8 c5 f1 ff ff       	call   803024 <is_free_block>
  803e5f:	83 c4 10             	add    $0x10,%esp
  803e62:	0f be c0             	movsbl %al,%eax
  803e65:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803e68:	83 ec 0c             	sub    $0xc,%esp
  803e6b:	ff 75 f0             	pushl  -0x10(%ebp)
  803e6e:	e8 98 f1 ff ff       	call   80300b <get_block_size>
  803e73:	83 c4 10             	add    $0x10,%esp
  803e76:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803e79:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803e7f:	0f 86 a7 02 00 00    	jbe    80412c <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803e85:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803e89:	0f 84 86 02 00 00    	je     804115 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803e8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e95:	01 d0                	add    %edx,%eax
  803e97:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803e9a:	0f 85 b2 00 00 00    	jne    803f52 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803ea0:	83 ec 0c             	sub    $0xc,%esp
  803ea3:	ff 75 08             	pushl  0x8(%ebp)
  803ea6:	e8 79 f1 ff ff       	call   803024 <is_free_block>
  803eab:	83 c4 10             	add    $0x10,%esp
  803eae:	84 c0                	test   %al,%al
  803eb0:	0f 94 c0             	sete   %al
  803eb3:	0f b6 c0             	movzbl %al,%eax
  803eb6:	83 ec 04             	sub    $0x4,%esp
  803eb9:	50                   	push   %eax
  803eba:	ff 75 0c             	pushl  0xc(%ebp)
  803ebd:	ff 75 08             	pushl  0x8(%ebp)
  803ec0:	e8 c2 f3 ff ff       	call   803287 <set_block_data>
  803ec5:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803ec8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803ecc:	75 17                	jne    803ee5 <realloc_block_FF+0x12e>
  803ece:	83 ec 04             	sub    $0x4,%esp
  803ed1:	68 80 59 80 00       	push   $0x805980
  803ed6:	68 db 01 00 00       	push   $0x1db
  803edb:	68 d7 58 80 00       	push   $0x8058d7
  803ee0:	e8 67 d3 ff ff       	call   80124c <_panic>
  803ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ee8:	8b 00                	mov    (%eax),%eax
  803eea:	85 c0                	test   %eax,%eax
  803eec:	74 10                	je     803efe <realloc_block_FF+0x147>
  803eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ef1:	8b 00                	mov    (%eax),%eax
  803ef3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803ef6:	8b 52 04             	mov    0x4(%edx),%edx
  803ef9:	89 50 04             	mov    %edx,0x4(%eax)
  803efc:	eb 0b                	jmp    803f09 <realloc_block_FF+0x152>
  803efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f01:	8b 40 04             	mov    0x4(%eax),%eax
  803f04:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f0c:	8b 40 04             	mov    0x4(%eax),%eax
  803f0f:	85 c0                	test   %eax,%eax
  803f11:	74 0f                	je     803f22 <realloc_block_FF+0x16b>
  803f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f16:	8b 40 04             	mov    0x4(%eax),%eax
  803f19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803f1c:	8b 12                	mov    (%edx),%edx
  803f1e:	89 10                	mov    %edx,(%eax)
  803f20:	eb 0a                	jmp    803f2c <realloc_block_FF+0x175>
  803f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f25:	8b 00                	mov    (%eax),%eax
  803f27:	a3 48 60 98 00       	mov    %eax,0x986048
  803f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f3f:	a1 54 60 98 00       	mov    0x986054,%eax
  803f44:	48                   	dec    %eax
  803f45:	a3 54 60 98 00       	mov    %eax,0x986054
				return va;
  803f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4d:	e9 0c 03 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803f52:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f58:	01 d0                	add    %edx,%eax
  803f5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803f5d:	0f 86 b2 01 00 00    	jbe    804115 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f66:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803f69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803f6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f6f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803f72:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803f75:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803f79:	0f 87 b8 00 00 00    	ja     804037 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  803f7f:	83 ec 0c             	sub    $0xc,%esp
  803f82:	ff 75 08             	pushl  0x8(%ebp)
  803f85:	e8 9a f0 ff ff       	call   803024 <is_free_block>
  803f8a:	83 c4 10             	add    $0x10,%esp
  803f8d:	84 c0                	test   %al,%al
  803f8f:	0f 94 c0             	sete   %al
  803f92:	0f b6 c0             	movzbl %al,%eax
  803f95:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803f98:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803f9b:	01 ca                	add    %ecx,%edx
  803f9d:	83 ec 04             	sub    $0x4,%esp
  803fa0:	50                   	push   %eax
  803fa1:	52                   	push   %edx
  803fa2:	ff 75 08             	pushl  0x8(%ebp)
  803fa5:	e8 dd f2 ff ff       	call   803287 <set_block_data>
  803faa:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803fad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803fb1:	75 17                	jne    803fca <realloc_block_FF+0x213>
  803fb3:	83 ec 04             	sub    $0x4,%esp
  803fb6:	68 80 59 80 00       	push   $0x805980
  803fbb:	68 e8 01 00 00       	push   $0x1e8
  803fc0:	68 d7 58 80 00       	push   $0x8058d7
  803fc5:	e8 82 d2 ff ff       	call   80124c <_panic>
  803fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fcd:	8b 00                	mov    (%eax),%eax
  803fcf:	85 c0                	test   %eax,%eax
  803fd1:	74 10                	je     803fe3 <realloc_block_FF+0x22c>
  803fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fd6:	8b 00                	mov    (%eax),%eax
  803fd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803fdb:	8b 52 04             	mov    0x4(%edx),%edx
  803fde:	89 50 04             	mov    %edx,0x4(%eax)
  803fe1:	eb 0b                	jmp    803fee <realloc_block_FF+0x237>
  803fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803fe6:	8b 40 04             	mov    0x4(%eax),%eax
  803fe9:	a3 4c 60 98 00       	mov    %eax,0x98604c
  803fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ff1:	8b 40 04             	mov    0x4(%eax),%eax
  803ff4:	85 c0                	test   %eax,%eax
  803ff6:	74 0f                	je     804007 <realloc_block_FF+0x250>
  803ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ffb:	8b 40 04             	mov    0x4(%eax),%eax
  803ffe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804001:	8b 12                	mov    (%edx),%edx
  804003:	89 10                	mov    %edx,(%eax)
  804005:	eb 0a                	jmp    804011 <realloc_block_FF+0x25a>
  804007:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80400a:	8b 00                	mov    (%eax),%eax
  80400c:	a3 48 60 98 00       	mov    %eax,0x986048
  804011:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804014:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80401a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80401d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804024:	a1 54 60 98 00       	mov    0x986054,%eax
  804029:	48                   	dec    %eax
  80402a:	a3 54 60 98 00       	mov    %eax,0x986054
					return va;
  80402f:	8b 45 08             	mov    0x8(%ebp),%eax
  804032:	e9 27 02 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  804037:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80403b:	75 17                	jne    804054 <realloc_block_FF+0x29d>
  80403d:	83 ec 04             	sub    $0x4,%esp
  804040:	68 80 59 80 00       	push   $0x805980
  804045:	68 ed 01 00 00       	push   $0x1ed
  80404a:	68 d7 58 80 00       	push   $0x8058d7
  80404f:	e8 f8 d1 ff ff       	call   80124c <_panic>
  804054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804057:	8b 00                	mov    (%eax),%eax
  804059:	85 c0                	test   %eax,%eax
  80405b:	74 10                	je     80406d <realloc_block_FF+0x2b6>
  80405d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804060:	8b 00                	mov    (%eax),%eax
  804062:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804065:	8b 52 04             	mov    0x4(%edx),%edx
  804068:	89 50 04             	mov    %edx,0x4(%eax)
  80406b:	eb 0b                	jmp    804078 <realloc_block_FF+0x2c1>
  80406d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804070:	8b 40 04             	mov    0x4(%eax),%eax
  804073:	a3 4c 60 98 00       	mov    %eax,0x98604c
  804078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80407b:	8b 40 04             	mov    0x4(%eax),%eax
  80407e:	85 c0                	test   %eax,%eax
  804080:	74 0f                	je     804091 <realloc_block_FF+0x2da>
  804082:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804085:	8b 40 04             	mov    0x4(%eax),%eax
  804088:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80408b:	8b 12                	mov    (%edx),%edx
  80408d:	89 10                	mov    %edx,(%eax)
  80408f:	eb 0a                	jmp    80409b <realloc_block_FF+0x2e4>
  804091:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804094:	8b 00                	mov    (%eax),%eax
  804096:	a3 48 60 98 00       	mov    %eax,0x986048
  80409b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80409e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8040a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040ae:	a1 54 60 98 00       	mov    0x986054,%eax
  8040b3:	48                   	dec    %eax
  8040b4:	a3 54 60 98 00       	mov    %eax,0x986054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8040b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8040bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040bf:	01 d0                	add    %edx,%eax
  8040c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8040c4:	83 ec 04             	sub    $0x4,%esp
  8040c7:	6a 00                	push   $0x0
  8040c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8040cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8040cf:	e8 b3 f1 ff ff       	call   803287 <set_block_data>
  8040d4:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8040d7:	83 ec 0c             	sub    $0xc,%esp
  8040da:	ff 75 08             	pushl  0x8(%ebp)
  8040dd:	e8 42 ef ff ff       	call   803024 <is_free_block>
  8040e2:	83 c4 10             	add    $0x10,%esp
  8040e5:	84 c0                	test   %al,%al
  8040e7:	0f 94 c0             	sete   %al
  8040ea:	0f b6 c0             	movzbl %al,%eax
  8040ed:	83 ec 04             	sub    $0x4,%esp
  8040f0:	50                   	push   %eax
  8040f1:	ff 75 0c             	pushl  0xc(%ebp)
  8040f4:	ff 75 08             	pushl  0x8(%ebp)
  8040f7:	e8 8b f1 ff ff       	call   803287 <set_block_data>
  8040fc:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8040ff:	83 ec 0c             	sub    $0xc,%esp
  804102:	ff 75 f0             	pushl  -0x10(%ebp)
  804105:	e8 d4 f1 ff ff       	call   8032de <insert_sorted_in_freeList>
  80410a:	83 c4 10             	add    $0x10,%esp
					return va;
  80410d:	8b 45 08             	mov    0x8(%ebp),%eax
  804110:	e9 49 01 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  804115:	8b 45 0c             	mov    0xc(%ebp),%eax
  804118:	83 e8 08             	sub    $0x8,%eax
  80411b:	83 ec 0c             	sub    $0xc,%esp
  80411e:	50                   	push   %eax
  80411f:	e8 4d f3 ff ff       	call   803471 <alloc_block_FF>
  804124:	83 c4 10             	add    $0x10,%esp
  804127:	e9 32 01 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80412c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80412f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  804132:	0f 83 21 01 00 00    	jae    804259 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  804138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80413b:	2b 45 0c             	sub    0xc(%ebp),%eax
  80413e:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  804141:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  804145:	77 0e                	ja     804155 <realloc_block_FF+0x39e>
  804147:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80414b:	75 08                	jne    804155 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80414d:	8b 45 08             	mov    0x8(%ebp),%eax
  804150:	e9 09 01 00 00       	jmp    80425e <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  804155:	8b 45 08             	mov    0x8(%ebp),%eax
  804158:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80415b:	83 ec 0c             	sub    $0xc,%esp
  80415e:	ff 75 08             	pushl  0x8(%ebp)
  804161:	e8 be ee ff ff       	call   803024 <is_free_block>
  804166:	83 c4 10             	add    $0x10,%esp
  804169:	84 c0                	test   %al,%al
  80416b:	0f 94 c0             	sete   %al
  80416e:	0f b6 c0             	movzbl %al,%eax
  804171:	83 ec 04             	sub    $0x4,%esp
  804174:	50                   	push   %eax
  804175:	ff 75 0c             	pushl  0xc(%ebp)
  804178:	ff 75 d8             	pushl  -0x28(%ebp)
  80417b:	e8 07 f1 ff ff       	call   803287 <set_block_data>
  804180:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  804183:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804186:	8b 45 0c             	mov    0xc(%ebp),%eax
  804189:	01 d0                	add    %edx,%eax
  80418b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80418e:	83 ec 04             	sub    $0x4,%esp
  804191:	6a 00                	push   $0x0
  804193:	ff 75 dc             	pushl  -0x24(%ebp)
  804196:	ff 75 d4             	pushl  -0x2c(%ebp)
  804199:	e8 e9 f0 ff ff       	call   803287 <set_block_data>
  80419e:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8041a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8041a5:	0f 84 9b 00 00 00    	je     804246 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8041ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8041ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8041b1:	01 d0                	add    %edx,%eax
  8041b3:	83 ec 04             	sub    $0x4,%esp
  8041b6:	6a 00                	push   $0x0
  8041b8:	50                   	push   %eax
  8041b9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8041bc:	e8 c6 f0 ff ff       	call   803287 <set_block_data>
  8041c1:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8041c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8041c8:	75 17                	jne    8041e1 <realloc_block_FF+0x42a>
  8041ca:	83 ec 04             	sub    $0x4,%esp
  8041cd:	68 80 59 80 00       	push   $0x805980
  8041d2:	68 10 02 00 00       	push   $0x210
  8041d7:	68 d7 58 80 00       	push   $0x8058d7
  8041dc:	e8 6b d0 ff ff       	call   80124c <_panic>
  8041e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041e4:	8b 00                	mov    (%eax),%eax
  8041e6:	85 c0                	test   %eax,%eax
  8041e8:	74 10                	je     8041fa <realloc_block_FF+0x443>
  8041ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041ed:	8b 00                	mov    (%eax),%eax
  8041ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8041f2:	8b 52 04             	mov    0x4(%edx),%edx
  8041f5:	89 50 04             	mov    %edx,0x4(%eax)
  8041f8:	eb 0b                	jmp    804205 <realloc_block_FF+0x44e>
  8041fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8041fd:	8b 40 04             	mov    0x4(%eax),%eax
  804200:	a3 4c 60 98 00       	mov    %eax,0x98604c
  804205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804208:	8b 40 04             	mov    0x4(%eax),%eax
  80420b:	85 c0                	test   %eax,%eax
  80420d:	74 0f                	je     80421e <realloc_block_FF+0x467>
  80420f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804212:	8b 40 04             	mov    0x4(%eax),%eax
  804215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804218:	8b 12                	mov    (%edx),%edx
  80421a:	89 10                	mov    %edx,(%eax)
  80421c:	eb 0a                	jmp    804228 <realloc_block_FF+0x471>
  80421e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804221:	8b 00                	mov    (%eax),%eax
  804223:	a3 48 60 98 00       	mov    %eax,0x986048
  804228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80422b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804231:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804234:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80423b:	a1 54 60 98 00       	mov    0x986054,%eax
  804240:	48                   	dec    %eax
  804241:	a3 54 60 98 00       	mov    %eax,0x986054
			}
			insert_sorted_in_freeList(remainingBlk);
  804246:	83 ec 0c             	sub    $0xc,%esp
  804249:	ff 75 d4             	pushl  -0x2c(%ebp)
  80424c:	e8 8d f0 ff ff       	call   8032de <insert_sorted_in_freeList>
  804251:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  804254:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804257:	eb 05                	jmp    80425e <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  804259:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80425e:	c9                   	leave  
  80425f:	c3                   	ret    

00804260 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  804260:	55                   	push   %ebp
  804261:	89 e5                	mov    %esp,%ebp
  804263:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804266:	83 ec 04             	sub    $0x4,%esp
  804269:	68 a0 59 80 00       	push   $0x8059a0
  80426e:	68 20 02 00 00       	push   $0x220
  804273:	68 d7 58 80 00       	push   $0x8058d7
  804278:	e8 cf cf ff ff       	call   80124c <_panic>

0080427d <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80427d:	55                   	push   %ebp
  80427e:	89 e5                	mov    %esp,%ebp
  804280:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804283:	83 ec 04             	sub    $0x4,%esp
  804286:	68 c8 59 80 00       	push   $0x8059c8
  80428b:	68 28 02 00 00       	push   $0x228
  804290:	68 d7 58 80 00       	push   $0x8058d7
  804295:	e8 b2 cf ff ff       	call   80124c <_panic>
  80429a:	66 90                	xchg   %ax,%ax

0080429c <__udivdi3>:
  80429c:	55                   	push   %ebp
  80429d:	57                   	push   %edi
  80429e:	56                   	push   %esi
  80429f:	53                   	push   %ebx
  8042a0:	83 ec 1c             	sub    $0x1c,%esp
  8042a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8042a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8042ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8042af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8042b3:	89 ca                	mov    %ecx,%edx
  8042b5:	89 f8                	mov    %edi,%eax
  8042b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8042bb:	85 f6                	test   %esi,%esi
  8042bd:	75 2d                	jne    8042ec <__udivdi3+0x50>
  8042bf:	39 cf                	cmp    %ecx,%edi
  8042c1:	77 65                	ja     804328 <__udivdi3+0x8c>
  8042c3:	89 fd                	mov    %edi,%ebp
  8042c5:	85 ff                	test   %edi,%edi
  8042c7:	75 0b                	jne    8042d4 <__udivdi3+0x38>
  8042c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8042ce:	31 d2                	xor    %edx,%edx
  8042d0:	f7 f7                	div    %edi
  8042d2:	89 c5                	mov    %eax,%ebp
  8042d4:	31 d2                	xor    %edx,%edx
  8042d6:	89 c8                	mov    %ecx,%eax
  8042d8:	f7 f5                	div    %ebp
  8042da:	89 c1                	mov    %eax,%ecx
  8042dc:	89 d8                	mov    %ebx,%eax
  8042de:	f7 f5                	div    %ebp
  8042e0:	89 cf                	mov    %ecx,%edi
  8042e2:	89 fa                	mov    %edi,%edx
  8042e4:	83 c4 1c             	add    $0x1c,%esp
  8042e7:	5b                   	pop    %ebx
  8042e8:	5e                   	pop    %esi
  8042e9:	5f                   	pop    %edi
  8042ea:	5d                   	pop    %ebp
  8042eb:	c3                   	ret    
  8042ec:	39 ce                	cmp    %ecx,%esi
  8042ee:	77 28                	ja     804318 <__udivdi3+0x7c>
  8042f0:	0f bd fe             	bsr    %esi,%edi
  8042f3:	83 f7 1f             	xor    $0x1f,%edi
  8042f6:	75 40                	jne    804338 <__udivdi3+0x9c>
  8042f8:	39 ce                	cmp    %ecx,%esi
  8042fa:	72 0a                	jb     804306 <__udivdi3+0x6a>
  8042fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804300:	0f 87 9e 00 00 00    	ja     8043a4 <__udivdi3+0x108>
  804306:	b8 01 00 00 00       	mov    $0x1,%eax
  80430b:	89 fa                	mov    %edi,%edx
  80430d:	83 c4 1c             	add    $0x1c,%esp
  804310:	5b                   	pop    %ebx
  804311:	5e                   	pop    %esi
  804312:	5f                   	pop    %edi
  804313:	5d                   	pop    %ebp
  804314:	c3                   	ret    
  804315:	8d 76 00             	lea    0x0(%esi),%esi
  804318:	31 ff                	xor    %edi,%edi
  80431a:	31 c0                	xor    %eax,%eax
  80431c:	89 fa                	mov    %edi,%edx
  80431e:	83 c4 1c             	add    $0x1c,%esp
  804321:	5b                   	pop    %ebx
  804322:	5e                   	pop    %esi
  804323:	5f                   	pop    %edi
  804324:	5d                   	pop    %ebp
  804325:	c3                   	ret    
  804326:	66 90                	xchg   %ax,%ax
  804328:	89 d8                	mov    %ebx,%eax
  80432a:	f7 f7                	div    %edi
  80432c:	31 ff                	xor    %edi,%edi
  80432e:	89 fa                	mov    %edi,%edx
  804330:	83 c4 1c             	add    $0x1c,%esp
  804333:	5b                   	pop    %ebx
  804334:	5e                   	pop    %esi
  804335:	5f                   	pop    %edi
  804336:	5d                   	pop    %ebp
  804337:	c3                   	ret    
  804338:	bd 20 00 00 00       	mov    $0x20,%ebp
  80433d:	89 eb                	mov    %ebp,%ebx
  80433f:	29 fb                	sub    %edi,%ebx
  804341:	89 f9                	mov    %edi,%ecx
  804343:	d3 e6                	shl    %cl,%esi
  804345:	89 c5                	mov    %eax,%ebp
  804347:	88 d9                	mov    %bl,%cl
  804349:	d3 ed                	shr    %cl,%ebp
  80434b:	89 e9                	mov    %ebp,%ecx
  80434d:	09 f1                	or     %esi,%ecx
  80434f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  804353:	89 f9                	mov    %edi,%ecx
  804355:	d3 e0                	shl    %cl,%eax
  804357:	89 c5                	mov    %eax,%ebp
  804359:	89 d6                	mov    %edx,%esi
  80435b:	88 d9                	mov    %bl,%cl
  80435d:	d3 ee                	shr    %cl,%esi
  80435f:	89 f9                	mov    %edi,%ecx
  804361:	d3 e2                	shl    %cl,%edx
  804363:	8b 44 24 08          	mov    0x8(%esp),%eax
  804367:	88 d9                	mov    %bl,%cl
  804369:	d3 e8                	shr    %cl,%eax
  80436b:	09 c2                	or     %eax,%edx
  80436d:	89 d0                	mov    %edx,%eax
  80436f:	89 f2                	mov    %esi,%edx
  804371:	f7 74 24 0c          	divl   0xc(%esp)
  804375:	89 d6                	mov    %edx,%esi
  804377:	89 c3                	mov    %eax,%ebx
  804379:	f7 e5                	mul    %ebp
  80437b:	39 d6                	cmp    %edx,%esi
  80437d:	72 19                	jb     804398 <__udivdi3+0xfc>
  80437f:	74 0b                	je     80438c <__udivdi3+0xf0>
  804381:	89 d8                	mov    %ebx,%eax
  804383:	31 ff                	xor    %edi,%edi
  804385:	e9 58 ff ff ff       	jmp    8042e2 <__udivdi3+0x46>
  80438a:	66 90                	xchg   %ax,%ax
  80438c:	8b 54 24 08          	mov    0x8(%esp),%edx
  804390:	89 f9                	mov    %edi,%ecx
  804392:	d3 e2                	shl    %cl,%edx
  804394:	39 c2                	cmp    %eax,%edx
  804396:	73 e9                	jae    804381 <__udivdi3+0xe5>
  804398:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80439b:	31 ff                	xor    %edi,%edi
  80439d:	e9 40 ff ff ff       	jmp    8042e2 <__udivdi3+0x46>
  8043a2:	66 90                	xchg   %ax,%ax
  8043a4:	31 c0                	xor    %eax,%eax
  8043a6:	e9 37 ff ff ff       	jmp    8042e2 <__udivdi3+0x46>
  8043ab:	90                   	nop

008043ac <__umoddi3>:
  8043ac:	55                   	push   %ebp
  8043ad:	57                   	push   %edi
  8043ae:	56                   	push   %esi
  8043af:	53                   	push   %ebx
  8043b0:	83 ec 1c             	sub    $0x1c,%esp
  8043b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8043b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8043bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8043bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8043c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8043cb:	89 f3                	mov    %esi,%ebx
  8043cd:	89 fa                	mov    %edi,%edx
  8043cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8043d3:	89 34 24             	mov    %esi,(%esp)
  8043d6:	85 c0                	test   %eax,%eax
  8043d8:	75 1a                	jne    8043f4 <__umoddi3+0x48>
  8043da:	39 f7                	cmp    %esi,%edi
  8043dc:	0f 86 a2 00 00 00    	jbe    804484 <__umoddi3+0xd8>
  8043e2:	89 c8                	mov    %ecx,%eax
  8043e4:	89 f2                	mov    %esi,%edx
  8043e6:	f7 f7                	div    %edi
  8043e8:	89 d0                	mov    %edx,%eax
  8043ea:	31 d2                	xor    %edx,%edx
  8043ec:	83 c4 1c             	add    $0x1c,%esp
  8043ef:	5b                   	pop    %ebx
  8043f0:	5e                   	pop    %esi
  8043f1:	5f                   	pop    %edi
  8043f2:	5d                   	pop    %ebp
  8043f3:	c3                   	ret    
  8043f4:	39 f0                	cmp    %esi,%eax
  8043f6:	0f 87 ac 00 00 00    	ja     8044a8 <__umoddi3+0xfc>
  8043fc:	0f bd e8             	bsr    %eax,%ebp
  8043ff:	83 f5 1f             	xor    $0x1f,%ebp
  804402:	0f 84 ac 00 00 00    	je     8044b4 <__umoddi3+0x108>
  804408:	bf 20 00 00 00       	mov    $0x20,%edi
  80440d:	29 ef                	sub    %ebp,%edi
  80440f:	89 fe                	mov    %edi,%esi
  804411:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804415:	89 e9                	mov    %ebp,%ecx
  804417:	d3 e0                	shl    %cl,%eax
  804419:	89 d7                	mov    %edx,%edi
  80441b:	89 f1                	mov    %esi,%ecx
  80441d:	d3 ef                	shr    %cl,%edi
  80441f:	09 c7                	or     %eax,%edi
  804421:	89 e9                	mov    %ebp,%ecx
  804423:	d3 e2                	shl    %cl,%edx
  804425:	89 14 24             	mov    %edx,(%esp)
  804428:	89 d8                	mov    %ebx,%eax
  80442a:	d3 e0                	shl    %cl,%eax
  80442c:	89 c2                	mov    %eax,%edx
  80442e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804432:	d3 e0                	shl    %cl,%eax
  804434:	89 44 24 04          	mov    %eax,0x4(%esp)
  804438:	8b 44 24 08          	mov    0x8(%esp),%eax
  80443c:	89 f1                	mov    %esi,%ecx
  80443e:	d3 e8                	shr    %cl,%eax
  804440:	09 d0                	or     %edx,%eax
  804442:	d3 eb                	shr    %cl,%ebx
  804444:	89 da                	mov    %ebx,%edx
  804446:	f7 f7                	div    %edi
  804448:	89 d3                	mov    %edx,%ebx
  80444a:	f7 24 24             	mull   (%esp)
  80444d:	89 c6                	mov    %eax,%esi
  80444f:	89 d1                	mov    %edx,%ecx
  804451:	39 d3                	cmp    %edx,%ebx
  804453:	0f 82 87 00 00 00    	jb     8044e0 <__umoddi3+0x134>
  804459:	0f 84 91 00 00 00    	je     8044f0 <__umoddi3+0x144>
  80445f:	8b 54 24 04          	mov    0x4(%esp),%edx
  804463:	29 f2                	sub    %esi,%edx
  804465:	19 cb                	sbb    %ecx,%ebx
  804467:	89 d8                	mov    %ebx,%eax
  804469:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80446d:	d3 e0                	shl    %cl,%eax
  80446f:	89 e9                	mov    %ebp,%ecx
  804471:	d3 ea                	shr    %cl,%edx
  804473:	09 d0                	or     %edx,%eax
  804475:	89 e9                	mov    %ebp,%ecx
  804477:	d3 eb                	shr    %cl,%ebx
  804479:	89 da                	mov    %ebx,%edx
  80447b:	83 c4 1c             	add    $0x1c,%esp
  80447e:	5b                   	pop    %ebx
  80447f:	5e                   	pop    %esi
  804480:	5f                   	pop    %edi
  804481:	5d                   	pop    %ebp
  804482:	c3                   	ret    
  804483:	90                   	nop
  804484:	89 fd                	mov    %edi,%ebp
  804486:	85 ff                	test   %edi,%edi
  804488:	75 0b                	jne    804495 <__umoddi3+0xe9>
  80448a:	b8 01 00 00 00       	mov    $0x1,%eax
  80448f:	31 d2                	xor    %edx,%edx
  804491:	f7 f7                	div    %edi
  804493:	89 c5                	mov    %eax,%ebp
  804495:	89 f0                	mov    %esi,%eax
  804497:	31 d2                	xor    %edx,%edx
  804499:	f7 f5                	div    %ebp
  80449b:	89 c8                	mov    %ecx,%eax
  80449d:	f7 f5                	div    %ebp
  80449f:	89 d0                	mov    %edx,%eax
  8044a1:	e9 44 ff ff ff       	jmp    8043ea <__umoddi3+0x3e>
  8044a6:	66 90                	xchg   %ax,%ax
  8044a8:	89 c8                	mov    %ecx,%eax
  8044aa:	89 f2                	mov    %esi,%edx
  8044ac:	83 c4 1c             	add    $0x1c,%esp
  8044af:	5b                   	pop    %ebx
  8044b0:	5e                   	pop    %esi
  8044b1:	5f                   	pop    %edi
  8044b2:	5d                   	pop    %ebp
  8044b3:	c3                   	ret    
  8044b4:	3b 04 24             	cmp    (%esp),%eax
  8044b7:	72 06                	jb     8044bf <__umoddi3+0x113>
  8044b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8044bd:	77 0f                	ja     8044ce <__umoddi3+0x122>
  8044bf:	89 f2                	mov    %esi,%edx
  8044c1:	29 f9                	sub    %edi,%ecx
  8044c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8044c7:	89 14 24             	mov    %edx,(%esp)
  8044ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8044ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8044d2:	8b 14 24             	mov    (%esp),%edx
  8044d5:	83 c4 1c             	add    $0x1c,%esp
  8044d8:	5b                   	pop    %ebx
  8044d9:	5e                   	pop    %esi
  8044da:	5f                   	pop    %edi
  8044db:	5d                   	pop    %ebp
  8044dc:	c3                   	ret    
  8044dd:	8d 76 00             	lea    0x0(%esi),%esi
  8044e0:	2b 04 24             	sub    (%esp),%eax
  8044e3:	19 fa                	sbb    %edi,%edx
  8044e5:	89 d1                	mov    %edx,%ecx
  8044e7:	89 c6                	mov    %eax,%esi
  8044e9:	e9 71 ff ff ff       	jmp    80445f <__umoddi3+0xb3>
  8044ee:	66 90                	xchg   %ax,%ax
  8044f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8044f4:	72 ea                	jb     8044e0 <__umoddi3+0x134>
  8044f6:	89 d9                	mov    %ebx,%ecx
  8044f8:	e9 62 ff ff ff       	jmp    80445f <__umoddi3+0xb3>
