
obj/user/tst_page_replacement_alloc:     file format elf32-i386


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
  800031:	e8 22 01 00 00       	call   800158 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x800000, 0x801000, 0x802000, 0x803000,											//Code & Data
		0xeebfd000, /*0xedbfd000 will be created during the call of sys_check_WS_list*/ //Stack
} ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  80003f:	6a 01                	push   $0x1
  800041:	68 00 00 20 00       	push   $0x200000
  800046:	6a 0b                	push   $0xb
  800048:	68 20 30 80 00       	push   $0x803020
  80004d:	e8 1d 18 00 00       	call   80186f <sys_check_WS_list>
  800052:	83 c4 10             	add    $0x10,%esp
  800055:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800058:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005c:	74 14                	je     800072 <_main+0x3a>
  80005e:	83 ec 04             	sub    $0x4,%esp
  800061:	68 00 1c 80 00       	push   $0x801c00
  800066:	6a 1b                	push   $0x1b
  800068:	68 74 1c 80 00       	push   $0x801c74
  80006d:	e8 2b 02 00 00       	call   80029d <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800072:	e8 9d 13 00 00       	call   801414 <sys_calculate_free_frames>
  800077:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  80007a:	e8 e0 13 00 00       	call   80145f <sys_pf_calculate_allocated_pages>
  80007f:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  800082:	a0 7f e0 80 00       	mov    0x80e07f,%al
  800087:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  80008a:	a0 7f f0 80 00       	mov    0x80f07f,%al
  80008f:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800092:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800099:	eb 4a                	jmp    8000e5 <_main+0xad>
	{
		arr[i] = -1 ;
  80009b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009e:	05 80 30 80 00       	add    $0x803080,%eax
  8000a3:	c6 00 ff             	movb   $0xff,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr + garbage5;
  8000a6:	a1 00 30 80 00       	mov    0x803000,%eax
  8000ab:	8a 00                	mov    (%eax),%al
  8000ad:	88 c2                	mov    %al,%dl
  8000af:	8a 45 f7             	mov    -0x9(%ebp),%al
  8000b2:	01 d0                	add    %edx,%eax
  8000b4:	88 45 e1             	mov    %al,-0x1f(%ebp)
		garbage5 = *ptr2 + garbage4;
  8000b7:	a1 04 30 80 00       	mov    0x803004,%eax
  8000bc:	8a 00                	mov    (%eax),%al
  8000be:	88 c2                	mov    %al,%dl
  8000c0:	8a 45 e1             	mov    -0x1f(%ebp),%al
  8000c3:	01 d0                	add    %edx,%eax
  8000c5:	88 45 f7             	mov    %al,-0x9(%ebp)
		ptr++ ; ptr2++ ;
  8000c8:	a1 00 30 80 00       	mov    0x803000,%eax
  8000cd:	40                   	inc    %eax
  8000ce:	a3 00 30 80 00       	mov    %eax,0x803000
  8000d3:	a1 04 30 80 00       	mov    0x803004,%eax
  8000d8:	40                   	inc    %eax
  8000d9:	a3 04 30 80 00       	mov    %eax,0x803004
	char garbage2 = arr[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000de:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000e5:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000ec:	7e ad                	jle    80009b <_main+0x63>

	//===================

	//cprintf("Checking Allocation in Mem & Page File... \n");
	{
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  8000ee:	e8 6c 13 00 00       	call   80145f <sys_pf_calculate_allocated_pages>
  8000f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 98 1c 80 00       	push   $0x801c98
  800100:	6a 3b                	push   $0x3b
  800102:	68 74 1c 80 00       	push   $0x801c74
  800107:	e8 91 01 00 00       	call   80029d <_panic>

		int freePagesAfter = (sys_calculate_free_frames() + sys_calculate_modified_frames());
  80010c:	e8 03 13 00 00       	call   801414 <sys_calculate_free_frames>
  800111:	89 c3                	mov    %eax,%ebx
  800113:	e8 15 13 00 00       	call   80142d <sys_calculate_modified_frames>
  800118:	01 d8                	add    %ebx,%eax
  80011a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if( (freePages - freePagesAfter) != 0 )
  80011d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800120:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800123:	74 1d                	je     800142 <_main+0x10a>
			panic("Extra memory are wrongly allocated... It's REplacement: expected that no extra frames are allocated. Expected = %d, Actual = %d", 0, (freePages - freePagesAfter));
  800125:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800128:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80012b:	83 ec 0c             	sub    $0xc,%esp
  80012e:	50                   	push   %eax
  80012f:	6a 00                	push   $0x0
  800131:	68 04 1d 80 00       	push   $0x801d04
  800136:	6a 3f                	push   $0x3f
  800138:	68 74 1c 80 00       	push   $0x801c74
  80013d:	e8 5b 01 00 00       	call   80029d <_panic>

	}

	cprintf("Congratulations!! test PAGE replacement [ALLOCATION] is completed successfully\n");
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	68 84 1d 80 00       	push   $0x801d84
  80014a:	e8 0b 04 00 00       	call   80055a <cprintf>
  80014f:	83 c4 10             	add    $0x10,%esp
	return;
  800152:	90                   	nop
}
  800153:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80015e:	e8 7a 14 00 00       	call   8015dd <sys_getenvindex>
  800163:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800169:	89 d0                	mov    %edx,%eax
  80016b:	c1 e0 02             	shl    $0x2,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	c1 e0 03             	shl    $0x3,%eax
  800173:	01 d0                	add    %edx,%eax
  800175:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80017c:	01 d0                	add    %edx,%eax
  80017e:	c1 e0 02             	shl    $0x2,%eax
  800181:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800186:	a3 60 30 80 00       	mov    %eax,0x803060

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018b:	a1 60 30 80 00       	mov    0x803060,%eax
  800190:	8a 40 20             	mov    0x20(%eax),%al
  800193:	84 c0                	test   %al,%al
  800195:	74 0d                	je     8001a4 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800197:	a1 60 30 80 00       	mov    0x803060,%eax
  80019c:	83 c0 20             	add    $0x20,%eax
  80019f:	a3 50 30 80 00       	mov    %eax,0x803050

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x5c>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 50 30 80 00       	mov    %eax,0x803050

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001c5:	a1 4c 30 80 00       	mov    0x80304c,%eax
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	0f 84 9f 00 00 00    	je     800271 <libmain+0x119>
	{
		sys_lock_cons();
  8001d2:	e8 8a 11 00 00       	call   801361 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	68 ec 1d 80 00       	push   $0x801dec
  8001df:	e8 76 03 00 00       	call   80055a <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001e7:	a1 60 30 80 00       	mov    0x803060,%eax
  8001ec:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001f2:	a1 60 30 80 00       	mov    0x803060,%eax
  8001f7:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001fd:	83 ec 04             	sub    $0x4,%esp
  800200:	52                   	push   %edx
  800201:	50                   	push   %eax
  800202:	68 14 1e 80 00       	push   $0x801e14
  800207:	e8 4e 03 00 00       	call   80055a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80020f:	a1 60 30 80 00       	mov    0x803060,%eax
  800214:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80021a:	a1 60 30 80 00       	mov    0x803060,%eax
  80021f:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800225:	a1 60 30 80 00       	mov    0x803060,%eax
  80022a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800230:	51                   	push   %ecx
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 3c 1e 80 00       	push   $0x801e3c
  800238:	e8 1d 03 00 00       	call   80055a <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800240:	a1 60 30 80 00       	mov    0x803060,%eax
  800245:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80024b:	83 ec 08             	sub    $0x8,%esp
  80024e:	50                   	push   %eax
  80024f:	68 94 1e 80 00       	push   $0x801e94
  800254:	e8 01 03 00 00       	call   80055a <cprintf>
  800259:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025c:	83 ec 0c             	sub    $0xc,%esp
  80025f:	68 ec 1d 80 00       	push   $0x801dec
  800264:	e8 f1 02 00 00       	call   80055a <cprintf>
  800269:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026c:	e8 0a 11 00 00       	call   80137b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800271:	e8 19 00 00 00       	call   80028f <exit>
}
  800276:	90                   	nop
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	6a 00                	push   $0x0
  800284:	e8 20 13 00 00       	call   8015a9 <sys_destroy_env>
  800289:	83 c4 10             	add    $0x10,%esp
}
  80028c:	90                   	nop
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <exit>:

void
exit(void)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800295:	e8 75 13 00 00       	call   80160f <sys_exit_env>
}
  80029a:	90                   	nop
  80029b:	c9                   	leave  
  80029c:	c3                   	ret    

0080029d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80029d:	55                   	push   %ebp
  80029e:	89 e5                	mov    %esp,%ebp
  8002a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002a6:	83 c0 04             	add    $0x4,%eax
  8002a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002ac:	a1 9c f0 80 00       	mov    0x80f09c,%eax
  8002b1:	85 c0                	test   %eax,%eax
  8002b3:	74 16                	je     8002cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002b5:	a1 9c f0 80 00       	mov    0x80f09c,%eax
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	50                   	push   %eax
  8002be:	68 a8 1e 80 00       	push   $0x801ea8
  8002c3:	e8 92 02 00 00       	call   80055a <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002cb:	a1 50 30 80 00       	mov    0x803050,%eax
  8002d0:	ff 75 0c             	pushl  0xc(%ebp)
  8002d3:	ff 75 08             	pushl  0x8(%ebp)
  8002d6:	50                   	push   %eax
  8002d7:	68 ad 1e 80 00       	push   $0x801ead
  8002dc:	e8 79 02 00 00       	call   80055a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e7:	83 ec 08             	sub    $0x8,%esp
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	50                   	push   %eax
  8002ee:	e8 fc 01 00 00       	call   8004ef <vcprintf>
  8002f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002f6:	83 ec 08             	sub    $0x8,%esp
  8002f9:	6a 00                	push   $0x0
  8002fb:	68 c9 1e 80 00       	push   $0x801ec9
  800300:	e8 ea 01 00 00       	call   8004ef <vcprintf>
  800305:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800308:	e8 82 ff ff ff       	call   80028f <exit>

	// should not return here
	while (1) ;
  80030d:	eb fe                	jmp    80030d <_panic+0x70>

