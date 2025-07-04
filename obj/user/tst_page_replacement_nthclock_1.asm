
obj/user/tst_page_replacement_nthclock_1:     file format elf32-i386


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
  800031:	e8 5b 01 00 00       	call   800191 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <fillPage>:
		0xeebfd000, /*will be created during the call of sys_check_WS_list*/ //Stack
		0x80a000, 0x804000, 0x80b000, 0x80c000,0x807000,0x800000,0x801000,0x808000,0x809000,0x803000,	//Code & Data
} ;

void fillPage(char* arr, int pageIdx, char val)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 14             	sub    $0x14,%esp
  80003e:	8b 45 10             	mov    0x10(%ebp),%eax
  800041:	88 45 ec             	mov    %al,-0x14(%ebp)
	for (int i = pageIdx*PAGE_SIZE; i < (pageIdx+1)*PAGE_SIZE; ++i)
  800044:	8b 45 0c             	mov    0xc(%ebp),%eax
  800047:	c1 e0 0c             	shl    $0xc,%eax
  80004a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80004d:	eb 10                	jmp    80005f <fillPage+0x27>
	{
		arr[i] = val;
  80004f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800052:	8b 45 08             	mov    0x8(%ebp),%eax
  800055:	01 c2                	add    %eax,%edx
  800057:	8a 45 ec             	mov    -0x14(%ebp),%al
  80005a:	88 02                	mov    %al,(%edx)
		0x80a000, 0x804000, 0x80b000, 0x80c000,0x807000,0x800000,0x801000,0x808000,0x809000,0x803000,	//Code & Data
} ;

void fillPage(char* arr, int pageIdx, char val)
{
	for (int i = pageIdx*PAGE_SIZE; i < (pageIdx+1)*PAGE_SIZE; ++i)
  80005c:	ff 45 fc             	incl   -0x4(%ebp)
  80005f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800062:	40                   	inc    %eax
  800063:	c1 e0 0c             	shl    $0xc,%eax
  800066:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800069:	7f e4                	jg     80004f <fillPage+0x17>
	{
		arr[i] = val;
	}
}
  80006b:	90                   	nop
  80006c:	c9                   	leave  
  80006d:	c3                   	ret    

0080006e <_main>:

void _main(void)
{
  80006e:	55                   	push   %ebp
  80006f:	89 e5                	mov    %esp,%ebp
  800071:	83 ec 28             	sub    $0x28,%esp
	//("STEP 0: checking Initial WS entries ...\n");
	bool found ;

#if USE_KHEAP
	{
		found = sys_check_WS_list(expectedInitialVAs, 11, 0x200000, 1);
  800074:	6a 01                	push   $0x1
  800076:	68 00 00 20 00       	push   $0x200000
  80007b:	6a 0b                	push   $0xb
  80007d:	68 20 30 80 00       	push   $0x803020
  800082:	e8 21 18 00 00       	call   8018a8 <sys_check_WS_list>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("INITIAL PAGE WS entry checking failed! Review size of the WS!!\n*****IF CORRECT, CHECK THE ISSUE WITH THE STAFF*****");
  80008d:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  800091:	74 14                	je     8000a7 <_main+0x39>
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	68 40 1c 80 00       	push   $0x801c40
  80009b:	6a 26                	push   $0x26
  80009d:	68 b4 1c 80 00       	push   $0x801cb4
  8000a2:	e8 2f 02 00 00       	call   8002d6 <_panic>
	}
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif

	int freePages = sys_calculate_free_frames();
  8000a7:	e8 a1 13 00 00       	call   80144d <sys_calculate_free_frames>
  8000ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000af:	e8 e4 13 00 00       	call   801498 <sys_pf_calculate_allocated_pages>
  8000b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	//Reading (Not Modified)
	char garbage1 = arr[PAGE_SIZE*11-1] ;
  8000b7:	a0 bf e0 80 00       	mov    0x80e0bf,%al
  8000bc:	88 45 e3             	mov    %al,-0x1d(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
  8000bf:	a0 bf f0 80 00       	mov    0x80f0bf,%al
  8000c4:	88 45 e2             	mov    %al,-0x1e(%ebp)
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000ce:	eb 32                	jmp    800102 <_main+0x94>
	{
		arr[i] = 'A' ;
  8000d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000d3:	05 c0 30 80 00       	add    $0x8030c0,%eax
  8000d8:	c6 00 41             	movb   $0x41,(%eax)
		/*2016: this BUGGY line is REMOVED el7! it overwrites the KERNEL CODE :( !!!*/
		//*ptr = *ptr2 ;
		/*==========================================================================*/
		//always use pages at 0x801000 and 0x804000
		garbage4 = *ptr ;
  8000db:	a1 00 30 80 00       	mov    0x803000,%eax
  8000e0:	8a 00                	mov    (%eax),%al
  8000e2:	88 45 f7             	mov    %al,-0x9(%ebp)
		if (i % PAGE_SIZE == 0)
  8000e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e8:	25 ff 0f 00 00       	and    $0xfff,%eax
  8000ed:	85 c0                	test   %eax,%eax
  8000ef:	75 0a                	jne    8000fb <_main+0x8d>
			garbage5 = *ptr2 ;
  8000f1:	a1 04 30 80 00       	mov    0x803004,%eax
  8000f6:	8a 00                	mov    (%eax),%al
  8000f8:	88 45 f6             	mov    %al,-0xa(%ebp)
	char garbage2 = arr[PAGE_SIZE*12-1] ;
	char garbage4,garbage5;

	//Writing (Modified)
	int i ;
	for (i = 0 ; i < PAGE_SIZE*10 ; i+=PAGE_SIZE/2)
  8000fb:	81 45 f0 00 08 00 00 	addl   $0x800,-0x10(%ebp)
  800102:	81 7d f0 ff 9f 00 00 	cmpl   $0x9fff,-0x10(%ebp)
  800109:	7e c5                	jle    8000d0 <_main+0x62>

	//===================

	//cprintf("Checking PAGE nth clock algorithm... \n");
	{
		found = sys_check_WS_list(expectedFinalVAs, 11, 0x807000, 1);
  80010b:	6a 01                	push   $0x1
  80010d:	68 00 70 80 00       	push   $0x807000
  800112:	6a 0b                	push   $0xb
  800114:	68 60 30 80 00       	push   $0x803060
  800119:	e8 8a 17 00 00       	call   8018a8 <sys_check_WS_list>
  80011e:	83 c4 10             	add    $0x10,%esp
  800121:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (found != 1) panic("Page Nth clock algo failed.. trace it by printing WS before and after page fault");
  800124:	83 7d ec 01          	cmpl   $0x1,-0x14(%ebp)
  800128:	74 14                	je     80013e <_main+0xd0>
  80012a:	83 ec 04             	sub    $0x4,%esp
  80012d:	68 dc 1c 80 00       	push   $0x801cdc
  800132:	6a 4e                	push   $0x4e
  800134:	68 b4 1c 80 00       	push   $0x801cb4
  800139:	e8 98 01 00 00       	call   8002d6 <_panic>
	}
	{
		if (garbage4 != *ptr) panic("test failed!");
  80013e:	a1 00 30 80 00       	mov    0x803000,%eax
  800143:	8a 00                	mov    (%eax),%al
  800145:	3a 45 f7             	cmp    -0x9(%ebp),%al
  800148:	74 14                	je     80015e <_main+0xf0>
  80014a:	83 ec 04             	sub    $0x4,%esp
  80014d:	68 2d 1d 80 00       	push   $0x801d2d
  800152:	6a 51                	push   $0x51
  800154:	68 b4 1c 80 00       	push   $0x801cb4
  800159:	e8 78 01 00 00       	call   8002d6 <_panic>
		if (garbage5 != *ptr2) panic("test failed!");
  80015e:	a1 04 30 80 00       	mov    0x803004,%eax
  800163:	8a 00                	mov    (%eax),%al
  800165:	3a 45 f6             	cmp    -0xa(%ebp),%al
  800168:	74 14                	je     80017e <_main+0x110>
  80016a:	83 ec 04             	sub    $0x4,%esp
  80016d:	68 2d 1d 80 00       	push   $0x801d2d
  800172:	6a 52                	push   $0x52
  800174:	68 b4 1c 80 00       	push   $0x801cb4
  800179:	e8 58 01 00 00       	call   8002d6 <_panic>
	}

	cprintf("Congratulations!! test PAGE replacement [Nth clock Alg.] is completed successfully.\n");
  80017e:	83 ec 0c             	sub    $0xc,%esp
  800181:	68 3c 1d 80 00       	push   $0x801d3c
  800186:	e8 08 04 00 00       	call   800593 <cprintf>
  80018b:	83 c4 10             	add    $0x10,%esp
	return;
  80018e:	90                   	nop
}
  80018f:	c9                   	leave  
  800190:	c3                   	ret    

00800191 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800191:	55                   	push   %ebp
  800192:	89 e5                	mov    %esp,%ebp
  800194:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800197:	e8 7a 14 00 00       	call   801616 <sys_getenvindex>
  80019c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80019f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a2:	89 d0                	mov    %edx,%eax
  8001a4:	c1 e0 02             	shl    $0x2,%eax
  8001a7:	01 d0                	add    %edx,%eax
  8001a9:	c1 e0 03             	shl    $0x3,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 02             	shl    $0x2,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 a0 30 80 00       	mov    %eax,0x8030a0

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001c9:	8a 40 20             	mov    0x20(%eax),%al
  8001cc:	84 c0                	test   %al,%al
  8001ce:	74 0d                	je     8001dd <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8001d0:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8001d5:	83 c0 20             	add    $0x20,%eax
  8001d8:	a3 90 30 80 00       	mov    %eax,0x803090

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e1:	7e 0a                	jle    8001ed <libmain+0x5c>
		binaryname = argv[0];
  8001e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e6:	8b 00                	mov    (%eax),%eax
  8001e8:	a3 90 30 80 00       	mov    %eax,0x803090

	// call user main routine
	_main(argc, argv);
  8001ed:	83 ec 08             	sub    $0x8,%esp
  8001f0:	ff 75 0c             	pushl  0xc(%ebp)
  8001f3:	ff 75 08             	pushl  0x8(%ebp)
  8001f6:	e8 73 fe ff ff       	call   80006e <_main>
  8001fb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001fe:	a1 8c 30 80 00       	mov    0x80308c,%eax
  800203:	85 c0                	test   %eax,%eax
  800205:	0f 84 9f 00 00 00    	je     8002aa <libmain+0x119>
	{
		sys_lock_cons();
  80020b:	e8 8a 11 00 00       	call   80139a <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	68 ac 1d 80 00       	push   $0x801dac
  800218:	e8 76 03 00 00       	call   800593 <cprintf>
  80021d:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800220:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800225:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80022b:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800230:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800236:	83 ec 04             	sub    $0x4,%esp
  800239:	52                   	push   %edx
  80023a:	50                   	push   %eax
  80023b:	68 d4 1d 80 00       	push   $0x801dd4
  800240:	e8 4e 03 00 00       	call   800593 <cprintf>
  800245:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800248:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80024d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800253:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800258:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80025e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800263:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800269:	51                   	push   %ecx
  80026a:	52                   	push   %edx
  80026b:	50                   	push   %eax
  80026c:	68 fc 1d 80 00       	push   $0x801dfc
  800271:	e8 1d 03 00 00       	call   800593 <cprintf>
  800276:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800279:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80027e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800284:	83 ec 08             	sub    $0x8,%esp
  800287:	50                   	push   %eax
  800288:	68 54 1e 80 00       	push   $0x801e54
  80028d:	e8 01 03 00 00       	call   800593 <cprintf>
  800292:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800295:	83 ec 0c             	sub    $0xc,%esp
  800298:	68 ac 1d 80 00       	push   $0x801dac
  80029d:	e8 f1 02 00 00       	call   800593 <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002a5:	e8 0a 11 00 00       	call   8013b4 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002aa:	e8 19 00 00 00       	call   8002c8 <exit>
}
  8002af:	90                   	nop
  8002b0:	c9                   	leave  
  8002b1:	c3                   	ret    

008002b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002b2:	55                   	push   %ebp
  8002b3:	89 e5                	mov    %esp,%ebp
  8002b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	6a 00                	push   $0x0
  8002bd:	e8 20 13 00 00       	call   8015e2 <sys_destroy_env>
  8002c2:	83 c4 10             	add    $0x10,%esp
}
  8002c5:	90                   	nop
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <exit>:

void
exit(void)
{
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ce:	e8 75 13 00 00       	call   801648 <sys_exit_env>
}
  8002d3:	90                   	nop
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002df:	83 c0 04             	add    $0x4,%eax
  8002e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e5:	a1 dc f0 80 00       	mov    0x80f0dc,%eax
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	74 16                	je     800304 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ee:	a1 dc f0 80 00       	mov    0x80f0dc,%eax
  8002f3:	83 ec 08             	sub    $0x8,%esp
  8002f6:	50                   	push   %eax
  8002f7:	68 68 1e 80 00       	push   $0x801e68
  8002fc:	e8 92 02 00 00       	call   800593 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800304:	a1 90 30 80 00       	mov    0x803090,%eax
  800309:	ff 75 0c             	pushl  0xc(%ebp)
  80030c:	ff 75 08             	pushl  0x8(%ebp)
  80030f:	50                   	push   %eax
  800310:	68 6d 1e 80 00       	push   $0x801e6d
  800315:	e8 79 02 00 00       	call   800593 <cprintf>
  80031a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80031d:	8b 45 10             	mov    0x10(%ebp),%eax
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 f4             	pushl  -0xc(%ebp)
  800326:	50                   	push   %eax
  800327:	e8 fc 01 00 00       	call   800528 <vcprintf>
  80032c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032f:	83 ec 08             	sub    $0x8,%esp
  800332:	6a 00                	push   $0x0
  800334:	68 89 1e 80 00       	push   $0x801e89
  800339:	e8 ea 01 00 00       	call   800528 <vcprintf>
  80033e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800341:	e8 82 ff ff ff       	call   8002c8 <exit>

	// should not return here
	while (1) ;
  800346:	eb fe                	jmp    800346 <_panic+0x70>

00800348 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80034e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800353:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035c:	39 c2                	cmp    %eax,%edx
  80035e:	74 14                	je     800374 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800360:	83 ec 04             	sub    $0x4,%esp
  800363:	68 8c 1e 80 00       	push   $0x801e8c
  800368:	6a 26                	push   $0x26
  80036a:	68 d8 1e 80 00       	push   $0x801ed8
  80036f:	e8 62 ff ff ff       	call   8002d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800374:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800382:	e9 c5 00 00 00       	jmp    80044c <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80038a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	01 d0                	add    %edx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	75 08                	jne    8003a4 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80039c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80039f:	e9 a5 00 00 00       	jmp    800449 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003b2:	eb 69                	jmp    80041d <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003b4:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8003b9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c2:	89 d0                	mov    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	01 d0                	add    %edx,%eax
  8003c8:	c1 e0 03             	shl    $0x3,%eax
  8003cb:	01 c8                	add    %ecx,%eax
  8003cd:	8a 40 04             	mov    0x4(%eax),%al
  8003d0:	84 c0                	test   %al,%al
  8003d2:	75 46                	jne    80041a <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003d4:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  8003d9:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003e2:	89 d0                	mov    %edx,%eax
  8003e4:	01 c0                	add    %eax,%eax
  8003e6:	01 d0                	add    %edx,%eax
  8003e8:	c1 e0 03             	shl    $0x3,%eax
  8003eb:	01 c8                	add    %ecx,%eax
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003fa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ff:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	01 c8                	add    %ecx,%eax
  80040b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80040d:	39 c2                	cmp    %eax,%edx
  80040f:	75 09                	jne    80041a <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800411:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800418:	eb 15                	jmp    80042f <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80041a:	ff 45 e8             	incl   -0x18(%ebp)
  80041d:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800422:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80042b:	39 c2                	cmp    %eax,%edx
  80042d:	77 85                	ja     8003b4 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80042f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800433:	75 14                	jne    800449 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800435:	83 ec 04             	sub    $0x4,%esp
  800438:	68 e4 1e 80 00       	push   $0x801ee4
  80043d:	6a 3a                	push   $0x3a
  80043f:	68 d8 1e 80 00       	push   $0x801ed8
  800444:	e8 8d fe ff ff       	call   8002d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800449:	ff 45 f0             	incl   -0x10(%ebp)
  80044c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800452:	0f 8c 2f ff ff ff    	jl     800387 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800458:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80045f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800466:	eb 26                	jmp    80048e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800468:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  80046d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800473:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800476:	89 d0                	mov    %edx,%eax
  800478:	01 c0                	add    %eax,%eax
  80047a:	01 d0                	add    %edx,%eax
  80047c:	c1 e0 03             	shl    $0x3,%eax
  80047f:	01 c8                	add    %ecx,%eax
  800481:	8a 40 04             	mov    0x4(%eax),%al
  800484:	3c 01                	cmp    $0x1,%al
  800486:	75 03                	jne    80048b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800488:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80048b:	ff 45 e0             	incl   -0x20(%ebp)
  80048e:	a1 a0 30 80 00       	mov    0x8030a0,%eax
  800493:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80049c:	39 c2                	cmp    %eax,%edx
  80049e:	77 c8                	ja     800468 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004a3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004a6:	74 14                	je     8004bc <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 38 1f 80 00       	push   $0x801f38
  8004b0:	6a 44                	push   $0x44
  8004b2:	68 d8 1e 80 00       	push   $0x801ed8
  8004b7:	e8 1a fe ff ff       	call   8002d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004bc:	90                   	nop
  8004bd:	c9                   	leave  
  8004be:	c3                   	ret    

008004bf <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004bf:	55                   	push   %ebp
  8004c0:	89 e5                	mov    %esp,%ebp
  8004c2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8004cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d0:	89 0a                	mov    %ecx,(%edx)
  8004d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8004d5:	88 d1                	mov    %dl,%cl
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e1:	8b 00                	mov    (%eax),%eax
  8004e3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004e8:	75 2c                	jne    800516 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004ea:	a0 c0 f0 80 00       	mov    0x80f0c0,%al
  8004ef:	0f b6 c0             	movzbl %al,%eax
  8004f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f5:	8b 12                	mov    (%edx),%edx
  8004f7:	89 d1                	mov    %edx,%ecx
  8004f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004fc:	83 c2 08             	add    $0x8,%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	51                   	push   %ecx
  800504:	52                   	push   %edx
  800505:	e8 4e 0e 00 00       	call   801358 <sys_cputs>
  80050a:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80050d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800516:	8b 45 0c             	mov    0xc(%ebp),%eax
  800519:	8b 40 04             	mov    0x4(%eax),%eax
  80051c:	8d 50 01             	lea    0x1(%eax),%edx
  80051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800522:	89 50 04             	mov    %edx,0x4(%eax)
}
  800525:	90                   	nop
  800526:	c9                   	leave  
  800527:	c3                   	ret    

