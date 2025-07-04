
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  80003e:	a1 20 40 80 00       	mov    0x804020,%eax
  800043:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800049:	a1 20 40 80 00       	mov    0x804020,%eax
  80004e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800054:	39 c2                	cmp    %eax,%edx
  800056:	72 14                	jb     80006c <_main+0x34>
			panic("Please increase the WS size");
  800058:	83 ec 04             	sub    $0x4,%esp
  80005b:	68 00 36 80 00       	push   $0x803600
  800060:	6a 0c                	push   $0xc
  800062:	68 1c 36 80 00       	push   $0x80361c
  800067:	e8 1c 02 00 00       	call   800288 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  80006c:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	z = sget(sys_getparentenvid(),"z");
  800073:	e8 34 1c 00 00       	call   801cac <sys_getparentenvid>
  800078:	83 ec 08             	sub    $0x8,%esp
  80007b:	68 39 36 80 00       	push   $0x803639
  800080:	50                   	push   %eax
  800081:	e8 c1 16 00 00       	call   801747 <sget>
  800086:	83 c4 10             	add    $0x10,%esp
  800089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  80008c:	83 ec 0c             	sub    $0xc,%esp
  80008f:	68 3c 36 80 00       	push   $0x80363c
  800094:	e8 ac 04 00 00       	call   800545 <cprintf>
  800099:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  80009c:	e8 30 1d 00 00       	call   801dd1 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	68 64 36 80 00       	push   $0x803664
  8000a9:	e8 97 04 00 00       	call   800545 <cprintf>
  8000ae:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000b1:	83 ec 0c             	sub    $0xc,%esp
  8000b4:	68 28 23 00 00       	push   $0x2328
  8000b9:	e8 18 32 00 00       	call   8032d6 <env_sleep>
  8000be:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=4) ;// panic("test failed");
  8000c1:	90                   	nop
  8000c2:	e8 24 1d 00 00       	call   801deb <gettst>
  8000c7:	83 f8 04             	cmp    $0x4,%eax
  8000ca:	75 f6                	jne    8000c2 <_main+0x8a>

	freeFrames = sys_calculate_free_frames() ;
  8000cc:	e8 f9 19 00 00       	call   801aca <sys_calculate_free_frames>
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(z);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8000da:	e8 ff 17 00 00       	call   8018de <sfree>
  8000df:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 84 36 80 00       	push   $0x803684
  8000ea:	e8 56 04 00 00       	call   800545 <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
	expected = 2+1; /*2pages+1table*/
  8000f2:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of z\nframes_storage of z: should be cleared now\n", expected);
  8000f9:	e8 cc 19 00 00       	call   801aca <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800108:	39 c2                	cmp    %eax,%edx
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	ff 75 e8             	pushl  -0x18(%ebp)
  80010f:	68 9c 36 80 00       	push   $0x80369c
  800114:	6a 28                	push   $0x28
  800116:	68 1c 36 80 00       	push   $0x80361c
  80011b:	e8 68 01 00 00       	call   800288 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	68 2c 37 80 00       	push   $0x80372c
  800128:	e8 18 04 00 00       	call   800545 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n%~Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 50 37 80 00       	push   $0x803750
  800138:	e8 08 04 00 00       	call   800545 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp

	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800149:	e8 45 1b 00 00       	call   801c93 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 02             	shl    $0x2,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	c1 e0 03             	shl    $0x3,%eax
  80015e:	01 d0                	add    %edx,%eax
  800160:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800167:	01 d0                	add    %edx,%eax
  800169:	c1 e0 02             	shl    $0x2,%eax
  80016c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800171:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	8a 40 20             	mov    0x20(%eax),%al
  80017e:	84 c0                	test   %al,%al
  800180:	74 0d                	je     80018f <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800182:	a1 20 40 80 00       	mov    0x804020,%eax
  800187:	83 c0 20             	add    $0x20,%eax
  80018a:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800193:	7e 0a                	jle    80019f <libmain+0x5c>
		binaryname = argv[0];
  800195:	8b 45 0c             	mov    0xc(%ebp),%eax
  800198:	8b 00                	mov    (%eax),%eax
  80019a:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80019f:	83 ec 08             	sub    $0x8,%esp
  8001a2:	ff 75 0c             	pushl  0xc(%ebp)
  8001a5:	ff 75 08             	pushl  0x8(%ebp)
  8001a8:	e8 8b fe ff ff       	call   800038 <_main>
  8001ad:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b5:	85 c0                	test   %eax,%eax
  8001b7:	0f 84 9f 00 00 00    	je     80025c <libmain+0x119>
	{
		sys_lock_cons();
  8001bd:	e8 55 18 00 00       	call   801a17 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001c2:	83 ec 0c             	sub    $0xc,%esp
  8001c5:	68 b8 37 80 00       	push   $0x8037b8
  8001ca:	e8 76 03 00 00       	call   800545 <cprintf>
  8001cf:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d7:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e2:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	52                   	push   %edx
  8001ec:	50                   	push   %eax
  8001ed:	68 e0 37 80 00       	push   $0x8037e0
  8001f2:	e8 4e 03 00 00       	call   800545 <cprintf>
  8001f7:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ff:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800205:	a1 20 40 80 00       	mov    0x804020,%eax
  80020a:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800210:	a1 20 40 80 00       	mov    0x804020,%eax
  800215:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80021b:	51                   	push   %ecx
  80021c:	52                   	push   %edx
  80021d:	50                   	push   %eax
  80021e:	68 08 38 80 00       	push   $0x803808
  800223:	e8 1d 03 00 00       	call   800545 <cprintf>
  800228:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	50                   	push   %eax
  80023a:	68 60 38 80 00       	push   $0x803860
  80023f:	e8 01 03 00 00       	call   800545 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 b8 37 80 00       	push   $0x8037b8
  80024f:	e8 f1 02 00 00       	call   800545 <cprintf>
  800254:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800257:	e8 d5 17 00 00       	call   801a31 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80025c:	e8 19 00 00 00       	call   80027a <exit>
}
  800261:	90                   	nop
  800262:	c9                   	leave  
  800263:	c3                   	ret    

00800264 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	6a 00                	push   $0x0
  80026f:	e8 eb 19 00 00       	call   801c5f <sys_destroy_env>
  800274:	83 c4 10             	add    $0x10,%esp
}
  800277:	90                   	nop
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <exit>:

void
exit(void)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800280:	e8 40 1a 00 00       	call   801cc5 <sys_exit_env>
}
  800285:	90                   	nop
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80028e:	8d 45 10             	lea    0x10(%ebp),%eax
  800291:	83 c0 04             	add    $0x4,%eax
  800294:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800297:	a1 60 40 98 00       	mov    0x984060,%eax
  80029c:	85 c0                	test   %eax,%eax
  80029e:	74 16                	je     8002b6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a0:	a1 60 40 98 00       	mov    0x984060,%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	50                   	push   %eax
  8002a9:	68 74 38 80 00       	push   $0x803874
  8002ae:	e8 92 02 00 00       	call   800545 <cprintf>
  8002b3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b6:	a1 04 40 80 00       	mov    0x804004,%eax
  8002bb:	ff 75 0c             	pushl  0xc(%ebp)
  8002be:	ff 75 08             	pushl  0x8(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	68 79 38 80 00       	push   $0x803879
  8002c7:	e8 79 02 00 00       	call   800545 <cprintf>
  8002cc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d8:	50                   	push   %eax
  8002d9:	e8 fc 01 00 00       	call   8004da <vcprintf>
  8002de:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e1:	83 ec 08             	sub    $0x8,%esp
  8002e4:	6a 00                	push   $0x0
  8002e6:	68 95 38 80 00       	push   $0x803895
  8002eb:	e8 ea 01 00 00       	call   8004da <vcprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002f3:	e8 82 ff ff ff       	call   80027a <exit>

	// should not return here
	while (1) ;
  8002f8:	eb fe                	jmp    8002f8 <_panic+0x70>

008002fa <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800300:	a1 20 40 80 00       	mov    0x804020,%eax
  800305:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80030b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030e:	39 c2                	cmp    %eax,%edx
  800310:	74 14                	je     800326 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	68 98 38 80 00       	push   $0x803898
  80031a:	6a 26                	push   $0x26
  80031c:	68 e4 38 80 00       	push   $0x8038e4
  800321:	e8 62 ff ff ff       	call   800288 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80032d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800334:	e9 c5 00 00 00       	jmp    8003fe <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	01 d0                	add    %edx,%eax
  800348:	8b 00                	mov    (%eax),%eax
  80034a:	85 c0                	test   %eax,%eax
  80034c:	75 08                	jne    800356 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80034e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800351:	e9 a5 00 00 00       	jmp    8003fb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800356:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800364:	eb 69                	jmp    8003cf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800366:	a1 20 40 80 00       	mov    0x804020,%eax
  80036b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800371:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800374:	89 d0                	mov    %edx,%eax
  800376:	01 c0                	add    %eax,%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	c1 e0 03             	shl    $0x3,%eax
  80037d:	01 c8                	add    %ecx,%eax
  80037f:	8a 40 04             	mov    0x4(%eax),%al
  800382:	84 c0                	test   %al,%al
  800384:	75 46                	jne    8003cc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800386:	a1 20 40 80 00       	mov    0x804020,%eax
  80038b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800391:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800394:	89 d0                	mov    %edx,%eax
  800396:	01 c0                	add    %eax,%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	c1 e0 03             	shl    $0x3,%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ac:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c8                	add    %ecx,%eax
  8003bd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003bf:	39 c2                	cmp    %eax,%edx
  8003c1:	75 09                	jne    8003cc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003c3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003ca:	eb 15                	jmp    8003e1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cc:	ff 45 e8             	incl   -0x18(%ebp)
  8003cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003dd:	39 c2                	cmp    %eax,%edx
  8003df:	77 85                	ja     800366 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e5:	75 14                	jne    8003fb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003e7:	83 ec 04             	sub    $0x4,%esp
  8003ea:	68 f0 38 80 00       	push   $0x8038f0
  8003ef:	6a 3a                	push   $0x3a
  8003f1:	68 e4 38 80 00       	push   $0x8038e4
  8003f6:	e8 8d fe ff ff       	call   800288 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fb:	ff 45 f0             	incl   -0x10(%ebp)
  8003fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	0f 8c 2f ff ff ff    	jl     800339 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800411:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800418:	eb 26                	jmp    800440 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041a:	a1 20 40 80 00       	mov    0x804020,%eax
  80041f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800425:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800428:	89 d0                	mov    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	c1 e0 03             	shl    $0x3,%eax
  800431:	01 c8                	add    %ecx,%eax
  800433:	8a 40 04             	mov    0x4(%eax),%al
  800436:	3c 01                	cmp    $0x1,%al
  800438:	75 03                	jne    80043d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  80043a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043d:	ff 45 e0             	incl   -0x20(%ebp)
  800440:	a1 20 40 80 00       	mov    0x804020,%eax
  800445:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80044b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044e:	39 c2                	cmp    %eax,%edx
  800450:	77 c8                	ja     80041a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800455:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800458:	74 14                	je     80046e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  80045a:	83 ec 04             	sub    $0x4,%esp
  80045d:	68 44 39 80 00       	push   $0x803944
  800462:	6a 44                	push   $0x44
  800464:	68 e4 38 80 00       	push   $0x8038e4
  800469:	e8 1a fe ff ff       	call   800288 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046e:	90                   	nop
  80046f:	c9                   	leave  
  800470:	c3                   	ret    

00800471 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800471:	55                   	push   %ebp
  800472:	89 e5                	mov    %esp,%ebp
  800474:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	8d 48 01             	lea    0x1(%eax),%ecx
  80047f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800482:	89 0a                	mov    %ecx,(%edx)
  800484:	8b 55 08             	mov    0x8(%ebp),%edx
  800487:	88 d1                	mov    %dl,%cl
  800489:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800490:	8b 45 0c             	mov    0xc(%ebp),%eax
  800493:	8b 00                	mov    (%eax),%eax
  800495:	3d ff 00 00 00       	cmp    $0xff,%eax
  80049a:	75 2c                	jne    8004c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049c:	a0 44 40 98 00       	mov    0x984044,%al
  8004a1:	0f b6 c0             	movzbl %al,%eax
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	8b 12                	mov    (%edx),%edx
  8004a9:	89 d1                	mov    %edx,%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	83 c2 08             	add    $0x8,%edx
  8004b1:	83 ec 04             	sub    $0x4,%esp
  8004b4:	50                   	push   %eax
  8004b5:	51                   	push   %ecx
  8004b6:	52                   	push   %edx
  8004b7:	e8 19 15 00 00       	call   8019d5 <sys_cputs>
  8004bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cb:	8b 40 04             	mov    0x4(%eax),%eax
  8004ce:	8d 50 01             	lea    0x1(%eax),%edx
  8004d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d7:	90                   	nop
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ea:	00 00 00 
	b.cnt = 0;
  8004ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f7:	ff 75 0c             	pushl  0xc(%ebp)
  8004fa:	ff 75 08             	pushl  0x8(%ebp)
  8004fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800503:	50                   	push   %eax
  800504:	68 71 04 80 00       	push   $0x800471
  800509:	e8 11 02 00 00       	call   80071f <vprintfmt>
  80050e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800511:	a0 44 40 98 00       	mov    0x984044,%al
  800516:	0f b6 c0             	movzbl %al,%eax
  800519:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051f:	83 ec 04             	sub    $0x4,%esp
  800522:	50                   	push   %eax
  800523:	52                   	push   %edx
  800524:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052a:	83 c0 08             	add    $0x8,%eax
  80052d:	50                   	push   %eax
  80052e:	e8 a2 14 00 00       	call   8019d5 <sys_cputs>
  800533:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800536:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
	return b.cnt;
  80053d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800543:	c9                   	leave  
  800544:	c3                   	ret    

00800545 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800545:	55                   	push   %ebp
  800546:	89 e5                	mov    %esp,%ebp
  800548:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054b:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
	va_start(ap, fmt);
  800552:	8d 45 0c             	lea    0xc(%ebp),%eax
  800555:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800558:	8b 45 08             	mov    0x8(%ebp),%eax
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	ff 75 f4             	pushl  -0xc(%ebp)
  800561:	50                   	push   %eax
  800562:	e8 73 ff ff ff       	call   8004da <vcprintf>
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800570:	c9                   	leave  
  800571:	c3                   	ret    

00800572 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800578:	e8 9a 14 00 00       	call   801a17 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80057d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800580:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	83 ec 08             	sub    $0x8,%esp
  800589:	ff 75 f4             	pushl  -0xc(%ebp)
  80058c:	50                   	push   %eax
  80058d:	e8 48 ff ff ff       	call   8004da <vcprintf>
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800598:	e8 94 14 00 00       	call   801a31 <sys_unlock_cons>
	return cnt;
  80059d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005a0:	c9                   	leave  
  8005a1:	c3                   	ret    

008005a2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	53                   	push   %ebx
  8005a6:	83 ec 14             	sub    $0x14,%esp
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005af:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c0:	77 55                	ja     800617 <printnum+0x75>
  8005c2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c5:	72 05                	jb     8005cc <printnum+0x2a>
  8005c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ca:	77 4b                	ja     800617 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005cf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005df:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e2:	e8 a5 2d 00 00       	call   80338c <__udivdi3>
  8005e7:	83 c4 10             	add    $0x10,%esp
  8005ea:	83 ec 04             	sub    $0x4,%esp
  8005ed:	ff 75 20             	pushl  0x20(%ebp)
  8005f0:	53                   	push   %ebx
  8005f1:	ff 75 18             	pushl  0x18(%ebp)
  8005f4:	52                   	push   %edx
  8005f5:	50                   	push   %eax
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 a1 ff ff ff       	call   8005a2 <printnum>
  800601:	83 c4 20             	add    $0x20,%esp
  800604:	eb 1a                	jmp    800620 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	ff 75 0c             	pushl  0xc(%ebp)
  80060c:	ff 75 20             	pushl  0x20(%ebp)
  80060f:	8b 45 08             	mov    0x8(%ebp),%eax
  800612:	ff d0                	call   *%eax
  800614:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800617:	ff 4d 1c             	decl   0x1c(%ebp)
  80061a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061e:	7f e6                	jg     800606 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800620:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800623:	bb 00 00 00 00       	mov    $0x0,%ebx
  800628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	53                   	push   %ebx
  80062f:	51                   	push   %ecx
  800630:	52                   	push   %edx
  800631:	50                   	push   %eax
  800632:	e8 65 2e 00 00       	call   80349c <__umoddi3>
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	05 b4 3b 80 00       	add    $0x803bb4,%eax
  80063f:	8a 00                	mov    (%eax),%al
  800641:	0f be c0             	movsbl %al,%eax
  800644:	83 ec 08             	sub    $0x8,%esp
  800647:	ff 75 0c             	pushl  0xc(%ebp)
  80064a:	50                   	push   %eax
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	ff d0                	call   *%eax
  800650:	83 c4 10             	add    $0x10,%esp
}
  800653:	90                   	nop
  800654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800660:	7e 1c                	jle    80067e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8b 00                	mov    (%eax),%eax
  800667:	8d 50 08             	lea    0x8(%eax),%edx
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	89 10                	mov    %edx,(%eax)
  80066f:	8b 45 08             	mov    0x8(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 e8 08             	sub    $0x8,%eax
  800677:	8b 50 04             	mov    0x4(%eax),%edx
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	eb 40                	jmp    8006be <getuint+0x65>
	else if (lflag)
  80067e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800682:	74 1e                	je     8006a2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	8d 50 04             	lea    0x4(%eax),%edx
  80068c:	8b 45 08             	mov    0x8(%ebp),%eax
  80068f:	89 10                	mov    %edx,(%eax)
  800691:	8b 45 08             	mov    0x8(%ebp),%eax
  800694:	8b 00                	mov    (%eax),%eax
  800696:	83 e8 04             	sub    $0x4,%eax
  800699:	8b 00                	mov    (%eax),%eax
  80069b:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a0:	eb 1c                	jmp    8006be <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 04             	lea    0x4(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 04             	sub    $0x4,%eax
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006be:	5d                   	pop    %ebp
  8006bf:	c3                   	ret    

008006c0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c7:	7e 1c                	jle    8006e5 <getint+0x25>
		return va_arg(*ap, long long);
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	8b 00                	mov    (%eax),%eax
  8006ce:	8d 50 08             	lea    0x8(%eax),%edx
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	89 10                	mov    %edx,(%eax)
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	83 e8 08             	sub    $0x8,%eax
  8006de:	8b 50 04             	mov    0x4(%eax),%edx
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	eb 38                	jmp    80071d <getint+0x5d>
	else if (lflag)
  8006e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e9:	74 1a                	je     800705 <getint+0x45>
		return va_arg(*ap, long);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
  800703:	eb 18                	jmp    80071d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800705:	8b 45 08             	mov    0x8(%ebp),%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	8d 50 04             	lea    0x4(%eax),%edx
  80070d:	8b 45 08             	mov    0x8(%ebp),%eax
  800710:	89 10                	mov    %edx,(%eax)
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	83 e8 04             	sub    $0x4,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	99                   	cltd   
}
  80071d:	5d                   	pop    %ebp
  80071e:	c3                   	ret    

0080071f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	56                   	push   %esi
  800723:	53                   	push   %ebx
  800724:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800727:	eb 17                	jmp    800740 <vprintfmt+0x21>
			if (ch == '\0')
  800729:	85 db                	test   %ebx,%ebx
  80072b:	0f 84 c1 03 00 00    	je     800af2 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	53                   	push   %ebx
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800740:	8b 45 10             	mov    0x10(%ebp),%eax
  800743:	8d 50 01             	lea    0x1(%eax),%edx
  800746:	89 55 10             	mov    %edx,0x10(%ebp)
  800749:	8a 00                	mov    (%eax),%al
  80074b:	0f b6 d8             	movzbl %al,%ebx
  80074e:	83 fb 25             	cmp    $0x25,%ebx
  800751:	75 d6                	jne    800729 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800753:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800757:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800765:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800773:	8b 45 10             	mov    0x10(%ebp),%eax
  800776:	8d 50 01             	lea    0x1(%eax),%edx
  800779:	89 55 10             	mov    %edx,0x10(%ebp)
  80077c:	8a 00                	mov    (%eax),%al
  80077e:	0f b6 d8             	movzbl %al,%ebx
  800781:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800784:	83 f8 5b             	cmp    $0x5b,%eax
  800787:	0f 87 3d 03 00 00    	ja     800aca <vprintfmt+0x3ab>
  80078d:	8b 04 85 d8 3b 80 00 	mov    0x803bd8(,%eax,4),%eax
  800794:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800796:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80079a:	eb d7                	jmp    800773 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007a0:	eb d1                	jmp    800773 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 02             	shl    $0x2,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d8                	add    %ebx,%eax
  8007b7:	83 e8 30             	sub    $0x30,%eax
  8007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c0:	8a 00                	mov    (%eax),%al
  8007c2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c8:	7e 3e                	jle    800808 <vprintfmt+0xe9>
  8007ca:	83 fb 39             	cmp    $0x39,%ebx
  8007cd:	7f 39                	jg     800808 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007cf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d2:	eb d5                	jmp    8007a9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	83 c0 04             	add    $0x4,%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	83 e8 04             	sub    $0x4,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e8:	eb 1f                	jmp    800809 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ee:	79 83                	jns    800773 <vprintfmt+0x54>
				width = 0;
  8007f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f7:	e9 77 ff ff ff       	jmp    800773 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800803:	e9 6b ff ff ff       	jmp    800773 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800808:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800809:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080d:	0f 89 60 ff ff ff    	jns    800773 <vprintfmt+0x54>
				width = precision, precision = -1;
  800813:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800816:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800819:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800820:	e9 4e ff ff ff       	jmp    800773 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800825:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800828:	e9 46 ff ff ff       	jmp    800773 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082d:	8b 45 14             	mov    0x14(%ebp),%eax
  800830:	83 c0 04             	add    $0x4,%eax
  800833:	89 45 14             	mov    %eax,0x14(%ebp)
  800836:	8b 45 14             	mov    0x14(%ebp),%eax
  800839:	83 e8 04             	sub    $0x4,%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	50                   	push   %eax
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
			break;
  80084d:	e9 9b 02 00 00       	jmp    800aed <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800863:	85 db                	test   %ebx,%ebx
  800865:	79 02                	jns    800869 <vprintfmt+0x14a>
				err = -err;
  800867:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800869:	83 fb 64             	cmp    $0x64,%ebx
  80086c:	7f 0b                	jg     800879 <vprintfmt+0x15a>
  80086e:	8b 34 9d 20 3a 80 00 	mov    0x803a20(,%ebx,4),%esi
  800875:	85 f6                	test   %esi,%esi
  800877:	75 19                	jne    800892 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800879:	53                   	push   %ebx
  80087a:	68 c5 3b 80 00       	push   $0x803bc5
  80087f:	ff 75 0c             	pushl  0xc(%ebp)
  800882:	ff 75 08             	pushl  0x8(%ebp)
  800885:	e8 70 02 00 00       	call   800afa <printfmt>
  80088a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088d:	e9 5b 02 00 00       	jmp    800aed <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800892:	56                   	push   %esi
  800893:	68 ce 3b 80 00       	push   $0x803bce
  800898:	ff 75 0c             	pushl  0xc(%ebp)
  80089b:	ff 75 08             	pushl  0x8(%ebp)
  80089e:	e8 57 02 00 00       	call   800afa <printfmt>
  8008a3:	83 c4 10             	add    $0x10,%esp
			break;
  8008a6:	e9 42 02 00 00       	jmp    800aed <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ae:	83 c0 04             	add    $0x4,%eax
  8008b1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b7:	83 e8 04             	sub    $0x4,%eax
  8008ba:	8b 30                	mov    (%eax),%esi
  8008bc:	85 f6                	test   %esi,%esi
  8008be:	75 05                	jne    8008c5 <vprintfmt+0x1a6>
				p = "(null)";
  8008c0:	be d1 3b 80 00       	mov    $0x803bd1,%esi
			if (width > 0 && padc != '-')
  8008c5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c9:	7e 6d                	jle    800938 <vprintfmt+0x219>
  8008cb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008cf:	74 67                	je     800938 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	50                   	push   %eax
  8008d8:	56                   	push   %esi
  8008d9:	e8 1e 03 00 00       	call   800bfc <strnlen>
  8008de:	83 c4 10             	add    $0x10,%esp
  8008e1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e4:	eb 16                	jmp    8008fc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ea:	83 ec 08             	sub    $0x8,%esp
  8008ed:	ff 75 0c             	pushl  0xc(%ebp)
  8008f0:	50                   	push   %eax
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	ff d0                	call   *%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800900:	7f e4                	jg     8008e6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800902:	eb 34                	jmp    800938 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800904:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800908:	74 1c                	je     800926 <vprintfmt+0x207>
  80090a:	83 fb 1f             	cmp    $0x1f,%ebx
  80090d:	7e 05                	jle    800914 <vprintfmt+0x1f5>
  80090f:	83 fb 7e             	cmp    $0x7e,%ebx
  800912:	7e 12                	jle    800926 <vprintfmt+0x207>
					putch('?', putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	6a 3f                	push   $0x3f
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	ff d0                	call   *%eax
  800921:	83 c4 10             	add    $0x10,%esp
  800924:	eb 0f                	jmp    800935 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	53                   	push   %ebx
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800935:	ff 4d e4             	decl   -0x1c(%ebp)
  800938:	89 f0                	mov    %esi,%eax
  80093a:	8d 70 01             	lea    0x1(%eax),%esi
  80093d:	8a 00                	mov    (%eax),%al
  80093f:	0f be d8             	movsbl %al,%ebx
  800942:	85 db                	test   %ebx,%ebx
  800944:	74 24                	je     80096a <vprintfmt+0x24b>
  800946:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80094a:	78 b8                	js     800904 <vprintfmt+0x1e5>
  80094c:	ff 4d e0             	decl   -0x20(%ebp)
  80094f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800953:	79 af                	jns    800904 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	eb 13                	jmp    80096a <vprintfmt+0x24b>
				putch(' ', putdat);
  800957:	83 ec 08             	sub    $0x8,%esp
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	6a 20                	push   $0x20
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
  800964:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800967:	ff 4d e4             	decl   -0x1c(%ebp)
  80096a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096e:	7f e7                	jg     800957 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800970:	e9 78 01 00 00       	jmp    800aed <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800975:	83 ec 08             	sub    $0x8,%esp
  800978:	ff 75 e8             	pushl  -0x18(%ebp)
  80097b:	8d 45 14             	lea    0x14(%ebp),%eax
  80097e:	50                   	push   %eax
  80097f:	e8 3c fd ff ff       	call   8006c0 <getint>
  800984:	83 c4 10             	add    $0x10,%esp
  800987:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	85 d2                	test   %edx,%edx
  800995:	79 23                	jns    8009ba <vprintfmt+0x29b>
				putch('-', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 2d                	push   $0x2d
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ad:	f7 d8                	neg    %eax
  8009af:	83 d2 00             	adc    $0x0,%edx
  8009b2:	f7 da                	neg    %edx
  8009b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c1:	e9 bc 00 00 00       	jmp    800a82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c6:	83 ec 08             	sub    $0x8,%esp
  8009c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009cf:	50                   	push   %eax
  8009d0:	e8 84 fc ff ff       	call   800659 <getuint>
  8009d5:	83 c4 10             	add    $0x10,%esp
  8009d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009de:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e5:	e9 98 00 00 00       	jmp    800a82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 0c             	pushl  0xc(%ebp)
  800a00:	6a 58                	push   $0x58
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	ff d0                	call   *%eax
  800a07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 0c             	pushl  0xc(%ebp)
  800a10:	6a 58                	push   $0x58
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	ff d0                	call   *%eax
  800a17:	83 c4 10             	add    $0x10,%esp
			break;
  800a1a:	e9 ce 00 00 00       	jmp    800aed <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 30                	push   $0x30
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 78                	push   $0x78
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a42:	83 c0 04             	add    $0x4,%eax
  800a45:	89 45 14             	mov    %eax,0x14(%ebp)
  800a48:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4b:	83 e8 04             	sub    $0x4,%eax
  800a4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a61:	eb 1f                	jmp    800a82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 e8             	pushl  -0x18(%ebp)
  800a69:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6c:	50                   	push   %eax
  800a6d:	e8 e7 fb ff ff       	call   800659 <getuint>
  800a72:	83 c4 10             	add    $0x10,%esp
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a89:	83 ec 04             	sub    $0x4,%esp
  800a8c:	52                   	push   %edx
  800a8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a90:	50                   	push   %eax
  800a91:	ff 75 f4             	pushl  -0xc(%ebp)
  800a94:	ff 75 f0             	pushl  -0x10(%ebp)
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	ff 75 08             	pushl  0x8(%ebp)
  800a9d:	e8 00 fb ff ff       	call   8005a2 <printnum>
  800aa2:	83 c4 20             	add    $0x20,%esp
			break;
  800aa5:	eb 46                	jmp    800aed <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa7:	83 ec 08             	sub    $0x8,%esp
  800aaa:	ff 75 0c             	pushl  0xc(%ebp)
  800aad:	53                   	push   %ebx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			break;
  800ab6:	eb 35                	jmp    800aed <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ab8:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  800abf:	eb 2c                	jmp    800aed <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ac1:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
			break;
  800ac8:	eb 23                	jmp    800aed <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aca:	83 ec 08             	sub    $0x8,%esp
  800acd:	ff 75 0c             	pushl  0xc(%ebp)
  800ad0:	6a 25                	push   $0x25
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ada:	ff 4d 10             	decl   0x10(%ebp)
  800add:	eb 03                	jmp    800ae2 <vprintfmt+0x3c3>
  800adf:	ff 4d 10             	decl   0x10(%ebp)
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	48                   	dec    %eax
  800ae6:	8a 00                	mov    (%eax),%al
  800ae8:	3c 25                	cmp    $0x25,%al
  800aea:	75 f3                	jne    800adf <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800aec:	90                   	nop
		}
	}
  800aed:	e9 35 fc ff ff       	jmp    800727 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af2:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af6:	5b                   	pop    %ebx
  800af7:	5e                   	pop    %esi
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b00:	8d 45 10             	lea    0x10(%ebp),%eax
  800b03:	83 c0 04             	add    $0x4,%eax
  800b06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b09:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0c:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0f:	50                   	push   %eax
  800b10:	ff 75 0c             	pushl  0xc(%ebp)
  800b13:	ff 75 08             	pushl  0x8(%ebp)
  800b16:	e8 04 fc ff ff       	call   80071f <vprintfmt>
  800b1b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b1e:	90                   	nop
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	8b 40 08             	mov    0x8(%eax),%eax
  800b2a:	8d 50 01             	lea    0x1(%eax),%edx
  800b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b30:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 10                	mov    (%eax),%edx
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	39 c2                	cmp    %eax,%edx
  800b40:	73 12                	jae    800b54 <sprintputch+0x33>
		*b->buf++ = ch;
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 00                	mov    (%eax),%eax
  800b47:	8d 48 01             	lea    0x1(%eax),%ecx
  800b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4d:	89 0a                	mov    %ecx,(%edx)
  800b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b52:	88 10                	mov    %dl,(%eax)
}
  800b54:	90                   	nop
  800b55:	5d                   	pop    %ebp
  800b56:	c3                   	ret    