0080030f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800315:	a1 60 30 80 00       	mov    0x803060,%eax
  80031a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800320:	8b 45 0c             	mov    0xc(%ebp),%eax
  800323:	39 c2                	cmp    %eax,%edx
  800325:	74 14                	je     80033b <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800327:	83 ec 04             	sub    $0x4,%esp
  80032a:	68 cc 1e 80 00       	push   $0x801ecc
  80032f:	6a 26                	push   $0x26
  800331:	68 18 1f 80 00       	push   $0x801f18
  800336:	e8 62 ff ff ff       	call   80029d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80033b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800342:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800349:	e9 c5 00 00 00       	jmp    800413 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800358:	8b 45 08             	mov    0x8(%ebp),%eax
  80035b:	01 d0                	add    %edx,%eax
  80035d:	8b 00                	mov    (%eax),%eax
  80035f:	85 c0                	test   %eax,%eax
  800361:	75 08                	jne    80036b <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800363:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800366:	e9 a5 00 00 00       	jmp    800410 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80036b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800372:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800379:	eb 69                	jmp    8003e4 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80037b:	a1 60 30 80 00       	mov    0x803060,%eax
  800380:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800386:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800389:	89 d0                	mov    %edx,%eax
  80038b:	01 c0                	add    %eax,%eax
  80038d:	01 d0                	add    %edx,%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	8a 40 04             	mov    0x4(%eax),%al
  800397:	84 c0                	test   %al,%al
  800399:	75 46                	jne    8003e1 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039b:	a1 60 30 80 00       	mov    0x803060,%eax
  8003a0:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a9:	89 d0                	mov    %edx,%eax
  8003ab:	01 c0                	add    %eax,%eax
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	c1 e0 03             	shl    $0x3,%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
  8003b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 c8                	add    %ecx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003d4:	39 c2                	cmp    %eax,%edx
  8003d6:	75 09                	jne    8003e1 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003d8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003df:	eb 15                	jmp    8003f6 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e1:	ff 45 e8             	incl   -0x18(%ebp)
  8003e4:	a1 60 30 80 00       	mov    0x803060,%eax
  8003e9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f2:	39 c2                	cmp    %eax,%edx
  8003f4:	77 85                	ja     80037b <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003fa:	75 14                	jne    800410 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003fc:	83 ec 04             	sub    $0x4,%esp
  8003ff:	68 24 1f 80 00       	push   $0x801f24
  800404:	6a 3a                	push   $0x3a
  800406:	68 18 1f 80 00       	push   $0x801f18
  80040b:	e8 8d fe ff ff       	call   80029d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800410:	ff 45 f0             	incl   -0x10(%ebp)
  800413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800416:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800419:	0f 8c 2f ff ff ff    	jl     80034e <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80041f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80042d:	eb 26                	jmp    800455 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80042f:	a1 60 30 80 00       	mov    0x803060,%eax
  800434:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80043a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	01 c0                	add    %eax,%eax
  800441:	01 d0                	add    %edx,%eax
  800443:	c1 e0 03             	shl    $0x3,%eax
  800446:	01 c8                	add    %ecx,%eax
  800448:	8a 40 04             	mov    0x4(%eax),%al
  80044b:	3c 01                	cmp    $0x1,%al
  80044d:	75 03                	jne    800452 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80044f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800452:	ff 45 e0             	incl   -0x20(%ebp)
  800455:	a1 60 30 80 00       	mov    0x803060,%eax
  80045a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800460:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800463:	39 c2                	cmp    %eax,%edx
  800465:	77 c8                	ja     80042f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80046d:	74 14                	je     800483 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80046f:	83 ec 04             	sub    $0x4,%esp
  800472:	68 78 1f 80 00       	push   $0x801f78
  800477:	6a 44                	push   $0x44
  800479:	68 18 1f 80 00       	push   $0x801f18
  80047e:	e8 1a fe ff ff       	call   80029d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800483:	90                   	nop
  800484:	c9                   	leave  
  800485:	c3                   	ret    

00800486 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	8d 48 01             	lea    0x1(%eax),%ecx
  800494:	8b 55 0c             	mov    0xc(%ebp),%edx
  800497:	89 0a                	mov    %ecx,(%edx)
  800499:	8b 55 08             	mov    0x8(%ebp),%edx
  80049c:	88 d1                	mov    %dl,%cl
  80049e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004af:	75 2c                	jne    8004dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004b1:	a0 80 f0 80 00       	mov    0x80f080,%al
  8004b6:	0f b6 c0             	movzbl %al,%eax
  8004b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bc:	8b 12                	mov    (%edx),%edx
  8004be:	89 d1                	mov    %edx,%ecx
  8004c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c3:	83 c2 08             	add    $0x8,%edx
  8004c6:	83 ec 04             	sub    $0x4,%esp
  8004c9:	50                   	push   %eax
  8004ca:	51                   	push   %ecx
  8004cb:	52                   	push   %edx
  8004cc:	e8 4e 0e 00 00       	call   80131f <sys_cputs>
  8004d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e0:	8b 40 04             	mov    0x4(%eax),%eax
  8004e3:	8d 50 01             	lea    0x1(%eax),%edx
  8004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ec:	90                   	nop
  8004ed:	c9                   	leave  
  8004ee:	c3                   	ret    

008004ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ef:	55                   	push   %ebp
  8004f0:	89 e5                	mov    %esp,%ebp
  8004f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ff:	00 00 00 
	b.cnt = 0;
  800502:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800509:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80050c:	ff 75 0c             	pushl  0xc(%ebp)
  80050f:	ff 75 08             	pushl  0x8(%ebp)
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	50                   	push   %eax
  800519:	68 86 04 80 00       	push   $0x800486
  80051e:	e8 11 02 00 00       	call   800734 <vprintfmt>
  800523:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800526:	a0 80 f0 80 00       	mov    0x80f080,%al
  80052b:	0f b6 c0             	movzbl %al,%eax
  80052e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800534:	83 ec 04             	sub    $0x4,%esp
  800537:	50                   	push   %eax
  800538:	52                   	push   %edx
  800539:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80053f:	83 c0 08             	add    $0x8,%eax
  800542:	50                   	push   %eax
  800543:	e8 d7 0d 00 00       	call   80131f <sys_cputs>
  800548:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80054b:	c6 05 80 f0 80 00 00 	movb   $0x0,0x80f080
	return b.cnt;
  800552:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800558:	c9                   	leave  
  800559:	c3                   	ret    

0080055a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800560:	c6 05 80 f0 80 00 01 	movb   $0x1,0x80f080
	va_start(ap, fmt);
  800567:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	83 ec 08             	sub    $0x8,%esp
  800573:	ff 75 f4             	pushl  -0xc(%ebp)
  800576:	50                   	push   %eax
  800577:	e8 73 ff ff ff       	call   8004ef <vcprintf>
  80057c:	83 c4 10             	add    $0x10,%esp
  80057f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800582:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800585:	c9                   	leave  
  800586:	c3                   	ret    

00800587 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800587:	55                   	push   %ebp
  800588:	89 e5                	mov    %esp,%ebp
  80058a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80058d:	e8 cf 0d 00 00       	call   801361 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 48 ff ff ff       	call   8004ef <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005ad:	e8 c9 0d 00 00       	call   80137b <sys_unlock_cons>
	return cnt;
  8005b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	53                   	push   %ebx
  8005bb:	83 ec 14             	sub    $0x14,%esp
  8005be:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8005cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d5:	77 55                	ja     80062c <printnum+0x75>
  8005d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005da:	72 05                	jb     8005e1 <printnum+0x2a>
  8005dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005df:	77 4b                	ja     80062c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ef:	52                   	push   %edx
  8005f0:	50                   	push   %eax
  8005f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005f7:	e8 98 13 00 00       	call   801994 <__udivdi3>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	83 ec 04             	sub    $0x4,%esp
  800602:	ff 75 20             	pushl  0x20(%ebp)
  800605:	53                   	push   %ebx
  800606:	ff 75 18             	pushl  0x18(%ebp)
  800609:	52                   	push   %edx
  80060a:	50                   	push   %eax
  80060b:	ff 75 0c             	pushl  0xc(%ebp)
  80060e:	ff 75 08             	pushl  0x8(%ebp)
  800611:	e8 a1 ff ff ff       	call   8005b7 <printnum>
  800616:	83 c4 20             	add    $0x20,%esp
  800619:	eb 1a                	jmp    800635 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 0c             	pushl  0xc(%ebp)
  800621:	ff 75 20             	pushl  0x20(%ebp)
  800624:	8b 45 08             	mov    0x8(%ebp),%eax
  800627:	ff d0                	call   *%eax
  800629:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80062c:	ff 4d 1c             	decl   0x1c(%ebp)
  80062f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800633:	7f e6                	jg     80061b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800635:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800638:	bb 00 00 00 00       	mov    $0x0,%ebx
  80063d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800640:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800643:	53                   	push   %ebx
  800644:	51                   	push   %ecx
  800645:	52                   	push   %edx
  800646:	50                   	push   %eax
  800647:	e8 58 14 00 00       	call   801aa4 <__umoddi3>
  80064c:	83 c4 10             	add    $0x10,%esp
  80064f:	05 f4 21 80 00       	add    $0x8021f4,%eax
  800654:	8a 00                	mov    (%eax),%al
  800656:	0f be c0             	movsbl %al,%eax
  800659:	83 ec 08             	sub    $0x8,%esp
  80065c:	ff 75 0c             	pushl  0xc(%ebp)
  80065f:	50                   	push   %eax
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	ff d0                	call   *%eax
  800665:	83 c4 10             	add    $0x10,%esp
}
  800668:	90                   	nop
  800669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80066c:	c9                   	leave  
  80066d:	c3                   	ret    

0080066e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80066e:	55                   	push   %ebp
  80066f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800671:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800675:	7e 1c                	jle    800693 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	8d 50 08             	lea    0x8(%eax),%edx
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	89 10                	mov    %edx,(%eax)
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	83 e8 08             	sub    $0x8,%eax
  80068c:	8b 50 04             	mov    0x4(%eax),%edx
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	eb 40                	jmp    8006d3 <getuint+0x65>
	else if (lflag)
  800693:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800697:	74 1e                	je     8006b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	8d 50 04             	lea    0x4(%eax),%edx
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	89 10                	mov    %edx,(%eax)
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	83 e8 04             	sub    $0x4,%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b5:	eb 1c                	jmp    8006d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 04             	lea    0x4(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 04             	sub    $0x4,%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006d3:	5d                   	pop    %ebp
  8006d4:	c3                   	ret    

008006d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006dc:	7e 1c                	jle    8006fa <getint+0x25>
		return va_arg(*ap, long long);
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	8d 50 08             	lea    0x8(%eax),%edx
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	89 10                	mov    %edx,(%eax)
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	83 e8 08             	sub    $0x8,%eax
  8006f3:	8b 50 04             	mov    0x4(%eax),%edx
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	eb 38                	jmp    800732 <getint+0x5d>
	else if (lflag)
  8006fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006fe:	74 1a                	je     80071a <getint+0x45>
		return va_arg(*ap, long);
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	8d 50 04             	lea    0x4(%eax),%edx
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	89 10                	mov    %edx,(%eax)
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	8b 00                	mov    (%eax),%eax
  800712:	83 e8 04             	sub    $0x4,%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	99                   	cltd   
  800718:	eb 18                	jmp    800732 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	8d 50 04             	lea    0x4(%eax),%edx
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	89 10                	mov    %edx,(%eax)
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	83 e8 04             	sub    $0x4,%eax
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	99                   	cltd   
}
  800732:	5d                   	pop    %ebp
  800733:	c3                   	ret    