00800528 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800528:	55                   	push   %ebp
  800529:	89 e5                	mov    %esp,%ebp
  80052b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800531:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800538:	00 00 00 
	b.cnt = 0;
  80053b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800542:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800545:	ff 75 0c             	pushl  0xc(%ebp)
  800548:	ff 75 08             	pushl  0x8(%ebp)
  80054b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800551:	50                   	push   %eax
  800552:	68 bf 04 80 00       	push   $0x8004bf
  800557:	e8 11 02 00 00       	call   80076d <vprintfmt>
  80055c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80055f:	a0 c0 f0 80 00       	mov    0x80f0c0,%al
  800564:	0f b6 c0             	movzbl %al,%eax
  800567:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80056d:	83 ec 04             	sub    $0x4,%esp
  800570:	50                   	push   %eax
  800571:	52                   	push   %edx
  800572:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800578:	83 c0 08             	add    $0x8,%eax
  80057b:	50                   	push   %eax
  80057c:	e8 d7 0d 00 00       	call   801358 <sys_cputs>
  800581:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800584:	c6 05 c0 f0 80 00 00 	movb   $0x0,0x80f0c0
	return b.cnt;
  80058b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800599:	c6 05 c0 f0 80 00 01 	movb   $0x1,0x80f0c0
	va_start(ap, fmt);
  8005a0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	83 ec 08             	sub    $0x8,%esp
  8005ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8005af:	50                   	push   %eax
  8005b0:	e8 73 ff ff ff       	call   800528 <vcprintf>
  8005b5:	83 c4 10             	add    $0x10,%esp
  8005b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005be:	c9                   	leave  
  8005bf:	c3                   	ret    

008005c0 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005c6:	e8 cf 0d 00 00       	call   80139a <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8005cb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005da:	50                   	push   %eax
  8005db:	e8 48 ff ff ff       	call   800528 <vcprintf>
  8005e0:	83 c4 10             	add    $0x10,%esp
  8005e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8005e6:	e8 c9 0d 00 00       	call   8013b4 <sys_unlock_cons>
	return cnt;
  8005eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ee:	c9                   	leave  
  8005ef:	c3                   	ret    

