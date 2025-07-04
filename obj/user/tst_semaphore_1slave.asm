
obj/user/tst_semaphore_1slave:     file format elf32-i386


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
  800031:	e8 fa 00 00 00       	call   800130 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: enter critical section, print it's ID, exit and signal the master program
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 8b 15 00 00       	call   8015ce <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int id = sys_getenvindex();
  800046:	e8 6a 15 00 00       	call   8015b5 <sys_getenvindex>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	struct semaphore cs1 = get_semaphore(parentenvID, "cs1");
  80004e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 80 37 80 00       	push   $0x803780
  800059:	ff 75 f4             	pushl  -0xc(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 8a 19 00 00       	call   8019ec <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = get_semaphore(parentenvID, "depend1");
  800065:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 84 37 80 00       	push   $0x803784
  800070:	ff 75 f4             	pushl  -0xc(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 73 19 00 00       	call   8019ec <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	cprintf("%d: before the critical section\n", id);
  80007c:	83 ec 08             	sub    $0x8,%esp
  80007f:	ff 75 f0             	pushl  -0x10(%ebp)
  800082:	68 8c 37 80 00       	push   $0x80378c
  800087:	e8 a6 04 00 00       	call   800532 <cprintf>
  80008c:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(cs1);
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	ff 75 e8             	pushl  -0x18(%ebp)
  800095:	e8 9b 19 00 00       	call   801a35 <wait_semaphore>
  80009a:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("%d: inside the critical section\n", id) ;
  80009d:	83 ec 08             	sub    $0x8,%esp
  8000a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000a3:	68 b0 37 80 00       	push   $0x8037b0
  8000a8:	e8 85 04 00 00       	call   800532 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp
		cprintf("my ID is %d\n", id);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b6:	68 d1 37 80 00       	push   $0x8037d1
  8000bb:	e8 72 04 00 00       	call   800532 <cprintf>
  8000c0:	83 c4 10             	add    $0x10,%esp
		int sem1val = semaphore_count(cs1);
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000c9:	e8 33 1a 00 00       	call   801b01 <semaphore_count>
  8000ce:	83 c4 10             	add    $0x10,%esp
  8000d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (sem1val > 0)
  8000d4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8000d8:	7e 14                	jle    8000ee <_main+0xb6>
			panic("Error: more than 1 process inside the CS... please review your semaphore code again...");
  8000da:	83 ec 04             	sub    $0x4,%esp
  8000dd:	68 e0 37 80 00       	push   $0x8037e0
  8000e2:	6a 15                	push   $0x15
  8000e4:	68 37 38 80 00       	push   $0x803837
  8000e9:	e8 87 01 00 00       	call   800275 <_panic>
		env_sleep(1000) ;
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	68 e8 03 00 00       	push   $0x3e8
  8000f6:	e8 11 1a 00 00       	call   801b0c <env_sleep>
  8000fb:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(cs1);
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	ff 75 e8             	pushl  -0x18(%ebp)
  800104:	e8 96 19 00 00       	call   801a9f <signal_semaphore>
  800109:	83 c4 10             	add    $0x10,%esp
	cprintf("%d: after the critical section\n", id);
  80010c:	83 ec 08             	sub    $0x8,%esp
  80010f:	ff 75 f0             	pushl  -0x10(%ebp)
  800112:	68 54 38 80 00       	push   $0x803854
  800117:	e8 16 04 00 00       	call   800532 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	signal_semaphore(depend1);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 75 19 00 00       	call   801a9f <signal_semaphore>
  80012a:	83 c4 10             	add    $0x10,%esp
	return;
  80012d:	90                   	nop
}
  80012e:	c9                   	leave  
  80012f:	c3                   	ret    

00800130 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800136:	e8 7a 14 00 00       	call   8015b5 <sys_getenvindex>
  80013b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80013e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800141:	89 d0                	mov    %edx,%eax
  800143:	c1 e0 02             	shl    $0x2,%eax
  800146:	01 d0                	add    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800154:	01 d0                	add    %edx,%eax
  800156:	c1 e0 02             	shl    $0x2,%eax
  800159:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80015e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800163:	a1 20 50 80 00       	mov    0x805020,%eax
  800168:	8a 40 20             	mov    0x20(%eax),%al
  80016b:	84 c0                	test   %al,%al
  80016d:	74 0d                	je     80017c <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80016f:	a1 20 50 80 00       	mov    0x805020,%eax
  800174:	83 c0 20             	add    $0x20,%eax
  800177:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80017c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800180:	7e 0a                	jle    80018c <libmain+0x5c>
		binaryname = argv[0];
  800182:	8b 45 0c             	mov    0xc(%ebp),%eax
  800185:	8b 00                	mov    (%eax),%eax
  800187:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80018c:	83 ec 08             	sub    $0x8,%esp
  80018f:	ff 75 0c             	pushl  0xc(%ebp)
  800192:	ff 75 08             	pushl  0x8(%ebp)
  800195:	e8 9e fe ff ff       	call   800038 <_main>
  80019a:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80019d:	a1 00 50 80 00       	mov    0x805000,%eax
  8001a2:	85 c0                	test   %eax,%eax
  8001a4:	0f 84 9f 00 00 00    	je     800249 <libmain+0x119>
	{
		sys_lock_cons();
  8001aa:	e8 8a 11 00 00       	call   801339 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001af:	83 ec 0c             	sub    $0xc,%esp
  8001b2:	68 8c 38 80 00       	push   $0x80388c
  8001b7:	e8 76 03 00 00       	call   800532 <cprintf>
  8001bc:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bf:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c4:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8001ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8001cf:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	52                   	push   %edx
  8001d9:	50                   	push   %eax
  8001da:	68 b4 38 80 00       	push   $0x8038b4
  8001df:	e8 4e 03 00 00       	call   800532 <cprintf>
  8001e4:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8001ec:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8001f7:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800202:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800208:	51                   	push   %ecx
  800209:	52                   	push   %edx
  80020a:	50                   	push   %eax
  80020b:	68 dc 38 80 00       	push   $0x8038dc
  800210:	e8 1d 03 00 00       	call   800532 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800218:	a1 20 50 80 00       	mov    0x805020,%eax
  80021d:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800223:	83 ec 08             	sub    $0x8,%esp
  800226:	50                   	push   %eax
  800227:	68 34 39 80 00       	push   $0x803934
  80022c:	e8 01 03 00 00       	call   800532 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 8c 38 80 00       	push   $0x80388c
  80023c:	e8 f1 02 00 00       	call   800532 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800244:	e8 0a 11 00 00       	call   801353 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800249:	e8 19 00 00 00       	call   800267 <exit>
}
  80024e:	90                   	nop
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	6a 00                	push   $0x0
  80025c:	e8 20 13 00 00       	call   801581 <sys_destroy_env>
  800261:	83 c4 10             	add    $0x10,%esp
}
  800264:	90                   	nop
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <exit>:

void
exit(void)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026d:	e8 75 13 00 00       	call   8015e7 <sys_exit_env>
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027b:	8d 45 10             	lea    0x10(%ebp),%eax
  80027e:	83 c0 04             	add    $0x4,%eax
  800281:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800284:	a1 60 50 98 00       	mov    0x985060,%eax
  800289:	85 c0                	test   %eax,%eax
  80028b:	74 16                	je     8002a3 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028d:	a1 60 50 98 00       	mov    0x985060,%eax
  800292:	83 ec 08             	sub    $0x8,%esp
  800295:	50                   	push   %eax
  800296:	68 48 39 80 00       	push   $0x803948
  80029b:	e8 92 02 00 00       	call   800532 <cprintf>
  8002a0:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a3:	a1 04 50 80 00       	mov    0x805004,%eax
  8002a8:	ff 75 0c             	pushl  0xc(%ebp)
  8002ab:	ff 75 08             	pushl  0x8(%ebp)
  8002ae:	50                   	push   %eax
  8002af:	68 4d 39 80 00       	push   $0x80394d
  8002b4:	e8 79 02 00 00       	call   800532 <cprintf>
  8002b9:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bf:	83 ec 08             	sub    $0x8,%esp
  8002c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c5:	50                   	push   %eax
  8002c6:	e8 fc 01 00 00       	call   8004c7 <vcprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ce:	83 ec 08             	sub    $0x8,%esp
  8002d1:	6a 00                	push   $0x0
  8002d3:	68 69 39 80 00       	push   $0x803969
  8002d8:	e8 ea 01 00 00       	call   8004c7 <vcprintf>
  8002dd:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e0:	e8 82 ff ff ff       	call   800267 <exit>

	// should not return here
	while (1) ;
  8002e5:	eb fe                	jmp    8002e5 <_panic+0x70>

008002e7 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8002f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	74 14                	je     800313 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 6c 39 80 00       	push   $0x80396c
  800307:	6a 26                	push   $0x26
  800309:	68 b8 39 80 00       	push   $0x8039b8
  80030e:	e8 62 ff ff ff       	call   800275 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800313:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80031a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800321:	e9 c5 00 00 00       	jmp    8003eb <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  800326:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800329:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800330:	8b 45 08             	mov    0x8(%ebp),%eax
  800333:	01 d0                	add    %edx,%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	85 c0                	test   %eax,%eax
  800339:	75 08                	jne    800343 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80033b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033e:	e9 a5 00 00 00       	jmp    8003e8 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  800343:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80034a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800351:	eb 69                	jmp    8003bc <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800353:	a1 20 50 80 00       	mov    0x805020,%eax
  800358:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80035e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800361:	89 d0                	mov    %edx,%eax
  800363:	01 c0                	add    %eax,%eax
  800365:	01 d0                	add    %edx,%eax
  800367:	c1 e0 03             	shl    $0x3,%eax
  80036a:	01 c8                	add    %ecx,%eax
  80036c:	8a 40 04             	mov    0x4(%eax),%al
  80036f:	84 c0                	test   %al,%al
  800371:	75 46                	jne    8003b9 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800373:	a1 20 50 80 00       	mov    0x805020,%eax
  800378:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80037e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800381:	89 d0                	mov    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	c1 e0 03             	shl    $0x3,%eax
  80038a:	01 c8                	add    %ecx,%eax
  80038c:	8b 00                	mov    (%eax),%eax
  80038e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800391:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800399:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ac:	39 c2                	cmp    %eax,%edx
  8003ae:	75 09                	jne    8003b9 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8003b0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b7:	eb 15                	jmp    8003ce <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b9:	ff 45 e8             	incl   -0x18(%ebp)
  8003bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8003c1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ca:	39 c2                	cmp    %eax,%edx
  8003cc:	77 85                	ja     800353 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d2:	75 14                	jne    8003e8 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8003d4:	83 ec 04             	sub    $0x4,%esp
  8003d7:	68 c4 39 80 00       	push   $0x8039c4
  8003dc:	6a 3a                	push   $0x3a
  8003de:	68 b8 39 80 00       	push   $0x8039b8
  8003e3:	e8 8d fe ff ff       	call   800275 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e8:	ff 45 f0             	incl   -0x10(%ebp)
  8003eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f1:	0f 8c 2f ff ff ff    	jl     800326 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800405:	eb 26                	jmp    80042d <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800407:	a1 20 50 80 00       	mov    0x805020,%eax
  80040c:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800412:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800415:	89 d0                	mov    %edx,%eax
  800417:	01 c0                	add    %eax,%eax
  800419:	01 d0                	add    %edx,%eax
  80041b:	c1 e0 03             	shl    $0x3,%eax
  80041e:	01 c8                	add    %ecx,%eax
  800420:	8a 40 04             	mov    0x4(%eax),%al
  800423:	3c 01                	cmp    $0x1,%al
  800425:	75 03                	jne    80042a <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  800427:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e0             	incl   -0x20(%ebp)
  80042d:	a1 20 50 80 00       	mov    0x805020,%eax
  800432:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043b:	39 c2                	cmp    %eax,%edx
  80043d:	77 c8                	ja     800407 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80043f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800442:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800445:	74 14                	je     80045b <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 18 3a 80 00       	push   $0x803a18
  80044f:	6a 44                	push   $0x44
  800451:	68 b8 39 80 00       	push   $0x8039b8
  800456:	e8 1a fe ff ff       	call   800275 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045b:	90                   	nop
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	8d 48 01             	lea    0x1(%eax),%ecx
  80046c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046f:	89 0a                	mov    %ecx,(%edx)
  800471:	8b 55 08             	mov    0x8(%ebp),%edx
  800474:	88 d1                	mov    %dl,%cl
  800476:	8b 55 0c             	mov    0xc(%ebp),%edx
  800479:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800480:	8b 00                	mov    (%eax),%eax
  800482:	3d ff 00 00 00       	cmp    $0xff,%eax
  800487:	75 2c                	jne    8004b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800489:	a0 44 50 98 00       	mov    0x985044,%al
  80048e:	0f b6 c0             	movzbl %al,%eax
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	8b 12                	mov    (%edx),%edx
  800496:	89 d1                	mov    %edx,%ecx
  800498:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049b:	83 c2 08             	add    $0x8,%edx
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	50                   	push   %eax
  8004a2:	51                   	push   %ecx
  8004a3:	52                   	push   %edx
  8004a4:	e8 4e 0e 00 00       	call   8012f7 <sys_cputs>
  8004a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 40 04             	mov    0x4(%eax),%eax
  8004bb:	8d 50 01             	lea    0x1(%eax),%edx
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c4:	90                   	nop
  8004c5:	c9                   	leave  
  8004c6:	c3                   	ret    

008004c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d7:	00 00 00 
	b.cnt = 0;
  8004da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e4:	ff 75 0c             	pushl  0xc(%ebp)
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f0:	50                   	push   %eax
  8004f1:	68 5e 04 80 00       	push   $0x80045e
  8004f6:	e8 11 02 00 00       	call   80070c <vprintfmt>
  8004fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004fe:	a0 44 50 98 00       	mov    0x985044,%al
  800503:	0f b6 c0             	movzbl %al,%eax
  800506:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050c:	83 ec 04             	sub    $0x4,%esp
  80050f:	50                   	push   %eax
  800510:	52                   	push   %edx
  800511:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800517:	83 c0 08             	add    $0x8,%eax
  80051a:	50                   	push   %eax
  80051b:	e8 d7 0d 00 00       	call   8012f7 <sys_cputs>
  800520:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800523:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  80052a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800538:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  80053f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800542:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	83 ec 08             	sub    $0x8,%esp
  80054b:	ff 75 f4             	pushl  -0xc(%ebp)
  80054e:	50                   	push   %eax
  80054f:	e8 73 ff ff ff       	call   8004c7 <vcprintf>
  800554:	83 c4 10             	add    $0x10,%esp
  800557:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    

0080055f <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800565:	e8 cf 0d 00 00       	call   801339 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80056a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800570:	8b 45 08             	mov    0x8(%ebp),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	ff 75 f4             	pushl  -0xc(%ebp)
  800579:	50                   	push   %eax
  80057a:	e8 48 ff ff ff       	call   8004c7 <vcprintf>
  80057f:	83 c4 10             	add    $0x10,%esp
  800582:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800585:	e8 c9 0d 00 00       	call   801353 <sys_unlock_cons>
	return cnt;
  80058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058d:	c9                   	leave  
  80058e:	c3                   	ret    

0080058f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	53                   	push   %ebx
  800593:	83 ec 14             	sub    $0x14,%esp
  800596:	8b 45 10             	mov    0x10(%ebp),%eax
  800599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ad:	77 55                	ja     800604 <printnum+0x75>
  8005af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b2:	72 05                	jb     8005b9 <printnum+0x2a>
  8005b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b7:	77 4b                	ja     800604 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c7:	52                   	push   %edx
  8005c8:	50                   	push   %eax
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8005cf:	e8 48 2f 00 00       	call   80351c <__udivdi3>
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	83 ec 04             	sub    $0x4,%esp
  8005da:	ff 75 20             	pushl  0x20(%ebp)
  8005dd:	53                   	push   %ebx
  8005de:	ff 75 18             	pushl  0x18(%ebp)
  8005e1:	52                   	push   %edx
  8005e2:	50                   	push   %eax
  8005e3:	ff 75 0c             	pushl  0xc(%ebp)
  8005e6:	ff 75 08             	pushl  0x8(%ebp)
  8005e9:	e8 a1 ff ff ff       	call   80058f <printnum>
  8005ee:	83 c4 20             	add    $0x20,%esp
  8005f1:	eb 1a                	jmp    80060d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 20             	pushl  0x20(%ebp)
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	ff d0                	call   *%eax
  800601:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800604:	ff 4d 1c             	decl   0x1c(%ebp)
  800607:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060b:	7f e6                	jg     8005f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800610:	bb 00 00 00 00       	mov    $0x0,%ebx
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061b:	53                   	push   %ebx
  80061c:	51                   	push   %ecx
  80061d:	52                   	push   %edx
  80061e:	50                   	push   %eax
  80061f:	e8 08 30 00 00       	call   80362c <__umoddi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	05 94 3c 80 00       	add    $0x803c94,%eax
  80062c:	8a 00                	mov    (%eax),%al
  80062e:	0f be c0             	movsbl %al,%eax
  800631:	83 ec 08             	sub    $0x8,%esp
  800634:	ff 75 0c             	pushl  0xc(%ebp)
  800637:	50                   	push   %eax
  800638:	8b 45 08             	mov    0x8(%ebp),%eax
  80063b:	ff d0                	call   *%eax
  80063d:	83 c4 10             	add    $0x10,%esp
}
  800640:	90                   	nop
  800641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800649:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064d:	7e 1c                	jle    80066b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	8d 50 08             	lea    0x8(%eax),%edx
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	89 10                	mov    %edx,(%eax)
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	8b 00                	mov    (%eax),%eax
  800661:	83 e8 08             	sub    $0x8,%eax
  800664:	8b 50 04             	mov    0x4(%eax),%edx
  800667:	8b 00                	mov    (%eax),%eax
  800669:	eb 40                	jmp    8006ab <getuint+0x65>
	else if (lflag)
  80066b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80066f:	74 1e                	je     80068f <getuint+0x49>
		return va_arg(*ap, unsigned long);
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
  80068d:	eb 1c                	jmp    8006ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	8d 50 04             	lea    0x4(%eax),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	89 10                	mov    %edx,(%eax)
  80069c:	8b 45 08             	mov    0x8(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	83 e8 04             	sub    $0x4,%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ab:	5d                   	pop    %ebp
  8006ac:	c3                   	ret    

008006ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b4:	7e 1c                	jle    8006d2 <getint+0x25>
		return va_arg(*ap, long long);
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	8d 50 08             	lea    0x8(%eax),%edx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	89 10                	mov    %edx,(%eax)
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	83 e8 08             	sub    $0x8,%eax
  8006cb:	8b 50 04             	mov    0x4(%eax),%edx
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	eb 38                	jmp    80070a <getint+0x5d>
	else if (lflag)
  8006d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d6:	74 1a                	je     8006f2 <getint+0x45>
		return va_arg(*ap, long);
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 50 04             	lea    0x4(%eax),%edx
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	89 10                	mov    %edx,(%eax)
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	83 e8 04             	sub    $0x4,%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	99                   	cltd   
  8006f0:	eb 18                	jmp    80070a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	8d 50 04             	lea    0x4(%eax),%edx
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	89 10                	mov    %edx,(%eax)
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8b 00                	mov    (%eax),%eax
  800704:	83 e8 04             	sub    $0x4,%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	99                   	cltd   
}
  80070a:	5d                   	pop    %ebp
  80070b:	c3                   	ret    