00800b57 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b57:	55                   	push   %ebp
  800b58:	89 e5                	mov    %esp,%ebp
  800b5a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	01 d0                	add    %edx,%eax
  800b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b7c:	74 06                	je     800b84 <vsnprintf+0x2d>
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	7f 07                	jg     800b8b <vsnprintf+0x34>
		return -E_INVAL;
  800b84:	b8 03 00 00 00       	mov    $0x3,%eax
  800b89:	eb 20                	jmp    800bab <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b8b:	ff 75 14             	pushl  0x14(%ebp)
  800b8e:	ff 75 10             	pushl  0x10(%ebp)
  800b91:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	68 21 0b 80 00       	push   $0x800b21
  800b9a:	e8 80 fb ff ff       	call   80071f <vprintfmt>
  800b9f:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb3:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb6:	83 c0 04             	add    $0x4,%eax
  800bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bbc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc2:	50                   	push   %eax
  800bc3:	ff 75 0c             	pushl  0xc(%ebp)
  800bc6:	ff 75 08             	pushl  0x8(%ebp)
  800bc9:	e8 89 ff ff ff       	call   800b57 <vsnprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
  800bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd7:	c9                   	leave  
  800bd8:	c3                   	ret    

00800bd9 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bdf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be6:	eb 06                	jmp    800bee <strlen+0x15>
		n++;
  800be8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800beb:	ff 45 08             	incl   0x8(%ebp)
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 f1                	jne    800be8 <strlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c02:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c09:	eb 09                	jmp    800c14 <strnlen+0x18>
		n++;
  800c0b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0e:	ff 45 08             	incl   0x8(%ebp)
  800c11:	ff 4d 0c             	decl   0xc(%ebp)
  800c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c18:	74 09                	je     800c23 <strnlen+0x27>
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	8a 00                	mov    (%eax),%al
  800c1f:	84 c0                	test   %al,%al
  800c21:	75 e8                	jne    800c0b <strnlen+0xf>
		n++;
	return n;
  800c23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c26:	c9                   	leave  
  800c27:	c3                   	ret    

00800c28 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c28:	55                   	push   %ebp
  800c29:	89 e5                	mov    %esp,%ebp
  800c2b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c34:	90                   	nop
  800c35:	8b 45 08             	mov    0x8(%ebp),%eax
  800c38:	8d 50 01             	lea    0x1(%eax),%edx
  800c3b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c41:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c44:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c47:	8a 12                	mov    (%edx),%dl
  800c49:	88 10                	mov    %dl,(%eax)
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e4                	jne    800c35 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 1f                	jmp    800c8a <strncpy+0x34>
		*dst++ = *src;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8d 50 01             	lea    0x1(%eax),%edx
  800c71:	89 55 08             	mov    %edx,0x8(%ebp)
  800c74:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c77:	8a 12                	mov    (%edx),%dl
  800c79:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	84 c0                	test   %al,%al
  800c82:	74 03                	je     800c87 <strncpy+0x31>
			src++;
  800c84:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c87:	ff 45 fc             	incl   -0x4(%ebp)
  800c8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c90:	72 d9                	jb     800c6b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c95:	c9                   	leave  
  800c96:	c3                   	ret    

00800c97 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c97:	55                   	push   %ebp
  800c98:	89 e5                	mov    %esp,%ebp
  800c9a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 30                	je     800cd9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca9:	eb 16                	jmp    800cc1 <strlcpy+0x2a>
			*dst++ = *src++;
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cc1:	ff 4d 10             	decl   0x10(%ebp)
  800cc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc8:	74 09                	je     800cd3 <strlcpy+0x3c>
  800cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccd:	8a 00                	mov    (%eax),%al
  800ccf:	84 c0                	test   %al,%al
  800cd1:	75 d8                	jne    800cab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cdf:	29 c2                	sub    %eax,%edx
  800ce1:	89 d0                	mov    %edx,%eax
}
  800ce3:	c9                   	leave  
  800ce4:	c3                   	ret    

00800ce5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce8:	eb 06                	jmp    800cf0 <strcmp+0xb>
		p++, q++;
  800cea:	ff 45 08             	incl   0x8(%ebp)
  800ced:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8a 00                	mov    (%eax),%al
  800cf5:	84 c0                	test   %al,%al
  800cf7:	74 0e                	je     800d07 <strcmp+0x22>
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	8a 10                	mov    (%eax),%dl
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	38 c2                	cmp    %al,%dl
  800d05:	74 e3                	je     800cea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	0f b6 d0             	movzbl %al,%edx
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	0f b6 c0             	movzbl %al,%eax
  800d17:	29 c2                	sub    %eax,%edx
  800d19:	89 d0                	mov    %edx,%eax
}
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d20:	eb 09                	jmp    800d2b <strncmp+0xe>
		n--, p++, q++;
  800d22:	ff 4d 10             	decl   0x10(%ebp)
  800d25:	ff 45 08             	incl   0x8(%ebp)
  800d28:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2f:	74 17                	je     800d48 <strncmp+0x2b>
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	84 c0                	test   %al,%al
  800d38:	74 0e                	je     800d48 <strncmp+0x2b>
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 10                	mov    (%eax),%dl
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	38 c2                	cmp    %al,%dl
  800d46:	74 da                	je     800d22 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4c:	75 07                	jne    800d55 <strncmp+0x38>
		return 0;
  800d4e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d53:	eb 14                	jmp    800d69 <strncmp+0x4c>
	else
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

00800d6b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 04             	sub    $0x4,%esp
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d77:	eb 12                	jmp    800d8b <strchr+0x20>
		if (*s == c)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d81:	75 05                	jne    800d88 <strchr+0x1d>
			return (char *) s;
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	eb 11                	jmp    800d99 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d88:	ff 45 08             	incl   0x8(%ebp)
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	84 c0                	test   %al,%al
  800d92:	75 e5                	jne    800d79 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 04             	sub    $0x4,%esp
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da7:	eb 0d                	jmp    800db6 <strfind+0x1b>
		if (*s == c)
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db1:	74 0e                	je     800dc1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 ea                	jne    800da9 <strfind+0xe>
  800dbf:	eb 01                	jmp    800dc2 <strfind+0x27>
		if (*s == c)
			break;
  800dc1:	90                   	nop
	return (char *) s;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd9:	eb 0e                	jmp    800de9 <memset+0x22>
		*p++ = c;
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	8d 50 01             	lea    0x1(%eax),%edx
  800de1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de9:	ff 4d f8             	decl   -0x8(%ebp)
  800dec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800df0:	79 e9                	jns    800ddb <memset+0x14>
		*p++ = c;

	return v;
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df5:	c9                   	leave  
  800df6:	c3                   	ret    

00800df7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df7:	55                   	push   %ebp
  800df8:	89 e5                	mov    %esp,%ebp
  800dfa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e09:	eb 16                	jmp    800e21 <memcpy+0x2a>
		*d++ = *s++;
  800e0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0e:	8d 50 01             	lea    0x1(%eax),%edx
  800e11:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e17:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e1a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1d:	8a 12                	mov    (%edx),%dl
  800e1f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e21:	8b 45 10             	mov    0x10(%ebp),%eax
  800e24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e27:	89 55 10             	mov    %edx,0x10(%ebp)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	75 dd                	jne    800e0b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e31:	c9                   	leave  
  800e32:	c3                   	ret    

