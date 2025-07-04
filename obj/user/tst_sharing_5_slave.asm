
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 dc 00 00 00       	call   800112 <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  800065:	68 20 35 80 00       	push   $0x803520
  80006a:	6a 0e                	push   $0xe
  80006c:	68 3c 35 80 00       	push   $0x80353c
  800071:	e8 e1 01 00 00       	call   800257 <_panic>
#else
	panic("make sure to enable the kernel heap: USE_KHEAP=1");
#endif
	/*=================================================*/

	uint32 pagealloc_start = USER_HEAP_START + DYN_ALLOC_MAX_SIZE + PAGE_SIZE; //UHS + 32MB + 4KB
  800076:	c7 45 f4 00 10 00 82 	movl   $0x82001000,-0xc(%ebp)
	uint32 *x, *y, *z ;
	int freeFrames, diff, expected;
sys_lock_cons();
  80007d:	e8 64 19 00 00       	call   8019e6 <sys_lock_cons>
	x = sget(sys_getparentenvid(),"x");
  800082:	e8 f4 1b 00 00       	call   801c7b <sys_getparentenvid>
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 57 35 80 00       	push   $0x803557
  80008f:	50                   	push   %eax
  800090:	e8 81 16 00 00       	call   801716 <sget>
  800095:	83 c4 10             	add    $0x10,%esp
  800098:	89 45 f0             	mov    %eax,-0x10(%ebp)

	freeFrames = sys_calculate_free_frames() ;
  80009b:	e8 f9 19 00 00       	call   801a99 <sys_calculate_free_frames>
  8000a0:	89 45 ec             	mov    %eax,-0x14(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000a3:	83 ec 0c             	sub    $0xc,%esp
  8000a6:	68 5c 35 80 00       	push   $0x80355c
  8000ab:	e8 64 04 00 00       	call   800514 <cprintf>
  8000b0:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b9:	e8 ef 17 00 00       	call   8018ad <sfree>
  8000be:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave env removed x\n");
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 80 35 80 00       	push   $0x803580
  8000c9:	e8 46 04 00 00       	call   800514 <cprintf>
  8000ce:	83 c4 10             	add    $0x10,%esp

	diff = (sys_calculate_free_frames() - freeFrames);
  8000d1:	e8 c3 19 00 00       	call   801a99 <sys_calculate_free_frames>
  8000d6:	89 c2                	mov    %eax,%edx
  8000d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000db:	29 c2                	sub    %eax,%edx
  8000dd:	89 d0                	mov    %edx,%eax
  8000df:	89 45 e8             	mov    %eax,-0x18(%ebp)
sys_unlock_cons();
  8000e2:	e8 19 19 00 00       	call   801a00 <sys_unlock_cons>
	expected = 1;
  8000e7:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000f4:	74 14                	je     80010a <_main+0xd2>
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	68 98 35 80 00       	push   $0x803598
  8000fe:	6a 26                	push   $0x26
  800100:	68 3c 35 80 00       	push   $0x80353c
  800105:	e8 4d 01 00 00       	call   800257 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80010a:	e8 91 1c 00 00       	call   801da0 <inctst>

	return;
  80010f:	90                   	nop
}
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800118:	e8 45 1b 00 00       	call   801c62 <sys_getenvindex>
  80011d:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800120:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800123:	89 d0                	mov    %edx,%eax
  800125:	c1 e0 02             	shl    $0x2,%eax
  800128:	01 d0                	add    %edx,%eax
  80012a:	c1 e0 03             	shl    $0x3,%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800136:	01 d0                	add    %edx,%eax
  800138:	c1 e0 02             	shl    $0x2,%eax
  80013b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800140:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800145:	a1 20 40 80 00       	mov    0x804020,%eax
  80014a:	8a 40 20             	mov    0x20(%eax),%al
  80014d:	84 c0                	test   %al,%al
  80014f:	74 0d                	je     80015e <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	83 c0 20             	add    $0x20,%eax
  800159:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80015e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800162:	7e 0a                	jle    80016e <libmain+0x5c>
		binaryname = argv[0];
  800164:	8b 45 0c             	mov    0xc(%ebp),%eax
  800167:	8b 00                	mov    (%eax),%eax
  800169:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	ff 75 0c             	pushl  0xc(%ebp)
  800174:	ff 75 08             	pushl  0x8(%ebp)
  800177:	e8 bc fe ff ff       	call   800038 <_main>
  80017c:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80017f:	a1 00 40 80 00       	mov    0x804000,%eax
  800184:	85 c0                	test   %eax,%eax
  800186:	0f 84 9f 00 00 00    	je     80022b <libmain+0x119>
	{
		sys_lock_cons();
  80018c:	e8 55 18 00 00       	call   8019e6 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	68 3c 36 80 00       	push   $0x80363c
  800199:	e8 76 03 00 00       	call   800514 <cprintf>
  80019e:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a6:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001b7:	83 ec 04             	sub    $0x4,%esp
  8001ba:	52                   	push   %edx
  8001bb:	50                   	push   %eax
  8001bc:	68 64 36 80 00       	push   $0x803664
  8001c1:	e8 4e 03 00 00       	call   800514 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001df:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e4:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001ea:	51                   	push   %ecx
  8001eb:	52                   	push   %edx
  8001ec:	50                   	push   %eax
  8001ed:	68 8c 36 80 00       	push   $0x80368c
  8001f2:	e8 1d 03 00 00       	call   800514 <cprintf>
  8001f7:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ff:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800205:	83 ec 08             	sub    $0x8,%esp
  800208:	50                   	push   %eax
  800209:	68 e4 36 80 00       	push   $0x8036e4
  80020e:	e8 01 03 00 00       	call   800514 <cprintf>
  800213:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 3c 36 80 00       	push   $0x80363c
  80021e:	e8 f1 02 00 00       	call   800514 <cprintf>
  800223:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800226:	e8 d5 17 00 00       	call   801a00 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80022b:	e8 19 00 00 00       	call   800249 <exit>
}
  800230:	90                   	nop
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800239:	83 ec 0c             	sub    $0xc,%esp
  80023c:	6a 00                	push   $0x0
  80023e:	e8 eb 19 00 00       	call   801c2e <sys_destroy_env>
  800243:	83 c4 10             	add    $0x10,%esp
}
  800246:	90                   	nop
  800247:	c9                   	leave  
  800248:	c3                   	ret    

00800249 <exit>:

void
exit(void)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80024f:	e8 40 1a 00 00       	call   801c94 <sys_exit_env>
}
  800254:	90                   	nop
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80025d:	8d 45 10             	lea    0x10(%ebp),%eax
  800260:	83 c0 04             	add    $0x4,%eax
  800263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800266:	a1 60 40 98 00       	mov    0x984060,%eax
  80026b:	85 c0                	test   %eax,%eax
  80026d:	74 16                	je     800285 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80026f:	a1 60 40 98 00       	mov    0x984060,%eax
  800274:	83 ec 08             	sub    $0x8,%esp
  800277:	50                   	push   %eax
  800278:	68 f8 36 80 00       	push   $0x8036f8
  80027d:	e8 92 02 00 00       	call   800514 <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800285:	a1 04 40 80 00       	mov    0x804004,%eax
  80028a:	ff 75 0c             	pushl  0xc(%ebp)
  80028d:	ff 75 08             	pushl  0x8(%ebp)
  800290:	50                   	push   %eax
  800291:	68 fd 36 80 00       	push   $0x8036fd
  800296:	e8 79 02 00 00       	call   800514 <cprintf>
  80029b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80029e:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002a7:	50                   	push   %eax
  8002a8:	e8 fc 01 00 00       	call   8004a9 <vcprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b0:	83 ec 08             	sub    $0x8,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	68 19 37 80 00       	push   $0x803719
  8002ba:	e8 ea 01 00 00       	call   8004a9 <vcprintf>
  8002bf:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c2:	e8 82 ff ff ff       	call   800249 <exit>

	// should not return here
	while (1) ;
  8002c7:	eb fe                	jmp    8002c7 <_panic+0x70>

008002c9 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	74 14                	je     8002f5 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e1:	83 ec 04             	sub    $0x4,%esp
  8002e4:	68 1c 37 80 00       	push   $0x80371c
  8002e9:	6a 26                	push   $0x26
  8002eb:	68 68 37 80 00       	push   $0x803768
  8002f0:	e8 62 ff ff ff       	call   800257 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800303:	e9 c5 00 00 00       	jmp    8003cd <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	01 d0                	add    %edx,%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	85 c0                	test   %eax,%eax
  80031b:	75 08                	jne    800325 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80031d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800320:	e9 a5 00 00 00       	jmp    8003ca <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800325:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800333:	eb 69                	jmp    80039e <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800335:	a1 20 40 80 00       	mov    0x804020,%eax
  80033a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800340:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800343:	89 d0                	mov    %edx,%eax
  800345:	01 c0                	add    %eax,%eax
  800347:	01 d0                	add    %edx,%eax
  800349:	c1 e0 03             	shl    $0x3,%eax
  80034c:	01 c8                	add    %ecx,%eax
  80034e:	8a 40 04             	mov    0x4(%eax),%al
  800351:	84 c0                	test   %al,%al
  800353:	75 46                	jne    80039b <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800355:	a1 20 40 80 00       	mov    0x804020,%eax
  80035a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800360:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800363:	89 d0                	mov    %edx,%eax
  800365:	01 c0                	add    %eax,%eax
  800367:	01 d0                	add    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 c8                	add    %ecx,%eax
  80036e:	8b 00                	mov    (%eax),%eax
  800370:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800373:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800376:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800380:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c8                	add    %ecx,%eax
  80038c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038e:	39 c2                	cmp    %eax,%edx
  800390:	75 09                	jne    80039b <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800392:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800399:	eb 15                	jmp    8003b0 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039b:	ff 45 e8             	incl   -0x18(%ebp)
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ac:	39 c2                	cmp    %eax,%edx
  8003ae:	77 85                	ja     800335 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b4:	75 14                	jne    8003ca <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	68 74 37 80 00       	push   $0x803774
  8003be:	6a 3a                	push   $0x3a
  8003c0:	68 68 37 80 00       	push   $0x803768
  8003c5:	e8 8d fe ff ff       	call   800257 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ca:	ff 45 f0             	incl   -0x10(%ebp)
  8003cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d3:	0f 8c 2f ff ff ff    	jl     800308 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e7:	eb 26                	jmp    80040f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ee:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003f4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f7:	89 d0                	mov    %edx,%eax
  8003f9:	01 c0                	add    %eax,%eax
  8003fb:	01 d0                	add    %edx,%eax
  8003fd:	c1 e0 03             	shl    $0x3,%eax
  800400:	01 c8                	add    %ecx,%eax
  800402:	8a 40 04             	mov    0x4(%eax),%al
  800405:	3c 01                	cmp    $0x1,%al
  800407:	75 03                	jne    80040c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800409:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040c:	ff 45 e0             	incl   -0x20(%ebp)
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80041a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 c8                	ja     8003e9 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800424:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800427:	74 14                	je     80043d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800429:	83 ec 04             	sub    $0x4,%esp
  80042c:	68 c8 37 80 00       	push   $0x8037c8
  800431:	6a 44                	push   $0x44
  800433:	68 68 37 80 00       	push   $0x803768
  800438:	e8 1a fe ff ff       	call   800257 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80043d:	90                   	nop
  80043e:	c9                   	leave  
  80043f:	c3                   	ret    

00800440 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800446:	8b 45 0c             	mov    0xc(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	8d 48 01             	lea    0x1(%eax),%ecx
  80044e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800451:	89 0a                	mov    %ecx,(%edx)
  800453:	8b 55 08             	mov    0x8(%ebp),%edx
  800456:	88 d1                	mov    %dl,%cl
  800458:	8b 55 0c             	mov    0xc(%ebp),%edx
  80045b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	3d ff 00 00 00       	cmp    $0xff,%eax
  800469:	75 2c                	jne    800497 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80046b:	a0 44 40 98 00       	mov    0x984044,%al
  800470:	0f b6 c0             	movzbl %al,%eax
  800473:	8b 55 0c             	mov    0xc(%ebp),%edx
  800476:	8b 12                	mov    (%edx),%edx
  800478:	89 d1                	mov    %edx,%ecx
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	83 c2 08             	add    $0x8,%edx
  800480:	83 ec 04             	sub    $0x4,%esp
  800483:	50                   	push   %eax
  800484:	51                   	push   %ecx
  800485:	52                   	push   %edx
  800486:	e8 19 15 00 00       	call   8019a4 <sys_cputs>
  80048b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80048e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800491:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049a:	8b 40 04             	mov    0x4(%eax),%eax
  80049d:	8d 50 01             	lea    0x1(%eax),%edx
  8004a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a6:	90                   	nop
  8004a7:	c9                   	leave  
  8004a8:	c3                   	ret    

008004a9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a9:	55                   	push   %ebp
  8004aa:	89 e5                	mov    %esp,%ebp
  8004ac:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004b2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b9:	00 00 00 
	b.cnt = 0;
  8004bc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004c3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c6:	ff 75 0c             	pushl  0xc(%ebp)
  8004c9:	ff 75 08             	pushl  0x8(%ebp)
  8004cc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004d2:	50                   	push   %eax
  8004d3:	68 40 04 80 00       	push   $0x800440
  8004d8:	e8 11 02 00 00       	call   8006ee <vprintfmt>
  8004dd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004e0:	a0 44 40 98 00       	mov    0x984044,%al
  8004e5:	0f b6 c0             	movzbl %al,%eax
  8004e8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	52                   	push   %edx
  8004f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f9:	83 c0 08             	add    $0x8,%eax
  8004fc:	50                   	push   %eax
  8004fd:	e8 a2 14 00 00       	call   8019a4 <sys_cputs>
  800502:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800505:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
	return b.cnt;
  80050c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800512:	c9                   	leave  
  800513:	c3                   	ret    

00800514 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
  800517:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80051a:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
	va_start(ap, fmt);
  800521:	8d 45 0c             	lea    0xc(%ebp),%eax
  800524:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	83 ec 08             	sub    $0x8,%esp
  80052d:	ff 75 f4             	pushl  -0xc(%ebp)
  800530:	50                   	push   %eax
  800531:	e8 73 ff ff ff       	call   8004a9 <vcprintf>
  800536:	83 c4 10             	add    $0x10,%esp
  800539:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80053c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053f:	c9                   	leave  
  800540:	c3                   	ret    

00800541 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800541:	55                   	push   %ebp
  800542:	89 e5                	mov    %esp,%ebp
  800544:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800547:	e8 9a 14 00 00       	call   8019e6 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80054c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800552:	8b 45 08             	mov    0x8(%ebp),%eax
  800555:	83 ec 08             	sub    $0x8,%esp
  800558:	ff 75 f4             	pushl  -0xc(%ebp)
  80055b:	50                   	push   %eax
  80055c:	e8 48 ff ff ff       	call   8004a9 <vcprintf>
  800561:	83 c4 10             	add    $0x10,%esp
  800564:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800567:	e8 94 14 00 00       	call   801a00 <sys_unlock_cons>
	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	53                   	push   %ebx
  800575:	83 ec 14             	sub    $0x14,%esp
  800578:	8b 45 10             	mov    0x10(%ebp),%eax
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800584:	8b 45 18             	mov    0x18(%ebp),%eax
  800587:	ba 00 00 00 00       	mov    $0x0,%edx
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	77 55                	ja     8005e6 <printnum+0x75>
  800591:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800594:	72 05                	jb     80059b <printnum+0x2a>
  800596:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800599:	77 4b                	ja     8005e6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80059b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80059e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005a1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a9:	52                   	push   %edx
  8005aa:	50                   	push   %eax
  8005ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ae:	ff 75 f0             	pushl  -0x10(%ebp)
  8005b1:	e8 f2 2c 00 00       	call   8032a8 <__udivdi3>
  8005b6:	83 c4 10             	add    $0x10,%esp
  8005b9:	83 ec 04             	sub    $0x4,%esp
  8005bc:	ff 75 20             	pushl  0x20(%ebp)
  8005bf:	53                   	push   %ebx
  8005c0:	ff 75 18             	pushl  0x18(%ebp)
  8005c3:	52                   	push   %edx
  8005c4:	50                   	push   %eax
  8005c5:	ff 75 0c             	pushl  0xc(%ebp)
  8005c8:	ff 75 08             	pushl  0x8(%ebp)
  8005cb:	e8 a1 ff ff ff       	call   800571 <printnum>
  8005d0:	83 c4 20             	add    $0x20,%esp
  8005d3:	eb 1a                	jmp    8005ef <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	ff 75 0c             	pushl  0xc(%ebp)
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	ff d0                	call   *%eax
  8005e3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e6:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005ed:	7f e6                	jg     8005d5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ef:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fd:	53                   	push   %ebx
  8005fe:	51                   	push   %ecx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	e8 b2 2d 00 00       	call   8033b8 <__umoddi3>
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	05 34 3a 80 00       	add    $0x803a34,%eax
  80060e:	8a 00                	mov    (%eax),%al
  800610:	0f be c0             	movsbl %al,%eax
  800613:	83 ec 08             	sub    $0x8,%esp
  800616:	ff 75 0c             	pushl  0xc(%ebp)
  800619:	50                   	push   %eax
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	ff d0                	call   *%eax
  80061f:	83 c4 10             	add    $0x10,%esp
}
  800622:	90                   	nop
  800623:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800626:	c9                   	leave  
  800627:	c3                   	ret    

