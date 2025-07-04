
obj/user/concurrent_start:     file format elf32-i386


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
  800031:	e8 f9 00 00 00       	call   80012f <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// hello, world
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	char *str ;
	sys_createSharedObject("cnc1", 512, 1, (void*) &str);
  80003e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800041:	50                   	push   %eax
  800042:	6a 01                	push   $0x1
  800044:	68 00 02 00 00       	push   $0x200
  800049:	68 e0 36 80 00       	push   $0x8036e0
  80004e:	e8 70 14 00 00       	call   8014c3 <sys_createSharedObject>
  800053:	83 c4 10             	add    $0x10,%esp

	struct semaphore cnc1 = create_semaphore("cnc1", 1);
  800056:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800059:	83 ec 04             	sub    $0x4,%esp
  80005c:	6a 01                	push   $0x1
  80005e:	68 e0 36 80 00       	push   $0x8036e0
  800063:	50                   	push   %eax
  800064:	e8 ff 18 00 00       	call   801968 <create_semaphore>
  800069:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80006c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80006f:	83 ec 04             	sub    $0x4,%esp
  800072:	6a 00                	push   $0x0
  800074:	68 e5 36 80 00       	push   $0x8036e5
  800079:	50                   	push   %eax
  80007a:	e8 e9 18 00 00       	call   801968 <create_semaphore>
  80007f:	83 c4 0c             	add    $0xc,%esp

	uint32 id1, id2;
	id2 = sys_create_env("qs2", (myEnv->page_WS_max_size), (myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800082:	a1 20 40 80 00       	mov    0x804020,%eax
  800087:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  80008d:	a1 20 40 80 00       	mov    0x804020,%eax
  800092:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800098:	89 c1                	mov    %eax,%ecx
  80009a:	a1 20 40 80 00       	mov    0x804020,%eax
  80009f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000a5:	52                   	push   %edx
  8000a6:	51                   	push   %ecx
  8000a7:	50                   	push   %eax
  8000a8:	68 ed 36 80 00       	push   $0x8036ed
  8000ad:	e8 94 14 00 00       	call   801546 <sys_create_env>
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	id1 = sys_create_env("qs1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8000bd:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c8:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000ce:	89 c1                	mov    %eax,%ecx
  8000d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000db:	52                   	push   %edx
  8000dc:	51                   	push   %ecx
  8000dd:	50                   	push   %eax
  8000de:	68 f1 36 80 00       	push   $0x8036f1
  8000e3:	e8 5e 14 00 00       	call   801546 <sys_create_env>
  8000e8:	83 c4 10             	add    $0x10,%esp
  8000eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR)
  8000ee:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000f2:	74 06                	je     8000fa <_main+0xc2>
  8000f4:	83 7d f4 ef          	cmpl   $0xffffffef,-0xc(%ebp)
  8000f8:	75 14                	jne    80010e <_main+0xd6>
		panic("NO AVAILABLE ENVs...");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 f5 36 80 00       	push   $0x8036f5
  800102:	6a 11                	push   $0x11
  800104:	68 0a 37 80 00       	push   $0x80370a
  800109:	e8 66 01 00 00       	call   800274 <_panic>

	sys_run_env(id2);
  80010e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	50                   	push   %eax
  800115:	e8 4a 14 00 00       	call   801564 <sys_run_env>
  80011a:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id1);
  80011d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 3b 14 00 00       	call   801564 <sys_run_env>
  800129:	83 c4 10             	add    $0x10,%esp

	return;
  80012c:	90                   	nop
}
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800135:	e8 7a 14 00 00       	call   8015b4 <sys_getenvindex>
  80013a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800140:	89 d0                	mov    %edx,%eax
  800142:	c1 e0 02             	shl    $0x2,%eax
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800153:	01 d0                	add    %edx,%eax
  800155:	c1 e0 02             	shl    $0x2,%eax
  800158:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800162:	a1 20 40 80 00       	mov    0x804020,%eax
  800167:	8a 40 20             	mov    0x20(%eax),%al
  80016a:	84 c0                	test   %al,%al
  80016c:	74 0d                	je     80017b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80016e:	a1 20 40 80 00       	mov    0x804020,%eax
  800173:	83 c0 20             	add    $0x20,%eax
  800176:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80017f:	7e 0a                	jle    80018b <libmain+0x5c>
		binaryname = argv[0];
  800181:	8b 45 0c             	mov    0xc(%ebp),%eax
  800184:	8b 00                	mov    (%eax),%eax
  800186:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80018b:	83 ec 08             	sub    $0x8,%esp
  80018e:	ff 75 0c             	pushl  0xc(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9f fe ff ff       	call   800038 <_main>
  800199:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80019c:	a1 00 40 80 00       	mov    0x804000,%eax
  8001a1:	85 c0                	test   %eax,%eax
  8001a3:	0f 84 9f 00 00 00    	je     800248 <libmain+0x119>
	{
		sys_lock_cons();
  8001a9:	e8 8a 11 00 00       	call   801338 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	68 3c 37 80 00       	push   $0x80373c
  8001b6:	e8 76 03 00 00       	call   800531 <cprintf>
  8001bb:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001be:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c3:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001d4:	83 ec 04             	sub    $0x4,%esp
  8001d7:	52                   	push   %edx
  8001d8:	50                   	push   %eax
  8001d9:	68 64 37 80 00       	push   $0x803764
  8001de:	e8 4e 03 00 00       	call   800531 <cprintf>
  8001e3:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001eb:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800207:	51                   	push   %ecx
  800208:	52                   	push   %edx
  800209:	50                   	push   %eax
  80020a:	68 8c 37 80 00       	push   $0x80378c
  80020f:	e8 1d 03 00 00       	call   800531 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800217:	a1 20 40 80 00       	mov    0x804020,%eax
  80021c:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800222:	83 ec 08             	sub    $0x8,%esp
  800225:	50                   	push   %eax
  800226:	68 e4 37 80 00       	push   $0x8037e4
  80022b:	e8 01 03 00 00       	call   800531 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800233:	83 ec 0c             	sub    $0xc,%esp
  800236:	68 3c 37 80 00       	push   $0x80373c
  80023b:	e8 f1 02 00 00       	call   800531 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800243:	e8 0a 11 00 00       	call   801352 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800248:	e8 19 00 00 00       	call   800266 <exit>
}
  80024d:	90                   	nop
  80024e:	c9                   	leave  
  80024f:	c3                   	ret    

00800250 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800250:	55                   	push   %ebp
  800251:	89 e5                	mov    %esp,%ebp
  800253:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	6a 00                	push   $0x0
  80025b:	e8 20 13 00 00       	call   801580 <sys_destroy_env>
  800260:	83 c4 10             	add    $0x10,%esp
}
  800263:	90                   	nop
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <exit>:

void
exit(void)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026c:	e8 75 13 00 00       	call   8015e6 <sys_exit_env>
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027a:	8d 45 10             	lea    0x10(%ebp),%eax
  80027d:	83 c0 04             	add    $0x4,%eax
  800280:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800283:	a1 60 40 98 00       	mov    0x984060,%eax
  800288:	85 c0                	test   %eax,%eax
  80028a:	74 16                	je     8002a2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028c:	a1 60 40 98 00       	mov    0x984060,%eax
  800291:	83 ec 08             	sub    $0x8,%esp
  800294:	50                   	push   %eax
  800295:	68 f8 37 80 00       	push   $0x8037f8
  80029a:	e8 92 02 00 00       	call   800531 <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a2:	a1 04 40 80 00       	mov    0x804004,%eax
  8002a7:	ff 75 0c             	pushl  0xc(%ebp)
  8002aa:	ff 75 08             	pushl  0x8(%ebp)
  8002ad:	50                   	push   %eax
  8002ae:	68 fd 37 80 00       	push   $0x8037fd
  8002b3:	e8 79 02 00 00       	call   800531 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8002be:	83 ec 08             	sub    $0x8,%esp
  8002c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c4:	50                   	push   %eax
  8002c5:	e8 fc 01 00 00       	call   8004c6 <vcprintf>
  8002ca:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002cd:	83 ec 08             	sub    $0x8,%esp
  8002d0:	6a 00                	push   $0x0
  8002d2:	68 19 38 80 00       	push   $0x803819
  8002d7:	e8 ea 01 00 00       	call   8004c6 <vcprintf>
  8002dc:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002df:	e8 82 ff ff ff       	call   800266 <exit>

	// should not return here
	while (1) ;
  8002e4:	eb fe                	jmp    8002e4 <_panic+0x70>

008002e6 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e6:	55                   	push   %ebp
  8002e7:	89 e5                	mov    %esp,%ebp
  8002e9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ec:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 1c 38 80 00       	push   $0x80381c
  800306:	6a 26                	push   $0x26
  800308:	68 68 38 80 00       	push   $0x803868
  80030d:	e8 62 ff ff ff       	call   800274 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c5 00 00 00       	jmp    8003ea <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a5 00 00 00       	jmp    8003e7 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
  800357:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
  800377:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 15                	jmp    8003cd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c9:	39 c2                	cmp    %eax,%edx
  8003cb:	77 85                	ja     800352 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d1:	75 14                	jne    8003e7 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003d3:	83 ec 04             	sub    $0x4,%esp
  8003d6:	68 74 38 80 00       	push   $0x803874
  8003db:	6a 3a                	push   $0x3a
  8003dd:	68 68 38 80 00       	push   $0x803868
  8003e2:	e8 8d fe ff ff       	call   800274 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e7:	ff 45 f0             	incl   -0x10(%ebp)
  8003ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ed:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f0:	0f 8c 2f ff ff ff    	jl     800325 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800404:	eb 26                	jmp    80042c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800406:	a1 20 40 80 00       	mov    0x804020,%eax
  80040b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800411:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800414:	89 d0                	mov    %edx,%eax
  800416:	01 c0                	add    %eax,%eax
  800418:	01 d0                	add    %edx,%eax
  80041a:	c1 e0 03             	shl    $0x3,%eax
  80041d:	01 c8                	add    %ecx,%eax
  80041f:	8a 40 04             	mov    0x4(%eax),%al
  800422:	3c 01                	cmp    $0x1,%al
  800424:	75 03                	jne    800429 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800426:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800429:	ff 45 e0             	incl   -0x20(%ebp)
  80042c:	a1 20 40 80 00       	mov    0x804020,%eax
  800431:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043a:	39 c2                	cmp    %eax,%edx
  80043c:	77 c8                	ja     800406 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80043e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800441:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800444:	74 14                	je     80045a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800446:	83 ec 04             	sub    $0x4,%esp
  800449:	68 c8 38 80 00       	push   $0x8038c8
  80044e:	6a 44                	push   $0x44
  800450:	68 68 38 80 00       	push   $0x803868
  800455:	e8 1a fe ff ff       	call   800274 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045a:	90                   	nop
  80045b:	c9                   	leave  
  80045c:	c3                   	ret    

0080045d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	8d 48 01             	lea    0x1(%eax),%ecx
  80046b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046e:	89 0a                	mov    %ecx,(%edx)
  800470:	8b 55 08             	mov    0x8(%ebp),%edx
  800473:	88 d1                	mov    %dl,%cl
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	3d ff 00 00 00       	cmp    $0xff,%eax
  800486:	75 2c                	jne    8004b4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800488:	a0 44 40 98 00       	mov    0x984044,%al
  80048d:	0f b6 c0             	movzbl %al,%eax
  800490:	8b 55 0c             	mov    0xc(%ebp),%edx
  800493:	8b 12                	mov    (%edx),%edx
  800495:	89 d1                	mov    %edx,%ecx
  800497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049a:	83 c2 08             	add    $0x8,%edx
  80049d:	83 ec 04             	sub    $0x4,%esp
  8004a0:	50                   	push   %eax
  8004a1:	51                   	push   %ecx
  8004a2:	52                   	push   %edx
  8004a3:	e8 4e 0e 00 00       	call   8012f6 <sys_cputs>
  8004a8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 40 04             	mov    0x4(%eax),%eax
  8004ba:	8d 50 01             	lea    0x1(%eax),%edx
  8004bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c3:	90                   	nop
  8004c4:	c9                   	leave  
  8004c5:	c3                   	ret    

008004c6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004cf:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d6:	00 00 00 
	b.cnt = 0;
  8004d9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e0:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	ff 75 08             	pushl  0x8(%ebp)
  8004e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004ef:	50                   	push   %eax
  8004f0:	68 5d 04 80 00       	push   $0x80045d
  8004f5:	e8 11 02 00 00       	call   80070b <vprintfmt>
  8004fa:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004fd:	a0 44 40 98 00       	mov    0x984044,%al
  800502:	0f b6 c0             	movzbl %al,%eax
  800505:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050b:	83 ec 04             	sub    $0x4,%esp
  80050e:	50                   	push   %eax
  80050f:	52                   	push   %edx
  800510:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800516:	83 c0 08             	add    $0x8,%eax
  800519:	50                   	push   %eax
  80051a:	e8 d7 0d 00 00       	call   8012f6 <sys_cputs>
  80051f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800522:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
	return b.cnt;
  800529:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800537:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
	va_start(ap, fmt);
  80053e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800541:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 f4             	pushl  -0xc(%ebp)
  80054d:	50                   	push   %eax
  80054e:	e8 73 ff ff ff       	call   8004c6 <vcprintf>
  800553:	83 c4 10             	add    $0x10,%esp
  800556:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800559:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800564:	e8 cf 0d 00 00       	call   801338 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800569:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	ff 75 f4             	pushl  -0xc(%ebp)
  800578:	50                   	push   %eax
  800579:	e8 48 ff ff ff       	call   8004c6 <vcprintf>
  80057e:	83 c4 10             	add    $0x10,%esp
  800581:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800584:	e8 c9 0d 00 00       	call   801352 <sys_unlock_cons>
	return cnt;
  800589:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058c:	c9                   	leave  
  80058d:	c3                   	ret    