008005f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005f0:	55                   	push   %ebp
  8005f1:	89 e5                	mov    %esp,%ebp
  8005f3:	53                   	push   %ebx
  8005f4:	83 ec 14             	sub    $0x14,%esp
  8005f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8005fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800603:	8b 45 18             	mov    0x18(%ebp),%eax
  800606:	ba 00 00 00 00       	mov    $0x0,%edx
  80060b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80060e:	77 55                	ja     800665 <printnum+0x75>
  800610:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800613:	72 05                	jb     80061a <printnum+0x2a>
  800615:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800618:	77 4b                	ja     800665 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80061a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80061d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800620:	8b 45 18             	mov    0x18(%ebp),%eax
  800623:	ba 00 00 00 00       	mov    $0x0,%edx
  800628:	52                   	push   %edx
  800629:	50                   	push   %eax
  80062a:	ff 75 f4             	pushl  -0xc(%ebp)
  80062d:	ff 75 f0             	pushl  -0x10(%ebp)
  800630:	e8 97 13 00 00       	call   8019cc <__udivdi3>
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	ff 75 20             	pushl  0x20(%ebp)
  80063e:	53                   	push   %ebx
  80063f:	ff 75 18             	pushl  0x18(%ebp)
  800642:	52                   	push   %edx
  800643:	50                   	push   %eax
  800644:	ff 75 0c             	pushl  0xc(%ebp)
  800647:	ff 75 08             	pushl  0x8(%ebp)
  80064a:	e8 a1 ff ff ff       	call   8005f0 <printnum>
  80064f:	83 c4 20             	add    $0x20,%esp
  800652:	eb 1a                	jmp    80066e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800654:	83 ec 08             	sub    $0x8,%esp
  800657:	ff 75 0c             	pushl  0xc(%ebp)
  80065a:	ff 75 20             	pushl  0x20(%ebp)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	ff d0                	call   *%eax
  800662:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800665:	ff 4d 1c             	decl   0x1c(%ebp)
  800668:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80066c:	7f e6                	jg     800654 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80066e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800671:	bb 00 00 00 00       	mov    $0x0,%ebx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80067c:	53                   	push   %ebx
  80067d:	51                   	push   %ecx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	e8 57 14 00 00       	call   801adc <__umoddi3>
  800685:	83 c4 10             	add    $0x10,%esp
  800688:	05 b4 21 80 00       	add    $0x8021b4,%eax
  80068d:	8a 00                	mov    (%eax),%al
  80068f:	0f be c0             	movsbl %al,%eax
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	50                   	push   %eax
  800699:	8b 45 08             	mov    0x8(%ebp),%eax
  80069c:	ff d0                	call   *%eax
  80069e:	83 c4 10             	add    $0x10,%esp
}
  8006a1:	90                   	nop
  8006a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006a5:	c9                   	leave  
  8006a6:	c3                   	ret    

008006a7 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006a7:	55                   	push   %ebp
  8006a8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006aa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ae:	7e 1c                	jle    8006cc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 08             	lea    0x8(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 08             	sub    $0x8,%eax
  8006c5:	8b 50 04             	mov    0x4(%eax),%edx
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	eb 40                	jmp    80070c <getuint+0x65>
	else if (lflag)
  8006cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d0:	74 1e                	je     8006f0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	8d 50 04             	lea    0x4(%eax),%edx
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 10                	mov    %edx,(%eax)
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	83 e8 04             	sub    $0x4,%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ee:	eb 1c                	jmp    80070c <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	8d 50 04             	lea    0x4(%eax),%edx
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	89 10                	mov    %edx,(%eax)
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	83 e8 04             	sub    $0x4,%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80070c:	5d                   	pop    %ebp
  80070d:	c3                   	ret    

0080070e <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80070e:	55                   	push   %ebp
  80070f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800711:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800715:	7e 1c                	jle    800733 <getint+0x25>
		return va_arg(*ap, long long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 08             	lea    0x8(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 08             	sub    $0x8,%eax
  80072c:	8b 50 04             	mov    0x4(%eax),%edx
  80072f:	8b 00                	mov    (%eax),%eax
  800731:	eb 38                	jmp    80076b <getint+0x5d>
	else if (lflag)
  800733:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800737:	74 1a                	je     800753 <getint+0x45>
		return va_arg(*ap, long);
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	8d 50 04             	lea    0x4(%eax),%edx
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	89 10                	mov    %edx,(%eax)
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	83 e8 04             	sub    $0x4,%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	99                   	cltd   
  800751:	eb 18                	jmp    80076b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	8d 50 04             	lea    0x4(%eax),%edx
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 10                	mov    %edx,(%eax)
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	8b 00                	mov    (%eax),%eax
  800765:	83 e8 04             	sub    $0x4,%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	99                   	cltd   
}
  80076b:	5d                   	pop    %ebp
  80076c:	c3                   	ret    

0080076d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	56                   	push   %esi
  800771:	53                   	push   %ebx
  800772:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800775:	eb 17                	jmp    80078e <vprintfmt+0x21>
			if (ch == '\0')
  800777:	85 db                	test   %ebx,%ebx
  800779:	0f 84 c1 03 00 00    	je     800b40 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	ff 75 0c             	pushl  0xc(%ebp)
  800785:	53                   	push   %ebx
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	ff d0                	call   *%eax
  80078b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80078e:	8b 45 10             	mov    0x10(%ebp),%eax
  800791:	8d 50 01             	lea    0x1(%eax),%edx
  800794:	89 55 10             	mov    %edx,0x10(%ebp)
  800797:	8a 00                	mov    (%eax),%al
  800799:	0f b6 d8             	movzbl %al,%ebx
  80079c:	83 fb 25             	cmp    $0x25,%ebx
  80079f:	75 d6                	jne    800777 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007a1:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007a5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007ac:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ba:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c4:	8d 50 01             	lea    0x1(%eax),%edx
  8007c7:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ca:	8a 00                	mov    (%eax),%al
  8007cc:	0f b6 d8             	movzbl %al,%ebx
  8007cf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007d2:	83 f8 5b             	cmp    $0x5b,%eax
  8007d5:	0f 87 3d 03 00 00    	ja     800b18 <vprintfmt+0x3ab>
  8007db:	8b 04 85 d8 21 80 00 	mov    0x8021d8(,%eax,4),%eax
  8007e2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007e4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007e8:	eb d7                	jmp    8007c1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007ea:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007ee:	eb d1                	jmp    8007c1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	c1 e0 02             	shl    $0x2,%eax
  8007ff:	01 d0                	add    %edx,%eax
  800801:	01 c0                	add    %eax,%eax
  800803:	01 d8                	add    %ebx,%eax
  800805:	83 e8 30             	sub    $0x30,%eax
  800808:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80080b:	8b 45 10             	mov    0x10(%ebp),%eax
  80080e:	8a 00                	mov    (%eax),%al
  800810:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800813:	83 fb 2f             	cmp    $0x2f,%ebx
  800816:	7e 3e                	jle    800856 <vprintfmt+0xe9>
  800818:	83 fb 39             	cmp    $0x39,%ebx
  80081b:	7f 39                	jg     800856 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80081d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800820:	eb d5                	jmp    8007f7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 c0 04             	add    $0x4,%eax
  800828:	89 45 14             	mov    %eax,0x14(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	83 e8 04             	sub    $0x4,%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800836:	eb 1f                	jmp    800857 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800838:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083c:	79 83                	jns    8007c1 <vprintfmt+0x54>
				width = 0;
  80083e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800845:	e9 77 ff ff ff       	jmp    8007c1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80084a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800851:	e9 6b ff ff ff       	jmp    8007c1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800856:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085b:	0f 89 60 ff ff ff    	jns    8007c1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800861:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800867:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80086e:	e9 4e ff ff ff       	jmp    8007c1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800873:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800876:	e9 46 ff ff ff       	jmp    8007c1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80087b:	8b 45 14             	mov    0x14(%ebp),%eax
  80087e:	83 c0 04             	add    $0x4,%eax
  800881:	89 45 14             	mov    %eax,0x14(%ebp)
  800884:	8b 45 14             	mov    0x14(%ebp),%eax
  800887:	83 e8 04             	sub    $0x4,%eax
  80088a:	8b 00                	mov    (%eax),%eax
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	ff 75 0c             	pushl  0xc(%ebp)
  800892:	50                   	push   %eax
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	ff d0                	call   *%eax
  800898:	83 c4 10             	add    $0x10,%esp
			break;
  80089b:	e9 9b 02 00 00       	jmp    800b3b <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 c0 04             	add    $0x4,%eax
  8008a6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008b1:	85 db                	test   %ebx,%ebx
  8008b3:	79 02                	jns    8008b7 <vprintfmt+0x14a>
				err = -err;
  8008b5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008b7:	83 fb 64             	cmp    $0x64,%ebx
  8008ba:	7f 0b                	jg     8008c7 <vprintfmt+0x15a>
  8008bc:	8b 34 9d 20 20 80 00 	mov    0x802020(,%ebx,4),%esi
  8008c3:	85 f6                	test   %esi,%esi
  8008c5:	75 19                	jne    8008e0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008c7:	53                   	push   %ebx
  8008c8:	68 c5 21 80 00       	push   $0x8021c5
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 70 02 00 00       	call   800b48 <printfmt>
  8008d8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008db:	e9 5b 02 00 00       	jmp    800b3b <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008e0:	56                   	push   %esi
  8008e1:	68 ce 21 80 00       	push   $0x8021ce
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	ff 75 08             	pushl  0x8(%ebp)
  8008ec:	e8 57 02 00 00       	call   800b48 <printfmt>
  8008f1:	83 c4 10             	add    $0x10,%esp
			break;
  8008f4:	e9 42 02 00 00       	jmp    800b3b <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 30                	mov    (%eax),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 05                	jne    800913 <vprintfmt+0x1a6>
				p = "(null)";
  80090e:	be d1 21 80 00       	mov    $0x8021d1,%esi
			if (width > 0 && padc != '-')
  800913:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800917:	7e 6d                	jle    800986 <vprintfmt+0x219>
  800919:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80091d:	74 67                	je     800986 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	83 ec 08             	sub    $0x8,%esp
  800925:	50                   	push   %eax
  800926:	56                   	push   %esi
  800927:	e8 1e 03 00 00       	call   800c4a <strnlen>
  80092c:	83 c4 10             	add    $0x10,%esp
  80092f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800932:	eb 16                	jmp    80094a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800934:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	ff 75 0c             	pushl  0xc(%ebp)
  80093e:	50                   	push   %eax
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e4                	jg     800934 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800950:	eb 34                	jmp    800986 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800952:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800956:	74 1c                	je     800974 <vprintfmt+0x207>
  800958:	83 fb 1f             	cmp    $0x1f,%ebx
  80095b:	7e 05                	jle    800962 <vprintfmt+0x1f5>
  80095d:	83 fb 7e             	cmp    $0x7e,%ebx
  800960:	7e 12                	jle    800974 <vprintfmt+0x207>
					putch('?', putdat);
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	6a 3f                	push   $0x3f
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
  800972:	eb 0f                	jmp    800983 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 0c             	pushl  0xc(%ebp)
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	ff d0                	call   *%eax
  800980:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800983:	ff 4d e4             	decl   -0x1c(%ebp)
  800986:	89 f0                	mov    %esi,%eax
  800988:	8d 70 01             	lea    0x1(%eax),%esi
  80098b:	8a 00                	mov    (%eax),%al
  80098d:	0f be d8             	movsbl %al,%ebx
  800990:	85 db                	test   %ebx,%ebx
  800992:	74 24                	je     8009b8 <vprintfmt+0x24b>
  800994:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800998:	78 b8                	js     800952 <vprintfmt+0x1e5>
  80099a:	ff 4d e0             	decl   -0x20(%ebp)
  80099d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a1:	79 af                	jns    800952 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a3:	eb 13                	jmp    8009b8 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009a5:	83 ec 08             	sub    $0x8,%esp
  8009a8:	ff 75 0c             	pushl  0xc(%ebp)
  8009ab:	6a 20                	push   $0x20
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	ff d0                	call   *%eax
  8009b2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009b5:	ff 4d e4             	decl   -0x1c(%ebp)
  8009b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009bc:	7f e7                	jg     8009a5 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009be:	e9 78 01 00 00       	jmp    800b3b <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009c9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009cc:	50                   	push   %eax
  8009cd:	e8 3c fd ff ff       	call   80070e <getint>
  8009d2:	83 c4 10             	add    $0x10,%esp
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009e1:	85 d2                	test   %edx,%edx
  8009e3:	79 23                	jns    800a08 <vprintfmt+0x29b>
				putch('-', putdat);
  8009e5:	83 ec 08             	sub    $0x8,%esp
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	6a 2d                	push   $0x2d
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	ff d0                	call   *%eax
  8009f2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009fb:	f7 d8                	neg    %eax
  8009fd:	83 d2 00             	adc    $0x0,%edx
  800a00:	f7 da                	neg    %edx
  800a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a08:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0f:	e9 bc 00 00 00       	jmp    800ad0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a14:	83 ec 08             	sub    $0x8,%esp
  800a17:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a1d:	50                   	push   %eax
  800a1e:	e8 84 fc ff ff       	call   8006a7 <getuint>
  800a23:	83 c4 10             	add    $0x10,%esp
  800a26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a33:	e9 98 00 00 00       	jmp    800ad0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a38:	83 ec 08             	sub    $0x8,%esp
  800a3b:	ff 75 0c             	pushl  0xc(%ebp)
  800a3e:	6a 58                	push   $0x58
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	ff d0                	call   *%eax
  800a45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a48:	83 ec 08             	sub    $0x8,%esp
  800a4b:	ff 75 0c             	pushl  0xc(%ebp)
  800a4e:	6a 58                	push   $0x58
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	ff d0                	call   *%eax
  800a55:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a58:	83 ec 08             	sub    $0x8,%esp
  800a5b:	ff 75 0c             	pushl  0xc(%ebp)
  800a5e:	6a 58                	push   $0x58
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	ff d0                	call   *%eax
  800a65:	83 c4 10             	add    $0x10,%esp
			break;
  800a68:	e9 ce 00 00 00       	jmp    800b3b <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a6d:	83 ec 08             	sub    $0x8,%esp
  800a70:	ff 75 0c             	pushl  0xc(%ebp)
  800a73:	6a 30                	push   $0x30
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	ff d0                	call   *%eax
  800a7a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a7d:	83 ec 08             	sub    $0x8,%esp
  800a80:	ff 75 0c             	pushl  0xc(%ebp)
  800a83:	6a 78                	push   $0x78
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aa8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aaf:	eb 1f                	jmp    800ad0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab7:	8d 45 14             	lea    0x14(%ebp),%eax
  800aba:	50                   	push   %eax
  800abb:	e8 e7 fb ff ff       	call   8006a7 <getuint>
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ac9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ad0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ad4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ad7:	83 ec 04             	sub    $0x4,%esp
  800ada:	52                   	push   %edx
  800adb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ade:	50                   	push   %eax
  800adf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 00 fb ff ff       	call   8005f0 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
			break;
  800af3:	eb 46                	jmp    800b3b <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	53                   	push   %ebx
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	ff d0                	call   *%eax
  800b01:	83 c4 10             	add    $0x10,%esp
			break;
  800b04:	eb 35                	jmp    800b3b <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b06:	c6 05 c0 f0 80 00 00 	movb   $0x0,0x80f0c0
			break;
  800b0d:	eb 2c                	jmp    800b3b <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b0f:	c6 05 c0 f0 80 00 01 	movb   $0x1,0x80f0c0
			break;
  800b16:	eb 23                	jmp    800b3b <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	6a 25                	push   $0x25
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	ff d0                	call   *%eax
  800b25:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b28:	ff 4d 10             	decl   0x10(%ebp)
  800b2b:	eb 03                	jmp    800b30 <vprintfmt+0x3c3>
  800b2d:	ff 4d 10             	decl   0x10(%ebp)
  800b30:	8b 45 10             	mov    0x10(%ebp),%eax
  800b33:	48                   	dec    %eax
  800b34:	8a 00                	mov    (%eax),%al
  800b36:	3c 25                	cmp    $0x25,%al
  800b38:	75 f3                	jne    800b2d <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b3a:	90                   	nop
		}
	}
  800b3b:	e9 35 fc ff ff       	jmp    800775 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b40:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b44:	5b                   	pop    %ebx
  800b45:	5e                   	pop    %esi
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b4e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b51:	83 c0 04             	add    $0x4,%eax
  800b54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b57:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b5d:	50                   	push   %eax
  800b5e:	ff 75 0c             	pushl  0xc(%ebp)
  800b61:	ff 75 08             	pushl  0x8(%ebp)
  800b64:	e8 04 fc ff ff       	call   80076d <vprintfmt>
  800b69:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b6c:	90                   	nop
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    

00800b6f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8b 40 08             	mov    0x8(%eax),%eax
  800b78:	8d 50 01             	lea    0x1(%eax),%edx
  800b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8b 10                	mov    (%eax),%edx
  800b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b89:	8b 40 04             	mov    0x4(%eax),%eax
  800b8c:	39 c2                	cmp    %eax,%edx
  800b8e:	73 12                	jae    800ba2 <sprintputch+0x33>
		*b->buf++ = ch;
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8b 00                	mov    (%eax),%eax
  800b95:	8d 48 01             	lea    0x1(%eax),%ecx
  800b98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9b:	89 0a                	mov    %ecx,(%edx)
  800b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba0:	88 10                	mov    %dl,(%eax)
}
  800ba2:	90                   	nop
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bab:	8b 45 08             	mov    0x8(%ebp),%eax
  800bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	01 d0                	add    %edx,%eax
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bc6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bca:	74 06                	je     800bd2 <vsnprintf+0x2d>
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	7f 07                	jg     800bd9 <vsnprintf+0x34>
		return -E_INVAL;
  800bd2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd7:	eb 20                	jmp    800bf9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd9:	ff 75 14             	pushl  0x14(%ebp)
  800bdc:	ff 75 10             	pushl  0x10(%ebp)
  800bdf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800be2:	50                   	push   %eax
  800be3:	68 6f 0b 80 00       	push   $0x800b6f
  800be8:	e8 80 fb ff ff       	call   80076d <vprintfmt>
  800bed:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c01:	8d 45 10             	lea    0x10(%ebp),%eax
  800c04:	83 c0 04             	add    $0x4,%eax
  800c07:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c10:	50                   	push   %eax
  800c11:	ff 75 0c             	pushl  0xc(%ebp)
  800c14:	ff 75 08             	pushl  0x8(%ebp)
  800c17:	e8 89 ff ff ff       	call   800ba5 <vsnprintf>
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 06                	jmp    800c3c <strlen+0x15>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	84 c0                	test   %al,%al
  800c43:	75 f1                	jne    800c36 <strlen+0xf>
		n++;
	return n;
  800c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c48:	c9                   	leave  
  800c49:	c3                   	ret    