0080070c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070c:	55                   	push   %ebp
  80070d:	89 e5                	mov    %esp,%ebp
  80070f:	56                   	push   %esi
  800710:	53                   	push   %ebx
  800711:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800714:	eb 17                	jmp    80072d <vprintfmt+0x21>
			if (ch == '\0')
  800716:	85 db                	test   %ebx,%ebx
  800718:	0f 84 c1 03 00 00    	je     800adf <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	53                   	push   %ebx
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	ff d0                	call   *%eax
  80072a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072d:	8b 45 10             	mov    0x10(%ebp),%eax
  800730:	8d 50 01             	lea    0x1(%eax),%edx
  800733:	89 55 10             	mov    %edx,0x10(%ebp)
  800736:	8a 00                	mov    (%eax),%al
  800738:	0f b6 d8             	movzbl %al,%ebx
  80073b:	83 fb 25             	cmp    $0x25,%ebx
  80073e:	75 d6                	jne    800716 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800740:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800744:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800752:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800759:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800760:	8b 45 10             	mov    0x10(%ebp),%eax
  800763:	8d 50 01             	lea    0x1(%eax),%edx
  800766:	89 55 10             	mov    %edx,0x10(%ebp)
  800769:	8a 00                	mov    (%eax),%al
  80076b:	0f b6 d8             	movzbl %al,%ebx
  80076e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800771:	83 f8 5b             	cmp    $0x5b,%eax
  800774:	0f 87 3d 03 00 00    	ja     800ab7 <vprintfmt+0x3ab>
  80077a:	8b 04 85 b8 3c 80 00 	mov    0x803cb8(,%eax,4),%eax
  800781:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800783:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800787:	eb d7                	jmp    800760 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800789:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078d:	eb d1                	jmp    800760 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80078f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800796:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800799:	89 d0                	mov    %edx,%eax
  80079b:	c1 e0 02             	shl    $0x2,%eax
  80079e:	01 d0                	add    %edx,%eax
  8007a0:	01 c0                	add    %eax,%eax
  8007a2:	01 d8                	add    %ebx,%eax
  8007a4:	83 e8 30             	sub    $0x30,%eax
  8007a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ad:	8a 00                	mov    (%eax),%al
  8007af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b5:	7e 3e                	jle    8007f5 <vprintfmt+0xe9>
  8007b7:	83 fb 39             	cmp    $0x39,%ebx
  8007ba:	7f 39                	jg     8007f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007bf:	eb d5                	jmp    800796 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c4:	83 c0 04             	add    $0x4,%eax
  8007c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	83 e8 04             	sub    $0x4,%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d5:	eb 1f                	jmp    8007f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007db:	79 83                	jns    800760 <vprintfmt+0x54>
				width = 0;
  8007dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e4:	e9 77 ff ff ff       	jmp    800760 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f0:	e9 6b ff ff ff       	jmp    800760 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fa:	0f 89 60 ff ff ff    	jns    800760 <vprintfmt+0x54>
				width = precision, precision = -1;
  800800:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800803:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800806:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080d:	e9 4e ff ff ff       	jmp    800760 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800812:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800815:	e9 46 ff ff ff       	jmp    800760 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 c0 04             	add    $0x4,%eax
  800820:	89 45 14             	mov    %eax,0x14(%ebp)
  800823:	8b 45 14             	mov    0x14(%ebp),%eax
  800826:	83 e8 04             	sub    $0x4,%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	50                   	push   %eax
  800832:	8b 45 08             	mov    0x8(%ebp),%eax
  800835:	ff d0                	call   *%eax
  800837:	83 c4 10             	add    $0x10,%esp
			break;
  80083a:	e9 9b 02 00 00       	jmp    800ada <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 14             	mov    %eax,0x14(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	83 e8 04             	sub    $0x4,%eax
  80084e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800850:	85 db                	test   %ebx,%ebx
  800852:	79 02                	jns    800856 <vprintfmt+0x14a>
				err = -err;
  800854:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800856:	83 fb 64             	cmp    $0x64,%ebx
  800859:	7f 0b                	jg     800866 <vprintfmt+0x15a>
  80085b:	8b 34 9d 00 3b 80 00 	mov    0x803b00(,%ebx,4),%esi
  800862:	85 f6                	test   %esi,%esi
  800864:	75 19                	jne    80087f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800866:	53                   	push   %ebx
  800867:	68 a5 3c 80 00       	push   $0x803ca5
  80086c:	ff 75 0c             	pushl  0xc(%ebp)
  80086f:	ff 75 08             	pushl  0x8(%ebp)
  800872:	e8 70 02 00 00       	call   800ae7 <printfmt>
  800877:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087a:	e9 5b 02 00 00       	jmp    800ada <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80087f:	56                   	push   %esi
  800880:	68 ae 3c 80 00       	push   $0x803cae
  800885:	ff 75 0c             	pushl  0xc(%ebp)
  800888:	ff 75 08             	pushl  0x8(%ebp)
  80088b:	e8 57 02 00 00       	call   800ae7 <printfmt>
  800890:	83 c4 10             	add    $0x10,%esp
			break;
  800893:	e9 42 02 00 00       	jmp    800ada <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 c0 04             	add    $0x4,%eax
  80089e:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	83 e8 04             	sub    $0x4,%eax
  8008a7:	8b 30                	mov    (%eax),%esi
  8008a9:	85 f6                	test   %esi,%esi
  8008ab:	75 05                	jne    8008b2 <vprintfmt+0x1a6>
				p = "(null)";
  8008ad:	be b1 3c 80 00       	mov    $0x803cb1,%esi
			if (width > 0 && padc != '-')
  8008b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b6:	7e 6d                	jle    800925 <vprintfmt+0x219>
  8008b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bc:	74 67                	je     800925 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c1:	83 ec 08             	sub    $0x8,%esp
  8008c4:	50                   	push   %eax
  8008c5:	56                   	push   %esi
  8008c6:	e8 1e 03 00 00       	call   800be9 <strnlen>
  8008cb:	83 c4 10             	add    $0x10,%esp
  8008ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d1:	eb 16                	jmp    8008e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d7:	83 ec 08             	sub    $0x8,%esp
  8008da:	ff 75 0c             	pushl  0xc(%ebp)
  8008dd:	50                   	push   %eax
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	ff d0                	call   *%eax
  8008e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	7f e4                	jg     8008d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ef:	eb 34                	jmp    800925 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f5:	74 1c                	je     800913 <vprintfmt+0x207>
  8008f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fa:	7e 05                	jle    800901 <vprintfmt+0x1f5>
  8008fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8008ff:	7e 12                	jle    800913 <vprintfmt+0x207>
					putch('?', putdat);
  800901:	83 ec 08             	sub    $0x8,%esp
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	6a 3f                	push   $0x3f
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	ff d0                	call   *%eax
  80090e:	83 c4 10             	add    $0x10,%esp
  800911:	eb 0f                	jmp    800922 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	53                   	push   %ebx
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	ff d0                	call   *%eax
  80091f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800922:	ff 4d e4             	decl   -0x1c(%ebp)
  800925:	89 f0                	mov    %esi,%eax
  800927:	8d 70 01             	lea    0x1(%eax),%esi
  80092a:	8a 00                	mov    (%eax),%al
  80092c:	0f be d8             	movsbl %al,%ebx
  80092f:	85 db                	test   %ebx,%ebx
  800931:	74 24                	je     800957 <vprintfmt+0x24b>
  800933:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800937:	78 b8                	js     8008f1 <vprintfmt+0x1e5>
  800939:	ff 4d e0             	decl   -0x20(%ebp)
  80093c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800940:	79 af                	jns    8008f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800942:	eb 13                	jmp    800957 <vprintfmt+0x24b>
				putch(' ', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 20                	push   $0x20
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	ff 4d e4             	decl   -0x1c(%ebp)
  800957:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095b:	7f e7                	jg     800944 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095d:	e9 78 01 00 00       	jmp    800ada <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 e8             	pushl  -0x18(%ebp)
  800968:	8d 45 14             	lea    0x14(%ebp),%eax
  80096b:	50                   	push   %eax
  80096c:	e8 3c fd ff ff       	call   8006ad <getint>
  800971:	83 c4 10             	add    $0x10,%esp
  800974:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800977:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800980:	85 d2                	test   %edx,%edx
  800982:	79 23                	jns    8009a7 <vprintfmt+0x29b>
				putch('-', putdat);
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	ff 75 0c             	pushl  0xc(%ebp)
  80098a:	6a 2d                	push   $0x2d
  80098c:	8b 45 08             	mov    0x8(%ebp),%eax
  80098f:	ff d0                	call   *%eax
  800991:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800997:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099a:	f7 d8                	neg    %eax
  80099c:	83 d2 00             	adc    $0x0,%edx
  80099f:	f7 da                	neg    %edx
  8009a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ae:	e9 bc 00 00 00       	jmp    800a6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b3:	83 ec 08             	sub    $0x8,%esp
  8009b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bc:	50                   	push   %eax
  8009bd:	e8 84 fc ff ff       	call   800646 <getuint>
  8009c2:	83 c4 10             	add    $0x10,%esp
  8009c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d2:	e9 98 00 00 00       	jmp    800a6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 58                	push   $0x58
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	6a 58                	push   $0x58
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	ff d0                	call   *%eax
  8009f4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f7:	83 ec 08             	sub    $0x8,%esp
  8009fa:	ff 75 0c             	pushl  0xc(%ebp)
  8009fd:	6a 58                	push   $0x58
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	ff d0                	call   *%eax
  800a04:	83 c4 10             	add    $0x10,%esp
			break;
  800a07:	e9 ce 00 00 00       	jmp    800ada <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0c:	83 ec 08             	sub    $0x8,%esp
  800a0f:	ff 75 0c             	pushl  0xc(%ebp)
  800a12:	6a 30                	push   $0x30
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	ff d0                	call   *%eax
  800a19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 78                	push   $0x78
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2f:	83 c0 04             	add    $0x4,%eax
  800a32:	89 45 14             	mov    %eax,0x14(%ebp)
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 e8 04             	sub    $0x4,%eax
  800a3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4e:	eb 1f                	jmp    800a6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 e8             	pushl  -0x18(%ebp)
  800a56:	8d 45 14             	lea    0x14(%ebp),%eax
  800a59:	50                   	push   %eax
  800a5a:	e8 e7 fb ff ff       	call   800646 <getuint>
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a76:	83 ec 04             	sub    $0x4,%esp
  800a79:	52                   	push   %edx
  800a7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7d:	50                   	push   %eax
  800a7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a81:	ff 75 f0             	pushl  -0x10(%ebp)
  800a84:	ff 75 0c             	pushl  0xc(%ebp)
  800a87:	ff 75 08             	pushl  0x8(%ebp)
  800a8a:	e8 00 fb ff ff       	call   80058f <printnum>
  800a8f:	83 c4 20             	add    $0x20,%esp
			break;
  800a92:	eb 46                	jmp    800ada <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	53                   	push   %ebx
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
			break;
  800aa3:	eb 35                	jmp    800ada <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800aa5:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800aac:	eb 2c                	jmp    800ada <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800aae:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3c3>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 35 fc ff ff       	jmp    800714 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 04 fc ff ff       	call   80070c <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 80 fb ff ff       	call   80070c <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dc:	75 bb                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xc3>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 73 fa ff ff       	call   800bc6 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 65 fa ff ff       	call   800bc6 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 32 fb ff ff       	call   800d58 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 d4 fa ff ff       	call   800d58 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <str2lower>:


char* str2lower(char *dst, const char *src)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  8012b5:	83 ec 04             	sub    $0x4,%esp
  8012b8:	68 28 3e 80 00       	push   $0x803e28
  8012bd:	68 3f 01 00 00       	push   $0x13f
  8012c2:	68 4a 3e 80 00       	push   $0x803e4a
  8012c7:	e8 a9 ef ff ff       	call   800275 <_panic>

008012cc <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	57                   	push   %edi
  8012d0:	56                   	push   %esi
  8012d1:	53                   	push   %ebx
  8012d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012e7:	cd 30                	int    $0x30
  8012e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8012ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012ef:	83 c4 10             	add    $0x10,%esp
  8012f2:	5b                   	pop    %ebx
  8012f3:	5e                   	pop    %esi
  8012f4:	5f                   	pop    %edi
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    

008012f7 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8012f7:	55                   	push   %ebp
  8012f8:	89 e5                	mov    %esp,%ebp
  8012fa:	83 ec 04             	sub    $0x4,%esp
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801303:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	52                   	push   %edx
  80130f:	ff 75 0c             	pushl  0xc(%ebp)
  801312:	50                   	push   %eax
  801313:	6a 00                	push   $0x0
  801315:	e8 b2 ff ff ff       	call   8012cc <syscall>
  80131a:	83 c4 18             	add    $0x18,%esp
}
  80131d:	90                   	nop
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <sys_cgetc>:

int sys_cgetc(void) {
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 02                	push   $0x2
  80132f:	e8 98 ff ff ff       	call   8012cc <syscall>
  801334:	83 c4 18             	add    $0x18,%esp
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_lock_cons>:

void sys_lock_cons(void) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 03                	push   $0x3
  801348:	e8 7f ff ff ff       	call   8012cc <syscall>
  80134d:	83 c4 18             	add    $0x18,%esp
}
  801350:	90                   	nop
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801356:	6a 00                	push   $0x0
  801358:	6a 00                	push   $0x0
  80135a:	6a 00                	push   $0x0
  80135c:	6a 00                	push   $0x0
  80135e:	6a 00                	push   $0x0
  801360:	6a 04                	push   $0x4
  801362:	e8 65 ff ff ff       	call   8012cc <syscall>
  801367:	83 c4 18             	add    $0x18,%esp
}
  80136a:	90                   	nop
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	52                   	push   %edx
  80137d:	50                   	push   %eax
  80137e:	6a 08                	push   $0x8
  801380:	e8 47 ff ff ff       	call   8012cc <syscall>
  801385:	83 c4 18             	add    $0x18,%esp
}
  801388:	c9                   	leave  
  801389:	c3                   	ret    

0080138a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80138f:	8b 75 18             	mov    0x18(%ebp),%esi
  801392:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801395:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801398:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	56                   	push   %esi
  80139f:	53                   	push   %ebx
  8013a0:	51                   	push   %ecx
  8013a1:	52                   	push   %edx
  8013a2:	50                   	push   %eax
  8013a3:	6a 09                	push   $0x9
  8013a5:	e8 22 ff ff ff       	call   8012cc <syscall>
  8013aa:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8013ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5e                   	pop    %esi
  8013b2:	5d                   	pop    %ebp
  8013b3:	c3                   	ret    

008013b4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8013b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	52                   	push   %edx
  8013c4:	50                   	push   %eax
  8013c5:	6a 0a                	push   $0xa
  8013c7:	e8 00 ff ff ff       	call   8012cc <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	ff 75 08             	pushl  0x8(%ebp)
  8013e0:	6a 0b                	push   $0xb
  8013e2:	e8 e5 fe ff ff       	call   8012cc <syscall>
  8013e7:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8013ea:	c9                   	leave  
  8013eb:	c3                   	ret    

008013ec <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 00                	push   $0x0
  8013f9:	6a 0c                	push   $0xc
  8013fb:	e8 cc fe ff ff       	call   8012cc <syscall>
  801400:	83 c4 18             	add    $0x18,%esp
}
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 0d                	push   $0xd
  801414:	e8 b3 fe ff ff       	call   8012cc <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 0e                	push   $0xe
  80142d:	e8 9a fe ff ff       	call   8012cc <syscall>
  801432:	83 c4 18             	add    $0x18,%esp
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	6a 00                	push   $0x0
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 0f                	push   $0xf
  801446:	e8 81 fe ff ff       	call   8012cc <syscall>
  80144b:	83 c4 18             	add    $0x18,%esp
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801453:	6a 00                	push   $0x0
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	ff 75 08             	pushl  0x8(%ebp)
  80145e:	6a 10                	push   $0x10
  801460:	e8 67 fe ff ff       	call   8012cc <syscall>
  801465:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801468:	c9                   	leave  
  801469:	c3                   	ret    

