
obj/user/tst_free_1:     file format elf32-i386


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
  800031:	e8 7e 16 00 00       	call   8016b4 <libmain>
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
  80005e:	81 ec b0 01 00 00    	sub    $0x1b0,%esp

#if USE_KHEAP
	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800064:	a1 20 70 80 00       	mov    0x807020,%eax
  800069:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80006f:	a1 20 70 80 00       	mov    0x807020,%eax
  800074:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80007a:	39 c2                	cmp    %eax,%edx
  80007c:	72 14                	jb     800092 <_main+0x39>
			panic("Please increase the WS size");
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	68 60 4b 80 00       	push   $0x804b60
  800086:	6a 1e                	push   $0x1e
  800088:	68 7c 4b 80 00       	push   $0x804b7c
  80008d:	e8 67 17 00 00       	call   8017f9 <_panic>
	}
	/*=================================================*/
#else
	panic("not handled!");
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800092:	c7 45 ec 00 10 00 82 	movl   $0x82001000,-0x14(%ebp)

	int eval = 0;
  800099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	bool is_correct = 1;
  8000a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

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
	short *shortArr, *shortArr2 ;
	int *intArr;
	struct MyStruct *structArr ;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	bool found;
	int start_freeFrames = sys_calculate_free_frames() ;
  8000d7:	e8 5f 2f 00 00       	call   80303b <sys_calculate_free_frames>
  8000dc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	cprintf("\n%~[1] Allocate spaces of different sizes in PAGE ALLOCATOR and write some data to them\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 90 4b 80 00       	push   $0x804b90
  8000e7:	e8 ca 19 00 00       	call   801ab6 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
	void* ptr_allocations[20] = {0};
  8000ef:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  8000f5:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ff:	89 d7                	mov    %edx,%edi
  800101:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//cprintf("3\n");
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800103:	e8 33 2f 00 00       	call   80303b <sys_calculate_free_frames>
  800108:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 76 2f 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800110:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	01 c0                	add    %eax,%eax
  800118:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	50                   	push   %eax
  80011f:	e8 42 27 00 00       	call   802866 <malloc>
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	89 85 bc fe ff ff    	mov    %eax,-0x144(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) {is_correct = 0; cprintf("1 Wrong start address for the allocated space... \n");}
  80012d:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800133:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800136:	74 17                	je     80014f <_main+0xf6>
  800138:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 ec 4b 80 00       	push   $0x804bec
  800147:	e8 6a 19 00 00       	call   801ab6 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  80014f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800156:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800159:	e8 dd 2e 00 00       	call   80303b <sys_calculate_free_frames>
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
  800195:	68 20 4c 80 00       	push   $0x804c20
  80019a:	e8 17 19 00 00       	call   801ab6 <cprintf>
  80019f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("1 Extra or less pages are allocated in PageFile\n");}
  8001a2:	e8 df 2e 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  8001a7:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001aa:	74 17                	je     8001c3 <_main+0x16a>
  8001ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 90 4c 80 00       	push   $0x804c90
  8001bb:	e8 f6 18 00 00       	call   801ab6 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  8001c3:	e8 73 2e 00 00       	call   80303b <sys_calculate_free_frames>
  8001c8:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ce:	01 c0                	add    %eax,%eax
  8001d0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001d3:	48                   	dec    %eax
  8001d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
			byteArr = (char *) ptr_allocations[0];
  8001d7:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
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
  8001ff:	e8 37 2e 00 00       	call   80303b <sys_calculate_free_frames>
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
  800237:	68 c4 4c 80 00       	push   $0x804cc4
  80023c:	e8 75 18 00 00       	call   801ab6 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800244:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800247:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80024a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80024d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800252:	89 85 b4 fe ff ff    	mov    %eax,-0x14c(%ebp)
  800258:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80025b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80025e:	01 d0                	add    %edx,%eax
  800260:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800263:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800266:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80026b:	89 85 b8 fe ff ff    	mov    %eax,-0x148(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  800271:	6a 02                	push   $0x2
  800273:	6a 00                	push   $0x0
  800275:	6a 02                	push   $0x2
  800277:	8d 85 b4 fe ff ff    	lea    -0x14c(%ebp),%eax
  80027d:	50                   	push   %eax
  80027e:	e8 13 32 00 00       	call   803496 <sys_check_WS_list>
  800283:	83 c4 10             	add    $0x10,%esp
  800286:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("1 malloc: page is not added to WS\n");}
  800289:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80028d:	74 17                	je     8002a6 <_main+0x24d>
  80028f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800296:	83 ec 0c             	sub    $0xc,%esp
  800299:	68 44 4d 80 00       	push   $0x804d44
  80029e:	e8 13 18 00 00       	call   801ab6 <cprintf>
  8002a3:	83 c4 10             	add    $0x10,%esp
		}
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8002a6:	e8 90 2d 00 00       	call   80303b <sys_calculate_free_frames>
  8002ab:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002ae:	e8 d3 2d 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  8002b3:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[1] = malloc(2*Mega-kilo);
  8002b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002b9:	01 c0                	add    %eax,%eax
  8002bb:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	50                   	push   %eax
  8002c2:	e8 9f 25 00 00       	call   802866 <malloc>
  8002c7:	83 c4 10             	add    $0x10,%esp
  8002ca:	89 85 c0 fe ff ff    	mov    %eax,-0x140(%ebp)
			if ((uint32) ptr_allocations[1] != (pagealloc_start + 2*Mega)) { is_correct = 0; cprintf("2 Wrong start address for the allocated space... \n");}
  8002d0:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  8002d6:	89 c2                	mov    %eax,%edx
  8002d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002db:	01 c0                	add    %eax,%eax
  8002dd:	89 c1                	mov    %eax,%ecx
  8002df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e2:	01 c8                	add    %ecx,%eax
  8002e4:	39 c2                	cmp    %eax,%edx
  8002e6:	74 17                	je     8002ff <_main+0x2a6>
  8002e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	68 68 4d 80 00       	push   $0x804d68
  8002f7:	e8 ba 17 00 00       	call   801ab6 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table exists*/ ;
  8002ff:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800306:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800309:	e8 2d 2d 00 00       	call   80303b <sys_calculate_free_frames>
  80030e:	29 c3                	sub    %eax,%ebx
  800310:	89 d8                	mov    %ebx,%eax
  800312:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800315:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800318:	83 c0 02             	add    $0x2,%eax
  80031b:	83 ec 04             	sub    $0x4,%esp
  80031e:	50                   	push   %eax
  80031f:	ff 75 c4             	pushl  -0x3c(%ebp)
  800322:	ff 75 c0             	pushl  -0x40(%ebp)
  800325:	e8 0e fd ff ff       	call   800038 <inRange>
  80032a:	83 c4 10             	add    $0x10,%esp
  80032d:	85 c0                	test   %eax,%eax
  80032f:	75 21                	jne    800352 <_main+0x2f9>
			{is_correct = 0; cprintf("2 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800338:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80033b:	83 c0 02             	add    $0x2,%eax
  80033e:	ff 75 c0             	pushl  -0x40(%ebp)
  800341:	50                   	push   %eax
  800342:	ff 75 c4             	pushl  -0x3c(%ebp)
  800345:	68 9c 4d 80 00       	push   $0x804d9c
  80034a:	e8 67 17 00 00       	call   801ab6 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("2 Extra or less pages are allocated in PageFile\n");}
  800352:	e8 2f 2d 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800357:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80035a:	74 17                	je     800373 <_main+0x31a>
  80035c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 0c 4e 80 00       	push   $0x804e0c
  80036b:	e8 46 17 00 00       	call   801ab6 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800373:	e8 c3 2c 00 00       	call   80303b <sys_calculate_free_frames>
  800378:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr = (short *) ptr_allocations[1];
  80037b:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800381:	89 45 a8             	mov    %eax,-0x58(%ebp)
			lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800384:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800387:	01 c0                	add    %eax,%eax
  800389:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80038c:	d1 e8                	shr    %eax
  80038e:	48                   	dec    %eax
  80038f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			shortArr[0] = minShort;
  800392:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800398:	66 89 02             	mov    %ax,(%edx)
			shortArr[lastIndexOfShort] = maxShort;
  80039b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80039e:	01 c0                	add    %eax,%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003a5:	01 c2                	add    %eax,%edx
  8003a7:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8003ab:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 2 ;
  8003ae:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8003b5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003b8:	e8 7e 2c 00 00       	call   80303b <sys_calculate_free_frames>
  8003bd:	29 c3                	sub    %eax,%ebx
  8003bf:	89 d8                	mov    %ebx,%eax
  8003c1:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8003c4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003c7:	83 c0 02             	add    $0x2,%eax
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	50                   	push   %eax
  8003ce:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <inRange>
  8003d9:	83 c4 10             	add    $0x10,%esp
  8003dc:	85 c0                	test   %eax,%eax
  8003de:	75 1d                	jne    8003fd <_main+0x3a4>
			{ is_correct = 0; cprintf("2 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  8003e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	ff 75 c0             	pushl  -0x40(%ebp)
  8003ed:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f0:	68 40 4e 80 00       	push   $0x804e40
  8003f5:	e8 bc 16 00 00       	call   801ab6 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  8003fd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800400:	89 45 a0             	mov    %eax,-0x60(%ebp)
  800403:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800406:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040b:	89 85 ac fe ff ff    	mov    %eax,-0x154(%ebp)
  800411:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800414:	01 c0                	add    %eax,%eax
  800416:	89 c2                	mov    %eax,%edx
  800418:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80041b:	01 d0                	add    %edx,%eax
  80041d:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800420:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800423:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800428:	89 85 b0 fe ff ff    	mov    %eax,-0x150(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80042e:	6a 02                	push   $0x2
  800430:	6a 00                	push   $0x0
  800432:	6a 02                	push   $0x2
  800434:	8d 85 ac fe ff ff    	lea    -0x154(%ebp),%eax
  80043a:	50                   	push   %eax
  80043b:	e8 56 30 00 00       	call   803496 <sys_check_WS_list>
  800440:	83 c4 10             	add    $0x10,%esp
  800443:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("2 malloc: page is not added to WS\n");}
  800446:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  80044a:	74 17                	je     800463 <_main+0x40a>
  80044c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800453:	83 ec 0c             	sub    $0xc,%esp
  800456:	68 c0 4e 80 00       	push   $0x804ec0
  80045b:	e8 56 16 00 00       	call   801ab6 <cprintf>
  800460:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800463:	e8 1e 2c 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800468:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[2] = malloc(3*kilo);
  80046b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80046e:	89 c2                	mov    %eax,%edx
  800470:	01 d2                	add    %edx,%edx
  800472:	01 d0                	add    %edx,%eax
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	50                   	push   %eax
  800478:	e8 e9 23 00 00       	call   802866 <malloc>
  80047d:	83 c4 10             	add    $0x10,%esp
  800480:	89 85 c4 fe ff ff    	mov    %eax,-0x13c(%ebp)
			if ((uint32) ptr_allocations[2] != (pagealloc_start + 4*Mega)) { is_correct = 0; cprintf("3 Wrong start address for the allocated space... \n");}
  800486:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  80048c:	89 c2                	mov    %eax,%edx
  80048e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800491:	c1 e0 02             	shl    $0x2,%eax
  800494:	89 c1                	mov    %eax,%ecx
  800496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800499:	01 c8                	add    %ecx,%eax
  80049b:	39 c2                	cmp    %eax,%edx
  80049d:	74 17                	je     8004b6 <_main+0x45d>
  80049f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a6:	83 ec 0c             	sub    $0xc,%esp
  8004a9:	68 e4 4e 80 00       	push   $0x804ee4
  8004ae:	e8 03 16 00 00       	call   801ab6 <cprintf>
  8004b3:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 1 /*table*/ ;
  8004b6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  8004bd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c0:	e8 76 2b 00 00       	call   80303b <sys_calculate_free_frames>
  8004c5:	29 c3                	sub    %eax,%ebx
  8004c7:	89 d8                	mov    %ebx,%eax
  8004c9:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  8004cc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004cf:	83 c0 02             	add    $0x2,%eax
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004d9:	ff 75 c0             	pushl  -0x40(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <inRange>
  8004e1:	83 c4 10             	add    $0x10,%esp
  8004e4:	85 c0                	test   %eax,%eax
  8004e6:	75 21                	jne    800509 <_main+0x4b0>
			{is_correct = 0; cprintf("3 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  8004e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f2:	83 c0 02             	add    $0x2,%eax
  8004f5:	ff 75 c0             	pushl  -0x40(%ebp)
  8004f8:	50                   	push   %eax
  8004f9:	ff 75 c4             	pushl  -0x3c(%ebp)
  8004fc:	68 18 4f 80 00       	push   $0x804f18
  800501:	e8 b0 15 00 00       	call   801ab6 <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("3 Extra or less pages are allocated in PageFile\n");}
  800509:	e8 78 2b 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  80050e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800511:	74 17                	je     80052a <_main+0x4d1>
  800513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	68 88 4f 80 00       	push   $0x804f88
  800522:	e8 8f 15 00 00       	call   801ab6 <cprintf>
  800527:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  80052a:	e8 0c 2b 00 00       	call   80303b <sys_calculate_free_frames>
  80052f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			intArr = (int *) ptr_allocations[2];
  800532:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  800538:	89 45 98             	mov    %eax,-0x68(%ebp)
			lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  80053b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80053e:	01 c0                	add    %eax,%eax
  800540:	c1 e8 02             	shr    $0x2,%eax
  800543:	48                   	dec    %eax
  800544:	89 45 94             	mov    %eax,-0x6c(%ebp)
			intArr[0] = minInt;
  800547:	8b 45 98             	mov    -0x68(%ebp),%eax
  80054a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80054d:	89 10                	mov    %edx,(%eax)
			intArr[lastIndexOfInt] = maxInt;
  80054f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800552:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800559:	8b 45 98             	mov    -0x68(%ebp),%eax
  80055c:	01 c2                	add    %eax,%edx
  80055e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800561:	89 02                	mov    %eax,(%edx)
			expectedNumOfFrames = 1 ;
  800563:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80056a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80056d:	e8 c9 2a 00 00       	call   80303b <sys_calculate_free_frames>
  800572:	29 c3                	sub    %eax,%ebx
  800574:	89 d8                	mov    %ebx,%eax
  800576:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800579:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80057c:	83 c0 02             	add    $0x2,%eax
  80057f:	83 ec 04             	sub    $0x4,%esp
  800582:	50                   	push   %eax
  800583:	ff 75 c4             	pushl  -0x3c(%ebp)
  800586:	ff 75 c0             	pushl  -0x40(%ebp)
  800589:	e8 aa fa ff ff       	call   800038 <inRange>
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	85 c0                	test   %eax,%eax
  800593:	75 1d                	jne    8005b2 <_main+0x559>
			{ is_correct = 0; cprintf("3 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800595:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059c:	83 ec 04             	sub    $0x4,%esp
  80059f:	ff 75 c0             	pushl  -0x40(%ebp)
  8005a2:	ff 75 c4             	pushl  -0x3c(%ebp)
  8005a5:	68 bc 4f 80 00       	push   $0x804fbc
  8005aa:	e8 07 15 00 00       	call   801ab6 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  8005b2:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005b5:	89 45 90             	mov    %eax,-0x70(%ebp)
  8005b8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8005bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c0:	89 85 a4 fe ff ff    	mov    %eax,-0x15c(%ebp)
  8005c6:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8005d3:	01 d0                	add    %edx,%eax
  8005d5:	89 45 8c             	mov    %eax,-0x74(%ebp)
  8005d8:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8005db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005e0:	89 85 a8 fe ff ff    	mov    %eax,-0x158(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8005e6:	6a 02                	push   $0x2
  8005e8:	6a 00                	push   $0x0
  8005ea:	6a 02                	push   $0x2
  8005ec:	8d 85 a4 fe ff ff    	lea    -0x15c(%ebp),%eax
  8005f2:	50                   	push   %eax
  8005f3:	e8 9e 2e 00 00       	call   803496 <sys_check_WS_list>
  8005f8:	83 c4 10             	add    $0x10,%esp
  8005fb:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("3 malloc: page is not added to WS\n");}
  8005fe:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800602:	74 17                	je     80061b <_main+0x5c2>
  800604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80060b:	83 ec 0c             	sub    $0xc,%esp
  80060e:	68 3c 50 80 00       	push   $0x80503c
  800613:	e8 9e 14 00 00       	call   801ab6 <cprintf>
  800618:	83 c4 10             	add    $0x10,%esp
		}

		//3 KB
		{
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80061b:	e8 66 2a 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800620:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[3] = malloc(3*kilo);
  800623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800626:	89 c2                	mov    %eax,%edx
  800628:	01 d2                	add    %edx,%edx
  80062a:	01 d0                	add    %edx,%eax
  80062c:	83 ec 0c             	sub    $0xc,%esp
  80062f:	50                   	push   %eax
  800630:	e8 31 22 00 00       	call   802866 <malloc>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	89 85 c8 fe ff ff    	mov    %eax,-0x138(%ebp)
			if ((uint32) ptr_allocations[3] != (pagealloc_start + 4*Mega + 4*kilo)) { is_correct = 0; cprintf("4 Wrong start address for the allocated space... \n");}
  80063e:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  800644:	89 c2                	mov    %eax,%edx
  800646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800649:	c1 e0 02             	shl    $0x2,%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800651:	c1 e0 02             	shl    $0x2,%eax
  800654:	01 c1                	add    %eax,%ecx
  800656:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800659:	01 c8                	add    %ecx,%eax
  80065b:	39 c2                	cmp    %eax,%edx
  80065d:	74 17                	je     800676 <_main+0x61d>
  80065f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800666:	83 ec 0c             	sub    $0xc,%esp
  800669:	68 60 50 80 00       	push   $0x805060
  80066e:	e8 43 14 00 00       	call   801ab6 <cprintf>
  800673:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("4 Extra or less pages are allocated in PageFile\n");}
  800676:	e8 0b 2a 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  80067b:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80067e:	74 17                	je     800697 <_main+0x63e>
  800680:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	68 94 50 80 00       	push   $0x805094
  80068f:	e8 22 14 00 00       	call   801ab6 <cprintf>
  800694:	83 c4 10             	add    $0x10,%esp
		}
		//7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800697:	e8 9f 29 00 00       	call   80303b <sys_calculate_free_frames>
  80069c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80069f:	e8 e2 29 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  8006a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[4] = malloc(7*kilo);
  8006a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006aa:	89 d0                	mov    %edx,%eax
  8006ac:	01 c0                	add    %eax,%eax
  8006ae:	01 d0                	add    %edx,%eax
  8006b0:	01 c0                	add    %eax,%eax
  8006b2:	01 d0                	add    %edx,%eax
  8006b4:	83 ec 0c             	sub    $0xc,%esp
  8006b7:	50                   	push   %eax
  8006b8:	e8 a9 21 00 00       	call   802866 <malloc>
  8006bd:	83 c4 10             	add    $0x10,%esp
  8006c0:	89 85 cc fe ff ff    	mov    %eax,-0x134(%ebp)
			if ((uint32) ptr_allocations[4] != (pagealloc_start + 4*Mega + 8*kilo)) { is_correct = 0; cprintf("5 Wrong start address for the allocated space... \n");}
  8006c6:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  8006cc:	89 c2                	mov    %eax,%edx
  8006ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006d1:	c1 e0 02             	shl    $0x2,%eax
  8006d4:	89 c1                	mov    %eax,%ecx
  8006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006d9:	c1 e0 03             	shl    $0x3,%eax
  8006dc:	01 c1                	add    %eax,%ecx
  8006de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006e1:	01 c8                	add    %ecx,%eax
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	74 17                	je     8006fe <_main+0x6a5>
  8006e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8006ee:	83 ec 0c             	sub    $0xc,%esp
  8006f1:	68 c8 50 80 00       	push   $0x8050c8
  8006f6:	e8 bb 13 00 00       	call   801ab6 <cprintf>
  8006fb:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  8006fe:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800705:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800708:	e8 2e 29 00 00       	call   80303b <sys_calculate_free_frames>
  80070d:	29 c3                	sub    %eax,%ebx
  80070f:	89 d8                	mov    %ebx,%eax
  800711:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800714:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800717:	83 c0 02             	add    $0x2,%eax
  80071a:	83 ec 04             	sub    $0x4,%esp
  80071d:	50                   	push   %eax
  80071e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800721:	ff 75 c0             	pushl  -0x40(%ebp)
  800724:	e8 0f f9 ff ff       	call   800038 <inRange>
  800729:	83 c4 10             	add    $0x10,%esp
  80072c:	85 c0                	test   %eax,%eax
  80072e:	75 21                	jne    800751 <_main+0x6f8>
			{is_correct = 0; cprintf("5 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800737:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80073a:	83 c0 02             	add    $0x2,%eax
  80073d:	ff 75 c0             	pushl  -0x40(%ebp)
  800740:	50                   	push   %eax
  800741:	ff 75 c4             	pushl  -0x3c(%ebp)
  800744:	68 fc 50 80 00       	push   $0x8050fc
  800749:	e8 68 13 00 00       	call   801ab6 <cprintf>
  80074e:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("5 Extra or less pages are allocated in PageFile\n");}
  800751:	e8 30 29 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800756:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800759:	74 17                	je     800772 <_main+0x719>
  80075b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	68 6c 51 80 00       	push   $0x80516c
  80076a:	e8 47 13 00 00       	call   801ab6 <cprintf>
  80076f:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800772:	e8 c4 28 00 00       	call   80303b <sys_calculate_free_frames>
  800777:	89 45 cc             	mov    %eax,-0x34(%ebp)
			structArr = (struct MyStruct *) ptr_allocations[4];
  80077a:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  800780:	89 45 88             	mov    %eax,-0x78(%ebp)
			lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  800783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800786:	89 d0                	mov    %edx,%eax
  800788:	01 c0                	add    %eax,%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	01 c0                	add    %eax,%eax
  80078e:	01 d0                	add    %edx,%eax
  800790:	c1 e8 03             	shr    $0x3,%eax
  800793:	48                   	dec    %eax
  800794:	89 45 84             	mov    %eax,-0x7c(%ebp)
			structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  800797:	8b 45 88             	mov    -0x78(%ebp),%eax
  80079a:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  80079d:	88 10                	mov    %dl,(%eax)
  80079f:	8b 55 88             	mov    -0x78(%ebp),%edx
  8007a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a5:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007a9:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007af:	89 50 04             	mov    %edx,0x4(%eax)
			structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  8007b2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007bc:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007bf:	01 c2                	add    %eax,%edx
  8007c1:	8a 45 e2             	mov    -0x1e(%ebp),%al
  8007c4:	88 02                	mov    %al,(%edx)
  8007c6:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007d0:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007d3:	01 c2                	add    %eax,%edx
  8007d5:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  8007d9:	66 89 42 02          	mov    %ax,0x2(%edx)
  8007dd:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007e7:	8b 45 88             	mov    -0x78(%ebp),%eax
  8007ea:	01 c2                	add    %eax,%edx
  8007ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007ef:	89 42 04             	mov    %eax,0x4(%edx)
			expectedNumOfFrames = 2 ;
  8007f2:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  8007f9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8007fc:	e8 3a 28 00 00       	call   80303b <sys_calculate_free_frames>
  800801:	29 c3                	sub    %eax,%ebx
  800803:	89 d8                	mov    %ebx,%eax
  800805:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800808:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80080b:	83 c0 02             	add    $0x2,%eax
  80080e:	83 ec 04             	sub    $0x4,%esp
  800811:	50                   	push   %eax
  800812:	ff 75 c4             	pushl  -0x3c(%ebp)
  800815:	ff 75 c0             	pushl  -0x40(%ebp)
  800818:	e8 1b f8 ff ff       	call   800038 <inRange>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	85 c0                	test   %eax,%eax
  800822:	75 1d                	jne    800841 <_main+0x7e8>
			{ is_correct = 0; cprintf("5 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800824:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80082b:	83 ec 04             	sub    $0x4,%esp
  80082e:	ff 75 c0             	pushl  -0x40(%ebp)
  800831:	ff 75 c4             	pushl  -0x3c(%ebp)
  800834:	68 a0 51 80 00       	push   $0x8051a0
  800839:	e8 78 12 00 00       	call   801ab6 <cprintf>
  80083e:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  800841:	8b 45 88             	mov    -0x78(%ebp),%eax
  800844:	89 45 80             	mov    %eax,-0x80(%ebp)
  800847:	8b 45 80             	mov    -0x80(%ebp),%eax
  80084a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80084f:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
  800855:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800858:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80085f:	8b 45 88             	mov    -0x78(%ebp),%eax
  800862:	01 d0                	add    %edx,%eax
  800864:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  80086a:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800870:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800875:	89 85 a0 fe ff ff    	mov    %eax,-0x160(%ebp)
			found = sys_check_WS_list(expectedVAs, 2, 0, 2);
  80087b:	6a 02                	push   $0x2
  80087d:	6a 00                	push   $0x0
  80087f:	6a 02                	push   $0x2
  800881:	8d 85 9c fe ff ff    	lea    -0x164(%ebp),%eax
  800887:	50                   	push   %eax
  800888:	e8 09 2c 00 00       	call   803496 <sys_check_WS_list>
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("5 malloc: page is not added to WS\n");}
  800893:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800897:	74 17                	je     8008b0 <_main+0x857>
  800899:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	68 20 52 80 00       	push   $0x805220
  8008a8:	e8 09 12 00 00       	call   801ab6 <cprintf>
  8008ad:	83 c4 10             	add    $0x10,%esp
		}
		//3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8008b0:	e8 86 27 00 00       	call   80303b <sys_calculate_free_frames>
  8008b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008b8:	e8 c9 27 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  8008bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[5] = malloc(3*Mega-kilo);
  8008c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008c3:	89 c2                	mov    %eax,%edx
  8008c5:	01 d2                	add    %edx,%edx
  8008c7:	01 d0                	add    %edx,%eax
  8008c9:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	50                   	push   %eax
  8008d0:	e8 91 1f 00 00       	call   802866 <malloc>
  8008d5:	83 c4 10             	add    $0x10,%esp
  8008d8:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
			if ((uint32) ptr_allocations[5] != (pagealloc_start + 4*Mega + 16*kilo)) { is_correct = 0; cprintf("6 Wrong start address for the allocated space... \n");}
  8008de:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  8008e4:	89 c2                	mov    %eax,%edx
  8008e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e9:	c1 e0 02             	shl    $0x2,%eax
  8008ec:	89 c1                	mov    %eax,%ecx
  8008ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008f1:	c1 e0 04             	shl    $0x4,%eax
  8008f4:	01 c1                	add    %eax,%ecx
  8008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f9:	01 c8                	add    %ecx,%eax
  8008fb:	39 c2                	cmp    %eax,%edx
  8008fd:	74 17                	je     800916 <_main+0x8bd>
  8008ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800906:	83 ec 0c             	sub    $0xc,%esp
  800909:	68 44 52 80 00       	push   $0x805244
  80090e:	e8 a3 11 00 00       	call   801ab6 <cprintf>
  800913:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*no table*/ ;
  800916:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e8 16 27 00 00       	call   80303b <sys_calculate_free_frames>
  800925:	29 c3                	sub    %eax,%ebx
  800927:	89 d8                	mov    %ebx,%eax
  800929:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  80092c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80092f:	83 c0 02             	add    $0x2,%eax
  800932:	83 ec 04             	sub    $0x4,%esp
  800935:	50                   	push   %eax
  800936:	ff 75 c4             	pushl  -0x3c(%ebp)
  800939:	ff 75 c0             	pushl  -0x40(%ebp)
  80093c:	e8 f7 f6 ff ff       	call   800038 <inRange>
  800941:	83 c4 10             	add    $0x10,%esp
  800944:	85 c0                	test   %eax,%eax
  800946:	75 21                	jne    800969 <_main+0x910>
			{is_correct = 0; cprintf("6 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80094f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800952:	83 c0 02             	add    $0x2,%eax
  800955:	ff 75 c0             	pushl  -0x40(%ebp)
  800958:	50                   	push   %eax
  800959:	ff 75 c4             	pushl  -0x3c(%ebp)
  80095c:	68 78 52 80 00       	push   $0x805278
  800961:	e8 50 11 00 00       	call   801ab6 <cprintf>
  800966:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("6 Extra or less pages are allocated in PageFile\n");}
  800969:	e8 18 27 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  80096e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800971:	74 17                	je     80098a <_main+0x931>
  800973:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80097a:	83 ec 0c             	sub    $0xc,%esp
  80097d:	68 e8 52 80 00       	push   $0x8052e8
  800982:	e8 2f 11 00 00       	call   801ab6 <cprintf>
  800987:	83 c4 10             	add    $0x10,%esp
		}
		//6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  80098a:	e8 ac 26 00 00       	call   80303b <sys_calculate_free_frames>
  80098f:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800992:	e8 ef 26 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800997:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[6] = malloc(6*Mega-kilo);
  80099a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80099d:	89 d0                	mov    %edx,%eax
  80099f:	01 c0                	add    %eax,%eax
  8009a1:	01 d0                	add    %edx,%eax
  8009a3:	01 c0                	add    %eax,%eax
  8009a5:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8009a8:	83 ec 0c             	sub    $0xc,%esp
  8009ab:	50                   	push   %eax
  8009ac:	e8 b5 1e 00 00       	call   802866 <malloc>
  8009b1:	83 c4 10             	add    $0x10,%esp
  8009b4:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
			if ((uint32) ptr_allocations[6] != (pagealloc_start + 7*Mega + 16*kilo)) { is_correct = 0; cprintf("7 Wrong start address for the allocated space... \n");}
  8009ba:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c5:	89 d0                	mov    %edx,%eax
  8009c7:	01 c0                	add    %eax,%eax
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	01 c0                	add    %eax,%eax
  8009cd:	01 d0                	add    %edx,%eax
  8009cf:	89 c2                	mov    %eax,%edx
  8009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009d4:	c1 e0 04             	shl    $0x4,%eax
  8009d7:	01 c2                	add    %eax,%edx
  8009d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009dc:	01 d0                	add    %edx,%eax
  8009de:	39 c1                	cmp    %eax,%ecx
  8009e0:	74 17                	je     8009f9 <_main+0x9a0>
  8009e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009e9:	83 ec 0c             	sub    $0xc,%esp
  8009ec:	68 1c 53 80 00       	push   $0x80531c
  8009f1:	e8 c0 10 00 00       	call   801ab6 <cprintf>
  8009f6:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 2 /*table*/ ;
  8009f9:	c7 45 c4 02 00 00 00 	movl   $0x2,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800a00:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800a03:	e8 33 26 00 00       	call   80303b <sys_calculate_free_frames>
  800a08:	29 c3                	sub    %eax,%ebx
  800a0a:	89 d8                	mov    %ebx,%eax
  800a0c:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800a0f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a12:	83 c0 02             	add    $0x2,%eax
  800a15:	83 ec 04             	sub    $0x4,%esp
  800a18:	50                   	push   %eax
  800a19:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a1c:	ff 75 c0             	pushl  -0x40(%ebp)
  800a1f:	e8 14 f6 ff ff       	call   800038 <inRange>
  800a24:	83 c4 10             	add    $0x10,%esp
  800a27:	85 c0                	test   %eax,%eax
  800a29:	75 21                	jne    800a4c <_main+0x9f3>
			{is_correct = 0; cprintf("7 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800a2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a32:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800a35:	83 c0 02             	add    $0x2,%eax
  800a38:	ff 75 c0             	pushl  -0x40(%ebp)
  800a3b:	50                   	push   %eax
  800a3c:	ff 75 c4             	pushl  -0x3c(%ebp)
  800a3f:	68 50 53 80 00       	push   $0x805350
  800a44:	e8 6d 10 00 00       	call   801ab6 <cprintf>
  800a49:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("7 Extra or less pages are allocated in PageFile\n");}
  800a4c:	e8 35 26 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800a51:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800a54:	74 17                	je     800a6d <_main+0xa14>
  800a56:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a5d:	83 ec 0c             	sub    $0xc,%esp
  800a60:	68 c0 53 80 00       	push   $0x8053c0
  800a65:	e8 4c 10 00 00       	call   801ab6 <cprintf>
  800a6a:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800a6d:	e8 c9 25 00 00       	call   80303b <sys_calculate_free_frames>
  800a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
			lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  800a75:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a78:	89 d0                	mov    %edx,%eax
  800a7a:	01 c0                	add    %eax,%eax
  800a7c:	01 d0                	add    %edx,%eax
  800a7e:	01 c0                	add    %eax,%eax
  800a80:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800a83:	48                   	dec    %eax
  800a84:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
			byteArr2 = (char *) ptr_allocations[6];
  800a8a:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  800a90:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
			byteArr2[0] = minByte ;
  800a96:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800a9c:	8a 55 e3             	mov    -0x1d(%ebp),%dl
  800a9f:	88 10                	mov    %dl,(%eax)
			byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  800aa1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800aa7:	89 c2                	mov    %eax,%edx
  800aa9:	c1 ea 1f             	shr    $0x1f,%edx
  800aac:	01 d0                	add    %edx,%eax
  800aae:	d1 f8                	sar    %eax
  800ab0:	89 c2                	mov    %eax,%edx
  800ab2:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ab8:	01 c2                	add    %eax,%edx
  800aba:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800abd:	88 c1                	mov    %al,%cl
  800abf:	c0 e9 07             	shr    $0x7,%cl
  800ac2:	01 c8                	add    %ecx,%eax
  800ac4:	d0 f8                	sar    %al
  800ac6:	88 02                	mov    %al,(%edx)
			byteArr2[lastIndexOfByte2] = maxByte ;
  800ac8:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800ace:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800ad4:	01 c2                	add    %eax,%edx
  800ad6:	8a 45 e2             	mov    -0x1e(%ebp),%al
  800ad9:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 3 ;
  800adb:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800ae2:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800ae5:	e8 51 25 00 00       	call   80303b <sys_calculate_free_frames>
  800aea:	29 c3                	sub    %eax,%ebx
  800aec:	89 d8                	mov    %ebx,%eax
  800aee:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800af1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800af4:	83 c0 02             	add    $0x2,%eax
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	ff 75 c4             	pushl  -0x3c(%ebp)
  800afe:	ff 75 c0             	pushl  -0x40(%ebp)
  800b01:	e8 32 f5 ff ff       	call   800038 <inRange>
  800b06:	83 c4 10             	add    $0x10,%esp
  800b09:	85 c0                	test   %eax,%eax
  800b0b:	75 1d                	jne    800b2a <_main+0xad1>
			{ is_correct = 0; cprintf("7 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800b0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b14:	83 ec 04             	sub    $0x4,%esp
  800b17:	ff 75 c0             	pushl  -0x40(%ebp)
  800b1a:	ff 75 c4             	pushl  -0x3c(%ebp)
  800b1d:	68 f4 53 80 00       	push   $0x8053f4
  800b22:	e8 8f 0f 00 00       	call   801ab6 <cprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  800b2a:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b30:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
  800b36:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b41:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
  800b47:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800b4d:	89 c2                	mov    %eax,%edx
  800b4f:	c1 ea 1f             	shr    $0x1f,%edx
  800b52:	01 d0                	add    %edx,%eax
  800b54:	d1 f8                	sar    %eax
  800b56:	89 c2                	mov    %eax,%edx
  800b58:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b5e:	01 d0                	add    %edx,%eax
  800b60:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
  800b66:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b71:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
  800b77:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  800b7d:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800b83:	01 d0                	add    %edx,%eax
  800b85:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800b8b:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800b91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b96:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800b9c:	6a 02                	push   $0x2
  800b9e:	6a 00                	push   $0x0
  800ba0:	6a 03                	push   $0x3
  800ba2:	8d 85 90 fe ff ff    	lea    -0x170(%ebp),%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 e8 28 00 00       	call   803496 <sys_check_WS_list>
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("7 malloc: page is not added to WS\n");}
  800bb4:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800bb8:	74 17                	je     800bd1 <_main+0xb78>
  800bba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 74 54 80 00       	push   $0x805474
  800bc9:	e8 e8 0e 00 00       	call   801ab6 <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
		}
		//14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  800bd1:	e8 65 24 00 00       	call   80303b <sys_calculate_free_frames>
  800bd6:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800bd9:	e8 a8 24 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800bde:	89 45 c8             	mov    %eax,-0x38(%ebp)
			ptr_allocations[7] = malloc(14*kilo);
  800be1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800be4:	89 d0                	mov    %edx,%eax
  800be6:	01 c0                	add    %eax,%eax
  800be8:	01 d0                	add    %edx,%eax
  800bea:	01 c0                	add    %eax,%eax
  800bec:	01 d0                	add    %edx,%eax
  800bee:	01 c0                	add    %eax,%eax
  800bf0:	83 ec 0c             	sub    $0xc,%esp
  800bf3:	50                   	push   %eax
  800bf4:	e8 6d 1c 00 00       	call   802866 <malloc>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
			if ((uint32) ptr_allocations[7] != (pagealloc_start + 13*Mega + 16*kilo)) { is_correct = 0; cprintf("8 Wrong start address for the allocated space... \n");}
  800c02:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800c08:	89 c1                	mov    %eax,%ecx
  800c0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800c0d:	89 d0                	mov    %edx,%eax
  800c0f:	01 c0                	add    %eax,%eax
  800c11:	01 d0                	add    %edx,%eax
  800c13:	c1 e0 02             	shl    $0x2,%eax
  800c16:	01 d0                	add    %edx,%eax
  800c18:	89 c2                	mov    %eax,%edx
  800c1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c1d:	c1 e0 04             	shl    $0x4,%eax
  800c20:	01 c2                	add    %eax,%edx
  800c22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c25:	01 d0                	add    %edx,%eax
  800c27:	39 c1                	cmp    %eax,%ecx
  800c29:	74 17                	je     800c42 <_main+0xbe9>
  800c2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c32:	83 ec 0c             	sub    $0xc,%esp
  800c35:	68 98 54 80 00       	push   $0x805498
  800c3a:	e8 77 0e 00 00       	call   801ab6 <cprintf>
  800c3f:	83 c4 10             	add    $0x10,%esp
			expectedNumOfFrames = 0 /*table*/ ;
  800c42:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			actualNumOfFrames = freeFrames - sys_calculate_free_frames();
  800c49:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800c4c:	e8 ea 23 00 00       	call   80303b <sys_calculate_free_frames>
  800c51:	29 c3                	sub    %eax,%ebx
  800c53:	89 d8                	mov    %ebx,%eax
  800c55:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800c58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c5b:	83 c0 02             	add    $0x2,%eax
  800c5e:	83 ec 04             	sub    $0x4,%esp
  800c61:	50                   	push   %eax
  800c62:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c65:	ff 75 c0             	pushl  -0x40(%ebp)
  800c68:	e8 cb f3 ff ff       	call   800038 <inRange>
  800c6d:	83 c4 10             	add    $0x10,%esp
  800c70:	85 c0                	test   %eax,%eax
  800c72:	75 21                	jne    800c95 <_main+0xc3c>
			{is_correct = 0; cprintf("8 Wrong allocation: unexpected number of pages that are allocated in memory! Expected = [%d, %d], Actual = %d\n", expectedNumOfFrames, expectedNumOfFrames+2, actualNumOfFrames);}
  800c74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c7b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800c7e:	83 c0 02             	add    $0x2,%eax
  800c81:	ff 75 c0             	pushl  -0x40(%ebp)
  800c84:	50                   	push   %eax
  800c85:	ff 75 c4             	pushl  -0x3c(%ebp)
  800c88:	68 cc 54 80 00       	push   $0x8054cc
  800c8d:	e8 24 0e 00 00       	call   801ab6 <cprintf>
  800c92:	83 c4 10             	add    $0x10,%esp
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) { is_correct = 0; cprintf("8 Extra or less pages are allocated in PageFile\n");}
  800c95:	e8 ec 23 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800c9a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800c9d:	74 17                	je     800cb6 <_main+0xc5d>
  800c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ca6:	83 ec 0c             	sub    $0xc,%esp
  800ca9:	68 3c 55 80 00       	push   $0x80553c
  800cae:	e8 03 0e 00 00       	call   801ab6 <cprintf>
  800cb3:	83 c4 10             	add    $0x10,%esp

			freeFrames = sys_calculate_free_frames() ;
  800cb6:	e8 80 23 00 00       	call   80303b <sys_calculate_free_frames>
  800cbb:	89 45 cc             	mov    %eax,-0x34(%ebp)
			shortArr2 = (short *) ptr_allocations[7];
  800cbe:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  800cc4:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  800cca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ccd:	89 d0                	mov    %edx,%eax
  800ccf:	01 c0                	add    %eax,%eax
  800cd1:	01 d0                	add    %edx,%eax
  800cd3:	01 c0                	add    %eax,%eax
  800cd5:	01 d0                	add    %edx,%eax
  800cd7:	01 c0                	add    %eax,%eax
  800cd9:	d1 e8                	shr    %eax
  800cdb:	48                   	dec    %eax
  800cdc:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			shortArr2[0] = minShort;
  800ce2:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
  800ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ceb:	66 89 02             	mov    %ax,(%edx)
			shortArr2[lastIndexOfShort2 / 2] = maxShort / 2;
  800cee:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800cf4:	89 c2                	mov    %eax,%edx
  800cf6:	c1 ea 1f             	shr    $0x1f,%edx
  800cf9:	01 d0                	add    %edx,%eax
  800cfb:	d1 f8                	sar    %eax
  800cfd:	01 c0                	add    %eax,%eax
  800cff:	89 c2                	mov    %eax,%edx
  800d01:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d07:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800d0a:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d0e:	89 c2                	mov    %eax,%edx
  800d10:	66 c1 ea 0f          	shr    $0xf,%dx
  800d14:	01 d0                	add    %edx,%eax
  800d16:	66 d1 f8             	sar    %ax
  800d19:	66 89 01             	mov    %ax,(%ecx)
			shortArr2[lastIndexOfShort2] = maxShort;
  800d1c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800d22:	01 c0                	add    %eax,%eax
  800d24:	89 c2                	mov    %eax,%edx
  800d26:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d2c:	01 c2                	add    %eax,%edx
  800d2e:	66 8b 45 de          	mov    -0x22(%ebp),%ax
  800d32:	66 89 02             	mov    %ax,(%edx)
			expectedNumOfFrames = 3 ;
  800d35:	c7 45 c4 03 00 00 00 	movl   $0x3,-0x3c(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  800d3c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800d3f:	e8 f7 22 00 00       	call   80303b <sys_calculate_free_frames>
  800d44:	29 c3                	sub    %eax,%ebx
  800d46:	89 d8                	mov    %ebx,%eax
  800d48:	89 45 c0             	mov    %eax,-0x40(%ebp)
			if (!inRange(actualNumOfFrames, expectedNumOfFrames, expectedNumOfFrames + 2 /*Block Alloc: max of 1 page & 1 table*/))
  800d4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800d4e:	83 c0 02             	add    $0x2,%eax
  800d51:	83 ec 04             	sub    $0x4,%esp
  800d54:	50                   	push   %eax
  800d55:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d58:	ff 75 c0             	pushl  -0x40(%ebp)
  800d5b:	e8 d8 f2 ff ff       	call   800038 <inRange>
  800d60:	83 c4 10             	add    $0x10,%esp
  800d63:	85 c0                	test   %eax,%eax
  800d65:	75 1d                	jne    800d84 <_main+0xd2b>
			{ is_correct = 0; cprintf("8 Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);}
  800d67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d6e:	83 ec 04             	sub    $0x4,%esp
  800d71:	ff 75 c0             	pushl  -0x40(%ebp)
  800d74:	ff 75 c4             	pushl  -0x3c(%ebp)
  800d77:	68 70 55 80 00       	push   $0x805570
  800d7c:	e8 35 0d 00 00       	call   801ab6 <cprintf>
  800d81:	83 c4 10             	add    $0x10,%esp
			uint32 expectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  800d84:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800d8a:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  800d90:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800d96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d9b:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
  800da1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800da7:	89 c2                	mov    %eax,%edx
  800da9:	c1 ea 1f             	shr    $0x1f,%edx
  800dac:	01 d0                	add    %edx,%eax
  800dae:	d1 f8                	sar    %eax
  800db0:	01 c0                	add    %eax,%eax
  800db2:	89 c2                	mov    %eax,%edx
  800db4:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800dba:	01 d0                	add    %edx,%eax
  800dbc:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800dc2:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800dc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dcd:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
  800dd3:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800dd9:	01 c0                	add    %eax,%eax
  800ddb:	89 c2                	mov    %eax,%edx
  800ddd:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  800de3:	01 d0                	add    %edx,%eax
  800de5:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800deb:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800df1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800df6:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
			found = sys_check_WS_list(expectedVAs, 3, 0, 2);
  800dfc:	6a 02                	push   $0x2
  800dfe:	6a 00                	push   $0x0
  800e00:	6a 03                	push   $0x3
  800e02:	8d 85 84 fe ff ff    	lea    -0x17c(%ebp),%eax
  800e08:	50                   	push   %eax
  800e09:	e8 88 26 00 00       	call   803496 <sys_check_WS_list>
  800e0e:	83 c4 10             	add    $0x10,%esp
  800e11:	89 45 ac             	mov    %eax,-0x54(%ebp)
			if (found != 1) { is_correct = 0; cprintf("8 malloc: page is not added to WS\n");}
  800e14:	83 7d ac 01          	cmpl   $0x1,-0x54(%ebp)
  800e18:	74 17                	je     800e31 <_main+0xdd8>
  800e1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e21:	83 ec 0c             	sub    $0xc,%esp
  800e24:	68 f0 55 80 00       	push   $0x8055f0
  800e29:	e8 88 0c 00 00       	call   801ab6 <cprintf>
  800e2e:	83 c4 10             	add    $0x10,%esp
		}
	}
	uint32 pagealloc_end = pagealloc_start + 13*Mega + 32*kilo ;
  800e31:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800e34:	89 d0                	mov    %edx,%eax
  800e36:	01 c0                	add    %eax,%eax
  800e38:	01 d0                	add    %edx,%eax
  800e3a:	c1 e0 02             	shl    $0x2,%eax
  800e3d:	01 d0                	add    %edx,%eax
  800e3f:	89 c2                	mov    %eax,%edx
  800e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e44:	c1 e0 05             	shl    $0x5,%eax
  800e47:	01 c2                	add    %eax,%edx
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	01 d0                	add    %edx,%eax
  800e4e:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)


	is_correct = 1;
  800e54:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	//FREE ALL
	cprintf("\n%~[2] Free all the allocated spaces from PAGE ALLOCATOR \[70%]\n");
  800e5b:	83 ec 0c             	sub    $0xc,%esp
  800e5e:	68 14 56 80 00       	push   $0x805614
  800e63:	e8 4e 0c 00 00       	call   801ab6 <cprintf>
  800e68:	83 c4 10             	add    $0x10,%esp
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800e6b:	e8 cb 21 00 00       	call   80303b <sys_calculate_free_frames>
  800e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e73:	e8 0e 22 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800e78:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[0]);
  800e7b:	8b 85 bc fe ff ff    	mov    -0x144(%ebp),%eax
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	50                   	push   %eax
  800e85:	e8 92 1b 00 00       	call   802a1c <free>
  800e8a:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) { is_correct = 0; cprintf("9 Wrong free: Extra or less pages are removed from PageFile\n");}
  800e8d:	e8 f4 21 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800e92:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800e95:	74 17                	je     800eae <_main+0xe55>
  800e97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9e:	83 ec 0c             	sub    $0xc,%esp
  800ea1:	68 54 56 80 00       	push   $0x805654
  800ea6:	e8 0b 0c 00 00       	call   801ab6 <cprintf>
  800eab:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) { is_correct = 0; cprintf("9 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800eae:	e8 88 21 00 00       	call   80303b <sys_calculate_free_frames>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eb8:	29 c2                	sub    %eax,%edx
  800eba:	89 d0                	mov    %edx,%eax
  800ebc:	83 f8 02             	cmp    $0x2,%eax
  800ebf:	74 17                	je     800ed8 <_main+0xe7f>
  800ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ec8:	83 ec 0c             	sub    $0xc,%esp
  800ecb:	68 94 56 80 00       	push   $0x805694
  800ed0:	e8 e1 0b 00 00       	call   801ab6 <cprintf>
  800ed5:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800ed8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800edb:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800ee1:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800eec:	89 85 7c fe ff ff    	mov    %eax,-0x184(%ebp)
  800ef2:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800ef5:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800ef8:	01 d0                	add    %edx,%eax
  800efa:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
  800f00:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800f06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f0b:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800f11:	6a 03                	push   $0x3
  800f13:	6a 00                	push   $0x0
  800f15:	6a 02                	push   $0x2
  800f17:	8d 85 7c fe ff ff    	lea    -0x184(%ebp),%eax
  800f1d:	50                   	push   %eax
  800f1e:	e8 73 25 00 00       	call   803496 <sys_check_WS_list>
  800f23:	83 c4 10             	add    $0x10,%esp
  800f26:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("9 free: page is not removed from WS\n");}
  800f2c:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  800f33:	74 17                	je     800f4c <_main+0xef3>
  800f35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	68 e4 56 80 00       	push   $0x8056e4
  800f44:	e8 6d 0b 00 00       	call   801ab6 <cprintf>
  800f49:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  800f4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f50:	74 04                	je     800f56 <_main+0xefd>
		{
			eval += 10;
  800f52:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  800f56:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  800f5d:	e8 d9 20 00 00       	call   80303b <sys_calculate_free_frames>
  800f62:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f65:	e8 1c 21 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800f6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[1]);
  800f6d:	8b 85 c0 fe ff ff    	mov    -0x140(%ebp),%eax
  800f73:	83 ec 0c             	sub    $0xc,%esp
  800f76:	50                   	push   %eax
  800f77:	e8 a0 1a 00 00       	call   802a1c <free>
  800f7c:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  800f7f:	e8 02 21 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  800f84:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800f87:	74 17                	je     800fa0 <_main+0xf47>
			{ is_correct = 0; cprintf("10 Wrong free: Extra or less pages are removed from PageFile\n");}
  800f89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	68 0c 57 80 00       	push   $0x80570c
  800f98:	e8 19 0b 00 00       	call   801ab6 <cprintf>
  800f9d:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2 /*we don't remove free tables anymore*/)
  800fa0:	e8 96 20 00 00       	call   80303b <sys_calculate_free_frames>
  800fa5:	89 c2                	mov    %eax,%edx
  800fa7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
  800fae:	83 f8 02             	cmp    $0x2,%eax
  800fb1:	74 17                	je     800fca <_main+0xf71>
			{ is_correct = 0; cprintf("10 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  800fb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800fba:	83 ec 0c             	sub    $0xc,%esp
  800fbd:	68 4c 57 80 00       	push   $0x80574c
  800fc2:	e8 ef 0a 00 00       	call   801ab6 <cprintf>
  800fc7:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE)} ;
  800fca:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fcd:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800fd3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800fd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fde:	89 85 74 fe ff ff    	mov    %eax,-0x18c(%ebp)
  800fe4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800fe7:	01 c0                	add    %eax,%eax
  800fe9:	89 c2                	mov    %eax,%edx
  800feb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ff6:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ffc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801001:	89 85 78 fe ff ff    	mov    %eax,-0x188(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  801007:	6a 03                	push   $0x3
  801009:	6a 00                	push   $0x0
  80100b:	6a 02                	push   $0x2
  80100d:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  801013:	50                   	push   %eax
  801014:	e8 7d 24 00 00       	call   803496 <sys_check_WS_list>
  801019:	83 c4 10             	add    $0x10,%esp
  80101c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("10 free: page is not removed from WS\n");}
  801022:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801029:	74 17                	je     801042 <_main+0xfe9>
  80102b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801032:	83 ec 0c             	sub    $0xc,%esp
  801035:	68 9c 57 80 00       	push   $0x80579c
  80103a:	e8 77 0a 00 00       	call   801ab6 <cprintf>
  80103f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801046:	74 04                	je     80104c <_main+0xff3>
		{
			eval += 10;
  801048:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80104c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 6 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801053:	e8 e3 1f 00 00       	call   80303b <sys_calculate_free_frames>
  801058:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80105b:	e8 26 20 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  801060:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[6]);
  801063:	8b 85 d4 fe ff ff    	mov    -0x12c(%ebp),%eax
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	50                   	push   %eax
  80106d:	e8 aa 19 00 00       	call   802a1c <free>
  801072:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801075:	e8 0c 20 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  80107a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80107d:	74 17                	je     801096 <_main+0x103d>
			{ is_correct = 0; cprintf("11 Wrong free: Extra or less pages are removed from PageFile\n");}
  80107f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	68 c4 57 80 00       	push   $0x8057c4
  80108e:	e8 23 0a 00 00       	call   801ab6 <cprintf>
  801093:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  801096:	e8 a0 1f 00 00       	call   80303b <sys_calculate_free_frames>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8010a0:	29 c2                	sub    %eax,%edx
  8010a2:	89 d0                	mov    %edx,%eax
  8010a4:	83 f8 03             	cmp    $0x3,%eax
  8010a7:	74 17                	je     8010c0 <_main+0x1067>
			{ is_correct = 0; cprintf("11 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8010a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b0:	83 ec 0c             	sub    $0xc,%esp
  8010b3:	68 04 58 80 00       	push   $0x805804
  8010b8:	e8 f9 09 00 00       	call   801ab6 <cprintf>
  8010bd:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE)} ;
  8010c0:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010c6:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  8010cc:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  8010d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010d7:	89 85 68 fe ff ff    	mov    %eax,-0x198(%ebp)
  8010dd:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8010e3:	89 c2                	mov    %eax,%edx
  8010e5:	c1 ea 1f             	shr    $0x1f,%edx
  8010e8:	01 d0                	add    %edx,%eax
  8010ea:	d1 f8                	sar    %eax
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8010f4:	01 d0                	add    %edx,%eax
  8010f6:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  8010fc:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  801102:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801107:	89 85 6c fe ff ff    	mov    %eax,-0x194(%ebp)
  80110d:	8b 95 78 ff ff ff    	mov    -0x88(%ebp),%edx
  801113:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  801119:	01 d0                	add    %edx,%eax
  80111b:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
  801121:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801127:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112c:	89 85 70 fe ff ff    	mov    %eax,-0x190(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801132:	6a 03                	push   $0x3
  801134:	6a 00                	push   $0x0
  801136:	6a 03                	push   $0x3
  801138:	8d 85 68 fe ff ff    	lea    -0x198(%ebp),%eax
  80113e:	50                   	push   %eax
  80113f:	e8 52 23 00 00       	call   803496 <sys_check_WS_list>
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("11 free: page is not removed from WS\n");}
  80114d:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801154:	74 17                	je     80116d <_main+0x1114>
  801156:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80115d:	83 ec 0c             	sub    $0xc,%esp
  801160:	68 54 58 80 00       	push   $0x805854
  801165:	e8 4c 09 00 00       	call   801ab6 <cprintf>
  80116a:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  80116d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801171:	74 04                	je     801177 <_main+0x111e>
		{
			eval += 10;
  801173:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801177:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 7 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  80117e:	e8 b8 1e 00 00       	call   80303b <sys_calculate_free_frames>
  801183:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801186:	e8 fb 1e 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  80118b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[4]);
  80118e:	8b 85 cc fe ff ff    	mov    -0x134(%ebp),%eax
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	50                   	push   %eax
  801198:	e8 7f 18 00 00       	call   802a1c <free>
  80119d:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  8011a0:	e8 e1 1e 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  8011a5:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8011a8:	74 17                	je     8011c1 <_main+0x1168>
			{ is_correct = 0; cprintf("12 Wrong free: Extra or less pages are removed from PageFile\n");}
  8011aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011b1:	83 ec 0c             	sub    $0xc,%esp
  8011b4:	68 7c 58 80 00       	push   $0x80587c
  8011b9:	e8 f8 08 00 00       	call   801ab6 <cprintf>
  8011be:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 2)
  8011c1:	e8 75 1e 00 00       	call   80303b <sys_calculate_free_frames>
  8011c6:	89 c2                	mov    %eax,%edx
  8011c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011cb:	29 c2                	sub    %eax,%edx
  8011cd:	89 d0                	mov    %edx,%eax
  8011cf:	83 f8 02             	cmp    $0x2,%eax
  8011d2:	74 17                	je     8011eb <_main+0x1192>
			{ is_correct = 0; cprintf("12 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8011d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	68 bc 58 80 00       	push   $0x8058bc
  8011e3:	e8 ce 08 00 00       	call   801ab6 <cprintf>
  8011e8:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(structArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(structArr[lastIndexOfStruct])), PAGE_SIZE)} ;
  8011eb:	8b 45 88             	mov    -0x78(%ebp),%eax
  8011ee:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
  8011f4:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ff:	89 85 60 fe ff ff    	mov    %eax,-0x1a0(%ebp)
  801205:	8b 45 84             	mov    -0x7c(%ebp),%eax
  801208:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80120f:	8b 45 88             	mov    -0x78(%ebp),%eax
  801212:	01 d0                	add    %edx,%eax
  801214:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  80121a:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801220:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801225:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80122b:	6a 03                	push   $0x3
  80122d:	6a 00                	push   $0x0
  80122f:	6a 02                	push   $0x2
  801231:	8d 85 60 fe ff ff    	lea    -0x1a0(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	e8 59 22 00 00       	call   803496 <sys_check_WS_list>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("12 free: page is not removed from WS\n");}
  801246:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  80124d:	74 17                	je     801266 <_main+0x120d>
  80124f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801256:	83 ec 0c             	sub    $0xc,%esp
  801259:	68 0c 59 80 00       	push   $0x80590c
  80125e:	e8 53 08 00 00       	call   801ab6 <cprintf>
  801263:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 04                	je     801270 <_main+0x1217>
		{
			eval += 10;
  80126c:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  801270:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 3 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  801277:	e8 bf 1d 00 00       	call   80303b <sys_calculate_free_frames>
  80127c:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80127f:	e8 02 1e 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  801284:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[5]);
  801287:	8b 85 d0 fe ff ff    	mov    -0x130(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 86 17 00 00       	call   802a1c <free>
  801296:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801299:	e8 e8 1d 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  80129e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8012a1:	74 17                	je     8012ba <_main+0x1261>
			{ is_correct = 0; cprintf("13 Wrong free: Extra or less pages are removed from PageFile\n");}
  8012a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	68 34 59 80 00       	push   $0x805934
  8012b2:	e8 ff 07 00 00       	call   801ab6 <cprintf>
  8012b7:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  8012ba:	e8 7c 1d 00 00       	call   80303b <sys_calculate_free_frames>
  8012bf:	89 c2                	mov    %eax,%edx
  8012c1:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8012c4:	39 c2                	cmp    %eax,%edx
  8012c6:	74 17                	je     8012df <_main+0x1286>
			{ is_correct = 0; cprintf("13 Wrong free: unexpected number of free frames after calling free\n");}
  8012c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8012cf:	83 ec 0c             	sub    $0xc,%esp
  8012d2:	68 74 59 80 00       	push   $0x805974
  8012d7:	e8 da 07 00 00       	call   801ab6 <cprintf>
  8012dc:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8012df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e3:	74 04                	je     8012e9 <_main+0x1290>
		{
			eval += 5;
  8012e5:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  8012e9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 1st 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8012f0:	e8 46 1d 00 00       	call   80303b <sys_calculate_free_frames>
  8012f5:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8012f8:	e8 89 1d 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  8012fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[2]);
  801300:	8b 85 c4 fe ff ff    	mov    -0x13c(%ebp),%eax
  801306:	83 ec 0c             	sub    $0xc,%esp
  801309:	50                   	push   %eax
  80130a:	e8 0d 17 00 00       	call   802a1c <free>
  80130f:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801312:	e8 6f 1d 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  801317:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80131a:	74 17                	je     801333 <_main+0x12da>
			{ is_correct = 0; cprintf("14 Wrong free: Extra or less pages are removed from PageFile\n");}
  80131c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 b8 59 80 00       	push   $0x8059b8
  80132b:	e8 86 07 00 00       	call   801ab6 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 1 /*+ 1*/)
  801333:	e8 03 1d 00 00       	call   80303b <sys_calculate_free_frames>
  801338:	89 c2                	mov    %eax,%edx
  80133a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80133d:	29 c2                	sub    %eax,%edx
  80133f:	89 d0                	mov    %edx,%eax
  801341:	83 f8 01             	cmp    $0x1,%eax
  801344:	74 17                	je     80135d <_main+0x1304>
			{ is_correct = 0; cprintf("14 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  801346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80134d:	83 ec 0c             	sub    $0xc,%esp
  801350:	68 f8 59 80 00       	push   $0x8059f8
  801355:	e8 5c 07 00 00       	call   801ab6 <cprintf>
  80135a:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE)} ;
  80135d:	8b 45 98             	mov    -0x68(%ebp),%eax
  801360:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801366:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80136c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801371:	89 85 58 fe ff ff    	mov    %eax,-0x1a8(%ebp)
  801377:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80137a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801381:	8b 45 98             	mov    -0x68(%ebp),%eax
  801384:	01 d0                	add    %edx,%eax
  801386:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80138c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801392:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801397:	89 85 5c fe ff ff    	mov    %eax,-0x1a4(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  80139d:	6a 03                	push   $0x3
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 02                	push   $0x2
  8013a3:	8d 85 58 fe ff ff    	lea    -0x1a8(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	e8 e7 20 00 00       	call   803496 <sys_check_WS_list>
  8013af:	83 c4 10             	add    $0x10,%esp
  8013b2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("14 free: page is not removed from WS\n");}
  8013b8:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  8013bf:	74 17                	je     8013d8 <_main+0x137f>
  8013c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	68 48 5a 80 00       	push   $0x805a48
  8013d0:	e8 e1 06 00 00       	call   801ab6 <cprintf>
  8013d5:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  8013d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013dc:	74 04                	je     8013e2 <_main+0x1389>
		{
			eval += 10;
  8013de:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  8013e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free 2nd 3 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  8013e9:	e8 4d 1c 00 00       	call   80303b <sys_calculate_free_frames>
  8013ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8013f1:	e8 90 1c 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  8013f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[3]);
  8013f9:	8b 85 c8 fe ff ff    	mov    -0x138(%ebp),%eax
  8013ff:	83 ec 0c             	sub    $0xc,%esp
  801402:	50                   	push   %eax
  801403:	e8 14 16 00 00       	call   802a1c <free>
  801408:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  80140b:	e8 76 1c 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  801410:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  801413:	74 17                	je     80142c <_main+0x13d3>
			{ is_correct = 0; cprintf("15 Wrong free: Extra or less pages are removed from PageFile\n");}
  801415:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	68 70 5a 80 00       	push   $0x805a70
  801424:	e8 8d 06 00 00       	call   801ab6 <cprintf>
  801429:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 0)
  80142c:	e8 0a 1c 00 00       	call   80303b <sys_calculate_free_frames>
  801431:	89 c2                	mov    %eax,%edx
  801433:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801436:	39 c2                	cmp    %eax,%edx
  801438:	74 17                	je     801451 <_main+0x13f8>
			{ is_correct = 0; cprintf("15 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  80143a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801441:	83 ec 0c             	sub    $0xc,%esp
  801444:	68 b0 5a 80 00       	push   $0x805ab0
  801449:	e8 68 06 00 00       	call   801ab6 <cprintf>
  80144e:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 04                	je     80145b <_main+0x1402>
		{
			eval += 5;
  801457:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
		}

		is_correct = 1;
  80145b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
		//Free last 14 KB
		{
			freeFrames = sys_calculate_free_frames() ;
  801462:	e8 d4 1b 00 00       	call   80303b <sys_calculate_free_frames>
  801467:	89 45 cc             	mov    %eax,-0x34(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80146a:	e8 17 1c 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  80146f:	89 45 c8             	mov    %eax,-0x38(%ebp)
			free(ptr_allocations[7]);
  801472:	8b 85 d8 fe ff ff    	mov    -0x128(%ebp),%eax
  801478:	83 ec 0c             	sub    $0xc,%esp
  80147b:	50                   	push   %eax
  80147c:	e8 9b 15 00 00       	call   802a1c <free>
  801481:	83 c4 10             	add    $0x10,%esp
			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0)
  801484:	e8 fd 1b 00 00       	call   803086 <sys_pf_calculate_allocated_pages>
  801489:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  80148c:	74 17                	je     8014a5 <_main+0x144c>
			{ is_correct = 0; cprintf("16 Wrong free: Extra or less pages are removed from PageFile\n");}
  80148e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801495:	83 ec 0c             	sub    $0xc,%esp
  801498:	68 00 5b 80 00       	push   $0x805b00
  80149d:	e8 14 06 00 00       	call   801ab6 <cprintf>
  8014a2:	83 c4 10             	add    $0x10,%esp
			if ((sys_calculate_free_frames() - freeFrames) != 3 /*+ 1*/)
  8014a5:	e8 91 1b 00 00       	call   80303b <sys_calculate_free_frames>
  8014aa:	89 c2                	mov    %eax,%edx
  8014ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8014af:	29 c2                	sub    %eax,%edx
  8014b1:	89 d0                	mov    %edx,%eax
  8014b3:	83 f8 03             	cmp    $0x3,%eax
  8014b6:	74 17                	je     8014cf <_main+0x1476>
			{ is_correct = 0; cprintf("16 Wrong free: WS pages in memory and/or page tables are not freed correctly\n");}
  8014b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	68 40 5b 80 00       	push   $0x805b40
  8014c7:	e8 ea 05 00 00       	call   801ab6 <cprintf>
  8014cc:	83 c4 10             	add    $0x10,%esp
			uint32 notExpectedVAs[3] = { ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2/2])), PAGE_SIZE), ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE)} ;
  8014cf:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8014d5:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  8014db:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	89 85 4c fe ff ff    	mov    %eax,-0x1b4(%ebp)
  8014ec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	c1 ea 1f             	shr    $0x1f,%edx
  8014f7:	01 d0                	add    %edx,%eax
  8014f9:	d1 f8                	sar    %eax
  8014fb:	01 c0                	add    %eax,%eax
  8014fd:	89 c2                	mov    %eax,%edx
  8014ff:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  80150d:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  801513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801518:	89 85 50 fe ff ff    	mov    %eax,-0x1b0(%ebp)
  80151e:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  801524:	01 c0                	add    %eax,%eax
  801526:	89 c2                	mov    %eax,%edx
  801528:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  801536:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  80153c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801541:	89 85 54 fe ff ff    	mov    %eax,-0x1ac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 3, 0, 3);
  801547:	6a 03                	push   $0x3
  801549:	6a 00                	push   $0x0
  80154b:	6a 03                	push   $0x3
  80154d:	8d 85 4c fe ff ff    	lea    -0x1b4(%ebp),%eax
  801553:	50                   	push   %eax
  801554:	e8 3d 1f 00 00       	call   803496 <sys_check_WS_list>
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
			if (chk != 1) { is_correct = 0; cprintf("16 free: page is not removed from WS\n");}
  801562:	83 bd 44 ff ff ff 01 	cmpl   $0x1,-0xbc(%ebp)
  801569:	74 17                	je     801582 <_main+0x1529>
  80156b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801572:	83 ec 0c             	sub    $0xc,%esp
  801575:	68 90 5b 80 00       	push   $0x805b90
  80157a:	e8 37 05 00 00       	call   801ab6 <cprintf>
  80157f:	83 c4 10             	add    $0x10,%esp
		}
		if (is_correct)
  801582:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801586:	74 04                	je     80158c <_main+0x1533>
		{
			eval += 10;
  801588:	83 45 f4 0a          	addl   $0xa,-0xc(%ebp)
		}

		is_correct = 1;
  80158c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	}

	is_correct = 1;
  801593:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	cprintf("\n%~[3] Test accessing a freed area (processes should be killed by the validation of the fault handler) [30%]\n");
  80159a:	83 ec 0c             	sub    $0xc,%esp
  80159d:	68 b8 5b 80 00       	push   $0x805bb8
  8015a2:	e8 0f 05 00 00       	call   801ab6 <cprintf>
  8015a7:	83 c4 10             	add    $0x10,%esp
	{
		rsttst();
  8015aa:	e8 33 1d 00 00       	call   8032e2 <rsttst>
		int ID1 = sys_create_env("tf1_slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8015af:	a1 20 70 80 00       	mov    0x807020,%eax
  8015b4:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8015ba:	a1 20 70 80 00       	mov    0x807020,%eax
  8015bf:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8015c5:	89 c1                	mov    %eax,%ecx
  8015c7:	a1 20 70 80 00       	mov    0x807020,%eax
  8015cc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8015d2:	52                   	push   %edx
  8015d3:	51                   	push   %ecx
  8015d4:	50                   	push   %eax
  8015d5:	68 26 5c 80 00       	push   $0x805c26
  8015da:	e8 b7 1b 00 00       	call   803196 <sys_create_env>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		sys_run_env(ID1);
  8015e8:	83 ec 0c             	sub    $0xc,%esp
  8015eb:	ff b5 10 ff ff ff    	pushl  -0xf0(%ebp)
  8015f1:	e8 be 1b 00 00       	call   8031b4 <sys_run_env>
  8015f6:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  8015f9:	90                   	nop
  8015fa:	e8 5d 1d 00 00       	call   80335c <gettst>
  8015ff:	83 f8 01             	cmp    $0x1,%eax
  801602:	75 f6                	jne    8015fa <_main+0x15a1>

		int ID2 = sys_create_env("tf1_slave2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  801604:	a1 20 70 80 00       	mov    0x807020,%eax
  801609:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  80160f:	a1 20 70 80 00       	mov    0x807020,%eax
  801614:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  80161a:	89 c1                	mov    %eax,%ecx
  80161c:	a1 20 70 80 00       	mov    0x807020,%eax
  801621:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  801627:	52                   	push   %edx
  801628:	51                   	push   %ecx
  801629:	50                   	push   %eax
  80162a:	68 31 5c 80 00       	push   $0x805c31
  80162f:	e8 62 1b 00 00       	call   803196 <sys_create_env>
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		sys_run_env(ID2);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff b5 0c ff ff ff    	pushl  -0xf4(%ebp)
  801646:	e8 69 1b 00 00       	call   8031b4 <sys_run_env>
  80164b:	83 c4 10             	add    $0x10,%esp

		//wait until a slave finishes the allocation & freeing operations
		while (gettst() != 1) ;
  80164e:	90                   	nop
  80164f:	e8 08 1d 00 00       	call   80335c <gettst>
  801654:	83 f8 01             	cmp    $0x1,%eax
  801657:	75 f6                	jne    80164f <_main+0x15f6>

		//signal them to start accessing the freed area
		inctst();
  801659:	e8 e4 1c 00 00       	call   803342 <inctst>

		//sleep for a while to allow each slave to try access its freed location
		env_sleep(10000);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	68 10 27 00 00       	push   $0x2710
  801666:	e8 dc 31 00 00       	call   804847 <env_sleep>
  80166b:	83 c4 10             	add    $0x10,%esp

		if (gettst() > 3)
  80166e:	e8 e9 1c 00 00       	call   80335c <gettst>
  801673:	83 f8 03             	cmp    $0x3,%eax
  801676:	76 17                	jbe    80168f <_main+0x1636>
		{ is_correct = 0; cprintf("\n17 Free: access to freed space is done while it's NOT expected to be!! (processes should be killed by the validation of the fault handler)\n");}
  801678:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167f:	83 ec 0c             	sub    $0xc,%esp
  801682:	68 3c 5c 80 00       	push   $0x805c3c
  801687:	e8 2a 04 00 00       	call   801ab6 <cprintf>
  80168c:	83 c4 10             	add    $0x10,%esp
	}
	if (is_correct)
  80168f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801693:	74 04                	je     801699 <_main+0x1640>
	{
		eval += 30;
  801695:	83 45 f4 1e          	addl   $0x1e,-0xc(%ebp)
	}
	cprintf("%~\ntest free [1] [PAGE ALLOCATOR] completed. Eval = %d\n\n", eval);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 f4             	pushl  -0xc(%ebp)
  80169f:	68 cc 5c 80 00       	push   $0x805ccc
  8016a4:	e8 0d 04 00 00       	call   801ab6 <cprintf>
  8016a9:	83 c4 10             	add    $0x10,%esp

	return;
  8016ac:	90                   	nop
}
  8016ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5f                   	pop    %edi
  8016b2:	5d                   	pop    %ebp
  8016b3:	c3                   	ret    

008016b4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
  8016b7:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8016ba:	e8 45 1b 00 00       	call   803204 <sys_getenvindex>
  8016bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8016c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c5:	89 d0                	mov    %edx,%eax
  8016c7:	c1 e0 02             	shl    $0x2,%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	c1 e0 03             	shl    $0x3,%eax
  8016cf:	01 d0                	add    %edx,%eax
  8016d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8016d8:	01 d0                	add    %edx,%eax
  8016da:	c1 e0 02             	shl    $0x2,%eax
  8016dd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8016e2:	a3 20 70 80 00       	mov    %eax,0x807020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8016e7:	a1 20 70 80 00       	mov    0x807020,%eax
  8016ec:	8a 40 20             	mov    0x20(%eax),%al
  8016ef:	84 c0                	test   %al,%al
  8016f1:	74 0d                	je     801700 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8016f3:	a1 20 70 80 00       	mov    0x807020,%eax
  8016f8:	83 c0 20             	add    $0x20,%eax
  8016fb:	a3 04 70 80 00       	mov    %eax,0x807004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801700:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801704:	7e 0a                	jle    801710 <libmain+0x5c>
		binaryname = argv[0];
  801706:	8b 45 0c             	mov    0xc(%ebp),%eax
  801709:	8b 00                	mov    (%eax),%eax
  80170b:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	_main(argc, argv);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	ff 75 0c             	pushl  0xc(%ebp)
  801716:	ff 75 08             	pushl  0x8(%ebp)
  801719:	e8 3b e9 ff ff       	call   800059 <_main>
  80171e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  801721:	a1 00 70 80 00       	mov    0x807000,%eax
  801726:	85 c0                	test   %eax,%eax
  801728:	0f 84 9f 00 00 00    	je     8017cd <libmain+0x119>
	{
		sys_lock_cons();
  80172e:	e8 55 18 00 00       	call   802f88 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 20 5d 80 00       	push   $0x805d20
  80173b:	e8 76 03 00 00       	call   801ab6 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801743:	a1 20 70 80 00       	mov    0x807020,%eax
  801748:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80174e:	a1 20 70 80 00       	mov    0x807020,%eax
  801753:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  801759:	83 ec 04             	sub    $0x4,%esp
  80175c:	52                   	push   %edx
  80175d:	50                   	push   %eax
  80175e:	68 48 5d 80 00       	push   $0x805d48
  801763:	e8 4e 03 00 00       	call   801ab6 <cprintf>
  801768:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80176b:	a1 20 70 80 00       	mov    0x807020,%eax
  801770:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  801776:	a1 20 70 80 00       	mov    0x807020,%eax
  80177b:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  801781:	a1 20 70 80 00       	mov    0x807020,%eax
  801786:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80178c:	51                   	push   %ecx
  80178d:	52                   	push   %edx
  80178e:	50                   	push   %eax
  80178f:	68 70 5d 80 00       	push   $0x805d70
  801794:	e8 1d 03 00 00       	call   801ab6 <cprintf>
  801799:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80179c:	a1 20 70 80 00       	mov    0x807020,%eax
  8017a1:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8017a7:	83 ec 08             	sub    $0x8,%esp
  8017aa:	50                   	push   %eax
  8017ab:	68 c8 5d 80 00       	push   $0x805dc8
  8017b0:	e8 01 03 00 00       	call   801ab6 <cprintf>
  8017b5:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	68 20 5d 80 00       	push   $0x805d20
  8017c0:	e8 f1 02 00 00       	call   801ab6 <cprintf>
  8017c5:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8017c8:	e8 d5 17 00 00       	call   802fa2 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8017cd:	e8 19 00 00 00       	call   8017eb <exit>
}
  8017d2:	90                   	nop
  8017d3:	c9                   	leave  
  8017d4:	c3                   	ret    

008017d5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8017db:	83 ec 0c             	sub    $0xc,%esp
  8017de:	6a 00                	push   $0x0
  8017e0:	e8 eb 19 00 00       	call   8031d0 <sys_destroy_env>
  8017e5:	83 c4 10             	add    $0x10,%esp
}
  8017e8:	90                   	nop
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <exit>:

