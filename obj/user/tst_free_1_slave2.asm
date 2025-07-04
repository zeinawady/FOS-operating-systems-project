
obj/user/tst_free_1_slave2:     file format elf32-i386


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
  800031:	e8 ad 02 00 00       	call   8002e3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp
#if USE_KHEAP

	//cprintf("1\n");
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800043:	a1 20 50 80 00       	mov    0x805020,%eax
  800048:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  80004e:	a1 20 50 80 00       	mov    0x805020,%eax
  800053:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800059:	39 c2                	cmp    %eax,%edx
  80005b:	72 14                	jb     800071 <_main+0x39>
			panic("Please increase the WS size");
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 e0 36 80 00       	push   $0x8036e0
  800065:	6a 12                	push   $0x12
  800067:	68 fc 36 80 00       	push   $0x8036fc
  80006c:	e8 b7 03 00 00       	call   800428 <_panic>
	}
	//	/*Dummy malloc to enforce the UHEAP initializations*/
	//	malloc(0);
	/*=================================================*/
#endif
	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800071:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)


	int Mega = 1024*1024;
  800078:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  80007f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	char minByte = 1<<7;
  800086:	c6 45 eb 80          	movb   $0x80,-0x15(%ebp)
	char maxByte = 0x7F;
  80008a:	c6 45 ea 7f          	movb   $0x7f,-0x16(%ebp)
	short minShort = 1<<15 ;
  80008e:	66 c7 45 e8 00 80    	movw   $0x8000,-0x18(%ebp)
	short maxShort = 0x7FFF;
  800094:	66 c7 45 e6 ff 7f    	movw   $0x7fff,-0x1a(%ebp)
	int minInt = 1<<31 ;
  80009a:	c7 45 e0 00 00 00 80 	movl   $0x80000000,-0x20(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000a1:	c7 45 dc ff ff ff 7f 	movl   $0x7fffffff,-0x24(%ebp)
	char *byteArr ;
	int lastIndexOfByte;

	int freeFrames, usedDiskPages, chk;
	int expectedNumOfFrames, actualNumOfFrames;
	void* ptr_allocations[20] = {0};
  8000a8:	8d 95 60 ff ff ff    	lea    -0xa0(%ebp),%edx
  8000ae:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b8:	89 d7                	mov    %edx,%edi
  8000ba:	f3 ab                	rep stos %eax,%es:(%edi)
	//ALLOCATE ONE SPACE
	{
		//2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8000bc:	e8 a9 1b 00 00       	call   801c6a <sys_calculate_free_frames>
  8000c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000c4:	e8 ec 1b 00 00       	call   801cb5 <sys_pf_calculate_allocated_pages>
  8000c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			ptr_allocations[0] = malloc(2*Mega-kilo);
  8000cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000cf:	01 c0                	add    %eax,%eax
  8000d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	50                   	push   %eax
  8000d8:	e8 b8 13 00 00       	call   801495 <malloc>
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
			if ((uint32) ptr_allocations[0] != (pagealloc_start)) panic("Wrong start address for the allocated space... ");
  8000e6:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8000ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000ef:	74 14                	je     800105 <_main+0xcd>
  8000f1:	83 ec 04             	sub    $0x4,%esp
  8000f4:	68 18 37 80 00       	push   $0x803718
  8000f9:	6a 31                	push   $0x31
  8000fb:	68 fc 36 80 00       	push   $0x8036fc
  800100:	e8 23 03 00 00       	call   800428 <_panic>
			if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800105:	e8 ab 1b 00 00       	call   801cb5 <sys_pf_calculate_allocated_pages>
  80010a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80010d:	74 14                	je     800123 <_main+0xeb>
  80010f:	83 ec 04             	sub    $0x4,%esp
  800112:	68 48 37 80 00       	push   $0x803748
  800117:	6a 32                	push   $0x32
  800119:	68 fc 36 80 00       	push   $0x8036fc
  80011e:	e8 05 03 00 00       	call   800428 <_panic>

			freeFrames = sys_calculate_free_frames() ;
  800123:	e8 42 1b 00 00       	call   801c6a <sys_calculate_free_frames>
  800128:	89 45 d8             	mov    %eax,-0x28(%ebp)
			lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  80012b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80012e:	01 c0                	add    %eax,%eax
  800130:	2b 45 ec             	sub    -0x14(%ebp),%eax
  800133:	48                   	dec    %eax
  800134:	89 45 d0             	mov    %eax,-0x30(%ebp)
			byteArr = (char *) ptr_allocations[0];
  800137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80013d:	89 45 cc             	mov    %eax,-0x34(%ebp)
			byteArr[0] = minByte ;
  800140:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800143:	8a 55 eb             	mov    -0x15(%ebp),%dl
  800146:	88 10                	mov    %dl,(%eax)
			byteArr[lastIndexOfByte] = maxByte ;
  800148:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80014b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014e:	01 c2                	add    %eax,%edx
  800150:	8a 45 ea             	mov    -0x16(%ebp),%al
  800153:	88 02                	mov    %al,(%edx)
			expectedNumOfFrames = 2 /*+1 table already created in malloc due to marking the allocated pages*/ ;
  800155:	c7 45 c8 02 00 00 00 	movl   $0x2,-0x38(%ebp)
			actualNumOfFrames = (freeFrames - sys_calculate_free_frames()) ;
  80015c:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  80015f:	e8 06 1b 00 00       	call   801c6a <sys_calculate_free_frames>
  800164:	29 c3                	sub    %eax,%ebx
  800166:	89 d8                	mov    %ebx,%eax
  800168:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			if (actualNumOfFrames < expectedNumOfFrames)
  80016b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80016e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800171:	7d 1a                	jge    80018d <_main+0x155>
				panic("Wrong fault handler: pages are not loaded successfully into memory/WS. Expected diff in frames at least = %d, actual = %d\n", expectedNumOfFrames, actualNumOfFrames);
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	ff 75 c4             	pushl  -0x3c(%ebp)
  800179:	ff 75 c8             	pushl  -0x38(%ebp)
  80017c:	68 78 37 80 00       	push   $0x803778
  800181:	6a 3c                	push   $0x3c
  800183:	68 fc 36 80 00       	push   $0x8036fc
  800188:	e8 9b 02 00 00       	call   800428 <_panic>

			uint32 expectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  80018d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800190:	89 45 c0             	mov    %eax,-0x40(%ebp)
  800193:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800196:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019b:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  8001a1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8001a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	89 45 bc             	mov    %eax,-0x44(%ebp)
  8001ac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8001af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001b4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
			chk = sys_check_WS_list(expectedVAs, 2, 0, 2);
  8001ba:	6a 02                	push   $0x2
  8001bc:	6a 00                	push   $0x0
  8001be:	6a 02                	push   $0x2
  8001c0:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
  8001c6:	50                   	push   %eax
  8001c7:	e8 f9 1e 00 00       	call   8020c5 <sys_check_WS_list>
  8001cc:	83 c4 10             	add    $0x10,%esp
  8001cf:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("malloc: page is not added to WS");
  8001d2:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  8001d6:	74 14                	je     8001ec <_main+0x1b4>
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	68 f4 37 80 00       	push   $0x8037f4
  8001e0:	6a 40                	push   $0x40
  8001e2:	68 fc 36 80 00       	push   $0x8036fc
  8001e7:	e8 3c 02 00 00       	call   800428 <_panic>

	//FREE IT
	{
		//Free 1st 2 MB
		{
			freeFrames = sys_calculate_free_frames() ;
  8001ec:	e8 79 1a 00 00       	call   801c6a <sys_calculate_free_frames>
  8001f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
			usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001f4:	e8 bc 1a 00 00       	call   801cb5 <sys_pf_calculate_allocated_pages>
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			free(ptr_allocations[0]);
  8001fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	50                   	push   %eax
  800206:	e8 40 14 00 00       	call   80164b <free>
  80020b:	83 c4 10             	add    $0x10,%esp

			if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong free: Extra or less pages are removed from PageFile");
  80020e:	e8 a2 1a 00 00       	call   801cb5 <sys_pf_calculate_allocated_pages>
  800213:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  800216:	74 14                	je     80022c <_main+0x1f4>
  800218:	83 ec 04             	sub    $0x4,%esp
  80021b:	68 14 38 80 00       	push   $0x803814
  800220:	6a 4d                	push   $0x4d
  800222:	68 fc 36 80 00       	push   $0x8036fc
  800227:	e8 fc 01 00 00       	call   800428 <_panic>
			if ((sys_calculate_free_frames() - freeFrames) != 2 ) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80022c:	e8 39 1a 00 00       	call   801c6a <sys_calculate_free_frames>
  800231:	89 c2                	mov    %eax,%edx
  800233:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800236:	29 c2                	sub    %eax,%edx
  800238:	89 d0                	mov    %edx,%eax
  80023a:	83 f8 02             	cmp    $0x2,%eax
  80023d:	74 14                	je     800253 <_main+0x21b>
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	68 50 38 80 00       	push   $0x803850
  800247:	6a 4e                	push   $0x4e
  800249:	68 fc 36 80 00       	push   $0x8036fc
  80024e:	e8 d5 01 00 00       	call   800428 <_panic>
			uint32 notExpectedVAs[2] = { ROUNDDOWN((uint32)(&(byteArr[0])), PAGE_SIZE), ROUNDDOWN((uint32)(&(byteArr[lastIndexOfByte])), PAGE_SIZE)} ;
  800253:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800256:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800259:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80025c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800261:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800267:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80026a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800272:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800275:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027a:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
			chk = sys_check_WS_list(notExpectedVAs, 2, 0, 3);
  800280:	6a 03                	push   $0x3
  800282:	6a 00                	push   $0x0
  800284:	6a 02                	push   $0x2
  800286:	8d 85 50 ff ff ff    	lea    -0xb0(%ebp),%eax
  80028c:	50                   	push   %eax
  80028d:	e8 33 1e 00 00       	call   8020c5 <sys_check_WS_list>
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	89 45 b8             	mov    %eax,-0x48(%ebp)
			if (chk != 1) panic("free: page is not removed from WS");
  800298:	83 7d b8 01          	cmpl   $0x1,-0x48(%ebp)
  80029c:	74 14                	je     8002b2 <_main+0x27a>
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	68 9c 38 80 00       	push   $0x80389c
  8002a6:	6a 51                	push   $0x51
  8002a8:	68 fc 36 80 00       	push   $0x8036fc
  8002ad:	e8 76 01 00 00       	call   800428 <_panic>
		}
	}

	inctst(); //to ensure that it reached here
  8002b2:	e8 ba 1c 00 00       	call   801f71 <inctst>

	//wait until receiving a signal from the master
	while (gettst() != 3) ;
  8002b7:	90                   	nop
  8002b8:	e8 ce 1c 00 00       	call   801f8b <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	75 f6                	jne    8002b8 <_main+0x280>

	//Test accessing a freed area (processes should be killed by the validation of the fault handler)
	{
		byteArr[0] = minByte ;
  8002c2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002c5:	8a 55 eb             	mov    -0x15(%ebp),%dl
  8002c8:	88 10                	mov    %dl,(%eax)
		inctst();
  8002ca:	e8 a2 1c 00 00       	call   801f71 <inctst>
		panic("tst_free_1_slave1 failed: The env must be killed and shouldn't return here.");
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 c0 38 80 00       	push   $0x8038c0
  8002d7:	6a 5e                	push   $0x5e
  8002d9:	68 fc 36 80 00       	push   $0x8036fc
  8002de:	e8 45 01 00 00       	call   800428 <_panic>

008002e3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8002e9:	e8 45 1b 00 00       	call   801e33 <sys_getenvindex>
  8002ee:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8002f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002f4:	89 d0                	mov    %edx,%eax
  8002f6:	c1 e0 02             	shl    $0x2,%eax
  8002f9:	01 d0                	add    %edx,%eax
  8002fb:	c1 e0 03             	shl    $0x3,%eax
  8002fe:	01 d0                	add    %edx,%eax
  800300:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800307:	01 d0                	add    %edx,%eax
  800309:	c1 e0 02             	shl    $0x2,%eax
  80030c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800311:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800316:	a1 20 50 80 00       	mov    0x805020,%eax
  80031b:	8a 40 20             	mov    0x20(%eax),%al
  80031e:	84 c0                	test   %al,%al
  800320:	74 0d                	je     80032f <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800322:	a1 20 50 80 00       	mov    0x805020,%eax
  800327:	83 c0 20             	add    $0x20,%eax
  80032a:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80032f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800333:	7e 0a                	jle    80033f <libmain+0x5c>
		binaryname = argv[0];
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8b 00                	mov    (%eax),%eax
  80033a:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80033f:	83 ec 08             	sub    $0x8,%esp
  800342:	ff 75 0c             	pushl  0xc(%ebp)
  800345:	ff 75 08             	pushl  0x8(%ebp)
  800348:	e8 eb fc ff ff       	call   800038 <_main>
  80034d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800350:	a1 00 50 80 00       	mov    0x805000,%eax
  800355:	85 c0                	test   %eax,%eax
  800357:	0f 84 9f 00 00 00    	je     8003fc <libmain+0x119>
	{
		sys_lock_cons();
  80035d:	e8 55 18 00 00       	call   801bb7 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800362:	83 ec 0c             	sub    $0xc,%esp
  800365:	68 24 39 80 00       	push   $0x803924
  80036a:	e8 76 03 00 00       	call   8006e5 <cprintf>
  80036f:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800372:	a1 20 50 80 00       	mov    0x805020,%eax
  800377:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80037d:	a1 20 50 80 00       	mov    0x805020,%eax
  800382:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800388:	83 ec 04             	sub    $0x4,%esp
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	68 4c 39 80 00       	push   $0x80394c
  800392:	e8 4e 03 00 00       	call   8006e5 <cprintf>
  800397:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80039a:	a1 20 50 80 00       	mov    0x805020,%eax
  80039f:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8003a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8003aa:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8003b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8003b5:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8003bb:	51                   	push   %ecx
  8003bc:	52                   	push   %edx
  8003bd:	50                   	push   %eax
  8003be:	68 74 39 80 00       	push   $0x803974
  8003c3:	e8 1d 03 00 00       	call   8006e5 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8003cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003d0:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8003d6:	83 ec 08             	sub    $0x8,%esp
  8003d9:	50                   	push   %eax
  8003da:	68 cc 39 80 00       	push   $0x8039cc
  8003df:	e8 01 03 00 00       	call   8006e5 <cprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8003e7:	83 ec 0c             	sub    $0xc,%esp
  8003ea:	68 24 39 80 00       	push   $0x803924
  8003ef:	e8 f1 02 00 00       	call   8006e5 <cprintf>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8003f7:	e8 d5 17 00 00       	call   801bd1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8003fc:	e8 19 00 00 00       	call   80041a <exit>
}
  800401:	90                   	nop
  800402:	c9                   	leave  
  800403:	c3                   	ret    

00800404 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800404:	55                   	push   %ebp
  800405:	89 e5                	mov    %esp,%ebp
  800407:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	6a 00                	push   $0x0
  80040f:	e8 eb 19 00 00       	call   801dff <sys_destroy_env>
  800414:	83 c4 10             	add    $0x10,%esp
}
  800417:	90                   	nop
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <exit>:

void
exit(void)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800420:	e8 40 1a 00 00       	call   801e65 <sys_exit_env>
}
  800425:	90                   	nop
  800426:	c9                   	leave  
  800427:	c3                   	ret    

00800428 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80042e:	8d 45 10             	lea    0x10(%ebp),%eax
  800431:	83 c0 04             	add    $0x4,%eax
  800434:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800437:	a1 60 50 98 00       	mov    0x985060,%eax
  80043c:	85 c0                	test   %eax,%eax
  80043e:	74 16                	je     800456 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800440:	a1 60 50 98 00       	mov    0x985060,%eax
  800445:	83 ec 08             	sub    $0x8,%esp
  800448:	50                   	push   %eax
  800449:	68 e0 39 80 00       	push   $0x8039e0
  80044e:	e8 92 02 00 00       	call   8006e5 <cprintf>
  800453:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800456:	a1 04 50 80 00       	mov    0x805004,%eax
  80045b:	ff 75 0c             	pushl  0xc(%ebp)
  80045e:	ff 75 08             	pushl  0x8(%ebp)
  800461:	50                   	push   %eax
  800462:	68 e5 39 80 00       	push   $0x8039e5
  800467:	e8 79 02 00 00       	call   8006e5 <cprintf>
  80046c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80046f:	8b 45 10             	mov    0x10(%ebp),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 f4             	pushl  -0xc(%ebp)
  800478:	50                   	push   %eax
  800479:	e8 fc 01 00 00       	call   80067a <vcprintf>
  80047e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	6a 00                	push   $0x0
  800486:	68 01 3a 80 00       	push   $0x803a01
  80048b:	e8 ea 01 00 00       	call   80067a <vcprintf>
  800490:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800493:	e8 82 ff ff ff       	call   80041a <exit>

	// should not return here
	while (1) ;
  800498:	eb fe                	jmp    800498 <_panic+0x70>

0080049a <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80049a:	55                   	push   %ebp
  80049b:	89 e5                	mov    %esp,%ebp
  80049d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8004a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ae:	39 c2                	cmp    %eax,%edx
  8004b0:	74 14                	je     8004c6 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 04 3a 80 00       	push   $0x803a04
  8004ba:	6a 26                	push   $0x26
  8004bc:	68 50 3a 80 00       	push   $0x803a50
  8004c1:	e8 62 ff ff ff       	call   800428 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8004c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8004cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004d4:	e9 c5 00 00 00       	jmp    80059e <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8004d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	75 08                	jne    8004f6 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8004ee:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004f1:	e9 a5 00 00 00       	jmp    80059b <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8004f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800504:	eb 69                	jmp    80056f <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800506:	a1 20 50 80 00       	mov    0x805020,%eax
  80050b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800511:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800514:	89 d0                	mov    %edx,%eax
  800516:	01 c0                	add    %eax,%eax
  800518:	01 d0                	add    %edx,%eax
  80051a:	c1 e0 03             	shl    $0x3,%eax
  80051d:	01 c8                	add    %ecx,%eax
  80051f:	8a 40 04             	mov    0x4(%eax),%al
  800522:	84 c0                	test   %al,%al
  800524:	75 46                	jne    80056c <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800526:	a1 20 50 80 00       	mov    0x805020,%eax
  80052b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800531:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800534:	89 d0                	mov    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d0                	add    %edx,%eax
  80053a:	c1 e0 03             	shl    $0x3,%eax
  80053d:	01 c8                	add    %ecx,%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800544:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800547:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80054c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80054e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800551:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	01 c8                	add    %ecx,%eax
  80055d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80055f:	39 c2                	cmp    %eax,%edx
  800561:	75 09                	jne    80056c <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800563:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80056a:	eb 15                	jmp    800581 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056c:	ff 45 e8             	incl   -0x18(%ebp)
  80056f:	a1 20 50 80 00       	mov    0x805020,%eax
  800574:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80057a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80057d:	39 c2                	cmp    %eax,%edx
  80057f:	77 85                	ja     800506 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800581:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800585:	75 14                	jne    80059b <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 5c 3a 80 00       	push   $0x803a5c
  80058f:	6a 3a                	push   $0x3a
  800591:	68 50 3a 80 00       	push   $0x803a50
  800596:	e8 8d fe ff ff       	call   800428 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80059b:	ff 45 f0             	incl   -0x10(%ebp)
  80059e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a4:	0f 8c 2f ff ff ff    	jl     8004d9 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8005aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005b1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8005b8:	eb 26                	jmp    8005e0 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8005c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c8:	89 d0                	mov    %edx,%eax
  8005ca:	01 c0                	add    %eax,%eax
  8005cc:	01 d0                	add    %edx,%eax
  8005ce:	c1 e0 03             	shl    $0x3,%eax
  8005d1:	01 c8                	add    %ecx,%eax
  8005d3:	8a 40 04             	mov    0x4(%eax),%al
  8005d6:	3c 01                	cmp    $0x1,%al
  8005d8:	75 03                	jne    8005dd <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8005da:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005dd:	ff 45 e0             	incl   -0x20(%ebp)
  8005e0:	a1 20 50 80 00       	mov    0x805020,%eax
  8005e5:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8005eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	77 c8                	ja     8005ba <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005f8:	74 14                	je     80060e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8005fa:	83 ec 04             	sub    $0x4,%esp
  8005fd:	68 b0 3a 80 00       	push   $0x803ab0
  800602:	6a 44                	push   $0x44
  800604:	68 50 3a 80 00       	push   $0x803a50
  800609:	e8 1a fe ff ff       	call   800428 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80060e:	90                   	nop
  80060f:	c9                   	leave  
  800610:	c3                   	ret    

00800611 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800611:	55                   	push   %ebp
  800612:	89 e5                	mov    %esp,%ebp
  800614:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	8d 48 01             	lea    0x1(%eax),%ecx
  80061f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800622:	89 0a                	mov    %ecx,(%edx)
  800624:	8b 55 08             	mov    0x8(%ebp),%edx
  800627:	88 d1                	mov    %dl,%cl
  800629:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800630:	8b 45 0c             	mov    0xc(%ebp),%eax
  800633:	8b 00                	mov    (%eax),%eax
  800635:	3d ff 00 00 00       	cmp    $0xff,%eax
  80063a:	75 2c                	jne    800668 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80063c:	a0 44 50 98 00       	mov    0x985044,%al
  800641:	0f b6 c0             	movzbl %al,%eax
  800644:	8b 55 0c             	mov    0xc(%ebp),%edx
  800647:	8b 12                	mov    (%edx),%edx
  800649:	89 d1                	mov    %edx,%ecx
  80064b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80064e:	83 c2 08             	add    $0x8,%edx
  800651:	83 ec 04             	sub    $0x4,%esp
  800654:	50                   	push   %eax
  800655:	51                   	push   %ecx
  800656:	52                   	push   %edx
  800657:	e8 19 15 00 00       	call   801b75 <sys_cputs>
  80065c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80065f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800662:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800668:	8b 45 0c             	mov    0xc(%ebp),%eax
  80066b:	8b 40 04             	mov    0x4(%eax),%eax
  80066e:	8d 50 01             	lea    0x1(%eax),%edx
  800671:	8b 45 0c             	mov    0xc(%ebp),%eax
  800674:	89 50 04             	mov    %edx,0x4(%eax)
}
  800677:	90                   	nop
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800683:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80068a:	00 00 00 
	b.cnt = 0;
  80068d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800694:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800697:	ff 75 0c             	pushl  0xc(%ebp)
  80069a:	ff 75 08             	pushl  0x8(%ebp)
  80069d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006a3:	50                   	push   %eax
  8006a4:	68 11 06 80 00       	push   $0x800611
  8006a9:	e8 11 02 00 00       	call   8008bf <vprintfmt>
  8006ae:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8006b1:	a0 44 50 98 00       	mov    0x985044,%al
  8006b6:	0f b6 c0             	movzbl %al,%eax
  8006b9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8006bf:	83 ec 04             	sub    $0x4,%esp
  8006c2:	50                   	push   %eax
  8006c3:	52                   	push   %edx
  8006c4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ca:	83 c0 08             	add    $0x8,%eax
  8006cd:	50                   	push   %eax
  8006ce:	e8 a2 14 00 00       	call   801b75 <sys_cputs>
  8006d3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006d6:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8006dd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006e3:	c9                   	leave  
  8006e4:	c3                   	ret    

