
obj/user/tst_page_replacement_nthclock_2:     file format elf32-i386


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
  800031:	e8 25 01 00 00       	call   80015b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
		0x809000, 0x80a000, 0x804000, 0x80b000,0x80c000,0x807000,0x800000,0x801000,0x808000,0x803000,	//Code & Data
		0xeebfd000, /*will be created during the call of sys_check_WS_list*/ //Stack
} ;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  80003e:	6a 01                	push   $0x1
  800040:	68 00 00 20 00       	push   $0x200000
  800045:	6a 0b                	push   $0xb
  800047:	68 20 30 80 00       	push   $0x803020
  80004c:	e8 21 18 00 00       	call   801872 <sys_check_WS_list>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  800057:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  80005b:	74 14                	je     800071 <_main+0x39>
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	68 00 1c 80 00       	push   $0x801c00
  800065:	6a 1e                	push   $0x1e
  800067:	68 74 1c 80 00       	push   $0x801c74
  80006c:	e8 2f 02 00 00       	call   8002a0 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  800071:	e8 a1 13 00 00       	call   801417 <sys_calculate_free_frames>
  800076:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  800079:	e8 e4 13 00 00       	call   801462 <sys_pf_calculate_allocated_pages>
  80007e:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  800081:	a0 bf e0 80 00       	mov    0x80e0bf,%al
  800086:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  800089:	a0 bf f0 80 00       	mov    0x80f0bf,%al
  80008e:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  800091:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800098:	eb 32                	jmp    8000cc <_main+0x94>
	{
		arr[i] = 'A' ;
  80009a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80009d:	05 c0 30 80 00       	add    $0x8030c0,%eax
  8000a2:	c6 00 41             	movb   $0x41,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  8000a5:	a1 00 30 80 00       	mov    0x803000,%eax
  8000aa:	8a 00                	mov    (%eax),%al
  8000ac:	88 45 f7             	mov    %al,-0x9(%ebp)
		if (i % PAGE_SIZE == 0)
  8000af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000b2:	25 ff 0f 00 00       	and    $0xfff,%eax
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	75 0a                	jne    8000c5 <_main+0x8d>
			garbage5 = *ptr2 ;
  8000bb:	a1 04 30 80 00       	mov    0x803004,%eax
  8000c0:	8a 00                	mov    (%eax),%al
  8000c2:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c5:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  8000cc:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  8000d3:	7e c5                	jle    80009a <_main+0x62>

	//===================

	//cprintf("Checking PAGE nth clock algorithm... \n");
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0x807000, 1);
  8000d5:	6a 01                	push   $0x1
  8000d7:	68 00 70 80 00       	push   $0x807000
  8000dc:	6a 0b                	push   $0xb
  8000de:	68 60 30 80 00       	push   $0x803060
  8000e3:	e8 8a 17 00 00       	call   801872 <sys_check_WS_list>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("Page Nth clock algo failed.. trace it by printing WS before and after page fault");
  8000ee:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  8000f2:	74 14                	je     800108 <_main+0xd0>
  8000f4:	83 ec 04             	sub    $0x4,%esp
  8000f7:	68 9c 1c 80 00       	push   $0x801c9c
  8000fc:	6a 3f                	push   $0x3f
  8000fe:	68 74 1c 80 00       	push   $0x801c74
  800103:	e8 98 01 00 00       	call   8002a0 <_panic>
	}
	{
		if (garbage4 != *ptr) panic("test failed!");
  800108:	a1 00 30 80 00       	mov    0x803000,%eax
  80010d:	8a 00                	mov    (%eax),%al
  80010f:	3a 45 f7             	cmp    -0x9(%ebp),%al
  800112:	74 14                	je     800128 <_main+0xf0>
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	68 ed 1c 80 00       	push   $0x801ced
  80011c:	6a 42                	push   $0x42
  80011e:	68 74 1c 80 00       	push   $0x801c74
  800123:	e8 78 01 00 00       	call   8002a0 <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  800128:	a1 04 30 80 00       	mov    0x803004,%eax
  80012d:	8a 00                	mov    (%eax),%al
  80012f:	3a 45 f6             	cmp    -0xa(%ebp),%al
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 ed 1c 80 00       	push   $0x801ced
  80013c:	6a 43                	push   $0x43
  80013e:	68 74 1c 80 00       	push   $0x801c74
  800143:	e8 58 01 00 00       	call   8002a0 <_panic>
	}

	cprintf("Congratulations!! test PAGE replacement [Nth clock Alg.] is completed successfully.\n");
  800148:	83 ec 0c             	sub    $0xc,%esp
  80014b:	68 fc 1c 80 00       	push   $0x801cfc
  800150:	e8 08 04 00 00       	call   80055d <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
	return;
  800158:	90                   	nop
}
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800161:	e8 7a 14 00 00       	call   8015e0 <sys_getenvindex>
  800166:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80016c:	89 d0                	mov    %edx,%eax
  80016e:	c1 e0 02             	shl    $0x2,%eax
  800171:	01 d0                	add    %edx,%eax
  800173:	c1 e0 03             	shl    $0x3,%eax
  800176:	01 d0                	add    %edx,%eax
  800178:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80017f:	01 d0                	add    %edx,%eax
  800181:	c1 e0 02             	shl    $0x2,%eax
  800184:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800189:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80018e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800193:	8a 40 20             	mov    0x20(%eax),%al
  800196:	84 c0                	test   %al,%al
  800198:	74 0d                	je     8001a7 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80019a:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80019f:	83 c0 20             	add    $0x20,%eax
  8001a2:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ab:	7e 0a                	jle    8001b7 <libmain+0x5c>
		binaryname = argv[0];
  8001ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b0:	8b 00                	mov    (%eax),%eax
  8001b2:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 0c             	pushl  0xc(%ebp)
  8001bd:	ff 75 08             	pushl  0x8(%ebp)
  8001c0:	e8 73 fe ff ff       	call   800038 <_main>
  8001c5:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001c8:	a1 8c 30 80 00       	mov    0x80308c,%eax
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	0f 84 9f 00 00 00    	je     800274 <libmain+0x119>
	{
		sys_lock_cons();
  8001d5:	e8 8a 11 00 00       	call   801364 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 6c 1d 80 00       	push   $0x801d6c
  8001e2:	e8 76 03 00 00       	call   80055d <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001ea:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001ef:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001f5:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001fa:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800200:	83 ec 04             	sub    $0x4,%esp
  800203:	52                   	push   %edx
  800204:	50                   	push   %eax
  800205:	68 94 1d 80 00       	push   $0x801d94
  80020a:	e8 4e 03 00 00       	call   80055d <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800212:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800217:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80021d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800222:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800228:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80022d:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800233:	51                   	push   %ecx
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 bc 1d 80 00       	push   $0x801dbc
  80023b:	e8 1d 03 00 00       	call   80055d <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800243:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800248:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80024e:	83 ec 08             	sub    $0x8,%esp
  800251:	50                   	push   %eax
  800252:	68 14 1e 80 00       	push   $0x801e14
  800257:	e8 01 03 00 00       	call   80055d <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80025f:	83 ec 0c             	sub    $0xc,%esp
  800262:	68 6c 1d 80 00       	push   $0x801d6c
  800267:	e8 f1 02 00 00       	call   80055d <cprintf>
  80026c:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80026f:	e8 0a 11 00 00       	call   80137e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800274:	e8 19 00 00 00       	call   800292 <exit>
}
  800279:	90                   	nop
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	6a 00                	push   $0x0
  800287:	e8 20 13 00 00       	call   8015ac <sys_destroy_env>
  80028c:	83 c4 10             	add    $0x10,%esp
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <exit>:

void
exit(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800298:	e8 75 13 00 00       	call   801612 <sys_exit_env>
}
  80029d:	90                   	nop
  80029e:	c9                   	leave  
  80029f:	c3                   	ret    

008002a0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002a6:	8d 45 10             	lea    0x10(%ebp),%eax
  8002a9:	83 c0 04             	add    $0x4,%eax
  8002ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002af:	a1 dc f0 80 00       	mov    0x80f0dc,%eax
  8002b4:	85 c0                	test   %eax,%eax
  8002b6:	74 16                	je     8002ce <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002b8:	a1 dc f0 80 00       	mov    0x80f0dc,%eax
  8002bd:	83 ec 08             	sub    $0x8,%esp
  8002c0:	50                   	push   %eax
  8002c1:	68 28 1e 80 00       	push   $0x801e28
  8002c6:	e8 92 02 00 00       	call   80055d <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ce:	a1 90 30 80 00       	mov    0x803090,%eax
  8002d3:	ff 75 0c             	pushl  0xc(%ebp)
  8002d6:	ff 75 08             	pushl  0x8(%ebp)
  8002d9:	50                   	push   %eax
  8002da:	68 2d 1e 80 00       	push   $0x801e2d
  8002df:	e8 79 02 00 00       	call   80055d <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f0:	50                   	push   %eax
  8002f1:	e8 fc 01 00 00       	call   8004f2 <vcprintf>
  8002f6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002f9:	83 ec 08             	sub    $0x8,%esp
  8002fc:	6a 00                	push   $0x0
  8002fe:	68 49 1e 80 00       	push   $0x801e49
  800303:	e8 ea 01 00 00       	call   8004f2 <vcprintf>
  800308:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80030b:	e8 82 ff ff ff       	call   800292 <exit>

	// should not return here
	while (1) ;
  800310:	eb fe                	jmp    800310 <_panic+0x70>