void
exit(void)
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
  8017ee:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8017f1:	e8 40 1a 00 00       	call   803236 <sys_exit_env>
}
  8017f6:	90                   	nop
  8017f7:	c9                   	leave  
  8017f8:	c3                   	ret    

008017f9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801802:	83 c0 04             	add    $0x4,%eax
  801805:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801808:	a1 60 70 98 00       	mov    0x987060,%eax
  80180d:	85 c0                	test   %eax,%eax
  80180f:	74 16                	je     801827 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801811:	a1 60 70 98 00       	mov    0x987060,%eax
  801816:	83 ec 08             	sub    $0x8,%esp
  801819:	50                   	push   %eax
  80181a:	68 dc 5d 80 00       	push   $0x805ddc
  80181f:	e8 92 02 00 00       	call   801ab6 <cprintf>
  801824:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801827:	a1 04 70 80 00       	mov    0x807004,%eax
  80182c:	ff 75 0c             	pushl  0xc(%ebp)
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	50                   	push   %eax
  801833:	68 e1 5d 80 00       	push   $0x805de1
  801838:	e8 79 02 00 00       	call   801ab6 <cprintf>
  80183d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801840:	8b 45 10             	mov    0x10(%ebp),%eax
  801843:	83 ec 08             	sub    $0x8,%esp
  801846:	ff 75 f4             	pushl  -0xc(%ebp)
  801849:	50                   	push   %eax
  80184a:	e8 fc 01 00 00       	call   801a4b <vcprintf>
  80184f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801852:	83 ec 08             	sub    $0x8,%esp
  801855:	6a 00                	push   $0x0
  801857:	68 fd 5d 80 00       	push   $0x805dfd
  80185c:	e8 ea 01 00 00       	call   801a4b <vcprintf>
  801861:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801864:	e8 82 ff ff ff       	call   8017eb <exit>

	// should not return here
	while (1) ;
  801869:	eb fe                	jmp    801869 <_panic+0x70>