008006e5 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006eb:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8006f2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800701:	50                   	push   %eax
  800702:	e8 73 ff ff ff       	call   80067a <vcprintf>
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80070d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800710:	c9                   	leave  
  800711:	c3                   	ret    

00800712 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800712:	55                   	push   %ebp
  800713:	89 e5                	mov    %esp,%ebp
  800715:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800718:	e8 9a 14 00 00       	call   801bb7 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80071d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800720:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	ff 75 f4             	pushl  -0xc(%ebp)
  80072c:	50                   	push   %eax
  80072d:	e8 48 ff ff ff       	call   80067a <vcprintf>
  800732:	83 c4 10             	add    $0x10,%esp
  800735:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800738:	e8 94 14 00 00       	call   801bd1 <sys_unlock_cons>
	return cnt;
  80073d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800740:	c9                   	leave  
  800741:	c3                   	ret    

00800742 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	53                   	push   %ebx
  800746:	83 ec 14             	sub    $0x14,%esp
  800749:	8b 45 10             	mov    0x10(%ebp),%eax
  80074c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800755:	8b 45 18             	mov    0x18(%ebp),%eax
  800758:	ba 00 00 00 00       	mov    $0x0,%edx
  80075d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800760:	77 55                	ja     8007b7 <printnum+0x75>
  800762:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800765:	72 05                	jb     80076c <printnum+0x2a>
  800767:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80076a:	77 4b                	ja     8007b7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80076c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80076f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800772:	8b 45 18             	mov    0x18(%ebp),%eax
  800775:	ba 00 00 00 00       	mov    $0x0,%edx
  80077a:	52                   	push   %edx
  80077b:	50                   	push   %eax
  80077c:	ff 75 f4             	pushl  -0xc(%ebp)
  80077f:	ff 75 f0             	pushl  -0x10(%ebp)
  800782:	e8 f1 2c 00 00       	call   803478 <__udivdi3>
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	ff 75 20             	pushl  0x20(%ebp)
  800790:	53                   	push   %ebx
  800791:	ff 75 18             	pushl  0x18(%ebp)
  800794:	52                   	push   %edx
  800795:	50                   	push   %eax
  800796:	ff 75 0c             	pushl  0xc(%ebp)
  800799:	ff 75 08             	pushl  0x8(%ebp)
  80079c:	e8 a1 ff ff ff       	call   800742 <printnum>
  8007a1:	83 c4 20             	add    $0x20,%esp
  8007a4:	eb 1a                	jmp    8007c0 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	ff 75 20             	pushl  0x20(%ebp)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	ff d0                	call   *%eax
  8007b4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007b7:	ff 4d 1c             	decl   0x1c(%ebp)
  8007ba:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8007be:	7f e6                	jg     8007a6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007c0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8007c3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ce:	53                   	push   %ebx
  8007cf:	51                   	push   %ecx
  8007d0:	52                   	push   %edx
  8007d1:	50                   	push   %eax
  8007d2:	e8 b1 2d 00 00       	call   803588 <__umoddi3>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	05 14 3d 80 00       	add    $0x803d14,%eax
  8007df:	8a 00                	mov    (%eax),%al
  8007e1:	0f be c0             	movsbl %al,%eax
  8007e4:	83 ec 08             	sub    $0x8,%esp
  8007e7:	ff 75 0c             	pushl  0xc(%ebp)
  8007ea:	50                   	push   %eax
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	ff d0                	call   *%eax
  8007f0:	83 c4 10             	add    $0x10,%esp
}
  8007f3:	90                   	nop
  8007f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    

008007f9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800800:	7e 1c                	jle    80081e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	8b 00                	mov    (%eax),%eax
  800807:	8d 50 08             	lea    0x8(%eax),%edx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	89 10                	mov    %edx,(%eax)
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	83 e8 08             	sub    $0x8,%eax
  800817:	8b 50 04             	mov    0x4(%eax),%edx
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	eb 40                	jmp    80085e <getuint+0x65>
	else if (lflag)
  80081e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800822:	74 1e                	je     800842 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 00                	mov    (%eax),%eax
  800829:	8d 50 04             	lea    0x4(%eax),%edx
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	89 10                	mov    %edx,(%eax)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	8b 00                	mov    (%eax),%eax
  800836:	83 e8 04             	sub    $0x4,%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	ba 00 00 00 00       	mov    $0x0,%edx
  800840:	eb 1c                	jmp    80085e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	8b 00                	mov    (%eax),%eax
  800847:	8d 50 04             	lea    0x4(%eax),%edx
  80084a:	8b 45 08             	mov    0x8(%ebp),%eax
  80084d:	89 10                	mov    %edx,(%eax)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	8b 00                	mov    (%eax),%eax
  800854:	83 e8 04             	sub    $0x4,%eax
  800857:	8b 00                	mov    (%eax),%eax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800863:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800867:	7e 1c                	jle    800885 <getint+0x25>
		return va_arg(*ap, long long);
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	8d 50 08             	lea    0x8(%eax),%edx
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	89 10                	mov    %edx,(%eax)
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 e8 08             	sub    $0x8,%eax
  80087e:	8b 50 04             	mov    0x4(%eax),%edx
  800881:	8b 00                	mov    (%eax),%eax
  800883:	eb 38                	jmp    8008bd <getint+0x5d>
	else if (lflag)
  800885:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800889:	74 1a                	je     8008a5 <getint+0x45>
		return va_arg(*ap, long);
  80088b:	8b 45 08             	mov    0x8(%ebp),%eax
  80088e:	8b 00                	mov    (%eax),%eax
  800890:	8d 50 04             	lea    0x4(%eax),%edx
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	89 10                	mov    %edx,(%eax)
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	8b 00                	mov    (%eax),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	99                   	cltd   
  8008a3:	eb 18                	jmp    8008bd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a8:	8b 00                	mov    (%eax),%eax
  8008aa:	8d 50 04             	lea    0x4(%eax),%edx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	89 10                	mov    %edx,(%eax)
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	83 e8 04             	sub    $0x4,%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	99                   	cltd   
}
  8008bd:	5d                   	pop    %ebp
  8008be:	c3                   	ret    

008008bf <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008bf:	55                   	push   %ebp
  8008c0:	89 e5                	mov    %esp,%ebp
  8008c2:	56                   	push   %esi
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008c7:	eb 17                	jmp    8008e0 <vprintfmt+0x21>
			if (ch == '\0')
  8008c9:	85 db                	test   %ebx,%ebx
  8008cb:	0f 84 c1 03 00 00    	je     800c92 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8008d1:	83 ec 08             	sub    $0x8,%esp
  8008d4:	ff 75 0c             	pushl  0xc(%ebp)
  8008d7:	53                   	push   %ebx
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	ff d0                	call   *%eax
  8008dd:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e3:	8d 50 01             	lea    0x1(%eax),%edx
  8008e6:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e9:	8a 00                	mov    (%eax),%al
  8008eb:	0f b6 d8             	movzbl %al,%ebx
  8008ee:	83 fb 25             	cmp    $0x25,%ebx
  8008f1:	75 d6                	jne    8008c9 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008f3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008f7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008fe:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800905:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80090c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800913:	8b 45 10             	mov    0x10(%ebp),%eax
  800916:	8d 50 01             	lea    0x1(%eax),%edx
  800919:	89 55 10             	mov    %edx,0x10(%ebp)
  80091c:	8a 00                	mov    (%eax),%al
  80091e:	0f b6 d8             	movzbl %al,%ebx
  800921:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800924:	83 f8 5b             	cmp    $0x5b,%eax
  800927:	0f 87 3d 03 00 00    	ja     800c6a <vprintfmt+0x3ab>
  80092d:	8b 04 85 38 3d 80 00 	mov    0x803d38(,%eax,4),%eax
  800934:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800936:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80093a:	eb d7                	jmp    800913 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80093c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800940:	eb d1                	jmp    800913 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800942:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800949:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80094c:	89 d0                	mov    %edx,%eax
  80094e:	c1 e0 02             	shl    $0x2,%eax
  800951:	01 d0                	add    %edx,%eax
  800953:	01 c0                	add    %eax,%eax
  800955:	01 d8                	add    %ebx,%eax
  800957:	83 e8 30             	sub    $0x30,%eax
  80095a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80095d:	8b 45 10             	mov    0x10(%ebp),%eax
  800960:	8a 00                	mov    (%eax),%al
  800962:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800965:	83 fb 2f             	cmp    $0x2f,%ebx
  800968:	7e 3e                	jle    8009a8 <vprintfmt+0xe9>
  80096a:	83 fb 39             	cmp    $0x39,%ebx
  80096d:	7f 39                	jg     8009a8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80096f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800972:	eb d5                	jmp    800949 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 c0 04             	add    $0x4,%eax
  80097a:	89 45 14             	mov    %eax,0x14(%ebp)
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	83 e8 04             	sub    $0x4,%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800988:	eb 1f                	jmp    8009a9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80098a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098e:	79 83                	jns    800913 <vprintfmt+0x54>
				width = 0;
  800990:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800997:	e9 77 ff ff ff       	jmp    800913 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80099c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009a3:	e9 6b ff ff ff       	jmp    800913 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8009a8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009a9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ad:	0f 89 60 ff ff ff    	jns    800913 <vprintfmt+0x54>
				width = precision, precision = -1;
  8009b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009b9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8009c0:	e9 4e ff ff ff       	jmp    800913 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009c5:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8009c8:	e9 46 ff ff ff       	jmp    800913 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d0:	83 c0 04             	add    $0x4,%eax
  8009d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d9:	83 e8 04             	sub    $0x4,%eax
  8009dc:	8b 00                	mov    (%eax),%eax
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	ff 75 0c             	pushl  0xc(%ebp)
  8009e4:	50                   	push   %eax
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	ff d0                	call   *%eax
  8009ea:	83 c4 10             	add    $0x10,%esp
			break;
  8009ed:	e9 9b 02 00 00       	jmp    800c8d <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 c0 04             	add    $0x4,%eax
  8009f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8009fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8009fe:	83 e8 04             	sub    $0x4,%eax
  800a01:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a03:	85 db                	test   %ebx,%ebx
  800a05:	79 02                	jns    800a09 <vprintfmt+0x14a>
				err = -err;
  800a07:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a09:	83 fb 64             	cmp    $0x64,%ebx
  800a0c:	7f 0b                	jg     800a19 <vprintfmt+0x15a>
  800a0e:	8b 34 9d 80 3b 80 00 	mov    0x803b80(,%ebx,4),%esi
  800a15:	85 f6                	test   %esi,%esi
  800a17:	75 19                	jne    800a32 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a19:	53                   	push   %ebx
  800a1a:	68 25 3d 80 00       	push   $0x803d25
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	ff 75 08             	pushl  0x8(%ebp)
  800a25:	e8 70 02 00 00       	call   800c9a <printfmt>
  800a2a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a2d:	e9 5b 02 00 00       	jmp    800c8d <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a32:	56                   	push   %esi
  800a33:	68 2e 3d 80 00       	push   $0x803d2e
  800a38:	ff 75 0c             	pushl  0xc(%ebp)
  800a3b:	ff 75 08             	pushl  0x8(%ebp)
  800a3e:	e8 57 02 00 00       	call   800c9a <printfmt>
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 42 02 00 00       	jmp    800c8d <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4e:	83 c0 04             	add    $0x4,%eax
  800a51:	89 45 14             	mov    %eax,0x14(%ebp)
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	83 e8 04             	sub    $0x4,%eax
  800a5a:	8b 30                	mov    (%eax),%esi
  800a5c:	85 f6                	test   %esi,%esi
  800a5e:	75 05                	jne    800a65 <vprintfmt+0x1a6>
				p = "(null)";
  800a60:	be 31 3d 80 00       	mov    $0x803d31,%esi
			if (width > 0 && padc != '-')
  800a65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a69:	7e 6d                	jle    800ad8 <vprintfmt+0x219>
  800a6b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a6f:	74 67                	je     800ad8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	50                   	push   %eax
  800a78:	56                   	push   %esi
  800a79:	e8 1e 03 00 00       	call   800d9c <strnlen>
  800a7e:	83 c4 10             	add    $0x10,%esp
  800a81:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a84:	eb 16                	jmp    800a9c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a86:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a8a:	83 ec 08             	sub    $0x8,%esp
  800a8d:	ff 75 0c             	pushl  0xc(%ebp)
  800a90:	50                   	push   %eax
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	ff d0                	call   *%eax
  800a96:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a99:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa0:	7f e4                	jg     800a86 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa2:	eb 34                	jmp    800ad8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800aa4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800aa8:	74 1c                	je     800ac6 <vprintfmt+0x207>
  800aaa:	83 fb 1f             	cmp    $0x1f,%ebx
  800aad:	7e 05                	jle    800ab4 <vprintfmt+0x1f5>
  800aaf:	83 fb 7e             	cmp    $0x7e,%ebx
  800ab2:	7e 12                	jle    800ac6 <vprintfmt+0x207>
					putch('?', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 3f                	push   $0x3f
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
  800ac4:	eb 0f                	jmp    800ad5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ac6:	83 ec 08             	sub    $0x8,%esp
  800ac9:	ff 75 0c             	pushl  0xc(%ebp)
  800acc:	53                   	push   %ebx
  800acd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad0:	ff d0                	call   *%eax
  800ad2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ad5:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad8:	89 f0                	mov    %esi,%eax
  800ada:	8d 70 01             	lea    0x1(%eax),%esi
  800add:	8a 00                	mov    (%eax),%al
  800adf:	0f be d8             	movsbl %al,%ebx
  800ae2:	85 db                	test   %ebx,%ebx
  800ae4:	74 24                	je     800b0a <vprintfmt+0x24b>
  800ae6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aea:	78 b8                	js     800aa4 <vprintfmt+0x1e5>
  800aec:	ff 4d e0             	decl   -0x20(%ebp)
  800aef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800af3:	79 af                	jns    800aa4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800af5:	eb 13                	jmp    800b0a <vprintfmt+0x24b>
				putch(' ', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 20                	push   $0x20
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b07:	ff 4d e4             	decl   -0x1c(%ebp)
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7f e7                	jg     800af7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b10:	e9 78 01 00 00       	jmp    800c8d <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b15:	83 ec 08             	sub    $0x8,%esp
  800b18:	ff 75 e8             	pushl  -0x18(%ebp)
  800b1b:	8d 45 14             	lea    0x14(%ebp),%eax
  800b1e:	50                   	push   %eax
  800b1f:	e8 3c fd ff ff       	call   800860 <getint>
  800b24:	83 c4 10             	add    $0x10,%esp
  800b27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b33:	85 d2                	test   %edx,%edx
  800b35:	79 23                	jns    800b5a <vprintfmt+0x29b>
				putch('-', putdat);
  800b37:	83 ec 08             	sub    $0x8,%esp
  800b3a:	ff 75 0c             	pushl  0xc(%ebp)
  800b3d:	6a 2d                	push   $0x2d
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	ff d0                	call   *%eax
  800b44:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b4d:	f7 d8                	neg    %eax
  800b4f:	83 d2 00             	adc    $0x0,%edx
  800b52:	f7 da                	neg    %edx
  800b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b57:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b61:	e9 bc 00 00 00       	jmp    800c22 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 e8             	pushl  -0x18(%ebp)
  800b6c:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6f:	50                   	push   %eax
  800b70:	e8 84 fc ff ff       	call   8007f9 <getuint>
  800b75:	83 c4 10             	add    $0x10,%esp
  800b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b85:	e9 98 00 00 00       	jmp    800c22 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 58                	push   $0x58
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 58                	push   $0x58
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800baa:	83 ec 08             	sub    $0x8,%esp
  800bad:	ff 75 0c             	pushl  0xc(%ebp)
  800bb0:	6a 58                	push   $0x58
  800bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb5:	ff d0                	call   *%eax
  800bb7:	83 c4 10             	add    $0x10,%esp
			break;
  800bba:	e9 ce 00 00 00       	jmp    800c8d <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	6a 30                	push   $0x30
  800bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bca:	ff d0                	call   *%eax
  800bcc:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800bcf:	83 ec 08             	sub    $0x8,%esp
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	6a 78                	push   $0x78
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	ff d0                	call   *%eax
  800bdc:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800be2:	83 c0 04             	add    $0x4,%eax
  800be5:	89 45 14             	mov    %eax,0x14(%ebp)
  800be8:	8b 45 14             	mov    0x14(%ebp),%eax
  800beb:	83 e8 04             	sub    $0x4,%eax
  800bee:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bfa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c01:	eb 1f                	jmp    800c22 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c03:	83 ec 08             	sub    $0x8,%esp
  800c06:	ff 75 e8             	pushl  -0x18(%ebp)
  800c09:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0c:	50                   	push   %eax
  800c0d:	e8 e7 fb ff ff       	call   8007f9 <getuint>
  800c12:	83 c4 10             	add    $0x10,%esp
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c1b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c22:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c29:	83 ec 04             	sub    $0x4,%esp
  800c2c:	52                   	push   %edx
  800c2d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c30:	50                   	push   %eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	ff 75 f0             	pushl  -0x10(%ebp)
  800c37:	ff 75 0c             	pushl  0xc(%ebp)
  800c3a:	ff 75 08             	pushl  0x8(%ebp)
  800c3d:	e8 00 fb ff ff       	call   800742 <printnum>
  800c42:	83 c4 20             	add    $0x20,%esp
			break;
  800c45:	eb 46                	jmp    800c8d <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c47:	83 ec 08             	sub    $0x8,%esp
  800c4a:	ff 75 0c             	pushl  0xc(%ebp)
  800c4d:	53                   	push   %ebx
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	ff d0                	call   *%eax
  800c53:	83 c4 10             	add    $0x10,%esp
			break;
  800c56:	eb 35                	jmp    800c8d <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800c58:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800c5f:	eb 2c                	jmp    800c8d <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800c61:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800c68:	eb 23                	jmp    800c8d <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c6a:	83 ec 08             	sub    $0x8,%esp
  800c6d:	ff 75 0c             	pushl  0xc(%ebp)
  800c70:	6a 25                	push   $0x25
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	ff d0                	call   *%eax
  800c77:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c7a:	ff 4d 10             	decl   0x10(%ebp)
  800c7d:	eb 03                	jmp    800c82 <vprintfmt+0x3c3>
  800c7f:	ff 4d 10             	decl   0x10(%ebp)
  800c82:	8b 45 10             	mov    0x10(%ebp),%eax
  800c85:	48                   	dec    %eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	3c 25                	cmp    $0x25,%al
  800c8a:	75 f3                	jne    800c7f <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800c8c:	90                   	nop
		}
	}
  800c8d:	e9 35 fc ff ff       	jmp    8008c7 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c92:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c96:	5b                   	pop    %ebx
  800c97:	5e                   	pop    %esi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 04 fc ff ff       	call   8008bf <vprintfmt>
  800cbb:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800cbe:	90                   	nop
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	8b 40 08             	mov    0x8(%eax),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd0:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800cd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd6:	8b 10                	mov    (%eax),%edx
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	8b 40 04             	mov    0x4(%eax),%eax
  800cde:	39 c2                	cmp    %eax,%edx
  800ce0:	73 12                	jae    800cf4 <sprintputch+0x33>
		*b->buf++ = ch;
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	8d 48 01             	lea    0x1(%eax),%ecx
  800cea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ced:	89 0a                	mov    %ecx,(%edx)
  800cef:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf2:	88 10                	mov    %dl,(%eax)
}
  800cf4:	90                   	nop
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	01 d0                	add    %edx,%eax
  800d0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d1c:	74 06                	je     800d24 <vsnprintf+0x2d>
  800d1e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d22:	7f 07                	jg     800d2b <vsnprintf+0x34>
		return -E_INVAL;
  800d24:	b8 03 00 00 00       	mov    $0x3,%eax
  800d29:	eb 20                	jmp    800d4b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d2b:	ff 75 14             	pushl  0x14(%ebp)
  800d2e:	ff 75 10             	pushl  0x10(%ebp)
  800d31:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d34:	50                   	push   %eax
  800d35:	68 c1 0c 80 00       	push   $0x800cc1
  800d3a:	e8 80 fb ff ff       	call   8008bf <vprintfmt>
  800d3f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d42:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d45:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d53:	8d 45 10             	lea    0x10(%ebp),%eax
  800d56:	83 c0 04             	add    $0x4,%eax
  800d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d62:	50                   	push   %eax
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	ff 75 08             	pushl  0x8(%ebp)
  800d69:	e8 89 ff ff ff       	call   800cf7 <vsnprintf>
  800d6e:	83 c4 10             	add    $0x10,%esp
  800d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d86:	eb 06                	jmp    800d8e <strlen+0x15>
		n++;
  800d88:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d8b:	ff 45 08             	incl   0x8(%ebp)
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	84 c0                	test   %al,%al
  800d95:	75 f1                	jne    800d88 <strlen+0xf>
		n++;
	return n;
  800d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800da2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800da9:	eb 09                	jmp    800db4 <strnlen+0x18>
		n++;
  800dab:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dae:	ff 45 08             	incl   0x8(%ebp)
  800db1:	ff 4d 0c             	decl   0xc(%ebp)
  800db4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db8:	74 09                	je     800dc3 <strnlen+0x27>
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	8a 00                	mov    (%eax),%al
  800dbf:	84 c0                	test   %al,%al
  800dc1:	75 e8                	jne    800dab <strnlen+0xf>
		n++;
	return n;
  800dc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
  800dcb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800dd4:	90                   	nop
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 08             	mov    %edx,0x8(%ebp)
  800dde:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de7:	8a 12                	mov    (%edx),%dl
  800de9:	88 10                	mov    %dl,(%eax)
  800deb:	8a 00                	mov    (%eax),%al
  800ded:	84 c0                	test   %al,%al
  800def:	75 e4                	jne    800dd5 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e09:	eb 1f                	jmp    800e2a <strncpy+0x34>
		*dst++ = *src;
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8d 50 01             	lea    0x1(%eax),%edx
  800e11:	89 55 08             	mov    %edx,0x8(%ebp)
  800e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e17:	8a 12                	mov    (%edx),%dl
  800e19:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	74 03                	je     800e27 <strncpy+0x31>
			src++;
  800e24:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e27:	ff 45 fc             	incl   -0x4(%ebp)
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e30:	72 d9                	jb     800e0b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e35:	c9                   	leave  
  800e36:	c3                   	ret    