00800628 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800628:	55                   	push   %ebp
  800629:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80062b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062f:	7e 1c                	jle    80064d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	8d 50 08             	lea    0x8(%eax),%edx
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	89 10                	mov    %edx,(%eax)
  80063e:	8b 45 08             	mov    0x8(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	83 e8 08             	sub    $0x8,%eax
  800646:	8b 50 04             	mov    0x4(%eax),%edx
  800649:	8b 00                	mov    (%eax),%eax
  80064b:	eb 40                	jmp    80068d <getuint+0x65>
	else if (lflag)
  80064d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800651:	74 1e                	je     800671 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 04             	lea    0x4(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 04             	sub    $0x4,%eax
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	eb 1c                	jmp    80068d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	8d 50 04             	lea    0x4(%eax),%edx
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	89 10                	mov    %edx,(%eax)
  80067e:	8b 45 08             	mov    0x8(%ebp),%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	83 e8 04             	sub    $0x4,%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80068d:	5d                   	pop    %ebp
  80068e:	c3                   	ret    

0080068f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800692:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800696:	7e 1c                	jle    8006b4 <getint+0x25>
		return va_arg(*ap, long long);
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	8d 50 08             	lea    0x8(%eax),%edx
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	89 10                	mov    %edx,(%eax)
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	83 e8 08             	sub    $0x8,%eax
  8006ad:	8b 50 04             	mov    0x4(%eax),%edx
  8006b0:	8b 00                	mov    (%eax),%eax
  8006b2:	eb 38                	jmp    8006ec <getint+0x5d>
	else if (lflag)
  8006b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b8:	74 1a                	je     8006d4 <getint+0x45>
		return va_arg(*ap, long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 04             	lea    0x4(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 04             	sub    $0x4,%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	99                   	cltd   
  8006d2:	eb 18                	jmp    8006ec <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	8d 50 04             	lea    0x4(%eax),%edx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	89 10                	mov    %edx,(%eax)
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	83 e8 04             	sub    $0x4,%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	99                   	cltd   
}
  8006ec:	5d                   	pop    %ebp
  8006ed:	c3                   	ret    

008006ee <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
  8006f1:	56                   	push   %esi
  8006f2:	53                   	push   %ebx
  8006f3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f6:	eb 17                	jmp    80070f <vprintfmt+0x21>
			if (ch == '\0')
  8006f8:	85 db                	test   %ebx,%ebx
  8006fa:	0f 84 c1 03 00 00    	je     800ac1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	53                   	push   %ebx
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	ff d0                	call   *%eax
  80070c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070f:	8b 45 10             	mov    0x10(%ebp),%eax
  800712:	8d 50 01             	lea    0x1(%eax),%edx
  800715:	89 55 10             	mov    %edx,0x10(%ebp)
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f b6 d8             	movzbl %al,%ebx
  80071d:	83 fb 25             	cmp    $0x25,%ebx
  800720:	75 d6                	jne    8006f8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800722:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800726:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80072d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800734:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80073b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800742:	8b 45 10             	mov    0x10(%ebp),%eax
  800745:	8d 50 01             	lea    0x1(%eax),%edx
  800748:	89 55 10             	mov    %edx,0x10(%ebp)
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f b6 d8             	movzbl %al,%ebx
  800750:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800753:	83 f8 5b             	cmp    $0x5b,%eax
  800756:	0f 87 3d 03 00 00    	ja     800a99 <vprintfmt+0x3ab>
  80075c:	8b 04 85 58 3a 80 00 	mov    0x803a58(,%eax,4),%eax
  800763:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800765:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800769:	eb d7                	jmp    800742 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80076b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076f:	eb d1                	jmp    800742 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800771:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800778:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80077b:	89 d0                	mov    %edx,%eax
  80077d:	c1 e0 02             	shl    $0x2,%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	01 c0                	add    %eax,%eax
  800784:	01 d8                	add    %ebx,%eax
  800786:	83 e8 30             	sub    $0x30,%eax
  800789:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80078c:	8b 45 10             	mov    0x10(%ebp),%eax
  80078f:	8a 00                	mov    (%eax),%al
  800791:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800794:	83 fb 2f             	cmp    $0x2f,%ebx
  800797:	7e 3e                	jle    8007d7 <vprintfmt+0xe9>
  800799:	83 fb 39             	cmp    $0x39,%ebx
  80079c:	7f 39                	jg     8007d7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80079e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007a1:	eb d5                	jmp    800778 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	83 c0 04             	add    $0x4,%eax
  8007a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	83 e8 04             	sub    $0x4,%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b7:	eb 1f                	jmp    8007d8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007bd:	79 83                	jns    800742 <vprintfmt+0x54>
				width = 0;
  8007bf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c6:	e9 77 ff ff ff       	jmp    800742 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007cb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007d2:	e9 6b ff ff ff       	jmp    800742 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	0f 89 60 ff ff ff    	jns    800742 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ef:	e9 4e ff ff ff       	jmp    800742 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f7:	e9 46 ff ff ff       	jmp    800742 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	83 c0 04             	add    $0x4,%eax
  800802:	89 45 14             	mov    %eax,0x14(%ebp)
  800805:	8b 45 14             	mov    0x14(%ebp),%eax
  800808:	83 e8 04             	sub    $0x4,%eax
  80080b:	8b 00                	mov    (%eax),%eax
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	50                   	push   %eax
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	ff d0                	call   *%eax
  800819:	83 c4 10             	add    $0x10,%esp
			break;
  80081c:	e9 9b 02 00 00       	jmp    800abc <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800821:	8b 45 14             	mov    0x14(%ebp),%eax
  800824:	83 c0 04             	add    $0x4,%eax
  800827:	89 45 14             	mov    %eax,0x14(%ebp)
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	83 e8 04             	sub    $0x4,%eax
  800830:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800832:	85 db                	test   %ebx,%ebx
  800834:	79 02                	jns    800838 <vprintfmt+0x14a>
				err = -err;
  800836:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800838:	83 fb 64             	cmp    $0x64,%ebx
  80083b:	7f 0b                	jg     800848 <vprintfmt+0x15a>
  80083d:	8b 34 9d a0 38 80 00 	mov    0x8038a0(,%ebx,4),%esi
  800844:	85 f6                	test   %esi,%esi
  800846:	75 19                	jne    800861 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800848:	53                   	push   %ebx
  800849:	68 45 3a 80 00       	push   $0x803a45
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 08             	pushl  0x8(%ebp)
  800854:	e8 70 02 00 00       	call   800ac9 <printfmt>
  800859:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80085c:	e9 5b 02 00 00       	jmp    800abc <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800861:	56                   	push   %esi
  800862:	68 4e 3a 80 00       	push   $0x803a4e
  800867:	ff 75 0c             	pushl  0xc(%ebp)
  80086a:	ff 75 08             	pushl  0x8(%ebp)
  80086d:	e8 57 02 00 00       	call   800ac9 <printfmt>
  800872:	83 c4 10             	add    $0x10,%esp
			break;
  800875:	e9 42 02 00 00       	jmp    800abc <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80087a:	8b 45 14             	mov    0x14(%ebp),%eax
  80087d:	83 c0 04             	add    $0x4,%eax
  800880:	89 45 14             	mov    %eax,0x14(%ebp)
  800883:	8b 45 14             	mov    0x14(%ebp),%eax
  800886:	83 e8 04             	sub    $0x4,%eax
  800889:	8b 30                	mov    (%eax),%esi
  80088b:	85 f6                	test   %esi,%esi
  80088d:	75 05                	jne    800894 <vprintfmt+0x1a6>
				p = "(null)";
  80088f:	be 51 3a 80 00       	mov    $0x803a51,%esi
			if (width > 0 && padc != '-')
  800894:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800898:	7e 6d                	jle    800907 <vprintfmt+0x219>
  80089a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80089e:	74 67                	je     800907 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a3:	83 ec 08             	sub    $0x8,%esp
  8008a6:	50                   	push   %eax
  8008a7:	56                   	push   %esi
  8008a8:	e8 1e 03 00 00       	call   800bcb <strnlen>
  8008ad:	83 c4 10             	add    $0x10,%esp
  8008b0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008b3:	eb 16                	jmp    8008cb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	50                   	push   %eax
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	ff d0                	call   *%eax
  8008c5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cf:	7f e4                	jg     8008b5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008d1:	eb 34                	jmp    800907 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008d3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d7:	74 1c                	je     8008f5 <vprintfmt+0x207>
  8008d9:	83 fb 1f             	cmp    $0x1f,%ebx
  8008dc:	7e 05                	jle    8008e3 <vprintfmt+0x1f5>
  8008de:	83 fb 7e             	cmp    $0x7e,%ebx
  8008e1:	7e 12                	jle    8008f5 <vprintfmt+0x207>
					putch('?', putdat);
  8008e3:	83 ec 08             	sub    $0x8,%esp
  8008e6:	ff 75 0c             	pushl  0xc(%ebp)
  8008e9:	6a 3f                	push   $0x3f
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	ff d0                	call   *%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	eb 0f                	jmp    800904 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	ff 75 0c             	pushl  0xc(%ebp)
  8008fb:	53                   	push   %ebx
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800904:	ff 4d e4             	decl   -0x1c(%ebp)
  800907:	89 f0                	mov    %esi,%eax
  800909:	8d 70 01             	lea    0x1(%eax),%esi
  80090c:	8a 00                	mov    (%eax),%al
  80090e:	0f be d8             	movsbl %al,%ebx
  800911:	85 db                	test   %ebx,%ebx
  800913:	74 24                	je     800939 <vprintfmt+0x24b>
  800915:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800919:	78 b8                	js     8008d3 <vprintfmt+0x1e5>
  80091b:	ff 4d e0             	decl   -0x20(%ebp)
  80091e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800922:	79 af                	jns    8008d3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800924:	eb 13                	jmp    800939 <vprintfmt+0x24b>
				putch(' ', putdat);
  800926:	83 ec 08             	sub    $0x8,%esp
  800929:	ff 75 0c             	pushl  0xc(%ebp)
  80092c:	6a 20                	push   $0x20
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e7                	jg     800926 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093f:	e9 78 01 00 00       	jmp    800abc <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 e8             	pushl  -0x18(%ebp)
  80094a:	8d 45 14             	lea    0x14(%ebp),%eax
  80094d:	50                   	push   %eax
  80094e:	e8 3c fd ff ff       	call   80068f <getint>
  800953:	83 c4 10             	add    $0x10,%esp
  800956:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800959:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80095c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800962:	85 d2                	test   %edx,%edx
  800964:	79 23                	jns    800989 <vprintfmt+0x29b>
				putch('-', putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	6a 2d                	push   $0x2d
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	ff d0                	call   *%eax
  800973:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800979:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097c:	f7 d8                	neg    %eax
  80097e:	83 d2 00             	adc    $0x0,%edx
  800981:	f7 da                	neg    %edx
  800983:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800986:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800989:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800990:	e9 bc 00 00 00       	jmp    800a51 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800995:	83 ec 08             	sub    $0x8,%esp
  800998:	ff 75 e8             	pushl  -0x18(%ebp)
  80099b:	8d 45 14             	lea    0x14(%ebp),%eax
  80099e:	50                   	push   %eax
  80099f:	e8 84 fc ff ff       	call   800628 <getuint>
  8009a4:	83 c4 10             	add    $0x10,%esp
  8009a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b4:	e9 98 00 00 00       	jmp    800a51 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b9:	83 ec 08             	sub    $0x8,%esp
  8009bc:	ff 75 0c             	pushl  0xc(%ebp)
  8009bf:	6a 58                	push   $0x58
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	ff d0                	call   *%eax
  8009c6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c9:	83 ec 08             	sub    $0x8,%esp
  8009cc:	ff 75 0c             	pushl  0xc(%ebp)
  8009cf:	6a 58                	push   $0x58
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d9:	83 ec 08             	sub    $0x8,%esp
  8009dc:	ff 75 0c             	pushl  0xc(%ebp)
  8009df:	6a 58                	push   $0x58
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	ff d0                	call   *%eax
  8009e6:	83 c4 10             	add    $0x10,%esp
			break;
  8009e9:	e9 ce 00 00 00       	jmp    800abc <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ee:	83 ec 08             	sub    $0x8,%esp
  8009f1:	ff 75 0c             	pushl  0xc(%ebp)
  8009f4:	6a 30                	push   $0x30
  8009f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f9:	ff d0                	call   *%eax
  8009fb:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009fe:	83 ec 08             	sub    $0x8,%esp
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	6a 78                	push   $0x78
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a29:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a30:	eb 1f                	jmp    800a51 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 e8             	pushl  -0x18(%ebp)
  800a38:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3b:	50                   	push   %eax
  800a3c:	e8 e7 fb ff ff       	call   800628 <getuint>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a47:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a4a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a51:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a58:	83 ec 04             	sub    $0x4,%esp
  800a5b:	52                   	push   %edx
  800a5c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5f:	50                   	push   %eax
  800a60:	ff 75 f4             	pushl  -0xc(%ebp)
  800a63:	ff 75 f0             	pushl  -0x10(%ebp)
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	ff 75 08             	pushl  0x8(%ebp)
  800a6c:	e8 00 fb ff ff       	call   800571 <printnum>
  800a71:	83 c4 20             	add    $0x20,%esp
			break;
  800a74:	eb 46                	jmp    800abc <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a76:	83 ec 08             	sub    $0x8,%esp
  800a79:	ff 75 0c             	pushl  0xc(%ebp)
  800a7c:	53                   	push   %ebx
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	ff d0                	call   *%eax
  800a82:	83 c4 10             	add    $0x10,%esp
			break;
  800a85:	eb 35                	jmp    800abc <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800a87:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  800a8e:	eb 2c                	jmp    800abc <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800a90:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
			break;
  800a97:	eb 23                	jmp    800abc <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a99:	83 ec 08             	sub    $0x8,%esp
  800a9c:	ff 75 0c             	pushl  0xc(%ebp)
  800a9f:	6a 25                	push   $0x25
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	ff d0                	call   *%eax
  800aa6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa9:	ff 4d 10             	decl   0x10(%ebp)
  800aac:	eb 03                	jmp    800ab1 <vprintfmt+0x3c3>
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab4:	48                   	dec    %eax
  800ab5:	8a 00                	mov    (%eax),%al
  800ab7:	3c 25                	cmp    $0x25,%al
  800ab9:	75 f3                	jne    800aae <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800abb:	90                   	nop
		}
	}
  800abc:	e9 35 fc ff ff       	jmp    8006f6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac5:	5b                   	pop    %ebx
  800ac6:	5e                   	pop    %esi
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800acf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad2:	83 c0 04             	add    $0x4,%eax
  800ad5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad8:	8b 45 10             	mov    0x10(%ebp),%eax
  800adb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ade:	50                   	push   %eax
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	ff 75 08             	pushl  0x8(%ebp)
  800ae5:	e8 04 fc ff ff       	call   8006ee <vprintfmt>
  800aea:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aed:	90                   	nop
  800aee:	c9                   	leave  
  800aef:	c3                   	ret    

00800af0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af6:	8b 40 08             	mov    0x8(%eax),%eax
  800af9:	8d 50 01             	lea    0x1(%eax),%edx
  800afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aff:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b05:	8b 10                	mov    (%eax),%edx
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 40 04             	mov    0x4(%eax),%eax
  800b0d:	39 c2                	cmp    %eax,%edx
  800b0f:	73 12                	jae    800b23 <sprintputch+0x33>
		*b->buf++ = ch;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 48 01             	lea    0x1(%eax),%ecx
  800b19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1c:	89 0a                	mov    %ecx,(%edx)
  800b1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b21:	88 10                	mov    %dl,(%eax)
}
  800b23:	90                   	nop
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	01 d0                	add    %edx,%eax
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4b:	74 06                	je     800b53 <vsnprintf+0x2d>
  800b4d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b51:	7f 07                	jg     800b5a <vsnprintf+0x34>
		return -E_INVAL;
  800b53:	b8 03 00 00 00       	mov    $0x3,%eax
  800b58:	eb 20                	jmp    800b7a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5a:	ff 75 14             	pushl  0x14(%ebp)
  800b5d:	ff 75 10             	pushl  0x10(%ebp)
  800b60:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b63:	50                   	push   %eax
  800b64:	68 f0 0a 80 00       	push   $0x800af0
  800b69:	e8 80 fb ff ff       	call   8006ee <vprintfmt>
  800b6e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b74:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    

00800b7c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b82:	8d 45 10             	lea    0x10(%ebp),%eax
  800b85:	83 c0 04             	add    $0x4,%eax
  800b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b91:	50                   	push   %eax
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	ff 75 08             	pushl  0x8(%ebp)
  800b98:	e8 89 ff ff ff       	call   800b26 <vsnprintf>
  800b9d:	83 c4 10             	add    $0x10,%esp
  800ba0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba6:	c9                   	leave  
  800ba7:	c3                   	ret    

00800ba8 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ba8:	55                   	push   %ebp
  800ba9:	89 e5                	mov    %esp,%ebp
  800bab:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb5:	eb 06                	jmp    800bbd <strlen+0x15>
		n++;
  800bb7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bba:	ff 45 08             	incl   0x8(%ebp)
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8a 00                	mov    (%eax),%al
  800bc2:	84 c0                	test   %al,%al
  800bc4:	75 f1                	jne    800bb7 <strlen+0xf>
		n++;
	return n;
  800bc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc9:	c9                   	leave  
  800bca:	c3                   	ret    

00800bcb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bcb:	55                   	push   %ebp
  800bcc:	89 e5                	mov    %esp,%ebp
  800bce:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd8:	eb 09                	jmp    800be3 <strnlen+0x18>
		n++;
  800bda:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdd:	ff 45 08             	incl   0x8(%ebp)
  800be0:	ff 4d 0c             	decl   0xc(%ebp)
  800be3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be7:	74 09                	je     800bf2 <strnlen+0x27>
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	8a 00                	mov    (%eax),%al
  800bee:	84 c0                	test   %al,%al
  800bf0:	75 e8                	jne    800bda <strnlen+0xf>
		n++;
	return n;
  800bf2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf5:	c9                   	leave  
  800bf6:	c3                   	ret    

00800bf7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf7:	55                   	push   %ebp
  800bf8:	89 e5                	mov    %esp,%ebp
  800bfa:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c03:	90                   	nop
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8d 50 01             	lea    0x1(%eax),%edx
  800c0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c16:	8a 12                	mov    (%edx),%dl
  800c18:	88 10                	mov    %dl,(%eax)
  800c1a:	8a 00                	mov    (%eax),%al
  800c1c:	84 c0                	test   %al,%al
  800c1e:	75 e4                	jne    800c04 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c23:	c9                   	leave  
  800c24:	c3                   	ret    

00800c25 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c38:	eb 1f                	jmp    800c59 <strncpy+0x34>
		*dst++ = *src;
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	8d 50 01             	lea    0x1(%eax),%edx
  800c40:	89 55 08             	mov    %edx,0x8(%ebp)
  800c43:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c46:	8a 12                	mov    (%edx),%dl
  800c48:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	84 c0                	test   %al,%al
  800c51:	74 03                	je     800c56 <strncpy+0x31>
			src++;
  800c53:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c56:	ff 45 fc             	incl   -0x4(%ebp)
  800c59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5f:	72 d9                	jb     800c3a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c61:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c64:	c9                   	leave  
  800c65:	c3                   	ret    

00800c66 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c76:	74 30                	je     800ca8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c78:	eb 16                	jmp    800c90 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8c:	8a 12                	mov    (%edx),%dl
  800c8e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c90:	ff 4d 10             	decl   0x10(%ebp)
  800c93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c97:	74 09                	je     800ca2 <strlcpy+0x3c>
  800c99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9c:	8a 00                	mov    (%eax),%al
  800c9e:	84 c0                	test   %al,%al
  800ca0:	75 d8                	jne    800c7a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cae:	29 c2                	sub    %eax,%edx
  800cb0:	89 d0                	mov    %edx,%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb7:	eb 06                	jmp    800cbf <strcmp+0xb>
		p++, q++;
  800cb9:	ff 45 08             	incl   0x8(%ebp)
  800cbc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	84 c0                	test   %al,%al
  800cc6:	74 0e                	je     800cd6 <strcmp+0x22>
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	8a 10                	mov    (%eax),%dl
  800ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	38 c2                	cmp    %al,%dl
  800cd4:	74 e3                	je     800cb9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	0f b6 d0             	movzbl %al,%edx
  800cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	0f b6 c0             	movzbl %al,%eax
  800ce6:	29 c2                	sub    %eax,%edx
  800ce8:	89 d0                	mov    %edx,%eax
}
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    