00800312 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800312:	55                   	push   %ebp
  800313:	89 e5                	mov    %esp,%ebp
  800315:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800318:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80031d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
  800326:	39 c2                	cmp    %eax,%edx
  800328:	74 14                	je     80033e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	68 4c 1e 80 00       	push   $0x801e4c
  800332:	6a 26                	push   $0x26
  800334:	68 98 1e 80 00       	push   $0x801e98
  800339:	e8 62 ff ff ff       	call   8002a0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80033e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800345:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80034c:	e9 c5 00 00 00       	jmp    800416 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800354:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	8b 00                	mov    (%eax),%eax
  800362:	85 c0                	test   %eax,%eax
  800364:	75 08                	jne    80036e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  800366:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800369:	e9 a5 00 00 00       	jmp    800413 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80036e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800375:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80037c:	eb 69                	jmp    8003e7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80037e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800383:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800389:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038c:	89 d0                	mov    %edx,%eax
  80038e:	01 c0                	add    %eax,%eax
  800390:	01 d0                	add    %edx,%eax
  800392:	c1 e0 03             	shl    $0x3,%eax
  800395:	01 c8                	add    %ecx,%eax
  800397:	8a 40 04             	mov    0x4(%eax),%al
  80039a:	84 c0                	test   %al,%al
  80039c:	75 46                	jne    8003e4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80039e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8003a3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ac:	89 d0                	mov    %edx,%eax
  8003ae:	01 c0                	add    %eax,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	c1 e0 03             	shl    $0x3,%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003c4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	01 c8                	add    %ecx,%eax
  8003d5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003d7:	39 c2                	cmp    %eax,%edx
  8003d9:	75 09                	jne    8003e4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003db:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003e2:	eb 15                	jmp    8003f9 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e4:	ff 45 e8             	incl   -0x18(%ebp)
  8003e7:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8003ec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f5:	39 c2                	cmp    %eax,%edx
  8003f7:	77 85                	ja     80037e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003fd:	75 14                	jne    800413 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003ff:	83 ec 04             	sub    $0x4,%esp
  800402:	68 a4 1e 80 00       	push   $0x801ea4
  800407:	6a 3a                	push   $0x3a
  800409:	68 98 1e 80 00       	push   $0x801e98
  80040e:	e8 8d fe ff ff       	call   8002a0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800413:	ff 45 f0             	incl   -0x10(%ebp)
  800416:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800419:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041c:	0f 8c 2f ff ff ff    	jl     800351 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800422:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800429:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800430:	eb 26                	jmp    800458 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800432:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800437:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80043d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800440:	89 d0                	mov    %edx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	c1 e0 03             	shl    $0x3,%eax
  800449:	01 c8                	add    %ecx,%eax
  80044b:	8a 40 04             	mov    0x4(%eax),%al
  80044e:	3c 01                	cmp    $0x1,%al
  800450:	75 03                	jne    800455 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800452:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800455:	ff 45 e0             	incl   -0x20(%ebp)
  800458:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80045d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800463:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800466:	39 c2                	cmp    %eax,%edx
  800468:	77 c8                	ja     800432 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80046a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800470:	74 14                	je     800486 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800472:	83 ec 04             	sub    $0x4,%esp
  800475:	68 f8 1e 80 00       	push   $0x801ef8
  80047a:	6a 44                	push   $0x44
  80047c:	68 98 1e 80 00       	push   $0x801e98
  800481:	e8 1a fe ff ff       	call   8002a0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800486:	90                   	nop
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	8d 48 01             	lea    0x1(%eax),%ecx
  800497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049a:	89 0a                	mov    %ecx,(%edx)
  80049c:	8b 55 08             	mov    0x8(%ebp),%edx
  80049f:	88 d1                	mov    %dl,%cl
  8004a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 00                	mov    (%eax),%eax
  8004ad:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004b2:	75 2c                	jne    8004e0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004b4:	a0 c0 f0 80 00       	mov    0x80f0c0,%al
  8004b9:	0f b6 c0             	movzbl %al,%eax
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	8b 12                	mov    (%edx),%edx
  8004c1:	89 d1                	mov    %edx,%ecx
  8004c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c6:	83 c2 08             	add    $0x8,%edx
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	50                   	push   %eax
  8004cd:	51                   	push   %ecx
  8004ce:	52                   	push   %edx
  8004cf:	e8 4e 0e 00 00       	call   801322 <sys_cputs>
  8004d4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8b 40 04             	mov    0x4(%eax),%eax
  8004e6:	8d 50 01             	lea    0x1(%eax),%edx
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800502:	00 00 00 
	b.cnt = 0;
  800505:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80050c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80050f:	ff 75 0c             	pushl  0xc(%ebp)
  800512:	ff 75 08             	pushl  0x8(%ebp)
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	50                   	push   %eax
  80051c:	68 89 04 80 00       	push   $0x800489
  800521:	e8 11 02 00 00       	call   800737 <vprintfmt>
  800526:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800529:	a0 c0 f0 80 00       	mov    0x80f0c0,%al
  80052e:	0f b6 c0             	movzbl %al,%eax
  800531:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800537:	83 ec 04             	sub    $0x4,%esp
  80053a:	50                   	push   %eax
  80053b:	52                   	push   %edx
  80053c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800542:	83 c0 08             	add    $0x8,%eax
  800545:	50                   	push   %eax
  800546:	e8 d7 0d 00 00       	call   801322 <sys_cputs>
  80054b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80054e:	c6 05 c0 f0 80 00 00 	movb   $0x0,0x80f0c0
	return b.cnt;
  800555:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80055b:	c9                   	leave  
  80055c:	c3                   	ret    

0080055d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80055d:	55                   	push   %ebp
  80055e:	89 e5                	mov    %esp,%ebp
  800560:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800563:	c6 05 c0 f0 80 00 01 	movb   $0x1,0x80f0c0
	va_start(ap, fmt);
  80056a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 f4             	pushl  -0xc(%ebp)
  800579:	50                   	push   %eax
  80057a:	e8 73 ff ff ff       	call   8004f2 <vcprintf>
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800585:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800588:	c9                   	leave  
  800589:	c3                   	ret    