00800e33 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4b:	73 50                	jae    800e9d <memmove+0x6a>
  800e4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e50:	8b 45 10             	mov    0x10(%ebp),%eax
  800e53:	01 d0                	add    %edx,%eax
  800e55:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e58:	76 43                	jbe    800e9d <memmove+0x6a>
		s += n;
  800e5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e60:	8b 45 10             	mov    0x10(%ebp),%eax
  800e63:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e66:	eb 10                	jmp    800e78 <memmove+0x45>
			*--d = *--s;
  800e68:	ff 4d f8             	decl   -0x8(%ebp)
  800e6b:	ff 4d fc             	decl   -0x4(%ebp)
  800e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e71:	8a 10                	mov    (%eax),%dl
  800e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e76:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e78:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e81:	85 c0                	test   %eax,%eax
  800e83:	75 e3                	jne    800e68 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e85:	eb 23                	jmp    800eaa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e8a:	8d 50 01             	lea    0x1(%eax),%edx
  800e8d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e90:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e96:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e99:	8a 12                	mov    (%edx),%dl
  800e9b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	75 dd                	jne    800e87 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ead:	c9                   	leave  
  800eae:	c3                   	ret    

00800eaf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebe:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ec1:	eb 2a                	jmp    800eed <memcmp+0x3e>
		if (*s1 != *s2)
  800ec3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec6:	8a 10                	mov    (%eax),%dl
  800ec8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecb:	8a 00                	mov    (%eax),%al
  800ecd:	38 c2                	cmp    %al,%dl
  800ecf:	74 16                	je     800ee7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ed1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	0f b6 d0             	movzbl %al,%edx
  800ed9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edc:	8a 00                	mov    (%eax),%al
  800ede:	0f b6 c0             	movzbl %al,%eax
  800ee1:	29 c2                	sub    %eax,%edx
  800ee3:	89 d0                	mov    %edx,%eax
  800ee5:	eb 18                	jmp    800eff <memcmp+0x50>
		s1++, s2++;
  800ee7:	ff 45 fc             	incl   -0x4(%ebp)
  800eea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef6:	85 c0                	test   %eax,%eax
  800ef8:	75 c9                	jne    800ec3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800efa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eff:	c9                   	leave  
  800f00:	c3                   	ret    

00800f01 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f01:	55                   	push   %ebp
  800f02:	89 e5                	mov    %esp,%ebp
  800f04:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f07:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	01 d0                	add    %edx,%eax
  800f0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f12:	eb 15                	jmp    800f29 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	8a 00                	mov    (%eax),%al
  800f19:	0f b6 d0             	movzbl %al,%edx
  800f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1f:	0f b6 c0             	movzbl %al,%eax
  800f22:	39 c2                	cmp    %eax,%edx
  800f24:	74 0d                	je     800f33 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f26:	ff 45 08             	incl   0x8(%ebp)
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2f:	72 e3                	jb     800f14 <memfind+0x13>
  800f31:	eb 01                	jmp    800f34 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f33:	90                   	nop
	return (void *) s;
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f46:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4d:	eb 03                	jmp    800f52 <strtol+0x19>
		s++;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	3c 20                	cmp    $0x20,%al
  800f59:	74 f4                	je     800f4f <strtol+0x16>
  800f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5e:	8a 00                	mov    (%eax),%al
  800f60:	3c 09                	cmp    $0x9,%al
  800f62:	74 eb                	je     800f4f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 2b                	cmp    $0x2b,%al
  800f6b:	75 05                	jne    800f72 <strtol+0x39>
		s++;
  800f6d:	ff 45 08             	incl   0x8(%ebp)
  800f70:	eb 13                	jmp    800f85 <strtol+0x4c>
	else if (*s == '-')
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	3c 2d                	cmp    $0x2d,%al
  800f79:	75 0a                	jne    800f85 <strtol+0x4c>
		s++, neg = 1;
  800f7b:	ff 45 08             	incl   0x8(%ebp)
  800f7e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	74 06                	je     800f91 <strtol+0x58>
  800f8b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f8f:	75 20                	jne    800fb1 <strtol+0x78>
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 30                	cmp    $0x30,%al
  800f98:	75 17                	jne    800fb1 <strtol+0x78>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	40                   	inc    %eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	3c 78                	cmp    $0x78,%al
  800fa2:	75 0d                	jne    800fb1 <strtol+0x78>
		s += 2, base = 16;
  800fa4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800faf:	eb 28                	jmp    800fd9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb5:	75 15                	jne    800fcc <strtol+0x93>
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	3c 30                	cmp    $0x30,%al
  800fbe:	75 0c                	jne    800fcc <strtol+0x93>
		s++, base = 8;
  800fc0:	ff 45 08             	incl   0x8(%ebp)
  800fc3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fca:	eb 0d                	jmp    800fd9 <strtol+0xa0>
	else if (base == 0)
  800fcc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd0:	75 07                	jne    800fd9 <strtol+0xa0>
		base = 10;
  800fd2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	8a 00                	mov    (%eax),%al
  800fde:	3c 2f                	cmp    $0x2f,%al
  800fe0:	7e 19                	jle    800ffb <strtol+0xc2>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 39                	cmp    $0x39,%al
  800fe9:	7f 10                	jg     800ffb <strtol+0xc2>
			dig = *s - '0';
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	0f be c0             	movsbl %al,%eax
  800ff3:	83 e8 30             	sub    $0x30,%eax
  800ff6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff9:	eb 42                	jmp    80103d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	3c 60                	cmp    $0x60,%al
  801002:	7e 19                	jle    80101d <strtol+0xe4>
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 7a                	cmp    $0x7a,%al
  80100b:	7f 10                	jg     80101d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	0f be c0             	movsbl %al,%eax
  801015:	83 e8 57             	sub    $0x57,%eax
  801018:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80101b:	eb 20                	jmp    80103d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 40                	cmp    $0x40,%al
  801024:	7e 39                	jle    80105f <strtol+0x126>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 5a                	cmp    $0x5a,%al
  80102d:	7f 30                	jg     80105f <strtol+0x126>
			dig = *s - 'A' + 10;
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	0f be c0             	movsbl %al,%eax
  801037:	83 e8 37             	sub    $0x37,%eax
  80103a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80103d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801040:	3b 45 10             	cmp    0x10(%ebp),%eax
  801043:	7d 19                	jge    80105e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801045:	ff 45 08             	incl   0x8(%ebp)
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104f:	89 c2                	mov    %eax,%edx
  801051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801054:	01 d0                	add    %edx,%eax
  801056:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801059:	e9 7b ff ff ff       	jmp    800fd9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80105e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80105f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801063:	74 08                	je     80106d <strtol+0x134>
		*endptr = (char *) s;
  801065:	8b 45 0c             	mov    0xc(%ebp),%eax
  801068:	8b 55 08             	mov    0x8(%ebp),%edx
  80106b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80106d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801071:	74 07                	je     80107a <strtol+0x141>
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	f7 d8                	neg    %eax
  801078:	eb 03                	jmp    80107d <strtol+0x144>
  80107a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <ltostr>:

void
ltostr(long value, char *str)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801085:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80108c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801093:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801097:	79 13                	jns    8010ac <ltostr+0x2d>
	{
		neg = 1;
  801099:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010b4:	99                   	cltd   
  8010b5:	f7 f9                	idiv   %ecx
  8010b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	89 c2                	mov    %eax,%edx
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	01 d0                	add    %edx,%eax
  8010ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010cd:	83 c2 30             	add    $0x30,%edx
  8010d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010da:	f7 e9                	imul   %ecx
  8010dc:	c1 fa 02             	sar    $0x2,%edx
  8010df:	89 c8                	mov    %ecx,%eax
  8010e1:	c1 f8 1f             	sar    $0x1f,%eax
  8010e4:	29 c2                	sub    %eax,%edx
  8010e6:	89 d0                	mov    %edx,%eax
  8010e8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ef:	75 bb                	jne    8010ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fb:	48                   	dec    %eax
  8010fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 3d                	je     801142 <ltostr+0xc3>
		start = 1 ;
  801105:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110c:	eb 34                	jmp    801142 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 d0                	add    %edx,%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80111b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	01 c2                	add    %eax,%edx
  801123:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801126:	8b 45 0c             	mov    0xc(%ebp),%eax
  801129:	01 c8                	add    %ecx,%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c2                	add    %eax,%edx
  801137:	8a 45 eb             	mov    -0x15(%ebp),%al
  80113a:	88 02                	mov    %al,(%edx)
		start++ ;
  80113c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801145:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801148:	7c c4                	jl     80110e <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80114a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	01 d0                	add    %edx,%eax
  801152:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801155:	90                   	nop
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115e:	ff 75 08             	pushl  0x8(%ebp)
  801161:	e8 73 fa ff ff       	call   800bd9 <strlen>
  801166:	83 c4 04             	add    $0x4,%esp
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116c:	ff 75 0c             	pushl  0xc(%ebp)
  80116f:	e8 65 fa ff ff       	call   800bd9 <strlen>
  801174:	83 c4 04             	add    $0x4,%esp
  801177:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80117a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801181:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801188:	eb 17                	jmp    8011a1 <strcconcat+0x49>
		final[s] = str1[s] ;
  80118a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118d:	8b 45 10             	mov    0x10(%ebp),%eax
  801190:	01 c2                	add    %eax,%edx
  801192:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	01 c8                	add    %ecx,%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119e:	ff 45 fc             	incl   -0x4(%ebp)
  8011a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a7:	7c e1                	jl     80118a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b7:	eb 1f                	jmp    8011d8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bc:	8d 50 01             	lea    0x1(%eax),%edx
  8011bf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c2:	89 c2                	mov    %eax,%edx
  8011c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c7:	01 c2                	add    %eax,%edx
  8011c9:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	01 c8                	add    %ecx,%eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
  8011d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011db:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011de:	7c d9                	jl     8011b9 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	01 d0                	add    %edx,%eax
  8011e8:	c6 00 00             	movb   $0x0,(%eax)
}
  8011eb:	90                   	nop
  8011ec:	c9                   	leave  
  8011ed:	c3                   	ret    

008011ee <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fd:	8b 00                	mov    (%eax),%eax
  8011ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	01 d0                	add    %edx,%eax
  80120b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801211:	eb 0c                	jmp    80121f <strsplit+0x31>
			*string++ = 0;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 08             	mov    %edx,0x8(%ebp)
  80121c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	84 c0                	test   %al,%al
  801226:	74 18                	je     801240 <strsplit+0x52>
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	0f be c0             	movsbl %al,%eax
  801230:	50                   	push   %eax
  801231:	ff 75 0c             	pushl  0xc(%ebp)
  801234:	e8 32 fb ff ff       	call   800d6b <strchr>
  801239:	83 c4 08             	add    $0x8,%esp
  80123c:	85 c0                	test   %eax,%eax
  80123e:	75 d3                	jne    801213 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	84 c0                	test   %al,%al
  801247:	74 5a                	je     8012a3 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801249:	8b 45 14             	mov    0x14(%ebp),%eax
  80124c:	8b 00                	mov    (%eax),%eax
  80124e:	83 f8 0f             	cmp    $0xf,%eax
  801251:	75 07                	jne    80125a <strsplit+0x6c>
		{
			return 0;
  801253:	b8 00 00 00 00       	mov    $0x0,%eax
  801258:	eb 66                	jmp    8012c0 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80125a:	8b 45 14             	mov    0x14(%ebp),%eax
  80125d:	8b 00                	mov    (%eax),%eax
  80125f:	8d 48 01             	lea    0x1(%eax),%ecx
  801262:	8b 55 14             	mov    0x14(%ebp),%edx
  801265:	89 0a                	mov    %ecx,(%edx)
  801267:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	01 c2                	add    %eax,%edx
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	eb 03                	jmp    80127d <strsplit+0x8f>
			string++;
  80127a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	84 c0                	test   %al,%al
  801284:	74 8b                	je     801211 <strsplit+0x23>
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	0f be c0             	movsbl %al,%eax
  80128e:	50                   	push   %eax
  80128f:	ff 75 0c             	pushl  0xc(%ebp)
  801292:	e8 d4 fa ff ff       	call   800d6b <strchr>
  801297:	83 c4 08             	add    $0x8,%esp
  80129a:	85 c0                	test   %eax,%eax
  80129c:	74 dc                	je     80127a <strsplit+0x8c>
			string++;
	}
  80129e:	e9 6e ff ff ff       	jmp    801211 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a3:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b3:	01 d0                	add    %edx,%eax
  8012b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012bb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012c0:	c9                   	leave  
  8012c1:	c3                   	ret    

008012c2 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012c2:	55                   	push   %ebp
  8012c3:	89 e5                	mov    %esp,%ebp
  8012c5:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012c8:	83 ec 04             	sub    $0x4,%esp
  8012cb:	68 48 3d 80 00       	push   $0x803d48
  8012d0:	68 3f 01 00 00       	push   $0x13f
  8012d5:	68 6a 3d 80 00       	push   $0x803d6a
  8012da:	e8 a9 ef ff ff       	call   800288 <_panic>

008012df <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	ff 75 08             	pushl  0x8(%ebp)
  8012eb:	e8 90 0c 00 00       	call   801f80 <sys_sbrk>
  8012f0:	83 c4 10             	add    $0x10,%esp
}
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    

008012f5 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8012fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ff:	75 0a                	jne    80130b <malloc+0x16>
		return NULL;
  801301:	b8 00 00 00 00       	mov    $0x0,%eax
  801306:	e9 9e 01 00 00       	jmp    8014a9 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80130b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801312:	77 2c                	ja     801340 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801314:	e8 eb 0a 00 00       	call   801e04 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801319:	85 c0                	test   %eax,%eax
  80131b:	74 19                	je     801336 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80131d:	83 ec 0c             	sub    $0xc,%esp
  801320:	ff 75 08             	pushl  0x8(%ebp)
  801323:	e8 85 11 00 00       	call   8024ad <alloc_block_FF>
  801328:	83 c4 10             	add    $0x10,%esp
  80132b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80132e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801331:	e9 73 01 00 00       	jmp    8014a9 <malloc+0x1b4>
		} else {
			return NULL;
  801336:	b8 00 00 00 00       	mov    $0x0,%eax
  80133b:	e9 69 01 00 00       	jmp    8014a9 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801340:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801347:	8b 55 08             	mov    0x8(%ebp),%edx
  80134a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134d:	01 d0                	add    %edx,%eax
  80134f:	48                   	dec    %eax
  801350:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801353:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801356:	ba 00 00 00 00       	mov    $0x0,%edx
  80135b:	f7 75 e0             	divl   -0x20(%ebp)
  80135e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801361:	29 d0                	sub    %edx,%eax
  801363:	c1 e8 0c             	shr    $0xc,%eax
  801366:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801370:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801377:	a1 20 40 80 00       	mov    0x804020,%eax
  80137c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80137f:	05 00 10 00 00       	add    $0x1000,%eax
  801384:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801387:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80138c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80138f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801392:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801399:	8b 55 08             	mov    0x8(%ebp),%edx
  80139c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80139f:	01 d0                	add    %edx,%eax
  8013a1:	48                   	dec    %eax
  8013a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8013a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ad:	f7 75 cc             	divl   -0x34(%ebp)
  8013b0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013b3:	29 d0                	sub    %edx,%eax
  8013b5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8013b8:	76 0a                	jbe    8013c4 <malloc+0xcf>
		return NULL;
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bf:	e9 e5 00 00 00       	jmp    8014a9 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8013c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013ca:	eb 48                	jmp    801414 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8013cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8013d2:	c1 e8 0c             	shr    $0xc,%eax
  8013d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8013d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8013db:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	75 11                	jne    8013f7 <malloc+0x102>
			freePagesCount++;
  8013e6:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8013e9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8013ed:	75 16                	jne    801405 <malloc+0x110>
				start = i;
  8013ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f5:	eb 0e                	jmp    801405 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8013f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8013fe:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801408:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80140b:	74 12                	je     80141f <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80140d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801414:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80141b:	76 af                	jbe    8013cc <malloc+0xd7>
  80141d:	eb 01                	jmp    801420 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80141f:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801420:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801424:	74 08                	je     80142e <malloc+0x139>
  801426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801429:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80142c:	74 07                	je     801435 <malloc+0x140>
		return NULL;
  80142e:	b8 00 00 00 00       	mov    $0x0,%eax
  801433:	eb 74                	jmp    8014a9 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801438:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80143b:	c1 e8 0c             	shr    $0xc,%eax
  80143e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801441:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801444:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801447:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80144e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801451:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801454:	eb 11                	jmp    801467 <malloc+0x172>
		markedPages[i] = 1;
  801456:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801459:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801460:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801464:	ff 45 e8             	incl   -0x18(%ebp)
  801467:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80146a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801472:	77 e2                	ja     801456 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801474:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80147b:	8b 55 08             	mov    0x8(%ebp),%edx
  80147e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801481:	01 d0                	add    %edx,%eax
  801483:	48                   	dec    %eax
  801484:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801487:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80148a:	ba 00 00 00 00       	mov    $0x0,%edx
  80148f:	f7 75 bc             	divl   -0x44(%ebp)
  801492:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801495:	29 d0                	sub    %edx,%eax
  801497:	83 ec 08             	sub    $0x8,%esp
  80149a:	50                   	push   %eax
  80149b:	ff 75 f0             	pushl  -0x10(%ebp)
  80149e:	e8 14 0b 00 00       	call   801fb7 <sys_allocate_user_mem>
  8014a3:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8014b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014b5:	0f 84 ee 00 00 00    	je     8015a9 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8014bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8014c0:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8014c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014c6:	77 09                	ja     8014d1 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8014c8:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8014cf:	76 14                	jbe    8014e5 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	68 78 3d 80 00       	push   $0x803d78
  8014d9:	6a 68                	push   $0x68
  8014db:	68 92 3d 80 00       	push   $0x803d92
  8014e0:	e8 a3 ed ff ff       	call   800288 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8014e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8014ea:	8b 40 74             	mov    0x74(%eax),%eax
  8014ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014f0:	77 20                	ja     801512 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8014f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8014f7:	8b 40 78             	mov    0x78(%eax),%eax
  8014fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014fd:	76 13                	jbe    801512 <free+0x67>
		free_block(virtual_address);
  8014ff:	83 ec 0c             	sub    $0xc,%esp
  801502:	ff 75 08             	pushl  0x8(%ebp)
  801505:	e8 6c 16 00 00       	call   802b76 <free_block>
  80150a:	83 c4 10             	add    $0x10,%esp
		return;
  80150d:	e9 98 00 00 00       	jmp    8015aa <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801512:	8b 55 08             	mov    0x8(%ebp),%edx
  801515:	a1 20 40 80 00       	mov    0x804020,%eax
  80151a:	8b 40 7c             	mov    0x7c(%eax),%eax
  80151d:	29 c2                	sub    %eax,%edx
  80151f:	89 d0                	mov    %edx,%eax
  801521:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801526:	c1 e8 0c             	shr    $0xc,%eax
  801529:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80152c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801533:	eb 16                	jmp    80154b <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153b:	01 d0                	add    %edx,%eax
  80153d:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801544:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801548:	ff 45 f4             	incl   -0xc(%ebp)
  80154b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154e:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801555:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801558:	7f db                	jg     801535 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80155a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155d:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801564:	c1 e0 0c             	shl    $0xc,%eax
  801567:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80156a:	8b 45 08             	mov    0x8(%ebp),%eax
  80156d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801570:	eb 1a                	jmp    80158c <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801572:	83 ec 08             	sub    $0x8,%esp
  801575:	68 00 10 00 00       	push   $0x1000
  80157a:	ff 75 f0             	pushl  -0x10(%ebp)
  80157d:	e8 19 0a 00 00       	call   801f9b <sys_free_user_mem>
  801582:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801585:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80158c:	8b 55 08             	mov    0x8(%ebp),%edx
  80158f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801592:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801594:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801597:	77 d9                	ja     801572 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801599:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159c:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  8015a3:	00 00 00 00 
  8015a7:	eb 01                	jmp    8015aa <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8015a9:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8015aa:	c9                   	leave  
  8015ab:	c3                   	ret    

008015ac <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8015ac:	55                   	push   %ebp
  8015ad:	89 e5                	mov    %esp,%ebp
  8015af:	83 ec 58             	sub    $0x58,%esp
  8015b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b5:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8015b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bc:	75 0a                	jne    8015c8 <smalloc+0x1c>
		return NULL;
  8015be:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c3:	e9 7d 01 00 00       	jmp    801745 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8015c8:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8015cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d5:	01 d0                	add    %edx,%eax
  8015d7:	48                   	dec    %eax
  8015d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015de:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e3:	f7 75 e4             	divl   -0x1c(%ebp)
  8015e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e9:	29 d0                	sub    %edx,%eax
  8015eb:	c1 e8 0c             	shr    $0xc,%eax
  8015ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8015f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8015f8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8015ff:	a1 20 40 80 00       	mov    0x804020,%eax
  801604:	8b 40 7c             	mov    0x7c(%eax),%eax
  801607:	05 00 10 00 00       	add    $0x1000,%eax
  80160c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80160f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801614:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801617:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80161a:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801627:	01 d0                	add    %edx,%eax
  801629:	48                   	dec    %eax
  80162a:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80162d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801630:	ba 00 00 00 00       	mov    $0x0,%edx
  801635:	f7 75 d0             	divl   -0x30(%ebp)
  801638:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80163b:	29 d0                	sub    %edx,%eax
  80163d:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801640:	76 0a                	jbe    80164c <smalloc+0xa0>
		return NULL;
  801642:	b8 00 00 00 00       	mov    $0x0,%eax
  801647:	e9 f9 00 00 00       	jmp    801745 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80164c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801652:	eb 48                	jmp    80169c <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801657:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80165a:	c1 e8 0c             	shr    $0xc,%eax
  80165d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801660:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801663:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  80166a:	85 c0                	test   %eax,%eax
  80166c:	75 11                	jne    80167f <smalloc+0xd3>
			freePagesCount++;
  80166e:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801671:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801675:	75 16                	jne    80168d <smalloc+0xe1>
				start = s;
  801677:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80167d:	eb 0e                	jmp    80168d <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80167f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801686:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801693:	74 12                	je     8016a7 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801695:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80169c:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8016a3:	76 af                	jbe    801654 <smalloc+0xa8>
  8016a5:	eb 01                	jmp    8016a8 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8016a7:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8016a8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016ac:	74 08                	je     8016b6 <smalloc+0x10a>
  8016ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8016b4:	74 0a                	je     8016c0 <smalloc+0x114>
		return NULL;
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bb:	e9 85 00 00 00       	jmp    801745 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8016c6:	c1 e8 0c             	shr    $0xc,%eax
  8016c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8016cc:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016d2:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016df:	eb 11                	jmp    8016f2 <smalloc+0x146>
		markedPages[s] = 1;
  8016e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e4:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8016eb:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016ef:	ff 45 e8             	incl   -0x18(%ebp)
  8016f2:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8016f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016f8:	01 d0                	add    %edx,%eax
  8016fa:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016fd:	77 e2                	ja     8016e1 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8016ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801702:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801706:	52                   	push   %edx
  801707:	50                   	push   %eax
  801708:	ff 75 0c             	pushl  0xc(%ebp)
  80170b:	ff 75 08             	pushl  0x8(%ebp)
  80170e:	e8 8f 04 00 00       	call   801ba2 <sys_createSharedObject>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801719:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80171d:	78 12                	js     801731 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80171f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801722:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801725:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  80172c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172f:	eb 14                	jmp    801745 <smalloc+0x199>
	}
	free((void*) start);
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	83 ec 0c             	sub    $0xc,%esp
  801737:	50                   	push   %eax
  801738:	e8 6e fd ff ff       	call   8014ab <free>
  80173d:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801745:	c9                   	leave  
  801746:	c3                   	ret    