00800cec <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cef:	eb 09                	jmp    800cfa <strncmp+0xe>
		n--, p++, q++;
  800cf1:	ff 4d 10             	decl   0x10(%ebp)
  800cf4:	ff 45 08             	incl   0x8(%ebp)
  800cf7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cfa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfe:	74 17                	je     800d17 <strncmp+0x2b>
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	84 c0                	test   %al,%al
  800d07:	74 0e                	je     800d17 <strncmp+0x2b>
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 10                	mov    (%eax),%dl
  800d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	38 c2                	cmp    %al,%dl
  800d15:	74 da                	je     800cf1 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1b:	75 07                	jne    800d24 <strncmp+0x38>
		return 0;
  800d1d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d22:	eb 14                	jmp    800d38 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 00                	mov    (%eax),%al
  800d29:	0f b6 d0             	movzbl %al,%edx
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	0f b6 c0             	movzbl %al,%eax
  800d34:	29 c2                	sub    %eax,%edx
  800d36:	89 d0                	mov    %edx,%eax
}
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	83 ec 04             	sub    $0x4,%esp
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d46:	eb 12                	jmp    800d5a <strchr+0x20>
		if (*s == c)
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d50:	75 05                	jne    800d57 <strchr+0x1d>
			return (char *) s;
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	eb 11                	jmp    800d68 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d57:	ff 45 08             	incl   0x8(%ebp)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	84 c0                	test   %al,%al
  800d61:	75 e5                	jne    800d48 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	83 ec 04             	sub    $0x4,%esp
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d76:	eb 0d                	jmp    800d85 <strfind+0x1b>
		if (*s == c)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d80:	74 0e                	je     800d90 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d82:	ff 45 08             	incl   0x8(%ebp)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	84 c0                	test   %al,%al
  800d8c:	75 ea                	jne    800d78 <strfind+0xe>
  800d8e:	eb 01                	jmp    800d91 <strfind+0x27>
		if (*s == c)
			break;
  800d90:	90                   	nop
	return (char *) s;
  800d91:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d94:	c9                   	leave  
  800d95:	c3                   	ret    

00800d96 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da8:	eb 0e                	jmp    800db8 <memset+0x22>
		*p++ = c;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dad:	8d 50 01             	lea    0x1(%eax),%edx
  800db0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db8:	ff 4d f8             	decl   -0x8(%ebp)
  800dbb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbf:	79 e9                	jns    800daa <memset+0x14>
		*p++ = c;

	return v;
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd8:	eb 16                	jmp    800df0 <memcpy+0x2a>
		*d++ = *s++;
  800dda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddd:	8d 50 01             	lea    0x1(%eax),%edx
  800de0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dec:	8a 12                	mov    (%edx),%dl
  800dee:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 dd                	jne    800dda <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e17:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1a:	73 50                	jae    800e6c <memmove+0x6a>
  800e1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	01 d0                	add    %edx,%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	76 43                	jbe    800e6c <memmove+0x6a>
		s += n;
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e35:	eb 10                	jmp    800e47 <memmove+0x45>
			*--d = *--s;
  800e37:	ff 4d f8             	decl   -0x8(%ebp)
  800e3a:	ff 4d fc             	decl   -0x4(%ebp)
  800e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e40:	8a 10                	mov    (%eax),%dl
  800e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e45:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e50:	85 c0                	test   %eax,%eax
  800e52:	75 e3                	jne    800e37 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e54:	eb 23                	jmp    800e79 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e59:	8d 50 01             	lea    0x1(%eax),%edx
  800e5c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e62:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e65:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e68:	8a 12                	mov    (%edx),%dl
  800e6a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e72:	89 55 10             	mov    %edx,0x10(%ebp)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	75 dd                	jne    800e56 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e90:	eb 2a                	jmp    800ebc <memcmp+0x3e>
		if (*s1 != *s2)
  800e92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e95:	8a 10                	mov    (%eax),%dl
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	38 c2                	cmp    %al,%dl
  800e9e:	74 16                	je     800eb6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea3:	8a 00                	mov    (%eax),%al
  800ea5:	0f b6 d0             	movzbl %al,%edx
  800ea8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eab:	8a 00                	mov    (%eax),%al
  800ead:	0f b6 c0             	movzbl %al,%eax
  800eb0:	29 c2                	sub    %eax,%edx
  800eb2:	89 d0                	mov    %edx,%eax
  800eb4:	eb 18                	jmp    800ece <memcmp+0x50>
		s1++, s2++;
  800eb6:	ff 45 fc             	incl   -0x4(%ebp)
  800eb9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	75 c9                	jne    800e92 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	01 d0                	add    %edx,%eax
  800ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee1:	eb 15                	jmp    800ef8 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	8a 00                	mov    (%eax),%al
  800ee8:	0f b6 d0             	movzbl %al,%edx
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	0f b6 c0             	movzbl %al,%eax
  800ef1:	39 c2                	cmp    %eax,%edx
  800ef3:	74 0d                	je     800f02 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef5:	ff 45 08             	incl   0x8(%ebp)
  800ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  800efb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efe:	72 e3                	jb     800ee3 <memfind+0x13>
  800f00:	eb 01                	jmp    800f03 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f02:	90                   	nop
	return (void *) s;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f15:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1c:	eb 03                	jmp    800f21 <strtol+0x19>
		s++;
  800f1e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 20                	cmp    $0x20,%al
  800f28:	74 f4                	je     800f1e <strtol+0x16>
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 09                	cmp    $0x9,%al
  800f31:	74 eb                	je     800f1e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	8a 00                	mov    (%eax),%al
  800f38:	3c 2b                	cmp    $0x2b,%al
  800f3a:	75 05                	jne    800f41 <strtol+0x39>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
  800f3f:	eb 13                	jmp    800f54 <strtol+0x4c>
	else if (*s == '-')
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	3c 2d                	cmp    $0x2d,%al
  800f48:	75 0a                	jne    800f54 <strtol+0x4c>
		s++, neg = 1;
  800f4a:	ff 45 08             	incl   0x8(%ebp)
  800f4d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f58:	74 06                	je     800f60 <strtol+0x58>
  800f5a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5e:	75 20                	jne    800f80 <strtol+0x78>
  800f60:	8b 45 08             	mov    0x8(%ebp),%eax
  800f63:	8a 00                	mov    (%eax),%al
  800f65:	3c 30                	cmp    $0x30,%al
  800f67:	75 17                	jne    800f80 <strtol+0x78>
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	40                   	inc    %eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 78                	cmp    $0x78,%al
  800f71:	75 0d                	jne    800f80 <strtol+0x78>
		s += 2, base = 16;
  800f73:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f77:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7e:	eb 28                	jmp    800fa8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f84:	75 15                	jne    800f9b <strtol+0x93>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 30                	cmp    $0x30,%al
  800f8d:	75 0c                	jne    800f9b <strtol+0x93>
		s++, base = 8;
  800f8f:	ff 45 08             	incl   0x8(%ebp)
  800f92:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f99:	eb 0d                	jmp    800fa8 <strtol+0xa0>
	else if (base == 0)
  800f9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9f:	75 07                	jne    800fa8 <strtol+0xa0>
		base = 10;
  800fa1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	8a 00                	mov    (%eax),%al
  800fad:	3c 2f                	cmp    $0x2f,%al
  800faf:	7e 19                	jle    800fca <strtol+0xc2>
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	3c 39                	cmp    $0x39,%al
  800fb8:	7f 10                	jg     800fca <strtol+0xc2>
			dig = *s - '0';
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	0f be c0             	movsbl %al,%eax
  800fc2:	83 e8 30             	sub    $0x30,%eax
  800fc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc8:	eb 42                	jmp    80100c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 60                	cmp    $0x60,%al
  800fd1:	7e 19                	jle    800fec <strtol+0xe4>
  800fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	3c 7a                	cmp    $0x7a,%al
  800fda:	7f 10                	jg     800fec <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	0f be c0             	movsbl %al,%eax
  800fe4:	83 e8 57             	sub    $0x57,%eax
  800fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fea:	eb 20                	jmp    80100c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 40                	cmp    $0x40,%al
  800ff3:	7e 39                	jle    80102e <strtol+0x126>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 5a                	cmp    $0x5a,%al
  800ffc:	7f 30                	jg     80102e <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 37             	sub    $0x37,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801012:	7d 19                	jge    80102d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801014:	ff 45 08             	incl   0x8(%ebp)
  801017:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101e:	89 c2                	mov    %eax,%edx
  801020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801023:	01 d0                	add    %edx,%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801028:	e9 7b ff ff ff       	jmp    800fa8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801032:	74 08                	je     80103c <strtol+0x134>
		*endptr = (char *) s;
  801034:	8b 45 0c             	mov    0xc(%ebp),%eax
  801037:	8b 55 08             	mov    0x8(%ebp),%edx
  80103a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801040:	74 07                	je     801049 <strtol+0x141>
  801042:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801045:	f7 d8                	neg    %eax
  801047:	eb 03                	jmp    80104c <strtol+0x144>
  801049:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104c:	c9                   	leave  
  80104d:	c3                   	ret    

0080104e <ltostr>:

void
ltostr(long value, char *str)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801054:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	79 13                	jns    80107b <ltostr+0x2d>
	{
		neg = 1;
  801068:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801075:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801078:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801083:	99                   	cltd   
  801084:	f7 f9                	idiv   %ecx
  801086:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108c:	8d 50 01             	lea    0x1(%eax),%edx
  80108f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801092:	89 c2                	mov    %eax,%edx
  801094:	8b 45 0c             	mov    0xc(%ebp),%eax
  801097:	01 d0                	add    %edx,%eax
  801099:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109c:	83 c2 30             	add    $0x30,%edx
  80109f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a9:	f7 e9                	imul   %ecx
  8010ab:	c1 fa 02             	sar    $0x2,%edx
  8010ae:	89 c8                	mov    %ecx,%eax
  8010b0:	c1 f8 1f             	sar    $0x1f,%eax
  8010b3:	29 c2                	sub    %eax,%edx
  8010b5:	89 d0                	mov    %edx,%eax
  8010b7:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010be:	75 bb                	jne    80107b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ca:	48                   	dec    %eax
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d2:	74 3d                	je     801111 <ltostr+0xc3>
		start = 1 ;
  8010d4:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010db:	eb 34                	jmp    801111 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f0:	01 c2                	add    %eax,%edx
  8010f2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c8                	add    %ecx,%eax
  8010fa:	8a 00                	mov    (%eax),%al
  8010fc:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801101:	8b 45 0c             	mov    0xc(%ebp),%eax
  801104:	01 c2                	add    %eax,%edx
  801106:	8a 45 eb             	mov    -0x15(%ebp),%al
  801109:	88 02                	mov    %al,(%edx)
		start++ ;
  80110b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80110e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801114:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801117:	7c c4                	jl     8010dd <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801119:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801124:	90                   	nop
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
  80112a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80112d:	ff 75 08             	pushl  0x8(%ebp)
  801130:	e8 73 fa ff ff       	call   800ba8 <strlen>
  801135:	83 c4 04             	add    $0x4,%esp
  801138:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80113b:	ff 75 0c             	pushl  0xc(%ebp)
  80113e:	e8 65 fa ff ff       	call   800ba8 <strlen>
  801143:	83 c4 04             	add    $0x4,%esp
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801149:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801157:	eb 17                	jmp    801170 <strcconcat+0x49>
		final[s] = str1[s] ;
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 c2                	add    %eax,%edx
  801161:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	01 c8                	add    %ecx,%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80116d:	ff 45 fc             	incl   -0x4(%ebp)
  801170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801173:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801176:	7c e1                	jl     801159 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801178:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80117f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801186:	eb 1f                	jmp    8011a7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801188:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118b:	8d 50 01             	lea    0x1(%eax),%edx
  80118e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801191:	89 c2                	mov    %eax,%edx
  801193:	8b 45 10             	mov    0x10(%ebp),%eax
  801196:	01 c2                	add    %eax,%edx
  801198:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	01 c8                	add    %ecx,%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a4:	ff 45 f8             	incl   -0x8(%ebp)
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c d9                	jl     801188 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cc:	8b 00                	mov    (%eax),%eax
  8011ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d8:	01 d0                	add    %edx,%eax
  8011da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e0:	eb 0c                	jmp    8011ee <strsplit+0x31>
			*string++ = 0;
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8d 50 01             	lea    0x1(%eax),%edx
  8011e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8011eb:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8a 00                	mov    (%eax),%al
  8011f3:	84 c0                	test   %al,%al
  8011f5:	74 18                	je     80120f <strsplit+0x52>
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	0f be c0             	movsbl %al,%eax
  8011ff:	50                   	push   %eax
  801200:	ff 75 0c             	pushl  0xc(%ebp)
  801203:	e8 32 fb ff ff       	call   800d3a <strchr>
  801208:	83 c4 08             	add    $0x8,%esp
  80120b:	85 c0                	test   %eax,%eax
  80120d:	75 d3                	jne    8011e2 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	8a 00                	mov    (%eax),%al
  801214:	84 c0                	test   %al,%al
  801216:	74 5a                	je     801272 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801218:	8b 45 14             	mov    0x14(%ebp),%eax
  80121b:	8b 00                	mov    (%eax),%eax
  80121d:	83 f8 0f             	cmp    $0xf,%eax
  801220:	75 07                	jne    801229 <strsplit+0x6c>
		{
			return 0;
  801222:	b8 00 00 00 00       	mov    $0x0,%eax
  801227:	eb 66                	jmp    80128f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801229:	8b 45 14             	mov    0x14(%ebp),%eax
  80122c:	8b 00                	mov    (%eax),%eax
  80122e:	8d 48 01             	lea    0x1(%eax),%ecx
  801231:	8b 55 14             	mov    0x14(%ebp),%edx
  801234:	89 0a                	mov    %ecx,(%edx)
  801236:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123d:	8b 45 10             	mov    0x10(%ebp),%eax
  801240:	01 c2                	add    %eax,%edx
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801247:	eb 03                	jmp    80124c <strsplit+0x8f>
			string++;
  801249:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 8b                	je     8011e0 <strsplit+0x23>
  801255:	8b 45 08             	mov    0x8(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f be c0             	movsbl %al,%eax
  80125d:	50                   	push   %eax
  80125e:	ff 75 0c             	pushl  0xc(%ebp)
  801261:	e8 d4 fa ff ff       	call   800d3a <strchr>
  801266:	83 c4 08             	add    $0x8,%esp
  801269:	85 c0                	test   %eax,%eax
  80126b:	74 dc                	je     801249 <strsplit+0x8c>
			string++;
	}
  80126d:	e9 6e ff ff ff       	jmp    8011e0 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801272:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801273:	8b 45 14             	mov    0x14(%ebp),%eax
  801276:	8b 00                	mov    (%eax),%eax
  801278:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127f:	8b 45 10             	mov    0x10(%ebp),%eax
  801282:	01 d0                	add    %edx,%eax
  801284:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80128a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801297:	83 ec 04             	sub    $0x4,%esp
  80129a:	68 c8 3b 80 00       	push   $0x803bc8
  80129f:	68 3f 01 00 00       	push   $0x13f
  8012a4:	68 ea 3b 80 00       	push   $0x803bea
  8012a9:	e8 a9 ef ff ff       	call   800257 <_panic>

008012ae <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	ff 75 08             	pushl  0x8(%ebp)
  8012ba:	e8 90 0c 00 00       	call   801f4f <sys_sbrk>
  8012bf:	83 c4 10             	add    $0x10,%esp
}
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  8012ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ce:	75 0a                	jne    8012da <malloc+0x16>
		return NULL;
  8012d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d5:	e9 9e 01 00 00       	jmp    801478 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  8012da:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  8012e1:	77 2c                	ja     80130f <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  8012e3:	e8 eb 0a 00 00       	call   801dd3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8012e8:	85 c0                	test   %eax,%eax
  8012ea:	74 19                	je     801305 <malloc+0x41>

			void * block = alloc_block_FF(size);
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	ff 75 08             	pushl  0x8(%ebp)
  8012f2:	e8 85 11 00 00       	call   80247c <alloc_block_FF>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  8012fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801300:	e9 73 01 00 00       	jmp    801478 <malloc+0x1b4>
		} else {
			return NULL;
  801305:	b8 00 00 00 00       	mov    $0x0,%eax
  80130a:	e9 69 01 00 00       	jmp    801478 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80130f:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801316:	8b 55 08             	mov    0x8(%ebp),%edx
  801319:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80131c:	01 d0                	add    %edx,%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801322:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801325:	ba 00 00 00 00       	mov    $0x0,%edx
  80132a:	f7 75 e0             	divl   -0x20(%ebp)
  80132d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801330:	29 d0                	sub    %edx,%eax
  801332:	c1 e8 0c             	shr    $0xc,%eax
  801335:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801338:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80133f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801346:	a1 20 40 80 00       	mov    0x804020,%eax
  80134b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80134e:	05 00 10 00 00       	add    $0x1000,%eax
  801353:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801356:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80135b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80135e:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801361:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801368:	8b 55 08             	mov    0x8(%ebp),%edx
  80136b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	48                   	dec    %eax
  801371:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801374:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801377:	ba 00 00 00 00       	mov    $0x0,%edx
  80137c:	f7 75 cc             	divl   -0x34(%ebp)
  80137f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801382:	29 d0                	sub    %edx,%eax
  801384:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801387:	76 0a                	jbe    801393 <malloc+0xcf>
		return NULL;
  801389:	b8 00 00 00 00       	mov    $0x0,%eax
  80138e:	e9 e5 00 00 00       	jmp    801478 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801393:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801396:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801399:	eb 48                	jmp    8013e3 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80139b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8013a1:	c1 e8 0c             	shr    $0xc,%eax
  8013a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  8013a7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8013aa:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	75 11                	jne    8013c6 <malloc+0x102>
			freePagesCount++;
  8013b5:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8013b8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8013bc:	75 16                	jne    8013d4 <malloc+0x110>
				start = i;
  8013be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c4:	eb 0e                	jmp    8013d4 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  8013c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8013cd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  8013d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d7:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8013da:	74 12                	je     8013ee <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  8013dc:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8013e3:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8013ea:	76 af                	jbe    80139b <malloc+0xd7>
  8013ec:	eb 01                	jmp    8013ef <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  8013ee:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  8013ef:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8013f3:	74 08                	je     8013fd <malloc+0x139>
  8013f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8013fb:	74 07                	je     801404 <malloc+0x140>
		return NULL;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801402:	eb 74                	jmp    801478 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80140a:	c1 e8 0c             	shr    $0xc,%eax
  80140d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801410:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801413:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801416:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80141d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801420:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801423:	eb 11                	jmp    801436 <malloc+0x172>
		markedPages[i] = 1;
  801425:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801428:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  80142f:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801433:	ff 45 e8             	incl   -0x18(%ebp)
  801436:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801439:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80143c:	01 d0                	add    %edx,%eax
  80143e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801441:	77 e2                	ja     801425 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801443:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80144a:	8b 55 08             	mov    0x8(%ebp),%edx
  80144d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801450:	01 d0                	add    %edx,%eax
  801452:	48                   	dec    %eax
  801453:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801456:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801459:	ba 00 00 00 00       	mov    $0x0,%edx
  80145e:	f7 75 bc             	divl   -0x44(%ebp)
  801461:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801464:	29 d0                	sub    %edx,%eax
  801466:	83 ec 08             	sub    $0x8,%esp
  801469:	50                   	push   %eax
  80146a:	ff 75 f0             	pushl  -0x10(%ebp)
  80146d:	e8 14 0b 00 00       	call   801f86 <sys_allocate_user_mem>
  801472:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801475:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801478:	c9                   	leave  
  801479:	c3                   	ret    

0080147a <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80147a:	55                   	push   %ebp
  80147b:	89 e5                	mov    %esp,%ebp
  80147d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801480:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801484:	0f 84 ee 00 00 00    	je     801578 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80148a:	a1 20 40 80 00       	mov    0x804020,%eax
  80148f:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801492:	3b 45 08             	cmp    0x8(%ebp),%eax
  801495:	77 09                	ja     8014a0 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801497:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  80149e:	76 14                	jbe    8014b4 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8014a0:	83 ec 04             	sub    $0x4,%esp
  8014a3:	68 f8 3b 80 00       	push   $0x803bf8
  8014a8:	6a 68                	push   $0x68
  8014aa:	68 12 3c 80 00       	push   $0x803c12
  8014af:	e8 a3 ed ff ff       	call   800257 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8014b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8014b9:	8b 40 74             	mov    0x74(%eax),%eax
  8014bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014bf:	77 20                	ja     8014e1 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8014c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8014c6:	8b 40 78             	mov    0x78(%eax),%eax
  8014c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8014cc:	76 13                	jbe    8014e1 <free+0x67>
		free_block(virtual_address);
  8014ce:	83 ec 0c             	sub    $0xc,%esp
  8014d1:	ff 75 08             	pushl  0x8(%ebp)
  8014d4:	e8 6c 16 00 00       	call   802b45 <free_block>
  8014d9:	83 c4 10             	add    $0x10,%esp
		return;
  8014dc:	e9 98 00 00 00       	jmp    801579 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8014e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8014e9:	8b 40 7c             	mov    0x7c(%eax),%eax
  8014ec:	29 c2                	sub    %eax,%edx
  8014ee:	89 d0                	mov    %edx,%eax
  8014f0:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8014f5:	c1 e8 0c             	shr    $0xc,%eax
  8014f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  8014fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801502:	eb 16                	jmp    80151a <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801507:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801513:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801517:	ff 45 f4             	incl   -0xc(%ebp)
  80151a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151d:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801524:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801527:	7f db                	jg     801504 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801529:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80152c:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801533:	c1 e0 0c             	shl    $0xc,%eax
  801536:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153f:	eb 1a                	jmp    80155b <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801541:	83 ec 08             	sub    $0x8,%esp
  801544:	68 00 10 00 00       	push   $0x1000
  801549:	ff 75 f0             	pushl  -0x10(%ebp)
  80154c:	e8 19 0a 00 00       	call   801f6a <sys_free_user_mem>
  801551:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801554:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  80155b:	8b 55 08             	mov    0x8(%ebp),%edx
  80155e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801561:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801563:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801566:	77 d9                	ja     801541 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80156b:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  801572:	00 00 00 00 
  801576:	eb 01                	jmp    801579 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801578:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 58             	sub    $0x58,%esp
  801581:	8b 45 10             	mov    0x10(%ebp),%eax
  801584:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801587:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80158b:	75 0a                	jne    801597 <smalloc+0x1c>
		return NULL;
  80158d:	b8 00 00 00 00       	mov    $0x0,%eax
  801592:	e9 7d 01 00 00       	jmp    801714 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801597:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80159e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015a4:	01 d0                	add    %edx,%eax
  8015a6:	48                   	dec    %eax
  8015a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b2:	f7 75 e4             	divl   -0x1c(%ebp)
  8015b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015b8:	29 d0                	sub    %edx,%eax
  8015ba:	c1 e8 0c             	shr    $0xc,%eax
  8015bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8015c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8015c7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8015ce:	a1 20 40 80 00       	mov    0x804020,%eax
  8015d3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015d6:	05 00 10 00 00       	add    $0x1000,%eax
  8015db:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8015de:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8015e3:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8015e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8015e9:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8015f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8015f6:	01 d0                	add    %edx,%eax
  8015f8:	48                   	dec    %eax
  8015f9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8015fc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8015ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801604:	f7 75 d0             	divl   -0x30(%ebp)
  801607:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80160a:	29 d0                	sub    %edx,%eax
  80160c:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80160f:	76 0a                	jbe    80161b <smalloc+0xa0>
		return NULL;
  801611:	b8 00 00 00 00       	mov    $0x0,%eax
  801616:	e9 f9 00 00 00       	jmp    801714 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80161b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80161e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801621:	eb 48                	jmp    80166b <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801626:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801629:	c1 e8 0c             	shr    $0xc,%eax
  80162c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  80162f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801632:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801639:	85 c0                	test   %eax,%eax
  80163b:	75 11                	jne    80164e <smalloc+0xd3>
			freePagesCount++;
  80163d:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801640:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801644:	75 16                	jne    80165c <smalloc+0xe1>
				start = s;
  801646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801649:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80164c:	eb 0e                	jmp    80165c <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  80164e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801655:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  80165c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801662:	74 12                	je     801676 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801664:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  80166b:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801672:	76 af                	jbe    801623 <smalloc+0xa8>
  801674:	eb 01                	jmp    801677 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801676:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801677:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80167b:	74 08                	je     801685 <smalloc+0x10a>
  80167d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801680:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801683:	74 0a                	je     80168f <smalloc+0x114>
		return NULL;
  801685:	b8 00 00 00 00       	mov    $0x0,%eax
  80168a:	e9 85 00 00 00       	jmp    801714 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801695:	c1 e8 0c             	shr    $0xc,%eax
  801698:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80169b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80169e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016a1:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016a8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016ae:	eb 11                	jmp    8016c1 <smalloc+0x146>
		markedPages[s] = 1;
  8016b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016b3:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8016ba:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8016be:	ff 45 e8             	incl   -0x18(%ebp)
  8016c1:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8016c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016c7:	01 d0                	add    %edx,%eax
  8016c9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016cc:	77 e2                	ja     8016b0 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8016ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d1:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8016d5:	52                   	push   %edx
  8016d6:	50                   	push   %eax
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	e8 8f 04 00 00       	call   801b71 <sys_createSharedObject>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8016e8:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8016ec:	78 12                	js     801700 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8016ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8016f1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8016f4:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  8016fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fe:	eb 14                	jmp    801714 <smalloc+0x199>
	}
	free((void*) start);
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	83 ec 0c             	sub    $0xc,%esp
  801706:	50                   	push   %eax
  801707:	e8 6e fd ff ff       	call   80147a <free>
  80170c:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80170f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801714:	c9                   	leave  
  801715:	c3                   	ret    