0080058e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058e:	55                   	push   %ebp
  80058f:	89 e5                	mov    %esp,%ebp
  800591:	53                   	push   %ebx
  800592:	83 ec 14             	sub    $0x14,%esp
  800595:	8b 45 10             	mov    0x10(%ebp),%eax
  800598:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059b:	8b 45 14             	mov    0x14(%ebp),%eax
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ac:	77 55                	ja     800603 <printnum+0x75>
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	72 05                	jb     8005b8 <printnum+0x2a>
  8005b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b6:	77 4b                	ja     800603 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005be:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c6:	52                   	push   %edx
  8005c7:	50                   	push   %eax
  8005c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ce:	e8 95 2e 00 00       	call   803468 <__udivdi3>
  8005d3:	83 c4 10             	add    $0x10,%esp
  8005d6:	83 ec 04             	sub    $0x4,%esp
  8005d9:	ff 75 20             	pushl  0x20(%ebp)
  8005dc:	53                   	push   %ebx
  8005dd:	ff 75 18             	pushl  0x18(%ebp)
  8005e0:	52                   	push   %edx
  8005e1:	50                   	push   %eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	e8 a1 ff ff ff       	call   80058e <printnum>
  8005ed:	83 c4 20             	add    $0x20,%esp
  8005f0:	eb 1a                	jmp    80060c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 20             	pushl  0x20(%ebp)
  8005fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fe:	ff d0                	call   *%eax
  800600:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800603:	ff 4d 1c             	decl   0x1c(%ebp)
  800606:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060a:	7f e6                	jg     8005f2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80060f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061a:	53                   	push   %ebx
  80061b:	51                   	push   %ecx
  80061c:	52                   	push   %edx
  80061d:	50                   	push   %eax
  80061e:	e8 55 2f 00 00       	call   803578 <__umoddi3>
  800623:	83 c4 10             	add    $0x10,%esp
  800626:	05 34 3b 80 00       	add    $0x803b34,%eax
  80062b:	8a 00                	mov    (%eax),%al
  80062d:	0f be c0             	movsbl %al,%eax
  800630:	83 ec 08             	sub    $0x8,%esp
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	50                   	push   %eax
  800637:	8b 45 08             	mov    0x8(%ebp),%eax
  80063a:	ff d0                	call   *%eax
  80063c:	83 c4 10             	add    $0x10,%esp
}
  80063f:	90                   	nop
  800640:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800648:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064c:	7e 1c                	jle    80066a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 08             	lea    0x8(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 08             	sub    $0x8,%eax
  800663:	8b 50 04             	mov    0x4(%eax),%edx
  800666:	8b 00                	mov    (%eax),%eax
  800668:	eb 40                	jmp    8006aa <getuint+0x65>
	else if (lflag)
  80066a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066e:	74 1e                	je     80068e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	8d 50 04             	lea    0x4(%eax),%edx
  800678:	8b 45 08             	mov    0x8(%ebp),%eax
  80067b:	89 10                	mov    %edx,(%eax)
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	83 e8 04             	sub    $0x4,%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	ba 00 00 00 00       	mov    $0x0,%edx
  80068c:	eb 1c                	jmp    8006aa <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 04             	lea    0x4(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 04             	sub    $0x4,%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006aa:	5d                   	pop    %ebp
  8006ab:	c3                   	ret    

008006ac <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ac:	55                   	push   %ebp
  8006ad:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006af:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b3:	7e 1c                	jle    8006d1 <getint+0x25>
		return va_arg(*ap, long long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 08             	lea    0x8(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 08             	sub    $0x8,%eax
  8006ca:	8b 50 04             	mov    0x4(%eax),%edx
  8006cd:	8b 00                	mov    (%eax),%eax
  8006cf:	eb 38                	jmp    800709 <getint+0x5d>
	else if (lflag)
  8006d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d5:	74 1a                	je     8006f1 <getint+0x45>
		return va_arg(*ap, long);
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	8b 00                	mov    (%eax),%eax
  8006dc:	8d 50 04             	lea    0x4(%eax),%edx
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	89 10                	mov    %edx,(%eax)
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	83 e8 04             	sub    $0x4,%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	99                   	cltd   
  8006ef:	eb 18                	jmp    800709 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	8d 50 04             	lea    0x4(%eax),%edx
  8006f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fc:	89 10                	mov    %edx,(%eax)
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	83 e8 04             	sub    $0x4,%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	99                   	cltd   
}
  800709:	5d                   	pop    %ebp
  80070a:	c3                   	ret    

0080070b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070b:	55                   	push   %ebp
  80070c:	89 e5                	mov    %esp,%ebp
  80070e:	56                   	push   %esi
  80070f:	53                   	push   %ebx
  800710:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800713:	eb 17                	jmp    80072c <vprintfmt+0x21>
			if (ch == '\0')
  800715:	85 db                	test   %ebx,%ebx
  800717:	0f 84 c1 03 00 00    	je     800ade <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	53                   	push   %ebx
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072c:	8b 45 10             	mov    0x10(%ebp),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	89 55 10             	mov    %edx,0x10(%ebp)
  800735:	8a 00                	mov    (%eax),%al
  800737:	0f b6 d8             	movzbl %al,%ebx
  80073a:	83 fb 25             	cmp    $0x25,%ebx
  80073d:	75 d6                	jne    800715 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80073f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800743:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800751:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800758:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80075f:	8b 45 10             	mov    0x10(%ebp),%eax
  800762:	8d 50 01             	lea    0x1(%eax),%edx
  800765:	89 55 10             	mov    %edx,0x10(%ebp)
  800768:	8a 00                	mov    (%eax),%al
  80076a:	0f b6 d8             	movzbl %al,%ebx
  80076d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800770:	83 f8 5b             	cmp    $0x5b,%eax
  800773:	0f 87 3d 03 00 00    	ja     800ab6 <vprintfmt+0x3ab>
  800779:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
  800780:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800782:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800786:	eb d7                	jmp    80075f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800788:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078c:	eb d1                	jmp    80075f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800795:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800798:	89 d0                	mov    %edx,%eax
  80079a:	c1 e0 02             	shl    $0x2,%eax
  80079d:	01 d0                	add    %edx,%eax
  80079f:	01 c0                	add    %eax,%eax
  8007a1:	01 d8                	add    %ebx,%eax
  8007a3:	83 e8 30             	sub    $0x30,%eax
  8007a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ac:	8a 00                	mov    (%eax),%al
  8007ae:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b4:	7e 3e                	jle    8007f4 <vprintfmt+0xe9>
  8007b6:	83 fb 39             	cmp    $0x39,%ebx
  8007b9:	7f 39                	jg     8007f4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007be:	eb d5                	jmp    800795 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 00                	mov    (%eax),%eax
  8007d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d4:	eb 1f                	jmp    8007f5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007da:	79 83                	jns    80075f <vprintfmt+0x54>
				width = 0;
  8007dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e3:	e9 77 ff ff ff       	jmp    80075f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007ef:	e9 6b ff ff ff       	jmp    80075f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f9:	0f 89 60 ff ff ff    	jns    80075f <vprintfmt+0x54>
				width = precision, precision = -1;
  8007ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800805:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080c:	e9 4e ff ff ff       	jmp    80075f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800811:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800814:	e9 46 ff ff ff       	jmp    80075f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	83 c0 04             	add    $0x4,%eax
  80081f:	89 45 14             	mov    %eax,0x14(%ebp)
  800822:	8b 45 14             	mov    0x14(%ebp),%eax
  800825:	83 e8 04             	sub    $0x4,%eax
  800828:	8b 00                	mov    (%eax),%eax
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	50                   	push   %eax
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
			break;
  800839:	e9 9b 02 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
  800847:	8b 45 14             	mov    0x14(%ebp),%eax
  80084a:	83 e8 04             	sub    $0x4,%eax
  80084d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80084f:	85 db                	test   %ebx,%ebx
  800851:	79 02                	jns    800855 <vprintfmt+0x14a>
				err = -err;
  800853:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800855:	83 fb 64             	cmp    $0x64,%ebx
  800858:	7f 0b                	jg     800865 <vprintfmt+0x15a>
  80085a:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  800861:	85 f6                	test   %esi,%esi
  800863:	75 19                	jne    80087e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800865:	53                   	push   %ebx
  800866:	68 45 3b 80 00       	push   $0x803b45
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	e8 70 02 00 00       	call   800ae6 <printfmt>
  800876:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800879:	e9 5b 02 00 00       	jmp    800ad9 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087e:	56                   	push   %esi
  80087f:	68 4e 3b 80 00       	push   $0x803b4e
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	ff 75 08             	pushl  0x8(%ebp)
  80088a:	e8 57 02 00 00       	call   800ae6 <printfmt>
  80088f:	83 c4 10             	add    $0x10,%esp
			break;
  800892:	e9 42 02 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	83 c0 04             	add    $0x4,%eax
  80089d:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a3:	83 e8 04             	sub    $0x4,%eax
  8008a6:	8b 30                	mov    (%eax),%esi
  8008a8:	85 f6                	test   %esi,%esi
  8008aa:	75 05                	jne    8008b1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ac:	be 51 3b 80 00       	mov    $0x803b51,%esi
			if (width > 0 && padc != '-')
  8008b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b5:	7e 6d                	jle    800924 <vprintfmt+0x219>
  8008b7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bb:	74 67                	je     800924 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	50                   	push   %eax
  8008c4:	56                   	push   %esi
  8008c5:	e8 1e 03 00 00       	call   800be8 <strnlen>
  8008ca:	83 c4 10             	add    $0x10,%esp
  8008cd:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d0:	eb 16                	jmp    8008e8 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d6:	83 ec 08             	sub    $0x8,%esp
  8008d9:	ff 75 0c             	pushl  0xc(%ebp)
  8008dc:	50                   	push   %eax
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	ff d0                	call   *%eax
  8008e2:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e5:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ec:	7f e4                	jg     8008d2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ee:	eb 34                	jmp    800924 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f4:	74 1c                	je     800912 <vprintfmt+0x207>
  8008f6:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f9:	7e 05                	jle    800900 <vprintfmt+0x1f5>
  8008fb:	83 fb 7e             	cmp    $0x7e,%ebx
  8008fe:	7e 12                	jle    800912 <vprintfmt+0x207>
					putch('?', putdat);
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	6a 3f                	push   $0x3f
  800908:	8b 45 08             	mov    0x8(%ebp),%eax
  80090b:	ff d0                	call   *%eax
  80090d:	83 c4 10             	add    $0x10,%esp
  800910:	eb 0f                	jmp    800921 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800912:	83 ec 08             	sub    $0x8,%esp
  800915:	ff 75 0c             	pushl  0xc(%ebp)
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	ff d0                	call   *%eax
  80091e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800921:	ff 4d e4             	decl   -0x1c(%ebp)
  800924:	89 f0                	mov    %esi,%eax
  800926:	8d 70 01             	lea    0x1(%eax),%esi
  800929:	8a 00                	mov    (%eax),%al
  80092b:	0f be d8             	movsbl %al,%ebx
  80092e:	85 db                	test   %ebx,%ebx
  800930:	74 24                	je     800956 <vprintfmt+0x24b>
  800932:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800936:	78 b8                	js     8008f0 <vprintfmt+0x1e5>
  800938:	ff 4d e0             	decl   -0x20(%ebp)
  80093b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093f:	79 af                	jns    8008f0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800941:	eb 13                	jmp    800956 <vprintfmt+0x24b>
				putch(' ', putdat);
  800943:	83 ec 08             	sub    $0x8,%esp
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	6a 20                	push   $0x20
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	ff d0                	call   *%eax
  800950:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800953:	ff 4d e4             	decl   -0x1c(%ebp)
  800956:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095a:	7f e7                	jg     800943 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095c:	e9 78 01 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 e8             	pushl  -0x18(%ebp)
  800967:	8d 45 14             	lea    0x14(%ebp),%eax
  80096a:	50                   	push   %eax
  80096b:	e8 3c fd ff ff       	call   8006ac <getint>
  800970:	83 c4 10             	add    $0x10,%esp
  800973:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800976:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800979:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80097f:	85 d2                	test   %edx,%edx
  800981:	79 23                	jns    8009a6 <vprintfmt+0x29b>
				putch('-', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 2d                	push   $0x2d
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800996:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800999:	f7 d8                	neg    %eax
  80099b:	83 d2 00             	adc    $0x0,%edx
  80099e:	f7 da                	neg    %edx
  8009a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ad:	e9 bc 00 00 00       	jmp    800a6e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 84 fc ff ff       	call   800645 <getuint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ca:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d1:	e9 98 00 00 00       	jmp    800a6e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 0c             	pushl  0xc(%ebp)
  8009dc:	6a 58                	push   $0x58
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e6:	83 ec 08             	sub    $0x8,%esp
  8009e9:	ff 75 0c             	pushl  0xc(%ebp)
  8009ec:	6a 58                	push   $0x58
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	ff d0                	call   *%eax
  8009f3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	6a 58                	push   $0x58
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	ff d0                	call   *%eax
  800a03:	83 c4 10             	add    $0x10,%esp
			break;
  800a06:	e9 ce 00 00 00       	jmp    800ad9 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 30                	push   $0x30
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 78                	push   $0x78
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 c0 04             	add    $0x4,%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 e8 04             	sub    $0x4,%eax
  800a3a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a46:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4d:	eb 1f                	jmp    800a6e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 e8             	pushl  -0x18(%ebp)
  800a55:	8d 45 14             	lea    0x14(%ebp),%eax
  800a58:	50                   	push   %eax
  800a59:	e8 e7 fb ff ff       	call   800645 <getuint>
  800a5e:	83 c4 10             	add    $0x10,%esp
  800a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a64:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a67:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a75:	83 ec 04             	sub    $0x4,%esp
  800a78:	52                   	push   %edx
  800a79:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7c:	50                   	push   %eax
  800a7d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a80:	ff 75 f0             	pushl  -0x10(%ebp)
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 00 fb ff ff       	call   80058e <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
			break;
  800a91:	eb 46                	jmp    800ad9 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	53                   	push   %ebx
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	ff d0                	call   *%eax
  800a9f:	83 c4 10             	add    $0x10,%esp
			break;
  800aa2:	eb 35                	jmp    800ad9 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa4:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  800aab:	eb 2c                	jmp    800ad9 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aad:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
			break;
  800ab4:	eb 23                	jmp    800ad9 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	6a 25                	push   $0x25
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	ff d0                	call   *%eax
  800ac3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac6:	ff 4d 10             	decl   0x10(%ebp)
  800ac9:	eb 03                	jmp    800ace <vprintfmt+0x3c3>
  800acb:	ff 4d 10             	decl   0x10(%ebp)
  800ace:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad1:	48                   	dec    %eax
  800ad2:	8a 00                	mov    (%eax),%al
  800ad4:	3c 25                	cmp    $0x25,%al
  800ad6:	75 f3                	jne    800acb <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad8:	90                   	nop
		}
	}
  800ad9:	e9 35 fc ff ff       	jmp    800713 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ade:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800adf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae2:	5b                   	pop    %ebx
  800ae3:	5e                   	pop    %esi
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aec:	8d 45 10             	lea    0x10(%ebp),%eax
  800aef:	83 c0 04             	add    $0x4,%eax
  800af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	ff 75 f4             	pushl  -0xc(%ebp)
  800afb:	50                   	push   %eax
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	ff 75 08             	pushl  0x8(%ebp)
  800b02:	e8 04 fc ff ff       	call   80070b <vprintfmt>
  800b07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0a:	90                   	nop
  800b0b:	c9                   	leave  
  800b0c:	c3                   	ret    

00800b0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 40 08             	mov    0x8(%eax),%eax
  800b16:	8d 50 01             	lea    0x1(%eax),%edx
  800b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b22:	8b 10                	mov    (%eax),%edx
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	8b 40 04             	mov    0x4(%eax),%eax
  800b2a:	39 c2                	cmp    %eax,%edx
  800b2c:	73 12                	jae    800b40 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	8d 48 01             	lea    0x1(%eax),%ecx
  800b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b39:	89 0a                	mov    %ecx,(%edx)
  800b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3e:	88 10                	mov    %dl,(%eax)
}
  800b40:	90                   	nop
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    

00800b43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	01 d0                	add    %edx,%eax
  800b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b68:	74 06                	je     800b70 <vsnprintf+0x2d>
  800b6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6e:	7f 07                	jg     800b77 <vsnprintf+0x34>
		return -E_INVAL;
  800b70:	b8 03 00 00 00       	mov    $0x3,%eax
  800b75:	eb 20                	jmp    800b97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b77:	ff 75 14             	pushl  0x14(%ebp)
  800b7a:	ff 75 10             	pushl  0x10(%ebp)
  800b7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b80:	50                   	push   %eax
  800b81:	68 0d 0b 80 00       	push   $0x800b0d
  800b86:	e8 80 fb ff ff       	call   80070b <vprintfmt>
  800b8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    

00800b99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b9f:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba2:	83 c0 04             	add    $0x4,%eax
  800ba5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bab:	ff 75 f4             	pushl  -0xc(%ebp)
  800bae:	50                   	push   %eax
  800baf:	ff 75 0c             	pushl  0xc(%ebp)
  800bb2:	ff 75 08             	pushl  0x8(%ebp)
  800bb5:	e8 89 ff ff ff       	call   800b43 <vsnprintf>
  800bba:	83 c4 10             	add    $0x10,%esp
  800bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd2:	eb 06                	jmp    800bda <strlen+0x15>
		n++;
  800bd4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 f1                	jne    800bd4 <strlen+0xf>
		n++;
	return n;
  800be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 09                	jmp    800c00 <strnlen+0x18>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	ff 4d 0c             	decl   0xc(%ebp)
  800c00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c04:	74 09                	je     800c0f <strnlen+0x27>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	84 c0                	test   %al,%al
  800c0d:	75 e8                	jne    800bf7 <strnlen+0xf>
		n++;
	return n;
  800c0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c12:	c9                   	leave  
  800c13:	c3                   	ret    

00800c14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c20:	90                   	nop
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c33:	8a 12                	mov    (%edx),%dl
  800c35:	88 10                	mov    %dl,(%eax)
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e4                	jne    800c21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c55:	eb 1f                	jmp    800c76 <strncpy+0x34>
		*dst++ = *src;
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	8d 50 01             	lea    0x1(%eax),%edx
  800c5d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	8a 12                	mov    (%edx),%dl
  800c65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6a:	8a 00                	mov    (%eax),%al
  800c6c:	84 c0                	test   %al,%al
  800c6e:	74 03                	je     800c73 <strncpy+0x31>
			src++;
  800c70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c73:	ff 45 fc             	incl   -0x4(%ebp)
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c79:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7c:	72 d9                	jb     800c57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c93:	74 30                	je     800cc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c95:	eb 16                	jmp    800cad <strlcpy+0x2a>
			*dst++ = *src++;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8d 50 01             	lea    0x1(%eax),%edx
  800c9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ca9:	8a 12                	mov    (%edx),%dl
  800cab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cad:	ff 4d 10             	decl   0x10(%ebp)
  800cb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb4:	74 09                	je     800cbf <strlcpy+0x3c>
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	84 c0                	test   %al,%al
  800cbd:	75 d8                	jne    800c97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccb:	29 c2                	sub    %eax,%edx
  800ccd:	89 d0                	mov    %edx,%eax
}
  800ccf:	c9                   	leave  
  800cd0:	c3                   	ret    

00800cd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd1:	55                   	push   %ebp
  800cd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd4:	eb 06                	jmp    800cdc <strcmp+0xb>
		p++, q++;
  800cd6:	ff 45 08             	incl   0x8(%ebp)
  800cd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	84 c0                	test   %al,%al
  800ce3:	74 0e                	je     800cf3 <strcmp+0x22>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 10                	mov    (%eax),%dl
  800cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ced:	8a 00                	mov    (%eax),%al
  800cef:	38 c2                	cmp    %al,%dl
  800cf1:	74 e3                	je     800cd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	0f b6 d0             	movzbl %al,%edx
  800cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	0f b6 c0             	movzbl %al,%eax
  800d03:	29 c2                	sub    %eax,%edx
  800d05:	89 d0                	mov    %edx,%eax
}
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0c:	eb 09                	jmp    800d17 <strncmp+0xe>
		n--, p++, q++;
  800d0e:	ff 4d 10             	decl   0x10(%ebp)
  800d11:	ff 45 08             	incl   0x8(%ebp)
  800d14:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1b:	74 17                	je     800d34 <strncmp+0x2b>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	84 c0                	test   %al,%al
  800d24:	74 0e                	je     800d34 <strncmp+0x2b>
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 10                	mov    (%eax),%dl
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	38 c2                	cmp    %al,%dl
  800d32:	74 da                	je     800d0e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	75 07                	jne    800d41 <strncmp+0x38>
		return 0;
  800d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d3f:	eb 14                	jmp    800d55 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f b6 d0             	movzbl %al,%edx
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	0f b6 c0             	movzbl %al,%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    

00800d57 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
  800d5a:	83 ec 04             	sub    $0x4,%esp
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d63:	eb 12                	jmp    800d77 <strchr+0x20>
		if (*s == c)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6d:	75 05                	jne    800d74 <strchr+0x1d>
			return (char *) s;
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	eb 11                	jmp    800d85 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d74:	ff 45 08             	incl   0x8(%ebp)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	75 e5                	jne    800d65 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d85:	c9                   	leave  
  800d86:	c3                   	ret    

00800d87 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	83 ec 04             	sub    $0x4,%esp
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d93:	eb 0d                	jmp    800da2 <strfind+0x1b>
		if (*s == c)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9d:	74 0e                	je     800dad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8a 00                	mov    (%eax),%al
  800da7:	84 c0                	test   %al,%al
  800da9:	75 ea                	jne    800d95 <strfind+0xe>
  800dab:	eb 01                	jmp    800dae <strfind+0x27>
		if (*s == c)
			break;
  800dad:	90                   	nop
	return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc5:	eb 0e                	jmp    800dd5 <memset+0x22>
		*p++ = c;
  800dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dca:	8d 50 01             	lea    0x1(%eax),%edx
  800dcd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd5:	ff 4d f8             	decl   -0x8(%ebp)
  800dd8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddc:	79 e9                	jns    800dc7 <memset+0x14>
		*p++ = c;

	return v;
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de1:	c9                   	leave  
  800de2:	c3                   	ret    

00800de3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df5:	eb 16                	jmp    800e0d <memcpy+0x2a>
		*d++ = *s++;
  800df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfa:	8d 50 01             	lea    0x1(%eax),%edx
  800dfd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e03:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e06:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e09:	8a 12                	mov    (%edx),%dl
  800e0b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e13:	89 55 10             	mov    %edx,0x10(%ebp)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	75 dd                	jne    800df7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1d:	c9                   	leave  
  800e1e:	c3                   	ret    

00800e1f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e1f:	55                   	push   %ebp
  800e20:	89 e5                	mov    %esp,%ebp
  800e22:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	73 50                	jae    800e89 <memmove+0x6a>
  800e39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 d0                	add    %edx,%eax
  800e41:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e44:	76 43                	jbe    800e89 <memmove+0x6a>
		s += n;
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e52:	eb 10                	jmp    800e64 <memmove+0x45>
			*--d = *--s;
  800e54:	ff 4d f8             	decl   -0x8(%ebp)
  800e57:	ff 4d fc             	decl   -0x4(%ebp)
  800e5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5d:	8a 10                	mov    (%eax),%dl
  800e5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e62:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e64:	8b 45 10             	mov    0x10(%ebp),%eax
  800e67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6d:	85 c0                	test   %eax,%eax
  800e6f:	75 e3                	jne    800e54 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e71:	eb 23                	jmp    800e96 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e76:	8d 50 01             	lea    0x1(%eax),%edx
  800e79:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e82:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e85:	8a 12                	mov    (%edx),%dl
  800e87:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e89:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e92:	85 c0                	test   %eax,%eax
  800e94:	75 dd                	jne    800e73 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eaa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ead:	eb 2a                	jmp    800ed9 <memcmp+0x3e>
		if (*s1 != *s2)
  800eaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb2:	8a 10                	mov    (%eax),%dl
  800eb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb7:	8a 00                	mov    (%eax),%al
  800eb9:	38 c2                	cmp    %al,%dl
  800ebb:	74 16                	je     800ed3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d0             	movzbl %al,%edx
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec8:	8a 00                	mov    (%eax),%al
  800eca:	0f b6 c0             	movzbl %al,%eax
  800ecd:	29 c2                	sub    %eax,%edx
  800ecf:	89 d0                	mov    %edx,%eax
  800ed1:	eb 18                	jmp    800eeb <memcmp+0x50>
		s1++, s2++;
  800ed3:	ff 45 fc             	incl   -0x4(%ebp)
  800ed6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800edf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee2:	85 c0                	test   %eax,%eax
  800ee4:	75 c9                	jne    800eaf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eeb:	c9                   	leave  
  800eec:	c3                   	ret    