0080186b <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801871:	a1 20 70 80 00       	mov    0x807020,%eax
  801876:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80187c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187f:	39 c2                	cmp    %eax,%edx
  801881:	74 14                	je     801897 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	68 00 5e 80 00       	push   $0x805e00
  80188b:	6a 26                	push   $0x26
  80188d:	68 4c 5e 80 00       	push   $0x805e4c
  801892:	e8 62 ff ff ff       	call   8017f9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801897:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80189e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8018a5:	e9 c5 00 00 00       	jmp    80196f <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	8b 00                	mov    (%eax),%eax
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	75 08                	jne    8018c7 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8018bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8018c2:	e9 a5 00 00 00       	jmp    80196c <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8018c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018d5:	eb 69                	jmp    801940 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8018d7:	a1 20 70 80 00       	mov    0x807020,%eax
  8018dc:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8018e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018e5:	89 d0                	mov    %edx,%eax
  8018e7:	01 c0                	add    %eax,%eax
  8018e9:	01 d0                	add    %edx,%eax
  8018eb:	c1 e0 03             	shl    $0x3,%eax
  8018ee:	01 c8                	add    %ecx,%eax
  8018f0:	8a 40 04             	mov    0x4(%eax),%al
  8018f3:	84 c0                	test   %al,%al
  8018f5:	75 46                	jne    80193d <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018f7:	a1 20 70 80 00       	mov    0x807020,%eax
  8018fc:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801902:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801905:	89 d0                	mov    %edx,%eax
  801907:	01 c0                	add    %eax,%eax
  801909:	01 d0                	add    %edx,%eax
  80190b:	c1 e0 03             	shl    $0x3,%eax
  80190e:	01 c8                	add    %ecx,%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801915:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801918:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80191d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80191f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801922:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	01 c8                	add    %ecx,%eax
  80192e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801930:	39 c2                	cmp    %eax,%edx
  801932:	75 09                	jne    80193d <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801934:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80193b:	eb 15                	jmp    801952 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80193d:	ff 45 e8             	incl   -0x18(%ebp)
  801940:	a1 20 70 80 00       	mov    0x807020,%eax
  801945:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80194b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80194e:	39 c2                	cmp    %eax,%edx
  801950:	77 85                	ja     8018d7 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801952:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801956:	75 14                	jne    80196c <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 58 5e 80 00       	push   $0x805e58
  801960:	6a 3a                	push   $0x3a
  801962:	68 4c 5e 80 00       	push   $0x805e4c
  801967:	e8 8d fe ff ff       	call   8017f9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80196c:	ff 45 f0             	incl   -0x10(%ebp)
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801975:	0f 8c 2f ff ff ff    	jl     8018aa <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80197b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801982:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801989:	eb 26                	jmp    8019b1 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80198b:	a1 20 70 80 00       	mov    0x807020,%eax
  801990:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801996:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801999:	89 d0                	mov    %edx,%eax
  80199b:	01 c0                	add    %eax,%eax
  80199d:	01 d0                	add    %edx,%eax
  80199f:	c1 e0 03             	shl    $0x3,%eax
  8019a2:	01 c8                	add    %ecx,%eax
  8019a4:	8a 40 04             	mov    0x4(%eax),%al
  8019a7:	3c 01                	cmp    $0x1,%al
  8019a9:	75 03                	jne    8019ae <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8019ab:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8019ae:	ff 45 e0             	incl   -0x20(%ebp)
  8019b1:	a1 20 70 80 00       	mov    0x807020,%eax
  8019b6:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8019bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019bf:	39 c2                	cmp    %eax,%edx
  8019c1:	77 c8                	ja     80198b <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8019c9:	74 14                	je     8019df <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 ac 5e 80 00       	push   $0x805eac
  8019d3:	6a 44                	push   $0x44
  8019d5:	68 4c 5e 80 00       	push   $0x805e4c
  8019da:	e8 1a fe ff ff       	call   8017f9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8019e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	8d 48 01             	lea    0x1(%eax),%ecx
  8019f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f3:	89 0a                	mov    %ecx,(%edx)
  8019f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f8:	88 d1                	mov    %dl,%cl
  8019fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a04:	8b 00                	mov    (%eax),%eax
  801a06:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a0b:	75 2c                	jne    801a39 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801a0d:	a0 44 70 98 00       	mov    0x987044,%al
  801a12:	0f b6 c0             	movzbl %al,%eax
  801a15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a18:	8b 12                	mov    (%edx),%edx
  801a1a:	89 d1                	mov    %edx,%ecx
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	83 c2 08             	add    $0x8,%edx
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	50                   	push   %eax
  801a26:	51                   	push   %ecx
  801a27:	52                   	push   %edx
  801a28:	e8 19 15 00 00       	call   802f46 <sys_cputs>
  801a2d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3c:	8b 40 04             	mov    0x4(%eax),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	89 50 04             	mov    %edx,0x4(%eax)
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801a54:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801a5b:	00 00 00 
	b.cnt = 0;
  801a5e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801a65:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801a68:	ff 75 0c             	pushl  0xc(%ebp)
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a74:	50                   	push   %eax
  801a75:	68 e2 19 80 00       	push   $0x8019e2
  801a7a:	e8 11 02 00 00       	call   801c90 <vprintfmt>
  801a7f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801a82:	a0 44 70 98 00       	mov    0x987044,%al
  801a87:	0f b6 c0             	movzbl %al,%eax
  801a8a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801a90:	83 ec 04             	sub    $0x4,%esp
  801a93:	50                   	push   %eax
  801a94:	52                   	push   %edx
  801a95:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801a9b:	83 c0 08             	add    $0x8,%eax
  801a9e:	50                   	push   %eax
  801a9f:	e8 a2 14 00 00       	call   802f46 <sys_cputs>
  801aa4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801aa7:	c6 05 44 70 98 00 00 	movb   $0x0,0x987044
	return b.cnt;
  801aae:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801abc:	c6 05 44 70 98 00 01 	movb   $0x1,0x987044
	va_start(ap, fmt);
  801ac3:	8d 45 0c             	lea    0xc(%ebp),%eax
  801ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	83 ec 08             	sub    $0x8,%esp
  801acf:	ff 75 f4             	pushl  -0xc(%ebp)
  801ad2:	50                   	push   %eax
  801ad3:	e8 73 ff ff ff       	call   801a4b <vcprintf>
  801ad8:	83 c4 10             	add    $0x10,%esp
  801adb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  801ae9:	e8 9a 14 00 00       	call   802f88 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  801aee:	8d 45 0c             	lea    0xc(%ebp),%eax
  801af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	83 ec 08             	sub    $0x8,%esp
  801afa:	ff 75 f4             	pushl  -0xc(%ebp)
  801afd:	50                   	push   %eax
  801afe:	e8 48 ff ff ff       	call   801a4b <vcprintf>
  801b03:	83 c4 10             	add    $0x10,%esp
  801b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  801b09:	e8 94 14 00 00       	call   802fa2 <sys_unlock_cons>
	return cnt;
  801b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	53                   	push   %ebx
  801b17:	83 ec 14             	sub    $0x14,%esp
  801b1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b20:	8b 45 14             	mov    0x14(%ebp),%eax
  801b23:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801b26:	8b 45 18             	mov    0x18(%ebp),%eax
  801b29:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b31:	77 55                	ja     801b88 <printnum+0x75>
  801b33:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801b36:	72 05                	jb     801b3d <printnum+0x2a>
  801b38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b3b:	77 4b                	ja     801b88 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801b3d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801b40:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801b43:	8b 45 18             	mov    0x18(%ebp),%eax
  801b46:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4b:	52                   	push   %edx
  801b4c:	50                   	push   %eax
  801b4d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b50:	ff 75 f0             	pushl  -0x10(%ebp)
  801b53:	e8 a4 2d 00 00       	call   8048fc <__udivdi3>
  801b58:	83 c4 10             	add    $0x10,%esp
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	ff 75 20             	pushl  0x20(%ebp)
  801b61:	53                   	push   %ebx
  801b62:	ff 75 18             	pushl  0x18(%ebp)
  801b65:	52                   	push   %edx
  801b66:	50                   	push   %eax
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	e8 a1 ff ff ff       	call   801b13 <printnum>
  801b72:	83 c4 20             	add    $0x20,%esp
  801b75:	eb 1a                	jmp    801b91 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801b77:	83 ec 08             	sub    $0x8,%esp
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 20             	pushl  0x20(%ebp)
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	ff d0                	call   *%eax
  801b85:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801b88:	ff 4d 1c             	decl   0x1c(%ebp)
  801b8b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801b8f:	7f e6                	jg     801b77 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801b91:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801b94:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b9f:	53                   	push   %ebx
  801ba0:	51                   	push   %ecx
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	e8 64 2e 00 00       	call   804a0c <__umoddi3>
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	05 14 61 80 00       	add    $0x806114,%eax
  801bb0:	8a 00                	mov    (%eax),%al
  801bb2:	0f be c0             	movsbl %al,%eax
  801bb5:	83 ec 08             	sub    $0x8,%esp
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	50                   	push   %eax
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	ff d0                	call   *%eax
  801bc1:	83 c4 10             	add    $0x10,%esp
}
  801bc4:	90                   	nop
  801bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bd1:	7e 1c                	jle    801bef <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8b 00                	mov    (%eax),%eax
  801bd8:	8d 50 08             	lea    0x8(%eax),%edx
  801bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bde:	89 10                	mov    %edx,(%eax)
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	8b 00                	mov    (%eax),%eax
  801be5:	83 e8 08             	sub    $0x8,%eax
  801be8:	8b 50 04             	mov    0x4(%eax),%edx
  801beb:	8b 00                	mov    (%eax),%eax
  801bed:	eb 40                	jmp    801c2f <getuint+0x65>
	else if (lflag)
  801bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801bf3:	74 1e                	je     801c13 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	8b 00                	mov    (%eax),%eax
  801bfa:	8d 50 04             	lea    0x4(%eax),%edx
  801bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801c00:	89 10                	mov    %edx,(%eax)
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	8b 00                	mov    (%eax),%eax
  801c07:	83 e8 04             	sub    $0x4,%eax
  801c0a:	8b 00                	mov    (%eax),%eax
  801c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c11:	eb 1c                	jmp    801c2f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	8b 00                	mov    (%eax),%eax
  801c18:	8d 50 04             	lea    0x4(%eax),%edx
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	89 10                	mov    %edx,(%eax)
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	8b 00                	mov    (%eax),%eax
  801c25:	83 e8 04             	sub    $0x4,%eax
  801c28:	8b 00                	mov    (%eax),%eax
  801c2a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    

00801c31 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801c34:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c38:	7e 1c                	jle    801c56 <getint+0x25>
		return va_arg(*ap, long long);
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	8b 00                	mov    (%eax),%eax
  801c3f:	8d 50 08             	lea    0x8(%eax),%edx
  801c42:	8b 45 08             	mov    0x8(%ebp),%eax
  801c45:	89 10                	mov    %edx,(%eax)
  801c47:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4a:	8b 00                	mov    (%eax),%eax
  801c4c:	83 e8 08             	sub    $0x8,%eax
  801c4f:	8b 50 04             	mov    0x4(%eax),%edx
  801c52:	8b 00                	mov    (%eax),%eax
  801c54:	eb 38                	jmp    801c8e <getint+0x5d>
	else if (lflag)
  801c56:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c5a:	74 1a                	je     801c76 <getint+0x45>
		return va_arg(*ap, long);
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	8b 00                	mov    (%eax),%eax
  801c61:	8d 50 04             	lea    0x4(%eax),%edx
  801c64:	8b 45 08             	mov    0x8(%ebp),%eax
  801c67:	89 10                	mov    %edx,(%eax)
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	83 e8 04             	sub    $0x4,%eax
  801c71:	8b 00                	mov    (%eax),%eax
  801c73:	99                   	cltd   
  801c74:	eb 18                	jmp    801c8e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	8b 00                	mov    (%eax),%eax
  801c7b:	8d 50 04             	lea    0x4(%eax),%edx
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	89 10                	mov    %edx,(%eax)
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	8b 00                	mov    (%eax),%eax
  801c88:	83 e8 04             	sub    $0x4,%eax
  801c8b:	8b 00                	mov    (%eax),%eax
  801c8d:	99                   	cltd   
}
  801c8e:	5d                   	pop    %ebp
  801c8f:	c3                   	ret    

00801c90 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	56                   	push   %esi
  801c94:	53                   	push   %ebx
  801c95:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801c98:	eb 17                	jmp    801cb1 <vprintfmt+0x21>
			if (ch == '\0')
  801c9a:	85 db                	test   %ebx,%ebx
  801c9c:	0f 84 c1 03 00 00    	je     802063 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  801ca2:	83 ec 08             	sub    $0x8,%esp
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	53                   	push   %ebx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	ff d0                	call   *%eax
  801cae:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb4:	8d 50 01             	lea    0x1(%eax),%edx
  801cb7:	89 55 10             	mov    %edx,0x10(%ebp)
  801cba:	8a 00                	mov    (%eax),%al
  801cbc:	0f b6 d8             	movzbl %al,%ebx
  801cbf:	83 fb 25             	cmp    $0x25,%ebx
  801cc2:	75 d6                	jne    801c9a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801cc4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801cc8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801ccf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801cd6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801cdd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce7:	8d 50 01             	lea    0x1(%eax),%edx
  801cea:	89 55 10             	mov    %edx,0x10(%ebp)
  801ced:	8a 00                	mov    (%eax),%al
  801cef:	0f b6 d8             	movzbl %al,%ebx
  801cf2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801cf5:	83 f8 5b             	cmp    $0x5b,%eax
  801cf8:	0f 87 3d 03 00 00    	ja     80203b <vprintfmt+0x3ab>
  801cfe:	8b 04 85 38 61 80 00 	mov    0x806138(,%eax,4),%eax
  801d05:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801d07:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801d0b:	eb d7                	jmp    801ce4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801d0d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801d11:	eb d1                	jmp    801ce4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d13:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801d1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d1d:	89 d0                	mov    %edx,%eax
  801d1f:	c1 e0 02             	shl    $0x2,%eax
  801d22:	01 d0                	add    %edx,%eax
  801d24:	01 c0                	add    %eax,%eax
  801d26:	01 d8                	add    %ebx,%eax
  801d28:	83 e8 30             	sub    $0x30,%eax
  801d2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d31:	8a 00                	mov    (%eax),%al
  801d33:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801d36:	83 fb 2f             	cmp    $0x2f,%ebx
  801d39:	7e 3e                	jle    801d79 <vprintfmt+0xe9>
  801d3b:	83 fb 39             	cmp    $0x39,%ebx
  801d3e:	7f 39                	jg     801d79 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801d40:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801d43:	eb d5                	jmp    801d1a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801d45:	8b 45 14             	mov    0x14(%ebp),%eax
  801d48:	83 c0 04             	add    $0x4,%eax
  801d4b:	89 45 14             	mov    %eax,0x14(%ebp)
  801d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d51:	83 e8 04             	sub    $0x4,%eax
  801d54:	8b 00                	mov    (%eax),%eax
  801d56:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801d59:	eb 1f                	jmp    801d7a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801d5b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d5f:	79 83                	jns    801ce4 <vprintfmt+0x54>
				width = 0;
  801d61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801d68:	e9 77 ff ff ff       	jmp    801ce4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801d6d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801d74:	e9 6b ff ff ff       	jmp    801ce4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801d79:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801d7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d7e:	0f 89 60 ff ff ff    	jns    801ce4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801d84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d87:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d8a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801d91:	e9 4e ff ff ff       	jmp    801ce4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801d96:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801d99:	e9 46 ff ff ff       	jmp    801ce4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801da1:	83 c0 04             	add    $0x4,%eax
  801da4:	89 45 14             	mov    %eax,0x14(%ebp)
  801da7:	8b 45 14             	mov    0x14(%ebp),%eax
  801daa:	83 e8 04             	sub    $0x4,%eax
  801dad:	8b 00                	mov    (%eax),%eax
  801daf:	83 ec 08             	sub    $0x8,%esp
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	50                   	push   %eax
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	ff d0                	call   *%eax
  801dbb:	83 c4 10             	add    $0x10,%esp
			break;
  801dbe:	e9 9b 02 00 00       	jmp    80205e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801dc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc6:	83 c0 04             	add    $0x4,%eax
  801dc9:	89 45 14             	mov    %eax,0x14(%ebp)
  801dcc:	8b 45 14             	mov    0x14(%ebp),%eax
  801dcf:	83 e8 04             	sub    $0x4,%eax
  801dd2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801dd4:	85 db                	test   %ebx,%ebx
  801dd6:	79 02                	jns    801dda <vprintfmt+0x14a>
				err = -err;
  801dd8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801dda:	83 fb 64             	cmp    $0x64,%ebx
  801ddd:	7f 0b                	jg     801dea <vprintfmt+0x15a>
  801ddf:	8b 34 9d 80 5f 80 00 	mov    0x805f80(,%ebx,4),%esi
  801de6:	85 f6                	test   %esi,%esi
  801de8:	75 19                	jne    801e03 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801dea:	53                   	push   %ebx
  801deb:	68 25 61 80 00       	push   $0x806125
  801df0:	ff 75 0c             	pushl  0xc(%ebp)
  801df3:	ff 75 08             	pushl  0x8(%ebp)
  801df6:	e8 70 02 00 00       	call   80206b <printfmt>
  801dfb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801dfe:	e9 5b 02 00 00       	jmp    80205e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801e03:	56                   	push   %esi
  801e04:	68 2e 61 80 00       	push   $0x80612e
  801e09:	ff 75 0c             	pushl  0xc(%ebp)
  801e0c:	ff 75 08             	pushl  0x8(%ebp)
  801e0f:	e8 57 02 00 00       	call   80206b <printfmt>
  801e14:	83 c4 10             	add    $0x10,%esp
			break;
  801e17:	e9 42 02 00 00       	jmp    80205e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801e1c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e1f:	83 c0 04             	add    $0x4,%eax
  801e22:	89 45 14             	mov    %eax,0x14(%ebp)
  801e25:	8b 45 14             	mov    0x14(%ebp),%eax
  801e28:	83 e8 04             	sub    $0x4,%eax
  801e2b:	8b 30                	mov    (%eax),%esi
  801e2d:	85 f6                	test   %esi,%esi
  801e2f:	75 05                	jne    801e36 <vprintfmt+0x1a6>
				p = "(null)";
  801e31:	be 31 61 80 00       	mov    $0x806131,%esi
			if (width > 0 && padc != '-')
  801e36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e3a:	7e 6d                	jle    801ea9 <vprintfmt+0x219>
  801e3c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801e40:	74 67                	je     801ea9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801e42:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e45:	83 ec 08             	sub    $0x8,%esp
  801e48:	50                   	push   %eax
  801e49:	56                   	push   %esi
  801e4a:	e8 1e 03 00 00       	call   80216d <strnlen>
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801e55:	eb 16                	jmp    801e6d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801e57:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801e5b:	83 ec 08             	sub    $0x8,%esp
  801e5e:	ff 75 0c             	pushl  0xc(%ebp)
  801e61:	50                   	push   %eax
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	ff d0                	call   *%eax
  801e67:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801e6a:	ff 4d e4             	decl   -0x1c(%ebp)
  801e6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e71:	7f e4                	jg     801e57 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801e73:	eb 34                	jmp    801ea9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801e75:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e79:	74 1c                	je     801e97 <vprintfmt+0x207>
  801e7b:	83 fb 1f             	cmp    $0x1f,%ebx
  801e7e:	7e 05                	jle    801e85 <vprintfmt+0x1f5>
  801e80:	83 fb 7e             	cmp    $0x7e,%ebx
  801e83:	7e 12                	jle    801e97 <vprintfmt+0x207>
					putch('?', putdat);
  801e85:	83 ec 08             	sub    $0x8,%esp
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	6a 3f                	push   $0x3f
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	ff d0                	call   *%eax
  801e92:	83 c4 10             	add    $0x10,%esp
  801e95:	eb 0f                	jmp    801ea6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801e97:	83 ec 08             	sub    $0x8,%esp
  801e9a:	ff 75 0c             	pushl  0xc(%ebp)
  801e9d:	53                   	push   %ebx
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	ff d0                	call   *%eax
  801ea3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ea6:	ff 4d e4             	decl   -0x1c(%ebp)
  801ea9:	89 f0                	mov    %esi,%eax
  801eab:	8d 70 01             	lea    0x1(%eax),%esi
  801eae:	8a 00                	mov    (%eax),%al
  801eb0:	0f be d8             	movsbl %al,%ebx
  801eb3:	85 db                	test   %ebx,%ebx
  801eb5:	74 24                	je     801edb <vprintfmt+0x24b>
  801eb7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ebb:	78 b8                	js     801e75 <vprintfmt+0x1e5>
  801ebd:	ff 4d e0             	decl   -0x20(%ebp)
  801ec0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ec4:	79 af                	jns    801e75 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ec6:	eb 13                	jmp    801edb <vprintfmt+0x24b>
				putch(' ', putdat);
  801ec8:	83 ec 08             	sub    $0x8,%esp
  801ecb:	ff 75 0c             	pushl  0xc(%ebp)
  801ece:	6a 20                	push   $0x20
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	ff d0                	call   *%eax
  801ed5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801ed8:	ff 4d e4             	decl   -0x1c(%ebp)
  801edb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801edf:	7f e7                	jg     801ec8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801ee1:	e9 78 01 00 00       	jmp    80205e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801ee6:	83 ec 08             	sub    $0x8,%esp
  801ee9:	ff 75 e8             	pushl  -0x18(%ebp)
  801eec:	8d 45 14             	lea    0x14(%ebp),%eax
  801eef:	50                   	push   %eax
  801ef0:	e8 3c fd ff ff       	call   801c31 <getint>
  801ef5:	83 c4 10             	add    $0x10,%esp
  801ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801efb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f04:	85 d2                	test   %edx,%edx
  801f06:	79 23                	jns    801f2b <vprintfmt+0x29b>
				putch('-', putdat);
  801f08:	83 ec 08             	sub    $0x8,%esp
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	6a 2d                	push   $0x2d
  801f10:	8b 45 08             	mov    0x8(%ebp),%eax
  801f13:	ff d0                	call   *%eax
  801f15:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1e:	f7 d8                	neg    %eax
  801f20:	83 d2 00             	adc    $0x0,%edx
  801f23:	f7 da                	neg    %edx
  801f25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f28:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801f2b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f32:	e9 bc 00 00 00       	jmp    801ff3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801f37:	83 ec 08             	sub    $0x8,%esp
  801f3a:	ff 75 e8             	pushl  -0x18(%ebp)
  801f3d:	8d 45 14             	lea    0x14(%ebp),%eax
  801f40:	50                   	push   %eax
  801f41:	e8 84 fc ff ff       	call   801bca <getuint>
  801f46:	83 c4 10             	add    $0x10,%esp
  801f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801f4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801f56:	e9 98 00 00 00       	jmp    801ff3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801f5b:	83 ec 08             	sub    $0x8,%esp
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	6a 58                	push   $0x58
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	ff d0                	call   *%eax
  801f68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f6b:	83 ec 08             	sub    $0x8,%esp
  801f6e:	ff 75 0c             	pushl  0xc(%ebp)
  801f71:	6a 58                	push   $0x58
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	ff d0                	call   *%eax
  801f78:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801f7b:	83 ec 08             	sub    $0x8,%esp
  801f7e:	ff 75 0c             	pushl  0xc(%ebp)
  801f81:	6a 58                	push   $0x58
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	ff d0                	call   *%eax
  801f88:	83 c4 10             	add    $0x10,%esp
			break;
  801f8b:	e9 ce 00 00 00       	jmp    80205e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  801f90:	83 ec 08             	sub    $0x8,%esp
  801f93:	ff 75 0c             	pushl  0xc(%ebp)
  801f96:	6a 30                	push   $0x30
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	ff d0                	call   *%eax
  801f9d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801fa0:	83 ec 08             	sub    $0x8,%esp
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	6a 78                	push   $0x78
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	ff d0                	call   *%eax
  801fad:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb3:	83 c0 04             	add    $0x4,%eax
  801fb6:	89 45 14             	mov    %eax,0x14(%ebp)
  801fb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fbc:	83 e8 04             	sub    $0x4,%eax
  801fbf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801fcb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801fd2:	eb 1f                	jmp    801ff3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801fd4:	83 ec 08             	sub    $0x8,%esp
  801fd7:	ff 75 e8             	pushl  -0x18(%ebp)
  801fda:	8d 45 14             	lea    0x14(%ebp),%eax
  801fdd:	50                   	push   %eax
  801fde:	e8 e7 fb ff ff       	call   801bca <getuint>
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801fec:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801ff3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	52                   	push   %edx
  801ffe:	ff 75 e4             	pushl  -0x1c(%ebp)
  802001:	50                   	push   %eax
  802002:	ff 75 f4             	pushl  -0xc(%ebp)
  802005:	ff 75 f0             	pushl  -0x10(%ebp)
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	ff 75 08             	pushl  0x8(%ebp)
  80200e:	e8 00 fb ff ff       	call   801b13 <printnum>
  802013:	83 c4 20             	add    $0x20,%esp
			break;
  802016:	eb 46                	jmp    80205e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  802018:	83 ec 08             	sub    $0x8,%esp
  80201b:	ff 75 0c             	pushl  0xc(%ebp)
  80201e:	53                   	push   %ebx
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	ff d0                	call   *%eax
  802024:	83 c4 10             	add    $0x10,%esp
			break;
  802027:	eb 35                	jmp    80205e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  802029:	c6 05 44 70 98 00 00 	movb   $0x0,0x987044
			break;
  802030:	eb 2c                	jmp    80205e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  802032:	c6 05 44 70 98 00 01 	movb   $0x1,0x987044
			break;
  802039:	eb 23                	jmp    80205e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80203b:	83 ec 08             	sub    $0x8,%esp
  80203e:	ff 75 0c             	pushl  0xc(%ebp)
  802041:	6a 25                	push   $0x25
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	ff d0                	call   *%eax
  802048:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80204b:	ff 4d 10             	decl   0x10(%ebp)
  80204e:	eb 03                	jmp    802053 <vprintfmt+0x3c3>
  802050:	ff 4d 10             	decl   0x10(%ebp)
  802053:	8b 45 10             	mov    0x10(%ebp),%eax
  802056:	48                   	dec    %eax
  802057:	8a 00                	mov    (%eax),%al
  802059:	3c 25                	cmp    $0x25,%al
  80205b:	75 f3                	jne    802050 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80205d:	90                   	nop
		}
	}
  80205e:	e9 35 fc ff ff       	jmp    801c98 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  802063:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  802064:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    