00800734 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800734:	55                   	push   %ebp
  800735:	89 e5                	mov    %esp,%ebp
  800737:	56                   	push   %esi
  800738:	53                   	push   %ebx
  800739:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073c:	eb 17                	jmp    800755 <vprintfmt+0x21>
			if (ch == '\0')
  80073e:	85 db                	test   %ebx,%ebx
  800740:	0f 84 c1 03 00 00    	je     800b07 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	53                   	push   %ebx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800755:	8b 45 10             	mov    0x10(%ebp),%eax
  800758:	8d 50 01             	lea    0x1(%eax),%edx
  80075b:	89 55 10             	mov    %edx,0x10(%ebp)
  80075e:	8a 00                	mov    (%eax),%al
  800760:	0f b6 d8             	movzbl %al,%ebx
  800763:	83 fb 25             	cmp    $0x25,%ebx
  800766:	75 d6                	jne    80073e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800768:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80076c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800773:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80077a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800781:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800788:	8b 45 10             	mov    0x10(%ebp),%eax
  80078b:	8d 50 01             	lea    0x1(%eax),%edx
  80078e:	89 55 10             	mov    %edx,0x10(%ebp)
  800791:	8a 00                	mov    (%eax),%al
  800793:	0f b6 d8             	movzbl %al,%ebx
  800796:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800799:	83 f8 5b             	cmp    $0x5b,%eax
  80079c:	0f 87 3d 03 00 00    	ja     800adf <vprintfmt+0x3ab>
  8007a2:	8b 04 85 18 22 80 00 	mov    0x802218(,%eax,4),%eax
  8007a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007af:	eb d7                	jmp    800788 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b5:	eb d1                	jmp    800788 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c1:	89 d0                	mov    %edx,%eax
  8007c3:	c1 e0 02             	shl    $0x2,%eax
  8007c6:	01 d0                	add    %edx,%eax
  8007c8:	01 c0                	add    %eax,%eax
  8007ca:	01 d8                	add    %ebx,%eax
  8007cc:	83 e8 30             	sub    $0x30,%eax
  8007cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d5:	8a 00                	mov    (%eax),%al
  8007d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007da:	83 fb 2f             	cmp    $0x2f,%ebx
  8007dd:	7e 3e                	jle    80081d <vprintfmt+0xe9>
  8007df:	83 fb 39             	cmp    $0x39,%ebx
  8007e2:	7f 39                	jg     80081d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007e7:	eb d5                	jmp    8007be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ec:	83 c0 04             	add    $0x4,%eax
  8007ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	83 e8 04             	sub    $0x4,%eax
  8007f8:	8b 00                	mov    (%eax),%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007fd:	eb 1f                	jmp    80081e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800803:	79 83                	jns    800788 <vprintfmt+0x54>
				width = 0;
  800805:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80080c:	e9 77 ff ff ff       	jmp    800788 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800811:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800818:	e9 6b ff ff ff       	jmp    800788 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80081d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80081e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800822:	0f 89 60 ff ff ff    	jns    800788 <vprintfmt+0x54>
				width = precision, precision = -1;
  800828:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80082e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800835:	e9 4e ff ff ff       	jmp    800788 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80083a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80083d:	e9 46 ff ff ff       	jmp    800788 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800842:	8b 45 14             	mov    0x14(%ebp),%eax
  800845:	83 c0 04             	add    $0x4,%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	8b 45 14             	mov    0x14(%ebp),%eax
  80084e:	83 e8 04             	sub    $0x4,%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	83 ec 08             	sub    $0x8,%esp
  800856:	ff 75 0c             	pushl  0xc(%ebp)
  800859:	50                   	push   %eax
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	ff d0                	call   *%eax
  80085f:	83 c4 10             	add    $0x10,%esp
			break;
  800862:	e9 9b 02 00 00       	jmp    800b02 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	83 c0 04             	add    $0x4,%eax
  80086d:	89 45 14             	mov    %eax,0x14(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	83 e8 04             	sub    $0x4,%eax
  800876:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800878:	85 db                	test   %ebx,%ebx
  80087a:	79 02                	jns    80087e <vprintfmt+0x14a>
				err = -err;
  80087c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80087e:	83 fb 64             	cmp    $0x64,%ebx
  800881:	7f 0b                	jg     80088e <vprintfmt+0x15a>
  800883:	8b 34 9d 60 20 80 00 	mov    0x802060(,%ebx,4),%esi
  80088a:	85 f6                	test   %esi,%esi
  80088c:	75 19                	jne    8008a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80088e:	53                   	push   %ebx
  80088f:	68 05 22 80 00       	push   $0x802205
  800894:	ff 75 0c             	pushl  0xc(%ebp)
  800897:	ff 75 08             	pushl  0x8(%ebp)
  80089a:	e8 70 02 00 00       	call   800b0f <printfmt>
  80089f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a2:	e9 5b 02 00 00       	jmp    800b02 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008a7:	56                   	push   %esi
  8008a8:	68 0e 22 80 00       	push   $0x80220e
  8008ad:	ff 75 0c             	pushl  0xc(%ebp)
  8008b0:	ff 75 08             	pushl  0x8(%ebp)
  8008b3:	e8 57 02 00 00       	call   800b0f <printfmt>
  8008b8:	83 c4 10             	add    $0x10,%esp
			break;
  8008bb:	e9 42 02 00 00       	jmp    800b02 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	83 c0 04             	add    $0x4,%eax
  8008c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	83 e8 04             	sub    $0x4,%eax
  8008cf:	8b 30                	mov    (%eax),%esi
  8008d1:	85 f6                	test   %esi,%esi
  8008d3:	75 05                	jne    8008da <vprintfmt+0x1a6>
				p = "(null)";
  8008d5:	be 11 22 80 00       	mov    $0x802211,%esi
			if (width > 0 && padc != '-')
  8008da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008de:	7e 6d                	jle    80094d <vprintfmt+0x219>
  8008e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008e4:	74 67                	je     80094d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	50                   	push   %eax
  8008ed:	56                   	push   %esi
  8008ee:	e8 1e 03 00 00       	call   800c11 <strnlen>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008f9:	eb 16                	jmp    800911 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	50                   	push   %eax
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	ff d0                	call   *%eax
  80090b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	ff 4d e4             	decl   -0x1c(%ebp)
  800911:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800915:	7f e4                	jg     8008fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800917:	eb 34                	jmp    80094d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800919:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80091d:	74 1c                	je     80093b <vprintfmt+0x207>
  80091f:	83 fb 1f             	cmp    $0x1f,%ebx
  800922:	7e 05                	jle    800929 <vprintfmt+0x1f5>
  800924:	83 fb 7e             	cmp    $0x7e,%ebx
  800927:	7e 12                	jle    80093b <vprintfmt+0x207>
					putch('?', putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	6a 3f                	push   $0x3f
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	eb 0f                	jmp    80094a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80093b:	83 ec 08             	sub    $0x8,%esp
  80093e:	ff 75 0c             	pushl  0xc(%ebp)
  800941:	53                   	push   %ebx
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	ff d0                	call   *%eax
  800947:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094a:	ff 4d e4             	decl   -0x1c(%ebp)
  80094d:	89 f0                	mov    %esi,%eax
  80094f:	8d 70 01             	lea    0x1(%eax),%esi
  800952:	8a 00                	mov    (%eax),%al
  800954:	0f be d8             	movsbl %al,%ebx
  800957:	85 db                	test   %ebx,%ebx
  800959:	74 24                	je     80097f <vprintfmt+0x24b>
  80095b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80095f:	78 b8                	js     800919 <vprintfmt+0x1e5>
  800961:	ff 4d e0             	decl   -0x20(%ebp)
  800964:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800968:	79 af                	jns    800919 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096a:	eb 13                	jmp    80097f <vprintfmt+0x24b>
				putch(' ', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 20                	push   $0x20
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097c:	ff 4d e4             	decl   -0x1c(%ebp)
  80097f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800983:	7f e7                	jg     80096c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800985:	e9 78 01 00 00       	jmp    800b02 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80098a:	83 ec 08             	sub    $0x8,%esp
  80098d:	ff 75 e8             	pushl  -0x18(%ebp)
  800990:	8d 45 14             	lea    0x14(%ebp),%eax
  800993:	50                   	push   %eax
  800994:	e8 3c fd ff ff       	call   8006d5 <getint>
  800999:	83 c4 10             	add    $0x10,%esp
  80099c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009a8:	85 d2                	test   %edx,%edx
  8009aa:	79 23                	jns    8009cf <vprintfmt+0x29b>
				putch('-', putdat);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 0c             	pushl  0xc(%ebp)
  8009b2:	6a 2d                	push   $0x2d
  8009b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b7:	ff d0                	call   *%eax
  8009b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c2:	f7 d8                	neg    %eax
  8009c4:	83 d2 00             	adc    $0x0,%edx
  8009c7:	f7 da                	neg    %edx
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 bc 00 00 00       	jmp    800a97 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e4:	50                   	push   %eax
  8009e5:	e8 84 fc ff ff       	call   80066e <getuint>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fa:	e9 98 00 00 00       	jmp    800a97 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 58                	push   $0x58
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			break;
  800a2f:	e9 ce 00 00 00       	jmp    800b02 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 30                	push   $0x30
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 78                	push   $0x78
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a54:	8b 45 14             	mov    0x14(%ebp),%eax
  800a57:	83 c0 04             	add    $0x4,%eax
  800a5a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	83 e8 04             	sub    $0x4,%eax
  800a63:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a6f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a76:	eb 1f                	jmp    800a97 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a81:	50                   	push   %eax
  800a82:	e8 e7 fb ff ff       	call   80066e <getuint>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a8d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a90:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a97:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a9e:	83 ec 04             	sub    $0x4,%esp
  800aa1:	52                   	push   %edx
  800aa2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	ff 75 08             	pushl  0x8(%ebp)
  800ab2:	e8 00 fb ff ff       	call   8005b7 <printnum>
  800ab7:	83 c4 20             	add    $0x20,%esp
			break;
  800aba:	eb 46                	jmp    800b02 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800abc:	83 ec 08             	sub    $0x8,%esp
  800abf:	ff 75 0c             	pushl  0xc(%ebp)
  800ac2:	53                   	push   %ebx
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			break;
  800acb:	eb 35                	jmp    800b02 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800acd:	c6 05 80 f0 80 00 00 	movb   $0x0,0x80f080
			break;
  800ad4:	eb 2c                	jmp    800b02 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ad6:	c6 05 80 f0 80 00 01 	movb   $0x1,0x80f080
			break;
  800add:	eb 23                	jmp    800b02 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800adf:	83 ec 08             	sub    $0x8,%esp
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	6a 25                	push   $0x25
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aea:	ff d0                	call   *%eax
  800aec:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aef:	ff 4d 10             	decl   0x10(%ebp)
  800af2:	eb 03                	jmp    800af7 <vprintfmt+0x3c3>
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	8b 45 10             	mov    0x10(%ebp),%eax
  800afa:	48                   	dec    %eax
  800afb:	8a 00                	mov    (%eax),%al
  800afd:	3c 25                	cmp    $0x25,%al
  800aff:	75 f3                	jne    800af4 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b01:	90                   	nop
		}
	}
  800b02:	e9 35 fc ff ff       	jmp    80073c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b07:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b0b:	5b                   	pop    %ebx
  800b0c:	5e                   	pop    %esi
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b15:	8d 45 10             	lea    0x10(%ebp),%eax
  800b18:	83 c0 04             	add    $0x4,%eax
  800b1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b21:	ff 75 f4             	pushl  -0xc(%ebp)
  800b24:	50                   	push   %eax
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	ff 75 08             	pushl  0x8(%ebp)
  800b2b:	e8 04 fc ff ff       	call   800734 <vprintfmt>
  800b30:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b33:	90                   	nop
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    

00800b36 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	8b 40 08             	mov    0x8(%eax),%eax
  800b3f:	8d 50 01             	lea    0x1(%eax),%edx
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4b:	8b 10                	mov    (%eax),%edx
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 40 04             	mov    0x4(%eax),%eax
  800b53:	39 c2                	cmp    %eax,%edx
  800b55:	73 12                	jae    800b69 <sprintputch+0x33>
		*b->buf++ = ch;
  800b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b62:	89 0a                	mov    %ecx,(%edx)
  800b64:	8b 55 08             	mov    0x8(%ebp),%edx
  800b67:	88 10                	mov    %dl,(%eax)
}
  800b69:	90                   	nop
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	01 d0                	add    %edx,%eax
  800b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b91:	74 06                	je     800b99 <vsnprintf+0x2d>
  800b93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b97:	7f 07                	jg     800ba0 <vsnprintf+0x34>
		return -E_INVAL;
  800b99:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9e:	eb 20                	jmp    800bc0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba0:	ff 75 14             	pushl  0x14(%ebp)
  800ba3:	ff 75 10             	pushl  0x10(%ebp)
  800ba6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba9:	50                   	push   %eax
  800baa:	68 36 0b 80 00       	push   $0x800b36
  800baf:	e8 80 fb ff ff       	call   800734 <vprintfmt>
  800bb4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc8:	8d 45 10             	lea    0x10(%ebp),%eax
  800bcb:	83 c0 04             	add    $0x4,%eax
  800bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd7:	50                   	push   %eax
  800bd8:	ff 75 0c             	pushl  0xc(%ebp)
  800bdb:	ff 75 08             	pushl  0x8(%ebp)
  800bde:	e8 89 ff ff ff       	call   800b6c <vsnprintf>
  800be3:	83 c4 10             	add    $0x10,%esp
  800be6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfb:	eb 06                	jmp    800c03 <strlen+0x15>
		n++;
  800bfd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c00:	ff 45 08             	incl   0x8(%ebp)
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	84 c0                	test   %al,%al
  800c0a:	75 f1                	jne    800bfd <strlen+0xf>
		n++;
	return n;
  800c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0f:	c9                   	leave  
  800c10:	c3                   	ret    

