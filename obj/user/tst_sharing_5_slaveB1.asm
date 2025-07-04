
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 0c 01 00 00       	call   800142 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

extern volatile bool printStats;
void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	printStats = 0;
  80003e:	c7 05 00 40 80 00 00 	movl   $0x0,0x804000
  800045:	00 00 00 

	/*=================================================*/
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
#if USE_KHEAP
	{
		if (LIST_SIZE(&(myEnv->page_WS_list)) >= myEnv->page_WS_max_size)
  800048:	a1 20 40 80 00       	mov    0x804020,%eax
  80004d:	8b 90 a0 00 00 00    	mov    0xa0(%eax),%edx
  800053:	a1 20 40 80 00       	mov    0x804020,%eax
  800058:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  80005e:	39 c2                	cmp    %eax,%edx
  800060:	72 14                	jb     800076 <_main+0x3e>
			panic("Please increase the WS size");
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	68 00 36 80 00       	push   $0x803600
  80006a:	6a 0f                	push   $0xf
  80006c:	68 1c 36 80 00       	push   $0x80361c
  800071:	e8 11 02 00 00       	call   800287 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;

	x = sget(sys_getparentenvid(),"x");
  80007d:	e8 29 1c 00 00       	call   801cab <sys_getparentenvid>
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	68 39 36 80 00       	push   $0x803639
  80008a:	50                   	push   %eax
  80008b:	e8 b6 16 00 00       	call   801746 <sget>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 3c 36 80 00       	push   $0x80363c
  80009e:	e8 a1 04 00 00       	call   800544 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000a6:	e8 25 1d 00 00       	call   801dd0 <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 64 36 80 00       	push   $0x803664
  8000b3:	e8 8c 04 00 00       	call   800544 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z and be completed.
	env_sleep(6000);
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 70 17 00 00       	push   $0x1770
  8000c3:	e8 0d 32 00 00       	call   8032d5 <env_sleep>
  8000c8:	83 c4 10             	add    $0x10,%esp
	while (gettst()!=3) ;// panic("test failed");
  8000cb:	90                   	nop
  8000cc:	e8 19 1d 00 00       	call   801dea <gettst>
  8000d1:	83 f8 03             	cmp    $0x3,%eax
  8000d4:	75 f6                	jne    8000cc <_main+0x94>

	freeFrames = sys_calculate_free_frames() ;
  8000d6:	e8 ee 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)

	sfree(x);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8000e4:	e8 f4 17 00 00       	call   8018dd <sfree>
  8000e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000ec:	83 ec 0c             	sub    $0xc,%esp
  8000ef:	68 84 36 80 00       	push   $0x803684
  8000f4:	e8 4b 04 00 00       	call   800544 <cprintf>
  8000f9:	83 c4 10             	add    $0x10,%esp
	expected = 2+1; /*2pages+1table*/
  8000fc:	c7 45 e8 03 00 00 00 	movl   $0x3,-0x18(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal %d !, Expected:\nfrom the env: 1 table and 2 for frames of x\nframes_storage of x: should be cleared now\n", expected);
  800103:	e8 c1 19 00 00       	call   801ac9 <sys_calculate_free_frames>
  800108:	89 c2                	mov    %eax,%edx
  80010a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80010d:	29 c2                	sub    %eax,%edx
  80010f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800112:	39 c2                	cmp    %eax,%edx
  800114:	74 14                	je     80012a <_main+0xf2>
  800116:	ff 75 e8             	pushl  -0x18(%ebp)
  800119:	68 9c 36 80 00       	push   $0x80369c
  80011e:	6a 29                	push   $0x29
  800120:	68 1c 36 80 00       	push   $0x80361c
  800125:	e8 5d 01 00 00       	call   800287 <_panic>

	//To indicate that it's completed successfully
	cprintf("SlaveB1 is completed.\n");
  80012a:	83 ec 0c             	sub    $0xc,%esp
  80012d:	68 2c 37 80 00       	push   $0x80372c
  800132:	e8 0d 04 00 00       	call   800544 <cprintf>
  800137:	83 c4 10             	add    $0x10,%esp
	inctst();
  80013a:	e8 91 1c 00 00       	call   801dd0 <inctst>
	return;
  80013f:	90                   	nop
}
  800140:	c9                   	leave  
  800141:	c3                   	ret    

00800142 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800142:	55                   	push   %ebp
  800143:	89 e5                	mov    %esp,%ebp
  800145:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800148:	e8 45 1b 00 00       	call   801c92 <sys_getenvindex>
  80014d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800150:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800153:	89 d0                	mov    %edx,%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 03             	shl    $0x3,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 02             	shl    $0x2,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 40 20             	mov    0x20(%eax),%al
  80017d:	84 c0                	test   %al,%al
  80017f:	74 0d                	je     80018e <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800181:	a1 20 40 80 00       	mov    0x804020,%eax
  800186:	83 c0 20             	add    $0x20,%eax
  800189:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800192:	7e 0a                	jle    80019e <libmain+0x5c>
		binaryname = argv[0];
  800194:	8b 45 0c             	mov    0xc(%ebp),%eax
  800197:	8b 00                	mov    (%eax),%eax
  800199:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 0c             	pushl  0xc(%ebp)
  8001a4:	ff 75 08             	pushl  0x8(%ebp)
  8001a7:	e8 8c fe ff ff       	call   800038 <_main>
  8001ac:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001af:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b4:	85 c0                	test   %eax,%eax
  8001b6:	0f 84 9f 00 00 00    	je     80025b <libmain+0x119>
	{
		sys_lock_cons();
  8001bc:	e8 55 18 00 00       	call   801a16 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001c1:	83 ec 0c             	sub    $0xc,%esp
  8001c4:	68 5c 37 80 00       	push   $0x80375c
  8001c9:	e8 76 03 00 00       	call   800544 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	52                   	push   %edx
  8001eb:	50                   	push   %eax
  8001ec:	68 84 37 80 00       	push   $0x803784
  8001f1:	e8 4e 03 00 00       	call   800544 <cprintf>
  8001f6:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800204:	a1 20 40 80 00       	mov    0x804020,%eax
  800209:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80020f:	a1 20 40 80 00       	mov    0x804020,%eax
  800214:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80021a:	51                   	push   %ecx
  80021b:	52                   	push   %edx
  80021c:	50                   	push   %eax
  80021d:	68 ac 37 80 00       	push   $0x8037ac
  800222:	e8 1d 03 00 00       	call   800544 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80022a:	a1 20 40 80 00       	mov    0x804020,%eax
  80022f:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800235:	83 ec 08             	sub    $0x8,%esp
  800238:	50                   	push   %eax
  800239:	68 04 38 80 00       	push   $0x803804
  80023e:	e8 01 03 00 00       	call   800544 <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 5c 37 80 00       	push   $0x80375c
  80024e:	e8 f1 02 00 00       	call   800544 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800256:	e8 d5 17 00 00       	call   801a30 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80025b:	e8 19 00 00 00       	call   800279 <exit>
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	6a 00                	push   $0x0
  80026e:	e8 eb 19 00 00       	call   801c5e <sys_destroy_env>
  800273:	83 c4 10             	add    $0x10,%esp
}
  800276:	90                   	nop
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <exit>:

void
exit(void)
{
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027f:	e8 40 1a 00 00       	call   801cc4 <sys_exit_env>
}
  800284:	90                   	nop
  800285:	c9                   	leave  
  800286:	c3                   	ret    

00800287 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80028d:	8d 45 10             	lea    0x10(%ebp),%eax
  800290:	83 c0 04             	add    $0x4,%eax
  800293:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800296:	a1 60 40 98 00       	mov    0x984060,%eax
  80029b:	85 c0                	test   %eax,%eax
  80029d:	74 16                	je     8002b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029f:	a1 60 40 98 00       	mov    0x984060,%eax
  8002a4:	83 ec 08             	sub    $0x8,%esp
  8002a7:	50                   	push   %eax
  8002a8:	68 18 38 80 00       	push   $0x803818
  8002ad:	e8 92 02 00 00       	call   800544 <cprintf>
  8002b2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8002ba:	ff 75 0c             	pushl  0xc(%ebp)
  8002bd:	ff 75 08             	pushl  0x8(%ebp)
  8002c0:	50                   	push   %eax
  8002c1:	68 1d 38 80 00       	push   $0x80381d
  8002c6:	e8 79 02 00 00       	call   800544 <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d1:	83 ec 08             	sub    $0x8,%esp
  8002d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d7:	50                   	push   %eax
  8002d8:	e8 fc 01 00 00       	call   8004d9 <vcprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e0:	83 ec 08             	sub    $0x8,%esp
  8002e3:	6a 00                	push   $0x0
  8002e5:	68 39 38 80 00       	push   $0x803839
  8002ea:	e8 ea 01 00 00       	call   8004d9 <vcprintf>
  8002ef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002f2:	e8 82 ff ff ff       	call   800279 <exit>

	// should not return here
	while (1) ;
  8002f7:	eb fe                	jmp    8002f7 <_panic+0x70>

008002f9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800304:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80030a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030d:	39 c2                	cmp    %eax,%edx
  80030f:	74 14                	je     800325 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800311:	83 ec 04             	sub    $0x4,%esp
  800314:	68 3c 38 80 00       	push   $0x80383c
  800319:	6a 26                	push   $0x26
  80031b:	68 88 38 80 00       	push   $0x803888
  800320:	e8 62 ff ff ff       	call   800287 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800325:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80032c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800333:	e9 c5 00 00 00       	jmp    8003fd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800342:	8b 45 08             	mov    0x8(%ebp),%eax
  800345:	01 d0                	add    %edx,%eax
  800347:	8b 00                	mov    (%eax),%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	75 08                	jne    800355 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80034d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800350:	e9 a5 00 00 00       	jmp    8003fa <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800355:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80035c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800363:	eb 69                	jmp    8003ce <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800365:	a1 20 40 80 00       	mov    0x804020,%eax
  80036a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800370:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800373:	89 d0                	mov    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	c1 e0 03             	shl    $0x3,%eax
  80037c:	01 c8                	add    %ecx,%eax
  80037e:	8a 40 04             	mov    0x4(%eax),%al
  800381:	84 c0                	test   %al,%al
  800383:	75 46                	jne    8003cb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800385:	a1 20 40 80 00       	mov    0x804020,%eax
  80038a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800390:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800393:	89 d0                	mov    %edx,%eax
  800395:	01 c0                	add    %eax,%eax
  800397:	01 d0                	add    %edx,%eax
  800399:	c1 e0 03             	shl    $0x3,%eax
  80039c:	01 c8                	add    %ecx,%eax
  80039e:	8b 00                	mov    (%eax),%eax
  8003a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ab:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ba:	01 c8                	add    %ecx,%eax
  8003bc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003be:	39 c2                	cmp    %eax,%edx
  8003c0:	75 09                	jne    8003cb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003c2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c9:	eb 15                	jmp    8003e0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003cb:	ff 45 e8             	incl   -0x18(%ebp)
  8003ce:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003dc:	39 c2                	cmp    %eax,%edx
  8003de:	77 85                	ja     800365 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e4:	75 14                	jne    8003fa <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 94 38 80 00       	push   $0x803894
  8003ee:	6a 3a                	push   $0x3a
  8003f0:	68 88 38 80 00       	push   $0x803888
  8003f5:	e8 8d fe ff ff       	call   800287 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fa:	ff 45 f0             	incl   -0x10(%ebp)
  8003fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800400:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800403:	0f 8c 2f ff ff ff    	jl     800338 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800409:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800410:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800417:	eb 26                	jmp    80043f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800424:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800427:	89 d0                	mov    %edx,%eax
  800429:	01 c0                	add    %eax,%eax
  80042b:	01 d0                	add    %edx,%eax
  80042d:	c1 e0 03             	shl    $0x3,%eax
  800430:	01 c8                	add    %ecx,%eax
  800432:	8a 40 04             	mov    0x4(%eax),%al
  800435:	3c 01                	cmp    $0x1,%al
  800437:	75 03                	jne    80043c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800439:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	ff 45 e0             	incl   -0x20(%ebp)
  80043f:	a1 20 40 80 00       	mov    0x804020,%eax
  800444:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 c8                	ja     800419 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 e8 38 80 00       	push   $0x8038e8
  800461:	6a 44                	push   $0x44
  800463:	68 88 38 80 00       	push   $0x803888
  800468:	e8 1a fe ff ff       	call   800287 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 44 40 98 00       	mov    0x984044,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 19 15 00 00       	call   8019d4 <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 44 40 98 00       	mov    0x984044,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 a2 14 00 00       	call   8019d4 <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800577:	e8 9a 14 00 00       	call   801a16 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800597:	e8 94 14 00 00       	call   801a30 <sys_unlock_cons>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 a6 2d 00 00       	call   80338c <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 66 2e 00 00       	call   80349c <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 54 3b 80 00       	add    $0x803b54,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 c1 03 00 00    	je     800af1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 5b             	cmp    $0x5b,%eax
  800786:	0f 87 3d 03 00 00    	ja     800ac9 <vprintfmt+0x3ab>
  80078c:	8b 04 85 78 3b 80 00 	mov    0x803b78(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 9b 02 00 00       	jmp    800aec <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d c0 39 80 00 	mov    0x8039c0(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 65 3b 80 00       	push   $0x803b65
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 70 02 00 00       	call   800af9 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 5b 02 00 00       	jmp    800aec <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 6e 3b 80 00       	push   $0x803b6e
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 57 02 00 00       	call   800af9 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 42 02 00 00       	jmp    800aec <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be 71 3b 80 00       	mov    $0x803b71,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 1e 03 00 00       	call   800bfb <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 78 01 00 00       	jmp    800aec <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 ce 00 00 00       	jmp    800aec <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 46                	jmp    800aec <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 35                	jmp    800aec <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800ab7:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  800abe:	eb 2c                	jmp    800aec <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800ac0:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
			break;
  800ac7:	eb 23                	jmp    800aec <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ac9:	83 ec 08             	sub    $0x8,%esp
  800acc:	ff 75 0c             	pushl  0xc(%ebp)
  800acf:	6a 25                	push   $0x25
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	ff d0                	call   *%eax
  800ad6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad9:	ff 4d 10             	decl   0x10(%ebp)
  800adc:	eb 03                	jmp    800ae1 <vprintfmt+0x3c3>
  800ade:	ff 4d 10             	decl   0x10(%ebp)
  800ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae4:	48                   	dec    %eax
  800ae5:	8a 00                	mov    (%eax),%al
  800ae7:	3c 25                	cmp    $0x25,%al
  800ae9:	75 f3                	jne    800ade <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800aeb:	90                   	nop
		}
	}
  800aec:	e9 35 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800af1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800af2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800af5:	5b                   	pop    %ebx
  800af6:	5e                   	pop    %esi
  800af7:	5d                   	pop    %ebp
  800af8:	c3                   	ret    