0080206b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  802071:	8d 45 10             	lea    0x10(%ebp),%eax
  802074:	83 c0 04             	add    $0x4,%eax
  802077:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80207a:	8b 45 10             	mov    0x10(%ebp),%eax
  80207d:	ff 75 f4             	pushl  -0xc(%ebp)
  802080:	50                   	push   %eax
  802081:	ff 75 0c             	pushl  0xc(%ebp)
  802084:	ff 75 08             	pushl  0x8(%ebp)
  802087:	e8 04 fc ff ff       	call   801c90 <vprintfmt>
  80208c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80208f:	90                   	nop
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  802095:	8b 45 0c             	mov    0xc(%ebp),%eax
  802098:	8b 40 08             	mov    0x8(%eax),%eax
  80209b:	8d 50 01             	lea    0x1(%eax),%edx
  80209e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8020a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a7:	8b 10                	mov    (%eax),%edx
  8020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ac:	8b 40 04             	mov    0x4(%eax),%eax
  8020af:	39 c2                	cmp    %eax,%edx
  8020b1:	73 12                	jae    8020c5 <sprintputch+0x33>
		*b->buf++ = ch;
  8020b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	8d 48 01             	lea    0x1(%eax),%ecx
  8020bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020be:	89 0a                	mov    %ecx,(%edx)
  8020c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020c3:	88 10                	mov    %dl,(%eax)
}
  8020c5:	90                   	nop
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    

008020c8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	01 d0                	add    %edx,%eax
  8020df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8020e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ed:	74 06                	je     8020f5 <vsnprintf+0x2d>
  8020ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8020f3:	7f 07                	jg     8020fc <vsnprintf+0x34>
		return -E_INVAL;
  8020f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8020fa:	eb 20                	jmp    80211c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8020fc:	ff 75 14             	pushl  0x14(%ebp)
  8020ff:	ff 75 10             	pushl  0x10(%ebp)
  802102:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802105:	50                   	push   %eax
  802106:	68 92 20 80 00       	push   $0x802092
  80210b:	e8 80 fb ff ff       	call   801c90 <vprintfmt>
  802110:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  802113:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802116:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  802124:	8d 45 10             	lea    0x10(%ebp),%eax
  802127:	83 c0 04             	add    $0x4,%eax
  80212a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80212d:	8b 45 10             	mov    0x10(%ebp),%eax
  802130:	ff 75 f4             	pushl  -0xc(%ebp)
  802133:	50                   	push   %eax
  802134:	ff 75 0c             	pushl  0xc(%ebp)
  802137:	ff 75 08             	pushl  0x8(%ebp)
  80213a:	e8 89 ff ff ff       	call   8020c8 <vsnprintf>
  80213f:	83 c4 10             	add    $0x10,%esp
  802142:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  802145:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  802150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802157:	eb 06                	jmp    80215f <strlen+0x15>
		n++;
  802159:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80215c:	ff 45 08             	incl   0x8(%ebp)
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	84 c0                	test   %al,%al
  802166:	75 f1                	jne    802159 <strlen+0xf>
		n++;
	return n;
  802168:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80216b:	c9                   	leave  
  80216c:	c3                   	ret    

0080216d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80216d:	55                   	push   %ebp
  80216e:	89 e5                	mov    %esp,%ebp
  802170:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802173:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80217a:	eb 09                	jmp    802185 <strnlen+0x18>
		n++;
  80217c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80217f:	ff 45 08             	incl   0x8(%ebp)
  802182:	ff 4d 0c             	decl   0xc(%ebp)
  802185:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802189:	74 09                	je     802194 <strnlen+0x27>
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	8a 00                	mov    (%eax),%al
  802190:	84 c0                	test   %al,%al
  802192:	75 e8                	jne    80217c <strnlen+0xf>
		n++;
	return n;
  802194:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
  80219c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8021a5:	90                   	nop
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8d 50 01             	lea    0x1(%eax),%edx
  8021ac:	89 55 08             	mov    %edx,0x8(%ebp)
  8021af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8021b5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8021b8:	8a 12                	mov    (%edx),%dl
  8021ba:	88 10                	mov    %dl,(%eax)
  8021bc:	8a 00                	mov    (%eax),%al
  8021be:	84 c0                	test   %al,%al
  8021c0:	75 e4                	jne    8021a6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8021c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8021d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8021da:	eb 1f                	jmp    8021fb <strncpy+0x34>
		*dst++ = *src;
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	8d 50 01             	lea    0x1(%eax),%edx
  8021e2:	89 55 08             	mov    %edx,0x8(%ebp)
  8021e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e8:	8a 12                	mov    (%edx),%dl
  8021ea:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	8a 00                	mov    (%eax),%al
  8021f1:	84 c0                	test   %al,%al
  8021f3:	74 03                	je     8021f8 <strncpy+0x31>
			src++;
  8021f5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8021f8:	ff 45 fc             	incl   -0x4(%ebp)
  8021fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021fe:	3b 45 10             	cmp    0x10(%ebp),%eax
  802201:	72 d9                	jb     8021dc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  802203:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80220e:	8b 45 08             	mov    0x8(%ebp),%eax
  802211:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  802214:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802218:	74 30                	je     80224a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80221a:	eb 16                	jmp    802232 <strlcpy+0x2a>
			*dst++ = *src++;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	8d 50 01             	lea    0x1(%eax),%edx
  802222:	89 55 08             	mov    %edx,0x8(%ebp)
  802225:	8b 55 0c             	mov    0xc(%ebp),%edx
  802228:	8d 4a 01             	lea    0x1(%edx),%ecx
  80222b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80222e:	8a 12                	mov    (%edx),%dl
  802230:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802232:	ff 4d 10             	decl   0x10(%ebp)
  802235:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802239:	74 09                	je     802244 <strlcpy+0x3c>
  80223b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223e:	8a 00                	mov    (%eax),%al
  802240:	84 c0                	test   %al,%al
  802242:	75 d8                	jne    80221c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80224a:	8b 55 08             	mov    0x8(%ebp),%edx
  80224d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802250:	29 c2                	sub    %eax,%edx
  802252:	89 d0                	mov    %edx,%eax
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  802259:	eb 06                	jmp    802261 <strcmp+0xb>
		p++, q++;
  80225b:	ff 45 08             	incl   0x8(%ebp)
  80225e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	8a 00                	mov    (%eax),%al
  802266:	84 c0                	test   %al,%al
  802268:	74 0e                	je     802278 <strcmp+0x22>
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	8a 10                	mov    (%eax),%dl
  80226f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802272:	8a 00                	mov    (%eax),%al
  802274:	38 c2                	cmp    %al,%dl
  802276:	74 e3                	je     80225b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	8a 00                	mov    (%eax),%al
  80227d:	0f b6 d0             	movzbl %al,%edx
  802280:	8b 45 0c             	mov    0xc(%ebp),%eax
  802283:	8a 00                	mov    (%eax),%al
  802285:	0f b6 c0             	movzbl %al,%eax
  802288:	29 c2                	sub    %eax,%edx
  80228a:	89 d0                	mov    %edx,%eax
}
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    

0080228e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  802291:	eb 09                	jmp    80229c <strncmp+0xe>
		n--, p++, q++;
  802293:	ff 4d 10             	decl   0x10(%ebp)
  802296:	ff 45 08             	incl   0x8(%ebp)
  802299:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80229c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a0:	74 17                	je     8022b9 <strncmp+0x2b>
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	8a 00                	mov    (%eax),%al
  8022a7:	84 c0                	test   %al,%al
  8022a9:	74 0e                	je     8022b9 <strncmp+0x2b>
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	8a 10                	mov    (%eax),%dl
  8022b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b3:	8a 00                	mov    (%eax),%al
  8022b5:	38 c2                	cmp    %al,%dl
  8022b7:	74 da                	je     802293 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8022b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022bd:	75 07                	jne    8022c6 <strncmp+0x38>
		return 0;
  8022bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c4:	eb 14                	jmp    8022da <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8a 00                	mov    (%eax),%al
  8022cb:	0f b6 d0             	movzbl %al,%edx
  8022ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d1:	8a 00                	mov    (%eax),%al
  8022d3:	0f b6 c0             	movzbl %al,%eax
  8022d6:	29 c2                	sub    %eax,%edx
  8022d8:	89 d0                	mov    %edx,%eax
}
  8022da:	5d                   	pop    %ebp
  8022db:	c3                   	ret    

008022dc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8022dc:	55                   	push   %ebp
  8022dd:	89 e5                	mov    %esp,%ebp
  8022df:	83 ec 04             	sub    $0x4,%esp
  8022e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8022e8:	eb 12                	jmp    8022fc <strchr+0x20>
		if (*s == c)
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	8a 00                	mov    (%eax),%al
  8022ef:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8022f2:	75 05                	jne    8022f9 <strchr+0x1d>
			return (char *) s;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	eb 11                	jmp    80230a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8022f9:	ff 45 08             	incl   0x8(%ebp)
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	8a 00                	mov    (%eax),%al
  802301:	84 c0                	test   %al,%al
  802303:	75 e5                	jne    8022ea <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 04             	sub    $0x4,%esp
  802312:	8b 45 0c             	mov    0xc(%ebp),%eax
  802315:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802318:	eb 0d                	jmp    802327 <strfind+0x1b>
		if (*s == c)
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	8a 00                	mov    (%eax),%al
  80231f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  802322:	74 0e                	je     802332 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  802324:	ff 45 08             	incl   0x8(%ebp)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8a 00                	mov    (%eax),%al
  80232c:	84 c0                	test   %al,%al
  80232e:	75 ea                	jne    80231a <strfind+0xe>
  802330:	eb 01                	jmp    802333 <strfind+0x27>
		if (*s == c)
			break;
  802332:	90                   	nop
	return (char *) s;
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
  80233b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  802344:	8b 45 10             	mov    0x10(%ebp),%eax
  802347:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80234a:	eb 0e                	jmp    80235a <memset+0x22>
		*p++ = c;
  80234c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80234f:	8d 50 01             	lea    0x1(%eax),%edx
  802352:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802355:	8b 55 0c             	mov    0xc(%ebp),%edx
  802358:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80235a:	ff 4d f8             	decl   -0x8(%ebp)
  80235d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  802361:	79 e9                	jns    80234c <memset+0x14>
		*p++ = c;

	return v;
  802363:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
  80236b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80236e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802371:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80237a:	eb 16                	jmp    802392 <memcpy+0x2a>
		*d++ = *s++;
  80237c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80237f:	8d 50 01             	lea    0x1(%eax),%edx
  802382:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8d 4a 01             	lea    0x1(%edx),%ecx
  80238b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80238e:	8a 12                	mov    (%edx),%dl
  802390:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  802392:	8b 45 10             	mov    0x10(%ebp),%eax
  802395:	8d 50 ff             	lea    -0x1(%eax),%edx
  802398:	89 55 10             	mov    %edx,0x10(%ebp)
  80239b:	85 c0                	test   %eax,%eax
  80239d:	75 dd                	jne    80237c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8023aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8023b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8023bc:	73 50                	jae    80240e <memmove+0x6a>
  8023be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023c4:	01 d0                	add    %edx,%eax
  8023c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8023c9:	76 43                	jbe    80240e <memmove+0x6a>
		s += n;
  8023cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ce:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8023d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8023d7:	eb 10                	jmp    8023e9 <memmove+0x45>
			*--d = *--s;
  8023d9:	ff 4d f8             	decl   -0x8(%ebp)
  8023dc:	ff 4d fc             	decl   -0x4(%ebp)
  8023df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023e2:	8a 10                	mov    (%eax),%dl
  8023e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023e7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8023e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ec:	8d 50 ff             	lea    -0x1(%eax),%edx
  8023ef:	89 55 10             	mov    %edx,0x10(%ebp)
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	75 e3                	jne    8023d9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8023f6:	eb 23                	jmp    80241b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8023f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023fb:	8d 50 01             	lea    0x1(%eax),%edx
  8023fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802401:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802404:	8d 4a 01             	lea    0x1(%edx),%ecx
  802407:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80240a:	8a 12                	mov    (%edx),%dl
  80240c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80240e:	8b 45 10             	mov    0x10(%ebp),%eax
  802411:	8d 50 ff             	lea    -0x1(%eax),%edx
  802414:	89 55 10             	mov    %edx,0x10(%ebp)
  802417:	85 c0                	test   %eax,%eax
  802419:	75 dd                	jne    8023f8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80242c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802432:	eb 2a                	jmp    80245e <memcmp+0x3e>
		if (*s1 != *s2)
  802434:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802437:	8a 10                	mov    (%eax),%dl
  802439:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80243c:	8a 00                	mov    (%eax),%al
  80243e:	38 c2                	cmp    %al,%dl
  802440:	74 16                	je     802458 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802442:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802445:	8a 00                	mov    (%eax),%al
  802447:	0f b6 d0             	movzbl %al,%edx
  80244a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80244d:	8a 00                	mov    (%eax),%al
  80244f:	0f b6 c0             	movzbl %al,%eax
  802452:	29 c2                	sub    %eax,%edx
  802454:	89 d0                	mov    %edx,%eax
  802456:	eb 18                	jmp    802470 <memcmp+0x50>
		s1++, s2++;
  802458:	ff 45 fc             	incl   -0x4(%ebp)
  80245b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80245e:	8b 45 10             	mov    0x10(%ebp),%eax
  802461:	8d 50 ff             	lea    -0x1(%eax),%edx
  802464:	89 55 10             	mov    %edx,0x10(%ebp)
  802467:	85 c0                	test   %eax,%eax
  802469:	75 c9                	jne    802434 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
  802475:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  802478:	8b 55 08             	mov    0x8(%ebp),%edx
  80247b:	8b 45 10             	mov    0x10(%ebp),%eax
  80247e:	01 d0                	add    %edx,%eax
  802480:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802483:	eb 15                	jmp    80249a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802485:	8b 45 08             	mov    0x8(%ebp),%eax
  802488:	8a 00                	mov    (%eax),%al
  80248a:	0f b6 d0             	movzbl %al,%edx
  80248d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802490:	0f b6 c0             	movzbl %al,%eax
  802493:	39 c2                	cmp    %eax,%edx
  802495:	74 0d                	je     8024a4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802497:	ff 45 08             	incl   0x8(%ebp)
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8024a0:	72 e3                	jb     802485 <memfind+0x13>
  8024a2:	eb 01                	jmp    8024a5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8024a4:	90                   	nop
	return (void *) s;
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8024a8:	c9                   	leave  
  8024a9:	c3                   	ret    

008024aa <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8024b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8024b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024be:	eb 03                	jmp    8024c3 <strtol+0x19>
		s++;
  8024c0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8024c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c6:	8a 00                	mov    (%eax),%al
  8024c8:	3c 20                	cmp    $0x20,%al
  8024ca:	74 f4                	je     8024c0 <strtol+0x16>
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	8a 00                	mov    (%eax),%al
  8024d1:	3c 09                	cmp    $0x9,%al
  8024d3:	74 eb                	je     8024c0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	8a 00                	mov    (%eax),%al
  8024da:	3c 2b                	cmp    $0x2b,%al
  8024dc:	75 05                	jne    8024e3 <strtol+0x39>
		s++;
  8024de:	ff 45 08             	incl   0x8(%ebp)
  8024e1:	eb 13                	jmp    8024f6 <strtol+0x4c>
	else if (*s == '-')
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	8a 00                	mov    (%eax),%al
  8024e8:	3c 2d                	cmp    $0x2d,%al
  8024ea:	75 0a                	jne    8024f6 <strtol+0x4c>
		s++, neg = 1;
  8024ec:	ff 45 08             	incl   0x8(%ebp)
  8024ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8024f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024fa:	74 06                	je     802502 <strtol+0x58>
  8024fc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802500:	75 20                	jne    802522 <strtol+0x78>
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	8a 00                	mov    (%eax),%al
  802507:	3c 30                	cmp    $0x30,%al
  802509:	75 17                	jne    802522 <strtol+0x78>
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	40                   	inc    %eax
  80250f:	8a 00                	mov    (%eax),%al
  802511:	3c 78                	cmp    $0x78,%al
  802513:	75 0d                	jne    802522 <strtol+0x78>
		s += 2, base = 16;
  802515:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802519:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802520:	eb 28                	jmp    80254a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802522:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802526:	75 15                	jne    80253d <strtol+0x93>
  802528:	8b 45 08             	mov    0x8(%ebp),%eax
  80252b:	8a 00                	mov    (%eax),%al
  80252d:	3c 30                	cmp    $0x30,%al
  80252f:	75 0c                	jne    80253d <strtol+0x93>
		s++, base = 8;
  802531:	ff 45 08             	incl   0x8(%ebp)
  802534:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80253b:	eb 0d                	jmp    80254a <strtol+0xa0>
	else if (base == 0)
  80253d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802541:	75 07                	jne    80254a <strtol+0xa0>
		base = 10;
  802543:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	8a 00                	mov    (%eax),%al
  80254f:	3c 2f                	cmp    $0x2f,%al
  802551:	7e 19                	jle    80256c <strtol+0xc2>
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	8a 00                	mov    (%eax),%al
  802558:	3c 39                	cmp    $0x39,%al
  80255a:	7f 10                	jg     80256c <strtol+0xc2>
			dig = *s - '0';
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	8a 00                	mov    (%eax),%al
  802561:	0f be c0             	movsbl %al,%eax
  802564:	83 e8 30             	sub    $0x30,%eax
  802567:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80256a:	eb 42                	jmp    8025ae <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	8a 00                	mov    (%eax),%al
  802571:	3c 60                	cmp    $0x60,%al
  802573:	7e 19                	jle    80258e <strtol+0xe4>
  802575:	8b 45 08             	mov    0x8(%ebp),%eax
  802578:	8a 00                	mov    (%eax),%al
  80257a:	3c 7a                	cmp    $0x7a,%al
  80257c:	7f 10                	jg     80258e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	8a 00                	mov    (%eax),%al
  802583:	0f be c0             	movsbl %al,%eax
  802586:	83 e8 57             	sub    $0x57,%eax
  802589:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258c:	eb 20                	jmp    8025ae <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	8a 00                	mov    (%eax),%al
  802593:	3c 40                	cmp    $0x40,%al
  802595:	7e 39                	jle    8025d0 <strtol+0x126>
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	8a 00                	mov    (%eax),%al
  80259c:	3c 5a                	cmp    $0x5a,%al
  80259e:	7f 30                	jg     8025d0 <strtol+0x126>
			dig = *s - 'A' + 10;
  8025a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a3:	8a 00                	mov    (%eax),%al
  8025a5:	0f be c0             	movsbl %al,%eax
  8025a8:	83 e8 37             	sub    $0x37,%eax
  8025ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8025b4:	7d 19                	jge    8025cf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8025b6:	ff 45 08             	incl   0x8(%ebp)
  8025b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025bc:	0f af 45 10          	imul   0x10(%ebp),%eax
  8025c0:	89 c2                	mov    %eax,%edx
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	01 d0                	add    %edx,%eax
  8025c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8025ca:	e9 7b ff ff ff       	jmp    80254a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8025cf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8025d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8025d4:	74 08                	je     8025de <strtol+0x134>
		*endptr = (char *) s;
  8025d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025dc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8025de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025e2:	74 07                	je     8025eb <strtol+0x141>
  8025e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025e7:	f7 d8                	neg    %eax
  8025e9:	eb 03                	jmp    8025ee <strtol+0x144>
  8025eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8025ee:	c9                   	leave  
  8025ef:	c3                   	ret    

008025f0 <ltostr>:

void
ltostr(long value, char *str)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8025f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8025fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802604:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802608:	79 13                	jns    80261d <ltostr+0x2d>
	{
		neg = 1;
  80260a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802611:	8b 45 0c             	mov    0xc(%ebp),%eax
  802614:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802617:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80261a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80261d:	8b 45 08             	mov    0x8(%ebp),%eax
  802620:	b9 0a 00 00 00       	mov    $0xa,%ecx
  802625:	99                   	cltd   
  802626:	f7 f9                	idiv   %ecx
  802628:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80262b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80262e:	8d 50 01             	lea    0x1(%eax),%edx
  802631:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802634:	89 c2                	mov    %eax,%edx
  802636:	8b 45 0c             	mov    0xc(%ebp),%eax
  802639:	01 d0                	add    %edx,%eax
  80263b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80263e:	83 c2 30             	add    $0x30,%edx
  802641:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802643:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802646:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80264b:	f7 e9                	imul   %ecx
  80264d:	c1 fa 02             	sar    $0x2,%edx
  802650:	89 c8                	mov    %ecx,%eax
  802652:	c1 f8 1f             	sar    $0x1f,%eax
  802655:	29 c2                	sub    %eax,%edx
  802657:	89 d0                	mov    %edx,%eax
  802659:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80265c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802660:	75 bb                	jne    80261d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802669:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80266c:	48                   	dec    %eax
  80266d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  802670:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802674:	74 3d                	je     8026b3 <ltostr+0xc3>
		start = 1 ;
  802676:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80267d:	eb 34                	jmp    8026b3 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80267f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802682:	8b 45 0c             	mov    0xc(%ebp),%eax
  802685:	01 d0                	add    %edx,%eax
  802687:	8a 00                	mov    (%eax),%al
  802689:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80268c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802692:	01 c2                	add    %eax,%edx
  802694:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802697:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269a:	01 c8                	add    %ecx,%eax
  80269c:	8a 00                	mov    (%eax),%al
  80269e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8026a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a6:	01 c2                	add    %eax,%edx
  8026a8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8026ab:	88 02                	mov    %al,(%edx)
		start++ ;
  8026ad:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8026b0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8026b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026b9:	7c c4                	jl     80267f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8026bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8026be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c1:	01 d0                	add    %edx,%eax
  8026c3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8026c6:	90                   	nop
  8026c7:	c9                   	leave  
  8026c8:	c3                   	ret    

008026c9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8026cf:	ff 75 08             	pushl  0x8(%ebp)
  8026d2:	e8 73 fa ff ff       	call   80214a <strlen>
  8026d7:	83 c4 04             	add    $0x4,%esp
  8026da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8026dd:	ff 75 0c             	pushl  0xc(%ebp)
  8026e0:	e8 65 fa ff ff       	call   80214a <strlen>
  8026e5:	83 c4 04             	add    $0x4,%esp
  8026e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8026eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8026f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8026f9:	eb 17                	jmp    802712 <strcconcat+0x49>
		final[s] = str1[s] ;
  8026fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802701:	01 c2                	add    %eax,%edx
  802703:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	01 c8                	add    %ecx,%eax
  80270b:	8a 00                	mov    (%eax),%al
  80270d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80270f:	ff 45 fc             	incl   -0x4(%ebp)
  802712:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802715:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802718:	7c e1                	jl     8026fb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80271a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802721:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  802728:	eb 1f                	jmp    802749 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80272a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80272d:	8d 50 01             	lea    0x1(%eax),%edx
  802730:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802733:	89 c2                	mov    %eax,%edx
  802735:	8b 45 10             	mov    0x10(%ebp),%eax
  802738:	01 c2                	add    %eax,%edx
  80273a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80273d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802740:	01 c8                	add    %ecx,%eax
  802742:	8a 00                	mov    (%eax),%al
  802744:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  802746:	ff 45 f8             	incl   -0x8(%ebp)
  802749:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80274c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80274f:	7c d9                	jl     80272a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802751:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802754:	8b 45 10             	mov    0x10(%ebp),%eax
  802757:	01 d0                	add    %edx,%eax
  802759:	c6 00 00             	movb   $0x0,(%eax)
}
  80275c:	90                   	nop
  80275d:	c9                   	leave  
  80275e:	c3                   	ret    

0080275f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80275f:	55                   	push   %ebp
  802760:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802762:	8b 45 14             	mov    0x14(%ebp),%eax
  802765:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80276b:	8b 45 14             	mov    0x14(%ebp),%eax
  80276e:	8b 00                	mov    (%eax),%eax
  802770:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802777:	8b 45 10             	mov    0x10(%ebp),%eax
  80277a:	01 d0                	add    %edx,%eax
  80277c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802782:	eb 0c                	jmp    802790 <strsplit+0x31>
			*string++ = 0;
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	8d 50 01             	lea    0x1(%eax),%edx
  80278a:	89 55 08             	mov    %edx,0x8(%ebp)
  80278d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  802790:	8b 45 08             	mov    0x8(%ebp),%eax
  802793:	8a 00                	mov    (%eax),%al
  802795:	84 c0                	test   %al,%al
  802797:	74 18                	je     8027b1 <strsplit+0x52>
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	8a 00                	mov    (%eax),%al
  80279e:	0f be c0             	movsbl %al,%eax
  8027a1:	50                   	push   %eax
  8027a2:	ff 75 0c             	pushl  0xc(%ebp)
  8027a5:	e8 32 fb ff ff       	call   8022dc <strchr>
  8027aa:	83 c4 08             	add    $0x8,%esp
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	75 d3                	jne    802784 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	8a 00                	mov    (%eax),%al
  8027b6:	84 c0                	test   %al,%al
  8027b8:	74 5a                	je     802814 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8027ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	83 f8 0f             	cmp    $0xf,%eax
  8027c2:	75 07                	jne    8027cb <strsplit+0x6c>
		{
			return 0;
  8027c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c9:	eb 66                	jmp    802831 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8027cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	8d 48 01             	lea    0x1(%eax),%ecx
  8027d3:	8b 55 14             	mov    0x14(%ebp),%edx
  8027d6:	89 0a                	mov    %ecx,(%edx)
  8027d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8027df:	8b 45 10             	mov    0x10(%ebp),%eax
  8027e2:	01 c2                	add    %eax,%edx
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8027e9:	eb 03                	jmp    8027ee <strsplit+0x8f>
			string++;
  8027eb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8027ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f1:	8a 00                	mov    (%eax),%al
  8027f3:	84 c0                	test   %al,%al
  8027f5:	74 8b                	je     802782 <strsplit+0x23>
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	8a 00                	mov    (%eax),%al
  8027fc:	0f be c0             	movsbl %al,%eax
  8027ff:	50                   	push   %eax
  802800:	ff 75 0c             	pushl  0xc(%ebp)
  802803:	e8 d4 fa ff ff       	call   8022dc <strchr>
  802808:	83 c4 08             	add    $0x8,%esp
  80280b:	85 c0                	test   %eax,%eax
  80280d:	74 dc                	je     8027eb <strsplit+0x8c>
			string++;
	}
  80280f:	e9 6e ff ff ff       	jmp    802782 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802814:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802815:	8b 45 14             	mov    0x14(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802821:	8b 45 10             	mov    0x10(%ebp),%eax
  802824:	01 d0                	add    %edx,%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80282c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
  802836:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  802839:	83 ec 04             	sub    $0x4,%esp
  80283c:	68 a8 62 80 00       	push   $0x8062a8
  802841:	68 3f 01 00 00       	push   $0x13f
  802846:	68 ca 62 80 00       	push   $0x8062ca
  80284b:	e8 a9 ef ff ff       	call   8017f9 <_panic>

00802850 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  802856:	83 ec 0c             	sub    $0xc,%esp
  802859:	ff 75 08             	pushl  0x8(%ebp)
  80285c:	e8 90 0c 00 00       	call   8034f1 <sys_sbrk>
  802861:	83 c4 10             	add    $0x10,%esp
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80286c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802870:	75 0a                	jne    80287c <malloc+0x16>
		return NULL;
  802872:	b8 00 00 00 00       	mov    $0x0,%eax
  802877:	e9 9e 01 00 00       	jmp    802a1a <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80287c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  802883:	77 2c                	ja     8028b1 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  802885:	e8 eb 0a 00 00       	call   803375 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80288a:	85 c0                	test   %eax,%eax
  80288c:	74 19                	je     8028a7 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80288e:	83 ec 0c             	sub    $0xc,%esp
  802891:	ff 75 08             	pushl  0x8(%ebp)
  802894:	e8 85 11 00 00       	call   803a1e <alloc_block_FF>
  802899:	83 c4 10             	add    $0x10,%esp
  80289c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80289f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028a2:	e9 73 01 00 00       	jmp    802a1a <malloc+0x1b4>
		} else {
			return NULL;
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ac:	e9 69 01 00 00       	jmp    802a1a <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8028b1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8028b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028be:	01 d0                	add    %edx,%eax
  8028c0:	48                   	dec    %eax
  8028c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8028c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028cc:	f7 75 e0             	divl   -0x20(%ebp)
  8028cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8028d2:	29 d0                	sub    %edx,%eax
  8028d4:	c1 e8 0c             	shr    $0xc,%eax
  8028d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8028da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8028e1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8028e8:	a1 20 70 80 00       	mov    0x807020,%eax
  8028ed:	8b 40 7c             	mov    0x7c(%eax),%eax
  8028f0:	05 00 10 00 00       	add    $0x1000,%eax
  8028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8028f8:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8028fd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802900:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802903:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80290a:	8b 55 08             	mov    0x8(%ebp),%edx
  80290d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802910:	01 d0                	add    %edx,%eax
  802912:	48                   	dec    %eax
  802913:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802916:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802919:	ba 00 00 00 00       	mov    $0x0,%edx
  80291e:	f7 75 cc             	divl   -0x34(%ebp)
  802921:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802924:	29 d0                	sub    %edx,%eax
  802926:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802929:	76 0a                	jbe    802935 <malloc+0xcf>
		return NULL;
  80292b:	b8 00 00 00 00       	mov    $0x0,%eax
  802930:	e9 e5 00 00 00       	jmp    802a1a <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  802935:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802938:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80293b:	eb 48                	jmp    802985 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80293d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802940:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802943:	c1 e8 0c             	shr    $0xc,%eax
  802946:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  802949:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80294c:	8b 04 85 40 70 90 00 	mov    0x907040(,%eax,4),%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	75 11                	jne    802968 <malloc+0x102>
			freePagesCount++;
  802957:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80295a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80295e:	75 16                	jne    802976 <malloc+0x110>
				start = i;
  802960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802963:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802966:	eb 0e                	jmp    802976 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  802968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80296f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80297c:	74 12                	je     802990 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80297e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802985:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80298c:	76 af                	jbe    80293d <malloc+0xd7>
  80298e:	eb 01                	jmp    802991 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  802990:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  802991:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802995:	74 08                	je     80299f <malloc+0x139>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80299d:	74 07                	je     8029a6 <malloc+0x140>
		return NULL;
  80299f:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a4:	eb 74                	jmp    802a1a <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8029a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8029ac:	c1 e8 0c             	shr    $0xc,%eax
  8029af:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8029b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029b8:	89 14 85 40 70 80 00 	mov    %edx,0x807040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8029bf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8029c5:	eb 11                	jmp    8029d8 <malloc+0x172>
		markedPages[i] = 1;
  8029c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029ca:	c7 04 85 40 70 90 00 	movl   $0x1,0x907040(,%eax,4)
  8029d1:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8029d5:	ff 45 e8             	incl   -0x18(%ebp)
  8029d8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8029db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029de:	01 d0                	add    %edx,%eax
  8029e0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8029e3:	77 e2                	ja     8029c7 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8029e5:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8029ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ef:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029f2:	01 d0                	add    %edx,%eax
  8029f4:	48                   	dec    %eax
  8029f5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8029f8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8029fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802a00:	f7 75 bc             	divl   -0x44(%ebp)
  802a03:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802a06:	29 d0                	sub    %edx,%eax
  802a08:	83 ec 08             	sub    $0x8,%esp
  802a0b:	50                   	push   %eax
  802a0c:	ff 75 f0             	pushl  -0x10(%ebp)
  802a0f:	e8 14 0b 00 00       	call   803528 <sys_allocate_user_mem>
  802a14:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  802a17:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  802a1a:	c9                   	leave  
  802a1b:	c3                   	ret    

00802a1c <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  802a1c:	55                   	push   %ebp
  802a1d:	89 e5                	mov    %esp,%ebp
  802a1f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  802a22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a26:	0f 84 ee 00 00 00    	je     802b1a <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  802a2c:	a1 20 70 80 00       	mov    0x807020,%eax
  802a31:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  802a34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a37:	77 09                	ja     802a42 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  802a39:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  802a40:	76 14                	jbe    802a56 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  802a42:	83 ec 04             	sub    $0x4,%esp
  802a45:	68 d8 62 80 00       	push   $0x8062d8
  802a4a:	6a 68                	push   $0x68
  802a4c:	68 f2 62 80 00       	push   $0x8062f2
  802a51:	e8 a3 ed ff ff       	call   8017f9 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  802a56:	a1 20 70 80 00       	mov    0x807020,%eax
  802a5b:	8b 40 74             	mov    0x74(%eax),%eax
  802a5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a61:	77 20                	ja     802a83 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  802a63:	a1 20 70 80 00       	mov    0x807020,%eax
  802a68:	8b 40 78             	mov    0x78(%eax),%eax
  802a6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6e:	76 13                	jbe    802a83 <free+0x67>
		free_block(virtual_address);
  802a70:	83 ec 0c             	sub    $0xc,%esp
  802a73:	ff 75 08             	pushl  0x8(%ebp)
  802a76:	e8 6c 16 00 00       	call   8040e7 <free_block>
  802a7b:	83 c4 10             	add    $0x10,%esp
		return;
  802a7e:	e9 98 00 00 00       	jmp    802b1b <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802a83:	8b 55 08             	mov    0x8(%ebp),%edx
  802a86:	a1 20 70 80 00       	mov    0x807020,%eax
  802a8b:	8b 40 7c             	mov    0x7c(%eax),%eax
  802a8e:	29 c2                	sub    %eax,%edx
  802a90:	89 d0                	mov    %edx,%eax
  802a92:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  802a97:	c1 e8 0c             	shr    $0xc,%eax
  802a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  802a9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aa4:	eb 16                	jmp    802abc <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  802aa6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aac:	01 d0                	add    %edx,%eax
  802aae:	c7 04 85 40 70 90 00 	movl   $0x0,0x907040(,%eax,4)
  802ab5:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  802ab9:	ff 45 f4             	incl   -0xc(%ebp)
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	8b 04 85 40 70 80 00 	mov    0x807040(,%eax,4),%eax
  802ac6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ac9:	7f db                	jg     802aa6 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  802acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ace:	8b 04 85 40 70 80 00 	mov    0x807040(,%eax,4),%eax
  802ad5:	c1 e0 0c             	shl    $0xc,%eax
  802ad8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ae1:	eb 1a                	jmp    802afd <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  802ae3:	83 ec 08             	sub    $0x8,%esp
  802ae6:	68 00 10 00 00       	push   $0x1000
  802aeb:	ff 75 f0             	pushl  -0x10(%ebp)
  802aee:	e8 19 0a 00 00       	call   80350c <sys_free_user_mem>
  802af3:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  802af6:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802afd:	8b 55 08             	mov    0x8(%ebp),%edx
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  802b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b08:	77 d9                	ja     802ae3 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  802b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0d:	c7 04 85 40 70 80 00 	movl   $0x0,0x807040(,%eax,4)
  802b14:	00 00 00 00 
  802b18:	eb 01                	jmp    802b1b <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  802b1a:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  802b1b:	c9                   	leave  
  802b1c:	c3                   	ret    

00802b1d <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  802b1d:	55                   	push   %ebp
  802b1e:	89 e5                	mov    %esp,%ebp
  802b20:	83 ec 58             	sub    $0x58,%esp
  802b23:	8b 45 10             	mov    0x10(%ebp),%eax
  802b26:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  802b29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802b2d:	75 0a                	jne    802b39 <smalloc+0x1c>
		return NULL;
  802b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b34:	e9 7d 01 00 00       	jmp    802cb6 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802b39:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  802b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b46:	01 d0                	add    %edx,%eax
  802b48:	48                   	dec    %eax
  802b49:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802b4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4f:	ba 00 00 00 00       	mov    $0x0,%edx
  802b54:	f7 75 e4             	divl   -0x1c(%ebp)
  802b57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b5a:	29 d0                	sub    %edx,%eax
  802b5c:	c1 e8 0c             	shr    $0xc,%eax
  802b5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  802b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802b69:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  802b70:	a1 20 70 80 00       	mov    0x807020,%eax
  802b75:	8b 40 7c             	mov    0x7c(%eax),%eax
  802b78:	05 00 10 00 00       	add    $0x1000,%eax
  802b7d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  802b80:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802b85:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802b88:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  802b8b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  802b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802b98:	01 d0                	add    %edx,%eax
  802b9a:	48                   	dec    %eax
  802b9b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802b9e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802ba1:	ba 00 00 00 00       	mov    $0x0,%edx
  802ba6:	f7 75 d0             	divl   -0x30(%ebp)
  802ba9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802bac:	29 d0                	sub    %edx,%eax
  802bae:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802bb1:	76 0a                	jbe    802bbd <smalloc+0xa0>
		return NULL;
  802bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bb8:	e9 f9 00 00 00       	jmp    802cb6 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802bbd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802bc3:	eb 48                	jmp    802c0d <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802bc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802bcb:	c1 e8 0c             	shr    $0xc,%eax
  802bce:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  802bd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802bd4:	8b 04 85 40 70 90 00 	mov    0x907040(,%eax,4),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	75 11                	jne    802bf0 <smalloc+0xd3>
			freePagesCount++;
  802bdf:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802be2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802be6:	75 16                	jne    802bfe <smalloc+0xe1>
				start = s;
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802bee:	eb 0e                	jmp    802bfe <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  802bf0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802bf7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c04:	74 12                	je     802c18 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802c06:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802c0d:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802c14:	76 af                	jbe    802bc5 <smalloc+0xa8>
  802c16:	eb 01                	jmp    802c19 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  802c18:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  802c19:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c1d:	74 08                	je     802c27 <smalloc+0x10a>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802c25:	74 0a                	je     802c31 <smalloc+0x114>
		return NULL;
  802c27:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2c:	e9 85 00 00 00       	jmp    802cb6 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c34:	2b 45 d8             	sub    -0x28(%ebp),%eax
  802c37:	c1 e8 0c             	shr    $0xc,%eax
  802c3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  802c3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802c40:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c43:	89 14 85 40 70 80 00 	mov    %edx,0x807040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  802c4a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c4d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802c50:	eb 11                	jmp    802c63 <smalloc+0x146>
		markedPages[s] = 1;
  802c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c55:	c7 04 85 40 70 90 00 	movl   $0x1,0x907040(,%eax,4)
  802c5c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  802c60:	ff 45 e8             	incl   -0x18(%ebp)
  802c63:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802c66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c69:	01 d0                	add    %edx,%eax
  802c6b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c6e:	77 e2                	ja     802c52 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  802c70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c73:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  802c77:	52                   	push   %edx
  802c78:	50                   	push   %eax
  802c79:	ff 75 0c             	pushl  0xc(%ebp)
  802c7c:	ff 75 08             	pushl  0x8(%ebp)
  802c7f:	e8 8f 04 00 00       	call   803113 <sys_createSharedObject>
  802c84:	83 c4 10             	add    $0x10,%esp
  802c87:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  802c8a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  802c8e:	78 12                	js     802ca2 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  802c90:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802c93:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802c96:	89 14 85 40 70 88 00 	mov    %edx,0x887040(,%eax,4)
		return (void*) start;
  802c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca0:	eb 14                	jmp    802cb6 <smalloc+0x199>
	}
	free((void*) start);
  802ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca5:	83 ec 0c             	sub    $0xc,%esp
  802ca8:	50                   	push   %eax
  802ca9:	e8 6e fd ff ff       	call   802a1c <free>
  802cae:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb6:	c9                   	leave  
  802cb7:	c3                   	ret    