0080058a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80058a:	55                   	push   %ebp
  80058b:	89 e5                	mov    %esp,%ebp
  80058d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800590:	e8 cf 0d 00 00       	call   801364 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800595:	8d 45 0c             	lea    0xc(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	83 ec 08             	sub    $0x8,%esp
  8005a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a4:	50                   	push   %eax
  8005a5:	e8 48 ff ff ff       	call   8004f2 <vcprintf>
  8005aa:	83 c4 10             	add    $0x10,%esp
  8005ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005b0:	e8 c9 0d 00 00       	call   80137e <sys_unlock_cons>
	return cnt;
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b8:	c9                   	leave  
  8005b9:	c3                   	ret    

008005ba <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ba:	55                   	push   %ebp
  8005bb:	89 e5                	mov    %esp,%ebp
  8005bd:	53                   	push   %ebx
  8005be:	83 ec 14             	sub    $0x14,%esp
  8005c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005cd:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005d8:	77 55                	ja     80062f <printnum+0x75>
  8005da:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005dd:	72 05                	jb     8005e4 <printnum+0x2a>
  8005df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005e2:	77 4b                	ja     80062f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005e4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005e7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005ea:	8b 45 18             	mov    0x18(%ebp),%eax
  8005ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f2:	52                   	push   %edx
  8005f3:	50                   	push   %eax
  8005f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8005fa:	e8 95 13 00 00       	call   801994 <__udivdi3>
  8005ff:	83 c4 10             	add    $0x10,%esp
  800602:	83 ec 04             	sub    $0x4,%esp
  800605:	ff 75 20             	pushl  0x20(%ebp)
  800608:	53                   	push   %ebx
  800609:	ff 75 18             	pushl  0x18(%ebp)
  80060c:	52                   	push   %edx
  80060d:	50                   	push   %eax
  80060e:	ff 75 0c             	pushl  0xc(%ebp)
  800611:	ff 75 08             	pushl  0x8(%ebp)
  800614:	e8 a1 ff ff ff       	call   8005ba <printnum>
  800619:	83 c4 20             	add    $0x20,%esp
  80061c:	eb 1a                	jmp    800638 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	ff 75 20             	pushl  0x20(%ebp)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	ff d0                	call   *%eax
  80062c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80062f:	ff 4d 1c             	decl   0x1c(%ebp)
  800632:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800636:	7f e6                	jg     80061e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800638:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80063b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800646:	53                   	push   %ebx
  800647:	51                   	push   %ecx
  800648:	52                   	push   %edx
  800649:	50                   	push   %eax
  80064a:	e8 55 14 00 00       	call   801aa4 <__umoddi3>
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	05 74 21 80 00       	add    $0x802174,%eax
  800657:	8a 00                	mov    (%eax),%al
  800659:	0f be c0             	movsbl %al,%eax
  80065c:	83 ec 08             	sub    $0x8,%esp
  80065f:	ff 75 0c             	pushl  0xc(%ebp)
  800662:	50                   	push   %eax
  800663:	8b 45 08             	mov    0x8(%ebp),%eax
  800666:	ff d0                	call   *%eax
  800668:	83 c4 10             	add    $0x10,%esp
}
  80066b:	90                   	nop
  80066c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800674:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800678:	7e 1c                	jle    800696 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	8d 50 08             	lea    0x8(%eax),%edx
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	89 10                	mov    %edx,(%eax)
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	83 e8 08             	sub    $0x8,%eax
  80068f:	8b 50 04             	mov    0x4(%eax),%edx
  800692:	8b 00                	mov    (%eax),%eax
  800694:	eb 40                	jmp    8006d6 <getuint+0x65>
	else if (lflag)
  800696:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80069a:	74 1e                	je     8006ba <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	8d 50 04             	lea    0x4(%eax),%edx
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	89 10                	mov    %edx,(%eax)
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	83 e8 04             	sub    $0x4,%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b8:	eb 1c                	jmp    8006d6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 04             	lea    0x4(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 04             	sub    $0x4,%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006d6:	5d                   	pop    %ebp
  8006d7:	c3                   	ret    

008006d8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006d8:	55                   	push   %ebp
  8006d9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006db:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006df:	7e 1c                	jle    8006fd <getint+0x25>
		return va_arg(*ap, long long);
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	8d 50 08             	lea    0x8(%eax),%edx
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	89 10                	mov    %edx,(%eax)
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	83 e8 08             	sub    $0x8,%eax
  8006f6:	8b 50 04             	mov    0x4(%eax),%edx
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	eb 38                	jmp    800735 <getint+0x5d>
	else if (lflag)
  8006fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800701:	74 1a                	je     80071d <getint+0x45>
		return va_arg(*ap, long);
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	8d 50 04             	lea    0x4(%eax),%edx
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 10                	mov    %edx,(%eax)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	83 e8 04             	sub    $0x4,%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	99                   	cltd   
  80071b:	eb 18                	jmp    800735 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	8d 50 04             	lea    0x4(%eax),%edx
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	89 10                	mov    %edx,(%eax)
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	83 e8 04             	sub    $0x4,%eax
  800732:	8b 00                	mov    (%eax),%eax
  800734:	99                   	cltd   
}
  800735:	5d                   	pop    %ebp
  800736:	c3                   	ret    