00800af9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800af9:	55                   	push   %ebp
  800afa:	89 e5                	mov    %esp,%ebp
  800afc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aff:	8d 45 10             	lea    0x10(%ebp),%eax
  800b02:	83 c0 04             	add    $0x4,%eax
  800b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b08:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b0e:	50                   	push   %eax
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	ff 75 08             	pushl  0x8(%ebp)
  800b15:	e8 04 fc ff ff       	call   80071e <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8b 40 08             	mov    0x8(%eax),%eax
  800b29:	8d 50 01             	lea    0x1(%eax),%edx
  800b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	8b 10                	mov    (%eax),%edx
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 04             	mov    0x4(%eax),%eax
  800b3d:	39 c2                	cmp    %eax,%edx
  800b3f:	73 12                	jae    800b53 <sprintputch+0x33>
		*b->buf++ = ch;
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	8d 48 01             	lea    0x1(%eax),%ecx
  800b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4c:	89 0a                	mov    %ecx,(%edx)
  800b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b51:	88 10                	mov    %dl,(%eax)
}
  800b53:	90                   	nop
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b65:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b68:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6b:	01 d0                	add    %edx,%eax
  800b6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b7b:	74 06                	je     800b83 <vsnprintf+0x2d>
  800b7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b81:	7f 07                	jg     800b8a <vsnprintf+0x34>
		return -E_INVAL;
  800b83:	b8 03 00 00 00       	mov    $0x3,%eax
  800b88:	eb 20                	jmp    800baa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b8a:	ff 75 14             	pushl  0x14(%ebp)
  800b8d:	ff 75 10             	pushl  0x10(%ebp)
  800b90:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b93:	50                   	push   %eax
  800b94:	68 20 0b 80 00       	push   $0x800b20
  800b99:	e8 80 fb ff ff       	call   80071e <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ba4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800baa:	c9                   	leave  
  800bab:	c3                   	ret    

00800bac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bb2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bb5:	83 c0 04             	add    $0x4,%eax
  800bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbe:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc1:	50                   	push   %eax
  800bc2:	ff 75 0c             	pushl  0xc(%ebp)
  800bc5:	ff 75 08             	pushl  0x8(%ebp)
  800bc8:	e8 89 ff ff ff       	call   800b56 <vsnprintf>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 06                	jmp    800bed <strlen+0x15>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	84 c0                	test   %al,%al
  800bf4:	75 f1                	jne    800be7 <strlen+0xf>
		n++;
	return n;
  800bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c08:	eb 09                	jmp    800c13 <strnlen+0x18>
		n++;
  800c0a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0d:	ff 45 08             	incl   0x8(%ebp)
  800c10:	ff 4d 0c             	decl   0xc(%ebp)
  800c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c17:	74 09                	je     800c22 <strnlen+0x27>
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 e8                	jne    800c0a <strnlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c33:	90                   	nop
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c43:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c46:	8a 12                	mov    (%edx),%dl
  800c48:	88 10                	mov    %dl,(%eax)
  800c4a:	8a 00                	mov    (%eax),%al
  800c4c:	84 c0                	test   %al,%al
  800c4e:	75 e4                	jne    800c34 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c53:	c9                   	leave  
  800c54:	c3                   	ret    

00800c55 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c61:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c68:	eb 1f                	jmp    800c89 <strncpy+0x34>
		*dst++ = *src;
  800c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6d:	8d 50 01             	lea    0x1(%eax),%edx
  800c70:	89 55 08             	mov    %edx,0x8(%ebp)
  800c73:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c76:	8a 12                	mov    (%edx),%dl
  800c78:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	84 c0                	test   %al,%al
  800c81:	74 03                	je     800c86 <strncpy+0x31>
			src++;
  800c83:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c86:	ff 45 fc             	incl   -0x4(%ebp)
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c8c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c8f:	72 d9                	jb     800c6a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c91:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ca2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca6:	74 30                	je     800cd8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ca8:	eb 16                	jmp    800cc0 <strlcpy+0x2a>
			*dst++ = *src++;
  800caa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cad:	8d 50 01             	lea    0x1(%eax),%edx
  800cb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cbc:	8a 12                	mov    (%edx),%dl
  800cbe:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc7:	74 09                	je     800cd2 <strlcpy+0x3c>
  800cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 d8                	jne    800caa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cde:	29 c2                	sub    %eax,%edx
  800ce0:	89 d0                	mov    %edx,%eax
}
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ce7:	eb 06                	jmp    800cef <strcmp+0xb>
		p++, q++;
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cef:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf2:	8a 00                	mov    (%eax),%al
  800cf4:	84 c0                	test   %al,%al
  800cf6:	74 0e                	je     800d06 <strcmp+0x22>
  800cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfb:	8a 10                	mov    (%eax),%dl
  800cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	38 c2                	cmp    %al,%dl
  800d04:	74 e3                	je     800ce9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	8a 00                	mov    (%eax),%al
  800d0b:	0f b6 d0             	movzbl %al,%edx
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 c0             	movzbl %al,%eax
  800d16:	29 c2                	sub    %eax,%edx
  800d18:	89 d0                	mov    %edx,%eax
}
  800d1a:	5d                   	pop    %ebp
  800d1b:	c3                   	ret    

00800d1c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d1f:	eb 09                	jmp    800d2a <strncmp+0xe>
		n--, p++, q++;
  800d21:	ff 4d 10             	decl   0x10(%ebp)
  800d24:	ff 45 08             	incl   0x8(%ebp)
  800d27:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2e:	74 17                	je     800d47 <strncmp+0x2b>
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	84 c0                	test   %al,%al
  800d37:	74 0e                	je     800d47 <strncmp+0x2b>
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 10                	mov    (%eax),%dl
  800d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d41:	8a 00                	mov    (%eax),%al
  800d43:	38 c2                	cmp    %al,%dl
  800d45:	74 da                	je     800d21 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	75 07                	jne    800d54 <strncmp+0x38>
		return 0;
  800d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d52:	eb 14                	jmp    800d68 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	0f b6 d0             	movzbl %al,%edx
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f b6 c0             	movzbl %al,%eax
  800d64:	29 c2                	sub    %eax,%edx
  800d66:	89 d0                	mov    %edx,%eax
}
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 04             	sub    $0x4,%esp
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d76:	eb 12                	jmp    800d8a <strchr+0x20>
		if (*s == c)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d80:	75 05                	jne    800d87 <strchr+0x1d>
			return (char *) s;
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	eb 11                	jmp    800d98 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 e5                	jne    800d78 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d98:	c9                   	leave  
  800d99:	c3                   	ret    

00800d9a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da6:	eb 0d                	jmp    800db5 <strfind+0x1b>
		if (*s == c)
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800db0:	74 0e                	je     800dc0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800db2:	ff 45 08             	incl   0x8(%ebp)
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	84 c0                	test   %al,%al
  800dbc:	75 ea                	jne    800da8 <strfind+0xe>
  800dbe:	eb 01                	jmp    800dc1 <strfind+0x27>
		if (*s == c)
			break;
  800dc0:	90                   	nop
	return (char *) s;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dd8:	eb 0e                	jmp    800de8 <memset+0x22>
		*p++ = c;
  800dda:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800de8:	ff 4d f8             	decl   -0x8(%ebp)
  800deb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800def:	79 e9                	jns    800dda <memset+0x14>
		*p++ = c;

	return v;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
  800e05:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e08:	eb 16                	jmp    800e20 <memcpy+0x2a>
		*d++ = *s++;
  800e0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0d:	8d 50 01             	lea    0x1(%eax),%edx
  800e10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e1c:	8a 12                	mov    (%edx),%dl
  800e1e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e20:	8b 45 10             	mov    0x10(%ebp),%eax
  800e23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e26:	89 55 10             	mov    %edx,0x10(%ebp)
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	75 dd                	jne    800e0a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e47:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e4a:	73 50                	jae    800e9c <memmove+0x6a>
  800e4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	01 d0                	add    %edx,%eax
  800e54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e57:	76 43                	jbe    800e9c <memmove+0x6a>
		s += n;
  800e59:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e65:	eb 10                	jmp    800e77 <memmove+0x45>
			*--d = *--s;
  800e67:	ff 4d f8             	decl   -0x8(%ebp)
  800e6a:	ff 4d fc             	decl   -0x4(%ebp)
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8a 10                	mov    (%eax),%dl
  800e72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e75:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e77:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e80:	85 c0                	test   %eax,%eax
  800e82:	75 e3                	jne    800e67 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e84:	eb 23                	jmp    800ea9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	8d 50 01             	lea    0x1(%eax),%edx
  800e8c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e8f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e95:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e98:	8a 12                	mov    (%edx),%dl
  800e9a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	75 dd                	jne    800e86 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eac:	c9                   	leave  
  800ead:	c3                   	ret    

00800eae <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ec0:	eb 2a                	jmp    800eec <memcmp+0x3e>
		if (*s1 != *s2)
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	8a 10                	mov    (%eax),%dl
  800ec7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eca:	8a 00                	mov    (%eax),%al
  800ecc:	38 c2                	cmp    %al,%dl
  800ece:	74 16                	je     800ee6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed3:	8a 00                	mov    (%eax),%al
  800ed5:	0f b6 d0             	movzbl %al,%edx
  800ed8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800edb:	8a 00                	mov    (%eax),%al
  800edd:	0f b6 c0             	movzbl %al,%eax
  800ee0:	29 c2                	sub    %eax,%edx
  800ee2:	89 d0                	mov    %edx,%eax
  800ee4:	eb 18                	jmp    800efe <memcmp+0x50>
		s1++, s2++;
  800ee6:	ff 45 fc             	incl   -0x4(%ebp)
  800ee9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 c9                	jne    800ec2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ef9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efe:	c9                   	leave  
  800eff:	c3                   	ret    

00800f00 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	01 d0                	add    %edx,%eax
  800f0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f11:	eb 15                	jmp    800f28 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 d0             	movzbl %al,%edx
  800f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1e:	0f b6 c0             	movzbl %al,%eax
  800f21:	39 c2                	cmp    %eax,%edx
  800f23:	74 0d                	je     800f32 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f2e:	72 e3                	jb     800f13 <memfind+0x13>
  800f30:	eb 01                	jmp    800f33 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f32:	90                   	nop
	return (void *) s;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f36:	c9                   	leave  
  800f37:	c3                   	ret    

00800f38 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f45:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f4c:	eb 03                	jmp    800f51 <strtol+0x19>
		s++;
  800f4e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 20                	cmp    $0x20,%al
  800f58:	74 f4                	je     800f4e <strtol+0x16>
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	3c 09                	cmp    $0x9,%al
  800f61:	74 eb                	je     800f4e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	3c 2b                	cmp    $0x2b,%al
  800f6a:	75 05                	jne    800f71 <strtol+0x39>
		s++;
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	eb 13                	jmp    800f84 <strtol+0x4c>
	else if (*s == '-')
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	3c 2d                	cmp    $0x2d,%al
  800f78:	75 0a                	jne    800f84 <strtol+0x4c>
		s++, neg = 1;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
  800f7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	74 06                	je     800f90 <strtol+0x58>
  800f8a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f8e:	75 20                	jne    800fb0 <strtol+0x78>
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 30                	cmp    $0x30,%al
  800f97:	75 17                	jne    800fb0 <strtol+0x78>
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	40                   	inc    %eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 78                	cmp    $0x78,%al
  800fa1:	75 0d                	jne    800fb0 <strtol+0x78>
		s += 2, base = 16;
  800fa3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fa7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fae:	eb 28                	jmp    800fd8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	75 15                	jne    800fcb <strtol+0x93>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 30                	cmp    $0x30,%al
  800fbd:	75 0c                	jne    800fcb <strtol+0x93>
		s++, base = 8;
  800fbf:	ff 45 08             	incl   0x8(%ebp)
  800fc2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fc9:	eb 0d                	jmp    800fd8 <strtol+0xa0>
	else if (base == 0)
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 07                	jne    800fd8 <strtol+0xa0>
		base = 10;
  800fd1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 2f                	cmp    $0x2f,%al
  800fdf:	7e 19                	jle    800ffa <strtol+0xc2>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 39                	cmp    $0x39,%al
  800fe8:	7f 10                	jg     800ffa <strtol+0xc2>
			dig = *s - '0';
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	8a 00                	mov    (%eax),%al
  800fef:	0f be c0             	movsbl %al,%eax
  800ff2:	83 e8 30             	sub    $0x30,%eax
  800ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff8:	eb 42                	jmp    80103c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 60                	cmp    $0x60,%al
  801001:	7e 19                	jle    80101c <strtol+0xe4>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 7a                	cmp    $0x7a,%al
  80100a:	7f 10                	jg     80101c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	8a 00                	mov    (%eax),%al
  801011:	0f be c0             	movsbl %al,%eax
  801014:	83 e8 57             	sub    $0x57,%eax
  801017:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80101a:	eb 20                	jmp    80103c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	3c 40                	cmp    $0x40,%al
  801023:	7e 39                	jle    80105e <strtol+0x126>
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	8a 00                	mov    (%eax),%al
  80102a:	3c 5a                	cmp    $0x5a,%al
  80102c:	7f 30                	jg     80105e <strtol+0x126>
			dig = *s - 'A' + 10;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
  801031:	8a 00                	mov    (%eax),%al
  801033:	0f be c0             	movsbl %al,%eax
  801036:	83 e8 37             	sub    $0x37,%eax
  801039:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80103c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80103f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801042:	7d 19                	jge    80105d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801044:	ff 45 08             	incl   0x8(%ebp)
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80104e:	89 c2                	mov    %eax,%edx
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	01 d0                	add    %edx,%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801058:	e9 7b ff ff ff       	jmp    800fd8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80105d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80105e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801062:	74 08                	je     80106c <strtol+0x134>
		*endptr = (char *) s;
  801064:	8b 45 0c             	mov    0xc(%ebp),%eax
  801067:	8b 55 08             	mov    0x8(%ebp),%edx
  80106a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80106c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801070:	74 07                	je     801079 <strtol+0x141>
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	f7 d8                	neg    %eax
  801077:	eb 03                	jmp    80107c <strtol+0x144>
  801079:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80107c:	c9                   	leave  
  80107d:	c3                   	ret    

0080107e <ltostr>:

void
ltostr(long value, char *str)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801084:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80108b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801092:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801096:	79 13                	jns    8010ab <ltostr+0x2d>
	{
		neg = 1;
  801098:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80109f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010a5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010a8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010b3:	99                   	cltd   
  8010b4:	f7 f9                	idiv   %ecx
  8010b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	8d 50 01             	lea    0x1(%eax),%edx
  8010bf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c2:	89 c2                	mov    %eax,%edx
  8010c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c7:	01 d0                	add    %edx,%eax
  8010c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010cc:	83 c2 30             	add    $0x30,%edx
  8010cf:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d9:	f7 e9                	imul   %ecx
  8010db:	c1 fa 02             	sar    $0x2,%edx
  8010de:	89 c8                	mov    %ecx,%eax
  8010e0:	c1 f8 1f             	sar    $0x1f,%eax
  8010e3:	29 c2                	sub    %eax,%edx
  8010e5:	89 d0                	mov    %edx,%eax
  8010e7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ee:	75 bb                	jne    8010ab <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fa:	48                   	dec    %eax
  8010fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801102:	74 3d                	je     801141 <ltostr+0xc3>
		start = 1 ;
  801104:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110b:	eb 34                	jmp    801141 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  80110d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801110:	8b 45 0c             	mov    0xc(%ebp),%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 c2                	add    %eax,%edx
  801122:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c8                	add    %ecx,%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	01 c2                	add    %eax,%edx
  801136:	8a 45 eb             	mov    -0x15(%ebp),%al
  801139:	88 02                	mov    %al,(%edx)
		start++ ;
  80113b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801144:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801147:	7c c4                	jl     80110d <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801149:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 d0                	add    %edx,%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801154:	90                   	nop
  801155:	c9                   	leave  
  801156:	c3                   	ret    

00801157 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115d:	ff 75 08             	pushl  0x8(%ebp)
  801160:	e8 73 fa ff ff       	call   800bd8 <strlen>
  801165:	83 c4 04             	add    $0x4,%esp
  801168:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116b:	ff 75 0c             	pushl  0xc(%ebp)
  80116e:	e8 65 fa ff ff       	call   800bd8 <strlen>
  801173:	83 c4 04             	add    $0x4,%esp
  801176:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801180:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801187:	eb 17                	jmp    8011a0 <strcconcat+0x49>
		final[s] = str1[s] ;
  801189:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118c:	8b 45 10             	mov    0x10(%ebp),%eax
  80118f:	01 c2                	add    %eax,%edx
  801191:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801194:	8b 45 08             	mov    0x8(%ebp),%eax
  801197:	01 c8                	add    %ecx,%eax
  801199:	8a 00                	mov    (%eax),%al
  80119b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119d:	ff 45 fc             	incl   -0x4(%ebp)
  8011a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a6:	7c e1                	jl     801189 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b6:	eb 1f                	jmp    8011d7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011bb:	8d 50 01             	lea    0x1(%eax),%edx
  8011be:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c1:	89 c2                	mov    %eax,%edx
  8011c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	01 c8                	add    %ecx,%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d4:	ff 45 f8             	incl   -0x8(%ebp)
  8011d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011da:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dd:	7c d9                	jl     8011b8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e5:	01 d0                	add    %edx,%eax
  8011e7:	c6 00 00             	movb   $0x0,(%eax)
}
  8011ea:	90                   	nop
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fc:	8b 00                	mov    (%eax),%eax
  8011fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801205:	8b 45 10             	mov    0x10(%ebp),%eax
  801208:	01 d0                	add    %edx,%eax
  80120a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801210:	eb 0c                	jmp    80121e <strsplit+0x31>
			*string++ = 0;
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8d 50 01             	lea    0x1(%eax),%edx
  801218:	89 55 08             	mov    %edx,0x8(%ebp)
  80121b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	84 c0                	test   %al,%al
  801225:	74 18                	je     80123f <strsplit+0x52>
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	0f be c0             	movsbl %al,%eax
  80122f:	50                   	push   %eax
  801230:	ff 75 0c             	pushl  0xc(%ebp)
  801233:	e8 32 fb ff ff       	call   800d6a <strchr>
  801238:	83 c4 08             	add    $0x8,%esp
  80123b:	85 c0                	test   %eax,%eax
  80123d:	75 d3                	jne    801212 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	84 c0                	test   %al,%al
  801246:	74 5a                	je     8012a2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	8b 00                	mov    (%eax),%eax
  80124d:	83 f8 0f             	cmp    $0xf,%eax
  801250:	75 07                	jne    801259 <strsplit+0x6c>
		{
			return 0;
  801252:	b8 00 00 00 00       	mov    $0x0,%eax
  801257:	eb 66                	jmp    8012bf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801259:	8b 45 14             	mov    0x14(%ebp),%eax
  80125c:	8b 00                	mov    (%eax),%eax
  80125e:	8d 48 01             	lea    0x1(%eax),%ecx
  801261:	8b 55 14             	mov    0x14(%ebp),%edx
  801264:	89 0a                	mov    %ecx,(%edx)
  801266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126d:	8b 45 10             	mov    0x10(%ebp),%eax
  801270:	01 c2                	add    %eax,%edx
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801277:	eb 03                	jmp    80127c <strsplit+0x8f>
			string++;
  801279:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8a 00                	mov    (%eax),%al
  801281:	84 c0                	test   %al,%al
  801283:	74 8b                	je     801210 <strsplit+0x23>
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8a 00                	mov    (%eax),%al
  80128a:	0f be c0             	movsbl %al,%eax
  80128d:	50                   	push   %eax
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	e8 d4 fa ff ff       	call   800d6a <strchr>
  801296:	83 c4 08             	add    $0x8,%esp
  801299:	85 c0                	test   %eax,%eax
  80129b:	74 dc                	je     801279 <strsplit+0x8c>
			string++;
	}
  80129d:	e9 6e ff ff ff       	jmp    801210 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a6:	8b 00                	mov    (%eax),%eax
  8012a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012af:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b2:	01 d0                	add    %edx,%eax
  8012b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ba:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bf:	c9                   	leave  
  8012c0:	c3                   	ret    

008012c1 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012c7:	83 ec 04             	sub    $0x4,%esp
  8012ca:	68 e8 3c 80 00       	push   $0x803ce8
  8012cf:	68 3f 01 00 00       	push   $0x13f
  8012d4:	68 0a 3d 80 00       	push   $0x803d0a
  8012d9:	e8 a9 ef ff ff       	call   800287 <_panic>

008012de <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012e4:	83 ec 0c             	sub    $0xc,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	e8 90 0c 00 00       	call   801f7f <sys_sbrk>
  8012ef:	83 c4 10             	add    $0x10,%esp
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8012fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012fe:	75 0a                	jne    80130a <malloc+0x16>
		return NULL;
  801300:	b8 00 00 00 00       	mov    $0x0,%eax
  801305:	e9 9e 01 00 00       	jmp    8014a8 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80130a:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801311:	77 2c                	ja     80133f <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801313:	e8 eb 0a 00 00       	call   801e03 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801318:	85 c0                	test   %eax,%eax
  80131a:	74 19                	je     801335 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80131c:	83 ec 0c             	sub    $0xc,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	e8 85 11 00 00       	call   8024ac <alloc_block_FF>
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80132d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801330:	e9 73 01 00 00       	jmp    8014a8 <malloc+0x1b4>
		} else {
			return NULL;
  801335:	b8 00 00 00 00       	mov    $0x0,%eax
  80133a:	e9 69 01 00 00       	jmp    8014a8 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80133f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80134c:	01 d0                	add    %edx,%eax
  80134e:	48                   	dec    %eax
  80134f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801352:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801355:	ba 00 00 00 00       	mov    $0x0,%edx
  80135a:	f7 75 e0             	divl   -0x20(%ebp)
  80135d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801360:	29 d0                	sub    %edx,%eax
  801362:	c1 e8 0c             	shr    $0xc,%eax
  801365:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80136f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801376:	a1 20 40 80 00       	mov    0x804020,%eax
  80137b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80137e:	05 00 10 00 00       	add    $0x1000,%eax
  801383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801386:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80138b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80138e:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801391:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801398:	8b 55 08             	mov    0x8(%ebp),%edx
  80139b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	48                   	dec    %eax
  8013a1:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8013a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ac:	f7 75 cc             	divl   -0x34(%ebp)
  8013af:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8013b2:	29 d0                	sub    %edx,%eax
  8013b4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8013b7:	76 0a                	jbe    8013c3 <malloc+0xcf>
		return NULL;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8013be:	e9 e5 00 00 00       	jmp    8014a8 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8013c3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013c9:	eb 48                	jmp    801413 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  8013cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ce:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8013d1:	c1 e8 0c             	shr    $0xc,%eax
  8013d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8013d7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8013da:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	75 11                	jne    8013f6 <malloc+0x102>
			freePagesCount++;
  8013e5:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8013e8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8013ec:	75 16                	jne    801404 <malloc+0x110>
				start = i;
  8013ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013f4:	eb 0e                	jmp    801404 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8013f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8013fd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80140a:	74 12                	je     80141e <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80140c:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801413:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80141a:	76 af                	jbe    8013cb <malloc+0xd7>
  80141c:	eb 01                	jmp    80141f <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  80141e:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  80141f:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801423:	74 08                	je     80142d <malloc+0x139>
  801425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801428:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80142b:	74 07                	je     801434 <malloc+0x140>
		return NULL;
  80142d:	b8 00 00 00 00       	mov    $0x0,%eax
  801432:	eb 74                	jmp    8014a8 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801437:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80143a:	c1 e8 0c             	shr    $0xc,%eax
  80143d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801440:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801443:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801446:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80144d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801450:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801453:	eb 11                	jmp    801466 <malloc+0x172>
		markedPages[i] = 1;
  801455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801458:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  80145f:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801463:	ff 45 e8             	incl   -0x18(%ebp)
  801466:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801469:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146c:	01 d0                	add    %edx,%eax
  80146e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801471:	77 e2                	ja     801455 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801473:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80147a:	8b 55 08             	mov    0x8(%ebp),%edx
  80147d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	48                   	dec    %eax
  801483:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801486:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801489:	ba 00 00 00 00       	mov    $0x0,%edx
  80148e:	f7 75 bc             	divl   -0x44(%ebp)
  801491:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801494:	29 d0                	sub    %edx,%eax
  801496:	83 ec 08             	sub    $0x8,%esp
  801499:	50                   	push   %eax
  80149a:	ff 75 f0             	pushl  -0x10(%ebp)
  80149d:	e8 14 0b 00 00       	call   801fb6 <sys_allocate_user_mem>
  8014a2:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  8014b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014b4:	0f 84 ee 00 00 00    	je     8015a8 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8014ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8014bf:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  8014c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014c5:	77 09                	ja     8014d0 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  8014c7:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8014ce:	76 14                	jbe    8014e4 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8014d0:	83 ec 04             	sub    $0x4,%esp
  8014d3:	68 18 3d 80 00       	push   $0x803d18
  8014d8:	6a 68                	push   $0x68
  8014da:	68 32 3d 80 00       	push   $0x803d32
  8014df:	e8 a3 ed ff ff       	call   800287 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8014e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8014e9:	8b 40 74             	mov    0x74(%eax),%eax
  8014ec:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014ef:	77 20                	ja     801511 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8014f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8014f6:	8b 40 78             	mov    0x78(%eax),%eax
  8014f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014fc:	76 13                	jbe    801511 <free+0x67>
		free_block(virtual_address);
  8014fe:	83 ec 0c             	sub    $0xc,%esp
  801501:	ff 75 08             	pushl  0x8(%ebp)
  801504:	e8 6c 16 00 00       	call   802b75 <free_block>
  801509:	83 c4 10             	add    $0x10,%esp
		return;
  80150c:	e9 98 00 00 00       	jmp    8015a9 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801511:	8b 55 08             	mov    0x8(%ebp),%edx
  801514:	a1 20 40 80 00       	mov    0x804020,%eax
  801519:	8b 40 7c             	mov    0x7c(%eax),%eax
  80151c:	29 c2                	sub    %eax,%edx
  80151e:	89 d0                	mov    %edx,%eax
  801520:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801525:	c1 e8 0c             	shr    $0xc,%eax
  801528:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80152b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801532:	eb 16                	jmp    80154a <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801534:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80153a:	01 d0                	add    %edx,%eax
  80153c:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801543:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801547:	ff 45 f4             	incl   -0xc(%ebp)
  80154a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154d:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801554:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801557:	7f db                	jg     801534 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801559:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155c:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801563:	c1 e0 0c             	shl    $0xc,%eax
  801566:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80156f:	eb 1a                	jmp    80158b <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801571:	83 ec 08             	sub    $0x8,%esp
  801574:	68 00 10 00 00       	push   $0x1000
  801579:	ff 75 f0             	pushl  -0x10(%ebp)
  80157c:	e8 19 0a 00 00       	call   801f9a <sys_free_user_mem>
  801581:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801584:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80158b:	8b 55 08             	mov    0x8(%ebp),%edx
  80158e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801591:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801593:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801596:	77 d9                	ja     801571 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801598:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80159b:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  8015a2:	00 00 00 00 
  8015a6:	eb 01                	jmp    8015a9 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8015a8:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8015a9:	c9                   	leave  
  8015aa:	c3                   	ret    

008015ab <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	83 ec 58             	sub    $0x58,%esp
  8015b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b4:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8015b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bb:	75 0a                	jne    8015c7 <smalloc+0x1c>
		return NULL;
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c2:	e9 7d 01 00 00       	jmp    801744 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8015c7:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8015ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d4:	01 d0                	add    %edx,%eax
  8015d6:	48                   	dec    %eax
  8015d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e2:	f7 75 e4             	divl   -0x1c(%ebp)
  8015e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e8:	29 d0                	sub    %edx,%eax
  8015ea:	c1 e8 0c             	shr    $0xc,%eax
  8015ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8015f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8015f7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8015fe:	a1 20 40 80 00       	mov    0x804020,%eax
  801603:	8b 40 7c             	mov    0x7c(%eax),%eax
  801606:	05 00 10 00 00       	add    $0x1000,%eax
  80160b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  80160e:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801613:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801616:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801619:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801626:	01 d0                	add    %edx,%eax
  801628:	48                   	dec    %eax
  801629:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80162c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80162f:	ba 00 00 00 00       	mov    $0x0,%edx
  801634:	f7 75 d0             	divl   -0x30(%ebp)
  801637:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80163a:	29 d0                	sub    %edx,%eax
  80163c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80163f:	76 0a                	jbe    80164b <smalloc+0xa0>
		return NULL;
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
  801646:	e9 f9 00 00 00       	jmp    801744 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80164b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801651:	eb 48                	jmp    80169b <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801656:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801659:	c1 e8 0c             	shr    $0xc,%eax
  80165c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80165f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801662:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801669:	85 c0                	test   %eax,%eax
  80166b:	75 11                	jne    80167e <smalloc+0xd3>
			freePagesCount++;
  80166d:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801670:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801674:	75 16                	jne    80168c <smalloc+0xe1>
				start = s;
  801676:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801679:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80167c:	eb 0e                	jmp    80168c <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80167e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801685:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80168c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801692:	74 12                	je     8016a6 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801694:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80169b:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8016a2:	76 af                	jbe    801653 <smalloc+0xa8>
  8016a4:	eb 01                	jmp    8016a7 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8016a6:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8016a7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8016ab:	74 08                	je     8016b5 <smalloc+0x10a>
  8016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8016b3:	74 0a                	je     8016bf <smalloc+0x114>
		return NULL;
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	e9 85 00 00 00       	jmp    801744 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  8016bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c2:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8016c5:	c1 e8 0c             	shr    $0xc,%eax
  8016c8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8016cb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8016ce:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016d1:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016de:	eb 11                	jmp    8016f1 <smalloc+0x146>
		markedPages[s] = 1;
  8016e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e3:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8016ea:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016ee:	ff 45 e8             	incl   -0x18(%ebp)
  8016f1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8016f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016f7:	01 d0                	add    %edx,%eax
  8016f9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016fc:	77 e2                	ja     8016e0 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8016fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801701:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801705:	52                   	push   %edx
  801706:	50                   	push   %eax
  801707:	ff 75 0c             	pushl  0xc(%ebp)
  80170a:	ff 75 08             	pushl  0x8(%ebp)
  80170d:	e8 8f 04 00 00       	call   801ba1 <sys_createSharedObject>
  801712:	83 c4 10             	add    $0x10,%esp
  801715:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801718:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80171c:	78 12                	js     801730 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  80171e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801721:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801724:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  80172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172e:	eb 14                	jmp    801744 <smalloc+0x199>
	}
	free((void*) start);
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	50                   	push   %eax
  801737:	e8 6e fd ff ff       	call   8014aa <free>
  80173c:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80173f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801744:	c9                   	leave  
  801745:	c3                   	ret    