00801747 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80174d:	83 ec 08             	sub    $0x8,%esp
  801750:	ff 75 0c             	pushl  0xc(%ebp)
  801753:	ff 75 08             	pushl  0x8(%ebp)
  801756:	e8 71 04 00 00       	call   801bcc <sys_getSizeOfSharedObject>
  80175b:	83 c4 10             	add    $0x10,%esp
  80175e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801761:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801768:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80176b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	48                   	dec    %eax
  801771:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	f7 75 e0             	divl   -0x20(%ebp)
  80177f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801782:	29 d0                	sub    %edx,%eax
  801784:	c1 e8 0c             	shr    $0xc,%eax
  801787:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80178a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801791:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801798:	a1 20 40 80 00       	mov    0x804020,%eax
  80179d:	8b 40 7c             	mov    0x7c(%eax),%eax
  8017a0:	05 00 10 00 00       	add    $0x1000,%eax
  8017a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8017a8:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017ad:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8017b3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8017ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017bd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017c0:	01 d0                	add    %edx,%eax
  8017c2:	48                   	dec    %eax
  8017c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8017c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ce:	f7 75 cc             	divl   -0x34(%ebp)
  8017d1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017d4:	29 d0                	sub    %edx,%eax
  8017d6:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017d9:	76 0a                	jbe    8017e5 <sget+0x9e>
		return NULL;
  8017db:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e0:	e9 f7 00 00 00       	jmp    8018dc <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017e5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017eb:	eb 48                	jmp    801835 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8017ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f0:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017f3:	c1 e8 0c             	shr    $0xc,%eax
  8017f6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8017f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017fc:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801803:	85 c0                	test   %eax,%eax
  801805:	75 11                	jne    801818 <sget+0xd1>
			free_Pages_Count++;
  801807:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80180a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80180e:	75 16                	jne    801826 <sget+0xdf>
				start = s;
  801810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801813:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801816:	eb 0e                	jmp    801826 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80181f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801829:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80182c:	74 12                	je     801840 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80182e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801835:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80183c:	76 af                	jbe    8017ed <sget+0xa6>
  80183e:	eb 01                	jmp    801841 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801840:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801841:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801845:	74 08                	je     80184f <sget+0x108>
  801847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80184a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80184d:	74 0a                	je     801859 <sget+0x112>
		return NULL;
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
  801854:	e9 83 00 00 00       	jmp    8018dc <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80185f:	c1 e8 0c             	shr    $0xc,%eax
  801862:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801865:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801868:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80186b:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801872:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801875:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801878:	eb 11                	jmp    80188b <sget+0x144>
		markedPages[k] = 1;
  80187a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187d:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801884:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801888:	ff 45 e8             	incl   -0x18(%ebp)
  80188b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80188e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801896:	77 e2                	ja     80187a <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801898:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189b:	83 ec 04             	sub    $0x4,%esp
  80189e:	50                   	push   %eax
  80189f:	ff 75 0c             	pushl  0xc(%ebp)
  8018a2:	ff 75 08             	pushl  0x8(%ebp)
  8018a5:	e8 3f 03 00 00       	call   801be9 <sys_getSharedObject>
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8018b0:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8018b4:	78 12                	js     8018c8 <sget+0x181>
		shardIDs[startPage] = ss;
  8018b6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018b9:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8018bc:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  8018c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c6:	eb 14                	jmp    8018dc <sget+0x195>
	}
	free((void*) start);
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cb:	83 ec 0c             	sub    $0xc,%esp
  8018ce:	50                   	push   %eax
  8018cf:	e8 d7 fb ff ff       	call   8014ab <free>
  8018d4:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8018e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8018ec:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018ef:	29 c2                	sub    %eax,%edx
  8018f1:	89 d0                	mov    %edx,%eax
  8018f3:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8018f8:	c1 e8 0c             	shr    $0xc,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8018fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801901:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  801908:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80190b:	83 ec 08             	sub    $0x8,%esp
  80190e:	ff 75 08             	pushl  0x8(%ebp)
  801911:	ff 75 f0             	pushl  -0x10(%ebp)
  801914:	e8 ef 02 00 00       	call   801c08 <sys_freeSharedObject>
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80191f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801923:	75 0e                	jne    801933 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801928:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  80192f:	ff ff ff ff 
	}

}
  801933:	90                   	nop
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80193c:	83 ec 04             	sub    $0x4,%esp
  80193f:	68 a0 3d 80 00       	push   $0x803da0
  801944:	68 19 01 00 00       	push   $0x119
  801949:	68 92 3d 80 00       	push   $0x803d92
  80194e:	e8 35 e9 ff ff       	call   800288 <_panic>

00801953 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
  801956:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	68 c6 3d 80 00       	push   $0x803dc6
  801961:	68 23 01 00 00       	push   $0x123
  801966:	68 92 3d 80 00       	push   $0x803d92
  80196b:	e8 18 e9 ff ff       	call   800288 <_panic>