00800737 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800737:	55                   	push   %ebp
  800738:	89 e5                	mov    %esp,%ebp
  80073a:	56                   	push   %esi
  80073b:	53                   	push   %ebx
  80073c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	eb 17                	jmp    800758 <vprintfmt+0x21>
			if (ch == '\0')
  800741:	85 db                	test   %ebx,%ebx
  800743:	0f 84 c1 03 00 00    	je     800b0a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 0c             	pushl  0xc(%ebp)
  80074f:	53                   	push   %ebx
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	ff d0                	call   *%eax
  800755:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800758:	8b 45 10             	mov    0x10(%ebp),%eax
  80075b:	8d 50 01             	lea    0x1(%eax),%edx
  80075e:	89 55 10             	mov    %edx,0x10(%ebp)
  800761:	8a 00                	mov    (%eax),%al
  800763:	0f b6 d8             	movzbl %al,%ebx
  800766:	83 fb 25             	cmp    $0x25,%ebx
  800769:	75 d6                	jne    800741 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80076b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80076f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800776:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80077d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800784:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80078b:	8b 45 10             	mov    0x10(%ebp),%eax
  80078e:	8d 50 01             	lea    0x1(%eax),%edx
  800791:	89 55 10             	mov    %edx,0x10(%ebp)
  800794:	8a 00                	mov    (%eax),%al
  800796:	0f b6 d8             	movzbl %al,%ebx
  800799:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80079c:	83 f8 5b             	cmp    $0x5b,%eax
  80079f:	0f 87 3d 03 00 00    	ja     800ae2 <vprintfmt+0x3ab>
  8007a5:	8b 04 85 98 21 80 00 	mov    0x802198(,%eax,4),%eax
  8007ac:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ae:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007b2:	eb d7                	jmp    80078b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007b4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007b8:	eb d1                	jmp    80078b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ba:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c4:	89 d0                	mov    %edx,%eax
  8007c6:	c1 e0 02             	shl    $0x2,%eax
  8007c9:	01 d0                	add    %edx,%eax
  8007cb:	01 c0                	add    %eax,%eax
  8007cd:	01 d8                	add    %ebx,%eax
  8007cf:	83 e8 30             	sub    $0x30,%eax
  8007d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8a 00                	mov    (%eax),%al
  8007da:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007dd:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e0:	7e 3e                	jle    800820 <vprintfmt+0xe9>
  8007e2:	83 fb 39             	cmp    $0x39,%ebx
  8007e5:	7f 39                	jg     800820 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007ea:	eb d5                	jmp    8007c1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ef:	83 c0 04             	add    $0x4,%eax
  8007f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 e8 04             	sub    $0x4,%eax
  8007fb:	8b 00                	mov    (%eax),%eax
  8007fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800800:	eb 1f                	jmp    800821 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800802:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800806:	79 83                	jns    80078b <vprintfmt+0x54>
				width = 0;
  800808:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80080f:	e9 77 ff ff ff       	jmp    80078b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800814:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80081b:	e9 6b ff ff ff       	jmp    80078b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800820:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800821:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800825:	0f 89 60 ff ff ff    	jns    80078b <vprintfmt+0x54>
				width = precision, precision = -1;
  80082b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80082e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800831:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800838:	e9 4e ff ff ff       	jmp    80078b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80083d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800840:	e9 46 ff ff ff       	jmp    80078b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800845:	8b 45 14             	mov    0x14(%ebp),%eax
  800848:	83 c0 04             	add    $0x4,%eax
  80084b:	89 45 14             	mov    %eax,0x14(%ebp)
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 e8 04             	sub    $0x4,%eax
  800854:	8b 00                	mov    (%eax),%eax
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	50                   	push   %eax
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			break;
  800865:	e9 9b 02 00 00       	jmp    800b05 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80087b:	85 db                	test   %ebx,%ebx
  80087d:	79 02                	jns    800881 <vprintfmt+0x14a>
				err = -err;
  80087f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800881:	83 fb 64             	cmp    $0x64,%ebx
  800884:	7f 0b                	jg     800891 <vprintfmt+0x15a>
  800886:	8b 34 9d e0 1f 80 00 	mov    0x801fe0(,%ebx,4),%esi
  80088d:	85 f6                	test   %esi,%esi
  80088f:	75 19                	jne    8008aa <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800891:	53                   	push   %ebx
  800892:	68 85 21 80 00       	push   $0x802185
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 70 02 00 00       	call   800b12 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008a5:	e9 5b 02 00 00       	jmp    800b05 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008aa:	56                   	push   %esi
  8008ab:	68 8e 21 80 00       	push   $0x80218e
  8008b0:	ff 75 0c             	pushl  0xc(%ebp)
  8008b3:	ff 75 08             	pushl  0x8(%ebp)
  8008b6:	e8 57 02 00 00       	call   800b12 <printfmt>
  8008bb:	83 c4 10             	add    $0x10,%esp
			break;
  8008be:	e9 42 02 00 00       	jmp    800b05 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c6:	83 c0 04             	add    $0x4,%eax
  8008c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 e8 04             	sub    $0x4,%eax
  8008d2:	8b 30                	mov    (%eax),%esi
  8008d4:	85 f6                	test   %esi,%esi
  8008d6:	75 05                	jne    8008dd <vprintfmt+0x1a6>
				p = "(null)";
  8008d8:	be 91 21 80 00       	mov    $0x802191,%esi
			if (width > 0 && padc != '-')
  8008dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e1:	7e 6d                	jle    800950 <vprintfmt+0x219>
  8008e3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008e7:	74 67                	je     800950 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	50                   	push   %eax
  8008f0:	56                   	push   %esi
  8008f1:	e8 1e 03 00 00       	call   800c14 <strnlen>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008fc:	eb 16                	jmp    800914 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008fe:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	50                   	push   %eax
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	ff 4d e4             	decl   -0x1c(%ebp)
  800914:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800918:	7f e4                	jg     8008fe <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091a:	eb 34                	jmp    800950 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80091c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800920:	74 1c                	je     80093e <vprintfmt+0x207>
  800922:	83 fb 1f             	cmp    $0x1f,%ebx
  800925:	7e 05                	jle    80092c <vprintfmt+0x1f5>
  800927:	83 fb 7e             	cmp    $0x7e,%ebx
  80092a:	7e 12                	jle    80093e <vprintfmt+0x207>
					putch('?', putdat);
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	6a 3f                	push   $0x3f
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	ff d0                	call   *%eax
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	eb 0f                	jmp    80094d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80093e:	83 ec 08             	sub    $0x8,%esp
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	53                   	push   %ebx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	89 f0                	mov    %esi,%eax
  800952:	8d 70 01             	lea    0x1(%eax),%esi
  800955:	8a 00                	mov    (%eax),%al
  800957:	0f be d8             	movsbl %al,%ebx
  80095a:	85 db                	test   %ebx,%ebx
  80095c:	74 24                	je     800982 <vprintfmt+0x24b>
  80095e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800962:	78 b8                	js     80091c <vprintfmt+0x1e5>
  800964:	ff 4d e0             	decl   -0x20(%ebp)
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	79 af                	jns    80091c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80096d:	eb 13                	jmp    800982 <vprintfmt+0x24b>
				putch(' ', putdat);
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	6a 20                	push   $0x20
  800977:	8b 45 08             	mov    0x8(%ebp),%eax
  80097a:	ff d0                	call   *%eax
  80097c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097f:	ff 4d e4             	decl   -0x1c(%ebp)
  800982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800986:	7f e7                	jg     80096f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800988:	e9 78 01 00 00       	jmp    800b05 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80098d:	83 ec 08             	sub    $0x8,%esp
  800990:	ff 75 e8             	pushl  -0x18(%ebp)
  800993:	8d 45 14             	lea    0x14(%ebp),%eax
  800996:	50                   	push   %eax
  800997:	e8 3c fd ff ff       	call   8006d8 <getint>
  80099c:	83 c4 10             	add    $0x10,%esp
  80099f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ab:	85 d2                	test   %edx,%edx
  8009ad:	79 23                	jns    8009d2 <vprintfmt+0x29b>
				putch('-', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 2d                	push   $0x2d
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c5:	f7 d8                	neg    %eax
  8009c7:	83 d2 00             	adc    $0x0,%edx
  8009ca:	f7 da                	neg    %edx
  8009cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009d2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d9:	e9 bc 00 00 00       	jmp    800a9a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009de:	83 ec 08             	sub    $0x8,%esp
  8009e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8009e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8009e7:	50                   	push   %eax
  8009e8:	e8 84 fc ff ff       	call   800671 <getuint>
  8009ed:	83 c4 10             	add    $0x10,%esp
  8009f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009f6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fd:	e9 98 00 00 00       	jmp    800a9a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a02:	83 ec 08             	sub    $0x8,%esp
  800a05:	ff 75 0c             	pushl  0xc(%ebp)
  800a08:	6a 58                	push   $0x58
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	6a 58                	push   $0x58
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a22:	83 ec 08             	sub    $0x8,%esp
  800a25:	ff 75 0c             	pushl  0xc(%ebp)
  800a28:	6a 58                	push   $0x58
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	ff d0                	call   *%eax
  800a2f:	83 c4 10             	add    $0x10,%esp
			break;
  800a32:	e9 ce 00 00 00       	jmp    800b05 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 30                	push   $0x30
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 78                	push   $0x78
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a57:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5a:	83 c0 04             	add    $0x4,%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 e8 04             	sub    $0x4,%eax
  800a66:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a79:	eb 1f                	jmp    800a9a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a7b:	83 ec 08             	sub    $0x8,%esp
  800a7e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a81:	8d 45 14             	lea    0x14(%ebp),%eax
  800a84:	50                   	push   %eax
  800a85:	e8 e7 fb ff ff       	call   800671 <getuint>
  800a8a:	83 c4 10             	add    $0x10,%esp
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a93:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a9a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa1:	83 ec 04             	sub    $0x4,%esp
  800aa4:	52                   	push   %edx
  800aa5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800aa8:	50                   	push   %eax
  800aa9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aac:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaf:	ff 75 0c             	pushl  0xc(%ebp)
  800ab2:	ff 75 08             	pushl  0x8(%ebp)
  800ab5:	e8 00 fb ff ff       	call   8005ba <printnum>
  800aba:	83 c4 20             	add    $0x20,%esp
			break;
  800abd:	eb 46                	jmp    800b05 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800abf:	83 ec 08             	sub    $0x8,%esp
  800ac2:	ff 75 0c             	pushl  0xc(%ebp)
  800ac5:	53                   	push   %ebx
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	ff d0                	call   *%eax
  800acb:	83 c4 10             	add    $0x10,%esp
			break;
  800ace:	eb 35                	jmp    800b05 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ad0:	c6 05 c0 f0 80 00 00 	movb   $0x0,0x80f0c0
			break;
  800ad7:	eb 2c                	jmp    800b05 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ad9:	c6 05 c0 f0 80 00 01 	movb   $0x1,0x80f0c0
			break;
  800ae0:	eb 23                	jmp    800b05 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	6a 25                	push   $0x25
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	ff d0                	call   *%eax
  800aef:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	eb 03                	jmp    800afa <vprintfmt+0x3c3>
  800af7:	ff 4d 10             	decl   0x10(%ebp)
  800afa:	8b 45 10             	mov    0x10(%ebp),%eax
  800afd:	48                   	dec    %eax
  800afe:	8a 00                	mov    (%eax),%al
  800b00:	3c 25                	cmp    $0x25,%al
  800b02:	75 f3                	jne    800af7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b04:	90                   	nop
		}
	}
  800b05:	e9 35 fc ff ff       	jmp    80073f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b0e:	5b                   	pop    %ebx
  800b0f:	5e                   	pop    %esi
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b18:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b21:	8b 45 10             	mov    0x10(%ebp),%eax
  800b24:	ff 75 f4             	pushl  -0xc(%ebp)
  800b27:	50                   	push   %eax
  800b28:	ff 75 0c             	pushl  0xc(%ebp)
  800b2b:	ff 75 08             	pushl  0x8(%ebp)
  800b2e:	e8 04 fc ff ff       	call   800737 <vprintfmt>
  800b33:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b36:	90                   	nop
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	8b 40 08             	mov    0x8(%eax),%eax
  800b42:	8d 50 01             	lea    0x1(%eax),%edx
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 10                	mov    (%eax),%edx
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8b 40 04             	mov    0x4(%eax),%eax
  800b56:	39 c2                	cmp    %eax,%edx
  800b58:	73 12                	jae    800b6c <sprintputch+0x33>
		*b->buf++ = ch;
  800b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5d:	8b 00                	mov    (%eax),%eax
  800b5f:	8d 48 01             	lea    0x1(%eax),%ecx
  800b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b65:	89 0a                	mov    %ecx,(%edx)
  800b67:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6a:	88 10                	mov    %dl,(%eax)
}
  800b6c:	90                   	nop
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	01 d0                	add    %edx,%eax
  800b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b94:	74 06                	je     800b9c <vsnprintf+0x2d>
  800b96:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9a:	7f 07                	jg     800ba3 <vsnprintf+0x34>
		return -E_INVAL;
  800b9c:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba1:	eb 20                	jmp    800bc3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba3:	ff 75 14             	pushl  0x14(%ebp)
  800ba6:	ff 75 10             	pushl  0x10(%ebp)
  800ba9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bac:	50                   	push   %eax
  800bad:	68 39 0b 80 00       	push   $0x800b39
  800bb2:	e8 80 fb ff ff       	call   800737 <vprintfmt>
  800bb7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 89 ff ff ff       	call   800b6f <vsnprintf>
  800be6:	83 c4 10             	add    $0x10,%esp
  800be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bfe:	eb 06                	jmp    800c06 <strlen+0x15>
		n++;
  800c00:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c03:	ff 45 08             	incl   0x8(%ebp)
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	84 c0                	test   %al,%al
  800c0d:	75 f1                	jne    800c00 <strlen+0xf>
		n++;
	return n;
  800c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 09                	jmp    800c2c <strnlen+0x18>
		n++;
  800c23:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c26:	ff 45 08             	incl   0x8(%ebp)
  800c29:	ff 4d 0c             	decl   0xc(%ebp)
  800c2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c30:	74 09                	je     800c3b <strnlen+0x27>
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	84 c0                	test   %al,%al
  800c39:	75 e8                	jne    800c23 <strnlen+0xf>
		n++;
	return n;
  800c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c3e:	c9                   	leave  
  800c3f:	c3                   	ret    