00802cb8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802cb8:	55                   	push   %ebp
  802cb9:	89 e5                	mov    %esp,%ebp
  802cbb:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  802cbe:	83 ec 08             	sub    $0x8,%esp
  802cc1:	ff 75 0c             	pushl  0xc(%ebp)
  802cc4:	ff 75 08             	pushl  0x8(%ebp)
  802cc7:	e8 71 04 00 00       	call   80313d <sys_getSizeOfSharedObject>
  802ccc:	83 c4 10             	add    $0x10,%esp
  802ccf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802cd2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802cd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cdf:	01 d0                	add    %edx,%eax
  802ce1:	48                   	dec    %eax
  802ce2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802ce5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ce8:	ba 00 00 00 00       	mov    $0x0,%edx
  802ced:	f7 75 e0             	divl   -0x20(%ebp)
  802cf0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cf3:	29 d0                	sub    %edx,%eax
  802cf5:	c1 e8 0c             	shr    $0xc,%eax
  802cf8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  802cfb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802d02:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  802d09:	a1 20 70 80 00       	mov    0x807020,%eax
  802d0e:	8b 40 7c             	mov    0x7c(%eax),%eax
  802d11:	05 00 10 00 00       	add    $0x1000,%eax
  802d16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  802d19:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802d1e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802d21:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802d24:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  802d2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d31:	01 d0                	add    %edx,%eax
  802d33:	48                   	dec    %eax
  802d34:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802d37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d3a:	ba 00 00 00 00       	mov    $0x0,%edx
  802d3f:	f7 75 cc             	divl   -0x34(%ebp)
  802d42:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d45:	29 d0                	sub    %edx,%eax
  802d47:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802d4a:	76 0a                	jbe    802d56 <sget+0x9e>
		return NULL;
  802d4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802d51:	e9 f7 00 00 00       	jmp    802e4d <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802d56:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802d59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d5c:	eb 48                	jmp    802da6 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802d64:	c1 e8 0c             	shr    $0xc,%eax
  802d67:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  802d6a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d6d:	8b 04 85 40 70 90 00 	mov    0x907040(,%eax,4),%eax
  802d74:	85 c0                	test   %eax,%eax
  802d76:	75 11                	jne    802d89 <sget+0xd1>
			free_Pages_Count++;
  802d78:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802d7b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802d7f:	75 16                	jne    802d97 <sget+0xdf>
				start = s;
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d87:	eb 0e                	jmp    802d97 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802d90:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802d9d:	74 12                	je     802db1 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802d9f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802da6:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802dad:	76 af                	jbe    802d5e <sget+0xa6>
  802daf:	eb 01                	jmp    802db2 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802db1:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802db2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802db6:	74 08                	je     802dc0 <sget+0x108>
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802dbe:	74 0a                	je     802dca <sget+0x112>
		return NULL;
  802dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dc5:	e9 83 00 00 00       	jmp    802e4d <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802dd0:	c1 e8 0c             	shr    $0xc,%eax
  802dd3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802dd6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802dd9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802ddc:	89 14 85 40 70 80 00 	mov    %edx,0x807040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802de3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802de6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802de9:	eb 11                	jmp    802dfc <sget+0x144>
		markedPages[k] = 1;
  802deb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dee:	c7 04 85 40 70 90 00 	movl   $0x1,0x907040(,%eax,4)
  802df5:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802df9:	ff 45 e8             	incl   -0x18(%ebp)
  802dfc:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802dff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e02:	01 d0                	add    %edx,%eax
  802e04:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e07:	77 e2                	ja     802deb <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	50                   	push   %eax
  802e10:	ff 75 0c             	pushl  0xc(%ebp)
  802e13:	ff 75 08             	pushl  0x8(%ebp)
  802e16:	e8 3f 03 00 00       	call   80315a <sys_getSharedObject>
  802e1b:	83 c4 10             	add    $0x10,%esp
  802e1e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802e21:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802e25:	78 12                	js     802e39 <sget+0x181>
		shardIDs[startPage] = ss;
  802e27:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802e2a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802e2d:	89 14 85 40 70 88 00 	mov    %edx,0x887040(,%eax,4)
		return (void*) start;
  802e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e37:	eb 14                	jmp    802e4d <sget+0x195>
	}
	free((void*) start);
  802e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3c:	83 ec 0c             	sub    $0xc,%esp
  802e3f:	50                   	push   %eax
  802e40:	e8 d7 fb ff ff       	call   802a1c <free>
  802e45:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802e48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e4d:	c9                   	leave  
  802e4e:	c3                   	ret    

00802e4f <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  802e4f:	55                   	push   %ebp
  802e50:	89 e5                	mov    %esp,%ebp
  802e52:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802e55:	8b 55 08             	mov    0x8(%ebp),%edx
  802e58:	a1 20 70 80 00       	mov    0x807020,%eax
  802e5d:	8b 40 7c             	mov    0x7c(%eax),%eax
  802e60:	29 c2                	sub    %eax,%edx
  802e62:	89 d0                	mov    %edx,%eax
  802e64:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  802e69:	c1 e8 0c             	shr    $0xc,%eax
  802e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 04 85 40 70 88 00 	mov    0x887040(,%eax,4),%eax
  802e79:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802e7c:	83 ec 08             	sub    $0x8,%esp
  802e7f:	ff 75 08             	pushl  0x8(%ebp)
  802e82:	ff 75 f0             	pushl  -0x10(%ebp)
  802e85:	e8 ef 02 00 00       	call   803179 <sys_freeSharedObject>
  802e8a:	83 c4 10             	add    $0x10,%esp
  802e8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  802e90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e94:	75 0e                	jne    802ea4 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	c7 04 85 40 70 88 00 	movl   $0xffffffff,0x887040(,%eax,4)
  802ea0:	ff ff ff ff 
	}

}
  802ea4:	90                   	nop
  802ea5:	c9                   	leave  
  802ea6:	c3                   	ret    

00802ea7 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802ea7:	55                   	push   %ebp
  802ea8:	89 e5                	mov    %esp,%ebp
  802eaa:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802ead:	83 ec 04             	sub    $0x4,%esp
  802eb0:	68 00 63 80 00       	push   $0x806300
  802eb5:	68 19 01 00 00       	push   $0x119
  802eba:	68 f2 62 80 00       	push   $0x8062f2
  802ebf:	e8 35 e9 ff ff       	call   8017f9 <_panic>

00802ec4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802ec4:	55                   	push   %ebp
  802ec5:	89 e5                	mov    %esp,%ebp
  802ec7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 26 63 80 00       	push   $0x806326
  802ed2:	68 23 01 00 00       	push   $0x123
  802ed7:	68 f2 62 80 00       	push   $0x8062f2
  802edc:	e8 18 e9 ff ff       	call   8017f9 <_panic>

00802ee1 <shrink>:

}
void shrink(uint32 newSize) {
  802ee1:	55                   	push   %ebp
  802ee2:	89 e5                	mov    %esp,%ebp
  802ee4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 26 63 80 00       	push   $0x806326
  802eef:	68 27 01 00 00       	push   $0x127
  802ef4:	68 f2 62 80 00       	push   $0x8062f2
  802ef9:	e8 fb e8 ff ff       	call   8017f9 <_panic>

00802efe <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802efe:	55                   	push   %ebp
  802eff:	89 e5                	mov    %esp,%ebp
  802f01:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802f04:	83 ec 04             	sub    $0x4,%esp
  802f07:	68 26 63 80 00       	push   $0x806326
  802f0c:	68 2b 01 00 00       	push   $0x12b
  802f11:	68 f2 62 80 00       	push   $0x8062f2
  802f16:	e8 de e8 ff ff       	call   8017f9 <_panic>

00802f1b <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  802f1b:	55                   	push   %ebp
  802f1c:	89 e5                	mov    %esp,%ebp
  802f1e:	57                   	push   %edi
  802f1f:	56                   	push   %esi
  802f20:	53                   	push   %ebx
  802f21:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  802f2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802f2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802f30:	8b 7d 18             	mov    0x18(%ebp),%edi
  802f33:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802f36:	cd 30                	int    $0x30
  802f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  802f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802f3e:	83 c4 10             	add    $0x10,%esp
  802f41:	5b                   	pop    %ebx
  802f42:	5e                   	pop    %esi
  802f43:	5f                   	pop    %edi
  802f44:	5d                   	pop    %ebp
  802f45:	c3                   	ret    

00802f46 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  802f46:	55                   	push   %ebp
  802f47:	89 e5                	mov    %esp,%ebp
  802f49:	83 ec 04             	sub    $0x4,%esp
  802f4c:	8b 45 10             	mov    0x10(%ebp),%eax
  802f4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  802f52:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	52                   	push   %edx
  802f5e:	ff 75 0c             	pushl  0xc(%ebp)
  802f61:	50                   	push   %eax
  802f62:	6a 00                	push   $0x0
  802f64:	e8 b2 ff ff ff       	call   802f1b <syscall>
  802f69:	83 c4 18             	add    $0x18,%esp
}
  802f6c:	90                   	nop
  802f6d:	c9                   	leave  
  802f6e:	c3                   	ret    

00802f6f <sys_cgetc>:

int sys_cgetc(void) {
  802f6f:	55                   	push   %ebp
  802f70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802f72:	6a 00                	push   $0x0
  802f74:	6a 00                	push   $0x0
  802f76:	6a 00                	push   $0x0
  802f78:	6a 00                	push   $0x0
  802f7a:	6a 00                	push   $0x0
  802f7c:	6a 02                	push   $0x2
  802f7e:	e8 98 ff ff ff       	call   802f1b <syscall>
  802f83:	83 c4 18             	add    $0x18,%esp
}
  802f86:	c9                   	leave  
  802f87:	c3                   	ret    

00802f88 <sys_lock_cons>:

void sys_lock_cons(void) {
  802f88:	55                   	push   %ebp
  802f89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  802f8b:	6a 00                	push   $0x0
  802f8d:	6a 00                	push   $0x0
  802f8f:	6a 00                	push   $0x0
  802f91:	6a 00                	push   $0x0
  802f93:	6a 00                	push   $0x0
  802f95:	6a 03                	push   $0x3
  802f97:	e8 7f ff ff ff       	call   802f1b <syscall>
  802f9c:	83 c4 18             	add    $0x18,%esp
}
  802f9f:	90                   	nop
  802fa0:	c9                   	leave  
  802fa1:	c3                   	ret    

00802fa2 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  802fa2:	55                   	push   %ebp
  802fa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  802fa5:	6a 00                	push   $0x0
  802fa7:	6a 00                	push   $0x0
  802fa9:	6a 00                	push   $0x0
  802fab:	6a 00                	push   $0x0
  802fad:	6a 00                	push   $0x0
  802faf:	6a 04                	push   $0x4
  802fb1:	e8 65 ff ff ff       	call   802f1b <syscall>
  802fb6:	83 c4 18             	add    $0x18,%esp
}
  802fb9:	90                   	nop
  802fba:	c9                   	leave  
  802fbb:	c3                   	ret    

00802fbc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  802fbc:	55                   	push   %ebp
  802fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  802fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	6a 00                	push   $0x0
  802fc7:	6a 00                	push   $0x0
  802fc9:	6a 00                	push   $0x0
  802fcb:	52                   	push   %edx
  802fcc:	50                   	push   %eax
  802fcd:	6a 08                	push   $0x8
  802fcf:	e8 47 ff ff ff       	call   802f1b <syscall>
  802fd4:	83 c4 18             	add    $0x18,%esp
}
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
  802fdc:	56                   	push   %esi
  802fdd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  802fde:	8b 75 18             	mov    0x18(%ebp),%esi
  802fe1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802fe4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	56                   	push   %esi
  802fee:	53                   	push   %ebx
  802fef:	51                   	push   %ecx
  802ff0:	52                   	push   %edx
  802ff1:	50                   	push   %eax
  802ff2:	6a 09                	push   $0x9
  802ff4:	e8 22 ff ff ff       	call   802f1b <syscall>
  802ff9:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  802ffc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fff:	5b                   	pop    %ebx
  803000:	5e                   	pop    %esi
  803001:	5d                   	pop    %ebp
  803002:	c3                   	ret    

00803003 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  803003:	55                   	push   %ebp
  803004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  803006:	8b 55 0c             	mov    0xc(%ebp),%edx
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	6a 00                	push   $0x0
  80300e:	6a 00                	push   $0x0
  803010:	6a 00                	push   $0x0
  803012:	52                   	push   %edx
  803013:	50                   	push   %eax
  803014:	6a 0a                	push   $0xa
  803016:	e8 00 ff ff ff       	call   802f1b <syscall>
  80301b:	83 c4 18             	add    $0x18,%esp
}
  80301e:	c9                   	leave  
  80301f:	c3                   	ret    

00803020 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  803020:	55                   	push   %ebp
  803021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  803023:	6a 00                	push   $0x0
  803025:	6a 00                	push   $0x0
  803027:	6a 00                	push   $0x0
  803029:	ff 75 0c             	pushl  0xc(%ebp)
  80302c:	ff 75 08             	pushl  0x8(%ebp)
  80302f:	6a 0b                	push   $0xb
  803031:	e8 e5 fe ff ff       	call   802f1b <syscall>
  803036:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  803039:	c9                   	leave  
  80303a:	c3                   	ret    

0080303b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80303b:	55                   	push   %ebp
  80303c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80303e:	6a 00                	push   $0x0
  803040:	6a 00                	push   $0x0
  803042:	6a 00                	push   $0x0
  803044:	6a 00                	push   $0x0
  803046:	6a 00                	push   $0x0
  803048:	6a 0c                	push   $0xc
  80304a:	e8 cc fe ff ff       	call   802f1b <syscall>
  80304f:	83 c4 18             	add    $0x18,%esp
}
  803052:	c9                   	leave  
  803053:	c3                   	ret    

00803054 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  803054:	55                   	push   %ebp
  803055:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  803057:	6a 00                	push   $0x0
  803059:	6a 00                	push   $0x0
  80305b:	6a 00                	push   $0x0
  80305d:	6a 00                	push   $0x0
  80305f:	6a 00                	push   $0x0
  803061:	6a 0d                	push   $0xd
  803063:	e8 b3 fe ff ff       	call   802f1b <syscall>
  803068:	83 c4 18             	add    $0x18,%esp
}
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  803070:	6a 00                	push   $0x0
  803072:	6a 00                	push   $0x0
  803074:	6a 00                	push   $0x0
  803076:	6a 00                	push   $0x0
  803078:	6a 00                	push   $0x0
  80307a:	6a 0e                	push   $0xe
  80307c:	e8 9a fe ff ff       	call   802f1b <syscall>
  803081:	83 c4 18             	add    $0x18,%esp
}
  803084:	c9                   	leave  
  803085:	c3                   	ret    

00803086 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  803086:	55                   	push   %ebp
  803087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  803089:	6a 00                	push   $0x0
  80308b:	6a 00                	push   $0x0
  80308d:	6a 00                	push   $0x0
  80308f:	6a 00                	push   $0x0
  803091:	6a 00                	push   $0x0
  803093:	6a 0f                	push   $0xf
  803095:	e8 81 fe ff ff       	call   802f1b <syscall>
  80309a:	83 c4 18             	add    $0x18,%esp
}
  80309d:	c9                   	leave  
  80309e:	c3                   	ret    

0080309f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80309f:	55                   	push   %ebp
  8030a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8030a2:	6a 00                	push   $0x0
  8030a4:	6a 00                	push   $0x0
  8030a6:	6a 00                	push   $0x0
  8030a8:	6a 00                	push   $0x0
  8030aa:	ff 75 08             	pushl  0x8(%ebp)
  8030ad:	6a 10                	push   $0x10
  8030af:	e8 67 fe ff ff       	call   802f1b <syscall>
  8030b4:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8030b7:	c9                   	leave  
  8030b8:	c3                   	ret    

008030b9 <sys_scarce_memory>:

void sys_scarce_memory() {
  8030b9:	55                   	push   %ebp
  8030ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8030bc:	6a 00                	push   $0x0
  8030be:	6a 00                	push   $0x0
  8030c0:	6a 00                	push   $0x0
  8030c2:	6a 00                	push   $0x0
  8030c4:	6a 00                	push   $0x0
  8030c6:	6a 11                	push   $0x11
  8030c8:	e8 4e fe ff ff       	call   802f1b <syscall>
  8030cd:	83 c4 18             	add    $0x18,%esp
}
  8030d0:	90                   	nop
  8030d1:	c9                   	leave  
  8030d2:	c3                   	ret    

008030d3 <sys_cputc>:

void sys_cputc(const char c) {
  8030d3:	55                   	push   %ebp
  8030d4:	89 e5                	mov    %esp,%ebp
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8030df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8030e3:	6a 00                	push   $0x0
  8030e5:	6a 00                	push   $0x0
  8030e7:	6a 00                	push   $0x0
  8030e9:	6a 00                	push   $0x0
  8030eb:	50                   	push   %eax
  8030ec:	6a 01                	push   $0x1
  8030ee:	e8 28 fe ff ff       	call   802f1b <syscall>
  8030f3:	83 c4 18             	add    $0x18,%esp
}
  8030f6:	90                   	nop
  8030f7:	c9                   	leave  
  8030f8:	c3                   	ret    

008030f9 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8030f9:	55                   	push   %ebp
  8030fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8030fc:	6a 00                	push   $0x0
  8030fe:	6a 00                	push   $0x0
  803100:	6a 00                	push   $0x0
  803102:	6a 00                	push   $0x0
  803104:	6a 00                	push   $0x0
  803106:	6a 14                	push   $0x14
  803108:	e8 0e fe ff ff       	call   802f1b <syscall>
  80310d:	83 c4 18             	add    $0x18,%esp
}
  803110:	90                   	nop
  803111:	c9                   	leave  
  803112:	c3                   	ret    

00803113 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  803113:	55                   	push   %ebp
  803114:	89 e5                	mov    %esp,%ebp
  803116:	83 ec 04             	sub    $0x4,%esp
  803119:	8b 45 10             	mov    0x10(%ebp),%eax
  80311c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80311f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  803122:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	6a 00                	push   $0x0
  80312b:	51                   	push   %ecx
  80312c:	52                   	push   %edx
  80312d:	ff 75 0c             	pushl  0xc(%ebp)
  803130:	50                   	push   %eax
  803131:	6a 15                	push   $0x15
  803133:	e8 e3 fd ff ff       	call   802f1b <syscall>
  803138:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  80313b:	c9                   	leave  
  80313c:	c3                   	ret    

0080313d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80313d:	55                   	push   %ebp
  80313e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  803140:	8b 55 0c             	mov    0xc(%ebp),%edx
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	6a 00                	push   $0x0
  803148:	6a 00                	push   $0x0
  80314a:	6a 00                	push   $0x0
  80314c:	52                   	push   %edx
  80314d:	50                   	push   %eax
  80314e:	6a 16                	push   $0x16
  803150:	e8 c6 fd ff ff       	call   802f1b <syscall>
  803155:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  803158:	c9                   	leave  
  803159:	c3                   	ret    

0080315a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80315a:	55                   	push   %ebp
  80315b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80315d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803160:	8b 55 0c             	mov    0xc(%ebp),%edx
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	6a 00                	push   $0x0
  803168:	6a 00                	push   $0x0
  80316a:	51                   	push   %ecx
  80316b:	52                   	push   %edx
  80316c:	50                   	push   %eax
  80316d:	6a 17                	push   $0x17
  80316f:	e8 a7 fd ff ff       	call   802f1b <syscall>
  803174:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  803177:	c9                   	leave  
  803178:	c3                   	ret    

00803179 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  803179:	55                   	push   %ebp
  80317a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80317c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	6a 00                	push   $0x0
  803184:	6a 00                	push   $0x0
  803186:	6a 00                	push   $0x0
  803188:	52                   	push   %edx
  803189:	50                   	push   %eax
  80318a:	6a 18                	push   $0x18
  80318c:	e8 8a fd ff ff       	call   802f1b <syscall>
  803191:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  803194:	c9                   	leave  
  803195:	c3                   	ret    

00803196 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  803196:	55                   	push   %ebp
  803197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	6a 00                	push   $0x0
  80319e:	ff 75 14             	pushl  0x14(%ebp)
  8031a1:	ff 75 10             	pushl  0x10(%ebp)
  8031a4:	ff 75 0c             	pushl  0xc(%ebp)
  8031a7:	50                   	push   %eax
  8031a8:	6a 19                	push   $0x19
  8031aa:	e8 6c fd ff ff       	call   802f1b <syscall>
  8031af:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <sys_run_env>:

void sys_run_env(int32 envId) {
  8031b4:	55                   	push   %ebp
  8031b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	6a 00                	push   $0x0
  8031bc:	6a 00                	push   $0x0
  8031be:	6a 00                	push   $0x0
  8031c0:	6a 00                	push   $0x0
  8031c2:	50                   	push   %eax
  8031c3:	6a 1a                	push   $0x1a
  8031c5:	e8 51 fd ff ff       	call   802f1b <syscall>
  8031ca:	83 c4 18             	add    $0x18,%esp
}
  8031cd:	90                   	nop
  8031ce:	c9                   	leave  
  8031cf:	c3                   	ret    

008031d0 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8031d0:	55                   	push   %ebp
  8031d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8031d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d6:	6a 00                	push   $0x0
  8031d8:	6a 00                	push   $0x0
  8031da:	6a 00                	push   $0x0
  8031dc:	6a 00                	push   $0x0
  8031de:	50                   	push   %eax
  8031df:	6a 1b                	push   $0x1b
  8031e1:	e8 35 fd ff ff       	call   802f1b <syscall>
  8031e6:	83 c4 18             	add    $0x18,%esp
}
  8031e9:	c9                   	leave  
  8031ea:	c3                   	ret    

008031eb <sys_getenvid>:

int32 sys_getenvid(void) {
  8031eb:	55                   	push   %ebp
  8031ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8031ee:	6a 00                	push   $0x0
  8031f0:	6a 00                	push   $0x0
  8031f2:	6a 00                	push   $0x0
  8031f4:	6a 00                	push   $0x0
  8031f6:	6a 00                	push   $0x0
  8031f8:	6a 05                	push   $0x5
  8031fa:	e8 1c fd ff ff       	call   802f1b <syscall>
  8031ff:	83 c4 18             	add    $0x18,%esp
}
  803202:	c9                   	leave  
  803203:	c3                   	ret    

00803204 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  803204:	55                   	push   %ebp
  803205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  803207:	6a 00                	push   $0x0
  803209:	6a 00                	push   $0x0
  80320b:	6a 00                	push   $0x0
  80320d:	6a 00                	push   $0x0
  80320f:	6a 00                	push   $0x0
  803211:	6a 06                	push   $0x6
  803213:	e8 03 fd ff ff       	call   802f1b <syscall>
  803218:	83 c4 18             	add    $0x18,%esp
}
  80321b:	c9                   	leave  
  80321c:	c3                   	ret    

0080321d <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80321d:	55                   	push   %ebp
  80321e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  803220:	6a 00                	push   $0x0
  803222:	6a 00                	push   $0x0
  803224:	6a 00                	push   $0x0
  803226:	6a 00                	push   $0x0
  803228:	6a 00                	push   $0x0
  80322a:	6a 07                	push   $0x7
  80322c:	e8 ea fc ff ff       	call   802f1b <syscall>
  803231:	83 c4 18             	add    $0x18,%esp
}
  803234:	c9                   	leave  
  803235:	c3                   	ret    

00803236 <sys_exit_env>:

void sys_exit_env(void) {
  803236:	55                   	push   %ebp
  803237:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  803239:	6a 00                	push   $0x0
  80323b:	6a 00                	push   $0x0
  80323d:	6a 00                	push   $0x0
  80323f:	6a 00                	push   $0x0
  803241:	6a 00                	push   $0x0
  803243:	6a 1c                	push   $0x1c
  803245:	e8 d1 fc ff ff       	call   802f1b <syscall>
  80324a:	83 c4 18             	add    $0x18,%esp
}
  80324d:	90                   	nop
  80324e:	c9                   	leave  
  80324f:	c3                   	ret    

00803250 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  803250:	55                   	push   %ebp
  803251:	89 e5                	mov    %esp,%ebp
  803253:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  803256:	8d 45 f8             	lea    -0x8(%ebp),%eax
  803259:	8d 50 04             	lea    0x4(%eax),%edx
  80325c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80325f:	6a 00                	push   $0x0
  803261:	6a 00                	push   $0x0
  803263:	6a 00                	push   $0x0
  803265:	52                   	push   %edx
  803266:	50                   	push   %eax
  803267:	6a 1d                	push   $0x1d
  803269:	e8 ad fc ff ff       	call   802f1b <syscall>
  80326e:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  803271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803274:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803277:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80327a:	89 01                	mov    %eax,(%ecx)
  80327c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	c9                   	leave  
  803283:	c2 04 00             	ret    $0x4

00803286 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  803286:	55                   	push   %ebp
  803287:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  803289:	6a 00                	push   $0x0
  80328b:	6a 00                	push   $0x0
  80328d:	ff 75 10             	pushl  0x10(%ebp)
  803290:	ff 75 0c             	pushl  0xc(%ebp)
  803293:	ff 75 08             	pushl  0x8(%ebp)
  803296:	6a 13                	push   $0x13
  803298:	e8 7e fc ff ff       	call   802f1b <syscall>
  80329d:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8032a0:	90                   	nop
}
  8032a1:	c9                   	leave  
  8032a2:	c3                   	ret    

008032a3 <sys_rcr2>:
uint32 sys_rcr2() {
  8032a3:	55                   	push   %ebp
  8032a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8032a6:	6a 00                	push   $0x0
  8032a8:	6a 00                	push   $0x0
  8032aa:	6a 00                	push   $0x0
  8032ac:	6a 00                	push   $0x0
  8032ae:	6a 00                	push   $0x0
  8032b0:	6a 1e                	push   $0x1e
  8032b2:	e8 64 fc ff ff       	call   802f1b <syscall>
  8032b7:	83 c4 18             	add    $0x18,%esp
}
  8032ba:	c9                   	leave  
  8032bb:	c3                   	ret    