0080146a <sys_scarce_memory>:

void sys_scarce_memory() {
  80146a:	55                   	push   %ebp
  80146b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 11                	push   $0x11
  801479:	e8 4e fe ff ff       	call   8012cc <syscall>
  80147e:	83 c4 18             	add    $0x18,%esp
}
  801481:	90                   	nop
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_cputc>:

void sys_cputc(const char c) {
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 04             	sub    $0x4,%esp
  80148a:	8b 45 08             	mov    0x8(%ebp),%eax
  80148d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801490:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	50                   	push   %eax
  80149d:	6a 01                	push   $0x1
  80149f:	e8 28 fe ff ff       	call   8012cc <syscall>
  8014a4:	83 c4 18             	add    $0x18,%esp
}
  8014a7:	90                   	nop
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 00                	push   $0x0
  8014b7:	6a 14                	push   $0x14
  8014b9:	e8 0e fe ff ff       	call   8012cc <syscall>
  8014be:	83 c4 18             	add    $0x18,%esp
}
  8014c1:	90                   	nop
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8014d0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014d3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	51                   	push   %ecx
  8014dd:	52                   	push   %edx
  8014de:	ff 75 0c             	pushl  0xc(%ebp)
  8014e1:	50                   	push   %eax
  8014e2:	6a 15                	push   $0x15
  8014e4:	e8 e3 fd ff ff       	call   8012cc <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8014f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	52                   	push   %edx
  8014fe:	50                   	push   %eax
  8014ff:	6a 16                	push   $0x16
  801501:	e8 c6 fd ff ff       	call   8012cc <syscall>
  801506:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80150e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801511:	8b 55 0c             	mov    0xc(%ebp),%edx
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	6a 00                	push   $0x0
  80151b:	51                   	push   %ecx
  80151c:	52                   	push   %edx
  80151d:	50                   	push   %eax
  80151e:	6a 17                	push   $0x17
  801520:	e8 a7 fd ff ff       	call   8012cc <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80152d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	52                   	push   %edx
  80153a:	50                   	push   %eax
  80153b:	6a 18                	push   $0x18
  80153d:	e8 8a fd ff ff       	call   8012cc <syscall>
  801542:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	6a 00                	push   $0x0
  80154f:	ff 75 14             	pushl  0x14(%ebp)
  801552:	ff 75 10             	pushl  0x10(%ebp)
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	50                   	push   %eax
  801559:	6a 19                	push   $0x19
  80155b:	e8 6c fd ff ff       	call   8012cc <syscall>
  801560:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_run_env>:

void sys_run_env(int32 envId) {
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	50                   	push   %eax
  801574:	6a 1a                	push   $0x1a
  801576:	e8 51 fd ff ff       	call   8012cc <syscall>
  80157b:	83 c4 18             	add    $0x18,%esp
}
  80157e:	90                   	nop
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	50                   	push   %eax
  801590:	6a 1b                	push   $0x1b
  801592:	e8 35 fd ff ff       	call   8012cc <syscall>
  801597:	83 c4 18             	add    $0x18,%esp
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <sys_getenvid>:

int32 sys_getenvid(void) {
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	6a 05                	push   $0x5
  8015ab:	e8 1c fd ff ff       	call   8012cc <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 00                	push   $0x0
  8015c2:	6a 06                	push   $0x6
  8015c4:	e8 03 fd ff ff       	call   8012cc <syscall>
  8015c9:	83 c4 18             	add    $0x18,%esp
}
  8015cc:	c9                   	leave  
  8015cd:	c3                   	ret    

008015ce <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 00                	push   $0x0
  8015d9:	6a 00                	push   $0x0
  8015db:	6a 07                	push   $0x7
  8015dd:	e8 ea fc ff ff       	call   8012cc <syscall>
  8015e2:	83 c4 18             	add    $0x18,%esp
}
  8015e5:	c9                   	leave  
  8015e6:	c3                   	ret    

008015e7 <sys_exit_env>:

void sys_exit_env(void) {
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015ea:	6a 00                	push   $0x0
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	6a 00                	push   $0x0
  8015f4:	6a 1c                	push   $0x1c
  8015f6:	e8 d1 fc ff ff       	call   8012cc <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
}
  8015fe:	90                   	nop
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801607:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80160a:	8d 50 04             	lea    0x4(%eax),%edx
  80160d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	52                   	push   %edx
  801617:	50                   	push   %eax
  801618:	6a 1d                	push   $0x1d
  80161a:	e8 ad fc ff ff       	call   8012cc <syscall>
  80161f:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801622:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801625:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801628:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162b:	89 01                	mov    %eax,(%ecx)
  80162d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	c9                   	leave  
  801634:	c2 04 00             	ret    $0x4

00801637 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	ff 75 10             	pushl  0x10(%ebp)
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	ff 75 08             	pushl  0x8(%ebp)
  801647:	6a 13                	push   $0x13
  801649:	e8 7e fc ff ff       	call   8012cc <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801651:	90                   	nop
}
  801652:	c9                   	leave  
  801653:	c3                   	ret    

00801654 <sys_rcr2>:
uint32 sys_rcr2() {
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 1e                	push   $0x1e
  801663:	e8 64 fc ff ff       	call   8012cc <syscall>
  801668:	83 c4 18             	add    $0x18,%esp
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 04             	sub    $0x4,%esp
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801679:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	50                   	push   %eax
  801686:	6a 1f                	push   $0x1f
  801688:	e8 3f fc ff ff       	call   8012cc <syscall>
  80168d:	83 c4 18             	add    $0x18,%esp
	return;
  801690:	90                   	nop
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <rsttst>:
void rsttst() {
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	6a 00                	push   $0x0
  80169e:	6a 00                	push   $0x0
  8016a0:	6a 21                	push   $0x21
  8016a2:	e8 25 fc ff ff       	call   8012cc <syscall>
  8016a7:	83 c4 18             	add    $0x18,%esp
	return;
  8016aa:	90                   	nop
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 04             	sub    $0x4,%esp
  8016b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8016b9:	8b 55 18             	mov    0x18(%ebp),%edx
  8016bc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016c0:	52                   	push   %edx
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 10             	pushl  0x10(%ebp)
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	ff 75 08             	pushl  0x8(%ebp)
  8016cb:	6a 20                	push   $0x20
  8016cd:	e8 fa fb ff ff       	call   8012cc <syscall>
  8016d2:	83 c4 18             	add    $0x18,%esp
	return;
  8016d5:	90                   	nop
}
  8016d6:	c9                   	leave  
  8016d7:	c3                   	ret    

008016d8 <chktst>:
void chktst(uint32 n) {
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	ff 75 08             	pushl  0x8(%ebp)
  8016e6:	6a 22                	push   $0x22
  8016e8:	e8 df fb ff ff       	call   8012cc <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
	return;
  8016f0:	90                   	nop
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <inctst>:

void inctst() {
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 23                	push   $0x23
  801702:	e8 c5 fb ff ff       	call   8012cc <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
	return;
  80170a:	90                   	nop
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <gettst>:
uint32 gettst() {
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	6a 00                	push   $0x0
  801718:	6a 00                	push   $0x0
  80171a:	6a 24                	push   $0x24
  80171c:	e8 ab fb ff ff       	call   8012cc <syscall>
  801721:	83 c4 18             	add    $0x18,%esp
}
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80172c:	6a 00                	push   $0x0
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 25                	push   $0x25
  801738:	e8 8f fb ff ff       	call   8012cc <syscall>
  80173d:	83 c4 18             	add    $0x18,%esp
  801740:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801743:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801747:	75 07                	jne    801750 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801749:	b8 01 00 00 00       	mov    $0x1,%eax
  80174e:	eb 05                	jmp    801755 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801750:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80175d:	6a 00                	push   $0x0
  80175f:	6a 00                	push   $0x0
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 25                	push   $0x25
  801769:	e8 5e fb ff ff       	call   8012cc <syscall>
  80176e:	83 c4 18             	add    $0x18,%esp
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801774:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801778:	75 07                	jne    801781 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80177a:	b8 01 00 00 00       	mov    $0x1,%eax
  80177f:	eb 05                	jmp    801786 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801781:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 25                	push   $0x25
  80179a:	e8 2d fb ff ff       	call   8012cc <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
  8017a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8017a5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8017a9:	75 07                	jne    8017b2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8017ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8017b0:	eb 05                	jmp    8017b7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8017b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 25                	push   $0x25
  8017cb:	e8 fc fa ff ff       	call   8012cc <syscall>
  8017d0:	83 c4 18             	add    $0x18,%esp
  8017d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017d6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017da:	75 07                	jne    8017e3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017dc:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e1:	eb 05                	jmp    8017e8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	ff 75 08             	pushl  0x8(%ebp)
  8017f8:	6a 26                	push   $0x26
  8017fa:	e8 cd fa ff ff       	call   8012cc <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
	return;
  801802:	90                   	nop
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801809:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80180c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	6a 00                	push   $0x0
  801817:	53                   	push   %ebx
  801818:	51                   	push   %ecx
  801819:	52                   	push   %edx
  80181a:	50                   	push   %eax
  80181b:	6a 27                	push   $0x27
  80181d:	e8 aa fa ff ff       	call   8012cc <syscall>
  801822:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 45 08             	mov    0x8(%ebp),%eax
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	52                   	push   %edx
  80183a:	50                   	push   %eax
  80183b:	6a 28                	push   $0x28
  80183d:	e8 8a fa ff ff       	call   8012cc <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  80184a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80184d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801850:	8b 45 08             	mov    0x8(%ebp),%eax
  801853:	6a 00                	push   $0x0
  801855:	51                   	push   %ecx
  801856:	ff 75 10             	pushl  0x10(%ebp)
  801859:	52                   	push   %edx
  80185a:	50                   	push   %eax
  80185b:	6a 29                	push   $0x29
  80185d:	e8 6a fa ff ff       	call   8012cc <syscall>
  801862:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	ff 75 10             	pushl  0x10(%ebp)
  801871:	ff 75 0c             	pushl  0xc(%ebp)
  801874:	ff 75 08             	pushl  0x8(%ebp)
  801877:	6a 12                	push   $0x12
  801879:	e8 4e fa ff ff       	call   8012cc <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
	return;
  801881:	90                   	nop
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	50                   	push   %eax
  801895:	6a 2a                	push   $0x2a
  801897:	e8 30 fa ff ff       	call   8012cc <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
	return;
  80189f:	90                   	nop
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	50                   	push   %eax
  8018b1:	6a 2b                	push   $0x2b
  8018b3:	e8 14 fa ff ff       	call   8012cc <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	ff 75 0c             	pushl  0xc(%ebp)
  8018c9:	ff 75 08             	pushl  0x8(%ebp)
  8018cc:	6a 2c                	push   $0x2c
  8018ce:	e8 f9 f9 ff ff       	call   8012cc <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
	return;
  8018d6:	90                   	nop
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	ff 75 08             	pushl  0x8(%ebp)
  8018e8:	6a 2d                	push   $0x2d
  8018ea:	e8 dd f9 ff ff       	call   8012cc <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
	return;
  8018f2:	90                   	nop
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	50                   	push   %eax
  801904:	6a 2f                	push   $0x2f
  801906:	e8 c1 f9 ff ff       	call   8012cc <syscall>
  80190b:	83 c4 18             	add    $0x18,%esp
	return;
  80190e:	90                   	nop
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801914:	8b 55 0c             	mov    0xc(%ebp),%edx
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	52                   	push   %edx
  801921:	50                   	push   %eax
  801922:	6a 30                	push   $0x30
  801924:	e8 a3 f9 ff ff       	call   8012cc <syscall>
  801929:	83 c4 18             	add    $0x18,%esp
	return;
  80192c:	90                   	nop
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	50                   	push   %eax
  80193e:	6a 31                	push   $0x31
  801940:	e8 87 f9 ff ff       	call   8012cc <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80194e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	52                   	push   %edx
  80195b:	50                   	push   %eax
  80195c:	6a 2e                	push   $0x2e
  80195e:	e8 69 f9 ff ff       	call   8012cc <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
    return;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  80196f:	83 ec 04             	sub    $0x4,%esp
  801972:	6a 01                	push   $0x1
  801974:	6a 58                	push   $0x58
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	e8 0f 05 00 00       	call   801e8d <smalloc>
  80197e:	83 c4 10             	add    $0x10,%esp
  801981:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801984:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801988:	75 14                	jne    80199e <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  80198a:	83 ec 04             	sub    $0x4,%esp
  80198d:	68 58 3e 80 00       	push   $0x803e58
  801992:	6a 10                	push   $0x10
  801994:	68 86 3e 80 00       	push   $0x803e86
  801999:	e8 d7 e8 ff ff       	call   800275 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  80199e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	50                   	push   %eax
  8019a5:	e8 4b ff ff ff       	call   8018f5 <sys_init_queue>
  8019aa:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  8019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b0:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  8019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ba:	83 c0 18             	add    $0x18,%eax
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	6a 40                	push   $0x40
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	e8 78 f2 ff ff       	call   800c43 <strncpy>
  8019cb:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  8019ce:	8b 55 10             	mov    0x10(%ebp),%edx
  8019d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d4:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019e3:	89 10                	mov    %edx,(%eax)
}
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	c9                   	leave  
  8019e9:	c2 04 00             	ret    $0x4

008019ec <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	ff 75 10             	pushl  0x10(%ebp)
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	e8 28 06 00 00       	call   802028 <sget>
  801a00:	83 c4 10             	add    $0x10,%esp
  801a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801a06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a0a:	75 14                	jne    801a20 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  801a0c:	83 ec 04             	sub    $0x4,%esp
  801a0f:	68 98 3e 80 00       	push   $0x803e98
  801a14:	6a 2c                	push   $0x2c
  801a16:	68 86 3e 80 00       	push   $0x803e86
  801a1b:	e8 55 e8 ff ff       	call   800275 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  801a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a2c:	89 10                	mov    %edx,(%eax)
}
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	c9                   	leave  
  801a32:	c2 04 00             	ret    $0x4

00801a35 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801a3b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8b 40 14             	mov    0x14(%eax),%eax
  801a48:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801a4b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a57:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801a5a:	f0 87 02             	lock xchg %eax,(%edx)
  801a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801a60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a63:	85 c0                	test   %eax,%eax
  801a65:	75 db                	jne    801a42 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	8b 50 10             	mov    0x10(%eax),%edx
  801a6d:	4a                   	dec    %edx
  801a6e:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	8b 40 10             	mov    0x10(%eax),%eax
  801a77:	85 c0                	test   %eax,%eax
  801a79:	79 18                	jns    801a93 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	8d 50 14             	lea    0x14(%eax),%edx
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	83 ec 08             	sub    $0x8,%esp
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	e8 83 fe ff ff       	call   801911 <sys_block_process>
  801a8e:	83 c4 10             	add    $0x10,%esp
  801a91:	eb 0a                	jmp    801a9d <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801aa5:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	8b 40 14             	mov    0x14(%eax),%eax
  801ab2:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801ab8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801abb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801ac4:	f0 87 02             	lock xchg %eax,(%edx)
  801ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801aca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801acd:	85 c0                	test   %eax,%eax
  801acf:	75 db                	jne    801aac <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	8b 50 10             	mov    0x10(%eax),%edx
  801ad7:	42                   	inc    %edx
  801ad8:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	8b 40 10             	mov    0x10(%eax),%eax
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	7f 0f                	jg     801af4 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	83 ec 0c             	sub    $0xc,%esp
  801aeb:	50                   	push   %eax
  801aec:	e8 3e fe ff ff       	call   80192f <sys_unblock_process>
  801af1:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	8b 40 10             	mov    0x10(%eax),%eax
}
  801b0a:	5d                   	pop    %ebp
  801b0b:	c3                   	ret    