00800eed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef9:	01 d0                	add    %edx,%eax
  800efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800efe:	eb 15                	jmp    800f15 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	0f b6 d0             	movzbl %al,%edx
  800f08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0b:	0f b6 c0             	movzbl %al,%eax
  800f0e:	39 c2                	cmp    %eax,%edx
  800f10:	74 0d                	je     800f1f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f12:	ff 45 08             	incl   0x8(%ebp)
  800f15:	8b 45 08             	mov    0x8(%ebp),%eax
  800f18:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1b:	72 e3                	jb     800f00 <memfind+0x13>
  800f1d:	eb 01                	jmp    800f20 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f1f:	90                   	nop
	return (void *) s;
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f32:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f39:	eb 03                	jmp    800f3e <strtol+0x19>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 00                	mov    (%eax),%al
  800f43:	3c 20                	cmp    $0x20,%al
  800f45:	74 f4                	je     800f3b <strtol+0x16>
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	3c 09                	cmp    $0x9,%al
  800f4e:	74 eb                	je     800f3b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	3c 2b                	cmp    $0x2b,%al
  800f57:	75 05                	jne    800f5e <strtol+0x39>
		s++;
  800f59:	ff 45 08             	incl   0x8(%ebp)
  800f5c:	eb 13                	jmp    800f71 <strtol+0x4c>
	else if (*s == '-')
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 2d                	cmp    $0x2d,%al
  800f65:	75 0a                	jne    800f71 <strtol+0x4c>
		s++, neg = 1;
  800f67:	ff 45 08             	incl   0x8(%ebp)
  800f6a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f75:	74 06                	je     800f7d <strtol+0x58>
  800f77:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7b:	75 20                	jne    800f9d <strtol+0x78>
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 30                	cmp    $0x30,%al
  800f84:	75 17                	jne    800f9d <strtol+0x78>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	40                   	inc    %eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 78                	cmp    $0x78,%al
  800f8e:	75 0d                	jne    800f9d <strtol+0x78>
		s += 2, base = 16;
  800f90:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f94:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9b:	eb 28                	jmp    800fc5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa1:	75 15                	jne    800fb8 <strtol+0x93>
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	3c 30                	cmp    $0x30,%al
  800faa:	75 0c                	jne    800fb8 <strtol+0x93>
		s++, base = 8;
  800fac:	ff 45 08             	incl   0x8(%ebp)
  800faf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb6:	eb 0d                	jmp    800fc5 <strtol+0xa0>
	else if (base == 0)
  800fb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbc:	75 07                	jne    800fc5 <strtol+0xa0>
		base = 10;
  800fbe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	3c 2f                	cmp    $0x2f,%al
  800fcc:	7e 19                	jle    800fe7 <strtol+0xc2>
  800fce:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd1:	8a 00                	mov    (%eax),%al
  800fd3:	3c 39                	cmp    $0x39,%al
  800fd5:	7f 10                	jg     800fe7 <strtol+0xc2>
			dig = *s - '0';
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	0f be c0             	movsbl %al,%eax
  800fdf:	83 e8 30             	sub    $0x30,%eax
  800fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe5:	eb 42                	jmp    801029 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 60                	cmp    $0x60,%al
  800fee:	7e 19                	jle    801009 <strtol+0xe4>
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	8a 00                	mov    (%eax),%al
  800ff5:	3c 7a                	cmp    $0x7a,%al
  800ff7:	7f 10                	jg     801009 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f be c0             	movsbl %al,%eax
  801001:	83 e8 57             	sub    $0x57,%eax
  801004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801007:	eb 20                	jmp    801029 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	3c 40                	cmp    $0x40,%al
  801010:	7e 39                	jle    80104b <strtol+0x126>
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	3c 5a                	cmp    $0x5a,%al
  801019:	7f 30                	jg     80104b <strtol+0x126>
			dig = *s - 'A' + 10;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f be c0             	movsbl %al,%eax
  801023:	83 e8 37             	sub    $0x37,%eax
  801026:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80102f:	7d 19                	jge    80104a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801037:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103b:	89 c2                	mov    %eax,%edx
  80103d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801040:	01 d0                	add    %edx,%eax
  801042:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801045:	e9 7b ff ff ff       	jmp    800fc5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80104f:	74 08                	je     801059 <strtol+0x134>
		*endptr = (char *) s;
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801059:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105d:	74 07                	je     801066 <strtol+0x141>
  80105f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801062:	f7 d8                	neg    %eax
  801064:	eb 03                	jmp    801069 <strtol+0x144>
  801066:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <ltostr>:

void
ltostr(long value, char *str)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801071:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801078:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80107f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801083:	79 13                	jns    801098 <ltostr+0x2d>
	{
		neg = 1;
  801085:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801092:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801095:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a0:	99                   	cltd   
  8010a1:	f7 f9                	idiv   %ecx
  8010a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010af:	89 c2                	mov    %eax,%edx
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	01 d0                	add    %edx,%eax
  8010b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010b9:	83 c2 30             	add    $0x30,%edx
  8010bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c6:	f7 e9                	imul   %ecx
  8010c8:	c1 fa 02             	sar    $0x2,%edx
  8010cb:	89 c8                	mov    %ecx,%eax
  8010cd:	c1 f8 1f             	sar    $0x1f,%eax
  8010d0:	29 c2                	sub    %eax,%edx
  8010d2:	89 d0                	mov    %edx,%eax
  8010d4:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010db:	75 bb                	jne    801098 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e7:	48                   	dec    %eax
  8010e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010eb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ef:	74 3d                	je     80112e <ltostr+0xc3>
		start = 1 ;
  8010f1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f8:	eb 34                	jmp    80112e <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 d0                	add    %edx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	01 c2                	add    %eax,%edx
  80110f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	01 c8                	add    %ecx,%eax
  801117:	8a 00                	mov    (%eax),%al
  801119:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	01 c2                	add    %eax,%edx
  801123:	8a 45 eb             	mov    -0x15(%ebp),%al
  801126:	88 02                	mov    %al,(%edx)
		start++ ;
  801128:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801131:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801134:	7c c4                	jl     8010fa <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801136:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801139:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113c:	01 d0                	add    %edx,%eax
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801141:	90                   	nop
  801142:	c9                   	leave  
  801143:	c3                   	ret    

00801144 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801144:	55                   	push   %ebp
  801145:	89 e5                	mov    %esp,%ebp
  801147:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114a:	ff 75 08             	pushl  0x8(%ebp)
  80114d:	e8 73 fa ff ff       	call   800bc5 <strlen>
  801152:	83 c4 04             	add    $0x4,%esp
  801155:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801158:	ff 75 0c             	pushl  0xc(%ebp)
  80115b:	e8 65 fa ff ff       	call   800bc5 <strlen>
  801160:	83 c4 04             	add    $0x4,%esp
  801163:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801166:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801174:	eb 17                	jmp    80118d <strcconcat+0x49>
		final[s] = str1[s] ;
  801176:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801179:	8b 45 10             	mov    0x10(%ebp),%eax
  80117c:	01 c2                	add    %eax,%edx
  80117e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	01 c8                	add    %ecx,%eax
  801186:	8a 00                	mov    (%eax),%al
  801188:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118a:	ff 45 fc             	incl   -0x4(%ebp)
  80118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801190:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801193:	7c e1                	jl     801176 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a3:	eb 1f                	jmp    8011c4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a8:	8d 50 01             	lea    0x1(%eax),%edx
  8011ab:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ae:	89 c2                	mov    %eax,%edx
  8011b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b3:	01 c2                	add    %eax,%edx
  8011b5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bb:	01 c8                	add    %ecx,%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c1:	ff 45 f8             	incl   -0x8(%ebp)
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ca:	7c d9                	jl     8011a5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d7:	90                   	nop
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e9:	8b 00                	mov    (%eax),%eax
  8011eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 d0                	add    %edx,%eax
  8011f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fd:	eb 0c                	jmp    80120b <strsplit+0x31>
			*string++ = 0;
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8d 50 01             	lea    0x1(%eax),%edx
  801205:	89 55 08             	mov    %edx,0x8(%ebp)
  801208:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	84 c0                	test   %al,%al
  801212:	74 18                	je     80122c <strsplit+0x52>
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	0f be c0             	movsbl %al,%eax
  80121c:	50                   	push   %eax
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 32 fb ff ff       	call   800d57 <strchr>
  801225:	83 c4 08             	add    $0x8,%esp
  801228:	85 c0                	test   %eax,%eax
  80122a:	75 d3                	jne    8011ff <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	84 c0                	test   %al,%al
  801233:	74 5a                	je     80128f <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801235:	8b 45 14             	mov    0x14(%ebp),%eax
  801238:	8b 00                	mov    (%eax),%eax
  80123a:	83 f8 0f             	cmp    $0xf,%eax
  80123d:	75 07                	jne    801246 <strsplit+0x6c>
		{
			return 0;
  80123f:	b8 00 00 00 00       	mov    $0x0,%eax
  801244:	eb 66                	jmp    8012ac <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	8b 00                	mov    (%eax),%eax
  80124b:	8d 48 01             	lea    0x1(%eax),%ecx
  80124e:	8b 55 14             	mov    0x14(%ebp),%edx
  801251:	89 0a                	mov    %ecx,(%edx)
  801253:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125a:	8b 45 10             	mov    0x10(%ebp),%eax
  80125d:	01 c2                	add    %eax,%edx
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801264:	eb 03                	jmp    801269 <strsplit+0x8f>
			string++;
  801266:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 8b                	je     8011fd <strsplit+0x23>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 d4 fa ff ff       	call   800d57 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	74 dc                	je     801266 <strsplit+0x8c>
			string++;
	}
  80128a:	e9 6e ff ff ff       	jmp    8011fd <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80128f:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801290:	8b 45 14             	mov    0x14(%ebp),%eax
  801293:	8b 00                	mov    (%eax),%eax
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 d0                	add    %edx,%eax
  8012a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012b4:	83 ec 04             	sub    $0x4,%esp
  8012b7:	68 c8 3c 80 00       	push   $0x803cc8
  8012bc:	68 3f 01 00 00       	push   $0x13f
  8012c1:	68 ea 3c 80 00       	push   $0x803cea
  8012c6:	e8 a9 ef ff ff       	call   800274 <_panic>

008012cb <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012e3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012e6:	cd 30                	int    $0x30
  8012e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8012eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ee:	83 c4 10             	add    $0x10,%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    

008012f6 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8012f6:	55                   	push   %ebp
  8012f7:	89 e5                	mov    %esp,%ebp
  8012f9:	83 ec 04             	sub    $0x4,%esp
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801302:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	52                   	push   %edx
  80130e:	ff 75 0c             	pushl  0xc(%ebp)
  801311:	50                   	push   %eax
  801312:	6a 00                	push   $0x0
  801314:	e8 b2 ff ff ff       	call   8012cb <syscall>
  801319:	83 c4 18             	add    $0x18,%esp
}
  80131c:	90                   	nop
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_cgetc>:

int sys_cgetc(void) {
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 02                	push   $0x2
  80132e:	e8 98 ff ff ff       	call   8012cb <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	c9                   	leave  
  801337:	c3                   	ret    

00801338 <sys_lock_cons>:

void sys_lock_cons(void) {
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 00                	push   $0x0
  801345:	6a 03                	push   $0x3
  801347:	e8 7f ff ff ff       	call   8012cb <syscall>
  80134c:	83 c4 18             	add    $0x18,%esp
}
  80134f:	90                   	nop
  801350:	c9                   	leave  
  801351:	c3                   	ret    

00801352 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801352:	55                   	push   %ebp
  801353:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801355:	6a 00                	push   $0x0
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 04                	push   $0x4
  801361:	e8 65 ff ff ff       	call   8012cb <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
}
  801369:	90                   	nop
  80136a:	c9                   	leave  
  80136b:	c3                   	ret    

0080136c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80136c:	55                   	push   %ebp
  80136d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80136f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	6a 00                	push   $0x0
  80137b:	52                   	push   %edx
  80137c:	50                   	push   %eax
  80137d:	6a 08                	push   $0x8
  80137f:	e8 47 ff ff ff       	call   8012cb <syscall>
  801384:	83 c4 18             	add    $0x18,%esp
}
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	56                   	push   %esi
  80138d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80138e:	8b 75 18             	mov    0x18(%ebp),%esi
  801391:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801394:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	56                   	push   %esi
  80139e:	53                   	push   %ebx
  80139f:	51                   	push   %ecx
  8013a0:	52                   	push   %edx
  8013a1:	50                   	push   %eax
  8013a2:	6a 09                	push   $0x9
  8013a4:	e8 22 ff ff ff       	call   8012cb <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8013ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013af:	5b                   	pop    %ebx
  8013b0:	5e                   	pop    %esi
  8013b1:	5d                   	pop    %ebp
  8013b2:	c3                   	ret    

008013b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	6a 00                	push   $0x0
  8013c2:	52                   	push   %edx
  8013c3:	50                   	push   %eax
  8013c4:	6a 0a                	push   $0xa
  8013c6:	e8 00 ff ff ff       	call   8012cb <syscall>
  8013cb:	83 c4 18             	add    $0x18,%esp
}
  8013ce:	c9                   	leave  
  8013cf:	c3                   	ret    

008013d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	ff 75 0c             	pushl  0xc(%ebp)
  8013dc:	ff 75 08             	pushl  0x8(%ebp)
  8013df:	6a 0b                	push   $0xb
  8013e1:	e8 e5 fe ff ff       	call   8012cb <syscall>
  8013e6:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 0c                	push   $0xc
  8013fa:	e8 cc fe ff ff       	call   8012cb <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	6a 00                	push   $0x0
  801411:	6a 0d                	push   $0xd
  801413:	e8 b3 fe ff ff       	call   8012cb <syscall>
  801418:	83 c4 18             	add    $0x18,%esp
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 0e                	push   $0xe
  80142c:	e8 9a fe ff ff       	call   8012cb <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 0f                	push   $0xf
  801445:	e8 81 fe ff ff       	call   8012cb <syscall>
  80144a:	83 c4 18             	add    $0x18,%esp
}
  80144d:	c9                   	leave  
  80144e:	c3                   	ret    

0080144f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	ff 75 08             	pushl  0x8(%ebp)
  80145d:	6a 10                	push   $0x10
  80145f:	e8 67 fe ff ff       	call   8012cb <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_scarce_memory>:

void sys_scarce_memory() {
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 11                	push   $0x11
  801478:	e8 4e fe ff ff       	call   8012cb <syscall>
  80147d:	83 c4 18             	add    $0x18,%esp
}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <sys_cputc>:

void sys_cputc(const char c) {
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80148f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801493:	6a 00                	push   $0x0
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	50                   	push   %eax
  80149c:	6a 01                	push   $0x1
  80149e:	e8 28 fe ff ff       	call   8012cb <syscall>
  8014a3:	83 c4 18             	add    $0x18,%esp
}
  8014a6:	90                   	nop
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    

008014a9 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 00                	push   $0x0
  8014b2:	6a 00                	push   $0x0
  8014b4:	6a 00                	push   $0x0
  8014b6:	6a 14                	push   $0x14
  8014b8:	e8 0e fe ff ff       	call   8012cb <syscall>
  8014bd:	83 c4 18             	add    $0x18,%esp
}
  8014c0:	90                   	nop
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8014cf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	6a 00                	push   $0x0
  8014db:	51                   	push   %ecx
  8014dc:	52                   	push   %edx
  8014dd:	ff 75 0c             	pushl  0xc(%ebp)
  8014e0:	50                   	push   %eax
  8014e1:	6a 15                	push   $0x15
  8014e3:	e8 e3 fd ff ff       	call   8012cb <syscall>
  8014e8:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8014f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	52                   	push   %edx
  8014fd:	50                   	push   %eax
  8014fe:	6a 16                	push   $0x16
  801500:	e8 c6 fd ff ff       	call   8012cb <syscall>
  801505:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801508:	c9                   	leave  
  801509:	c3                   	ret    

0080150a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80150d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	51                   	push   %ecx
  80151b:	52                   	push   %edx
  80151c:	50                   	push   %eax
  80151d:	6a 17                	push   $0x17
  80151f:	e8 a7 fd ff ff       	call   8012cb <syscall>
  801524:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80152c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	6a 00                	push   $0x0
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	52                   	push   %edx
  801539:	50                   	push   %eax
  80153a:	6a 18                	push   $0x18
  80153c:	e8 8a fd ff ff       	call   8012cb <syscall>
  801541:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801549:	8b 45 08             	mov    0x8(%ebp),%eax
  80154c:	6a 00                	push   $0x0
  80154e:	ff 75 14             	pushl  0x14(%ebp)
  801551:	ff 75 10             	pushl  0x10(%ebp)
  801554:	ff 75 0c             	pushl  0xc(%ebp)
  801557:	50                   	push   %eax
  801558:	6a 19                	push   $0x19
  80155a:	e8 6c fd ff ff       	call   8012cb <syscall>
  80155f:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_run_env>:

void sys_run_env(int32 envId) {
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	50                   	push   %eax
  801573:	6a 1a                	push   $0x1a
  801575:	e8 51 fd ff ff       	call   8012cb <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	90                   	nop
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 00                	push   $0x0
  80158e:	50                   	push   %eax
  80158f:	6a 1b                	push   $0x1b
  801591:	e8 35 fd ff ff       	call   8012cb <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_getenvid>:

int32 sys_getenvid(void) {
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	6a 00                	push   $0x0
  8015a8:	6a 05                	push   $0x5
  8015aa:	e8 1c fd ff ff       	call   8012cb <syscall>
  8015af:	83 c4 18             	add    $0x18,%esp
}
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 06                	push   $0x6
  8015c3:	e8 03 fd ff ff       	call   8012cb <syscall>
  8015c8:	83 c4 18             	add    $0x18,%esp
}
  8015cb:	c9                   	leave  
  8015cc:	c3                   	ret    

008015cd <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015d0:	6a 00                	push   $0x0
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	6a 07                	push   $0x7
  8015dc:	e8 ea fc ff ff       	call   8012cb <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_exit_env>:

void sys_exit_env(void) {
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 1c                	push   $0x1c
  8015f5:	e8 d1 fc ff ff       	call   8012cb <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	90                   	nop
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801606:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801609:	8d 50 04             	lea    0x4(%eax),%edx
  80160c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	52                   	push   %edx
  801616:	50                   	push   %eax
  801617:	6a 1d                	push   $0x1d
  801619:	e8 ad fc ff ff       	call   8012cb <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801621:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801624:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801627:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162a:	89 01                	mov    %eax,(%ecx)
  80162c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	c9                   	leave  
  801633:	c2 04 00             	ret    $0x4

00801636 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	ff 75 10             	pushl  0x10(%ebp)
  801640:	ff 75 0c             	pushl  0xc(%ebp)
  801643:	ff 75 08             	pushl  0x8(%ebp)
  801646:	6a 13                	push   $0x13
  801648:	e8 7e fc ff ff       	call   8012cb <syscall>
  80164d:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801650:	90                   	nop
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_rcr2>:
uint32 sys_rcr2() {
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	6a 00                	push   $0x0
  80165e:	6a 00                	push   $0x0
  801660:	6a 1e                	push   $0x1e
  801662:	e8 64 fc ff ff       	call   8012cb <syscall>
  801667:	83 c4 18             	add    $0x18,%esp
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801678:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	50                   	push   %eax
  801685:	6a 1f                	push   $0x1f
  801687:	e8 3f fc ff ff       	call   8012cb <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
	return;
  80168f:	90                   	nop
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <rsttst>:
void rsttst() {
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 21                	push   $0x21
  8016a1:	e8 25 fc ff ff       	call   8012cb <syscall>
  8016a6:	83 c4 18             	add    $0x18,%esp
	return;
  8016a9:	90                   	nop
}
  8016aa:	c9                   	leave  
  8016ab:	c3                   	ret    

008016ac <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8016ac:	55                   	push   %ebp
  8016ad:	89 e5                	mov    %esp,%ebp
  8016af:	83 ec 04             	sub    $0x4,%esp
  8016b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016b8:	8b 55 18             	mov    0x18(%ebp),%edx
  8016bb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016bf:	52                   	push   %edx
  8016c0:	50                   	push   %eax
  8016c1:	ff 75 10             	pushl  0x10(%ebp)
  8016c4:	ff 75 0c             	pushl  0xc(%ebp)
  8016c7:	ff 75 08             	pushl  0x8(%ebp)
  8016ca:	6a 20                	push   $0x20
  8016cc:	e8 fa fb ff ff       	call   8012cb <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <chktst>:
void chktst(uint32 n) {
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	ff 75 08             	pushl  0x8(%ebp)
  8016e5:	6a 22                	push   $0x22
  8016e7:	e8 df fb ff ff       	call   8012cb <syscall>
  8016ec:	83 c4 18             	add    $0x18,%esp
	return;
  8016ef:	90                   	nop
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <inctst>:

void inctst() {
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 23                	push   $0x23
  801701:	e8 c5 fb ff ff       	call   8012cb <syscall>
  801706:	83 c4 18             	add    $0x18,%esp
	return;
  801709:	90                   	nop
}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <gettst>:
uint32 gettst() {
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 24                	push   $0x24
  80171b:	e8 ab fb ff ff       	call   8012cb <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 00                	push   $0x0
  801733:	6a 00                	push   $0x0
  801735:	6a 25                	push   $0x25
  801737:	e8 8f fb ff ff       	call   8012cb <syscall>
  80173c:	83 c4 18             	add    $0x18,%esp
  80173f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801742:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801746:	75 07                	jne    80174f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801748:	b8 01 00 00 00       	mov    $0x1,%eax
  80174d:	eb 05                	jmp    801754 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 25                	push   $0x25
  801768:	e8 5e fb ff ff       	call   8012cb <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
  801770:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801773:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801777:	75 07                	jne    801780 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801779:	b8 01 00 00 00       	mov    $0x1,%eax
  80177e:	eb 05                	jmp    801785 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
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
  801799:	e8 2d fb ff ff       	call   8012cb <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017a4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017a8:	75 07                	jne    8017b1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8017af:	eb 05                	jmp    8017b6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
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
  8017ca:	e8 fc fa ff ff       	call   8012cb <syscall>
  8017cf:	83 c4 18             	add    $0x18,%esp
  8017d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017d5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017d9:	75 07                	jne    8017e2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017db:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e0:	eb 05                	jmp    8017e7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	ff 75 08             	pushl  0x8(%ebp)
  8017f7:	6a 26                	push   $0x26
  8017f9:	e8 cd fa ff ff       	call   8012cb <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
	return;
  801801:	90                   	nop
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801808:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	6a 00                	push   $0x0
  801816:	53                   	push   %ebx
  801817:	51                   	push   %ecx
  801818:	52                   	push   %edx
  801819:	50                   	push   %eax
  80181a:	6a 27                	push   $0x27
  80181c:	e8 aa fa ff ff       	call   8012cb <syscall>
  801821:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80182c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	52                   	push   %edx
  801839:	50                   	push   %eax
  80183a:	6a 28                	push   $0x28
  80183c:	e8 8a fa ff ff       	call   8012cb <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801849:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80184c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	6a 00                	push   $0x0
  801854:	51                   	push   %ecx
  801855:	ff 75 10             	pushl  0x10(%ebp)
  801858:	52                   	push   %edx
  801859:	50                   	push   %eax
  80185a:	6a 29                	push   $0x29
  80185c:	e8 6a fa ff ff       	call   8012cb <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801864:	c9                   	leave  
  801865:	c3                   	ret    

00801866 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 10             	pushl  0x10(%ebp)
  801870:	ff 75 0c             	pushl  0xc(%ebp)
  801873:	ff 75 08             	pushl  0x8(%ebp)
  801876:	6a 12                	push   $0x12
  801878:	e8 4e fa ff ff       	call   8012cb <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
	return;
  801880:	90                   	nop
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801886:	8b 55 0c             	mov    0xc(%ebp),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 2a                	push   $0x2a
  801896:	e8 30 fa ff ff       	call   8012cb <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
	return;
  80189e:	90                   	nop
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	50                   	push   %eax
  8018b0:	6a 2b                	push   $0x2b
  8018b2:	e8 14 fa ff ff       	call   8012cb <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 2c                	push   $0x2c
  8018cd:	e8 f9 f9 ff ff       	call   8012cb <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	6a 2d                	push   $0x2d
  8018e9:	e8 dd f9 ff ff       	call   8012cb <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	50                   	push   %eax
  801903:	6a 2f                	push   $0x2f
  801905:	e8 c1 f9 ff ff       	call   8012cb <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
	return;
  80190d:	90                   	nop
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	8b 45 08             	mov    0x8(%ebp),%eax
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	52                   	push   %edx
  801920:	50                   	push   %eax
  801921:	6a 30                	push   $0x30
  801923:	e8 a3 f9 ff ff       	call   8012cb <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
	return;
  80192b:	90                   	nop
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 31                	push   $0x31
  80193f:	e8 87 f9 ff ff       	call   8012cb <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	52                   	push   %edx
  80195a:	50                   	push   %eax
  80195b:	6a 2e                	push   $0x2e
  80195d:	e8 69 f9 ff ff       	call   8012cb <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
    return;
  801965:	90                   	nop
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	6a 01                	push   $0x1
  801973:	6a 58                	push   $0x58
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	e8 5b 04 00 00       	call   801dd8 <smalloc>
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801983:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801987:	75 14                	jne    80199d <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	68 f8 3c 80 00       	push   $0x803cf8
  801991:	6a 10                	push   $0x10
  801993:	68 26 3d 80 00       	push   $0x803d26
  801998:	e8 d7 e8 ff ff       	call   800274 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  80199d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a0:	83 ec 0c             	sub    $0xc,%esp
  8019a3:	50                   	push   %eax
  8019a4:	e8 4b ff ff ff       	call   8018f4 <sys_init_queue>
  8019a9:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  8019ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019af:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  8019b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b9:	83 c0 18             	add    $0x18,%eax
  8019bc:	83 ec 04             	sub    $0x4,%esp
  8019bf:	6a 40                	push   $0x40
  8019c1:	ff 75 0c             	pushl  0xc(%ebp)
  8019c4:	50                   	push   %eax
  8019c5:	e8 78 f2 ff ff       	call   800c42 <strncpy>
  8019ca:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  8019cd:	8b 55 10             	mov    0x10(%ebp),%edx
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  8019d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  8019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019df:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e2:	89 10                	mov    %edx,(%eax)
}
  8019e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e7:	c9                   	leave  
  8019e8:	c2 04 00             	ret    $0x4

008019eb <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	ff 75 10             	pushl  0x10(%ebp)
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	e8 74 05 00 00       	call   801f73 <sget>
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801a05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a09:	75 14                	jne    801a1f <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	68 38 3d 80 00       	push   $0x803d38
  801a13:	6a 2c                	push   $0x2c
  801a15:	68 26 3d 80 00       	push   $0x803d26
  801a1a:	e8 55 e8 ff ff       	call   800274 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  801a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2b:	89 10                	mov    %edx,(%eax)
}
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	c9                   	leave  
  801a31:	c2 04 00             	ret    $0x4

00801a34 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801a3a:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	8b 40 14             	mov    0x14(%eax),%eax
  801a47:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801a4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a56:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801a59:	f0 87 02             	lock xchg %eax,(%edx)
  801a5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a62:	85 c0                	test   %eax,%eax
  801a64:	75 db                	jne    801a41 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	8b 50 10             	mov    0x10(%eax),%edx
  801a6c:	4a                   	dec    %edx
  801a6d:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  801a70:	8b 45 08             	mov    0x8(%ebp),%eax
  801a73:	8b 40 10             	mov    0x10(%eax),%eax
  801a76:	85 c0                	test   %eax,%eax
  801a78:	79 18                	jns    801a92 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8d 50 14             	lea    0x14(%eax),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	83 ec 08             	sub    $0x8,%esp
  801a86:	52                   	push   %edx
  801a87:	50                   	push   %eax
  801a88:	e8 83 fe ff ff       	call   801910 <sys_block_process>
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	eb 0a                	jmp    801a9c <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801aa4:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8b 40 14             	mov    0x14(%eax),%eax
  801ab1:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801ab7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ac3:	f0 87 02             	lock xchg %eax,(%edx)
  801ac6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801acc:	85 c0                	test   %eax,%eax
  801ace:	75 db                	jne    801aab <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	8b 50 10             	mov    0x10(%eax),%edx
  801ad6:	42                   	inc    %edx
  801ad7:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8b 40 10             	mov    0x10(%eax),%eax
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	7f 0f                	jg     801af3 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	83 ec 0c             	sub    $0xc,%esp
  801aea:	50                   	push   %eax
  801aeb:	e8 3e fe ff ff       	call   80192e <sys_unblock_process>
  801af0:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801afd:	90                   	nop
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	8b 40 10             	mov    0x10(%eax),%eax
}
  801b09:	5d                   	pop    %ebp
  801b0a:	c3                   	ret    

00801b0b <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b11:	83 ec 0c             	sub    $0xc,%esp
  801b14:	ff 75 08             	pushl  0x8(%ebp)
  801b17:	e8 85 fd ff ff       	call   8018a1 <sys_sbrk>
  801b1c:	83 c4 10             	add    $0x10,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801b27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b2b:	75 0a                	jne    801b37 <malloc+0x16>
		return NULL;
  801b2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b32:	e9 9e 01 00 00       	jmp    801cd5 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801b37:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801b3e:	77 2c                	ja     801b6c <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801b40:	e8 e0 fb ff ff       	call   801725 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b45:	85 c0                	test   %eax,%eax
  801b47:	74 19                	je     801b62 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801b49:	83 ec 0c             	sub    $0xc,%esp
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	e8 e8 0a 00 00       	call   80263c <alloc_block_FF>
  801b54:	83 c4 10             	add    $0x10,%esp
  801b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801b5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5d:	e9 73 01 00 00       	jmp    801cd5 <malloc+0x1b4>
		} else {
			return NULL;
  801b62:	b8 00 00 00 00       	mov    $0x0,%eax
  801b67:	e9 69 01 00 00       	jmp    801cd5 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801b6c:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801b73:	8b 55 08             	mov    0x8(%ebp),%edx
  801b76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b79:	01 d0                	add    %edx,%eax
  801b7b:	48                   	dec    %eax
  801b7c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b7f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b82:	ba 00 00 00 00       	mov    $0x0,%edx
  801b87:	f7 75 e0             	divl   -0x20(%ebp)
  801b8a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b8d:	29 d0                	sub    %edx,%eax
  801b8f:	c1 e8 0c             	shr    $0xc,%eax
  801b92:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801b9c:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801ba3:	a1 20 40 80 00       	mov    0x804020,%eax
  801ba8:	8b 40 7c             	mov    0x7c(%eax),%eax
  801bab:	05 00 10 00 00       	add    $0x1000,%eax
  801bb0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801bb3:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801bb8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801bbb:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801bbe:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  801bc8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801bcb:	01 d0                	add    %edx,%eax
  801bcd:	48                   	dec    %eax
  801bce:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801bd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd9:	f7 75 cc             	divl   -0x34(%ebp)
  801bdc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801bdf:	29 d0                	sub    %edx,%eax
  801be1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801be4:	76 0a                	jbe    801bf0 <malloc+0xcf>
		return NULL;
  801be6:	b8 00 00 00 00       	mov    $0x0,%eax
  801beb:	e9 e5 00 00 00       	jmp    801cd5 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801bf0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bf6:	eb 48                	jmp    801c40 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bfb:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801bfe:	c1 e8 0c             	shr    $0xc,%eax
  801c01:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801c04:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c07:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801c0e:	85 c0                	test   %eax,%eax
  801c10:	75 11                	jne    801c23 <malloc+0x102>
			freePagesCount++;
  801c12:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801c15:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c19:	75 16                	jne    801c31 <malloc+0x110>
				start = i;
  801c1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c21:	eb 0e                	jmp    801c31 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801c23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801c2a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c34:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c37:	74 12                	je     801c4b <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801c39:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801c40:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801c47:	76 af                	jbe    801bf8 <malloc+0xd7>
  801c49:	eb 01                	jmp    801c4c <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801c4b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801c4c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c50:	74 08                	je     801c5a <malloc+0x139>
  801c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c55:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c58:	74 07                	je     801c61 <malloc+0x140>
		return NULL;
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5f:	eb 74                	jmp    801cd5 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c64:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c67:	c1 e8 0c             	shr    $0xc,%eax
  801c6a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801c6d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c70:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c73:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c7a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801c7d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c80:	eb 11                	jmp    801c93 <malloc+0x172>
		markedPages[i] = 1;
  801c82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c85:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801c8c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801c90:	ff 45 e8             	incl   -0x18(%ebp)
  801c93:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801c96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c99:	01 d0                	add    %edx,%eax
  801c9b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801c9e:	77 e2                	ja     801c82 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801ca0:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  801caa:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801cad:	01 d0                	add    %edx,%eax
  801caf:	48                   	dec    %eax
  801cb0:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801cb3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801cb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cbb:	f7 75 bc             	divl   -0x44(%ebp)
  801cbe:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801cc1:	29 d0                	sub    %edx,%eax
  801cc3:	83 ec 08             	sub    $0x8,%esp
  801cc6:	50                   	push   %eax
  801cc7:	ff 75 f0             	pushl  -0x10(%ebp)
  801cca:	e8 09 fc ff ff       	call   8018d8 <sys_allocate_user_mem>
  801ccf:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    

00801cd7 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801cdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ce1:	0f 84 ee 00 00 00    	je     801dd5 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801ce7:	a1 20 40 80 00       	mov    0x804020,%eax
  801cec:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801cef:	3b 45 08             	cmp    0x8(%ebp),%eax
  801cf2:	77 09                	ja     801cfd <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801cf4:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801cfb:	76 14                	jbe    801d11 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	68 5c 3d 80 00       	push   $0x803d5c
  801d05:	6a 68                	push   $0x68
  801d07:	68 76 3d 80 00       	push   $0x803d76
  801d0c:	e8 63 e5 ff ff       	call   800274 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801d11:	a1 20 40 80 00       	mov    0x804020,%eax
  801d16:	8b 40 74             	mov    0x74(%eax),%eax
  801d19:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d1c:	77 20                	ja     801d3e <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801d1e:	a1 20 40 80 00       	mov    0x804020,%eax
  801d23:	8b 40 78             	mov    0x78(%eax),%eax
  801d26:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d29:	76 13                	jbe    801d3e <free+0x67>
		free_block(virtual_address);
  801d2b:	83 ec 0c             	sub    $0xc,%esp
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	e8 cf 0f 00 00       	call   802d05 <free_block>
  801d36:	83 c4 10             	add    $0x10,%esp
		return;
  801d39:	e9 98 00 00 00       	jmp    801dd6 <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801d3e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d41:	a1 20 40 80 00       	mov    0x804020,%eax
  801d46:	8b 40 7c             	mov    0x7c(%eax),%eax
  801d49:	29 c2                	sub    %eax,%edx
  801d4b:	89 d0                	mov    %edx,%eax
  801d4d:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801d52:	c1 e8 0c             	shr    $0xc,%eax
  801d55:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801d5f:	eb 16                	jmp    801d77 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801d61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d67:	01 d0                	add    %edx,%eax
  801d69:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801d70:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801d74:	ff 45 f4             	incl   -0xc(%ebp)
  801d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7a:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801d81:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d84:	7f db                	jg     801d61 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801d86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d89:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801d90:	c1 e0 0c             	shl    $0xc,%eax
  801d93:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d9c:	eb 1a                	jmp    801db8 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801d9e:	83 ec 08             	sub    $0x8,%esp
  801da1:	68 00 10 00 00       	push   $0x1000
  801da6:	ff 75 f0             	pushl  -0x10(%ebp)
  801da9:	e8 0e fb ff ff       	call   8018bc <sys_free_user_mem>
  801dae:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801db1:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801db8:	8b 55 08             	mov    0x8(%ebp),%edx
  801dbb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dbe:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801dc0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801dc3:	77 d9                	ja     801d9e <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc8:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  801dcf:	00 00 00 00 
  801dd3:	eb 01                	jmp    801dd6 <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801dd5:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801dd6:	c9                   	leave  
  801dd7:	c3                   	ret    

00801dd8 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801dd8:	55                   	push   %ebp
  801dd9:	89 e5                	mov    %esp,%ebp
  801ddb:	83 ec 58             	sub    $0x58,%esp
  801dde:	8b 45 10             	mov    0x10(%ebp),%eax
  801de1:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801de4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801de8:	75 0a                	jne    801df4 <smalloc+0x1c>
		return NULL;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	e9 7d 01 00 00       	jmp    801f71 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801df4:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e01:	01 d0                	add    %edx,%eax
  801e03:	48                   	dec    %eax
  801e04:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e0a:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0f:	f7 75 e4             	divl   -0x1c(%ebp)
  801e12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e15:	29 d0                	sub    %edx,%eax
  801e17:	c1 e8 0c             	shr    $0xc,%eax
  801e1a:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801e24:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801e2b:	a1 20 40 80 00       	mov    0x804020,%eax
  801e30:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e33:	05 00 10 00 00       	add    $0x1000,%eax
  801e38:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801e3b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801e40:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801e43:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801e46:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801e4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801e53:	01 d0                	add    %edx,%eax
  801e55:	48                   	dec    %eax
  801e56:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801e59:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e61:	f7 75 d0             	divl   -0x30(%ebp)
  801e64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801e67:	29 d0                	sub    %edx,%eax
  801e69:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801e6c:	76 0a                	jbe    801e78 <smalloc+0xa0>
		return NULL;
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e73:	e9 f9 00 00 00       	jmp    801f71 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801e78:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e7e:	eb 48                	jmp    801ec8 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801e80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e83:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801e86:	c1 e8 0c             	shr    $0xc,%eax
  801e89:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801e8c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801e8f:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801e96:	85 c0                	test   %eax,%eax
  801e98:	75 11                	jne    801eab <smalloc+0xd3>
			freePagesCount++;
  801e9a:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801e9d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ea1:	75 16                	jne    801eb9 <smalloc+0xe1>
				start = s;
  801ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ea9:	eb 0e                	jmp    801eb9 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801eb2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801ebf:	74 12                	je     801ed3 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801ec1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801ec8:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801ecf:	76 af                	jbe    801e80 <smalloc+0xa8>
  801ed1:	eb 01                	jmp    801ed4 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801ed3:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801ed4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ed8:	74 08                	je     801ee2 <smalloc+0x10a>
  801eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801ee0:	74 0a                	je     801eec <smalloc+0x114>
		return NULL;
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	e9 85 00 00 00       	jmp    801f71 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801eec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eef:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ef2:	c1 e8 0c             	shr    $0xc,%eax
  801ef5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801ef8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801efb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801efe:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801f05:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f08:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f0b:	eb 11                	jmp    801f1e <smalloc+0x146>
		markedPages[s] = 1;
  801f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f10:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801f17:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801f1b:	ff 45 e8             	incl   -0x18(%ebp)
  801f1e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f24:	01 d0                	add    %edx,%eax
  801f26:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f29:	77 e2                	ja     801f0d <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801f2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f2e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	ff 75 0c             	pushl  0xc(%ebp)
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	e8 84 f5 ff ff       	call   8014c3 <sys_createSharedObject>
  801f3f:	83 c4 10             	add    $0x10,%esp
  801f42:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801f45:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801f49:	78 12                	js     801f5d <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801f4b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f4e:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801f51:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  801f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5b:	eb 14                	jmp    801f71 <smalloc+0x199>
	}
	free((void*) start);
  801f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f60:	83 ec 0c             	sub    $0xc,%esp
  801f63:	50                   	push   %eax
  801f64:	e8 6e fd ff ff       	call   801cd7 <free>
  801f69:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801f79:	83 ec 08             	sub    $0x8,%esp
  801f7c:	ff 75 0c             	pushl  0xc(%ebp)
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	e8 66 f5 ff ff       	call   8014ed <sys_getSizeOfSharedObject>
  801f87:	83 c4 10             	add    $0x10,%esp
  801f8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801f8d:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801f94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f9a:	01 d0                	add    %edx,%eax
  801f9c:	48                   	dec    %eax
  801f9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801fa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fa3:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa8:	f7 75 e0             	divl   -0x20(%ebp)
  801fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fae:	29 d0                	sub    %edx,%eax
  801fb0:	c1 e8 0c             	shr    $0xc,%eax
  801fb3:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  801fb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801fbd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  801fc4:	a1 20 40 80 00       	mov    0x804020,%eax
  801fc9:	8b 40 7c             	mov    0x7c(%eax),%eax
  801fcc:	05 00 10 00 00       	add    $0x1000,%eax
  801fd1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  801fd4:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801fd9:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fdc:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801fdf:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801fe6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801fe9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801fec:	01 d0                	add    %edx,%eax
  801fee:	48                   	dec    %eax
  801fef:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801ff2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ff5:	ba 00 00 00 00       	mov    $0x0,%edx
  801ffa:	f7 75 cc             	divl   -0x34(%ebp)
  801ffd:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802000:	29 d0                	sub    %edx,%eax
  802002:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802005:	76 0a                	jbe    802011 <sget+0x9e>
		return NULL;
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	e9 f7 00 00 00       	jmp    802108 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802011:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802014:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802017:	eb 48                	jmp    802061 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  802019:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80201c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80201f:	c1 e8 0c             	shr    $0xc,%eax
  802022:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  802025:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802028:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  80202f:	85 c0                	test   %eax,%eax
  802031:	75 11                	jne    802044 <sget+0xd1>
			free_Pages_Count++;
  802033:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802036:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80203a:	75 16                	jne    802052 <sget+0xdf>
				start = s;
  80203c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80203f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802042:	eb 0e                	jmp    802052 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  802044:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80204b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802058:	74 12                	je     80206c <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80205a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802061:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802068:	76 af                	jbe    802019 <sget+0xa6>
  80206a:	eb 01                	jmp    80206d <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  80206c:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  80206d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802071:	74 08                	je     80207b <sget+0x108>
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802079:	74 0a                	je     802085 <sget+0x112>
		return NULL;
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
  802080:	e9 83 00 00 00       	jmp    802108 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  802085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802088:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80208b:	c1 e8 0c             	shr    $0xc,%eax
  80208e:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802091:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802094:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802097:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80209e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020a4:	eb 11                	jmp    8020b7 <sget+0x144>
		markedPages[k] = 1;
  8020a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a9:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  8020b0:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8020b4:	ff 45 e8             	incl   -0x18(%ebp)
  8020b7:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8020ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8020c2:	77 e2                	ja     8020a6 <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8020c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	50                   	push   %eax
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	e8 34 f4 ff ff       	call   80150a <sys_getSharedObject>
  8020d6:	83 c4 10             	add    $0x10,%esp
  8020d9:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  8020dc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  8020e0:	78 12                	js     8020f4 <sget+0x181>
		shardIDs[startPage] = ss;
  8020e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020e5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  8020e8:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  8020ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f2:	eb 14                	jmp    802108 <sget+0x195>
	}
	free((void*) start);
  8020f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f7:	83 ec 0c             	sub    $0xc,%esp
  8020fa:	50                   	push   %eax
  8020fb:	e8 d7 fb ff ff       	call   801cd7 <free>
  802100:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802110:	8b 55 08             	mov    0x8(%ebp),%edx
  802113:	a1 20 40 80 00       	mov    0x804020,%eax
  802118:	8b 40 7c             	mov    0x7c(%eax),%eax
  80211b:	29 c2                	sub    %eax,%edx
  80211d:	89 d0                	mov    %edx,%eax
  80211f:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  802124:	c1 e8 0c             	shr    $0xc,%eax
  802127:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  802134:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  802137:	83 ec 08             	sub    $0x8,%esp
  80213a:	ff 75 08             	pushl  0x8(%ebp)
  80213d:	ff 75 f0             	pushl  -0x10(%ebp)
  802140:	e8 e4 f3 ff ff       	call   801529 <sys_freeSharedObject>
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  80214b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80214f:	75 0e                	jne    80215f <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802154:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  80215b:	ff ff ff ff 
	}

}
  80215f:	90                   	nop
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	68 84 3d 80 00       	push   $0x803d84
  802170:	68 19 01 00 00       	push   $0x119
  802175:	68 76 3d 80 00       	push   $0x803d76
  80217a:	e8 f5 e0 ff ff       	call   800274 <_panic>