008032bc <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8032bc:	55                   	push   %ebp
  8032bd:	89 e5                	mov    %esp,%ebp
  8032bf:	83 ec 04             	sub    $0x4,%esp
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8032c8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8032cc:	6a 00                	push   $0x0
  8032ce:	6a 00                	push   $0x0
  8032d0:	6a 00                	push   $0x0
  8032d2:	6a 00                	push   $0x0
  8032d4:	50                   	push   %eax
  8032d5:	6a 1f                	push   $0x1f
  8032d7:	e8 3f fc ff ff       	call   802f1b <syscall>
  8032dc:	83 c4 18             	add    $0x18,%esp
	return;
  8032df:	90                   	nop
}
  8032e0:	c9                   	leave  
  8032e1:	c3                   	ret    

008032e2 <rsttst>:
void rsttst() {
  8032e2:	55                   	push   %ebp
  8032e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8032e5:	6a 00                	push   $0x0
  8032e7:	6a 00                	push   $0x0
  8032e9:	6a 00                	push   $0x0
  8032eb:	6a 00                	push   $0x0
  8032ed:	6a 00                	push   $0x0
  8032ef:	6a 21                	push   $0x21
  8032f1:	e8 25 fc ff ff       	call   802f1b <syscall>
  8032f6:	83 c4 18             	add    $0x18,%esp
	return;
  8032f9:	90                   	nop
}
  8032fa:	c9                   	leave  
  8032fb:	c3                   	ret    

008032fc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8032fc:	55                   	push   %ebp
  8032fd:	89 e5                	mov    %esp,%ebp
  8032ff:	83 ec 04             	sub    $0x4,%esp
  803302:	8b 45 14             	mov    0x14(%ebp),%eax
  803305:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803308:	8b 55 18             	mov    0x18(%ebp),%edx
  80330b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80330f:	52                   	push   %edx
  803310:	50                   	push   %eax
  803311:	ff 75 10             	pushl  0x10(%ebp)
  803314:	ff 75 0c             	pushl  0xc(%ebp)
  803317:	ff 75 08             	pushl  0x8(%ebp)
  80331a:	6a 20                	push   $0x20
  80331c:	e8 fa fb ff ff       	call   802f1b <syscall>
  803321:	83 c4 18             	add    $0x18,%esp
	return;
  803324:	90                   	nop
}
  803325:	c9                   	leave  
  803326:	c3                   	ret    

00803327 <chktst>:
void chktst(uint32 n) {
  803327:	55                   	push   %ebp
  803328:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80332a:	6a 00                	push   $0x0
  80332c:	6a 00                	push   $0x0
  80332e:	6a 00                	push   $0x0
  803330:	6a 00                	push   $0x0
  803332:	ff 75 08             	pushl  0x8(%ebp)
  803335:	6a 22                	push   $0x22
  803337:	e8 df fb ff ff       	call   802f1b <syscall>
  80333c:	83 c4 18             	add    $0x18,%esp
	return;
  80333f:	90                   	nop
}
  803340:	c9                   	leave  
  803341:	c3                   	ret    

00803342 <inctst>:

void inctst() {
  803342:	55                   	push   %ebp
  803343:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  803345:	6a 00                	push   $0x0
  803347:	6a 00                	push   $0x0
  803349:	6a 00                	push   $0x0
  80334b:	6a 00                	push   $0x0
  80334d:	6a 00                	push   $0x0
  80334f:	6a 23                	push   $0x23
  803351:	e8 c5 fb ff ff       	call   802f1b <syscall>
  803356:	83 c4 18             	add    $0x18,%esp
	return;
  803359:	90                   	nop
}
  80335a:	c9                   	leave  
  80335b:	c3                   	ret    

0080335c <gettst>:
uint32 gettst() {
  80335c:	55                   	push   %ebp
  80335d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80335f:	6a 00                	push   $0x0
  803361:	6a 00                	push   $0x0
  803363:	6a 00                	push   $0x0
  803365:	6a 00                	push   $0x0
  803367:	6a 00                	push   $0x0
  803369:	6a 24                	push   $0x24
  80336b:	e8 ab fb ff ff       	call   802f1b <syscall>
  803370:	83 c4 18             	add    $0x18,%esp
}
  803373:	c9                   	leave  
  803374:	c3                   	ret    

00803375 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  803375:	55                   	push   %ebp
  803376:	89 e5                	mov    %esp,%ebp
  803378:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80337b:	6a 00                	push   $0x0
  80337d:	6a 00                	push   $0x0
  80337f:	6a 00                	push   $0x0
  803381:	6a 00                	push   $0x0
  803383:	6a 00                	push   $0x0
  803385:	6a 25                	push   $0x25
  803387:	e8 8f fb ff ff       	call   802f1b <syscall>
  80338c:	83 c4 18             	add    $0x18,%esp
  80338f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  803392:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  803396:	75 07                	jne    80339f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  803398:	b8 01 00 00 00       	mov    $0x1,%eax
  80339d:	eb 05                	jmp    8033a4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80339f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033a4:	c9                   	leave  
  8033a5:	c3                   	ret    

008033a6 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8033a6:	55                   	push   %ebp
  8033a7:	89 e5                	mov    %esp,%ebp
  8033a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033ac:	6a 00                	push   $0x0
  8033ae:	6a 00                	push   $0x0
  8033b0:	6a 00                	push   $0x0
  8033b2:	6a 00                	push   $0x0
  8033b4:	6a 00                	push   $0x0
  8033b6:	6a 25                	push   $0x25
  8033b8:	e8 5e fb ff ff       	call   802f1b <syscall>
  8033bd:	83 c4 18             	add    $0x18,%esp
  8033c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8033c3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8033c7:	75 07                	jne    8033d0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8033c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ce:	eb 05                	jmp    8033d5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8033d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033d5:	c9                   	leave  
  8033d6:	c3                   	ret    

008033d7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8033d7:	55                   	push   %ebp
  8033d8:	89 e5                	mov    %esp,%ebp
  8033da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8033dd:	6a 00                	push   $0x0
  8033df:	6a 00                	push   $0x0
  8033e1:	6a 00                	push   $0x0
  8033e3:	6a 00                	push   $0x0
  8033e5:	6a 00                	push   $0x0
  8033e7:	6a 25                	push   $0x25
  8033e9:	e8 2d fb ff ff       	call   802f1b <syscall>
  8033ee:	83 c4 18             	add    $0x18,%esp
  8033f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8033f4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8033f8:	75 07                	jne    803401 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8033fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ff:	eb 05                	jmp    803406 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  803401:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803406:	c9                   	leave  
  803407:	c3                   	ret    

00803408 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  803408:	55                   	push   %ebp
  803409:	89 e5                	mov    %esp,%ebp
  80340b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80340e:	6a 00                	push   $0x0
  803410:	6a 00                	push   $0x0
  803412:	6a 00                	push   $0x0
  803414:	6a 00                	push   $0x0
  803416:	6a 00                	push   $0x0
  803418:	6a 25                	push   $0x25
  80341a:	e8 fc fa ff ff       	call   802f1b <syscall>
  80341f:	83 c4 18             	add    $0x18,%esp
  803422:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803425:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803429:	75 07                	jne    803432 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80342b:	b8 01 00 00 00       	mov    $0x1,%eax
  803430:	eb 05                	jmp    803437 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803432:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803437:	c9                   	leave  
  803438:	c3                   	ret    

00803439 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  803439:	55                   	push   %ebp
  80343a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80343c:	6a 00                	push   $0x0
  80343e:	6a 00                	push   $0x0
  803440:	6a 00                	push   $0x0
  803442:	6a 00                	push   $0x0
  803444:	ff 75 08             	pushl  0x8(%ebp)
  803447:	6a 26                	push   $0x26
  803449:	e8 cd fa ff ff       	call   802f1b <syscall>
  80344e:	83 c4 18             	add    $0x18,%esp
	return;
  803451:	90                   	nop
}
  803452:	c9                   	leave  
  803453:	c3                   	ret    

00803454 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  803454:	55                   	push   %ebp
  803455:	89 e5                	mov    %esp,%ebp
  803457:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  803458:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80345b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80345e:	8b 55 0c             	mov    0xc(%ebp),%edx
  803461:	8b 45 08             	mov    0x8(%ebp),%eax
  803464:	6a 00                	push   $0x0
  803466:	53                   	push   %ebx
  803467:	51                   	push   %ecx
  803468:	52                   	push   %edx
  803469:	50                   	push   %eax
  80346a:	6a 27                	push   $0x27
  80346c:	e8 aa fa ff ff       	call   802f1b <syscall>
  803471:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  803474:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  803477:	c9                   	leave  
  803478:	c3                   	ret    

00803479 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  803479:	55                   	push   %ebp
  80347a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80347c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	6a 00                	push   $0x0
  803484:	6a 00                	push   $0x0
  803486:	6a 00                	push   $0x0
  803488:	52                   	push   %edx
  803489:	50                   	push   %eax
  80348a:	6a 28                	push   $0x28
  80348c:	e8 8a fa ff ff       	call   802f1b <syscall>
  803491:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  803494:	c9                   	leave  
  803495:	c3                   	ret    

00803496 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  803496:	55                   	push   %ebp
  803497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  803499:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80349c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	6a 00                	push   $0x0
  8034a4:	51                   	push   %ecx
  8034a5:	ff 75 10             	pushl  0x10(%ebp)
  8034a8:	52                   	push   %edx
  8034a9:	50                   	push   %eax
  8034aa:	6a 29                	push   $0x29
  8034ac:	e8 6a fa ff ff       	call   802f1b <syscall>
  8034b1:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8034b4:	c9                   	leave  
  8034b5:	c3                   	ret    

008034b6 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8034b6:	55                   	push   %ebp
  8034b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8034b9:	6a 00                	push   $0x0
  8034bb:	6a 00                	push   $0x0
  8034bd:	ff 75 10             	pushl  0x10(%ebp)
  8034c0:	ff 75 0c             	pushl  0xc(%ebp)
  8034c3:	ff 75 08             	pushl  0x8(%ebp)
  8034c6:	6a 12                	push   $0x12
  8034c8:	e8 4e fa ff ff       	call   802f1b <syscall>
  8034cd:	83 c4 18             	add    $0x18,%esp
	return;
  8034d0:	90                   	nop
}
  8034d1:	c9                   	leave  
  8034d2:	c3                   	ret    

008034d3 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8034d3:	55                   	push   %ebp
  8034d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8034d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	6a 00                	push   $0x0
  8034de:	6a 00                	push   $0x0
  8034e0:	6a 00                	push   $0x0
  8034e2:	52                   	push   %edx
  8034e3:	50                   	push   %eax
  8034e4:	6a 2a                	push   $0x2a
  8034e6:	e8 30 fa ff ff       	call   802f1b <syscall>
  8034eb:	83 c4 18             	add    $0x18,%esp
	return;
  8034ee:	90                   	nop
}
  8034ef:	c9                   	leave  
  8034f0:	c3                   	ret    

008034f1 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8034f1:	55                   	push   %ebp
  8034f2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	6a 00                	push   $0x0
  8034f9:	6a 00                	push   $0x0
  8034fb:	6a 00                	push   $0x0
  8034fd:	6a 00                	push   $0x0
  8034ff:	50                   	push   %eax
  803500:	6a 2b                	push   $0x2b
  803502:	e8 14 fa ff ff       	call   802f1b <syscall>
  803507:	83 c4 18             	add    $0x18,%esp
}
  80350a:	c9                   	leave  
  80350b:	c3                   	ret    

0080350c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80350c:	55                   	push   %ebp
  80350d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80350f:	6a 00                	push   $0x0
  803511:	6a 00                	push   $0x0
  803513:	6a 00                	push   $0x0
  803515:	ff 75 0c             	pushl  0xc(%ebp)
  803518:	ff 75 08             	pushl  0x8(%ebp)
  80351b:	6a 2c                	push   $0x2c
  80351d:	e8 f9 f9 ff ff       	call   802f1b <syscall>
  803522:	83 c4 18             	add    $0x18,%esp
	return;
  803525:	90                   	nop
}
  803526:	c9                   	leave  
  803527:	c3                   	ret    

00803528 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  803528:	55                   	push   %ebp
  803529:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80352b:	6a 00                	push   $0x0
  80352d:	6a 00                	push   $0x0
  80352f:	6a 00                	push   $0x0
  803531:	ff 75 0c             	pushl  0xc(%ebp)
  803534:	ff 75 08             	pushl  0x8(%ebp)
  803537:	6a 2d                	push   $0x2d
  803539:	e8 dd f9 ff ff       	call   802f1b <syscall>
  80353e:	83 c4 18             	add    $0x18,%esp
	return;
  803541:	90                   	nop
}
  803542:	c9                   	leave  
  803543:	c3                   	ret    

00803544 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  803544:	55                   	push   %ebp
  803545:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	6a 00                	push   $0x0
  80354c:	6a 00                	push   $0x0
  80354e:	6a 00                	push   $0x0
  803550:	6a 00                	push   $0x0
  803552:	50                   	push   %eax
  803553:	6a 2f                	push   $0x2f
  803555:	e8 c1 f9 ff ff       	call   802f1b <syscall>
  80355a:	83 c4 18             	add    $0x18,%esp
	return;
  80355d:	90                   	nop
}
  80355e:	c9                   	leave  
  80355f:	c3                   	ret    

00803560 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  803560:	55                   	push   %ebp
  803561:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  803563:	8b 55 0c             	mov    0xc(%ebp),%edx
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	6a 00                	push   $0x0
  80356b:	6a 00                	push   $0x0
  80356d:	6a 00                	push   $0x0
  80356f:	52                   	push   %edx
  803570:	50                   	push   %eax
  803571:	6a 30                	push   $0x30
  803573:	e8 a3 f9 ff ff       	call   802f1b <syscall>
  803578:	83 c4 18             	add    $0x18,%esp
	return;
  80357b:	90                   	nop
}
  80357c:	c9                   	leave  
  80357d:	c3                   	ret    

0080357e <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80357e:	55                   	push   %ebp
  80357f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  803581:	8b 45 08             	mov    0x8(%ebp),%eax
  803584:	6a 00                	push   $0x0
  803586:	6a 00                	push   $0x0
  803588:	6a 00                	push   $0x0
  80358a:	6a 00                	push   $0x0
  80358c:	50                   	push   %eax
  80358d:	6a 31                	push   $0x31
  80358f:	e8 87 f9 ff ff       	call   802f1b <syscall>
  803594:	83 c4 18             	add    $0x18,%esp
	return;
  803597:	90                   	nop
}
  803598:	c9                   	leave  
  803599:	c3                   	ret    

0080359a <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80359a:	55                   	push   %ebp
  80359b:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80359d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	6a 00                	push   $0x0
  8035a5:	6a 00                	push   $0x0
  8035a7:	6a 00                	push   $0x0
  8035a9:	52                   	push   %edx
  8035aa:	50                   	push   %eax
  8035ab:	6a 2e                	push   $0x2e
  8035ad:	e8 69 f9 ff ff       	call   802f1b <syscall>
  8035b2:	83 c4 18             	add    $0x18,%esp
    return;
  8035b5:	90                   	nop
}
  8035b6:	c9                   	leave  
  8035b7:	c3                   	ret    

008035b8 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8035b8:	55                   	push   %ebp
  8035b9:	89 e5                	mov    %esp,%ebp
  8035bb:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	83 e8 04             	sub    $0x4,%eax
  8035c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8035c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8035cf:	c9                   	leave  
  8035d0:	c3                   	ret    

008035d1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8035d1:	55                   	push   %ebp
  8035d2:	89 e5                	mov    %esp,%ebp
  8035d4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	83 e8 04             	sub    $0x4,%eax
  8035dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8035e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8035e3:	8b 00                	mov    (%eax),%eax
  8035e5:	83 e0 01             	and    $0x1,%eax
  8035e8:	85 c0                	test   %eax,%eax
  8035ea:	0f 94 c0             	sete   %al
}
  8035ed:	c9                   	leave  
  8035ee:	c3                   	ret    

008035ef <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8035ef:	55                   	push   %ebp
  8035f0:	89 e5                	mov    %esp,%ebp
  8035f2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8035f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8035fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035ff:	83 f8 02             	cmp    $0x2,%eax
  803602:	74 2b                	je     80362f <alloc_block+0x40>
  803604:	83 f8 02             	cmp    $0x2,%eax
  803607:	7f 07                	jg     803610 <alloc_block+0x21>
  803609:	83 f8 01             	cmp    $0x1,%eax
  80360c:	74 0e                	je     80361c <alloc_block+0x2d>
  80360e:	eb 58                	jmp    803668 <alloc_block+0x79>
  803610:	83 f8 03             	cmp    $0x3,%eax
  803613:	74 2d                	je     803642 <alloc_block+0x53>
  803615:	83 f8 04             	cmp    $0x4,%eax
  803618:	74 3b                	je     803655 <alloc_block+0x66>
  80361a:	eb 4c                	jmp    803668 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80361c:	83 ec 0c             	sub    $0xc,%esp
  80361f:	ff 75 08             	pushl  0x8(%ebp)
  803622:	e8 f7 03 00 00       	call   803a1e <alloc_block_FF>
  803627:	83 c4 10             	add    $0x10,%esp
  80362a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80362d:	eb 4a                	jmp    803679 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80362f:	83 ec 0c             	sub    $0xc,%esp
  803632:	ff 75 08             	pushl  0x8(%ebp)
  803635:	e8 f0 11 00 00       	call   80482a <alloc_block_NF>
  80363a:	83 c4 10             	add    $0x10,%esp
  80363d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803640:	eb 37                	jmp    803679 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  803642:	83 ec 0c             	sub    $0xc,%esp
  803645:	ff 75 08             	pushl  0x8(%ebp)
  803648:	e8 08 08 00 00       	call   803e55 <alloc_block_BF>
  80364d:	83 c4 10             	add    $0x10,%esp
  803650:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803653:	eb 24                	jmp    803679 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  803655:	83 ec 0c             	sub    $0xc,%esp
  803658:	ff 75 08             	pushl  0x8(%ebp)
  80365b:	e8 ad 11 00 00       	call   80480d <alloc_block_WF>
  803660:	83 c4 10             	add    $0x10,%esp
  803663:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  803666:	eb 11                	jmp    803679 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  803668:	83 ec 0c             	sub    $0xc,%esp
  80366b:	68 38 63 80 00       	push   $0x806338
  803670:	e8 41 e4 ff ff       	call   801ab6 <cprintf>
  803675:	83 c4 10             	add    $0x10,%esp
		break;
  803678:	90                   	nop
	}
	return va;
  803679:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80367c:	c9                   	leave  
  80367d:	c3                   	ret    

0080367e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80367e:	55                   	push   %ebp
  80367f:	89 e5                	mov    %esp,%ebp
  803681:	53                   	push   %ebx
  803682:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  803685:	83 ec 0c             	sub    $0xc,%esp
  803688:	68 58 63 80 00       	push   $0x806358
  80368d:	e8 24 e4 ff ff       	call   801ab6 <cprintf>
  803692:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  803695:	83 ec 0c             	sub    $0xc,%esp
  803698:	68 83 63 80 00       	push   $0x806383
  80369d:	e8 14 e4 ff ff       	call   801ab6 <cprintf>
  8036a2:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8036a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ab:	eb 37                	jmp    8036e4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8036ad:	83 ec 0c             	sub    $0xc,%esp
  8036b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8036b3:	e8 19 ff ff ff       	call   8035d1 <is_free_block>
  8036b8:	83 c4 10             	add    $0x10,%esp
  8036bb:	0f be d8             	movsbl %al,%ebx
  8036be:	83 ec 0c             	sub    $0xc,%esp
  8036c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8036c4:	e8 ef fe ff ff       	call   8035b8 <get_block_size>
  8036c9:	83 c4 10             	add    $0x10,%esp
  8036cc:	83 ec 04             	sub    $0x4,%esp
  8036cf:	53                   	push   %ebx
  8036d0:	50                   	push   %eax
  8036d1:	68 9b 63 80 00       	push   $0x80639b
  8036d6:	e8 db e3 ff ff       	call   801ab6 <cprintf>
  8036db:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8036de:	8b 45 10             	mov    0x10(%ebp),%eax
  8036e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e8:	74 07                	je     8036f1 <print_blocks_list+0x73>
  8036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ed:	8b 00                	mov    (%eax),%eax
  8036ef:	eb 05                	jmp    8036f6 <print_blocks_list+0x78>
  8036f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036f6:	89 45 10             	mov    %eax,0x10(%ebp)
  8036f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8036fc:	85 c0                	test   %eax,%eax
  8036fe:	75 ad                	jne    8036ad <print_blocks_list+0x2f>
  803700:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803704:	75 a7                	jne    8036ad <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  803706:	83 ec 0c             	sub    $0xc,%esp
  803709:	68 58 63 80 00       	push   $0x806358
  80370e:	e8 a3 e3 ff ff       	call   801ab6 <cprintf>
  803713:	83 c4 10             	add    $0x10,%esp

}
  803716:	90                   	nop
  803717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80371a:	c9                   	leave  
  80371b:	c3                   	ret    

0080371c <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80371c:	55                   	push   %ebp
  80371d:	89 e5                	mov    %esp,%ebp
  80371f:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  803722:	8b 45 0c             	mov    0xc(%ebp),%eax
  803725:	83 e0 01             	and    $0x1,%eax
  803728:	85 c0                	test   %eax,%eax
  80372a:	74 03                	je     80372f <initialize_dynamic_allocator+0x13>
  80372c:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80372f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803733:	0f 84 f8 00 00 00    	je     803831 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  803739:	c7 05 40 70 98 00 01 	movl   $0x1,0x987040
  803740:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  803743:	a1 40 70 98 00       	mov    0x987040,%eax
  803748:	85 c0                	test   %eax,%eax
  80374a:	0f 84 e2 00 00 00    	je     803832 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  803756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803759:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80375f:	8b 55 08             	mov    0x8(%ebp),%edx
  803762:	8b 45 0c             	mov    0xc(%ebp),%eax
  803765:	01 d0                	add    %edx,%eax
  803767:	83 e8 04             	sub    $0x4,%eax
  80376a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	83 c0 08             	add    $0x8,%eax
  80377c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80377f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803782:	83 e8 08             	sub    $0x8,%eax
  803785:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  803788:	83 ec 04             	sub    $0x4,%esp
  80378b:	6a 00                	push   $0x0
  80378d:	ff 75 e8             	pushl  -0x18(%ebp)
  803790:	ff 75 ec             	pushl  -0x14(%ebp)
  803793:	e8 9c 00 00 00       	call   803834 <set_block_data>
  803798:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80379b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80379e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8037a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8037ae:	c7 05 48 70 98 00 00 	movl   $0x0,0x987048
  8037b5:	00 00 00 
  8037b8:	c7 05 4c 70 98 00 00 	movl   $0x0,0x98704c
  8037bf:	00 00 00 
  8037c2:	c7 05 54 70 98 00 00 	movl   $0x0,0x987054
  8037c9:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8037cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8037d0:	75 17                	jne    8037e9 <initialize_dynamic_allocator+0xcd>
  8037d2:	83 ec 04             	sub    $0x4,%esp
  8037d5:	68 b4 63 80 00       	push   $0x8063b4
  8037da:	68 80 00 00 00       	push   $0x80
  8037df:	68 d7 63 80 00       	push   $0x8063d7
  8037e4:	e8 10 e0 ff ff       	call   8017f9 <_panic>
  8037e9:	8b 15 48 70 98 00    	mov    0x987048,%edx
  8037ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f2:	89 10                	mov    %edx,(%eax)
  8037f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8037f7:	8b 00                	mov    (%eax),%eax
  8037f9:	85 c0                	test   %eax,%eax
  8037fb:	74 0d                	je     80380a <initialize_dynamic_allocator+0xee>
  8037fd:	a1 48 70 98 00       	mov    0x987048,%eax
  803802:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803805:	89 50 04             	mov    %edx,0x4(%eax)
  803808:	eb 08                	jmp    803812 <initialize_dynamic_allocator+0xf6>
  80380a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80380d:	a3 4c 70 98 00       	mov    %eax,0x98704c
  803812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803815:	a3 48 70 98 00       	mov    %eax,0x987048
  80381a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80381d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803824:	a1 54 70 98 00       	mov    0x987054,%eax
  803829:	40                   	inc    %eax
  80382a:	a3 54 70 98 00       	mov    %eax,0x987054
  80382f:	eb 01                	jmp    803832 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  803831:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  803832:	c9                   	leave  
  803833:	c3                   	ret    

00803834 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  803834:	55                   	push   %ebp
  803835:	89 e5                	mov    %esp,%ebp
  803837:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80383a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80383d:	83 e0 01             	and    $0x1,%eax
  803840:	85 c0                	test   %eax,%eax
  803842:	74 03                	je     803847 <set_block_data+0x13>
	{
		totalSize++;
  803844:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  803847:	8b 45 08             	mov    0x8(%ebp),%eax
  80384a:	83 e8 04             	sub    $0x4,%eax
  80384d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  803850:	8b 45 0c             	mov    0xc(%ebp),%eax
  803853:	83 e0 fe             	and    $0xfffffffe,%eax
  803856:	89 c2                	mov    %eax,%edx
  803858:	8b 45 10             	mov    0x10(%ebp),%eax
  80385b:	83 e0 01             	and    $0x1,%eax
  80385e:	09 c2                	or     %eax,%edx
  803860:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803863:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  803865:	8b 45 0c             	mov    0xc(%ebp),%eax
  803868:	8d 50 f8             	lea    -0x8(%eax),%edx
  80386b:	8b 45 08             	mov    0x8(%ebp),%eax
  80386e:	01 d0                	add    %edx,%eax
  803870:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  803873:	8b 45 0c             	mov    0xc(%ebp),%eax
  803876:	83 e0 fe             	and    $0xfffffffe,%eax
  803879:	89 c2                	mov    %eax,%edx
  80387b:	8b 45 10             	mov    0x10(%ebp),%eax
  80387e:	83 e0 01             	and    $0x1,%eax
  803881:	09 c2                	or     %eax,%edx
  803883:	8b 45 f8             	mov    -0x8(%ebp),%eax
  803886:	89 10                	mov    %edx,(%eax)
}
  803888:	90                   	nop
  803889:	c9                   	leave  
  80388a:	c3                   	ret    

0080388b <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80388b:	55                   	push   %ebp
  80388c:	89 e5                	mov    %esp,%ebp
  80388e:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  803891:	a1 48 70 98 00       	mov    0x987048,%eax
  803896:	85 c0                	test   %eax,%eax
  803898:	75 68                	jne    803902 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80389a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389e:	75 17                	jne    8038b7 <insert_sorted_in_freeList+0x2c>
  8038a0:	83 ec 04             	sub    $0x4,%esp
  8038a3:	68 b4 63 80 00       	push   $0x8063b4
  8038a8:	68 9d 00 00 00       	push   $0x9d
  8038ad:	68 d7 63 80 00       	push   $0x8063d7
  8038b2:	e8 42 df ff ff       	call   8017f9 <_panic>
  8038b7:	8b 15 48 70 98 00    	mov    0x987048,%edx
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	89 10                	mov    %edx,(%eax)
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	85 c0                	test   %eax,%eax
  8038c9:	74 0d                	je     8038d8 <insert_sorted_in_freeList+0x4d>
  8038cb:	a1 48 70 98 00       	mov    0x987048,%eax
  8038d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d3:	89 50 04             	mov    %edx,0x4(%eax)
  8038d6:	eb 08                	jmp    8038e0 <insert_sorted_in_freeList+0x55>
  8038d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038db:	a3 4c 70 98 00       	mov    %eax,0x98704c
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	a3 48 70 98 00       	mov    %eax,0x987048
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f2:	a1 54 70 98 00       	mov    0x987054,%eax
  8038f7:	40                   	inc    %eax
  8038f8:	a3 54 70 98 00       	mov    %eax,0x987054
		return;
  8038fd:	e9 1a 01 00 00       	jmp    803a1c <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803902:	a1 48 70 98 00       	mov    0x987048,%eax
  803907:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80390a:	eb 7f                	jmp    80398b <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80390c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803912:	76 6f                	jbe    803983 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  803914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803918:	74 06                	je     803920 <insert_sorted_in_freeList+0x95>
  80391a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80391e:	75 17                	jne    803937 <insert_sorted_in_freeList+0xac>
  803920:	83 ec 04             	sub    $0x4,%esp
  803923:	68 f0 63 80 00       	push   $0x8063f0
  803928:	68 a6 00 00 00       	push   $0xa6
  80392d:	68 d7 63 80 00       	push   $0x8063d7
  803932:	e8 c2 de ff ff       	call   8017f9 <_panic>
  803937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80393a:	8b 50 04             	mov    0x4(%eax),%edx
  80393d:	8b 45 08             	mov    0x8(%ebp),%eax
  803940:	89 50 04             	mov    %edx,0x4(%eax)
  803943:	8b 45 08             	mov    0x8(%ebp),%eax
  803946:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803949:	89 10                	mov    %edx,(%eax)
  80394b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80394e:	8b 40 04             	mov    0x4(%eax),%eax
  803951:	85 c0                	test   %eax,%eax
  803953:	74 0d                	je     803962 <insert_sorted_in_freeList+0xd7>
  803955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803958:	8b 40 04             	mov    0x4(%eax),%eax
  80395b:	8b 55 08             	mov    0x8(%ebp),%edx
  80395e:	89 10                	mov    %edx,(%eax)
  803960:	eb 08                	jmp    80396a <insert_sorted_in_freeList+0xdf>
  803962:	8b 45 08             	mov    0x8(%ebp),%eax
  803965:	a3 48 70 98 00       	mov    %eax,0x987048
  80396a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80396d:	8b 55 08             	mov    0x8(%ebp),%edx
  803970:	89 50 04             	mov    %edx,0x4(%eax)
  803973:	a1 54 70 98 00       	mov    0x987054,%eax
  803978:	40                   	inc    %eax
  803979:	a3 54 70 98 00       	mov    %eax,0x987054
			return;
  80397e:	e9 99 00 00 00       	jmp    803a1c <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  803983:	a1 50 70 98 00       	mov    0x987050,%eax
  803988:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80398b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80398f:	74 07                	je     803998 <insert_sorted_in_freeList+0x10d>
  803991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803994:	8b 00                	mov    (%eax),%eax
  803996:	eb 05                	jmp    80399d <insert_sorted_in_freeList+0x112>
  803998:	b8 00 00 00 00       	mov    $0x0,%eax
  80399d:	a3 50 70 98 00       	mov    %eax,0x987050
  8039a2:	a1 50 70 98 00       	mov    0x987050,%eax
  8039a7:	85 c0                	test   %eax,%eax
  8039a9:	0f 85 5d ff ff ff    	jne    80390c <insert_sorted_in_freeList+0x81>
  8039af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039b3:	0f 85 53 ff ff ff    	jne    80390c <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8039b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039bd:	75 17                	jne    8039d6 <insert_sorted_in_freeList+0x14b>
  8039bf:	83 ec 04             	sub    $0x4,%esp
  8039c2:	68 28 64 80 00       	push   $0x806428
  8039c7:	68 ab 00 00 00       	push   $0xab
  8039cc:	68 d7 63 80 00       	push   $0x8063d7
  8039d1:	e8 23 de ff ff       	call   8017f9 <_panic>
  8039d6:	8b 15 4c 70 98 00    	mov    0x98704c,%edx
  8039dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8039df:	89 50 04             	mov    %edx,0x4(%eax)
  8039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e5:	8b 40 04             	mov    0x4(%eax),%eax
  8039e8:	85 c0                	test   %eax,%eax
  8039ea:	74 0c                	je     8039f8 <insert_sorted_in_freeList+0x16d>
  8039ec:	a1 4c 70 98 00       	mov    0x98704c,%eax
  8039f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8039f4:	89 10                	mov    %edx,(%eax)
  8039f6:	eb 08                	jmp    803a00 <insert_sorted_in_freeList+0x175>
  8039f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fb:	a3 48 70 98 00       	mov    %eax,0x987048
  803a00:	8b 45 08             	mov    0x8(%ebp),%eax
  803a03:	a3 4c 70 98 00       	mov    %eax,0x98704c
  803a08:	8b 45 08             	mov    0x8(%ebp),%eax
  803a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803a11:	a1 54 70 98 00       	mov    0x987054,%eax
  803a16:	40                   	inc    %eax
  803a17:	a3 54 70 98 00       	mov    %eax,0x987054
}
  803a1c:	c9                   	leave  
  803a1d:	c3                   	ret    