00800e37 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e47:	74 30                	je     800e79 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e49:	eb 16                	jmp    800e61 <strlcpy+0x2a>
			*dst++ = *src++;
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8d 50 01             	lea    0x1(%eax),%edx
  800e51:	89 55 08             	mov    %edx,0x8(%ebp)
  800e54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e57:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e61:	ff 4d 10             	decl   0x10(%ebp)
  800e64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e68:	74 09                	je     800e73 <strlcpy+0x3c>
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	8a 00                	mov    (%eax),%al
  800e6f:	84 c0                	test   %al,%al
  800e71:	75 d8                	jne    800e4b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7f:	29 c2                	sub    %eax,%edx
  800e81:	89 d0                	mov    %edx,%eax
}
  800e83:	c9                   	leave  
  800e84:	c3                   	ret    

00800e85 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e88:	eb 06                	jmp    800e90 <strcmp+0xb>
		p++, q++;
  800e8a:	ff 45 08             	incl   0x8(%ebp)
  800e8d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e90:	8b 45 08             	mov    0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	84 c0                	test   %al,%al
  800e97:	74 0e                	je     800ea7 <strcmp+0x22>
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	38 c2                	cmp    %al,%dl
  800ea5:	74 e3                	je     800e8a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 d0             	movzbl %al,%edx
  800eaf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb2:	8a 00                	mov    (%eax),%al
  800eb4:	0f b6 c0             	movzbl %al,%eax
  800eb7:	29 c2                	sub    %eax,%edx
  800eb9:	89 d0                	mov    %edx,%eax
}
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ec0:	eb 09                	jmp    800ecb <strncmp+0xe>
		n--, p++, q++;
  800ec2:	ff 4d 10             	decl   0x10(%ebp)
  800ec5:	ff 45 08             	incl   0x8(%ebp)
  800ec8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ecb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecf:	74 17                	je     800ee8 <strncmp+0x2b>
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	84 c0                	test   %al,%al
  800ed8:	74 0e                	je     800ee8 <strncmp+0x2b>
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	8a 10                	mov    (%eax),%dl
  800edf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee2:	8a 00                	mov    (%eax),%al
  800ee4:	38 c2                	cmp    %al,%dl
  800ee6:	74 da                	je     800ec2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eec:	75 07                	jne    800ef5 <strncmp+0x38>
		return 0;
  800eee:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef3:	eb 14                	jmp    800f09 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 d0             	movzbl %al,%edx
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 c0             	movzbl %al,%eax
  800f05:	29 c2                	sub    %eax,%edx
  800f07:	89 d0                	mov    %edx,%eax
}
  800f09:	5d                   	pop    %ebp
  800f0a:	c3                   	ret    