00800c40 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
  800c49:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4c:	90                   	nop
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	8d 50 01             	lea    0x1(%eax),%edx
  800c53:	89 55 08             	mov    %edx,0x8(%ebp)
  800c56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c59:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5f:	8a 12                	mov    (%edx),%dl
  800c61:	88 10                	mov    %dl,(%eax)
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e4                	jne    800c4d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c81:	eb 1f                	jmp    800ca2 <strncpy+0x34>
		*dst++ = *src;
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8d 50 01             	lea    0x1(%eax),%edx
  800c89:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8f:	8a 12                	mov    (%edx),%dl
  800c91:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	84 c0                	test   %al,%al
  800c9a:	74 03                	je     800c9f <strncpy+0x31>
			src++;
  800c9c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ca2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca5:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca8:	72 d9                	jb     800c83 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800caa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cad:	c9                   	leave  
  800cae:	c3                   	ret    

00800caf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbf:	74 30                	je     800cf1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc1:	eb 16                	jmp    800cd9 <strlcpy+0x2a>
			*dst++ = *src++;
  800cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc6:	8d 50 01             	lea    0x1(%eax),%edx
  800cc9:	89 55 08             	mov    %edx,0x8(%ebp)
  800ccc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ccf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd5:	8a 12                	mov    (%edx),%dl
  800cd7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd9:	ff 4d 10             	decl   0x10(%ebp)
  800cdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce0:	74 09                	je     800ceb <strlcpy+0x3c>
  800ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce5:	8a 00                	mov    (%eax),%al
  800ce7:	84 c0                	test   %al,%al
  800ce9:	75 d8                	jne    800cc3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf7:	29 c2                	sub    %eax,%edx
  800cf9:	89 d0                	mov    %edx,%eax
}
  800cfb:	c9                   	leave  
  800cfc:	c3                   	ret    

00800cfd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d00:	eb 06                	jmp    800d08 <strcmp+0xb>
		p++, q++;
  800d02:	ff 45 08             	incl   0x8(%ebp)
  800d05:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	84 c0                	test   %al,%al
  800d0f:	74 0e                	je     800d1f <strcmp+0x22>
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8a 10                	mov    (%eax),%dl
  800d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	38 c2                	cmp    %al,%dl
  800d1d:	74 e3                	je     800d02 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f b6 d0             	movzbl %al,%edx
  800d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2a:	8a 00                	mov    (%eax),%al
  800d2c:	0f b6 c0             	movzbl %al,%eax
  800d2f:	29 c2                	sub    %eax,%edx
  800d31:	89 d0                	mov    %edx,%eax
}
  800d33:	5d                   	pop    %ebp
  800d34:	c3                   	ret    

00800d35 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d35:	55                   	push   %ebp
  800d36:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d38:	eb 09                	jmp    800d43 <strncmp+0xe>
		n--, p++, q++;
  800d3a:	ff 4d 10             	decl   0x10(%ebp)
  800d3d:	ff 45 08             	incl   0x8(%ebp)
  800d40:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d47:	74 17                	je     800d60 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	84 c0                	test   %al,%al
  800d50:	74 0e                	je     800d60 <strncmp+0x2b>
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8a 10                	mov    (%eax),%dl
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	38 c2                	cmp    %al,%dl
  800d5e:	74 da                	je     800d3a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d64:	75 07                	jne    800d6d <strncmp+0x38>
		return 0;
  800d66:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6b:	eb 14                	jmp    800d81 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	0f b6 d0             	movzbl %al,%edx
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	0f b6 c0             	movzbl %al,%eax
  800d7d:	29 c2                	sub    %eax,%edx
  800d7f:	89 d0                	mov    %edx,%eax
}
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 04             	sub    $0x4,%esp
  800d89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8f:	eb 12                	jmp    800da3 <strchr+0x20>
		if (*s == c)
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d99:	75 05                	jne    800da0 <strchr+0x1d>
			return (char *) s;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	eb 11                	jmp    800db1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 e5                	jne    800d91 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 04             	sub    $0x4,%esp
  800db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbf:	eb 0d                	jmp    800dce <strfind+0x1b>
		if (*s == c)
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc9:	74 0e                	je     800dd9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcb:	ff 45 08             	incl   0x8(%ebp)
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	84 c0                	test   %al,%al
  800dd5:	75 ea                	jne    800dc1 <strfind+0xe>
  800dd7:	eb 01                	jmp    800dda <strfind+0x27>
		if (*s == c)
			break;
  800dd9:	90                   	nop
	return (char *) s;
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
  800de8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800deb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dee:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df1:	eb 0e                	jmp    800e01 <memset+0x22>
		*p++ = c;
  800df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df6:	8d 50 01             	lea    0x1(%eax),%edx
  800df9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dff:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e01:	ff 4d f8             	decl   -0x8(%ebp)
  800e04:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e08:	79 e9                	jns    800df3 <memset+0x14>
		*p++ = c;

	return v;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e21:	eb 16                	jmp    800e39 <memcpy+0x2a>
		*d++ = *s++;
  800e23:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e26:	8d 50 01             	lea    0x1(%eax),%edx
  800e29:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e32:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e35:	8a 12                	mov    (%edx),%dl
  800e37:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	75 dd                	jne    800e23 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e57:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e60:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e63:	73 50                	jae    800eb5 <memmove+0x6a>
  800e65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e68:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6b:	01 d0                	add    %edx,%eax
  800e6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e70:	76 43                	jbe    800eb5 <memmove+0x6a>
		s += n;
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
  800e75:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e78:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e7e:	eb 10                	jmp    800e90 <memmove+0x45>
			*--d = *--s;
  800e80:	ff 4d f8             	decl   -0x8(%ebp)
  800e83:	ff 4d fc             	decl   -0x4(%ebp)
  800e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e89:	8a 10                	mov    (%eax),%dl
  800e8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e90:	8b 45 10             	mov    0x10(%ebp),%eax
  800e93:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e96:	89 55 10             	mov    %edx,0x10(%ebp)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	75 e3                	jne    800e80 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9d:	eb 23                	jmp    800ec2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea2:	8d 50 01             	lea    0x1(%eax),%edx
  800ea5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eab:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eae:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb1:	8a 12                	mov    (%edx),%dl
  800eb3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebb:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebe:	85 c0                	test   %eax,%eax
  800ec0:	75 dd                	jne    800e9f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed9:	eb 2a                	jmp    800f05 <memcmp+0x3e>
		if (*s1 != *s2)
  800edb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ede:	8a 10                	mov    (%eax),%dl
  800ee0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	38 c2                	cmp    %al,%dl
  800ee7:	74 16                	je     800eff <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eec:	8a 00                	mov    (%eax),%al
  800eee:	0f b6 d0             	movzbl %al,%edx
  800ef1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef4:	8a 00                	mov    (%eax),%al
  800ef6:	0f b6 c0             	movzbl %al,%eax
  800ef9:	29 c2                	sub    %eax,%edx
  800efb:	89 d0                	mov    %edx,%eax
  800efd:	eb 18                	jmp    800f17 <memcmp+0x50>
		s1++, s2++;
  800eff:	ff 45 fc             	incl   -0x4(%ebp)
  800f02:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f05:	8b 45 10             	mov    0x10(%ebp),%eax
  800f08:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	75 c9                	jne    800edb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f17:	c9                   	leave  
  800f18:	c3                   	ret    

00800f19 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	01 d0                	add    %edx,%eax
  800f27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2a:	eb 15                	jmp    800f41 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 00                	mov    (%eax),%al
  800f31:	0f b6 d0             	movzbl %al,%edx
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	0f b6 c0             	movzbl %al,%eax
  800f3a:	39 c2                	cmp    %eax,%edx
  800f3c:	74 0d                	je     800f4b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f3e:	ff 45 08             	incl   0x8(%ebp)
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f47:	72 e3                	jb     800f2c <memfind+0x13>
  800f49:	eb 01                	jmp    800f4c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4b:	90                   	nop
	return (void *) s;
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4f:	c9                   	leave  
  800f50:	c3                   	ret    