00801970 <shrink>:

}
void shrink(uint32 newSize) {
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	68 c6 3d 80 00       	push   $0x803dc6
  80197e:	68 27 01 00 00       	push   $0x127
  801983:	68 92 3d 80 00       	push   $0x803d92
  801988:	e8 fb e8 ff ff       	call   800288 <_panic>

0080198d <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	68 c6 3d 80 00       	push   $0x803dc6
  80199b:	68 2b 01 00 00       	push   $0x12b
  8019a0:	68 92 3d 80 00       	push   $0x803d92
  8019a5:	e8 de e8 ff ff       	call   800288 <_panic>

008019aa <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	57                   	push   %edi
  8019ae:	56                   	push   %esi
  8019af:	53                   	push   %ebx
  8019b0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019bf:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c5:	cd 30                	int    $0x30
  8019c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5f                   	pop    %edi
  8019d3:	5d                   	pop    %ebp
  8019d4:	c3                   	ret    

008019d5 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 04             	sub    $0x4,%esp
  8019db:	8b 45 10             	mov    0x10(%ebp),%eax
  8019de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8019e1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	52                   	push   %edx
  8019ed:	ff 75 0c             	pushl  0xc(%ebp)
  8019f0:	50                   	push   %eax
  8019f1:	6a 00                	push   $0x0
  8019f3:	e8 b2 ff ff ff       	call   8019aa <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	90                   	nop
  8019fc:	c9                   	leave  
  8019fd:	c3                   	ret    

008019fe <sys_cgetc>:

int sys_cgetc(void) {
  8019fe:	55                   	push   %ebp
  8019ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 02                	push   $0x2
  801a0d:	e8 98 ff ff ff       	call   8019aa <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_lock_cons>:

void sys_lock_cons(void) {
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 03                	push   $0x3
  801a26:	e8 7f ff ff ff       	call   8019aa <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	90                   	nop
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 04                	push   $0x4
  801a40:	e8 65 ff ff ff       	call   8019aa <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	90                   	nop
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a51:	8b 45 08             	mov    0x8(%ebp),%eax
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	52                   	push   %edx
  801a5b:	50                   	push   %eax
  801a5c:	6a 08                	push   $0x8
  801a5e:	e8 47 ff ff ff       	call   8019aa <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	56                   	push   %esi
  801a6c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801a6d:	8b 75 18             	mov    0x18(%ebp),%esi
  801a70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a73:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	56                   	push   %esi
  801a7d:	53                   	push   %ebx
  801a7e:	51                   	push   %ecx
  801a7f:	52                   	push   %edx
  801a80:	50                   	push   %eax
  801a81:	6a 09                	push   $0x9
  801a83:	e8 22 ff ff ff       	call   8019aa <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801a8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8e:	5b                   	pop    %ebx
  801a8f:	5e                   	pop    %esi
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    

00801a92 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	52                   	push   %edx
  801aa2:	50                   	push   %eax
  801aa3:	6a 0a                	push   $0xa
  801aa5:	e8 00 ff ff ff       	call   8019aa <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	ff 75 0c             	pushl  0xc(%ebp)
  801abb:	ff 75 08             	pushl  0x8(%ebp)
  801abe:	6a 0b                	push   $0xb
  801ac0:	e8 e5 fe ff ff       	call   8019aa <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 0c                	push   $0xc
  801ad9:	e8 cc fe ff ff       	call   8019aa <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 0d                	push   $0xd
  801af2:	e8 b3 fe ff ff       	call   8019aa <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aff:	6a 00                	push   $0x0
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 0e                	push   $0xe
  801b0b:	e8 9a fe ff ff       	call   8019aa <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 0f                	push   $0xf
  801b24:	e8 81 fe ff ff       	call   8019aa <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 08             	pushl  0x8(%ebp)
  801b3c:	6a 10                	push   $0x10
  801b3e:	e8 67 fe ff ff       	call   8019aa <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_scarce_memory>:

void sys_scarce_memory() {
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 11                	push   $0x11
  801b57:	e8 4e fe ff ff       	call   8019aa <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	90                   	nop
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_cputc>:

void sys_cputc(const char c) {
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 04             	sub    $0x4,%esp
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b6e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	50                   	push   %eax
  801b7b:	6a 01                	push   $0x1
  801b7d:	e8 28 fe ff ff       	call   8019aa <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	90                   	nop
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 14                	push   $0x14
  801b97:	e8 0e fe ff ff       	call   8019aa <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	90                   	nop
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  801bab:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801bae:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	51                   	push   %ecx
  801bbb:	52                   	push   %edx
  801bbc:	ff 75 0c             	pushl  0xc(%ebp)
  801bbf:	50                   	push   %eax
  801bc0:	6a 15                	push   $0x15
  801bc2:	e8 e3 fd ff ff       	call   8019aa <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	52                   	push   %edx
  801bdc:	50                   	push   %eax
  801bdd:	6a 16                	push   $0x16
  801bdf:	e8 c6 fd ff ff       	call   8019aa <syscall>
  801be4:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801be7:	c9                   	leave  
  801be8:	c3                   	ret    

00801be9 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801be9:	55                   	push   %ebp
  801bea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801bec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	51                   	push   %ecx
  801bfa:	52                   	push   %edx
  801bfb:	50                   	push   %eax
  801bfc:	6a 17                	push   $0x17
  801bfe:	e8 a7 fd ff ff       	call   8019aa <syscall>
  801c03:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801c0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	52                   	push   %edx
  801c18:	50                   	push   %eax
  801c19:	6a 18                	push   $0x18
  801c1b:	e8 8a fd ff ff       	call   8019aa <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801c28:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 14             	pushl  0x14(%ebp)
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	50                   	push   %eax
  801c37:	6a 19                	push   $0x19
  801c39:	e8 6c fd ff ff       	call   8019aa <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_run_env>:

void sys_run_env(int32 envId) {
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	50                   	push   %eax
  801c52:	6a 1a                	push   $0x1a
  801c54:	e8 51 fd ff ff       	call   8019aa <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	90                   	nop
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	50                   	push   %eax
  801c6e:	6a 1b                	push   $0x1b
  801c70:	e8 35 fd ff ff       	call   8019aa <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_getenvid>:

int32 sys_getenvid(void) {
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 05                	push   $0x5
  801c89:	e8 1c fd ff ff       	call   8019aa <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 06                	push   $0x6
  801ca2:	e8 03 fd ff ff       	call   8019aa <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	c9                   	leave  
  801cab:	c3                   	ret    

00801cac <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 07                	push   $0x7
  801cbb:	e8 ea fc ff ff       	call   8019aa <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <sys_exit_env>:

void sys_exit_env(void) {
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 1c                	push   $0x1c
  801cd4:	e8 d1 fc ff ff       	call   8019aa <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	90                   	nop
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801ce5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce8:	8d 50 04             	lea    0x4(%eax),%edx
  801ceb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 1d                	push   $0x1d
  801cf8:	e8 ad fc ff ff       	call   8019aa <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801d00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d06:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d09:	89 01                	mov    %eax,(%ecx)
  801d0b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	c9                   	leave  
  801d12:	c2 04 00             	ret    $0x4

00801d15 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	ff 75 10             	pushl  0x10(%ebp)
  801d1f:	ff 75 0c             	pushl  0xc(%ebp)
  801d22:	ff 75 08             	pushl  0x8(%ebp)
  801d25:	6a 13                	push   $0x13
  801d27:	e8 7e fc ff ff       	call   8019aa <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801d2f:	90                   	nop
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_rcr2>:
uint32 sys_rcr2() {
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 1e                	push   $0x1e
  801d41:	e8 64 fc ff ff       	call   8019aa <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d57:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	50                   	push   %eax
  801d64:	6a 1f                	push   $0x1f
  801d66:	e8 3f fc ff ff       	call   8019aa <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return;
  801d6e:	90                   	nop
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <rsttst>:
void rsttst() {
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 21                	push   $0x21
  801d80:	e8 25 fc ff ff       	call   8019aa <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
	return;
  801d88:	90                   	nop
}
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 04             	sub    $0x4,%esp
  801d91:	8b 45 14             	mov    0x14(%ebp),%eax
  801d94:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d97:	8b 55 18             	mov    0x18(%ebp),%edx
  801d9a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d9e:	52                   	push   %edx
  801d9f:	50                   	push   %eax
  801da0:	ff 75 10             	pushl  0x10(%ebp)
  801da3:	ff 75 0c             	pushl  0xc(%ebp)
  801da6:	ff 75 08             	pushl  0x8(%ebp)
  801da9:	6a 20                	push   $0x20
  801dab:	e8 fa fb ff ff       	call   8019aa <syscall>
  801db0:	83 c4 18             	add    $0x18,%esp
	return;
  801db3:	90                   	nop
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <chktst>:
void chktst(uint32 n) {
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	ff 75 08             	pushl  0x8(%ebp)
  801dc4:	6a 22                	push   $0x22
  801dc6:	e8 df fb ff ff       	call   8019aa <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
	return;
  801dce:	90                   	nop
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <inctst>:

void inctst() {
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 23                	push   $0x23
  801de0:	e8 c5 fb ff ff       	call   8019aa <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
	return;
  801de8:	90                   	nop
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <gettst>:
uint32 gettst() {
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 24                	push   $0x24
  801dfa:	e8 ab fb ff ff       	call   8019aa <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 25                	push   $0x25
  801e16:	e8 8f fb ff ff       	call   8019aa <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
  801e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e21:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e25:	75 07                	jne    801e2e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e27:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2c:	eb 05                	jmp    801e33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 25                	push   $0x25
  801e47:	e8 5e fb ff ff       	call   8019aa <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
  801e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e52:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e56:	75 07                	jne    801e5f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e58:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5d:	eb 05                	jmp    801e64 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 25                	push   $0x25
  801e78:	e8 2d fb ff ff       	call   8019aa <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
  801e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e83:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e87:	75 07                	jne    801e90 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e89:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8e:	eb 05                	jmp    801e95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 25                	push   $0x25
  801ea9:	e8 fc fa ff ff       	call   8019aa <syscall>
  801eae:	83 c4 18             	add    $0x18,%esp
  801eb1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eb4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eb8:	75 07                	jne    801ec1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eba:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebf:	eb 05                	jmp    801ec6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	ff 75 08             	pushl  0x8(%ebp)
  801ed6:	6a 26                	push   $0x26
  801ed8:	e8 cd fa ff ff       	call   8019aa <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
	return;
  801ee0:	90                   	nop
}
  801ee1:	c9                   	leave  
  801ee2:	c3                   	ret    

00801ee3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801ee3:	55                   	push   %ebp
  801ee4:	89 e5                	mov    %esp,%ebp
  801ee6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801ee7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef3:	6a 00                	push   $0x0
  801ef5:	53                   	push   %ebx
  801ef6:	51                   	push   %ecx
  801ef7:	52                   	push   %edx
  801ef8:	50                   	push   %eax
  801ef9:	6a 27                	push   $0x27
  801efb:	e8 aa fa ff ff       	call   8019aa <syscall>
  801f00:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801f03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	6a 28                	push   $0x28
  801f1b:	e8 8a fa ff ff       	call   8019aa <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801f28:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	6a 00                	push   $0x0
  801f33:	51                   	push   %ecx
  801f34:	ff 75 10             	pushl  0x10(%ebp)
  801f37:	52                   	push   %edx
  801f38:	50                   	push   %eax
  801f39:	6a 29                	push   $0x29
  801f3b:	e8 6a fa ff ff       	call   8019aa <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	ff 75 10             	pushl  0x10(%ebp)
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	6a 12                	push   $0x12
  801f57:	e8 4e fa ff ff       	call   8019aa <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801f65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	52                   	push   %edx
  801f72:	50                   	push   %eax
  801f73:	6a 2a                	push   $0x2a
  801f75:	e8 30 fa ff ff       	call   8019aa <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
	return;
  801f7d:	90                   	nop
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801f83:	8b 45 08             	mov    0x8(%ebp),%eax
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	50                   	push   %eax
  801f8f:	6a 2b                	push   $0x2b
  801f91:	e8 14 fa ff ff       	call   8019aa <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	ff 75 0c             	pushl  0xc(%ebp)
  801fa7:	ff 75 08             	pushl  0x8(%ebp)
  801faa:	6a 2c                	push   $0x2c
  801fac:	e8 f9 f9 ff ff       	call   8019aa <syscall>
  801fb1:	83 c4 18             	add    $0x18,%esp
	return;
  801fb4:	90                   	nop
}
  801fb5:	c9                   	leave  
  801fb6:	c3                   	ret    

00801fb7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801fb7:	55                   	push   %ebp
  801fb8:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	6a 00                	push   $0x0
  801fc0:	ff 75 0c             	pushl  0xc(%ebp)
  801fc3:	ff 75 08             	pushl  0x8(%ebp)
  801fc6:	6a 2d                	push   $0x2d
  801fc8:	e8 dd f9 ff ff       	call   8019aa <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
	return;
  801fd0:	90                   	nop
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	50                   	push   %eax
  801fe2:	6a 2f                	push   $0x2f
  801fe4:	e8 c1 f9 ff ff       	call   8019aa <syscall>
  801fe9:	83 c4 18             	add    $0x18,%esp
	return;
  801fec:	90                   	nop
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801ff2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	52                   	push   %edx
  801fff:	50                   	push   %eax
  802000:	6a 30                	push   $0x30
  802002:	e8 a3 f9 ff ff       	call   8019aa <syscall>
  802007:	83 c4 18             	add    $0x18,%esp
	return;
  80200a:	90                   	nop
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	50                   	push   %eax
  80201c:	6a 31                	push   $0x31
  80201e:	e8 87 f9 ff ff       	call   8019aa <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
	return;
  802026:	90                   	nop
}
  802027:	c9                   	leave  
  802028:	c3                   	ret    

00802029 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80202c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	52                   	push   %edx
  802039:	50                   	push   %eax
  80203a:	6a 2e                	push   $0x2e
  80203c:	e8 69 f9 ff ff       	call   8019aa <syscall>
  802041:	83 c4 18             	add    $0x18,%esp
    return;
  802044:	90                   	nop
}
  802045:	c9                   	leave  
  802046:	c3                   	ret    

00802047 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80204d:	8b 45 08             	mov    0x8(%ebp),%eax
  802050:	83 e8 04             	sub    $0x4,%eax
  802053:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802059:	8b 00                	mov    (%eax),%eax
  80205b:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80205e:	c9                   	leave  
  80205f:	c3                   	ret    

00802060 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802060:	55                   	push   %ebp
  802061:	89 e5                	mov    %esp,%ebp
  802063:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	83 e8 04             	sub    $0x4,%eax
  80206c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80206f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802072:	8b 00                	mov    (%eax),%eax
  802074:	83 e0 01             	and    $0x1,%eax
  802077:	85 c0                	test   %eax,%eax
  802079:	0f 94 c0             	sete   %al
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802084:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80208b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208e:	83 f8 02             	cmp    $0x2,%eax
  802091:	74 2b                	je     8020be <alloc_block+0x40>
  802093:	83 f8 02             	cmp    $0x2,%eax
  802096:	7f 07                	jg     80209f <alloc_block+0x21>
  802098:	83 f8 01             	cmp    $0x1,%eax
  80209b:	74 0e                	je     8020ab <alloc_block+0x2d>
  80209d:	eb 58                	jmp    8020f7 <alloc_block+0x79>
  80209f:	83 f8 03             	cmp    $0x3,%eax
  8020a2:	74 2d                	je     8020d1 <alloc_block+0x53>
  8020a4:	83 f8 04             	cmp    $0x4,%eax
  8020a7:	74 3b                	je     8020e4 <alloc_block+0x66>
  8020a9:	eb 4c                	jmp    8020f7 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020ab:	83 ec 0c             	sub    $0xc,%esp
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	e8 f7 03 00 00       	call   8024ad <alloc_block_FF>
  8020b6:	83 c4 10             	add    $0x10,%esp
  8020b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020bc:	eb 4a                	jmp    802108 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020be:	83 ec 0c             	sub    $0xc,%esp
  8020c1:	ff 75 08             	pushl  0x8(%ebp)
  8020c4:	e8 f0 11 00 00       	call   8032b9 <alloc_block_NF>
  8020c9:	83 c4 10             	add    $0x10,%esp
  8020cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020cf:	eb 37                	jmp    802108 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	ff 75 08             	pushl  0x8(%ebp)
  8020d7:	e8 08 08 00 00       	call   8028e4 <alloc_block_BF>
  8020dc:	83 c4 10             	add    $0x10,%esp
  8020df:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e2:	eb 24                	jmp    802108 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020e4:	83 ec 0c             	sub    $0xc,%esp
  8020e7:	ff 75 08             	pushl  0x8(%ebp)
  8020ea:	e8 ad 11 00 00       	call   80329c <alloc_block_WF>
  8020ef:	83 c4 10             	add    $0x10,%esp
  8020f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f5:	eb 11                	jmp    802108 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020f7:	83 ec 0c             	sub    $0xc,%esp
  8020fa:	68 d8 3d 80 00       	push   $0x803dd8
  8020ff:	e8 41 e4 ff ff       	call   800545 <cprintf>
  802104:	83 c4 10             	add    $0x10,%esp
		break;
  802107:	90                   	nop
	}
	return va;
  802108:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	53                   	push   %ebx
  802111:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	68 f8 3d 80 00       	push   $0x803df8
  80211c:	e8 24 e4 ff ff       	call   800545 <cprintf>
  802121:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802124:	83 ec 0c             	sub    $0xc,%esp
  802127:	68 23 3e 80 00       	push   $0x803e23
  80212c:	e8 14 e4 ff ff       	call   800545 <cprintf>
  802131:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213a:	eb 37                	jmp    802173 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80213c:	83 ec 0c             	sub    $0xc,%esp
  80213f:	ff 75 f4             	pushl  -0xc(%ebp)
  802142:	e8 19 ff ff ff       	call   802060 <is_free_block>
  802147:	83 c4 10             	add    $0x10,%esp
  80214a:	0f be d8             	movsbl %al,%ebx
  80214d:	83 ec 0c             	sub    $0xc,%esp
  802150:	ff 75 f4             	pushl  -0xc(%ebp)
  802153:	e8 ef fe ff ff       	call   802047 <get_block_size>
  802158:	83 c4 10             	add    $0x10,%esp
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	53                   	push   %ebx
  80215f:	50                   	push   %eax
  802160:	68 3b 3e 80 00       	push   $0x803e3b
  802165:	e8 db e3 ff ff       	call   800545 <cprintf>
  80216a:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80216d:	8b 45 10             	mov    0x10(%ebp),%eax
  802170:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802173:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802177:	74 07                	je     802180 <print_blocks_list+0x73>
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	eb 05                	jmp    802185 <print_blocks_list+0x78>
  802180:	b8 00 00 00 00       	mov    $0x0,%eax
  802185:	89 45 10             	mov    %eax,0x10(%ebp)
  802188:	8b 45 10             	mov    0x10(%ebp),%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	75 ad                	jne    80213c <print_blocks_list+0x2f>
  80218f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802193:	75 a7                	jne    80213c <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802195:	83 ec 0c             	sub    $0xc,%esp
  802198:	68 f8 3d 80 00       	push   $0x803df8
  80219d:	e8 a3 e3 ff ff       	call   800545 <cprintf>
  8021a2:	83 c4 10             	add    $0x10,%esp

}
  8021a5:	90                   	nop
  8021a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a9:	c9                   	leave  
  8021aa:	c3                   	ret    

008021ab <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b4:	83 e0 01             	and    $0x1,%eax
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	74 03                	je     8021be <initialize_dynamic_allocator+0x13>
  8021bb:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8021be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021c2:	0f 84 f8 00 00 00    	je     8022c0 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8021c8:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  8021cf:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8021d2:	a1 40 40 98 00       	mov    0x984040,%eax
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	0f 84 e2 00 00 00    	je     8022c1 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f4:	01 d0                	add    %edx,%eax
  8021f6:	83 e8 04             	sub    $0x4,%eax
  8021f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ff:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	83 c0 08             	add    $0x8,%eax
  80220b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80220e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802211:	83 e8 08             	sub    $0x8,%eax
  802214:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802217:	83 ec 04             	sub    $0x4,%esp
  80221a:	6a 00                	push   $0x0
  80221c:	ff 75 e8             	pushl  -0x18(%ebp)
  80221f:	ff 75 ec             	pushl  -0x14(%ebp)
  802222:	e8 9c 00 00 00       	call   8022c3 <set_block_data>
  802227:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80222a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802236:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80223d:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  802244:	00 00 00 
  802247:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  80224e:	00 00 00 
  802251:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  802258:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80225b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80225f:	75 17                	jne    802278 <initialize_dynamic_allocator+0xcd>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 54 3e 80 00       	push   $0x803e54
  802269:	68 80 00 00 00       	push   $0x80
  80226e:	68 77 3e 80 00       	push   $0x803e77
  802273:	e8 10 e0 ff ff       	call   800288 <_panic>
  802278:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80227e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802281:	89 10                	mov    %edx,(%eax)
  802283:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802286:	8b 00                	mov    (%eax),%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	74 0d                	je     802299 <initialize_dynamic_allocator+0xee>
  80228c:	a1 48 40 98 00       	mov    0x984048,%eax
  802291:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802294:	89 50 04             	mov    %edx,0x4(%eax)
  802297:	eb 08                	jmp    8022a1 <initialize_dynamic_allocator+0xf6>
  802299:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229c:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8022a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a4:	a3 48 40 98 00       	mov    %eax,0x984048
  8022a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b3:	a1 54 40 98 00       	mov    0x984054,%eax
  8022b8:	40                   	inc    %eax
  8022b9:	a3 54 40 98 00       	mov    %eax,0x984054
  8022be:	eb 01                	jmp    8022c1 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8022c0:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
  8022c6:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8022c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cc:	83 e0 01             	and    $0x1,%eax
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	74 03                	je     8022d6 <set_block_data+0x13>
	{
		totalSize++;
  8022d3:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	83 e8 04             	sub    $0x4,%eax
  8022dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8022df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e2:	83 e0 fe             	and    $0xfffffffe,%eax
  8022e5:	89 c2                	mov    %eax,%edx
  8022e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ea:	83 e0 01             	and    $0x1,%eax
  8022ed:	09 c2                	or     %eax,%edx
  8022ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f2:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8022f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f7:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	01 d0                	add    %edx,%eax
  8022ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802302:	8b 45 0c             	mov    0xc(%ebp),%eax
  802305:	83 e0 fe             	and    $0xfffffffe,%eax
  802308:	89 c2                	mov    %eax,%edx
  80230a:	8b 45 10             	mov    0x10(%ebp),%eax
  80230d:	83 e0 01             	and    $0x1,%eax
  802310:	09 c2                	or     %eax,%edx
  802312:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802315:	89 10                	mov    %edx,(%eax)
}
  802317:	90                   	nop
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
  80231d:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802320:	a1 48 40 98 00       	mov    0x984048,%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	75 68                	jne    802391 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802329:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232d:	75 17                	jne    802346 <insert_sorted_in_freeList+0x2c>
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	68 54 3e 80 00       	push   $0x803e54
  802337:	68 9d 00 00 00       	push   $0x9d
  80233c:	68 77 3e 80 00       	push   $0x803e77
  802341:	e8 42 df ff ff       	call   800288 <_panic>
  802346:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	89 10                	mov    %edx,(%eax)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	85 c0                	test   %eax,%eax
  802358:	74 0d                	je     802367 <insert_sorted_in_freeList+0x4d>
  80235a:	a1 48 40 98 00       	mov    0x984048,%eax
  80235f:	8b 55 08             	mov    0x8(%ebp),%edx
  802362:	89 50 04             	mov    %edx,0x4(%eax)
  802365:	eb 08                	jmp    80236f <insert_sorted_in_freeList+0x55>
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	a3 48 40 98 00       	mov    %eax,0x984048
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802381:	a1 54 40 98 00       	mov    0x984054,%eax
  802386:	40                   	inc    %eax
  802387:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  80238c:	e9 1a 01 00 00       	jmp    8024ab <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802391:	a1 48 40 98 00       	mov    0x984048,%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802399:	eb 7f                	jmp    80241a <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a1:	76 6f                	jbe    802412 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8023a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a7:	74 06                	je     8023af <insert_sorted_in_freeList+0x95>
  8023a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ad:	75 17                	jne    8023c6 <insert_sorted_in_freeList+0xac>
  8023af:	83 ec 04             	sub    $0x4,%esp
  8023b2:	68 90 3e 80 00       	push   $0x803e90
  8023b7:	68 a6 00 00 00       	push   $0xa6
  8023bc:	68 77 3e 80 00       	push   $0x803e77
  8023c1:	e8 c2 de ff ff       	call   800288 <_panic>
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 50 04             	mov    0x4(%eax),%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	89 50 04             	mov    %edx,0x4(%eax)
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d8:	89 10                	mov    %edx,(%eax)
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	74 0d                	je     8023f1 <insert_sorted_in_freeList+0xd7>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ed:	89 10                	mov    %edx,(%eax)
  8023ef:	eb 08                	jmp    8023f9 <insert_sorted_in_freeList+0xdf>
  8023f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f4:	a3 48 40 98 00       	mov    %eax,0x984048
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ff:	89 50 04             	mov    %edx,0x4(%eax)
  802402:	a1 54 40 98 00       	mov    0x984054,%eax
  802407:	40                   	inc    %eax
  802408:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  80240d:	e9 99 00 00 00       	jmp    8024ab <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802412:	a1 50 40 98 00       	mov    0x984050,%eax
  802417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80241a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241e:	74 07                	je     802427 <insert_sorted_in_freeList+0x10d>
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	eb 05                	jmp    80242c <insert_sorted_in_freeList+0x112>
  802427:	b8 00 00 00 00       	mov    $0x0,%eax
  80242c:	a3 50 40 98 00       	mov    %eax,0x984050
  802431:	a1 50 40 98 00       	mov    0x984050,%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	0f 85 5d ff ff ff    	jne    80239b <insert_sorted_in_freeList+0x81>
  80243e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802442:	0f 85 53 ff ff ff    	jne    80239b <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802448:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80244c:	75 17                	jne    802465 <insert_sorted_in_freeList+0x14b>
  80244e:	83 ec 04             	sub    $0x4,%esp
  802451:	68 c8 3e 80 00       	push   $0x803ec8
  802456:	68 ab 00 00 00       	push   $0xab
  80245b:	68 77 3e 80 00       	push   $0x803e77
  802460:	e8 23 de ff ff       	call   800288 <_panic>
  802465:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	89 50 04             	mov    %edx,0x4(%eax)
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	8b 40 04             	mov    0x4(%eax),%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	74 0c                	je     802487 <insert_sorted_in_freeList+0x16d>
  80247b:	a1 4c 40 98 00       	mov    0x98404c,%eax
  802480:	8b 55 08             	mov    0x8(%ebp),%edx
  802483:	89 10                	mov    %edx,(%eax)
  802485:	eb 08                	jmp    80248f <insert_sorted_in_freeList+0x175>
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	a3 48 40 98 00       	mov    %eax,0x984048
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a0:	a1 54 40 98 00       	mov    0x984054,%eax
  8024a5:	40                   	inc    %eax
  8024a6:	a3 54 40 98 00       	mov    %eax,0x984054
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	83 e0 01             	and    $0x1,%eax
  8024b9:	85 c0                	test   %eax,%eax
  8024bb:	74 03                	je     8024c0 <alloc_block_FF+0x13>
  8024bd:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024c0:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024c4:	77 07                	ja     8024cd <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024c6:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024cd:	a1 40 40 98 00       	mov    0x984040,%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	75 63                	jne    802539 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d9:	83 c0 10             	add    $0x10,%eax
  8024dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024df:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ec:	01 d0                	add    %edx,%eax
  8024ee:	48                   	dec    %eax
  8024ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fa:	f7 75 ec             	divl   -0x14(%ebp)
  8024fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802500:	29 d0                	sub    %edx,%eax
  802502:	c1 e8 0c             	shr    $0xc,%eax
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	50                   	push   %eax
  802509:	e8 d1 ed ff ff       	call   8012df <sbrk>
  80250e:	83 c4 10             	add    $0x10,%esp
  802511:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802514:	83 ec 0c             	sub    $0xc,%esp
  802517:	6a 00                	push   $0x0
  802519:	e8 c1 ed ff ff       	call   8012df <sbrk>
  80251e:	83 c4 10             	add    $0x10,%esp
  802521:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802527:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80252a:	83 ec 08             	sub    $0x8,%esp
  80252d:	50                   	push   %eax
  80252e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802531:	e8 75 fc ff ff       	call   8021ab <initialize_dynamic_allocator>
  802536:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802539:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80253d:	75 0a                	jne    802549 <alloc_block_FF+0x9c>
	{
		return NULL;
  80253f:	b8 00 00 00 00       	mov    $0x0,%eax
  802544:	e9 99 03 00 00       	jmp    8028e2 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802549:	8b 45 08             	mov    0x8(%ebp),%eax
  80254c:	83 c0 08             	add    $0x8,%eax
  80254f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802552:	a1 48 40 98 00       	mov    0x984048,%eax
  802557:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255a:	e9 03 02 00 00       	jmp    802762 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  80255f:	83 ec 0c             	sub    $0xc,%esp
  802562:	ff 75 f4             	pushl  -0xc(%ebp)
  802565:	e8 dd fa ff ff       	call   802047 <get_block_size>
  80256a:	83 c4 10             	add    $0x10,%esp
  80256d:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802570:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802573:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802576:	0f 82 de 01 00 00    	jb     80275a <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80257c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80257f:	83 c0 10             	add    $0x10,%eax
  802582:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802585:	0f 87 32 01 00 00    	ja     8026bd <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80258b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80258e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802591:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802594:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802597:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80259a:	01 d0                	add    %edx,%eax
  80259c:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80259f:	83 ec 04             	sub    $0x4,%esp
  8025a2:	6a 00                	push   $0x0
  8025a4:	ff 75 98             	pushl  -0x68(%ebp)
  8025a7:	ff 75 94             	pushl  -0x6c(%ebp)
  8025aa:	e8 14 fd ff ff       	call   8022c3 <set_block_data>
  8025af:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8025b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b6:	74 06                	je     8025be <alloc_block_FF+0x111>
  8025b8:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8025bc:	75 17                	jne    8025d5 <alloc_block_FF+0x128>
  8025be:	83 ec 04             	sub    $0x4,%esp
  8025c1:	68 ec 3e 80 00       	push   $0x803eec
  8025c6:	68 de 00 00 00       	push   $0xde
  8025cb:	68 77 3e 80 00       	push   $0x803e77
  8025d0:	e8 b3 dc ff ff       	call   800288 <_panic>
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 10                	mov    (%eax),%edx
  8025da:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025dd:	89 10                	mov    %edx,(%eax)
  8025df:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	74 0b                	je     8025f3 <alloc_block_FF+0x146>
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 00                	mov    (%eax),%eax
  8025ed:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025f0:	89 50 04             	mov    %edx,0x4(%eax)
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025f9:	89 10                	mov    %edx,(%eax)
  8025fb:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802601:	89 50 04             	mov    %edx,0x4(%eax)
  802604:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802607:	8b 00                	mov    (%eax),%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	75 08                	jne    802615 <alloc_block_FF+0x168>
  80260d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802610:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802615:	a1 54 40 98 00       	mov    0x984054,%eax
  80261a:	40                   	inc    %eax
  80261b:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802620:	83 ec 04             	sub    $0x4,%esp
  802623:	6a 01                	push   $0x1
  802625:	ff 75 dc             	pushl  -0x24(%ebp)
  802628:	ff 75 f4             	pushl  -0xc(%ebp)
  80262b:	e8 93 fc ff ff       	call   8022c3 <set_block_data>
  802630:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802633:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802637:	75 17                	jne    802650 <alloc_block_FF+0x1a3>
  802639:	83 ec 04             	sub    $0x4,%esp
  80263c:	68 20 3f 80 00       	push   $0x803f20
  802641:	68 e3 00 00 00       	push   $0xe3
  802646:	68 77 3e 80 00       	push   $0x803e77
  80264b:	e8 38 dc ff ff       	call   800288 <_panic>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	85 c0                	test   %eax,%eax
  802657:	74 10                	je     802669 <alloc_block_FF+0x1bc>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802661:	8b 52 04             	mov    0x4(%edx),%edx
  802664:	89 50 04             	mov    %edx,0x4(%eax)
  802667:	eb 0b                	jmp    802674 <alloc_block_FF+0x1c7>
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 04             	mov    0x4(%eax),%eax
  80266f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 0f                	je     80268d <alloc_block_FF+0x1e0>
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 04             	mov    0x4(%eax),%eax
  802684:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802687:	8b 12                	mov    (%edx),%edx
  802689:	89 10                	mov    %edx,(%eax)
  80268b:	eb 0a                	jmp    802697 <alloc_block_FF+0x1ea>
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	a3 48 40 98 00       	mov    %eax,0x984048
  802697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026aa:	a1 54 40 98 00       	mov    0x984054,%eax
  8026af:	48                   	dec    %eax
  8026b0:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  8026b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b8:	e9 25 02 00 00       	jmp    8028e2 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8026bd:	83 ec 04             	sub    $0x4,%esp
  8026c0:	6a 01                	push   $0x1
  8026c2:	ff 75 9c             	pushl  -0x64(%ebp)
  8026c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c8:	e8 f6 fb ff ff       	call   8022c3 <set_block_data>
  8026cd:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8026d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d4:	75 17                	jne    8026ed <alloc_block_FF+0x240>
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	68 20 3f 80 00       	push   $0x803f20
  8026de:	68 eb 00 00 00       	push   $0xeb
  8026e3:	68 77 3e 80 00       	push   $0x803e77
  8026e8:	e8 9b db ff ff       	call   800288 <_panic>
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	85 c0                	test   %eax,%eax
  8026f4:	74 10                	je     802706 <alloc_block_FF+0x259>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fe:	8b 52 04             	mov    0x4(%edx),%edx
  802701:	89 50 04             	mov    %edx,0x4(%eax)
  802704:	eb 0b                	jmp    802711 <alloc_block_FF+0x264>
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 40 04             	mov    0x4(%eax),%eax
  80270c:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 40 04             	mov    0x4(%eax),%eax
  802717:	85 c0                	test   %eax,%eax
  802719:	74 0f                	je     80272a <alloc_block_FF+0x27d>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 40 04             	mov    0x4(%eax),%eax
  802721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802724:	8b 12                	mov    (%edx),%edx
  802726:	89 10                	mov    %edx,(%eax)
  802728:	eb 0a                	jmp    802734 <alloc_block_FF+0x287>
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 00                	mov    (%eax),%eax
  80272f:	a3 48 40 98 00       	mov    %eax,0x984048
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802747:	a1 54 40 98 00       	mov    0x984054,%eax
  80274c:	48                   	dec    %eax
  80274d:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	e9 88 01 00 00       	jmp    8028e2 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80275a:	a1 50 40 98 00       	mov    0x984050,%eax
  80275f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802766:	74 07                	je     80276f <alloc_block_FF+0x2c2>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	eb 05                	jmp    802774 <alloc_block_FF+0x2c7>
  80276f:	b8 00 00 00 00       	mov    $0x0,%eax
  802774:	a3 50 40 98 00       	mov    %eax,0x984050
  802779:	a1 50 40 98 00       	mov    0x984050,%eax
  80277e:	85 c0                	test   %eax,%eax
  802780:	0f 85 d9 fd ff ff    	jne    80255f <alloc_block_FF+0xb2>
  802786:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278a:	0f 85 cf fd ff ff    	jne    80255f <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802790:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802797:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80279a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80279d:	01 d0                	add    %edx,%eax
  80279f:	48                   	dec    %eax
  8027a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8027ab:	f7 75 d8             	divl   -0x28(%ebp)
  8027ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b1:	29 d0                	sub    %edx,%eax
  8027b3:	c1 e8 0c             	shr    $0xc,%eax
  8027b6:	83 ec 0c             	sub    $0xc,%esp
  8027b9:	50                   	push   %eax
  8027ba:	e8 20 eb ff ff       	call   8012df <sbrk>
  8027bf:	83 c4 10             	add    $0x10,%esp
  8027c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8027c5:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027c9:	75 0a                	jne    8027d5 <alloc_block_FF+0x328>
		return NULL;
  8027cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d0:	e9 0d 01 00 00       	jmp    8028e2 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8027d5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027d8:	83 e8 04             	sub    $0x4,%eax
  8027db:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8027de:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8027e5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027e8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027eb:	01 d0                	add    %edx,%eax
  8027ed:	48                   	dec    %eax
  8027ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8027f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f9:	f7 75 c8             	divl   -0x38(%ebp)
  8027fc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027ff:	29 d0                	sub    %edx,%eax
  802801:	c1 e8 02             	shr    $0x2,%eax
  802804:	c1 e0 02             	shl    $0x2,%eax
  802807:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  80280a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80280d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802813:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802816:	83 e8 08             	sub    $0x8,%eax
  802819:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80281c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	83 e0 fe             	and    $0xfffffffe,%eax
  802824:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802827:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80282a:	f7 d8                	neg    %eax
  80282c:	89 c2                	mov    %eax,%edx
  80282e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802831:	01 d0                	add    %edx,%eax
  802833:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802836:	83 ec 0c             	sub    $0xc,%esp
  802839:	ff 75 b8             	pushl  -0x48(%ebp)
  80283c:	e8 1f f8 ff ff       	call   802060 <is_free_block>
  802841:	83 c4 10             	add    $0x10,%esp
  802844:	0f be c0             	movsbl %al,%eax
  802847:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  80284a:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80284e:	74 42                	je     802892 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802850:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802857:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80285a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80285d:	01 d0                	add    %edx,%eax
  80285f:	48                   	dec    %eax
  802860:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802863:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802866:	ba 00 00 00 00       	mov    $0x0,%edx
  80286b:	f7 75 b0             	divl   -0x50(%ebp)
  80286e:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802871:	29 d0                	sub    %edx,%eax
  802873:	89 c2                	mov    %eax,%edx
  802875:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802878:	01 d0                	add    %edx,%eax
  80287a:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	6a 00                	push   $0x0
  802882:	ff 75 a8             	pushl  -0x58(%ebp)
  802885:	ff 75 b8             	pushl  -0x48(%ebp)
  802888:	e8 36 fa ff ff       	call   8022c3 <set_block_data>
  80288d:	83 c4 10             	add    $0x10,%esp
  802890:	eb 42                	jmp    8028d4 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802892:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802899:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80289c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80289f:	01 d0                	add    %edx,%eax
  8028a1:	48                   	dec    %eax
  8028a2:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8028a5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ad:	f7 75 a4             	divl   -0x5c(%ebp)
  8028b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028b3:	29 d0                	sub    %edx,%eax
  8028b5:	83 ec 04             	sub    $0x4,%esp
  8028b8:	6a 00                	push   $0x0
  8028ba:	50                   	push   %eax
  8028bb:	ff 75 d0             	pushl  -0x30(%ebp)
  8028be:	e8 00 fa ff ff       	call   8022c3 <set_block_data>
  8028c3:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8028c6:	83 ec 0c             	sub    $0xc,%esp
  8028c9:	ff 75 d0             	pushl  -0x30(%ebp)
  8028cc:	e8 49 fa ff ff       	call   80231a <insert_sorted_in_freeList>
  8028d1:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8028d4:	83 ec 0c             	sub    $0xc,%esp
  8028d7:	ff 75 08             	pushl  0x8(%ebp)
  8028da:	e8 ce fb ff ff       	call   8024ad <alloc_block_FF>
  8028df:	83 c4 10             	add    $0x10,%esp
}
  8028e2:	c9                   	leave  
  8028e3:	c3                   	ret    

008028e4 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028e4:	55                   	push   %ebp
  8028e5:	89 e5                	mov    %esp,%ebp
  8028e7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8028ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ee:	75 0a                	jne    8028fa <alloc_block_BF+0x16>
	{
		return NULL;
  8028f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f5:	e9 7a 02 00 00       	jmp    802b74 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	83 c0 08             	add    $0x8,%eax
  802900:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802903:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  80290a:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802911:	a1 48 40 98 00       	mov    0x984048,%eax
  802916:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802919:	eb 32                	jmp    80294d <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  80291b:	ff 75 ec             	pushl  -0x14(%ebp)
  80291e:	e8 24 f7 ff ff       	call   802047 <get_block_size>
  802923:	83 c4 04             	add    $0x4,%esp
  802926:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802929:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80292f:	72 14                	jb     802945 <alloc_block_BF+0x61>
  802931:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802934:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802937:	73 0c                	jae    802945 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80293f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802942:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802945:	a1 50 40 98 00       	mov    0x984050,%eax
  80294a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80294d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802951:	74 07                	je     80295a <alloc_block_BF+0x76>
  802953:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	eb 05                	jmp    80295f <alloc_block_BF+0x7b>
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
  80295f:	a3 50 40 98 00       	mov    %eax,0x984050
  802964:	a1 50 40 98 00       	mov    0x984050,%eax
  802969:	85 c0                	test   %eax,%eax
  80296b:	75 ae                	jne    80291b <alloc_block_BF+0x37>
  80296d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802971:	75 a8                	jne    80291b <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802977:	75 22                	jne    80299b <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802979:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297c:	83 ec 0c             	sub    $0xc,%esp
  80297f:	50                   	push   %eax
  802980:	e8 5a e9 ff ff       	call   8012df <sbrk>
  802985:	83 c4 10             	add    $0x10,%esp
  802988:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80298b:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80298f:	75 0a                	jne    80299b <alloc_block_BF+0xb7>
			return NULL;
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
  802996:	e9 d9 01 00 00       	jmp    802b74 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80299b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299e:	83 c0 10             	add    $0x10,%eax
  8029a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029a4:	0f 87 32 01 00 00    	ja     802adc <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029b0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8029b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b9:	01 d0                	add    %edx,%eax
  8029bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8029be:	83 ec 04             	sub    $0x4,%esp
  8029c1:	6a 00                	push   $0x0
  8029c3:	ff 75 dc             	pushl  -0x24(%ebp)
  8029c6:	ff 75 d8             	pushl  -0x28(%ebp)
  8029c9:	e8 f5 f8 ff ff       	call   8022c3 <set_block_data>
  8029ce:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8029d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d5:	74 06                	je     8029dd <alloc_block_BF+0xf9>
  8029d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029db:	75 17                	jne    8029f4 <alloc_block_BF+0x110>
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	68 ec 3e 80 00       	push   $0x803eec
  8029e5:	68 49 01 00 00       	push   $0x149
  8029ea:	68 77 3e 80 00       	push   $0x803e77
  8029ef:	e8 94 d8 ff ff       	call   800288 <_panic>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 10                	mov    (%eax),%edx
  8029f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029fc:	89 10                	mov    %edx,(%eax)
  8029fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 0b                	je     802a12 <alloc_block_BF+0x12e>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 00                	mov    (%eax),%eax
  802a0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a0f:	89 50 04             	mov    %edx,0x4(%eax)
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a18:	89 10                	mov    %edx,(%eax)
  802a1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a20:	89 50 04             	mov    %edx,0x4(%eax)
  802a23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	75 08                	jne    802a34 <alloc_block_BF+0x150>
  802a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a2f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a34:	a1 54 40 98 00       	mov    0x984054,%eax
  802a39:	40                   	inc    %eax
  802a3a:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802a3f:	83 ec 04             	sub    $0x4,%esp
  802a42:	6a 01                	push   $0x1
  802a44:	ff 75 e8             	pushl  -0x18(%ebp)
  802a47:	ff 75 f4             	pushl  -0xc(%ebp)
  802a4a:	e8 74 f8 ff ff       	call   8022c3 <set_block_data>
  802a4f:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a56:	75 17                	jne    802a6f <alloc_block_BF+0x18b>
  802a58:	83 ec 04             	sub    $0x4,%esp
  802a5b:	68 20 3f 80 00       	push   $0x803f20
  802a60:	68 4e 01 00 00       	push   $0x14e
  802a65:	68 77 3e 80 00       	push   $0x803e77
  802a6a:	e8 19 d8 ff ff       	call   800288 <_panic>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	85 c0                	test   %eax,%eax
  802a76:	74 10                	je     802a88 <alloc_block_BF+0x1a4>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a80:	8b 52 04             	mov    0x4(%edx),%edx
  802a83:	89 50 04             	mov    %edx,0x4(%eax)
  802a86:	eb 0b                	jmp    802a93 <alloc_block_BF+0x1af>
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 40 04             	mov    0x4(%eax),%eax
  802a99:	85 c0                	test   %eax,%eax
  802a9b:	74 0f                	je     802aac <alloc_block_BF+0x1c8>
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 40 04             	mov    0x4(%eax),%eax
  802aa3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa6:	8b 12                	mov    (%edx),%edx
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	eb 0a                	jmp    802ab6 <alloc_block_BF+0x1d2>
  802aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	a3 48 40 98 00       	mov    %eax,0x984048
  802ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac9:	a1 54 40 98 00       	mov    0x984054,%eax
  802ace:	48                   	dec    %eax
  802acf:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	e9 98 00 00 00       	jmp    802b74 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802adc:	83 ec 04             	sub    $0x4,%esp
  802adf:	6a 01                	push   $0x1
  802ae1:	ff 75 f0             	pushl  -0x10(%ebp)
  802ae4:	ff 75 f4             	pushl  -0xc(%ebp)
  802ae7:	e8 d7 f7 ff ff       	call   8022c3 <set_block_data>
  802aec:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af3:	75 17                	jne    802b0c <alloc_block_BF+0x228>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 20 3f 80 00       	push   $0x803f20
  802afd:	68 56 01 00 00       	push   $0x156
  802b02:	68 77 3e 80 00       	push   $0x803e77
  802b07:	e8 7c d7 ff ff       	call   800288 <_panic>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 10                	je     802b25 <alloc_block_BF+0x241>
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1d:	8b 52 04             	mov    0x4(%edx),%edx
  802b20:	89 50 04             	mov    %edx,0x4(%eax)
  802b23:	eb 0b                	jmp    802b30 <alloc_block_BF+0x24c>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0f                	je     802b49 <alloc_block_BF+0x265>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b43:	8b 12                	mov    (%edx),%edx
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	eb 0a                	jmp    802b53 <alloc_block_BF+0x26f>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	a3 48 40 98 00       	mov    %eax,0x984048
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b66:	a1 54 40 98 00       	mov    0x984054,%eax
  802b6b:	48                   	dec    %eax
  802b6c:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802b74:	c9                   	leave  
  802b75:	c3                   	ret    

00802b76 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802b76:	55                   	push   %ebp
  802b77:	89 e5                	mov    %esp,%ebp
  802b79:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802b7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b80:	0f 84 6a 02 00 00    	je     802df0 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802b86:	ff 75 08             	pushl  0x8(%ebp)
  802b89:	e8 b9 f4 ff ff       	call   802047 <get_block_size>
  802b8e:	83 c4 04             	add    $0x4,%esp
  802b91:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	83 e8 08             	sub    $0x8,%eax
  802b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	83 e0 fe             	and    $0xfffffffe,%eax
  802ba5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bab:	f7 d8                	neg    %eax
  802bad:	89 c2                	mov    %eax,%edx
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	01 d0                	add    %edx,%eax
  802bb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802bb7:	ff 75 e8             	pushl  -0x18(%ebp)
  802bba:	e8 a1 f4 ff ff       	call   802060 <is_free_block>
  802bbf:	83 c4 04             	add    $0x4,%esp
  802bc2:	0f be c0             	movsbl %al,%eax
  802bc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	01 d0                	add    %edx,%eax
  802bd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802bd3:	ff 75 e0             	pushl  -0x20(%ebp)
  802bd6:	e8 85 f4 ff ff       	call   802060 <is_free_block>
  802bdb:	83 c4 04             	add    $0x4,%esp
  802bde:	0f be c0             	movsbl %al,%eax
  802be1:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802be4:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802be8:	75 34                	jne    802c1e <free_block+0xa8>
  802bea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bee:	75 2e                	jne    802c1e <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802bf0:	ff 75 e8             	pushl  -0x18(%ebp)
  802bf3:	e8 4f f4 ff ff       	call   802047 <get_block_size>
  802bf8:	83 c4 04             	add    $0x4,%esp
  802bfb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802bfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c01:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c04:	01 d0                	add    %edx,%eax
  802c06:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802c09:	6a 00                	push   $0x0
  802c0b:	ff 75 d4             	pushl  -0x2c(%ebp)
  802c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  802c11:	e8 ad f6 ff ff       	call   8022c3 <set_block_data>
  802c16:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802c19:	e9 d3 01 00 00       	jmp    802df1 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802c1e:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802c22:	0f 85 c8 00 00 00    	jne    802cf0 <free_block+0x17a>
  802c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c2c:	0f 85 be 00 00 00    	jne    802cf0 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802c32:	ff 75 e0             	pushl  -0x20(%ebp)
  802c35:	e8 0d f4 ff ff       	call   802047 <get_block_size>
  802c3a:	83 c4 04             	add    $0x4,%esp
  802c3d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c43:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c46:	01 d0                	add    %edx,%eax
  802c48:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802c4b:	6a 00                	push   $0x0
  802c4d:	ff 75 cc             	pushl  -0x34(%ebp)
  802c50:	ff 75 08             	pushl  0x8(%ebp)
  802c53:	e8 6b f6 ff ff       	call   8022c3 <set_block_data>
  802c58:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802c5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c5f:	75 17                	jne    802c78 <free_block+0x102>
  802c61:	83 ec 04             	sub    $0x4,%esp
  802c64:	68 20 3f 80 00       	push   $0x803f20
  802c69:	68 87 01 00 00       	push   $0x187
  802c6e:	68 77 3e 80 00       	push   $0x803e77
  802c73:	e8 10 d6 ff ff       	call   800288 <_panic>
  802c78:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7b:	8b 00                	mov    (%eax),%eax
  802c7d:	85 c0                	test   %eax,%eax
  802c7f:	74 10                	je     802c91 <free_block+0x11b>
  802c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c89:	8b 52 04             	mov    0x4(%edx),%edx
  802c8c:	89 50 04             	mov    %edx,0x4(%eax)
  802c8f:	eb 0b                	jmp    802c9c <free_block+0x126>
  802c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802c9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ca2:	85 c0                	test   %eax,%eax
  802ca4:	74 0f                	je     802cb5 <free_block+0x13f>
  802ca6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca9:	8b 40 04             	mov    0x4(%eax),%eax
  802cac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802caf:	8b 12                	mov    (%edx),%edx
  802cb1:	89 10                	mov    %edx,(%eax)
  802cb3:	eb 0a                	jmp    802cbf <free_block+0x149>
  802cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb8:	8b 00                	mov    (%eax),%eax
  802cba:	a3 48 40 98 00       	mov    %eax,0x984048
  802cbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ccb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd2:	a1 54 40 98 00       	mov    0x984054,%eax
  802cd7:	48                   	dec    %eax
  802cd8:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802cdd:	83 ec 0c             	sub    $0xc,%esp
  802ce0:	ff 75 08             	pushl  0x8(%ebp)
  802ce3:	e8 32 f6 ff ff       	call   80231a <insert_sorted_in_freeList>
  802ce8:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802ceb:	e9 01 01 00 00       	jmp    802df1 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802cf0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802cf4:	0f 85 d3 00 00 00    	jne    802dcd <free_block+0x257>
  802cfa:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802cfe:	0f 85 c9 00 00 00    	jne    802dcd <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802d04:	83 ec 0c             	sub    $0xc,%esp
  802d07:	ff 75 e8             	pushl  -0x18(%ebp)
  802d0a:	e8 38 f3 ff ff       	call   802047 <get_block_size>
  802d0f:	83 c4 10             	add    $0x10,%esp
  802d12:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802d15:	83 ec 0c             	sub    $0xc,%esp
  802d18:	ff 75 e0             	pushl  -0x20(%ebp)
  802d1b:	e8 27 f3 ff ff       	call   802047 <get_block_size>
  802d20:	83 c4 10             	add    $0x10,%esp
  802d23:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802d26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d29:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d2c:	01 c2                	add    %eax,%edx
  802d2e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d31:	01 d0                	add    %edx,%eax
  802d33:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	6a 00                	push   $0x0
  802d3b:	ff 75 c0             	pushl  -0x40(%ebp)
  802d3e:	ff 75 e8             	pushl  -0x18(%ebp)
  802d41:	e8 7d f5 ff ff       	call   8022c3 <set_block_data>
  802d46:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802d49:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d4d:	75 17                	jne    802d66 <free_block+0x1f0>
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	68 20 3f 80 00       	push   $0x803f20
  802d57:	68 94 01 00 00       	push   $0x194
  802d5c:	68 77 3e 80 00       	push   $0x803e77
  802d61:	e8 22 d5 ff ff       	call   800288 <_panic>
  802d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	74 10                	je     802d7f <free_block+0x209>
  802d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d77:	8b 52 04             	mov    0x4(%edx),%edx
  802d7a:	89 50 04             	mov    %edx,0x4(%eax)
  802d7d:	eb 0b                	jmp    802d8a <free_block+0x214>
  802d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d82:	8b 40 04             	mov    0x4(%eax),%eax
  802d85:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	74 0f                	je     802da3 <free_block+0x22d>
  802d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d97:	8b 40 04             	mov    0x4(%eax),%eax
  802d9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d9d:	8b 12                	mov    (%edx),%edx
  802d9f:	89 10                	mov    %edx,(%eax)
  802da1:	eb 0a                	jmp    802dad <free_block+0x237>
  802da3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	a3 48 40 98 00       	mov    %eax,0x984048
  802dad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc0:	a1 54 40 98 00       	mov    0x984054,%eax
  802dc5:	48                   	dec    %eax
  802dc6:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802dcb:	eb 24                	jmp    802df1 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802dcd:	83 ec 04             	sub    $0x4,%esp
  802dd0:	6a 00                	push   $0x0
  802dd2:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd5:	ff 75 08             	pushl  0x8(%ebp)
  802dd8:	e8 e6 f4 ff ff       	call   8022c3 <set_block_data>
  802ddd:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802de0:	83 ec 0c             	sub    $0xc,%esp
  802de3:	ff 75 08             	pushl  0x8(%ebp)
  802de6:	e8 2f f5 ff ff       	call   80231a <insert_sorted_in_freeList>
  802deb:	83 c4 10             	add    $0x10,%esp
  802dee:	eb 01                	jmp    802df1 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802df0:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802df1:	c9                   	leave  
  802df2:	c3                   	ret    

00802df3 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802df3:	55                   	push   %ebp
  802df4:	89 e5                	mov    %esp,%ebp
  802df6:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802df9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfd:	75 10                	jne    802e0f <realloc_block_FF+0x1c>
  802dff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e03:	75 0a                	jne    802e0f <realloc_block_FF+0x1c>
	{
		return NULL;
  802e05:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0a:	e9 8b 04 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802e0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e13:	75 18                	jne    802e2d <realloc_block_FF+0x3a>
	{
		free_block(va);
  802e15:	83 ec 0c             	sub    $0xc,%esp
  802e18:	ff 75 08             	pushl  0x8(%ebp)
  802e1b:	e8 56 fd ff ff       	call   802b76 <free_block>
  802e20:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802e23:	b8 00 00 00 00       	mov    $0x0,%eax
  802e28:	e9 6d 04 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802e2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e31:	75 13                	jne    802e46 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802e33:	83 ec 0c             	sub    $0xc,%esp
  802e36:	ff 75 0c             	pushl  0xc(%ebp)
  802e39:	e8 6f f6 ff ff       	call   8024ad <alloc_block_FF>
  802e3e:	83 c4 10             	add    $0x10,%esp
  802e41:	e9 54 04 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e49:	83 e0 01             	and    $0x1,%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 03                	je     802e53 <realloc_block_FF+0x60>
	{
		new_size++;
  802e50:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802e53:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802e57:	77 07                	ja     802e60 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802e59:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802e60:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802e64:	83 ec 0c             	sub    $0xc,%esp
  802e67:	ff 75 08             	pushl  0x8(%ebp)
  802e6a:	e8 d8 f1 ff ff       	call   802047 <get_block_size>
  802e6f:	83 c4 10             	add    $0x10,%esp
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e7b:	75 08                	jne    802e85 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	e9 15 04 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802e85:	8b 55 08             	mov    0x8(%ebp),%edx
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	01 d0                	add    %edx,%eax
  802e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802e90:	83 ec 0c             	sub    $0xc,%esp
  802e93:	ff 75 f0             	pushl  -0x10(%ebp)
  802e96:	e8 c5 f1 ff ff       	call   802060 <is_free_block>
  802e9b:	83 c4 10             	add    $0x10,%esp
  802e9e:	0f be c0             	movsbl %al,%eax
  802ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802ea4:	83 ec 0c             	sub    $0xc,%esp
  802ea7:	ff 75 f0             	pushl  -0x10(%ebp)
  802eaa:	e8 98 f1 ff ff       	call   802047 <get_block_size>
  802eaf:	83 c4 10             	add    $0x10,%esp
  802eb2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802ebb:	0f 86 a7 02 00 00    	jbe    803168 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802ec1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ec5:	0f 84 86 02 00 00    	je     803151 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802ecb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	01 d0                	add    %edx,%eax
  802ed3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ed6:	0f 85 b2 00 00 00    	jne    802f8e <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802edc:	83 ec 0c             	sub    $0xc,%esp
  802edf:	ff 75 08             	pushl  0x8(%ebp)
  802ee2:	e8 79 f1 ff ff       	call   802060 <is_free_block>
  802ee7:	83 c4 10             	add    $0x10,%esp
  802eea:	84 c0                	test   %al,%al
  802eec:	0f 94 c0             	sete   %al
  802eef:	0f b6 c0             	movzbl %al,%eax
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	50                   	push   %eax
  802ef6:	ff 75 0c             	pushl  0xc(%ebp)
  802ef9:	ff 75 08             	pushl  0x8(%ebp)
  802efc:	e8 c2 f3 ff ff       	call   8022c3 <set_block_data>
  802f01:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802f04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f08:	75 17                	jne    802f21 <realloc_block_FF+0x12e>
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	68 20 3f 80 00       	push   $0x803f20
  802f12:	68 db 01 00 00       	push   $0x1db
  802f17:	68 77 3e 80 00       	push   $0x803e77
  802f1c:	e8 67 d3 ff ff       	call   800288 <_panic>
  802f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f24:	8b 00                	mov    (%eax),%eax
  802f26:	85 c0                	test   %eax,%eax
  802f28:	74 10                	je     802f3a <realloc_block_FF+0x147>
  802f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f32:	8b 52 04             	mov    0x4(%edx),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	eb 0b                	jmp    802f45 <realloc_block_FF+0x152>
  802f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3d:	8b 40 04             	mov    0x4(%eax),%eax
  802f40:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f48:	8b 40 04             	mov    0x4(%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	74 0f                	je     802f5e <realloc_block_FF+0x16b>
  802f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f52:	8b 40 04             	mov    0x4(%eax),%eax
  802f55:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f58:	8b 12                	mov    (%edx),%edx
  802f5a:	89 10                	mov    %edx,(%eax)
  802f5c:	eb 0a                	jmp    802f68 <realloc_block_FF+0x175>
  802f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	a3 48 40 98 00       	mov    %eax,0x984048
  802f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7b:	a1 54 40 98 00       	mov    0x984054,%eax
  802f80:	48                   	dec    %eax
  802f81:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	e9 0c 03 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802f8e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	01 d0                	add    %edx,%eax
  802f96:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f99:	0f 86 b2 01 00 00    	jbe    803151 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802fa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802fae:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802fb1:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802fb5:	0f 87 b8 00 00 00    	ja     803073 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802fbb:	83 ec 0c             	sub    $0xc,%esp
  802fbe:	ff 75 08             	pushl  0x8(%ebp)
  802fc1:	e8 9a f0 ff ff       	call   802060 <is_free_block>
  802fc6:	83 c4 10             	add    $0x10,%esp
  802fc9:	84 c0                	test   %al,%al
  802fcb:	0f 94 c0             	sete   %al
  802fce:	0f b6 c0             	movzbl %al,%eax
  802fd1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802fd4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd7:	01 ca                	add    %ecx,%edx
  802fd9:	83 ec 04             	sub    $0x4,%esp
  802fdc:	50                   	push   %eax
  802fdd:	52                   	push   %edx
  802fde:	ff 75 08             	pushl  0x8(%ebp)
  802fe1:	e8 dd f2 ff ff       	call   8022c3 <set_block_data>
  802fe6:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802fe9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fed:	75 17                	jne    803006 <realloc_block_FF+0x213>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 20 3f 80 00       	push   $0x803f20
  802ff7:	68 e8 01 00 00       	push   $0x1e8
  802ffc:	68 77 3e 80 00       	push   $0x803e77
  803001:	e8 82 d2 ff ff       	call   800288 <_panic>
  803006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	85 c0                	test   %eax,%eax
  80300d:	74 10                	je     80301f <realloc_block_FF+0x22c>
  80300f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803012:	8b 00                	mov    (%eax),%eax
  803014:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803017:	8b 52 04             	mov    0x4(%edx),%edx
  80301a:	89 50 04             	mov    %edx,0x4(%eax)
  80301d:	eb 0b                	jmp    80302a <realloc_block_FF+0x237>
  80301f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80302a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302d:	8b 40 04             	mov    0x4(%eax),%eax
  803030:	85 c0                	test   %eax,%eax
  803032:	74 0f                	je     803043 <realloc_block_FF+0x250>
  803034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803037:	8b 40 04             	mov    0x4(%eax),%eax
  80303a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303d:	8b 12                	mov    (%edx),%edx
  80303f:	89 10                	mov    %edx,(%eax)
  803041:	eb 0a                	jmp    80304d <realloc_block_FF+0x25a>
  803043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	a3 48 40 98 00       	mov    %eax,0x984048
  80304d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803050:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803060:	a1 54 40 98 00       	mov    0x984054,%eax
  803065:	48                   	dec    %eax
  803066:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	e9 27 02 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803073:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803077:	75 17                	jne    803090 <realloc_block_FF+0x29d>
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	68 20 3f 80 00       	push   $0x803f20
  803081:	68 ed 01 00 00       	push   $0x1ed
  803086:	68 77 3e 80 00       	push   $0x803e77
  80308b:	e8 f8 d1 ff ff       	call   800288 <_panic>
  803090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 10                	je     8030a9 <realloc_block_FF+0x2b6>
  803099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a1:	8b 52 04             	mov    0x4(%edx),%edx
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	eb 0b                	jmp    8030b4 <realloc_block_FF+0x2c1>
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	8b 40 04             	mov    0x4(%eax),%eax
  8030af:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8030b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	85 c0                	test   %eax,%eax
  8030bc:	74 0f                	je     8030cd <realloc_block_FF+0x2da>
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c7:	8b 12                	mov    (%edx),%edx
  8030c9:	89 10                	mov    %edx,(%eax)
  8030cb:	eb 0a                	jmp    8030d7 <realloc_block_FF+0x2e4>
  8030cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	a3 48 40 98 00       	mov    %eax,0x984048
  8030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ea:	a1 54 40 98 00       	mov    0x984054,%eax
  8030ef:	48                   	dec    %eax
  8030f0:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8030f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fb:	01 d0                	add    %edx,%eax
  8030fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803100:	83 ec 04             	sub    $0x4,%esp
  803103:	6a 00                	push   $0x0
  803105:	ff 75 e0             	pushl  -0x20(%ebp)
  803108:	ff 75 f0             	pushl  -0x10(%ebp)
  80310b:	e8 b3 f1 ff ff       	call   8022c3 <set_block_data>
  803110:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803113:	83 ec 0c             	sub    $0xc,%esp
  803116:	ff 75 08             	pushl  0x8(%ebp)
  803119:	e8 42 ef ff ff       	call   802060 <is_free_block>
  80311e:	83 c4 10             	add    $0x10,%esp
  803121:	84 c0                	test   %al,%al
  803123:	0f 94 c0             	sete   %al
  803126:	0f b6 c0             	movzbl %al,%eax
  803129:	83 ec 04             	sub    $0x4,%esp
  80312c:	50                   	push   %eax
  80312d:	ff 75 0c             	pushl  0xc(%ebp)
  803130:	ff 75 08             	pushl  0x8(%ebp)
  803133:	e8 8b f1 ff ff       	call   8022c3 <set_block_data>
  803138:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80313b:	83 ec 0c             	sub    $0xc,%esp
  80313e:	ff 75 f0             	pushl  -0x10(%ebp)
  803141:	e8 d4 f1 ff ff       	call   80231a <insert_sorted_in_freeList>
  803146:	83 c4 10             	add    $0x10,%esp
					return va;
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	e9 49 01 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803151:	8b 45 0c             	mov    0xc(%ebp),%eax
  803154:	83 e8 08             	sub    $0x8,%eax
  803157:	83 ec 0c             	sub    $0xc,%esp
  80315a:	50                   	push   %eax
  80315b:	e8 4d f3 ff ff       	call   8024ad <alloc_block_FF>
  803160:	83 c4 10             	add    $0x10,%esp
  803163:	e9 32 01 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80316e:	0f 83 21 01 00 00    	jae    803295 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	2b 45 0c             	sub    0xc(%ebp),%eax
  80317a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80317d:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803181:	77 0e                	ja     803191 <realloc_block_FF+0x39e>
  803183:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803187:	75 08                	jne    803191 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803189:	8b 45 08             	mov    0x8(%ebp),%eax
  80318c:	e9 09 01 00 00       	jmp    80329a <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803197:	83 ec 0c             	sub    $0xc,%esp
  80319a:	ff 75 08             	pushl  0x8(%ebp)
  80319d:	e8 be ee ff ff       	call   802060 <is_free_block>
  8031a2:	83 c4 10             	add    $0x10,%esp
  8031a5:	84 c0                	test   %al,%al
  8031a7:	0f 94 c0             	sete   %al
  8031aa:	0f b6 c0             	movzbl %al,%eax
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	50                   	push   %eax
  8031b1:	ff 75 0c             	pushl  0xc(%ebp)
  8031b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8031b7:	e8 07 f1 ff ff       	call   8022c3 <set_block_data>
  8031bc:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8031bf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c5:	01 d0                	add    %edx,%eax
  8031c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	6a 00                	push   $0x0
  8031cf:	ff 75 dc             	pushl  -0x24(%ebp)
  8031d2:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031d5:	e8 e9 f0 ff ff       	call   8022c3 <set_block_data>
  8031da:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8031dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031e1:	0f 84 9b 00 00 00    	je     803282 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8031e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ed:	01 d0                	add    %edx,%eax
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	6a 00                	push   $0x0
  8031f4:	50                   	push   %eax
  8031f5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031f8:	e8 c6 f0 ff ff       	call   8022c3 <set_block_data>
  8031fd:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803200:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803204:	75 17                	jne    80321d <realloc_block_FF+0x42a>
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	68 20 3f 80 00       	push   $0x803f20
  80320e:	68 10 02 00 00       	push   $0x210
  803213:	68 77 3e 80 00       	push   $0x803e77
  803218:	e8 6b d0 ff ff       	call   800288 <_panic>
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	8b 00                	mov    (%eax),%eax
  803222:	85 c0                	test   %eax,%eax
  803224:	74 10                	je     803236 <realloc_block_FF+0x443>
  803226:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803229:	8b 00                	mov    (%eax),%eax
  80322b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322e:	8b 52 04             	mov    0x4(%edx),%edx
  803231:	89 50 04             	mov    %edx,0x4(%eax)
  803234:	eb 0b                	jmp    803241 <realloc_block_FF+0x44e>
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	8b 40 04             	mov    0x4(%eax),%eax
  80323c:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803241:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803244:	8b 40 04             	mov    0x4(%eax),%eax
  803247:	85 c0                	test   %eax,%eax
  803249:	74 0f                	je     80325a <realloc_block_FF+0x467>
  80324b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324e:	8b 40 04             	mov    0x4(%eax),%eax
  803251:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803254:	8b 12                	mov    (%edx),%edx
  803256:	89 10                	mov    %edx,(%eax)
  803258:	eb 0a                	jmp    803264 <realloc_block_FF+0x471>
  80325a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325d:	8b 00                	mov    (%eax),%eax
  80325f:	a3 48 40 98 00       	mov    %eax,0x984048
  803264:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803267:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803270:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803277:	a1 54 40 98 00       	mov    0x984054,%eax
  80327c:	48                   	dec    %eax
  80327d:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  803282:	83 ec 0c             	sub    $0xc,%esp
  803285:	ff 75 d4             	pushl  -0x2c(%ebp)
  803288:	e8 8d f0 ff ff       	call   80231a <insert_sorted_in_freeList>
  80328d:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803293:	eb 05                	jmp    80329a <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803295:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80329a:	c9                   	leave  
  80329b:	c3                   	ret    

0080329c <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80329c:	55                   	push   %ebp
  80329d:	89 e5                	mov    %esp,%ebp
  80329f:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8032a2:	83 ec 04             	sub    $0x4,%esp
  8032a5:	68 40 3f 80 00       	push   $0x803f40
  8032aa:	68 20 02 00 00       	push   $0x220
  8032af:	68 77 3e 80 00       	push   $0x803e77
  8032b4:	e8 cf cf ff ff       	call   800288 <_panic>

008032b9 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8032b9:	55                   	push   %ebp
  8032ba:	89 e5                	mov    %esp,%ebp
  8032bc:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8032bf:	83 ec 04             	sub    $0x4,%esp
  8032c2:	68 68 3f 80 00       	push   $0x803f68
  8032c7:	68 28 02 00 00       	push   $0x228
  8032cc:	68 77 3e 80 00       	push   $0x803e77
  8032d1:	e8 b2 cf ff ff       	call   800288 <_panic>

008032d6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032d6:	55                   	push   %ebp
  8032d7:	89 e5                	mov    %esp,%ebp
  8032d9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032df:	89 d0                	mov    %edx,%eax
  8032e1:	c1 e0 02             	shl    $0x2,%eax
  8032e4:	01 d0                	add    %edx,%eax
  8032e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ed:	01 d0                	add    %edx,%eax
  8032ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f6:	01 d0                	add    %edx,%eax
  8032f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ff:	01 d0                	add    %edx,%eax
  803301:	c1 e0 04             	shl    $0x4,%eax
  803304:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803307:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80330e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803311:	83 ec 0c             	sub    $0xc,%esp
  803314:	50                   	push   %eax
  803315:	e8 c5 e9 ff ff       	call   801cdf <sys_get_virtual_time>
  80331a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80331d:	eb 41                	jmp    803360 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80331f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803322:	83 ec 0c             	sub    $0xc,%esp
  803325:	50                   	push   %eax
  803326:	e8 b4 e9 ff ff       	call   801cdf <sys_get_virtual_time>
  80332b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80332e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803331:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803334:	29 c2                	sub    %eax,%edx
  803336:	89 d0                	mov    %edx,%eax
  803338:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80333b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803341:	89 d1                	mov    %edx,%ecx
  803343:	29 c1                	sub    %eax,%ecx
  803345:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803348:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334b:	39 c2                	cmp    %eax,%edx
  80334d:	0f 97 c0             	seta   %al
  803350:	0f b6 c0             	movzbl %al,%eax
  803353:	29 c1                	sub    %eax,%ecx
  803355:	89 c8                	mov    %ecx,%eax
  803357:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80335a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80335d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803363:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803366:	72 b7                	jb     80331f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803368:	90                   	nop
  803369:	c9                   	leave  
  80336a:	c3                   	ret    

0080336b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80336b:	55                   	push   %ebp
  80336c:	89 e5                	mov    %esp,%ebp
  80336e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803378:	eb 03                	jmp    80337d <busy_wait+0x12>
  80337a:	ff 45 fc             	incl   -0x4(%ebp)
  80337d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803380:	3b 45 08             	cmp    0x8(%ebp),%eax
  803383:	72 f5                	jb     80337a <busy_wait+0xf>
	return i;
  803385:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803388:	c9                   	leave  
  803389:	c3                   	ret    
  80338a:	66 90                	xchg   %ax,%ax

0080338c <__udivdi3>:
  80338c:	55                   	push   %ebp
  80338d:	57                   	push   %edi
  80338e:	56                   	push   %esi
  80338f:	53                   	push   %ebx
  803390:	83 ec 1c             	sub    $0x1c,%esp
  803393:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803397:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80339b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80339f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033a3:	89 ca                	mov    %ecx,%edx
  8033a5:	89 f8                	mov    %edi,%eax
  8033a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033ab:	85 f6                	test   %esi,%esi
  8033ad:	75 2d                	jne    8033dc <__udivdi3+0x50>
  8033af:	39 cf                	cmp    %ecx,%edi
  8033b1:	77 65                	ja     803418 <__udivdi3+0x8c>
  8033b3:	89 fd                	mov    %edi,%ebp
  8033b5:	85 ff                	test   %edi,%edi
  8033b7:	75 0b                	jne    8033c4 <__udivdi3+0x38>
  8033b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8033be:	31 d2                	xor    %edx,%edx
  8033c0:	f7 f7                	div    %edi
  8033c2:	89 c5                	mov    %eax,%ebp
  8033c4:	31 d2                	xor    %edx,%edx
  8033c6:	89 c8                	mov    %ecx,%eax
  8033c8:	f7 f5                	div    %ebp
  8033ca:	89 c1                	mov    %eax,%ecx
  8033cc:	89 d8                	mov    %ebx,%eax
  8033ce:	f7 f5                	div    %ebp
  8033d0:	89 cf                	mov    %ecx,%edi
  8033d2:	89 fa                	mov    %edi,%edx
  8033d4:	83 c4 1c             	add    $0x1c,%esp
  8033d7:	5b                   	pop    %ebx
  8033d8:	5e                   	pop    %esi
  8033d9:	5f                   	pop    %edi
  8033da:	5d                   	pop    %ebp
  8033db:	c3                   	ret    
  8033dc:	39 ce                	cmp    %ecx,%esi
  8033de:	77 28                	ja     803408 <__udivdi3+0x7c>
  8033e0:	0f bd fe             	bsr    %esi,%edi
  8033e3:	83 f7 1f             	xor    $0x1f,%edi
  8033e6:	75 40                	jne    803428 <__udivdi3+0x9c>
  8033e8:	39 ce                	cmp    %ecx,%esi
  8033ea:	72 0a                	jb     8033f6 <__udivdi3+0x6a>
  8033ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033f0:	0f 87 9e 00 00 00    	ja     803494 <__udivdi3+0x108>
  8033f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033fb:	89 fa                	mov    %edi,%edx
  8033fd:	83 c4 1c             	add    $0x1c,%esp
  803400:	5b                   	pop    %ebx
  803401:	5e                   	pop    %esi
  803402:	5f                   	pop    %edi
  803403:	5d                   	pop    %ebp
  803404:	c3                   	ret    
  803405:	8d 76 00             	lea    0x0(%esi),%esi
  803408:	31 ff                	xor    %edi,%edi
  80340a:	31 c0                	xor    %eax,%eax
  80340c:	89 fa                	mov    %edi,%edx
  80340e:	83 c4 1c             	add    $0x1c,%esp
  803411:	5b                   	pop    %ebx
  803412:	5e                   	pop    %esi
  803413:	5f                   	pop    %edi
  803414:	5d                   	pop    %ebp
  803415:	c3                   	ret    
  803416:	66 90                	xchg   %ax,%ax
  803418:	89 d8                	mov    %ebx,%eax
  80341a:	f7 f7                	div    %edi
  80341c:	31 ff                	xor    %edi,%edi
  80341e:	89 fa                	mov    %edi,%edx
  803420:	83 c4 1c             	add    $0x1c,%esp
  803423:	5b                   	pop    %ebx
  803424:	5e                   	pop    %esi
  803425:	5f                   	pop    %edi
  803426:	5d                   	pop    %ebp
  803427:	c3                   	ret    
  803428:	bd 20 00 00 00       	mov    $0x20,%ebp
  80342d:	89 eb                	mov    %ebp,%ebx
  80342f:	29 fb                	sub    %edi,%ebx
  803431:	89 f9                	mov    %edi,%ecx
  803433:	d3 e6                	shl    %cl,%esi
  803435:	89 c5                	mov    %eax,%ebp
  803437:	88 d9                	mov    %bl,%cl
  803439:	d3 ed                	shr    %cl,%ebp
  80343b:	89 e9                	mov    %ebp,%ecx
  80343d:	09 f1                	or     %esi,%ecx
  80343f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803443:	89 f9                	mov    %edi,%ecx
  803445:	d3 e0                	shl    %cl,%eax
  803447:	89 c5                	mov    %eax,%ebp
  803449:	89 d6                	mov    %edx,%esi
  80344b:	88 d9                	mov    %bl,%cl
  80344d:	d3 ee                	shr    %cl,%esi
  80344f:	89 f9                	mov    %edi,%ecx
  803451:	d3 e2                	shl    %cl,%edx
  803453:	8b 44 24 08          	mov    0x8(%esp),%eax
  803457:	88 d9                	mov    %bl,%cl
  803459:	d3 e8                	shr    %cl,%eax
  80345b:	09 c2                	or     %eax,%edx
  80345d:	89 d0                	mov    %edx,%eax
  80345f:	89 f2                	mov    %esi,%edx
  803461:	f7 74 24 0c          	divl   0xc(%esp)
  803465:	89 d6                	mov    %edx,%esi
  803467:	89 c3                	mov    %eax,%ebx
  803469:	f7 e5                	mul    %ebp
  80346b:	39 d6                	cmp    %edx,%esi
  80346d:	72 19                	jb     803488 <__udivdi3+0xfc>
  80346f:	74 0b                	je     80347c <__udivdi3+0xf0>
  803471:	89 d8                	mov    %ebx,%eax
  803473:	31 ff                	xor    %edi,%edi
  803475:	e9 58 ff ff ff       	jmp    8033d2 <__udivdi3+0x46>
  80347a:	66 90                	xchg   %ax,%ax
  80347c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803480:	89 f9                	mov    %edi,%ecx
  803482:	d3 e2                	shl    %cl,%edx
  803484:	39 c2                	cmp    %eax,%edx
  803486:	73 e9                	jae    803471 <__udivdi3+0xe5>
  803488:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80348b:	31 ff                	xor    %edi,%edi
  80348d:	e9 40 ff ff ff       	jmp    8033d2 <__udivdi3+0x46>
  803492:	66 90                	xchg   %ax,%ax
  803494:	31 c0                	xor    %eax,%eax
  803496:	e9 37 ff ff ff       	jmp    8033d2 <__udivdi3+0x46>
  80349b:	90                   	nop

0080349c <__umoddi3>:
  80349c:	55                   	push   %ebp
  80349d:	57                   	push   %edi
  80349e:	56                   	push   %esi
  80349f:	53                   	push   %ebx
  8034a0:	83 ec 1c             	sub    $0x1c,%esp
  8034a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034bb:	89 f3                	mov    %esi,%ebx
  8034bd:	89 fa                	mov    %edi,%edx
  8034bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c3:	89 34 24             	mov    %esi,(%esp)
  8034c6:	85 c0                	test   %eax,%eax
  8034c8:	75 1a                	jne    8034e4 <__umoddi3+0x48>
  8034ca:	39 f7                	cmp    %esi,%edi
  8034cc:	0f 86 a2 00 00 00    	jbe    803574 <__umoddi3+0xd8>
  8034d2:	89 c8                	mov    %ecx,%eax
  8034d4:	89 f2                	mov    %esi,%edx
  8034d6:	f7 f7                	div    %edi
  8034d8:	89 d0                	mov    %edx,%eax
  8034da:	31 d2                	xor    %edx,%edx
  8034dc:	83 c4 1c             	add    $0x1c,%esp
  8034df:	5b                   	pop    %ebx
  8034e0:	5e                   	pop    %esi
  8034e1:	5f                   	pop    %edi
  8034e2:	5d                   	pop    %ebp
  8034e3:	c3                   	ret    
  8034e4:	39 f0                	cmp    %esi,%eax
  8034e6:	0f 87 ac 00 00 00    	ja     803598 <__umoddi3+0xfc>
  8034ec:	0f bd e8             	bsr    %eax,%ebp
  8034ef:	83 f5 1f             	xor    $0x1f,%ebp
  8034f2:	0f 84 ac 00 00 00    	je     8035a4 <__umoddi3+0x108>
  8034f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8034fd:	29 ef                	sub    %ebp,%edi
  8034ff:	89 fe                	mov    %edi,%esi
  803501:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803505:	89 e9                	mov    %ebp,%ecx
  803507:	d3 e0                	shl    %cl,%eax
  803509:	89 d7                	mov    %edx,%edi
  80350b:	89 f1                	mov    %esi,%ecx
  80350d:	d3 ef                	shr    %cl,%edi
  80350f:	09 c7                	or     %eax,%edi
  803511:	89 e9                	mov    %ebp,%ecx
  803513:	d3 e2                	shl    %cl,%edx
  803515:	89 14 24             	mov    %edx,(%esp)
  803518:	89 d8                	mov    %ebx,%eax
  80351a:	d3 e0                	shl    %cl,%eax
  80351c:	89 c2                	mov    %eax,%edx
  80351e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803522:	d3 e0                	shl    %cl,%eax
  803524:	89 44 24 04          	mov    %eax,0x4(%esp)
  803528:	8b 44 24 08          	mov    0x8(%esp),%eax
  80352c:	89 f1                	mov    %esi,%ecx
  80352e:	d3 e8                	shr    %cl,%eax
  803530:	09 d0                	or     %edx,%eax
  803532:	d3 eb                	shr    %cl,%ebx
  803534:	89 da                	mov    %ebx,%edx
  803536:	f7 f7                	div    %edi
  803538:	89 d3                	mov    %edx,%ebx
  80353a:	f7 24 24             	mull   (%esp)
  80353d:	89 c6                	mov    %eax,%esi
  80353f:	89 d1                	mov    %edx,%ecx
  803541:	39 d3                	cmp    %edx,%ebx
  803543:	0f 82 87 00 00 00    	jb     8035d0 <__umoddi3+0x134>
  803549:	0f 84 91 00 00 00    	je     8035e0 <__umoddi3+0x144>
  80354f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803553:	29 f2                	sub    %esi,%edx
  803555:	19 cb                	sbb    %ecx,%ebx
  803557:	89 d8                	mov    %ebx,%eax
  803559:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80355d:	d3 e0                	shl    %cl,%eax
  80355f:	89 e9                	mov    %ebp,%ecx
  803561:	d3 ea                	shr    %cl,%edx
  803563:	09 d0                	or     %edx,%eax
  803565:	89 e9                	mov    %ebp,%ecx
  803567:	d3 eb                	shr    %cl,%ebx
  803569:	89 da                	mov    %ebx,%edx
  80356b:	83 c4 1c             	add    $0x1c,%esp
  80356e:	5b                   	pop    %ebx
  80356f:	5e                   	pop    %esi
  803570:	5f                   	pop    %edi
  803571:	5d                   	pop    %ebp
  803572:	c3                   	ret    
  803573:	90                   	nop
  803574:	89 fd                	mov    %edi,%ebp
  803576:	85 ff                	test   %edi,%edi
  803578:	75 0b                	jne    803585 <__umoddi3+0xe9>
  80357a:	b8 01 00 00 00       	mov    $0x1,%eax
  80357f:	31 d2                	xor    %edx,%edx
  803581:	f7 f7                	div    %edi
  803583:	89 c5                	mov    %eax,%ebp
  803585:	89 f0                	mov    %esi,%eax
  803587:	31 d2                	xor    %edx,%edx
  803589:	f7 f5                	div    %ebp
  80358b:	89 c8                	mov    %ecx,%eax
  80358d:	f7 f5                	div    %ebp
  80358f:	89 d0                	mov    %edx,%eax
  803591:	e9 44 ff ff ff       	jmp    8034da <__umoddi3+0x3e>
  803596:	66 90                	xchg   %ax,%ax
  803598:	89 c8                	mov    %ecx,%eax
  80359a:	89 f2                	mov    %esi,%edx
  80359c:	83 c4 1c             	add    $0x1c,%esp
  80359f:	5b                   	pop    %ebx
  8035a0:	5e                   	pop    %esi
  8035a1:	5f                   	pop    %edi
  8035a2:	5d                   	pop    %ebp
  8035a3:	c3                   	ret    
  8035a4:	3b 04 24             	cmp    (%esp),%eax
  8035a7:	72 06                	jb     8035af <__umoddi3+0x113>
  8035a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035ad:	77 0f                	ja     8035be <__umoddi3+0x122>
  8035af:	89 f2                	mov    %esi,%edx
  8035b1:	29 f9                	sub    %edi,%ecx
  8035b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035b7:	89 14 24             	mov    %edx,(%esp)
  8035ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035c2:	8b 14 24             	mov    (%esp),%edx
  8035c5:	83 c4 1c             	add    $0x1c,%esp
  8035c8:	5b                   	pop    %ebx
  8035c9:	5e                   	pop    %esi
  8035ca:	5f                   	pop    %edi
  8035cb:	5d                   	pop    %ebp
  8035cc:	c3                   	ret    
  8035cd:	8d 76 00             	lea    0x0(%esi),%esi
  8035d0:	2b 04 24             	sub    (%esp),%eax
  8035d3:	19 fa                	sbb    %edi,%edx
  8035d5:	89 d1                	mov    %edx,%ecx
  8035d7:	89 c6                	mov    %eax,%esi
  8035d9:	e9 71 ff ff ff       	jmp    80354f <__umoddi3+0xb3>
  8035de:	66 90                	xchg   %ax,%ax
  8035e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035e4:	72 ea                	jb     8035d0 <__umoddi3+0x134>
  8035e6:	89 d9                	mov    %ebx,%ecx
  8035e8:	e9 62 ff ff ff       	jmp    80354f <__umoddi3+0xb3>