00800f0b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 04             	sub    $0x4,%esp
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f17:	eb 12                	jmp    800f2b <strchr+0x20>
		if (*s == c)
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f21:	75 05                	jne    800f28 <strchr+0x1d>
			return (char *) s;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	eb 11                	jmp    800f39 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f28:	ff 45 08             	incl   0x8(%ebp)
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	84 c0                	test   %al,%al
  800f32:	75 e5                	jne    800f19 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 04             	sub    $0x4,%esp
  800f41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f44:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f47:	eb 0d                	jmp    800f56 <strfind+0x1b>
		if (*s == c)
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f51:	74 0e                	je     800f61 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f53:	ff 45 08             	incl   0x8(%ebp)
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	84 c0                	test   %al,%al
  800f5d:	75 ea                	jne    800f49 <strfind+0xe>
  800f5f:	eb 01                	jmp    800f62 <strfind+0x27>
		if (*s == c)
			break;
  800f61:	90                   	nop
	return (char *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f73:	8b 45 10             	mov    0x10(%ebp),%eax
  800f76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f79:	eb 0e                	jmp    800f89 <memset+0x22>
		*p++ = c;
  800f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f7e:	8d 50 01             	lea    0x1(%eax),%edx
  800f81:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f87:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f89:	ff 4d f8             	decl   -0x8(%ebp)
  800f8c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f90:	79 e9                	jns    800f7b <memset+0x14>
		*p++ = c;

	return v;
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f95:	c9                   	leave  
  800f96:	c3                   	ret    

00800f97 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fa9:	eb 16                	jmp    800fc1 <memcpy+0x2a>
		*d++ = *s++;
  800fab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fae:	8d 50 01             	lea    0x1(%eax),%edx
  800fb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fbd:	8a 12                	mov    (%edx),%dl
  800fbf:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800fc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	75 dd                	jne    800fab <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd1:	c9                   	leave  
  800fd2:	c3                   	ret    

00800fd3 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800feb:	73 50                	jae    80103d <memmove+0x6a>
  800fed:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ff0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff3:	01 d0                	add    %edx,%eax
  800ff5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ff8:	76 43                	jbe    80103d <memmove+0x6a>
		s += n;
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801000:	8b 45 10             	mov    0x10(%ebp),%eax
  801003:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801006:	eb 10                	jmp    801018 <memmove+0x45>
			*--d = *--s;
  801008:	ff 4d f8             	decl   -0x8(%ebp)
  80100b:	ff 4d fc             	decl   -0x4(%ebp)
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8a 10                	mov    (%eax),%dl
  801013:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801016:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101e:	89 55 10             	mov    %edx,0x10(%ebp)
  801021:	85 c0                	test   %eax,%eax
  801023:	75 e3                	jne    801008 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801025:	eb 23                	jmp    80104a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	8d 50 01             	lea    0x1(%eax),%edx
  80102d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801030:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801033:	8d 4a 01             	lea    0x1(%edx),%ecx
  801036:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801039:	8a 12                	mov    (%edx),%dl
  80103b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80103d:	8b 45 10             	mov    0x10(%ebp),%eax
  801040:	8d 50 ff             	lea    -0x1(%eax),%edx
  801043:	89 55 10             	mov    %edx,0x10(%ebp)
  801046:	85 c0                	test   %eax,%eax
  801048:	75 dd                	jne    801027 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801061:	eb 2a                	jmp    80108d <memcmp+0x3e>
		if (*s1 != *s2)
  801063:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801066:	8a 10                	mov    (%eax),%dl
  801068:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106b:	8a 00                	mov    (%eax),%al
  80106d:	38 c2                	cmp    %al,%dl
  80106f:	74 16                	je     801087 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801071:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	0f b6 d0             	movzbl %al,%edx
  801079:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	0f b6 c0             	movzbl %al,%eax
  801081:	29 c2                	sub    %eax,%edx
  801083:	89 d0                	mov    %edx,%eax
  801085:	eb 18                	jmp    80109f <memcmp+0x50>
		s1++, s2++;
  801087:	ff 45 fc             	incl   -0x4(%ebp)
  80108a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	8d 50 ff             	lea    -0x1(%eax),%edx
  801093:	89 55 10             	mov    %edx,0x10(%ebp)
  801096:	85 c0                	test   %eax,%eax
  801098:	75 c9                	jne    801063 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80109a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	01 d0                	add    %edx,%eax
  8010af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010b2:	eb 15                	jmp    8010c9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	0f b6 d0             	movzbl %al,%edx
  8010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bf:	0f b6 c0             	movzbl %al,%eax
  8010c2:	39 c2                	cmp    %eax,%edx
  8010c4:	74 0d                	je     8010d3 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8010cf:	72 e3                	jb     8010b4 <memfind+0x13>
  8010d1:	eb 01                	jmp    8010d4 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8010d3:	90                   	nop
	return (void *) s;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d7:	c9                   	leave  
  8010d8:	c3                   	ret    

008010d9 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010d9:	55                   	push   %ebp
  8010da:	89 e5                	mov    %esp,%ebp
  8010dc:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8010df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8010e6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ed:	eb 03                	jmp    8010f2 <strtol+0x19>
		s++;
  8010ef:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	8a 00                	mov    (%eax),%al
  8010f7:	3c 20                	cmp    $0x20,%al
  8010f9:	74 f4                	je     8010ef <strtol+0x16>
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	3c 09                	cmp    $0x9,%al
  801102:	74 eb                	je     8010ef <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	3c 2b                	cmp    $0x2b,%al
  80110b:	75 05                	jne    801112 <strtol+0x39>
		s++;
  80110d:	ff 45 08             	incl   0x8(%ebp)
  801110:	eb 13                	jmp    801125 <strtol+0x4c>
	else if (*s == '-')
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	3c 2d                	cmp    $0x2d,%al
  801119:	75 0a                	jne    801125 <strtol+0x4c>
		s++, neg = 1;
  80111b:	ff 45 08             	incl   0x8(%ebp)
  80111e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	74 06                	je     801131 <strtol+0x58>
  80112b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80112f:	75 20                	jne    801151 <strtol+0x78>
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	3c 30                	cmp    $0x30,%al
  801138:	75 17                	jne    801151 <strtol+0x78>
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
  80113d:	40                   	inc    %eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 78                	cmp    $0x78,%al
  801142:	75 0d                	jne    801151 <strtol+0x78>
		s += 2, base = 16;
  801144:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801148:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80114f:	eb 28                	jmp    801179 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801151:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801155:	75 15                	jne    80116c <strtol+0x93>
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	8a 00                	mov    (%eax),%al
  80115c:	3c 30                	cmp    $0x30,%al
  80115e:	75 0c                	jne    80116c <strtol+0x93>
		s++, base = 8;
  801160:	ff 45 08             	incl   0x8(%ebp)
  801163:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80116a:	eb 0d                	jmp    801179 <strtol+0xa0>
	else if (base == 0)
  80116c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801170:	75 07                	jne    801179 <strtol+0xa0>
		base = 10;
  801172:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	3c 2f                	cmp    $0x2f,%al
  801180:	7e 19                	jle    80119b <strtol+0xc2>
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 39                	cmp    $0x39,%al
  801189:	7f 10                	jg     80119b <strtol+0xc2>
			dig = *s - '0';
  80118b:	8b 45 08             	mov    0x8(%ebp),%eax
  80118e:	8a 00                	mov    (%eax),%al
  801190:	0f be c0             	movsbl %al,%eax
  801193:	83 e8 30             	sub    $0x30,%eax
  801196:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801199:	eb 42                	jmp    8011dd <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	3c 60                	cmp    $0x60,%al
  8011a2:	7e 19                	jle    8011bd <strtol+0xe4>
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	3c 7a                	cmp    $0x7a,%al
  8011ab:	7f 10                	jg     8011bd <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	0f be c0             	movsbl %al,%eax
  8011b5:	83 e8 57             	sub    $0x57,%eax
  8011b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011bb:	eb 20                	jmp    8011dd <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	3c 40                	cmp    $0x40,%al
  8011c4:	7e 39                	jle    8011ff <strtol+0x126>
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	3c 5a                	cmp    $0x5a,%al
  8011cd:	7f 30                	jg     8011ff <strtol+0x126>
			dig = *s - 'A' + 10;
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	0f be c0             	movsbl %al,%eax
  8011d7:	83 e8 37             	sub    $0x37,%eax
  8011da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8011dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8011e3:	7d 19                	jge    8011fe <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8011e5:	ff 45 08             	incl   0x8(%ebp)
  8011e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011eb:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011f9:	e9 7b ff ff ff       	jmp    801179 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011fe:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801203:	74 08                	je     80120d <strtol+0x134>
		*endptr = (char *) s;
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	8b 55 08             	mov    0x8(%ebp),%edx
  80120b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80120d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801211:	74 07                	je     80121a <strtol+0x141>
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	f7 d8                	neg    %eax
  801218:	eb 03                	jmp    80121d <strtol+0x144>
  80121a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80121d:	c9                   	leave  
  80121e:	c3                   	ret    

0080121f <ltostr>:

void
ltostr(long value, char *str)
{
  80121f:	55                   	push   %ebp
  801220:	89 e5                	mov    %esp,%ebp
  801222:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801225:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80122c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801233:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801237:	79 13                	jns    80124c <ltostr+0x2d>
	{
		neg = 1;
  801239:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801240:	8b 45 0c             	mov    0xc(%ebp),%eax
  801243:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801246:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801249:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801254:	99                   	cltd   
  801255:	f7 f9                	idiv   %ecx
  801257:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80125a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125d:	8d 50 01             	lea    0x1(%eax),%edx
  801260:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801263:	89 c2                	mov    %eax,%edx
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	01 d0                	add    %edx,%eax
  80126a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126d:	83 c2 30             	add    $0x30,%edx
  801270:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801272:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801275:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80127a:	f7 e9                	imul   %ecx
  80127c:	c1 fa 02             	sar    $0x2,%edx
  80127f:	89 c8                	mov    %ecx,%eax
  801281:	c1 f8 1f             	sar    $0x1f,%eax
  801284:	29 c2                	sub    %eax,%edx
  801286:	89 d0                	mov    %edx,%eax
  801288:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80128b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128f:	75 bb                	jne    80124c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801291:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801298:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129b:	48                   	dec    %eax
  80129c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80129f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a3:	74 3d                	je     8012e2 <ltostr+0xc3>
		start = 1 ;
  8012a5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8012ac:	eb 34                	jmp    8012e2 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8012ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b4:	01 d0                	add    %edx,%eax
  8012b6:	8a 00                	mov    (%eax),%al
  8012b8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8012bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d5:	01 c2                	add    %eax,%edx
  8012d7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012da:	88 02                	mov    %al,(%edx)
		start++ ;
  8012dc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012df:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012e8:	7c c4                	jl     8012ae <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f0:	01 d0                	add    %edx,%eax
  8012f2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012f5:	90                   	nop
  8012f6:	c9                   	leave  
  8012f7:	c3                   	ret    

008012f8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	e8 73 fa ff ff       	call   800d79 <strlen>
  801306:	83 c4 04             	add    $0x4,%esp
  801309:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80130c:	ff 75 0c             	pushl  0xc(%ebp)
  80130f:	e8 65 fa ff ff       	call   800d79 <strlen>
  801314:	83 c4 04             	add    $0x4,%esp
  801317:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80131a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801321:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801328:	eb 17                	jmp    801341 <strcconcat+0x49>
		final[s] = str1[s] ;
  80132a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132d:	8b 45 10             	mov    0x10(%ebp),%eax
  801330:	01 c2                	add    %eax,%edx
  801332:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801335:	8b 45 08             	mov    0x8(%ebp),%eax
  801338:	01 c8                	add    %ecx,%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80133e:	ff 45 fc             	incl   -0x4(%ebp)
  801341:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801344:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801347:	7c e1                	jl     80132a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801349:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801350:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801357:	eb 1f                	jmp    801378 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801359:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80135c:	8d 50 01             	lea    0x1(%eax),%edx
  80135f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801362:	89 c2                	mov    %eax,%edx
  801364:	8b 45 10             	mov    0x10(%ebp),%eax
  801367:	01 c2                	add    %eax,%edx
  801369:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 c8                	add    %ecx,%eax
  801371:	8a 00                	mov    (%eax),%al
  801373:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801375:	ff 45 f8             	incl   -0x8(%ebp)
  801378:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80137b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80137e:	7c d9                	jl     801359 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801380:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801383:	8b 45 10             	mov    0x10(%ebp),%eax
  801386:	01 d0                	add    %edx,%eax
  801388:	c6 00 00             	movb   $0x0,(%eax)
}
  80138b:	90                   	nop
  80138c:	c9                   	leave  
  80138d:	c3                   	ret    

0080138e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801391:	8b 45 14             	mov    0x14(%ebp),%eax
  801394:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	8b 00                	mov    (%eax),%eax
  80139f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a9:	01 d0                	add    %edx,%eax
  8013ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013b1:	eb 0c                	jmp    8013bf <strsplit+0x31>
			*string++ = 0;
  8013b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b6:	8d 50 01             	lea    0x1(%eax),%edx
  8013b9:	89 55 08             	mov    %edx,0x8(%ebp)
  8013bc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8a 00                	mov    (%eax),%al
  8013c4:	84 c0                	test   %al,%al
  8013c6:	74 18                	je     8013e0 <strsplit+0x52>
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	0f be c0             	movsbl %al,%eax
  8013d0:	50                   	push   %eax
  8013d1:	ff 75 0c             	pushl  0xc(%ebp)
  8013d4:	e8 32 fb ff ff       	call   800f0b <strchr>
  8013d9:	83 c4 08             	add    $0x8,%esp
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	75 d3                	jne    8013b3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	84 c0                	test   %al,%al
  8013e7:	74 5a                	je     801443 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	83 f8 0f             	cmp    $0xf,%eax
  8013f1:	75 07                	jne    8013fa <strsplit+0x6c>
		{
			return 0;
  8013f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f8:	eb 66                	jmp    801460 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fd:	8b 00                	mov    (%eax),%eax
  8013ff:	8d 48 01             	lea    0x1(%eax),%ecx
  801402:	8b 55 14             	mov    0x14(%ebp),%edx
  801405:	89 0a                	mov    %ecx,(%edx)
  801407:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140e:	8b 45 10             	mov    0x10(%ebp),%eax
  801411:	01 c2                	add    %eax,%edx
  801413:	8b 45 08             	mov    0x8(%ebp),%eax
  801416:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801418:	eb 03                	jmp    80141d <strsplit+0x8f>
			string++;
  80141a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	84 c0                	test   %al,%al
  801424:	74 8b                	je     8013b1 <strsplit+0x23>
  801426:	8b 45 08             	mov    0x8(%ebp),%eax
  801429:	8a 00                	mov    (%eax),%al
  80142b:	0f be c0             	movsbl %al,%eax
  80142e:	50                   	push   %eax
  80142f:	ff 75 0c             	pushl  0xc(%ebp)
  801432:	e8 d4 fa ff ff       	call   800f0b <strchr>
  801437:	83 c4 08             	add    $0x8,%esp
  80143a:	85 c0                	test   %eax,%eax
  80143c:	74 dc                	je     80141a <strsplit+0x8c>
			string++;
	}
  80143e:	e9 6e ff ff ff       	jmp    8013b1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801443:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801444:	8b 45 14             	mov    0x14(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801450:	8b 45 10             	mov    0x10(%ebp),%eax
  801453:	01 d0                	add    %edx,%eax
  801455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80145b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801468:	83 ec 04             	sub    $0x4,%esp
  80146b:	68 a8 3e 80 00       	push   $0x803ea8
  801470:	68 3f 01 00 00       	push   $0x13f
  801475:	68 ca 3e 80 00       	push   $0x803eca
  80147a:	e8 a9 ef ff ff       	call   800428 <_panic>

0080147f <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	ff 75 08             	pushl  0x8(%ebp)
  80148b:	e8 90 0c 00 00       	call   802120 <sys_sbrk>
  801490:	83 c4 10             	add    $0x10,%esp
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80149b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80149f:	75 0a                	jne    8014ab <malloc+0x16>
		return NULL;
  8014a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a6:	e9 9e 01 00 00       	jmp    801649 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8014ab:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8014b2:	77 2c                	ja     8014e0 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8014b4:	e8 eb 0a 00 00       	call   801fa4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	74 19                	je     8014d6 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8014bd:	83 ec 0c             	sub    $0xc,%esp
  8014c0:	ff 75 08             	pushl  0x8(%ebp)
  8014c3:	e8 85 11 00 00       	call   80264d <alloc_block_FF>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8014ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014d1:	e9 73 01 00 00       	jmp    801649 <malloc+0x1b4>
		} else {
			return NULL;
  8014d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014db:	e9 69 01 00 00       	jmp    801649 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8014e0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8014e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ed:	01 d0                	add    %edx,%eax
  8014ef:	48                   	dec    %eax
  8014f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8014f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fb:	f7 75 e0             	divl   -0x20(%ebp)
  8014fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801501:	29 d0                	sub    %edx,%eax
  801503:	c1 e8 0c             	shr    $0xc,%eax
  801506:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801509:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801510:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801517:	a1 20 50 80 00       	mov    0x805020,%eax
  80151c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80151f:	05 00 10 00 00       	add    $0x1000,%eax
  801524:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801527:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80152c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80152f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801532:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801539:	8b 55 08             	mov    0x8(%ebp),%edx
  80153c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80153f:	01 d0                	add    %edx,%eax
  801541:	48                   	dec    %eax
  801542:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801545:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801548:	ba 00 00 00 00       	mov    $0x0,%edx
  80154d:	f7 75 cc             	divl   -0x34(%ebp)
  801550:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801553:	29 d0                	sub    %edx,%eax
  801555:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801558:	76 0a                	jbe    801564 <malloc+0xcf>
		return NULL;
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
  80155f:	e9 e5 00 00 00       	jmp    801649 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801567:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80156a:	eb 48                	jmp    8015b4 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80156c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801572:	c1 e8 0c             	shr    $0xc,%eax
  801575:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801578:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80157b:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801582:	85 c0                	test   %eax,%eax
  801584:	75 11                	jne    801597 <malloc+0x102>
			freePagesCount++;
  801586:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801589:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80158d:	75 16                	jne    8015a5 <malloc+0x110>
				start = i;
  80158f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801595:	eb 0e                	jmp    8015a5 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80159e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8015ab:	74 12                	je     8015bf <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8015ad:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8015b4:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8015bb:	76 af                	jbe    80156c <malloc+0xd7>
  8015bd:	eb 01                	jmp    8015c0 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8015bf:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8015c0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8015c4:	74 08                	je     8015ce <malloc+0x139>
  8015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8015cc:	74 07                	je     8015d5 <malloc+0x140>
		return NULL;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d3:	eb 74                	jmp    801649 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8015d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8015db:	c1 e8 0c             	shr    $0xc,%eax
  8015de:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  8015e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015e4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015e7:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8015ee:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8015f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015f4:	eb 11                	jmp    801607 <malloc+0x172>
		markedPages[i] = 1;
  8015f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f9:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801600:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801604:	ff 45 e8             	incl   -0x18(%ebp)
  801607:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80160a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80160d:	01 d0                	add    %edx,%eax
  80160f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801612:	77 e2                	ja     8015f6 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801614:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80161b:	8b 55 08             	mov    0x8(%ebp),%edx
  80161e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801621:	01 d0                	add    %edx,%eax
  801623:	48                   	dec    %eax
  801624:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801627:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80162a:	ba 00 00 00 00       	mov    $0x0,%edx
  80162f:	f7 75 bc             	divl   -0x44(%ebp)
  801632:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801635:	29 d0                	sub    %edx,%eax
  801637:	83 ec 08             	sub    $0x8,%esp
  80163a:	50                   	push   %eax
  80163b:	ff 75 f0             	pushl  -0x10(%ebp)
  80163e:	e8 14 0b 00 00       	call   802157 <sys_allocate_user_mem>
  801643:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801651:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801655:	0f 84 ee 00 00 00    	je     801749 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80165b:	a1 20 50 80 00       	mov    0x805020,%eax
  801660:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801663:	3b 45 08             	cmp    0x8(%ebp),%eax
  801666:	77 09                	ja     801671 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801668:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  80166f:	76 14                	jbe    801685 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	68 d8 3e 80 00       	push   $0x803ed8
  801679:	6a 68                	push   $0x68
  80167b:	68 f2 3e 80 00       	push   $0x803ef2
  801680:	e8 a3 ed ff ff       	call   800428 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801685:	a1 20 50 80 00       	mov    0x805020,%eax
  80168a:	8b 40 74             	mov    0x74(%eax),%eax
  80168d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801690:	77 20                	ja     8016b2 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801692:	a1 20 50 80 00       	mov    0x805020,%eax
  801697:	8b 40 78             	mov    0x78(%eax),%eax
  80169a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80169d:	76 13                	jbe    8016b2 <free+0x67>
		free_block(virtual_address);
  80169f:	83 ec 0c             	sub    $0xc,%esp
  8016a2:	ff 75 08             	pushl  0x8(%ebp)
  8016a5:	e8 6c 16 00 00       	call   802d16 <free_block>
  8016aa:	83 c4 10             	add    $0x10,%esp
		return;
  8016ad:	e9 98 00 00 00       	jmp    80174a <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8016b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8016b5:	a1 20 50 80 00       	mov    0x805020,%eax
  8016ba:	8b 40 7c             	mov    0x7c(%eax),%eax
  8016bd:	29 c2                	sub    %eax,%edx
  8016bf:	89 d0                	mov    %edx,%eax
  8016c1:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8016c6:	c1 e8 0c             	shr    $0xc,%eax
  8016c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8016cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8016d3:	eb 16                	jmp    8016eb <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  8016d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  8016e4:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8016e8:	ff 45 f4             	incl   -0xc(%ebp)
  8016eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ee:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8016f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016f8:	7f db                	jg     8016d5 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8016fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fd:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801704:	c1 e0 0c             	shl    $0xc,%eax
  801707:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80170a:	8b 45 08             	mov    0x8(%ebp),%eax
  80170d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801710:	eb 1a                	jmp    80172c <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801712:	83 ec 08             	sub    $0x8,%esp
  801715:	68 00 10 00 00       	push   $0x1000
  80171a:	ff 75 f0             	pushl  -0x10(%ebp)
  80171d:	e8 19 0a 00 00       	call   80213b <sys_free_user_mem>
  801722:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801725:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80172c:	8b 55 08             	mov    0x8(%ebp),%edx
  80172f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801732:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801734:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801737:	77 d9                	ja     801712 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801739:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80173c:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801743:	00 00 00 00 
  801747:	eb 01                	jmp    80174a <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801749:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 58             	sub    $0x58,%esp
  801752:	8b 45 10             	mov    0x10(%ebp),%eax
  801755:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801758:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80175c:	75 0a                	jne    801768 <smalloc+0x1c>
		return NULL;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	e9 7d 01 00 00       	jmp    8018e5 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801768:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80176f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801772:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	48                   	dec    %eax
  801778:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80177b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80177e:	ba 00 00 00 00       	mov    $0x0,%edx
  801783:	f7 75 e4             	divl   -0x1c(%ebp)
  801786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801789:	29 d0                	sub    %edx,%eax
  80178b:	c1 e8 0c             	shr    $0xc,%eax
  80178e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801791:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801798:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  80179f:	a1 20 50 80 00       	mov    0x805020,%eax
  8017a4:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017a7:	05 00 10 00 00       	add    $0x1000,%eax
  8017ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8017af:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017b4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8017ba:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8017c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8017c7:	01 d0                	add    %edx,%eax
  8017c9:	48                   	dec    %eax
  8017ca:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8017cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	f7 75 d0             	divl   -0x30(%ebp)
  8017d8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017db:	29 d0                	sub    %edx,%eax
  8017dd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  8017e0:	76 0a                	jbe    8017ec <smalloc+0xa0>
		return NULL;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e7:	e9 f9 00 00 00       	jmp    8018e5 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f2:	eb 48                	jmp    80183c <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8017f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8017fa:	c1 e8 0c             	shr    $0xc,%eax
  8017fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801800:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801803:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80180a:	85 c0                	test   %eax,%eax
  80180c:	75 11                	jne    80181f <smalloc+0xd3>
			freePagesCount++;
  80180e:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801811:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801815:	75 16                	jne    80182d <smalloc+0xe1>
				start = s;
  801817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80181d:	eb 0e                	jmp    80182d <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80181f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801826:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801833:	74 12                	je     801847 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801835:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80183c:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801843:	76 af                	jbe    8017f4 <smalloc+0xa8>
  801845:	eb 01                	jmp    801848 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801847:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801848:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80184c:	74 08                	je     801856 <smalloc+0x10a>
  80184e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801851:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801854:	74 0a                	je     801860 <smalloc+0x114>
		return NULL;
  801856:	b8 00 00 00 00       	mov    $0x0,%eax
  80185b:	e9 85 00 00 00       	jmp    8018e5 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801863:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801866:	c1 e8 0c             	shr    $0xc,%eax
  801869:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80186c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80186f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801872:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801879:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80187c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80187f:	eb 11                	jmp    801892 <smalloc+0x146>
		markedPages[s] = 1;
  801881:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801884:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80188b:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80188f:	ff 45 e8             	incl   -0x18(%ebp)
  801892:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801895:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801898:	01 d0                	add    %edx,%eax
  80189a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80189d:	77 e2                	ja     801881 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  80189f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	ff 75 0c             	pushl  0xc(%ebp)
  8018ab:	ff 75 08             	pushl  0x8(%ebp)
  8018ae:	e8 8f 04 00 00       	call   801d42 <sys_createSharedObject>
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8018b9:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8018bd:	78 12                	js     8018d1 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8018bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8018c2:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8018c5:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8018cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cf:	eb 14                	jmp    8018e5 <smalloc+0x199>
	}
	free((void*) start);
  8018d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d4:	83 ec 0c             	sub    $0xc,%esp
  8018d7:	50                   	push   %eax
  8018d8:	e8 6e fd ff ff       	call   80164b <free>
  8018dd:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  8018ed:	83 ec 08             	sub    $0x8,%esp
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	ff 75 08             	pushl  0x8(%ebp)
  8018f6:	e8 71 04 00 00       	call   801d6c <sys_getSizeOfSharedObject>
  8018fb:	83 c4 10             	add    $0x10,%esp
  8018fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801901:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801908:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80190b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80190e:	01 d0                	add    %edx,%eax
  801910:	48                   	dec    %eax
  801911:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801914:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	f7 75 e0             	divl   -0x20(%ebp)
  80191f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801922:	29 d0                	sub    %edx,%eax
  801924:	c1 e8 0c             	shr    $0xc,%eax
  801927:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80192a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801931:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801938:	a1 20 50 80 00       	mov    0x805020,%eax
  80193d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801940:	05 00 10 00 00       	add    $0x1000,%eax
  801945:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801948:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80194d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801950:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801953:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80195a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80195d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801960:	01 d0                	add    %edx,%eax
  801962:	48                   	dec    %eax
  801963:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801966:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801969:	ba 00 00 00 00       	mov    $0x0,%edx
  80196e:	f7 75 cc             	divl   -0x34(%ebp)
  801971:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801974:	29 d0                	sub    %edx,%eax
  801976:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801979:	76 0a                	jbe    801985 <sget+0x9e>
		return NULL;
  80197b:	b8 00 00 00 00       	mov    $0x0,%eax
  801980:	e9 f7 00 00 00       	jmp    801a7c <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801985:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801988:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80198b:	eb 48                	jmp    8019d5 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80198d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801990:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801993:	c1 e8 0c             	shr    $0xc,%eax
  801996:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  801999:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80199c:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8019a3:	85 c0                	test   %eax,%eax
  8019a5:	75 11                	jne    8019b8 <sget+0xd1>
			free_Pages_Count++;
  8019a7:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8019aa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019ae:	75 16                	jne    8019c6 <sget+0xdf>
				start = s;
  8019b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019b6:	eb 0e                	jmp    8019c6 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8019b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8019bf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019cc:	74 12                	je     8019e0 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8019ce:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8019d5:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8019dc:	76 af                	jbe    80198d <sget+0xa6>
  8019de:	eb 01                	jmp    8019e1 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8019e0:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8019e1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8019e5:	74 08                	je     8019ef <sget+0x108>
  8019e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ea:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8019ed:	74 0a                	je     8019f9 <sget+0x112>
		return NULL;
  8019ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8019f4:	e9 83 00 00 00       	jmp    801a7c <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fc:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8019ff:	c1 e8 0c             	shr    $0xc,%eax
  801a02:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801a05:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a08:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a0b:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801a12:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a15:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a18:	eb 11                	jmp    801a2b <sget+0x144>
		markedPages[k] = 1;
  801a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a1d:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801a24:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801a28:	ff 45 e8             	incl   -0x18(%ebp)
  801a2b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801a2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a31:	01 d0                	add    %edx,%eax
  801a33:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801a36:	77 e2                	ja     801a1a <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	50                   	push   %eax
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	ff 75 08             	pushl  0x8(%ebp)
  801a45:	e8 3f 03 00 00       	call   801d89 <sys_getSharedObject>
  801a4a:	83 c4 10             	add    $0x10,%esp
  801a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801a50:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801a54:	78 12                	js     801a68 <sget+0x181>
		shardIDs[startPage] = ss;
  801a56:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801a59:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801a5c:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a66:	eb 14                	jmp    801a7c <sget+0x195>
	}
	free((void*) start);
  801a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	50                   	push   %eax
  801a6f:	e8 d7 fb ff ff       	call   80164b <free>
  801a74:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801a84:	8b 55 08             	mov    0x8(%ebp),%edx
  801a87:	a1 20 50 80 00       	mov    0x805020,%eax
  801a8c:	8b 40 7c             	mov    0x7c(%eax),%eax
  801a8f:	29 c2                	sub    %eax,%edx
  801a91:	89 d0                	mov    %edx,%eax
  801a93:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801a98:	c1 e8 0c             	shr    $0xc,%eax
  801a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa1:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  801aab:	83 ec 08             	sub    $0x8,%esp
  801aae:	ff 75 08             	pushl  0x8(%ebp)
  801ab1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab4:	e8 ef 02 00 00       	call   801da8 <sys_freeSharedObject>
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801abf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ac3:	75 0e                	jne    801ad3 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac8:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801acf:	ff ff ff ff 
	}

}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 00 3f 80 00       	push   $0x803f00
  801ae4:	68 19 01 00 00       	push   $0x119
  801ae9:	68 f2 3e 80 00       	push   $0x803ef2
  801aee:	e8 35 e9 ff ff       	call   800428 <_panic>

00801af3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801af9:	83 ec 04             	sub    $0x4,%esp
  801afc:	68 26 3f 80 00       	push   $0x803f26
  801b01:	68 23 01 00 00       	push   $0x123
  801b06:	68 f2 3e 80 00       	push   $0x803ef2
  801b0b:	e8 18 e9 ff ff       	call   800428 <_panic>