00803a1e <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  803a1e:	55                   	push   %ebp
  803a1f:	89 e5                	mov    %esp,%ebp
  803a21:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  803a24:	8b 45 08             	mov    0x8(%ebp),%eax
  803a27:	83 e0 01             	and    $0x1,%eax
  803a2a:	85 c0                	test   %eax,%eax
  803a2c:	74 03                	je     803a31 <alloc_block_FF+0x13>
  803a2e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  803a31:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  803a35:	77 07                	ja     803a3e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  803a37:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  803a3e:	a1 40 70 98 00       	mov    0x987040,%eax
  803a43:	85 c0                	test   %eax,%eax
  803a45:	75 63                	jne    803aaa <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  803a47:	8b 45 08             	mov    0x8(%ebp),%eax
  803a4a:	83 c0 10             	add    $0x10,%eax
  803a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  803a50:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  803a57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803a5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a5d:	01 d0                	add    %edx,%eax
  803a5f:	48                   	dec    %eax
  803a60:	89 45 e8             	mov    %eax,-0x18(%ebp)
  803a63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a66:	ba 00 00 00 00       	mov    $0x0,%edx
  803a6b:	f7 75 ec             	divl   -0x14(%ebp)
  803a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a71:	29 d0                	sub    %edx,%eax
  803a73:	c1 e8 0c             	shr    $0xc,%eax
  803a76:	83 ec 0c             	sub    $0xc,%esp
  803a79:	50                   	push   %eax
  803a7a:	e8 d1 ed ff ff       	call   802850 <sbrk>
  803a7f:	83 c4 10             	add    $0x10,%esp
  803a82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  803a85:	83 ec 0c             	sub    $0xc,%esp
  803a88:	6a 00                	push   $0x0
  803a8a:	e8 c1 ed ff ff       	call   802850 <sbrk>
  803a8f:	83 c4 10             	add    $0x10,%esp
  803a92:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  803a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a98:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  803a9b:	83 ec 08             	sub    $0x8,%esp
  803a9e:	50                   	push   %eax
  803a9f:	ff 75 e4             	pushl  -0x1c(%ebp)
  803aa2:	e8 75 fc ff ff       	call   80371c <initialize_dynamic_allocator>
  803aa7:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  803aaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803aae:	75 0a                	jne    803aba <alloc_block_FF+0x9c>
	{
		return NULL;
  803ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ab5:	e9 99 03 00 00       	jmp    803e53 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803aba:	8b 45 08             	mov    0x8(%ebp),%eax
  803abd:	83 c0 08             	add    $0x8,%eax
  803ac0:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803ac3:	a1 48 70 98 00       	mov    0x987048,%eax
  803ac8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803acb:	e9 03 02 00 00       	jmp    803cd3 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  803ad0:	83 ec 0c             	sub    $0xc,%esp
  803ad3:	ff 75 f4             	pushl  -0xc(%ebp)
  803ad6:	e8 dd fa ff ff       	call   8035b8 <get_block_size>
  803adb:	83 c4 10             	add    $0x10,%esp
  803ade:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  803ae1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  803ae4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  803ae7:	0f 82 de 01 00 00    	jb     803ccb <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  803aed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803af0:	83 c0 10             	add    $0x10,%eax
  803af3:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  803af6:	0f 87 32 01 00 00    	ja     803c2e <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  803afc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  803aff:	2b 45 dc             	sub    -0x24(%ebp),%eax
  803b02:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  803b05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b08:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803b0b:	01 d0                	add    %edx,%eax
  803b0d:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  803b10:	83 ec 04             	sub    $0x4,%esp
  803b13:	6a 00                	push   $0x0
  803b15:	ff 75 98             	pushl  -0x68(%ebp)
  803b18:	ff 75 94             	pushl  -0x6c(%ebp)
  803b1b:	e8 14 fd ff ff       	call   803834 <set_block_data>
  803b20:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  803b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b27:	74 06                	je     803b2f <alloc_block_FF+0x111>
  803b29:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  803b2d:	75 17                	jne    803b46 <alloc_block_FF+0x128>
  803b2f:	83 ec 04             	sub    $0x4,%esp
  803b32:	68 4c 64 80 00       	push   $0x80644c
  803b37:	68 de 00 00 00       	push   $0xde
  803b3c:	68 d7 63 80 00       	push   $0x8063d7
  803b41:	e8 b3 dc ff ff       	call   8017f9 <_panic>
  803b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b49:	8b 10                	mov    (%eax),%edx
  803b4b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803b4e:	89 10                	mov    %edx,(%eax)
  803b50:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803b53:	8b 00                	mov    (%eax),%eax
  803b55:	85 c0                	test   %eax,%eax
  803b57:	74 0b                	je     803b64 <alloc_block_FF+0x146>
  803b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b5c:	8b 00                	mov    (%eax),%eax
  803b5e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  803b61:	89 50 04             	mov    %edx,0x4(%eax)
  803b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b67:	8b 55 94             	mov    -0x6c(%ebp),%edx
  803b6a:	89 10                	mov    %edx,(%eax)
  803b6c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b72:	89 50 04             	mov    %edx,0x4(%eax)
  803b75:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803b78:	8b 00                	mov    (%eax),%eax
  803b7a:	85 c0                	test   %eax,%eax
  803b7c:	75 08                	jne    803b86 <alloc_block_FF+0x168>
  803b7e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  803b81:	a3 4c 70 98 00       	mov    %eax,0x98704c
  803b86:	a1 54 70 98 00       	mov    0x987054,%eax
  803b8b:	40                   	inc    %eax
  803b8c:	a3 54 70 98 00       	mov    %eax,0x987054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  803b91:	83 ec 04             	sub    $0x4,%esp
  803b94:	6a 01                	push   $0x1
  803b96:	ff 75 dc             	pushl  -0x24(%ebp)
  803b99:	ff 75 f4             	pushl  -0xc(%ebp)
  803b9c:	e8 93 fc ff ff       	call   803834 <set_block_data>
  803ba1:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ba8:	75 17                	jne    803bc1 <alloc_block_FF+0x1a3>
  803baa:	83 ec 04             	sub    $0x4,%esp
  803bad:	68 80 64 80 00       	push   $0x806480
  803bb2:	68 e3 00 00 00       	push   $0xe3
  803bb7:	68 d7 63 80 00       	push   $0x8063d7
  803bbc:	e8 38 dc ff ff       	call   8017f9 <_panic>
  803bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc4:	8b 00                	mov    (%eax),%eax
  803bc6:	85 c0                	test   %eax,%eax
  803bc8:	74 10                	je     803bda <alloc_block_FF+0x1bc>
  803bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bcd:	8b 00                	mov    (%eax),%eax
  803bcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bd2:	8b 52 04             	mov    0x4(%edx),%edx
  803bd5:	89 50 04             	mov    %edx,0x4(%eax)
  803bd8:	eb 0b                	jmp    803be5 <alloc_block_FF+0x1c7>
  803bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdd:	8b 40 04             	mov    0x4(%eax),%eax
  803be0:	a3 4c 70 98 00       	mov    %eax,0x98704c
  803be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803be8:	8b 40 04             	mov    0x4(%eax),%eax
  803beb:	85 c0                	test   %eax,%eax
  803bed:	74 0f                	je     803bfe <alloc_block_FF+0x1e0>
  803bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bf2:	8b 40 04             	mov    0x4(%eax),%eax
  803bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803bf8:	8b 12                	mov    (%edx),%edx
  803bfa:	89 10                	mov    %edx,(%eax)
  803bfc:	eb 0a                	jmp    803c08 <alloc_block_FF+0x1ea>
  803bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c01:	8b 00                	mov    (%eax),%eax
  803c03:	a3 48 70 98 00       	mov    %eax,0x987048
  803c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c1b:	a1 54 70 98 00       	mov    0x987054,%eax
  803c20:	48                   	dec    %eax
  803c21:	a3 54 70 98 00       	mov    %eax,0x987054
				return (void*)((uint32*)block);
  803c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c29:	e9 25 02 00 00       	jmp    803e53 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  803c2e:	83 ec 04             	sub    $0x4,%esp
  803c31:	6a 01                	push   $0x1
  803c33:	ff 75 9c             	pushl  -0x64(%ebp)
  803c36:	ff 75 f4             	pushl  -0xc(%ebp)
  803c39:	e8 f6 fb ff ff       	call   803834 <set_block_data>
  803c3e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  803c41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c45:	75 17                	jne    803c5e <alloc_block_FF+0x240>
  803c47:	83 ec 04             	sub    $0x4,%esp
  803c4a:	68 80 64 80 00       	push   $0x806480
  803c4f:	68 eb 00 00 00       	push   $0xeb
  803c54:	68 d7 63 80 00       	push   $0x8063d7
  803c59:	e8 9b db ff ff       	call   8017f9 <_panic>
  803c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c61:	8b 00                	mov    (%eax),%eax
  803c63:	85 c0                	test   %eax,%eax
  803c65:	74 10                	je     803c77 <alloc_block_FF+0x259>
  803c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c6a:	8b 00                	mov    (%eax),%eax
  803c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c6f:	8b 52 04             	mov    0x4(%edx),%edx
  803c72:	89 50 04             	mov    %edx,0x4(%eax)
  803c75:	eb 0b                	jmp    803c82 <alloc_block_FF+0x264>
  803c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7a:	8b 40 04             	mov    0x4(%eax),%eax
  803c7d:	a3 4c 70 98 00       	mov    %eax,0x98704c
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	8b 40 04             	mov    0x4(%eax),%eax
  803c88:	85 c0                	test   %eax,%eax
  803c8a:	74 0f                	je     803c9b <alloc_block_FF+0x27d>
  803c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c8f:	8b 40 04             	mov    0x4(%eax),%eax
  803c92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c95:	8b 12                	mov    (%edx),%edx
  803c97:	89 10                	mov    %edx,(%eax)
  803c99:	eb 0a                	jmp    803ca5 <alloc_block_FF+0x287>
  803c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9e:	8b 00                	mov    (%eax),%eax
  803ca0:	a3 48 70 98 00       	mov    %eax,0x987048
  803ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803cb8:	a1 54 70 98 00       	mov    0x987054,%eax
  803cbd:	48                   	dec    %eax
  803cbe:	a3 54 70 98 00       	mov    %eax,0x987054
				return (void*)((uint32*)block);
  803cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc6:	e9 88 01 00 00       	jmp    803e53 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803ccb:	a1 50 70 98 00       	mov    0x987050,%eax
  803cd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cd7:	74 07                	je     803ce0 <alloc_block_FF+0x2c2>
  803cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cdc:	8b 00                	mov    (%eax),%eax
  803cde:	eb 05                	jmp    803ce5 <alloc_block_FF+0x2c7>
  803ce0:	b8 00 00 00 00       	mov    $0x0,%eax
  803ce5:	a3 50 70 98 00       	mov    %eax,0x987050
  803cea:	a1 50 70 98 00       	mov    0x987050,%eax
  803cef:	85 c0                	test   %eax,%eax
  803cf1:	0f 85 d9 fd ff ff    	jne    803ad0 <alloc_block_FF+0xb2>
  803cf7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803cfb:	0f 85 cf fd ff ff    	jne    803ad0 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  803d01:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  803d08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803d0e:	01 d0                	add    %edx,%eax
  803d10:	48                   	dec    %eax
  803d11:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  803d14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d17:	ba 00 00 00 00       	mov    $0x0,%edx
  803d1c:	f7 75 d8             	divl   -0x28(%ebp)
  803d1f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803d22:	29 d0                	sub    %edx,%eax
  803d24:	c1 e8 0c             	shr    $0xc,%eax
  803d27:	83 ec 0c             	sub    $0xc,%esp
  803d2a:	50                   	push   %eax
  803d2b:	e8 20 eb ff ff       	call   802850 <sbrk>
  803d30:	83 c4 10             	add    $0x10,%esp
  803d33:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  803d36:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  803d3a:	75 0a                	jne    803d46 <alloc_block_FF+0x328>
		return NULL;
  803d3c:	b8 00 00 00 00       	mov    $0x0,%eax
  803d41:	e9 0d 01 00 00       	jmp    803e53 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  803d46:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d49:	83 e8 04             	sub    $0x4,%eax
  803d4c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  803d4f:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  803d56:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803d59:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803d5c:	01 d0                	add    %edx,%eax
  803d5e:	48                   	dec    %eax
  803d5f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  803d62:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d65:	ba 00 00 00 00       	mov    $0x0,%edx
  803d6a:	f7 75 c8             	divl   -0x38(%ebp)
  803d6d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803d70:	29 d0                	sub    %edx,%eax
  803d72:	c1 e8 02             	shr    $0x2,%eax
  803d75:	c1 e0 02             	shl    $0x2,%eax
  803d78:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  803d7b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  803d7e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  803d84:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803d87:	83 e8 08             	sub    $0x8,%eax
  803d8a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  803d8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  803d90:	8b 00                	mov    (%eax),%eax
  803d92:	83 e0 fe             	and    $0xfffffffe,%eax
  803d95:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  803d98:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803d9b:	f7 d8                	neg    %eax
  803d9d:	89 c2                	mov    %eax,%edx
  803d9f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  803da2:	01 d0                	add    %edx,%eax
  803da4:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  803da7:	83 ec 0c             	sub    $0xc,%esp
  803daa:	ff 75 b8             	pushl  -0x48(%ebp)
  803dad:	e8 1f f8 ff ff       	call   8035d1 <is_free_block>
  803db2:	83 c4 10             	add    $0x10,%esp
  803db5:	0f be c0             	movsbl %al,%eax
  803db8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  803dbb:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  803dbf:	74 42                	je     803e03 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  803dc1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  803dc8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803dcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  803dce:	01 d0                	add    %edx,%eax
  803dd0:	48                   	dec    %eax
  803dd1:	89 45 ac             	mov    %eax,-0x54(%ebp)
  803dd4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803dd7:	ba 00 00 00 00       	mov    $0x0,%edx
  803ddc:	f7 75 b0             	divl   -0x50(%ebp)
  803ddf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  803de2:	29 d0                	sub    %edx,%eax
  803de4:	89 c2                	mov    %eax,%edx
  803de6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  803de9:	01 d0                	add    %edx,%eax
  803deb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  803dee:	83 ec 04             	sub    $0x4,%esp
  803df1:	6a 00                	push   $0x0
  803df3:	ff 75 a8             	pushl  -0x58(%ebp)
  803df6:	ff 75 b8             	pushl  -0x48(%ebp)
  803df9:	e8 36 fa ff ff       	call   803834 <set_block_data>
  803dfe:	83 c4 10             	add    $0x10,%esp
  803e01:	eb 42                	jmp    803e45 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  803e03:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  803e0a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803e0d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  803e10:	01 d0                	add    %edx,%eax
  803e12:	48                   	dec    %eax
  803e13:	89 45 a0             	mov    %eax,-0x60(%ebp)
  803e16:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803e19:	ba 00 00 00 00       	mov    $0x0,%edx
  803e1e:	f7 75 a4             	divl   -0x5c(%ebp)
  803e21:	8b 45 a0             	mov    -0x60(%ebp),%eax
  803e24:	29 d0                	sub    %edx,%eax
  803e26:	83 ec 04             	sub    $0x4,%esp
  803e29:	6a 00                	push   $0x0
  803e2b:	50                   	push   %eax
  803e2c:	ff 75 d0             	pushl  -0x30(%ebp)
  803e2f:	e8 00 fa ff ff       	call   803834 <set_block_data>
  803e34:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  803e37:	83 ec 0c             	sub    $0xc,%esp
  803e3a:	ff 75 d0             	pushl  -0x30(%ebp)
  803e3d:	e8 49 fa ff ff       	call   80388b <insert_sorted_in_freeList>
  803e42:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  803e45:	83 ec 0c             	sub    $0xc,%esp
  803e48:	ff 75 08             	pushl  0x8(%ebp)
  803e4b:	e8 ce fb ff ff       	call   803a1e <alloc_block_FF>
  803e50:	83 c4 10             	add    $0x10,%esp
}
  803e53:	c9                   	leave  
  803e54:	c3                   	ret    