0080217f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
  802182:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802185:	83 ec 04             	sub    $0x4,%esp
  802188:	68 aa 3d 80 00       	push   $0x803daa
  80218d:	68 23 01 00 00       	push   $0x123
  802192:	68 76 3d 80 00       	push   $0x803d76
  802197:	e8 d8 e0 ff ff       	call   800274 <_panic>

0080219c <shrink>:

}
void shrink(uint32 newSize) {
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021a2:	83 ec 04             	sub    $0x4,%esp
  8021a5:	68 aa 3d 80 00       	push   $0x803daa
  8021aa:	68 27 01 00 00       	push   $0x127
  8021af:	68 76 3d 80 00       	push   $0x803d76
  8021b4:	e8 bb e0 ff ff       	call   800274 <_panic>

008021b9 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021bf:	83 ec 04             	sub    $0x4,%esp
  8021c2:	68 aa 3d 80 00       	push   $0x803daa
  8021c7:	68 2b 01 00 00       	push   $0x12b
  8021cc:	68 76 3d 80 00       	push   $0x803d76
  8021d1:	e8 9e e0 ff ff       	call   800274 <_panic>

008021d6 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	83 e8 04             	sub    $0x4,%eax
  8021e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  8021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
  8021f2:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8021f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f8:	83 e8 04             	sub    $0x4,%eax
  8021fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8021fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802201:	8b 00                	mov    (%eax),%eax
  802203:	83 e0 01             	and    $0x1,%eax
  802206:	85 c0                	test   %eax,%eax
  802208:	0f 94 c0             	sete   %al
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802213:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80221a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221d:	83 f8 02             	cmp    $0x2,%eax
  802220:	74 2b                	je     80224d <alloc_block+0x40>
  802222:	83 f8 02             	cmp    $0x2,%eax
  802225:	7f 07                	jg     80222e <alloc_block+0x21>
  802227:	83 f8 01             	cmp    $0x1,%eax
  80222a:	74 0e                	je     80223a <alloc_block+0x2d>
  80222c:	eb 58                	jmp    802286 <alloc_block+0x79>
  80222e:	83 f8 03             	cmp    $0x3,%eax
  802231:	74 2d                	je     802260 <alloc_block+0x53>
  802233:	83 f8 04             	cmp    $0x4,%eax
  802236:	74 3b                	je     802273 <alloc_block+0x66>
  802238:	eb 4c                	jmp    802286 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80223a:	83 ec 0c             	sub    $0xc,%esp
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	e8 f7 03 00 00       	call   80263c <alloc_block_FF>
  802245:	83 c4 10             	add    $0x10,%esp
  802248:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80224b:	eb 4a                	jmp    802297 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  80224d:	83 ec 0c             	sub    $0xc,%esp
  802250:	ff 75 08             	pushl  0x8(%ebp)
  802253:	e8 f0 11 00 00       	call   803448 <alloc_block_NF>
  802258:	83 c4 10             	add    $0x10,%esp
  80225b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80225e:	eb 37                	jmp    802297 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	ff 75 08             	pushl  0x8(%ebp)
  802266:	e8 08 08 00 00       	call   802a73 <alloc_block_BF>
  80226b:	83 c4 10             	add    $0x10,%esp
  80226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802271:	eb 24                	jmp    802297 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802273:	83 ec 0c             	sub    $0xc,%esp
  802276:	ff 75 08             	pushl  0x8(%ebp)
  802279:	e8 ad 11 00 00       	call   80342b <alloc_block_WF>
  80227e:	83 c4 10             	add    $0x10,%esp
  802281:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802284:	eb 11                	jmp    802297 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  802286:	83 ec 0c             	sub    $0xc,%esp
  802289:	68 bc 3d 80 00       	push   $0x803dbc
  80228e:	e8 9e e2 ff ff       	call   800531 <cprintf>
  802293:	83 c4 10             	add    $0x10,%esp
		break;
  802296:	90                   	nop
	}
	return va;
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80229a:	c9                   	leave  
  80229b:	c3                   	ret    

0080229c <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	53                   	push   %ebx
  8022a0:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  8022a3:	83 ec 0c             	sub    $0xc,%esp
  8022a6:	68 dc 3d 80 00       	push   $0x803ddc
  8022ab:	e8 81 e2 ff ff       	call   800531 <cprintf>
  8022b0:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  8022b3:	83 ec 0c             	sub    $0xc,%esp
  8022b6:	68 07 3e 80 00       	push   $0x803e07
  8022bb:	e8 71 e2 ff ff       	call   800531 <cprintf>
  8022c0:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c9:	eb 37                	jmp    802302 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  8022cb:	83 ec 0c             	sub    $0xc,%esp
  8022ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8022d1:	e8 19 ff ff ff       	call   8021ef <is_free_block>
  8022d6:	83 c4 10             	add    $0x10,%esp
  8022d9:	0f be d8             	movsbl %al,%ebx
  8022dc:	83 ec 0c             	sub    $0xc,%esp
  8022df:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e2:	e8 ef fe ff ff       	call   8021d6 <get_block_size>
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	83 ec 04             	sub    $0x4,%esp
  8022ed:	53                   	push   %ebx
  8022ee:	50                   	push   %eax
  8022ef:	68 1f 3e 80 00       	push   $0x803e1f
  8022f4:	e8 38 e2 ff ff       	call   800531 <cprintf>
  8022f9:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8022fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802306:	74 07                	je     80230f <print_blocks_list+0x73>
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 00                	mov    (%eax),%eax
  80230d:	eb 05                	jmp    802314 <print_blocks_list+0x78>
  80230f:	b8 00 00 00 00       	mov    $0x0,%eax
  802314:	89 45 10             	mov    %eax,0x10(%ebp)
  802317:	8b 45 10             	mov    0x10(%ebp),%eax
  80231a:	85 c0                	test   %eax,%eax
  80231c:	75 ad                	jne    8022cb <print_blocks_list+0x2f>
  80231e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802322:	75 a7                	jne    8022cb <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802324:	83 ec 0c             	sub    $0xc,%esp
  802327:	68 dc 3d 80 00       	push   $0x803ddc
  80232c:	e8 00 e2 ff ff       	call   800531 <cprintf>
  802331:	83 c4 10             	add    $0x10,%esp

}
  802334:	90                   	nop
  802335:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
  80233d:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802340:	8b 45 0c             	mov    0xc(%ebp),%eax
  802343:	83 e0 01             	and    $0x1,%eax
  802346:	85 c0                	test   %eax,%eax
  802348:	74 03                	je     80234d <initialize_dynamic_allocator+0x13>
  80234a:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80234d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802351:	0f 84 f8 00 00 00    	je     80244f <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802357:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  80235e:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802361:	a1 40 40 98 00       	mov    0x984040,%eax
  802366:	85 c0                	test   %eax,%eax
  802368:	0f 84 e2 00 00 00    	je     802450 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80237d:	8b 55 08             	mov    0x8(%ebp),%edx
  802380:	8b 45 0c             	mov    0xc(%ebp),%eax
  802383:	01 d0                	add    %edx,%eax
  802385:	83 e8 04             	sub    $0x4,%eax
  802388:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	83 c0 08             	add    $0x8,%eax
  80239a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80239d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a0:	83 e8 08             	sub    $0x8,%eax
  8023a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	6a 00                	push   $0x0
  8023ab:	ff 75 e8             	pushl  -0x18(%ebp)
  8023ae:	ff 75 ec             	pushl  -0x14(%ebp)
  8023b1:	e8 9c 00 00 00       	call   802452 <set_block_data>
  8023b6:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  8023b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  8023c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  8023cc:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  8023d3:	00 00 00 
  8023d6:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  8023dd:	00 00 00 
  8023e0:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  8023e7:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8023ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023ee:	75 17                	jne    802407 <initialize_dynamic_allocator+0xcd>
  8023f0:	83 ec 04             	sub    $0x4,%esp
  8023f3:	68 38 3e 80 00       	push   $0x803e38
  8023f8:	68 80 00 00 00       	push   $0x80
  8023fd:	68 5b 3e 80 00       	push   $0x803e5b
  802402:	e8 6d de ff ff       	call   800274 <_panic>
  802407:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80240d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802410:	89 10                	mov    %edx,(%eax)
  802412:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	74 0d                	je     802428 <initialize_dynamic_allocator+0xee>
  80241b:	a1 48 40 98 00       	mov    0x984048,%eax
  802420:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802423:	89 50 04             	mov    %edx,0x4(%eax)
  802426:	eb 08                	jmp    802430 <initialize_dynamic_allocator+0xf6>
  802428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802430:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802433:	a3 48 40 98 00       	mov    %eax,0x984048
  802438:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802442:	a1 54 40 98 00       	mov    0x984054,%eax
  802447:	40                   	inc    %eax
  802448:	a3 54 40 98 00       	mov    %eax,0x984054
  80244d:	eb 01                	jmp    802450 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  80244f:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245b:	83 e0 01             	and    $0x1,%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	74 03                	je     802465 <set_block_data+0x13>
	{
		totalSize++;
  802462:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	83 e8 04             	sub    $0x4,%eax
  80246b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  80246e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802471:	83 e0 fe             	and    $0xfffffffe,%eax
  802474:	89 c2                	mov    %eax,%edx
  802476:	8b 45 10             	mov    0x10(%ebp),%eax
  802479:	83 e0 01             	and    $0x1,%eax
  80247c:	09 c2                	or     %eax,%edx
  80247e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802481:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802483:	8b 45 0c             	mov    0xc(%ebp),%eax
  802486:	8d 50 f8             	lea    -0x8(%eax),%edx
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	01 d0                	add    %edx,%eax
  80248e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802491:	8b 45 0c             	mov    0xc(%ebp),%eax
  802494:	83 e0 fe             	and    $0xfffffffe,%eax
  802497:	89 c2                	mov    %eax,%edx
  802499:	8b 45 10             	mov    0x10(%ebp),%eax
  80249c:	83 e0 01             	and    $0x1,%eax
  80249f:	09 c2                	or     %eax,%edx
  8024a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024a4:	89 10                	mov    %edx,(%eax)
}
  8024a6:	90                   	nop
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
  8024ac:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  8024af:	a1 48 40 98 00       	mov    0x984048,%eax
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	75 68                	jne    802520 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  8024b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024bc:	75 17                	jne    8024d5 <insert_sorted_in_freeList+0x2c>
  8024be:	83 ec 04             	sub    $0x4,%esp
  8024c1:	68 38 3e 80 00       	push   $0x803e38
  8024c6:	68 9d 00 00 00       	push   $0x9d
  8024cb:	68 5b 3e 80 00       	push   $0x803e5b
  8024d0:	e8 9f dd ff ff       	call   800274 <_panic>
  8024d5:	8b 15 48 40 98 00    	mov    0x984048,%edx
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	89 10                	mov    %edx,(%eax)
  8024e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	74 0d                	je     8024f6 <insert_sorted_in_freeList+0x4d>
  8024e9:	a1 48 40 98 00       	mov    0x984048,%eax
  8024ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f1:	89 50 04             	mov    %edx,0x4(%eax)
  8024f4:	eb 08                	jmp    8024fe <insert_sorted_in_freeList+0x55>
  8024f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f9:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	a3 48 40 98 00       	mov    %eax,0x984048
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802510:	a1 54 40 98 00       	mov    0x984054,%eax
  802515:	40                   	inc    %eax
  802516:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  80251b:	e9 1a 01 00 00       	jmp    80263a <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802520:	a1 48 40 98 00       	mov    0x984048,%eax
  802525:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802528:	eb 7f                	jmp    8025a9 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802530:	76 6f                	jbe    8025a1 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802536:	74 06                	je     80253e <insert_sorted_in_freeList+0x95>
  802538:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80253c:	75 17                	jne    802555 <insert_sorted_in_freeList+0xac>
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	68 74 3e 80 00       	push   $0x803e74
  802546:	68 a6 00 00 00       	push   $0xa6
  80254b:	68 5b 3e 80 00       	push   $0x803e5b
  802550:	e8 1f dd ff ff       	call   800274 <_panic>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 50 04             	mov    0x4(%eax),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	89 50 04             	mov    %edx,0x4(%eax)
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802567:	89 10                	mov    %edx,(%eax)
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 04             	mov    0x4(%eax),%eax
  80256f:	85 c0                	test   %eax,%eax
  802571:	74 0d                	je     802580 <insert_sorted_in_freeList+0xd7>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	8b 55 08             	mov    0x8(%ebp),%edx
  80257c:	89 10                	mov    %edx,(%eax)
  80257e:	eb 08                	jmp    802588 <insert_sorted_in_freeList+0xdf>
  802580:	8b 45 08             	mov    0x8(%ebp),%eax
  802583:	a3 48 40 98 00       	mov    %eax,0x984048
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 55 08             	mov    0x8(%ebp),%edx
  80258e:	89 50 04             	mov    %edx,0x4(%eax)
  802591:	a1 54 40 98 00       	mov    0x984054,%eax
  802596:	40                   	inc    %eax
  802597:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  80259c:	e9 99 00 00 00       	jmp    80263a <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8025a1:	a1 50 40 98 00       	mov    0x984050,%eax
  8025a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ad:	74 07                	je     8025b6 <insert_sorted_in_freeList+0x10d>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	eb 05                	jmp    8025bb <insert_sorted_in_freeList+0x112>
  8025b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bb:	a3 50 40 98 00       	mov    %eax,0x984050
  8025c0:	a1 50 40 98 00       	mov    0x984050,%eax
  8025c5:	85 c0                	test   %eax,%eax
  8025c7:	0f 85 5d ff ff ff    	jne    80252a <insert_sorted_in_freeList+0x81>
  8025cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d1:	0f 85 53 ff ff ff    	jne    80252a <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  8025d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025db:	75 17                	jne    8025f4 <insert_sorted_in_freeList+0x14b>
  8025dd:	83 ec 04             	sub    $0x4,%esp
  8025e0:	68 ac 3e 80 00       	push   $0x803eac
  8025e5:	68 ab 00 00 00       	push   $0xab
  8025ea:	68 5b 3e 80 00       	push   $0x803e5b
  8025ef:	e8 80 dc ff ff       	call   800274 <_panic>
  8025f4:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	89 50 04             	mov    %edx,0x4(%eax)
  802600:	8b 45 08             	mov    0x8(%ebp),%eax
  802603:	8b 40 04             	mov    0x4(%eax),%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	74 0c                	je     802616 <insert_sorted_in_freeList+0x16d>
  80260a:	a1 4c 40 98 00       	mov    0x98404c,%eax
  80260f:	8b 55 08             	mov    0x8(%ebp),%edx
  802612:	89 10                	mov    %edx,(%eax)
  802614:	eb 08                	jmp    80261e <insert_sorted_in_freeList+0x175>
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	a3 48 40 98 00       	mov    %eax,0x984048
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262f:	a1 54 40 98 00       	mov    0x984054,%eax
  802634:	40                   	inc    %eax
  802635:	a3 54 40 98 00       	mov    %eax,0x984054
}
  80263a:	c9                   	leave  
  80263b:	c3                   	ret    