00801b10 <shrink>:

}
void shrink(uint32 newSize) {
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b16:	83 ec 04             	sub    $0x4,%esp
  801b19:	68 26 3f 80 00       	push   $0x803f26
  801b1e:	68 27 01 00 00       	push   $0x127
  801b23:	68 f2 3e 80 00       	push   $0x803ef2
  801b28:	e8 fb e8 ff ff       	call   800428 <_panic>

00801b2d <freeHeap>:

}
void freeHeap(void* virtual_address) {
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
  801b30:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b33:	83 ec 04             	sub    $0x4,%esp
  801b36:	68 26 3f 80 00       	push   $0x803f26
  801b3b:	68 2b 01 00 00       	push   $0x12b
  801b40:	68 f2 3e 80 00       	push   $0x803ef2
  801b45:	e8 de e8 ff ff       	call   800428 <_panic>

00801b4a <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	57                   	push   %edi
  801b4e:	56                   	push   %esi
  801b4f:	53                   	push   %ebx
  801b50:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b5f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b62:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b65:	cd 30                	int    $0x30
  801b67:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	5b                   	pop    %ebx
  801b71:	5e                   	pop    %esi
  801b72:	5f                   	pop    %edi
  801b73:	5d                   	pop    %ebp
  801b74:	c3                   	ret    

00801b75 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	83 ec 04             	sub    $0x4,%esp
  801b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801b81:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	52                   	push   %edx
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	50                   	push   %eax
  801b91:	6a 00                	push   $0x0
  801b93:	e8 b2 ff ff ff       	call   801b4a <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	90                   	nop
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_cgetc>:

int sys_cgetc(void) {
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 02                	push   $0x2
  801bad:	e8 98 ff ff ff       	call   801b4a <syscall>
  801bb2:	83 c4 18             	add    $0x18,%esp
}
  801bb5:	c9                   	leave  
  801bb6:	c3                   	ret    

00801bb7 <sys_lock_cons>:

void sys_lock_cons(void) {
  801bb7:	55                   	push   %ebp
  801bb8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 03                	push   $0x3
  801bc6:	e8 7f ff ff ff       	call   801b4a <syscall>
  801bcb:	83 c4 18             	add    $0x18,%esp
}
  801bce:	90                   	nop
  801bcf:	c9                   	leave  
  801bd0:	c3                   	ret    

00801bd1 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801bd1:	55                   	push   %ebp
  801bd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 04                	push   $0x4
  801be0:	e8 65 ff ff ff       	call   801b4a <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	90                   	nop
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 08                	push   $0x8
  801bfe:	e8 47 ff ff ff       	call   801b4a <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	56                   	push   %esi
  801c0c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801c0d:	8b 75 18             	mov    0x18(%ebp),%esi
  801c10:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	56                   	push   %esi
  801c1d:	53                   	push   %ebx
  801c1e:	51                   	push   %ecx
  801c1f:	52                   	push   %edx
  801c20:	50                   	push   %eax
  801c21:	6a 09                	push   $0x9
  801c23:	e8 22 ff ff ff       	call   801b4a <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801c2b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2e:	5b                   	pop    %ebx
  801c2f:	5e                   	pop    %esi
  801c30:	5d                   	pop    %ebp
  801c31:	c3                   	ret    

00801c32 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c38:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	52                   	push   %edx
  801c42:	50                   	push   %eax
  801c43:	6a 0a                	push   $0xa
  801c45:	e8 00 ff ff ff       	call   801b4a <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	6a 0b                	push   $0xb
  801c60:	e8 e5 fe ff ff       	call   801b4a <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 0c                	push   $0xc
  801c79:	e8 cc fe ff ff       	call   801b4a <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 0d                	push   $0xd
  801c92:	e8 b3 fe ff ff       	call   801b4a <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 0e                	push   $0xe
  801cab:	e8 9a fe ff ff       	call   801b4a <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 0f                	push   $0xf
  801cc4:	e8 81 fe ff ff       	call   801b4a <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	6a 10                	push   $0x10
  801cde:	e8 67 fe ff ff       	call   801b4a <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_scarce_memory>:

void sys_scarce_memory() {
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 11                	push   $0x11
  801cf7:	e8 4e fe ff ff       	call   801b4a <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
}
  801cff:	90                   	nop
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_cputc>:

void sys_cputc(const char c) {
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d0e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	50                   	push   %eax
  801d1b:	6a 01                	push   $0x1
  801d1d:	e8 28 fe ff ff       	call   801b4a <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 14                	push   $0x14
  801d37:	e8 0e fe ff ff       	call   801b4a <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	90                   	nop
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 04             	sub    $0x4,%esp
  801d48:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801d4e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d51:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	6a 00                	push   $0x0
  801d5a:	51                   	push   %ecx
  801d5b:	52                   	push   %edx
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	50                   	push   %eax
  801d60:	6a 15                	push   $0x15
  801d62:	e8 e3 fd ff ff       	call   801b4a <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	6a 16                	push   $0x16
  801d7f:	e8 c6 fd ff ff       	call   801b4a <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801d8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	51                   	push   %ecx
  801d9a:	52                   	push   %edx
  801d9b:	50                   	push   %eax
  801d9c:	6a 17                	push   $0x17
  801d9e:	e8 a7 fd ff ff       	call   801b4a <syscall>
  801da3:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801dab:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dae:	8b 45 08             	mov    0x8(%ebp),%eax
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	52                   	push   %edx
  801db8:	50                   	push   %eax
  801db9:	6a 18                	push   $0x18
  801dbb:	e8 8a fd ff ff       	call   801b4a <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 14             	pushl  0x14(%ebp)
  801dd0:	ff 75 10             	pushl  0x10(%ebp)
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	50                   	push   %eax
  801dd7:	6a 19                	push   $0x19
  801dd9:	e8 6c fd ff ff       	call   801b4a <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_run_env>:

void sys_run_env(int32 envId) {
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801de6:	8b 45 08             	mov    0x8(%ebp),%eax
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	50                   	push   %eax
  801df2:	6a 1a                	push   $0x1a
  801df4:	e8 51 fd ff ff       	call   801b4a <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	90                   	nop
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e02:	8b 45 08             	mov    0x8(%ebp),%eax
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	50                   	push   %eax
  801e0e:	6a 1b                	push   $0x1b
  801e10:	e8 35 fd ff ff       	call   801b4a <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_getenvid>:

int32 sys_getenvid(void) {
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 05                	push   $0x5
  801e29:	e8 1c fd ff ff       	call   801b4a <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 06                	push   $0x6
  801e42:	e8 03 fd ff ff       	call   801b4a <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 07                	push   $0x7
  801e5b:	e8 ea fc ff ff       	call   801b4a <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_exit_env>:

void sys_exit_env(void) {
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 1c                	push   $0x1c
  801e74:	e8 d1 fc ff ff       	call   801b4a <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
}
  801e7c:	90                   	nop
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801e85:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e88:	8d 50 04             	lea    0x4(%eax),%edx
  801e8b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	52                   	push   %edx
  801e95:	50                   	push   %eax
  801e96:	6a 1d                	push   $0x1d
  801e98:	e8 ad fc ff ff       	call   801b4a <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801ea0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ea3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ea9:	89 01                	mov    %eax,(%ecx)
  801eab:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	c9                   	leave  
  801eb2:	c2 04 00             	ret    $0x4

00801eb5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	ff 75 10             	pushl  0x10(%ebp)
  801ebf:	ff 75 0c             	pushl  0xc(%ebp)
  801ec2:	ff 75 08             	pushl  0x8(%ebp)
  801ec5:	6a 13                	push   $0x13
  801ec7:	e8 7e fc ff ff       	call   801b4a <syscall>
  801ecc:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801ecf:	90                   	nop
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_rcr2>:
uint32 sys_rcr2() {
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 1e                	push   $0x1e
  801ee1:	e8 64 fc ff ff       	call   801b4a <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	83 ec 04             	sub    $0x4,%esp
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ef7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	50                   	push   %eax
  801f04:	6a 1f                	push   $0x1f
  801f06:	e8 3f fc ff ff       	call   801b4a <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
	return;
  801f0e:	90                   	nop
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <rsttst>:
void rsttst() {
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 21                	push   $0x21
  801f20:	e8 25 fc ff ff       	call   801b4a <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
	return;
  801f28:	90                   	nop
}
  801f29:	c9                   	leave  
  801f2a:	c3                   	ret    

00801f2b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801f2b:	55                   	push   %ebp
  801f2c:	89 e5                	mov    %esp,%ebp
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	8b 45 14             	mov    0x14(%ebp),%eax
  801f34:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f37:	8b 55 18             	mov    0x18(%ebp),%edx
  801f3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	ff 75 10             	pushl  0x10(%ebp)
  801f43:	ff 75 0c             	pushl  0xc(%ebp)
  801f46:	ff 75 08             	pushl  0x8(%ebp)
  801f49:	6a 20                	push   $0x20
  801f4b:	e8 fa fb ff ff       	call   801b4a <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
	return;
  801f53:	90                   	nop
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <chktst>:
void chktst(uint32 n) {
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	ff 75 08             	pushl  0x8(%ebp)
  801f64:	6a 22                	push   $0x22
  801f66:	e8 df fb ff ff       	call   801b4a <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
	return;
  801f6e:	90                   	nop
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <inctst>:

void inctst() {
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f74:	6a 00                	push   $0x0
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 23                	push   $0x23
  801f80:	e8 c5 fb ff ff       	call   801b4a <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
	return;
  801f88:	90                   	nop
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <gettst>:
uint32 gettst() {
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 24                	push   $0x24
  801f9a:	e8 ab fb ff ff       	call   801b4a <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 25                	push   $0x25
  801fb6:	e8 8f fb ff ff       	call   801b4a <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
  801fbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fc1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fc5:	75 07                	jne    801fce <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcc:	eb 05                	jmp    801fd3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 25                	push   $0x25
  801fe7:	e8 5e fb ff ff       	call   801b4a <syscall>
  801fec:	83 c4 18             	add    $0x18,%esp
  801fef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ff2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ff6:	75 07                	jne    801fff <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ff8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffd:	eb 05                	jmp    802004 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802004:	c9                   	leave  
  802005:	c3                   	ret    

00802006 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 25                	push   $0x25
  802018:	e8 2d fb ff ff       	call   801b4a <syscall>
  80201d:	83 c4 18             	add    $0x18,%esp
  802020:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802023:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802027:	75 07                	jne    802030 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	eb 05                	jmp    802035 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 25                	push   $0x25
  802049:	e8 fc fa ff ff       	call   801b4a <syscall>
  80204e:	83 c4 18             	add    $0x18,%esp
  802051:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802054:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802058:	75 07                	jne    802061 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80205a:	b8 01 00 00 00       	mov    $0x1,%eax
  80205f:	eb 05                	jmp    802066 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802061:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	ff 75 08             	pushl  0x8(%ebp)
  802076:	6a 26                	push   $0x26
  802078:	e8 cd fa ff ff       	call   801b4a <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
	return;
  802080:	90                   	nop
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
  802086:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  802087:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80208a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80208d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802090:	8b 45 08             	mov    0x8(%ebp),%eax
  802093:	6a 00                	push   $0x0
  802095:	53                   	push   %ebx
  802096:	51                   	push   %ecx
  802097:	52                   	push   %edx
  802098:	50                   	push   %eax
  802099:	6a 27                	push   $0x27
  80209b:	e8 aa fa ff ff       	call   801b4a <syscall>
  8020a0:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8020a3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020a6:	c9                   	leave  
  8020a7:	c3                   	ret    

008020a8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8020ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	52                   	push   %edx
  8020b8:	50                   	push   %eax
  8020b9:	6a 28                	push   $0x28
  8020bb:	e8 8a fa ff ff       	call   801b4a <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8020c8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	6a 00                	push   $0x0
  8020d3:	51                   	push   %ecx
  8020d4:	ff 75 10             	pushl  0x10(%ebp)
  8020d7:	52                   	push   %edx
  8020d8:	50                   	push   %eax
  8020d9:	6a 29                	push   $0x29
  8020db:	e8 6a fa ff ff       	call   801b4a <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	ff 75 10             	pushl  0x10(%ebp)
  8020ef:	ff 75 0c             	pushl  0xc(%ebp)
  8020f2:	ff 75 08             	pushl  0x8(%ebp)
  8020f5:	6a 12                	push   $0x12
  8020f7:	e8 4e fa ff ff       	call   801b4a <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
	return;
  8020ff:	90                   	nop
}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  802105:	8b 55 0c             	mov    0xc(%ebp),%edx
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	52                   	push   %edx
  802112:	50                   	push   %eax
  802113:	6a 2a                	push   $0x2a
  802115:	e8 30 fa ff ff       	call   801b4a <syscall>
  80211a:	83 c4 18             	add    $0x18,%esp
	return;
  80211d:	90                   	nop
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	50                   	push   %eax
  80212f:	6a 2b                	push   $0x2b
  802131:	e8 14 fa ff ff       	call   801b4a <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	ff 75 0c             	pushl  0xc(%ebp)
  802147:	ff 75 08             	pushl  0x8(%ebp)
  80214a:	6a 2c                	push   $0x2c
  80214c:	e8 f9 f9 ff ff       	call   801b4a <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
	return;
  802154:	90                   	nop
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	ff 75 0c             	pushl  0xc(%ebp)
  802163:	ff 75 08             	pushl  0x8(%ebp)
  802166:	6a 2d                	push   $0x2d
  802168:	e8 dd f9 ff ff       	call   801b4a <syscall>
  80216d:	83 c4 18             	add    $0x18,%esp
	return;
  802170:	90                   	nop
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	50                   	push   %eax
  802182:	6a 2f                	push   $0x2f
  802184:	e8 c1 f9 ff ff       	call   801b4a <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
	return;
  80218c:	90                   	nop
}
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  802192:	8b 55 0c             	mov    0xc(%ebp),%edx
  802195:	8b 45 08             	mov    0x8(%ebp),%eax
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	52                   	push   %edx
  80219f:	50                   	push   %eax
  8021a0:	6a 30                	push   $0x30
  8021a2:	e8 a3 f9 ff ff       	call   801b4a <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
	return;
  8021aa:	90                   	nop
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	50                   	push   %eax
  8021bc:	6a 31                	push   $0x31
  8021be:	e8 87 f9 ff ff       	call   801b4a <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
	return;
  8021c6:	90                   	nop
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8021cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	52                   	push   %edx
  8021d9:	50                   	push   %eax
  8021da:	6a 2e                	push   $0x2e
  8021dc:	e8 69 f9 ff ff       	call   801b4a <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
    return;
  8021e4:	90                   	nop
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	83 e8 04             	sub    $0x4,%eax
  8021f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	83 e8 04             	sub    $0x4,%eax
  80220c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80220f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	83 e0 01             	and    $0x1,%eax
  802217:	85 c0                	test   %eax,%eax
  802219:	0f 94 c0             	sete   %al
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80222b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222e:	83 f8 02             	cmp    $0x2,%eax
  802231:	74 2b                	je     80225e <alloc_block+0x40>
  802233:	83 f8 02             	cmp    $0x2,%eax
  802236:	7f 07                	jg     80223f <alloc_block+0x21>
  802238:	83 f8 01             	cmp    $0x1,%eax
  80223b:	74 0e                	je     80224b <alloc_block+0x2d>
  80223d:	eb 58                	jmp    802297 <alloc_block+0x79>
  80223f:	83 f8 03             	cmp    $0x3,%eax
  802242:	74 2d                	je     802271 <alloc_block+0x53>
  802244:	83 f8 04             	cmp    $0x4,%eax
  802247:	74 3b                	je     802284 <alloc_block+0x66>
  802249:	eb 4c                	jmp    802297 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80224b:	83 ec 0c             	sub    $0xc,%esp
  80224e:	ff 75 08             	pushl  0x8(%ebp)
  802251:	e8 f7 03 00 00       	call   80264d <alloc_block_FF>
  802256:	83 c4 10             	add    $0x10,%esp
  802259:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80225c:	eb 4a                	jmp    8022a8 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80225e:	83 ec 0c             	sub    $0xc,%esp
  802261:	ff 75 08             	pushl  0x8(%ebp)
  802264:	e8 f0 11 00 00       	call   803459 <alloc_block_NF>
  802269:	83 c4 10             	add    $0x10,%esp
  80226c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80226f:	eb 37                	jmp    8022a8 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802271:	83 ec 0c             	sub    $0xc,%esp
  802274:	ff 75 08             	pushl  0x8(%ebp)
  802277:	e8 08 08 00 00       	call   802a84 <alloc_block_BF>
  80227c:	83 c4 10             	add    $0x10,%esp
  80227f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802282:	eb 24                	jmp    8022a8 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802284:	83 ec 0c             	sub    $0xc,%esp
  802287:	ff 75 08             	pushl  0x8(%ebp)
  80228a:	e8 ad 11 00 00       	call   80343c <alloc_block_WF>
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802295:	eb 11                	jmp    8022a8 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802297:	83 ec 0c             	sub    $0xc,%esp
  80229a:	68 38 3f 80 00       	push   $0x803f38
  80229f:	e8 41 e4 ff ff       	call   8006e5 <cprintf>
  8022a4:	83 c4 10             	add    $0x10,%esp
		break;
  8022a7:	90                   	nop
	}
	return va;
  8022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
  8022b0:	53                   	push   %ebx
  8022b1:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022b4:	83 ec 0c             	sub    $0xc,%esp
  8022b7:	68 58 3f 80 00       	push   $0x803f58
  8022bc:	e8 24 e4 ff ff       	call   8006e5 <cprintf>
  8022c1:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022c4:	83 ec 0c             	sub    $0xc,%esp
  8022c7:	68 83 3f 80 00       	push   $0x803f83
  8022cc:	e8 14 e4 ff ff       	call   8006e5 <cprintf>
  8022d1:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022da:	eb 37                	jmp    802313 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022dc:	83 ec 0c             	sub    $0xc,%esp
  8022df:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e2:	e8 19 ff ff ff       	call   802200 <is_free_block>
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	0f be d8             	movsbl %al,%ebx
  8022ed:	83 ec 0c             	sub    $0xc,%esp
  8022f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8022f3:	e8 ef fe ff ff       	call   8021e7 <get_block_size>
  8022f8:	83 c4 10             	add    $0x10,%esp
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	53                   	push   %ebx
  8022ff:	50                   	push   %eax
  802300:	68 9b 3f 80 00       	push   $0x803f9b
  802305:	e8 db e3 ff ff       	call   8006e5 <cprintf>
  80230a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80230d:	8b 45 10             	mov    0x10(%ebp),%eax
  802310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802313:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802317:	74 07                	je     802320 <print_blocks_list+0x73>
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 00                	mov    (%eax),%eax
  80231e:	eb 05                	jmp    802325 <print_blocks_list+0x78>
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
  802325:	89 45 10             	mov    %eax,0x10(%ebp)
  802328:	8b 45 10             	mov    0x10(%ebp),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	75 ad                	jne    8022dc <print_blocks_list+0x2f>
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	75 a7                	jne    8022dc <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802335:	83 ec 0c             	sub    $0xc,%esp
  802338:	68 58 3f 80 00       	push   $0x803f58
  80233d:	e8 a3 e3 ff ff       	call   8006e5 <cprintf>
  802342:	83 c4 10             	add    $0x10,%esp

}
  802345:	90                   	nop
  802346:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	83 e0 01             	and    $0x1,%eax
  802357:	85 c0                	test   %eax,%eax
  802359:	74 03                	je     80235e <initialize_dynamic_allocator+0x13>
  80235b:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80235e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802362:	0f 84 f8 00 00 00    	je     802460 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802368:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  80236f:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802372:	a1 40 50 98 00       	mov    0x985040,%eax
  802377:	85 c0                	test   %eax,%eax
  802379:	0f 84 e2 00 00 00    	je     802461 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80238e:	8b 55 08             	mov    0x8(%ebp),%edx
  802391:	8b 45 0c             	mov    0xc(%ebp),%eax
  802394:	01 d0                	add    %edx,%eax
  802396:	83 e8 04             	sub    $0x4,%eax
  802399:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80239c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	83 c0 08             	add    $0x8,%eax
  8023ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8023ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b1:	83 e8 08             	sub    $0x8,%eax
  8023b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8023b7:	83 ec 04             	sub    $0x4,%esp
  8023ba:	6a 00                	push   $0x0
  8023bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8023bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8023c2:	e8 9c 00 00 00       	call   802463 <set_block_data>
  8023c7:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8023ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8023d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8023dd:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  8023e4:	00 00 00 
  8023e7:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  8023ee:	00 00 00 
  8023f1:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8023f8:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8023fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023ff:	75 17                	jne    802418 <initialize_dynamic_allocator+0xcd>
  802401:	83 ec 04             	sub    $0x4,%esp
  802404:	68 b4 3f 80 00       	push   $0x803fb4
  802409:	68 80 00 00 00       	push   $0x80
  80240e:	68 d7 3f 80 00       	push   $0x803fd7
  802413:	e8 10 e0 ff ff       	call   800428 <_panic>
  802418:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80241e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802421:	89 10                	mov    %edx,(%eax)
  802423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 0d                	je     802439 <initialize_dynamic_allocator+0xee>
  80242c:	a1 48 50 98 00       	mov    0x985048,%eax
  802431:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802434:	89 50 04             	mov    %edx,0x4(%eax)
  802437:	eb 08                	jmp    802441 <initialize_dynamic_allocator+0xf6>
  802439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802441:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802444:	a3 48 50 98 00       	mov    %eax,0x985048
  802449:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802453:	a1 54 50 98 00       	mov    0x985054,%eax
  802458:	40                   	inc    %eax
  802459:	a3 54 50 98 00       	mov    %eax,0x985054
  80245e:	eb 01                	jmp    802461 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802460:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246c:	83 e0 01             	and    $0x1,%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 03                	je     802476 <set_block_data+0x13>
	{
		totalSize++;
  802473:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802476:	8b 45 08             	mov    0x8(%ebp),%eax
  802479:	83 e8 04             	sub    $0x4,%eax
  80247c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  80247f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802482:	83 e0 fe             	and    $0xfffffffe,%eax
  802485:	89 c2                	mov    %eax,%edx
  802487:	8b 45 10             	mov    0x10(%ebp),%eax
  80248a:	83 e0 01             	and    $0x1,%eax
  80248d:	09 c2                	or     %eax,%edx
  80248f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802492:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802494:	8b 45 0c             	mov    0xc(%ebp),%eax
  802497:	8d 50 f8             	lea    -0x8(%eax),%edx
  80249a:	8b 45 08             	mov    0x8(%ebp),%eax
  80249d:	01 d0                	add    %edx,%eax
  80249f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8024a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a5:	83 e0 fe             	and    $0xfffffffe,%eax
  8024a8:	89 c2                	mov    %eax,%edx
  8024aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ad:	83 e0 01             	and    $0x1,%eax
  8024b0:	09 c2                	or     %eax,%edx
  8024b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024b5:	89 10                	mov    %edx,(%eax)
}
  8024b7:	90                   	nop
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8024c0:	a1 48 50 98 00       	mov    0x985048,%eax
  8024c5:	85 c0                	test   %eax,%eax
  8024c7:	75 68                	jne    802531 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8024c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024cd:	75 17                	jne    8024e6 <insert_sorted_in_freeList+0x2c>
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	68 b4 3f 80 00       	push   $0x803fb4
  8024d7:	68 9d 00 00 00       	push   $0x9d
  8024dc:	68 d7 3f 80 00       	push   $0x803fd7
  8024e1:	e8 42 df ff ff       	call   800428 <_panic>
  8024e6:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8024ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ef:	89 10                	mov    %edx,(%eax)
  8024f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f4:	8b 00                	mov    (%eax),%eax
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	74 0d                	je     802507 <insert_sorted_in_freeList+0x4d>
  8024fa:	a1 48 50 98 00       	mov    0x985048,%eax
  8024ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802502:	89 50 04             	mov    %edx,0x4(%eax)
  802505:	eb 08                	jmp    80250f <insert_sorted_in_freeList+0x55>
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	a3 48 50 98 00       	mov    %eax,0x985048
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802521:	a1 54 50 98 00       	mov    0x985054,%eax
  802526:	40                   	inc    %eax
  802527:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  80252c:	e9 1a 01 00 00       	jmp    80264b <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802531:	a1 48 50 98 00       	mov    0x985048,%eax
  802536:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802539:	eb 7f                	jmp    8025ba <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802541:	76 6f                	jbe    8025b2 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802547:	74 06                	je     80254f <insert_sorted_in_freeList+0x95>
  802549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80254d:	75 17                	jne    802566 <insert_sorted_in_freeList+0xac>
  80254f:	83 ec 04             	sub    $0x4,%esp
  802552:	68 f0 3f 80 00       	push   $0x803ff0
  802557:	68 a6 00 00 00       	push   $0xa6
  80255c:	68 d7 3f 80 00       	push   $0x803fd7
  802561:	e8 c2 de ff ff       	call   800428 <_panic>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 50 04             	mov    0x4(%eax),%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	89 50 04             	mov    %edx,0x4(%eax)
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802578:	89 10                	mov    %edx,(%eax)
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 04             	mov    0x4(%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 0d                	je     802591 <insert_sorted_in_freeList+0xd7>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	8b 55 08             	mov    0x8(%ebp),%edx
  80258d:	89 10                	mov    %edx,(%eax)
  80258f:	eb 08                	jmp    802599 <insert_sorted_in_freeList+0xdf>
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	a3 48 50 98 00       	mov    %eax,0x985048
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 55 08             	mov    0x8(%ebp),%edx
  80259f:	89 50 04             	mov    %edx,0x4(%eax)
  8025a2:	a1 54 50 98 00       	mov    0x985054,%eax
  8025a7:	40                   	inc    %eax
  8025a8:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  8025ad:	e9 99 00 00 00       	jmp    80264b <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8025b2:	a1 50 50 98 00       	mov    0x985050,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	74 07                	je     8025c7 <insert_sorted_in_freeList+0x10d>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	eb 05                	jmp    8025cc <insert_sorted_in_freeList+0x112>
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	a3 50 50 98 00       	mov    %eax,0x985050
  8025d1:	a1 50 50 98 00       	mov    0x985050,%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 85 5d ff ff ff    	jne    80253b <insert_sorted_in_freeList+0x81>
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e2:	0f 85 53 ff ff ff    	jne    80253b <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8025e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025ec:	75 17                	jne    802605 <insert_sorted_in_freeList+0x14b>
  8025ee:	83 ec 04             	sub    $0x4,%esp
  8025f1:	68 28 40 80 00       	push   $0x804028
  8025f6:	68 ab 00 00 00       	push   $0xab
  8025fb:	68 d7 3f 80 00       	push   $0x803fd7
  802600:	e8 23 de ff ff       	call   800428 <_panic>
  802605:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	89 50 04             	mov    %edx,0x4(%eax)
  802611:	8b 45 08             	mov    0x8(%ebp),%eax
  802614:	8b 40 04             	mov    0x4(%eax),%eax
  802617:	85 c0                	test   %eax,%eax
  802619:	74 0c                	je     802627 <insert_sorted_in_freeList+0x16d>
  80261b:	a1 4c 50 98 00       	mov    0x98504c,%eax
  802620:	8b 55 08             	mov    0x8(%ebp),%edx
  802623:	89 10                	mov    %edx,(%eax)
  802625:	eb 08                	jmp    80262f <insert_sorted_in_freeList+0x175>
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	a3 48 50 98 00       	mov    %eax,0x985048
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802640:	a1 54 50 98 00       	mov    0x985054,%eax
  802645:	40                   	inc    %eax
  802646:	a3 54 50 98 00       	mov    %eax,0x985054
}
  80264b:	c9                   	leave  
  80264c:	c3                   	ret    

0080264d <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80264d:	55                   	push   %ebp
  80264e:	89 e5                	mov    %esp,%ebp
  802650:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	83 e0 01             	and    $0x1,%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 03                	je     802660 <alloc_block_FF+0x13>
  80265d:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802660:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802664:	77 07                	ja     80266d <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802666:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80266d:	a1 40 50 98 00       	mov    0x985040,%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	75 63                	jne    8026d9 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	83 c0 10             	add    $0x10,%eax
  80267c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80267f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802686:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268c:	01 d0                	add    %edx,%eax
  80268e:	48                   	dec    %eax
  80268f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802692:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802695:	ba 00 00 00 00       	mov    $0x0,%edx
  80269a:	f7 75 ec             	divl   -0x14(%ebp)
  80269d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a0:	29 d0                	sub    %edx,%eax
  8026a2:	c1 e8 0c             	shr    $0xc,%eax
  8026a5:	83 ec 0c             	sub    $0xc,%esp
  8026a8:	50                   	push   %eax
  8026a9:	e8 d1 ed ff ff       	call   80147f <sbrk>
  8026ae:	83 c4 10             	add    $0x10,%esp
  8026b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026b4:	83 ec 0c             	sub    $0xc,%esp
  8026b7:	6a 00                	push   $0x0
  8026b9:	e8 c1 ed ff ff       	call   80147f <sbrk>
  8026be:	83 c4 10             	add    $0x10,%esp
  8026c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c7:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8026ca:	83 ec 08             	sub    $0x8,%esp
  8026cd:	50                   	push   %eax
  8026ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026d1:	e8 75 fc ff ff       	call   80234b <initialize_dynamic_allocator>
  8026d6:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8026d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026dd:	75 0a                	jne    8026e9 <alloc_block_FF+0x9c>
	{
		return NULL;
  8026df:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e4:	e9 99 03 00 00       	jmp    802a82 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8026e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ec:	83 c0 08             	add    $0x8,%eax
  8026ef:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8026f2:	a1 48 50 98 00       	mov    0x985048,%eax
  8026f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026fa:	e9 03 02 00 00       	jmp    802902 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8026ff:	83 ec 0c             	sub    $0xc,%esp
  802702:	ff 75 f4             	pushl  -0xc(%ebp)
  802705:	e8 dd fa ff ff       	call   8021e7 <get_block_size>
  80270a:	83 c4 10             	add    $0x10,%esp
  80270d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802710:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802713:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802716:	0f 82 de 01 00 00    	jb     8028fa <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80271c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80271f:	83 c0 10             	add    $0x10,%eax
  802722:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802725:	0f 87 32 01 00 00    	ja     80285d <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80272b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80272e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802731:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802734:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802737:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80273a:	01 d0                	add    %edx,%eax
  80273c:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80273f:	83 ec 04             	sub    $0x4,%esp
  802742:	6a 00                	push   $0x0
  802744:	ff 75 98             	pushl  -0x68(%ebp)
  802747:	ff 75 94             	pushl  -0x6c(%ebp)
  80274a:	e8 14 fd ff ff       	call   802463 <set_block_data>
  80274f:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802752:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802756:	74 06                	je     80275e <alloc_block_FF+0x111>
  802758:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80275c:	75 17                	jne    802775 <alloc_block_FF+0x128>
  80275e:	83 ec 04             	sub    $0x4,%esp
  802761:	68 4c 40 80 00       	push   $0x80404c
  802766:	68 de 00 00 00       	push   $0xde
  80276b:	68 d7 3f 80 00       	push   $0x803fd7
  802770:	e8 b3 dc ff ff       	call   800428 <_panic>
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	8b 10                	mov    (%eax),%edx
  80277a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80277d:	89 10                	mov    %edx,(%eax)
  80277f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	85 c0                	test   %eax,%eax
  802786:	74 0b                	je     802793 <alloc_block_FF+0x146>
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 00                	mov    (%eax),%eax
  80278d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802790:	89 50 04             	mov    %edx,0x4(%eax)
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80279e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a1:	89 50 04             	mov    %edx,0x4(%eax)
  8027a4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	75 08                	jne    8027b5 <alloc_block_FF+0x168>
  8027ad:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027b0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027b5:	a1 54 50 98 00       	mov    0x985054,%eax
  8027ba:	40                   	inc    %eax
  8027bb:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8027c0:	83 ec 04             	sub    $0x4,%esp
  8027c3:	6a 01                	push   $0x1
  8027c5:	ff 75 dc             	pushl  -0x24(%ebp)
  8027c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8027cb:	e8 93 fc ff ff       	call   802463 <set_block_data>
  8027d0:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8027d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d7:	75 17                	jne    8027f0 <alloc_block_FF+0x1a3>
  8027d9:	83 ec 04             	sub    $0x4,%esp
  8027dc:	68 80 40 80 00       	push   $0x804080
  8027e1:	68 e3 00 00 00       	push   $0xe3
  8027e6:	68 d7 3f 80 00       	push   $0x803fd7
  8027eb:	e8 38 dc ff ff       	call   800428 <_panic>
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 10                	je     802809 <alloc_block_FF+0x1bc>
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802801:	8b 52 04             	mov    0x4(%edx),%edx
  802804:	89 50 04             	mov    %edx,0x4(%eax)
  802807:	eb 0b                	jmp    802814 <alloc_block_FF+0x1c7>
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 40 04             	mov    0x4(%eax),%eax
  80280f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 40 04             	mov    0x4(%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 0f                	je     80282d <alloc_block_FF+0x1e0>
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	8b 40 04             	mov    0x4(%eax),%eax
  802824:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802827:	8b 12                	mov    (%edx),%edx
  802829:	89 10                	mov    %edx,(%eax)
  80282b:	eb 0a                	jmp    802837 <alloc_block_FF+0x1ea>
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	8b 00                	mov    (%eax),%eax
  802832:	a3 48 50 98 00       	mov    %eax,0x985048
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284a:	a1 54 50 98 00       	mov    0x985054,%eax
  80284f:	48                   	dec    %eax
  802850:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	e9 25 02 00 00       	jmp    802a82 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	6a 01                	push   $0x1
  802862:	ff 75 9c             	pushl  -0x64(%ebp)
  802865:	ff 75 f4             	pushl  -0xc(%ebp)
  802868:	e8 f6 fb ff ff       	call   802463 <set_block_data>
  80286d:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802874:	75 17                	jne    80288d <alloc_block_FF+0x240>
  802876:	83 ec 04             	sub    $0x4,%esp
  802879:	68 80 40 80 00       	push   $0x804080
  80287e:	68 eb 00 00 00       	push   $0xeb
  802883:	68 d7 3f 80 00       	push   $0x803fd7
  802888:	e8 9b db ff ff       	call   800428 <_panic>
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 00                	mov    (%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 10                	je     8028a6 <alloc_block_FF+0x259>
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 00                	mov    (%eax),%eax
  80289b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289e:	8b 52 04             	mov    0x4(%edx),%edx
  8028a1:	89 50 04             	mov    %edx,0x4(%eax)
  8028a4:	eb 0b                	jmp    8028b1 <alloc_block_FF+0x264>
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ac:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	85 c0                	test   %eax,%eax
  8028b9:	74 0f                	je     8028ca <alloc_block_FF+0x27d>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 40 04             	mov    0x4(%eax),%eax
  8028c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c4:	8b 12                	mov    (%edx),%edx
  8028c6:	89 10                	mov    %edx,(%eax)
  8028c8:	eb 0a                	jmp    8028d4 <alloc_block_FF+0x287>
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	a3 48 50 98 00       	mov    %eax,0x985048
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e7:	a1 54 50 98 00       	mov    0x985054,%eax
  8028ec:	48                   	dec    %eax
  8028ed:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	e9 88 01 00 00       	jmp    802a82 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8028fa:	a1 50 50 98 00       	mov    0x985050,%eax
  8028ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802902:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802906:	74 07                	je     80290f <alloc_block_FF+0x2c2>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	eb 05                	jmp    802914 <alloc_block_FF+0x2c7>
  80290f:	b8 00 00 00 00       	mov    $0x0,%eax
  802914:	a3 50 50 98 00       	mov    %eax,0x985050
  802919:	a1 50 50 98 00       	mov    0x985050,%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	0f 85 d9 fd ff ff    	jne    8026ff <alloc_block_FF+0xb2>
  802926:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292a:	0f 85 cf fd ff ff    	jne    8026ff <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802930:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802937:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80293a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80293d:	01 d0                	add    %edx,%eax
  80293f:	48                   	dec    %eax
  802940:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802943:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802946:	ba 00 00 00 00       	mov    $0x0,%edx
  80294b:	f7 75 d8             	divl   -0x28(%ebp)
  80294e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802951:	29 d0                	sub    %edx,%eax
  802953:	c1 e8 0c             	shr    $0xc,%eax
  802956:	83 ec 0c             	sub    $0xc,%esp
  802959:	50                   	push   %eax
  80295a:	e8 20 eb ff ff       	call   80147f <sbrk>
  80295f:	83 c4 10             	add    $0x10,%esp
  802962:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802965:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802969:	75 0a                	jne    802975 <alloc_block_FF+0x328>
		return NULL;
  80296b:	b8 00 00 00 00       	mov    $0x0,%eax
  802970:	e9 0d 01 00 00       	jmp    802a82 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802975:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802978:	83 e8 04             	sub    $0x4,%eax
  80297b:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  80297e:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802985:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802988:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80298b:	01 d0                	add    %edx,%eax
  80298d:	48                   	dec    %eax
  80298e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802991:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802994:	ba 00 00 00 00       	mov    $0x0,%edx
  802999:	f7 75 c8             	divl   -0x38(%ebp)
  80299c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80299f:	29 d0                	sub    %edx,%eax
  8029a1:	c1 e8 02             	shr    $0x2,%eax
  8029a4:	c1 e0 02             	shl    $0x2,%eax
  8029a7:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8029aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8029ad:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8029b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029b6:	83 e8 08             	sub    $0x8,%eax
  8029b9:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8029bc:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	83 e0 fe             	and    $0xfffffffe,%eax
  8029c4:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8029c7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029ca:	f7 d8                	neg    %eax
  8029cc:	89 c2                	mov    %eax,%edx
  8029ce:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029d1:	01 d0                	add    %edx,%eax
  8029d3:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8029d6:	83 ec 0c             	sub    $0xc,%esp
  8029d9:	ff 75 b8             	pushl  -0x48(%ebp)
  8029dc:	e8 1f f8 ff ff       	call   802200 <is_free_block>
  8029e1:	83 c4 10             	add    $0x10,%esp
  8029e4:	0f be c0             	movsbl %al,%eax
  8029e7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8029ea:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8029ee:	74 42                	je     802a32 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8029f0:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029f7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029fa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029fd:	01 d0                	add    %edx,%eax
  8029ff:	48                   	dec    %eax
  802a00:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a03:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a06:	ba 00 00 00 00       	mov    $0x0,%edx
  802a0b:	f7 75 b0             	divl   -0x50(%ebp)
  802a0e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a11:	29 d0                	sub    %edx,%eax
  802a13:	89 c2                	mov    %eax,%edx
  802a15:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a18:	01 d0                	add    %edx,%eax
  802a1a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802a1d:	83 ec 04             	sub    $0x4,%esp
  802a20:	6a 00                	push   $0x0
  802a22:	ff 75 a8             	pushl  -0x58(%ebp)
  802a25:	ff 75 b8             	pushl  -0x48(%ebp)
  802a28:	e8 36 fa ff ff       	call   802463 <set_block_data>
  802a2d:	83 c4 10             	add    $0x10,%esp
  802a30:	eb 42                	jmp    802a74 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802a32:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802a39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a3c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a3f:	01 d0                	add    %edx,%eax
  802a41:	48                   	dec    %eax
  802a42:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802a45:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a48:	ba 00 00 00 00       	mov    $0x0,%edx
  802a4d:	f7 75 a4             	divl   -0x5c(%ebp)
  802a50:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a53:	29 d0                	sub    %edx,%eax
  802a55:	83 ec 04             	sub    $0x4,%esp
  802a58:	6a 00                	push   $0x0
  802a5a:	50                   	push   %eax
  802a5b:	ff 75 d0             	pushl  -0x30(%ebp)
  802a5e:	e8 00 fa ff ff       	call   802463 <set_block_data>
  802a63:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802a66:	83 ec 0c             	sub    $0xc,%esp
  802a69:	ff 75 d0             	pushl  -0x30(%ebp)
  802a6c:	e8 49 fa ff ff       	call   8024ba <insert_sorted_in_freeList>
  802a71:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802a74:	83 ec 0c             	sub    $0xc,%esp
  802a77:	ff 75 08             	pushl  0x8(%ebp)
  802a7a:	e8 ce fb ff ff       	call   80264d <alloc_block_FF>
  802a7f:	83 c4 10             	add    $0x10,%esp
}
  802a82:	c9                   	leave  
  802a83:	c3                   	ret    

00802a84 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a84:	55                   	push   %ebp
  802a85:	89 e5                	mov    %esp,%ebp
  802a87:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802a8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8e:	75 0a                	jne    802a9a <alloc_block_BF+0x16>
	{
		return NULL;
  802a90:	b8 00 00 00 00       	mov    $0x0,%eax
  802a95:	e9 7a 02 00 00       	jmp    802d14 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	83 c0 08             	add    $0x8,%eax
  802aa0:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802aa3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802aaa:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ab1:	a1 48 50 98 00       	mov    0x985048,%eax
  802ab6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ab9:	eb 32                	jmp    802aed <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802abb:	ff 75 ec             	pushl  -0x14(%ebp)
  802abe:	e8 24 f7 ff ff       	call   8021e7 <get_block_size>
  802ac3:	83 c4 04             	add    $0x4,%esp
  802ac6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802acc:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802acf:	72 14                	jb     802ae5 <alloc_block_BF+0x61>
  802ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ad7:	73 0c                	jae    802ae5 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802ad9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ae5:	a1 50 50 98 00       	mov    0x985050,%eax
  802aea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802aed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af1:	74 07                	je     802afa <alloc_block_BF+0x76>
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	eb 05                	jmp    802aff <alloc_block_BF+0x7b>
  802afa:	b8 00 00 00 00       	mov    $0x0,%eax
  802aff:	a3 50 50 98 00       	mov    %eax,0x985050
  802b04:	a1 50 50 98 00       	mov    0x985050,%eax
  802b09:	85 c0                	test   %eax,%eax
  802b0b:	75 ae                	jne    802abb <alloc_block_BF+0x37>
  802b0d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b11:	75 a8                	jne    802abb <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b17:	75 22                	jne    802b3b <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802b19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1c:	83 ec 0c             	sub    $0xc,%esp
  802b1f:	50                   	push   %eax
  802b20:	e8 5a e9 ff ff       	call   80147f <sbrk>
  802b25:	83 c4 10             	add    $0x10,%esp
  802b28:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802b2b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802b2f:	75 0a                	jne    802b3b <alloc_block_BF+0xb7>
			return NULL;
  802b31:	b8 00 00 00 00       	mov    $0x0,%eax
  802b36:	e9 d9 01 00 00       	jmp    802d14 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802b3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b3e:	83 c0 10             	add    $0x10,%eax
  802b41:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b44:	0f 87 32 01 00 00    	ja     802c7c <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802b4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4d:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b50:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b59:	01 d0                	add    %edx,%eax
  802b5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802b5e:	83 ec 04             	sub    $0x4,%esp
  802b61:	6a 00                	push   $0x0
  802b63:	ff 75 dc             	pushl  -0x24(%ebp)
  802b66:	ff 75 d8             	pushl  -0x28(%ebp)
  802b69:	e8 f5 f8 ff ff       	call   802463 <set_block_data>
  802b6e:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802b71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b75:	74 06                	je     802b7d <alloc_block_BF+0xf9>
  802b77:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b7b:	75 17                	jne    802b94 <alloc_block_BF+0x110>
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	68 4c 40 80 00       	push   $0x80404c
  802b85:	68 49 01 00 00       	push   $0x149
  802b8a:	68 d7 3f 80 00       	push   $0x803fd7
  802b8f:	e8 94 d8 ff ff       	call   800428 <_panic>
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 10                	mov    (%eax),%edx
  802b99:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b9c:	89 10                	mov    %edx,(%eax)
  802b9e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	74 0b                	je     802bb2 <alloc_block_BF+0x12e>
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802baf:	89 50 04             	mov    %edx,0x4(%eax)
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802bb8:	89 10                	mov    %edx,(%eax)
  802bba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc0:	89 50 04             	mov    %edx,0x4(%eax)
  802bc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bc6:	8b 00                	mov    (%eax),%eax
  802bc8:	85 c0                	test   %eax,%eax
  802bca:	75 08                	jne    802bd4 <alloc_block_BF+0x150>
  802bcc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bcf:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bd4:	a1 54 50 98 00       	mov    0x985054,%eax
  802bd9:	40                   	inc    %eax
  802bda:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	6a 01                	push   $0x1
  802be4:	ff 75 e8             	pushl  -0x18(%ebp)
  802be7:	ff 75 f4             	pushl  -0xc(%ebp)
  802bea:	e8 74 f8 ff ff       	call   802463 <set_block_data>
  802bef:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	75 17                	jne    802c0f <alloc_block_BF+0x18b>
  802bf8:	83 ec 04             	sub    $0x4,%esp
  802bfb:	68 80 40 80 00       	push   $0x804080
  802c00:	68 4e 01 00 00       	push   $0x14e
  802c05:	68 d7 3f 80 00       	push   $0x803fd7
  802c0a:	e8 19 d8 ff ff       	call   800428 <_panic>
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	8b 00                	mov    (%eax),%eax
  802c14:	85 c0                	test   %eax,%eax
  802c16:	74 10                	je     802c28 <alloc_block_BF+0x1a4>
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 00                	mov    (%eax),%eax
  802c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c20:	8b 52 04             	mov    0x4(%edx),%edx
  802c23:	89 50 04             	mov    %edx,0x4(%eax)
  802c26:	eb 0b                	jmp    802c33 <alloc_block_BF+0x1af>
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	8b 40 04             	mov    0x4(%eax),%eax
  802c2e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 40 04             	mov    0x4(%eax),%eax
  802c39:	85 c0                	test   %eax,%eax
  802c3b:	74 0f                	je     802c4c <alloc_block_BF+0x1c8>
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c46:	8b 12                	mov    (%edx),%edx
  802c48:	89 10                	mov    %edx,(%eax)
  802c4a:	eb 0a                	jmp    802c56 <alloc_block_BF+0x1d2>
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	a3 48 50 98 00       	mov    %eax,0x985048
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c69:	a1 54 50 98 00       	mov    0x985054,%eax
  802c6e:	48                   	dec    %eax
  802c6f:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	e9 98 00 00 00       	jmp    802d14 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802c7c:	83 ec 04             	sub    $0x4,%esp
  802c7f:	6a 01                	push   $0x1
  802c81:	ff 75 f0             	pushl  -0x10(%ebp)
  802c84:	ff 75 f4             	pushl  -0xc(%ebp)
  802c87:	e8 d7 f7 ff ff       	call   802463 <set_block_data>
  802c8c:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c93:	75 17                	jne    802cac <alloc_block_BF+0x228>
  802c95:	83 ec 04             	sub    $0x4,%esp
  802c98:	68 80 40 80 00       	push   $0x804080
  802c9d:	68 56 01 00 00       	push   $0x156
  802ca2:	68 d7 3f 80 00       	push   $0x803fd7
  802ca7:	e8 7c d7 ff ff       	call   800428 <_panic>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 00                	mov    (%eax),%eax
  802cb1:	85 c0                	test   %eax,%eax
  802cb3:	74 10                	je     802cc5 <alloc_block_BF+0x241>
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cbd:	8b 52 04             	mov    0x4(%edx),%edx
  802cc0:	89 50 04             	mov    %edx,0x4(%eax)
  802cc3:	eb 0b                	jmp    802cd0 <alloc_block_BF+0x24c>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 04             	mov    0x4(%eax),%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	74 0f                	je     802ce9 <alloc_block_BF+0x265>
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce3:	8b 12                	mov    (%edx),%edx
  802ce5:	89 10                	mov    %edx,(%eax)
  802ce7:	eb 0a                	jmp    802cf3 <alloc_block_BF+0x26f>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	a3 48 50 98 00       	mov    %eax,0x985048
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d06:	a1 54 50 98 00       	mov    0x985054,%eax
  802d0b:	48                   	dec    %eax
  802d0c:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802d14:	c9                   	leave  
  802d15:	c3                   	ret    

00802d16 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d16:	55                   	push   %ebp
  802d17:	89 e5                	mov    %esp,%ebp
  802d19:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802d1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d20:	0f 84 6a 02 00 00    	je     802f90 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802d26:	ff 75 08             	pushl  0x8(%ebp)
  802d29:	e8 b9 f4 ff ff       	call   8021e7 <get_block_size>
  802d2e:	83 c4 04             	add    $0x4,%esp
  802d31:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	83 e8 08             	sub    $0x8,%eax
  802d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	83 e0 fe             	and    $0xfffffffe,%eax
  802d45:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802d48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4b:	f7 d8                	neg    %eax
  802d4d:	89 c2                	mov    %eax,%edx
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	01 d0                	add    %edx,%eax
  802d54:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802d57:	ff 75 e8             	pushl  -0x18(%ebp)
  802d5a:	e8 a1 f4 ff ff       	call   802200 <is_free_block>
  802d5f:	83 c4 04             	add    $0x4,%esp
  802d62:	0f be c0             	movsbl %al,%eax
  802d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802d68:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6e:	01 d0                	add    %edx,%eax
  802d70:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802d73:	ff 75 e0             	pushl  -0x20(%ebp)
  802d76:	e8 85 f4 ff ff       	call   802200 <is_free_block>
  802d7b:	83 c4 04             	add    $0x4,%esp
  802d7e:	0f be c0             	movsbl %al,%eax
  802d81:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802d84:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d88:	75 34                	jne    802dbe <free_block+0xa8>
  802d8a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d8e:	75 2e                	jne    802dbe <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802d90:	ff 75 e8             	pushl  -0x18(%ebp)
  802d93:	e8 4f f4 ff ff       	call   8021e7 <get_block_size>
  802d98:	83 c4 04             	add    $0x4,%esp
  802d9b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802d9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802da4:	01 d0                	add    %edx,%eax
  802da6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802da9:	6a 00                	push   $0x0
  802dab:	ff 75 d4             	pushl  -0x2c(%ebp)
  802dae:	ff 75 e8             	pushl  -0x18(%ebp)
  802db1:	e8 ad f6 ff ff       	call   802463 <set_block_data>
  802db6:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802db9:	e9 d3 01 00 00       	jmp    802f91 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802dbe:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802dc2:	0f 85 c8 00 00 00    	jne    802e90 <free_block+0x17a>
  802dc8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dcc:	0f 85 be 00 00 00    	jne    802e90 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802dd2:	ff 75 e0             	pushl  -0x20(%ebp)
  802dd5:	e8 0d f4 ff ff       	call   8021e7 <get_block_size>
  802dda:	83 c4 04             	add    $0x4,%esp
  802ddd:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802de6:	01 d0                	add    %edx,%eax
  802de8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802deb:	6a 00                	push   $0x0
  802ded:	ff 75 cc             	pushl  -0x34(%ebp)
  802df0:	ff 75 08             	pushl  0x8(%ebp)
  802df3:	e8 6b f6 ff ff       	call   802463 <set_block_data>
  802df8:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802dfb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dff:	75 17                	jne    802e18 <free_block+0x102>
  802e01:	83 ec 04             	sub    $0x4,%esp
  802e04:	68 80 40 80 00       	push   $0x804080
  802e09:	68 87 01 00 00       	push   $0x187
  802e0e:	68 d7 3f 80 00       	push   $0x803fd7
  802e13:	e8 10 d6 ff ff       	call   800428 <_panic>
  802e18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	85 c0                	test   %eax,%eax
  802e1f:	74 10                	je     802e31 <free_block+0x11b>
  802e21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e24:	8b 00                	mov    (%eax),%eax
  802e26:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e29:	8b 52 04             	mov    0x4(%edx),%edx
  802e2c:	89 50 04             	mov    %edx,0x4(%eax)
  802e2f:	eb 0b                	jmp    802e3c <free_block+0x126>
  802e31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e3f:	8b 40 04             	mov    0x4(%eax),%eax
  802e42:	85 c0                	test   %eax,%eax
  802e44:	74 0f                	je     802e55 <free_block+0x13f>
  802e46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e4f:	8b 12                	mov    (%edx),%edx
  802e51:	89 10                	mov    %edx,(%eax)
  802e53:	eb 0a                	jmp    802e5f <free_block+0x149>
  802e55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e58:	8b 00                	mov    (%eax),%eax
  802e5a:	a3 48 50 98 00       	mov    %eax,0x985048
  802e5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e72:	a1 54 50 98 00       	mov    0x985054,%eax
  802e77:	48                   	dec    %eax
  802e78:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e7d:	83 ec 0c             	sub    $0xc,%esp
  802e80:	ff 75 08             	pushl  0x8(%ebp)
  802e83:	e8 32 f6 ff ff       	call   8024ba <insert_sorted_in_freeList>
  802e88:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802e8b:	e9 01 01 00 00       	jmp    802f91 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802e90:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e94:	0f 85 d3 00 00 00    	jne    802f6d <free_block+0x257>
  802e9a:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e9e:	0f 85 c9 00 00 00    	jne    802f6d <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802ea4:	83 ec 0c             	sub    $0xc,%esp
  802ea7:	ff 75 e8             	pushl  -0x18(%ebp)
  802eaa:	e8 38 f3 ff ff       	call   8021e7 <get_block_size>
  802eaf:	83 c4 10             	add    $0x10,%esp
  802eb2:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802eb5:	83 ec 0c             	sub    $0xc,%esp
  802eb8:	ff 75 e0             	pushl  -0x20(%ebp)
  802ebb:	e8 27 f3 ff ff       	call   8021e7 <get_block_size>
  802ec0:	83 c4 10             	add    $0x10,%esp
  802ec3:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ecc:	01 c2                	add    %eax,%edx
  802ece:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ed1:	01 d0                	add    %edx,%eax
  802ed3:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	6a 00                	push   $0x0
  802edb:	ff 75 c0             	pushl  -0x40(%ebp)
  802ede:	ff 75 e8             	pushl  -0x18(%ebp)
  802ee1:	e8 7d f5 ff ff       	call   802463 <set_block_data>
  802ee6:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802ee9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802eed:	75 17                	jne    802f06 <free_block+0x1f0>
  802eef:	83 ec 04             	sub    $0x4,%esp
  802ef2:	68 80 40 80 00       	push   $0x804080
  802ef7:	68 94 01 00 00       	push   $0x194
  802efc:	68 d7 3f 80 00       	push   $0x803fd7
  802f01:	e8 22 d5 ff ff       	call   800428 <_panic>
  802f06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 10                	je     802f1f <free_block+0x209>
  802f0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f17:	8b 52 04             	mov    0x4(%edx),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%eax)
  802f1d:	eb 0b                	jmp    802f2a <free_block+0x214>
  802f1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f22:	8b 40 04             	mov    0x4(%eax),%eax
  802f25:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f2d:	8b 40 04             	mov    0x4(%eax),%eax
  802f30:	85 c0                	test   %eax,%eax
  802f32:	74 0f                	je     802f43 <free_block+0x22d>
  802f34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f37:	8b 40 04             	mov    0x4(%eax),%eax
  802f3a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f3d:	8b 12                	mov    (%edx),%edx
  802f3f:	89 10                	mov    %edx,(%eax)
  802f41:	eb 0a                	jmp    802f4d <free_block+0x237>
  802f43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	a3 48 50 98 00       	mov    %eax,0x985048
  802f4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f60:	a1 54 50 98 00       	mov    0x985054,%eax
  802f65:	48                   	dec    %eax
  802f66:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802f6b:	eb 24                	jmp    802f91 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	6a 00                	push   $0x0
  802f72:	ff 75 f4             	pushl  -0xc(%ebp)
  802f75:	ff 75 08             	pushl  0x8(%ebp)
  802f78:	e8 e6 f4 ff ff       	call   802463 <set_block_data>
  802f7d:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f80:	83 ec 0c             	sub    $0xc,%esp
  802f83:	ff 75 08             	pushl  0x8(%ebp)
  802f86:	e8 2f f5 ff ff       	call   8024ba <insert_sorted_in_freeList>
  802f8b:	83 c4 10             	add    $0x10,%esp
  802f8e:	eb 01                	jmp    802f91 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802f90:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802f91:	c9                   	leave  
  802f92:	c3                   	ret    

00802f93 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
  802f96:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802f99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9d:	75 10                	jne    802faf <realloc_block_FF+0x1c>
  802f9f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa3:	75 0a                	jne    802faf <realloc_block_FF+0x1c>
	{
		return NULL;
  802fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  802faa:	e9 8b 04 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802faf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fb3:	75 18                	jne    802fcd <realloc_block_FF+0x3a>
	{
		free_block(va);
  802fb5:	83 ec 0c             	sub    $0xc,%esp
  802fb8:	ff 75 08             	pushl  0x8(%ebp)
  802fbb:	e8 56 fd ff ff       	call   802d16 <free_block>
  802fc0:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc8:	e9 6d 04 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802fcd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd1:	75 13                	jne    802fe6 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802fd3:	83 ec 0c             	sub    $0xc,%esp
  802fd6:	ff 75 0c             	pushl  0xc(%ebp)
  802fd9:	e8 6f f6 ff ff       	call   80264d <alloc_block_FF>
  802fde:	83 c4 10             	add    $0x10,%esp
  802fe1:	e9 54 04 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe9:	83 e0 01             	and    $0x1,%eax
  802fec:	85 c0                	test   %eax,%eax
  802fee:	74 03                	je     802ff3 <realloc_block_FF+0x60>
	{
		new_size++;
  802ff0:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802ff3:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802ff7:	77 07                	ja     803000 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802ff9:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803000:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803004:	83 ec 0c             	sub    $0xc,%esp
  803007:	ff 75 08             	pushl  0x8(%ebp)
  80300a:	e8 d8 f1 ff ff       	call   8021e7 <get_block_size>
  80300f:	83 c4 10             	add    $0x10,%esp
  803012:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80301b:	75 08                	jne    803025 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	e9 15 04 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803025:	8b 55 08             	mov    0x8(%ebp),%edx
  803028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302b:	01 d0                	add    %edx,%eax
  80302d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803030:	83 ec 0c             	sub    $0xc,%esp
  803033:	ff 75 f0             	pushl  -0x10(%ebp)
  803036:	e8 c5 f1 ff ff       	call   802200 <is_free_block>
  80303b:	83 c4 10             	add    $0x10,%esp
  80303e:	0f be c0             	movsbl %al,%eax
  803041:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803044:	83 ec 0c             	sub    $0xc,%esp
  803047:	ff 75 f0             	pushl  -0x10(%ebp)
  80304a:	e8 98 f1 ff ff       	call   8021e7 <get_block_size>
  80304f:	83 c4 10             	add    $0x10,%esp
  803052:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803055:	8b 45 0c             	mov    0xc(%ebp),%eax
  803058:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80305b:	0f 86 a7 02 00 00    	jbe    803308 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803061:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803065:	0f 84 86 02 00 00    	je     8032f1 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80306b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	01 d0                	add    %edx,%eax
  803073:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803076:	0f 85 b2 00 00 00    	jne    80312e <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80307c:	83 ec 0c             	sub    $0xc,%esp
  80307f:	ff 75 08             	pushl  0x8(%ebp)
  803082:	e8 79 f1 ff ff       	call   802200 <is_free_block>
  803087:	83 c4 10             	add    $0x10,%esp
  80308a:	84 c0                	test   %al,%al
  80308c:	0f 94 c0             	sete   %al
  80308f:	0f b6 c0             	movzbl %al,%eax
  803092:	83 ec 04             	sub    $0x4,%esp
  803095:	50                   	push   %eax
  803096:	ff 75 0c             	pushl  0xc(%ebp)
  803099:	ff 75 08             	pushl  0x8(%ebp)
  80309c:	e8 c2 f3 ff ff       	call   802463 <set_block_data>
  8030a1:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8030a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a8:	75 17                	jne    8030c1 <realloc_block_FF+0x12e>
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	68 80 40 80 00       	push   $0x804080
  8030b2:	68 db 01 00 00       	push   $0x1db
  8030b7:	68 d7 3f 80 00       	push   $0x803fd7
  8030bc:	e8 67 d3 ff ff       	call   800428 <_panic>
  8030c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 10                	je     8030da <realloc_block_FF+0x147>
  8030ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d2:	8b 52 04             	mov    0x4(%edx),%edx
  8030d5:	89 50 04             	mov    %edx,0x4(%eax)
  8030d8:	eb 0b                	jmp    8030e5 <realloc_block_FF+0x152>
  8030da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dd:	8b 40 04             	mov    0x4(%eax),%eax
  8030e0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8030e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0f                	je     8030fe <realloc_block_FF+0x16b>
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f8:	8b 12                	mov    (%edx),%edx
  8030fa:	89 10                	mov    %edx,(%eax)
  8030fc:	eb 0a                	jmp    803108 <realloc_block_FF+0x175>
  8030fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	a3 48 50 98 00       	mov    %eax,0x985048
  803108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311b:	a1 54 50 98 00       	mov    0x985054,%eax
  803120:	48                   	dec    %eax
  803121:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	e9 0c 03 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80312e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803134:	01 d0                	add    %edx,%eax
  803136:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803139:	0f 86 b2 01 00 00    	jbe    8032f1 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  80313f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803142:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803145:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803148:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80314b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80314e:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803151:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803155:	0f 87 b8 00 00 00    	ja     803213 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80315b:	83 ec 0c             	sub    $0xc,%esp
  80315e:	ff 75 08             	pushl  0x8(%ebp)
  803161:	e8 9a f0 ff ff       	call   802200 <is_free_block>
  803166:	83 c4 10             	add    $0x10,%esp
  803169:	84 c0                	test   %al,%al
  80316b:	0f 94 c0             	sete   %al
  80316e:	0f b6 c0             	movzbl %al,%eax
  803171:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803174:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803177:	01 ca                	add    %ecx,%edx
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	50                   	push   %eax
  80317d:	52                   	push   %edx
  80317e:	ff 75 08             	pushl  0x8(%ebp)
  803181:	e8 dd f2 ff ff       	call   802463 <set_block_data>
  803186:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803189:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80318d:	75 17                	jne    8031a6 <realloc_block_FF+0x213>
  80318f:	83 ec 04             	sub    $0x4,%esp
  803192:	68 80 40 80 00       	push   $0x804080
  803197:	68 e8 01 00 00       	push   $0x1e8
  80319c:	68 d7 3f 80 00       	push   $0x803fd7
  8031a1:	e8 82 d2 ff ff       	call   800428 <_panic>
  8031a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a9:	8b 00                	mov    (%eax),%eax
  8031ab:	85 c0                	test   %eax,%eax
  8031ad:	74 10                	je     8031bf <realloc_block_FF+0x22c>
  8031af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b7:	8b 52 04             	mov    0x4(%edx),%edx
  8031ba:	89 50 04             	mov    %edx,0x4(%eax)
  8031bd:	eb 0b                	jmp    8031ca <realloc_block_FF+0x237>
  8031bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c2:	8b 40 04             	mov    0x4(%eax),%eax
  8031c5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031cd:	8b 40 04             	mov    0x4(%eax),%eax
  8031d0:	85 c0                	test   %eax,%eax
  8031d2:	74 0f                	je     8031e3 <realloc_block_FF+0x250>
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	8b 40 04             	mov    0x4(%eax),%eax
  8031da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031dd:	8b 12                	mov    (%edx),%edx
  8031df:	89 10                	mov    %edx,(%eax)
  8031e1:	eb 0a                	jmp    8031ed <realloc_block_FF+0x25a>
  8031e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e6:	8b 00                	mov    (%eax),%eax
  8031e8:	a3 48 50 98 00       	mov    %eax,0x985048
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803200:	a1 54 50 98 00       	mov    0x985054,%eax
  803205:	48                   	dec    %eax
  803206:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	e9 27 02 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803213:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803217:	75 17                	jne    803230 <realloc_block_FF+0x29d>
  803219:	83 ec 04             	sub    $0x4,%esp
  80321c:	68 80 40 80 00       	push   $0x804080
  803221:	68 ed 01 00 00       	push   $0x1ed
  803226:	68 d7 3f 80 00       	push   $0x803fd7
  80322b:	e8 f8 d1 ff ff       	call   800428 <_panic>
  803230:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 10                	je     803249 <realloc_block_FF+0x2b6>
  803239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323c:	8b 00                	mov    (%eax),%eax
  80323e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803241:	8b 52 04             	mov    0x4(%edx),%edx
  803244:	89 50 04             	mov    %edx,0x4(%eax)
  803247:	eb 0b                	jmp    803254 <realloc_block_FF+0x2c1>
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	8b 40 04             	mov    0x4(%eax),%eax
  80324f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 40 04             	mov    0x4(%eax),%eax
  80325a:	85 c0                	test   %eax,%eax
  80325c:	74 0f                	je     80326d <realloc_block_FF+0x2da>
  80325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803261:	8b 40 04             	mov    0x4(%eax),%eax
  803264:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803267:	8b 12                	mov    (%edx),%edx
  803269:	89 10                	mov    %edx,(%eax)
  80326b:	eb 0a                	jmp    803277 <realloc_block_FF+0x2e4>
  80326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803270:	8b 00                	mov    (%eax),%eax
  803272:	a3 48 50 98 00       	mov    %eax,0x985048
  803277:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803280:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803283:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80328a:	a1 54 50 98 00       	mov    0x985054,%eax
  80328f:	48                   	dec    %eax
  803290:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803295:	8b 55 08             	mov    0x8(%ebp),%edx
  803298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80329b:	01 d0                	add    %edx,%eax
  80329d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8032a0:	83 ec 04             	sub    $0x4,%esp
  8032a3:	6a 00                	push   $0x0
  8032a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8032a8:	ff 75 f0             	pushl  -0x10(%ebp)
  8032ab:	e8 b3 f1 ff ff       	call   802463 <set_block_data>
  8032b0:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8032b3:	83 ec 0c             	sub    $0xc,%esp
  8032b6:	ff 75 08             	pushl  0x8(%ebp)
  8032b9:	e8 42 ef ff ff       	call   802200 <is_free_block>
  8032be:	83 c4 10             	add    $0x10,%esp
  8032c1:	84 c0                	test   %al,%al
  8032c3:	0f 94 c0             	sete   %al
  8032c6:	0f b6 c0             	movzbl %al,%eax
  8032c9:	83 ec 04             	sub    $0x4,%esp
  8032cc:	50                   	push   %eax
  8032cd:	ff 75 0c             	pushl  0xc(%ebp)
  8032d0:	ff 75 08             	pushl  0x8(%ebp)
  8032d3:	e8 8b f1 ff ff       	call   802463 <set_block_data>
  8032d8:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8032db:	83 ec 0c             	sub    $0xc,%esp
  8032de:	ff 75 f0             	pushl  -0x10(%ebp)
  8032e1:	e8 d4 f1 ff ff       	call   8024ba <insert_sorted_in_freeList>
  8032e6:	83 c4 10             	add    $0x10,%esp
					return va;
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	e9 49 01 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8032f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f4:	83 e8 08             	sub    $0x8,%eax
  8032f7:	83 ec 0c             	sub    $0xc,%esp
  8032fa:	50                   	push   %eax
  8032fb:	e8 4d f3 ff ff       	call   80264d <alloc_block_FF>
  803300:	83 c4 10             	add    $0x10,%esp
  803303:	e9 32 01 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80330b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80330e:	0f 83 21 01 00 00    	jae    803435 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803317:	2b 45 0c             	sub    0xc(%ebp),%eax
  80331a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80331d:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803321:	77 0e                	ja     803331 <realloc_block_FF+0x39e>
  803323:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803327:	75 08                	jne    803331 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803329:	8b 45 08             	mov    0x8(%ebp),%eax
  80332c:	e9 09 01 00 00       	jmp    80343a <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803337:	83 ec 0c             	sub    $0xc,%esp
  80333a:	ff 75 08             	pushl  0x8(%ebp)
  80333d:	e8 be ee ff ff       	call   802200 <is_free_block>
  803342:	83 c4 10             	add    $0x10,%esp
  803345:	84 c0                	test   %al,%al
  803347:	0f 94 c0             	sete   %al
  80334a:	0f b6 c0             	movzbl %al,%eax
  80334d:	83 ec 04             	sub    $0x4,%esp
  803350:	50                   	push   %eax
  803351:	ff 75 0c             	pushl  0xc(%ebp)
  803354:	ff 75 d8             	pushl  -0x28(%ebp)
  803357:	e8 07 f1 ff ff       	call   802463 <set_block_data>
  80335c:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80335f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803362:	8b 45 0c             	mov    0xc(%ebp),%eax
  803365:	01 d0                	add    %edx,%eax
  803367:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80336a:	83 ec 04             	sub    $0x4,%esp
  80336d:	6a 00                	push   $0x0
  80336f:	ff 75 dc             	pushl  -0x24(%ebp)
  803372:	ff 75 d4             	pushl  -0x2c(%ebp)
  803375:	e8 e9 f0 ff ff       	call   802463 <set_block_data>
  80337a:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80337d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803381:	0f 84 9b 00 00 00    	je     803422 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803387:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	01 d0                	add    %edx,%eax
  80338f:	83 ec 04             	sub    $0x4,%esp
  803392:	6a 00                	push   $0x0
  803394:	50                   	push   %eax
  803395:	ff 75 d4             	pushl  -0x2c(%ebp)
  803398:	e8 c6 f0 ff ff       	call   802463 <set_block_data>
  80339d:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8033a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033a4:	75 17                	jne    8033bd <realloc_block_FF+0x42a>
  8033a6:	83 ec 04             	sub    $0x4,%esp
  8033a9:	68 80 40 80 00       	push   $0x804080
  8033ae:	68 10 02 00 00       	push   $0x210
  8033b3:	68 d7 3f 80 00       	push   $0x803fd7
  8033b8:	e8 6b d0 ff ff       	call   800428 <_panic>
  8033bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c0:	8b 00                	mov    (%eax),%eax
  8033c2:	85 c0                	test   %eax,%eax
  8033c4:	74 10                	je     8033d6 <realloc_block_FF+0x443>
  8033c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c9:	8b 00                	mov    (%eax),%eax
  8033cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033ce:	8b 52 04             	mov    0x4(%edx),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	eb 0b                	jmp    8033e1 <realloc_block_FF+0x44e>
  8033d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d9:	8b 40 04             	mov    0x4(%eax),%eax
  8033dc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8033e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e4:	8b 40 04             	mov    0x4(%eax),%eax
  8033e7:	85 c0                	test   %eax,%eax
  8033e9:	74 0f                	je     8033fa <realloc_block_FF+0x467>
  8033eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ee:	8b 40 04             	mov    0x4(%eax),%eax
  8033f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033f4:	8b 12                	mov    (%edx),%edx
  8033f6:	89 10                	mov    %edx,(%eax)
  8033f8:	eb 0a                	jmp    803404 <realloc_block_FF+0x471>
  8033fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	a3 48 50 98 00       	mov    %eax,0x985048
  803404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803407:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80340d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803410:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803417:	a1 54 50 98 00       	mov    0x985054,%eax
  80341c:	48                   	dec    %eax
  80341d:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  803422:	83 ec 0c             	sub    $0xc,%esp
  803425:	ff 75 d4             	pushl  -0x2c(%ebp)
  803428:	e8 8d f0 ff ff       	call   8024ba <insert_sorted_in_freeList>
  80342d:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803430:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803433:	eb 05                	jmp    80343a <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80343a:	c9                   	leave  
  80343b:	c3                   	ret    

0080343c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80343c:	55                   	push   %ebp
  80343d:	89 e5                	mov    %esp,%ebp
  80343f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803442:	83 ec 04             	sub    $0x4,%esp
  803445:	68 a0 40 80 00       	push   $0x8040a0
  80344a:	68 20 02 00 00       	push   $0x220
  80344f:	68 d7 3f 80 00       	push   $0x803fd7
  803454:	e8 cf cf ff ff       	call   800428 <_panic>

00803459 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803459:	55                   	push   %ebp
  80345a:	89 e5                	mov    %esp,%ebp
  80345c:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80345f:	83 ec 04             	sub    $0x4,%esp
  803462:	68 c8 40 80 00       	push   $0x8040c8
  803467:	68 28 02 00 00       	push   $0x228
  80346c:	68 d7 3f 80 00       	push   $0x803fd7
  803471:	e8 b2 cf ff ff       	call   800428 <_panic>
  803476:	66 90                	xchg   %ax,%ax

00803478 <__udivdi3>:
  803478:	55                   	push   %ebp
  803479:	57                   	push   %edi
  80347a:	56                   	push   %esi
  80347b:	53                   	push   %ebx
  80347c:	83 ec 1c             	sub    $0x1c,%esp
  80347f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803483:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803487:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80348b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80348f:	89 ca                	mov    %ecx,%edx
  803491:	89 f8                	mov    %edi,%eax
  803493:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803497:	85 f6                	test   %esi,%esi
  803499:	75 2d                	jne    8034c8 <__udivdi3+0x50>
  80349b:	39 cf                	cmp    %ecx,%edi
  80349d:	77 65                	ja     803504 <__udivdi3+0x8c>
  80349f:	89 fd                	mov    %edi,%ebp
  8034a1:	85 ff                	test   %edi,%edi
  8034a3:	75 0b                	jne    8034b0 <__udivdi3+0x38>
  8034a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034aa:	31 d2                	xor    %edx,%edx
  8034ac:	f7 f7                	div    %edi
  8034ae:	89 c5                	mov    %eax,%ebp
  8034b0:	31 d2                	xor    %edx,%edx
  8034b2:	89 c8                	mov    %ecx,%eax
  8034b4:	f7 f5                	div    %ebp
  8034b6:	89 c1                	mov    %eax,%ecx
  8034b8:	89 d8                	mov    %ebx,%eax
  8034ba:	f7 f5                	div    %ebp
  8034bc:	89 cf                	mov    %ecx,%edi
  8034be:	89 fa                	mov    %edi,%edx
  8034c0:	83 c4 1c             	add    $0x1c,%esp
  8034c3:	5b                   	pop    %ebx
  8034c4:	5e                   	pop    %esi
  8034c5:	5f                   	pop    %edi
  8034c6:	5d                   	pop    %ebp
  8034c7:	c3                   	ret    
  8034c8:	39 ce                	cmp    %ecx,%esi
  8034ca:	77 28                	ja     8034f4 <__udivdi3+0x7c>
  8034cc:	0f bd fe             	bsr    %esi,%edi
  8034cf:	83 f7 1f             	xor    $0x1f,%edi
  8034d2:	75 40                	jne    803514 <__udivdi3+0x9c>
  8034d4:	39 ce                	cmp    %ecx,%esi
  8034d6:	72 0a                	jb     8034e2 <__udivdi3+0x6a>
  8034d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034dc:	0f 87 9e 00 00 00    	ja     803580 <__udivdi3+0x108>
  8034e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034e7:	89 fa                	mov    %edi,%edx
  8034e9:	83 c4 1c             	add    $0x1c,%esp
  8034ec:	5b                   	pop    %ebx
  8034ed:	5e                   	pop    %esi
  8034ee:	5f                   	pop    %edi
  8034ef:	5d                   	pop    %ebp
  8034f0:	c3                   	ret    
  8034f1:	8d 76 00             	lea    0x0(%esi),%esi
  8034f4:	31 ff                	xor    %edi,%edi
  8034f6:	31 c0                	xor    %eax,%eax
  8034f8:	89 fa                	mov    %edi,%edx
  8034fa:	83 c4 1c             	add    $0x1c,%esp
  8034fd:	5b                   	pop    %ebx
  8034fe:	5e                   	pop    %esi
  8034ff:	5f                   	pop    %edi
  803500:	5d                   	pop    %ebp
  803501:	c3                   	ret    
  803502:	66 90                	xchg   %ax,%ax
  803504:	89 d8                	mov    %ebx,%eax
  803506:	f7 f7                	div    %edi
  803508:	31 ff                	xor    %edi,%edi
  80350a:	89 fa                	mov    %edi,%edx
  80350c:	83 c4 1c             	add    $0x1c,%esp
  80350f:	5b                   	pop    %ebx
  803510:	5e                   	pop    %esi
  803511:	5f                   	pop    %edi
  803512:	5d                   	pop    %ebp
  803513:	c3                   	ret    
  803514:	bd 20 00 00 00       	mov    $0x20,%ebp
  803519:	89 eb                	mov    %ebp,%ebx
  80351b:	29 fb                	sub    %edi,%ebx
  80351d:	89 f9                	mov    %edi,%ecx
  80351f:	d3 e6                	shl    %cl,%esi
  803521:	89 c5                	mov    %eax,%ebp
  803523:	88 d9                	mov    %bl,%cl
  803525:	d3 ed                	shr    %cl,%ebp
  803527:	89 e9                	mov    %ebp,%ecx
  803529:	09 f1                	or     %esi,%ecx
  80352b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80352f:	89 f9                	mov    %edi,%ecx
  803531:	d3 e0                	shl    %cl,%eax
  803533:	89 c5                	mov    %eax,%ebp
  803535:	89 d6                	mov    %edx,%esi
  803537:	88 d9                	mov    %bl,%cl
  803539:	d3 ee                	shr    %cl,%esi
  80353b:	89 f9                	mov    %edi,%ecx
  80353d:	d3 e2                	shl    %cl,%edx
  80353f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803543:	88 d9                	mov    %bl,%cl
  803545:	d3 e8                	shr    %cl,%eax
  803547:	09 c2                	or     %eax,%edx
  803549:	89 d0                	mov    %edx,%eax
  80354b:	89 f2                	mov    %esi,%edx
  80354d:	f7 74 24 0c          	divl   0xc(%esp)
  803551:	89 d6                	mov    %edx,%esi
  803553:	89 c3                	mov    %eax,%ebx
  803555:	f7 e5                	mul    %ebp
  803557:	39 d6                	cmp    %edx,%esi
  803559:	72 19                	jb     803574 <__udivdi3+0xfc>
  80355b:	74 0b                	je     803568 <__udivdi3+0xf0>
  80355d:	89 d8                	mov    %ebx,%eax
  80355f:	31 ff                	xor    %edi,%edi
  803561:	e9 58 ff ff ff       	jmp    8034be <__udivdi3+0x46>
  803566:	66 90                	xchg   %ax,%ax
  803568:	8b 54 24 08          	mov    0x8(%esp),%edx
  80356c:	89 f9                	mov    %edi,%ecx
  80356e:	d3 e2                	shl    %cl,%edx
  803570:	39 c2                	cmp    %eax,%edx
  803572:	73 e9                	jae    80355d <__udivdi3+0xe5>
  803574:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803577:	31 ff                	xor    %edi,%edi
  803579:	e9 40 ff ff ff       	jmp    8034be <__udivdi3+0x46>
  80357e:	66 90                	xchg   %ax,%ax
  803580:	31 c0                	xor    %eax,%eax
  803582:	e9 37 ff ff ff       	jmp    8034be <__udivdi3+0x46>
  803587:	90                   	nop

00803588 <__umoddi3>:
  803588:	55                   	push   %ebp
  803589:	57                   	push   %edi
  80358a:	56                   	push   %esi
  80358b:	53                   	push   %ebx
  80358c:	83 ec 1c             	sub    $0x1c,%esp
  80358f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803593:	8b 74 24 34          	mov    0x34(%esp),%esi
  803597:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80359f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035a7:	89 f3                	mov    %esi,%ebx
  8035a9:	89 fa                	mov    %edi,%edx
  8035ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035af:	89 34 24             	mov    %esi,(%esp)
  8035b2:	85 c0                	test   %eax,%eax
  8035b4:	75 1a                	jne    8035d0 <__umoddi3+0x48>
  8035b6:	39 f7                	cmp    %esi,%edi
  8035b8:	0f 86 a2 00 00 00    	jbe    803660 <__umoddi3+0xd8>
  8035be:	89 c8                	mov    %ecx,%eax
  8035c0:	89 f2                	mov    %esi,%edx
  8035c2:	f7 f7                	div    %edi
  8035c4:	89 d0                	mov    %edx,%eax
  8035c6:	31 d2                	xor    %edx,%edx
  8035c8:	83 c4 1c             	add    $0x1c,%esp
  8035cb:	5b                   	pop    %ebx
  8035cc:	5e                   	pop    %esi
  8035cd:	5f                   	pop    %edi
  8035ce:	5d                   	pop    %ebp
  8035cf:	c3                   	ret    
  8035d0:	39 f0                	cmp    %esi,%eax
  8035d2:	0f 87 ac 00 00 00    	ja     803684 <__umoddi3+0xfc>
  8035d8:	0f bd e8             	bsr    %eax,%ebp
  8035db:	83 f5 1f             	xor    $0x1f,%ebp
  8035de:	0f 84 ac 00 00 00    	je     803690 <__umoddi3+0x108>
  8035e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035e9:	29 ef                	sub    %ebp,%edi
  8035eb:	89 fe                	mov    %edi,%esi
  8035ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 e0                	shl    %cl,%eax
  8035f5:	89 d7                	mov    %edx,%edi
  8035f7:	89 f1                	mov    %esi,%ecx
  8035f9:	d3 ef                	shr    %cl,%edi
  8035fb:	09 c7                	or     %eax,%edi
  8035fd:	89 e9                	mov    %ebp,%ecx
  8035ff:	d3 e2                	shl    %cl,%edx
  803601:	89 14 24             	mov    %edx,(%esp)
  803604:	89 d8                	mov    %ebx,%eax
  803606:	d3 e0                	shl    %cl,%eax
  803608:	89 c2                	mov    %eax,%edx
  80360a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360e:	d3 e0                	shl    %cl,%eax
  803610:	89 44 24 04          	mov    %eax,0x4(%esp)
  803614:	8b 44 24 08          	mov    0x8(%esp),%eax
  803618:	89 f1                	mov    %esi,%ecx
  80361a:	d3 e8                	shr    %cl,%eax
  80361c:	09 d0                	or     %edx,%eax
  80361e:	d3 eb                	shr    %cl,%ebx
  803620:	89 da                	mov    %ebx,%edx
  803622:	f7 f7                	div    %edi
  803624:	89 d3                	mov    %edx,%ebx
  803626:	f7 24 24             	mull   (%esp)
  803629:	89 c6                	mov    %eax,%esi
  80362b:	89 d1                	mov    %edx,%ecx
  80362d:	39 d3                	cmp    %edx,%ebx
  80362f:	0f 82 87 00 00 00    	jb     8036bc <__umoddi3+0x134>
  803635:	0f 84 91 00 00 00    	je     8036cc <__umoddi3+0x144>
  80363b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80363f:	29 f2                	sub    %esi,%edx
  803641:	19 cb                	sbb    %ecx,%ebx
  803643:	89 d8                	mov    %ebx,%eax
  803645:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803649:	d3 e0                	shl    %cl,%eax
  80364b:	89 e9                	mov    %ebp,%ecx
  80364d:	d3 ea                	shr    %cl,%edx
  80364f:	09 d0                	or     %edx,%eax
  803651:	89 e9                	mov    %ebp,%ecx
  803653:	d3 eb                	shr    %cl,%ebx
  803655:	89 da                	mov    %ebx,%edx
  803657:	83 c4 1c             	add    $0x1c,%esp
  80365a:	5b                   	pop    %ebx
  80365b:	5e                   	pop    %esi
  80365c:	5f                   	pop    %edi
  80365d:	5d                   	pop    %ebp
  80365e:	c3                   	ret    
  80365f:	90                   	nop
  803660:	89 fd                	mov    %edi,%ebp
  803662:	85 ff                	test   %edi,%edi
  803664:	75 0b                	jne    803671 <__umoddi3+0xe9>
  803666:	b8 01 00 00 00       	mov    $0x1,%eax
  80366b:	31 d2                	xor    %edx,%edx
  80366d:	f7 f7                	div    %edi
  80366f:	89 c5                	mov    %eax,%ebp
  803671:	89 f0                	mov    %esi,%eax
  803673:	31 d2                	xor    %edx,%edx
  803675:	f7 f5                	div    %ebp
  803677:	89 c8                	mov    %ecx,%eax
  803679:	f7 f5                	div    %ebp
  80367b:	89 d0                	mov    %edx,%eax
  80367d:	e9 44 ff ff ff       	jmp    8035c6 <__umoddi3+0x3e>
  803682:	66 90                	xchg   %ax,%ax
  803684:	89 c8                	mov    %ecx,%eax
  803686:	89 f2                	mov    %esi,%edx
  803688:	83 c4 1c             	add    $0x1c,%esp
  80368b:	5b                   	pop    %ebx
  80368c:	5e                   	pop    %esi
  80368d:	5f                   	pop    %edi
  80368e:	5d                   	pop    %ebp
  80368f:	c3                   	ret    
  803690:	3b 04 24             	cmp    (%esp),%eax
  803693:	72 06                	jb     80369b <__umoddi3+0x113>
  803695:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803699:	77 0f                	ja     8036aa <__umoddi3+0x122>
  80369b:	89 f2                	mov    %esi,%edx
  80369d:	29 f9                	sub    %edi,%ecx
  80369f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036a3:	89 14 24             	mov    %edx,(%esp)
  8036a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036ae:	8b 14 24             	mov    (%esp),%edx
  8036b1:	83 c4 1c             	add    $0x1c,%esp
  8036b4:	5b                   	pop    %ebx
  8036b5:	5e                   	pop    %esi
  8036b6:	5f                   	pop    %edi
  8036b7:	5d                   	pop    %ebp
  8036b8:	c3                   	ret    
  8036b9:	8d 76 00             	lea    0x0(%esi),%esi
  8036bc:	2b 04 24             	sub    (%esp),%eax
  8036bf:	19 fa                	sbb    %edi,%edx
  8036c1:	89 d1                	mov    %edx,%ecx
  8036c3:	89 c6                	mov    %eax,%esi
  8036c5:	e9 71 ff ff ff       	jmp    80363b <__umoddi3+0xb3>
  8036ca:	66 90                	xchg   %ax,%ax
  8036cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036d0:	72 ea                	jb     8036bc <__umoddi3+0x134>
  8036d2:	89 d9                	mov    %ebx,%ecx
  8036d4:	e9 62 ff ff ff       	jmp    80363b <__umoddi3+0xb3>