00801b0c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801b12:	8b 55 08             	mov    0x8(%ebp),%edx
  801b15:	89 d0                	mov    %edx,%eax
  801b17:	c1 e0 02             	shl    $0x2,%eax
  801b1a:	01 d0                	add    %edx,%eax
  801b1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b23:	01 d0                	add    %edx,%eax
  801b25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b35:	01 d0                	add    %edx,%eax
  801b37:	c1 e0 04             	shl    $0x4,%eax
  801b3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801b3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801b44:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801b47:	83 ec 0c             	sub    $0xc,%esp
  801b4a:	50                   	push   %eax
  801b4b:	e8 b1 fa ff ff       	call   801601 <sys_get_virtual_time>
  801b50:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801b53:	eb 41                	jmp    801b96 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801b55:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b58:	83 ec 0c             	sub    $0xc,%esp
  801b5b:	50                   	push   %eax
  801b5c:	e8 a0 fa ff ff       	call   801601 <sys_get_virtual_time>
  801b61:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801b64:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b6a:	29 c2                	sub    %eax,%edx
  801b6c:	89 d0                	mov    %edx,%eax
  801b6e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801b71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b77:	89 d1                	mov    %edx,%ecx
  801b79:	29 c1                	sub    %eax,%ecx
  801b7b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b81:	39 c2                	cmp    %eax,%edx
  801b83:	0f 97 c0             	seta   %al
  801b86:	0f b6 c0             	movzbl %al,%eax
  801b89:	29 c1                	sub    %eax,%ecx
  801b8b:	89 c8                	mov    %ecx,%eax
  801b8d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b93:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b99:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9c:	72 b7                	jb     801b55 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b9e:	90                   	nop
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801ba7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801bae:	eb 03                	jmp    801bb3 <busy_wait+0x12>
  801bb0:	ff 45 fc             	incl   -0x4(%ebp)
  801bb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bb6:	3b 45 08             	cmp    0x8(%ebp),%eax
  801bb9:	72 f5                	jb     801bb0 <busy_wait+0xf>
	return i;
  801bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801bc6:	83 ec 0c             	sub    $0xc,%esp
  801bc9:	ff 75 08             	pushl  0x8(%ebp)
  801bcc:	e8 d1 fc ff ff       	call   8018a2 <sys_sbrk>
  801bd1:	83 c4 10             	add    $0x10,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
  801bd9:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be0:	75 0a                	jne    801bec <malloc+0x16>
		return NULL;
  801be2:	b8 00 00 00 00       	mov    $0x0,%eax
  801be7:	e9 9e 01 00 00       	jmp    801d8a <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801bec:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bf3:	77 2c                	ja     801c21 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801bf5:	e8 2c fb ff ff       	call   801726 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	74 19                	je     801c17 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801bfe:	83 ec 0c             	sub    $0xc,%esp
  801c01:	ff 75 08             	pushl  0x8(%ebp)
  801c04:	e8 e8 0a 00 00       	call   8026f1 <alloc_block_FF>
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c12:	e9 73 01 00 00       	jmp    801d8a <malloc+0x1b4>
		} else {
			return NULL;
  801c17:	b8 00 00 00 00       	mov    $0x0,%eax
  801c1c:	e9 69 01 00 00       	jmp    801d8a <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801c21:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801c28:	8b 55 08             	mov    0x8(%ebp),%edx
  801c2b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2e:	01 d0                	add    %edx,%eax
  801c30:	48                   	dec    %eax
  801c31:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c34:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c37:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3c:	f7 75 e0             	divl   -0x20(%ebp)
  801c3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c42:	29 d0                	sub    %edx,%eax
  801c44:	c1 e8 0c             	shr    $0xc,%eax
  801c47:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801c51:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801c58:	a1 20 50 80 00       	mov    0x805020,%eax
  801c5d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801c60:	05 00 10 00 00       	add    $0x1000,%eax
  801c65:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801c68:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801c6d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c70:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801c73:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  801c7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c80:	01 d0                	add    %edx,%eax
  801c82:	48                   	dec    %eax
  801c83:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c86:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c89:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8e:	f7 75 cc             	divl   -0x34(%ebp)
  801c91:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c94:	29 d0                	sub    %edx,%eax
  801c96:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c99:	76 0a                	jbe    801ca5 <malloc+0xcf>
		return NULL;
  801c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca0:	e9 e5 00 00 00       	jmp    801d8a <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801ca5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ca8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801cab:	eb 48                	jmp    801cf5 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb0:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801cb3:	c1 e8 0c             	shr    $0xc,%eax
  801cb6:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801cb9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801cbc:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801cc3:	85 c0                	test   %eax,%eax
  801cc5:	75 11                	jne    801cd8 <malloc+0x102>
			freePagesCount++;
  801cc7:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801cca:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cce:	75 16                	jne    801ce6 <malloc+0x110>
				start = i;
  801cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cd6:	eb 0e                	jmp    801ce6 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801cd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801cdf:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801cec:	74 12                	je     801d00 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801cee:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801cf5:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801cfc:	76 af                	jbe    801cad <malloc+0xd7>
  801cfe:	eb 01                	jmp    801d01 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801d00:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801d01:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801d05:	74 08                	je     801d0f <malloc+0x139>
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801d0d:	74 07                	je     801d16 <malloc+0x140>
		return NULL;
  801d0f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d14:	eb 74                	jmp    801d8a <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d19:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d1c:	c1 e8 0c             	shr    $0xc,%eax
  801d1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801d22:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d25:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d28:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801d2f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d32:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d35:	eb 11                	jmp    801d48 <malloc+0x172>
		markedPages[i] = 1;
  801d37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d3a:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801d41:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801d45:	ff 45 e8             	incl   -0x18(%ebp)
  801d48:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801d4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d4e:	01 d0                	add    %edx,%eax
  801d50:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d53:	77 e2                	ja     801d37 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801d55:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d62:	01 d0                	add    %edx,%eax
  801d64:	48                   	dec    %eax
  801d65:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d70:	f7 75 bc             	divl   -0x44(%ebp)
  801d73:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d76:	29 d0                	sub    %edx,%eax
  801d78:	83 ec 08             	sub    $0x8,%esp
  801d7b:	50                   	push   %eax
  801d7c:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7f:	e8 55 fb ff ff       	call   8018d9 <sys_allocate_user_mem>
  801d84:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801d87:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801d8a:	c9                   	leave  
  801d8b:	c3                   	ret    

00801d8c <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801d8c:	55                   	push   %ebp
  801d8d:	89 e5                	mov    %esp,%ebp
  801d8f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801d92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d96:	0f 84 ee 00 00 00    	je     801e8a <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801d9c:	a1 20 50 80 00       	mov    0x805020,%eax
  801da1:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801da4:	3b 45 08             	cmp    0x8(%ebp),%eax
  801da7:	77 09                	ja     801db2 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801da9:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801db0:	76 14                	jbe    801dc6 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	68 bc 3e 80 00       	push   $0x803ebc
  801dba:	6a 68                	push   $0x68
  801dbc:	68 d6 3e 80 00       	push   $0x803ed6
  801dc1:	e8 af e4 ff ff       	call   800275 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801dc6:	a1 20 50 80 00       	mov    0x805020,%eax
  801dcb:	8b 40 74             	mov    0x74(%eax),%eax
  801dce:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dd1:	77 20                	ja     801df3 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801dd3:	a1 20 50 80 00       	mov    0x805020,%eax
  801dd8:	8b 40 78             	mov    0x78(%eax),%eax
  801ddb:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dde:	76 13                	jbe    801df3 <free+0x67>
		free_block(virtual_address);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff 75 08             	pushl  0x8(%ebp)
  801de6:	e8 cf 0f 00 00       	call   802dba <free_block>
  801deb:	83 c4 10             	add    $0x10,%esp
		return;
  801dee:	e9 98 00 00 00       	jmp    801e8b <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801df3:	8b 55 08             	mov    0x8(%ebp),%edx
  801df6:	a1 20 50 80 00       	mov    0x805020,%eax
  801dfb:	8b 40 7c             	mov    0x7c(%eax),%eax
  801dfe:	29 c2                	sub    %eax,%edx
  801e00:	89 d0                	mov    %edx,%eax
  801e02:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801e07:	c1 e8 0c             	shr    $0xc,%eax
  801e0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801e0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801e14:	eb 16                	jmp    801e2c <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801e16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1c:	01 d0                	add    %edx,%eax
  801e1e:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801e25:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801e29:	ff 45 f4             	incl   -0xc(%ebp)
  801e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2f:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801e36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e39:	7f db                	jg     801e16 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801e3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e3e:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801e45:	c1 e0 0c             	shl    $0xc,%eax
  801e48:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e51:	eb 1a                	jmp    801e6d <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801e53:	83 ec 08             	sub    $0x8,%esp
  801e56:	68 00 10 00 00       	push   $0x1000
  801e5b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5e:	e8 5a fa ff ff       	call   8018bd <sys_free_user_mem>
  801e63:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801e66:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801e6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801e70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e73:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801e75:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e78:	77 d9                	ja     801e53 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7d:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801e84:	00 00 00 00 
  801e88:	eb 01                	jmp    801e8b <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801e8a:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 58             	sub    $0x58,%esp
  801e93:	8b 45 10             	mov    0x10(%ebp),%eax
  801e96:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801e99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e9d:	75 0a                	jne    801ea9 <smalloc+0x1c>
		return NULL;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	e9 7d 01 00 00       	jmp    802026 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801ea9:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eb6:	01 d0                	add    %edx,%eax
  801eb8:	48                   	dec    %eax
  801eb9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ebf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec4:	f7 75 e4             	divl   -0x1c(%ebp)
  801ec7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eca:	29 d0                	sub    %edx,%eax
  801ecc:	c1 e8 0c             	shr    $0xc,%eax
  801ecf:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801ed2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801ed9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801ee0:	a1 20 50 80 00       	mov    0x805020,%eax
  801ee5:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ee8:	05 00 10 00 00       	add    $0x1000,%eax
  801eed:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801ef0:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ef5:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ef8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801efb:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801f02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f05:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	48                   	dec    %eax
  801f0b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f0e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f11:	ba 00 00 00 00       	mov    $0x0,%edx
  801f16:	f7 75 d0             	divl   -0x30(%ebp)
  801f19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f1c:	29 d0                	sub    %edx,%eax
  801f1e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f21:	76 0a                	jbe    801f2d <smalloc+0xa0>
		return NULL;
  801f23:	b8 00 00 00 00       	mov    $0x0,%eax
  801f28:	e9 f9 00 00 00       	jmp    802026 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f33:	eb 48                	jmp    801f7d <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801f35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f38:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801f3b:	c1 e8 0c             	shr    $0xc,%eax
  801f3e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801f41:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f44:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	75 11                	jne    801f60 <smalloc+0xd3>
			freePagesCount++;
  801f4f:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801f52:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f56:	75 16                	jne    801f6e <smalloc+0xe1>
				start = s;
  801f58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f5e:	eb 0e                	jmp    801f6e <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801f60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801f67:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f74:	74 12                	je     801f88 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f76:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801f7d:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801f84:	76 af                	jbe    801f35 <smalloc+0xa8>
  801f86:	eb 01                	jmp    801f89 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801f88:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801f89:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f8d:	74 08                	je     801f97 <smalloc+0x10a>
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f95:	74 0a                	je     801fa1 <smalloc+0x114>
		return NULL;
  801f97:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9c:	e9 85 00 00 00       	jmp    802026 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801fa7:	c1 e8 0c             	shr    $0xc,%eax
  801faa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801fad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801fb0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fb3:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801fba:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fc0:	eb 11                	jmp    801fd3 <smalloc+0x146>
		markedPages[s] = 1;
  801fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fc5:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801fcc:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801fd0:	ff 45 e8             	incl   -0x18(%ebp)
  801fd3:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801fd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fde:	77 e2                	ja     801fc2 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801fe0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fe3:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801fe7:	52                   	push   %edx
  801fe8:	50                   	push   %eax
  801fe9:	ff 75 0c             	pushl  0xc(%ebp)
  801fec:	ff 75 08             	pushl  0x8(%ebp)
  801fef:	e8 d0 f4 ff ff       	call   8014c4 <sys_createSharedObject>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801ffa:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801ffe:	78 12                	js     802012 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  802000:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802003:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802006:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  80200d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802010:	eb 14                	jmp    802026 <smalloc+0x199>
	}
	free((void*) start);
  802012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	50                   	push   %eax
  802019:	e8 6e fd ff ff       	call   801d8c <free>
  80201e:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802021:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
  80202b:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80202e:	83 ec 08             	sub    $0x8,%esp
  802031:	ff 75 0c             	pushl  0xc(%ebp)
  802034:	ff 75 08             	pushl  0x8(%ebp)
  802037:	e8 b2 f4 ff ff       	call   8014ee <sys_getSizeOfSharedObject>
  80203c:	83 c4 10             	add    $0x10,%esp
  80203f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802042:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  802049:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80204c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80204f:	01 d0                	add    %edx,%eax
  802051:	48                   	dec    %eax
  802052:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802055:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802058:	ba 00 00 00 00       	mov    $0x0,%edx
  80205d:	f7 75 e0             	divl   -0x20(%ebp)
  802060:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802063:	29 d0                	sub    %edx,%eax
  802065:	c1 e8 0c             	shr    $0xc,%eax
  802068:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80206b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802072:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  802079:	a1 20 50 80 00       	mov    0x805020,%eax
  80207e:	8b 40 7c             	mov    0x7c(%eax),%eax
  802081:	05 00 10 00 00       	add    $0x1000,%eax
  802086:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  802089:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80208e:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802091:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802094:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80209b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80209e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8020a1:	01 d0                	add    %edx,%eax
  8020a3:	48                   	dec    %eax
  8020a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8020a7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8020af:	f7 75 cc             	divl   -0x34(%ebp)
  8020b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8020b5:	29 d0                	sub    %edx,%eax
  8020b7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8020ba:	76 0a                	jbe    8020c6 <sget+0x9e>
		return NULL;
  8020bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c1:	e9 f7 00 00 00       	jmp    8021bd <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8020c6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020cc:	eb 48                	jmp    802116 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8020ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d1:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020d4:	c1 e8 0c             	shr    $0xc,%eax
  8020d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8020da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020dd:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8020e4:	85 c0                	test   %eax,%eax
  8020e6:	75 11                	jne    8020f9 <sget+0xd1>
			free_Pages_Count++;
  8020e8:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8020eb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020ef:	75 16                	jne    802107 <sget+0xdf>
				start = s;
  8020f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020f7:	eb 0e                	jmp    802107 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8020f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  802100:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80210d:	74 12                	je     802121 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80210f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802116:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80211d:	76 af                	jbe    8020ce <sget+0xa6>
  80211f:	eb 01                	jmp    802122 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802121:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802122:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802126:	74 08                	je     802130 <sget+0x108>
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80212e:	74 0a                	je     80213a <sget+0x112>
		return NULL;
  802130:	b8 00 00 00 00       	mov    $0x0,%eax
  802135:	e9 83 00 00 00       	jmp    8021bd <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80213a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802140:	c1 e8 0c             	shr    $0xc,%eax
  802143:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802146:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802149:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80214c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802153:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802156:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802159:	eb 11                	jmp    80216c <sget+0x144>
		markedPages[k] = 1;
  80215b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80215e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802165:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802169:	ff 45 e8             	incl   -0x18(%ebp)
  80216c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80216f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802172:	01 d0                	add    %edx,%eax
  802174:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802177:	77 e2                	ja     80215b <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	50                   	push   %eax
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	ff 75 08             	pushl  0x8(%ebp)
  802186:	e8 80 f3 ff ff       	call   80150b <sys_getSharedObject>
  80218b:	83 c4 10             	add    $0x10,%esp
  80218e:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802191:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802195:	78 12                	js     8021a9 <sget+0x181>
		shardIDs[startPage] = ss;
  802197:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80219a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80219d:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  8021a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a7:	eb 14                	jmp    8021bd <sget+0x195>
	}
	free((void*) start);
  8021a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ac:	83 ec 0c             	sub    $0xc,%esp
  8021af:	50                   	push   %eax
  8021b0:	e8 d7 fb ff ff       	call   801d8c <free>
  8021b5:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8021b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8021c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8021cd:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021d0:	29 c2                	sub    %eax,%edx
  8021d2:	89 d0                	mov    %edx,%eax
  8021d4:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8021d9:	c1 e8 0c             	shr    $0xc,%eax
  8021dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8021e9:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8021ec:	83 ec 08             	sub    $0x8,%esp
  8021ef:	ff 75 08             	pushl  0x8(%ebp)
  8021f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8021f5:	e8 30 f3 ff ff       	call   80152a <sys_freeSharedObject>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  802200:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802204:	75 0e                	jne    802214 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  802210:	ff ff ff ff 
	}

}
  802214:	90                   	nop
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80221d:	83 ec 04             	sub    $0x4,%esp
  802220:	68 e4 3e 80 00       	push   $0x803ee4
  802225:	68 19 01 00 00       	push   $0x119
  80222a:	68 d6 3e 80 00       	push   $0x803ed6
  80222f:	e8 41 e0 ff ff       	call   800275 <_panic>

00802234 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80223a:	83 ec 04             	sub    $0x4,%esp
  80223d:	68 0a 3f 80 00       	push   $0x803f0a
  802242:	68 23 01 00 00       	push   $0x123
  802247:	68 d6 3e 80 00       	push   $0x803ed6
  80224c:	e8 24 e0 ff ff       	call   800275 <_panic>