0080263c <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  80263c:	55                   	push   %ebp
  80263d:	89 e5                	mov    %esp,%ebp
  80263f:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	83 e0 01             	and    $0x1,%eax
  802648:	85 c0                	test   %eax,%eax
  80264a:	74 03                	je     80264f <alloc_block_FF+0x13>
  80264c:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  80264f:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802653:	77 07                	ja     80265c <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802655:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80265c:	a1 40 40 98 00       	mov    0x984040,%eax
  802661:	85 c0                	test   %eax,%eax
  802663:	75 63                	jne    8026c8 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802665:	8b 45 08             	mov    0x8(%ebp),%eax
  802668:	83 c0 10             	add    $0x10,%eax
  80266b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  80266e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802675:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802678:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267b:	01 d0                	add    %edx,%eax
  80267d:	48                   	dec    %eax
  80267e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802681:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802684:	ba 00 00 00 00       	mov    $0x0,%edx
  802689:	f7 75 ec             	divl   -0x14(%ebp)
  80268c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268f:	29 d0                	sub    %edx,%eax
  802691:	c1 e8 0c             	shr    $0xc,%eax
  802694:	83 ec 0c             	sub    $0xc,%esp
  802697:	50                   	push   %eax
  802698:	e8 6e f4 ff ff       	call   801b0b <sbrk>
  80269d:	83 c4 10             	add    $0x10,%esp
  8026a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  8026a3:	83 ec 0c             	sub    $0xc,%esp
  8026a6:	6a 00                	push   $0x0
  8026a8:	e8 5e f4 ff ff       	call   801b0b <sbrk>
  8026ad:	83 c4 10             	add    $0x10,%esp
  8026b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  8026b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8026b9:	83 ec 08             	sub    $0x8,%esp
  8026bc:	50                   	push   %eax
  8026bd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8026c0:	e8 75 fc ff ff       	call   80233a <initialize_dynamic_allocator>
  8026c5:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  8026c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026cc:	75 0a                	jne    8026d8 <alloc_block_FF+0x9c>
	{
		return NULL;
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d3:	e9 99 03 00 00       	jmp    802a71 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	83 c0 08             	add    $0x8,%eax
  8026de:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8026e1:	a1 48 40 98 00       	mov    0x984048,%eax
  8026e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e9:	e9 03 02 00 00       	jmp    8028f1 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8026ee:	83 ec 0c             	sub    $0xc,%esp
  8026f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8026f4:	e8 dd fa ff ff       	call   8021d6 <get_block_size>
  8026f9:	83 c4 10             	add    $0x10,%esp
  8026fc:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8026ff:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802702:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802705:	0f 82 de 01 00 00    	jb     8028e9 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80270b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80270e:	83 c0 10             	add    $0x10,%eax
  802711:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802714:	0f 87 32 01 00 00    	ja     80284c <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80271a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80271d:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802720:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802723:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802726:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802729:	01 d0                	add    %edx,%eax
  80272b:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	6a 00                	push   $0x0
  802733:	ff 75 98             	pushl  -0x68(%ebp)
  802736:	ff 75 94             	pushl  -0x6c(%ebp)
  802739:	e8 14 fd ff ff       	call   802452 <set_block_data>
  80273e:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802745:	74 06                	je     80274d <alloc_block_FF+0x111>
  802747:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80274b:	75 17                	jne    802764 <alloc_block_FF+0x128>
  80274d:	83 ec 04             	sub    $0x4,%esp
  802750:	68 d0 3e 80 00       	push   $0x803ed0
  802755:	68 de 00 00 00       	push   $0xde
  80275a:	68 5b 3e 80 00       	push   $0x803e5b
  80275f:	e8 10 db ff ff       	call   800274 <_panic>
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 10                	mov    (%eax),%edx
  802769:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80276c:	89 10                	mov    %edx,(%eax)
  80276e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	74 0b                	je     802782 <alloc_block_FF+0x146>
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80277f:	89 50 04             	mov    %edx,0x4(%eax)
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802788:	89 10                	mov    %edx,(%eax)
  80278a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80278d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802790:	89 50 04             	mov    %edx,0x4(%eax)
  802793:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	75 08                	jne    8027a4 <alloc_block_FF+0x168>
  80279c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80279f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8027a4:	a1 54 40 98 00       	mov    0x984054,%eax
  8027a9:	40                   	inc    %eax
  8027aa:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  8027af:	83 ec 04             	sub    $0x4,%esp
  8027b2:	6a 01                	push   $0x1
  8027b4:	ff 75 dc             	pushl  -0x24(%ebp)
  8027b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8027ba:	e8 93 fc ff ff       	call   802452 <set_block_data>
  8027bf:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8027c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c6:	75 17                	jne    8027df <alloc_block_FF+0x1a3>
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	68 04 3f 80 00       	push   $0x803f04
  8027d0:	68 e3 00 00 00       	push   $0xe3
  8027d5:	68 5b 3e 80 00       	push   $0x803e5b
  8027da:	e8 95 da ff ff       	call   800274 <_panic>
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 10                	je     8027f8 <alloc_block_FF+0x1bc>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f0:	8b 52 04             	mov    0x4(%edx),%edx
  8027f3:	89 50 04             	mov    %edx,0x4(%eax)
  8027f6:	eb 0b                	jmp    802803 <alloc_block_FF+0x1c7>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	74 0f                	je     80281c <alloc_block_FF+0x1e0>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802816:	8b 12                	mov    (%edx),%edx
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	eb 0a                	jmp    802826 <alloc_block_FF+0x1ea>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	a3 48 40 98 00       	mov    %eax,0x984048
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802839:	a1 54 40 98 00       	mov    0x984054,%eax
  80283e:	48                   	dec    %eax
  80283f:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	e9 25 02 00 00       	jmp    802a71 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80284c:	83 ec 04             	sub    $0x4,%esp
  80284f:	6a 01                	push   $0x1
  802851:	ff 75 9c             	pushl  -0x64(%ebp)
  802854:	ff 75 f4             	pushl  -0xc(%ebp)
  802857:	e8 f6 fb ff ff       	call   802452 <set_block_data>
  80285c:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80285f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802863:	75 17                	jne    80287c <alloc_block_FF+0x240>
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	68 04 3f 80 00       	push   $0x803f04
  80286d:	68 eb 00 00 00       	push   $0xeb
  802872:	68 5b 3e 80 00       	push   $0x803e5b
  802877:	e8 f8 d9 ff ff       	call   800274 <_panic>
  80287c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	85 c0                	test   %eax,%eax
  802883:	74 10                	je     802895 <alloc_block_FF+0x259>
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288d:	8b 52 04             	mov    0x4(%edx),%edx
  802890:	89 50 04             	mov    %edx,0x4(%eax)
  802893:	eb 0b                	jmp    8028a0 <alloc_block_FF+0x264>
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 40 04             	mov    0x4(%eax),%eax
  80289b:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	85 c0                	test   %eax,%eax
  8028a8:	74 0f                	je     8028b9 <alloc_block_FF+0x27d>
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 40 04             	mov    0x4(%eax),%eax
  8028b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b3:	8b 12                	mov    (%edx),%edx
  8028b5:	89 10                	mov    %edx,(%eax)
  8028b7:	eb 0a                	jmp    8028c3 <alloc_block_FF+0x287>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 00                	mov    (%eax),%eax
  8028be:	a3 48 40 98 00       	mov    %eax,0x984048
  8028c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d6:	a1 54 40 98 00       	mov    0x984054,%eax
  8028db:	48                   	dec    %eax
  8028dc:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  8028e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e4:	e9 88 01 00 00       	jmp    802a71 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8028e9:	a1 50 40 98 00       	mov    0x984050,%eax
  8028ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f5:	74 07                	je     8028fe <alloc_block_FF+0x2c2>
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	eb 05                	jmp    802903 <alloc_block_FF+0x2c7>
  8028fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802903:	a3 50 40 98 00       	mov    %eax,0x984050
  802908:	a1 50 40 98 00       	mov    0x984050,%eax
  80290d:	85 c0                	test   %eax,%eax
  80290f:	0f 85 d9 fd ff ff    	jne    8026ee <alloc_block_FF+0xb2>
  802915:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802919:	0f 85 cf fd ff ff    	jne    8026ee <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  80291f:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802926:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802929:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80292c:	01 d0                	add    %edx,%eax
  80292e:	48                   	dec    %eax
  80292f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802932:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802935:	ba 00 00 00 00       	mov    $0x0,%edx
  80293a:	f7 75 d8             	divl   -0x28(%ebp)
  80293d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802940:	29 d0                	sub    %edx,%eax
  802942:	c1 e8 0c             	shr    $0xc,%eax
  802945:	83 ec 0c             	sub    $0xc,%esp
  802948:	50                   	push   %eax
  802949:	e8 bd f1 ff ff       	call   801b0b <sbrk>
  80294e:	83 c4 10             	add    $0x10,%esp
  802951:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802954:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802958:	75 0a                	jne    802964 <alloc_block_FF+0x328>
		return NULL;
  80295a:	b8 00 00 00 00       	mov    $0x0,%eax
  80295f:	e9 0d 01 00 00       	jmp    802a71 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802964:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802967:	83 e8 04             	sub    $0x4,%eax
  80296a:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  80296d:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802974:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802977:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80297a:	01 d0                	add    %edx,%eax
  80297c:	48                   	dec    %eax
  80297d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802980:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802983:	ba 00 00 00 00       	mov    $0x0,%edx
  802988:	f7 75 c8             	divl   -0x38(%ebp)
  80298b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80298e:	29 d0                	sub    %edx,%eax
  802990:	c1 e8 02             	shr    $0x2,%eax
  802993:	c1 e0 02             	shl    $0x2,%eax
  802996:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802999:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80299c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  8029a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029a5:	83 e8 08             	sub    $0x8,%eax
  8029a8:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  8029ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	83 e0 fe             	and    $0xfffffffe,%eax
  8029b3:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  8029b6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8029b9:	f7 d8                	neg    %eax
  8029bb:	89 c2                	mov    %eax,%edx
  8029bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029c0:	01 d0                	add    %edx,%eax
  8029c2:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  8029c5:	83 ec 0c             	sub    $0xc,%esp
  8029c8:	ff 75 b8             	pushl  -0x48(%ebp)
  8029cb:	e8 1f f8 ff ff       	call   8021ef <is_free_block>
  8029d0:	83 c4 10             	add    $0x10,%esp
  8029d3:	0f be c0             	movsbl %al,%eax
  8029d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  8029d9:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8029dd:	74 42                	je     802a21 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8029df:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8029e6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029e9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8029ec:	01 d0                	add    %edx,%eax
  8029ee:	48                   	dec    %eax
  8029ef:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8029f2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8029f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8029fa:	f7 75 b0             	divl   -0x50(%ebp)
  8029fd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a00:	29 d0                	sub    %edx,%eax
  802a02:	89 c2                	mov    %eax,%edx
  802a04:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a07:	01 d0                	add    %edx,%eax
  802a09:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802a0c:	83 ec 04             	sub    $0x4,%esp
  802a0f:	6a 00                	push   $0x0
  802a11:	ff 75 a8             	pushl  -0x58(%ebp)
  802a14:	ff 75 b8             	pushl  -0x48(%ebp)
  802a17:	e8 36 fa ff ff       	call   802452 <set_block_data>
  802a1c:	83 c4 10             	add    $0x10,%esp
  802a1f:	eb 42                	jmp    802a63 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802a21:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802a28:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a2b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a2e:	01 d0                	add    %edx,%eax
  802a30:	48                   	dec    %eax
  802a31:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802a34:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a37:	ba 00 00 00 00       	mov    $0x0,%edx
  802a3c:	f7 75 a4             	divl   -0x5c(%ebp)
  802a3f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a42:	29 d0                	sub    %edx,%eax
  802a44:	83 ec 04             	sub    $0x4,%esp
  802a47:	6a 00                	push   $0x0
  802a49:	50                   	push   %eax
  802a4a:	ff 75 d0             	pushl  -0x30(%ebp)
  802a4d:	e8 00 fa ff ff       	call   802452 <set_block_data>
  802a52:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802a55:	83 ec 0c             	sub    $0xc,%esp
  802a58:	ff 75 d0             	pushl  -0x30(%ebp)
  802a5b:	e8 49 fa ff ff       	call   8024a9 <insert_sorted_in_freeList>
  802a60:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802a63:	83 ec 0c             	sub    $0xc,%esp
  802a66:	ff 75 08             	pushl  0x8(%ebp)
  802a69:	e8 ce fb ff ff       	call   80263c <alloc_block_FF>
  802a6e:	83 c4 10             	add    $0x10,%esp
}
  802a71:	c9                   	leave  
  802a72:	c3                   	ret    