00800c4a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c4a:	55                   	push   %ebp
  800c4b:	89 e5                	mov    %esp,%ebp
  800c4d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c50:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c57:	eb 09                	jmp    800c62 <strnlen+0x18>
		n++;
  800c59:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c5c:	ff 45 08             	incl   0x8(%ebp)
  800c5f:	ff 4d 0c             	decl   0xc(%ebp)
  800c62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c66:	74 09                	je     800c71 <strnlen+0x27>
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	75 e8                	jne    800c59 <strnlen+0xf>
		n++;
	return n;
  800c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c82:	90                   	nop
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8d 50 01             	lea    0x1(%eax),%edx
  800c89:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c92:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c95:	8a 12                	mov    (%edx),%dl
  800c97:	88 10                	mov    %dl,(%eax)
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	84 c0                	test   %al,%al
  800c9d:	75 e4                	jne    800c83 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cb0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb7:	eb 1f                	jmp    800cd8 <strncpy+0x34>
		*dst++ = *src;
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8d 50 01             	lea    0x1(%eax),%edx
  800cbf:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc5:	8a 12                	mov    (%edx),%dl
  800cc7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	74 03                	je     800cd5 <strncpy+0x31>
			src++;
  800cd2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
  800cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cde:	72 d9                	jb     800cb9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ce0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf5:	74 30                	je     800d27 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cf7:	eb 16                	jmp    800d0f <strlcpy+0x2a>
			*dst++ = *src++;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8d 50 01             	lea    0x1(%eax),%edx
  800cff:	89 55 08             	mov    %edx,0x8(%ebp)
  800d02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d08:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0b:	8a 12                	mov    (%edx),%dl
  800d0d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d16:	74 09                	je     800d21 <strlcpy+0x3c>
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	84 c0                	test   %al,%al
  800d1f:	75 d8                	jne    800cf9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d27:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d2d:	29 c2                	sub    %eax,%edx
  800d2f:	89 d0                	mov    %edx,%eax
}
  800d31:	c9                   	leave  
  800d32:	c3                   	ret    

00800d33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d36:	eb 06                	jmp    800d3e <strcmp+0xb>
		p++, q++;
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	84 c0                	test   %al,%al
  800d45:	74 0e                	je     800d55 <strcmp+0x22>
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 10                	mov    (%eax),%dl
  800d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4f:	8a 00                	mov    (%eax),%al
  800d51:	38 c2                	cmp    %al,%dl
  800d53:	74 e3                	je     800d38 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 d0             	movzbl %al,%edx
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	8a 00                	mov    (%eax),%al
  800d62:	0f b6 c0             	movzbl %al,%eax
  800d65:	29 c2                	sub    %eax,%edx
  800d67:	89 d0                	mov    %edx,%eax
}
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d6e:	eb 09                	jmp    800d79 <strncmp+0xe>
		n--, p++, q++;
  800d70:	ff 4d 10             	decl   0x10(%ebp)
  800d73:	ff 45 08             	incl   0x8(%ebp)
  800d76:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7d:	74 17                	je     800d96 <strncmp+0x2b>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	84 c0                	test   %al,%al
  800d86:	74 0e                	je     800d96 <strncmp+0x2b>
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 10                	mov    (%eax),%dl
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8a 00                	mov    (%eax),%al
  800d92:	38 c2                	cmp    %al,%dl
  800d94:	74 da                	je     800d70 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9a:	75 07                	jne    800da3 <strncmp+0x38>
		return 0;
  800d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  800da1:	eb 14                	jmp    800db7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 d0             	movzbl %al,%edx
  800dab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dae:	8a 00                	mov    (%eax),%al
  800db0:	0f b6 c0             	movzbl %al,%eax
  800db3:	29 c2                	sub    %eax,%edx
  800db5:	89 d0                	mov    %edx,%eax
}
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 04             	sub    $0x4,%esp
  800dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc5:	eb 12                	jmp    800dd9 <strchr+0x20>
		if (*s == c)
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcf:	75 05                	jne    800dd6 <strchr+0x1d>
			return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	eb 11                	jmp    800de7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dd6:	ff 45 08             	incl   0x8(%ebp)
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	84 c0                	test   %al,%al
  800de0:	75 e5                	jne    800dc7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800de2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 04             	sub    $0x4,%esp
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800df5:	eb 0d                	jmp    800e04 <strfind+0x1b>
		if (*s == c)
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	8a 00                	mov    (%eax),%al
  800dfc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dff:	74 0e                	je     800e0f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e01:	ff 45 08             	incl   0x8(%ebp)
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8a 00                	mov    (%eax),%al
  800e09:	84 c0                	test   %al,%al
  800e0b:	75 ea                	jne    800df7 <strfind+0xe>
  800e0d:	eb 01                	jmp    800e10 <strfind+0x27>
		if (*s == c)
			break;
  800e0f:	90                   	nop
	return (char *) s;
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e13:	c9                   	leave  
  800e14:	c3                   	ret    