00802251 <shrink>:

}
void shrink(uint32 newSize) {
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802257:	83 ec 04             	sub    $0x4,%esp
  80225a:	68 0a 3f 80 00       	push   $0x803f0a
  80225f:	68 27 01 00 00       	push   $0x127
  802264:	68 d6 3e 80 00       	push   $0x803ed6
  802269:	e8 07 e0 ff ff       	call   800275 <_panic>

0080226e <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
  802271:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	68 0a 3f 80 00       	push   $0x803f0a
  80227c:	68 2b 01 00 00       	push   $0x12b
  802281:	68 d6 3e 80 00       	push   $0x803ed6
  802286:	e8 ea df ff ff       	call   800275 <_panic>

0080228b <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80228b:	55                   	push   %ebp
  80228c:	89 e5                	mov    %esp,%ebp
  80228e:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	83 e8 04             	sub    $0x4,%eax
  802297:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80229a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80229d:	8b 00                	mov    (%eax),%eax
  80229f:	83 e0 fe             	and    $0xfffffffe,%eax
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	83 e8 04             	sub    $0x4,%eax
  8022b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8022b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	83 e0 01             	and    $0x1,%eax
  8022bb:	85 c0                	test   %eax,%eax
  8022bd:	0f 94 c0             	sete   %al
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8022c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8022cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d2:	83 f8 02             	cmp    $0x2,%eax
  8022d5:	74 2b                	je     802302 <alloc_block+0x40>
  8022d7:	83 f8 02             	cmp    $0x2,%eax
  8022da:	7f 07                	jg     8022e3 <alloc_block+0x21>
  8022dc:	83 f8 01             	cmp    $0x1,%eax
  8022df:	74 0e                	je     8022ef <alloc_block+0x2d>
  8022e1:	eb 58                	jmp    80233b <alloc_block+0x79>
  8022e3:	83 f8 03             	cmp    $0x3,%eax
  8022e6:	74 2d                	je     802315 <alloc_block+0x53>
  8022e8:	83 f8 04             	cmp    $0x4,%eax
  8022eb:	74 3b                	je     802328 <alloc_block+0x66>
  8022ed:	eb 4c                	jmp    80233b <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8022ef:	83 ec 0c             	sub    $0xc,%esp
  8022f2:	ff 75 08             	pushl  0x8(%ebp)
  8022f5:	e8 f7 03 00 00       	call   8026f1 <alloc_block_FF>
  8022fa:	83 c4 10             	add    $0x10,%esp
  8022fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802300:	eb 4a                	jmp    80234c <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  802302:	83 ec 0c             	sub    $0xc,%esp
  802305:	ff 75 08             	pushl  0x8(%ebp)
  802308:	e8 f0 11 00 00       	call   8034fd <alloc_block_NF>
  80230d:	83 c4 10             	add    $0x10,%esp
  802310:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802313:	eb 37                	jmp    80234c <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802315:	83 ec 0c             	sub    $0xc,%esp
  802318:	ff 75 08             	pushl  0x8(%ebp)
  80231b:	e8 08 08 00 00       	call   802b28 <alloc_block_BF>
  802320:	83 c4 10             	add    $0x10,%esp
  802323:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802326:	eb 24                	jmp    80234c <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  802328:	83 ec 0c             	sub    $0xc,%esp
  80232b:	ff 75 08             	pushl  0x8(%ebp)
  80232e:	e8 ad 11 00 00       	call   8034e0 <alloc_block_WF>
  802333:	83 c4 10             	add    $0x10,%esp
  802336:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802339:	eb 11                	jmp    80234c <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80233b:	83 ec 0c             	sub    $0xc,%esp
  80233e:	68 1c 3f 80 00       	push   $0x803f1c
  802343:	e8 ea e1 ff ff       	call   800532 <cprintf>
  802348:	83 c4 10             	add    $0x10,%esp
		break;
  80234b:	90                   	nop
	}
	return va;
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	53                   	push   %ebx
  802355:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802358:	83 ec 0c             	sub    $0xc,%esp
  80235b:	68 3c 3f 80 00       	push   $0x803f3c
  802360:	e8 cd e1 ff ff       	call   800532 <cprintf>
  802365:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802368:	83 ec 0c             	sub    $0xc,%esp
  80236b:	68 67 3f 80 00       	push   $0x803f67
  802370:	e8 bd e1 ff ff       	call   800532 <cprintf>
  802375:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237e:	eb 37                	jmp    8023b7 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802380:	83 ec 0c             	sub    $0xc,%esp
  802383:	ff 75 f4             	pushl  -0xc(%ebp)
  802386:	e8 19 ff ff ff       	call   8022a4 <is_free_block>
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	0f be d8             	movsbl %al,%ebx
  802391:	83 ec 0c             	sub    $0xc,%esp
  802394:	ff 75 f4             	pushl  -0xc(%ebp)
  802397:	e8 ef fe ff ff       	call   80228b <get_block_size>
  80239c:	83 c4 10             	add    $0x10,%esp
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	53                   	push   %ebx
  8023a3:	50                   	push   %eax
  8023a4:	68 7f 3f 80 00       	push   $0x803f7f
  8023a9:	e8 84 e1 ff ff       	call   800532 <cprintf>
  8023ae:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8023b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bb:	74 07                	je     8023c4 <print_blocks_list+0x73>
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	eb 05                	jmp    8023c9 <print_blocks_list+0x78>
  8023c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c9:	89 45 10             	mov    %eax,0x10(%ebp)
  8023cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	75 ad                	jne    802380 <print_blocks_list+0x2f>
  8023d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d7:	75 a7                	jne    802380 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8023d9:	83 ec 0c             	sub    $0xc,%esp
  8023dc:	68 3c 3f 80 00       	push   $0x803f3c
  8023e1:	e8 4c e1 ff ff       	call   800532 <cprintf>
  8023e6:	83 c4 10             	add    $0x10,%esp

}
  8023e9:	90                   	nop
  8023ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8023f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f8:	83 e0 01             	and    $0x1,%eax
  8023fb:	85 c0                	test   %eax,%eax
  8023fd:	74 03                	je     802402 <initialize_dynamic_allocator+0x13>
  8023ff:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802402:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802406:	0f 84 f8 00 00 00    	je     802504 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80240c:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802413:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802416:	a1 40 50 98 00       	mov    0x985040,%eax
  80241b:	85 c0                	test   %eax,%eax
  80241d:	0f 84 e2 00 00 00    	je     802505 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802432:	8b 55 08             	mov    0x8(%ebp),%edx
  802435:	8b 45 0c             	mov    0xc(%ebp),%eax
  802438:	01 d0                	add    %edx,%eax
  80243a:	83 e8 04             	sub    $0x4,%eax
  80243d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	83 c0 08             	add    $0x8,%eax
  80244f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802452:	8b 45 0c             	mov    0xc(%ebp),%eax
  802455:	83 e8 08             	sub    $0x8,%eax
  802458:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	6a 00                	push   $0x0
  802460:	ff 75 e8             	pushl  -0x18(%ebp)
  802463:	ff 75 ec             	pushl  -0x14(%ebp)
  802466:	e8 9c 00 00 00       	call   802507 <set_block_data>
  80246b:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80246e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802477:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802481:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802488:	00 00 00 
  80248b:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802492:	00 00 00 
  802495:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80249c:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80249f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024a3:	75 17                	jne    8024bc <initialize_dynamic_allocator+0xcd>
  8024a5:	83 ec 04             	sub    $0x4,%esp
  8024a8:	68 98 3f 80 00       	push   $0x803f98
  8024ad:	68 80 00 00 00       	push   $0x80
  8024b2:	68 bb 3f 80 00       	push   $0x803fbb
  8024b7:	e8 b9 dd ff ff       	call   800275 <_panic>
  8024bc:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8024c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c5:	89 10                	mov    %edx,(%eax)
  8024c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	74 0d                	je     8024dd <initialize_dynamic_allocator+0xee>
  8024d0:	a1 48 50 98 00       	mov    0x985048,%eax
  8024d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d8:	89 50 04             	mov    %edx,0x4(%eax)
  8024db:	eb 08                	jmp    8024e5 <initialize_dynamic_allocator+0xf6>
  8024dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e8:	a3 48 50 98 00       	mov    %eax,0x985048
  8024ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f7:	a1 54 50 98 00       	mov    0x985054,%eax
  8024fc:	40                   	inc    %eax
  8024fd:	a3 54 50 98 00       	mov    %eax,0x985054
  802502:	eb 01                	jmp    802505 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802504:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80250d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802510:	83 e0 01             	and    $0x1,%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	74 03                	je     80251a <set_block_data+0x13>
	{
		totalSize++;
  802517:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	83 e8 04             	sub    $0x4,%eax
  802520:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802523:	8b 45 0c             	mov    0xc(%ebp),%eax
  802526:	83 e0 fe             	and    $0xfffffffe,%eax
  802529:	89 c2                	mov    %eax,%edx
  80252b:	8b 45 10             	mov    0x10(%ebp),%eax
  80252e:	83 e0 01             	and    $0x1,%eax
  802531:	09 c2                	or     %eax,%edx
  802533:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802536:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253b:	8d 50 f8             	lea    -0x8(%eax),%edx
  80253e:	8b 45 08             	mov    0x8(%ebp),%eax
  802541:	01 d0                	add    %edx,%eax
  802543:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802546:	8b 45 0c             	mov    0xc(%ebp),%eax
  802549:	83 e0 fe             	and    $0xfffffffe,%eax
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	8b 45 10             	mov    0x10(%ebp),%eax
  802551:	83 e0 01             	and    $0x1,%eax
  802554:	09 c2                	or     %eax,%edx
  802556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802559:	89 10                	mov    %edx,(%eax)
}
  80255b:	90                   	nop
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802564:	a1 48 50 98 00       	mov    0x985048,%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	75 68                	jne    8025d5 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80256d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802571:	75 17                	jne    80258a <insert_sorted_in_freeList+0x2c>
  802573:	83 ec 04             	sub    $0x4,%esp
  802576:	68 98 3f 80 00       	push   $0x803f98
  80257b:	68 9d 00 00 00       	push   $0x9d
  802580:	68 bb 3f 80 00       	push   $0x803fbb
  802585:	e8 eb dc ff ff       	call   800275 <_panic>
  80258a:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	89 10                	mov    %edx,(%eax)
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	74 0d                	je     8025ab <insert_sorted_in_freeList+0x4d>
  80259e:	a1 48 50 98 00       	mov    0x985048,%eax
  8025a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a6:	89 50 04             	mov    %edx,0x4(%eax)
  8025a9:	eb 08                	jmp    8025b3 <insert_sorted_in_freeList+0x55>
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	a3 48 50 98 00       	mov    %eax,0x985048
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025c5:	a1 54 50 98 00       	mov    0x985054,%eax
  8025ca:	40                   	inc    %eax
  8025cb:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8025d0:	e9 1a 01 00 00       	jmp    8026ef <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8025d5:	a1 48 50 98 00       	mov    0x985048,%eax
  8025da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025dd:	eb 7f                	jmp    80265e <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e5:	76 6f                	jbe    802656 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8025e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025eb:	74 06                	je     8025f3 <insert_sorted_in_freeList+0x95>
  8025ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f1:	75 17                	jne    80260a <insert_sorted_in_freeList+0xac>
  8025f3:	83 ec 04             	sub    $0x4,%esp
  8025f6:	68 d4 3f 80 00       	push   $0x803fd4
  8025fb:	68 a6 00 00 00       	push   $0xa6
  802600:	68 bb 3f 80 00       	push   $0x803fbb
  802605:	e8 6b dc ff ff       	call   800275 <_panic>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 50 04             	mov    0x4(%eax),%edx
  802610:	8b 45 08             	mov    0x8(%ebp),%eax
  802613:	89 50 04             	mov    %edx,0x4(%eax)
  802616:	8b 45 08             	mov    0x8(%ebp),%eax
  802619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80261c:	89 10                	mov    %edx,(%eax)
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0d                	je     802635 <insert_sorted_in_freeList+0xd7>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	8b 55 08             	mov    0x8(%ebp),%edx
  802631:	89 10                	mov    %edx,(%eax)
  802633:	eb 08                	jmp    80263d <insert_sorted_in_freeList+0xdf>
  802635:	8b 45 08             	mov    0x8(%ebp),%eax
  802638:	a3 48 50 98 00       	mov    %eax,0x985048
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 55 08             	mov    0x8(%ebp),%edx
  802643:	89 50 04             	mov    %edx,0x4(%eax)
  802646:	a1 54 50 98 00       	mov    0x985054,%eax
  80264b:	40                   	inc    %eax
  80264c:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802651:	e9 99 00 00 00       	jmp    8026ef <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802656:	a1 50 50 98 00       	mov    0x985050,%eax
  80265b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802662:	74 07                	je     80266b <insert_sorted_in_freeList+0x10d>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	eb 05                	jmp    802670 <insert_sorted_in_freeList+0x112>
  80266b:	b8 00 00 00 00       	mov    $0x0,%eax
  802670:	a3 50 50 98 00       	mov    %eax,0x985050
  802675:	a1 50 50 98 00       	mov    0x985050,%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	0f 85 5d ff ff ff    	jne    8025df <insert_sorted_in_freeList+0x81>
  802682:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802686:	0f 85 53 ff ff ff    	jne    8025df <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80268c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802690:	75 17                	jne    8026a9 <insert_sorted_in_freeList+0x14b>
  802692:	83 ec 04             	sub    $0x4,%esp
  802695:	68 0c 40 80 00       	push   $0x80400c
  80269a:	68 ab 00 00 00       	push   $0xab
  80269f:	68 bb 3f 80 00       	push   $0x803fbb
  8026a4:	e8 cc db ff ff       	call   800275 <_panic>
  8026a9:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	89 50 04             	mov    %edx,0x4(%eax)
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	74 0c                	je     8026cb <insert_sorted_in_freeList+0x16d>
  8026bf:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8026c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c7:	89 10                	mov    %edx,(%eax)
  8026c9:	eb 08                	jmp    8026d3 <insert_sorted_in_freeList+0x175>
  8026cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ce:	a3 48 50 98 00       	mov    %eax,0x985048
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e4:	a1 54 50 98 00       	mov    0x985054,%eax
  8026e9:	40                   	inc    %eax
  8026ea:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	83 e0 01             	and    $0x1,%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	74 03                	je     802704 <alloc_block_FF+0x13>
  802701:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802704:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802708:	77 07                	ja     802711 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  80270a:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802711:	a1 40 50 98 00       	mov    0x985040,%eax
  802716:	85 c0                	test   %eax,%eax
  802718:	75 63                	jne    80277d <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	83 c0 10             	add    $0x10,%eax
  802720:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802723:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80272a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80272d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802730:	01 d0                	add    %edx,%eax
  802732:	48                   	dec    %eax
  802733:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802736:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802739:	ba 00 00 00 00       	mov    $0x0,%edx
  80273e:	f7 75 ec             	divl   -0x14(%ebp)
  802741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802744:	29 d0                	sub    %edx,%eax
  802746:	c1 e8 0c             	shr    $0xc,%eax
  802749:	83 ec 0c             	sub    $0xc,%esp
  80274c:	50                   	push   %eax
  80274d:	e8 6e f4 ff ff       	call   801bc0 <sbrk>
  802752:	83 c4 10             	add    $0x10,%esp
  802755:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802758:	83 ec 0c             	sub    $0xc,%esp
  80275b:	6a 00                	push   $0x0
  80275d:	e8 5e f4 ff ff       	call   801bc0 <sbrk>
  802762:	83 c4 10             	add    $0x10,%esp
  802765:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802768:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80276e:	83 ec 08             	sub    $0x8,%esp
  802771:	50                   	push   %eax
  802772:	ff 75 e4             	pushl  -0x1c(%ebp)
  802775:	e8 75 fc ff ff       	call   8023ef <initialize_dynamic_allocator>
  80277a:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80277d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802781:	75 0a                	jne    80278d <alloc_block_FF+0x9c>
	{
		return NULL;
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	e9 99 03 00 00       	jmp    802b26 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80278d:	8b 45 08             	mov    0x8(%ebp),%eax
  802790:	83 c0 08             	add    $0x8,%eax
  802793:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802796:	a1 48 50 98 00       	mov    0x985048,%eax
  80279b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80279e:	e9 03 02 00 00       	jmp    8029a6 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8027a3:	83 ec 0c             	sub    $0xc,%esp
  8027a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8027a9:	e8 dd fa ff ff       	call   80228b <get_block_size>
  8027ae:	83 c4 10             	add    $0x10,%esp
  8027b1:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8027b4:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8027b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8027ba:	0f 82 de 01 00 00    	jb     80299e <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8027c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c3:	83 c0 10             	add    $0x10,%eax
  8027c6:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8027c9:	0f 87 32 01 00 00    	ja     802901 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8027cf:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8027d2:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8027d5:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8027d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027de:	01 d0                	add    %edx,%eax
  8027e0:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8027e3:	83 ec 04             	sub    $0x4,%esp
  8027e6:	6a 00                	push   $0x0
  8027e8:	ff 75 98             	pushl  -0x68(%ebp)
  8027eb:	ff 75 94             	pushl  -0x6c(%ebp)
  8027ee:	e8 14 fd ff ff       	call   802507 <set_block_data>
  8027f3:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	74 06                	je     802802 <alloc_block_FF+0x111>
  8027fc:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802800:	75 17                	jne    802819 <alloc_block_FF+0x128>
  802802:	83 ec 04             	sub    $0x4,%esp
  802805:	68 30 40 80 00       	push   $0x804030
  80280a:	68 de 00 00 00       	push   $0xde
  80280f:	68 bb 3f 80 00       	push   $0x803fbb
  802814:	e8 5c da ff ff       	call   800275 <_panic>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 10                	mov    (%eax),%edx
  80281e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802821:	89 10                	mov    %edx,(%eax)
  802823:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	85 c0                	test   %eax,%eax
  80282a:	74 0b                	je     802837 <alloc_block_FF+0x146>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802834:	89 50 04             	mov    %edx,0x4(%eax)
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80283d:	89 10                	mov    %edx,(%eax)
  80283f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802845:	89 50 04             	mov    %edx,0x4(%eax)
  802848:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	75 08                	jne    802859 <alloc_block_FF+0x168>
  802851:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802854:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802859:	a1 54 50 98 00       	mov    0x985054,%eax
  80285e:	40                   	inc    %eax
  80285f:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802864:	83 ec 04             	sub    $0x4,%esp
  802867:	6a 01                	push   $0x1
  802869:	ff 75 dc             	pushl  -0x24(%ebp)
  80286c:	ff 75 f4             	pushl  -0xc(%ebp)
  80286f:	e8 93 fc ff ff       	call   802507 <set_block_data>
  802874:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802877:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287b:	75 17                	jne    802894 <alloc_block_FF+0x1a3>
  80287d:	83 ec 04             	sub    $0x4,%esp
  802880:	68 64 40 80 00       	push   $0x804064
  802885:	68 e3 00 00 00       	push   $0xe3
  80288a:	68 bb 3f 80 00       	push   $0x803fbb
  80288f:	e8 e1 d9 ff ff       	call   800275 <_panic>
  802894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	85 c0                	test   %eax,%eax
  80289b:	74 10                	je     8028ad <alloc_block_FF+0x1bc>
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a5:	8b 52 04             	mov    0x4(%edx),%edx
  8028a8:	89 50 04             	mov    %edx,0x4(%eax)
  8028ab:	eb 0b                	jmp    8028b8 <alloc_block_FF+0x1c7>
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 40 04             	mov    0x4(%eax),%eax
  8028be:	85 c0                	test   %eax,%eax
  8028c0:	74 0f                	je     8028d1 <alloc_block_FF+0x1e0>
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cb:	8b 12                	mov    (%edx),%edx
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	eb 0a                	jmp    8028db <alloc_block_FF+0x1ea>
  8028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	a3 48 50 98 00       	mov    %eax,0x985048
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ee:	a1 54 50 98 00       	mov    0x985054,%eax
  8028f3:	48                   	dec    %eax
  8028f4:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	e9 25 02 00 00       	jmp    802b26 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802901:	83 ec 04             	sub    $0x4,%esp
  802904:	6a 01                	push   $0x1
  802906:	ff 75 9c             	pushl  -0x64(%ebp)
  802909:	ff 75 f4             	pushl  -0xc(%ebp)
  80290c:	e8 f6 fb ff ff       	call   802507 <set_block_data>
  802911:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802914:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802918:	75 17                	jne    802931 <alloc_block_FF+0x240>
  80291a:	83 ec 04             	sub    $0x4,%esp
  80291d:	68 64 40 80 00       	push   $0x804064
  802922:	68 eb 00 00 00       	push   $0xeb
  802927:	68 bb 3f 80 00       	push   $0x803fbb
  80292c:	e8 44 d9 ff ff       	call   800275 <_panic>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	85 c0                	test   %eax,%eax
  802938:	74 10                	je     80294a <alloc_block_FF+0x259>
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802942:	8b 52 04             	mov    0x4(%edx),%edx
  802945:	89 50 04             	mov    %edx,0x4(%eax)
  802948:	eb 0b                	jmp    802955 <alloc_block_FF+0x264>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 40 04             	mov    0x4(%eax),%eax
  802950:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 40 04             	mov    0x4(%eax),%eax
  80295b:	85 c0                	test   %eax,%eax
  80295d:	74 0f                	je     80296e <alloc_block_FF+0x27d>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 40 04             	mov    0x4(%eax),%eax
  802965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802968:	8b 12                	mov    (%edx),%edx
  80296a:	89 10                	mov    %edx,(%eax)
  80296c:	eb 0a                	jmp    802978 <alloc_block_FF+0x287>
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 00                	mov    (%eax),%eax
  802973:	a3 48 50 98 00       	mov    %eax,0x985048
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298b:	a1 54 50 98 00       	mov    0x985054,%eax
  802990:	48                   	dec    %eax
  802991:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	e9 88 01 00 00       	jmp    802b26 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80299e:	a1 50 50 98 00       	mov    0x985050,%eax
  8029a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029aa:	74 07                	je     8029b3 <alloc_block_FF+0x2c2>
  8029ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029af:	8b 00                	mov    (%eax),%eax
  8029b1:	eb 05                	jmp    8029b8 <alloc_block_FF+0x2c7>
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b8:	a3 50 50 98 00       	mov    %eax,0x985050
  8029bd:	a1 50 50 98 00       	mov    0x985050,%eax
  8029c2:	85 c0                	test   %eax,%eax
  8029c4:	0f 85 d9 fd ff ff    	jne    8027a3 <alloc_block_FF+0xb2>
  8029ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ce:	0f 85 cf fd ff ff    	jne    8027a3 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8029d4:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8029db:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	48                   	dec    %eax
  8029e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ef:	f7 75 d8             	divl   -0x28(%ebp)
  8029f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029f5:	29 d0                	sub    %edx,%eax
  8029f7:	c1 e8 0c             	shr    $0xc,%eax
  8029fa:	83 ec 0c             	sub    $0xc,%esp
  8029fd:	50                   	push   %eax
  8029fe:	e8 bd f1 ff ff       	call   801bc0 <sbrk>
  802a03:	83 c4 10             	add    $0x10,%esp
  802a06:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802a09:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802a0d:	75 0a                	jne    802a19 <alloc_block_FF+0x328>
		return NULL;
  802a0f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a14:	e9 0d 01 00 00       	jmp    802b26 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802a19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a1c:	83 e8 04             	sub    $0x4,%eax
  802a1f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802a22:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802a29:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a2f:	01 d0                	add    %edx,%eax
  802a31:	48                   	dec    %eax
  802a32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802a35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a38:	ba 00 00 00 00       	mov    $0x0,%edx
  802a3d:	f7 75 c8             	divl   -0x38(%ebp)
  802a40:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a43:	29 d0                	sub    %edx,%eax
  802a45:	c1 e8 02             	shr    $0x2,%eax
  802a48:	c1 e0 02             	shl    $0x2,%eax
  802a4b:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802a4e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a51:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802a57:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a5a:	83 e8 08             	sub    $0x8,%eax
  802a5d:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802a60:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	83 e0 fe             	and    $0xfffffffe,%eax
  802a68:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802a6b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a6e:	f7 d8                	neg    %eax
  802a70:	89 c2                	mov    %eax,%edx
  802a72:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a75:	01 d0                	add    %edx,%eax
  802a77:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802a7a:	83 ec 0c             	sub    $0xc,%esp
  802a7d:	ff 75 b8             	pushl  -0x48(%ebp)
  802a80:	e8 1f f8 ff ff       	call   8022a4 <is_free_block>
  802a85:	83 c4 10             	add    $0x10,%esp
  802a88:	0f be c0             	movsbl %al,%eax
  802a8b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802a8e:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802a92:	74 42                	je     802ad6 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802a94:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a9b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a9e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802aa1:	01 d0                	add    %edx,%eax
  802aa3:	48                   	dec    %eax
  802aa4:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802aa7:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  802aaf:	f7 75 b0             	divl   -0x50(%ebp)
  802ab2:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802ab5:	29 d0                	sub    %edx,%eax
  802ab7:	89 c2                	mov    %eax,%edx
  802ab9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802abc:	01 d0                	add    %edx,%eax
  802abe:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802ac1:	83 ec 04             	sub    $0x4,%esp
  802ac4:	6a 00                	push   $0x0
  802ac6:	ff 75 a8             	pushl  -0x58(%ebp)
  802ac9:	ff 75 b8             	pushl  -0x48(%ebp)
  802acc:	e8 36 fa ff ff       	call   802507 <set_block_data>
  802ad1:	83 c4 10             	add    $0x10,%esp
  802ad4:	eb 42                	jmp    802b18 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802ad6:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802add:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ae0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ae3:	01 d0                	add    %edx,%eax
  802ae5:	48                   	dec    %eax
  802ae6:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802ae9:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802aec:	ba 00 00 00 00       	mov    $0x0,%edx
  802af1:	f7 75 a4             	divl   -0x5c(%ebp)
  802af4:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802af7:	29 d0                	sub    %edx,%eax
  802af9:	83 ec 04             	sub    $0x4,%esp
  802afc:	6a 00                	push   $0x0
  802afe:	50                   	push   %eax
  802aff:	ff 75 d0             	pushl  -0x30(%ebp)
  802b02:	e8 00 fa ff ff       	call   802507 <set_block_data>
  802b07:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802b0a:	83 ec 0c             	sub    $0xc,%esp
  802b0d:	ff 75 d0             	pushl  -0x30(%ebp)
  802b10:	e8 49 fa ff ff       	call   80255e <insert_sorted_in_freeList>
  802b15:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802b18:	83 ec 0c             	sub    $0xc,%esp
  802b1b:	ff 75 08             	pushl  0x8(%ebp)
  802b1e:	e8 ce fb ff ff       	call   8026f1 <alloc_block_FF>
  802b23:	83 c4 10             	add    $0x10,%esp
}
  802b26:	c9                   	leave  
  802b27:	c3                   	ret    