00800c11 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c17:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1e:	eb 09                	jmp    800c29 <strnlen+0x18>
		n++;
  800c20:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c23:	ff 45 08             	incl   0x8(%ebp)
  800c26:	ff 4d 0c             	decl   0xc(%ebp)
  800c29:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2d:	74 09                	je     800c38 <strnlen+0x27>
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	84 c0                	test   %al,%al
  800c36:	75 e8                	jne    800c20 <strnlen+0xf>
		n++;
	return n;
  800c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3b:	c9                   	leave  
  800c3c:	c3                   	ret    

00800c3d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
  800c46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c49:	90                   	nop
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c59:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5c:	8a 12                	mov    (%edx),%dl
  800c5e:	88 10                	mov    %dl,(%eax)
  800c60:	8a 00                	mov    (%eax),%al
  800c62:	84 c0                	test   %al,%al
  800c64:	75 e4                	jne    800c4a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7e:	eb 1f                	jmp    800c9f <strncpy+0x34>
		*dst++ = *src;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	89 55 08             	mov    %edx,0x8(%ebp)
  800c89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8c:	8a 12                	mov    (%edx),%dl
  800c8e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c93:	8a 00                	mov    (%eax),%al
  800c95:	84 c0                	test   %al,%al
  800c97:	74 03                	je     800c9c <strncpy+0x31>
			src++;
  800c99:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9c:	ff 45 fc             	incl   -0x4(%ebp)
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca5:	72 d9                	jb     800c80 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caa:	c9                   	leave  
  800cab:	c3                   	ret    

00800cac <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbc:	74 30                	je     800cee <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbe:	eb 16                	jmp    800cd6 <strlcpy+0x2a>
			*dst++ = *src++;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8d 50 01             	lea    0x1(%eax),%edx
  800cc6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd2:	8a 12                	mov    (%edx),%dl
  800cd4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd6:	ff 4d 10             	decl   0x10(%ebp)
  800cd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdd:	74 09                	je     800ce8 <strlcpy+0x3c>
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	84 c0                	test   %al,%al
  800ce6:	75 d8                	jne    800cc0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf4:	29 c2                	sub    %eax,%edx
  800cf6:	89 d0                	mov    %edx,%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfd:	eb 06                	jmp    800d05 <strcmp+0xb>
		p++, q++;
  800cff:	ff 45 08             	incl   0x8(%ebp)
  800d02:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strcmp+0x22>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 e3                	je     800cff <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8a 00                	mov    (%eax),%al
  800d21:	0f b6 d0             	movzbl %al,%edx
  800d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	0f b6 c0             	movzbl %al,%eax
  800d2c:	29 c2                	sub    %eax,%edx
  800d2e:	89 d0                	mov    %edx,%eax
}
  800d30:	5d                   	pop    %ebp
  800d31:	c3                   	ret    

00800d32 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d35:	eb 09                	jmp    800d40 <strncmp+0xe>
		n--, p++, q++;
  800d37:	ff 4d 10             	decl   0x10(%ebp)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d44:	74 17                	je     800d5d <strncmp+0x2b>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 0e                	je     800d5d <strncmp+0x2b>
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	8a 10                	mov    (%eax),%dl
  800d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	38 c2                	cmp    %al,%dl
  800d5b:	74 da                	je     800d37 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d61:	75 07                	jne    800d6a <strncmp+0x38>
		return 0;
  800d63:	b8 00 00 00 00       	mov    $0x0,%eax
  800d68:	eb 14                	jmp    800d7e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	0f b6 d0             	movzbl %al,%edx
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	0f b6 c0             	movzbl %al,%eax
  800d7a:	29 c2                	sub    %eax,%edx
  800d7c:	89 d0                	mov    %edx,%eax
}
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 04             	sub    $0x4,%esp
  800d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d89:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8c:	eb 12                	jmp    800da0 <strchr+0x20>
		if (*s == c)
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d96:	75 05                	jne    800d9d <strchr+0x1d>
			return (char *) s;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	eb 11                	jmp    800dae <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9d:	ff 45 08             	incl   0x8(%ebp)
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	84 c0                	test   %al,%al
  800da7:	75 e5                	jne    800d8e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	83 ec 04             	sub    $0x4,%esp
  800db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbc:	eb 0d                	jmp    800dcb <strfind+0x1b>
		if (*s == c)
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	8a 00                	mov    (%eax),%al
  800dc3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc6:	74 0e                	je     800dd6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc8:	ff 45 08             	incl   0x8(%ebp)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	75 ea                	jne    800dbe <strfind+0xe>
  800dd4:	eb 01                	jmp    800dd7 <strfind+0x27>
		if (*s == c)
			break;
  800dd6:	90                   	nop
	return (char *) s;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    

00800ddc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de8:	8b 45 10             	mov    0x10(%ebp),%eax
  800deb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dee:	eb 0e                	jmp    800dfe <memset+0x22>
		*p++ = c;
  800df0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df3:	8d 50 01             	lea    0x1(%eax),%edx
  800df6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfe:	ff 4d f8             	decl   -0x8(%ebp)
  800e01:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e05:	79 e9                	jns    800df0 <memset+0x14>
		*p++ = c;

	return v;
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e18:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1e:	eb 16                	jmp    800e36 <memcpy+0x2a>
		*d++ = *s++;
  800e20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e23:	8d 50 01             	lea    0x1(%eax),%edx
  800e26:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e32:	8a 12                	mov    (%edx),%dl
  800e34:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3f:	85 c0                	test   %eax,%eax
  800e41:	75 dd                	jne    800e20 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e46:	c9                   	leave  
  800e47:	c3                   	ret    