00801746 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801746:	55                   	push   %ebp
  801747:	89 e5                	mov    %esp,%ebp
  801749:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	ff 75 0c             	pushl  0xc(%ebp)
  801752:	ff 75 08             	pushl  0x8(%ebp)
  801755:	e8 71 04 00 00       	call   801bcb <sys_getSizeOfSharedObject>
  80175a:	83 c4 10             	add    $0x10,%esp
  80175d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801760:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801767:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80176a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	48                   	dec    %eax
  801770:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801773:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801776:	ba 00 00 00 00       	mov    $0x0,%edx
  80177b:	f7 75 e0             	divl   -0x20(%ebp)
  80177e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801781:	29 d0                	sub    %edx,%eax
  801783:	c1 e8 0c             	shr    $0xc,%eax
  801786:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801789:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801790:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801797:	a1 20 40 80 00       	mov    0x804020,%eax
  80179c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80179f:	05 00 10 00 00       	add    $0x1000,%eax
  8017a4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8017a7:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8017ac:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017af:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  8017b2:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8017b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	48                   	dec    %eax
  8017c2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8017c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cd:	f7 75 cc             	divl   -0x34(%ebp)
  8017d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017d3:	29 d0                	sub    %edx,%eax
  8017d5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017d8:	76 0a                	jbe    8017e4 <sget+0x9e>
		return NULL;
  8017da:	b8 00 00 00 00       	mov    $0x0,%eax
  8017df:	e9 f7 00 00 00       	jmp    8018db <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017ea:	eb 48                	jmp    801834 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8017ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ef:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017f2:	c1 e8 0c             	shr    $0xc,%eax
  8017f5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8017f8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017fb:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801802:	85 c0                	test   %eax,%eax
  801804:	75 11                	jne    801817 <sget+0xd1>
			free_Pages_Count++;
  801806:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801809:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80180d:	75 16                	jne    801825 <sget+0xdf>
				start = s;
  80180f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801812:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801815:	eb 0e                	jmp    801825 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801817:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80181e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801828:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80182b:	74 12                	je     80183f <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80182d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801834:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80183b:	76 af                	jbe    8017ec <sget+0xa6>
  80183d:	eb 01                	jmp    801840 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80183f:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801840:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801844:	74 08                	je     80184e <sget+0x108>
  801846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801849:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80184c:	74 0a                	je     801858 <sget+0x112>
		return NULL;
  80184e:	b8 00 00 00 00       	mov    $0x0,%eax
  801853:	e9 83 00 00 00       	jmp    8018db <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80185e:	c1 e8 0c             	shr    $0xc,%eax
  801861:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801864:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801867:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80186a:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801871:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801874:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801877:	eb 11                	jmp    80188a <sget+0x144>
		markedPages[k] = 1;
  801879:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187c:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801883:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801887:	ff 45 e8             	incl   -0x18(%ebp)
  80188a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80188d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801895:	77 e2                	ja     801879 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189a:	83 ec 04             	sub    $0x4,%esp
  80189d:	50                   	push   %eax
  80189e:	ff 75 0c             	pushl  0xc(%ebp)
  8018a1:	ff 75 08             	pushl  0x8(%ebp)
  8018a4:	e8 3f 03 00 00       	call   801be8 <sys_getSharedObject>
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8018af:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8018b3:	78 12                	js     8018c7 <sget+0x181>
		shardIDs[startPage] = ss;
  8018b5:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8018b8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8018bb:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  8018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c5:	eb 14                	jmp    8018db <sget+0x195>
	}
	free((void*) start);
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ca:	83 ec 0c             	sub    $0xc,%esp
  8018cd:	50                   	push   %eax
  8018ce:	e8 d7 fb ff ff       	call   8014aa <free>
  8018d3:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8018e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8018eb:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018ee:	29 c2                	sub    %eax,%edx
  8018f0:	89 d0                	mov    %edx,%eax
  8018f2:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8018f7:	c1 e8 0c             	shr    $0xc,%eax
  8018fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801900:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  801907:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80190a:	83 ec 08             	sub    $0x8,%esp
  80190d:	ff 75 08             	pushl  0x8(%ebp)
  801910:	ff 75 f0             	pushl  -0x10(%ebp)
  801913:	e8 ef 02 00 00       	call   801c07 <sys_freeSharedObject>
  801918:	83 c4 10             	add    $0x10,%esp
  80191b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80191e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801922:	75 0e                	jne    801932 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801927:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  80192e:	ff ff ff ff 
	}

}
  801932:	90                   	nop
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 40 3d 80 00       	push   $0x803d40
  801943:	68 19 01 00 00       	push   $0x119
  801948:	68 32 3d 80 00       	push   $0x803d32
  80194d:	e8 35 e9 ff ff       	call   800287 <_panic>

00801952 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 66 3d 80 00       	push   $0x803d66
  801960:	68 23 01 00 00       	push   $0x123
  801965:	68 32 3d 80 00       	push   $0x803d32
  80196a:	e8 18 e9 ff ff       	call   800287 <_panic>