00802b28 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b28:	55                   	push   %ebp
  802b29:	89 e5                	mov    %esp,%ebp
  802b2b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b32:	75 0a                	jne    802b3e <alloc_block_BF+0x16>
	{
		return NULL;
  802b34:	b8 00 00 00 00       	mov    $0x0,%eax
  802b39:	e9 7a 02 00 00       	jmp    802db8 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b41:	83 c0 08             	add    $0x8,%eax
  802b44:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802b47:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802b4e:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802b55:	a1 48 50 98 00       	mov    0x985048,%eax
  802b5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b5d:	eb 32                	jmp    802b91 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802b5f:	ff 75 ec             	pushl  -0x14(%ebp)
  802b62:	e8 24 f7 ff ff       	call   80228b <get_block_size>
  802b67:	83 c4 04             	add    $0x4,%esp
  802b6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802b6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b70:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b73:	72 14                	jb     802b89 <alloc_block_BF+0x61>
  802b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b78:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b7b:	73 0c                	jae    802b89 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802b7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b86:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802b89:	a1 50 50 98 00       	mov    0x985050,%eax
  802b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b95:	74 07                	je     802b9e <alloc_block_BF+0x76>
  802b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	eb 05                	jmp    802ba3 <alloc_block_BF+0x7b>
  802b9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ba3:	a3 50 50 98 00       	mov    %eax,0x985050
  802ba8:	a1 50 50 98 00       	mov    0x985050,%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	75 ae                	jne    802b5f <alloc_block_BF+0x37>
  802bb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bb5:	75 a8                	jne    802b5f <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbb:	75 22                	jne    802bdf <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802bbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc0:	83 ec 0c             	sub    $0xc,%esp
  802bc3:	50                   	push   %eax
  802bc4:	e8 f7 ef ff ff       	call   801bc0 <sbrk>
  802bc9:	83 c4 10             	add    $0x10,%esp
  802bcc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802bcf:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802bd3:	75 0a                	jne    802bdf <alloc_block_BF+0xb7>
			return NULL;
  802bd5:	b8 00 00 00 00       	mov    $0x0,%eax
  802bda:	e9 d9 01 00 00       	jmp    802db8 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802bdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be2:	83 c0 10             	add    $0x10,%eax
  802be5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802be8:	0f 87 32 01 00 00    	ja     802d20 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802bf4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802bf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bfd:	01 d0                	add    %edx,%eax
  802bff:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802c02:	83 ec 04             	sub    $0x4,%esp
  802c05:	6a 00                	push   $0x0
  802c07:	ff 75 dc             	pushl  -0x24(%ebp)
  802c0a:	ff 75 d8             	pushl  -0x28(%ebp)
  802c0d:	e8 f5 f8 ff ff       	call   802507 <set_block_data>
  802c12:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802c15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c19:	74 06                	je     802c21 <alloc_block_BF+0xf9>
  802c1b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802c1f:	75 17                	jne    802c38 <alloc_block_BF+0x110>
  802c21:	83 ec 04             	sub    $0x4,%esp
  802c24:	68 30 40 80 00       	push   $0x804030
  802c29:	68 49 01 00 00       	push   $0x149
  802c2e:	68 bb 3f 80 00       	push   $0x803fbb
  802c33:	e8 3d d6 ff ff       	call   800275 <_panic>
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	8b 10                	mov    (%eax),%edx
  802c3d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c40:	89 10                	mov    %edx,(%eax)
  802c42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c45:	8b 00                	mov    (%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 0b                	je     802c56 <alloc_block_BF+0x12e>
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c53:	89 50 04             	mov    %edx,0x4(%eax)
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c64:	89 50 04             	mov    %edx,0x4(%eax)
  802c67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c6a:	8b 00                	mov    (%eax),%eax
  802c6c:	85 c0                	test   %eax,%eax
  802c6e:	75 08                	jne    802c78 <alloc_block_BF+0x150>
  802c70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c73:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c78:	a1 54 50 98 00       	mov    0x985054,%eax
  802c7d:	40                   	inc    %eax
  802c7e:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802c83:	83 ec 04             	sub    $0x4,%esp
  802c86:	6a 01                	push   $0x1
  802c88:	ff 75 e8             	pushl  -0x18(%ebp)
  802c8b:	ff 75 f4             	pushl  -0xc(%ebp)
  802c8e:	e8 74 f8 ff ff       	call   802507 <set_block_data>
  802c93:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9a:	75 17                	jne    802cb3 <alloc_block_BF+0x18b>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 64 40 80 00       	push   $0x804064
  802ca4:	68 4e 01 00 00       	push   $0x14e
  802ca9:	68 bb 3f 80 00       	push   $0x803fbb
  802cae:	e8 c2 d5 ff ff       	call   800275 <_panic>
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 00                	mov    (%eax),%eax
  802cb8:	85 c0                	test   %eax,%eax
  802cba:	74 10                	je     802ccc <alloc_block_BF+0x1a4>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc4:	8b 52 04             	mov    0x4(%edx),%edx
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	eb 0b                	jmp    802cd7 <alloc_block_BF+0x1af>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 04             	mov    0x4(%eax),%eax
  802cd2:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 0f                	je     802cf0 <alloc_block_BF+0x1c8>
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	8b 40 04             	mov    0x4(%eax),%eax
  802ce7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cea:	8b 12                	mov    (%edx),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 0a                	jmp    802cfa <alloc_block_BF+0x1d2>
  802cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf3:	8b 00                	mov    (%eax),%eax
  802cf5:	a3 48 50 98 00       	mov    %eax,0x985048
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0d:	a1 54 50 98 00       	mov    0x985054,%eax
  802d12:	48                   	dec    %eax
  802d13:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	e9 98 00 00 00       	jmp    802db8 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	6a 01                	push   $0x1
  802d25:	ff 75 f0             	pushl  -0x10(%ebp)
  802d28:	ff 75 f4             	pushl  -0xc(%ebp)
  802d2b:	e8 d7 f7 ff ff       	call   802507 <set_block_data>
  802d30:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d37:	75 17                	jne    802d50 <alloc_block_BF+0x228>
  802d39:	83 ec 04             	sub    $0x4,%esp
  802d3c:	68 64 40 80 00       	push   $0x804064
  802d41:	68 56 01 00 00       	push   $0x156
  802d46:	68 bb 3f 80 00       	push   $0x803fbb
  802d4b:	e8 25 d5 ff ff       	call   800275 <_panic>
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	85 c0                	test   %eax,%eax
  802d57:	74 10                	je     802d69 <alloc_block_BF+0x241>
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 00                	mov    (%eax),%eax
  802d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d61:	8b 52 04             	mov    0x4(%edx),%edx
  802d64:	89 50 04             	mov    %edx,0x4(%eax)
  802d67:	eb 0b                	jmp    802d74 <alloc_block_BF+0x24c>
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	85 c0                	test   %eax,%eax
  802d7c:	74 0f                	je     802d8d <alloc_block_BF+0x265>
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 04             	mov    0x4(%eax),%eax
  802d84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d87:	8b 12                	mov    (%edx),%edx
  802d89:	89 10                	mov    %edx,(%eax)
  802d8b:	eb 0a                	jmp    802d97 <alloc_block_BF+0x26f>
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	8b 00                	mov    (%eax),%eax
  802d92:	a3 48 50 98 00       	mov    %eax,0x985048
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802daa:	a1 54 50 98 00       	mov    0x985054,%eax
  802daf:	48                   	dec    %eax
  802db0:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802db8:	c9                   	leave  
  802db9:	c3                   	ret    

00802dba <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802dba:	55                   	push   %ebp
  802dbb:	89 e5                	mov    %esp,%ebp
  802dbd:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802dc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc4:	0f 84 6a 02 00 00    	je     803034 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802dca:	ff 75 08             	pushl  0x8(%ebp)
  802dcd:	e8 b9 f4 ff ff       	call   80228b <get_block_size>
  802dd2:	83 c4 04             	add    $0x4,%esp
  802dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	83 e8 08             	sub    $0x8,%eax
  802dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	83 e0 fe             	and    $0xfffffffe,%eax
  802de9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802def:	f7 d8                	neg    %eax
  802df1:	89 c2                	mov    %eax,%edx
  802df3:	8b 45 08             	mov    0x8(%ebp),%eax
  802df6:	01 d0                	add    %edx,%eax
  802df8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802dfb:	ff 75 e8             	pushl  -0x18(%ebp)
  802dfe:	e8 a1 f4 ff ff       	call   8022a4 <is_free_block>
  802e03:	83 c4 04             	add    $0x4,%esp
  802e06:	0f be c0             	movsbl %al,%eax
  802e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	01 d0                	add    %edx,%eax
  802e14:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802e17:	ff 75 e0             	pushl  -0x20(%ebp)
  802e1a:	e8 85 f4 ff ff       	call   8022a4 <is_free_block>
  802e1f:	83 c4 04             	add    $0x4,%esp
  802e22:	0f be c0             	movsbl %al,%eax
  802e25:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802e28:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e2c:	75 34                	jne    802e62 <free_block+0xa8>
  802e2e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e32:	75 2e                	jne    802e62 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802e34:	ff 75 e8             	pushl  -0x18(%ebp)
  802e37:	e8 4f f4 ff ff       	call   80228b <get_block_size>
  802e3c:	83 c4 04             	add    $0x4,%esp
  802e3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e48:	01 d0                	add    %edx,%eax
  802e4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802e4d:	6a 00                	push   $0x0
  802e4f:	ff 75 d4             	pushl  -0x2c(%ebp)
  802e52:	ff 75 e8             	pushl  -0x18(%ebp)
  802e55:	e8 ad f6 ff ff       	call   802507 <set_block_data>
  802e5a:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802e5d:	e9 d3 01 00 00       	jmp    803035 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802e62:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e66:	0f 85 c8 00 00 00    	jne    802f34 <free_block+0x17a>
  802e6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e70:	0f 85 be 00 00 00    	jne    802f34 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802e76:	ff 75 e0             	pushl  -0x20(%ebp)
  802e79:	e8 0d f4 ff ff       	call   80228b <get_block_size>
  802e7e:	83 c4 04             	add    $0x4,%esp
  802e81:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e87:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e8a:	01 d0                	add    %edx,%eax
  802e8c:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802e8f:	6a 00                	push   $0x0
  802e91:	ff 75 cc             	pushl  -0x34(%ebp)
  802e94:	ff 75 08             	pushl  0x8(%ebp)
  802e97:	e8 6b f6 ff ff       	call   802507 <set_block_data>
  802e9c:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802e9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ea3:	75 17                	jne    802ebc <free_block+0x102>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 64 40 80 00       	push   $0x804064
  802ead:	68 87 01 00 00       	push   $0x187
  802eb2:	68 bb 3f 80 00       	push   $0x803fbb
  802eb7:	e8 b9 d3 ff ff       	call   800275 <_panic>
  802ebc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 10                	je     802ed5 <free_block+0x11b>
  802ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ecd:	8b 52 04             	mov    0x4(%edx),%edx
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	eb 0b                	jmp    802ee0 <free_block+0x126>
  802ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 0f                	je     802ef9 <free_block+0x13f>
  802eea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef3:	8b 12                	mov    (%edx),%edx
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	eb 0a                	jmp    802f03 <free_block+0x149>
  802ef9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	a3 48 50 98 00       	mov    %eax,0x985048
  802f03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 54 50 98 00       	mov    0x985054,%eax
  802f1b:	48                   	dec    %eax
  802f1c:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f21:	83 ec 0c             	sub    $0xc,%esp
  802f24:	ff 75 08             	pushl  0x8(%ebp)
  802f27:	e8 32 f6 ff ff       	call   80255e <insert_sorted_in_freeList>
  802f2c:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802f2f:	e9 01 01 00 00       	jmp    803035 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802f34:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802f38:	0f 85 d3 00 00 00    	jne    803011 <free_block+0x257>
  802f3e:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802f42:	0f 85 c9 00 00 00    	jne    803011 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802f48:	83 ec 0c             	sub    $0xc,%esp
  802f4b:	ff 75 e8             	pushl  -0x18(%ebp)
  802f4e:	e8 38 f3 ff ff       	call   80228b <get_block_size>
  802f53:	83 c4 10             	add    $0x10,%esp
  802f56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802f59:	83 ec 0c             	sub    $0xc,%esp
  802f5c:	ff 75 e0             	pushl  -0x20(%ebp)
  802f5f:	e8 27 f3 ff ff       	call   80228b <get_block_size>
  802f64:	83 c4 10             	add    $0x10,%esp
  802f67:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f70:	01 c2                	add    %eax,%edx
  802f72:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f75:	01 d0                	add    %edx,%eax
  802f77:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	6a 00                	push   $0x0
  802f7f:	ff 75 c0             	pushl  -0x40(%ebp)
  802f82:	ff 75 e8             	pushl  -0x18(%ebp)
  802f85:	e8 7d f5 ff ff       	call   802507 <set_block_data>
  802f8a:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802f8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f91:	75 17                	jne    802faa <free_block+0x1f0>
  802f93:	83 ec 04             	sub    $0x4,%esp
  802f96:	68 64 40 80 00       	push   $0x804064
  802f9b:	68 94 01 00 00       	push   $0x194
  802fa0:	68 bb 3f 80 00       	push   $0x803fbb
  802fa5:	e8 cb d2 ff ff       	call   800275 <_panic>
  802faa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	85 c0                	test   %eax,%eax
  802fb1:	74 10                	je     802fc3 <free_block+0x209>
  802fb3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb6:	8b 00                	mov    (%eax),%eax
  802fb8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fbb:	8b 52 04             	mov    0x4(%edx),%edx
  802fbe:	89 50 04             	mov    %edx,0x4(%eax)
  802fc1:	eb 0b                	jmp    802fce <free_block+0x214>
  802fc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc6:	8b 40 04             	mov    0x4(%eax),%eax
  802fc9:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	85 c0                	test   %eax,%eax
  802fd6:	74 0f                	je     802fe7 <free_block+0x22d>
  802fd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fdb:	8b 40 04             	mov    0x4(%eax),%eax
  802fde:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fe1:	8b 12                	mov    (%edx),%edx
  802fe3:	89 10                	mov    %edx,(%eax)
  802fe5:	eb 0a                	jmp    802ff1 <free_block+0x237>
  802fe7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fea:	8b 00                	mov    (%eax),%eax
  802fec:	a3 48 50 98 00       	mov    %eax,0x985048
  802ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803004:	a1 54 50 98 00       	mov    0x985054,%eax
  803009:	48                   	dec    %eax
  80300a:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  80300f:	eb 24                	jmp    803035 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803011:	83 ec 04             	sub    $0x4,%esp
  803014:	6a 00                	push   $0x0
  803016:	ff 75 f4             	pushl  -0xc(%ebp)
  803019:	ff 75 08             	pushl  0x8(%ebp)
  80301c:	e8 e6 f4 ff ff       	call   802507 <set_block_data>
  803021:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803024:	83 ec 0c             	sub    $0xc,%esp
  803027:	ff 75 08             	pushl  0x8(%ebp)
  80302a:	e8 2f f5 ff ff       	call   80255e <insert_sorted_in_freeList>
  80302f:	83 c4 10             	add    $0x10,%esp
  803032:	eb 01                	jmp    803035 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803034:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803035:	c9                   	leave  
  803036:	c3                   	ret    

00803037 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  803037:	55                   	push   %ebp
  803038:	89 e5                	mov    %esp,%ebp
  80303a:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  80303d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803041:	75 10                	jne    803053 <realloc_block_FF+0x1c>
  803043:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803047:	75 0a                	jne    803053 <realloc_block_FF+0x1c>
	{
		return NULL;
  803049:	b8 00 00 00 00       	mov    $0x0,%eax
  80304e:	e9 8b 04 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803053:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803057:	75 18                	jne    803071 <realloc_block_FF+0x3a>
	{
		free_block(va);
  803059:	83 ec 0c             	sub    $0xc,%esp
  80305c:	ff 75 08             	pushl  0x8(%ebp)
  80305f:	e8 56 fd ff ff       	call   802dba <free_block>
  803064:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803067:	b8 00 00 00 00       	mov    $0x0,%eax
  80306c:	e9 6d 04 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803071:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803075:	75 13                	jne    80308a <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803077:	83 ec 0c             	sub    $0xc,%esp
  80307a:	ff 75 0c             	pushl  0xc(%ebp)
  80307d:	e8 6f f6 ff ff       	call   8026f1 <alloc_block_FF>
  803082:	83 c4 10             	add    $0x10,%esp
  803085:	e9 54 04 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  80308a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80308d:	83 e0 01             	and    $0x1,%eax
  803090:	85 c0                	test   %eax,%eax
  803092:	74 03                	je     803097 <realloc_block_FF+0x60>
	{
		new_size++;
  803094:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803097:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80309b:	77 07                	ja     8030a4 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80309d:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  8030a4:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  8030a8:	83 ec 0c             	sub    $0xc,%esp
  8030ab:	ff 75 08             	pushl  0x8(%ebp)
  8030ae:	e8 d8 f1 ff ff       	call   80228b <get_block_size>
  8030b3:	83 c4 10             	add    $0x10,%esp
  8030b6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030bf:	75 08                	jne    8030c9 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	e9 15 04 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8030c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cf:	01 d0                	add    %edx,%eax
  8030d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8030d4:	83 ec 0c             	sub    $0xc,%esp
  8030d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8030da:	e8 c5 f1 ff ff       	call   8022a4 <is_free_block>
  8030df:	83 c4 10             	add    $0x10,%esp
  8030e2:	0f be c0             	movsbl %al,%eax
  8030e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8030e8:	83 ec 0c             	sub    $0xc,%esp
  8030eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8030ee:	e8 98 f1 ff ff       	call   80228b <get_block_size>
  8030f3:	83 c4 10             	add    $0x10,%esp
  8030f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8030f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8030ff:	0f 86 a7 02 00 00    	jbe    8033ac <realloc_block_FF+0x375>
	{
		if(isNextFree)
  803105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803109:	0f 84 86 02 00 00    	je     803395 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  80310f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	01 d0                	add    %edx,%eax
  803117:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80311a:	0f 85 b2 00 00 00    	jne    8031d2 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803120:	83 ec 0c             	sub    $0xc,%esp
  803123:	ff 75 08             	pushl  0x8(%ebp)
  803126:	e8 79 f1 ff ff       	call   8022a4 <is_free_block>
  80312b:	83 c4 10             	add    $0x10,%esp
  80312e:	84 c0                	test   %al,%al
  803130:	0f 94 c0             	sete   %al
  803133:	0f b6 c0             	movzbl %al,%eax
  803136:	83 ec 04             	sub    $0x4,%esp
  803139:	50                   	push   %eax
  80313a:	ff 75 0c             	pushl  0xc(%ebp)
  80313d:	ff 75 08             	pushl  0x8(%ebp)
  803140:	e8 c2 f3 ff ff       	call   802507 <set_block_data>
  803145:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  803148:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80314c:	75 17                	jne    803165 <realloc_block_FF+0x12e>
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	68 64 40 80 00       	push   $0x804064
  803156:	68 db 01 00 00       	push   $0x1db
  80315b:	68 bb 3f 80 00       	push   $0x803fbb
  803160:	e8 10 d1 ff ff       	call   800275 <_panic>
  803165:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803168:	8b 00                	mov    (%eax),%eax
  80316a:	85 c0                	test   %eax,%eax
  80316c:	74 10                	je     80317e <realloc_block_FF+0x147>
  80316e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803171:	8b 00                	mov    (%eax),%eax
  803173:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803176:	8b 52 04             	mov    0x4(%edx),%edx
  803179:	89 50 04             	mov    %edx,0x4(%eax)
  80317c:	eb 0b                	jmp    803189 <realloc_block_FF+0x152>
  80317e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803181:	8b 40 04             	mov    0x4(%eax),%eax
  803184:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803189:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318c:	8b 40 04             	mov    0x4(%eax),%eax
  80318f:	85 c0                	test   %eax,%eax
  803191:	74 0f                	je     8031a2 <realloc_block_FF+0x16b>
  803193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803196:	8b 40 04             	mov    0x4(%eax),%eax
  803199:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80319c:	8b 12                	mov    (%edx),%edx
  80319e:	89 10                	mov    %edx,(%eax)
  8031a0:	eb 0a                	jmp    8031ac <realloc_block_FF+0x175>
  8031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a5:	8b 00                	mov    (%eax),%eax
  8031a7:	a3 48 50 98 00       	mov    %eax,0x985048
  8031ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bf:	a1 54 50 98 00       	mov    0x985054,%eax
  8031c4:	48                   	dec    %eax
  8031c5:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cd:	e9 0c 03 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8031d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d8:	01 d0                	add    %edx,%eax
  8031da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031dd:	0f 86 b2 01 00 00    	jbe    803395 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8031e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031e6:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8031e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8031ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031ef:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8031f2:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8031f5:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8031f9:	0f 87 b8 00 00 00    	ja     8032b7 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8031ff:	83 ec 0c             	sub    $0xc,%esp
  803202:	ff 75 08             	pushl  0x8(%ebp)
  803205:	e8 9a f0 ff ff       	call   8022a4 <is_free_block>
  80320a:	83 c4 10             	add    $0x10,%esp
  80320d:	84 c0                	test   %al,%al
  80320f:	0f 94 c0             	sete   %al
  803212:	0f b6 c0             	movzbl %al,%eax
  803215:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803218:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80321b:	01 ca                	add    %ecx,%edx
  80321d:	83 ec 04             	sub    $0x4,%esp
  803220:	50                   	push   %eax
  803221:	52                   	push   %edx
  803222:	ff 75 08             	pushl  0x8(%ebp)
  803225:	e8 dd f2 ff ff       	call   802507 <set_block_data>
  80322a:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80322d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803231:	75 17                	jne    80324a <realloc_block_FF+0x213>
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 64 40 80 00       	push   $0x804064
  80323b:	68 e8 01 00 00       	push   $0x1e8
  803240:	68 bb 3f 80 00       	push   $0x803fbb
  803245:	e8 2b d0 ff ff       	call   800275 <_panic>
  80324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 10                	je     803263 <realloc_block_FF+0x22c>
  803253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80325b:	8b 52 04             	mov    0x4(%edx),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 0b                	jmp    80326e <realloc_block_FF+0x237>
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0f                	je     803287 <realloc_block_FF+0x250>
  803278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803281:	8b 12                	mov    (%edx),%edx
  803283:	89 10                	mov    %edx,(%eax)
  803285:	eb 0a                	jmp    803291 <realloc_block_FF+0x25a>
  803287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	a3 48 50 98 00       	mov    %eax,0x985048
  803291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 54 50 98 00       	mov    0x985054,%eax
  8032a9:	48                   	dec    %eax
  8032aa:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	e9 27 02 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8032b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032bb:	75 17                	jne    8032d4 <realloc_block_FF+0x29d>
  8032bd:	83 ec 04             	sub    $0x4,%esp
  8032c0:	68 64 40 80 00       	push   $0x804064
  8032c5:	68 ed 01 00 00       	push   $0x1ed
  8032ca:	68 bb 3f 80 00       	push   $0x803fbb
  8032cf:	e8 a1 cf ff ff       	call   800275 <_panic>
  8032d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d7:	8b 00                	mov    (%eax),%eax
  8032d9:	85 c0                	test   %eax,%eax
  8032db:	74 10                	je     8032ed <realloc_block_FF+0x2b6>
  8032dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e0:	8b 00                	mov    (%eax),%eax
  8032e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032e5:	8b 52 04             	mov    0x4(%edx),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	eb 0b                	jmp    8032f8 <realloc_block_FF+0x2c1>
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	8b 40 04             	mov    0x4(%eax),%eax
  8032f3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fb:	8b 40 04             	mov    0x4(%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 0f                	je     803311 <realloc_block_FF+0x2da>
  803302:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803305:	8b 40 04             	mov    0x4(%eax),%eax
  803308:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80330b:	8b 12                	mov    (%edx),%edx
  80330d:	89 10                	mov    %edx,(%eax)
  80330f:	eb 0a                	jmp    80331b <realloc_block_FF+0x2e4>
  803311:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803314:	8b 00                	mov    (%eax),%eax
  803316:	a3 48 50 98 00       	mov    %eax,0x985048
  80331b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80331e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803324:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803327:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80332e:	a1 54 50 98 00       	mov    0x985054,%eax
  803333:	48                   	dec    %eax
  803334:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  803339:	8b 55 08             	mov    0x8(%ebp),%edx
  80333c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80333f:	01 d0                	add    %edx,%eax
  803341:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803344:	83 ec 04             	sub    $0x4,%esp
  803347:	6a 00                	push   $0x0
  803349:	ff 75 e0             	pushl  -0x20(%ebp)
  80334c:	ff 75 f0             	pushl  -0x10(%ebp)
  80334f:	e8 b3 f1 ff ff       	call   802507 <set_block_data>
  803354:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803357:	83 ec 0c             	sub    $0xc,%esp
  80335a:	ff 75 08             	pushl  0x8(%ebp)
  80335d:	e8 42 ef ff ff       	call   8022a4 <is_free_block>
  803362:	83 c4 10             	add    $0x10,%esp
  803365:	84 c0                	test   %al,%al
  803367:	0f 94 c0             	sete   %al
  80336a:	0f b6 c0             	movzbl %al,%eax
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	50                   	push   %eax
  803371:	ff 75 0c             	pushl  0xc(%ebp)
  803374:	ff 75 08             	pushl  0x8(%ebp)
  803377:	e8 8b f1 ff ff       	call   802507 <set_block_data>
  80337c:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80337f:	83 ec 0c             	sub    $0xc,%esp
  803382:	ff 75 f0             	pushl  -0x10(%ebp)
  803385:	e8 d4 f1 ff ff       	call   80255e <insert_sorted_in_freeList>
  80338a:	83 c4 10             	add    $0x10,%esp
					return va;
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	e9 49 01 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803395:	8b 45 0c             	mov    0xc(%ebp),%eax
  803398:	83 e8 08             	sub    $0x8,%eax
  80339b:	83 ec 0c             	sub    $0xc,%esp
  80339e:	50                   	push   %eax
  80339f:	e8 4d f3 ff ff       	call   8026f1 <alloc_block_FF>
  8033a4:	83 c4 10             	add    $0x10,%esp
  8033a7:	e9 32 01 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  8033ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033b2:	0f 83 21 01 00 00    	jae    8034d9 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8033b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bb:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033be:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8033c1:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8033c5:	77 0e                	ja     8033d5 <realloc_block_FF+0x39e>
  8033c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033cb:	75 08                	jne    8033d5 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	e9 09 01 00 00       	jmp    8034de <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8033d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8033db:	83 ec 0c             	sub    $0xc,%esp
  8033de:	ff 75 08             	pushl  0x8(%ebp)
  8033e1:	e8 be ee ff ff       	call   8022a4 <is_free_block>
  8033e6:	83 c4 10             	add    $0x10,%esp
  8033e9:	84 c0                	test   %al,%al
  8033eb:	0f 94 c0             	sete   %al
  8033ee:	0f b6 c0             	movzbl %al,%eax
  8033f1:	83 ec 04             	sub    $0x4,%esp
  8033f4:	50                   	push   %eax
  8033f5:	ff 75 0c             	pushl  0xc(%ebp)
  8033f8:	ff 75 d8             	pushl  -0x28(%ebp)
  8033fb:	e8 07 f1 ff ff       	call   802507 <set_block_data>
  803400:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803403:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803406:	8b 45 0c             	mov    0xc(%ebp),%eax
  803409:	01 d0                	add    %edx,%eax
  80340b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80340e:	83 ec 04             	sub    $0x4,%esp
  803411:	6a 00                	push   $0x0
  803413:	ff 75 dc             	pushl  -0x24(%ebp)
  803416:	ff 75 d4             	pushl  -0x2c(%ebp)
  803419:	e8 e9 f0 ff ff       	call   802507 <set_block_data>
  80341e:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803425:	0f 84 9b 00 00 00    	je     8034c6 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80342b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80342e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803431:	01 d0                	add    %edx,%eax
  803433:	83 ec 04             	sub    $0x4,%esp
  803436:	6a 00                	push   $0x0
  803438:	50                   	push   %eax
  803439:	ff 75 d4             	pushl  -0x2c(%ebp)
  80343c:	e8 c6 f0 ff ff       	call   802507 <set_block_data>
  803441:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803444:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803448:	75 17                	jne    803461 <realloc_block_FF+0x42a>
  80344a:	83 ec 04             	sub    $0x4,%esp
  80344d:	68 64 40 80 00       	push   $0x804064
  803452:	68 10 02 00 00       	push   $0x210
  803457:	68 bb 3f 80 00       	push   $0x803fbb
  80345c:	e8 14 ce ff ff       	call   800275 <_panic>
  803461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	85 c0                	test   %eax,%eax
  803468:	74 10                	je     80347a <realloc_block_FF+0x443>
  80346a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346d:	8b 00                	mov    (%eax),%eax
  80346f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803472:	8b 52 04             	mov    0x4(%edx),%edx
  803475:	89 50 04             	mov    %edx,0x4(%eax)
  803478:	eb 0b                	jmp    803485 <realloc_block_FF+0x44e>
  80347a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347d:	8b 40 04             	mov    0x4(%eax),%eax
  803480:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803488:	8b 40 04             	mov    0x4(%eax),%eax
  80348b:	85 c0                	test   %eax,%eax
  80348d:	74 0f                	je     80349e <realloc_block_FF+0x467>
  80348f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803492:	8b 40 04             	mov    0x4(%eax),%eax
  803495:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803498:	8b 12                	mov    (%edx),%edx
  80349a:	89 10                	mov    %edx,(%eax)
  80349c:	eb 0a                	jmp    8034a8 <realloc_block_FF+0x471>
  80349e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a1:	8b 00                	mov    (%eax),%eax
  8034a3:	a3 48 50 98 00       	mov    %eax,0x985048
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034bb:	a1 54 50 98 00       	mov    0x985054,%eax
  8034c0:	48                   	dec    %eax
  8034c1:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8034c6:	83 ec 0c             	sub    $0xc,%esp
  8034c9:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034cc:	e8 8d f0 ff ff       	call   80255e <insert_sorted_in_freeList>
  8034d1:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8034d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034d7:	eb 05                	jmp    8034de <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8034d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034de:	c9                   	leave  
  8034df:	c3                   	ret    

008034e0 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8034e0:	55                   	push   %ebp
  8034e1:	89 e5                	mov    %esp,%ebp
  8034e3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8034e6:	83 ec 04             	sub    $0x4,%esp
  8034e9:	68 84 40 80 00       	push   $0x804084
  8034ee:	68 20 02 00 00       	push   $0x220
  8034f3:	68 bb 3f 80 00       	push   $0x803fbb
  8034f8:	e8 78 cd ff ff       	call   800275 <_panic>

008034fd <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8034fd:	55                   	push   %ebp
  8034fe:	89 e5                	mov    %esp,%ebp
  803500:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803503:	83 ec 04             	sub    $0x4,%esp
  803506:	68 ac 40 80 00       	push   $0x8040ac
  80350b:	68 28 02 00 00       	push   $0x228
  803510:	68 bb 3f 80 00       	push   $0x803fbb
  803515:	e8 5b cd ff ff       	call   800275 <_panic>
  80351a:	66 90                	xchg   %ax,%ax

0080351c <__udivdi3>:
  80351c:	55                   	push   %ebp
  80351d:	57                   	push   %edi
  80351e:	56                   	push   %esi
  80351f:	53                   	push   %ebx
  803520:	83 ec 1c             	sub    $0x1c,%esp
  803523:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803527:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80352b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803533:	89 ca                	mov    %ecx,%edx
  803535:	89 f8                	mov    %edi,%eax
  803537:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80353b:	85 f6                	test   %esi,%esi
  80353d:	75 2d                	jne    80356c <__udivdi3+0x50>
  80353f:	39 cf                	cmp    %ecx,%edi
  803541:	77 65                	ja     8035a8 <__udivdi3+0x8c>
  803543:	89 fd                	mov    %edi,%ebp
  803545:	85 ff                	test   %edi,%edi
  803547:	75 0b                	jne    803554 <__udivdi3+0x38>
  803549:	b8 01 00 00 00       	mov    $0x1,%eax
  80354e:	31 d2                	xor    %edx,%edx
  803550:	f7 f7                	div    %edi
  803552:	89 c5                	mov    %eax,%ebp
  803554:	31 d2                	xor    %edx,%edx
  803556:	89 c8                	mov    %ecx,%eax
  803558:	f7 f5                	div    %ebp
  80355a:	89 c1                	mov    %eax,%ecx
  80355c:	89 d8                	mov    %ebx,%eax
  80355e:	f7 f5                	div    %ebp
  803560:	89 cf                	mov    %ecx,%edi
  803562:	89 fa                	mov    %edi,%edx
  803564:	83 c4 1c             	add    $0x1c,%esp
  803567:	5b                   	pop    %ebx
  803568:	5e                   	pop    %esi
  803569:	5f                   	pop    %edi
  80356a:	5d                   	pop    %ebp
  80356b:	c3                   	ret    
  80356c:	39 ce                	cmp    %ecx,%esi
  80356e:	77 28                	ja     803598 <__udivdi3+0x7c>
  803570:	0f bd fe             	bsr    %esi,%edi
  803573:	83 f7 1f             	xor    $0x1f,%edi
  803576:	75 40                	jne    8035b8 <__udivdi3+0x9c>
  803578:	39 ce                	cmp    %ecx,%esi
  80357a:	72 0a                	jb     803586 <__udivdi3+0x6a>
  80357c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803580:	0f 87 9e 00 00 00    	ja     803624 <__udivdi3+0x108>
  803586:	b8 01 00 00 00       	mov    $0x1,%eax
  80358b:	89 fa                	mov    %edi,%edx
  80358d:	83 c4 1c             	add    $0x1c,%esp
  803590:	5b                   	pop    %ebx
  803591:	5e                   	pop    %esi
  803592:	5f                   	pop    %edi
  803593:	5d                   	pop    %ebp
  803594:	c3                   	ret    
  803595:	8d 76 00             	lea    0x0(%esi),%esi
  803598:	31 ff                	xor    %edi,%edi
  80359a:	31 c0                	xor    %eax,%eax
  80359c:	89 fa                	mov    %edi,%edx
  80359e:	83 c4 1c             	add    $0x1c,%esp
  8035a1:	5b                   	pop    %ebx
  8035a2:	5e                   	pop    %esi
  8035a3:	5f                   	pop    %edi
  8035a4:	5d                   	pop    %ebp
  8035a5:	c3                   	ret    
  8035a6:	66 90                	xchg   %ax,%ax
  8035a8:	89 d8                	mov    %ebx,%eax
  8035aa:	f7 f7                	div    %edi
  8035ac:	31 ff                	xor    %edi,%edi
  8035ae:	89 fa                	mov    %edi,%edx
  8035b0:	83 c4 1c             	add    $0x1c,%esp
  8035b3:	5b                   	pop    %ebx
  8035b4:	5e                   	pop    %esi
  8035b5:	5f                   	pop    %edi
  8035b6:	5d                   	pop    %ebp
  8035b7:	c3                   	ret    
  8035b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035bd:	89 eb                	mov    %ebp,%ebx
  8035bf:	29 fb                	sub    %edi,%ebx
  8035c1:	89 f9                	mov    %edi,%ecx
  8035c3:	d3 e6                	shl    %cl,%esi
  8035c5:	89 c5                	mov    %eax,%ebp
  8035c7:	88 d9                	mov    %bl,%cl
  8035c9:	d3 ed                	shr    %cl,%ebp
  8035cb:	89 e9                	mov    %ebp,%ecx
  8035cd:	09 f1                	or     %esi,%ecx
  8035cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035d3:	89 f9                	mov    %edi,%ecx
  8035d5:	d3 e0                	shl    %cl,%eax
  8035d7:	89 c5                	mov    %eax,%ebp
  8035d9:	89 d6                	mov    %edx,%esi
  8035db:	88 d9                	mov    %bl,%cl
  8035dd:	d3 ee                	shr    %cl,%esi
  8035df:	89 f9                	mov    %edi,%ecx
  8035e1:	d3 e2                	shl    %cl,%edx
  8035e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035e7:	88 d9                	mov    %bl,%cl
  8035e9:	d3 e8                	shr    %cl,%eax
  8035eb:	09 c2                	or     %eax,%edx
  8035ed:	89 d0                	mov    %edx,%eax
  8035ef:	89 f2                	mov    %esi,%edx
  8035f1:	f7 74 24 0c          	divl   0xc(%esp)
  8035f5:	89 d6                	mov    %edx,%esi
  8035f7:	89 c3                	mov    %eax,%ebx
  8035f9:	f7 e5                	mul    %ebp
  8035fb:	39 d6                	cmp    %edx,%esi
  8035fd:	72 19                	jb     803618 <__udivdi3+0xfc>
  8035ff:	74 0b                	je     80360c <__udivdi3+0xf0>
  803601:	89 d8                	mov    %ebx,%eax
  803603:	31 ff                	xor    %edi,%edi
  803605:	e9 58 ff ff ff       	jmp    803562 <__udivdi3+0x46>
  80360a:	66 90                	xchg   %ax,%ax
  80360c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803610:	89 f9                	mov    %edi,%ecx
  803612:	d3 e2                	shl    %cl,%edx
  803614:	39 c2                	cmp    %eax,%edx
  803616:	73 e9                	jae    803601 <__udivdi3+0xe5>
  803618:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80361b:	31 ff                	xor    %edi,%edi
  80361d:	e9 40 ff ff ff       	jmp    803562 <__udivdi3+0x46>
  803622:	66 90                	xchg   %ax,%ax
  803624:	31 c0                	xor    %eax,%eax
  803626:	e9 37 ff ff ff       	jmp    803562 <__udivdi3+0x46>
  80362b:	90                   	nop

0080362c <__umoddi3>:
  80362c:	55                   	push   %ebp
  80362d:	57                   	push   %edi
  80362e:	56                   	push   %esi
  80362f:	53                   	push   %ebx
  803630:	83 ec 1c             	sub    $0x1c,%esp
  803633:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803637:	8b 74 24 34          	mov    0x34(%esp),%esi
  80363b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80363f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803643:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803647:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80364b:	89 f3                	mov    %esi,%ebx
  80364d:	89 fa                	mov    %edi,%edx
  80364f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803653:	89 34 24             	mov    %esi,(%esp)
  803656:	85 c0                	test   %eax,%eax
  803658:	75 1a                	jne    803674 <__umoddi3+0x48>
  80365a:	39 f7                	cmp    %esi,%edi
  80365c:	0f 86 a2 00 00 00    	jbe    803704 <__umoddi3+0xd8>
  803662:	89 c8                	mov    %ecx,%eax
  803664:	89 f2                	mov    %esi,%edx
  803666:	f7 f7                	div    %edi
  803668:	89 d0                	mov    %edx,%eax
  80366a:	31 d2                	xor    %edx,%edx
  80366c:	83 c4 1c             	add    $0x1c,%esp
  80366f:	5b                   	pop    %ebx
  803670:	5e                   	pop    %esi
  803671:	5f                   	pop    %edi
  803672:	5d                   	pop    %ebp
  803673:	c3                   	ret    
  803674:	39 f0                	cmp    %esi,%eax
  803676:	0f 87 ac 00 00 00    	ja     803728 <__umoddi3+0xfc>
  80367c:	0f bd e8             	bsr    %eax,%ebp
  80367f:	83 f5 1f             	xor    $0x1f,%ebp
  803682:	0f 84 ac 00 00 00    	je     803734 <__umoddi3+0x108>
  803688:	bf 20 00 00 00       	mov    $0x20,%edi
  80368d:	29 ef                	sub    %ebp,%edi
  80368f:	89 fe                	mov    %edi,%esi
  803691:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803695:	89 e9                	mov    %ebp,%ecx
  803697:	d3 e0                	shl    %cl,%eax
  803699:	89 d7                	mov    %edx,%edi
  80369b:	89 f1                	mov    %esi,%ecx
  80369d:	d3 ef                	shr    %cl,%edi
  80369f:	09 c7                	or     %eax,%edi
  8036a1:	89 e9                	mov    %ebp,%ecx
  8036a3:	d3 e2                	shl    %cl,%edx
  8036a5:	89 14 24             	mov    %edx,(%esp)
  8036a8:	89 d8                	mov    %ebx,%eax
  8036aa:	d3 e0                	shl    %cl,%eax
  8036ac:	89 c2                	mov    %eax,%edx
  8036ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036b2:	d3 e0                	shl    %cl,%eax
  8036b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036bc:	89 f1                	mov    %esi,%ecx
  8036be:	d3 e8                	shr    %cl,%eax
  8036c0:	09 d0                	or     %edx,%eax
  8036c2:	d3 eb                	shr    %cl,%ebx
  8036c4:	89 da                	mov    %ebx,%edx
  8036c6:	f7 f7                	div    %edi
  8036c8:	89 d3                	mov    %edx,%ebx
  8036ca:	f7 24 24             	mull   (%esp)
  8036cd:	89 c6                	mov    %eax,%esi
  8036cf:	89 d1                	mov    %edx,%ecx
  8036d1:	39 d3                	cmp    %edx,%ebx
  8036d3:	0f 82 87 00 00 00    	jb     803760 <__umoddi3+0x134>
  8036d9:	0f 84 91 00 00 00    	je     803770 <__umoddi3+0x144>
  8036df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036e3:	29 f2                	sub    %esi,%edx
  8036e5:	19 cb                	sbb    %ecx,%ebx
  8036e7:	89 d8                	mov    %ebx,%eax
  8036e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036ed:	d3 e0                	shl    %cl,%eax
  8036ef:	89 e9                	mov    %ebp,%ecx
  8036f1:	d3 ea                	shr    %cl,%edx
  8036f3:	09 d0                	or     %edx,%eax
  8036f5:	89 e9                	mov    %ebp,%ecx
  8036f7:	d3 eb                	shr    %cl,%ebx
  8036f9:	89 da                	mov    %ebx,%edx
  8036fb:	83 c4 1c             	add    $0x1c,%esp
  8036fe:	5b                   	pop    %ebx
  8036ff:	5e                   	pop    %esi
  803700:	5f                   	pop    %edi
  803701:	5d                   	pop    %ebp
  803702:	c3                   	ret    
  803703:	90                   	nop
  803704:	89 fd                	mov    %edi,%ebp
  803706:	85 ff                	test   %edi,%edi
  803708:	75 0b                	jne    803715 <__umoddi3+0xe9>
  80370a:	b8 01 00 00 00       	mov    $0x1,%eax
  80370f:	31 d2                	xor    %edx,%edx
  803711:	f7 f7                	div    %edi
  803713:	89 c5                	mov    %eax,%ebp
  803715:	89 f0                	mov    %esi,%eax
  803717:	31 d2                	xor    %edx,%edx
  803719:	f7 f5                	div    %ebp
  80371b:	89 c8                	mov    %ecx,%eax
  80371d:	f7 f5                	div    %ebp
  80371f:	89 d0                	mov    %edx,%eax
  803721:	e9 44 ff ff ff       	jmp    80366a <__umoddi3+0x3e>
  803726:	66 90                	xchg   %ax,%ax
  803728:	89 c8                	mov    %ecx,%eax
  80372a:	89 f2                	mov    %esi,%edx
  80372c:	83 c4 1c             	add    $0x1c,%esp
  80372f:	5b                   	pop    %ebx
  803730:	5e                   	pop    %esi
  803731:	5f                   	pop    %edi
  803732:	5d                   	pop    %ebp
  803733:	c3                   	ret    
  803734:	3b 04 24             	cmp    (%esp),%eax
  803737:	72 06                	jb     80373f <__umoddi3+0x113>
  803739:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80373d:	77 0f                	ja     80374e <__umoddi3+0x122>
  80373f:	89 f2                	mov    %esi,%edx
  803741:	29 f9                	sub    %edi,%ecx
  803743:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803747:	89 14 24             	mov    %edx,(%esp)
  80374a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80374e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803752:	8b 14 24             	mov    (%esp),%edx
  803755:	83 c4 1c             	add    $0x1c,%esp
  803758:	5b                   	pop    %ebx
  803759:	5e                   	pop    %esi
  80375a:	5f                   	pop    %edi
  80375b:	5d                   	pop    %ebp
  80375c:	c3                   	ret    
  80375d:	8d 76 00             	lea    0x0(%esi),%esi
  803760:	2b 04 24             	sub    (%esp),%eax
  803763:	19 fa                	sbb    %edi,%edx
  803765:	89 d1                	mov    %edx,%ecx
  803767:	89 c6                	mov    %eax,%esi
  803769:	e9 71 ff ff ff       	jmp    8036df <__umoddi3+0xb3>
  80376e:	66 90                	xchg   %ax,%ax
  803770:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803774:	72 ea                	jb     803760 <__umoddi3+0x134>
  803776:	89 d9                	mov    %ebx,%ecx
  803778:	e9 62 ff ff ff       	jmp    8036df <__umoddi3+0xb3>