00800e15 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e27:	eb 0e                	jmp    800e37 <memset+0x22>
		*p++ = c;
  800e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e2c:	8d 50 01             	lea    0x1(%eax),%edx
  800e2f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e37:	ff 4d f8             	decl   -0x8(%ebp)
  800e3a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e3e:	79 e9                	jns    800e29 <memset+0x14>
		*p++ = c;

	return v;
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e57:	eb 16                	jmp    800e6f <memcpy+0x2a>
		*d++ = *s++;
  800e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5c:	8d 50 01             	lea    0x1(%eax),%edx
  800e5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e62:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e68:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6b:	8a 12                	mov    (%edx),%dl
  800e6d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	89 55 10             	mov    %edx,0x10(%ebp)
  800e78:	85 c0                	test   %eax,%eax
  800e7a:	75 dd                	jne    800e59 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7f:	c9                   	leave  
  800e80:	c3                   	ret    

00800e81 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e81:	55                   	push   %ebp
  800e82:	89 e5                	mov    %esp,%ebp
  800e84:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e90:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e99:	73 50                	jae    800eeb <memmove+0x6a>
  800e9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	01 d0                	add    %edx,%eax
  800ea3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ea6:	76 43                	jbe    800eeb <memmove+0x6a>
		s += n;
  800ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eab:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eb4:	eb 10                	jmp    800ec6 <memmove+0x45>
			*--d = *--s;
  800eb6:	ff 4d f8             	decl   -0x8(%ebp)
  800eb9:	ff 4d fc             	decl   -0x4(%ebp)
  800ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ebf:	8a 10                	mov    (%eax),%dl
  800ec1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ecf:	85 c0                	test   %eax,%eax
  800ed1:	75 e3                	jne    800eb6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ed3:	eb 23                	jmp    800ef8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ede:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee7:	8a 12                	mov    (%edx),%dl
  800ee9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eeb:	8b 45 10             	mov    0x10(%ebp),%eax
  800eee:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	75 dd                	jne    800ed5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f0f:	eb 2a                	jmp    800f3b <memcmp+0x3e>
		if (*s1 != *s2)
  800f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f14:	8a 10                	mov    (%eax),%dl
  800f16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f19:	8a 00                	mov    (%eax),%al
  800f1b:	38 c2                	cmp    %al,%dl
  800f1d:	74 16                	je     800f35 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 d0             	movzbl %al,%edx
  800f27:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 c0             	movzbl %al,%eax
  800f2f:	29 c2                	sub    %eax,%edx
  800f31:	89 d0                	mov    %edx,%eax
  800f33:	eb 18                	jmp    800f4d <memcmp+0x50>
		s1++, s2++;
  800f35:	ff 45 fc             	incl   -0x4(%ebp)
  800f38:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f41:	89 55 10             	mov    %edx,0x10(%ebp)
  800f44:	85 c0                	test   %eax,%eax
  800f46:	75 c9                	jne    800f11 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f48:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f4d:	c9                   	leave  
  800f4e:	c3                   	ret    

00800f4f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5b:	01 d0                	add    %edx,%eax
  800f5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f60:	eb 15                	jmp    800f77 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	8a 00                	mov    (%eax),%al
  800f67:	0f b6 d0             	movzbl %al,%edx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	0f b6 c0             	movzbl %al,%eax
  800f70:	39 c2                	cmp    %eax,%edx
  800f72:	74 0d                	je     800f81 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f7d:	72 e3                	jb     800f62 <memfind+0x13>
  800f7f:	eb 01                	jmp    800f82 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f81:	90                   	nop
	return (void *) s;
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    

00800f87 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f94:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f9b:	eb 03                	jmp    800fa0 <strtol+0x19>
		s++;
  800f9d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 20                	cmp    $0x20,%al
  800fa7:	74 f4                	je     800f9d <strtol+0x16>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 09                	cmp    $0x9,%al
  800fb0:	74 eb                	je     800f9d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3c 2b                	cmp    $0x2b,%al
  800fb9:	75 05                	jne    800fc0 <strtol+0x39>
		s++;
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	eb 13                	jmp    800fd3 <strtol+0x4c>
	else if (*s == '-')
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 2d                	cmp    $0x2d,%al
  800fc7:	75 0a                	jne    800fd3 <strtol+0x4c>
		s++, neg = 1;
  800fc9:	ff 45 08             	incl   0x8(%ebp)
  800fcc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd7:	74 06                	je     800fdf <strtol+0x58>
  800fd9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fdd:	75 20                	jne    800fff <strtol+0x78>
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	3c 30                	cmp    $0x30,%al
  800fe6:	75 17                	jne    800fff <strtol+0x78>
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	40                   	inc    %eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 78                	cmp    $0x78,%al
  800ff0:	75 0d                	jne    800fff <strtol+0x78>
		s += 2, base = 16;
  800ff2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ff6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ffd:	eb 28                	jmp    801027 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801003:	75 15                	jne    80101a <strtol+0x93>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 30                	cmp    $0x30,%al
  80100c:	75 0c                	jne    80101a <strtol+0x93>
		s++, base = 8;
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801018:	eb 0d                	jmp    801027 <strtol+0xa0>
	else if (base == 0)
  80101a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101e:	75 07                	jne    801027 <strtol+0xa0>
		base = 10;
  801020:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	3c 2f                	cmp    $0x2f,%al
  80102e:	7e 19                	jle    801049 <strtol+0xc2>
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 39                	cmp    $0x39,%al
  801037:	7f 10                	jg     801049 <strtol+0xc2>
			dig = *s - '0';
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	0f be c0             	movsbl %al,%eax
  801041:	83 e8 30             	sub    $0x30,%eax
  801044:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801047:	eb 42                	jmp    80108b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 60                	cmp    $0x60,%al
  801050:	7e 19                	jle    80106b <strtol+0xe4>
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	8a 00                	mov    (%eax),%al
  801057:	3c 7a                	cmp    $0x7a,%al
  801059:	7f 10                	jg     80106b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80105b:	8b 45 08             	mov    0x8(%ebp),%eax
  80105e:	8a 00                	mov    (%eax),%al
  801060:	0f be c0             	movsbl %al,%eax
  801063:	83 e8 57             	sub    $0x57,%eax
  801066:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801069:	eb 20                	jmp    80108b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 40                	cmp    $0x40,%al
  801072:	7e 39                	jle    8010ad <strtol+0x126>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 5a                	cmp    $0x5a,%al
  80107b:	7f 30                	jg     8010ad <strtol+0x126>
			dig = *s - 'A' + 10;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 37             	sub    $0x37,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80108b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80108e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801091:	7d 19                	jge    8010ac <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801093:	ff 45 08             	incl   0x8(%ebp)
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	0f af 45 10          	imul   0x10(%ebp),%eax
  80109d:	89 c2                	mov    %eax,%edx
  80109f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010a7:	e9 7b ff ff ff       	jmp    801027 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010ac:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010b1:	74 08                	je     8010bb <strtol+0x134>
		*endptr = (char *) s;
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010bf:	74 07                	je     8010c8 <strtol+0x141>
  8010c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c4:	f7 d8                	neg    %eax
  8010c6:	eb 03                	jmp    8010cb <strtol+0x144>
  8010c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010cb:	c9                   	leave  
  8010cc:	c3                   	ret    

008010cd <ltostr>:

void
ltostr(long value, char *str)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010e5:	79 13                	jns    8010fa <ltostr+0x2d>
	{
		neg = 1;
  8010e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010f4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801102:	99                   	cltd   
  801103:	f7 f9                	idiv   %ecx
  801105:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801108:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110b:	8d 50 01             	lea    0x1(%eax),%edx
  80110e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801111:	89 c2                	mov    %eax,%edx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 d0                	add    %edx,%eax
  801118:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80111b:	83 c2 30             	add    $0x30,%edx
  80111e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801120:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801123:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801128:	f7 e9                	imul   %ecx
  80112a:	c1 fa 02             	sar    $0x2,%edx
  80112d:	89 c8                	mov    %ecx,%eax
  80112f:	c1 f8 1f             	sar    $0x1f,%eax
  801132:	29 c2                	sub    %eax,%edx
  801134:	89 d0                	mov    %edx,%eax
  801136:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801139:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80113d:	75 bb                	jne    8010fa <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801146:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801149:	48                   	dec    %eax
  80114a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801151:	74 3d                	je     801190 <ltostr+0xc3>
		start = 1 ;
  801153:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80115a:	eb 34                	jmp    801190 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80115c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 d0                	add    %edx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	01 c2                	add    %eax,%edx
  801171:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	01 c8                	add    %ecx,%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8a 45 eb             	mov    -0x15(%ebp),%al
  801188:	88 02                	mov    %al,(%edx)
		start++ ;
  80118a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801193:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801196:	7c c4                	jl     80115c <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801198:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a3:	90                   	nop
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ac:	ff 75 08             	pushl  0x8(%ebp)
  8011af:	e8 73 fa ff ff       	call   800c27 <strlen>
  8011b4:	83 c4 04             	add    $0x4,%esp
  8011b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011ba:	ff 75 0c             	pushl  0xc(%ebp)
  8011bd:	e8 65 fa ff ff       	call   800c27 <strlen>
  8011c2:	83 c4 04             	add    $0x4,%esp
  8011c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d6:	eb 17                	jmp    8011ef <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011db:	8b 45 10             	mov    0x10(%ebp),%eax
  8011de:	01 c2                	add    %eax,%edx
  8011e0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	01 c8                	add    %ecx,%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011ec:	ff 45 fc             	incl   -0x4(%ebp)
  8011ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f5:	7c e1                	jl     8011d8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801205:	eb 1f                	jmp    801226 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	89 c2                	mov    %eax,%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 c2                	add    %eax,%edx
  801217:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80121a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121d:	01 c8                	add    %ecx,%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801223:	ff 45 f8             	incl   -0x8(%ebp)
  801226:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801229:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122c:	7c d9                	jl     801207 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	01 d0                	add    %edx,%eax
  801236:	c6 00 00             	movb   $0x0,(%eax)
}
  801239:	90                   	nop
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123f:	8b 45 14             	mov    0x14(%ebp),%eax
  801242:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	8b 00                	mov    (%eax),%eax
  80124d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	01 d0                	add    %edx,%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125f:	eb 0c                	jmp    80126d <strsplit+0x31>
			*string++ = 0;
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8d 50 01             	lea    0x1(%eax),%edx
  801267:	89 55 08             	mov    %edx,0x8(%ebp)
  80126a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	84 c0                	test   %al,%al
  801274:	74 18                	je     80128e <strsplit+0x52>
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	0f be c0             	movsbl %al,%eax
  80127e:	50                   	push   %eax
  80127f:	ff 75 0c             	pushl  0xc(%ebp)
  801282:	e8 32 fb ff ff       	call   800db9 <strchr>
  801287:	83 c4 08             	add    $0x8,%esp
  80128a:	85 c0                	test   %eax,%eax
  80128c:	75 d3                	jne    801261 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
  801291:	8a 00                	mov    (%eax),%al
  801293:	84 c0                	test   %al,%al
  801295:	74 5a                	je     8012f1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	83 f8 0f             	cmp    $0xf,%eax
  80129f:	75 07                	jne    8012a8 <strsplit+0x6c>
		{
			return 0;
  8012a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a6:	eb 66                	jmp    80130e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8012b0:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b3:	89 0a                	mov    %ecx,(%edx)
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 c2                	add    %eax,%edx
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c6:	eb 03                	jmp    8012cb <strsplit+0x8f>
			string++;
  8012c8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 8b                	je     80125f <strsplit+0x23>
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8a 00                	mov    (%eax),%al
  8012d9:	0f be c0             	movsbl %al,%eax
  8012dc:	50                   	push   %eax
  8012dd:	ff 75 0c             	pushl  0xc(%ebp)
  8012e0:	e8 d4 fa ff ff       	call   800db9 <strchr>
  8012e5:	83 c4 08             	add    $0x8,%esp
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	74 dc                	je     8012c8 <strsplit+0x8c>
			string++;
	}
  8012ec:	e9 6e ff ff ff       	jmp    80125f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f5:	8b 00                	mov    (%eax),%eax
  8012f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801301:	01 d0                	add    %edx,%eax
  801303:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801309:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130e:	c9                   	leave  
  80130f:	c3                   	ret    