00801716 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	ff 75 0c             	pushl  0xc(%ebp)
  801722:	ff 75 08             	pushl  0x8(%ebp)
  801725:	e8 71 04 00 00       	call   801b9b <sys_getSizeOfSharedObject>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801730:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801737:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80173a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80173d:	01 d0                	add    %edx,%eax
  80173f:	48                   	dec    %eax
  801740:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801743:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801746:	ba 00 00 00 00       	mov    $0x0,%edx
  80174b:	f7 75 e0             	divl   -0x20(%ebp)
  80174e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801751:	29 d0                	sub    %edx,%eax
  801753:	c1 e8 0c             	shr    $0xc,%eax
  801756:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801760:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801767:	a1 20 40 80 00       	mov    0x804020,%eax
  80176c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80176f:	05 00 10 00 00       	add    $0x1000,%eax
  801774:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801777:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80177c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80177f:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801782:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801789:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80178c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80178f:	01 d0                	add    %edx,%eax
  801791:	48                   	dec    %eax
  801792:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801795:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801798:	ba 00 00 00 00       	mov    $0x0,%edx
  80179d:	f7 75 cc             	divl   -0x34(%ebp)
  8017a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8017a3:	29 d0                	sub    %edx,%eax
  8017a5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8017a8:	76 0a                	jbe    8017b4 <sget+0x9e>
		return NULL;
  8017aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017af:	e9 f7 00 00 00       	jmp    8018ab <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017ba:	eb 48                	jmp    801804 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8017bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bf:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8017c2:	c1 e8 0c             	shr    $0xc,%eax
  8017c5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8017c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8017cb:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  8017d2:	85 c0                	test   %eax,%eax
  8017d4:	75 11                	jne    8017e7 <sget+0xd1>
			free_Pages_Count++;
  8017d6:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8017d9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8017dd:	75 16                	jne    8017f5 <sget+0xdf>
				start = s;
  8017df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017e5:	eb 0e                	jmp    8017f5 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8017e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8017ee:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8017f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f8:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8017fb:	74 12                	je     80180f <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8017fd:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801804:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80180b:	76 af                	jbe    8017bc <sget+0xa6>
  80180d:	eb 01                	jmp    801810 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80180f:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801810:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801814:	74 08                	je     80181e <sget+0x108>
  801816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801819:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80181c:	74 0a                	je     801828 <sget+0x112>
		return NULL;
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
  801823:	e9 83 00 00 00       	jmp    8018ab <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  801828:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182b:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80182e:	c1 e8 0c             	shr    $0xc,%eax
  801831:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  801834:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801837:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80183a:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801841:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801844:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801847:	eb 11                	jmp    80185a <sget+0x144>
		markedPages[k] = 1;
  801849:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80184c:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801853:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  801857:	ff 45 e8             	incl   -0x18(%ebp)
  80185a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80185d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801860:	01 d0                	add    %edx,%eax
  801862:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801865:	77 e2                	ja     801849 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  801867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	50                   	push   %eax
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 3f 03 00 00       	call   801bb8 <sys_getSharedObject>
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  80187f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801883:	78 12                	js     801897 <sget+0x181>
		shardIDs[startPage] = ss;
  801885:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801888:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80188b:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  801892:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801895:	eb 14                	jmp    8018ab <sget+0x195>
	}
	free((void*) start);
  801897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189a:	83 ec 0c             	sub    $0xc,%esp
  80189d:	50                   	push   %eax
  80189e:	e8 d7 fb ff ff       	call   80147a <free>
  8018a3:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8018a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8018b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b6:	a1 20 40 80 00       	mov    0x804020,%eax
  8018bb:	8b 40 7c             	mov    0x7c(%eax),%eax
  8018be:	29 c2                	sub    %eax,%edx
  8018c0:	89 d0                	mov    %edx,%eax
  8018c2:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8018c7:	c1 e8 0c             	shr    $0xc,%eax
  8018ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8018cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d0:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  8018d7:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8018da:	83 ec 08             	sub    $0x8,%esp
  8018dd:	ff 75 08             	pushl  0x8(%ebp)
  8018e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e3:	e8 ef 02 00 00       	call   801bd7 <sys_freeSharedObject>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8018ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018f2:	75 0e                	jne    801902 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f7:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  8018fe:	ff ff ff ff 
	}

}
  801902:	90                   	nop
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80190b:	83 ec 04             	sub    $0x4,%esp
  80190e:	68 20 3c 80 00       	push   $0x803c20
  801913:	68 19 01 00 00       	push   $0x119
  801918:	68 12 3c 80 00       	push   $0x803c12
  80191d:	e8 35 e9 ff ff       	call   800257 <_panic>

00801922 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801928:	83 ec 04             	sub    $0x4,%esp
  80192b:	68 46 3c 80 00       	push   $0x803c46
  801930:	68 23 01 00 00       	push   $0x123
  801935:	68 12 3c 80 00       	push   $0x803c12
  80193a:	e8 18 e9 ff ff       	call   800257 <_panic>