00803e55 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  803e55:	55                   	push   %ebp
  803e56:	89 e5                	mov    %esp,%ebp
  803e58:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  803e5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e5f:	75 0a                	jne    803e6b <alloc_block_BF+0x16>
	{
		return NULL;
  803e61:	b8 00 00 00 00       	mov    $0x0,%eax
  803e66:	e9 7a 02 00 00       	jmp    8040e5 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  803e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6e:	83 c0 08             	add    $0x8,%eax
  803e71:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  803e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  803e7b:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803e82:	a1 48 70 98 00       	mov    0x987048,%eax
  803e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803e8a:	eb 32                	jmp    803ebe <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  803e8c:	ff 75 ec             	pushl  -0x14(%ebp)
  803e8f:	e8 24 f7 ff ff       	call   8035b8 <get_block_size>
  803e94:	83 c4 04             	add    $0x4,%esp
  803e97:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  803e9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803e9d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803ea0:	72 14                	jb     803eb6 <alloc_block_BF+0x61>
  803ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ea5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803ea8:	73 0c                	jae    803eb6 <alloc_block_BF+0x61>
		{
			minBlk = block;
  803eaa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  803eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  803eb6:	a1 50 70 98 00       	mov    0x987050,%eax
  803ebb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ebe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ec2:	74 07                	je     803ecb <alloc_block_BF+0x76>
  803ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803ec7:	8b 00                	mov    (%eax),%eax
  803ec9:	eb 05                	jmp    803ed0 <alloc_block_BF+0x7b>
  803ecb:	b8 00 00 00 00       	mov    $0x0,%eax
  803ed0:	a3 50 70 98 00       	mov    %eax,0x987050
  803ed5:	a1 50 70 98 00       	mov    0x987050,%eax
  803eda:	85 c0                	test   %eax,%eax
  803edc:	75 ae                	jne    803e8c <alloc_block_BF+0x37>
  803ede:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803ee2:	75 a8                	jne    803e8c <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  803ee4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ee8:	75 22                	jne    803f0c <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  803eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803eed:	83 ec 0c             	sub    $0xc,%esp
  803ef0:	50                   	push   %eax
  803ef1:	e8 5a e9 ff ff       	call   802850 <sbrk>
  803ef6:	83 c4 10             	add    $0x10,%esp
  803ef9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  803efc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  803f00:	75 0a                	jne    803f0c <alloc_block_BF+0xb7>
			return NULL;
  803f02:	b8 00 00 00 00       	mov    $0x0,%eax
  803f07:	e9 d9 01 00 00       	jmp    8040e5 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  803f0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f0f:	83 c0 10             	add    $0x10,%eax
  803f12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803f15:	0f 87 32 01 00 00    	ja     80404d <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  803f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803f1e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803f21:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  803f24:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803f2a:	01 d0                	add    %edx,%eax
  803f2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  803f2f:	83 ec 04             	sub    $0x4,%esp
  803f32:	6a 00                	push   $0x0
  803f34:	ff 75 dc             	pushl  -0x24(%ebp)
  803f37:	ff 75 d8             	pushl  -0x28(%ebp)
  803f3a:	e8 f5 f8 ff ff       	call   803834 <set_block_data>
  803f3f:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  803f42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f46:	74 06                	je     803f4e <alloc_block_BF+0xf9>
  803f48:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  803f4c:	75 17                	jne    803f65 <alloc_block_BF+0x110>
  803f4e:	83 ec 04             	sub    $0x4,%esp
  803f51:	68 4c 64 80 00       	push   $0x80644c
  803f56:	68 49 01 00 00       	push   $0x149
  803f5b:	68 d7 63 80 00       	push   $0x8063d7
  803f60:	e8 94 d8 ff ff       	call   8017f9 <_panic>
  803f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f68:	8b 10                	mov    (%eax),%edx
  803f6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f6d:	89 10                	mov    %edx,(%eax)
  803f6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f72:	8b 00                	mov    (%eax),%eax
  803f74:	85 c0                	test   %eax,%eax
  803f76:	74 0b                	je     803f83 <alloc_block_BF+0x12e>
  803f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f7b:	8b 00                	mov    (%eax),%eax
  803f7d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f80:	89 50 04             	mov    %edx,0x4(%eax)
  803f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f86:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803f89:	89 10                	mov    %edx,(%eax)
  803f8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803f91:	89 50 04             	mov    %edx,0x4(%eax)
  803f94:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803f97:	8b 00                	mov    (%eax),%eax
  803f99:	85 c0                	test   %eax,%eax
  803f9b:	75 08                	jne    803fa5 <alloc_block_BF+0x150>
  803f9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803fa0:	a3 4c 70 98 00       	mov    %eax,0x98704c
  803fa5:	a1 54 70 98 00       	mov    0x987054,%eax
  803faa:	40                   	inc    %eax
  803fab:	a3 54 70 98 00       	mov    %eax,0x987054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  803fb0:	83 ec 04             	sub    $0x4,%esp
  803fb3:	6a 01                	push   $0x1
  803fb5:	ff 75 e8             	pushl  -0x18(%ebp)
  803fb8:	ff 75 f4             	pushl  -0xc(%ebp)
  803fbb:	e8 74 f8 ff ff       	call   803834 <set_block_data>
  803fc0:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803fc7:	75 17                	jne    803fe0 <alloc_block_BF+0x18b>
  803fc9:	83 ec 04             	sub    $0x4,%esp
  803fcc:	68 80 64 80 00       	push   $0x806480
  803fd1:	68 4e 01 00 00       	push   $0x14e
  803fd6:	68 d7 63 80 00       	push   $0x8063d7
  803fdb:	e8 19 d8 ff ff       	call   8017f9 <_panic>
  803fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fe3:	8b 00                	mov    (%eax),%eax
  803fe5:	85 c0                	test   %eax,%eax
  803fe7:	74 10                	je     803ff9 <alloc_block_BF+0x1a4>
  803fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fec:	8b 00                	mov    (%eax),%eax
  803fee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803ff1:	8b 52 04             	mov    0x4(%edx),%edx
  803ff4:	89 50 04             	mov    %edx,0x4(%eax)
  803ff7:	eb 0b                	jmp    804004 <alloc_block_BF+0x1af>
  803ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ffc:	8b 40 04             	mov    0x4(%eax),%eax
  803fff:	a3 4c 70 98 00       	mov    %eax,0x98704c
  804004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804007:	8b 40 04             	mov    0x4(%eax),%eax
  80400a:	85 c0                	test   %eax,%eax
  80400c:	74 0f                	je     80401d <alloc_block_BF+0x1c8>
  80400e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804011:	8b 40 04             	mov    0x4(%eax),%eax
  804014:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804017:	8b 12                	mov    (%edx),%edx
  804019:	89 10                	mov    %edx,(%eax)
  80401b:	eb 0a                	jmp    804027 <alloc_block_BF+0x1d2>
  80401d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804020:	8b 00                	mov    (%eax),%eax
  804022:	a3 48 70 98 00       	mov    %eax,0x987048
  804027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80402a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80403a:	a1 54 70 98 00       	mov    0x987054,%eax
  80403f:	48                   	dec    %eax
  804040:	a3 54 70 98 00       	mov    %eax,0x987054
		return (void*)((uint32*)minBlk);
  804045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804048:	e9 98 00 00 00       	jmp    8040e5 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  80404d:	83 ec 04             	sub    $0x4,%esp
  804050:	6a 01                	push   $0x1
  804052:	ff 75 f0             	pushl  -0x10(%ebp)
  804055:	ff 75 f4             	pushl  -0xc(%ebp)
  804058:	e8 d7 f7 ff ff       	call   803834 <set_block_data>
  80405d:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  804060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804064:	75 17                	jne    80407d <alloc_block_BF+0x228>
  804066:	83 ec 04             	sub    $0x4,%esp
  804069:	68 80 64 80 00       	push   $0x806480
  80406e:	68 56 01 00 00       	push   $0x156
  804073:	68 d7 63 80 00       	push   $0x8063d7
  804078:	e8 7c d7 ff ff       	call   8017f9 <_panic>
  80407d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804080:	8b 00                	mov    (%eax),%eax
  804082:	85 c0                	test   %eax,%eax
  804084:	74 10                	je     804096 <alloc_block_BF+0x241>
  804086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804089:	8b 00                	mov    (%eax),%eax
  80408b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80408e:	8b 52 04             	mov    0x4(%edx),%edx
  804091:	89 50 04             	mov    %edx,0x4(%eax)
  804094:	eb 0b                	jmp    8040a1 <alloc_block_BF+0x24c>
  804096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804099:	8b 40 04             	mov    0x4(%eax),%eax
  80409c:	a3 4c 70 98 00       	mov    %eax,0x98704c
  8040a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a4:	8b 40 04             	mov    0x4(%eax),%eax
  8040a7:	85 c0                	test   %eax,%eax
  8040a9:	74 0f                	je     8040ba <alloc_block_BF+0x265>
  8040ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ae:	8b 40 04             	mov    0x4(%eax),%eax
  8040b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8040b4:	8b 12                	mov    (%edx),%edx
  8040b6:	89 10                	mov    %edx,(%eax)
  8040b8:	eb 0a                	jmp    8040c4 <alloc_block_BF+0x26f>
  8040ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040bd:	8b 00                	mov    (%eax),%eax
  8040bf:	a3 48 70 98 00       	mov    %eax,0x987048
  8040c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8040cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8040d7:	a1 54 70 98 00       	mov    0x987054,%eax
  8040dc:	48                   	dec    %eax
  8040dd:	a3 54 70 98 00       	mov    %eax,0x987054
		return (void*)((uint32*)minBlk);
  8040e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  8040e5:	c9                   	leave  
  8040e6:	c3                   	ret    

008040e7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8040e7:	55                   	push   %ebp
  8040e8:	89 e5                	mov    %esp,%ebp
  8040ea:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  8040ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040f1:	0f 84 6a 02 00 00    	je     804361 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  8040f7:	ff 75 08             	pushl  0x8(%ebp)
  8040fa:	e8 b9 f4 ff ff       	call   8035b8 <get_block_size>
  8040ff:	83 c4 04             	add    $0x4,%esp
  804102:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  804105:	8b 45 08             	mov    0x8(%ebp),%eax
  804108:	83 e8 08             	sub    $0x8,%eax
  80410b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  80410e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804111:	8b 00                	mov    (%eax),%eax
  804113:	83 e0 fe             	and    $0xfffffffe,%eax
  804116:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  804119:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80411c:	f7 d8                	neg    %eax
  80411e:	89 c2                	mov    %eax,%edx
  804120:	8b 45 08             	mov    0x8(%ebp),%eax
  804123:	01 d0                	add    %edx,%eax
  804125:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  804128:	ff 75 e8             	pushl  -0x18(%ebp)
  80412b:	e8 a1 f4 ff ff       	call   8035d1 <is_free_block>
  804130:	83 c4 04             	add    $0x4,%esp
  804133:	0f be c0             	movsbl %al,%eax
  804136:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  804139:	8b 55 08             	mov    0x8(%ebp),%edx
  80413c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80413f:	01 d0                	add    %edx,%eax
  804141:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  804144:	ff 75 e0             	pushl  -0x20(%ebp)
  804147:	e8 85 f4 ff ff       	call   8035d1 <is_free_block>
  80414c:	83 c4 04             	add    $0x4,%esp
  80414f:	0f be c0             	movsbl %al,%eax
  804152:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  804155:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  804159:	75 34                	jne    80418f <free_block+0xa8>
  80415b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80415f:	75 2e                	jne    80418f <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  804161:	ff 75 e8             	pushl  -0x18(%ebp)
  804164:	e8 4f f4 ff ff       	call   8035b8 <get_block_size>
  804169:	83 c4 04             	add    $0x4,%esp
  80416c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  80416f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  804172:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804175:	01 d0                	add    %edx,%eax
  804177:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  80417a:	6a 00                	push   $0x0
  80417c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80417f:	ff 75 e8             	pushl  -0x18(%ebp)
  804182:	e8 ad f6 ff ff       	call   803834 <set_block_data>
  804187:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  80418a:	e9 d3 01 00 00       	jmp    804362 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  80418f:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  804193:	0f 85 c8 00 00 00    	jne    804261 <free_block+0x17a>
  804199:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80419d:	0f 85 be 00 00 00    	jne    804261 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  8041a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8041a6:	e8 0d f4 ff ff       	call   8035b8 <get_block_size>
  8041ab:	83 c4 04             	add    $0x4,%esp
  8041ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  8041b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8041b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8041b7:	01 d0                	add    %edx,%eax
  8041b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  8041bc:	6a 00                	push   $0x0
  8041be:	ff 75 cc             	pushl  -0x34(%ebp)
  8041c1:	ff 75 08             	pushl  0x8(%ebp)
  8041c4:	e8 6b f6 ff ff       	call   803834 <set_block_data>
  8041c9:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  8041cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8041d0:	75 17                	jne    8041e9 <free_block+0x102>
  8041d2:	83 ec 04             	sub    $0x4,%esp
  8041d5:	68 80 64 80 00       	push   $0x806480
  8041da:	68 87 01 00 00       	push   $0x187
  8041df:	68 d7 63 80 00       	push   $0x8063d7
  8041e4:	e8 10 d6 ff ff       	call   8017f9 <_panic>
  8041e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041ec:	8b 00                	mov    (%eax),%eax
  8041ee:	85 c0                	test   %eax,%eax
  8041f0:	74 10                	je     804202 <free_block+0x11b>
  8041f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8041f5:	8b 00                	mov    (%eax),%eax
  8041f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8041fa:	8b 52 04             	mov    0x4(%edx),%edx
  8041fd:	89 50 04             	mov    %edx,0x4(%eax)
  804200:	eb 0b                	jmp    80420d <free_block+0x126>
  804202:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804205:	8b 40 04             	mov    0x4(%eax),%eax
  804208:	a3 4c 70 98 00       	mov    %eax,0x98704c
  80420d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804210:	8b 40 04             	mov    0x4(%eax),%eax
  804213:	85 c0                	test   %eax,%eax
  804215:	74 0f                	je     804226 <free_block+0x13f>
  804217:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80421a:	8b 40 04             	mov    0x4(%eax),%eax
  80421d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  804220:	8b 12                	mov    (%edx),%edx
  804222:	89 10                	mov    %edx,(%eax)
  804224:	eb 0a                	jmp    804230 <free_block+0x149>
  804226:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804229:	8b 00                	mov    (%eax),%eax
  80422b:	a3 48 70 98 00       	mov    %eax,0x987048
  804230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804233:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804239:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80423c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804243:	a1 54 70 98 00       	mov    0x987054,%eax
  804248:	48                   	dec    %eax
  804249:	a3 54 70 98 00       	mov    %eax,0x987054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  80424e:	83 ec 0c             	sub    $0xc,%esp
  804251:	ff 75 08             	pushl  0x8(%ebp)
  804254:	e8 32 f6 ff ff       	call   80388b <insert_sorted_in_freeList>
  804259:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  80425c:	e9 01 01 00 00       	jmp    804362 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  804261:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  804265:	0f 85 d3 00 00 00    	jne    80433e <free_block+0x257>
  80426b:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  80426f:	0f 85 c9 00 00 00    	jne    80433e <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  804275:	83 ec 0c             	sub    $0xc,%esp
  804278:	ff 75 e8             	pushl  -0x18(%ebp)
  80427b:	e8 38 f3 ff ff       	call   8035b8 <get_block_size>
  804280:	83 c4 10             	add    $0x10,%esp
  804283:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  804286:	83 ec 0c             	sub    $0xc,%esp
  804289:	ff 75 e0             	pushl  -0x20(%ebp)
  80428c:	e8 27 f3 ff ff       	call   8035b8 <get_block_size>
  804291:	83 c4 10             	add    $0x10,%esp
  804294:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  804297:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80429a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80429d:	01 c2                	add    %eax,%edx
  80429f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8042a2:	01 d0                	add    %edx,%eax
  8042a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  8042a7:	83 ec 04             	sub    $0x4,%esp
  8042aa:	6a 00                	push   $0x0
  8042ac:	ff 75 c0             	pushl  -0x40(%ebp)
  8042af:	ff 75 e8             	pushl  -0x18(%ebp)
  8042b2:	e8 7d f5 ff ff       	call   803834 <set_block_data>
  8042b7:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  8042ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8042be:	75 17                	jne    8042d7 <free_block+0x1f0>
  8042c0:	83 ec 04             	sub    $0x4,%esp
  8042c3:	68 80 64 80 00       	push   $0x806480
  8042c8:	68 94 01 00 00       	push   $0x194
  8042cd:	68 d7 63 80 00       	push   $0x8063d7
  8042d2:	e8 22 d5 ff ff       	call   8017f9 <_panic>
  8042d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042da:	8b 00                	mov    (%eax),%eax
  8042dc:	85 c0                	test   %eax,%eax
  8042de:	74 10                	je     8042f0 <free_block+0x209>
  8042e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042e3:	8b 00                	mov    (%eax),%eax
  8042e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8042e8:	8b 52 04             	mov    0x4(%edx),%edx
  8042eb:	89 50 04             	mov    %edx,0x4(%eax)
  8042ee:	eb 0b                	jmp    8042fb <free_block+0x214>
  8042f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042f3:	8b 40 04             	mov    0x4(%eax),%eax
  8042f6:	a3 4c 70 98 00       	mov    %eax,0x98704c
  8042fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8042fe:	8b 40 04             	mov    0x4(%eax),%eax
  804301:	85 c0                	test   %eax,%eax
  804303:	74 0f                	je     804314 <free_block+0x22d>
  804305:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804308:	8b 40 04             	mov    0x4(%eax),%eax
  80430b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80430e:	8b 12                	mov    (%edx),%edx
  804310:	89 10                	mov    %edx,(%eax)
  804312:	eb 0a                	jmp    80431e <free_block+0x237>
  804314:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804317:	8b 00                	mov    (%eax),%eax
  804319:	a3 48 70 98 00       	mov    %eax,0x987048
  80431e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80432a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804331:	a1 54 70 98 00       	mov    0x987054,%eax
  804336:	48                   	dec    %eax
  804337:	a3 54 70 98 00       	mov    %eax,0x987054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  80433c:	eb 24                	jmp    804362 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  80433e:	83 ec 04             	sub    $0x4,%esp
  804341:	6a 00                	push   $0x0
  804343:	ff 75 f4             	pushl  -0xc(%ebp)
  804346:	ff 75 08             	pushl  0x8(%ebp)
  804349:	e8 e6 f4 ff ff       	call   803834 <set_block_data>
  80434e:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  804351:	83 ec 0c             	sub    $0xc,%esp
  804354:	ff 75 08             	pushl  0x8(%ebp)
  804357:	e8 2f f5 ff ff       	call   80388b <insert_sorted_in_freeList>
  80435c:	83 c4 10             	add    $0x10,%esp
  80435f:	eb 01                	jmp    804362 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  804361:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  804362:	c9                   	leave  
  804363:	c3                   	ret    

00804364 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  804364:	55                   	push   %ebp
  804365:	89 e5                	mov    %esp,%ebp
  804367:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  80436a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80436e:	75 10                	jne    804380 <realloc_block_FF+0x1c>
  804370:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804374:	75 0a                	jne    804380 <realloc_block_FF+0x1c>
	{
		return NULL;
  804376:	b8 00 00 00 00       	mov    $0x0,%eax
  80437b:	e9 8b 04 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  804380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  804384:	75 18                	jne    80439e <realloc_block_FF+0x3a>
	{
		free_block(va);
  804386:	83 ec 0c             	sub    $0xc,%esp
  804389:	ff 75 08             	pushl  0x8(%ebp)
  80438c:	e8 56 fd ff ff       	call   8040e7 <free_block>
  804391:	83 c4 10             	add    $0x10,%esp
		return NULL;
  804394:	b8 00 00 00 00       	mov    $0x0,%eax
  804399:	e9 6d 04 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  80439e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8043a2:	75 13                	jne    8043b7 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  8043a4:	83 ec 0c             	sub    $0xc,%esp
  8043a7:	ff 75 0c             	pushl  0xc(%ebp)
  8043aa:	e8 6f f6 ff ff       	call   803a1e <alloc_block_FF>
  8043af:	83 c4 10             	add    $0x10,%esp
  8043b2:	e9 54 04 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  8043b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8043ba:	83 e0 01             	and    $0x1,%eax
  8043bd:	85 c0                	test   %eax,%eax
  8043bf:	74 03                	je     8043c4 <realloc_block_FF+0x60>
	{
		new_size++;
  8043c1:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  8043c4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  8043c8:	77 07                	ja     8043d1 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  8043ca:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  8043d1:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  8043d5:	83 ec 0c             	sub    $0xc,%esp
  8043d8:	ff 75 08             	pushl  0x8(%ebp)
  8043db:	e8 d8 f1 ff ff       	call   8035b8 <get_block_size>
  8043e0:	83 c4 10             	add    $0x10,%esp
  8043e3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8043e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8043ec:	75 08                	jne    8043f6 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8043ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8043f1:	e9 15 04 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8043f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8043f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043fc:	01 d0                	add    %edx,%eax
  8043fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  804401:	83 ec 0c             	sub    $0xc,%esp
  804404:	ff 75 f0             	pushl  -0x10(%ebp)
  804407:	e8 c5 f1 ff ff       	call   8035d1 <is_free_block>
  80440c:	83 c4 10             	add    $0x10,%esp
  80440f:	0f be c0             	movsbl %al,%eax
  804412:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  804415:	83 ec 0c             	sub    $0xc,%esp
  804418:	ff 75 f0             	pushl  -0x10(%ebp)
  80441b:	e8 98 f1 ff ff       	call   8035b8 <get_block_size>
  804420:	83 c4 10             	add    $0x10,%esp
  804423:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  804426:	8b 45 0c             	mov    0xc(%ebp),%eax
  804429:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80442c:	0f 86 a7 02 00 00    	jbe    8046d9 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  804432:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804436:	0f 84 86 02 00 00    	je     8046c2 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80443c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80443f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804442:	01 d0                	add    %edx,%eax
  804444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  804447:	0f 85 b2 00 00 00    	jne    8044ff <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80444d:	83 ec 0c             	sub    $0xc,%esp
  804450:	ff 75 08             	pushl  0x8(%ebp)
  804453:	e8 79 f1 ff ff       	call   8035d1 <is_free_block>
  804458:	83 c4 10             	add    $0x10,%esp
  80445b:	84 c0                	test   %al,%al
  80445d:	0f 94 c0             	sete   %al
  804460:	0f b6 c0             	movzbl %al,%eax
  804463:	83 ec 04             	sub    $0x4,%esp
  804466:	50                   	push   %eax
  804467:	ff 75 0c             	pushl  0xc(%ebp)
  80446a:	ff 75 08             	pushl  0x8(%ebp)
  80446d:	e8 c2 f3 ff ff       	call   803834 <set_block_data>
  804472:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  804475:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804479:	75 17                	jne    804492 <realloc_block_FF+0x12e>
  80447b:	83 ec 04             	sub    $0x4,%esp
  80447e:	68 80 64 80 00       	push   $0x806480
  804483:	68 db 01 00 00       	push   $0x1db
  804488:	68 d7 63 80 00       	push   $0x8063d7
  80448d:	e8 67 d3 ff ff       	call   8017f9 <_panic>
  804492:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804495:	8b 00                	mov    (%eax),%eax
  804497:	85 c0                	test   %eax,%eax
  804499:	74 10                	je     8044ab <realloc_block_FF+0x147>
  80449b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80449e:	8b 00                	mov    (%eax),%eax
  8044a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044a3:	8b 52 04             	mov    0x4(%edx),%edx
  8044a6:	89 50 04             	mov    %edx,0x4(%eax)
  8044a9:	eb 0b                	jmp    8044b6 <realloc_block_FF+0x152>
  8044ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044ae:	8b 40 04             	mov    0x4(%eax),%eax
  8044b1:	a3 4c 70 98 00       	mov    %eax,0x98704c
  8044b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044b9:	8b 40 04             	mov    0x4(%eax),%eax
  8044bc:	85 c0                	test   %eax,%eax
  8044be:	74 0f                	je     8044cf <realloc_block_FF+0x16b>
  8044c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044c3:	8b 40 04             	mov    0x4(%eax),%eax
  8044c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8044c9:	8b 12                	mov    (%edx),%edx
  8044cb:	89 10                	mov    %edx,(%eax)
  8044cd:	eb 0a                	jmp    8044d9 <realloc_block_FF+0x175>
  8044cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044d2:	8b 00                	mov    (%eax),%eax
  8044d4:	a3 48 70 98 00       	mov    %eax,0x987048
  8044d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8044e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8044e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8044ec:	a1 54 70 98 00       	mov    0x987054,%eax
  8044f1:	48                   	dec    %eax
  8044f2:	a3 54 70 98 00       	mov    %eax,0x987054
				return va;
  8044f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8044fa:	e9 0c 03 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8044ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804505:	01 d0                	add    %edx,%eax
  804507:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80450a:	0f 86 b2 01 00 00    	jbe    8046c2 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  804510:	8b 45 0c             	mov    0xc(%ebp),%eax
  804513:	2b 45 f4             	sub    -0xc(%ebp),%eax
  804516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  804519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80451c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80451f:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  804522:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  804526:	0f 87 b8 00 00 00    	ja     8045e4 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80452c:	83 ec 0c             	sub    $0xc,%esp
  80452f:	ff 75 08             	pushl  0x8(%ebp)
  804532:	e8 9a f0 ff ff       	call   8035d1 <is_free_block>
  804537:	83 c4 10             	add    $0x10,%esp
  80453a:	84 c0                	test   %al,%al
  80453c:	0f 94 c0             	sete   %al
  80453f:	0f b6 c0             	movzbl %al,%eax
  804542:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  804545:	8b 55 e8             	mov    -0x18(%ebp),%edx
  804548:	01 ca                	add    %ecx,%edx
  80454a:	83 ec 04             	sub    $0x4,%esp
  80454d:	50                   	push   %eax
  80454e:	52                   	push   %edx
  80454f:	ff 75 08             	pushl  0x8(%ebp)
  804552:	e8 dd f2 ff ff       	call   803834 <set_block_data>
  804557:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80455a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80455e:	75 17                	jne    804577 <realloc_block_FF+0x213>
  804560:	83 ec 04             	sub    $0x4,%esp
  804563:	68 80 64 80 00       	push   $0x806480
  804568:	68 e8 01 00 00       	push   $0x1e8
  80456d:	68 d7 63 80 00       	push   $0x8063d7
  804572:	e8 82 d2 ff ff       	call   8017f9 <_panic>
  804577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80457a:	8b 00                	mov    (%eax),%eax
  80457c:	85 c0                	test   %eax,%eax
  80457e:	74 10                	je     804590 <realloc_block_FF+0x22c>
  804580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804583:	8b 00                	mov    (%eax),%eax
  804585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804588:	8b 52 04             	mov    0x4(%edx),%edx
  80458b:	89 50 04             	mov    %edx,0x4(%eax)
  80458e:	eb 0b                	jmp    80459b <realloc_block_FF+0x237>
  804590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804593:	8b 40 04             	mov    0x4(%eax),%eax
  804596:	a3 4c 70 98 00       	mov    %eax,0x98704c
  80459b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80459e:	8b 40 04             	mov    0x4(%eax),%eax
  8045a1:	85 c0                	test   %eax,%eax
  8045a3:	74 0f                	je     8045b4 <realloc_block_FF+0x250>
  8045a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045a8:	8b 40 04             	mov    0x4(%eax),%eax
  8045ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8045ae:	8b 12                	mov    (%edx),%edx
  8045b0:	89 10                	mov    %edx,(%eax)
  8045b2:	eb 0a                	jmp    8045be <realloc_block_FF+0x25a>
  8045b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045b7:	8b 00                	mov    (%eax),%eax
  8045b9:	a3 48 70 98 00       	mov    %eax,0x987048
  8045be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8045c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8045ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8045d1:	a1 54 70 98 00       	mov    0x987054,%eax
  8045d6:	48                   	dec    %eax
  8045d7:	a3 54 70 98 00       	mov    %eax,0x987054
					return va;
  8045dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8045df:	e9 27 02 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8045e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8045e8:	75 17                	jne    804601 <realloc_block_FF+0x29d>
  8045ea:	83 ec 04             	sub    $0x4,%esp
  8045ed:	68 80 64 80 00       	push   $0x806480
  8045f2:	68 ed 01 00 00       	push   $0x1ed
  8045f7:	68 d7 63 80 00       	push   $0x8063d7
  8045fc:	e8 f8 d1 ff ff       	call   8017f9 <_panic>
  804601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804604:	8b 00                	mov    (%eax),%eax
  804606:	85 c0                	test   %eax,%eax
  804608:	74 10                	je     80461a <realloc_block_FF+0x2b6>
  80460a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80460d:	8b 00                	mov    (%eax),%eax
  80460f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804612:	8b 52 04             	mov    0x4(%edx),%edx
  804615:	89 50 04             	mov    %edx,0x4(%eax)
  804618:	eb 0b                	jmp    804625 <realloc_block_FF+0x2c1>
  80461a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80461d:	8b 40 04             	mov    0x4(%eax),%eax
  804620:	a3 4c 70 98 00       	mov    %eax,0x98704c
  804625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804628:	8b 40 04             	mov    0x4(%eax),%eax
  80462b:	85 c0                	test   %eax,%eax
  80462d:	74 0f                	je     80463e <realloc_block_FF+0x2da>
  80462f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804632:	8b 40 04             	mov    0x4(%eax),%eax
  804635:	8b 55 f0             	mov    -0x10(%ebp),%edx
  804638:	8b 12                	mov    (%edx),%edx
  80463a:	89 10                	mov    %edx,(%eax)
  80463c:	eb 0a                	jmp    804648 <realloc_block_FF+0x2e4>
  80463e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804641:	8b 00                	mov    (%eax),%eax
  804643:	a3 48 70 98 00       	mov    %eax,0x987048
  804648:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80464b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80465b:	a1 54 70 98 00       	mov    0x987054,%eax
  804660:	48                   	dec    %eax
  804661:	a3 54 70 98 00       	mov    %eax,0x987054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  804666:	8b 55 08             	mov    0x8(%ebp),%edx
  804669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80466c:	01 d0                	add    %edx,%eax
  80466e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  804671:	83 ec 04             	sub    $0x4,%esp
  804674:	6a 00                	push   $0x0
  804676:	ff 75 e0             	pushl  -0x20(%ebp)
  804679:	ff 75 f0             	pushl  -0x10(%ebp)
  80467c:	e8 b3 f1 ff ff       	call   803834 <set_block_data>
  804681:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  804684:	83 ec 0c             	sub    $0xc,%esp
  804687:	ff 75 08             	pushl  0x8(%ebp)
  80468a:	e8 42 ef ff ff       	call   8035d1 <is_free_block>
  80468f:	83 c4 10             	add    $0x10,%esp
  804692:	84 c0                	test   %al,%al
  804694:	0f 94 c0             	sete   %al
  804697:	0f b6 c0             	movzbl %al,%eax
  80469a:	83 ec 04             	sub    $0x4,%esp
  80469d:	50                   	push   %eax
  80469e:	ff 75 0c             	pushl  0xc(%ebp)
  8046a1:	ff 75 08             	pushl  0x8(%ebp)
  8046a4:	e8 8b f1 ff ff       	call   803834 <set_block_data>
  8046a9:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8046ac:	83 ec 0c             	sub    $0xc,%esp
  8046af:	ff 75 f0             	pushl  -0x10(%ebp)
  8046b2:	e8 d4 f1 ff ff       	call   80388b <insert_sorted_in_freeList>
  8046b7:	83 c4 10             	add    $0x10,%esp
					return va;
  8046ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8046bd:	e9 49 01 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8046c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046c5:	83 e8 08             	sub    $0x8,%eax
  8046c8:	83 ec 0c             	sub    $0xc,%esp
  8046cb:	50                   	push   %eax
  8046cc:	e8 4d f3 ff ff       	call   803a1e <alloc_block_FF>
  8046d1:	83 c4 10             	add    $0x10,%esp
  8046d4:	e9 32 01 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8046d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8046dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8046df:	0f 83 21 01 00 00    	jae    804806 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8046e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8046e8:	2b 45 0c             	sub    0xc(%ebp),%eax
  8046eb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8046ee:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8046f2:	77 0e                	ja     804702 <realloc_block_FF+0x39e>
  8046f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8046f8:	75 08                	jne    804702 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8046fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8046fd:	e9 09 01 00 00       	jmp    80480b <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  804702:	8b 45 08             	mov    0x8(%ebp),%eax
  804705:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  804708:	83 ec 0c             	sub    $0xc,%esp
  80470b:	ff 75 08             	pushl  0x8(%ebp)
  80470e:	e8 be ee ff ff       	call   8035d1 <is_free_block>
  804713:	83 c4 10             	add    $0x10,%esp
  804716:	84 c0                	test   %al,%al
  804718:	0f 94 c0             	sete   %al
  80471b:	0f b6 c0             	movzbl %al,%eax
  80471e:	83 ec 04             	sub    $0x4,%esp
  804721:	50                   	push   %eax
  804722:	ff 75 0c             	pushl  0xc(%ebp)
  804725:	ff 75 d8             	pushl  -0x28(%ebp)
  804728:	e8 07 f1 ff ff       	call   803834 <set_block_data>
  80472d:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  804730:	8b 55 d8             	mov    -0x28(%ebp),%edx
  804733:	8b 45 0c             	mov    0xc(%ebp),%eax
  804736:	01 d0                	add    %edx,%eax
  804738:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80473b:	83 ec 04             	sub    $0x4,%esp
  80473e:	6a 00                	push   $0x0
  804740:	ff 75 dc             	pushl  -0x24(%ebp)
  804743:	ff 75 d4             	pushl  -0x2c(%ebp)
  804746:	e8 e9 f0 ff ff       	call   803834 <set_block_data>
  80474b:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80474e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  804752:	0f 84 9b 00 00 00    	je     8047f3 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  804758:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80475b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80475e:	01 d0                	add    %edx,%eax
  804760:	83 ec 04             	sub    $0x4,%esp
  804763:	6a 00                	push   $0x0
  804765:	50                   	push   %eax
  804766:	ff 75 d4             	pushl  -0x2c(%ebp)
  804769:	e8 c6 f0 ff ff       	call   803834 <set_block_data>
  80476e:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  804771:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  804775:	75 17                	jne    80478e <realloc_block_FF+0x42a>
  804777:	83 ec 04             	sub    $0x4,%esp
  80477a:	68 80 64 80 00       	push   $0x806480
  80477f:	68 10 02 00 00       	push   $0x210
  804784:	68 d7 63 80 00       	push   $0x8063d7
  804789:	e8 6b d0 ff ff       	call   8017f9 <_panic>
  80478e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  804791:	8b 00                	mov    (%eax),%eax
  804793:	85 c0                	test   %eax,%eax
  804795:	74 10                	je     8047a7 <realloc_block_FF+0x443>
  804797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80479a:	8b 00                	mov    (%eax),%eax
  80479c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80479f:	8b 52 04             	mov    0x4(%edx),%edx
  8047a2:	89 50 04             	mov    %edx,0x4(%eax)
  8047a5:	eb 0b                	jmp    8047b2 <realloc_block_FF+0x44e>
  8047a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047aa:	8b 40 04             	mov    0x4(%eax),%eax
  8047ad:	a3 4c 70 98 00       	mov    %eax,0x98704c
  8047b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047b5:	8b 40 04             	mov    0x4(%eax),%eax
  8047b8:	85 c0                	test   %eax,%eax
  8047ba:	74 0f                	je     8047cb <realloc_block_FF+0x467>
  8047bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047bf:	8b 40 04             	mov    0x4(%eax),%eax
  8047c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8047c5:	8b 12                	mov    (%edx),%edx
  8047c7:	89 10                	mov    %edx,(%eax)
  8047c9:	eb 0a                	jmp    8047d5 <realloc_block_FF+0x471>
  8047cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047ce:	8b 00                	mov    (%eax),%eax
  8047d0:	a3 48 70 98 00       	mov    %eax,0x987048
  8047d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8047de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8047e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8047e8:	a1 54 70 98 00       	mov    0x987054,%eax
  8047ed:	48                   	dec    %eax
  8047ee:	a3 54 70 98 00       	mov    %eax,0x987054
			}
			insert_sorted_in_freeList(remainingBlk);
  8047f3:	83 ec 0c             	sub    $0xc,%esp
  8047f6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8047f9:	e8 8d f0 ff ff       	call   80388b <insert_sorted_in_freeList>
  8047fe:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  804801:	8b 45 d8             	mov    -0x28(%ebp),%eax
  804804:	eb 05                	jmp    80480b <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  804806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80480b:	c9                   	leave  
  80480c:	c3                   	ret    

0080480d <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80480d:	55                   	push   %ebp
  80480e:	89 e5                	mov    %esp,%ebp
  804810:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  804813:	83 ec 04             	sub    $0x4,%esp
  804816:	68 a0 64 80 00       	push   $0x8064a0
  80481b:	68 20 02 00 00       	push   $0x220
  804820:	68 d7 63 80 00       	push   $0x8063d7
  804825:	e8 cf cf ff ff       	call   8017f9 <_panic>

0080482a <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80482a:	55                   	push   %ebp
  80482b:	89 e5                	mov    %esp,%ebp
  80482d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  804830:	83 ec 04             	sub    $0x4,%esp
  804833:	68 c8 64 80 00       	push   $0x8064c8
  804838:	68 28 02 00 00       	push   $0x228
  80483d:	68 d7 63 80 00       	push   $0x8063d7
  804842:	e8 b2 cf ff ff       	call   8017f9 <_panic>

00804847 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  804847:	55                   	push   %ebp
  804848:	89 e5                	mov    %esp,%ebp
  80484a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80484d:	8b 55 08             	mov    0x8(%ebp),%edx
  804850:	89 d0                	mov    %edx,%eax
  804852:	c1 e0 02             	shl    $0x2,%eax
  804855:	01 d0                	add    %edx,%eax
  804857:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80485e:	01 d0                	add    %edx,%eax
  804860:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804867:	01 d0                	add    %edx,%eax
  804869:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  804870:	01 d0                	add    %edx,%eax
  804872:	c1 e0 04             	shl    $0x4,%eax
  804875:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  804878:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80487f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  804882:	83 ec 0c             	sub    $0xc,%esp
  804885:	50                   	push   %eax
  804886:	e8 c5 e9 ff ff       	call   803250 <sys_get_virtual_time>
  80488b:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80488e:	eb 41                	jmp    8048d1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  804890:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804893:	83 ec 0c             	sub    $0xc,%esp
  804896:	50                   	push   %eax
  804897:	e8 b4 e9 ff ff       	call   803250 <sys_get_virtual_time>
  80489c:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80489f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8048a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8048a5:	29 c2                	sub    %eax,%edx
  8048a7:	89 d0                	mov    %edx,%eax
  8048a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8048ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8048af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8048b2:	89 d1                	mov    %edx,%ecx
  8048b4:	29 c1                	sub    %eax,%ecx
  8048b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8048b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8048bc:	39 c2                	cmp    %eax,%edx
  8048be:	0f 97 c0             	seta   %al
  8048c1:	0f b6 c0             	movzbl %al,%eax
  8048c4:	29 c1                	sub    %eax,%ecx
  8048c6:	89 c8                	mov    %ecx,%eax
  8048c8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8048cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8048ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8048d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8048d4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8048d7:	72 b7                	jb     804890 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8048d9:	90                   	nop
  8048da:	c9                   	leave  
  8048db:	c3                   	ret    

008048dc <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8048dc:	55                   	push   %ebp
  8048dd:	89 e5                	mov    %esp,%ebp
  8048df:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8048e2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8048e9:	eb 03                	jmp    8048ee <busy_wait+0x12>
  8048eb:	ff 45 fc             	incl   -0x4(%ebp)
  8048ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8048f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8048f4:	72 f5                	jb     8048eb <busy_wait+0xf>
	return i;
  8048f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8048f9:	c9                   	leave  
  8048fa:	c3                   	ret    
  8048fb:	90                   	nop

008048fc <__udivdi3>:
  8048fc:	55                   	push   %ebp
  8048fd:	57                   	push   %edi
  8048fe:	56                   	push   %esi
  8048ff:	53                   	push   %ebx
  804900:	83 ec 1c             	sub    $0x1c,%esp
  804903:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804907:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80490b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80490f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804913:	89 ca                	mov    %ecx,%edx
  804915:	89 f8                	mov    %edi,%eax
  804917:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80491b:	85 f6                	test   %esi,%esi
  80491d:	75 2d                	jne    80494c <__udivdi3+0x50>
  80491f:	39 cf                	cmp    %ecx,%edi
  804921:	77 65                	ja     804988 <__udivdi3+0x8c>
  804923:	89 fd                	mov    %edi,%ebp
  804925:	85 ff                	test   %edi,%edi
  804927:	75 0b                	jne    804934 <__udivdi3+0x38>
  804929:	b8 01 00 00 00       	mov    $0x1,%eax
  80492e:	31 d2                	xor    %edx,%edx
  804930:	f7 f7                	div    %edi
  804932:	89 c5                	mov    %eax,%ebp
  804934:	31 d2                	xor    %edx,%edx
  804936:	89 c8                	mov    %ecx,%eax
  804938:	f7 f5                	div    %ebp
  80493a:	89 c1                	mov    %eax,%ecx
  80493c:	89 d8                	mov    %ebx,%eax
  80493e:	f7 f5                	div    %ebp
  804940:	89 cf                	mov    %ecx,%edi
  804942:	89 fa                	mov    %edi,%edx
  804944:	83 c4 1c             	add    $0x1c,%esp
  804947:	5b                   	pop    %ebx
  804948:	5e                   	pop    %esi
  804949:	5f                   	pop    %edi
  80494a:	5d                   	pop    %ebp
  80494b:	c3                   	ret    
  80494c:	39 ce                	cmp    %ecx,%esi
  80494e:	77 28                	ja     804978 <__udivdi3+0x7c>
  804950:	0f bd fe             	bsr    %esi,%edi
  804953:	83 f7 1f             	xor    $0x1f,%edi
  804956:	75 40                	jne    804998 <__udivdi3+0x9c>
  804958:	39 ce                	cmp    %ecx,%esi
  80495a:	72 0a                	jb     804966 <__udivdi3+0x6a>
  80495c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804960:	0f 87 9e 00 00 00    	ja     804a04 <__udivdi3+0x108>
  804966:	b8 01 00 00 00       	mov    $0x1,%eax
  80496b:	89 fa                	mov    %edi,%edx
  80496d:	83 c4 1c             	add    $0x1c,%esp
  804970:	5b                   	pop    %ebx
  804971:	5e                   	pop    %esi
  804972:	5f                   	pop    %edi
  804973:	5d                   	pop    %ebp
  804974:	c3                   	ret    
  804975:	8d 76 00             	lea    0x0(%esi),%esi
  804978:	31 ff                	xor    %edi,%edi
  80497a:	31 c0                	xor    %eax,%eax
  80497c:	89 fa                	mov    %edi,%edx
  80497e:	83 c4 1c             	add    $0x1c,%esp
  804981:	5b                   	pop    %ebx
  804982:	5e                   	pop    %esi
  804983:	5f                   	pop    %edi
  804984:	5d                   	pop    %ebp
  804985:	c3                   	ret    
  804986:	66 90                	xchg   %ax,%ax
  804988:	89 d8                	mov    %ebx,%eax
  80498a:	f7 f7                	div    %edi
  80498c:	31 ff                	xor    %edi,%edi
  80498e:	89 fa                	mov    %edi,%edx
  804990:	83 c4 1c             	add    $0x1c,%esp
  804993:	5b                   	pop    %ebx
  804994:	5e                   	pop    %esi
  804995:	5f                   	pop    %edi
  804996:	5d                   	pop    %ebp
  804997:	c3                   	ret    
  804998:	bd 20 00 00 00       	mov    $0x20,%ebp
  80499d:	89 eb                	mov    %ebp,%ebx
  80499f:	29 fb                	sub    %edi,%ebx
  8049a1:	89 f9                	mov    %edi,%ecx
  8049a3:	d3 e6                	shl    %cl,%esi
  8049a5:	89 c5                	mov    %eax,%ebp
  8049a7:	88 d9                	mov    %bl,%cl
  8049a9:	d3 ed                	shr    %cl,%ebp
  8049ab:	89 e9                	mov    %ebp,%ecx
  8049ad:	09 f1                	or     %esi,%ecx
  8049af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8049b3:	89 f9                	mov    %edi,%ecx
  8049b5:	d3 e0                	shl    %cl,%eax
  8049b7:	89 c5                	mov    %eax,%ebp
  8049b9:	89 d6                	mov    %edx,%esi
  8049bb:	88 d9                	mov    %bl,%cl
  8049bd:	d3 ee                	shr    %cl,%esi
  8049bf:	89 f9                	mov    %edi,%ecx
  8049c1:	d3 e2                	shl    %cl,%edx
  8049c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8049c7:	88 d9                	mov    %bl,%cl
  8049c9:	d3 e8                	shr    %cl,%eax
  8049cb:	09 c2                	or     %eax,%edx
  8049cd:	89 d0                	mov    %edx,%eax
  8049cf:	89 f2                	mov    %esi,%edx
  8049d1:	f7 74 24 0c          	divl   0xc(%esp)
  8049d5:	89 d6                	mov    %edx,%esi
  8049d7:	89 c3                	mov    %eax,%ebx
  8049d9:	f7 e5                	mul    %ebp
  8049db:	39 d6                	cmp    %edx,%esi
  8049dd:	72 19                	jb     8049f8 <__udivdi3+0xfc>
  8049df:	74 0b                	je     8049ec <__udivdi3+0xf0>
  8049e1:	89 d8                	mov    %ebx,%eax
  8049e3:	31 ff                	xor    %edi,%edi
  8049e5:	e9 58 ff ff ff       	jmp    804942 <__udivdi3+0x46>
  8049ea:	66 90                	xchg   %ax,%ax
  8049ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8049f0:	89 f9                	mov    %edi,%ecx
  8049f2:	d3 e2                	shl    %cl,%edx
  8049f4:	39 c2                	cmp    %eax,%edx
  8049f6:	73 e9                	jae    8049e1 <__udivdi3+0xe5>
  8049f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8049fb:	31 ff                	xor    %edi,%edi
  8049fd:	e9 40 ff ff ff       	jmp    804942 <__udivdi3+0x46>
  804a02:	66 90                	xchg   %ax,%ax
  804a04:	31 c0                	xor    %eax,%eax
  804a06:	e9 37 ff ff ff       	jmp    804942 <__udivdi3+0x46>
  804a0b:	90                   	nop

00804a0c <__umoddi3>:
  804a0c:	55                   	push   %ebp
  804a0d:	57                   	push   %edi
  804a0e:	56                   	push   %esi
  804a0f:	53                   	push   %ebx
  804a10:	83 ec 1c             	sub    $0x1c,%esp
  804a13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804a17:	8b 74 24 34          	mov    0x34(%esp),%esi
  804a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804a1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  804a23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804a27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804a2b:	89 f3                	mov    %esi,%ebx
  804a2d:	89 fa                	mov    %edi,%edx
  804a2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804a33:	89 34 24             	mov    %esi,(%esp)
  804a36:	85 c0                	test   %eax,%eax
  804a38:	75 1a                	jne    804a54 <__umoddi3+0x48>
  804a3a:	39 f7                	cmp    %esi,%edi
  804a3c:	0f 86 a2 00 00 00    	jbe    804ae4 <__umoddi3+0xd8>
  804a42:	89 c8                	mov    %ecx,%eax
  804a44:	89 f2                	mov    %esi,%edx
  804a46:	f7 f7                	div    %edi
  804a48:	89 d0                	mov    %edx,%eax
  804a4a:	31 d2                	xor    %edx,%edx
  804a4c:	83 c4 1c             	add    $0x1c,%esp
  804a4f:	5b                   	pop    %ebx
  804a50:	5e                   	pop    %esi
  804a51:	5f                   	pop    %edi
  804a52:	5d                   	pop    %ebp
  804a53:	c3                   	ret    
  804a54:	39 f0                	cmp    %esi,%eax
  804a56:	0f 87 ac 00 00 00    	ja     804b08 <__umoddi3+0xfc>
  804a5c:	0f bd e8             	bsr    %eax,%ebp
  804a5f:	83 f5 1f             	xor    $0x1f,%ebp
  804a62:	0f 84 ac 00 00 00    	je     804b14 <__umoddi3+0x108>
  804a68:	bf 20 00 00 00       	mov    $0x20,%edi
  804a6d:	29 ef                	sub    %ebp,%edi
  804a6f:	89 fe                	mov    %edi,%esi
  804a71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  804a75:	89 e9                	mov    %ebp,%ecx
  804a77:	d3 e0                	shl    %cl,%eax
  804a79:	89 d7                	mov    %edx,%edi
  804a7b:	89 f1                	mov    %esi,%ecx
  804a7d:	d3 ef                	shr    %cl,%edi
  804a7f:	09 c7                	or     %eax,%edi
  804a81:	89 e9                	mov    %ebp,%ecx
  804a83:	d3 e2                	shl    %cl,%edx
  804a85:	89 14 24             	mov    %edx,(%esp)
  804a88:	89 d8                	mov    %ebx,%eax
  804a8a:	d3 e0                	shl    %cl,%eax
  804a8c:	89 c2                	mov    %eax,%edx
  804a8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a92:	d3 e0                	shl    %cl,%eax
  804a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  804a98:	8b 44 24 08          	mov    0x8(%esp),%eax
  804a9c:	89 f1                	mov    %esi,%ecx
  804a9e:	d3 e8                	shr    %cl,%eax
  804aa0:	09 d0                	or     %edx,%eax
  804aa2:	d3 eb                	shr    %cl,%ebx
  804aa4:	89 da                	mov    %ebx,%edx
  804aa6:	f7 f7                	div    %edi
  804aa8:	89 d3                	mov    %edx,%ebx
  804aaa:	f7 24 24             	mull   (%esp)
  804aad:	89 c6                	mov    %eax,%esi
  804aaf:	89 d1                	mov    %edx,%ecx
  804ab1:	39 d3                	cmp    %edx,%ebx
  804ab3:	0f 82 87 00 00 00    	jb     804b40 <__umoddi3+0x134>
  804ab9:	0f 84 91 00 00 00    	je     804b50 <__umoddi3+0x144>
  804abf:	8b 54 24 04          	mov    0x4(%esp),%edx
  804ac3:	29 f2                	sub    %esi,%edx
  804ac5:	19 cb                	sbb    %ecx,%ebx
  804ac7:	89 d8                	mov    %ebx,%eax
  804ac9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804acd:	d3 e0                	shl    %cl,%eax
  804acf:	89 e9                	mov    %ebp,%ecx
  804ad1:	d3 ea                	shr    %cl,%edx
  804ad3:	09 d0                	or     %edx,%eax
  804ad5:	89 e9                	mov    %ebp,%ecx
  804ad7:	d3 eb                	shr    %cl,%ebx
  804ad9:	89 da                	mov    %ebx,%edx
  804adb:	83 c4 1c             	add    $0x1c,%esp
  804ade:	5b                   	pop    %ebx
  804adf:	5e                   	pop    %esi
  804ae0:	5f                   	pop    %edi
  804ae1:	5d                   	pop    %ebp
  804ae2:	c3                   	ret    
  804ae3:	90                   	nop
  804ae4:	89 fd                	mov    %edi,%ebp
  804ae6:	85 ff                	test   %edi,%edi
  804ae8:	75 0b                	jne    804af5 <__umoddi3+0xe9>
  804aea:	b8 01 00 00 00       	mov    $0x1,%eax
  804aef:	31 d2                	xor    %edx,%edx
  804af1:	f7 f7                	div    %edi
  804af3:	89 c5                	mov    %eax,%ebp
  804af5:	89 f0                	mov    %esi,%eax
  804af7:	31 d2                	xor    %edx,%edx
  804af9:	f7 f5                	div    %ebp
  804afb:	89 c8                	mov    %ecx,%eax
  804afd:	f7 f5                	div    %ebp
  804aff:	89 d0                	mov    %edx,%eax
  804b01:	e9 44 ff ff ff       	jmp    804a4a <__umoddi3+0x3e>
  804b06:	66 90                	xchg   %ax,%ax
  804b08:	89 c8                	mov    %ecx,%eax
  804b0a:	89 f2                	mov    %esi,%edx
  804b0c:	83 c4 1c             	add    $0x1c,%esp
  804b0f:	5b                   	pop    %ebx
  804b10:	5e                   	pop    %esi
  804b11:	5f                   	pop    %edi
  804b12:	5d                   	pop    %ebp
  804b13:	c3                   	ret    
  804b14:	3b 04 24             	cmp    (%esp),%eax
  804b17:	72 06                	jb     804b1f <__umoddi3+0x113>
  804b19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804b1d:	77 0f                	ja     804b2e <__umoddi3+0x122>
  804b1f:	89 f2                	mov    %esi,%edx
  804b21:	29 f9                	sub    %edi,%ecx
  804b23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804b27:	89 14 24             	mov    %edx,(%esp)
  804b2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804b2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  804b32:	8b 14 24             	mov    (%esp),%edx
  804b35:	83 c4 1c             	add    $0x1c,%esp
  804b38:	5b                   	pop    %ebx
  804b39:	5e                   	pop    %esi
  804b3a:	5f                   	pop    %edi
  804b3b:	5d                   	pop    %ebp
  804b3c:	c3                   	ret    
  804b3d:	8d 76 00             	lea    0x0(%esi),%esi
  804b40:	2b 04 24             	sub    (%esp),%eax
  804b43:	19 fa                	sbb    %edi,%edx
  804b45:	89 d1                	mov    %edx,%ecx
  804b47:	89 c6                	mov    %eax,%esi
  804b49:	e9 71 ff ff ff       	jmp    804abf <__umoddi3+0xb3>
  804b4e:	66 90                	xchg   %ax,%ax
  804b50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  804b54:	72 ea                	jb     804b40 <__umoddi3+0x134>
  804b56:	89 d9                	mov    %ebx,%ecx
  804b58:	e9 62 ff ff ff       	jmp    804abf <__umoddi3+0xb3>