00801310 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801316:	83 ec 04             	sub    $0x4,%esp
  801319:	68 48 23 80 00       	push   $0x802348
  80131e:	68 3f 01 00 00       	push   $0x13f
  801323:	68 6a 23 80 00       	push   $0x80236a
  801328:	e8 a9 ef ff ff       	call   8002d6 <_panic>

0080132d <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	57                   	push   %edi
  801331:	56                   	push   %esi
  801332:	53                   	push   %ebx
  801333:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80133f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801342:	8b 7d 18             	mov    0x18(%ebp),%edi
  801345:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801348:	cd 30                	int    $0x30
  80134a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801350:	83 c4 10             	add    $0x10,%esp
  801353:	5b                   	pop    %ebx
  801354:	5e                   	pop    %esi
  801355:	5f                   	pop    %edi
  801356:	5d                   	pop    %ebp
  801357:	c3                   	ret    

00801358 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 04             	sub    $0x4,%esp
  80135e:	8b 45 10             	mov    0x10(%ebp),%eax
  801361:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801364:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	52                   	push   %edx
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	50                   	push   %eax
  801374:	6a 00                	push   $0x0
  801376:	e8 b2 ff ff ff       	call   80132d <syscall>
  80137b:	83 c4 18             	add    $0x18,%esp
}
  80137e:	90                   	nop
  80137f:	c9                   	leave  
  801380:	c3                   	ret    

00801381 <sys_cgetc>:

int sys_cgetc(void) {
  801381:	55                   	push   %ebp
  801382:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	6a 00                	push   $0x0
  80138e:	6a 02                	push   $0x2
  801390:	e8 98 ff ff ff       	call   80132d <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
}
  801398:	c9                   	leave  
  801399:	c3                   	ret    

0080139a <sys_lock_cons>:

void sys_lock_cons(void) {
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 00                	push   $0x0
  8013a3:	6a 00                	push   $0x0
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 03                	push   $0x3
  8013a9:	e8 7f ff ff ff       	call   80132d <syscall>
  8013ae:	83 c4 18             	add    $0x18,%esp
}
  8013b1:	90                   	nop
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 04                	push   $0x4
  8013c3:	e8 65 ff ff ff       	call   80132d <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
}
  8013cb:	90                   	nop
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 00                	push   $0x0
  8013dd:	52                   	push   %edx
  8013de:	50                   	push   %eax
  8013df:	6a 08                	push   $0x8
  8013e1:	e8 47 ff ff ff       	call   80132d <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	56                   	push   %esi
  8013ef:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8013f0:	8b 75 18             	mov    0x18(%ebp),%esi
  8013f3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8013f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8013f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ff:	56                   	push   %esi
  801400:	53                   	push   %ebx
  801401:	51                   	push   %ecx
  801402:	52                   	push   %edx
  801403:	50                   	push   %eax
  801404:	6a 09                	push   $0x9
  801406:	e8 22 ff ff ff       	call   80132d <syscall>
  80140b:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  80140e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801411:	5b                   	pop    %ebx
  801412:	5e                   	pop    %esi
  801413:	5d                   	pop    %ebp
  801414:	c3                   	ret    

00801415 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801415:	55                   	push   %ebp
  801416:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801418:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141b:	8b 45 08             	mov    0x8(%ebp),%eax
  80141e:	6a 00                	push   $0x0
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	52                   	push   %edx
  801425:	50                   	push   %eax
  801426:	6a 0a                	push   $0xa
  801428:	e8 00 ff ff ff       	call   80132d <syscall>
  80142d:	83 c4 18             	add    $0x18,%esp
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	ff 75 0c             	pushl  0xc(%ebp)
  80143e:	ff 75 08             	pushl  0x8(%ebp)
  801441:	6a 0b                	push   $0xb
  801443:	e8 e5 fe ff ff       	call   80132d <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 0c                	push   $0xc
  80145c:	e8 cc fe ff ff       	call   80132d <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 0d                	push   $0xd
  801475:	e8 b3 fe ff ff       	call   80132d <syscall>
  80147a:	83 c4 18             	add    $0x18,%esp
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 00                	push   $0x0
  80148c:	6a 0e                	push   $0xe
  80148e:	e8 9a fe ff ff       	call   80132d <syscall>
  801493:	83 c4 18             	add    $0x18,%esp
}
  801496:	c9                   	leave  
  801497:	c3                   	ret    

00801498 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801498:	55                   	push   %ebp
  801499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 0f                	push   $0xf
  8014a7:	e8 81 fe ff ff       	call   80132d <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	ff 75 08             	pushl  0x8(%ebp)
  8014bf:	6a 10                	push   $0x10
  8014c1:	e8 67 fe ff ff       	call   80132d <syscall>
  8014c6:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <sys_scarce_memory>:

void sys_scarce_memory() {
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 00                	push   $0x0
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 11                	push   $0x11
  8014da:	e8 4e fe ff ff       	call   80132d <syscall>
  8014df:	83 c4 18             	add    $0x18,%esp
}
  8014e2:	90                   	nop
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <sys_cputc>:

void sys_cputc(const char c) {
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 04             	sub    $0x4,%esp
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8014f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	50                   	push   %eax
  8014fe:	6a 01                	push   $0x1
  801500:	e8 28 fe ff ff       	call   80132d <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
}
  801508:	90                   	nop
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  80150e:	6a 00                	push   $0x0
  801510:	6a 00                	push   $0x0
  801512:	6a 00                	push   $0x0
  801514:	6a 00                	push   $0x0
  801516:	6a 00                	push   $0x0
  801518:	6a 14                	push   $0x14
  80151a:	e8 0e fe ff ff       	call   80132d <syscall>
  80151f:	83 c4 18             	add    $0x18,%esp
}
  801522:	90                   	nop
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 04             	sub    $0x4,%esp
  80152b:	8b 45 10             	mov    0x10(%ebp),%eax
  80152e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801531:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801534:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801538:	8b 45 08             	mov    0x8(%ebp),%eax
  80153b:	6a 00                	push   $0x0
  80153d:	51                   	push   %ecx
  80153e:	52                   	push   %edx
  80153f:	ff 75 0c             	pushl  0xc(%ebp)
  801542:	50                   	push   %eax
  801543:	6a 15                	push   $0x15
  801545:	e8 e3 fd ff ff       	call   80132d <syscall>
  80154a:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801552:	8b 55 0c             	mov    0xc(%ebp),%edx
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	52                   	push   %edx
  80155f:	50                   	push   %eax
  801560:	6a 16                	push   $0x16
  801562:	e8 c6 fd ff ff       	call   80132d <syscall>
  801567:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80156f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801572:	8b 55 0c             	mov    0xc(%ebp),%edx
  801575:	8b 45 08             	mov    0x8(%ebp),%eax
  801578:	6a 00                	push   $0x0
  80157a:	6a 00                	push   $0x0
  80157c:	51                   	push   %ecx
  80157d:	52                   	push   %edx
  80157e:	50                   	push   %eax
  80157f:	6a 17                	push   $0x17
  801581:	e8 a7 fd ff ff       	call   80132d <syscall>
  801586:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80158e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	52                   	push   %edx
  80159b:	50                   	push   %eax
  80159c:	6a 18                	push   $0x18
  80159e:	e8 8a fd ff ff       	call   80132d <syscall>
  8015a3:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	6a 00                	push   $0x0
  8015b0:	ff 75 14             	pushl  0x14(%ebp)
  8015b3:	ff 75 10             	pushl  0x10(%ebp)
  8015b6:	ff 75 0c             	pushl  0xc(%ebp)
  8015b9:	50                   	push   %eax
  8015ba:	6a 19                	push   $0x19
  8015bc:	e8 6c fd ff ff       	call   80132d <syscall>
  8015c1:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <sys_run_env>:

void sys_run_env(int32 envId) {
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	50                   	push   %eax
  8015d5:	6a 1a                	push   $0x1a
  8015d7:	e8 51 fd ff ff       	call   80132d <syscall>
  8015dc:	83 c4 18             	add    $0x18,%esp
}
  8015df:	90                   	nop
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8015e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	50                   	push   %eax
  8015f1:	6a 1b                	push   $0x1b
  8015f3:	e8 35 fd ff ff       	call   80132d <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_getenvid>:

int32 sys_getenvid(void) {
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	6a 00                	push   $0x0
  80160a:	6a 05                	push   $0x5
  80160c:	e8 1c fd ff ff       	call   80132d <syscall>
  801611:	83 c4 18             	add    $0x18,%esp
}
  801614:	c9                   	leave  
  801615:	c3                   	ret    