00802a73 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802a73:	55                   	push   %ebp
  802a74:	89 e5                	mov    %esp,%ebp
  802a76:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802a79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7d:	75 0a                	jne    802a89 <alloc_block_BF+0x16>
	{
		return NULL;
  802a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a84:	e9 7a 02 00 00       	jmp    802d03 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	83 c0 08             	add    $0x8,%eax
  802a8f:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802a92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802a99:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802aa0:	a1 48 40 98 00       	mov    0x984048,%eax
  802aa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802aa8:	eb 32                	jmp    802adc <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802aaa:	ff 75 ec             	pushl  -0x14(%ebp)
  802aad:	e8 24 f7 ff ff       	call   8021d6 <get_block_size>
  802ab2:	83 c4 04             	add    $0x4,%esp
  802ab5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802abb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802abe:	72 14                	jb     802ad4 <alloc_block_BF+0x61>
  802ac0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ac6:	73 0c                	jae    802ad4 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802ac8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802ad4:	a1 50 40 98 00       	mov    0x984050,%eax
  802ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802adc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ae0:	74 07                	je     802ae9 <alloc_block_BF+0x76>
  802ae2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	eb 05                	jmp    802aee <alloc_block_BF+0x7b>
  802ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  802aee:	a3 50 40 98 00       	mov    %eax,0x984050
  802af3:	a1 50 40 98 00       	mov    0x984050,%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	75 ae                	jne    802aaa <alloc_block_BF+0x37>
  802afc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b00:	75 a8                	jne    802aaa <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802b02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b06:	75 22                	jne    802b2a <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802b08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0b:	83 ec 0c             	sub    $0xc,%esp
  802b0e:	50                   	push   %eax
  802b0f:	e8 f7 ef ff ff       	call   801b0b <sbrk>
  802b14:	83 c4 10             	add    $0x10,%esp
  802b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802b1a:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802b1e:	75 0a                	jne    802b2a <alloc_block_BF+0xb7>
			return NULL;
  802b20:	b8 00 00 00 00       	mov    $0x0,%eax
  802b25:	e9 d9 01 00 00       	jmp    802d03 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2d:	83 c0 10             	add    $0x10,%eax
  802b30:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b33:	0f 87 32 01 00 00    	ja     802c6b <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802b3f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b48:	01 d0                	add    %edx,%eax
  802b4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802b4d:	83 ec 04             	sub    $0x4,%esp
  802b50:	6a 00                	push   $0x0
  802b52:	ff 75 dc             	pushl  -0x24(%ebp)
  802b55:	ff 75 d8             	pushl  -0x28(%ebp)
  802b58:	e8 f5 f8 ff ff       	call   802452 <set_block_data>
  802b5d:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802b60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b64:	74 06                	je     802b6c <alloc_block_BF+0xf9>
  802b66:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802b6a:	75 17                	jne    802b83 <alloc_block_BF+0x110>
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	68 d0 3e 80 00       	push   $0x803ed0
  802b74:	68 49 01 00 00       	push   $0x149
  802b79:	68 5b 3e 80 00       	push   $0x803e5b
  802b7e:	e8 f1 d6 ff ff       	call   800274 <_panic>
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 10                	mov    (%eax),%edx
  802b88:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b8b:	89 10                	mov    %edx,(%eax)
  802b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802b90:	8b 00                	mov    (%eax),%eax
  802b92:	85 c0                	test   %eax,%eax
  802b94:	74 0b                	je     802ba1 <alloc_block_BF+0x12e>
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802b9e:	89 50 04             	mov    %edx,0x4(%eax)
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ba7:	89 10                	mov    %edx,(%eax)
  802ba9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802baf:	89 50 04             	mov    %edx,0x4(%eax)
  802bb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bb5:	8b 00                	mov    (%eax),%eax
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	75 08                	jne    802bc3 <alloc_block_BF+0x150>
  802bbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bbe:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802bc3:	a1 54 40 98 00       	mov    0x984054,%eax
  802bc8:	40                   	inc    %eax
  802bc9:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802bce:	83 ec 04             	sub    $0x4,%esp
  802bd1:	6a 01                	push   $0x1
  802bd3:	ff 75 e8             	pushl  -0x18(%ebp)
  802bd6:	ff 75 f4             	pushl  -0xc(%ebp)
  802bd9:	e8 74 f8 ff ff       	call   802452 <set_block_data>
  802bde:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802be1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be5:	75 17                	jne    802bfe <alloc_block_BF+0x18b>
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	68 04 3f 80 00       	push   $0x803f04
  802bef:	68 4e 01 00 00       	push   $0x14e
  802bf4:	68 5b 3e 80 00       	push   $0x803e5b
  802bf9:	e8 76 d6 ff ff       	call   800274 <_panic>
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	74 10                	je     802c17 <alloc_block_BF+0x1a4>
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0f:	8b 52 04             	mov    0x4(%edx),%edx
  802c12:	89 50 04             	mov    %edx,0x4(%eax)
  802c15:	eb 0b                	jmp    802c22 <alloc_block_BF+0x1af>
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 04             	mov    0x4(%eax),%eax
  802c1d:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 40 04             	mov    0x4(%eax),%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	74 0f                	je     802c3b <alloc_block_BF+0x1c8>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 40 04             	mov    0x4(%eax),%eax
  802c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c35:	8b 12                	mov    (%edx),%edx
  802c37:	89 10                	mov    %edx,(%eax)
  802c39:	eb 0a                	jmp    802c45 <alloc_block_BF+0x1d2>
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 00                	mov    (%eax),%eax
  802c40:	a3 48 40 98 00       	mov    %eax,0x984048
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c58:	a1 54 40 98 00       	mov    0x984054,%eax
  802c5d:	48                   	dec    %eax
  802c5e:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c66:	e9 98 00 00 00       	jmp    802d03 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802c6b:	83 ec 04             	sub    $0x4,%esp
  802c6e:	6a 01                	push   $0x1
  802c70:	ff 75 f0             	pushl  -0x10(%ebp)
  802c73:	ff 75 f4             	pushl  -0xc(%ebp)
  802c76:	e8 d7 f7 ff ff       	call   802452 <set_block_data>
  802c7b:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c82:	75 17                	jne    802c9b <alloc_block_BF+0x228>
  802c84:	83 ec 04             	sub    $0x4,%esp
  802c87:	68 04 3f 80 00       	push   $0x803f04
  802c8c:	68 56 01 00 00       	push   $0x156
  802c91:	68 5b 3e 80 00       	push   $0x803e5b
  802c96:	e8 d9 d5 ff ff       	call   800274 <_panic>
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	85 c0                	test   %eax,%eax
  802ca2:	74 10                	je     802cb4 <alloc_block_BF+0x241>
  802ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cac:	8b 52 04             	mov    0x4(%edx),%edx
  802caf:	89 50 04             	mov    %edx,0x4(%eax)
  802cb2:	eb 0b                	jmp    802cbf <alloc_block_BF+0x24c>
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 04             	mov    0x4(%eax),%eax
  802cba:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 40 04             	mov    0x4(%eax),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	74 0f                	je     802cd8 <alloc_block_BF+0x265>
  802cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccc:	8b 40 04             	mov    0x4(%eax),%eax
  802ccf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd2:	8b 12                	mov    (%edx),%edx
  802cd4:	89 10                	mov    %edx,(%eax)
  802cd6:	eb 0a                	jmp    802ce2 <alloc_block_BF+0x26f>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	a3 48 40 98 00       	mov    %eax,0x984048
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf5:	a1 54 40 98 00       	mov    0x984054,%eax
  802cfa:	48                   	dec    %eax
  802cfb:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802d03:	c9                   	leave  
  802d04:	c3                   	ret    

00802d05 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d05:	55                   	push   %ebp
  802d06:	89 e5                	mov    %esp,%ebp
  802d08:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802d0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0f:	0f 84 6a 02 00 00    	je     802f7f <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802d15:	ff 75 08             	pushl  0x8(%ebp)
  802d18:	e8 b9 f4 ff ff       	call   8021d6 <get_block_size>
  802d1d:	83 c4 04             	add    $0x4,%esp
  802d20:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	83 e8 08             	sub    $0x8,%eax
  802d29:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2f:	8b 00                	mov    (%eax),%eax
  802d31:	83 e0 fe             	and    $0xfffffffe,%eax
  802d34:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3a:	f7 d8                	neg    %eax
  802d3c:	89 c2                	mov    %eax,%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	01 d0                	add    %edx,%eax
  802d43:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802d46:	ff 75 e8             	pushl  -0x18(%ebp)
  802d49:	e8 a1 f4 ff ff       	call   8021ef <is_free_block>
  802d4e:	83 c4 04             	add    $0x4,%esp
  802d51:	0f be c0             	movsbl %al,%eax
  802d54:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802d57:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	01 d0                	add    %edx,%eax
  802d5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802d62:	ff 75 e0             	pushl  -0x20(%ebp)
  802d65:	e8 85 f4 ff ff       	call   8021ef <is_free_block>
  802d6a:	83 c4 04             	add    $0x4,%esp
  802d6d:	0f be c0             	movsbl %al,%eax
  802d70:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802d73:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802d77:	75 34                	jne    802dad <free_block+0xa8>
  802d79:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802d7d:	75 2e                	jne    802dad <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802d7f:	ff 75 e8             	pushl  -0x18(%ebp)
  802d82:	e8 4f f4 ff ff       	call   8021d6 <get_block_size>
  802d87:	83 c4 04             	add    $0x4,%esp
  802d8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802d93:	01 d0                	add    %edx,%eax
  802d95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802d98:	6a 00                	push   $0x0
  802d9a:	ff 75 d4             	pushl  -0x2c(%ebp)
  802d9d:	ff 75 e8             	pushl  -0x18(%ebp)
  802da0:	e8 ad f6 ff ff       	call   802452 <set_block_data>
  802da5:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802da8:	e9 d3 01 00 00       	jmp    802f80 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802dad:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802db1:	0f 85 c8 00 00 00    	jne    802e7f <free_block+0x17a>
  802db7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802dbb:	0f 85 be 00 00 00    	jne    802e7f <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802dc1:	ff 75 e0             	pushl  -0x20(%ebp)
  802dc4:	e8 0d f4 ff ff       	call   8021d6 <get_block_size>
  802dc9:	83 c4 04             	add    $0x4,%esp
  802dcc:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802dcf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802dd5:	01 d0                	add    %edx,%eax
  802dd7:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802dda:	6a 00                	push   $0x0
  802ddc:	ff 75 cc             	pushl  -0x34(%ebp)
  802ddf:	ff 75 08             	pushl  0x8(%ebp)
  802de2:	e8 6b f6 ff ff       	call   802452 <set_block_data>
  802de7:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802dea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802dee:	75 17                	jne    802e07 <free_block+0x102>
  802df0:	83 ec 04             	sub    $0x4,%esp
  802df3:	68 04 3f 80 00       	push   $0x803f04
  802df8:	68 87 01 00 00       	push   $0x187
  802dfd:	68 5b 3e 80 00       	push   $0x803e5b
  802e02:	e8 6d d4 ff ff       	call   800274 <_panic>
  802e07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 10                	je     802e20 <free_block+0x11b>
  802e10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e13:	8b 00                	mov    (%eax),%eax
  802e15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e18:	8b 52 04             	mov    0x4(%edx),%edx
  802e1b:	89 50 04             	mov    %edx,0x4(%eax)
  802e1e:	eb 0b                	jmp    802e2b <free_block+0x126>
  802e20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e23:	8b 40 04             	mov    0x4(%eax),%eax
  802e26:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802e2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e2e:	8b 40 04             	mov    0x4(%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 0f                	je     802e44 <free_block+0x13f>
  802e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e3e:	8b 12                	mov    (%edx),%edx
  802e40:	89 10                	mov    %edx,(%eax)
  802e42:	eb 0a                	jmp    802e4e <free_block+0x149>
  802e44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e47:	8b 00                	mov    (%eax),%eax
  802e49:	a3 48 40 98 00       	mov    %eax,0x984048
  802e4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e51:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e61:	a1 54 40 98 00       	mov    0x984054,%eax
  802e66:	48                   	dec    %eax
  802e67:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802e6c:	83 ec 0c             	sub    $0xc,%esp
  802e6f:	ff 75 08             	pushl  0x8(%ebp)
  802e72:	e8 32 f6 ff ff       	call   8024a9 <insert_sorted_in_freeList>
  802e77:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802e7a:	e9 01 01 00 00       	jmp    802f80 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802e7f:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e83:	0f 85 d3 00 00 00    	jne    802f5c <free_block+0x257>
  802e89:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e8d:	0f 85 c9 00 00 00    	jne    802f5c <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802e93:	83 ec 0c             	sub    $0xc,%esp
  802e96:	ff 75 e8             	pushl  -0x18(%ebp)
  802e99:	e8 38 f3 ff ff       	call   8021d6 <get_block_size>
  802e9e:	83 c4 10             	add    $0x10,%esp
  802ea1:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802ea4:	83 ec 0c             	sub    $0xc,%esp
  802ea7:	ff 75 e0             	pushl  -0x20(%ebp)
  802eaa:	e8 27 f3 ff ff       	call   8021d6 <get_block_size>
  802eaf:	83 c4 10             	add    $0x10,%esp
  802eb2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802eb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802ebb:	01 c2                	add    %eax,%edx
  802ebd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802ec0:	01 d0                	add    %edx,%eax
  802ec2:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802ec5:	83 ec 04             	sub    $0x4,%esp
  802ec8:	6a 00                	push   $0x0
  802eca:	ff 75 c0             	pushl  -0x40(%ebp)
  802ecd:	ff 75 e8             	pushl  -0x18(%ebp)
  802ed0:	e8 7d f5 ff ff       	call   802452 <set_block_data>
  802ed5:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802ed8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802edc:	75 17                	jne    802ef5 <free_block+0x1f0>
  802ede:	83 ec 04             	sub    $0x4,%esp
  802ee1:	68 04 3f 80 00       	push   $0x803f04
  802ee6:	68 94 01 00 00       	push   $0x194
  802eeb:	68 5b 3e 80 00       	push   $0x803e5b
  802ef0:	e8 7f d3 ff ff       	call   800274 <_panic>
  802ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef8:	8b 00                	mov    (%eax),%eax
  802efa:	85 c0                	test   %eax,%eax
  802efc:	74 10                	je     802f0e <free_block+0x209>
  802efe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f06:	8b 52 04             	mov    0x4(%edx),%edx
  802f09:	89 50 04             	mov    %edx,0x4(%eax)
  802f0c:	eb 0b                	jmp    802f19 <free_block+0x214>
  802f0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f11:	8b 40 04             	mov    0x4(%eax),%eax
  802f14:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802f19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f1c:	8b 40 04             	mov    0x4(%eax),%eax
  802f1f:	85 c0                	test   %eax,%eax
  802f21:	74 0f                	je     802f32 <free_block+0x22d>
  802f23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f26:	8b 40 04             	mov    0x4(%eax),%eax
  802f29:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f2c:	8b 12                	mov    (%edx),%edx
  802f2e:	89 10                	mov    %edx,(%eax)
  802f30:	eb 0a                	jmp    802f3c <free_block+0x237>
  802f32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	a3 48 40 98 00       	mov    %eax,0x984048
  802f3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4f:	a1 54 40 98 00       	mov    0x984054,%eax
  802f54:	48                   	dec    %eax
  802f55:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802f5a:	eb 24                	jmp    802f80 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802f5c:	83 ec 04             	sub    $0x4,%esp
  802f5f:	6a 00                	push   $0x0
  802f61:	ff 75 f4             	pushl  -0xc(%ebp)
  802f64:	ff 75 08             	pushl  0x8(%ebp)
  802f67:	e8 e6 f4 ff ff       	call   802452 <set_block_data>
  802f6c:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f6f:	83 ec 0c             	sub    $0xc,%esp
  802f72:	ff 75 08             	pushl  0x8(%ebp)
  802f75:	e8 2f f5 ff ff       	call   8024a9 <insert_sorted_in_freeList>
  802f7a:	83 c4 10             	add    $0x10,%esp
  802f7d:	eb 01                	jmp    802f80 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802f7f:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802f80:	c9                   	leave  
  802f81:	c3                   	ret    

00802f82 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802f82:	55                   	push   %ebp
  802f83:	89 e5                	mov    %esp,%ebp
  802f85:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8c:	75 10                	jne    802f9e <realloc_block_FF+0x1c>
  802f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802f92:	75 0a                	jne    802f9e <realloc_block_FF+0x1c>
	{
		return NULL;
  802f94:	b8 00 00 00 00       	mov    $0x0,%eax
  802f99:	e9 8b 04 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802f9e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802fa2:	75 18                	jne    802fbc <realloc_block_FF+0x3a>
	{
		free_block(va);
  802fa4:	83 ec 0c             	sub    $0xc,%esp
  802fa7:	ff 75 08             	pushl  0x8(%ebp)
  802faa:	e8 56 fd ff ff       	call   802d05 <free_block>
  802faf:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb7:	e9 6d 04 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802fbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc0:	75 13                	jne    802fd5 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802fc2:	83 ec 0c             	sub    $0xc,%esp
  802fc5:	ff 75 0c             	pushl  0xc(%ebp)
  802fc8:	e8 6f f6 ff ff       	call   80263c <alloc_block_FF>
  802fcd:	83 c4 10             	add    $0x10,%esp
  802fd0:	e9 54 04 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fd8:	83 e0 01             	and    $0x1,%eax
  802fdb:	85 c0                	test   %eax,%eax
  802fdd:	74 03                	je     802fe2 <realloc_block_FF+0x60>
	{
		new_size++;
  802fdf:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802fe2:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802fe6:	77 07                	ja     802fef <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802fe8:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802fef:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802ff3:	83 ec 0c             	sub    $0xc,%esp
  802ff6:	ff 75 08             	pushl  0x8(%ebp)
  802ff9:	e8 d8 f1 ff ff       	call   8021d6 <get_block_size>
  802ffe:	83 c4 10             	add    $0x10,%esp
  803001:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803007:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80300a:	75 08                	jne    803014 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	e9 15 04 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803014:	8b 55 08             	mov    0x8(%ebp),%edx
  803017:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301a:	01 d0                	add    %edx,%eax
  80301c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80301f:	83 ec 0c             	sub    $0xc,%esp
  803022:	ff 75 f0             	pushl  -0x10(%ebp)
  803025:	e8 c5 f1 ff ff       	call   8021ef <is_free_block>
  80302a:	83 c4 10             	add    $0x10,%esp
  80302d:	0f be c0             	movsbl %al,%eax
  803030:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803033:	83 ec 0c             	sub    $0xc,%esp
  803036:	ff 75 f0             	pushl  -0x10(%ebp)
  803039:	e8 98 f1 ff ff       	call   8021d6 <get_block_size>
  80303e:	83 c4 10             	add    $0x10,%esp
  803041:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  803044:	8b 45 0c             	mov    0xc(%ebp),%eax
  803047:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80304a:	0f 86 a7 02 00 00    	jbe    8032f7 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803050:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803054:	0f 84 86 02 00 00    	je     8032e0 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80305a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	01 d0                	add    %edx,%eax
  803062:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803065:	0f 85 b2 00 00 00    	jne    80311d <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  80306b:	83 ec 0c             	sub    $0xc,%esp
  80306e:	ff 75 08             	pushl  0x8(%ebp)
  803071:	e8 79 f1 ff ff       	call   8021ef <is_free_block>
  803076:	83 c4 10             	add    $0x10,%esp
  803079:	84 c0                	test   %al,%al
  80307b:	0f 94 c0             	sete   %al
  80307e:	0f b6 c0             	movzbl %al,%eax
  803081:	83 ec 04             	sub    $0x4,%esp
  803084:	50                   	push   %eax
  803085:	ff 75 0c             	pushl  0xc(%ebp)
  803088:	ff 75 08             	pushl  0x8(%ebp)
  80308b:	e8 c2 f3 ff ff       	call   802452 <set_block_data>
  803090:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803093:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803097:	75 17                	jne    8030b0 <realloc_block_FF+0x12e>
  803099:	83 ec 04             	sub    $0x4,%esp
  80309c:	68 04 3f 80 00       	push   $0x803f04
  8030a1:	68 db 01 00 00       	push   $0x1db
  8030a6:	68 5b 3e 80 00       	push   $0x803e5b
  8030ab:	e8 c4 d1 ff ff       	call   800274 <_panic>
  8030b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	85 c0                	test   %eax,%eax
  8030b7:	74 10                	je     8030c9 <realloc_block_FF+0x147>
  8030b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030c1:	8b 52 04             	mov    0x4(%edx),%edx
  8030c4:	89 50 04             	mov    %edx,0x4(%eax)
  8030c7:	eb 0b                	jmp    8030d4 <realloc_block_FF+0x152>
  8030c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cc:	8b 40 04             	mov    0x4(%eax),%eax
  8030cf:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 40 04             	mov    0x4(%eax),%eax
  8030da:	85 c0                	test   %eax,%eax
  8030dc:	74 0f                	je     8030ed <realloc_block_FF+0x16b>
  8030de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e1:	8b 40 04             	mov    0x4(%eax),%eax
  8030e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e7:	8b 12                	mov    (%edx),%edx
  8030e9:	89 10                	mov    %edx,(%eax)
  8030eb:	eb 0a                	jmp    8030f7 <realloc_block_FF+0x175>
  8030ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f0:	8b 00                	mov    (%eax),%eax
  8030f2:	a3 48 40 98 00       	mov    %eax,0x984048
  8030f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803103:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310a:	a1 54 40 98 00       	mov    0x984054,%eax
  80310f:	48                   	dec    %eax
  803110:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	e9 0c 03 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  80311d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	01 d0                	add    %edx,%eax
  803125:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803128:	0f 86 b2 01 00 00    	jbe    8032e0 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  80312e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803131:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  803137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80313d:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  803140:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  803144:	0f 87 b8 00 00 00    	ja     803202 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  80314a:	83 ec 0c             	sub    $0xc,%esp
  80314d:	ff 75 08             	pushl  0x8(%ebp)
  803150:	e8 9a f0 ff ff       	call   8021ef <is_free_block>
  803155:	83 c4 10             	add    $0x10,%esp
  803158:	84 c0                	test   %al,%al
  80315a:	0f 94 c0             	sete   %al
  80315d:	0f b6 c0             	movzbl %al,%eax
  803160:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803163:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803166:	01 ca                	add    %ecx,%edx
  803168:	83 ec 04             	sub    $0x4,%esp
  80316b:	50                   	push   %eax
  80316c:	52                   	push   %edx
  80316d:	ff 75 08             	pushl  0x8(%ebp)
  803170:	e8 dd f2 ff ff       	call   802452 <set_block_data>
  803175:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803178:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80317c:	75 17                	jne    803195 <realloc_block_FF+0x213>
  80317e:	83 ec 04             	sub    $0x4,%esp
  803181:	68 04 3f 80 00       	push   $0x803f04
  803186:	68 e8 01 00 00       	push   $0x1e8
  80318b:	68 5b 3e 80 00       	push   $0x803e5b
  803190:	e8 df d0 ff ff       	call   800274 <_panic>
  803195:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803198:	8b 00                	mov    (%eax),%eax
  80319a:	85 c0                	test   %eax,%eax
  80319c:	74 10                	je     8031ae <realloc_block_FF+0x22c>
  80319e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a6:	8b 52 04             	mov    0x4(%edx),%edx
  8031a9:	89 50 04             	mov    %edx,0x4(%eax)
  8031ac:	eb 0b                	jmp    8031b9 <realloc_block_FF+0x237>
  8031ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bc:	8b 40 04             	mov    0x4(%eax),%eax
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	74 0f                	je     8031d2 <realloc_block_FF+0x250>
  8031c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c6:	8b 40 04             	mov    0x4(%eax),%eax
  8031c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031cc:	8b 12                	mov    (%edx),%edx
  8031ce:	89 10                	mov    %edx,(%eax)
  8031d0:	eb 0a                	jmp    8031dc <realloc_block_FF+0x25a>
  8031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d5:	8b 00                	mov    (%eax),%eax
  8031d7:	a3 48 40 98 00       	mov    %eax,0x984048
  8031dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ef:	a1 54 40 98 00       	mov    0x984054,%eax
  8031f4:	48                   	dec    %eax
  8031f5:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	e9 27 02 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803202:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803206:	75 17                	jne    80321f <realloc_block_FF+0x29d>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 04 3f 80 00       	push   $0x803f04
  803210:	68 ed 01 00 00       	push   $0x1ed
  803215:	68 5b 3e 80 00       	push   $0x803e5b
  80321a:	e8 55 d0 ff ff       	call   800274 <_panic>
  80321f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803222:	8b 00                	mov    (%eax),%eax
  803224:	85 c0                	test   %eax,%eax
  803226:	74 10                	je     803238 <realloc_block_FF+0x2b6>
  803228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803230:	8b 52 04             	mov    0x4(%edx),%edx
  803233:	89 50 04             	mov    %edx,0x4(%eax)
  803236:	eb 0b                	jmp    803243 <realloc_block_FF+0x2c1>
  803238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803246:	8b 40 04             	mov    0x4(%eax),%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	74 0f                	je     80325c <realloc_block_FF+0x2da>
  80324d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803250:	8b 40 04             	mov    0x4(%eax),%eax
  803253:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803256:	8b 12                	mov    (%edx),%edx
  803258:	89 10                	mov    %edx,(%eax)
  80325a:	eb 0a                	jmp    803266 <realloc_block_FF+0x2e4>
  80325c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325f:	8b 00                	mov    (%eax),%eax
  803261:	a3 48 40 98 00       	mov    %eax,0x984048
  803266:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803269:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80326f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803279:	a1 54 40 98 00       	mov    0x984054,%eax
  80327e:	48                   	dec    %eax
  80327f:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803284:	8b 55 08             	mov    0x8(%ebp),%edx
  803287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80328a:	01 d0                	add    %edx,%eax
  80328c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  80328f:	83 ec 04             	sub    $0x4,%esp
  803292:	6a 00                	push   $0x0
  803294:	ff 75 e0             	pushl  -0x20(%ebp)
  803297:	ff 75 f0             	pushl  -0x10(%ebp)
  80329a:	e8 b3 f1 ff ff       	call   802452 <set_block_data>
  80329f:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  8032a2:	83 ec 0c             	sub    $0xc,%esp
  8032a5:	ff 75 08             	pushl  0x8(%ebp)
  8032a8:	e8 42 ef ff ff       	call   8021ef <is_free_block>
  8032ad:	83 c4 10             	add    $0x10,%esp
  8032b0:	84 c0                	test   %al,%al
  8032b2:	0f 94 c0             	sete   %al
  8032b5:	0f b6 c0             	movzbl %al,%eax
  8032b8:	83 ec 04             	sub    $0x4,%esp
  8032bb:	50                   	push   %eax
  8032bc:	ff 75 0c             	pushl  0xc(%ebp)
  8032bf:	ff 75 08             	pushl  0x8(%ebp)
  8032c2:	e8 8b f1 ff ff       	call   802452 <set_block_data>
  8032c7:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  8032ca:	83 ec 0c             	sub    $0xc,%esp
  8032cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8032d0:	e8 d4 f1 ff ff       	call   8024a9 <insert_sorted_in_freeList>
  8032d5:	83 c4 10             	add    $0x10,%esp
					return va;
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	e9 49 01 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  8032e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e3:	83 e8 08             	sub    $0x8,%eax
  8032e6:	83 ec 0c             	sub    $0xc,%esp
  8032e9:	50                   	push   %eax
  8032ea:	e8 4d f3 ff ff       	call   80263c <alloc_block_FF>
  8032ef:	83 c4 10             	add    $0x10,%esp
  8032f2:	e9 32 01 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8032f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8032fd:	0f 83 21 01 00 00    	jae    803424 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803306:	2b 45 0c             	sub    0xc(%ebp),%eax
  803309:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  80330c:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803310:	77 0e                	ja     803320 <realloc_block_FF+0x39e>
  803312:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803316:	75 08                	jne    803320 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	e9 09 01 00 00       	jmp    803429 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  803326:	83 ec 0c             	sub    $0xc,%esp
  803329:	ff 75 08             	pushl  0x8(%ebp)
  80332c:	e8 be ee ff ff       	call   8021ef <is_free_block>
  803331:	83 c4 10             	add    $0x10,%esp
  803334:	84 c0                	test   %al,%al
  803336:	0f 94 c0             	sete   %al
  803339:	0f b6 c0             	movzbl %al,%eax
  80333c:	83 ec 04             	sub    $0x4,%esp
  80333f:	50                   	push   %eax
  803340:	ff 75 0c             	pushl  0xc(%ebp)
  803343:	ff 75 d8             	pushl  -0x28(%ebp)
  803346:	e8 07 f1 ff ff       	call   802452 <set_block_data>
  80334b:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  80334e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803351:	8b 45 0c             	mov    0xc(%ebp),%eax
  803354:	01 d0                	add    %edx,%eax
  803356:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803359:	83 ec 04             	sub    $0x4,%esp
  80335c:	6a 00                	push   $0x0
  80335e:	ff 75 dc             	pushl  -0x24(%ebp)
  803361:	ff 75 d4             	pushl  -0x2c(%ebp)
  803364:	e8 e9 f0 ff ff       	call   802452 <set_block_data>
  803369:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80336c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803370:	0f 84 9b 00 00 00    	je     803411 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803376:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803379:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337c:	01 d0                	add    %edx,%eax
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	6a 00                	push   $0x0
  803383:	50                   	push   %eax
  803384:	ff 75 d4             	pushl  -0x2c(%ebp)
  803387:	e8 c6 f0 ff ff       	call   802452 <set_block_data>
  80338c:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  80338f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803393:	75 17                	jne    8033ac <realloc_block_FF+0x42a>
  803395:	83 ec 04             	sub    $0x4,%esp
  803398:	68 04 3f 80 00       	push   $0x803f04
  80339d:	68 10 02 00 00       	push   $0x210
  8033a2:	68 5b 3e 80 00       	push   $0x803e5b
  8033a7:	e8 c8 ce ff ff       	call   800274 <_panic>
  8033ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	74 10                	je     8033c5 <realloc_block_FF+0x443>
  8033b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b8:	8b 00                	mov    (%eax),%eax
  8033ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033bd:	8b 52 04             	mov    0x4(%edx),%edx
  8033c0:	89 50 04             	mov    %edx,0x4(%eax)
  8033c3:	eb 0b                	jmp    8033d0 <realloc_block_FF+0x44e>
  8033c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c8:	8b 40 04             	mov    0x4(%eax),%eax
  8033cb:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8033d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d3:	8b 40 04             	mov    0x4(%eax),%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	74 0f                	je     8033e9 <realloc_block_FF+0x467>
  8033da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033dd:	8b 40 04             	mov    0x4(%eax),%eax
  8033e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033e3:	8b 12                	mov    (%edx),%edx
  8033e5:	89 10                	mov    %edx,(%eax)
  8033e7:	eb 0a                	jmp    8033f3 <realloc_block_FF+0x471>
  8033e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	a3 48 40 98 00       	mov    %eax,0x984048
  8033f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803406:	a1 54 40 98 00       	mov    0x984054,%eax
  80340b:	48                   	dec    %eax
  80340c:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  803411:	83 ec 0c             	sub    $0xc,%esp
  803414:	ff 75 d4             	pushl  -0x2c(%ebp)
  803417:	e8 8d f0 ff ff       	call   8024a9 <insert_sorted_in_freeList>
  80341c:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  80341f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803422:	eb 05                	jmp    803429 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803424:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803429:	c9                   	leave  
  80342a:	c3                   	ret    

0080342b <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80342b:	55                   	push   %ebp
  80342c:	89 e5                	mov    %esp,%ebp
  80342e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803431:	83 ec 04             	sub    $0x4,%esp
  803434:	68 24 3f 80 00       	push   $0x803f24
  803439:	68 20 02 00 00       	push   $0x220
  80343e:	68 5b 3e 80 00       	push   $0x803e5b
  803443:	e8 2c ce ff ff       	call   800274 <_panic>

00803448 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  803448:	55                   	push   %ebp
  803449:	89 e5                	mov    %esp,%ebp
  80344b:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  80344e:	83 ec 04             	sub    $0x4,%esp
  803451:	68 4c 3f 80 00       	push   $0x803f4c
  803456:	68 28 02 00 00       	push   $0x228
  80345b:	68 5b 3e 80 00       	push   $0x803e5b
  803460:	e8 0f ce ff ff       	call   800274 <_panic>
  803465:	66 90                	xchg   %ax,%ax
  803467:	90                   	nop

00803468 <__udivdi3>:
  803468:	55                   	push   %ebp
  803469:	57                   	push   %edi
  80346a:	56                   	push   %esi
  80346b:	53                   	push   %ebx
  80346c:	83 ec 1c             	sub    $0x1c,%esp
  80346f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803473:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803477:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80347b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80347f:	89 ca                	mov    %ecx,%edx
  803481:	89 f8                	mov    %edi,%eax
  803483:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803487:	85 f6                	test   %esi,%esi
  803489:	75 2d                	jne    8034b8 <__udivdi3+0x50>
  80348b:	39 cf                	cmp    %ecx,%edi
  80348d:	77 65                	ja     8034f4 <__udivdi3+0x8c>
  80348f:	89 fd                	mov    %edi,%ebp
  803491:	85 ff                	test   %edi,%edi
  803493:	75 0b                	jne    8034a0 <__udivdi3+0x38>
  803495:	b8 01 00 00 00       	mov    $0x1,%eax
  80349a:	31 d2                	xor    %edx,%edx
  80349c:	f7 f7                	div    %edi
  80349e:	89 c5                	mov    %eax,%ebp
  8034a0:	31 d2                	xor    %edx,%edx
  8034a2:	89 c8                	mov    %ecx,%eax
  8034a4:	f7 f5                	div    %ebp
  8034a6:	89 c1                	mov    %eax,%ecx
  8034a8:	89 d8                	mov    %ebx,%eax
  8034aa:	f7 f5                	div    %ebp
  8034ac:	89 cf                	mov    %ecx,%edi
  8034ae:	89 fa                	mov    %edi,%edx
  8034b0:	83 c4 1c             	add    $0x1c,%esp
  8034b3:	5b                   	pop    %ebx
  8034b4:	5e                   	pop    %esi
  8034b5:	5f                   	pop    %edi
  8034b6:	5d                   	pop    %ebp
  8034b7:	c3                   	ret    
  8034b8:	39 ce                	cmp    %ecx,%esi
  8034ba:	77 28                	ja     8034e4 <__udivdi3+0x7c>
  8034bc:	0f bd fe             	bsr    %esi,%edi
  8034bf:	83 f7 1f             	xor    $0x1f,%edi
  8034c2:	75 40                	jne    803504 <__udivdi3+0x9c>
  8034c4:	39 ce                	cmp    %ecx,%esi
  8034c6:	72 0a                	jb     8034d2 <__udivdi3+0x6a>
  8034c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034cc:	0f 87 9e 00 00 00    	ja     803570 <__udivdi3+0x108>
  8034d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034d7:	89 fa                	mov    %edi,%edx
  8034d9:	83 c4 1c             	add    $0x1c,%esp
  8034dc:	5b                   	pop    %ebx
  8034dd:	5e                   	pop    %esi
  8034de:	5f                   	pop    %edi
  8034df:	5d                   	pop    %ebp
  8034e0:	c3                   	ret    
  8034e1:	8d 76 00             	lea    0x0(%esi),%esi
  8034e4:	31 ff                	xor    %edi,%edi
  8034e6:	31 c0                	xor    %eax,%eax
  8034e8:	89 fa                	mov    %edi,%edx
  8034ea:	83 c4 1c             	add    $0x1c,%esp
  8034ed:	5b                   	pop    %ebx
  8034ee:	5e                   	pop    %esi
  8034ef:	5f                   	pop    %edi
  8034f0:	5d                   	pop    %ebp
  8034f1:	c3                   	ret    
  8034f2:	66 90                	xchg   %ax,%ax
  8034f4:	89 d8                	mov    %ebx,%eax
  8034f6:	f7 f7                	div    %edi
  8034f8:	31 ff                	xor    %edi,%edi
  8034fa:	89 fa                	mov    %edi,%edx
  8034fc:	83 c4 1c             	add    $0x1c,%esp
  8034ff:	5b                   	pop    %ebx
  803500:	5e                   	pop    %esi
  803501:	5f                   	pop    %edi
  803502:	5d                   	pop    %ebp
  803503:	c3                   	ret    
  803504:	bd 20 00 00 00       	mov    $0x20,%ebp
  803509:	89 eb                	mov    %ebp,%ebx
  80350b:	29 fb                	sub    %edi,%ebx
  80350d:	89 f9                	mov    %edi,%ecx
  80350f:	d3 e6                	shl    %cl,%esi
  803511:	89 c5                	mov    %eax,%ebp
  803513:	88 d9                	mov    %bl,%cl
  803515:	d3 ed                	shr    %cl,%ebp
  803517:	89 e9                	mov    %ebp,%ecx
  803519:	09 f1                	or     %esi,%ecx
  80351b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80351f:	89 f9                	mov    %edi,%ecx
  803521:	d3 e0                	shl    %cl,%eax
  803523:	89 c5                	mov    %eax,%ebp
  803525:	89 d6                	mov    %edx,%esi
  803527:	88 d9                	mov    %bl,%cl
  803529:	d3 ee                	shr    %cl,%esi
  80352b:	89 f9                	mov    %edi,%ecx
  80352d:	d3 e2                	shl    %cl,%edx
  80352f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803533:	88 d9                	mov    %bl,%cl
  803535:	d3 e8                	shr    %cl,%eax
  803537:	09 c2                	or     %eax,%edx
  803539:	89 d0                	mov    %edx,%eax
  80353b:	89 f2                	mov    %esi,%edx
  80353d:	f7 74 24 0c          	divl   0xc(%esp)
  803541:	89 d6                	mov    %edx,%esi
  803543:	89 c3                	mov    %eax,%ebx
  803545:	f7 e5                	mul    %ebp
  803547:	39 d6                	cmp    %edx,%esi
  803549:	72 19                	jb     803564 <__udivdi3+0xfc>
  80354b:	74 0b                	je     803558 <__udivdi3+0xf0>
  80354d:	89 d8                	mov    %ebx,%eax
  80354f:	31 ff                	xor    %edi,%edi
  803551:	e9 58 ff ff ff       	jmp    8034ae <__udivdi3+0x46>
  803556:	66 90                	xchg   %ax,%ax
  803558:	8b 54 24 08          	mov    0x8(%esp),%edx
  80355c:	89 f9                	mov    %edi,%ecx
  80355e:	d3 e2                	shl    %cl,%edx
  803560:	39 c2                	cmp    %eax,%edx
  803562:	73 e9                	jae    80354d <__udivdi3+0xe5>
  803564:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803567:	31 ff                	xor    %edi,%edi
  803569:	e9 40 ff ff ff       	jmp    8034ae <__udivdi3+0x46>
  80356e:	66 90                	xchg   %ax,%ax
  803570:	31 c0                	xor    %eax,%eax
  803572:	e9 37 ff ff ff       	jmp    8034ae <__udivdi3+0x46>
  803577:	90                   	nop

00803578 <__umoddi3>:
  803578:	55                   	push   %ebp
  803579:	57                   	push   %edi
  80357a:	56                   	push   %esi
  80357b:	53                   	push   %ebx
  80357c:	83 ec 1c             	sub    $0x1c,%esp
  80357f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803583:	8b 74 24 34          	mov    0x34(%esp),%esi
  803587:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80358f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803593:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803597:	89 f3                	mov    %esi,%ebx
  803599:	89 fa                	mov    %edi,%edx
  80359b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80359f:	89 34 24             	mov    %esi,(%esp)
  8035a2:	85 c0                	test   %eax,%eax
  8035a4:	75 1a                	jne    8035c0 <__umoddi3+0x48>
  8035a6:	39 f7                	cmp    %esi,%edi
  8035a8:	0f 86 a2 00 00 00    	jbe    803650 <__umoddi3+0xd8>
  8035ae:	89 c8                	mov    %ecx,%eax
  8035b0:	89 f2                	mov    %esi,%edx
  8035b2:	f7 f7                	div    %edi
  8035b4:	89 d0                	mov    %edx,%eax
  8035b6:	31 d2                	xor    %edx,%edx
  8035b8:	83 c4 1c             	add    $0x1c,%esp
  8035bb:	5b                   	pop    %ebx
  8035bc:	5e                   	pop    %esi
  8035bd:	5f                   	pop    %edi
  8035be:	5d                   	pop    %ebp
  8035bf:	c3                   	ret    
  8035c0:	39 f0                	cmp    %esi,%eax
  8035c2:	0f 87 ac 00 00 00    	ja     803674 <__umoddi3+0xfc>
  8035c8:	0f bd e8             	bsr    %eax,%ebp
  8035cb:	83 f5 1f             	xor    $0x1f,%ebp
  8035ce:	0f 84 ac 00 00 00    	je     803680 <__umoddi3+0x108>
  8035d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035d9:	29 ef                	sub    %ebp,%edi
  8035db:	89 fe                	mov    %edi,%esi
  8035dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035e1:	89 e9                	mov    %ebp,%ecx
  8035e3:	d3 e0                	shl    %cl,%eax
  8035e5:	89 d7                	mov    %edx,%edi
  8035e7:	89 f1                	mov    %esi,%ecx
  8035e9:	d3 ef                	shr    %cl,%edi
  8035eb:	09 c7                	or     %eax,%edi
  8035ed:	89 e9                	mov    %ebp,%ecx
  8035ef:	d3 e2                	shl    %cl,%edx
  8035f1:	89 14 24             	mov    %edx,(%esp)
  8035f4:	89 d8                	mov    %ebx,%eax
  8035f6:	d3 e0                	shl    %cl,%eax
  8035f8:	89 c2                	mov    %eax,%edx
  8035fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035fe:	d3 e0                	shl    %cl,%eax
  803600:	89 44 24 04          	mov    %eax,0x4(%esp)
  803604:	8b 44 24 08          	mov    0x8(%esp),%eax
  803608:	89 f1                	mov    %esi,%ecx
  80360a:	d3 e8                	shr    %cl,%eax
  80360c:	09 d0                	or     %edx,%eax
  80360e:	d3 eb                	shr    %cl,%ebx
  803610:	89 da                	mov    %ebx,%edx
  803612:	f7 f7                	div    %edi
  803614:	89 d3                	mov    %edx,%ebx
  803616:	f7 24 24             	mull   (%esp)
  803619:	89 c6                	mov    %eax,%esi
  80361b:	89 d1                	mov    %edx,%ecx
  80361d:	39 d3                	cmp    %edx,%ebx
  80361f:	0f 82 87 00 00 00    	jb     8036ac <__umoddi3+0x134>
  803625:	0f 84 91 00 00 00    	je     8036bc <__umoddi3+0x144>
  80362b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80362f:	29 f2                	sub    %esi,%edx
  803631:	19 cb                	sbb    %ecx,%ebx
  803633:	89 d8                	mov    %ebx,%eax
  803635:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803639:	d3 e0                	shl    %cl,%eax
  80363b:	89 e9                	mov    %ebp,%ecx
  80363d:	d3 ea                	shr    %cl,%edx
  80363f:	09 d0                	or     %edx,%eax
  803641:	89 e9                	mov    %ebp,%ecx
  803643:	d3 eb                	shr    %cl,%ebx
  803645:	89 da                	mov    %ebx,%edx
  803647:	83 c4 1c             	add    $0x1c,%esp
  80364a:	5b                   	pop    %ebx
  80364b:	5e                   	pop    %esi
  80364c:	5f                   	pop    %edi
  80364d:	5d                   	pop    %ebp
  80364e:	c3                   	ret    
  80364f:	90                   	nop
  803650:	89 fd                	mov    %edi,%ebp
  803652:	85 ff                	test   %edi,%edi
  803654:	75 0b                	jne    803661 <__umoddi3+0xe9>
  803656:	b8 01 00 00 00       	mov    $0x1,%eax
  80365b:	31 d2                	xor    %edx,%edx
  80365d:	f7 f7                	div    %edi
  80365f:	89 c5                	mov    %eax,%ebp
  803661:	89 f0                	mov    %esi,%eax
  803663:	31 d2                	xor    %edx,%edx
  803665:	f7 f5                	div    %ebp
  803667:	89 c8                	mov    %ecx,%eax
  803669:	f7 f5                	div    %ebp
  80366b:	89 d0                	mov    %edx,%eax
  80366d:	e9 44 ff ff ff       	jmp    8035b6 <__umoddi3+0x3e>
  803672:	66 90                	xchg   %ax,%ax
  803674:	89 c8                	mov    %ecx,%eax
  803676:	89 f2                	mov    %esi,%edx
  803678:	83 c4 1c             	add    $0x1c,%esp
  80367b:	5b                   	pop    %ebx
  80367c:	5e                   	pop    %esi
  80367d:	5f                   	pop    %edi
  80367e:	5d                   	pop    %ebp
  80367f:	c3                   	ret    
  803680:	3b 04 24             	cmp    (%esp),%eax
  803683:	72 06                	jb     80368b <__umoddi3+0x113>
  803685:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803689:	77 0f                	ja     80369a <__umoddi3+0x122>
  80368b:	89 f2                	mov    %esi,%edx
  80368d:	29 f9                	sub    %edi,%ecx
  80368f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803693:	89 14 24             	mov    %edx,(%esp)
  803696:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80369e:	8b 14 24             	mov    (%esp),%edx
  8036a1:	83 c4 1c             	add    $0x1c,%esp
  8036a4:	5b                   	pop    %ebx
  8036a5:	5e                   	pop    %esi
  8036a6:	5f                   	pop    %edi
  8036a7:	5d                   	pop    %ebp
  8036a8:	c3                   	ret    
  8036a9:	8d 76 00             	lea    0x0(%esi),%esi
  8036ac:	2b 04 24             	sub    (%esp),%eax
  8036af:	19 fa                	sbb    %edi,%edx
  8036b1:	89 d1                	mov    %edx,%ecx
  8036b3:	89 c6                	mov    %eax,%esi
  8036b5:	e9 71 ff ff ff       	jmp    80362b <__umoddi3+0xb3>
  8036ba:	66 90                	xchg   %ax,%ax
  8036bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036c0:	72 ea                	jb     8036ac <__umoddi3+0x134>
  8036c2:	89 d9                	mov    %ebx,%ecx
  8036c4:	e9 62 ff ff ff       	jmp    80362b <__umoddi3+0xb3>