00800f51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	eb 03                	jmp    800f6a <strtol+0x19>
		s++;
  800f67:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 20                	cmp    $0x20,%al
  800f71:	74 f4                	je     800f67 <strtol+0x16>
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 09                	cmp    $0x9,%al
  800f7a:	74 eb                	je     800f67 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	8a 00                	mov    (%eax),%al
  800f81:	3c 2b                	cmp    $0x2b,%al
  800f83:	75 05                	jne    800f8a <strtol+0x39>
		s++;
  800f85:	ff 45 08             	incl   0x8(%ebp)
  800f88:	eb 13                	jmp    800f9d <strtol+0x4c>
	else if (*s == '-')
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	3c 2d                	cmp    $0x2d,%al
  800f91:	75 0a                	jne    800f9d <strtol+0x4c>
		s++, neg = 1;
  800f93:	ff 45 08             	incl   0x8(%ebp)
  800f96:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	74 06                	je     800fa9 <strtol+0x58>
  800fa3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa7:	75 20                	jne    800fc9 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 30                	cmp    $0x30,%al
  800fb0:	75 17                	jne    800fc9 <strtol+0x78>
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	40                   	inc    %eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 78                	cmp    $0x78,%al
  800fba:	75 0d                	jne    800fc9 <strtol+0x78>
		s += 2, base = 16;
  800fbc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc7:	eb 28                	jmp    800ff1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcd:	75 15                	jne    800fe4 <strtol+0x93>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 30                	cmp    $0x30,%al
  800fd6:	75 0c                	jne    800fe4 <strtol+0x93>
		s++, base = 8;
  800fd8:	ff 45 08             	incl   0x8(%ebp)
  800fdb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe2:	eb 0d                	jmp    800ff1 <strtol+0xa0>
	else if (base == 0)
  800fe4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe8:	75 07                	jne    800ff1 <strtol+0xa0>
		base = 10;
  800fea:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 2f                	cmp    $0x2f,%al
  800ff8:	7e 19                	jle    801013 <strtol+0xc2>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 39                	cmp    $0x39,%al
  801001:	7f 10                	jg     801013 <strtol+0xc2>
			dig = *s - '0';
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 30             	sub    $0x30,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801011:	eb 42                	jmp    801055 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 60                	cmp    $0x60,%al
  80101a:	7e 19                	jle    801035 <strtol+0xe4>
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	3c 7a                	cmp    $0x7a,%al
  801023:	7f 10                	jg     801035 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	0f be c0             	movsbl %al,%eax
  80102d:	83 e8 57             	sub    $0x57,%eax
  801030:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801033:	eb 20                	jmp    801055 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 40                	cmp    $0x40,%al
  80103c:	7e 39                	jle    801077 <strtol+0x126>
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	3c 5a                	cmp    $0x5a,%al
  801045:	7f 30                	jg     801077 <strtol+0x126>
			dig = *s - 'A' + 10;
  801047:	8b 45 08             	mov    0x8(%ebp),%eax
  80104a:	8a 00                	mov    (%eax),%al
  80104c:	0f be c0             	movsbl %al,%eax
  80104f:	83 e8 37             	sub    $0x37,%eax
  801052:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801058:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105b:	7d 19                	jge    801076 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105d:	ff 45 08             	incl   0x8(%ebp)
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	0f af 45 10          	imul   0x10(%ebp),%eax
  801067:	89 c2                	mov    %eax,%edx
  801069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106c:	01 d0                	add    %edx,%eax
  80106e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801071:	e9 7b ff ff ff       	jmp    800ff1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801076:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801077:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107b:	74 08                	je     801085 <strtol+0x134>
		*endptr = (char *) s;
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	8b 55 08             	mov    0x8(%ebp),%edx
  801083:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801085:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801089:	74 07                	je     801092 <strtol+0x141>
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	f7 d8                	neg    %eax
  801090:	eb 03                	jmp    801095 <strtol+0x144>
  801092:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801095:	c9                   	leave  
  801096:	c3                   	ret    

00801097 <ltostr>:

void
ltostr(long value, char *str)
{
  801097:	55                   	push   %ebp
  801098:	89 e5                	mov    %esp,%ebp
  80109a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010af:	79 13                	jns    8010c4 <ltostr+0x2d>
	{
		neg = 1;
  8010b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010be:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010cc:	99                   	cltd   
  8010cd:	f7 f9                	idiv   %ecx
  8010cf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d5:	8d 50 01             	lea    0x1(%eax),%edx
  8010d8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010db:	89 c2                	mov    %eax,%edx
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e5:	83 c2 30             	add    $0x30,%edx
  8010e8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ed:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f2:	f7 e9                	imul   %ecx
  8010f4:	c1 fa 02             	sar    $0x2,%edx
  8010f7:	89 c8                	mov    %ecx,%eax
  8010f9:	c1 f8 1f             	sar    $0x1f,%eax
  8010fc:	29 c2                	sub    %eax,%edx
  8010fe:	89 d0                	mov    %edx,%eax
  801100:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801103:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801107:	75 bb                	jne    8010c4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801109:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801110:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801113:	48                   	dec    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801117:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80111b:	74 3d                	je     80115a <ltostr+0xc3>
		start = 1 ;
  80111d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801124:	eb 34                	jmp    80115a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801126:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801129:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112c:	01 d0                	add    %edx,%eax
  80112e:	8a 00                	mov    (%eax),%al
  801130:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801133:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	01 c2                	add    %eax,%edx
  80113b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c8                	add    %ecx,%eax
  801143:	8a 00                	mov    (%eax),%al
  801145:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801147:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 c2                	add    %eax,%edx
  80114f:	8a 45 eb             	mov    -0x15(%ebp),%al
  801152:	88 02                	mov    %al,(%edx)
		start++ ;
  801154:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801157:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80115a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801160:	7c c4                	jl     801126 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801162:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801165:	8b 45 0c             	mov    0xc(%ebp),%eax
  801168:	01 d0                	add    %edx,%eax
  80116a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80116d:	90                   	nop
  80116e:	c9                   	leave  
  80116f:	c3                   	ret    

00801170 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801176:	ff 75 08             	pushl  0x8(%ebp)
  801179:	e8 73 fa ff ff       	call   800bf1 <strlen>
  80117e:	83 c4 04             	add    $0x4,%esp
  801181:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	e8 65 fa ff ff       	call   800bf1 <strlen>
  80118c:	83 c4 04             	add    $0x4,%esp
  80118f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801192:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011a0:	eb 17                	jmp    8011b9 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a8:	01 c2                	add    %eax,%edx
  8011aa:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	01 c8                	add    %ecx,%eax
  8011b2:	8a 00                	mov    (%eax),%al
  8011b4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011b6:	ff 45 fc             	incl   -0x4(%ebp)
  8011b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011bf:	7c e1                	jl     8011a2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011cf:	eb 1f                	jmp    8011f0 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d4:	8d 50 01             	lea    0x1(%eax),%edx
  8011d7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011da:	89 c2                	mov    %eax,%edx
  8011dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8011df:	01 c2                	add    %eax,%edx
  8011e1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e7:	01 c8                	add    %ecx,%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ed:	ff 45 f8             	incl   -0x8(%ebp)
  8011f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f6:	7c d9                	jl     8011d1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	c6 00 00             	movb   $0x0,(%eax)
}
  801203:	90                   	nop
  801204:	c9                   	leave  
  801205:	c3                   	ret    

00801206 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801209:	8b 45 14             	mov    0x14(%ebp),%eax
  80120c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801212:	8b 45 14             	mov    0x14(%ebp),%eax
  801215:	8b 00                	mov    (%eax),%eax
  801217:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801229:	eb 0c                	jmp    801237 <strsplit+0x31>
			*string++ = 0;
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8d 50 01             	lea    0x1(%eax),%edx
  801231:	89 55 08             	mov    %edx,0x8(%ebp)
  801234:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	84 c0                	test   %al,%al
  80123e:	74 18                	je     801258 <strsplit+0x52>
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	50                   	push   %eax
  801249:	ff 75 0c             	pushl  0xc(%ebp)
  80124c:	e8 32 fb ff ff       	call   800d83 <strchr>
  801251:	83 c4 08             	add    $0x8,%esp
  801254:	85 c0                	test   %eax,%eax
  801256:	75 d3                	jne    80122b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 5a                	je     8012bb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801261:	8b 45 14             	mov    0x14(%ebp),%eax
  801264:	8b 00                	mov    (%eax),%eax
  801266:	83 f8 0f             	cmp    $0xf,%eax
  801269:	75 07                	jne    801272 <strsplit+0x6c>
		{
			return 0;
  80126b:	b8 00 00 00 00       	mov    $0x0,%eax
  801270:	eb 66                	jmp    8012d8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801272:	8b 45 14             	mov    0x14(%ebp),%eax
  801275:	8b 00                	mov    (%eax),%eax
  801277:	8d 48 01             	lea    0x1(%eax),%ecx
  80127a:	8b 55 14             	mov    0x14(%ebp),%edx
  80127d:	89 0a                	mov    %ecx,(%edx)
  80127f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 c2                	add    %eax,%edx
  80128b:	8b 45 08             	mov    0x8(%ebp),%eax
  80128e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801290:	eb 03                	jmp    801295 <strsplit+0x8f>
			string++;
  801292:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801295:	8b 45 08             	mov    0x8(%ebp),%eax
  801298:	8a 00                	mov    (%eax),%al
  80129a:	84 c0                	test   %al,%al
  80129c:	74 8b                	je     801229 <strsplit+0x23>
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8a 00                	mov    (%eax),%al
  8012a3:	0f be c0             	movsbl %al,%eax
  8012a6:	50                   	push   %eax
  8012a7:	ff 75 0c             	pushl  0xc(%ebp)
  8012aa:	e8 d4 fa ff ff       	call   800d83 <strchr>
  8012af:	83 c4 08             	add    $0x8,%esp
  8012b2:	85 c0                	test   %eax,%eax
  8012b4:	74 dc                	je     801292 <strsplit+0x8c>
			string++;
	}
  8012b6:	e9 6e ff ff ff       	jmp    801229 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012bb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012bf:	8b 00                	mov    (%eax),%eax
  8012c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cb:	01 d0                	add    %edx,%eax
  8012cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012e0:	83 ec 04             	sub    $0x4,%esp
  8012e3:	68 08 23 80 00       	push   $0x802308
  8012e8:	68 3f 01 00 00       	push   $0x13f
  8012ed:	68 2a 23 80 00       	push   $0x80232a
  8012f2:	e8 a9 ef ff ff       	call   8002a0 <_panic>

008012f7 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	57                   	push   %edi
  8012fb:	56                   	push   %esi
  8012fc:	53                   	push   %ebx
  8012fd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	8b 55 0c             	mov    0xc(%ebp),%edx
  801306:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801309:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80130c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80130f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801312:	cd 30                	int    $0x30
  801314:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801317:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	5b                   	pop    %ebx
  80131e:	5e                   	pop    %esi
  80131f:	5f                   	pop    %edi
  801320:	5d                   	pop    %ebp
  801321:	c3                   	ret    

00801322 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
  801325:	83 ec 04             	sub    $0x4,%esp
  801328:	8b 45 10             	mov    0x10(%ebp),%eax
  80132b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80132e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	52                   	push   %edx
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	50                   	push   %eax
  80133e:	6a 00                	push   $0x0
  801340:	e8 b2 ff ff ff       	call   8012f7 <syscall>
  801345:	83 c4 18             	add    $0x18,%esp
}
  801348:	90                   	nop
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_cgetc>:

int sys_cgetc(void) {
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 02                	push   $0x2
  80135a:	e8 98 ff ff ff       	call   8012f7 <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <sys_lock_cons>:

void sys_lock_cons(void) {
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 03                	push   $0x3
  801373:	e8 7f ff ff ff       	call   8012f7 <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	90                   	nop
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    

0080137e <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 00                	push   $0x0
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 04                	push   $0x4
  80138d:	e8 65 ff ff ff       	call   8012f7 <syscall>
  801392:	83 c4 18             	add    $0x18,%esp
}
  801395:	90                   	nop
  801396:	c9                   	leave  
  801397:	c3                   	ret    

00801398 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801398:	55                   	push   %ebp
  801399:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80139b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	52                   	push   %edx
  8013a8:	50                   	push   %eax
  8013a9:	6a 08                	push   $0x8
  8013ab:	e8 47 ff ff ff       	call   8012f7 <syscall>
  8013b0:	83 c4 18             	add    $0x18,%esp
}
  8013b3:	c9                   	leave  
  8013b4:	c3                   	ret    

008013b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	56                   	push   %esi
  8013b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8013ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8013bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	56                   	push   %esi
  8013ca:	53                   	push   %ebx
  8013cb:	51                   	push   %ecx
  8013cc:	52                   	push   %edx
  8013cd:	50                   	push   %eax
  8013ce:	6a 09                	push   $0x9
  8013d0:	e8 22 ff ff ff       	call   8012f7 <syscall>
  8013d5:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8013d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013db:	5b                   	pop    %ebx
  8013dc:	5e                   	pop    %esi
  8013dd:	5d                   	pop    %ebp
  8013de:	c3                   	ret    

008013df <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8013df:	55                   	push   %ebp
  8013e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	52                   	push   %edx
  8013ef:	50                   	push   %eax
  8013f0:	6a 0a                	push   $0xa
  8013f2:	e8 00 ff ff ff       	call   8012f7 <syscall>
  8013f7:	83 c4 18             	add    $0x18,%esp
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	ff 75 0c             	pushl  0xc(%ebp)
  801408:	ff 75 08             	pushl  0x8(%ebp)
  80140b:	6a 0b                	push   $0xb
  80140d:	e8 e5 fe ff ff       	call   8012f7 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 0c                	push   $0xc
  801426:	e8 cc fe ff ff       	call   8012f7 <syscall>
  80142b:	83 c4 18             	add    $0x18,%esp
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 0d                	push   $0xd
  80143f:	e8 b3 fe ff ff       	call   8012f7 <syscall>
  801444:	83 c4 18             	add    $0x18,%esp
}
  801447:	c9                   	leave  
  801448:	c3                   	ret    

00801449 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 0e                	push   $0xe
  801458:	e8 9a fe ff ff       	call   8012f7 <syscall>
  80145d:	83 c4 18             	add    $0x18,%esp
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 0f                	push   $0xf
  801471:	e8 81 fe ff ff       	call   8012f7 <syscall>
  801476:	83 c4 18             	add    $0x18,%esp
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	ff 75 08             	pushl  0x8(%ebp)
  801489:	6a 10                	push   $0x10
  80148b:	e8 67 fe ff ff       	call   8012f7 <syscall>
  801490:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <sys_scarce_memory>:

void sys_scarce_memory() {
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 11                	push   $0x11
  8014a4:	e8 4e fe ff ff       	call   8012f7 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
}
  8014ac:	90                   	nop
  8014ad:	c9                   	leave  
  8014ae:	c3                   	ret    

008014af <sys_cputc>:

void sys_cputc(const char c) {
  8014af:	55                   	push   %ebp
  8014b0:	89 e5                	mov    %esp,%ebp
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	50                   	push   %eax
  8014c8:	6a 01                	push   $0x1
  8014ca:	e8 28 fe ff ff       	call   8012f7 <syscall>
  8014cf:	83 c4 18             	add    $0x18,%esp
}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 14                	push   $0x14
  8014e4:	e8 0e fe ff ff       	call   8012f7 <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
}
  8014ec:	90                   	nop
  8014ed:	c9                   	leave  
  8014ee:	c3                   	ret    

008014ef <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8014ef:	55                   	push   %ebp
  8014f0:	89 e5                	mov    %esp,%ebp
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8014fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	6a 00                	push   $0x0
  801507:	51                   	push   %ecx
  801508:	52                   	push   %edx
  801509:	ff 75 0c             	pushl  0xc(%ebp)
  80150c:	50                   	push   %eax
  80150d:	6a 15                	push   $0x15
  80150f:	e8 e3 fd ff ff       	call   8012f7 <syscall>
  801514:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80151c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	6a 00                	push   $0x0
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	52                   	push   %edx
  801529:	50                   	push   %eax
  80152a:	6a 16                	push   $0x16
  80152c:	e8 c6 fd ff ff       	call   8012f7 <syscall>
  801531:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801539:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80153c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80153f:	8b 45 08             	mov    0x8(%ebp),%eax
  801542:	6a 00                	push   $0x0
  801544:	6a 00                	push   $0x0
  801546:	51                   	push   %ecx
  801547:	52                   	push   %edx
  801548:	50                   	push   %eax
  801549:	6a 17                	push   $0x17
  80154b:	e8 a7 fd ff ff       	call   8012f7 <syscall>
  801550:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801553:	c9                   	leave  
  801554:	c3                   	ret    

00801555 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	6a 00                	push   $0x0
  801560:	6a 00                	push   $0x0
  801562:	6a 00                	push   $0x0
  801564:	52                   	push   %edx
  801565:	50                   	push   %eax
  801566:	6a 18                	push   $0x18
  801568:	e8 8a fd ff ff       	call   8012f7 <syscall>
  80156d:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801570:	c9                   	leave  
  801571:	c3                   	ret    

00801572 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801572:	55                   	push   %ebp
  801573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	6a 00                	push   $0x0
  80157a:	ff 75 14             	pushl  0x14(%ebp)
  80157d:	ff 75 10             	pushl  0x10(%ebp)
  801580:	ff 75 0c             	pushl  0xc(%ebp)
  801583:	50                   	push   %eax
  801584:	6a 19                	push   $0x19
  801586:	e8 6c fd ff ff       	call   8012f7 <syscall>
  80158b:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <sys_run_env>:

void sys_run_env(int32 envId) {
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	50                   	push   %eax
  80159f:	6a 1a                	push   $0x1a
  8015a1:	e8 51 fd ff ff       	call   8012f7 <syscall>
  8015a6:	83 c4 18             	add    $0x18,%esp
}
  8015a9:	90                   	nop
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	6a 00                	push   $0x0
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	50                   	push   %eax
  8015bb:	6a 1b                	push   $0x1b
  8015bd:	e8 35 fd ff ff       	call   8012f7 <syscall>
  8015c2:	83 c4 18             	add    $0x18,%esp
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <sys_getenvid>:

int32 sys_getenvid(void) {
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 05                	push   $0x5
  8015d6:	e8 1c fd ff ff       	call   8012f7 <syscall>
  8015db:	83 c4 18             	add    $0x18,%esp
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 06                	push   $0x6
  8015ef:	e8 03 fd ff ff       	call   8012f7 <syscall>
  8015f4:	83 c4 18             	add    $0x18,%esp
}
  8015f7:	c9                   	leave  
  8015f8:	c3                   	ret    

008015f9 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 07                	push   $0x7
  801608:	e8 ea fc ff ff       	call   8012f7 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_exit_env>:

void sys_exit_env(void) {
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 1c                	push   $0x1c
  801621:	e8 d1 fc ff ff       	call   8012f7 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	90                   	nop
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801632:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801635:	8d 50 04             	lea    0x4(%eax),%edx
  801638:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	52                   	push   %edx
  801642:	50                   	push   %eax
  801643:	6a 1d                	push   $0x1d
  801645:	e8 ad fc ff ff       	call   8012f7 <syscall>
  80164a:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80164d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801650:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801653:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801656:	89 01                	mov    %eax,(%ecx)
  801658:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	c9                   	leave  
  80165f:	c2 04 00             	ret    $0x4

00801662 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801665:	6a 00                	push   $0x0
  801667:	6a 00                	push   $0x0
  801669:	ff 75 10             	pushl  0x10(%ebp)
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	6a 13                	push   $0x13
  801674:	e8 7e fc ff ff       	call   8012f7 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80167c:	90                   	nop
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_rcr2>:
uint32 sys_rcr2() {
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 1e                	push   $0x1e
  80168e:	e8 64 fc ff ff       	call   8012f7 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	83 ec 04             	sub    $0x4,%esp
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016a4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	50                   	push   %eax
  8016b1:	6a 1f                	push   $0x1f
  8016b3:	e8 3f fc ff ff       	call   8012f7 <syscall>
  8016b8:	83 c4 18             	add    $0x18,%esp
	return;
  8016bb:	90                   	nop
}
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    

008016be <rsttst>:
void rsttst() {
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 00                	push   $0x0
  8016cb:	6a 21                	push   $0x21
  8016cd:	e8 25 fc ff ff       	call   8012f7 <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
	return;
  8016d5:	90                   	nop
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016e4:	8b 55 18             	mov    0x18(%ebp),%edx
  8016e7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	ff 75 10             	pushl  0x10(%ebp)
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	6a 20                	push   $0x20
  8016f8:	e8 fa fb ff ff       	call   8012f7 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
	return;
  801700:	90                   	nop
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <chktst>:
void chktst(uint32 n) {
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	6a 22                	push   $0x22
  801713:	e8 df fb ff ff       	call   8012f7 <syscall>
  801718:	83 c4 18             	add    $0x18,%esp
	return;
  80171b:	90                   	nop
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <inctst>:

void inctst() {
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801721:	6a 00                	push   $0x0
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 23                	push   $0x23
  80172d:	e8 c5 fb ff ff       	call   8012f7 <syscall>
  801732:	83 c4 18             	add    $0x18,%esp
	return;
  801735:	90                   	nop
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <gettst>:
uint32 gettst() {
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 00                	push   $0x0
  801745:	6a 24                	push   $0x24
  801747:	e8 ab fb ff ff       	call   8012f7 <syscall>
  80174c:	83 c4 18             	add    $0x18,%esp
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 25                	push   $0x25
  801763:	e8 8f fb ff ff       	call   8012f7 <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
  80176b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80176e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801772:	75 07                	jne    80177b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801774:	b8 01 00 00 00       	mov    $0x1,%eax
  801779:	eb 05                	jmp    801780 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80177b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801780:	c9                   	leave  
  801781:	c3                   	ret    

00801782 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801788:	6a 00                	push   $0x0
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 25                	push   $0x25
  801794:	e8 5e fb ff ff       	call   8012f7 <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
  80179c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80179f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017a3:	75 07                	jne    8017ac <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017aa:	eb 05                	jmp    8017b1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 25                	push   $0x25
  8017c5:	e8 2d fb ff ff       	call   8012f7 <syscall>
  8017ca:	83 c4 18             	add    $0x18,%esp
  8017cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017d0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017d4:	75 07                	jne    8017dd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017db:	eb 05                	jmp    8017e2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 25                	push   $0x25
  8017f6:	e8 fc fa ff ff       	call   8012f7 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
  8017fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801801:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801805:	75 07                	jne    80180e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801807:	b8 01 00 00 00       	mov    $0x1,%eax
  80180c:	eb 05                	jmp    801813 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80180e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801813:	c9                   	leave  
  801814:	c3                   	ret    

00801815 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	ff 75 08             	pushl  0x8(%ebp)
  801823:	6a 26                	push   $0x26
  801825:	e8 cd fa ff ff       	call   8012f7 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
	return;
  80182d:	90                   	nop
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801834:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801837:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	6a 00                	push   $0x0
  801842:	53                   	push   %ebx
  801843:	51                   	push   %ecx
  801844:	52                   	push   %edx
  801845:	50                   	push   %eax
  801846:	6a 27                	push   $0x27
  801848:	e8 aa fa ff ff       	call   8012f7 <syscall>
  80184d:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801850:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	52                   	push   %edx
  801865:	50                   	push   %eax
  801866:	6a 28                	push   $0x28
  801868:	e8 8a fa ff ff       	call   8012f7 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801875:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801878:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	6a 00                	push   $0x0
  801880:	51                   	push   %ecx
  801881:	ff 75 10             	pushl  0x10(%ebp)
  801884:	52                   	push   %edx
  801885:	50                   	push   %eax
  801886:	6a 29                	push   $0x29
  801888:	e8 6a fa ff ff       	call   8012f7 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	ff 75 10             	pushl  0x10(%ebp)
  80189c:	ff 75 0c             	pushl  0xc(%ebp)
  80189f:	ff 75 08             	pushl  0x8(%ebp)
  8018a2:	6a 12                	push   $0x12
  8018a4:	e8 4e fa ff ff       	call   8012f7 <syscall>
  8018a9:	83 c4 18             	add    $0x18,%esp
	return;
  8018ac:	90                   	nop
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	52                   	push   %edx
  8018bf:	50                   	push   %eax
  8018c0:	6a 2a                	push   $0x2a
  8018c2:	e8 30 fa ff ff       	call   8012f7 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
	return;
  8018ca:	90                   	nop
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	50                   	push   %eax
  8018dc:	6a 2b                	push   $0x2b
  8018de:	e8 14 fa ff ff       	call   8012f7 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 0c             	pushl  0xc(%ebp)
  8018f4:	ff 75 08             	pushl  0x8(%ebp)
  8018f7:	6a 2c                	push   $0x2c
  8018f9:	e8 f9 f9 ff ff       	call   8012f7 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
	return;
  801901:	90                   	nop
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	ff 75 08             	pushl  0x8(%ebp)
  801913:	6a 2d                	push   $0x2d
  801915:	e8 dd f9 ff ff       	call   8012f7 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
	return;
  80191d:	90                   	nop
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	50                   	push   %eax
  80192f:	6a 2f                	push   $0x2f
  801931:	e8 c1 f9 ff ff       	call   8012f7 <syscall>
  801936:	83 c4 18             	add    $0x18,%esp
	return;
  801939:	90                   	nop
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	52                   	push   %edx
  80194c:	50                   	push   %eax
  80194d:	6a 30                	push   $0x30
  80194f:	e8 a3 f9 ff ff       	call   8012f7 <syscall>
  801954:	83 c4 18             	add    $0x18,%esp
	return;
  801957:	90                   	nop
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	50                   	push   %eax
  801969:	6a 31                	push   $0x31
  80196b:	e8 87 f9 ff ff       	call   8012f7 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
	return;
  801973:	90                   	nop
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 2e                	push   $0x2e
  801989:	e8 69 f9 ff ff       	call   8012f7 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
    return;
  801991:	90                   	nop
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

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