0080193f <shrink>:

}
void shrink(uint32 newSize) {
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801945:	83 ec 04             	sub    $0x4,%esp
  801948:	68 46 3c 80 00       	push   $0x803c46
  80194d:	68 27 01 00 00       	push   $0x127
  801952:	68 12 3c 80 00       	push   $0x803c12
  801957:	e8 fb e8 ff ff       	call   800257 <_panic>

0080195c <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 46 3c 80 00       	push   $0x803c46
  80196a:	68 2b 01 00 00       	push   $0x12b
  80196f:	68 12 3c 80 00       	push   $0x803c12
  801974:	e8 de e8 ff ff       	call   800257 <_panic>

00801979 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	57                   	push   %edi
  80197d:	56                   	push   %esi
  80197e:	53                   	push   %ebx
  80197f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 55 0c             	mov    0xc(%ebp),%edx
  801988:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80198e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801991:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801994:	cd 30                	int    $0x30
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801999:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	5b                   	pop    %ebx
  8019a0:	5e                   	pop    %esi
  8019a1:	5f                   	pop    %edi
  8019a2:	5d                   	pop    %ebp
  8019a3:	c3                   	ret    

008019a4 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	83 ec 04             	sub    $0x4,%esp
  8019aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8019b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	52                   	push   %edx
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	50                   	push   %eax
  8019c0:	6a 00                	push   $0x0
  8019c2:	e8 b2 ff ff ff       	call   801979 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_cgetc>:

int sys_cgetc(void) {
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 02                	push   $0x2
  8019dc:	e8 98 ff ff ff       	call   801979 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_lock_cons>:

void sys_lock_cons(void) {
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 03                	push   $0x3
  8019f5:	e8 7f ff ff ff       	call   801979 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 04                	push   $0x4
  801a0f:	e8 65 ff ff ff       	call   801979 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	90                   	nop
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	52                   	push   %edx
  801a2a:	50                   	push   %eax
  801a2b:	6a 08                	push   $0x8
  801a2d:	e8 47 ff ff ff       	call   801979 <syscall>
  801a32:	83 c4 18             	add    $0x18,%esp
}
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	56                   	push   %esi
  801a3b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801a3c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a3f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a42:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	51                   	push   %ecx
  801a4e:	52                   	push   %edx
  801a4f:	50                   	push   %eax
  801a50:	6a 09                	push   $0x9
  801a52:	e8 22 ff ff ff       	call   801979 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801a5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5d:	5b                   	pop    %ebx
  801a5e:	5e                   	pop    %esi
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    

00801a61 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 0a                	push   $0xa
  801a74:	e8 00 ff ff ff       	call   801979 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	6a 0b                	push   $0xb
  801a8f:	e8 e5 fe ff ff       	call   801979 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 0c                	push   $0xc
  801aa8:	e8 cc fe ff ff       	call   801979 <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 0d                	push   $0xd
  801ac1:	e8 b3 fe ff ff       	call   801979 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 0e                	push   $0xe
  801ada:	e8 9a fe ff ff       	call   801979 <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 0f                	push   $0xf
  801af3:	e8 81 fe ff ff       	call   801979 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	ff 75 08             	pushl  0x8(%ebp)
  801b0b:	6a 10                	push   $0x10
  801b0d:	e8 67 fe ff ff       	call   801979 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_scarce_memory>:

void sys_scarce_memory() {
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 11                	push   $0x11
  801b26:	e8 4e fe ff ff       	call   801979 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_cputc>:

void sys_cputc(const char c) {
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 04             	sub    $0x4,%esp
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b3d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	50                   	push   %eax
  801b4a:	6a 01                	push   $0x1
  801b4c:	e8 28 fe ff ff       	call   801979 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 14                	push   $0x14
  801b66:	e8 0e fe ff ff       	call   801979 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	90                   	nop
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 04             	sub    $0x4,%esp
  801b77:	8b 45 10             	mov    0x10(%ebp),%eax
  801b7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801b7d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b80:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	6a 00                	push   $0x0
  801b89:	51                   	push   %ecx
  801b8a:	52                   	push   %edx
  801b8b:	ff 75 0c             	pushl  0xc(%ebp)
  801b8e:	50                   	push   %eax
  801b8f:	6a 15                	push   $0x15
  801b91:	e8 e3 fd ff ff       	call   801979 <syscall>
  801b96:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801b99:	c9                   	leave  
  801b9a:	c3                   	ret    

00801b9b <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801b9b:	55                   	push   %ebp
  801b9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	52                   	push   %edx
  801bab:	50                   	push   %eax
  801bac:	6a 16                	push   $0x16
  801bae:	e8 c6 fd ff ff       	call   801979 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801bbb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	51                   	push   %ecx
  801bc9:	52                   	push   %edx
  801bca:	50                   	push   %eax
  801bcb:	6a 17                	push   $0x17
  801bcd:	e8 a7 fd ff ff       	call   801979 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 18                	push   $0x18
  801bea:	e8 8a fd ff ff       	call   801979 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	6a 00                	push   $0x0
  801bfc:	ff 75 14             	pushl  0x14(%ebp)
  801bff:	ff 75 10             	pushl  0x10(%ebp)
  801c02:	ff 75 0c             	pushl  0xc(%ebp)
  801c05:	50                   	push   %eax
  801c06:	6a 19                	push   $0x19
  801c08:	e8 6c fd ff ff       	call   801979 <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_run_env>:

void sys_run_env(int32 envId) {
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	50                   	push   %eax
  801c21:	6a 1a                	push   $0x1a
  801c23:	e8 51 fd ff ff       	call   801979 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	90                   	nop
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c31:	8b 45 08             	mov    0x8(%ebp),%eax
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	50                   	push   %eax
  801c3d:	6a 1b                	push   $0x1b
  801c3f:	e8 35 fd ff ff       	call   801979 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_getenvid>:

int32 sys_getenvid(void) {
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 05                	push   $0x5
  801c58:	e8 1c fd ff ff       	call   801979 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 06                	push   $0x6
  801c71:	e8 03 fd ff ff       	call   801979 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 07                	push   $0x7
  801c8a:	e8 ea fc ff ff       	call   801979 <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
}
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_exit_env>:

void sys_exit_env(void) {
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 1c                	push   $0x1c
  801ca3:	e8 d1 fc ff ff       	call   801979 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
}
  801cab:	90                   	nop
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
  801cb1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801cb4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb7:	8d 50 04             	lea    0x4(%eax),%edx
  801cba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	52                   	push   %edx
  801cc4:	50                   	push   %eax
  801cc5:	6a 1d                	push   $0x1d
  801cc7:	e8 ad fc ff ff       	call   801979 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801ccf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd8:	89 01                	mov    %eax,(%ecx)
  801cda:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	c9                   	leave  
  801ce1:	c2 04 00             	ret    $0x4

00801ce4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	ff 75 10             	pushl  0x10(%ebp)
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	6a 13                	push   $0x13
  801cf6:	e8 7e fc ff ff       	call   801979 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801cfe:	90                   	nop
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_rcr2>:
uint32 sys_rcr2() {
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 1e                	push   $0x1e
  801d10:	e8 64 fc ff ff       	call   801979 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 04             	sub    $0x4,%esp
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d26:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	50                   	push   %eax
  801d33:	6a 1f                	push   $0x1f
  801d35:	e8 3f fc ff ff       	call   801979 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <rsttst>:
void rsttst() {
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 21                	push   $0x21
  801d4f:	e8 25 fc ff ff       	call   801979 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
	return;
  801d57:	90                   	nop
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	8b 45 14             	mov    0x14(%ebp),%eax
  801d63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d66:	8b 55 18             	mov    0x18(%ebp),%edx
  801d69:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6d:	52                   	push   %edx
  801d6e:	50                   	push   %eax
  801d6f:	ff 75 10             	pushl  0x10(%ebp)
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 20                	push   $0x20
  801d7a:	e8 fa fb ff ff       	call   801979 <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <chktst>:
void chktst(uint32 n) {
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	ff 75 08             	pushl  0x8(%ebp)
  801d93:	6a 22                	push   $0x22
  801d95:	e8 df fb ff ff       	call   801979 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return;
  801d9d:	90                   	nop
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <inctst>:

void inctst() {
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 23                	push   $0x23
  801daf:	e8 c5 fb ff ff       	call   801979 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
	return;
  801db7:	90                   	nop
}
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <gettst>:
uint32 gettst() {
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 24                	push   $0x24
  801dc9:	e8 ab fb ff ff       	call   801979 <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
  801dd6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 25                	push   $0x25
  801de5:	e8 8f fb ff ff       	call   801979 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
  801ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801df0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df4:	75 07                	jne    801dfd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfb:	eb 05                	jmp    801e02 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
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
  801e16:	e8 5e fb ff ff       	call   801979 <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
  801e1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e21:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e25:	75 07                	jne    801e2e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e27:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2c:	eb 05                	jmp    801e33 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
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
  801e47:	e8 2d fb ff ff       	call   801979 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
  801e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e52:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e56:	75 07                	jne    801e5f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e58:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5d:	eb 05                	jmp    801e64 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
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
  801e78:	e8 fc fa ff ff       	call   801979 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
  801e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e83:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e87:	75 07                	jne    801e90 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e89:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8e:	eb 05                	jmp    801e95 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	ff 75 08             	pushl  0x8(%ebp)
  801ea5:	6a 26                	push   $0x26
  801ea7:	e8 cd fa ff ff       	call   801979 <syscall>
  801eac:	83 c4 18             	add    $0x18,%esp
	return;
  801eaf:	90                   	nop
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801eb6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec2:	6a 00                	push   $0x0
  801ec4:	53                   	push   %ebx
  801ec5:	51                   	push   %ecx
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	6a 27                	push   $0x27
  801eca:	e8 aa fa ff ff       	call   801979 <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801ed2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801eda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	52                   	push   %edx
  801ee7:	50                   	push   %eax
  801ee8:	6a 28                	push   $0x28
  801eea:	e8 8a fa ff ff       	call   801979 <syscall>
  801eef:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801ef2:	c9                   	leave  
  801ef3:	c3                   	ret    

00801ef4 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801ef7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efd:	8b 45 08             	mov    0x8(%ebp),%eax
  801f00:	6a 00                	push   $0x0
  801f02:	51                   	push   %ecx
  801f03:	ff 75 10             	pushl  0x10(%ebp)
  801f06:	52                   	push   %edx
  801f07:	50                   	push   %eax
  801f08:	6a 29                	push   $0x29
  801f0a:	e8 6a fa ff ff       	call   801979 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	ff 75 10             	pushl  0x10(%ebp)
  801f1e:	ff 75 0c             	pushl  0xc(%ebp)
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	6a 12                	push   $0x12
  801f26:	e8 4e fa ff ff       	call   801979 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
	return;
  801f2e:	90                   	nop
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801f34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f37:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	52                   	push   %edx
  801f41:	50                   	push   %eax
  801f42:	6a 2a                	push   $0x2a
  801f44:	e8 30 fa ff ff       	call   801979 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
	return;
  801f4c:	90                   	nop
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801f52:	8b 45 08             	mov    0x8(%ebp),%eax
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	50                   	push   %eax
  801f5e:	6a 2b                	push   $0x2b
  801f60:	e8 14 fa ff ff       	call   801979 <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	c9                   	leave  
  801f69:	c3                   	ret    

00801f6a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801f6a:	55                   	push   %ebp
  801f6b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	ff 75 0c             	pushl  0xc(%ebp)
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	6a 2c                	push   $0x2c
  801f7b:	e8 f9 f9 ff ff       	call   801979 <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
	return;
  801f83:	90                   	nop
}
  801f84:	c9                   	leave  
  801f85:	c3                   	ret    

00801f86 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801f86:	55                   	push   %ebp
  801f87:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	ff 75 0c             	pushl  0xc(%ebp)
  801f92:	ff 75 08             	pushl  0x8(%ebp)
  801f95:	6a 2d                	push   $0x2d
  801f97:	e8 dd f9 ff ff       	call   801979 <syscall>
  801f9c:	83 c4 18             	add    $0x18,%esp
	return;
  801f9f:	90                   	nop
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	50                   	push   %eax
  801fb1:	6a 2f                	push   $0x2f
  801fb3:	e8 c1 f9 ff ff       	call   801979 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
	return;
  801fbb:	90                   	nop
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	52                   	push   %edx
  801fce:	50                   	push   %eax
  801fcf:	6a 30                	push   $0x30
  801fd1:	e8 a3 f9 ff ff       	call   801979 <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
	return;
  801fd9:	90                   	nop
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	50                   	push   %eax
  801feb:	6a 31                	push   $0x31
  801fed:	e8 87 f9 ff ff       	call   801979 <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
	return;
  801ff5:	90                   	nop
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	52                   	push   %edx
  802008:	50                   	push   %eax
  802009:	6a 2e                	push   $0x2e
  80200b:	e8 69 f9 ff ff       	call   801979 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
    return;
  802013:	90                   	nop
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	83 e8 04             	sub    $0x4,%eax
  802022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802025:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802028:	8b 00                	mov    (%eax),%eax
  80202a:	83 e0 fe             	and    $0xfffffffe,%eax
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
  802032:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	83 e8 04             	sub    $0x4,%eax
  80203b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  80203e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802041:	8b 00                	mov    (%eax),%eax
  802043:	83 e0 01             	and    $0x1,%eax
  802046:	85 c0                	test   %eax,%eax
  802048:	0f 94 c0             	sete   %al
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802053:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80205a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205d:	83 f8 02             	cmp    $0x2,%eax
  802060:	74 2b                	je     80208d <alloc_block+0x40>
  802062:	83 f8 02             	cmp    $0x2,%eax
  802065:	7f 07                	jg     80206e <alloc_block+0x21>
  802067:	83 f8 01             	cmp    $0x1,%eax
  80206a:	74 0e                	je     80207a <alloc_block+0x2d>
  80206c:	eb 58                	jmp    8020c6 <alloc_block+0x79>
  80206e:	83 f8 03             	cmp    $0x3,%eax
  802071:	74 2d                	je     8020a0 <alloc_block+0x53>
  802073:	83 f8 04             	cmp    $0x4,%eax
  802076:	74 3b                	je     8020b3 <alloc_block+0x66>
  802078:	eb 4c                	jmp    8020c6 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80207a:	83 ec 0c             	sub    $0xc,%esp
  80207d:	ff 75 08             	pushl  0x8(%ebp)
  802080:	e8 f7 03 00 00       	call   80247c <alloc_block_FF>
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80208b:	eb 4a                	jmp    8020d7 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	ff 75 08             	pushl  0x8(%ebp)
  802093:	e8 f0 11 00 00       	call   803288 <alloc_block_NF>
  802098:	83 c4 10             	add    $0x10,%esp
  80209b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80209e:	eb 37                	jmp    8020d7 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8020a0:	83 ec 0c             	sub    $0xc,%esp
  8020a3:	ff 75 08             	pushl  0x8(%ebp)
  8020a6:	e8 08 08 00 00       	call   8028b3 <alloc_block_BF>
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020b1:	eb 24                	jmp    8020d7 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8020b3:	83 ec 0c             	sub    $0xc,%esp
  8020b6:	ff 75 08             	pushl  0x8(%ebp)
  8020b9:	e8 ad 11 00 00       	call   80326b <alloc_block_WF>
  8020be:	83 c4 10             	add    $0x10,%esp
  8020c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8020c4:	eb 11                	jmp    8020d7 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8020c6:	83 ec 0c             	sub    $0xc,%esp
  8020c9:	68 58 3c 80 00       	push   $0x803c58
  8020ce:	e8 41 e4 ff ff       	call   800514 <cprintf>
  8020d3:	83 c4 10             	add    $0x10,%esp
		break;
  8020d6:	90                   	nop
	}
	return va;
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	53                   	push   %ebx
  8020e0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	68 78 3c 80 00       	push   $0x803c78
  8020eb:	e8 24 e4 ff ff       	call   800514 <cprintf>
  8020f0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8020f3:	83 ec 0c             	sub    $0xc,%esp
  8020f6:	68 a3 3c 80 00       	push   $0x803ca3
  8020fb:	e8 14 e4 ff ff       	call   800514 <cprintf>
  802100:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802109:	eb 37                	jmp    802142 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80210b:	83 ec 0c             	sub    $0xc,%esp
  80210e:	ff 75 f4             	pushl  -0xc(%ebp)
  802111:	e8 19 ff ff ff       	call   80202f <is_free_block>
  802116:	83 c4 10             	add    $0x10,%esp
  802119:	0f be d8             	movsbl %al,%ebx
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	ff 75 f4             	pushl  -0xc(%ebp)
  802122:	e8 ef fe ff ff       	call   802016 <get_block_size>
  802127:	83 c4 10             	add    $0x10,%esp
  80212a:	83 ec 04             	sub    $0x4,%esp
  80212d:	53                   	push   %ebx
  80212e:	50                   	push   %eax
  80212f:	68 bb 3c 80 00       	push   $0x803cbb
  802134:	e8 db e3 ff ff       	call   800514 <cprintf>
  802139:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802146:	74 07                	je     80214f <print_blocks_list+0x73>
  802148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214b:	8b 00                	mov    (%eax),%eax
  80214d:	eb 05                	jmp    802154 <print_blocks_list+0x78>
  80214f:	b8 00 00 00 00       	mov    $0x0,%eax
  802154:	89 45 10             	mov    %eax,0x10(%ebp)
  802157:	8b 45 10             	mov    0x10(%ebp),%eax
  80215a:	85 c0                	test   %eax,%eax
  80215c:	75 ad                	jne    80210b <print_blocks_list+0x2f>
  80215e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802162:	75 a7                	jne    80210b <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802164:	83 ec 0c             	sub    $0xc,%esp
  802167:	68 78 3c 80 00       	push   $0x803c78
  80216c:	e8 a3 e3 ff ff       	call   800514 <cprintf>
  802171:	83 c4 10             	add    $0x10,%esp

}
  802174:	90                   	nop
  802175:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
  80217d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802180:	8b 45 0c             	mov    0xc(%ebp),%eax
  802183:	83 e0 01             	and    $0x1,%eax
  802186:	85 c0                	test   %eax,%eax
  802188:	74 03                	je     80218d <initialize_dynamic_allocator+0x13>
  80218a:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80218d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802191:	0f 84 f8 00 00 00    	je     80228f <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802197:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  80219e:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8021a1:	a1 40 40 98 00       	mov    0x984040,%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	0f 84 e2 00 00 00    	je     802290 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8021bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c3:	01 d0                	add    %edx,%eax
  8021c5:	83 e8 04             	sub    $0x4,%eax
  8021c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8021cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ce:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	83 c0 08             	add    $0x8,%eax
  8021da:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  8021dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e0:	83 e8 08             	sub    $0x8,%eax
  8021e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	6a 00                	push   $0x0
  8021eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8021ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8021f1:	e8 9c 00 00 00       	call   802292 <set_block_data>
  8021f6:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8021f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802202:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802205:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80220c:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  802213:	00 00 00 
  802216:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  80221d:	00 00 00 
  802220:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  802227:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80222a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80222e:	75 17                	jne    802247 <initialize_dynamic_allocator+0xcd>
  802230:	83 ec 04             	sub    $0x4,%esp
  802233:	68 d4 3c 80 00       	push   $0x803cd4
  802238:	68 80 00 00 00       	push   $0x80
  80223d:	68 f7 3c 80 00       	push   $0x803cf7
  802242:	e8 10 e0 ff ff       	call   800257 <_panic>
  802247:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802250:	89 10                	mov    %edx,(%eax)
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	8b 00                	mov    (%eax),%eax
  802257:	85 c0                	test   %eax,%eax
  802259:	74 0d                	je     802268 <initialize_dynamic_allocator+0xee>
  80225b:	a1 48 40 98 00       	mov    0x984048,%eax
  802260:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802263:	89 50 04             	mov    %edx,0x4(%eax)
  802266:	eb 08                	jmp    802270 <initialize_dynamic_allocator+0xf6>
  802268:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80226b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802270:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802273:	a3 48 40 98 00       	mov    %eax,0x984048
  802278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802282:	a1 54 40 98 00       	mov    0x984054,%eax
  802287:	40                   	inc    %eax
  802288:	a3 54 40 98 00       	mov    %eax,0x984054
  80228d:	eb 01                	jmp    802290 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80228f:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
  802295:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80229b:	83 e0 01             	and    $0x1,%eax
  80229e:	85 c0                	test   %eax,%eax
  8022a0:	74 03                	je     8022a5 <set_block_data+0x13>
	{
		totalSize++;
  8022a2:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	83 e8 04             	sub    $0x4,%eax
  8022ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8022ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b1:	83 e0 fe             	and    $0xfffffffe,%eax
  8022b4:	89 c2                	mov    %eax,%edx
  8022b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8022b9:	83 e0 01             	and    $0x1,%eax
  8022bc:	09 c2                	or     %eax,%edx
  8022be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c1:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	8d 50 f8             	lea    -0x8(%eax),%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	01 d0                	add    %edx,%eax
  8022ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8022d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d4:	83 e0 fe             	and    $0xfffffffe,%eax
  8022d7:	89 c2                	mov    %eax,%edx
  8022d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8022dc:	83 e0 01             	and    $0x1,%eax
  8022df:	09 c2                	or     %eax,%edx
  8022e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022e4:	89 10                	mov    %edx,(%eax)
}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8022ef:	a1 48 40 98 00       	mov    0x984048,%eax
  8022f4:	85 c0                	test   %eax,%eax
  8022f6:	75 68                	jne    802360 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8022f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022fc:	75 17                	jne    802315 <insert_sorted_in_freeList+0x2c>
  8022fe:	83 ec 04             	sub    $0x4,%esp
  802301:	68 d4 3c 80 00       	push   $0x803cd4
  802306:	68 9d 00 00 00       	push   $0x9d
  80230b:	68 f7 3c 80 00       	push   $0x803cf7
  802310:	e8 42 df ff ff       	call   800257 <_panic>
  802315:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	89 10                	mov    %edx,(%eax)
  802320:	8b 45 08             	mov    0x8(%ebp),%eax
  802323:	8b 00                	mov    (%eax),%eax
  802325:	85 c0                	test   %eax,%eax
  802327:	74 0d                	je     802336 <insert_sorted_in_freeList+0x4d>
  802329:	a1 48 40 98 00       	mov    0x984048,%eax
  80232e:	8b 55 08             	mov    0x8(%ebp),%edx
  802331:	89 50 04             	mov    %edx,0x4(%eax)
  802334:	eb 08                	jmp    80233e <insert_sorted_in_freeList+0x55>
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80233e:	8b 45 08             	mov    0x8(%ebp),%eax
  802341:	a3 48 40 98 00       	mov    %eax,0x984048
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802350:	a1 54 40 98 00       	mov    0x984054,%eax
  802355:	40                   	inc    %eax
  802356:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  80235b:	e9 1a 01 00 00       	jmp    80247a <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802360:	a1 48 40 98 00       	mov    0x984048,%eax
  802365:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802368:	eb 7f                	jmp    8023e9 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80236a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802370:	76 6f                	jbe    8023e1 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802376:	74 06                	je     80237e <insert_sorted_in_freeList+0x95>
  802378:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80237c:	75 17                	jne    802395 <insert_sorted_in_freeList+0xac>
  80237e:	83 ec 04             	sub    $0x4,%esp
  802381:	68 10 3d 80 00       	push   $0x803d10
  802386:	68 a6 00 00 00       	push   $0xa6
  80238b:	68 f7 3c 80 00       	push   $0x803cf7
  802390:	e8 c2 de ff ff       	call   800257 <_panic>
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 50 04             	mov    0x4(%eax),%edx
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a7:	89 10                	mov    %edx,(%eax)
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	8b 40 04             	mov    0x4(%eax),%eax
  8023af:	85 c0                	test   %eax,%eax
  8023b1:	74 0d                	je     8023c0 <insert_sorted_in_freeList+0xd7>
  8023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b6:	8b 40 04             	mov    0x4(%eax),%eax
  8023b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023bc:	89 10                	mov    %edx,(%eax)
  8023be:	eb 08                	jmp    8023c8 <insert_sorted_in_freeList+0xdf>
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	a3 48 40 98 00       	mov    %eax,0x984048
  8023c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ce:	89 50 04             	mov    %edx,0x4(%eax)
  8023d1:	a1 54 40 98 00       	mov    0x984054,%eax
  8023d6:	40                   	inc    %eax
  8023d7:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  8023dc:	e9 99 00 00 00       	jmp    80247a <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8023e1:	a1 50 40 98 00       	mov    0x984050,%eax
  8023e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ed:	74 07                	je     8023f6 <insert_sorted_in_freeList+0x10d>
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 00                	mov    (%eax),%eax
  8023f4:	eb 05                	jmp    8023fb <insert_sorted_in_freeList+0x112>
  8023f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fb:	a3 50 40 98 00       	mov    %eax,0x984050
  802400:	a1 50 40 98 00       	mov    0x984050,%eax
  802405:	85 c0                	test   %eax,%eax
  802407:	0f 85 5d ff ff ff    	jne    80236a <insert_sorted_in_freeList+0x81>
  80240d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802411:	0f 85 53 ff ff ff    	jne    80236a <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802417:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80241b:	75 17                	jne    802434 <insert_sorted_in_freeList+0x14b>
  80241d:	83 ec 04             	sub    $0x4,%esp
  802420:	68 48 3d 80 00       	push   $0x803d48
  802425:	68 ab 00 00 00       	push   $0xab
  80242a:	68 f7 3c 80 00       	push   $0x803cf7
  80242f:	e8 23 de ff ff       	call   800257 <_panic>
  802434:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	89 50 04             	mov    %edx,0x4(%eax)
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	8b 40 04             	mov    0x4(%eax),%eax
  802446:	85 c0                	test   %eax,%eax
  802448:	74 0c                	je     802456 <insert_sorted_in_freeList+0x16d>
  80244a:	a1 4c 40 98 00       	mov    0x98404c,%eax
  80244f:	8b 55 08             	mov    0x8(%ebp),%edx
  802452:	89 10                	mov    %edx,(%eax)
  802454:	eb 08                	jmp    80245e <insert_sorted_in_freeList+0x175>
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	a3 48 40 98 00       	mov    %eax,0x984048
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246f:	a1 54 40 98 00       	mov    0x984054,%eax
  802474:	40                   	inc    %eax
  802475:	a3 54 40 98 00       	mov    %eax,0x984054
}
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
  80247f:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	83 e0 01             	and    $0x1,%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 03                	je     80248f <alloc_block_FF+0x13>
  80248c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80248f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802493:	77 07                	ja     80249c <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802495:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80249c:	a1 40 40 98 00       	mov    0x984040,%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	75 63                	jne    802508 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8024a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a8:	83 c0 10             	add    $0x10,%eax
  8024ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8024ae:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8024b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bb:	01 d0                	add    %edx,%eax
  8024bd:	48                   	dec    %eax
  8024be:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8024c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c9:	f7 75 ec             	divl   -0x14(%ebp)
  8024cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024cf:	29 d0                	sub    %edx,%eax
  8024d1:	c1 e8 0c             	shr    $0xc,%eax
  8024d4:	83 ec 0c             	sub    $0xc,%esp
  8024d7:	50                   	push   %eax
  8024d8:	e8 d1 ed ff ff       	call   8012ae <sbrk>
  8024dd:	83 c4 10             	add    $0x10,%esp
  8024e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8024e3:	83 ec 0c             	sub    $0xc,%esp
  8024e6:	6a 00                	push   $0x0
  8024e8:	e8 c1 ed ff ff       	call   8012ae <sbrk>
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8024f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024f6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8024f9:	83 ec 08             	sub    $0x8,%esp
  8024fc:	50                   	push   %eax
  8024fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  802500:	e8 75 fc ff ff       	call   80217a <initialize_dynamic_allocator>
  802505:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80250c:	75 0a                	jne    802518 <alloc_block_FF+0x9c>
	{
		return NULL;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
  802513:	e9 99 03 00 00       	jmp    8028b1 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	83 c0 08             	add    $0x8,%eax
  80251e:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802521:	a1 48 40 98 00       	mov    0x984048,%eax
  802526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802529:	e9 03 02 00 00       	jmp    802731 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  80252e:	83 ec 0c             	sub    $0xc,%esp
  802531:	ff 75 f4             	pushl  -0xc(%ebp)
  802534:	e8 dd fa ff ff       	call   802016 <get_block_size>
  802539:	83 c4 10             	add    $0x10,%esp
  80253c:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  80253f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802542:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802545:	0f 82 de 01 00 00    	jb     802729 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80254b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80254e:	83 c0 10             	add    $0x10,%eax
  802551:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802554:	0f 87 32 01 00 00    	ja     80268c <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80255a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80255d:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802560:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802569:	01 d0                	add    %edx,%eax
  80256b:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80256e:	83 ec 04             	sub    $0x4,%esp
  802571:	6a 00                	push   $0x0
  802573:	ff 75 98             	pushl  -0x68(%ebp)
  802576:	ff 75 94             	pushl  -0x6c(%ebp)
  802579:	e8 14 fd ff ff       	call   802292 <set_block_data>
  80257e:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	74 06                	je     80258d <alloc_block_FF+0x111>
  802587:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80258b:	75 17                	jne    8025a4 <alloc_block_FF+0x128>
  80258d:	83 ec 04             	sub    $0x4,%esp
  802590:	68 6c 3d 80 00       	push   $0x803d6c
  802595:	68 de 00 00 00       	push   $0xde
  80259a:	68 f7 3c 80 00       	push   $0x803cf7
  80259f:	e8 b3 dc ff ff       	call   800257 <_panic>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 10                	mov    (%eax),%edx
  8025a9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025ac:	89 10                	mov    %edx,(%eax)
  8025ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 0b                	je     8025c2 <alloc_block_FF+0x146>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025bf:	89 50 04             	mov    %edx,0x4(%eax)
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8025c8:	89 10                	mov    %edx,(%eax)
  8025ca:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d0:	89 50 04             	mov    %edx,0x4(%eax)
  8025d3:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	75 08                	jne    8025e4 <alloc_block_FF+0x168>
  8025dc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8025df:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8025e4:	a1 54 40 98 00       	mov    0x984054,%eax
  8025e9:	40                   	inc    %eax
  8025ea:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8025ef:	83 ec 04             	sub    $0x4,%esp
  8025f2:	6a 01                	push   $0x1
  8025f4:	ff 75 dc             	pushl  -0x24(%ebp)
  8025f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025fa:	e8 93 fc ff ff       	call   802292 <set_block_data>
  8025ff:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802602:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802606:	75 17                	jne    80261f <alloc_block_FF+0x1a3>
  802608:	83 ec 04             	sub    $0x4,%esp
  80260b:	68 a0 3d 80 00       	push   $0x803da0
  802610:	68 e3 00 00 00       	push   $0xe3
  802615:	68 f7 3c 80 00       	push   $0x803cf7
  80261a:	e8 38 dc ff ff       	call   800257 <_panic>
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 00                	mov    (%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 10                	je     802638 <alloc_block_FF+0x1bc>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802630:	8b 52 04             	mov    0x4(%edx),%edx
  802633:	89 50 04             	mov    %edx,0x4(%eax)
  802636:	eb 0b                	jmp    802643 <alloc_block_FF+0x1c7>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 40 04             	mov    0x4(%eax),%eax
  80263e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	85 c0                	test   %eax,%eax
  80264b:	74 0f                	je     80265c <alloc_block_FF+0x1e0>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 40 04             	mov    0x4(%eax),%eax
  802653:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802656:	8b 12                	mov    (%edx),%edx
  802658:	89 10                	mov    %edx,(%eax)
  80265a:	eb 0a                	jmp    802666 <alloc_block_FF+0x1ea>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	a3 48 40 98 00       	mov    %eax,0x984048
  802666:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802679:	a1 54 40 98 00       	mov    0x984054,%eax
  80267e:	48                   	dec    %eax
  80267f:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	e9 25 02 00 00       	jmp    8028b1 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80268c:	83 ec 04             	sub    $0x4,%esp
  80268f:	6a 01                	push   $0x1
  802691:	ff 75 9c             	pushl  -0x64(%ebp)
  802694:	ff 75 f4             	pushl  -0xc(%ebp)
  802697:	e8 f6 fb ff ff       	call   802292 <set_block_data>
  80269c:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80269f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a3:	75 17                	jne    8026bc <alloc_block_FF+0x240>
  8026a5:	83 ec 04             	sub    $0x4,%esp
  8026a8:	68 a0 3d 80 00       	push   $0x803da0
  8026ad:	68 eb 00 00 00       	push   $0xeb
  8026b2:	68 f7 3c 80 00       	push   $0x803cf7
  8026b7:	e8 9b db ff ff       	call   800257 <_panic>
  8026bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bf:	8b 00                	mov    (%eax),%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	74 10                	je     8026d5 <alloc_block_FF+0x259>
  8026c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c8:	8b 00                	mov    (%eax),%eax
  8026ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cd:	8b 52 04             	mov    0x4(%edx),%edx
  8026d0:	89 50 04             	mov    %edx,0x4(%eax)
  8026d3:	eb 0b                	jmp    8026e0 <alloc_block_FF+0x264>
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 04             	mov    0x4(%eax),%eax
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	74 0f                	je     8026f9 <alloc_block_FF+0x27d>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 04             	mov    0x4(%eax),%eax
  8026f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f3:	8b 12                	mov    (%edx),%edx
  8026f5:	89 10                	mov    %edx,(%eax)
  8026f7:	eb 0a                	jmp    802703 <alloc_block_FF+0x287>
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 00                	mov    (%eax),%eax
  8026fe:	a3 48 40 98 00       	mov    %eax,0x984048
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802716:	a1 54 40 98 00       	mov    0x984054,%eax
  80271b:	48                   	dec    %eax
  80271c:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	e9 88 01 00 00       	jmp    8028b1 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802729:	a1 50 40 98 00       	mov    0x984050,%eax
  80272e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802735:	74 07                	je     80273e <alloc_block_FF+0x2c2>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	eb 05                	jmp    802743 <alloc_block_FF+0x2c7>
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
  802743:	a3 50 40 98 00       	mov    %eax,0x984050
  802748:	a1 50 40 98 00       	mov    0x984050,%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	0f 85 d9 fd ff ff    	jne    80252e <alloc_block_FF+0xb2>
  802755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802759:	0f 85 cf fd ff ff    	jne    80252e <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80275f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802766:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802769:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80276c:	01 d0                	add    %edx,%eax
  80276e:	48                   	dec    %eax
  80276f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802775:	ba 00 00 00 00       	mov    $0x0,%edx
  80277a:	f7 75 d8             	divl   -0x28(%ebp)
  80277d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802780:	29 d0                	sub    %edx,%eax
  802782:	c1 e8 0c             	shr    $0xc,%eax
  802785:	83 ec 0c             	sub    $0xc,%esp
  802788:	50                   	push   %eax
  802789:	e8 20 eb ff ff       	call   8012ae <sbrk>
  80278e:	83 c4 10             	add    $0x10,%esp
  802791:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802794:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802798:	75 0a                	jne    8027a4 <alloc_block_FF+0x328>
		return NULL;
  80279a:	b8 00 00 00 00       	mov    $0x0,%eax
  80279f:	e9 0d 01 00 00       	jmp    8028b1 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8027a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027a7:	83 e8 04             	sub    $0x4,%eax
  8027aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8027ad:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8027b4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8027b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8027ba:	01 d0                	add    %edx,%eax
  8027bc:	48                   	dec    %eax
  8027bd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8027c0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8027c8:	f7 75 c8             	divl   -0x38(%ebp)
  8027cb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8027ce:	29 d0                	sub    %edx,%eax
  8027d0:	c1 e8 02             	shr    $0x2,%eax
  8027d3:	c1 e0 02             	shl    $0x2,%eax
  8027d6:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8027d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8027dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8027e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8027e5:	83 e8 08             	sub    $0x8,%eax
  8027e8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8027eb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	83 e0 fe             	and    $0xfffffffe,%eax
  8027f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8027f6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8027f9:	f7 d8                	neg    %eax
  8027fb:	89 c2                	mov    %eax,%edx
  8027fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802800:	01 d0                	add    %edx,%eax
  802802:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802805:	83 ec 0c             	sub    $0xc,%esp
  802808:	ff 75 b8             	pushl  -0x48(%ebp)
  80280b:	e8 1f f8 ff ff       	call   80202f <is_free_block>
  802810:	83 c4 10             	add    $0x10,%esp
  802813:	0f be c0             	movsbl %al,%eax
  802816:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802819:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80281d:	74 42                	je     802861 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  80281f:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802826:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802829:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80282c:	01 d0                	add    %edx,%eax
  80282e:	48                   	dec    %eax
  80282f:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802832:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802835:	ba 00 00 00 00       	mov    $0x0,%edx
  80283a:	f7 75 b0             	divl   -0x50(%ebp)
  80283d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802840:	29 d0                	sub    %edx,%eax
  802842:	89 c2                	mov    %eax,%edx
  802844:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802847:	01 d0                	add    %edx,%eax
  802849:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  80284c:	83 ec 04             	sub    $0x4,%esp
  80284f:	6a 00                	push   $0x0
  802851:	ff 75 a8             	pushl  -0x58(%ebp)
  802854:	ff 75 b8             	pushl  -0x48(%ebp)
  802857:	e8 36 fa ff ff       	call   802292 <set_block_data>
  80285c:	83 c4 10             	add    $0x10,%esp
  80285f:	eb 42                	jmp    8028a3 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802861:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802868:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80286b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80286e:	01 d0                	add    %edx,%eax
  802870:	48                   	dec    %eax
  802871:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802874:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802877:	ba 00 00 00 00       	mov    $0x0,%edx
  80287c:	f7 75 a4             	divl   -0x5c(%ebp)
  80287f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802882:	29 d0                	sub    %edx,%eax
  802884:	83 ec 04             	sub    $0x4,%esp
  802887:	6a 00                	push   $0x0
  802889:	50                   	push   %eax
  80288a:	ff 75 d0             	pushl  -0x30(%ebp)
  80288d:	e8 00 fa ff ff       	call   802292 <set_block_data>
  802892:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802895:	83 ec 0c             	sub    $0xc,%esp
  802898:	ff 75 d0             	pushl  -0x30(%ebp)
  80289b:	e8 49 fa ff ff       	call   8022e9 <insert_sorted_in_freeList>
  8028a0:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  8028a3:	83 ec 0c             	sub    $0xc,%esp
  8028a6:	ff 75 08             	pushl  0x8(%ebp)
  8028a9:	e8 ce fb ff ff       	call   80247c <alloc_block_FF>
  8028ae:	83 c4 10             	add    $0x10,%esp
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  8028b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028bd:	75 0a                	jne    8028c9 <alloc_block_BF+0x16>
	{
		return NULL;
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	e9 7a 02 00 00       	jmp    802b43 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	83 c0 08             	add    $0x8,%eax
  8028cf:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  8028d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  8028d9:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8028e0:	a1 48 40 98 00       	mov    0x984048,%eax
  8028e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028e8:	eb 32                	jmp    80291c <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  8028ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8028ed:	e8 24 f7 ff ff       	call   802016 <get_block_size>
  8028f2:	83 c4 04             	add    $0x4,%esp
  8028f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  8028f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028fb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8028fe:	72 14                	jb     802914 <alloc_block_BF+0x61>
  802900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802903:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802906:	73 0c                	jae    802914 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  80290e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802911:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802914:	a1 50 40 98 00       	mov    0x984050,%eax
  802919:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80291c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802920:	74 07                	je     802929 <alloc_block_BF+0x76>
  802922:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	eb 05                	jmp    80292e <alloc_block_BF+0x7b>
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
  80292e:	a3 50 40 98 00       	mov    %eax,0x984050
  802933:	a1 50 40 98 00       	mov    0x984050,%eax
  802938:	85 c0                	test   %eax,%eax
  80293a:	75 ae                	jne    8028ea <alloc_block_BF+0x37>
  80293c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802940:	75 a8                	jne    8028ea <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802946:	75 22                	jne    80296a <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802948:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294b:	83 ec 0c             	sub    $0xc,%esp
  80294e:	50                   	push   %eax
  80294f:	e8 5a e9 ff ff       	call   8012ae <sbrk>
  802954:	83 c4 10             	add    $0x10,%esp
  802957:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  80295a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  80295e:	75 0a                	jne    80296a <alloc_block_BF+0xb7>
			return NULL;
  802960:	b8 00 00 00 00       	mov    $0x0,%eax
  802965:	e9 d9 01 00 00       	jmp    802b43 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  80296a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296d:	83 c0 10             	add    $0x10,%eax
  802970:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802973:	0f 87 32 01 00 00    	ja     802aab <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80297f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802982:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802985:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802988:	01 d0                	add    %edx,%eax
  80298a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  80298d:	83 ec 04             	sub    $0x4,%esp
  802990:	6a 00                	push   $0x0
  802992:	ff 75 dc             	pushl  -0x24(%ebp)
  802995:	ff 75 d8             	pushl  -0x28(%ebp)
  802998:	e8 f5 f8 ff ff       	call   802292 <set_block_data>
  80299d:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  8029a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a4:	74 06                	je     8029ac <alloc_block_BF+0xf9>
  8029a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8029aa:	75 17                	jne    8029c3 <alloc_block_BF+0x110>
  8029ac:	83 ec 04             	sub    $0x4,%esp
  8029af:	68 6c 3d 80 00       	push   $0x803d6c
  8029b4:	68 49 01 00 00       	push   $0x149
  8029b9:	68 f7 3c 80 00       	push   $0x803cf7
  8029be:	e8 94 d8 ff ff       	call   800257 <_panic>
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 10                	mov    (%eax),%edx
  8029c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 0b                	je     8029e1 <alloc_block_BF+0x12e>
  8029d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ef:	89 50 04             	mov    %edx,0x4(%eax)
  8029f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	75 08                	jne    802a03 <alloc_block_BF+0x150>
  8029fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029fe:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a03:	a1 54 40 98 00       	mov    0x984054,%eax
  802a08:	40                   	inc    %eax
  802a09:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802a0e:	83 ec 04             	sub    $0x4,%esp
  802a11:	6a 01                	push   $0x1
  802a13:	ff 75 e8             	pushl  -0x18(%ebp)
  802a16:	ff 75 f4             	pushl  -0xc(%ebp)
  802a19:	e8 74 f8 ff ff       	call   802292 <set_block_data>
  802a1e:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802a21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a25:	75 17                	jne    802a3e <alloc_block_BF+0x18b>
  802a27:	83 ec 04             	sub    $0x4,%esp
  802a2a:	68 a0 3d 80 00       	push   $0x803da0
  802a2f:	68 4e 01 00 00       	push   $0x14e
  802a34:	68 f7 3c 80 00       	push   $0x803cf7
  802a39:	e8 19 d8 ff ff       	call   800257 <_panic>
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 00                	mov    (%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 10                	je     802a57 <alloc_block_BF+0x1a4>
  802a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4a:	8b 00                	mov    (%eax),%eax
  802a4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a4f:	8b 52 04             	mov    0x4(%edx),%edx
  802a52:	89 50 04             	mov    %edx,0x4(%eax)
  802a55:	eb 0b                	jmp    802a62 <alloc_block_BF+0x1af>
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 04             	mov    0x4(%eax),%eax
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 0f                	je     802a7b <alloc_block_BF+0x1c8>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a75:	8b 12                	mov    (%edx),%edx
  802a77:	89 10                	mov    %edx,(%eax)
  802a79:	eb 0a                	jmp    802a85 <alloc_block_BF+0x1d2>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	a3 48 40 98 00       	mov    %eax,0x984048
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a98:	a1 54 40 98 00       	mov    0x984054,%eax
  802a9d:	48                   	dec    %eax
  802a9e:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	e9 98 00 00 00       	jmp    802b43 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802aab:	83 ec 04             	sub    $0x4,%esp
  802aae:	6a 01                	push   $0x1
  802ab0:	ff 75 f0             	pushl  -0x10(%ebp)
  802ab3:	ff 75 f4             	pushl  -0xc(%ebp)
  802ab6:	e8 d7 f7 ff ff       	call   802292 <set_block_data>
  802abb:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802abe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac2:	75 17                	jne    802adb <alloc_block_BF+0x228>
  802ac4:	83 ec 04             	sub    $0x4,%esp
  802ac7:	68 a0 3d 80 00       	push   $0x803da0
  802acc:	68 56 01 00 00       	push   $0x156
  802ad1:	68 f7 3c 80 00       	push   $0x803cf7
  802ad6:	e8 7c d7 ff ff       	call   800257 <_panic>
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	74 10                	je     802af4 <alloc_block_BF+0x241>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aec:	8b 52 04             	mov    0x4(%edx),%edx
  802aef:	89 50 04             	mov    %edx,0x4(%eax)
  802af2:	eb 0b                	jmp    802aff <alloc_block_BF+0x24c>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 40 04             	mov    0x4(%eax),%eax
  802afa:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 04             	mov    0x4(%eax),%eax
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 0f                	je     802b18 <alloc_block_BF+0x265>
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 04             	mov    0x4(%eax),%eax
  802b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b12:	8b 12                	mov    (%edx),%edx
  802b14:	89 10                	mov    %edx,(%eax)
  802b16:	eb 0a                	jmp    802b22 <alloc_block_BF+0x26f>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	a3 48 40 98 00       	mov    %eax,0x984048
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b35:	a1 54 40 98 00       	mov    0x984054,%eax
  802b3a:	48                   	dec    %eax
  802b3b:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802b43:	c9                   	leave  
  802b44:	c3                   	ret    

00802b45 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802b45:	55                   	push   %ebp
  802b46:	89 e5                	mov    %esp,%ebp
  802b48:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802b4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4f:	0f 84 6a 02 00 00    	je     802dbf <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802b55:	ff 75 08             	pushl  0x8(%ebp)
  802b58:	e8 b9 f4 ff ff       	call   802016 <get_block_size>
  802b5d:	83 c4 04             	add    $0x4,%esp
  802b60:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	83 e8 08             	sub    $0x8,%eax
  802b69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	83 e0 fe             	and    $0xfffffffe,%eax
  802b74:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	f7 d8                	neg    %eax
  802b7c:	89 c2                	mov    %eax,%edx
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	01 d0                	add    %edx,%eax
  802b83:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802b86:	ff 75 e8             	pushl  -0x18(%ebp)
  802b89:	e8 a1 f4 ff ff       	call   80202f <is_free_block>
  802b8e:	83 c4 04             	add    $0x4,%esp
  802b91:	0f be c0             	movsbl %al,%eax
  802b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802b97:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	01 d0                	add    %edx,%eax
  802b9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ba2:	ff 75 e0             	pushl  -0x20(%ebp)
  802ba5:	e8 85 f4 ff ff       	call   80202f <is_free_block>
  802baa:	83 c4 04             	add    $0x4,%esp
  802bad:	0f be c0             	movsbl %al,%eax
  802bb0:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802bb3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802bb7:	75 34                	jne    802bed <free_block+0xa8>
  802bb9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802bbd:	75 2e                	jne    802bed <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802bbf:	ff 75 e8             	pushl  -0x18(%ebp)
  802bc2:	e8 4f f4 ff ff       	call   802016 <get_block_size>
  802bc7:	83 c4 04             	add    $0x4,%esp
  802bca:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bd0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bd3:	01 d0                	add    %edx,%eax
  802bd5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802bd8:	6a 00                	push   $0x0
  802bda:	ff 75 d4             	pushl  -0x2c(%ebp)
  802bdd:	ff 75 e8             	pushl  -0x18(%ebp)
  802be0:	e8 ad f6 ff ff       	call   802292 <set_block_data>
  802be5:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802be8:	e9 d3 01 00 00       	jmp    802dc0 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802bed:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802bf1:	0f 85 c8 00 00 00    	jne    802cbf <free_block+0x17a>
  802bf7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802bfb:	0f 85 be 00 00 00    	jne    802cbf <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802c01:	ff 75 e0             	pushl  -0x20(%ebp)
  802c04:	e8 0d f4 ff ff       	call   802016 <get_block_size>
  802c09:	83 c4 04             	add    $0x4,%esp
  802c0c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c12:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802c15:	01 d0                	add    %edx,%eax
  802c17:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802c1a:	6a 00                	push   $0x0
  802c1c:	ff 75 cc             	pushl  -0x34(%ebp)
  802c1f:	ff 75 08             	pushl  0x8(%ebp)
  802c22:	e8 6b f6 ff ff       	call   802292 <set_block_data>
  802c27:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802c2a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c2e:	75 17                	jne    802c47 <free_block+0x102>
  802c30:	83 ec 04             	sub    $0x4,%esp
  802c33:	68 a0 3d 80 00       	push   $0x803da0
  802c38:	68 87 01 00 00       	push   $0x187
  802c3d:	68 f7 3c 80 00       	push   $0x803cf7
  802c42:	e8 10 d6 ff ff       	call   800257 <_panic>
  802c47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	74 10                	je     802c60 <free_block+0x11b>
  802c50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c58:	8b 52 04             	mov    0x4(%edx),%edx
  802c5b:	89 50 04             	mov    %edx,0x4(%eax)
  802c5e:	eb 0b                	jmp    802c6b <free_block+0x126>
  802c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c63:	8b 40 04             	mov    0x4(%eax),%eax
  802c66:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 0f                	je     802c84 <free_block+0x13f>
  802c75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c78:	8b 40 04             	mov    0x4(%eax),%eax
  802c7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802c7e:	8b 12                	mov    (%edx),%edx
  802c80:	89 10                	mov    %edx,(%eax)
  802c82:	eb 0a                	jmp    802c8e <free_block+0x149>
  802c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	a3 48 40 98 00       	mov    %eax,0x984048
  802c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca1:	a1 54 40 98 00       	mov    0x984054,%eax
  802ca6:	48                   	dec    %eax
  802ca7:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802cac:	83 ec 0c             	sub    $0xc,%esp
  802caf:	ff 75 08             	pushl  0x8(%ebp)
  802cb2:	e8 32 f6 ff ff       	call   8022e9 <insert_sorted_in_freeList>
  802cb7:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802cba:	e9 01 01 00 00       	jmp    802dc0 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802cbf:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802cc3:	0f 85 d3 00 00 00    	jne    802d9c <free_block+0x257>
  802cc9:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802ccd:	0f 85 c9 00 00 00    	jne    802d9c <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802cd3:	83 ec 0c             	sub    $0xc,%esp
  802cd6:	ff 75 e8             	pushl  -0x18(%ebp)
  802cd9:	e8 38 f3 ff ff       	call   802016 <get_block_size>
  802cde:	83 c4 10             	add    $0x10,%esp
  802ce1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802ce4:	83 ec 0c             	sub    $0xc,%esp
  802ce7:	ff 75 e0             	pushl  -0x20(%ebp)
  802cea:	e8 27 f3 ff ff       	call   802016 <get_block_size>
  802cef:	83 c4 10             	add    $0x10,%esp
  802cf2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802cf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802cfb:	01 c2                	add    %eax,%edx
  802cfd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d00:	01 d0                	add    %edx,%eax
  802d02:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802d05:	83 ec 04             	sub    $0x4,%esp
  802d08:	6a 00                	push   $0x0
  802d0a:	ff 75 c0             	pushl  -0x40(%ebp)
  802d0d:	ff 75 e8             	pushl  -0x18(%ebp)
  802d10:	e8 7d f5 ff ff       	call   802292 <set_block_data>
  802d15:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802d18:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d1c:	75 17                	jne    802d35 <free_block+0x1f0>
  802d1e:	83 ec 04             	sub    $0x4,%esp
  802d21:	68 a0 3d 80 00       	push   $0x803da0
  802d26:	68 94 01 00 00       	push   $0x194
  802d2b:	68 f7 3c 80 00       	push   $0x803cf7
  802d30:	e8 22 d5 ff ff       	call   800257 <_panic>
  802d35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 10                	je     802d4e <free_block+0x209>
  802d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d46:	8b 52 04             	mov    0x4(%edx),%edx
  802d49:	89 50 04             	mov    %edx,0x4(%eax)
  802d4c:	eb 0b                	jmp    802d59 <free_block+0x214>
  802d4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d51:	8b 40 04             	mov    0x4(%eax),%eax
  802d54:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d5c:	8b 40 04             	mov    0x4(%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 0f                	je     802d72 <free_block+0x22d>
  802d63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d66:	8b 40 04             	mov    0x4(%eax),%eax
  802d69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d6c:	8b 12                	mov    (%edx),%edx
  802d6e:	89 10                	mov    %edx,(%eax)
  802d70:	eb 0a                	jmp    802d7c <free_block+0x237>
  802d72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	a3 48 40 98 00       	mov    %eax,0x984048
  802d7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8f:	a1 54 40 98 00       	mov    0x984054,%eax
  802d94:	48                   	dec    %eax
  802d95:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802d9a:	eb 24                	jmp    802dc0 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802d9c:	83 ec 04             	sub    $0x4,%esp
  802d9f:	6a 00                	push   $0x0
  802da1:	ff 75 f4             	pushl  -0xc(%ebp)
  802da4:	ff 75 08             	pushl  0x8(%ebp)
  802da7:	e8 e6 f4 ff ff       	call   802292 <set_block_data>
  802dac:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802daf:	83 ec 0c             	sub    $0xc,%esp
  802db2:	ff 75 08             	pushl  0x8(%ebp)
  802db5:	e8 2f f5 ff ff       	call   8022e9 <insert_sorted_in_freeList>
  802dba:	83 c4 10             	add    $0x10,%esp
  802dbd:	eb 01                	jmp    802dc0 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802dbf:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802dc0:	c9                   	leave  
  802dc1:	c3                   	ret    

00802dc2 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802dc2:	55                   	push   %ebp
  802dc3:	89 e5                	mov    %esp,%ebp
  802dc5:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802dc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcc:	75 10                	jne    802dde <realloc_block_FF+0x1c>
  802dce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802dd2:	75 0a                	jne    802dde <realloc_block_FF+0x1c>
	{
		return NULL;
  802dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd9:	e9 8b 04 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802dde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802de2:	75 18                	jne    802dfc <realloc_block_FF+0x3a>
	{
		free_block(va);
  802de4:	83 ec 0c             	sub    $0xc,%esp
  802de7:	ff 75 08             	pushl  0x8(%ebp)
  802dea:	e8 56 fd ff ff       	call   802b45 <free_block>
  802def:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802df2:	b8 00 00 00 00       	mov    $0x0,%eax
  802df7:	e9 6d 04 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802dfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e00:	75 13                	jne    802e15 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802e02:	83 ec 0c             	sub    $0xc,%esp
  802e05:	ff 75 0c             	pushl  0xc(%ebp)
  802e08:	e8 6f f6 ff ff       	call   80247c <alloc_block_FF>
  802e0d:	83 c4 10             	add    $0x10,%esp
  802e10:	e9 54 04 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e18:	83 e0 01             	and    $0x1,%eax
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	74 03                	je     802e22 <realloc_block_FF+0x60>
	{
		new_size++;
  802e1f:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802e22:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802e26:	77 07                	ja     802e2f <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802e28:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802e2f:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802e33:	83 ec 0c             	sub    $0xc,%esp
  802e36:	ff 75 08             	pushl  0x8(%ebp)
  802e39:	e8 d8 f1 ff ff       	call   802016 <get_block_size>
  802e3e:	83 c4 10             	add    $0x10,%esp
  802e41:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802e4a:	75 08                	jne    802e54 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	e9 15 04 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802e54:	8b 55 08             	mov    0x8(%ebp),%edx
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	01 d0                	add    %edx,%eax
  802e5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802e5f:	83 ec 0c             	sub    $0xc,%esp
  802e62:	ff 75 f0             	pushl  -0x10(%ebp)
  802e65:	e8 c5 f1 ff ff       	call   80202f <is_free_block>
  802e6a:	83 c4 10             	add    $0x10,%esp
  802e6d:	0f be c0             	movsbl %al,%eax
  802e70:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802e73:	83 ec 0c             	sub    $0xc,%esp
  802e76:	ff 75 f0             	pushl  -0x10(%ebp)
  802e79:	e8 98 f1 ff ff       	call   802016 <get_block_size>
  802e7e:	83 c4 10             	add    $0x10,%esp
  802e81:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e87:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802e8a:	0f 86 a7 02 00 00    	jbe    803137 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802e90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e94:	0f 84 86 02 00 00    	je     803120 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802e9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	01 d0                	add    %edx,%eax
  802ea2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ea5:	0f 85 b2 00 00 00    	jne    802f5d <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802eab:	83 ec 0c             	sub    $0xc,%esp
  802eae:	ff 75 08             	pushl  0x8(%ebp)
  802eb1:	e8 79 f1 ff ff       	call   80202f <is_free_block>
  802eb6:	83 c4 10             	add    $0x10,%esp
  802eb9:	84 c0                	test   %al,%al
  802ebb:	0f 94 c0             	sete   %al
  802ebe:	0f b6 c0             	movzbl %al,%eax
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	50                   	push   %eax
  802ec5:	ff 75 0c             	pushl  0xc(%ebp)
  802ec8:	ff 75 08             	pushl  0x8(%ebp)
  802ecb:	e8 c2 f3 ff ff       	call   802292 <set_block_data>
  802ed0:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802ed3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ed7:	75 17                	jne    802ef0 <realloc_block_FF+0x12e>
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	68 a0 3d 80 00       	push   $0x803da0
  802ee1:	68 db 01 00 00       	push   $0x1db
  802ee6:	68 f7 3c 80 00       	push   $0x803cf7
  802eeb:	e8 67 d3 ff ff       	call   800257 <_panic>
  802ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef3:	8b 00                	mov    (%eax),%eax
  802ef5:	85 c0                	test   %eax,%eax
  802ef7:	74 10                	je     802f09 <realloc_block_FF+0x147>
  802ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f01:	8b 52 04             	mov    0x4(%edx),%edx
  802f04:	89 50 04             	mov    %edx,0x4(%eax)
  802f07:	eb 0b                	jmp    802f14 <realloc_block_FF+0x152>
  802f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0c:	8b 40 04             	mov    0x4(%eax),%eax
  802f0f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 0f                	je     802f2d <realloc_block_FF+0x16b>
  802f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f27:	8b 12                	mov    (%edx),%edx
  802f29:	89 10                	mov    %edx,(%eax)
  802f2b:	eb 0a                	jmp    802f37 <realloc_block_FF+0x175>
  802f2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	a3 48 40 98 00       	mov    %eax,0x984048
  802f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4a:	a1 54 40 98 00       	mov    0x984054,%eax
  802f4f:	48                   	dec    %eax
  802f50:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	e9 0c 03 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802f5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f63:	01 d0                	add    %edx,%eax
  802f65:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802f68:	0f 86 b2 01 00 00    	jbe    803120 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f71:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802f77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802f7d:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802f80:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802f84:	0f 87 b8 00 00 00    	ja     803042 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802f8a:	83 ec 0c             	sub    $0xc,%esp
  802f8d:	ff 75 08             	pushl  0x8(%ebp)
  802f90:	e8 9a f0 ff ff       	call   80202f <is_free_block>
  802f95:	83 c4 10             	add    $0x10,%esp
  802f98:	84 c0                	test   %al,%al
  802f9a:	0f 94 c0             	sete   %al
  802f9d:	0f b6 c0             	movzbl %al,%eax
  802fa0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802fa3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fa6:	01 ca                	add    %ecx,%edx
  802fa8:	83 ec 04             	sub    $0x4,%esp
  802fab:	50                   	push   %eax
  802fac:	52                   	push   %edx
  802fad:	ff 75 08             	pushl  0x8(%ebp)
  802fb0:	e8 dd f2 ff ff       	call   802292 <set_block_data>
  802fb5:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802fb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fbc:	75 17                	jne    802fd5 <realloc_block_FF+0x213>
  802fbe:	83 ec 04             	sub    $0x4,%esp
  802fc1:	68 a0 3d 80 00       	push   $0x803da0
  802fc6:	68 e8 01 00 00       	push   $0x1e8
  802fcb:	68 f7 3c 80 00       	push   $0x803cf7
  802fd0:	e8 82 d2 ff ff       	call   800257 <_panic>
  802fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 10                	je     802fee <realloc_block_FF+0x22c>
  802fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe1:	8b 00                	mov    (%eax),%eax
  802fe3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fe6:	8b 52 04             	mov    0x4(%edx),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	eb 0b                	jmp    802ff9 <realloc_block_FF+0x237>
  802fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff1:	8b 40 04             	mov    0x4(%eax),%eax
  802ff4:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	85 c0                	test   %eax,%eax
  803001:	74 0f                	je     803012 <realloc_block_FF+0x250>
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	8b 40 04             	mov    0x4(%eax),%eax
  803009:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80300c:	8b 12                	mov    (%edx),%edx
  80300e:	89 10                	mov    %edx,(%eax)
  803010:	eb 0a                	jmp    80301c <realloc_block_FF+0x25a>
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	a3 48 40 98 00       	mov    %eax,0x984048
  80301c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803025:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803028:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302f:	a1 54 40 98 00       	mov    0x984054,%eax
  803034:	48                   	dec    %eax
  803035:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	e9 27 02 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803042:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803046:	75 17                	jne    80305f <realloc_block_FF+0x29d>
  803048:	83 ec 04             	sub    $0x4,%esp
  80304b:	68 a0 3d 80 00       	push   $0x803da0
  803050:	68 ed 01 00 00       	push   $0x1ed
  803055:	68 f7 3c 80 00       	push   $0x803cf7
  80305a:	e8 f8 d1 ff ff       	call   800257 <_panic>
  80305f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 10                	je     803078 <realloc_block_FF+0x2b6>
  803068:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306b:	8b 00                	mov    (%eax),%eax
  80306d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803070:	8b 52 04             	mov    0x4(%edx),%edx
  803073:	89 50 04             	mov    %edx,0x4(%eax)
  803076:	eb 0b                	jmp    803083 <realloc_block_FF+0x2c1>
  803078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307b:	8b 40 04             	mov    0x4(%eax),%eax
  80307e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803083:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803086:	8b 40 04             	mov    0x4(%eax),%eax
  803089:	85 c0                	test   %eax,%eax
  80308b:	74 0f                	je     80309c <realloc_block_FF+0x2da>
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	8b 40 04             	mov    0x4(%eax),%eax
  803093:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803096:	8b 12                	mov    (%edx),%edx
  803098:	89 10                	mov    %edx,(%eax)
  80309a:	eb 0a                	jmp    8030a6 <realloc_block_FF+0x2e4>
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309f:	8b 00                	mov    (%eax),%eax
  8030a1:	a3 48 40 98 00       	mov    %eax,0x984048
  8030a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b9:	a1 54 40 98 00       	mov    0x984054,%eax
  8030be:	48                   	dec    %eax
  8030bf:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8030c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ca:	01 d0                	add    %edx,%eax
  8030cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8030cf:	83 ec 04             	sub    $0x4,%esp
  8030d2:	6a 00                	push   $0x0
  8030d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8030d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8030da:	e8 b3 f1 ff ff       	call   802292 <set_block_data>
  8030df:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8030e2:	83 ec 0c             	sub    $0xc,%esp
  8030e5:	ff 75 08             	pushl  0x8(%ebp)
  8030e8:	e8 42 ef ff ff       	call   80202f <is_free_block>
  8030ed:	83 c4 10             	add    $0x10,%esp
  8030f0:	84 c0                	test   %al,%al
  8030f2:	0f 94 c0             	sete   %al
  8030f5:	0f b6 c0             	movzbl %al,%eax
  8030f8:	83 ec 04             	sub    $0x4,%esp
  8030fb:	50                   	push   %eax
  8030fc:	ff 75 0c             	pushl  0xc(%ebp)
  8030ff:	ff 75 08             	pushl  0x8(%ebp)
  803102:	e8 8b f1 ff ff       	call   802292 <set_block_data>
  803107:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80310a:	83 ec 0c             	sub    $0xc,%esp
  80310d:	ff 75 f0             	pushl  -0x10(%ebp)
  803110:	e8 d4 f1 ff ff       	call   8022e9 <insert_sorted_in_freeList>
  803115:	83 c4 10             	add    $0x10,%esp
					return va;
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	e9 49 01 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803120:	8b 45 0c             	mov    0xc(%ebp),%eax
  803123:	83 e8 08             	sub    $0x8,%eax
  803126:	83 ec 0c             	sub    $0xc,%esp
  803129:	50                   	push   %eax
  80312a:	e8 4d f3 ff ff       	call   80247c <alloc_block_FF>
  80312f:	83 c4 10             	add    $0x10,%esp
  803132:	e9 32 01 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80313a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80313d:	0f 83 21 01 00 00    	jae    803264 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	2b 45 0c             	sub    0xc(%ebp),%eax
  803149:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80314c:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803150:	77 0e                	ja     803160 <realloc_block_FF+0x39e>
  803152:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803156:	75 08                	jne    803160 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	e9 09 01 00 00       	jmp    803269 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803166:	83 ec 0c             	sub    $0xc,%esp
  803169:	ff 75 08             	pushl  0x8(%ebp)
  80316c:	e8 be ee ff ff       	call   80202f <is_free_block>
  803171:	83 c4 10             	add    $0x10,%esp
  803174:	84 c0                	test   %al,%al
  803176:	0f 94 c0             	sete   %al
  803179:	0f b6 c0             	movzbl %al,%eax
  80317c:	83 ec 04             	sub    $0x4,%esp
  80317f:	50                   	push   %eax
  803180:	ff 75 0c             	pushl  0xc(%ebp)
  803183:	ff 75 d8             	pushl  -0x28(%ebp)
  803186:	e8 07 f1 ff ff       	call   802292 <set_block_data>
  80318b:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80318e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803191:	8b 45 0c             	mov    0xc(%ebp),%eax
  803194:	01 d0                	add    %edx,%eax
  803196:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803199:	83 ec 04             	sub    $0x4,%esp
  80319c:	6a 00                	push   $0x0
  80319e:	ff 75 dc             	pushl  -0x24(%ebp)
  8031a1:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031a4:	e8 e9 f0 ff ff       	call   802292 <set_block_data>
  8031a9:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8031ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031b0:	0f 84 9b 00 00 00    	je     803251 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8031b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8031b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031bc:	01 d0                	add    %edx,%eax
  8031be:	83 ec 04             	sub    $0x4,%esp
  8031c1:	6a 00                	push   $0x0
  8031c3:	50                   	push   %eax
  8031c4:	ff 75 d4             	pushl  -0x2c(%ebp)
  8031c7:	e8 c6 f0 ff ff       	call   802292 <set_block_data>
  8031cc:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8031cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031d3:	75 17                	jne    8031ec <realloc_block_FF+0x42a>
  8031d5:	83 ec 04             	sub    $0x4,%esp
  8031d8:	68 a0 3d 80 00       	push   $0x803da0
  8031dd:	68 10 02 00 00       	push   $0x210
  8031e2:	68 f7 3c 80 00       	push   $0x803cf7
  8031e7:	e8 6b d0 ff ff       	call   800257 <_panic>
  8031ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 10                	je     803205 <realloc_block_FF+0x443>
  8031f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f8:	8b 00                	mov    (%eax),%eax
  8031fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031fd:	8b 52 04             	mov    0x4(%edx),%edx
  803200:	89 50 04             	mov    %edx,0x4(%eax)
  803203:	eb 0b                	jmp    803210 <realloc_block_FF+0x44e>
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	8b 40 04             	mov    0x4(%eax),%eax
  80320b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803210:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803213:	8b 40 04             	mov    0x4(%eax),%eax
  803216:	85 c0                	test   %eax,%eax
  803218:	74 0f                	je     803229 <realloc_block_FF+0x467>
  80321a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803223:	8b 12                	mov    (%edx),%edx
  803225:	89 10                	mov    %edx,(%eax)
  803227:	eb 0a                	jmp    803233 <realloc_block_FF+0x471>
  803229:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	a3 48 40 98 00       	mov    %eax,0x984048
  803233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803236:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80323c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 54 40 98 00       	mov    0x984054,%eax
  80324b:	48                   	dec    %eax
  80324c:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  803251:	83 ec 0c             	sub    $0xc,%esp
  803254:	ff 75 d4             	pushl  -0x2c(%ebp)
  803257:	e8 8d f0 ff ff       	call   8022e9 <insert_sorted_in_freeList>
  80325c:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80325f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803262:	eb 05                	jmp    803269 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803264:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803269:	c9                   	leave  
  80326a:	c3                   	ret    

0080326b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80326b:	55                   	push   %ebp
  80326c:	89 e5                	mov    %esp,%ebp
  80326e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803271:	83 ec 04             	sub    $0x4,%esp
  803274:	68 c0 3d 80 00       	push   $0x803dc0
  803279:	68 20 02 00 00       	push   $0x220
  80327e:	68 f7 3c 80 00       	push   $0x803cf7
  803283:	e8 cf cf ff ff       	call   800257 <_panic>

00803288 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803288:	55                   	push   %ebp
  803289:	89 e5                	mov    %esp,%ebp
  80328b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80328e:	83 ec 04             	sub    $0x4,%esp
  803291:	68 e8 3d 80 00       	push   $0x803de8
  803296:	68 28 02 00 00       	push   $0x228
  80329b:	68 f7 3c 80 00       	push   $0x803cf7
  8032a0:	e8 b2 cf ff ff       	call   800257 <_panic>
  8032a5:	66 90                	xchg   %ax,%ax
  8032a7:	90                   	nop

008032a8 <__udivdi3>:
  8032a8:	55                   	push   %ebp
  8032a9:	57                   	push   %edi
  8032aa:	56                   	push   %esi
  8032ab:	53                   	push   %ebx
  8032ac:	83 ec 1c             	sub    $0x1c,%esp
  8032af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032bf:	89 ca                	mov    %ecx,%edx
  8032c1:	89 f8                	mov    %edi,%eax
  8032c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032c7:	85 f6                	test   %esi,%esi
  8032c9:	75 2d                	jne    8032f8 <__udivdi3+0x50>
  8032cb:	39 cf                	cmp    %ecx,%edi
  8032cd:	77 65                	ja     803334 <__udivdi3+0x8c>
  8032cf:	89 fd                	mov    %edi,%ebp
  8032d1:	85 ff                	test   %edi,%edi
  8032d3:	75 0b                	jne    8032e0 <__udivdi3+0x38>
  8032d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8032da:	31 d2                	xor    %edx,%edx
  8032dc:	f7 f7                	div    %edi
  8032de:	89 c5                	mov    %eax,%ebp
  8032e0:	31 d2                	xor    %edx,%edx
  8032e2:	89 c8                	mov    %ecx,%eax
  8032e4:	f7 f5                	div    %ebp
  8032e6:	89 c1                	mov    %eax,%ecx
  8032e8:	89 d8                	mov    %ebx,%eax
  8032ea:	f7 f5                	div    %ebp
  8032ec:	89 cf                	mov    %ecx,%edi
  8032ee:	89 fa                	mov    %edi,%edx
  8032f0:	83 c4 1c             	add    $0x1c,%esp
  8032f3:	5b                   	pop    %ebx
  8032f4:	5e                   	pop    %esi
  8032f5:	5f                   	pop    %edi
  8032f6:	5d                   	pop    %ebp
  8032f7:	c3                   	ret    
  8032f8:	39 ce                	cmp    %ecx,%esi
  8032fa:	77 28                	ja     803324 <__udivdi3+0x7c>
  8032fc:	0f bd fe             	bsr    %esi,%edi
  8032ff:	83 f7 1f             	xor    $0x1f,%edi
  803302:	75 40                	jne    803344 <__udivdi3+0x9c>
  803304:	39 ce                	cmp    %ecx,%esi
  803306:	72 0a                	jb     803312 <__udivdi3+0x6a>
  803308:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80330c:	0f 87 9e 00 00 00    	ja     8033b0 <__udivdi3+0x108>
  803312:	b8 01 00 00 00       	mov    $0x1,%eax
  803317:	89 fa                	mov    %edi,%edx
  803319:	83 c4 1c             	add    $0x1c,%esp
  80331c:	5b                   	pop    %ebx
  80331d:	5e                   	pop    %esi
  80331e:	5f                   	pop    %edi
  80331f:	5d                   	pop    %ebp
  803320:	c3                   	ret    
  803321:	8d 76 00             	lea    0x0(%esi),%esi
  803324:	31 ff                	xor    %edi,%edi
  803326:	31 c0                	xor    %eax,%eax
  803328:	89 fa                	mov    %edi,%edx
  80332a:	83 c4 1c             	add    $0x1c,%esp
  80332d:	5b                   	pop    %ebx
  80332e:	5e                   	pop    %esi
  80332f:	5f                   	pop    %edi
  803330:	5d                   	pop    %ebp
  803331:	c3                   	ret    
  803332:	66 90                	xchg   %ax,%ax
  803334:	89 d8                	mov    %ebx,%eax
  803336:	f7 f7                	div    %edi
  803338:	31 ff                	xor    %edi,%edi
  80333a:	89 fa                	mov    %edi,%edx
  80333c:	83 c4 1c             	add    $0x1c,%esp
  80333f:	5b                   	pop    %ebx
  803340:	5e                   	pop    %esi
  803341:	5f                   	pop    %edi
  803342:	5d                   	pop    %ebp
  803343:	c3                   	ret    
  803344:	bd 20 00 00 00       	mov    $0x20,%ebp
  803349:	89 eb                	mov    %ebp,%ebx
  80334b:	29 fb                	sub    %edi,%ebx
  80334d:	89 f9                	mov    %edi,%ecx
  80334f:	d3 e6                	shl    %cl,%esi
  803351:	89 c5                	mov    %eax,%ebp
  803353:	88 d9                	mov    %bl,%cl
  803355:	d3 ed                	shr    %cl,%ebp
  803357:	89 e9                	mov    %ebp,%ecx
  803359:	09 f1                	or     %esi,%ecx
  80335b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80335f:	89 f9                	mov    %edi,%ecx
  803361:	d3 e0                	shl    %cl,%eax
  803363:	89 c5                	mov    %eax,%ebp
  803365:	89 d6                	mov    %edx,%esi
  803367:	88 d9                	mov    %bl,%cl
  803369:	d3 ee                	shr    %cl,%esi
  80336b:	89 f9                	mov    %edi,%ecx
  80336d:	d3 e2                	shl    %cl,%edx
  80336f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803373:	88 d9                	mov    %bl,%cl
  803375:	d3 e8                	shr    %cl,%eax
  803377:	09 c2                	or     %eax,%edx
  803379:	89 d0                	mov    %edx,%eax
  80337b:	89 f2                	mov    %esi,%edx
  80337d:	f7 74 24 0c          	divl   0xc(%esp)
  803381:	89 d6                	mov    %edx,%esi
  803383:	89 c3                	mov    %eax,%ebx
  803385:	f7 e5                	mul    %ebp
  803387:	39 d6                	cmp    %edx,%esi
  803389:	72 19                	jb     8033a4 <__udivdi3+0xfc>
  80338b:	74 0b                	je     803398 <__udivdi3+0xf0>
  80338d:	89 d8                	mov    %ebx,%eax
  80338f:	31 ff                	xor    %edi,%edi
  803391:	e9 58 ff ff ff       	jmp    8032ee <__udivdi3+0x46>
  803396:	66 90                	xchg   %ax,%ax
  803398:	8b 54 24 08          	mov    0x8(%esp),%edx
  80339c:	89 f9                	mov    %edi,%ecx
  80339e:	d3 e2                	shl    %cl,%edx
  8033a0:	39 c2                	cmp    %eax,%edx
  8033a2:	73 e9                	jae    80338d <__udivdi3+0xe5>
  8033a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033a7:	31 ff                	xor    %edi,%edi
  8033a9:	e9 40 ff ff ff       	jmp    8032ee <__udivdi3+0x46>
  8033ae:	66 90                	xchg   %ax,%ax
  8033b0:	31 c0                	xor    %eax,%eax
  8033b2:	e9 37 ff ff ff       	jmp    8032ee <__udivdi3+0x46>
  8033b7:	90                   	nop

008033b8 <__umoddi3>:
  8033b8:	55                   	push   %ebp
  8033b9:	57                   	push   %edi
  8033ba:	56                   	push   %esi
  8033bb:	53                   	push   %ebx
  8033bc:	83 ec 1c             	sub    $0x1c,%esp
  8033bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033d7:	89 f3                	mov    %esi,%ebx
  8033d9:	89 fa                	mov    %edi,%edx
  8033db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033df:	89 34 24             	mov    %esi,(%esp)
  8033e2:	85 c0                	test   %eax,%eax
  8033e4:	75 1a                	jne    803400 <__umoddi3+0x48>
  8033e6:	39 f7                	cmp    %esi,%edi
  8033e8:	0f 86 a2 00 00 00    	jbe    803490 <__umoddi3+0xd8>
  8033ee:	89 c8                	mov    %ecx,%eax
  8033f0:	89 f2                	mov    %esi,%edx
  8033f2:	f7 f7                	div    %edi
  8033f4:	89 d0                	mov    %edx,%eax
  8033f6:	31 d2                	xor    %edx,%edx
  8033f8:	83 c4 1c             	add    $0x1c,%esp
  8033fb:	5b                   	pop    %ebx
  8033fc:	5e                   	pop    %esi
  8033fd:	5f                   	pop    %edi
  8033fe:	5d                   	pop    %ebp
  8033ff:	c3                   	ret    
  803400:	39 f0                	cmp    %esi,%eax
  803402:	0f 87 ac 00 00 00    	ja     8034b4 <__umoddi3+0xfc>
  803408:	0f bd e8             	bsr    %eax,%ebp
  80340b:	83 f5 1f             	xor    $0x1f,%ebp
  80340e:	0f 84 ac 00 00 00    	je     8034c0 <__umoddi3+0x108>
  803414:	bf 20 00 00 00       	mov    $0x20,%edi
  803419:	29 ef                	sub    %ebp,%edi
  80341b:	89 fe                	mov    %edi,%esi
  80341d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803421:	89 e9                	mov    %ebp,%ecx
  803423:	d3 e0                	shl    %cl,%eax
  803425:	89 d7                	mov    %edx,%edi
  803427:	89 f1                	mov    %esi,%ecx
  803429:	d3 ef                	shr    %cl,%edi
  80342b:	09 c7                	or     %eax,%edi
  80342d:	89 e9                	mov    %ebp,%ecx
  80342f:	d3 e2                	shl    %cl,%edx
  803431:	89 14 24             	mov    %edx,(%esp)
  803434:	89 d8                	mov    %ebx,%eax
  803436:	d3 e0                	shl    %cl,%eax
  803438:	89 c2                	mov    %eax,%edx
  80343a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80343e:	d3 e0                	shl    %cl,%eax
  803440:	89 44 24 04          	mov    %eax,0x4(%esp)
  803444:	8b 44 24 08          	mov    0x8(%esp),%eax
  803448:	89 f1                	mov    %esi,%ecx
  80344a:	d3 e8                	shr    %cl,%eax
  80344c:	09 d0                	or     %edx,%eax
  80344e:	d3 eb                	shr    %cl,%ebx
  803450:	89 da                	mov    %ebx,%edx
  803452:	f7 f7                	div    %edi
  803454:	89 d3                	mov    %edx,%ebx
  803456:	f7 24 24             	mull   (%esp)
  803459:	89 c6                	mov    %eax,%esi
  80345b:	89 d1                	mov    %edx,%ecx
  80345d:	39 d3                	cmp    %edx,%ebx
  80345f:	0f 82 87 00 00 00    	jb     8034ec <__umoddi3+0x134>
  803465:	0f 84 91 00 00 00    	je     8034fc <__umoddi3+0x144>
  80346b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80346f:	29 f2                	sub    %esi,%edx
  803471:	19 cb                	sbb    %ecx,%ebx
  803473:	89 d8                	mov    %ebx,%eax
  803475:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803479:	d3 e0                	shl    %cl,%eax
  80347b:	89 e9                	mov    %ebp,%ecx
  80347d:	d3 ea                	shr    %cl,%edx
  80347f:	09 d0                	or     %edx,%eax
  803481:	89 e9                	mov    %ebp,%ecx
  803483:	d3 eb                	shr    %cl,%ebx
  803485:	89 da                	mov    %ebx,%edx
  803487:	83 c4 1c             	add    $0x1c,%esp
  80348a:	5b                   	pop    %ebx
  80348b:	5e                   	pop    %esi
  80348c:	5f                   	pop    %edi
  80348d:	5d                   	pop    %ebp
  80348e:	c3                   	ret    
  80348f:	90                   	nop
  803490:	89 fd                	mov    %edi,%ebp
  803492:	85 ff                	test   %edi,%edi
  803494:	75 0b                	jne    8034a1 <__umoddi3+0xe9>
  803496:	b8 01 00 00 00       	mov    $0x1,%eax
  80349b:	31 d2                	xor    %edx,%edx
  80349d:	f7 f7                	div    %edi
  80349f:	89 c5                	mov    %eax,%ebp
  8034a1:	89 f0                	mov    %esi,%eax
  8034a3:	31 d2                	xor    %edx,%edx
  8034a5:	f7 f5                	div    %ebp
  8034a7:	89 c8                	mov    %ecx,%eax
  8034a9:	f7 f5                	div    %ebp
  8034ab:	89 d0                	mov    %edx,%eax
  8034ad:	e9 44 ff ff ff       	jmp    8033f6 <__umoddi3+0x3e>
  8034b2:	66 90                	xchg   %ax,%ax
  8034b4:	89 c8                	mov    %ecx,%eax
  8034b6:	89 f2                	mov    %esi,%edx
  8034b8:	83 c4 1c             	add    $0x1c,%esp
  8034bb:	5b                   	pop    %ebx
  8034bc:	5e                   	pop    %esi
  8034bd:	5f                   	pop    %edi
  8034be:	5d                   	pop    %ebp
  8034bf:	c3                   	ret    
  8034c0:	3b 04 24             	cmp    (%esp),%eax
  8034c3:	72 06                	jb     8034cb <__umoddi3+0x113>
  8034c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034c9:	77 0f                	ja     8034da <__umoddi3+0x122>
  8034cb:	89 f2                	mov    %esi,%edx
  8034cd:	29 f9                	sub    %edi,%ecx
  8034cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034d3:	89 14 24             	mov    %edx,(%esp)
  8034d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034de:	8b 14 24             	mov    (%esp),%edx
  8034e1:	83 c4 1c             	add    $0x1c,%esp
  8034e4:	5b                   	pop    %ebx
  8034e5:	5e                   	pop    %esi
  8034e6:	5f                   	pop    %edi
  8034e7:	5d                   	pop    %ebp
  8034e8:	c3                   	ret    
  8034e9:	8d 76 00             	lea    0x0(%esi),%esi
  8034ec:	2b 04 24             	sub    (%esp),%eax
  8034ef:	19 fa                	sbb    %edi,%edx
  8034f1:	89 d1                	mov    %edx,%ecx
  8034f3:	89 c6                	mov    %eax,%esi
  8034f5:	e9 71 ff ff ff       	jmp    80346b <__umoddi3+0xb3>
  8034fa:	66 90                	xchg   %ax,%ax
  8034fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803500:	72 ea                	jb     8034ec <__umoddi3+0x134>
  803502:	89 d9                	mov    %ebx,%ecx
  803504:	e9 62 ff ff ff       	jmp    80346b <__umoddi3+0xb3>