0080196f <shrink>:

}
void shrink(uint32 newSize) {
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801975:	83 ec 04             	sub    $0x4,%esp
  801978:	68 66 3d 80 00       	push   $0x803d66
  80197d:	68 27 01 00 00       	push   $0x127
  801982:	68 32 3d 80 00       	push   $0x803d32
  801987:	e8 fb e8 ff ff       	call   800287 <_panic>

0080198c <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	68 66 3d 80 00       	push   $0x803d66
  80199a:	68 2b 01 00 00       	push   $0x12b
  80199f:	68 32 3d 80 00       	push   $0x803d32
  8019a4:	e8 de e8 ff ff       	call   800287 <_panic>

008019a9 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
  8019ac:	57                   	push   %edi
  8019ad:	56                   	push   %esi
  8019ae:	53                   	push   %ebx
  8019af:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019be:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019c1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019c4:	cd 30                	int    $0x30
  8019c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8019c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019cc:	83 c4 10             	add    $0x10,%esp
  8019cf:	5b                   	pop    %ebx
  8019d0:	5e                   	pop    %esi
  8019d1:	5f                   	pop    %edi
  8019d2:	5d                   	pop    %ebp
  8019d3:	c3                   	ret    

008019d4 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	8b 45 10             	mov    0x10(%ebp),%eax
  8019dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8019e0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	52                   	push   %edx
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	e8 b2 ff ff ff       	call   8019a9 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	90                   	nop
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_cgetc>:

int sys_cgetc(void) {
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 02                	push   $0x2
  801a0c:	e8 98 ff ff ff       	call   8019a9 <syscall>
  801a11:	83 c4 18             	add    $0x18,%esp
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_lock_cons>:

void sys_lock_cons(void) {
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 03                	push   $0x3
  801a25:	e8 7f ff ff ff       	call   8019a9 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 04                	push   $0x4
  801a3f:	e8 65 ff ff ff       	call   8019a9 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	90                   	nop
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	52                   	push   %edx
  801a5a:	50                   	push   %eax
  801a5b:	6a 08                	push   $0x8
  801a5d:	e8 47 ff ff ff       	call   8019a9 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801a6c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a6f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a72:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	56                   	push   %esi
  801a7c:	53                   	push   %ebx
  801a7d:	51                   	push   %ecx
  801a7e:	52                   	push   %edx
  801a7f:	50                   	push   %eax
  801a80:	6a 09                	push   $0x9
  801a82:	e8 22 ff ff ff       	call   8019a9 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801a8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a8d:	5b                   	pop    %ebx
  801a8e:	5e                   	pop    %esi
  801a8f:	5d                   	pop    %ebp
  801a90:	c3                   	ret    

00801a91 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	52                   	push   %edx
  801aa1:	50                   	push   %eax
  801aa2:	6a 0a                	push   $0xa
  801aa4:	e8 00 ff ff ff       	call   8019a9 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	ff 75 08             	pushl  0x8(%ebp)
  801abd:	6a 0b                	push   $0xb
  801abf:	e8 e5 fe ff ff       	call   8019a9 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 0c                	push   $0xc
  801ad8:	e8 cc fe ff ff       	call   8019a9 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 0d                	push   $0xd
  801af1:	e8 b3 fe ff ff       	call   8019a9 <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 0e                	push   $0xe
  801b0a:	e8 9a fe ff ff       	call   8019a9 <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 0f                	push   $0xf
  801b23:	e8 81 fe ff ff       	call   8019a9 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	ff 75 08             	pushl  0x8(%ebp)
  801b3b:	6a 10                	push   $0x10
  801b3d:	e8 67 fe ff ff       	call   8019a9 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_scarce_memory>:

void sys_scarce_memory() {
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 11                	push   $0x11
  801b56:	e8 4e fe ff ff       	call   8019a9 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	90                   	nop
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_cputc>:

void sys_cputc(const char c) {
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
  801b64:	83 ec 04             	sub    $0x4,%esp
  801b67:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b6d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	50                   	push   %eax
  801b7a:	6a 01                	push   $0x1
  801b7c:	e8 28 fe ff ff       	call   8019a9 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	90                   	nop
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 14                	push   $0x14
  801b96:	e8 0e fe ff ff       	call   8019a9 <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	90                   	nop
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	8b 45 10             	mov    0x10(%ebp),%eax
  801baa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801bad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bb0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	51                   	push   %ecx
  801bba:	52                   	push   %edx
  801bbb:	ff 75 0c             	pushl  0xc(%ebp)
  801bbe:	50                   	push   %eax
  801bbf:	6a 15                	push   $0x15
  801bc1:	e8 e3 fd ff ff       	call   8019a9 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801bce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	52                   	push   %edx
  801bdb:	50                   	push   %eax
  801bdc:	6a 16                	push   $0x16
  801bde:	e8 c6 fd ff ff       	call   8019a9 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801beb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	51                   	push   %ecx
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 17                	push   $0x17
  801bfd:	e8 a7 fd ff ff       	call   8019a9 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	52                   	push   %edx
  801c17:	50                   	push   %eax
  801c18:	6a 18                	push   $0x18
  801c1a:	e8 8a fd ff ff       	call   8019a9 <syscall>
  801c1f:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801c22:	c9                   	leave  
  801c23:	c3                   	ret    

00801c24 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801c24:	55                   	push   %ebp
  801c25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	ff 75 14             	pushl  0x14(%ebp)
  801c2f:	ff 75 10             	pushl  0x10(%ebp)
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	50                   	push   %eax
  801c36:	6a 19                	push   $0x19
  801c38:	e8 6c fd ff ff       	call   8019a9 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_run_env>:

void sys_run_env(int32 envId) {
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	50                   	push   %eax
  801c51:	6a 1a                	push   $0x1a
  801c53:	e8 51 fd ff ff       	call   8019a9 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	90                   	nop
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	50                   	push   %eax
  801c6d:	6a 1b                	push   $0x1b
  801c6f:	e8 35 fd ff ff       	call   8019a9 <syscall>
  801c74:	83 c4 18             	add    $0x18,%esp
}
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    

00801c79 <sys_getenvid>:

int32 sys_getenvid(void) {
  801c79:	55                   	push   %ebp
  801c7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 05                	push   $0x5
  801c88:	e8 1c fd ff ff       	call   8019a9 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
}
  801c90:	c9                   	leave  
  801c91:	c3                   	ret    

00801c92 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801c92:	55                   	push   %ebp
  801c93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 06                	push   $0x6
  801ca1:	e8 03 fd ff ff       	call   8019a9 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 07                	push   $0x7
  801cba:	e8 ea fc ff ff       	call   8019a9 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <sys_exit_env>:

void sys_exit_env(void) {
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 1c                	push   $0x1c
  801cd3:	e8 d1 fc ff ff       	call   8019a9 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	90                   	nop
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801ce4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce7:	8d 50 04             	lea    0x4(%eax),%edx
  801cea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	52                   	push   %edx
  801cf4:	50                   	push   %eax
  801cf5:	6a 1d                	push   $0x1d
  801cf7:	e8 ad fc ff ff       	call   8019a9 <syscall>
  801cfc:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801cff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d02:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d08:	89 01                	mov    %eax,(%ecx)
  801d0a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	c9                   	leave  
  801d11:	c2 04 00             	ret    $0x4

00801d14 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 10             	pushl  0x10(%ebp)
  801d1e:	ff 75 0c             	pushl  0xc(%ebp)
  801d21:	ff 75 08             	pushl  0x8(%ebp)
  801d24:	6a 13                	push   $0x13
  801d26:	e8 7e fc ff ff       	call   8019a9 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801d2e:	90                   	nop
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_rcr2>:
uint32 sys_rcr2() {
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 1e                	push   $0x1e
  801d40:	e8 64 fc ff ff       	call   8019a9 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 04             	sub    $0x4,%esp
  801d50:	8b 45 08             	mov    0x8(%ebp),%eax
  801d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d56:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	50                   	push   %eax
  801d63:	6a 1f                	push   $0x1f
  801d65:	e8 3f fc ff ff       	call   8019a9 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
	return;
  801d6d:	90                   	nop
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <rsttst>:
void rsttst() {
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 21                	push   $0x21
  801d7f:	e8 25 fc ff ff       	call   8019a9 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
	return;
  801d87:	90                   	nop
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 04             	sub    $0x4,%esp
  801d90:	8b 45 14             	mov    0x14(%ebp),%eax
  801d93:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d96:	8b 55 18             	mov    0x18(%ebp),%edx
  801d99:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d9d:	52                   	push   %edx
  801d9e:	50                   	push   %eax
  801d9f:	ff 75 10             	pushl  0x10(%ebp)
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	ff 75 08             	pushl  0x8(%ebp)
  801da8:	6a 20                	push   $0x20
  801daa:	e8 fa fb ff ff       	call   8019a9 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
	return;
  801db2:	90                   	nop
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <chktst>:
void chktst(uint32 n) {
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	ff 75 08             	pushl  0x8(%ebp)
  801dc3:	6a 22                	push   $0x22
  801dc5:	e8 df fb ff ff       	call   8019a9 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
	return;
  801dcd:	90                   	nop
}
  801dce:	c9                   	leave  
  801dcf:	c3                   	ret    

00801dd0 <inctst>:

void inctst() {
  801dd0:	55                   	push   %ebp
  801dd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 23                	push   $0x23
  801ddf:	e8 c5 fb ff ff       	call   8019a9 <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
	return;
  801de7:	90                   	nop
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <gettst>:
uint32 gettst() {
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 24                	push   $0x24
  801df9:	e8 ab fb ff ff       	call   8019a9 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 25                	push   $0x25
  801e15:	e8 8f fb ff ff       	call   8019a9 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
  801e1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e20:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e24:	75 07                	jne    801e2d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	eb 05                	jmp    801e32 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 25                	push   $0x25
  801e46:	e8 5e fb ff ff       	call   8019a9 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
  801e4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e51:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e55:	75 07                	jne    801e5e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e57:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5c:	eb 05                	jmp    801e63 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 25                	push   $0x25
  801e77:	e8 2d fb ff ff       	call   8019a9 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
  801e7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e82:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e86:	75 07                	jne    801e8f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e88:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8d:	eb 05                	jmp    801e94 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 25                	push   $0x25
  801ea8:	e8 fc fa ff ff       	call   8019a9 <syscall>
  801ead:	83 c4 18             	add    $0x18,%esp
  801eb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eb3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eb7:	75 07                	jne    801ec0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eb9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebe:	eb 05                	jmp    801ec5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	ff 75 08             	pushl  0x8(%ebp)
  801ed5:	6a 26                	push   $0x26
  801ed7:	e8 cd fa ff ff       	call   8019a9 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
	return;
  801edf:	90                   	nop
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801ee6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eef:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef2:	6a 00                	push   $0x0
  801ef4:	53                   	push   %ebx
  801ef5:	51                   	push   %ecx
  801ef6:	52                   	push   %edx
  801ef7:	50                   	push   %eax
  801ef8:	6a 27                	push   $0x27
  801efa:	e8 aa fa ff ff       	call   8019a9 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801f02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801f0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	52                   	push   %edx
  801f17:	50                   	push   %eax
  801f18:	6a 28                	push   $0x28
  801f1a:	e8 8a fa ff ff       	call   8019a9 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801f22:	c9                   	leave  
  801f23:	c3                   	ret    

00801f24 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801f27:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f30:	6a 00                	push   $0x0
  801f32:	51                   	push   %ecx
  801f33:	ff 75 10             	pushl  0x10(%ebp)
  801f36:	52                   	push   %edx
  801f37:	50                   	push   %eax
  801f38:	6a 29                	push   $0x29
  801f3a:	e8 6a fa ff ff       	call   8019a9 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	ff 75 10             	pushl  0x10(%ebp)
  801f4e:	ff 75 0c             	pushl  0xc(%ebp)
  801f51:	ff 75 08             	pushl  0x8(%ebp)
  801f54:	6a 12                	push   $0x12
  801f56:	e8 4e fa ff ff       	call   8019a9 <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
	return;
  801f5e:	90                   	nop
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	52                   	push   %edx
  801f71:	50                   	push   %eax
  801f72:	6a 2a                	push   $0x2a
  801f74:	e8 30 fa ff ff       	call   8019a9 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
	return;
  801f7c:	90                   	nop
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	50                   	push   %eax
  801f8e:	6a 2b                	push   $0x2b
  801f90:	e8 14 fa ff ff       	call   8019a9 <syscall>
  801f95:	83 c4 18             	add    $0x18,%esp
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	ff 75 0c             	pushl  0xc(%ebp)
  801fa6:	ff 75 08             	pushl  0x8(%ebp)
  801fa9:	6a 2c                	push   $0x2c
  801fab:	e8 f9 f9 ff ff       	call   8019a9 <syscall>
  801fb0:	83 c4 18             	add    $0x18,%esp
	return;
  801fb3:	90                   	nop
}
  801fb4:	c9                   	leave  
  801fb5:	c3                   	ret    

00801fb6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	ff 75 08             	pushl  0x8(%ebp)
  801fc5:	6a 2d                	push   $0x2d
  801fc7:	e8 dd f9 ff ff       	call   8019a9 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
	return;
  801fcf:	90                   	nop
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	50                   	push   %eax
  801fe1:	6a 2f                	push   $0x2f
  801fe3:	e8 c1 f9 ff ff       	call   8019a9 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
	return;
  801feb:	90                   	nop
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801ff1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	52                   	push   %edx
  801ffe:	50                   	push   %eax
  801fff:	6a 30                	push   $0x30
  802001:	e8 a3 f9 ff ff       	call   8019a9 <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
	return;
  802009:	90                   	nop
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	50                   	push   %eax
  80201b:	6a 31                	push   $0x31
  80201d:	e8 87 f9 ff ff       	call   8019a9 <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
	return;
  802025:	90                   	nop
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80202b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202e:	8b 45 08             	mov    0x8(%ebp),%eax
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	52                   	push   %edx
  802038:	50                   	push   %eax
  802039:	6a 2e                	push   $0x2e
  80203b:	e8 69 f9 ff ff       	call   8019a9 <syscall>
  802040:	83 c4 18             	add    $0x18,%esp
    return;
  802043:	90                   	nop
}
  802044:	c9                   	leave  
  802045:	c3                   	ret    

00802046 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802046:	55                   	push   %ebp
  802047:	89 e5                	mov    %esp,%ebp
  802049:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	83 e8 04             	sub    $0x4,%eax
  802052:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802055:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802058:	8b 00                	mov    (%eax),%eax
  80205a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	83 e8 04             	sub    $0x4,%eax
  80206b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80206e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802071:	8b 00                	mov    (%eax),%eax
  802073:	83 e0 01             	and    $0x1,%eax
  802076:	85 c0                	test   %eax,%eax
  802078:	0f 94 c0             	sete   %al
}
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80208a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208d:	83 f8 02             	cmp    $0x2,%eax
  802090:	74 2b                	je     8020bd <alloc_block+0x40>
  802092:	83 f8 02             	cmp    $0x2,%eax
  802095:	7f 07                	jg     80209e <alloc_block+0x21>
  802097:	83 f8 01             	cmp    $0x1,%eax
  80209a:	74 0e                	je     8020aa <alloc_block+0x2d>
  80209c:	eb 58                	jmp    8020f6 <alloc_block+0x79>
  80209e:	83 f8 03             	cmp    $0x3,%eax
  8020a1:	74 2d                	je     8020d0 <alloc_block+0x53>
  8020a3:	83 f8 04             	cmp    $0x4,%eax
  8020a6:	74 3b                	je     8020e3 <alloc_block+0x66>
  8020a8:	eb 4c                	jmp    8020f6 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8020aa:	83 ec 0c             	sub    $0xc,%esp
  8020ad:	ff 75 08             	pushl  0x8(%ebp)
  8020b0:	e8 f7 03 00 00       	call   8024ac <alloc_block_FF>
  8020b5:	83 c4 10             	add    $0x10,%esp
  8020b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020bb:	eb 4a                	jmp    802107 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8020bd:	83 ec 0c             	sub    $0xc,%esp
  8020c0:	ff 75 08             	pushl  0x8(%ebp)
  8020c3:	e8 f0 11 00 00       	call   8032b8 <alloc_block_NF>
  8020c8:	83 c4 10             	add    $0x10,%esp
  8020cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020ce:	eb 37                	jmp    802107 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	ff 75 08             	pushl  0x8(%ebp)
  8020d6:	e8 08 08 00 00       	call   8028e3 <alloc_block_BF>
  8020db:	83 c4 10             	add    $0x10,%esp
  8020de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020e1:	eb 24                	jmp    802107 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	ff 75 08             	pushl  0x8(%ebp)
  8020e9:	e8 ad 11 00 00       	call   80329b <alloc_block_WF>
  8020ee:	83 c4 10             	add    $0x10,%esp
  8020f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020f4:	eb 11                	jmp    802107 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020f6:	83 ec 0c             	sub    $0xc,%esp
  8020f9:	68 78 3d 80 00       	push   $0x803d78
  8020fe:	e8 41 e4 ff ff       	call   800544 <cprintf>
  802103:	83 c4 10             	add    $0x10,%esp
		break;
  802106:	90                   	nop
	}
	return va;
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	53                   	push   %ebx
  802110:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802113:	83 ec 0c             	sub    $0xc,%esp
  802116:	68 98 3d 80 00       	push   $0x803d98
  80211b:	e8 24 e4 ff ff       	call   800544 <cprintf>
  802120:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802123:	83 ec 0c             	sub    $0xc,%esp
  802126:	68 c3 3d 80 00       	push   $0x803dc3
  80212b:	e8 14 e4 ff ff       	call   800544 <cprintf>
  802130:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802133:	8b 45 08             	mov    0x8(%ebp),%eax
  802136:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802139:	eb 37                	jmp    802172 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80213b:	83 ec 0c             	sub    $0xc,%esp
  80213e:	ff 75 f4             	pushl  -0xc(%ebp)
  802141:	e8 19 ff ff ff       	call   80205f <is_free_block>
  802146:	83 c4 10             	add    $0x10,%esp
  802149:	0f be d8             	movsbl %al,%ebx
  80214c:	83 ec 0c             	sub    $0xc,%esp
  80214f:	ff 75 f4             	pushl  -0xc(%ebp)
  802152:	e8 ef fe ff ff       	call   802046 <get_block_size>
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	53                   	push   %ebx
  80215e:	50                   	push   %eax
  80215f:	68 db 3d 80 00       	push   $0x803ddb
  802164:	e8 db e3 ff ff       	call   800544 <cprintf>
  802169:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80216c:	8b 45 10             	mov    0x10(%ebp),%eax
  80216f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802172:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802176:	74 07                	je     80217f <print_blocks_list+0x73>
  802178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217b:	8b 00                	mov    (%eax),%eax
  80217d:	eb 05                	jmp    802184 <print_blocks_list+0x78>
  80217f:	b8 00 00 00 00       	mov    $0x0,%eax
  802184:	89 45 10             	mov    %eax,0x10(%ebp)
  802187:	8b 45 10             	mov    0x10(%ebp),%eax
  80218a:	85 c0                	test   %eax,%eax
  80218c:	75 ad                	jne    80213b <print_blocks_list+0x2f>
  80218e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802192:	75 a7                	jne    80213b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802194:	83 ec 0c             	sub    $0xc,%esp
  802197:	68 98 3d 80 00       	push   $0x803d98
  80219c:	e8 a3 e3 ff ff       	call   800544 <cprintf>
  8021a1:	83 c4 10             	add    $0x10,%esp

}
  8021a4:	90                   	nop
  8021a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8021b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b3:	83 e0 01             	and    $0x1,%eax
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	74 03                	je     8021bd <initialize_dynamic_allocator+0x13>
  8021ba:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8021bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021c1:	0f 84 f8 00 00 00    	je     8022bf <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8021c7:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  8021ce:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8021d1:	a1 40 40 98 00       	mov    0x984040,%eax
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	0f 84 e2 00 00 00    	je     8022c0 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8021ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f3:	01 d0                	add    %edx,%eax
  8021f5:	83 e8 04             	sub    $0x4,%eax
  8021f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	83 c0 08             	add    $0x8,%eax
  80220a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80220d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802210:	83 e8 08             	sub    $0x8,%eax
  802213:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802216:	83 ec 04             	sub    $0x4,%esp
  802219:	6a 00                	push   $0x0
  80221b:	ff 75 e8             	pushl  -0x18(%ebp)
  80221e:	ff 75 ec             	pushl  -0x14(%ebp)
  802221:	e8 9c 00 00 00       	call   8022c2 <set_block_data>
  802226:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802229:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802232:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80223c:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  802243:	00 00 00 
  802246:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  80224d:	00 00 00 
  802250:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  802257:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80225a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80225e:	75 17                	jne    802277 <initialize_dynamic_allocator+0xcd>
  802260:	83 ec 04             	sub    $0x4,%esp
  802263:	68 f4 3d 80 00       	push   $0x803df4
  802268:	68 80 00 00 00       	push   $0x80
  80226d:	68 17 3e 80 00       	push   $0x803e17
  802272:	e8 10 e0 ff ff       	call   800287 <_panic>
  802277:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80227d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802280:	89 10                	mov    %edx,(%eax)
  802282:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802285:	8b 00                	mov    (%eax),%eax
  802287:	85 c0                	test   %eax,%eax
  802289:	74 0d                	je     802298 <initialize_dynamic_allocator+0xee>
  80228b:	a1 48 40 98 00       	mov    0x984048,%eax
  802290:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802293:	89 50 04             	mov    %edx,0x4(%eax)
  802296:	eb 08                	jmp    8022a0 <initialize_dynamic_allocator+0xf6>
  802298:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80229b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8022a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022a3:	a3 48 40 98 00       	mov    %eax,0x984048
  8022a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b2:	a1 54 40 98 00       	mov    0x984054,%eax
  8022b7:	40                   	inc    %eax
  8022b8:	a3 54 40 98 00       	mov    %eax,0x984054
  8022bd:	eb 01                	jmp    8022c0 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8022bf:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	83 e0 01             	and    $0x1,%eax
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	74 03                	je     8022d5 <set_block_data+0x13>
	{
		totalSize++;
  8022d2:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	83 e8 04             	sub    $0x4,%eax
  8022db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	83 e0 fe             	and    $0xfffffffe,%eax
  8022e4:	89 c2                	mov    %eax,%edx
  8022e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022e9:	83 e0 01             	and    $0x1,%eax
  8022ec:	09 c2                	or     %eax,%edx
  8022ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f1:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8022f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f6:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	01 d0                	add    %edx,%eax
  8022fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802301:	8b 45 0c             	mov    0xc(%ebp),%eax
  802304:	83 e0 fe             	and    $0xfffffffe,%eax
  802307:	89 c2                	mov    %eax,%edx
  802309:	8b 45 10             	mov    0x10(%ebp),%eax
  80230c:	83 e0 01             	and    $0x1,%eax
  80230f:	09 c2                	or     %eax,%edx
  802311:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802314:	89 10                	mov    %edx,(%eax)
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  80231f:	a1 48 40 98 00       	mov    0x984048,%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	75 68                	jne    802390 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802328:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232c:	75 17                	jne    802345 <insert_sorted_in_freeList+0x2c>
  80232e:	83 ec 04             	sub    $0x4,%esp
  802331:	68 f4 3d 80 00       	push   $0x803df4
  802336:	68 9d 00 00 00       	push   $0x9d
  80233b:	68 17 3e 80 00       	push   $0x803e17
  802340:	e8 42 df ff ff       	call   800287 <_panic>
  802345:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	89 10                	mov    %edx,(%eax)
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	8b 00                	mov    (%eax),%eax
  802355:	85 c0                	test   %eax,%eax
  802357:	74 0d                	je     802366 <insert_sorted_in_freeList+0x4d>
  802359:	a1 48 40 98 00       	mov    0x984048,%eax
  80235e:	8b 55 08             	mov    0x8(%ebp),%edx
  802361:	89 50 04             	mov    %edx,0x4(%eax)
  802364:	eb 08                	jmp    80236e <insert_sorted_in_freeList+0x55>
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	a3 48 40 98 00       	mov    %eax,0x984048
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802380:	a1 54 40 98 00       	mov    0x984054,%eax
  802385:	40                   	inc    %eax
  802386:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  80238b:	e9 1a 01 00 00       	jmp    8024aa <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802390:	a1 48 40 98 00       	mov    0x984048,%eax
  802395:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802398:	eb 7f                	jmp    802419 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a0:	76 6f                	jbe    802411 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8023a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a6:	74 06                	je     8023ae <insert_sorted_in_freeList+0x95>
  8023a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023ac:	75 17                	jne    8023c5 <insert_sorted_in_freeList+0xac>
  8023ae:	83 ec 04             	sub    $0x4,%esp
  8023b1:	68 30 3e 80 00       	push   $0x803e30
  8023b6:	68 a6 00 00 00       	push   $0xa6
  8023bb:	68 17 3e 80 00       	push   $0x803e17
  8023c0:	e8 c2 de ff ff       	call   800287 <_panic>
  8023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c8:	8b 50 04             	mov    0x4(%eax),%edx
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	89 50 04             	mov    %edx,0x4(%eax)
  8023d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d7:	89 10                	mov    %edx,(%eax)
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 40 04             	mov    0x4(%eax),%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 0d                	je     8023f0 <insert_sorted_in_freeList+0xd7>
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 04             	mov    0x4(%eax),%eax
  8023e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ec:	89 10                	mov    %edx,(%eax)
  8023ee:	eb 08                	jmp    8023f8 <insert_sorted_in_freeList+0xdf>
  8023f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f3:	a3 48 40 98 00       	mov    %eax,0x984048
  8023f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fe:	89 50 04             	mov    %edx,0x4(%eax)
  802401:	a1 54 40 98 00       	mov    0x984054,%eax
  802406:	40                   	inc    %eax
  802407:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  80240c:	e9 99 00 00 00       	jmp    8024aa <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802411:	a1 50 40 98 00       	mov    0x984050,%eax
  802416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	74 07                	je     802426 <insert_sorted_in_freeList+0x10d>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	eb 05                	jmp    80242b <insert_sorted_in_freeList+0x112>
  802426:	b8 00 00 00 00       	mov    $0x0,%eax
  80242b:	a3 50 40 98 00       	mov    %eax,0x984050
  802430:	a1 50 40 98 00       	mov    0x984050,%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	0f 85 5d ff ff ff    	jne    80239a <insert_sorted_in_freeList+0x81>
  80243d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802441:	0f 85 53 ff ff ff    	jne    80239a <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802447:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80244b:	75 17                	jne    802464 <insert_sorted_in_freeList+0x14b>
  80244d:	83 ec 04             	sub    $0x4,%esp
  802450:	68 68 3e 80 00       	push   $0x803e68
  802455:	68 ab 00 00 00       	push   $0xab
  80245a:	68 17 3e 80 00       	push   $0x803e17
  80245f:	e8 23 de ff ff       	call   800287 <_panic>
  802464:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	89 50 04             	mov    %edx,0x4(%eax)
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	8b 40 04             	mov    0x4(%eax),%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 0c                	je     802486 <insert_sorted_in_freeList+0x16d>
  80247a:	a1 4c 40 98 00       	mov    0x98404c,%eax
  80247f:	8b 55 08             	mov    0x8(%ebp),%edx
  802482:	89 10                	mov    %edx,(%eax)
  802484:	eb 08                	jmp    80248e <insert_sorted_in_freeList+0x175>
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	a3 48 40 98 00       	mov    %eax,0x984048
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802496:	8b 45 08             	mov    0x8(%ebp),%eax
  802499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249f:	a1 54 40 98 00       	mov    0x984054,%eax
  8024a4:	40                   	inc    %eax
  8024a5:	a3 54 40 98 00       	mov    %eax,0x984054
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	83 e0 01             	and    $0x1,%eax
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 03                	je     8024bf <alloc_block_FF+0x13>
  8024bc:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8024bf:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8024c3:	77 07                	ja     8024cc <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8024c5:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8024cc:	a1 40 40 98 00       	mov    0x984040,%eax
  8024d1:	85 c0                	test   %eax,%eax
  8024d3:	75 63                	jne    802538 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	83 c0 10             	add    $0x10,%eax
  8024db:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024de:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024eb:	01 d0                	add    %edx,%eax
  8024ed:	48                   	dec    %eax
  8024ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f9:	f7 75 ec             	divl   -0x14(%ebp)
  8024fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ff:	29 d0                	sub    %edx,%eax
  802501:	c1 e8 0c             	shr    $0xc,%eax
  802504:	83 ec 0c             	sub    $0xc,%esp
  802507:	50                   	push   %eax
  802508:	e8 d1 ed ff ff       	call   8012de <sbrk>
  80250d:	83 c4 10             	add    $0x10,%esp
  802510:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802513:	83 ec 0c             	sub    $0xc,%esp
  802516:	6a 00                	push   $0x0
  802518:	e8 c1 ed ff ff       	call   8012de <sbrk>
  80251d:	83 c4 10             	add    $0x10,%esp
  802520:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802523:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802526:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802529:	83 ec 08             	sub    $0x8,%esp
  80252c:	50                   	push   %eax
  80252d:	ff 75 e4             	pushl  -0x1c(%ebp)
  802530:	e8 75 fc ff ff       	call   8021aa <initialize_dynamic_allocator>
  802535:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802538:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80253c:	75 0a                	jne    802548 <alloc_block_FF+0x9c>
	{
		return NULL;
  80253e:	b8 00 00 00 00       	mov    $0x0,%eax
  802543:	e9 99 03 00 00       	jmp    8028e1 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802548:	8b 45 08             	mov    0x8(%ebp),%eax
  80254b:	83 c0 08             	add    $0x8,%eax
  80254e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802551:	a1 48 40 98 00       	mov    0x984048,%eax
  802556:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802559:	e9 03 02 00 00       	jmp    802761 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  80255e:	83 ec 0c             	sub    $0xc,%esp
  802561:	ff 75 f4             	pushl  -0xc(%ebp)
  802564:	e8 dd fa ff ff       	call   802046 <get_block_size>
  802569:	83 c4 10             	add    $0x10,%esp
  80256c:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  80256f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802572:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802575:	0f 82 de 01 00 00    	jb     802759 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80257b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80257e:	83 c0 10             	add    $0x10,%eax
  802581:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802584:	0f 87 32 01 00 00    	ja     8026bc <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80258a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80258d:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802590:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802593:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802596:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802599:	01 d0                	add    %edx,%eax
  80259b:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80259e:	83 ec 04             	sub    $0x4,%esp
  8025a1:	6a 00                	push   $0x0
  8025a3:	ff 75 98             	pushl  -0x68(%ebp)
  8025a6:	ff 75 94             	pushl  -0x6c(%ebp)
  8025a9:	e8 14 fd ff ff       	call   8022c2 <set_block_data>
  8025ae:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8025b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b5:	74 06                	je     8025bd <alloc_block_FF+0x111>
  8025b7:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8025bb:	75 17                	jne    8025d4 <alloc_block_FF+0x128>
  8025bd:	83 ec 04             	sub    $0x4,%esp
  8025c0:	68 8c 3e 80 00       	push   $0x803e8c
  8025c5:	68 de 00 00 00       	push   $0xde
  8025ca:	68 17 3e 80 00       	push   $0x803e17
  8025cf:	e8 b3 dc ff ff       	call   800287 <_panic>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 10                	mov    (%eax),%edx
  8025d9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025dc:	89 10                	mov    %edx,(%eax)
  8025de:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025e1:	8b 00                	mov    (%eax),%eax
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	74 0b                	je     8025f2 <alloc_block_FF+0x146>
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 00                	mov    (%eax),%eax
  8025ec:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025ef:	89 50 04             	mov    %edx,0x4(%eax)
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025f8:	89 10                	mov    %edx,(%eax)
  8025fa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802600:	89 50 04             	mov    %edx,0x4(%eax)
  802603:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	75 08                	jne    802614 <alloc_block_FF+0x168>
  80260c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80260f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802614:	a1 54 40 98 00       	mov    0x984054,%eax
  802619:	40                   	inc    %eax
  80261a:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  80261f:	83 ec 04             	sub    $0x4,%esp
  802622:	6a 01                	push   $0x1
  802624:	ff 75 dc             	pushl  -0x24(%ebp)
  802627:	ff 75 f4             	pushl  -0xc(%ebp)
  80262a:	e8 93 fc ff ff       	call   8022c2 <set_block_data>
  80262f:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802632:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802636:	75 17                	jne    80264f <alloc_block_FF+0x1a3>
  802638:	83 ec 04             	sub    $0x4,%esp
  80263b:	68 c0 3e 80 00       	push   $0x803ec0
  802640:	68 e3 00 00 00       	push   $0xe3
  802645:	68 17 3e 80 00       	push   $0x803e17
  80264a:	e8 38 dc ff ff       	call   800287 <_panic>
  80264f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	74 10                	je     802668 <alloc_block_FF+0x1bc>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802660:	8b 52 04             	mov    0x4(%edx),%edx
  802663:	89 50 04             	mov    %edx,0x4(%eax)
  802666:	eb 0b                	jmp    802673 <alloc_block_FF+0x1c7>
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 40 04             	mov    0x4(%eax),%eax
  80266e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 04             	mov    0x4(%eax),%eax
  802679:	85 c0                	test   %eax,%eax
  80267b:	74 0f                	je     80268c <alloc_block_FF+0x1e0>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 40 04             	mov    0x4(%eax),%eax
  802683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802686:	8b 12                	mov    (%edx),%edx
  802688:	89 10                	mov    %edx,(%eax)
  80268a:	eb 0a                	jmp    802696 <alloc_block_FF+0x1ea>
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	a3 48 40 98 00       	mov    %eax,0x984048
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a9:	a1 54 40 98 00       	mov    0x984054,%eax
  8026ae:	48                   	dec    %eax
  8026af:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	e9 25 02 00 00       	jmp    8028e1 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8026bc:	83 ec 04             	sub    $0x4,%esp
  8026bf:	6a 01                	push   $0x1
  8026c1:	ff 75 9c             	pushl  -0x64(%ebp)
  8026c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8026c7:	e8 f6 fb ff ff       	call   8022c2 <set_block_data>
  8026cc:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8026cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d3:	75 17                	jne    8026ec <alloc_block_FF+0x240>
  8026d5:	83 ec 04             	sub    $0x4,%esp
  8026d8:	68 c0 3e 80 00       	push   $0x803ec0
  8026dd:	68 eb 00 00 00       	push   $0xeb
  8026e2:	68 17 3e 80 00       	push   $0x803e17
  8026e7:	e8 9b db ff ff       	call   800287 <_panic>
  8026ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 10                	je     802705 <alloc_block_FF+0x259>
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fd:	8b 52 04             	mov    0x4(%edx),%edx
  802700:	89 50 04             	mov    %edx,0x4(%eax)
  802703:	eb 0b                	jmp    802710 <alloc_block_FF+0x264>
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 04             	mov    0x4(%eax),%eax
  80270b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 04             	mov    0x4(%eax),%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	74 0f                	je     802729 <alloc_block_FF+0x27d>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 40 04             	mov    0x4(%eax),%eax
  802720:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802723:	8b 12                	mov    (%edx),%edx
  802725:	89 10                	mov    %edx,(%eax)
  802727:	eb 0a                	jmp    802733 <alloc_block_FF+0x287>
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	8b 00                	mov    (%eax),%eax
  80272e:	a3 48 40 98 00       	mov    %eax,0x984048
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802746:	a1 54 40 98 00       	mov    0x984054,%eax
  80274b:	48                   	dec    %eax
  80274c:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	e9 88 01 00 00       	jmp    8028e1 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802759:	a1 50 40 98 00       	mov    0x984050,%eax
  80275e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802761:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802765:	74 07                	je     80276e <alloc_block_FF+0x2c2>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	eb 05                	jmp    802773 <alloc_block_FF+0x2c7>
  80276e:	b8 00 00 00 00       	mov    $0x0,%eax
  802773:	a3 50 40 98 00       	mov    %eax,0x984050
  802778:	a1 50 40 98 00       	mov    0x984050,%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	0f 85 d9 fd ff ff    	jne    80255e <alloc_block_FF+0xb2>
  802785:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802789:	0f 85 cf fd ff ff    	jne    80255e <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80278f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802796:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802799:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80279c:	01 d0                	add    %edx,%eax
  80279e:	48                   	dec    %eax
  80279f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8027a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8027aa:	f7 75 d8             	divl   -0x28(%ebp)
  8027ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8027b0:	29 d0                	sub    %edx,%eax
  8027b2:	c1 e8 0c             	shr    $0xc,%eax
  8027b5:	83 ec 0c             	sub    $0xc,%esp
  8027b8:	50                   	push   %eax
  8027b9:	e8 20 eb ff ff       	call   8012de <sbrk>
  8027be:	83 c4 10             	add    $0x10,%esp
  8027c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8027c4:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8027c8:	75 0a                	jne    8027d4 <alloc_block_FF+0x328>
		return NULL;
  8027ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cf:	e9 0d 01 00 00       	jmp    8028e1 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8027d4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027d7:	83 e8 04             	sub    $0x4,%eax
  8027da:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8027dd:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8027e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027e7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ea:	01 d0                	add    %edx,%eax
  8027ec:	48                   	dec    %eax
  8027ed:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8027f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027f8:	f7 75 c8             	divl   -0x38(%ebp)
  8027fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027fe:	29 d0                	sub    %edx,%eax
  802800:	c1 e8 02             	shr    $0x2,%eax
  802803:	c1 e0 02             	shl    $0x2,%eax
  802806:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802809:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80280c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802812:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802815:	83 e8 08             	sub    $0x8,%eax
  802818:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80281b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80281e:	8b 00                	mov    (%eax),%eax
  802820:	83 e0 fe             	and    $0xfffffffe,%eax
  802823:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802826:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802829:	f7 d8                	neg    %eax
  80282b:	89 c2                	mov    %eax,%edx
  80282d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802830:	01 d0                	add    %edx,%eax
  802832:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802835:	83 ec 0c             	sub    $0xc,%esp
  802838:	ff 75 b8             	pushl  -0x48(%ebp)
  80283b:	e8 1f f8 ff ff       	call   80205f <is_free_block>
  802840:	83 c4 10             	add    $0x10,%esp
  802843:	0f be c0             	movsbl %al,%eax
  802846:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802849:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80284d:	74 42                	je     802891 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80284f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802856:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802859:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80285c:	01 d0                	add    %edx,%eax
  80285e:	48                   	dec    %eax
  80285f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802862:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802865:	ba 00 00 00 00       	mov    $0x0,%edx
  80286a:	f7 75 b0             	divl   -0x50(%ebp)
  80286d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802870:	29 d0                	sub    %edx,%eax
  802872:	89 c2                	mov    %eax,%edx
  802874:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802877:	01 d0                	add    %edx,%eax
  802879:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	6a 00                	push   $0x0
  802881:	ff 75 a8             	pushl  -0x58(%ebp)
  802884:	ff 75 b8             	pushl  -0x48(%ebp)
  802887:	e8 36 fa ff ff       	call   8022c2 <set_block_data>
  80288c:	83 c4 10             	add    $0x10,%esp
  80288f:	eb 42                	jmp    8028d3 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802891:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802898:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80289b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80289e:	01 d0                	add    %edx,%eax
  8028a0:	48                   	dec    %eax
  8028a1:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8028a4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8028ac:	f7 75 a4             	divl   -0x5c(%ebp)
  8028af:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8028b2:	29 d0                	sub    %edx,%eax
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	6a 00                	push   $0x0
  8028b9:	50                   	push   %eax
  8028ba:	ff 75 d0             	pushl  -0x30(%ebp)
  8028bd:	e8 00 fa ff ff       	call   8022c2 <set_block_data>
  8028c2:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  8028c5:	83 ec 0c             	sub    $0xc,%esp
  8028c8:	ff 75 d0             	pushl  -0x30(%ebp)
  8028cb:	e8 49 fa ff ff       	call   802319 <insert_sorted_in_freeList>
  8028d0:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8028d3:	83 ec 0c             	sub    $0xc,%esp
  8028d6:	ff 75 08             	pushl  0x8(%ebp)
  8028d9:	e8 ce fb ff ff       	call   8024ac <alloc_block_FF>
  8028de:	83 c4 10             	add    $0x10,%esp
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8028e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ed:	75 0a                	jne    8028f9 <alloc_block_BF+0x16>
	{
		return NULL;
  8028ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f4:	e9 7a 02 00 00       	jmp    802b73 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	83 c0 08             	add    $0x8,%eax
  8028ff:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802902:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802909:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802910:	a1 48 40 98 00       	mov    0x984048,%eax
  802915:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802918:	eb 32                	jmp    80294c <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  80291a:	ff 75 ec             	pushl  -0x14(%ebp)
  80291d:	e8 24 f7 ff ff       	call   802046 <get_block_size>
  802922:	83 c4 04             	add    $0x4,%esp
  802925:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80292b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80292e:	72 14                	jb     802944 <alloc_block_BF+0x61>
  802930:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802933:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802936:	73 0c                	jae    802944 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802938:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80293b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80293e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802941:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802944:	a1 50 40 98 00       	mov    0x984050,%eax
  802949:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80294c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802950:	74 07                	je     802959 <alloc_block_BF+0x76>
  802952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	eb 05                	jmp    80295e <alloc_block_BF+0x7b>
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
  80295e:	a3 50 40 98 00       	mov    %eax,0x984050
  802963:	a1 50 40 98 00       	mov    0x984050,%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	75 ae                	jne    80291a <alloc_block_BF+0x37>
  80296c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802970:	75 a8                	jne    80291a <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802972:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802976:	75 22                	jne    80299a <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297b:	83 ec 0c             	sub    $0xc,%esp
  80297e:	50                   	push   %eax
  80297f:	e8 5a e9 ff ff       	call   8012de <sbrk>
  802984:	83 c4 10             	add    $0x10,%esp
  802987:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80298a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80298e:	75 0a                	jne    80299a <alloc_block_BF+0xb7>
			return NULL;
  802990:	b8 00 00 00 00       	mov    $0x0,%eax
  802995:	e9 d9 01 00 00       	jmp    802b73 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80299a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299d:	83 c0 10             	add    $0x10,%eax
  8029a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8029a3:	0f 87 32 01 00 00    	ja     802adb <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029af:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  8029b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029b8:	01 d0                	add    %edx,%eax
  8029ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  8029bd:	83 ec 04             	sub    $0x4,%esp
  8029c0:	6a 00                	push   $0x0
  8029c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8029c5:	ff 75 d8             	pushl  -0x28(%ebp)
  8029c8:	e8 f5 f8 ff ff       	call   8022c2 <set_block_data>
  8029cd:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8029d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d4:	74 06                	je     8029dc <alloc_block_BF+0xf9>
  8029d6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029da:	75 17                	jne    8029f3 <alloc_block_BF+0x110>
  8029dc:	83 ec 04             	sub    $0x4,%esp
  8029df:	68 8c 3e 80 00       	push   $0x803e8c
  8029e4:	68 49 01 00 00       	push   $0x149
  8029e9:	68 17 3e 80 00       	push   $0x803e17
  8029ee:	e8 94 d8 ff ff       	call   800287 <_panic>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 10                	mov    (%eax),%edx
  8029f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029fb:	89 10                	mov    %edx,(%eax)
  8029fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 0b                	je     802a11 <alloc_block_BF+0x12e>
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 00                	mov    (%eax),%eax
  802a0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802a17:	89 10                	mov    %edx,(%eax)
  802a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	85 c0                	test   %eax,%eax
  802a29:	75 08                	jne    802a33 <alloc_block_BF+0x150>
  802a2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a2e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a33:	a1 54 40 98 00       	mov    0x984054,%eax
  802a38:	40                   	inc    %eax
  802a39:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	6a 01                	push   $0x1
  802a43:	ff 75 e8             	pushl  -0x18(%ebp)
  802a46:	ff 75 f4             	pushl  -0xc(%ebp)
  802a49:	e8 74 f8 ff ff       	call   8022c2 <set_block_data>
  802a4e:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a55:	75 17                	jne    802a6e <alloc_block_BF+0x18b>
  802a57:	83 ec 04             	sub    $0x4,%esp
  802a5a:	68 c0 3e 80 00       	push   $0x803ec0
  802a5f:	68 4e 01 00 00       	push   $0x14e
  802a64:	68 17 3e 80 00       	push   $0x803e17
  802a69:	e8 19 d8 ff ff       	call   800287 <_panic>
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	74 10                	je     802a87 <alloc_block_BF+0x1a4>
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7f:	8b 52 04             	mov    0x4(%edx),%edx
  802a82:	89 50 04             	mov    %edx,0x4(%eax)
  802a85:	eb 0b                	jmp    802a92 <alloc_block_BF+0x1af>
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 40 04             	mov    0x4(%eax),%eax
  802a8d:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	74 0f                	je     802aab <alloc_block_BF+0x1c8>
  802a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9f:	8b 40 04             	mov    0x4(%eax),%eax
  802aa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa5:	8b 12                	mov    (%edx),%edx
  802aa7:	89 10                	mov    %edx,(%eax)
  802aa9:	eb 0a                	jmp    802ab5 <alloc_block_BF+0x1d2>
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	8b 00                	mov    (%eax),%eax
  802ab0:	a3 48 40 98 00       	mov    %eax,0x984048
  802ab5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ac8:	a1 54 40 98 00       	mov    0x984054,%eax
  802acd:	48                   	dec    %eax
  802ace:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad6:	e9 98 00 00 00       	jmp    802b73 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802adb:	83 ec 04             	sub    $0x4,%esp
  802ade:	6a 01                	push   $0x1
  802ae0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ae3:	ff 75 f4             	pushl  -0xc(%ebp)
  802ae6:	e8 d7 f7 ff ff       	call   8022c2 <set_block_data>
  802aeb:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802aee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af2:	75 17                	jne    802b0b <alloc_block_BF+0x228>
  802af4:	83 ec 04             	sub    $0x4,%esp
  802af7:	68 c0 3e 80 00       	push   $0x803ec0
  802afc:	68 56 01 00 00       	push   $0x156
  802b01:	68 17 3e 80 00       	push   $0x803e17
  802b06:	e8 7c d7 ff ff       	call   800287 <_panic>
  802b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 10                	je     802b24 <alloc_block_BF+0x241>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 00                	mov    (%eax),%eax
  802b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1c:	8b 52 04             	mov    0x4(%edx),%edx
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	eb 0b                	jmp    802b2f <alloc_block_BF+0x24c>
  802b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b27:	8b 40 04             	mov    0x4(%eax),%eax
  802b2a:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 40 04             	mov    0x4(%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0f                	je     802b48 <alloc_block_BF+0x265>
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 40 04             	mov    0x4(%eax),%eax
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	8b 12                	mov    (%edx),%edx
  802b44:	89 10                	mov    %edx,(%eax)
  802b46:	eb 0a                	jmp    802b52 <alloc_block_BF+0x26f>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	a3 48 40 98 00       	mov    %eax,0x984048
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b65:	a1 54 40 98 00       	mov    0x984054,%eax
  802b6a:	48                   	dec    %eax
  802b6b:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802b73:	c9                   	leave  
  802b74:	c3                   	ret    

00802b75 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802b75:	55                   	push   %ebp
  802b76:	89 e5                	mov    %esp,%ebp
  802b78:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802b7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7f:	0f 84 6a 02 00 00    	je     802def <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802b85:	ff 75 08             	pushl  0x8(%ebp)
  802b88:	e8 b9 f4 ff ff       	call   802046 <get_block_size>
  802b8d:	83 c4 04             	add    $0x4,%esp
  802b90:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	83 e8 08             	sub    $0x8,%eax
  802b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	83 e0 fe             	and    $0xfffffffe,%eax
  802ba4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baa:	f7 d8                	neg    %eax
  802bac:	89 c2                	mov    %eax,%edx
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	01 d0                	add    %edx,%eax
  802bb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802bb6:	ff 75 e8             	pushl  -0x18(%ebp)
  802bb9:	e8 a1 f4 ff ff       	call   80205f <is_free_block>
  802bbe:	83 c4 04             	add    $0x4,%esp
  802bc1:	0f be c0             	movsbl %al,%eax
  802bc4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802bc7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcd:	01 d0                	add    %edx,%eax
  802bcf:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802bd2:	ff 75 e0             	pushl  -0x20(%ebp)
  802bd5:	e8 85 f4 ff ff       	call   80205f <is_free_block>
  802bda:	83 c4 04             	add    $0x4,%esp
  802bdd:	0f be c0             	movsbl %al,%eax
  802be0:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802be3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802be7:	75 34                	jne    802c1d <free_block+0xa8>
  802be9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bed:	75 2e                	jne    802c1d <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802bef:	ff 75 e8             	pushl  -0x18(%ebp)
  802bf2:	e8 4f f4 ff ff       	call   802046 <get_block_size>
  802bf7:	83 c4 04             	add    $0x4,%esp
  802bfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802bfd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c00:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c03:	01 d0                	add    %edx,%eax
  802c05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802c08:	6a 00                	push   $0x0
  802c0a:	ff 75 d4             	pushl  -0x2c(%ebp)
  802c0d:	ff 75 e8             	pushl  -0x18(%ebp)
  802c10:	e8 ad f6 ff ff       	call   8022c2 <set_block_data>
  802c15:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802c18:	e9 d3 01 00 00       	jmp    802df0 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802c1d:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802c21:	0f 85 c8 00 00 00    	jne    802cef <free_block+0x17a>
  802c27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802c2b:	0f 85 be 00 00 00    	jne    802cef <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802c31:	ff 75 e0             	pushl  -0x20(%ebp)
  802c34:	e8 0d f4 ff ff       	call   802046 <get_block_size>
  802c39:	83 c4 04             	add    $0x4,%esp
  802c3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802c3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c42:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c45:	01 d0                	add    %edx,%eax
  802c47:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802c4a:	6a 00                	push   $0x0
  802c4c:	ff 75 cc             	pushl  -0x34(%ebp)
  802c4f:	ff 75 08             	pushl  0x8(%ebp)
  802c52:	e8 6b f6 ff ff       	call   8022c2 <set_block_data>
  802c57:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802c5a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c5e:	75 17                	jne    802c77 <free_block+0x102>
  802c60:	83 ec 04             	sub    $0x4,%esp
  802c63:	68 c0 3e 80 00       	push   $0x803ec0
  802c68:	68 87 01 00 00       	push   $0x187
  802c6d:	68 17 3e 80 00       	push   $0x803e17
  802c72:	e8 10 d6 ff ff       	call   800287 <_panic>
  802c77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	85 c0                	test   %eax,%eax
  802c7e:	74 10                	je     802c90 <free_block+0x11b>
  802c80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c83:	8b 00                	mov    (%eax),%eax
  802c85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c88:	8b 52 04             	mov    0x4(%edx),%edx
  802c8b:	89 50 04             	mov    %edx,0x4(%eax)
  802c8e:	eb 0b                	jmp    802c9b <free_block+0x126>
  802c90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	74 0f                	je     802cb4 <free_block+0x13f>
  802ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca8:	8b 40 04             	mov    0x4(%eax),%eax
  802cab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cae:	8b 12                	mov    (%edx),%edx
  802cb0:	89 10                	mov    %edx,(%eax)
  802cb2:	eb 0a                	jmp    802cbe <free_block+0x149>
  802cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb7:	8b 00                	mov    (%eax),%eax
  802cb9:	a3 48 40 98 00       	mov    %eax,0x984048
  802cbe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd1:	a1 54 40 98 00       	mov    0x984054,%eax
  802cd6:	48                   	dec    %eax
  802cd7:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802cdc:	83 ec 0c             	sub    $0xc,%esp
  802cdf:	ff 75 08             	pushl  0x8(%ebp)
  802ce2:	e8 32 f6 ff ff       	call   802319 <insert_sorted_in_freeList>
  802ce7:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802cea:	e9 01 01 00 00       	jmp    802df0 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802cef:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802cf3:	0f 85 d3 00 00 00    	jne    802dcc <free_block+0x257>
  802cf9:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802cfd:	0f 85 c9 00 00 00    	jne    802dcc <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802d03:	83 ec 0c             	sub    $0xc,%esp
  802d06:	ff 75 e8             	pushl  -0x18(%ebp)
  802d09:	e8 38 f3 ff ff       	call   802046 <get_block_size>
  802d0e:	83 c4 10             	add    $0x10,%esp
  802d11:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802d14:	83 ec 0c             	sub    $0xc,%esp
  802d17:	ff 75 e0             	pushl  -0x20(%ebp)
  802d1a:	e8 27 f3 ff ff       	call   802046 <get_block_size>
  802d1f:	83 c4 10             	add    $0x10,%esp
  802d22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802d25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d28:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d2b:	01 c2                	add    %eax,%edx
  802d2d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d30:	01 d0                	add    %edx,%eax
  802d32:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802d35:	83 ec 04             	sub    $0x4,%esp
  802d38:	6a 00                	push   $0x0
  802d3a:	ff 75 c0             	pushl  -0x40(%ebp)
  802d3d:	ff 75 e8             	pushl  -0x18(%ebp)
  802d40:	e8 7d f5 ff ff       	call   8022c2 <set_block_data>
  802d45:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802d48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d4c:	75 17                	jne    802d65 <free_block+0x1f0>
  802d4e:	83 ec 04             	sub    $0x4,%esp
  802d51:	68 c0 3e 80 00       	push   $0x803ec0
  802d56:	68 94 01 00 00       	push   $0x194
  802d5b:	68 17 3e 80 00       	push   $0x803e17
  802d60:	e8 22 d5 ff ff       	call   800287 <_panic>
  802d65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	74 10                	je     802d7e <free_block+0x209>
  802d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d71:	8b 00                	mov    (%eax),%eax
  802d73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d76:	8b 52 04             	mov    0x4(%edx),%edx
  802d79:	89 50 04             	mov    %edx,0x4(%eax)
  802d7c:	eb 0b                	jmp    802d89 <free_block+0x214>
  802d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8c:	8b 40 04             	mov    0x4(%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 0f                	je     802da2 <free_block+0x22d>
  802d93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d9c:	8b 12                	mov    (%edx),%edx
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	eb 0a                	jmp    802dac <free_block+0x237>
  802da2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	a3 48 40 98 00       	mov    %eax,0x984048
  802dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802daf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dbf:	a1 54 40 98 00       	mov    0x984054,%eax
  802dc4:	48                   	dec    %eax
  802dc5:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802dca:	eb 24                	jmp    802df0 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	6a 00                	push   $0x0
  802dd1:	ff 75 f4             	pushl  -0xc(%ebp)
  802dd4:	ff 75 08             	pushl  0x8(%ebp)
  802dd7:	e8 e6 f4 ff ff       	call   8022c2 <set_block_data>
  802ddc:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802ddf:	83 ec 0c             	sub    $0xc,%esp
  802de2:	ff 75 08             	pushl  0x8(%ebp)
  802de5:	e8 2f f5 ff ff       	call   802319 <insert_sorted_in_freeList>
  802dea:	83 c4 10             	add    $0x10,%esp
  802ded:	eb 01                	jmp    802df0 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802def:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802df0:	c9                   	leave  
  802df1:	c3                   	ret    

00802df2 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802df2:	55                   	push   %ebp
  802df3:	89 e5                	mov    %esp,%ebp
  802df5:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802df8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfc:	75 10                	jne    802e0e <realloc_block_FF+0x1c>
  802dfe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e02:	75 0a                	jne    802e0e <realloc_block_FF+0x1c>
	{
		return NULL;
  802e04:	b8 00 00 00 00       	mov    $0x0,%eax
  802e09:	e9 8b 04 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802e0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802e12:	75 18                	jne    802e2c <realloc_block_FF+0x3a>
	{
		free_block(va);
  802e14:	83 ec 0c             	sub    $0xc,%esp
  802e17:	ff 75 08             	pushl  0x8(%ebp)
  802e1a:	e8 56 fd ff ff       	call   802b75 <free_block>
  802e1f:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802e22:	b8 00 00 00 00       	mov    $0x0,%eax
  802e27:	e9 6d 04 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e30:	75 13                	jne    802e45 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802e32:	83 ec 0c             	sub    $0xc,%esp
  802e35:	ff 75 0c             	pushl  0xc(%ebp)
  802e38:	e8 6f f6 ff ff       	call   8024ac <alloc_block_FF>
  802e3d:	83 c4 10             	add    $0x10,%esp
  802e40:	e9 54 04 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e48:	83 e0 01             	and    $0x1,%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 03                	je     802e52 <realloc_block_FF+0x60>
	{
		new_size++;
  802e4f:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802e52:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802e56:	77 07                	ja     802e5f <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802e58:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802e5f:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802e63:	83 ec 0c             	sub    $0xc,%esp
  802e66:	ff 75 08             	pushl  0x8(%ebp)
  802e69:	e8 d8 f1 ff ff       	call   802046 <get_block_size>
  802e6e:	83 c4 10             	add    $0x10,%esp
  802e71:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e7a:	75 08                	jne    802e84 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	e9 15 04 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802e84:	8b 55 08             	mov    0x8(%ebp),%edx
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	01 d0                	add    %edx,%eax
  802e8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802e8f:	83 ec 0c             	sub    $0xc,%esp
  802e92:	ff 75 f0             	pushl  -0x10(%ebp)
  802e95:	e8 c5 f1 ff ff       	call   80205f <is_free_block>
  802e9a:	83 c4 10             	add    $0x10,%esp
  802e9d:	0f be c0             	movsbl %al,%eax
  802ea0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802ea3:	83 ec 0c             	sub    $0xc,%esp
  802ea6:	ff 75 f0             	pushl  -0x10(%ebp)
  802ea9:	e8 98 f1 ff ff       	call   802046 <get_block_size>
  802eae:	83 c4 10             	add    $0x10,%esp
  802eb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802eb7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802eba:	0f 86 a7 02 00 00    	jbe    803167 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802ec0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ec4:	0f 84 86 02 00 00    	je     803150 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802eca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	01 d0                	add    %edx,%eax
  802ed2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ed5:	0f 85 b2 00 00 00    	jne    802f8d <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802edb:	83 ec 0c             	sub    $0xc,%esp
  802ede:	ff 75 08             	pushl  0x8(%ebp)
  802ee1:	e8 79 f1 ff ff       	call   80205f <is_free_block>
  802ee6:	83 c4 10             	add    $0x10,%esp
  802ee9:	84 c0                	test   %al,%al
  802eeb:	0f 94 c0             	sete   %al
  802eee:	0f b6 c0             	movzbl %al,%eax
  802ef1:	83 ec 04             	sub    $0x4,%esp
  802ef4:	50                   	push   %eax
  802ef5:	ff 75 0c             	pushl  0xc(%ebp)
  802ef8:	ff 75 08             	pushl  0x8(%ebp)
  802efb:	e8 c2 f3 ff ff       	call   8022c2 <set_block_data>
  802f00:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f07:	75 17                	jne    802f20 <realloc_block_FF+0x12e>
  802f09:	83 ec 04             	sub    $0x4,%esp
  802f0c:	68 c0 3e 80 00       	push   $0x803ec0
  802f11:	68 db 01 00 00       	push   $0x1db
  802f16:	68 17 3e 80 00       	push   $0x803e17
  802f1b:	e8 67 d3 ff ff       	call   800287 <_panic>
  802f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 10                	je     802f39 <realloc_block_FF+0x147>
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f31:	8b 52 04             	mov    0x4(%edx),%edx
  802f34:	89 50 04             	mov    %edx,0x4(%eax)
  802f37:	eb 0b                	jmp    802f44 <realloc_block_FF+0x152>
  802f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f47:	8b 40 04             	mov    0x4(%eax),%eax
  802f4a:	85 c0                	test   %eax,%eax
  802f4c:	74 0f                	je     802f5d <realloc_block_FF+0x16b>
  802f4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f57:	8b 12                	mov    (%edx),%edx
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	eb 0a                	jmp    802f67 <realloc_block_FF+0x175>
  802f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	a3 48 40 98 00       	mov    %eax,0x984048
  802f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7a:	a1 54 40 98 00       	mov    0x984054,%eax
  802f7f:	48                   	dec    %eax
  802f80:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	e9 0c 03 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802f8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	01 d0                	add    %edx,%eax
  802f95:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f98:	0f 86 b2 01 00 00    	jbe    803150 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa1:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802fa4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802fad:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802fb0:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802fb4:	0f 87 b8 00 00 00    	ja     803072 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802fba:	83 ec 0c             	sub    $0xc,%esp
  802fbd:	ff 75 08             	pushl  0x8(%ebp)
  802fc0:	e8 9a f0 ff ff       	call   80205f <is_free_block>
  802fc5:	83 c4 10             	add    $0x10,%esp
  802fc8:	84 c0                	test   %al,%al
  802fca:	0f 94 c0             	sete   %al
  802fcd:	0f b6 c0             	movzbl %al,%eax
  802fd0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802fd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fd6:	01 ca                	add    %ecx,%edx
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	50                   	push   %eax
  802fdc:	52                   	push   %edx
  802fdd:	ff 75 08             	pushl  0x8(%ebp)
  802fe0:	e8 dd f2 ff ff       	call   8022c2 <set_block_data>
  802fe5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802fe8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fec:	75 17                	jne    803005 <realloc_block_FF+0x213>
  802fee:	83 ec 04             	sub    $0x4,%esp
  802ff1:	68 c0 3e 80 00       	push   $0x803ec0
  802ff6:	68 e8 01 00 00       	push   $0x1e8
  802ffb:	68 17 3e 80 00       	push   $0x803e17
  803000:	e8 82 d2 ff ff       	call   800287 <_panic>
  803005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	85 c0                	test   %eax,%eax
  80300c:	74 10                	je     80301e <realloc_block_FF+0x22c>
  80300e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803016:	8b 52 04             	mov    0x4(%edx),%edx
  803019:	89 50 04             	mov    %edx,0x4(%eax)
  80301c:	eb 0b                	jmp    803029 <realloc_block_FF+0x237>
  80301e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803021:	8b 40 04             	mov    0x4(%eax),%eax
  803024:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	85 c0                	test   %eax,%eax
  803031:	74 0f                	je     803042 <realloc_block_FF+0x250>
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	8b 40 04             	mov    0x4(%eax),%eax
  803039:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80303c:	8b 12                	mov    (%edx),%edx
  80303e:	89 10                	mov    %edx,(%eax)
  803040:	eb 0a                	jmp    80304c <realloc_block_FF+0x25a>
  803042:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	a3 48 40 98 00       	mov    %eax,0x984048
  80304c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80304f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803055:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305f:	a1 54 40 98 00       	mov    0x984054,%eax
  803064:	48                   	dec    %eax
  803065:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  80306d:	e9 27 02 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803072:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803076:	75 17                	jne    80308f <realloc_block_FF+0x29d>
  803078:	83 ec 04             	sub    $0x4,%esp
  80307b:	68 c0 3e 80 00       	push   $0x803ec0
  803080:	68 ed 01 00 00       	push   $0x1ed
  803085:	68 17 3e 80 00       	push   $0x803e17
  80308a:	e8 f8 d1 ff ff       	call   800287 <_panic>
  80308f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 10                	je     8030a8 <realloc_block_FF+0x2b6>
  803098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309b:	8b 00                	mov    (%eax),%eax
  80309d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a0:	8b 52 04             	mov    0x4(%edx),%edx
  8030a3:	89 50 04             	mov    %edx,0x4(%eax)
  8030a6:	eb 0b                	jmp    8030b3 <realloc_block_FF+0x2c1>
  8030a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ab:	8b 40 04             	mov    0x4(%eax),%eax
  8030ae:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b6:	8b 40 04             	mov    0x4(%eax),%eax
  8030b9:	85 c0                	test   %eax,%eax
  8030bb:	74 0f                	je     8030cc <realloc_block_FF+0x2da>
  8030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c0:	8b 40 04             	mov    0x4(%eax),%eax
  8030c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c6:	8b 12                	mov    (%edx),%edx
  8030c8:	89 10                	mov    %edx,(%eax)
  8030ca:	eb 0a                	jmp    8030d6 <realloc_block_FF+0x2e4>
  8030cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cf:	8b 00                	mov    (%eax),%eax
  8030d1:	a3 48 40 98 00       	mov    %eax,0x984048
  8030d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e9:	a1 54 40 98 00       	mov    0x984054,%eax
  8030ee:	48                   	dec    %eax
  8030ef:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8030f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fa:	01 d0                	add    %edx,%eax
  8030fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8030ff:	83 ec 04             	sub    $0x4,%esp
  803102:	6a 00                	push   $0x0
  803104:	ff 75 e0             	pushl  -0x20(%ebp)
  803107:	ff 75 f0             	pushl  -0x10(%ebp)
  80310a:	e8 b3 f1 ff ff       	call   8022c2 <set_block_data>
  80310f:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803112:	83 ec 0c             	sub    $0xc,%esp
  803115:	ff 75 08             	pushl  0x8(%ebp)
  803118:	e8 42 ef ff ff       	call   80205f <is_free_block>
  80311d:	83 c4 10             	add    $0x10,%esp
  803120:	84 c0                	test   %al,%al
  803122:	0f 94 c0             	sete   %al
  803125:	0f b6 c0             	movzbl %al,%eax
  803128:	83 ec 04             	sub    $0x4,%esp
  80312b:	50                   	push   %eax
  80312c:	ff 75 0c             	pushl  0xc(%ebp)
  80312f:	ff 75 08             	pushl  0x8(%ebp)
  803132:	e8 8b f1 ff ff       	call   8022c2 <set_block_data>
  803137:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80313a:	83 ec 0c             	sub    $0xc,%esp
  80313d:	ff 75 f0             	pushl  -0x10(%ebp)
  803140:	e8 d4 f1 ff ff       	call   802319 <insert_sorted_in_freeList>
  803145:	83 c4 10             	add    $0x10,%esp
					return va;
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	e9 49 01 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803150:	8b 45 0c             	mov    0xc(%ebp),%eax
  803153:	83 e8 08             	sub    $0x8,%eax
  803156:	83 ec 0c             	sub    $0xc,%esp
  803159:	50                   	push   %eax
  80315a:	e8 4d f3 ff ff       	call   8024ac <alloc_block_FF>
  80315f:	83 c4 10             	add    $0x10,%esp
  803162:	e9 32 01 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80316a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80316d:	0f 83 21 01 00 00    	jae    803294 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803176:	2b 45 0c             	sub    0xc(%ebp),%eax
  803179:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80317c:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803180:	77 0e                	ja     803190 <realloc_block_FF+0x39e>
  803182:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803186:	75 08                	jne    803190 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	e9 09 01 00 00       	jmp    803299 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803190:	8b 45 08             	mov    0x8(%ebp),%eax
  803193:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803196:	83 ec 0c             	sub    $0xc,%esp
  803199:	ff 75 08             	pushl  0x8(%ebp)
  80319c:	e8 be ee ff ff       	call   80205f <is_free_block>
  8031a1:	83 c4 10             	add    $0x10,%esp
  8031a4:	84 c0                	test   %al,%al
  8031a6:	0f 94 c0             	sete   %al
  8031a9:	0f b6 c0             	movzbl %al,%eax
  8031ac:	83 ec 04             	sub    $0x4,%esp
  8031af:	50                   	push   %eax
  8031b0:	ff 75 0c             	pushl  0xc(%ebp)
  8031b3:	ff 75 d8             	pushl  -0x28(%ebp)
  8031b6:	e8 07 f1 ff ff       	call   8022c2 <set_block_data>
  8031bb:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8031be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8031c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031c4:	01 d0                	add    %edx,%eax
  8031c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8031c9:	83 ec 04             	sub    $0x4,%esp
  8031cc:	6a 00                	push   $0x0
  8031ce:	ff 75 dc             	pushl  -0x24(%ebp)
  8031d1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031d4:	e8 e9 f0 ff ff       	call   8022c2 <set_block_data>
  8031d9:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8031dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031e0:	0f 84 9b 00 00 00    	je     803281 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8031e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ec:	01 d0                	add    %edx,%eax
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	6a 00                	push   $0x0
  8031f3:	50                   	push   %eax
  8031f4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031f7:	e8 c6 f0 ff ff       	call   8022c2 <set_block_data>
  8031fc:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8031ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803203:	75 17                	jne    80321c <realloc_block_FF+0x42a>
  803205:	83 ec 04             	sub    $0x4,%esp
  803208:	68 c0 3e 80 00       	push   $0x803ec0
  80320d:	68 10 02 00 00       	push   $0x210
  803212:	68 17 3e 80 00       	push   $0x803e17
  803217:	e8 6b d0 ff ff       	call   800287 <_panic>
  80321c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321f:	8b 00                	mov    (%eax),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	74 10                	je     803235 <realloc_block_FF+0x443>
  803225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80322d:	8b 52 04             	mov    0x4(%edx),%edx
  803230:	89 50 04             	mov    %edx,0x4(%eax)
  803233:	eb 0b                	jmp    803240 <realloc_block_FF+0x44e>
  803235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803238:	8b 40 04             	mov    0x4(%eax),%eax
  80323b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803243:	8b 40 04             	mov    0x4(%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	74 0f                	je     803259 <realloc_block_FF+0x467>
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	8b 40 04             	mov    0x4(%eax),%eax
  803250:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803253:	8b 12                	mov    (%edx),%edx
  803255:	89 10                	mov    %edx,(%eax)
  803257:	eb 0a                	jmp    803263 <realloc_block_FF+0x471>
  803259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325c:	8b 00                	mov    (%eax),%eax
  80325e:	a3 48 40 98 00       	mov    %eax,0x984048
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803276:	a1 54 40 98 00       	mov    0x984054,%eax
  80327b:	48                   	dec    %eax
  80327c:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  803281:	83 ec 0c             	sub    $0xc,%esp
  803284:	ff 75 d4             	pushl  -0x2c(%ebp)
  803287:	e8 8d f0 ff ff       	call   802319 <insert_sorted_in_freeList>
  80328c:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80328f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803292:	eb 05                	jmp    803299 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803294:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803299:	c9                   	leave  
  80329a:	c3                   	ret    

0080329b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80329b:	55                   	push   %ebp
  80329c:	89 e5                	mov    %esp,%ebp
  80329e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8032a1:	83 ec 04             	sub    $0x4,%esp
  8032a4:	68 e0 3e 80 00       	push   $0x803ee0
  8032a9:	68 20 02 00 00       	push   $0x220
  8032ae:	68 17 3e 80 00       	push   $0x803e17
  8032b3:	e8 cf cf ff ff       	call   800287 <_panic>

008032b8 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8032b8:	55                   	push   %ebp
  8032b9:	89 e5                	mov    %esp,%ebp
  8032bb:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	68 08 3f 80 00       	push   $0x803f08
  8032c6:	68 28 02 00 00       	push   $0x228
  8032cb:	68 17 3e 80 00       	push   $0x803e17
  8032d0:	e8 b2 cf ff ff       	call   800287 <_panic>

008032d5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032d5:	55                   	push   %ebp
  8032d6:	89 e5                	mov    %esp,%ebp
  8032d8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032db:	8b 55 08             	mov    0x8(%ebp),%edx
  8032de:	89 d0                	mov    %edx,%eax
  8032e0:	c1 e0 02             	shl    $0x2,%eax
  8032e3:	01 d0                	add    %edx,%eax
  8032e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ec:	01 d0                	add    %edx,%eax
  8032ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f5:	01 d0                	add    %edx,%eax
  8032f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032fe:	01 d0                	add    %edx,%eax
  803300:	c1 e0 04             	shl    $0x4,%eax
  803303:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80330d:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803310:	83 ec 0c             	sub    $0xc,%esp
  803313:	50                   	push   %eax
  803314:	e8 c5 e9 ff ff       	call   801cde <sys_get_virtual_time>
  803319:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80331c:	eb 41                	jmp    80335f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80331e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803321:	83 ec 0c             	sub    $0xc,%esp
  803324:	50                   	push   %eax
  803325:	e8 b4 e9 ff ff       	call   801cde <sys_get_virtual_time>
  80332a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80332d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803333:	29 c2                	sub    %eax,%edx
  803335:	89 d0                	mov    %edx,%eax
  803337:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80333a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80333d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803340:	89 d1                	mov    %edx,%ecx
  803342:	29 c1                	sub    %eax,%ecx
  803344:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803347:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80334a:	39 c2                	cmp    %eax,%edx
  80334c:	0f 97 c0             	seta   %al
  80334f:	0f b6 c0             	movzbl %al,%eax
  803352:	29 c1                	sub    %eax,%ecx
  803354:	89 c8                	mov    %ecx,%eax
  803356:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803359:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80335c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803365:	72 b7                	jb     80331e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803367:	90                   	nop
  803368:	c9                   	leave  
  803369:	c3                   	ret    

0080336a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80336a:	55                   	push   %ebp
  80336b:	89 e5                	mov    %esp,%ebp
  80336d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803370:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803377:	eb 03                	jmp    80337c <busy_wait+0x12>
  803379:	ff 45 fc             	incl   -0x4(%ebp)
  80337c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80337f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803382:	72 f5                	jb     803379 <busy_wait+0xf>
	return i;
  803384:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803387:	c9                   	leave  
  803388:	c3                   	ret    
  803389:	66 90                	xchg   %ax,%ax
  80338b:	90                   	nop

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