00800e48 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e48:	55                   	push   %ebp
  800e49:	89 e5                	mov    %esp,%ebp
  800e4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e60:	73 50                	jae    800eb2 <memmove+0x6a>
  800e62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	01 d0                	add    %edx,%eax
  800e6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6d:	76 43                	jbe    800eb2 <memmove+0x6a>
		s += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e75:	8b 45 10             	mov    0x10(%ebp),%eax
  800e78:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e7b:	eb 10                	jmp    800e8d <memmove+0x45>
			*--d = *--s;
  800e7d:	ff 4d f8             	decl   -0x8(%ebp)
  800e80:	ff 4d fc             	decl   -0x4(%ebp)
  800e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e86:	8a 10                	mov    (%eax),%dl
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e90:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e93:	89 55 10             	mov    %edx,0x10(%ebp)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	75 e3                	jne    800e7d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9a:	eb 23                	jmp    800ebf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8d 50 01             	lea    0x1(%eax),%edx
  800ea2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eab:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eae:	8a 12                	mov    (%edx),%dl
  800eb0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebb:	85 c0                	test   %eax,%eax
  800ebd:	75 dd                	jne    800e9c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec2:	c9                   	leave  
  800ec3:	c3                   	ret    

00800ec4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed6:	eb 2a                	jmp    800f02 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edb:	8a 10                	mov    (%eax),%dl
  800edd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	38 c2                	cmp    %al,%dl
  800ee4:	74 16                	je     800efc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	0f b6 d0             	movzbl %al,%edx
  800eee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	29 c2                	sub    %eax,%edx
  800ef8:	89 d0                	mov    %edx,%eax
  800efa:	eb 18                	jmp    800f14 <memcmp+0x50>
		s1++, s2++;
  800efc:	ff 45 fc             	incl   -0x4(%ebp)
  800eff:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f02:	8b 45 10             	mov    0x10(%ebp),%eax
  800f05:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f08:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	75 c9                	jne    800ed8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
  800f19:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f22:	01 d0                	add    %edx,%eax
  800f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f27:	eb 15                	jmp    800f3e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	0f b6 d0             	movzbl %al,%edx
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	0f b6 c0             	movzbl %al,%eax
  800f37:	39 c2                	cmp    %eax,%edx
  800f39:	74 0d                	je     800f48 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f44:	72 e3                	jb     800f29 <memfind+0x13>
  800f46:	eb 01                	jmp    800f49 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f48:	90                   	nop
	return (void *) s;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4c:	c9                   	leave  
  800f4d:	c3                   	ret    

00800f4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f5b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f62:	eb 03                	jmp    800f67 <strtol+0x19>
		s++;
  800f64:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6a:	8a 00                	mov    (%eax),%al
  800f6c:	3c 20                	cmp    $0x20,%al
  800f6e:	74 f4                	je     800f64 <strtol+0x16>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 09                	cmp    $0x9,%al
  800f77:	74 eb                	je     800f64 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	3c 2b                	cmp    $0x2b,%al
  800f80:	75 05                	jne    800f87 <strtol+0x39>
		s++;
  800f82:	ff 45 08             	incl   0x8(%ebp)
  800f85:	eb 13                	jmp    800f9a <strtol+0x4c>
	else if (*s == '-')
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 2d                	cmp    $0x2d,%al
  800f8e:	75 0a                	jne    800f9a <strtol+0x4c>
		s++, neg = 1;
  800f90:	ff 45 08             	incl   0x8(%ebp)
  800f93:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	74 06                	je     800fa6 <strtol+0x58>
  800fa0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa4:	75 20                	jne    800fc6 <strtol+0x78>
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	3c 30                	cmp    $0x30,%al
  800fad:	75 17                	jne    800fc6 <strtol+0x78>
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	40                   	inc    %eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 78                	cmp    $0x78,%al
  800fb7:	75 0d                	jne    800fc6 <strtol+0x78>
		s += 2, base = 16;
  800fb9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc4:	eb 28                	jmp    800fee <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fca:	75 15                	jne    800fe1 <strtol+0x93>
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	8a 00                	mov    (%eax),%al
  800fd1:	3c 30                	cmp    $0x30,%al
  800fd3:	75 0c                	jne    800fe1 <strtol+0x93>
		s++, base = 8;
  800fd5:	ff 45 08             	incl   0x8(%ebp)
  800fd8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdf:	eb 0d                	jmp    800fee <strtol+0xa0>
	else if (base == 0)
  800fe1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe5:	75 07                	jne    800fee <strtol+0xa0>
		base = 10;
  800fe7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3c 2f                	cmp    $0x2f,%al
  800ff5:	7e 19                	jle    801010 <strtol+0xc2>
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	3c 39                	cmp    $0x39,%al
  800ffe:	7f 10                	jg     801010 <strtol+0xc2>
			dig = *s - '0';
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	0f be c0             	movsbl %al,%eax
  801008:	83 e8 30             	sub    $0x30,%eax
  80100b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100e:	eb 42                	jmp    801052 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 60                	cmp    $0x60,%al
  801017:	7e 19                	jle    801032 <strtol+0xe4>
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 7a                	cmp    $0x7a,%al
  801020:	7f 10                	jg     801032 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f be c0             	movsbl %al,%eax
  80102a:	83 e8 57             	sub    $0x57,%eax
  80102d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801030:	eb 20                	jmp    801052 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 40                	cmp    $0x40,%al
  801039:	7e 39                	jle    801074 <strtol+0x126>
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	3c 5a                	cmp    $0x5a,%al
  801042:	7f 30                	jg     801074 <strtol+0x126>
			dig = *s - 'A' + 10;
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8a 00                	mov    (%eax),%al
  801049:	0f be c0             	movsbl %al,%eax
  80104c:	83 e8 37             	sub    $0x37,%eax
  80104f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801055:	3b 45 10             	cmp    0x10(%ebp),%eax
  801058:	7d 19                	jge    801073 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801060:	0f af 45 10          	imul   0x10(%ebp),%eax
  801064:	89 c2                	mov    %eax,%edx
  801066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801069:	01 d0                	add    %edx,%eax
  80106b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106e:	e9 7b ff ff ff       	jmp    800fee <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801073:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 08                	je     801082 <strtol+0x134>
		*endptr = (char *) s;
  80107a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107d:	8b 55 08             	mov    0x8(%ebp),%edx
  801080:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801082:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801086:	74 07                	je     80108f <strtol+0x141>
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	f7 d8                	neg    %eax
  80108d:	eb 03                	jmp    801092 <strtol+0x144>
  80108f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <ltostr>:

void
ltostr(long value, char *str)
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ac:	79 13                	jns    8010c1 <ltostr+0x2d>
	{
		neg = 1;
  8010ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010bb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010be:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c9:	99                   	cltd   
  8010ca:	f7 f9                	idiv   %ecx
  8010cc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8d 50 01             	lea    0x1(%eax),%edx
  8010d5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d8:	89 c2                	mov    %eax,%edx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	01 d0                	add    %edx,%eax
  8010df:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e2:	83 c2 30             	add    $0x30,%edx
  8010e5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ea:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ef:	f7 e9                	imul   %ecx
  8010f1:	c1 fa 02             	sar    $0x2,%edx
  8010f4:	89 c8                	mov    %ecx,%eax
  8010f6:	c1 f8 1f             	sar    $0x1f,%eax
  8010f9:	29 c2                	sub    %eax,%edx
  8010fb:	89 d0                	mov    %edx,%eax
  8010fd:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801100:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801104:	75 bb                	jne    8010c1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801106:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801110:	48                   	dec    %eax
  801111:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801114:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801118:	74 3d                	je     801157 <ltostr+0xc3>
		start = 1 ;
  80111a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801121:	eb 34                	jmp    801157 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801123:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	01 d0                	add    %edx,%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801130:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801133:	8b 45 0c             	mov    0xc(%ebp),%eax
  801136:	01 c2                	add    %eax,%edx
  801138:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	01 c8                	add    %ecx,%eax
  801140:	8a 00                	mov    (%eax),%al
  801142:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801144:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	01 c2                	add    %eax,%edx
  80114c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80114f:	88 02                	mov    %al,(%edx)
		start++ ;
  801151:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801154:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80115d:	7c c4                	jl     801123 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80115f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	01 d0                	add    %edx,%eax
  801167:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80116a:	90                   	nop
  80116b:	c9                   	leave  
  80116c:	c3                   	ret    

0080116d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801173:	ff 75 08             	pushl  0x8(%ebp)
  801176:	e8 73 fa ff ff       	call   800bee <strlen>
  80117b:	83 c4 04             	add    $0x4,%esp
  80117e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801181:	ff 75 0c             	pushl  0xc(%ebp)
  801184:	e8 65 fa ff ff       	call   800bee <strlen>
  801189:	83 c4 04             	add    $0x4,%esp
  80118c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80118f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801196:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80119d:	eb 17                	jmp    8011b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80119f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a5:	01 c2                	add    %eax,%edx
  8011a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	01 c8                	add    %ecx,%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011b3:	ff 45 fc             	incl   -0x4(%ebp)
  8011b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011bc:	7c e1                	jl     80119f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011cc:	eb 1f                	jmp    8011ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d1:	8d 50 01             	lea    0x1(%eax),%edx
  8011d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011d7:	89 c2                	mov    %eax,%edx
  8011d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dc:	01 c2                	add    %eax,%edx
  8011de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e4:	01 c8                	add    %ecx,%eax
  8011e6:	8a 00                	mov    (%eax),%al
  8011e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ea:	ff 45 f8             	incl   -0x8(%ebp)
  8011ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f3:	7c d9                	jl     8011ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fb:	01 d0                	add    %edx,%eax
  8011fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801200:	90                   	nop
  801201:	c9                   	leave  
  801202:	c3                   	ret    

00801203 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80120f:	8b 45 14             	mov    0x14(%ebp),%eax
  801212:	8b 00                	mov    (%eax),%eax
  801214:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80121b:	8b 45 10             	mov    0x10(%ebp),%eax
  80121e:	01 d0                	add    %edx,%eax
  801220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801226:	eb 0c                	jmp    801234 <strsplit+0x31>
			*string++ = 0;
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8d 50 01             	lea    0x1(%eax),%edx
  80122e:	89 55 08             	mov    %edx,0x8(%ebp)
  801231:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	84 c0                	test   %al,%al
  80123b:	74 18                	je     801255 <strsplit+0x52>
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	0f be c0             	movsbl %al,%eax
  801245:	50                   	push   %eax
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	e8 32 fb ff ff       	call   800d80 <strchr>
  80124e:	83 c4 08             	add    $0x8,%esp
  801251:	85 c0                	test   %eax,%eax
  801253:	75 d3                	jne    801228 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	84 c0                	test   %al,%al
  80125c:	74 5a                	je     8012b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	8b 00                	mov    (%eax),%eax
  801263:	83 f8 0f             	cmp    $0xf,%eax
  801266:	75 07                	jne    80126f <strsplit+0x6c>
		{
			return 0;
  801268:	b8 00 00 00 00       	mov    $0x0,%eax
  80126d:	eb 66                	jmp    8012d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80126f:	8b 45 14             	mov    0x14(%ebp),%eax
  801272:	8b 00                	mov    (%eax),%eax
  801274:	8d 48 01             	lea    0x1(%eax),%ecx
  801277:	8b 55 14             	mov    0x14(%ebp),%edx
  80127a:	89 0a                	mov    %ecx,(%edx)
  80127c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801283:	8b 45 10             	mov    0x10(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80128d:	eb 03                	jmp    801292 <strsplit+0x8f>
			string++;
  80128f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	84 c0                	test   %al,%al
  801299:	74 8b                	je     801226 <strsplit+0x23>
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	8a 00                	mov    (%eax),%al
  8012a0:	0f be c0             	movsbl %al,%eax
  8012a3:	50                   	push   %eax
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	e8 d4 fa ff ff       	call   800d80 <strchr>
  8012ac:	83 c4 08             	add    $0x8,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	74 dc                	je     80128f <strsplit+0x8c>
			string++;
	}
  8012b3:	e9 6e ff ff ff       	jmp    801226 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bc:	8b 00                	mov    (%eax),%eax
  8012be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
  8012da:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012dd:	83 ec 04             	sub    $0x4,%esp
  8012e0:	68 88 23 80 00       	push   $0x802388
  8012e5:	68 3f 01 00 00       	push   $0x13f
  8012ea:	68 aa 23 80 00       	push   $0x8023aa
  8012ef:	e8 a9 ef ff ff       	call   80029d <_panic>

008012f4 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	57                   	push   %edi
  8012f8:	56                   	push   %esi
  8012f9:	53                   	push   %ebx
  8012fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8b 55 0c             	mov    0xc(%ebp),%edx
  801303:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801306:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801309:	8b 7d 18             	mov    0x18(%ebp),%edi
  80130c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80130f:	cd 30                	int    $0x30
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	5b                   	pop    %ebx
  80131b:	5e                   	pop    %esi
  80131c:	5f                   	pop    %edi
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	83 ec 04             	sub    $0x4,%esp
  801325:	8b 45 10             	mov    0x10(%ebp),%eax
  801328:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80132b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80132f:	8b 45 08             	mov    0x8(%ebp),%eax
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	52                   	push   %edx
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	50                   	push   %eax
  80133b:	6a 00                	push   $0x0
  80133d:	e8 b2 ff ff ff       	call   8012f4 <syscall>
  801342:	83 c4 18             	add    $0x18,%esp
}
  801345:	90                   	nop
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <sys_cgetc>:

int sys_cgetc(void) {
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	6a 02                	push   $0x2
  801357:	e8 98 ff ff ff       	call   8012f4 <syscall>
  80135c:	83 c4 18             	add    $0x18,%esp
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <sys_lock_cons>:

void sys_lock_cons(void) {
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 00                	push   $0x0
  80136e:	6a 03                	push   $0x3
  801370:	e8 7f ff ff ff       	call   8012f4 <syscall>
  801375:	83 c4 18             	add    $0x18,%esp
}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 04                	push   $0x4
  80138a:	e8 65 ff ff ff       	call   8012f4 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	52                   	push   %edx
  8013a5:	50                   	push   %eax
  8013a6:	6a 08                	push   $0x8
  8013a8:	e8 47 ff ff ff       	call   8012f4 <syscall>
  8013ad:	83 c4 18             	add    $0x18,%esp
}
  8013b0:	c9                   	leave  
  8013b1:	c3                   	ret    

008013b2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	56                   	push   %esi
  8013b6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8013b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8013ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013bd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	56                   	push   %esi
  8013c7:	53                   	push   %ebx
  8013c8:	51                   	push   %ecx
  8013c9:	52                   	push   %edx
  8013ca:	50                   	push   %eax
  8013cb:	6a 09                	push   $0x9
  8013cd:	e8 22 ff ff ff       	call   8012f4 <syscall>
  8013d2:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8013d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013d8:	5b                   	pop    %ebx
  8013d9:	5e                   	pop    %esi
  8013da:	5d                   	pop    %ebp
  8013db:	c3                   	ret    

008013dc <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8013dc:	55                   	push   %ebp
  8013dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	52                   	push   %edx
  8013ec:	50                   	push   %eax
  8013ed:	6a 0a                	push   $0xa
  8013ef:	e8 00 ff ff ff       	call   8012f4 <syscall>
  8013f4:	83 c4 18             	add    $0x18,%esp
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8013fc:	6a 00                	push   $0x0
  8013fe:	6a 00                	push   $0x0
  801400:	6a 00                	push   $0x0
  801402:	ff 75 0c             	pushl  0xc(%ebp)
  801405:	ff 75 08             	pushl  0x8(%ebp)
  801408:	6a 0b                	push   $0xb
  80140a:	e8 e5 fe ff ff       	call   8012f4 <syscall>
  80140f:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801412:	c9                   	leave  
  801413:	c3                   	ret    

00801414 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801414:	55                   	push   %ebp
  801415:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	6a 00                	push   $0x0
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 0c                	push   $0xc
  801423:	e8 cc fe ff ff       	call   8012f4 <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
}
  80142b:	c9                   	leave  
  80142c:	c3                   	ret    

0080142d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 0d                	push   $0xd
  80143c:	e8 b3 fe ff ff       	call   8012f4 <syscall>
  801441:	83 c4 18             	add    $0x18,%esp
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 0e                	push   $0xe
  801455:	e8 9a fe ff ff       	call   8012f4 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 0f                	push   $0xf
  80146e:	e8 81 fe ff ff       	call   8012f4 <syscall>
  801473:	83 c4 18             	add    $0x18,%esp
}
  801476:	c9                   	leave  
  801477:	c3                   	ret    

00801478 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801478:	55                   	push   %ebp
  801479:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 00                	push   $0x0
  801483:	ff 75 08             	pushl  0x8(%ebp)
  801486:	6a 10                	push   $0x10
  801488:	e8 67 fe ff ff       	call   8012f4 <syscall>
  80148d:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_scarce_memory>:

void sys_scarce_memory() {
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 11                	push   $0x11
  8014a1:	e8 4e fe ff ff       	call   8012f4 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
}
  8014a9:	90                   	nop
  8014aa:	c9                   	leave  
  8014ab:	c3                   	ret    

008014ac <sys_cputc>:

void sys_cputc(const char c) {
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 04             	sub    $0x4,%esp
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014b8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	50                   	push   %eax
  8014c5:	6a 01                	push   $0x1
  8014c7:	e8 28 fe ff ff       	call   8012f4 <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 14                	push   $0x14
  8014e1:	e8 0e fe ff ff       	call   8012f4 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
}
  8014e9:	90                   	nop
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8014f8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014fb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801502:	6a 00                	push   $0x0
  801504:	51                   	push   %ecx
  801505:	52                   	push   %edx
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	50                   	push   %eax
  80150a:	6a 15                	push   $0x15
  80150c:	e8 e3 fd ff ff       	call   8012f4 <syscall>
  801511:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801519:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151c:	8b 45 08             	mov    0x8(%ebp),%eax
  80151f:	6a 00                	push   $0x0
  801521:	6a 00                	push   $0x0
  801523:	6a 00                	push   $0x0
  801525:	52                   	push   %edx
  801526:	50                   	push   %eax
  801527:	6a 16                	push   $0x16
  801529:	e8 c6 fd ff ff       	call   8012f4 <syscall>
  80152e:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801536:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	51                   	push   %ecx
  801544:	52                   	push   %edx
  801545:	50                   	push   %eax
  801546:	6a 17                	push   $0x17
  801548:	e8 a7 fd ff ff       	call   8012f4 <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801550:	c9                   	leave  
  801551:	c3                   	ret    

00801552 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801555:	8b 55 0c             	mov    0xc(%ebp),%edx
  801558:	8b 45 08             	mov    0x8(%ebp),%eax
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 00                	push   $0x0
  801561:	52                   	push   %edx
  801562:	50                   	push   %eax
  801563:	6a 18                	push   $0x18
  801565:	e8 8a fd ff ff       	call   8012f4 <syscall>
  80156a:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80156d:	c9                   	leave  
  80156e:	c3                   	ret    

0080156f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80156f:	55                   	push   %ebp
  801570:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801572:	8b 45 08             	mov    0x8(%ebp),%eax
  801575:	6a 00                	push   $0x0
  801577:	ff 75 14             	pushl  0x14(%ebp)
  80157a:	ff 75 10             	pushl  0x10(%ebp)
  80157d:	ff 75 0c             	pushl  0xc(%ebp)
  801580:	50                   	push   %eax
  801581:	6a 19                	push   $0x19
  801583:	e8 6c fd ff ff       	call   8012f4 <syscall>
  801588:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80158b:	c9                   	leave  
  80158c:	c3                   	ret    

0080158d <sys_run_env>:

void sys_run_env(int32 envId) {
  80158d:	55                   	push   %ebp
  80158e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	6a 00                	push   $0x0
  801595:	6a 00                	push   $0x0
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	50                   	push   %eax
  80159c:	6a 1a                	push   $0x1a
  80159e:	e8 51 fd ff ff       	call   8012f4 <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
}
  8015a6:	90                   	nop
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	50                   	push   %eax
  8015b8:	6a 1b                	push   $0x1b
  8015ba:	e8 35 fd ff ff       	call   8012f4 <syscall>
  8015bf:	83 c4 18             	add    $0x18,%esp
}
  8015c2:	c9                   	leave  
  8015c3:	c3                   	ret    

008015c4 <sys_getenvid>:

int32 sys_getenvid(void) {
  8015c4:	55                   	push   %ebp
  8015c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 05                	push   $0x5
  8015d3:	e8 1c fd ff ff       	call   8012f4 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 06                	push   $0x6
  8015ec:	e8 03 fd ff ff       	call   8012f4 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 07                	push   $0x7
  801605:	e8 ea fc ff ff       	call   8012f4 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_exit_env>:

void sys_exit_env(void) {
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 1c                	push   $0x1c
  80161e:	e8 d1 fc ff ff       	call   8012f4 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	90                   	nop
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80162f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801632:	8d 50 04             	lea    0x4(%eax),%edx
  801635:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	52                   	push   %edx
  80163f:	50                   	push   %eax
  801640:	6a 1d                	push   $0x1d
  801642:	e8 ad fc ff ff       	call   8012f4 <syscall>
  801647:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80164a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80164d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801650:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801653:	89 01                	mov    %eax,(%ecx)
  801655:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	c9                   	leave  
  80165c:	c2 04 00             	ret    $0x4

0080165f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	ff 75 10             	pushl  0x10(%ebp)
  801669:	ff 75 0c             	pushl  0xc(%ebp)
  80166c:	ff 75 08             	pushl  0x8(%ebp)
  80166f:	6a 13                	push   $0x13
  801671:	e8 7e fc ff ff       	call   8012f4 <syscall>
  801676:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801679:	90                   	nop
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <sys_rcr2>:
uint32 sys_rcr2() {
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 1e                	push   $0x1e
  80168b:	e8 64 fc ff ff       	call   8012f4 <syscall>
  801690:	83 c4 18             	add    $0x18,%esp
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016a1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	50                   	push   %eax
  8016ae:	6a 1f                	push   $0x1f
  8016b0:	e8 3f fc ff ff       	call   8012f4 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
	return;
  8016b8:	90                   	nop
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <rsttst>:
void rsttst() {
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 21                	push   $0x21
  8016ca:	e8 25 fc ff ff       	call   8012f4 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
	return;
  8016d2:	90                   	nop
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	8b 45 14             	mov    0x14(%ebp),%eax
  8016de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016e1:	8b 55 18             	mov    0x18(%ebp),%edx
  8016e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016e8:	52                   	push   %edx
  8016e9:	50                   	push   %eax
  8016ea:	ff 75 10             	pushl  0x10(%ebp)
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	6a 20                	push   $0x20
  8016f5:	e8 fa fb ff ff       	call   8012f4 <syscall>
  8016fa:	83 c4 18             	add    $0x18,%esp
	return;
  8016fd:	90                   	nop
}
  8016fe:	c9                   	leave  
  8016ff:	c3                   	ret    

00801700 <chktst>:
void chktst(uint32 n) {
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801703:	6a 00                	push   $0x0
  801705:	6a 00                	push   $0x0
  801707:	6a 00                	push   $0x0
  801709:	6a 00                	push   $0x0
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	6a 22                	push   $0x22
  801710:	e8 df fb ff ff       	call   8012f4 <syscall>
  801715:	83 c4 18             	add    $0x18,%esp
	return;
  801718:	90                   	nop
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <inctst>:

void inctst() {
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 23                	push   $0x23
  80172a:	e8 c5 fb ff ff       	call   8012f4 <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
	return;
  801732:	90                   	nop
}
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <gettst>:
uint32 gettst() {
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 24                	push   $0x24
  801744:	e8 ab fb ff ff       	call   8012f4 <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 25                	push   $0x25
  801760:	e8 8f fb ff ff       	call   8012f4 <syscall>
  801765:	83 c4 18             	add    $0x18,%esp
  801768:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80176b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80176f:	75 07                	jne    801778 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801771:	b8 01 00 00 00       	mov    $0x1,%eax
  801776:	eb 05                	jmp    80177d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801785:	6a 00                	push   $0x0
  801787:	6a 00                	push   $0x0
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 25                	push   $0x25
  801791:	e8 5e fb ff ff       	call   8012f4 <syscall>
  801796:	83 c4 18             	add    $0x18,%esp
  801799:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80179c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017a0:	75 07                	jne    8017a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017a7:	eb 05                	jmp    8017ae <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ae:	c9                   	leave  
  8017af:	c3                   	ret    

008017b0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b6:	6a 00                	push   $0x0
  8017b8:	6a 00                	push   $0x0
  8017ba:	6a 00                	push   $0x0
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 25                	push   $0x25
  8017c2:	e8 2d fb ff ff       	call   8012f4 <syscall>
  8017c7:	83 c4 18             	add    $0x18,%esp
  8017ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017cd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017d1:	75 07                	jne    8017da <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d8:	eb 05                	jmp    8017df <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017e7:	6a 00                	push   $0x0
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 25                	push   $0x25
  8017f3:	e8 fc fa ff ff       	call   8012f4 <syscall>
  8017f8:	83 c4 18             	add    $0x18,%esp
  8017fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017fe:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801802:	75 07                	jne    80180b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801804:	b8 01 00 00 00       	mov    $0x1,%eax
  801809:	eb 05                	jmp    801810 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80180b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	ff 75 08             	pushl  0x8(%ebp)
  801820:	6a 26                	push   $0x26
  801822:	e8 cd fa ff ff       	call   8012f4 <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
	return;
  80182a:	90                   	nop
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801831:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801834:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801837:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	6a 00                	push   $0x0
  80183f:	53                   	push   %ebx
  801840:	51                   	push   %ecx
  801841:	52                   	push   %edx
  801842:	50                   	push   %eax
  801843:	6a 27                	push   $0x27
  801845:	e8 aa fa ff ff       	call   8012f4 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80184d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801855:	8b 55 0c             	mov    0xc(%ebp),%edx
  801858:	8b 45 08             	mov    0x8(%ebp),%eax
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	52                   	push   %edx
  801862:	50                   	push   %eax
  801863:	6a 28                	push   $0x28
  801865:	e8 8a fa ff ff       	call   8012f4 <syscall>
  80186a:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801872:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801875:	8b 55 0c             	mov    0xc(%ebp),%edx
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	6a 00                	push   $0x0
  80187d:	51                   	push   %ecx
  80187e:	ff 75 10             	pushl  0x10(%ebp)
  801881:	52                   	push   %edx
  801882:	50                   	push   %eax
  801883:	6a 29                	push   $0x29
  801885:	e8 6a fa ff ff       	call   8012f4 <syscall>
  80188a:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80188d:	c9                   	leave  
  80188e:	c3                   	ret    

0080188f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	ff 75 10             	pushl  0x10(%ebp)
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	6a 12                	push   $0x12
  8018a1:	e8 4e fa ff ff       	call   8012f4 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
	return;
  8018a9:	90                   	nop
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8018af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 2a                	push   $0x2a
  8018bf:	e8 30 fa ff ff       	call   8012f4 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
	return;
  8018c7:	90                   	nop
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	50                   	push   %eax
  8018d9:	6a 2b                	push   $0x2b
  8018db:	e8 14 fa ff ff       	call   8012f4 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	ff 75 0c             	pushl  0xc(%ebp)
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	6a 2c                	push   $0x2c
  8018f6:	e8 f9 f9 ff ff       	call   8012f4 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
	return;
  8018fe:	90                   	nop
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	ff 75 08             	pushl  0x8(%ebp)
  801910:	6a 2d                	push   $0x2d
  801912:	e8 dd f9 ff ff       	call   8012f4 <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
	return;
  80191a:	90                   	nop
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801920:	8b 45 08             	mov    0x8(%ebp),%eax
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	50                   	push   %eax
  80192c:	6a 2f                	push   $0x2f
  80192e:	e8 c1 f9 ff ff       	call   8012f4 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
	return;
  801936:	90                   	nop
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80193c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	52                   	push   %edx
  801949:	50                   	push   %eax
  80194a:	6a 30                	push   $0x30
  80194c:	e8 a3 f9 ff ff       	call   8012f4 <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
	return;
  801954:	90                   	nop
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	50                   	push   %eax
  801966:	6a 31                	push   $0x31
  801968:	e8 87 f9 ff ff       	call   8012f4 <syscall>
  80196d:	83 c4 18             	add    $0x18,%esp
	return;
  801970:	90                   	nop
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801976:	8b 55 0c             	mov    0xc(%ebp),%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	52                   	push   %edx
  801983:	50                   	push   %eax
  801984:	6a 2e                	push   $0x2e
  801986:	e8 69 f9 ff ff       	call   8012f4 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
    return;
  80198e:	90                   	nop
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    
  801991:	66 90                	xchg   %ax,%ax
  801993:	90                   	nop

00801994 <__udivdi3>:
  801994:	55                   	push   %ebp
  801995:	57                   	push   %edi
  801996:	56                   	push   %esi
  801997:	53                   	push   %ebx
  801998:	83 ec 1c             	sub    $0x1c,%esp
  80199b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80199f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ab:	89 ca                	mov    %ecx,%edx
  8019ad:	89 f8                	mov    %edi,%eax
  8019af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019b3:	85 f6                	test   %esi,%esi
  8019b5:	75 2d                	jne    8019e4 <__udivdi3+0x50>
  8019b7:	39 cf                	cmp    %ecx,%edi
  8019b9:	77 65                	ja     801a20 <__udivdi3+0x8c>
  8019bb:	89 fd                	mov    %edi,%ebp
  8019bd:	85 ff                	test   %edi,%edi
  8019bf:	75 0b                	jne    8019cc <__udivdi3+0x38>
  8019c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c6:	31 d2                	xor    %edx,%edx
  8019c8:	f7 f7                	div    %edi
  8019ca:	89 c5                	mov    %eax,%ebp
  8019cc:	31 d2                	xor    %edx,%edx
  8019ce:	89 c8                	mov    %ecx,%eax
  8019d0:	f7 f5                	div    %ebp
  8019d2:	89 c1                	mov    %eax,%ecx
  8019d4:	89 d8                	mov    %ebx,%eax
  8019d6:	f7 f5                	div    %ebp
  8019d8:	89 cf                	mov    %ecx,%edi
  8019da:	89 fa                	mov    %edi,%edx
  8019dc:	83 c4 1c             	add    $0x1c,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    
  8019e4:	39 ce                	cmp    %ecx,%esi
  8019e6:	77 28                	ja     801a10 <__udivdi3+0x7c>
  8019e8:	0f bd fe             	bsr    %esi,%edi
  8019eb:	83 f7 1f             	xor    $0x1f,%edi
  8019ee:	75 40                	jne    801a30 <__udivdi3+0x9c>
  8019f0:	39 ce                	cmp    %ecx,%esi
  8019f2:	72 0a                	jb     8019fe <__udivdi3+0x6a>
  8019f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019f8:	0f 87 9e 00 00 00    	ja     801a9c <__udivdi3+0x108>
  8019fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801a03:	89 fa                	mov    %edi,%edx
  801a05:	83 c4 1c             	add    $0x1c,%esp
  801a08:	5b                   	pop    %ebx
  801a09:	5e                   	pop    %esi
  801a0a:	5f                   	pop    %edi
  801a0b:	5d                   	pop    %ebp
  801a0c:	c3                   	ret    
  801a0d:	8d 76 00             	lea    0x0(%esi),%esi
  801a10:	31 ff                	xor    %edi,%edi
  801a12:	31 c0                	xor    %eax,%eax
  801a14:	89 fa                	mov    %edi,%edx
  801a16:	83 c4 1c             	add    $0x1c,%esp
  801a19:	5b                   	pop    %ebx
  801a1a:	5e                   	pop    %esi
  801a1b:	5f                   	pop    %edi
  801a1c:	5d                   	pop    %ebp
  801a1d:	c3                   	ret    
  801a1e:	66 90                	xchg   %ax,%ax
  801a20:	89 d8                	mov    %ebx,%eax
  801a22:	f7 f7                	div    %edi
  801a24:	31 ff                	xor    %edi,%edi
  801a26:	89 fa                	mov    %edi,%edx
  801a28:	83 c4 1c             	add    $0x1c,%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5f                   	pop    %edi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    
  801a30:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a35:	89 eb                	mov    %ebp,%ebx
  801a37:	29 fb                	sub    %edi,%ebx
  801a39:	89 f9                	mov    %edi,%ecx
  801a3b:	d3 e6                	shl    %cl,%esi
  801a3d:	89 c5                	mov    %eax,%ebp
  801a3f:	88 d9                	mov    %bl,%cl
  801a41:	d3 ed                	shr    %cl,%ebp
  801a43:	89 e9                	mov    %ebp,%ecx
  801a45:	09 f1                	or     %esi,%ecx
  801a47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a4b:	89 f9                	mov    %edi,%ecx
  801a4d:	d3 e0                	shl    %cl,%eax
  801a4f:	89 c5                	mov    %eax,%ebp
  801a51:	89 d6                	mov    %edx,%esi
  801a53:	88 d9                	mov    %bl,%cl
  801a55:	d3 ee                	shr    %cl,%esi
  801a57:	89 f9                	mov    %edi,%ecx
  801a59:	d3 e2                	shl    %cl,%edx
  801a5b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5f:	88 d9                	mov    %bl,%cl
  801a61:	d3 e8                	shr    %cl,%eax
  801a63:	09 c2                	or     %eax,%edx
  801a65:	89 d0                	mov    %edx,%eax
  801a67:	89 f2                	mov    %esi,%edx
  801a69:	f7 74 24 0c          	divl   0xc(%esp)
  801a6d:	89 d6                	mov    %edx,%esi
  801a6f:	89 c3                	mov    %eax,%ebx
  801a71:	f7 e5                	mul    %ebp
  801a73:	39 d6                	cmp    %edx,%esi
  801a75:	72 19                	jb     801a90 <__udivdi3+0xfc>
  801a77:	74 0b                	je     801a84 <__udivdi3+0xf0>
  801a79:	89 d8                	mov    %ebx,%eax
  801a7b:	31 ff                	xor    %edi,%edi
  801a7d:	e9 58 ff ff ff       	jmp    8019da <__udivdi3+0x46>
  801a82:	66 90                	xchg   %ax,%ax
  801a84:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a88:	89 f9                	mov    %edi,%ecx
  801a8a:	d3 e2                	shl    %cl,%edx
  801a8c:	39 c2                	cmp    %eax,%edx
  801a8e:	73 e9                	jae    801a79 <__udivdi3+0xe5>
  801a90:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a93:	31 ff                	xor    %edi,%edi
  801a95:	e9 40 ff ff ff       	jmp    8019da <__udivdi3+0x46>
  801a9a:	66 90                	xchg   %ax,%ax
  801a9c:	31 c0                	xor    %eax,%eax
  801a9e:	e9 37 ff ff ff       	jmp    8019da <__udivdi3+0x46>
  801aa3:	90                   	nop

00801aa4 <__umoddi3>:
  801aa4:	55                   	push   %ebp
  801aa5:	57                   	push   %edi
  801aa6:	56                   	push   %esi
  801aa7:	53                   	push   %ebx
  801aa8:	83 ec 1c             	sub    $0x1c,%esp
  801aab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aaf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ab3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801abb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801abf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ac3:	89 f3                	mov    %esi,%ebx
  801ac5:	89 fa                	mov    %edi,%edx
  801ac7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801acb:	89 34 24             	mov    %esi,(%esp)
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	75 1a                	jne    801aec <__umoddi3+0x48>
  801ad2:	39 f7                	cmp    %esi,%edi
  801ad4:	0f 86 a2 00 00 00    	jbe    801b7c <__umoddi3+0xd8>
  801ada:	89 c8                	mov    %ecx,%eax
  801adc:	89 f2                	mov    %esi,%edx
  801ade:	f7 f7                	div    %edi
  801ae0:	89 d0                	mov    %edx,%eax
  801ae2:	31 d2                	xor    %edx,%edx
  801ae4:	83 c4 1c             	add    $0x1c,%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5f                   	pop    %edi
  801aea:	5d                   	pop    %ebp
  801aeb:	c3                   	ret    
  801aec:	39 f0                	cmp    %esi,%eax
  801aee:	0f 87 ac 00 00 00    	ja     801ba0 <__umoddi3+0xfc>
  801af4:	0f bd e8             	bsr    %eax,%ebp
  801af7:	83 f5 1f             	xor    $0x1f,%ebp
  801afa:	0f 84 ac 00 00 00    	je     801bac <__umoddi3+0x108>
  801b00:	bf 20 00 00 00       	mov    $0x20,%edi
  801b05:	29 ef                	sub    %ebp,%edi
  801b07:	89 fe                	mov    %edi,%esi
  801b09:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b0d:	89 e9                	mov    %ebp,%ecx
  801b0f:	d3 e0                	shl    %cl,%eax
  801b11:	89 d7                	mov    %edx,%edi
  801b13:	89 f1                	mov    %esi,%ecx
  801b15:	d3 ef                	shr    %cl,%edi
  801b17:	09 c7                	or     %eax,%edi
  801b19:	89 e9                	mov    %ebp,%ecx
  801b1b:	d3 e2                	shl    %cl,%edx
  801b1d:	89 14 24             	mov    %edx,(%esp)
  801b20:	89 d8                	mov    %ebx,%eax
  801b22:	d3 e0                	shl    %cl,%eax
  801b24:	89 c2                	mov    %eax,%edx
  801b26:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b2a:	d3 e0                	shl    %cl,%eax
  801b2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b30:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b34:	89 f1                	mov    %esi,%ecx
  801b36:	d3 e8                	shr    %cl,%eax
  801b38:	09 d0                	or     %edx,%eax
  801b3a:	d3 eb                	shr    %cl,%ebx
  801b3c:	89 da                	mov    %ebx,%edx
  801b3e:	f7 f7                	div    %edi
  801b40:	89 d3                	mov    %edx,%ebx
  801b42:	f7 24 24             	mull   (%esp)
  801b45:	89 c6                	mov    %eax,%esi
  801b47:	89 d1                	mov    %edx,%ecx
  801b49:	39 d3                	cmp    %edx,%ebx
  801b4b:	0f 82 87 00 00 00    	jb     801bd8 <__umoddi3+0x134>
  801b51:	0f 84 91 00 00 00    	je     801be8 <__umoddi3+0x144>
  801b57:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b5b:	29 f2                	sub    %esi,%edx
  801b5d:	19 cb                	sbb    %ecx,%ebx
  801b5f:	89 d8                	mov    %ebx,%eax
  801b61:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b65:	d3 e0                	shl    %cl,%eax
  801b67:	89 e9                	mov    %ebp,%ecx
  801b69:	d3 ea                	shr    %cl,%edx
  801b6b:	09 d0                	or     %edx,%eax
  801b6d:	89 e9                	mov    %ebp,%ecx
  801b6f:	d3 eb                	shr    %cl,%ebx
  801b71:	89 da                	mov    %ebx,%edx
  801b73:	83 c4 1c             	add    $0x1c,%esp
  801b76:	5b                   	pop    %ebx
  801b77:	5e                   	pop    %esi
  801b78:	5f                   	pop    %edi
  801b79:	5d                   	pop    %ebp
  801b7a:	c3                   	ret    
  801b7b:	90                   	nop
  801b7c:	89 fd                	mov    %edi,%ebp
  801b7e:	85 ff                	test   %edi,%edi
  801b80:	75 0b                	jne    801b8d <__umoddi3+0xe9>
  801b82:	b8 01 00 00 00       	mov    $0x1,%eax
  801b87:	31 d2                	xor    %edx,%edx
  801b89:	f7 f7                	div    %edi
  801b8b:	89 c5                	mov    %eax,%ebp
  801b8d:	89 f0                	mov    %esi,%eax
  801b8f:	31 d2                	xor    %edx,%edx
  801b91:	f7 f5                	div    %ebp
  801b93:	89 c8                	mov    %ecx,%eax
  801b95:	f7 f5                	div    %ebp
  801b97:	89 d0                	mov    %edx,%eax
  801b99:	e9 44 ff ff ff       	jmp    801ae2 <__umoddi3+0x3e>
  801b9e:	66 90                	xchg   %ax,%ax
  801ba0:	89 c8                	mov    %ecx,%eax
  801ba2:	89 f2                	mov    %esi,%edx
  801ba4:	83 c4 1c             	add    $0x1c,%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5f                   	pop    %edi
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    
  801bac:	3b 04 24             	cmp    (%esp),%eax
  801baf:	72 06                	jb     801bb7 <__umoddi3+0x113>
  801bb1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bb5:	77 0f                	ja     801bc6 <__umoddi3+0x122>
  801bb7:	89 f2                	mov    %esi,%edx
  801bb9:	29 f9                	sub    %edi,%ecx
  801bbb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bbf:	89 14 24             	mov    %edx,(%esp)
  801bc2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bc6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bca:	8b 14 24             	mov    (%esp),%edx
  801bcd:	83 c4 1c             	add    $0x1c,%esp
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    
  801bd5:	8d 76 00             	lea    0x0(%esi),%esi
  801bd8:	2b 04 24             	sub    (%esp),%eax
  801bdb:	19 fa                	sbb    %edi,%edx
  801bdd:	89 d1                	mov    %edx,%ecx
  801bdf:	89 c6                	mov    %eax,%esi
  801be1:	e9 71 ff ff ff       	jmp    801b57 <__umoddi3+0xb3>
  801be6:	66 90                	xchg   %ax,%ax
  801be8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801bec:	72 ea                	jb     801bd8 <__umoddi3+0x134>
  801bee:	89 d9                	mov    %ebx,%ecx
  801bf0:	e9 62 ff ff ff       	jmp    801b57 <__umoddi3+0xb3>