00801616 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801616:	55                   	push   %ebp
  801617:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 06                	push   $0x6
  801625:	e8 03 fd ff ff       	call   80132d <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 07                	push   $0x7
  80163e:	e8 ea fc ff ff       	call   80132d <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_exit_env>:

void sys_exit_env(void) {
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 1c                	push   $0x1c
  801657:	e8 d1 fc ff ff       	call   80132d <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	90                   	nop
  801660:	c9                   	leave  
  801661:	c3                   	ret    

00801662 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801668:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80166b:	8d 50 04             	lea    0x4(%eax),%edx
  80166e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	6a 00                	push   $0x0
  801677:	52                   	push   %edx
  801678:	50                   	push   %eax
  801679:	6a 1d                	push   $0x1d
  80167b:	e8 ad fc ff ff       	call   80132d <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801683:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801686:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801689:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168c:	89 01                	mov    %eax,(%ecx)
  80168e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	c9                   	leave  
  801695:	c2 04 00             	ret    $0x4

00801698 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	ff 75 10             	pushl  0x10(%ebp)
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	ff 75 08             	pushl  0x8(%ebp)
  8016a8:	6a 13                	push   $0x13
  8016aa:	e8 7e fc ff ff       	call   80132d <syscall>
  8016af:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8016b2:	90                   	nop
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <sys_rcr2>:
uint32 sys_rcr2() {
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	6a 00                	push   $0x0
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 1e                	push   $0x1e
  8016c4:	e8 64 fc ff ff       	call   80132d <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8016da:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	50                   	push   %eax
  8016e7:	6a 1f                	push   $0x1f
  8016e9:	e8 3f fc ff ff       	call   80132d <syscall>
  8016ee:	83 c4 18             	add    $0x18,%esp
	return;
  8016f1:	90                   	nop
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <rsttst>:
void rsttst() {
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 21                	push   $0x21
  801703:	e8 25 fc ff ff       	call   80132d <syscall>
  801708:	83 c4 18             	add    $0x18,%esp
	return;
  80170b:	90                   	nop
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	8b 45 14             	mov    0x14(%ebp),%eax
  801717:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80171a:	8b 55 18             	mov    0x18(%ebp),%edx
  80171d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801721:	52                   	push   %edx
  801722:	50                   	push   %eax
  801723:	ff 75 10             	pushl  0x10(%ebp)
  801726:	ff 75 0c             	pushl  0xc(%ebp)
  801729:	ff 75 08             	pushl  0x8(%ebp)
  80172c:	6a 20                	push   $0x20
  80172e:	e8 fa fb ff ff       	call   80132d <syscall>
  801733:	83 c4 18             	add    $0x18,%esp
	return;
  801736:	90                   	nop
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <chktst>:
void chktst(uint32 n) {
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	ff 75 08             	pushl  0x8(%ebp)
  801747:	6a 22                	push   $0x22
  801749:	e8 df fb ff ff       	call   80132d <syscall>
  80174e:	83 c4 18             	add    $0x18,%esp
	return;
  801751:	90                   	nop
}
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <inctst>:

void inctst() {
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801757:	6a 00                	push   $0x0
  801759:	6a 00                	push   $0x0
  80175b:	6a 00                	push   $0x0
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 23                	push   $0x23
  801763:	e8 c5 fb ff ff       	call   80132d <syscall>
  801768:	83 c4 18             	add    $0x18,%esp
	return;
  80176b:	90                   	nop
}
  80176c:	c9                   	leave  
  80176d:	c3                   	ret    

0080176e <gettst>:
uint32 gettst() {
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 24                	push   $0x24
  80177d:	e8 ab fb ff ff       	call   80132d <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 00                	push   $0x0
  801795:	6a 00                	push   $0x0
  801797:	6a 25                	push   $0x25
  801799:	e8 8f fb ff ff       	call   80132d <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017a4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017a8:	75 07                	jne    8017b1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8017af:	eb 05                	jmp    8017b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 25                	push   $0x25
  8017ca:	e8 5e fb ff ff       	call   80132d <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
  8017d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8017d5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8017d9:	75 07                	jne    8017e2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8017db:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e0:	eb 05                	jmp    8017e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 25                	push   $0x25
  8017fb:	e8 2d fb ff ff       	call   80132d <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
  801803:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801806:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80180a:	75 07                	jne    801813 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80180c:	b8 01 00 00 00       	mov    $0x1,%eax
  801811:	eb 05                	jmp    801818 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801818:	c9                   	leave  
  801819:	c3                   	ret    

0080181a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801820:	6a 00                	push   $0x0
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 25                	push   $0x25
  80182c:	e8 fc fa ff ff       	call   80132d <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
  801834:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801837:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80183b:	75 07                	jne    801844 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80183d:	b8 01 00 00 00       	mov    $0x1,%eax
  801842:	eb 05                	jmp    801849 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	ff 75 08             	pushl  0x8(%ebp)
  801859:	6a 26                	push   $0x26
  80185b:	e8 cd fa ff ff       	call   80132d <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
	return;
  801863:	90                   	nop
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80186a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801870:	8b 55 0c             	mov    0xc(%ebp),%edx
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	6a 00                	push   $0x0
  801878:	53                   	push   %ebx
  801879:	51                   	push   %ecx
  80187a:	52                   	push   %edx
  80187b:	50                   	push   %eax
  80187c:	6a 27                	push   $0x27
  80187e:	e8 aa fa ff ff       	call   80132d <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80188e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801891:	8b 45 08             	mov    0x8(%ebp),%eax
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	52                   	push   %edx
  80189b:	50                   	push   %eax
  80189c:	6a 28                	push   $0x28
  80189e:	e8 8a fa ff ff       	call   80132d <syscall>
  8018a3:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8018ab:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	51                   	push   %ecx
  8018b7:	ff 75 10             	pushl  0x10(%ebp)
  8018ba:	52                   	push   %edx
  8018bb:	50                   	push   %eax
  8018bc:	6a 29                	push   $0x29
  8018be:	e8 6a fa ff ff       	call   80132d <syscall>
  8018c3:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 10             	pushl  0x10(%ebp)
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	ff 75 08             	pushl  0x8(%ebp)
  8018d8:	6a 12                	push   $0x12
  8018da:	e8 4e fa ff ff       	call   80132d <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
	return;
  8018e2:	90                   	nop
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8018e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	52                   	push   %edx
  8018f5:	50                   	push   %eax
  8018f6:	6a 2a                	push   $0x2a
  8018f8:	e8 30 fa ff ff       	call   80132d <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
	return;
  801900:	90                   	nop
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	50                   	push   %eax
  801912:	6a 2b                	push   $0x2b
  801914:	e8 14 fa ff ff       	call   80132d <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	6a 2c                	push   $0x2c
  80192f:	e8 f9 f9 ff ff       	call   80132d <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
	return;
  801937:	90                   	nop
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	ff 75 0c             	pushl  0xc(%ebp)
  801946:	ff 75 08             	pushl  0x8(%ebp)
  801949:	6a 2d                	push   $0x2d
  80194b:	e8 dd f9 ff ff       	call   80132d <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
	return;
  801953:	90                   	nop
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	50                   	push   %eax
  801965:	6a 2f                	push   $0x2f
  801967:	e8 c1 f9 ff ff       	call   80132d <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
	return;
  80196f:	90                   	nop
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801975:	8b 55 0c             	mov    0xc(%ebp),%edx
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	52                   	push   %edx
  801982:	50                   	push   %eax
  801983:	6a 30                	push   $0x30
  801985:	e8 a3 f9 ff ff       	call   80132d <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801993:	8b 45 08             	mov    0x8(%ebp),%eax
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	50                   	push   %eax
  80199f:	6a 31                	push   $0x31
  8019a1:	e8 87 f9 ff ff       	call   80132d <syscall>
  8019a6:	83 c4 18             	add    $0x18,%esp
	return;
  8019a9:	90                   	nop
}
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	52                   	push   %edx
  8019bc:	50                   	push   %eax
  8019bd:	6a 2e                	push   $0x2e
  8019bf:	e8 69 f9 ff ff       	call   80132d <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
    return;
  8019c7:	90                   	nop
}
  8019c8:	c9                   	leave  
  8019c9:	c3                   	ret    
  8019ca:	66 90                	xchg   %ax,%ax

008019cc <__udivdi3>:
  8019cc:	55                   	push   %ebp
  8019cd:	57                   	push   %edi
  8019ce:	56                   	push   %esi
  8019cf:	53                   	push   %ebx
  8019d0:	83 ec 1c             	sub    $0x1c,%esp
  8019d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8019d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8019db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019e3:	89 ca                	mov    %ecx,%edx
  8019e5:	89 f8                	mov    %edi,%eax
  8019e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019eb:	85 f6                	test   %esi,%esi
  8019ed:	75 2d                	jne    801a1c <__udivdi3+0x50>
  8019ef:	39 cf                	cmp    %ecx,%edi
  8019f1:	77 65                	ja     801a58 <__udivdi3+0x8c>
  8019f3:	89 fd                	mov    %edi,%ebp
  8019f5:	85 ff                	test   %edi,%edi
  8019f7:	75 0b                	jne    801a04 <__udivdi3+0x38>
  8019f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019fe:	31 d2                	xor    %edx,%edx
  801a00:	f7 f7                	div    %edi
  801a02:	89 c5                	mov    %eax,%ebp
  801a04:	31 d2                	xor    %edx,%edx
  801a06:	89 c8                	mov    %ecx,%eax
  801a08:	f7 f5                	div    %ebp
  801a0a:	89 c1                	mov    %eax,%ecx
  801a0c:	89 d8                	mov    %ebx,%eax
  801a0e:	f7 f5                	div    %ebp
  801a10:	89 cf                	mov    %ecx,%edi
  801a12:	89 fa                	mov    %edi,%edx
  801a14:	83 c4 1c             	add    $0x1c,%esp
  801a17:	5b                   	pop    %ebx
  801a18:	5e                   	pop    %esi
  801a19:	5f                   	pop    %edi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
  801a1c:	39 ce                	cmp    %ecx,%esi
  801a1e:	77 28                	ja     801a48 <__udivdi3+0x7c>
  801a20:	0f bd fe             	bsr    %esi,%edi
  801a23:	83 f7 1f             	xor    $0x1f,%edi
  801a26:	75 40                	jne    801a68 <__udivdi3+0x9c>
  801a28:	39 ce                	cmp    %ecx,%esi
  801a2a:	72 0a                	jb     801a36 <__udivdi3+0x6a>
  801a2c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801a30:	0f 87 9e 00 00 00    	ja     801ad4 <__udivdi3+0x108>
  801a36:	b8 01 00 00 00       	mov    $0x1,%eax
  801a3b:	89 fa                	mov    %edi,%edx
  801a3d:	83 c4 1c             	add    $0x1c,%esp
  801a40:	5b                   	pop    %ebx
  801a41:	5e                   	pop    %esi
  801a42:	5f                   	pop    %edi
  801a43:	5d                   	pop    %ebp
  801a44:	c3                   	ret    
  801a45:	8d 76 00             	lea    0x0(%esi),%esi
  801a48:	31 ff                	xor    %edi,%edi
  801a4a:	31 c0                	xor    %eax,%eax
  801a4c:	89 fa                	mov    %edi,%edx
  801a4e:	83 c4 1c             	add    $0x1c,%esp
  801a51:	5b                   	pop    %ebx
  801a52:	5e                   	pop    %esi
  801a53:	5f                   	pop    %edi
  801a54:	5d                   	pop    %ebp
  801a55:	c3                   	ret    
  801a56:	66 90                	xchg   %ax,%ax
  801a58:	89 d8                	mov    %ebx,%eax
  801a5a:	f7 f7                	div    %edi
  801a5c:	31 ff                	xor    %edi,%edi
  801a5e:	89 fa                	mov    %edi,%edx
  801a60:	83 c4 1c             	add    $0x1c,%esp
  801a63:	5b                   	pop    %ebx
  801a64:	5e                   	pop    %esi
  801a65:	5f                   	pop    %edi
  801a66:	5d                   	pop    %ebp
  801a67:	c3                   	ret    
  801a68:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a6d:	89 eb                	mov    %ebp,%ebx
  801a6f:	29 fb                	sub    %edi,%ebx
  801a71:	89 f9                	mov    %edi,%ecx
  801a73:	d3 e6                	shl    %cl,%esi
  801a75:	89 c5                	mov    %eax,%ebp
  801a77:	88 d9                	mov    %bl,%cl
  801a79:	d3 ed                	shr    %cl,%ebp
  801a7b:	89 e9                	mov    %ebp,%ecx
  801a7d:	09 f1                	or     %esi,%ecx
  801a7f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a83:	89 f9                	mov    %edi,%ecx
  801a85:	d3 e0                	shl    %cl,%eax
  801a87:	89 c5                	mov    %eax,%ebp
  801a89:	89 d6                	mov    %edx,%esi
  801a8b:	88 d9                	mov    %bl,%cl
  801a8d:	d3 ee                	shr    %cl,%esi
  801a8f:	89 f9                	mov    %edi,%ecx
  801a91:	d3 e2                	shl    %cl,%edx
  801a93:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a97:	88 d9                	mov    %bl,%cl
  801a99:	d3 e8                	shr    %cl,%eax
  801a9b:	09 c2                	or     %eax,%edx
  801a9d:	89 d0                	mov    %edx,%eax
  801a9f:	89 f2                	mov    %esi,%edx
  801aa1:	f7 74 24 0c          	divl   0xc(%esp)
  801aa5:	89 d6                	mov    %edx,%esi
  801aa7:	89 c3                	mov    %eax,%ebx
  801aa9:	f7 e5                	mul    %ebp
  801aab:	39 d6                	cmp    %edx,%esi
  801aad:	72 19                	jb     801ac8 <__udivdi3+0xfc>
  801aaf:	74 0b                	je     801abc <__udivdi3+0xf0>
  801ab1:	89 d8                	mov    %ebx,%eax
  801ab3:	31 ff                	xor    %edi,%edi
  801ab5:	e9 58 ff ff ff       	jmp    801a12 <__udivdi3+0x46>
  801aba:	66 90                	xchg   %ax,%ax
  801abc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ac0:	89 f9                	mov    %edi,%ecx
  801ac2:	d3 e2                	shl    %cl,%edx
  801ac4:	39 c2                	cmp    %eax,%edx
  801ac6:	73 e9                	jae    801ab1 <__udivdi3+0xe5>
  801ac8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801acb:	31 ff                	xor    %edi,%edi
  801acd:	e9 40 ff ff ff       	jmp    801a12 <__udivdi3+0x46>
  801ad2:	66 90                	xchg   %ax,%ax
  801ad4:	31 c0                	xor    %eax,%eax
  801ad6:	e9 37 ff ff ff       	jmp    801a12 <__udivdi3+0x46>
  801adb:	90                   	nop

00801adc <__umoddi3>:
  801adc:	55                   	push   %ebp
  801add:	57                   	push   %edi
  801ade:	56                   	push   %esi
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 1c             	sub    $0x1c,%esp
  801ae3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ae7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801aeb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801aef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801af3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801af7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801afb:	89 f3                	mov    %esi,%ebx
  801afd:	89 fa                	mov    %edi,%edx
  801aff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b03:	89 34 24             	mov    %esi,(%esp)
  801b06:	85 c0                	test   %eax,%eax
  801b08:	75 1a                	jne    801b24 <__umoddi3+0x48>
  801b0a:	39 f7                	cmp    %esi,%edi
  801b0c:	0f 86 a2 00 00 00    	jbe    801bb4 <__umoddi3+0xd8>
  801b12:	89 c8                	mov    %ecx,%eax
  801b14:	89 f2                	mov    %esi,%edx
  801b16:	f7 f7                	div    %edi
  801b18:	89 d0                	mov    %edx,%eax
  801b1a:	31 d2                	xor    %edx,%edx
  801b1c:	83 c4 1c             	add    $0x1c,%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5f                   	pop    %edi
  801b22:	5d                   	pop    %ebp
  801b23:	c3                   	ret    
  801b24:	39 f0                	cmp    %esi,%eax
  801b26:	0f 87 ac 00 00 00    	ja     801bd8 <__umoddi3+0xfc>
  801b2c:	0f bd e8             	bsr    %eax,%ebp
  801b2f:	83 f5 1f             	xor    $0x1f,%ebp
  801b32:	0f 84 ac 00 00 00    	je     801be4 <__umoddi3+0x108>
  801b38:	bf 20 00 00 00       	mov    $0x20,%edi
  801b3d:	29 ef                	sub    %ebp,%edi
  801b3f:	89 fe                	mov    %edi,%esi
  801b41:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b45:	89 e9                	mov    %ebp,%ecx
  801b47:	d3 e0                	shl    %cl,%eax
  801b49:	89 d7                	mov    %edx,%edi
  801b4b:	89 f1                	mov    %esi,%ecx
  801b4d:	d3 ef                	shr    %cl,%edi
  801b4f:	09 c7                	or     %eax,%edi
  801b51:	89 e9                	mov    %ebp,%ecx
  801b53:	d3 e2                	shl    %cl,%edx
  801b55:	89 14 24             	mov    %edx,(%esp)
  801b58:	89 d8                	mov    %ebx,%eax
  801b5a:	d3 e0                	shl    %cl,%eax
  801b5c:	89 c2                	mov    %eax,%edx
  801b5e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b62:	d3 e0                	shl    %cl,%eax
  801b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b68:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b6c:	89 f1                	mov    %esi,%ecx
  801b6e:	d3 e8                	shr    %cl,%eax
  801b70:	09 d0                	or     %edx,%eax
  801b72:	d3 eb                	shr    %cl,%ebx
  801b74:	89 da                	mov    %ebx,%edx
  801b76:	f7 f7                	div    %edi
  801b78:	89 d3                	mov    %edx,%ebx
  801b7a:	f7 24 24             	mull   (%esp)
  801b7d:	89 c6                	mov    %eax,%esi
  801b7f:	89 d1                	mov    %edx,%ecx
  801b81:	39 d3                	cmp    %edx,%ebx
  801b83:	0f 82 87 00 00 00    	jb     801c10 <__umoddi3+0x134>
  801b89:	0f 84 91 00 00 00    	je     801c20 <__umoddi3+0x144>
  801b8f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b93:	29 f2                	sub    %esi,%edx
  801b95:	19 cb                	sbb    %ecx,%ebx
  801b97:	89 d8                	mov    %ebx,%eax
  801b99:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b9d:	d3 e0                	shl    %cl,%eax
  801b9f:	89 e9                	mov    %ebp,%ecx
  801ba1:	d3 ea                	shr    %cl,%edx
  801ba3:	09 d0                	or     %edx,%eax
  801ba5:	89 e9                	mov    %ebp,%ecx
  801ba7:	d3 eb                	shr    %cl,%ebx
  801ba9:	89 da                	mov    %ebx,%edx
  801bab:	83 c4 1c             	add    $0x1c,%esp
  801bae:	5b                   	pop    %ebx
  801baf:	5e                   	pop    %esi
  801bb0:	5f                   	pop    %edi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    
  801bb3:	90                   	nop
  801bb4:	89 fd                	mov    %edi,%ebp
  801bb6:	85 ff                	test   %edi,%edi
  801bb8:	75 0b                	jne    801bc5 <__umoddi3+0xe9>
  801bba:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbf:	31 d2                	xor    %edx,%edx
  801bc1:	f7 f7                	div    %edi
  801bc3:	89 c5                	mov    %eax,%ebp
  801bc5:	89 f0                	mov    %esi,%eax
  801bc7:	31 d2                	xor    %edx,%edx
  801bc9:	f7 f5                	div    %ebp
  801bcb:	89 c8                	mov    %ecx,%eax
  801bcd:	f7 f5                	div    %ebp
  801bcf:	89 d0                	mov    %edx,%eax
  801bd1:	e9 44 ff ff ff       	jmp    801b1a <__umoddi3+0x3e>
  801bd6:	66 90                	xchg   %ax,%ax
  801bd8:	89 c8                	mov    %ecx,%eax
  801bda:	89 f2                	mov    %esi,%edx
  801bdc:	83 c4 1c             	add    $0x1c,%esp
  801bdf:	5b                   	pop    %ebx
  801be0:	5e                   	pop    %esi
  801be1:	5f                   	pop    %edi
  801be2:	5d                   	pop    %ebp
  801be3:	c3                   	ret    
  801be4:	3b 04 24             	cmp    (%esp),%eax
  801be7:	72 06                	jb     801bef <__umoddi3+0x113>
  801be9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bed:	77 0f                	ja     801bfe <__umoddi3+0x122>
  801bef:	89 f2                	mov    %esi,%edx
  801bf1:	29 f9                	sub    %edi,%ecx
  801bf3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bf7:	89 14 24             	mov    %edx,(%esp)
  801bfa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bfe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801c02:	8b 14 24             	mov    (%esp),%edx
  801c05:	83 c4 1c             	add    $0x1c,%esp
  801c08:	5b                   	pop    %ebx
  801c09:	5e                   	pop    %esi
  801c0a:	5f                   	pop    %edi
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    
  801c0d:	8d 76 00             	lea    0x0(%esi),%esi
  801c10:	2b 04 24             	sub    (%esp),%eax
  801c13:	19 fa                	sbb    %edi,%edx
  801c15:	89 d1                	mov    %edx,%ecx
  801c17:	89 c6                	mov    %eax,%esi
  801c19:	e9 71 ff ff ff       	jmp    801b8f <__umoddi3+0xb3>
  801c1e:	66 90                	xchg   %ax,%ax
  801c20:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801c24:	72 ea                	jb     801c10 <__umoddi3+0x134>
  801c26:	89 d9                	mov    %ebx,%ecx
  801c28:	e9 62 ff ff ff       	jmp    801b8f <__umoddi3+0xb3>
