
obj/user/tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 92 01 00 00       	call   8001c8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 f1 15 00 00       	call   801634 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	struct semaphore cs1 = create_semaphore("cs1", 1);
  800046:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 01                	push   $0x1
  80004e:	68 80 37 80 00       	push   $0x803780
  800053:	50                   	push   %eax
  800054:	e8 a8 19 00 00       	call   801a01 <create_semaphore>
  800059:	83 c4 0c             	add    $0xc,%esp
	struct semaphore depend1 = create_semaphore("depend1", 0);
  80005c:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 00                	push   $0x0
  800064:	68 84 37 80 00       	push   $0x803784
  800069:	50                   	push   %eax
  80006a:	e8 92 19 00 00       	call   801a01 <create_semaphore>
  80006f:	83 c4 0c             	add    $0xc,%esp

	int id1, id2, id3;
	id1 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800072:	a1 20 50 80 00       	mov    0x805020,%eax
  800077:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  80007d:	a1 20 50 80 00       	mov    0x805020,%eax
  800082:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  800088:	89 c1                	mov    %eax,%ecx
  80008a:	a1 20 50 80 00       	mov    0x805020,%eax
  80008f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800095:	52                   	push   %edx
  800096:	51                   	push   %ecx
  800097:	50                   	push   %eax
  800098:	68 8c 37 80 00       	push   $0x80378c
  80009d:	e8 3d 15 00 00       	call   8015df <sys_create_env>
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000a8:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ad:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000b3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b8:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000be:	89 c1                	mov    %eax,%ecx
  8000c0:	a1 20 50 80 00       	mov    0x805020,%eax
  8000c5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  8000cb:	52                   	push   %edx
  8000cc:	51                   	push   %ecx
  8000cd:	50                   	push   %eax
  8000ce:	68 8c 37 80 00       	push   $0x80378c
  8000d3:	e8 07 15 00 00       	call   8015df <sys_create_env>
  8000d8:	83 c4 10             	add    $0x10,%esp
  8000db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("sem1Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000de:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e3:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ee:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000f4:	89 c1                	mov    %eax,%ecx
  8000f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000fb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800101:	52                   	push   %edx
  800102:	51                   	push   %ecx
  800103:	50                   	push   %eax
  800104:	68 8c 37 80 00       	push   $0x80378c
  800109:	e8 d1 14 00 00       	call   8015df <sys_create_env>
  80010e:	83 c4 10             	add    $0x10,%esp
  800111:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(id1);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 f0             	pushl  -0x10(%ebp)
  80011a:	e8 de 14 00 00       	call   8015fd <sys_run_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 d0 14 00 00       	call   8015fd <sys_run_env>
  80012d:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	ff 75 e8             	pushl  -0x18(%ebp)
  800136:	e8 c2 14 00 00       	call   8015fd <sys_run_env>
  80013b:	83 c4 10             	add    $0x10,%esp

	wait_semaphore(depend1);
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	ff 75 d8             	pushl  -0x28(%ebp)
  800144:	e8 84 19 00 00       	call   801acd <wait_semaphore>
  800149:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80014c:	83 ec 0c             	sub    $0xc,%esp
  80014f:	ff 75 d8             	pushl  -0x28(%ebp)
  800152:	e8 76 19 00 00       	call   801acd <wait_semaphore>
  800157:	83 c4 10             	add    $0x10,%esp
	wait_semaphore(depend1);
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	ff 75 d8             	pushl  -0x28(%ebp)
  800160:	e8 68 19 00 00       	call   801acd <wait_semaphore>
  800165:	83 c4 10             	add    $0x10,%esp

	int sem1val = semaphore_count(cs1);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	ff 75 dc             	pushl  -0x24(%ebp)
  80016e:	e8 26 1a 00 00       	call   801b99 <semaphore_count>
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = semaphore_count(depend1);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	ff 75 d8             	pushl  -0x28(%ebp)
  80017f:	e8 15 1a 00 00       	call   801b99 <semaphore_count>
  800184:	83 c4 10             	add    $0x10,%esp
  800187:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80018a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80018e:	75 18                	jne    8001a8 <_main+0x170>
  800190:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800194:	75 12                	jne    8001a8 <_main+0x170>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  800196:	83 ec 0c             	sub    $0xc,%esp
  800199:	68 98 37 80 00       	push   $0x803798
  80019e:	e8 27 04 00 00       	call   8005ca <cprintf>
  8001a3:	83 c4 10             	add    $0x10,%esp
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);

	return;
  8001a6:	eb 1e                	jmp    8001c6 <_main+0x18e>
	int sem1val = semaphore_count(cs1);
	int sem2val = semaphore_count(depend1);
	if (sem2val == 0 && sem1val == 1)
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
	else
		panic("Error: wrong semaphore value... please review your semaphore code again! Expected = %d, %d, Actual = %d, %d", 1, 0, sem1val, sem2val);
  8001a8:	83 ec 04             	sub    $0x4,%esp
  8001ab:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ae:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b1:	6a 00                	push   $0x0
  8001b3:	6a 01                	push   $0x1
  8001b5:	68 e0 37 80 00       	push   $0x8037e0
  8001ba:	6a 1f                	push   $0x1f
  8001bc:	68 4c 38 80 00       	push   $0x80384c
  8001c1:	e8 47 01 00 00       	call   80030d <_panic>

	return;
}
  8001c6:	c9                   	leave  
  8001c7:	c3                   	ret    

008001c8 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001ce:	e8 7a 14 00 00       	call   80164d <sys_getenvindex>
  8001d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001d9:	89 d0                	mov    %edx,%eax
  8001db:	c1 e0 02             	shl    $0x2,%eax
  8001de:	01 d0                	add    %edx,%eax
  8001e0:	c1 e0 03             	shl    $0x3,%eax
  8001e3:	01 d0                	add    %edx,%eax
  8001e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001ec:	01 d0                	add    %edx,%eax
  8001ee:	c1 e0 02             	shl    $0x2,%eax
  8001f1:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f6:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001fb:	a1 20 50 80 00       	mov    0x805020,%eax
  800200:	8a 40 20             	mov    0x20(%eax),%al
  800203:	84 c0                	test   %al,%al
  800205:	74 0d                	je     800214 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800207:	a1 20 50 80 00       	mov    0x805020,%eax
  80020c:	83 c0 20             	add    $0x20,%eax
  80020f:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800218:	7e 0a                	jle    800224 <libmain+0x5c>
		binaryname = argv[0];
  80021a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80021d:	8b 00                	mov    (%eax),%eax
  80021f:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  800224:	83 ec 08             	sub    $0x8,%esp
  800227:	ff 75 0c             	pushl  0xc(%ebp)
  80022a:	ff 75 08             	pushl  0x8(%ebp)
  80022d:	e8 06 fe ff ff       	call   800038 <_main>
  800232:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800235:	a1 00 50 80 00       	mov    0x805000,%eax
  80023a:	85 c0                	test   %eax,%eax
  80023c:	0f 84 9f 00 00 00    	je     8002e1 <libmain+0x119>
	{
		sys_lock_cons();
  800242:	e8 8a 11 00 00       	call   8013d1 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	68 84 38 80 00       	push   $0x803884
  80024f:	e8 76 03 00 00       	call   8005ca <cprintf>
  800254:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800257:	a1 20 50 80 00       	mov    0x805020,%eax
  80025c:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800262:	a1 20 50 80 00       	mov    0x805020,%eax
  800267:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	52                   	push   %edx
  800271:	50                   	push   %eax
  800272:	68 ac 38 80 00       	push   $0x8038ac
  800277:	e8 4e 03 00 00       	call   8005ca <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80027f:	a1 20 50 80 00       	mov    0x805020,%eax
  800284:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80028a:	a1 20 50 80 00       	mov    0x805020,%eax
  80028f:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800295:	a1 20 50 80 00       	mov    0x805020,%eax
  80029a:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002a0:	51                   	push   %ecx
  8002a1:	52                   	push   %edx
  8002a2:	50                   	push   %eax
  8002a3:	68 d4 38 80 00       	push   $0x8038d4
  8002a8:	e8 1d 03 00 00       	call   8005ca <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b5:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	50                   	push   %eax
  8002bf:	68 2c 39 80 00       	push   $0x80392c
  8002c4:	e8 01 03 00 00       	call   8005ca <cprintf>
  8002c9:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	68 84 38 80 00       	push   $0x803884
  8002d4:	e8 f1 02 00 00       	call   8005ca <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002dc:	e8 0a 11 00 00       	call   8013eb <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002e1:	e8 19 00 00 00       	call   8002ff <exit>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002ef:	83 ec 0c             	sub    $0xc,%esp
  8002f2:	6a 00                	push   $0x0
  8002f4:	e8 20 13 00 00       	call   801619 <sys_destroy_env>
  8002f9:	83 c4 10             	add    $0x10,%esp
}
  8002fc:	90                   	nop
  8002fd:	c9                   	leave  
  8002fe:	c3                   	ret    

008002ff <exit>:

void
exit(void)
{
  8002ff:	55                   	push   %ebp
  800300:	89 e5                	mov    %esp,%ebp
  800302:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800305:	e8 75 13 00 00       	call   80167f <sys_exit_env>
}
  80030a:	90                   	nop
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800313:	8d 45 10             	lea    0x10(%ebp),%eax
  800316:	83 c0 04             	add    $0x4,%eax
  800319:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80031c:	a1 60 50 98 00       	mov    0x985060,%eax
  800321:	85 c0                	test   %eax,%eax
  800323:	74 16                	je     80033b <_panic+0x2e>
		cprintf("%s: ", argv0);
  800325:	a1 60 50 98 00       	mov    0x985060,%eax
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	50                   	push   %eax
  80032e:	68 40 39 80 00       	push   $0x803940
  800333:	e8 92 02 00 00       	call   8005ca <cprintf>
  800338:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80033b:	a1 04 50 80 00       	mov    0x805004,%eax
  800340:	ff 75 0c             	pushl  0xc(%ebp)
  800343:	ff 75 08             	pushl  0x8(%ebp)
  800346:	50                   	push   %eax
  800347:	68 45 39 80 00       	push   $0x803945
  80034c:	e8 79 02 00 00       	call   8005ca <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800354:	8b 45 10             	mov    0x10(%ebp),%eax
  800357:	83 ec 08             	sub    $0x8,%esp
  80035a:	ff 75 f4             	pushl  -0xc(%ebp)
  80035d:	50                   	push   %eax
  80035e:	e8 fc 01 00 00       	call   80055f <vcprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800366:	83 ec 08             	sub    $0x8,%esp
  800369:	6a 00                	push   $0x0
  80036b:	68 61 39 80 00       	push   $0x803961
  800370:	e8 ea 01 00 00       	call   80055f <vcprintf>
  800375:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800378:	e8 82 ff ff ff       	call   8002ff <exit>

	// should not return here
	while (1) ;
  80037d:	eb fe                	jmp    80037d <_panic+0x70>

0080037f <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800385:	a1 20 50 80 00       	mov    0x805020,%eax
  80038a:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800390:	8b 45 0c             	mov    0xc(%ebp),%eax
  800393:	39 c2                	cmp    %eax,%edx
  800395:	74 14                	je     8003ab <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800397:	83 ec 04             	sub    $0x4,%esp
  80039a:	68 64 39 80 00       	push   $0x803964
  80039f:	6a 26                	push   $0x26
  8003a1:	68 b0 39 80 00       	push   $0x8039b0
  8003a6:	e8 62 ff ff ff       	call   80030d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003b9:	e9 c5 00 00 00       	jmp    800483 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cb:	01 d0                	add    %edx,%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	75 08                	jne    8003db <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003d3:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003d6:	e9 a5 00 00 00       	jmp    800480 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003e9:	eb 69                	jmp    800454 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8003f0:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8003f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f9:	89 d0                	mov    %edx,%eax
  8003fb:	01 c0                	add    %eax,%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	c1 e0 03             	shl    $0x3,%eax
  800402:	01 c8                	add    %ecx,%eax
  800404:	8a 40 04             	mov    0x4(%eax),%al
  800407:	84 c0                	test   %al,%al
  800409:	75 46                	jne    800451 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80040b:	a1 20 50 80 00       	mov    0x805020,%eax
  800410:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  800416:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8b 00                	mov    (%eax),%eax
  800426:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800429:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80042c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800431:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800436:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c8                	add    %ecx,%eax
  800442:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800444:	39 c2                	cmp    %eax,%edx
  800446:	75 09                	jne    800451 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  800448:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80044f:	eb 15                	jmp    800466 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	ff 45 e8             	incl   -0x18(%ebp)
  800454:	a1 20 50 80 00       	mov    0x805020,%eax
  800459:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80045f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800462:	39 c2                	cmp    %eax,%edx
  800464:	77 85                	ja     8003eb <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800466:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046a:	75 14                	jne    800480 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80046c:	83 ec 04             	sub    $0x4,%esp
  80046f:	68 bc 39 80 00       	push   $0x8039bc
  800474:	6a 3a                	push   $0x3a
  800476:	68 b0 39 80 00       	push   $0x8039b0
  80047b:	e8 8d fe ff ff       	call   80030d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800480:	ff 45 f0             	incl   -0x10(%ebp)
  800483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800486:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800489:	0f 8c 2f ff ff ff    	jl     8003be <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80048f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800496:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049d:	eb 26                	jmp    8004c5 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80049f:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a4:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8004aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004ad:	89 d0                	mov    %edx,%eax
  8004af:	01 c0                	add    %eax,%eax
  8004b1:	01 d0                	add    %edx,%eax
  8004b3:	c1 e0 03             	shl    $0x3,%eax
  8004b6:	01 c8                	add    %ecx,%eax
  8004b8:	8a 40 04             	mov    0x4(%eax),%al
  8004bb:	3c 01                	cmp    $0x1,%al
  8004bd:	75 03                	jne    8004c2 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004bf:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c2:	ff 45 e0             	incl   -0x20(%ebp)
  8004c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004ca:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d3:	39 c2                	cmp    %eax,%edx
  8004d5:	77 c8                	ja     80049f <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004da:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dd:	74 14                	je     8004f3 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004df:	83 ec 04             	sub    $0x4,%esp
  8004e2:	68 10 3a 80 00       	push   $0x803a10
  8004e7:	6a 44                	push   $0x44
  8004e9:	68 b0 39 80 00       	push   $0x8039b0
  8004ee:	e8 1a fe ff ff       	call   80030d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f3:	90                   	nop
  8004f4:	c9                   	leave  
  8004f5:	c3                   	ret    

008004f6 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	8b 00                	mov    (%eax),%eax
  800501:	8d 48 01             	lea    0x1(%eax),%ecx
  800504:	8b 55 0c             	mov    0xc(%ebp),%edx
  800507:	89 0a                	mov    %ecx,(%edx)
  800509:	8b 55 08             	mov    0x8(%ebp),%edx
  80050c:	88 d1                	mov    %dl,%cl
  80050e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800511:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800515:	8b 45 0c             	mov    0xc(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051f:	75 2c                	jne    80054d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800521:	a0 44 50 98 00       	mov    0x985044,%al
  800526:	0f b6 c0             	movzbl %al,%eax
  800529:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052c:	8b 12                	mov    (%edx),%edx
  80052e:	89 d1                	mov    %edx,%ecx
  800530:	8b 55 0c             	mov    0xc(%ebp),%edx
  800533:	83 c2 08             	add    $0x8,%edx
  800536:	83 ec 04             	sub    $0x4,%esp
  800539:	50                   	push   %eax
  80053a:	51                   	push   %ecx
  80053b:	52                   	push   %edx
  80053c:	e8 4e 0e 00 00       	call   80138f <sys_cputs>
  800541:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800544:	8b 45 0c             	mov    0xc(%ebp),%eax
  800547:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800550:	8b 40 04             	mov    0x4(%eax),%eax
  800553:	8d 50 01             	lea    0x1(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055c:	90                   	nop
  80055d:	c9                   	leave  
  80055e:	c3                   	ret    

0080055f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055f:	55                   	push   %ebp
  800560:	89 e5                	mov    %esp,%ebp
  800562:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800568:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056f:	00 00 00 
	b.cnt = 0;
  800572:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800579:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	ff 75 08             	pushl  0x8(%ebp)
  800582:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800588:	50                   	push   %eax
  800589:	68 f6 04 80 00       	push   $0x8004f6
  80058e:	e8 11 02 00 00       	call   8007a4 <vprintfmt>
  800593:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800596:	a0 44 50 98 00       	mov    0x985044,%al
  80059b:	0f b6 c0             	movzbl %al,%eax
  80059e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a4:	83 ec 04             	sub    $0x4,%esp
  8005a7:	50                   	push   %eax
  8005a8:	52                   	push   %edx
  8005a9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005af:	83 c0 08             	add    $0x8,%eax
  8005b2:	50                   	push   %eax
  8005b3:	e8 d7 0d 00 00       	call   80138f <sys_cputs>
  8005b8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005bb:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8005c2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005d0:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8005d7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e6:	50                   	push   %eax
  8005e7:	e8 73 ff ff ff       	call   80055f <vcprintf>
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f5:	c9                   	leave  
  8005f6:	c3                   	ret    

008005f7 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8005fd:	e8 cf 0d 00 00       	call   8013d1 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800602:	8d 45 0c             	lea    0xc(%ebp),%eax
  800605:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	83 ec 08             	sub    $0x8,%esp
  80060e:	ff 75 f4             	pushl  -0xc(%ebp)
  800611:	50                   	push   %eax
  800612:	e8 48 ff ff ff       	call   80055f <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80061d:	e8 c9 0d 00 00       	call   8013eb <sys_unlock_cons>
	return cnt;
  800622:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800625:	c9                   	leave  
  800626:	c3                   	ret    

00800627 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	53                   	push   %ebx
  80062b:	83 ec 14             	sub    $0x14,%esp
  80062e:	8b 45 10             	mov    0x10(%ebp),%eax
  800631:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80063a:	8b 45 18             	mov    0x18(%ebp),%eax
  80063d:	ba 00 00 00 00       	mov    $0x0,%edx
  800642:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800645:	77 55                	ja     80069c <printnum+0x75>
  800647:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80064a:	72 05                	jb     800651 <printnum+0x2a>
  80064c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064f:	77 4b                	ja     80069c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800651:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800654:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800657:	8b 45 18             	mov    0x18(%ebp),%eax
  80065a:	ba 00 00 00 00       	mov    $0x0,%edx
  80065f:	52                   	push   %edx
  800660:	50                   	push   %eax
  800661:	ff 75 f4             	pushl  -0xc(%ebp)
  800664:	ff 75 f0             	pushl  -0x10(%ebp)
  800667:	e8 94 2e 00 00       	call   803500 <__udivdi3>
  80066c:	83 c4 10             	add    $0x10,%esp
  80066f:	83 ec 04             	sub    $0x4,%esp
  800672:	ff 75 20             	pushl  0x20(%ebp)
  800675:	53                   	push   %ebx
  800676:	ff 75 18             	pushl  0x18(%ebp)
  800679:	52                   	push   %edx
  80067a:	50                   	push   %eax
  80067b:	ff 75 0c             	pushl  0xc(%ebp)
  80067e:	ff 75 08             	pushl  0x8(%ebp)
  800681:	e8 a1 ff ff ff       	call   800627 <printnum>
  800686:	83 c4 20             	add    $0x20,%esp
  800689:	eb 1a                	jmp    8006a5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	ff d0                	call   *%eax
  800699:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069c:	ff 4d 1c             	decl   0x1c(%ebp)
  80069f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a3:	7f e6                	jg     80068b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b3:	53                   	push   %ebx
  8006b4:	51                   	push   %ecx
  8006b5:	52                   	push   %edx
  8006b6:	50                   	push   %eax
  8006b7:	e8 54 2f 00 00       	call   803610 <__umoddi3>
  8006bc:	83 c4 10             	add    $0x10,%esp
  8006bf:	05 74 3c 80 00       	add    $0x803c74,%eax
  8006c4:	8a 00                	mov    (%eax),%al
  8006c6:	0f be c0             	movsbl %al,%eax
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	ff 75 0c             	pushl  0xc(%ebp)
  8006cf:	50                   	push   %eax
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	ff d0                	call   *%eax
  8006d5:	83 c4 10             	add    $0x10,%esp
}
  8006d8:	90                   	nop
  8006d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006dc:	c9                   	leave  
  8006dd:	c3                   	ret    

008006de <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006de:	55                   	push   %ebp
  8006df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e5:	7e 1c                	jle    800703 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	8d 50 08             	lea    0x8(%eax),%edx
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	89 10                	mov    %edx,(%eax)
  8006f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	83 e8 08             	sub    $0x8,%eax
  8006fc:	8b 50 04             	mov    0x4(%eax),%edx
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	eb 40                	jmp    800743 <getuint+0x65>
	else if (lflag)
  800703:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800707:	74 1e                	je     800727 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 04             	lea    0x4(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 04             	sub    $0x4,%eax
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	ba 00 00 00 00       	mov    $0x0,%edx
  800725:	eb 1c                	jmp    800743 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	8b 00                	mov    (%eax),%eax
  80072c:	8d 50 04             	lea    0x4(%eax),%edx
  80072f:	8b 45 08             	mov    0x8(%ebp),%eax
  800732:	89 10                	mov    %edx,(%eax)
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	8b 00                	mov    (%eax),%eax
  800739:	83 e8 04             	sub    $0x4,%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800743:	5d                   	pop    %ebp
  800744:	c3                   	ret    

00800745 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800745:	55                   	push   %ebp
  800746:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800748:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074c:	7e 1c                	jle    80076a <getint+0x25>
		return va_arg(*ap, long long);
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	8d 50 08             	lea    0x8(%eax),%edx
  800756:	8b 45 08             	mov    0x8(%ebp),%eax
  800759:	89 10                	mov    %edx,(%eax)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	83 e8 08             	sub    $0x8,%eax
  800763:	8b 50 04             	mov    0x4(%eax),%edx
  800766:	8b 00                	mov    (%eax),%eax
  800768:	eb 38                	jmp    8007a2 <getint+0x5d>
	else if (lflag)
  80076a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076e:	74 1a                	je     80078a <getint+0x45>
		return va_arg(*ap, long);
  800770:	8b 45 08             	mov    0x8(%ebp),%eax
  800773:	8b 00                	mov    (%eax),%eax
  800775:	8d 50 04             	lea    0x4(%eax),%edx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	89 10                	mov    %edx,(%eax)
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	8b 00                	mov    (%eax),%eax
  800782:	83 e8 04             	sub    $0x4,%eax
  800785:	8b 00                	mov    (%eax),%eax
  800787:	99                   	cltd   
  800788:	eb 18                	jmp    8007a2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80078a:	8b 45 08             	mov    0x8(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	8d 50 04             	lea    0x4(%eax),%edx
  800792:	8b 45 08             	mov    0x8(%ebp),%eax
  800795:	89 10                	mov    %edx,(%eax)
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	83 e8 04             	sub    $0x4,%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	99                   	cltd   
}
  8007a2:	5d                   	pop    %ebp
  8007a3:	c3                   	ret    

008007a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a4:	55                   	push   %ebp
  8007a5:	89 e5                	mov    %esp,%ebp
  8007a7:	56                   	push   %esi
  8007a8:	53                   	push   %ebx
  8007a9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ac:	eb 17                	jmp    8007c5 <vprintfmt+0x21>
			if (ch == '\0')
  8007ae:	85 db                	test   %ebx,%ebx
  8007b0:	0f 84 c1 03 00 00    	je     800b77 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	53                   	push   %ebx
  8007bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c0:	ff d0                	call   *%eax
  8007c2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c8:	8d 50 01             	lea    0x1(%eax),%edx
  8007cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ce:	8a 00                	mov    (%eax),%al
  8007d0:	0f b6 d8             	movzbl %al,%ebx
  8007d3:	83 fb 25             	cmp    $0x25,%ebx
  8007d6:	75 d6                	jne    8007ae <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007dc:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007ea:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fb:	8d 50 01             	lea    0x1(%eax),%edx
  8007fe:	89 55 10             	mov    %edx,0x10(%ebp)
  800801:	8a 00                	mov    (%eax),%al
  800803:	0f b6 d8             	movzbl %al,%ebx
  800806:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800809:	83 f8 5b             	cmp    $0x5b,%eax
  80080c:	0f 87 3d 03 00 00    	ja     800b4f <vprintfmt+0x3ab>
  800812:	8b 04 85 98 3c 80 00 	mov    0x803c98(,%eax,4),%eax
  800819:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081f:	eb d7                	jmp    8007f8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800821:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800825:	eb d1                	jmp    8007f8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800831:	89 d0                	mov    %edx,%eax
  800833:	c1 e0 02             	shl    $0x2,%eax
  800836:	01 d0                	add    %edx,%eax
  800838:	01 c0                	add    %eax,%eax
  80083a:	01 d8                	add    %ebx,%eax
  80083c:	83 e8 30             	sub    $0x30,%eax
  80083f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800842:	8b 45 10             	mov    0x10(%ebp),%eax
  800845:	8a 00                	mov    (%eax),%al
  800847:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80084a:	83 fb 2f             	cmp    $0x2f,%ebx
  80084d:	7e 3e                	jle    80088d <vprintfmt+0xe9>
  80084f:	83 fb 39             	cmp    $0x39,%ebx
  800852:	7f 39                	jg     80088d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800854:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800857:	eb d5                	jmp    80082e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086d:	eb 1f                	jmp    80088e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800873:	79 83                	jns    8007f8 <vprintfmt+0x54>
				width = 0;
  800875:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087c:	e9 77 ff ff ff       	jmp    8007f8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800881:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800888:	e9 6b ff ff ff       	jmp    8007f8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	0f 89 60 ff ff ff    	jns    8007f8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a5:	e9 4e ff ff ff       	jmp    8007f8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008aa:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ad:	e9 46 ff ff ff       	jmp    8007f8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b5:	83 c0 04             	add    $0x4,%eax
  8008b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008be:	83 e8 04             	sub    $0x4,%eax
  8008c1:	8b 00                	mov    (%eax),%eax
  8008c3:	83 ec 08             	sub    $0x8,%esp
  8008c6:	ff 75 0c             	pushl  0xc(%ebp)
  8008c9:	50                   	push   %eax
  8008ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cd:	ff d0                	call   *%eax
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 9b 02 00 00       	jmp    800b72 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e8:	85 db                	test   %ebx,%ebx
  8008ea:	79 02                	jns    8008ee <vprintfmt+0x14a>
				err = -err;
  8008ec:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ee:	83 fb 64             	cmp    $0x64,%ebx
  8008f1:	7f 0b                	jg     8008fe <vprintfmt+0x15a>
  8008f3:	8b 34 9d e0 3a 80 00 	mov    0x803ae0(,%ebx,4),%esi
  8008fa:	85 f6                	test   %esi,%esi
  8008fc:	75 19                	jne    800917 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fe:	53                   	push   %ebx
  8008ff:	68 85 3c 80 00       	push   $0x803c85
  800904:	ff 75 0c             	pushl  0xc(%ebp)
  800907:	ff 75 08             	pushl  0x8(%ebp)
  80090a:	e8 70 02 00 00       	call   800b7f <printfmt>
  80090f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800912:	e9 5b 02 00 00       	jmp    800b72 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800917:	56                   	push   %esi
  800918:	68 8e 3c 80 00       	push   $0x803c8e
  80091d:	ff 75 0c             	pushl  0xc(%ebp)
  800920:	ff 75 08             	pushl  0x8(%ebp)
  800923:	e8 57 02 00 00       	call   800b7f <printfmt>
  800928:	83 c4 10             	add    $0x10,%esp
			break;
  80092b:	e9 42 02 00 00       	jmp    800b72 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	83 c0 04             	add    $0x4,%eax
  800936:	89 45 14             	mov    %eax,0x14(%ebp)
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 e8 04             	sub    $0x4,%eax
  80093f:	8b 30                	mov    (%eax),%esi
  800941:	85 f6                	test   %esi,%esi
  800943:	75 05                	jne    80094a <vprintfmt+0x1a6>
				p = "(null)";
  800945:	be 91 3c 80 00       	mov    $0x803c91,%esi
			if (width > 0 && padc != '-')
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7e 6d                	jle    8009bd <vprintfmt+0x219>
  800950:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800954:	74 67                	je     8009bd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800956:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800959:	83 ec 08             	sub    $0x8,%esp
  80095c:	50                   	push   %eax
  80095d:	56                   	push   %esi
  80095e:	e8 1e 03 00 00       	call   800c81 <strnlen>
  800963:	83 c4 10             	add    $0x10,%esp
  800966:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800969:	eb 16                	jmp    800981 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096f:	83 ec 08             	sub    $0x8,%esp
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	50                   	push   %eax
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	ff d0                	call   *%eax
  80097b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097e:	ff 4d e4             	decl   -0x1c(%ebp)
  800981:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800985:	7f e4                	jg     80096b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800987:	eb 34                	jmp    8009bd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800989:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098d:	74 1c                	je     8009ab <vprintfmt+0x207>
  80098f:	83 fb 1f             	cmp    $0x1f,%ebx
  800992:	7e 05                	jle    800999 <vprintfmt+0x1f5>
  800994:	83 fb 7e             	cmp    $0x7e,%ebx
  800997:	7e 12                	jle    8009ab <vprintfmt+0x207>
					putch('?', putdat);
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 0c             	pushl  0xc(%ebp)
  80099f:	6a 3f                	push   $0x3f
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	ff d0                	call   *%eax
  8009a6:	83 c4 10             	add    $0x10,%esp
  8009a9:	eb 0f                	jmp    8009ba <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 0c             	pushl  0xc(%ebp)
  8009b1:	53                   	push   %ebx
  8009b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b5:	ff d0                	call   *%eax
  8009b7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bd:	89 f0                	mov    %esi,%eax
  8009bf:	8d 70 01             	lea    0x1(%eax),%esi
  8009c2:	8a 00                	mov    (%eax),%al
  8009c4:	0f be d8             	movsbl %al,%ebx
  8009c7:	85 db                	test   %ebx,%ebx
  8009c9:	74 24                	je     8009ef <vprintfmt+0x24b>
  8009cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009cf:	78 b8                	js     800989 <vprintfmt+0x1e5>
  8009d1:	ff 4d e0             	decl   -0x20(%ebp)
  8009d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d8:	79 af                	jns    800989 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009da:	eb 13                	jmp    8009ef <vprintfmt+0x24b>
				putch(' ', putdat);
  8009dc:	83 ec 08             	sub    $0x8,%esp
  8009df:	ff 75 0c             	pushl  0xc(%ebp)
  8009e2:	6a 20                	push   $0x20
  8009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e7:	ff d0                	call   *%eax
  8009e9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ec:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f3:	7f e7                	jg     8009dc <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f5:	e9 78 01 00 00       	jmp    800b72 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009fa:	83 ec 08             	sub    $0x8,%esp
  8009fd:	ff 75 e8             	pushl  -0x18(%ebp)
  800a00:	8d 45 14             	lea    0x14(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	e8 3c fd ff ff       	call   800745 <getint>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a18:	85 d2                	test   %edx,%edx
  800a1a:	79 23                	jns    800a3f <vprintfmt+0x29b>
				putch('-', putdat);
  800a1c:	83 ec 08             	sub    $0x8,%esp
  800a1f:	ff 75 0c             	pushl  0xc(%ebp)
  800a22:	6a 2d                	push   $0x2d
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	ff d0                	call   *%eax
  800a29:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a32:	f7 d8                	neg    %eax
  800a34:	83 d2 00             	adc    $0x0,%edx
  800a37:	f7 da                	neg    %edx
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a51:	8d 45 14             	lea    0x14(%ebp),%eax
  800a54:	50                   	push   %eax
  800a55:	e8 84 fc ff ff       	call   8006de <getuint>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a60:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a63:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a6a:	e9 98 00 00 00       	jmp    800b07 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 58                	push   $0x58
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			break;
  800a9f:	e9 ce 00 00 00       	jmp    800b72 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa4:	83 ec 08             	sub    $0x8,%esp
  800aa7:	ff 75 0c             	pushl  0xc(%ebp)
  800aaa:	6a 30                	push   $0x30
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	ff d0                	call   *%eax
  800ab1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 78                	push   $0x78
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac7:	83 c0 04             	add    $0x4,%eax
  800aca:	89 45 14             	mov    %eax,0x14(%ebp)
  800acd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad0:	83 e8 04             	sub    $0x4,%eax
  800ad3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800adf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae6:	eb 1f                	jmp    800b07 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae8:	83 ec 08             	sub    $0x8,%esp
  800aeb:	ff 75 e8             	pushl  -0x18(%ebp)
  800aee:	8d 45 14             	lea    0x14(%ebp),%eax
  800af1:	50                   	push   %eax
  800af2:	e8 e7 fb ff ff       	call   8006de <getuint>
  800af7:	83 c4 10             	add    $0x10,%esp
  800afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b00:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b07:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0e:	83 ec 04             	sub    $0x4,%esp
  800b11:	52                   	push   %edx
  800b12:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b15:	50                   	push   %eax
  800b16:	ff 75 f4             	pushl  -0xc(%ebp)
  800b19:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1c:	ff 75 0c             	pushl  0xc(%ebp)
  800b1f:	ff 75 08             	pushl  0x8(%ebp)
  800b22:	e8 00 fb ff ff       	call   800627 <printnum>
  800b27:	83 c4 20             	add    $0x20,%esp
			break;
  800b2a:	eb 46                	jmp    800b72 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2c:	83 ec 08             	sub    $0x8,%esp
  800b2f:	ff 75 0c             	pushl  0xc(%ebp)
  800b32:	53                   	push   %ebx
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			break;
  800b3b:	eb 35                	jmp    800b72 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b3d:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800b44:	eb 2c                	jmp    800b72 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b46:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800b4d:	eb 23                	jmp    800b72 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 25                	push   $0x25
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5f:	ff 4d 10             	decl   0x10(%ebp)
  800b62:	eb 03                	jmp    800b67 <vprintfmt+0x3c3>
  800b64:	ff 4d 10             	decl   0x10(%ebp)
  800b67:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6a:	48                   	dec    %eax
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	3c 25                	cmp    $0x25,%al
  800b6f:	75 f3                	jne    800b64 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b71:	90                   	nop
		}
	}
  800b72:	e9 35 fc ff ff       	jmp    8007ac <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b77:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b7b:	5b                   	pop    %ebx
  800b7c:	5e                   	pop    %esi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b85:	8d 45 10             	lea    0x10(%ebp),%eax
  800b88:	83 c0 04             	add    $0x4,%eax
  800b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	ff 75 f4             	pushl  -0xc(%ebp)
  800b94:	50                   	push   %eax
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	ff 75 08             	pushl  0x8(%ebp)
  800b9b:	e8 04 fc ff ff       	call   8007a4 <vprintfmt>
  800ba0:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba3:	90                   	nop
  800ba4:	c9                   	leave  
  800ba5:	c3                   	ret    

00800ba6 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8b 40 08             	mov    0x8(%eax),%eax
  800baf:	8d 50 01             	lea    0x1(%eax),%edx
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbb:	8b 10                	mov    (%eax),%edx
  800bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc0:	8b 40 04             	mov    0x4(%eax),%eax
  800bc3:	39 c2                	cmp    %eax,%edx
  800bc5:	73 12                	jae    800bd9 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bca:	8b 00                	mov    (%eax),%eax
  800bcc:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd2:	89 0a                	mov    %ecx,(%edx)
  800bd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd7:	88 10                	mov    %dl,(%eax)
}
  800bd9:	90                   	nop
  800bda:	5d                   	pop    %ebp
  800bdb:	c3                   	ret    

00800bdc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800beb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	01 d0                	add    %edx,%eax
  800bf3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c01:	74 06                	je     800c09 <vsnprintf+0x2d>
  800c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c07:	7f 07                	jg     800c10 <vsnprintf+0x34>
		return -E_INVAL;
  800c09:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0e:	eb 20                	jmp    800c30 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c10:	ff 75 14             	pushl  0x14(%ebp)
  800c13:	ff 75 10             	pushl  0x10(%ebp)
  800c16:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c19:	50                   	push   %eax
  800c1a:	68 a6 0b 80 00       	push   $0x800ba6
  800c1f:	e8 80 fb ff ff       	call   8007a4 <vprintfmt>
  800c24:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c38:	8d 45 10             	lea    0x10(%ebp),%eax
  800c3b:	83 c0 04             	add    $0x4,%eax
  800c3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c41:	8b 45 10             	mov    0x10(%ebp),%eax
  800c44:	ff 75 f4             	pushl  -0xc(%ebp)
  800c47:	50                   	push   %eax
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	ff 75 08             	pushl  0x8(%ebp)
  800c4e:	e8 89 ff ff ff       	call   800bdc <vsnprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
  800c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c6b:	eb 06                	jmp    800c73 <strlen+0x15>
		n++;
  800c6d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c70:	ff 45 08             	incl   0x8(%ebp)
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 f1                	jne    800c6d <strlen+0xf>
		n++;
	return n;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8e:	eb 09                	jmp    800c99 <strnlen+0x18>
		n++;
  800c90:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c93:	ff 45 08             	incl   0x8(%ebp)
  800c96:	ff 4d 0c             	decl   0xc(%ebp)
  800c99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9d:	74 09                	je     800ca8 <strnlen+0x27>
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	84 c0                	test   %al,%al
  800ca6:	75 e8                	jne    800c90 <strnlen+0xf>
		n++;
	return n;
  800ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cab:	c9                   	leave  
  800cac:	c3                   	ret    

00800cad <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cad:	55                   	push   %ebp
  800cae:	89 e5                	mov    %esp,%ebp
  800cb0:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb9:	90                   	nop
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
  800cd0:	8a 00                	mov    (%eax),%al
  800cd2:	84 c0                	test   %al,%al
  800cd4:	75 e4                	jne    800cba <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd9:	c9                   	leave  
  800cda:	c3                   	ret    

00800cdb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cee:	eb 1f                	jmp    800d0f <strncpy+0x34>
		*dst++ = *src;
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	8d 50 01             	lea    0x1(%eax),%edx
  800cf6:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfc:	8a 12                	mov    (%edx),%dl
  800cfe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	8a 00                	mov    (%eax),%al
  800d05:	84 c0                	test   %al,%al
  800d07:	74 03                	je     800d0c <strncpy+0x31>
			src++;
  800d09:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d12:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d15:	72 d9                	jb     800cf0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d1a:	c9                   	leave  
  800d1b:	c3                   	ret    

00800d1c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2c:	74 30                	je     800d5e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2e:	eb 16                	jmp    800d46 <strlcpy+0x2a>
			*dst++ = *src++;
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8d 50 01             	lea    0x1(%eax),%edx
  800d36:	89 55 08             	mov    %edx,0x8(%ebp)
  800d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d46:	ff 4d 10             	decl   0x10(%ebp)
  800d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4d:	74 09                	je     800d58 <strlcpy+0x3c>
  800d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d52:	8a 00                	mov    (%eax),%al
  800d54:	84 c0                	test   %al,%al
  800d56:	75 d8                	jne    800d30 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d64:	29 c2                	sub    %eax,%edx
  800d66:	89 d0                	mov    %edx,%eax
}
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6d:	eb 06                	jmp    800d75 <strcmp+0xb>
		p++, q++;
  800d6f:	ff 45 08             	incl   0x8(%ebp)
  800d72:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 0e                	je     800d8c <strcmp+0x22>
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 10                	mov    (%eax),%dl
  800d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	38 c2                	cmp    %al,%dl
  800d8a:	74 e3                	je     800d6f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d0             	movzbl %al,%edx
  800d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	0f b6 c0             	movzbl %al,%eax
  800d9c:	29 c2                	sub    %eax,%edx
  800d9e:	89 d0                	mov    %edx,%eax
}
  800da0:	5d                   	pop    %ebp
  800da1:	c3                   	ret    

00800da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da5:	eb 09                	jmp    800db0 <strncmp+0xe>
		n--, p++, q++;
  800da7:	ff 4d 10             	decl   0x10(%ebp)
  800daa:	ff 45 08             	incl   0x8(%ebp)
  800dad:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800db0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db4:	74 17                	je     800dcd <strncmp+0x2b>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	74 0e                	je     800dcd <strncmp+0x2b>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 10                	mov    (%eax),%dl
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	38 c2                	cmp    %al,%dl
  800dcb:	74 da                	je     800da7 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd1:	75 07                	jne    800dda <strncmp+0x38>
		return 0;
  800dd3:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd8:	eb 14                	jmp    800dee <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 d0             	movzbl %al,%edx
  800de2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 c0             	movzbl %al,%eax
  800dea:	29 c2                	sub    %eax,%edx
  800dec:	89 d0                	mov    %edx,%eax
}
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 04             	sub    $0x4,%esp
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfc:	eb 12                	jmp    800e10 <strchr+0x20>
		if (*s == c)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e06:	75 05                	jne    800e0d <strchr+0x1d>
			return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	eb 11                	jmp    800e1e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0d:	ff 45 08             	incl   0x8(%ebp)
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e5                	jne    800dfe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 04             	sub    $0x4,%esp
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2c:	eb 0d                	jmp    800e3b <strfind+0x1b>
		if (*s == c)
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e36:	74 0e                	je     800e46 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e38:	ff 45 08             	incl   0x8(%ebp)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	84 c0                	test   %al,%al
  800e42:	75 ea                	jne    800e2e <strfind+0xe>
  800e44:	eb 01                	jmp    800e47 <strfind+0x27>
		if (*s == c)
			break;
  800e46:	90                   	nop
	return (char *) s;
  800e47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e58:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5e:	eb 0e                	jmp    800e6e <memset+0x22>
		*p++ = c;
  800e60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e63:	8d 50 01             	lea    0x1(%eax),%edx
  800e66:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6e:	ff 4d f8             	decl   -0x8(%ebp)
  800e71:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e75:	79 e9                	jns    800e60 <memset+0x14>
		*p++ = c;

	return v;
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7a:	c9                   	leave  
  800e7b:	c3                   	ret    

00800e7c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8e:	eb 16                	jmp    800ea6 <memcpy+0x2a>
		*d++ = *s++;
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	8d 50 01             	lea    0x1(%eax),%edx
  800e96:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e99:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea2:	8a 12                	mov    (%edx),%dl
  800ea4:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 dd                	jne    800e90 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ed0:	73 50                	jae    800f22 <memmove+0x6a>
  800ed2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed8:	01 d0                	add    %edx,%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	76 43                	jbe    800f22 <memmove+0x6a>
		s += n;
  800edf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eeb:	eb 10                	jmp    800efd <memmove+0x45>
			*--d = *--s;
  800eed:	ff 4d f8             	decl   -0x8(%ebp)
  800ef0:	ff 4d fc             	decl   -0x4(%ebp)
  800ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef6:	8a 10                	mov    (%eax),%dl
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efd:	8b 45 10             	mov    0x10(%ebp),%eax
  800f00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f03:	89 55 10             	mov    %edx,0x10(%ebp)
  800f06:	85 c0                	test   %eax,%eax
  800f08:	75 e3                	jne    800eed <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f0a:	eb 23                	jmp    800f2f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	8d 50 01             	lea    0x1(%eax),%edx
  800f12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f18:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f1b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f22:	8b 45 10             	mov    0x10(%ebp),%eax
  800f25:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f28:	89 55 10             	mov    %edx,0x10(%ebp)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	75 dd                	jne    800f0c <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f43:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f46:	eb 2a                	jmp    800f72 <memcmp+0x3e>
		if (*s1 != *s2)
  800f48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 16                	je     800f6c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f56:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
  800f6a:	eb 18                	jmp    800f84 <memcmp+0x50>
		s1++, s2++;
  800f6c:	ff 45 fc             	incl   -0x4(%ebp)
  800f6f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 c9                	jne    800f48 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f84:	c9                   	leave  
  800f85:	c3                   	ret    

00800f86 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f92:	01 d0                	add    %edx,%eax
  800f94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f97:	eb 15                	jmp    800fae <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	0f b6 d0             	movzbl %al,%edx
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	0f b6 c0             	movzbl %al,%eax
  800fa7:	39 c2                	cmp    %eax,%edx
  800fa9:	74 0d                	je     800fb8 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fab:	ff 45 08             	incl   0x8(%ebp)
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb4:	72 e3                	jb     800f99 <memfind+0x13>
  800fb6:	eb 01                	jmp    800fb9 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb8:	90                   	nop
	return (void *) s;
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbc:	c9                   	leave  
  800fbd:	c3                   	ret    

00800fbe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fcb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd2:	eb 03                	jmp    800fd7 <strtol+0x19>
		s++;
  800fd4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 20                	cmp    $0x20,%al
  800fde:	74 f4                	je     800fd4 <strtol+0x16>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 09                	cmp    $0x9,%al
  800fe7:	74 eb                	je     800fd4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	3c 2b                	cmp    $0x2b,%al
  800ff0:	75 05                	jne    800ff7 <strtol+0x39>
		s++;
  800ff2:	ff 45 08             	incl   0x8(%ebp)
  800ff5:	eb 13                	jmp    80100a <strtol+0x4c>
	else if (*s == '-')
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	8a 00                	mov    (%eax),%al
  800ffc:	3c 2d                	cmp    $0x2d,%al
  800ffe:	75 0a                	jne    80100a <strtol+0x4c>
		s++, neg = 1;
  801000:	ff 45 08             	incl   0x8(%ebp)
  801003:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80100a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100e:	74 06                	je     801016 <strtol+0x58>
  801010:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801014:	75 20                	jne    801036 <strtol+0x78>
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	3c 30                	cmp    $0x30,%al
  80101d:	75 17                	jne    801036 <strtol+0x78>
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	40                   	inc    %eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3c 78                	cmp    $0x78,%al
  801027:	75 0d                	jne    801036 <strtol+0x78>
		s += 2, base = 16;
  801029:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801034:	eb 28                	jmp    80105e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801036:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103a:	75 15                	jne    801051 <strtol+0x93>
  80103c:	8b 45 08             	mov    0x8(%ebp),%eax
  80103f:	8a 00                	mov    (%eax),%al
  801041:	3c 30                	cmp    $0x30,%al
  801043:	75 0c                	jne    801051 <strtol+0x93>
		s++, base = 8;
  801045:	ff 45 08             	incl   0x8(%ebp)
  801048:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104f:	eb 0d                	jmp    80105e <strtol+0xa0>
	else if (base == 0)
  801051:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801055:	75 07                	jne    80105e <strtol+0xa0>
		base = 10;
  801057:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2f                	cmp    $0x2f,%al
  801065:	7e 19                	jle    801080 <strtol+0xc2>
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	8a 00                	mov    (%eax),%al
  80106c:	3c 39                	cmp    $0x39,%al
  80106e:	7f 10                	jg     801080 <strtol+0xc2>
			dig = *s - '0';
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	0f be c0             	movsbl %al,%eax
  801078:	83 e8 30             	sub    $0x30,%eax
  80107b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107e:	eb 42                	jmp    8010c2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	8a 00                	mov    (%eax),%al
  801085:	3c 60                	cmp    $0x60,%al
  801087:	7e 19                	jle    8010a2 <strtol+0xe4>
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8a 00                	mov    (%eax),%al
  80108e:	3c 7a                	cmp    $0x7a,%al
  801090:	7f 10                	jg     8010a2 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	0f be c0             	movsbl %al,%eax
  80109a:	83 e8 57             	sub    $0x57,%eax
  80109d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010a0:	eb 20                	jmp    8010c2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	8a 00                	mov    (%eax),%al
  8010a7:	3c 40                	cmp    $0x40,%al
  8010a9:	7e 39                	jle    8010e4 <strtol+0x126>
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 5a                	cmp    $0x5a,%al
  8010b2:	7f 30                	jg     8010e4 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	0f be c0             	movsbl %al,%eax
  8010bc:	83 e8 37             	sub    $0x37,%eax
  8010bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c8:	7d 19                	jge    8010e3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010ca:	ff 45 08             	incl   0x8(%ebp)
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d4:	89 c2                	mov    %eax,%edx
  8010d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d9:	01 d0                	add    %edx,%eax
  8010db:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010de:	e9 7b ff ff ff       	jmp    80105e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e8:	74 08                	je     8010f2 <strtol+0x134>
		*endptr = (char *) s;
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 07                	je     8010ff <strtol+0x141>
  8010f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fb:	f7 d8                	neg    %eax
  8010fd:	eb 03                	jmp    801102 <strtol+0x144>
  8010ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801102:	c9                   	leave  
  801103:	c3                   	ret    

00801104 <ltostr>:

void
ltostr(long value, char *str)
{
  801104:	55                   	push   %ebp
  801105:	89 e5                	mov    %esp,%ebp
  801107:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80110a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801111:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801118:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111c:	79 13                	jns    801131 <ltostr+0x2d>
	{
		neg = 1;
  80111e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80112b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801139:	99                   	cltd   
  80113a:	f7 f9                	idiv   %ecx
  80113c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	83 c2 30             	add    $0x30,%edx
  801155:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801157:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80115a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115f:	f7 e9                	imul   %ecx
  801161:	c1 fa 02             	sar    $0x2,%edx
  801164:	89 c8                	mov    %ecx,%eax
  801166:	c1 f8 1f             	sar    $0x1f,%eax
  801169:	29 c2                	sub    %eax,%edx
  80116b:	89 d0                	mov    %edx,%eax
  80116d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  801170:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801174:	75 bb                	jne    801131 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801176:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801180:	48                   	dec    %eax
  801181:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801184:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801188:	74 3d                	je     8011c7 <ltostr+0xc3>
		start = 1 ;
  80118a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801191:	eb 34                	jmp    8011c7 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  801193:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	01 d0                	add    %edx,%eax
  80119b:	8a 00                	mov    (%eax),%al
  80119d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c2                	add    %eax,%edx
  8011a8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	01 c8                	add    %ecx,%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011bf:	88 02                	mov    %al,(%edx)
		start++ ;
  8011c1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011c4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ca:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cd:	7c c4                	jl     801193 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011da:	90                   	nop
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011e3:	ff 75 08             	pushl  0x8(%ebp)
  8011e6:	e8 73 fa ff ff       	call   800c5e <strlen>
  8011eb:	83 c4 04             	add    $0x4,%esp
  8011ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011f1:	ff 75 0c             	pushl  0xc(%ebp)
  8011f4:	e8 65 fa ff ff       	call   800c5e <strlen>
  8011f9:	83 c4 04             	add    $0x4,%esp
  8011fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801206:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80120d:	eb 17                	jmp    801226 <strcconcat+0x49>
		final[s] = str1[s] ;
  80120f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 c2                	add    %eax,%edx
  801217:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	01 c8                	add    %ecx,%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801223:	ff 45 fc             	incl   -0x4(%ebp)
  801226:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801229:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80122c:	7c e1                	jl     80120f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80122e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801235:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80123c:	eb 1f                	jmp    80125d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80123e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801241:	8d 50 01             	lea    0x1(%eax),%edx
  801244:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801247:	89 c2                	mov    %eax,%edx
  801249:	8b 45 10             	mov    0x10(%ebp),%eax
  80124c:	01 c2                	add    %eax,%edx
  80124e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801251:	8b 45 0c             	mov    0xc(%ebp),%eax
  801254:	01 c8                	add    %ecx,%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80125a:	ff 45 f8             	incl   -0x8(%ebp)
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801263:	7c d9                	jl     80123e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801265:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801268:	8b 45 10             	mov    0x10(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	c6 00 00             	movb   $0x0,(%eax)
}
  801270:	90                   	nop
  801271:	c9                   	leave  
  801272:	c3                   	ret    

00801273 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801273:	55                   	push   %ebp
  801274:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801276:	8b 45 14             	mov    0x14(%ebp),%eax
  801279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80127f:	8b 45 14             	mov    0x14(%ebp),%eax
  801282:	8b 00                	mov    (%eax),%eax
  801284:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80128b:	8b 45 10             	mov    0x10(%ebp),%eax
  80128e:	01 d0                	add    %edx,%eax
  801290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801296:	eb 0c                	jmp    8012a4 <strsplit+0x31>
			*string++ = 0;
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8d 50 01             	lea    0x1(%eax),%edx
  80129e:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8a 00                	mov    (%eax),%al
  8012a9:	84 c0                	test   %al,%al
  8012ab:	74 18                	je     8012c5 <strsplit+0x52>
  8012ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b0:	8a 00                	mov    (%eax),%al
  8012b2:	0f be c0             	movsbl %al,%eax
  8012b5:	50                   	push   %eax
  8012b6:	ff 75 0c             	pushl  0xc(%ebp)
  8012b9:	e8 32 fb ff ff       	call   800df0 <strchr>
  8012be:	83 c4 08             	add    $0x8,%esp
  8012c1:	85 c0                	test   %eax,%eax
  8012c3:	75 d3                	jne    801298 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	8a 00                	mov    (%eax),%al
  8012ca:	84 c0                	test   %al,%al
  8012cc:	74 5a                	je     801328 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d1:	8b 00                	mov    (%eax),%eax
  8012d3:	83 f8 0f             	cmp    $0xf,%eax
  8012d6:	75 07                	jne    8012df <strsplit+0x6c>
		{
			return 0;
  8012d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012dd:	eb 66                	jmp    801345 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012df:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e2:	8b 00                	mov    (%eax),%eax
  8012e4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012e7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ea:	89 0a                	mov    %ecx,(%edx)
  8012ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	01 c2                	add    %eax,%edx
  8012f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fb:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012fd:	eb 03                	jmp    801302 <strsplit+0x8f>
			string++;
  8012ff:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	8a 00                	mov    (%eax),%al
  801307:	84 c0                	test   %al,%al
  801309:	74 8b                	je     801296 <strsplit+0x23>
  80130b:	8b 45 08             	mov    0x8(%ebp),%eax
  80130e:	8a 00                	mov    (%eax),%al
  801310:	0f be c0             	movsbl %al,%eax
  801313:	50                   	push   %eax
  801314:	ff 75 0c             	pushl  0xc(%ebp)
  801317:	e8 d4 fa ff ff       	call   800df0 <strchr>
  80131c:	83 c4 08             	add    $0x8,%esp
  80131f:	85 c0                	test   %eax,%eax
  801321:	74 dc                	je     8012ff <strsplit+0x8c>
			string++;
	}
  801323:	e9 6e ff ff ff       	jmp    801296 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801328:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801329:	8b 45 14             	mov    0x14(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801335:	8b 45 10             	mov    0x10(%ebp),%eax
  801338:	01 d0                	add    %edx,%eax
  80133a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801340:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
  80134a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80134d:	83 ec 04             	sub    $0x4,%esp
  801350:	68 08 3e 80 00       	push   $0x803e08
  801355:	68 3f 01 00 00       	push   $0x13f
  80135a:	68 2a 3e 80 00       	push   $0x803e2a
  80135f:	e8 a9 ef ff ff       	call   80030d <_panic>

00801364 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	57                   	push   %edi
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
  80136a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	8b 55 0c             	mov    0xc(%ebp),%edx
  801373:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801376:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801379:	8b 7d 18             	mov    0x18(%ebp),%edi
  80137c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80137f:	cd 30                	int    $0x30
  801381:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	5b                   	pop    %ebx
  80138b:	5e                   	pop    %esi
  80138c:	5f                   	pop    %edi
  80138d:	5d                   	pop    %ebp
  80138e:	c3                   	ret    

0080138f <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80139b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	52                   	push   %edx
  8013a7:	ff 75 0c             	pushl  0xc(%ebp)
  8013aa:	50                   	push   %eax
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 b2 ff ff ff       	call   801364 <syscall>
  8013b2:	83 c4 18             	add    $0x18,%esp
}
  8013b5:	90                   	nop
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    

008013b8 <sys_cgetc>:

int sys_cgetc(void) {
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 00                	push   $0x0
  8013c5:	6a 02                	push   $0x2
  8013c7:	e8 98 ff ff ff       	call   801364 <syscall>
  8013cc:	83 c4 18             	add    $0x18,%esp
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <sys_lock_cons>:

void sys_lock_cons(void) {
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 00                	push   $0x0
  8013de:	6a 03                	push   $0x3
  8013e0:	e8 7f ff ff ff       	call   801364 <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
}
  8013e8:	90                   	nop
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8013ee:	6a 00                	push   $0x0
  8013f0:	6a 00                	push   $0x0
  8013f2:	6a 00                	push   $0x0
  8013f4:	6a 00                	push   $0x0
  8013f6:	6a 00                	push   $0x0
  8013f8:	6a 04                	push   $0x4
  8013fa:	e8 65 ff ff ff       	call   801364 <syscall>
  8013ff:	83 c4 18             	add    $0x18,%esp
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801408:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	6a 00                	push   $0x0
  801410:	6a 00                	push   $0x0
  801412:	6a 00                	push   $0x0
  801414:	52                   	push   %edx
  801415:	50                   	push   %eax
  801416:	6a 08                	push   $0x8
  801418:	e8 47 ff ff ff       	call   801364 <syscall>
  80141d:	83 c4 18             	add    $0x18,%esp
}
  801420:	c9                   	leave  
  801421:	c3                   	ret    

00801422 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	56                   	push   %esi
  801426:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801427:	8b 75 18             	mov    0x18(%ebp),%esi
  80142a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80142d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801430:	8b 55 0c             	mov    0xc(%ebp),%edx
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	56                   	push   %esi
  801437:	53                   	push   %ebx
  801438:	51                   	push   %ecx
  801439:	52                   	push   %edx
  80143a:	50                   	push   %eax
  80143b:	6a 09                	push   $0x9
  80143d:	e8 22 ff ff ff       	call   801364 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801445:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801448:	5b                   	pop    %ebx
  801449:	5e                   	pop    %esi
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80144f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	6a 00                	push   $0x0
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	52                   	push   %edx
  80145c:	50                   	push   %eax
  80145d:	6a 0a                	push   $0xa
  80145f:	e8 00 ff ff ff       	call   801364 <syscall>
  801464:	83 c4 18             	add    $0x18,%esp
}
  801467:	c9                   	leave  
  801468:	c3                   	ret    

00801469 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801469:	55                   	push   %ebp
  80146a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80146c:	6a 00                	push   $0x0
  80146e:	6a 00                	push   $0x0
  801470:	6a 00                	push   $0x0
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	ff 75 08             	pushl  0x8(%ebp)
  801478:	6a 0b                	push   $0xb
  80147a:	e8 e5 fe ff ff       	call   801364 <syscall>
  80147f:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 0c                	push   $0xc
  801493:	e8 cc fe ff ff       	call   801364 <syscall>
  801498:	83 c4 18             	add    $0x18,%esp
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 0d                	push   $0xd
  8014ac:	e8 b3 fe ff ff       	call   801364 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
}
  8014b4:	c9                   	leave  
  8014b5:	c3                   	ret    

008014b6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8014b6:	55                   	push   %ebp
  8014b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8014b9:	6a 00                	push   $0x0
  8014bb:	6a 00                	push   $0x0
  8014bd:	6a 00                	push   $0x0
  8014bf:	6a 00                	push   $0x0
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 0e                	push   $0xe
  8014c5:	e8 9a fe ff ff       	call   801364 <syscall>
  8014ca:	83 c4 18             	add    $0x18,%esp
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8014d2:	6a 00                	push   $0x0
  8014d4:	6a 00                	push   $0x0
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 0f                	push   $0xf
  8014de:	e8 81 fe ff ff       	call   801364 <syscall>
  8014e3:	83 c4 18             	add    $0x18,%esp
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 00                	push   $0x0
  8014f3:	ff 75 08             	pushl  0x8(%ebp)
  8014f6:	6a 10                	push   $0x10
  8014f8:	e8 67 fe ff ff       	call   801364 <syscall>
  8014fd:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <sys_scarce_memory>:

void sys_scarce_memory() {
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801505:	6a 00                	push   $0x0
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 11                	push   $0x11
  801511:	e8 4e fe ff ff       	call   801364 <syscall>
  801516:	83 c4 18             	add    $0x18,%esp
}
  801519:	90                   	nop
  80151a:	c9                   	leave  
  80151b:	c3                   	ret    

0080151c <sys_cputc>:

void sys_cputc(const char c) {
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801528:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	6a 00                	push   $0x0
  801532:	6a 00                	push   $0x0
  801534:	50                   	push   %eax
  801535:	6a 01                	push   $0x1
  801537:	e8 28 fe ff ff       	call   801364 <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
}
  80153f:	90                   	nop
  801540:	c9                   	leave  
  801541:	c3                   	ret    

00801542 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801542:	55                   	push   %ebp
  801543:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801545:	6a 00                	push   $0x0
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 14                	push   $0x14
  801551:	e8 0e fe ff ff       	call   801364 <syscall>
  801556:	83 c4 18             	add    $0x18,%esp
}
  801559:	90                   	nop
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	8b 45 10             	mov    0x10(%ebp),%eax
  801565:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801568:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80156b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	6a 00                	push   $0x0
  801574:	51                   	push   %ecx
  801575:	52                   	push   %edx
  801576:	ff 75 0c             	pushl  0xc(%ebp)
  801579:	50                   	push   %eax
  80157a:	6a 15                	push   $0x15
  80157c:	e8 e3 fd ff ff       	call   801364 <syscall>
  801581:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801584:	c9                   	leave  
  801585:	c3                   	ret    

00801586 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	6a 00                	push   $0x0
  801591:	6a 00                	push   $0x0
  801593:	6a 00                	push   $0x0
  801595:	52                   	push   %edx
  801596:	50                   	push   %eax
  801597:	6a 16                	push   $0x16
  801599:	e8 c6 fd ff ff       	call   801364 <syscall>
  80159e:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8015a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	51                   	push   %ecx
  8015b4:	52                   	push   %edx
  8015b5:	50                   	push   %eax
  8015b6:	6a 17                	push   $0x17
  8015b8:	e8 a7 fd ff ff       	call   801364 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8015c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	52                   	push   %edx
  8015d2:	50                   	push   %eax
  8015d3:	6a 18                	push   $0x18
  8015d5:	e8 8a fd ff ff       	call   801364 <syscall>
  8015da:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8015dd:	c9                   	leave  
  8015de:	c3                   	ret    

008015df <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8015df:	55                   	push   %ebp
  8015e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	6a 00                	push   $0x0
  8015e7:	ff 75 14             	pushl  0x14(%ebp)
  8015ea:	ff 75 10             	pushl  0x10(%ebp)
  8015ed:	ff 75 0c             	pushl  0xc(%ebp)
  8015f0:	50                   	push   %eax
  8015f1:	6a 19                	push   $0x19
  8015f3:	e8 6c fd ff ff       	call   801364 <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_run_env>:

void sys_run_env(int32 envId) {
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801600:	8b 45 08             	mov    0x8(%ebp),%eax
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	50                   	push   %eax
  80160c:	6a 1a                	push   $0x1a
  80160e:	e8 51 fd ff ff       	call   801364 <syscall>
  801613:	83 c4 18             	add    $0x18,%esp
}
  801616:	90                   	nop
  801617:	c9                   	leave  
  801618:	c3                   	ret    

00801619 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801619:	55                   	push   %ebp
  80161a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80161c:	8b 45 08             	mov    0x8(%ebp),%eax
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	50                   	push   %eax
  801628:	6a 1b                	push   $0x1b
  80162a:	e8 35 fd ff ff       	call   801364 <syscall>
  80162f:	83 c4 18             	add    $0x18,%esp
}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_getenvid>:

int32 sys_getenvid(void) {
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 00                	push   $0x0
  80163f:	6a 00                	push   $0x0
  801641:	6a 05                	push   $0x5
  801643:	e8 1c fd ff ff       	call   801364 <syscall>
  801648:	83 c4 18             	add    $0x18,%esp
}
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801650:	6a 00                	push   $0x0
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 06                	push   $0x6
  80165c:	e8 03 fd ff ff       	call   801364 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801669:	6a 00                	push   $0x0
  80166b:	6a 00                	push   $0x0
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 07                	push   $0x7
  801675:	e8 ea fc ff ff       	call   801364 <syscall>
  80167a:	83 c4 18             	add    $0x18,%esp
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_exit_env>:

void sys_exit_env(void) {
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	6a 1c                	push   $0x1c
  80168e:	e8 d1 fc ff ff       	call   801364 <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
}
  801696:	90                   	nop
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80169f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a2:	8d 50 04             	lea    0x4(%eax),%edx
  8016a5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	52                   	push   %edx
  8016af:	50                   	push   %eax
  8016b0:	6a 1d                	push   $0x1d
  8016b2:	e8 ad fc ff ff       	call   801364 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8016ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016c3:	89 01                	mov    %eax,(%ecx)
  8016c5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	c9                   	leave  
  8016cc:	c2 04 00             	ret    $0x4

008016cf <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 10             	pushl  0x10(%ebp)
  8016d9:	ff 75 0c             	pushl  0xc(%ebp)
  8016dc:	ff 75 08             	pushl  0x8(%ebp)
  8016df:	6a 13                	push   $0x13
  8016e1:	e8 7e fc ff ff       	call   801364 <syscall>
  8016e6:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8016e9:	90                   	nop
}
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <sys_rcr2>:
uint32 sys_rcr2() {
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 1e                	push   $0x1e
  8016fb:	e8 64 fc ff ff       	call   801364 <syscall>
  801700:	83 c4 18             	add    $0x18,%esp
}
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801711:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 00                	push   $0x0
  80171b:	6a 00                	push   $0x0
  80171d:	50                   	push   %eax
  80171e:	6a 1f                	push   $0x1f
  801720:	e8 3f fc ff ff       	call   801364 <syscall>
  801725:	83 c4 18             	add    $0x18,%esp
	return;
  801728:	90                   	nop
}
  801729:	c9                   	leave  
  80172a:	c3                   	ret    

0080172b <rsttst>:
void rsttst() {
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80172e:	6a 00                	push   $0x0
  801730:	6a 00                	push   $0x0
  801732:	6a 00                	push   $0x0
  801734:	6a 00                	push   $0x0
  801736:	6a 00                	push   $0x0
  801738:	6a 21                	push   $0x21
  80173a:	e8 25 fc ff ff       	call   801364 <syscall>
  80173f:	83 c4 18             	add    $0x18,%esp
	return;
  801742:	90                   	nop
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	8b 45 14             	mov    0x14(%ebp),%eax
  80174e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801751:	8b 55 18             	mov    0x18(%ebp),%edx
  801754:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801758:	52                   	push   %edx
  801759:	50                   	push   %eax
  80175a:	ff 75 10             	pushl  0x10(%ebp)
  80175d:	ff 75 0c             	pushl  0xc(%ebp)
  801760:	ff 75 08             	pushl  0x8(%ebp)
  801763:	6a 20                	push   $0x20
  801765:	e8 fa fb ff ff       	call   801364 <syscall>
  80176a:	83 c4 18             	add    $0x18,%esp
	return;
  80176d:	90                   	nop
}
  80176e:	c9                   	leave  
  80176f:	c3                   	ret    

00801770 <chktst>:
void chktst(uint32 n) {
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	ff 75 08             	pushl  0x8(%ebp)
  80177e:	6a 22                	push   $0x22
  801780:	e8 df fb ff ff       	call   801364 <syscall>
  801785:	83 c4 18             	add    $0x18,%esp
	return;
  801788:	90                   	nop
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <inctst>:

void inctst() {
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80178e:	6a 00                	push   $0x0
  801790:	6a 00                	push   $0x0
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 23                	push   $0x23
  80179a:	e8 c5 fb ff ff       	call   801364 <syscall>
  80179f:	83 c4 18             	add    $0x18,%esp
	return;
  8017a2:	90                   	nop
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <gettst>:
uint32 gettst() {
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 00                	push   $0x0
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 24                	push   $0x24
  8017b4:	e8 ab fb ff ff       	call   801364 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	c9                   	leave  
  8017bd:	c3                   	ret    

008017be <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 00                	push   $0x0
  8017c8:	6a 00                	push   $0x0
  8017ca:	6a 00                	push   $0x0
  8017cc:	6a 00                	push   $0x0
  8017ce:	6a 25                	push   $0x25
  8017d0:	e8 8f fb ff ff       	call   801364 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
  8017d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8017db:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8017df:	75 07                	jne    8017e8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8017e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e6:	eb 05                	jmp    8017ed <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8017e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ed:	c9                   	leave  
  8017ee:	c3                   	ret    

008017ef <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 00                	push   $0x0
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 25                	push   $0x25
  801801:	e8 5e fb ff ff       	call   801364 <syscall>
  801806:	83 c4 18             	add    $0x18,%esp
  801809:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80180c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801810:	75 07                	jne    801819 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801812:	b8 01 00 00 00       	mov    $0x1,%eax
  801817:	eb 05                	jmp    80181e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 25                	push   $0x25
  801832:	e8 2d fb ff ff       	call   801364 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
  80183a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80183d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801841:	75 07                	jne    80184a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801843:	b8 01 00 00 00       	mov    $0x1,%eax
  801848:	eb 05                	jmp    80184f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 25                	push   $0x25
  801863:	e8 fc fa ff ff       	call   801364 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
  80186b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80186e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801872:	75 07                	jne    80187b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801874:	b8 01 00 00 00       	mov    $0x1,%eax
  801879:	eb 05                	jmp    801880 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	ff 75 08             	pushl  0x8(%ebp)
  801890:	6a 26                	push   $0x26
  801892:	e8 cd fa ff ff       	call   801364 <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
	return;
  80189a:	90                   	nop
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8018a1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	53                   	push   %ebx
  8018b0:	51                   	push   %ecx
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 27                	push   $0x27
  8018b5:	e8 aa fa ff ff       	call   801364 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8018bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8018c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 28                	push   $0x28
  8018d5:	e8 8a fa ff ff       	call   801364 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8018e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	6a 00                	push   $0x0
  8018ed:	51                   	push   %ecx
  8018ee:	ff 75 10             	pushl  0x10(%ebp)
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	6a 29                	push   $0x29
  8018f5:	e8 6a fa ff ff       	call   801364 <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	ff 75 10             	pushl  0x10(%ebp)
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	6a 12                	push   $0x12
  801911:	e8 4e fa ff ff       	call   801364 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
	return;
  801919:	90                   	nop
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 2a                	push   $0x2a
  80192f:	e8 30 fa ff ff       	call   801364 <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
	return;
  801937:	90                   	nop
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80193d:	8b 45 08             	mov    0x8(%ebp),%eax
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	50                   	push   %eax
  801949:	6a 2b                	push   $0x2b
  80194b:	e8 14 fa ff ff       	call   801364 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	ff 75 08             	pushl  0x8(%ebp)
  801964:	6a 2c                	push   $0x2c
  801966:	e8 f9 f9 ff ff       	call   801364 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
	return;
  80196e:	90                   	nop
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	ff 75 0c             	pushl  0xc(%ebp)
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	6a 2d                	push   $0x2d
  801982:	e8 dd f9 ff ff       	call   801364 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
	return;
  80198a:	90                   	nop
}
  80198b:	c9                   	leave  
  80198c:	c3                   	ret    

0080198d <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	50                   	push   %eax
  80199c:	6a 2f                	push   $0x2f
  80199e:	e8 c1 f9 ff ff       	call   801364 <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
	return;
  8019a6:	90                   	nop
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    

008019a9 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8019a9:	55                   	push   %ebp
  8019aa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8019ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019af:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	52                   	push   %edx
  8019b9:	50                   	push   %eax
  8019ba:	6a 30                	push   $0x30
  8019bc:	e8 a3 f9 ff ff       	call   801364 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
	return;
  8019c4:	90                   	nop
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8019ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	50                   	push   %eax
  8019d6:	6a 31                	push   $0x31
  8019d8:	e8 87 f9 ff ff       	call   801364 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
	return;
  8019e0:	90                   	nop
}
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8019e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	52                   	push   %edx
  8019f3:	50                   	push   %eax
  8019f4:	6a 2e                	push   $0x2e
  8019f6:	e8 69 f9 ff ff       	call   801364 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
    return;
  8019fe:	90                   	nop
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	6a 01                	push   $0x1
  801a0c:	6a 58                	push   $0x58
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	e8 5b 04 00 00       	call   801e71 <smalloc>
  801a16:	83 c4 10             	add    $0x10,%esp
  801a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a20:	75 14                	jne    801a36 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	68 38 3e 80 00       	push   $0x803e38
  801a2a:	6a 10                	push   $0x10
  801a2c:	68 66 3e 80 00       	push   $0x803e66
  801a31:	e8 d7 e8 ff ff       	call   80030d <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  801a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a39:	83 ec 0c             	sub    $0xc,%esp
  801a3c:	50                   	push   %eax
  801a3d:	e8 4b ff ff ff       	call   80198d <sys_init_queue>
  801a42:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  801a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a48:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  801a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a52:	83 c0 18             	add    $0x18,%eax
  801a55:	83 ec 04             	sub    $0x4,%esp
  801a58:	6a 40                	push   $0x40
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	e8 78 f2 ff ff       	call   800cdb <strncpy>
  801a63:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  801a66:	8b 55 10             	mov    0x10(%ebp),%edx
  801a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6c:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  801a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a72:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  801a75:	8b 45 08             	mov    0x8(%ebp),%eax
  801a78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a7b:	89 10                	mov    %edx,(%eax)
}
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	c9                   	leave  
  801a81:	c2 04 00             	ret    $0x4

00801a84 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  801a8a:	83 ec 08             	sub    $0x8,%esp
  801a8d:	ff 75 10             	pushl  0x10(%ebp)
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 74 05 00 00       	call   80200c <sget>
  801a98:	83 c4 10             	add    $0x10,%esp
  801a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801aa2:	75 14                	jne    801ab8 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	68 78 3e 80 00       	push   $0x803e78
  801aac:	6a 2c                	push   $0x2c
  801aae:	68 66 3e 80 00       	push   $0x803e66
  801ab3:	e8 55 e8 ff ff       	call   80030d <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  801ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ac4:	89 10                	mov    %edx,(%eax)
}
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	c9                   	leave  
  801aca:	c2 04 00             	ret    $0x4

00801acd <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
  801ad0:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801ad3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	8b 40 14             	mov    0x14(%eax),%eax
  801ae0:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801ae3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801ae9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801af2:	f0 87 02             	lock xchg %eax,(%edx)
  801af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801afb:	85 c0                	test   %eax,%eax
  801afd:	75 db                	jne    801ada <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	8b 50 10             	mov    0x10(%eax),%edx
  801b05:	4a                   	dec    %edx
  801b06:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8b 40 10             	mov    0x10(%eax),%eax
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	79 18                	jns    801b2b <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	8d 50 14             	lea    0x14(%eax),%edx
  801b19:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1c:	83 ec 08             	sub    $0x8,%esp
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	e8 83 fe ff ff       	call   8019a9 <sys_block_process>
  801b26:	83 c4 10             	add    $0x10,%esp
  801b29:	eb 0a                	jmp    801b35 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801b3d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	8b 40 14             	mov    0x14(%eax),%eax
  801b4a:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801b4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801b50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b59:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801b5c:	f0 87 02             	lock xchg %eax,(%edx)
  801b5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801b62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b65:	85 c0                	test   %eax,%eax
  801b67:	75 db                	jne    801b44 <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  801b69:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6c:	8b 50 10             	mov    0x10(%eax),%edx
  801b6f:	42                   	inc    %edx
  801b70:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	8b 40 10             	mov    0x10(%eax),%eax
  801b79:	85 c0                	test   %eax,%eax
  801b7b:	7f 0f                	jg     801b8c <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	83 ec 0c             	sub    $0xc,%esp
  801b83:	50                   	push   %eax
  801b84:	e8 3e fe ff ff       	call   8019c7 <sys_unblock_process>
  801b89:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801b96:	90                   	nop
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	8b 40 10             	mov    0x10(%eax),%eax
}
  801ba2:	5d                   	pop    %ebp
  801ba3:	c3                   	ret    

00801ba4 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
  801ba7:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801baa:	83 ec 0c             	sub    $0xc,%esp
  801bad:	ff 75 08             	pushl  0x8(%ebp)
  801bb0:	e8 85 fd ff ff       	call   80193a <sys_sbrk>
  801bb5:	83 c4 10             	add    $0x10,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801bc0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bc4:	75 0a                	jne    801bd0 <malloc+0x16>
		return NULL;
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcb:	e9 9e 01 00 00       	jmp    801d6e <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801bd0:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801bd7:	77 2c                	ja     801c05 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801bd9:	e8 e0 fb ff ff       	call   8017be <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bde:	85 c0                	test   %eax,%eax
  801be0:	74 19                	je     801bfb <malloc+0x41>

			void * block = alloc_block_FF(size);
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	ff 75 08             	pushl  0x8(%ebp)
  801be8:	e8 e8 0a 00 00       	call   8026d5 <alloc_block_FF>
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801bf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bf6:	e9 73 01 00 00       	jmp    801d6e <malloc+0x1b4>
		} else {
			return NULL;
  801bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801c00:	e9 69 01 00 00       	jmp    801d6e <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801c05:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  801c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c12:	01 d0                	add    %edx,%eax
  801c14:	48                   	dec    %eax
  801c15:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c20:	f7 75 e0             	divl   -0x20(%ebp)
  801c23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c26:	29 d0                	sub    %edx,%eax
  801c28:	c1 e8 0c             	shr    $0xc,%eax
  801c2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801c2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801c35:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801c3c:	a1 20 50 80 00       	mov    0x805020,%eax
  801c41:	8b 40 7c             	mov    0x7c(%eax),%eax
  801c44:	05 00 10 00 00       	add    $0x1000,%eax
  801c49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801c4c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801c51:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c54:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801c57:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801c61:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c64:	01 d0                	add    %edx,%eax
  801c66:	48                   	dec    %eax
  801c67:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c72:	f7 75 cc             	divl   -0x34(%ebp)
  801c75:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c78:	29 d0                	sub    %edx,%eax
  801c7a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c7d:	76 0a                	jbe    801c89 <malloc+0xcf>
		return NULL;
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	e9 e5 00 00 00       	jmp    801d6e <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801c89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c8f:	eb 48                	jmp    801cd9 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801c91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c94:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c97:	c1 e8 0c             	shr    $0xc,%eax
  801c9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801c9d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801ca0:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	75 11                	jne    801cbc <malloc+0x102>
			freePagesCount++;
  801cab:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801cae:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cb2:	75 16                	jne    801cca <malloc+0x110>
				start = i;
  801cb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cba:	eb 0e                	jmp    801cca <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801cbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801cc3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccd:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801cd0:	74 12                	je     801ce4 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801cd2:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801cd9:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801ce0:	76 af                	jbe    801c91 <malloc+0xd7>
  801ce2:	eb 01                	jmp    801ce5 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801ce4:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801ce5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ce9:	74 08                	je     801cf3 <malloc+0x139>
  801ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cee:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801cf1:	74 07                	je     801cfa <malloc+0x140>
		return NULL;
  801cf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf8:	eb 74                	jmp    801d6e <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801d00:	c1 e8 0c             	shr    $0xc,%eax
  801d03:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801d06:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d09:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d0c:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801d13:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d16:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d19:	eb 11                	jmp    801d2c <malloc+0x172>
		markedPages[i] = 1;
  801d1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d1e:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801d25:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801d29:	ff 45 e8             	incl   -0x18(%ebp)
  801d2c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801d2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d32:	01 d0                	add    %edx,%eax
  801d34:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d37:	77 e2                	ja     801d1b <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801d39:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d40:	8b 55 08             	mov    0x8(%ebp),%edx
  801d43:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d46:	01 d0                	add    %edx,%eax
  801d48:	48                   	dec    %eax
  801d49:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d4c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d4f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d54:	f7 75 bc             	divl   -0x44(%ebp)
  801d57:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d5a:	29 d0                	sub    %edx,%eax
  801d5c:	83 ec 08             	sub    $0x8,%esp
  801d5f:	50                   	push   %eax
  801d60:	ff 75 f0             	pushl  -0x10(%ebp)
  801d63:	e8 09 fc ff ff       	call   801971 <sys_allocate_user_mem>
  801d68:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801d76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d7a:	0f 84 ee 00 00 00    	je     801e6e <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801d80:	a1 20 50 80 00       	mov    0x805020,%eax
  801d85:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801d88:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d8b:	77 09                	ja     801d96 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801d8d:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801d94:	76 14                	jbe    801daa <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801d96:	83 ec 04             	sub    $0x4,%esp
  801d99:	68 9c 3e 80 00       	push   $0x803e9c
  801d9e:	6a 68                	push   $0x68
  801da0:	68 b6 3e 80 00       	push   $0x803eb6
  801da5:	e8 63 e5 ff ff       	call   80030d <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801daa:	a1 20 50 80 00       	mov    0x805020,%eax
  801daf:	8b 40 74             	mov    0x74(%eax),%eax
  801db2:	3b 45 08             	cmp    0x8(%ebp),%eax
  801db5:	77 20                	ja     801dd7 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801db7:	a1 20 50 80 00       	mov    0x805020,%eax
  801dbc:	8b 40 78             	mov    0x78(%eax),%eax
  801dbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  801dc2:	76 13                	jbe    801dd7 <free+0x67>
		free_block(virtual_address);
  801dc4:	83 ec 0c             	sub    $0xc,%esp
  801dc7:	ff 75 08             	pushl  0x8(%ebp)
  801dca:	e8 cf 0f 00 00       	call   802d9e <free_block>
  801dcf:	83 c4 10             	add    $0x10,%esp
		return;
  801dd2:	e9 98 00 00 00       	jmp    801e6f <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801dd7:	8b 55 08             	mov    0x8(%ebp),%edx
  801dda:	a1 20 50 80 00       	mov    0x805020,%eax
  801ddf:	8b 40 7c             	mov    0x7c(%eax),%eax
  801de2:	29 c2                	sub    %eax,%edx
  801de4:	89 d0                	mov    %edx,%eax
  801de6:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801deb:	c1 e8 0c             	shr    $0xc,%eax
  801dee:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801df1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801df8:	eb 16                	jmp    801e10 <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e00:	01 d0                	add    %edx,%eax
  801e02:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801e09:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801e0d:	ff 45 f4             	incl   -0xc(%ebp)
  801e10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e13:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801e1a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801e1d:	7f db                	jg     801dfa <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801e1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e22:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  801e29:	c1 e0 0c             	shl    $0xc,%eax
  801e2c:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e35:	eb 1a                	jmp    801e51 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801e37:	83 ec 08             	sub    $0x8,%esp
  801e3a:	68 00 10 00 00       	push   $0x1000
  801e3f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e42:	e8 0e fb ff ff       	call   801955 <sys_free_user_mem>
  801e47:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801e4a:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801e51:	8b 55 08             	mov    0x8(%ebp),%edx
  801e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e57:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801e59:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e5c:	77 d9                	ja     801e37 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801e5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e61:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  801e68:	00 00 00 00 
  801e6c:	eb 01                	jmp    801e6f <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801e6e:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 58             	sub    $0x58,%esp
  801e77:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7a:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801e7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e81:	75 0a                	jne    801e8d <smalloc+0x1c>
		return NULL;
  801e83:	b8 00 00 00 00       	mov    $0x0,%eax
  801e88:	e9 7d 01 00 00       	jmp    80200a <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801e8d:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801e94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9a:	01 d0                	add    %edx,%eax
  801e9c:	48                   	dec    %eax
  801e9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ea3:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea8:	f7 75 e4             	divl   -0x1c(%ebp)
  801eab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801eae:	29 d0                	sub    %edx,%eax
  801eb0:	c1 e8 0c             	shr    $0xc,%eax
  801eb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801eb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801ebd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801ec4:	a1 20 50 80 00       	mov    0x805020,%eax
  801ec9:	8b 40 7c             	mov    0x7c(%eax),%eax
  801ecc:	05 00 10 00 00       	add    $0x1000,%eax
  801ed1:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801ed4:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ed9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801edc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801edf:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eec:	01 d0                	add    %edx,%eax
  801eee:	48                   	dec    %eax
  801eef:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ef2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ef5:	ba 00 00 00 00       	mov    $0x0,%edx
  801efa:	f7 75 d0             	divl   -0x30(%ebp)
  801efd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f00:	29 d0                	sub    %edx,%eax
  801f02:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801f05:	76 0a                	jbe    801f11 <smalloc+0xa0>
		return NULL;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0c:	e9 f9 00 00 00       	jmp    80200a <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f11:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f17:	eb 48                	jmp    801f61 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801f19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1c:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801f1f:	c1 e8 0c             	shr    $0xc,%eax
  801f22:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801f25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f28:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	75 11                	jne    801f44 <smalloc+0xd3>
			freePagesCount++;
  801f33:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801f36:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f3a:	75 16                	jne    801f52 <smalloc+0xe1>
				start = s;
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f42:	eb 0e                	jmp    801f52 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801f44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801f4b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f58:	74 12                	je     801f6c <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f5a:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801f61:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801f68:	76 af                	jbe    801f19 <smalloc+0xa8>
  801f6a:	eb 01                	jmp    801f6d <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801f6c:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801f6d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f71:	74 08                	je     801f7b <smalloc+0x10a>
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f79:	74 0a                	je     801f85 <smalloc+0x114>
		return NULL;
  801f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f80:	e9 85 00 00 00       	jmp    80200a <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f88:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801f8b:	c1 e8 0c             	shr    $0xc,%eax
  801f8e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801f91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f94:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f97:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801f9e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fa1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fa4:	eb 11                	jmp    801fb7 <smalloc+0x146>
		markedPages[s] = 1;
  801fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa9:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  801fb0:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801fb4:	ff 45 e8             	incl   -0x18(%ebp)
  801fb7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801fba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fbd:	01 d0                	add    %edx,%eax
  801fbf:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fc2:	77 e2                	ja     801fa6 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801fc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fc7:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801fcb:	52                   	push   %edx
  801fcc:	50                   	push   %eax
  801fcd:	ff 75 0c             	pushl  0xc(%ebp)
  801fd0:	ff 75 08             	pushl  0x8(%ebp)
  801fd3:	e8 84 f5 ff ff       	call   80155c <sys_createSharedObject>
  801fd8:	83 c4 10             	add    $0x10,%esp
  801fdb:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801fde:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801fe2:	78 12                	js     801ff6 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801fe4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fe7:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801fea:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff4:	eb 14                	jmp    80200a <smalloc+0x199>
	}
	free((void*) start);
  801ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	50                   	push   %eax
  801ffd:	e8 6e fd ff ff       	call   801d70 <free>
  802002:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  802012:	83 ec 08             	sub    $0x8,%esp
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	ff 75 08             	pushl  0x8(%ebp)
  80201b:	e8 66 f5 ff ff       	call   801586 <sys_getSizeOfSharedObject>
  802020:	83 c4 10             	add    $0x10,%esp
  802023:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802026:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80202d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802030:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802033:	01 d0                	add    %edx,%eax
  802035:	48                   	dec    %eax
  802036:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802039:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80203c:	ba 00 00 00 00       	mov    $0x0,%edx
  802041:	f7 75 e0             	divl   -0x20(%ebp)
  802044:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802047:	29 d0                	sub    %edx,%eax
  802049:	c1 e8 0c             	shr    $0xc,%eax
  80204c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80204f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802056:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80205d:	a1 20 50 80 00       	mov    0x805020,%eax
  802062:	8b 40 7c             	mov    0x7c(%eax),%eax
  802065:	05 00 10 00 00       	add    $0x1000,%eax
  80206a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80206d:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802072:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802075:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802078:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80207f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802082:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802085:	01 d0                	add    %edx,%eax
  802087:	48                   	dec    %eax
  802088:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80208b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80208e:	ba 00 00 00 00       	mov    $0x0,%edx
  802093:	f7 75 cc             	divl   -0x34(%ebp)
  802096:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802099:	29 d0                	sub    %edx,%eax
  80209b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80209e:	76 0a                	jbe    8020aa <sget+0x9e>
		return NULL;
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a5:	e9 f7 00 00 00       	jmp    8021a1 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8020aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020b0:	eb 48                	jmp    8020fa <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8020b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b5:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020b8:	c1 e8 0c             	shr    $0xc,%eax
  8020bb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8020be:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8020c1:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 11                	jne    8020dd <sget+0xd1>
			free_Pages_Count++;
  8020cc:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8020cf:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020d3:	75 16                	jne    8020eb <sget+0xdf>
				start = s;
  8020d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020db:	eb 0e                	jmp    8020eb <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8020dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8020e4:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8020f1:	74 12                	je     802105 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8020f3:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8020fa:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802101:	76 af                	jbe    8020b2 <sget+0xa6>
  802103:	eb 01                	jmp    802106 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802105:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802106:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80210a:	74 08                	je     802114 <sget+0x108>
  80210c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802112:	74 0a                	je     80211e <sget+0x112>
		return NULL;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	e9 83 00 00 00       	jmp    8021a1 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80211e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802121:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802124:	c1 e8 0c             	shr    $0xc,%eax
  802127:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  80212a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80212d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802130:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802137:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80213a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80213d:	eb 11                	jmp    802150 <sget+0x144>
		markedPages[k] = 1;
  80213f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802142:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802149:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80214d:	ff 45 e8             	incl   -0x18(%ebp)
  802150:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802153:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802156:	01 d0                	add    %edx,%eax
  802158:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80215b:	77 e2                	ja     80213f <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	50                   	push   %eax
  802164:	ff 75 0c             	pushl  0xc(%ebp)
  802167:	ff 75 08             	pushl  0x8(%ebp)
  80216a:	e8 34 f4 ff ff       	call   8015a3 <sys_getSharedObject>
  80216f:	83 c4 10             	add    $0x10,%esp
  802172:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802175:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802179:	78 12                	js     80218d <sget+0x181>
		shardIDs[startPage] = ss;
  80217b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80217e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802181:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  802188:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218b:	eb 14                	jmp    8021a1 <sget+0x195>
	}
	free((void*) start);
  80218d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802190:	83 ec 0c             	sub    $0xc,%esp
  802193:	50                   	push   %eax
  802194:	e8 d7 fb ff ff       	call   801d70 <free>
  802199:	83 c4 10             	add    $0x10,%esp
	return NULL;
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8021a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8021b1:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021b4:	29 c2                	sub    %eax,%edx
  8021b6:	89 d0                	mov    %edx,%eax
  8021b8:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8021bd:	c1 e8 0c             	shr    $0xc,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8021cd:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8021d0:	83 ec 08             	sub    $0x8,%esp
  8021d3:	ff 75 08             	pushl  0x8(%ebp)
  8021d6:	ff 75 f0             	pushl  -0x10(%ebp)
  8021d9:	e8 e4 f3 ff ff       	call   8015c2 <sys_freeSharedObject>
  8021de:	83 c4 10             	add    $0x10,%esp
  8021e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8021e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e8:	75 0e                	jne    8021f8 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  8021f4:	ff ff ff ff 
	}

}
  8021f8:	90                   	nop
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802201:	83 ec 04             	sub    $0x4,%esp
  802204:	68 c4 3e 80 00       	push   $0x803ec4
  802209:	68 19 01 00 00       	push   $0x119
  80220e:	68 b6 3e 80 00       	push   $0x803eb6
  802213:	e8 f5 e0 ff ff       	call   80030d <_panic>

00802218 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	68 ea 3e 80 00       	push   $0x803eea
  802226:	68 23 01 00 00       	push   $0x123
  80222b:	68 b6 3e 80 00       	push   $0x803eb6
  802230:	e8 d8 e0 ff ff       	call   80030d <_panic>

00802235 <shrink>:

}
void shrink(uint32 newSize) {
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 ea 3e 80 00       	push   $0x803eea
  802243:	68 27 01 00 00       	push   $0x127
  802248:	68 b6 3e 80 00       	push   $0x803eb6
  80224d:	e8 bb e0 ff ff       	call   80030d <_panic>

00802252 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802258:	83 ec 04             	sub    $0x4,%esp
  80225b:	68 ea 3e 80 00       	push   $0x803eea
  802260:	68 2b 01 00 00       	push   $0x12b
  802265:	68 b6 3e 80 00       	push   $0x803eb6
  80226a:	e8 9e e0 ff ff       	call   80030d <_panic>

0080226f <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	83 e8 04             	sub    $0x4,%eax
  80227b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80227e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802281:	8b 00                	mov    (%eax),%eax
  802283:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	83 e8 04             	sub    $0x4,%eax
  802294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802297:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80229a:	8b 00                	mov    (%eax),%eax
  80229c:	83 e0 01             	and    $0x1,%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	0f 94 c0             	sete   %al
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8022ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8022b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b6:	83 f8 02             	cmp    $0x2,%eax
  8022b9:	74 2b                	je     8022e6 <alloc_block+0x40>
  8022bb:	83 f8 02             	cmp    $0x2,%eax
  8022be:	7f 07                	jg     8022c7 <alloc_block+0x21>
  8022c0:	83 f8 01             	cmp    $0x1,%eax
  8022c3:	74 0e                	je     8022d3 <alloc_block+0x2d>
  8022c5:	eb 58                	jmp    80231f <alloc_block+0x79>
  8022c7:	83 f8 03             	cmp    $0x3,%eax
  8022ca:	74 2d                	je     8022f9 <alloc_block+0x53>
  8022cc:	83 f8 04             	cmp    $0x4,%eax
  8022cf:	74 3b                	je     80230c <alloc_block+0x66>
  8022d1:	eb 4c                	jmp    80231f <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8022d3:	83 ec 0c             	sub    $0xc,%esp
  8022d6:	ff 75 08             	pushl  0x8(%ebp)
  8022d9:	e8 f7 03 00 00       	call   8026d5 <alloc_block_FF>
  8022de:	83 c4 10             	add    $0x10,%esp
  8022e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022e4:	eb 4a                	jmp    802330 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8022e6:	83 ec 0c             	sub    $0xc,%esp
  8022e9:	ff 75 08             	pushl  0x8(%ebp)
  8022ec:	e8 f0 11 00 00       	call   8034e1 <alloc_block_NF>
  8022f1:	83 c4 10             	add    $0x10,%esp
  8022f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022f7:	eb 37                	jmp    802330 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8022f9:	83 ec 0c             	sub    $0xc,%esp
  8022fc:	ff 75 08             	pushl  0x8(%ebp)
  8022ff:	e8 08 08 00 00       	call   802b0c <alloc_block_BF>
  802304:	83 c4 10             	add    $0x10,%esp
  802307:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80230a:	eb 24                	jmp    802330 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80230c:	83 ec 0c             	sub    $0xc,%esp
  80230f:	ff 75 08             	pushl  0x8(%ebp)
  802312:	e8 ad 11 00 00       	call   8034c4 <alloc_block_WF>
  802317:	83 c4 10             	add    $0x10,%esp
  80231a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80231d:	eb 11                	jmp    802330 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80231f:	83 ec 0c             	sub    $0xc,%esp
  802322:	68 fc 3e 80 00       	push   $0x803efc
  802327:	e8 9e e2 ff ff       	call   8005ca <cprintf>
  80232c:	83 c4 10             	add    $0x10,%esp
		break;
  80232f:	90                   	nop
	}
	return va;
  802330:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	53                   	push   %ebx
  802339:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80233c:	83 ec 0c             	sub    $0xc,%esp
  80233f:	68 1c 3f 80 00       	push   $0x803f1c
  802344:	e8 81 e2 ff ff       	call   8005ca <cprintf>
  802349:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80234c:	83 ec 0c             	sub    $0xc,%esp
  80234f:	68 47 3f 80 00       	push   $0x803f47
  802354:	e8 71 e2 ff ff       	call   8005ca <cprintf>
  802359:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802362:	eb 37                	jmp    80239b <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802364:	83 ec 0c             	sub    $0xc,%esp
  802367:	ff 75 f4             	pushl  -0xc(%ebp)
  80236a:	e8 19 ff ff ff       	call   802288 <is_free_block>
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	0f be d8             	movsbl %al,%ebx
  802375:	83 ec 0c             	sub    $0xc,%esp
  802378:	ff 75 f4             	pushl  -0xc(%ebp)
  80237b:	e8 ef fe ff ff       	call   80226f <get_block_size>
  802380:	83 c4 10             	add    $0x10,%esp
  802383:	83 ec 04             	sub    $0x4,%esp
  802386:	53                   	push   %ebx
  802387:	50                   	push   %eax
  802388:	68 5f 3f 80 00       	push   $0x803f5f
  80238d:	e8 38 e2 ff ff       	call   8005ca <cprintf>
  802392:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802395:	8b 45 10             	mov    0x10(%ebp),%eax
  802398:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239f:	74 07                	je     8023a8 <print_blocks_list+0x73>
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 00                	mov    (%eax),%eax
  8023a6:	eb 05                	jmp    8023ad <print_blocks_list+0x78>
  8023a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ad:	89 45 10             	mov    %eax,0x10(%ebp)
  8023b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b3:	85 c0                	test   %eax,%eax
  8023b5:	75 ad                	jne    802364 <print_blocks_list+0x2f>
  8023b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bb:	75 a7                	jne    802364 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8023bd:	83 ec 0c             	sub    $0xc,%esp
  8023c0:	68 1c 3f 80 00       	push   $0x803f1c
  8023c5:	e8 00 e2 ff ff       	call   8005ca <cprintf>
  8023ca:	83 c4 10             	add    $0x10,%esp

}
  8023cd:	90                   	nop
  8023ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8023d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023dc:	83 e0 01             	and    $0x1,%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	74 03                	je     8023e6 <initialize_dynamic_allocator+0x13>
  8023e3:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8023e6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023ea:	0f 84 f8 00 00 00    	je     8024e8 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8023f0:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  8023f7:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8023fa:	a1 40 50 98 00       	mov    0x985040,%eax
  8023ff:	85 c0                	test   %eax,%eax
  802401:	0f 84 e2 00 00 00    	je     8024e9 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802407:	8b 45 08             	mov    0x8(%ebp),%eax
  80240a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802416:	8b 55 08             	mov    0x8(%ebp),%edx
  802419:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241c:	01 d0                	add    %edx,%eax
  80241e:	83 e8 04             	sub    $0x4,%eax
  802421:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802427:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  80242d:	8b 45 08             	mov    0x8(%ebp),%eax
  802430:	83 c0 08             	add    $0x8,%eax
  802433:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802436:	8b 45 0c             	mov    0xc(%ebp),%eax
  802439:	83 e8 08             	sub    $0x8,%eax
  80243c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80243f:	83 ec 04             	sub    $0x4,%esp
  802442:	6a 00                	push   $0x0
  802444:	ff 75 e8             	pushl  -0x18(%ebp)
  802447:	ff 75 ec             	pushl  -0x14(%ebp)
  80244a:	e8 9c 00 00 00       	call   8024eb <set_block_data>
  80244f:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802452:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  80245b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802465:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  80246c:	00 00 00 
  80246f:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802476:	00 00 00 
  802479:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  802480:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802483:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802487:	75 17                	jne    8024a0 <initialize_dynamic_allocator+0xcd>
  802489:	83 ec 04             	sub    $0x4,%esp
  80248c:	68 78 3f 80 00       	push   $0x803f78
  802491:	68 80 00 00 00       	push   $0x80
  802496:	68 9b 3f 80 00       	push   $0x803f9b
  80249b:	e8 6d de ff ff       	call   80030d <_panic>
  8024a0:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8024a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a9:	89 10                	mov    %edx,(%eax)
  8024ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 0d                	je     8024c1 <initialize_dynamic_allocator+0xee>
  8024b4:	a1 48 50 98 00       	mov    0x985048,%eax
  8024b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024bc:	89 50 04             	mov    %edx,0x4(%eax)
  8024bf:	eb 08                	jmp    8024c9 <initialize_dynamic_allocator+0xf6>
  8024c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cc:	a3 48 50 98 00       	mov    %eax,0x985048
  8024d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024db:	a1 54 50 98 00       	mov    0x985054,%eax
  8024e0:	40                   	inc    %eax
  8024e1:	a3 54 50 98 00       	mov    %eax,0x985054
  8024e6:	eb 01                	jmp    8024e9 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8024e8:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8024f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f4:	83 e0 01             	and    $0x1,%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	74 03                	je     8024fe <set_block_data+0x13>
	{
		totalSize++;
  8024fb:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8024fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802501:	83 e8 04             	sub    $0x4,%eax
  802504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802507:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250a:	83 e0 fe             	and    $0xfffffffe,%eax
  80250d:	89 c2                	mov    %eax,%edx
  80250f:	8b 45 10             	mov    0x10(%ebp),%eax
  802512:	83 e0 01             	and    $0x1,%eax
  802515:	09 c2                	or     %eax,%edx
  802517:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80251a:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  80251c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80251f:	8d 50 f8             	lea    -0x8(%eax),%edx
  802522:	8b 45 08             	mov    0x8(%ebp),%eax
  802525:	01 d0                	add    %edx,%eax
  802527:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  80252a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80252d:	83 e0 fe             	and    $0xfffffffe,%eax
  802530:	89 c2                	mov    %eax,%edx
  802532:	8b 45 10             	mov    0x10(%ebp),%eax
  802535:	83 e0 01             	and    $0x1,%eax
  802538:	09 c2                	or     %eax,%edx
  80253a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80253d:	89 10                	mov    %edx,(%eax)
}
  80253f:	90                   	nop
  802540:	c9                   	leave  
  802541:	c3                   	ret    

00802542 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802542:	55                   	push   %ebp
  802543:	89 e5                	mov    %esp,%ebp
  802545:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802548:	a1 48 50 98 00       	mov    0x985048,%eax
  80254d:	85 c0                	test   %eax,%eax
  80254f:	75 68                	jne    8025b9 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802551:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802555:	75 17                	jne    80256e <insert_sorted_in_freeList+0x2c>
  802557:	83 ec 04             	sub    $0x4,%esp
  80255a:	68 78 3f 80 00       	push   $0x803f78
  80255f:	68 9d 00 00 00       	push   $0x9d
  802564:	68 9b 3f 80 00       	push   $0x803f9b
  802569:	e8 9f dd ff ff       	call   80030d <_panic>
  80256e:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	89 10                	mov    %edx,(%eax)
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	85 c0                	test   %eax,%eax
  802580:	74 0d                	je     80258f <insert_sorted_in_freeList+0x4d>
  802582:	a1 48 50 98 00       	mov    0x985048,%eax
  802587:	8b 55 08             	mov    0x8(%ebp),%edx
  80258a:	89 50 04             	mov    %edx,0x4(%eax)
  80258d:	eb 08                	jmp    802597 <insert_sorted_in_freeList+0x55>
  80258f:	8b 45 08             	mov    0x8(%ebp),%eax
  802592:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	a3 48 50 98 00       	mov    %eax,0x985048
  80259f:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a9:	a1 54 50 98 00       	mov    0x985054,%eax
  8025ae:	40                   	inc    %eax
  8025af:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8025b4:	e9 1a 01 00 00       	jmp    8026d3 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8025b9:	a1 48 50 98 00       	mov    0x985048,%eax
  8025be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c1:	eb 7f                	jmp    802642 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c9:	76 6f                	jbe    80263a <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8025cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cf:	74 06                	je     8025d7 <insert_sorted_in_freeList+0x95>
  8025d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025d5:	75 17                	jne    8025ee <insert_sorted_in_freeList+0xac>
  8025d7:	83 ec 04             	sub    $0x4,%esp
  8025da:	68 b4 3f 80 00       	push   $0x803fb4
  8025df:	68 a6 00 00 00       	push   $0xa6
  8025e4:	68 9b 3f 80 00       	push   $0x803f9b
  8025e9:	e8 1f dd ff ff       	call   80030d <_panic>
  8025ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f1:	8b 50 04             	mov    0x4(%eax),%edx
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	89 50 04             	mov    %edx,0x4(%eax)
  8025fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802600:	89 10                	mov    %edx,(%eax)
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 40 04             	mov    0x4(%eax),%eax
  802608:	85 c0                	test   %eax,%eax
  80260a:	74 0d                	je     802619 <insert_sorted_in_freeList+0xd7>
  80260c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260f:	8b 40 04             	mov    0x4(%eax),%eax
  802612:	8b 55 08             	mov    0x8(%ebp),%edx
  802615:	89 10                	mov    %edx,(%eax)
  802617:	eb 08                	jmp    802621 <insert_sorted_in_freeList+0xdf>
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	a3 48 50 98 00       	mov    %eax,0x985048
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	8b 55 08             	mov    0x8(%ebp),%edx
  802627:	89 50 04             	mov    %edx,0x4(%eax)
  80262a:	a1 54 50 98 00       	mov    0x985054,%eax
  80262f:	40                   	inc    %eax
  802630:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802635:	e9 99 00 00 00       	jmp    8026d3 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  80263a:	a1 50 50 98 00       	mov    0x985050,%eax
  80263f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802646:	74 07                	je     80264f <insert_sorted_in_freeList+0x10d>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	eb 05                	jmp    802654 <insert_sorted_in_freeList+0x112>
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	a3 50 50 98 00       	mov    %eax,0x985050
  802659:	a1 50 50 98 00       	mov    0x985050,%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	0f 85 5d ff ff ff    	jne    8025c3 <insert_sorted_in_freeList+0x81>
  802666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266a:	0f 85 53 ff ff ff    	jne    8025c3 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802670:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802674:	75 17                	jne    80268d <insert_sorted_in_freeList+0x14b>
  802676:	83 ec 04             	sub    $0x4,%esp
  802679:	68 ec 3f 80 00       	push   $0x803fec
  80267e:	68 ab 00 00 00       	push   $0xab
  802683:	68 9b 3f 80 00       	push   $0x803f9b
  802688:	e8 80 dc ff ff       	call   80030d <_panic>
  80268d:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	89 50 04             	mov    %edx,0x4(%eax)
  802699:	8b 45 08             	mov    0x8(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 0c                	je     8026af <insert_sorted_in_freeList+0x16d>
  8026a3:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8026a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ab:	89 10                	mov    %edx,(%eax)
  8026ad:	eb 08                	jmp    8026b7 <insert_sorted_in_freeList+0x175>
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	a3 48 50 98 00       	mov    %eax,0x985048
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8026bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c8:	a1 54 50 98 00       	mov    0x985054,%eax
  8026cd:	40                   	inc    %eax
  8026ce:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	83 e0 01             	and    $0x1,%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 03                	je     8026e8 <alloc_block_FF+0x13>
  8026e5:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026e8:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026ec:	77 07                	ja     8026f5 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026ee:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026f5:	a1 40 50 98 00       	mov    0x985040,%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	75 63                	jne    802761 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	83 c0 10             	add    $0x10,%eax
  802704:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802707:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80270e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802714:	01 d0                	add    %edx,%eax
  802716:	48                   	dec    %eax
  802717:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80271a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271d:	ba 00 00 00 00       	mov    $0x0,%edx
  802722:	f7 75 ec             	divl   -0x14(%ebp)
  802725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802728:	29 d0                	sub    %edx,%eax
  80272a:	c1 e8 0c             	shr    $0xc,%eax
  80272d:	83 ec 0c             	sub    $0xc,%esp
  802730:	50                   	push   %eax
  802731:	e8 6e f4 ff ff       	call   801ba4 <sbrk>
  802736:	83 c4 10             	add    $0x10,%esp
  802739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  80273c:	83 ec 0c             	sub    $0xc,%esp
  80273f:	6a 00                	push   $0x0
  802741:	e8 5e f4 ff ff       	call   801ba4 <sbrk>
  802746:	83 c4 10             	add    $0x10,%esp
  802749:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  80274c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802752:	83 ec 08             	sub    $0x8,%esp
  802755:	50                   	push   %eax
  802756:	ff 75 e4             	pushl  -0x1c(%ebp)
  802759:	e8 75 fc ff ff       	call   8023d3 <initialize_dynamic_allocator>
  80275e:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802761:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802765:	75 0a                	jne    802771 <alloc_block_FF+0x9c>
	{
		return NULL;
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	e9 99 03 00 00       	jmp    802b0a <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	83 c0 08             	add    $0x8,%eax
  802777:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80277a:	a1 48 50 98 00       	mov    0x985048,%eax
  80277f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802782:	e9 03 02 00 00       	jmp    80298a <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802787:	83 ec 0c             	sub    $0xc,%esp
  80278a:	ff 75 f4             	pushl  -0xc(%ebp)
  80278d:	e8 dd fa ff ff       	call   80226f <get_block_size>
  802792:	83 c4 10             	add    $0x10,%esp
  802795:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802798:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80279b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80279e:	0f 82 de 01 00 00    	jb     802982 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8027a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027a7:	83 c0 10             	add    $0x10,%eax
  8027aa:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8027ad:	0f 87 32 01 00 00    	ja     8028e5 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8027b3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8027b6:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8027b9:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8027bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027c2:	01 d0                	add    %edx,%eax
  8027c4:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	6a 00                	push   $0x0
  8027cc:	ff 75 98             	pushl  -0x68(%ebp)
  8027cf:	ff 75 94             	pushl  -0x6c(%ebp)
  8027d2:	e8 14 fd ff ff       	call   8024eb <set_block_data>
  8027d7:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8027da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027de:	74 06                	je     8027e6 <alloc_block_FF+0x111>
  8027e0:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8027e4:	75 17                	jne    8027fd <alloc_block_FF+0x128>
  8027e6:	83 ec 04             	sub    $0x4,%esp
  8027e9:	68 10 40 80 00       	push   $0x804010
  8027ee:	68 de 00 00 00       	push   $0xde
  8027f3:	68 9b 3f 80 00       	push   $0x803f9b
  8027f8:	e8 10 db ff ff       	call   80030d <_panic>
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	8b 10                	mov    (%eax),%edx
  802802:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802805:	89 10                	mov    %edx,(%eax)
  802807:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 0b                	je     80281b <alloc_block_FF+0x146>
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802818:	89 50 04             	mov    %edx,0x4(%eax)
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802821:	89 10                	mov    %edx,(%eax)
  802823:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802826:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80282f:	8b 00                	mov    (%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	75 08                	jne    80283d <alloc_block_FF+0x168>
  802835:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802838:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80283d:	a1 54 50 98 00       	mov    0x985054,%eax
  802842:	40                   	inc    %eax
  802843:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802848:	83 ec 04             	sub    $0x4,%esp
  80284b:	6a 01                	push   $0x1
  80284d:	ff 75 dc             	pushl  -0x24(%ebp)
  802850:	ff 75 f4             	pushl  -0xc(%ebp)
  802853:	e8 93 fc ff ff       	call   8024eb <set_block_data>
  802858:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  80285b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285f:	75 17                	jne    802878 <alloc_block_FF+0x1a3>
  802861:	83 ec 04             	sub    $0x4,%esp
  802864:	68 44 40 80 00       	push   $0x804044
  802869:	68 e3 00 00 00       	push   $0xe3
  80286e:	68 9b 3f 80 00       	push   $0x803f9b
  802873:	e8 95 da ff ff       	call   80030d <_panic>
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 00                	mov    (%eax),%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	74 10                	je     802891 <alloc_block_FF+0x1bc>
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802889:	8b 52 04             	mov    0x4(%edx),%edx
  80288c:	89 50 04             	mov    %edx,0x4(%eax)
  80288f:	eb 0b                	jmp    80289c <alloc_block_FF+0x1c7>
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 40 04             	mov    0x4(%eax),%eax
  802897:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 0f                	je     8028b5 <alloc_block_FF+0x1e0>
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028af:	8b 12                	mov    (%edx),%edx
  8028b1:	89 10                	mov    %edx,(%eax)
  8028b3:	eb 0a                	jmp    8028bf <alloc_block_FF+0x1ea>
  8028b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b8:	8b 00                	mov    (%eax),%eax
  8028ba:	a3 48 50 98 00       	mov    %eax,0x985048
  8028bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d2:	a1 54 50 98 00       	mov    0x985054,%eax
  8028d7:	48                   	dec    %eax
  8028d8:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	e9 25 02 00 00       	jmp    802b0a <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8028e5:	83 ec 04             	sub    $0x4,%esp
  8028e8:	6a 01                	push   $0x1
  8028ea:	ff 75 9c             	pushl  -0x64(%ebp)
  8028ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8028f0:	e8 f6 fb ff ff       	call   8024eb <set_block_data>
  8028f5:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8028f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fc:	75 17                	jne    802915 <alloc_block_FF+0x240>
  8028fe:	83 ec 04             	sub    $0x4,%esp
  802901:	68 44 40 80 00       	push   $0x804044
  802906:	68 eb 00 00 00       	push   $0xeb
  80290b:	68 9b 3f 80 00       	push   $0x803f9b
  802910:	e8 f8 d9 ff ff       	call   80030d <_panic>
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 10                	je     80292e <alloc_block_FF+0x259>
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 00                	mov    (%eax),%eax
  802923:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802926:	8b 52 04             	mov    0x4(%edx),%edx
  802929:	89 50 04             	mov    %edx,0x4(%eax)
  80292c:	eb 0b                	jmp    802939 <alloc_block_FF+0x264>
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 40 04             	mov    0x4(%eax),%eax
  802934:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 40 04             	mov    0x4(%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	74 0f                	je     802952 <alloc_block_FF+0x27d>
  802943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802946:	8b 40 04             	mov    0x4(%eax),%eax
  802949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294c:	8b 12                	mov    (%edx),%edx
  80294e:	89 10                	mov    %edx,(%eax)
  802950:	eb 0a                	jmp    80295c <alloc_block_FF+0x287>
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	a3 48 50 98 00       	mov    %eax,0x985048
  80295c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802965:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802968:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296f:	a1 54 50 98 00       	mov    0x985054,%eax
  802974:	48                   	dec    %eax
  802975:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	e9 88 01 00 00       	jmp    802b0a <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802982:	a1 50 50 98 00       	mov    0x985050,%eax
  802987:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298e:	74 07                	je     802997 <alloc_block_FF+0x2c2>
  802990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802993:	8b 00                	mov    (%eax),%eax
  802995:	eb 05                	jmp    80299c <alloc_block_FF+0x2c7>
  802997:	b8 00 00 00 00       	mov    $0x0,%eax
  80299c:	a3 50 50 98 00       	mov    %eax,0x985050
  8029a1:	a1 50 50 98 00       	mov    0x985050,%eax
  8029a6:	85 c0                	test   %eax,%eax
  8029a8:	0f 85 d9 fd ff ff    	jne    802787 <alloc_block_FF+0xb2>
  8029ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b2:	0f 85 cf fd ff ff    	jne    802787 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8029b8:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8029bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8029c5:	01 d0                	add    %edx,%eax
  8029c7:	48                   	dec    %eax
  8029c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8029cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8029d3:	f7 75 d8             	divl   -0x28(%ebp)
  8029d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029d9:	29 d0                	sub    %edx,%eax
  8029db:	c1 e8 0c             	shr    $0xc,%eax
  8029de:	83 ec 0c             	sub    $0xc,%esp
  8029e1:	50                   	push   %eax
  8029e2:	e8 bd f1 ff ff       	call   801ba4 <sbrk>
  8029e7:	83 c4 10             	add    $0x10,%esp
  8029ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8029ed:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8029f1:	75 0a                	jne    8029fd <alloc_block_FF+0x328>
		return NULL;
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	e9 0d 01 00 00       	jmp    802b0a <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8029fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a00:	83 e8 04             	sub    $0x4,%eax
  802a03:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802a06:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a10:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802a13:	01 d0                	add    %edx,%eax
  802a15:	48                   	dec    %eax
  802a16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802a19:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a1c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a21:	f7 75 c8             	divl   -0x38(%ebp)
  802a24:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802a27:	29 d0                	sub    %edx,%eax
  802a29:	c1 e8 02             	shr    $0x2,%eax
  802a2c:	c1 e0 02             	shl    $0x2,%eax
  802a2f:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802a32:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a35:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802a3b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a3e:	83 e8 08             	sub    $0x8,%eax
  802a41:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802a44:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a47:	8b 00                	mov    (%eax),%eax
  802a49:	83 e0 fe             	and    $0xfffffffe,%eax
  802a4c:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802a4f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a52:	f7 d8                	neg    %eax
  802a54:	89 c2                	mov    %eax,%edx
  802a56:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a59:	01 d0                	add    %edx,%eax
  802a5b:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802a5e:	83 ec 0c             	sub    $0xc,%esp
  802a61:	ff 75 b8             	pushl  -0x48(%ebp)
  802a64:	e8 1f f8 ff ff       	call   802288 <is_free_block>
  802a69:	83 c4 10             	add    $0x10,%esp
  802a6c:	0f be c0             	movsbl %al,%eax
  802a6f:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802a72:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802a76:	74 42                	je     802aba <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802a78:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a7f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a82:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a85:	01 d0                	add    %edx,%eax
  802a87:	48                   	dec    %eax
  802a88:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a8b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a8e:	ba 00 00 00 00       	mov    $0x0,%edx
  802a93:	f7 75 b0             	divl   -0x50(%ebp)
  802a96:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a99:	29 d0                	sub    %edx,%eax
  802a9b:	89 c2                	mov    %eax,%edx
  802a9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802aa0:	01 d0                	add    %edx,%eax
  802aa2:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802aa5:	83 ec 04             	sub    $0x4,%esp
  802aa8:	6a 00                	push   $0x0
  802aaa:	ff 75 a8             	pushl  -0x58(%ebp)
  802aad:	ff 75 b8             	pushl  -0x48(%ebp)
  802ab0:	e8 36 fa ff ff       	call   8024eb <set_block_data>
  802ab5:	83 c4 10             	add    $0x10,%esp
  802ab8:	eb 42                	jmp    802afc <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802aba:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802ac1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802ac4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802ac7:	01 d0                	add    %edx,%eax
  802ac9:	48                   	dec    %eax
  802aca:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802acd:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  802ad5:	f7 75 a4             	divl   -0x5c(%ebp)
  802ad8:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802adb:	29 d0                	sub    %edx,%eax
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	6a 00                	push   $0x0
  802ae2:	50                   	push   %eax
  802ae3:	ff 75 d0             	pushl  -0x30(%ebp)
  802ae6:	e8 00 fa ff ff       	call   8024eb <set_block_data>
  802aeb:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802aee:	83 ec 0c             	sub    $0xc,%esp
  802af1:	ff 75 d0             	pushl  -0x30(%ebp)
  802af4:	e8 49 fa ff ff       	call   802542 <insert_sorted_in_freeList>
  802af9:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802afc:	83 ec 0c             	sub    $0xc,%esp
  802aff:	ff 75 08             	pushl  0x8(%ebp)
  802b02:	e8 ce fb ff ff       	call   8026d5 <alloc_block_FF>
  802b07:	83 c4 10             	add    $0x10,%esp
}
  802b0a:	c9                   	leave  
  802b0b:	c3                   	ret    

00802b0c <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
  802b0f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802b12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b16:	75 0a                	jne    802b22 <alloc_block_BF+0x16>
	{
		return NULL;
  802b18:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1d:	e9 7a 02 00 00       	jmp    802d9c <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	83 c0 08             	add    $0x8,%eax
  802b28:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802b32:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802b39:	a1 48 50 98 00       	mov    0x985048,%eax
  802b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b41:	eb 32                	jmp    802b75 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802b43:	ff 75 ec             	pushl  -0x14(%ebp)
  802b46:	e8 24 f7 ff ff       	call   80226f <get_block_size>
  802b4b:	83 c4 04             	add    $0x4,%esp
  802b4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b54:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b57:	72 14                	jb     802b6d <alloc_block_BF+0x61>
  802b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b5f:	73 0c                	jae    802b6d <alloc_block_BF+0x61>
		{
			minBlk = block;
  802b61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802b67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802b6d:	a1 50 50 98 00       	mov    0x985050,%eax
  802b72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b75:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b79:	74 07                	je     802b82 <alloc_block_BF+0x76>
  802b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7e:	8b 00                	mov    (%eax),%eax
  802b80:	eb 05                	jmp    802b87 <alloc_block_BF+0x7b>
  802b82:	b8 00 00 00 00       	mov    $0x0,%eax
  802b87:	a3 50 50 98 00       	mov    %eax,0x985050
  802b8c:	a1 50 50 98 00       	mov    0x985050,%eax
  802b91:	85 c0                	test   %eax,%eax
  802b93:	75 ae                	jne    802b43 <alloc_block_BF+0x37>
  802b95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b99:	75 a8                	jne    802b43 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9f:	75 22                	jne    802bc3 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802ba1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba4:	83 ec 0c             	sub    $0xc,%esp
  802ba7:	50                   	push   %eax
  802ba8:	e8 f7 ef ff ff       	call   801ba4 <sbrk>
  802bad:	83 c4 10             	add    $0x10,%esp
  802bb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802bb3:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802bb7:	75 0a                	jne    802bc3 <alloc_block_BF+0xb7>
			return NULL;
  802bb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bbe:	e9 d9 01 00 00       	jmp    802d9c <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bc6:	83 c0 10             	add    $0x10,%eax
  802bc9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802bcc:	0f 87 32 01 00 00    	ja     802d04 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802bd8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be1:	01 d0                	add    %edx,%eax
  802be3:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	6a 00                	push   $0x0
  802beb:	ff 75 dc             	pushl  -0x24(%ebp)
  802bee:	ff 75 d8             	pushl  -0x28(%ebp)
  802bf1:	e8 f5 f8 ff ff       	call   8024eb <set_block_data>
  802bf6:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802bf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfd:	74 06                	je     802c05 <alloc_block_BF+0xf9>
  802bff:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802c03:	75 17                	jne    802c1c <alloc_block_BF+0x110>
  802c05:	83 ec 04             	sub    $0x4,%esp
  802c08:	68 10 40 80 00       	push   $0x804010
  802c0d:	68 49 01 00 00       	push   $0x149
  802c12:	68 9b 3f 80 00       	push   $0x803f9b
  802c17:	e8 f1 d6 ff ff       	call   80030d <_panic>
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 10                	mov    (%eax),%edx
  802c21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c24:	89 10                	mov    %edx,(%eax)
  802c26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 0b                	je     802c3a <alloc_block_BF+0x12e>
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	8b 00                	mov    (%eax),%eax
  802c34:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c37:	89 50 04             	mov    %edx,0x4(%eax)
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c40:	89 10                	mov    %edx,(%eax)
  802c42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c48:	89 50 04             	mov    %edx,0x4(%eax)
  802c4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	75 08                	jne    802c5c <alloc_block_BF+0x150>
  802c54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c57:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c5c:	a1 54 50 98 00       	mov    0x985054,%eax
  802c61:	40                   	inc    %eax
  802c62:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802c67:	83 ec 04             	sub    $0x4,%esp
  802c6a:	6a 01                	push   $0x1
  802c6c:	ff 75 e8             	pushl  -0x18(%ebp)
  802c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  802c72:	e8 74 f8 ff ff       	call   8024eb <set_block_data>
  802c77:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7e:	75 17                	jne    802c97 <alloc_block_BF+0x18b>
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	68 44 40 80 00       	push   $0x804044
  802c88:	68 4e 01 00 00       	push   $0x14e
  802c8d:	68 9b 3f 80 00       	push   $0x803f9b
  802c92:	e8 76 d6 ff ff       	call   80030d <_panic>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 10                	je     802cb0 <alloc_block_BF+0x1a4>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca8:	8b 52 04             	mov    0x4(%edx),%edx
  802cab:	89 50 04             	mov    %edx,0x4(%eax)
  802cae:	eb 0b                	jmp    802cbb <alloc_block_BF+0x1af>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 40 04             	mov    0x4(%eax),%eax
  802cb6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 40 04             	mov    0x4(%eax),%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	74 0f                	je     802cd4 <alloc_block_BF+0x1c8>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 04             	mov    0x4(%eax),%eax
  802ccb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cce:	8b 12                	mov    (%edx),%edx
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	eb 0a                	jmp    802cde <alloc_block_BF+0x1d2>
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 00                	mov    (%eax),%eax
  802cd9:	a3 48 50 98 00       	mov    %eax,0x985048
  802cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 54 50 98 00       	mov    0x985054,%eax
  802cf6:	48                   	dec    %eax
  802cf7:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cff:	e9 98 00 00 00       	jmp    802d9c <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802d04:	83 ec 04             	sub    $0x4,%esp
  802d07:	6a 01                	push   $0x1
  802d09:	ff 75 f0             	pushl  -0x10(%ebp)
  802d0c:	ff 75 f4             	pushl  -0xc(%ebp)
  802d0f:	e8 d7 f7 ff ff       	call   8024eb <set_block_data>
  802d14:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802d17:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1b:	75 17                	jne    802d34 <alloc_block_BF+0x228>
  802d1d:	83 ec 04             	sub    $0x4,%esp
  802d20:	68 44 40 80 00       	push   $0x804044
  802d25:	68 56 01 00 00       	push   $0x156
  802d2a:	68 9b 3f 80 00       	push   $0x803f9b
  802d2f:	e8 d9 d5 ff ff       	call   80030d <_panic>
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	85 c0                	test   %eax,%eax
  802d3b:	74 10                	je     802d4d <alloc_block_BF+0x241>
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d45:	8b 52 04             	mov    0x4(%edx),%edx
  802d48:	89 50 04             	mov    %edx,0x4(%eax)
  802d4b:	eb 0b                	jmp    802d58 <alloc_block_BF+0x24c>
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 04             	mov    0x4(%eax),%eax
  802d53:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 40 04             	mov    0x4(%eax),%eax
  802d5e:	85 c0                	test   %eax,%eax
  802d60:	74 0f                	je     802d71 <alloc_block_BF+0x265>
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 40 04             	mov    0x4(%eax),%eax
  802d68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6b:	8b 12                	mov    (%edx),%edx
  802d6d:	89 10                	mov    %edx,(%eax)
  802d6f:	eb 0a                	jmp    802d7b <alloc_block_BF+0x26f>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	a3 48 50 98 00       	mov    %eax,0x985048
  802d7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8e:	a1 54 50 98 00       	mov    0x985054,%eax
  802d93:	48                   	dec    %eax
  802d94:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802d9c:	c9                   	leave  
  802d9d:	c3                   	ret    

00802d9e <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d9e:	55                   	push   %ebp
  802d9f:	89 e5                	mov    %esp,%ebp
  802da1:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802da4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da8:	0f 84 6a 02 00 00    	je     803018 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802dae:	ff 75 08             	pushl  0x8(%ebp)
  802db1:	e8 b9 f4 ff ff       	call   80226f <get_block_size>
  802db6:	83 c4 04             	add    $0x4,%esp
  802db9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	83 e8 08             	sub    $0x8,%eax
  802dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	83 e0 fe             	and    $0xfffffffe,%eax
  802dcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd3:	f7 d8                	neg    %eax
  802dd5:	89 c2                	mov    %eax,%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	01 d0                	add    %edx,%eax
  802ddc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802ddf:	ff 75 e8             	pushl  -0x18(%ebp)
  802de2:	e8 a1 f4 ff ff       	call   802288 <is_free_block>
  802de7:	83 c4 04             	add    $0x4,%esp
  802dea:	0f be c0             	movsbl %al,%eax
  802ded:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802df0:	8b 55 08             	mov    0x8(%ebp),%edx
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	01 d0                	add    %edx,%eax
  802df8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802dfb:	ff 75 e0             	pushl  -0x20(%ebp)
  802dfe:	e8 85 f4 ff ff       	call   802288 <is_free_block>
  802e03:	83 c4 04             	add    $0x4,%esp
  802e06:	0f be c0             	movsbl %al,%eax
  802e09:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802e0c:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802e10:	75 34                	jne    802e46 <free_block+0xa8>
  802e12:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802e16:	75 2e                	jne    802e46 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802e18:	ff 75 e8             	pushl  -0x18(%ebp)
  802e1b:	e8 4f f4 ff ff       	call   80226f <get_block_size>
  802e20:	83 c4 04             	add    $0x4,%esp
  802e23:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802e26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e29:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802e2c:	01 d0                	add    %edx,%eax
  802e2e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802e31:	6a 00                	push   $0x0
  802e33:	ff 75 d4             	pushl  -0x2c(%ebp)
  802e36:	ff 75 e8             	pushl  -0x18(%ebp)
  802e39:	e8 ad f6 ff ff       	call   8024eb <set_block_data>
  802e3e:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802e41:	e9 d3 01 00 00       	jmp    803019 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802e46:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e4a:	0f 85 c8 00 00 00    	jne    802f18 <free_block+0x17a>
  802e50:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e54:	0f 85 be 00 00 00    	jne    802f18 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802e5a:	ff 75 e0             	pushl  -0x20(%ebp)
  802e5d:	e8 0d f4 ff ff       	call   80226f <get_block_size>
  802e62:	83 c4 04             	add    $0x4,%esp
  802e65:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802e68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e6b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e6e:	01 d0                	add    %edx,%eax
  802e70:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802e73:	6a 00                	push   $0x0
  802e75:	ff 75 cc             	pushl  -0x34(%ebp)
  802e78:	ff 75 08             	pushl  0x8(%ebp)
  802e7b:	e8 6b f6 ff ff       	call   8024eb <set_block_data>
  802e80:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802e83:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e87:	75 17                	jne    802ea0 <free_block+0x102>
  802e89:	83 ec 04             	sub    $0x4,%esp
  802e8c:	68 44 40 80 00       	push   $0x804044
  802e91:	68 87 01 00 00       	push   $0x187
  802e96:	68 9b 3f 80 00       	push   $0x803f9b
  802e9b:	e8 6d d4 ff ff       	call   80030d <_panic>
  802ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea3:	8b 00                	mov    (%eax),%eax
  802ea5:	85 c0                	test   %eax,%eax
  802ea7:	74 10                	je     802eb9 <free_block+0x11b>
  802ea9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eac:	8b 00                	mov    (%eax),%eax
  802eae:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eb1:	8b 52 04             	mov    0x4(%edx),%edx
  802eb4:	89 50 04             	mov    %edx,0x4(%eax)
  802eb7:	eb 0b                	jmp    802ec4 <free_block+0x126>
  802eb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802ec4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec7:	8b 40 04             	mov    0x4(%eax),%eax
  802eca:	85 c0                	test   %eax,%eax
  802ecc:	74 0f                	je     802edd <free_block+0x13f>
  802ece:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed1:	8b 40 04             	mov    0x4(%eax),%eax
  802ed4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ed7:	8b 12                	mov    (%edx),%edx
  802ed9:	89 10                	mov    %edx,(%eax)
  802edb:	eb 0a                	jmp    802ee7 <free_block+0x149>
  802edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	a3 48 50 98 00       	mov    %eax,0x985048
  802ee7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efa:	a1 54 50 98 00       	mov    0x985054,%eax
  802eff:	48                   	dec    %eax
  802f00:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802f05:	83 ec 0c             	sub    $0xc,%esp
  802f08:	ff 75 08             	pushl  0x8(%ebp)
  802f0b:	e8 32 f6 ff ff       	call   802542 <insert_sorted_in_freeList>
  802f10:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802f13:	e9 01 01 00 00       	jmp    803019 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802f18:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802f1c:	0f 85 d3 00 00 00    	jne    802ff5 <free_block+0x257>
  802f22:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802f26:	0f 85 c9 00 00 00    	jne    802ff5 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802f2c:	83 ec 0c             	sub    $0xc,%esp
  802f2f:	ff 75 e8             	pushl  -0x18(%ebp)
  802f32:	e8 38 f3 ff ff       	call   80226f <get_block_size>
  802f37:	83 c4 10             	add    $0x10,%esp
  802f3a:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802f3d:	83 ec 0c             	sub    $0xc,%esp
  802f40:	ff 75 e0             	pushl  -0x20(%ebp)
  802f43:	e8 27 f3 ff ff       	call   80226f <get_block_size>
  802f48:	83 c4 10             	add    $0x10,%esp
  802f4b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f51:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f54:	01 c2                	add    %eax,%edx
  802f56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f59:	01 d0                	add    %edx,%eax
  802f5b:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802f5e:	83 ec 04             	sub    $0x4,%esp
  802f61:	6a 00                	push   $0x0
  802f63:	ff 75 c0             	pushl  -0x40(%ebp)
  802f66:	ff 75 e8             	pushl  -0x18(%ebp)
  802f69:	e8 7d f5 ff ff       	call   8024eb <set_block_data>
  802f6e:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802f71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f75:	75 17                	jne    802f8e <free_block+0x1f0>
  802f77:	83 ec 04             	sub    $0x4,%esp
  802f7a:	68 44 40 80 00       	push   $0x804044
  802f7f:	68 94 01 00 00       	push   $0x194
  802f84:	68 9b 3f 80 00       	push   $0x803f9b
  802f89:	e8 7f d3 ff ff       	call   80030d <_panic>
  802f8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 10                	je     802fa7 <free_block+0x209>
  802f97:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f9f:	8b 52 04             	mov    0x4(%edx),%edx
  802fa2:	89 50 04             	mov    %edx,0x4(%eax)
  802fa5:	eb 0b                	jmp    802fb2 <free_block+0x214>
  802fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802faa:	8b 40 04             	mov    0x4(%eax),%eax
  802fad:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	85 c0                	test   %eax,%eax
  802fba:	74 0f                	je     802fcb <free_block+0x22d>
  802fbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fbf:	8b 40 04             	mov    0x4(%eax),%eax
  802fc2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fc5:	8b 12                	mov    (%edx),%edx
  802fc7:	89 10                	mov    %edx,(%eax)
  802fc9:	eb 0a                	jmp    802fd5 <free_block+0x237>
  802fcb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	a3 48 50 98 00       	mov    %eax,0x985048
  802fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fe1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe8:	a1 54 50 98 00       	mov    0x985054,%eax
  802fed:	48                   	dec    %eax
  802fee:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802ff3:	eb 24                	jmp    803019 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802ff5:	83 ec 04             	sub    $0x4,%esp
  802ff8:	6a 00                	push   $0x0
  802ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  802ffd:	ff 75 08             	pushl  0x8(%ebp)
  803000:	e8 e6 f4 ff ff       	call   8024eb <set_block_data>
  803005:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803008:	83 ec 0c             	sub    $0xc,%esp
  80300b:	ff 75 08             	pushl  0x8(%ebp)
  80300e:	e8 2f f5 ff ff       	call   802542 <insert_sorted_in_freeList>
  803013:	83 c4 10             	add    $0x10,%esp
  803016:	eb 01                	jmp    803019 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803018:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    

0080301b <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  80301b:	55                   	push   %ebp
  80301c:	89 e5                	mov    %esp,%ebp
  80301e:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803021:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803025:	75 10                	jne    803037 <realloc_block_FF+0x1c>
  803027:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80302b:	75 0a                	jne    803037 <realloc_block_FF+0x1c>
	{
		return NULL;
  80302d:	b8 00 00 00 00       	mov    $0x0,%eax
  803032:	e9 8b 04 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803037:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80303b:	75 18                	jne    803055 <realloc_block_FF+0x3a>
	{
		free_block(va);
  80303d:	83 ec 0c             	sub    $0xc,%esp
  803040:	ff 75 08             	pushl  0x8(%ebp)
  803043:	e8 56 fd ff ff       	call   802d9e <free_block>
  803048:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80304b:	b8 00 00 00 00       	mov    $0x0,%eax
  803050:	e9 6d 04 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803059:	75 13                	jne    80306e <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  80305b:	83 ec 0c             	sub    $0xc,%esp
  80305e:	ff 75 0c             	pushl  0xc(%ebp)
  803061:	e8 6f f6 ff ff       	call   8026d5 <alloc_block_FF>
  803066:	83 c4 10             	add    $0x10,%esp
  803069:	e9 54 04 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  80306e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803071:	83 e0 01             	and    $0x1,%eax
  803074:	85 c0                	test   %eax,%eax
  803076:	74 03                	je     80307b <realloc_block_FF+0x60>
	{
		new_size++;
  803078:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  80307b:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80307f:	77 07                	ja     803088 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803081:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803088:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80308c:	83 ec 0c             	sub    $0xc,%esp
  80308f:	ff 75 08             	pushl  0x8(%ebp)
  803092:	e8 d8 f1 ff ff       	call   80226f <get_block_size>
  803097:	83 c4 10             	add    $0x10,%esp
  80309a:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030a3:	75 08                	jne    8030ad <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	e9 15 04 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8030ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b3:	01 d0                	add    %edx,%eax
  8030b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8030b8:	83 ec 0c             	sub    $0xc,%esp
  8030bb:	ff 75 f0             	pushl  -0x10(%ebp)
  8030be:	e8 c5 f1 ff ff       	call   802288 <is_free_block>
  8030c3:	83 c4 10             	add    $0x10,%esp
  8030c6:	0f be c0             	movsbl %al,%eax
  8030c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8030cc:	83 ec 0c             	sub    $0xc,%esp
  8030cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8030d2:	e8 98 f1 ff ff       	call   80226f <get_block_size>
  8030d7:	83 c4 10             	add    $0x10,%esp
  8030da:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8030dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8030e3:	0f 86 a7 02 00 00    	jbe    803390 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8030e9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030ed:	0f 84 86 02 00 00    	je     803379 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8030f3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f9:	01 d0                	add    %edx,%eax
  8030fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030fe:	0f 85 b2 00 00 00    	jne    8031b6 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803104:	83 ec 0c             	sub    $0xc,%esp
  803107:	ff 75 08             	pushl  0x8(%ebp)
  80310a:	e8 79 f1 ff ff       	call   802288 <is_free_block>
  80310f:	83 c4 10             	add    $0x10,%esp
  803112:	84 c0                	test   %al,%al
  803114:	0f 94 c0             	sete   %al
  803117:	0f b6 c0             	movzbl %al,%eax
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	50                   	push   %eax
  80311e:	ff 75 0c             	pushl  0xc(%ebp)
  803121:	ff 75 08             	pushl  0x8(%ebp)
  803124:	e8 c2 f3 ff ff       	call   8024eb <set_block_data>
  803129:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  80312c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803130:	75 17                	jne    803149 <realloc_block_FF+0x12e>
  803132:	83 ec 04             	sub    $0x4,%esp
  803135:	68 44 40 80 00       	push   $0x804044
  80313a:	68 db 01 00 00       	push   $0x1db
  80313f:	68 9b 3f 80 00       	push   $0x803f9b
  803144:	e8 c4 d1 ff ff       	call   80030d <_panic>
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 00                	mov    (%eax),%eax
  80314e:	85 c0                	test   %eax,%eax
  803150:	74 10                	je     803162 <realloc_block_FF+0x147>
  803152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80315a:	8b 52 04             	mov    0x4(%edx),%edx
  80315d:	89 50 04             	mov    %edx,0x4(%eax)
  803160:	eb 0b                	jmp    80316d <realloc_block_FF+0x152>
  803162:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803165:	8b 40 04             	mov    0x4(%eax),%eax
  803168:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	8b 40 04             	mov    0x4(%eax),%eax
  803173:	85 c0                	test   %eax,%eax
  803175:	74 0f                	je     803186 <realloc_block_FF+0x16b>
  803177:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317a:	8b 40 04             	mov    0x4(%eax),%eax
  80317d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803180:	8b 12                	mov    (%edx),%edx
  803182:	89 10                	mov    %edx,(%eax)
  803184:	eb 0a                	jmp    803190 <realloc_block_FF+0x175>
  803186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803189:	8b 00                	mov    (%eax),%eax
  80318b:	a3 48 50 98 00       	mov    %eax,0x985048
  803190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803193:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a3:	a1 54 50 98 00       	mov    0x985054,%eax
  8031a8:	48                   	dec    %eax
  8031a9:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	e9 0c 03 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8031b6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bc:	01 d0                	add    %edx,%eax
  8031be:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031c1:	0f 86 b2 01 00 00    	jbe    803379 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8031c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ca:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8031cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8031d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8031d6:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8031d9:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8031dd:	0f 87 b8 00 00 00    	ja     80329b <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8031e3:	83 ec 0c             	sub    $0xc,%esp
  8031e6:	ff 75 08             	pushl  0x8(%ebp)
  8031e9:	e8 9a f0 ff ff       	call   802288 <is_free_block>
  8031ee:	83 c4 10             	add    $0x10,%esp
  8031f1:	84 c0                	test   %al,%al
  8031f3:	0f 94 c0             	sete   %al
  8031f6:	0f b6 c0             	movzbl %al,%eax
  8031f9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8031fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ff:	01 ca                	add    %ecx,%edx
  803201:	83 ec 04             	sub    $0x4,%esp
  803204:	50                   	push   %eax
  803205:	52                   	push   %edx
  803206:	ff 75 08             	pushl  0x8(%ebp)
  803209:	e8 dd f2 ff ff       	call   8024eb <set_block_data>
  80320e:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803211:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803215:	75 17                	jne    80322e <realloc_block_FF+0x213>
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 44 40 80 00       	push   $0x804044
  80321f:	68 e8 01 00 00       	push   $0x1e8
  803224:	68 9b 3f 80 00       	push   $0x803f9b
  803229:	e8 df d0 ff ff       	call   80030d <_panic>
  80322e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803231:	8b 00                	mov    (%eax),%eax
  803233:	85 c0                	test   %eax,%eax
  803235:	74 10                	je     803247 <realloc_block_FF+0x22c>
  803237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80323f:	8b 52 04             	mov    0x4(%edx),%edx
  803242:	89 50 04             	mov    %edx,0x4(%eax)
  803245:	eb 0b                	jmp    803252 <realloc_block_FF+0x237>
  803247:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324a:	8b 40 04             	mov    0x4(%eax),%eax
  80324d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803255:	8b 40 04             	mov    0x4(%eax),%eax
  803258:	85 c0                	test   %eax,%eax
  80325a:	74 0f                	je     80326b <realloc_block_FF+0x250>
  80325c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80325f:	8b 40 04             	mov    0x4(%eax),%eax
  803262:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803265:	8b 12                	mov    (%edx),%edx
  803267:	89 10                	mov    %edx,(%eax)
  803269:	eb 0a                	jmp    803275 <realloc_block_FF+0x25a>
  80326b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	a3 48 50 98 00       	mov    %eax,0x985048
  803275:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803278:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80327e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803281:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803288:	a1 54 50 98 00       	mov    0x985054,%eax
  80328d:	48                   	dec    %eax
  80328e:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	e9 27 02 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  80329b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80329f:	75 17                	jne    8032b8 <realloc_block_FF+0x29d>
  8032a1:	83 ec 04             	sub    $0x4,%esp
  8032a4:	68 44 40 80 00       	push   $0x804044
  8032a9:	68 ed 01 00 00       	push   $0x1ed
  8032ae:	68 9b 3f 80 00       	push   $0x803f9b
  8032b3:	e8 55 d0 ff ff       	call   80030d <_panic>
  8032b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	74 10                	je     8032d1 <realloc_block_FF+0x2b6>
  8032c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c4:	8b 00                	mov    (%eax),%eax
  8032c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032c9:	8b 52 04             	mov    0x4(%edx),%edx
  8032cc:	89 50 04             	mov    %edx,0x4(%eax)
  8032cf:	eb 0b                	jmp    8032dc <realloc_block_FF+0x2c1>
  8032d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d4:	8b 40 04             	mov    0x4(%eax),%eax
  8032d7:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032df:	8b 40 04             	mov    0x4(%eax),%eax
  8032e2:	85 c0                	test   %eax,%eax
  8032e4:	74 0f                	je     8032f5 <realloc_block_FF+0x2da>
  8032e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ef:	8b 12                	mov    (%edx),%edx
  8032f1:	89 10                	mov    %edx,(%eax)
  8032f3:	eb 0a                	jmp    8032ff <realloc_block_FF+0x2e4>
  8032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f8:	8b 00                	mov    (%eax),%eax
  8032fa:	a3 48 50 98 00       	mov    %eax,0x985048
  8032ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803308:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803312:	a1 54 50 98 00       	mov    0x985054,%eax
  803317:	48                   	dec    %eax
  803318:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  80331d:	8b 55 08             	mov    0x8(%ebp),%edx
  803320:	8b 45 0c             	mov    0xc(%ebp),%eax
  803323:	01 d0                	add    %edx,%eax
  803325:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803328:	83 ec 04             	sub    $0x4,%esp
  80332b:	6a 00                	push   $0x0
  80332d:	ff 75 e0             	pushl  -0x20(%ebp)
  803330:	ff 75 f0             	pushl  -0x10(%ebp)
  803333:	e8 b3 f1 ff ff       	call   8024eb <set_block_data>
  803338:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  80333b:	83 ec 0c             	sub    $0xc,%esp
  80333e:	ff 75 08             	pushl  0x8(%ebp)
  803341:	e8 42 ef ff ff       	call   802288 <is_free_block>
  803346:	83 c4 10             	add    $0x10,%esp
  803349:	84 c0                	test   %al,%al
  80334b:	0f 94 c0             	sete   %al
  80334e:	0f b6 c0             	movzbl %al,%eax
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	50                   	push   %eax
  803355:	ff 75 0c             	pushl  0xc(%ebp)
  803358:	ff 75 08             	pushl  0x8(%ebp)
  80335b:	e8 8b f1 ff ff       	call   8024eb <set_block_data>
  803360:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803363:	83 ec 0c             	sub    $0xc,%esp
  803366:	ff 75 f0             	pushl  -0x10(%ebp)
  803369:	e8 d4 f1 ff ff       	call   802542 <insert_sorted_in_freeList>
  80336e:	83 c4 10             	add    $0x10,%esp
					return va;
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	e9 49 01 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803379:	8b 45 0c             	mov    0xc(%ebp),%eax
  80337c:	83 e8 08             	sub    $0x8,%eax
  80337f:	83 ec 0c             	sub    $0xc,%esp
  803382:	50                   	push   %eax
  803383:	e8 4d f3 ff ff       	call   8026d5 <alloc_block_FF>
  803388:	83 c4 10             	add    $0x10,%esp
  80338b:	e9 32 01 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  803390:	8b 45 0c             	mov    0xc(%ebp),%eax
  803393:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803396:	0f 83 21 01 00 00    	jae    8034bd <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  80339c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339f:	2b 45 0c             	sub    0xc(%ebp),%eax
  8033a2:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8033a5:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8033a9:	77 0e                	ja     8033b9 <realloc_block_FF+0x39e>
  8033ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033af:	75 08                	jne    8033b9 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	e9 09 01 00 00       	jmp    8034c2 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8033bf:	83 ec 0c             	sub    $0xc,%esp
  8033c2:	ff 75 08             	pushl  0x8(%ebp)
  8033c5:	e8 be ee ff ff       	call   802288 <is_free_block>
  8033ca:	83 c4 10             	add    $0x10,%esp
  8033cd:	84 c0                	test   %al,%al
  8033cf:	0f 94 c0             	sete   %al
  8033d2:	0f b6 c0             	movzbl %al,%eax
  8033d5:	83 ec 04             	sub    $0x4,%esp
  8033d8:	50                   	push   %eax
  8033d9:	ff 75 0c             	pushl  0xc(%ebp)
  8033dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8033df:	e8 07 f1 ff ff       	call   8024eb <set_block_data>
  8033e4:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8033e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ed:	01 d0                	add    %edx,%eax
  8033ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8033f2:	83 ec 04             	sub    $0x4,%esp
  8033f5:	6a 00                	push   $0x0
  8033f7:	ff 75 dc             	pushl  -0x24(%ebp)
  8033fa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033fd:	e8 e9 f0 ff ff       	call   8024eb <set_block_data>
  803402:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803405:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803409:	0f 84 9b 00 00 00    	je     8034aa <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80340f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803412:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803415:	01 d0                	add    %edx,%eax
  803417:	83 ec 04             	sub    $0x4,%esp
  80341a:	6a 00                	push   $0x0
  80341c:	50                   	push   %eax
  80341d:	ff 75 d4             	pushl  -0x2c(%ebp)
  803420:	e8 c6 f0 ff ff       	call   8024eb <set_block_data>
  803425:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803428:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80342c:	75 17                	jne    803445 <realloc_block_FF+0x42a>
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 44 40 80 00       	push   $0x804044
  803436:	68 10 02 00 00       	push   $0x210
  80343b:	68 9b 3f 80 00       	push   $0x803f9b
  803440:	e8 c8 ce ff ff       	call   80030d <_panic>
  803445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803448:	8b 00                	mov    (%eax),%eax
  80344a:	85 c0                	test   %eax,%eax
  80344c:	74 10                	je     80345e <realloc_block_FF+0x443>
  80344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803456:	8b 52 04             	mov    0x4(%edx),%edx
  803459:	89 50 04             	mov    %edx,0x4(%eax)
  80345c:	eb 0b                	jmp    803469 <realloc_block_FF+0x44e>
  80345e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803461:	8b 40 04             	mov    0x4(%eax),%eax
  803464:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80346c:	8b 40 04             	mov    0x4(%eax),%eax
  80346f:	85 c0                	test   %eax,%eax
  803471:	74 0f                	je     803482 <realloc_block_FF+0x467>
  803473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803476:	8b 40 04             	mov    0x4(%eax),%eax
  803479:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80347c:	8b 12                	mov    (%edx),%edx
  80347e:	89 10                	mov    %edx,(%eax)
  803480:	eb 0a                	jmp    80348c <realloc_block_FF+0x471>
  803482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803485:	8b 00                	mov    (%eax),%eax
  803487:	a3 48 50 98 00       	mov    %eax,0x985048
  80348c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80348f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349f:	a1 54 50 98 00       	mov    0x985054,%eax
  8034a4:	48                   	dec    %eax
  8034a5:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8034aa:	83 ec 0c             	sub    $0xc,%esp
  8034ad:	ff 75 d4             	pushl  -0x2c(%ebp)
  8034b0:	e8 8d f0 ff ff       	call   802542 <insert_sorted_in_freeList>
  8034b5:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8034b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8034bb:	eb 05                	jmp    8034c2 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8034bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8034c2:	c9                   	leave  
  8034c3:	c3                   	ret    

008034c4 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8034c4:	55                   	push   %ebp
  8034c5:	89 e5                	mov    %esp,%ebp
  8034c7:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8034ca:	83 ec 04             	sub    $0x4,%esp
  8034cd:	68 64 40 80 00       	push   $0x804064
  8034d2:	68 20 02 00 00       	push   $0x220
  8034d7:	68 9b 3f 80 00       	push   $0x803f9b
  8034dc:	e8 2c ce ff ff       	call   80030d <_panic>

008034e1 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8034e1:	55                   	push   %ebp
  8034e2:	89 e5                	mov    %esp,%ebp
  8034e4:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8034e7:	83 ec 04             	sub    $0x4,%esp
  8034ea:	68 8c 40 80 00       	push   $0x80408c
  8034ef:	68 28 02 00 00       	push   $0x228
  8034f4:	68 9b 3f 80 00       	push   $0x803f9b
  8034f9:	e8 0f ce ff ff       	call   80030d <_panic>
  8034fe:	66 90                	xchg   %ax,%ax

00803500 <__udivdi3>:
  803500:	55                   	push   %ebp
  803501:	57                   	push   %edi
  803502:	56                   	push   %esi
  803503:	53                   	push   %ebx
  803504:	83 ec 1c             	sub    $0x1c,%esp
  803507:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80350b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80350f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803513:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803517:	89 ca                	mov    %ecx,%edx
  803519:	89 f8                	mov    %edi,%eax
  80351b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80351f:	85 f6                	test   %esi,%esi
  803521:	75 2d                	jne    803550 <__udivdi3+0x50>
  803523:	39 cf                	cmp    %ecx,%edi
  803525:	77 65                	ja     80358c <__udivdi3+0x8c>
  803527:	89 fd                	mov    %edi,%ebp
  803529:	85 ff                	test   %edi,%edi
  80352b:	75 0b                	jne    803538 <__udivdi3+0x38>
  80352d:	b8 01 00 00 00       	mov    $0x1,%eax
  803532:	31 d2                	xor    %edx,%edx
  803534:	f7 f7                	div    %edi
  803536:	89 c5                	mov    %eax,%ebp
  803538:	31 d2                	xor    %edx,%edx
  80353a:	89 c8                	mov    %ecx,%eax
  80353c:	f7 f5                	div    %ebp
  80353e:	89 c1                	mov    %eax,%ecx
  803540:	89 d8                	mov    %ebx,%eax
  803542:	f7 f5                	div    %ebp
  803544:	89 cf                	mov    %ecx,%edi
  803546:	89 fa                	mov    %edi,%edx
  803548:	83 c4 1c             	add    $0x1c,%esp
  80354b:	5b                   	pop    %ebx
  80354c:	5e                   	pop    %esi
  80354d:	5f                   	pop    %edi
  80354e:	5d                   	pop    %ebp
  80354f:	c3                   	ret    
  803550:	39 ce                	cmp    %ecx,%esi
  803552:	77 28                	ja     80357c <__udivdi3+0x7c>
  803554:	0f bd fe             	bsr    %esi,%edi
  803557:	83 f7 1f             	xor    $0x1f,%edi
  80355a:	75 40                	jne    80359c <__udivdi3+0x9c>
  80355c:	39 ce                	cmp    %ecx,%esi
  80355e:	72 0a                	jb     80356a <__udivdi3+0x6a>
  803560:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803564:	0f 87 9e 00 00 00    	ja     803608 <__udivdi3+0x108>
  80356a:	b8 01 00 00 00       	mov    $0x1,%eax
  80356f:	89 fa                	mov    %edi,%edx
  803571:	83 c4 1c             	add    $0x1c,%esp
  803574:	5b                   	pop    %ebx
  803575:	5e                   	pop    %esi
  803576:	5f                   	pop    %edi
  803577:	5d                   	pop    %ebp
  803578:	c3                   	ret    
  803579:	8d 76 00             	lea    0x0(%esi),%esi
  80357c:	31 ff                	xor    %edi,%edi
  80357e:	31 c0                	xor    %eax,%eax
  803580:	89 fa                	mov    %edi,%edx
  803582:	83 c4 1c             	add    $0x1c,%esp
  803585:	5b                   	pop    %ebx
  803586:	5e                   	pop    %esi
  803587:	5f                   	pop    %edi
  803588:	5d                   	pop    %ebp
  803589:	c3                   	ret    
  80358a:	66 90                	xchg   %ax,%ax
  80358c:	89 d8                	mov    %ebx,%eax
  80358e:	f7 f7                	div    %edi
  803590:	31 ff                	xor    %edi,%edi
  803592:	89 fa                	mov    %edi,%edx
  803594:	83 c4 1c             	add    $0x1c,%esp
  803597:	5b                   	pop    %ebx
  803598:	5e                   	pop    %esi
  803599:	5f                   	pop    %edi
  80359a:	5d                   	pop    %ebp
  80359b:	c3                   	ret    
  80359c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035a1:	89 eb                	mov    %ebp,%ebx
  8035a3:	29 fb                	sub    %edi,%ebx
  8035a5:	89 f9                	mov    %edi,%ecx
  8035a7:	d3 e6                	shl    %cl,%esi
  8035a9:	89 c5                	mov    %eax,%ebp
  8035ab:	88 d9                	mov    %bl,%cl
  8035ad:	d3 ed                	shr    %cl,%ebp
  8035af:	89 e9                	mov    %ebp,%ecx
  8035b1:	09 f1                	or     %esi,%ecx
  8035b3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035b7:	89 f9                	mov    %edi,%ecx
  8035b9:	d3 e0                	shl    %cl,%eax
  8035bb:	89 c5                	mov    %eax,%ebp
  8035bd:	89 d6                	mov    %edx,%esi
  8035bf:	88 d9                	mov    %bl,%cl
  8035c1:	d3 ee                	shr    %cl,%esi
  8035c3:	89 f9                	mov    %edi,%ecx
  8035c5:	d3 e2                	shl    %cl,%edx
  8035c7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035cb:	88 d9                	mov    %bl,%cl
  8035cd:	d3 e8                	shr    %cl,%eax
  8035cf:	09 c2                	or     %eax,%edx
  8035d1:	89 d0                	mov    %edx,%eax
  8035d3:	89 f2                	mov    %esi,%edx
  8035d5:	f7 74 24 0c          	divl   0xc(%esp)
  8035d9:	89 d6                	mov    %edx,%esi
  8035db:	89 c3                	mov    %eax,%ebx
  8035dd:	f7 e5                	mul    %ebp
  8035df:	39 d6                	cmp    %edx,%esi
  8035e1:	72 19                	jb     8035fc <__udivdi3+0xfc>
  8035e3:	74 0b                	je     8035f0 <__udivdi3+0xf0>
  8035e5:	89 d8                	mov    %ebx,%eax
  8035e7:	31 ff                	xor    %edi,%edi
  8035e9:	e9 58 ff ff ff       	jmp    803546 <__udivdi3+0x46>
  8035ee:	66 90                	xchg   %ax,%ax
  8035f0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035f4:	89 f9                	mov    %edi,%ecx
  8035f6:	d3 e2                	shl    %cl,%edx
  8035f8:	39 c2                	cmp    %eax,%edx
  8035fa:	73 e9                	jae    8035e5 <__udivdi3+0xe5>
  8035fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035ff:	31 ff                	xor    %edi,%edi
  803601:	e9 40 ff ff ff       	jmp    803546 <__udivdi3+0x46>
  803606:	66 90                	xchg   %ax,%ax
  803608:	31 c0                	xor    %eax,%eax
  80360a:	e9 37 ff ff ff       	jmp    803546 <__udivdi3+0x46>
  80360f:	90                   	nop

00803610 <__umoddi3>:
  803610:	55                   	push   %ebp
  803611:	57                   	push   %edi
  803612:	56                   	push   %esi
  803613:	53                   	push   %ebx
  803614:	83 ec 1c             	sub    $0x1c,%esp
  803617:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80361b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80361f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803623:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803627:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80362b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80362f:	89 f3                	mov    %esi,%ebx
  803631:	89 fa                	mov    %edi,%edx
  803633:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803637:	89 34 24             	mov    %esi,(%esp)
  80363a:	85 c0                	test   %eax,%eax
  80363c:	75 1a                	jne    803658 <__umoddi3+0x48>
  80363e:	39 f7                	cmp    %esi,%edi
  803640:	0f 86 a2 00 00 00    	jbe    8036e8 <__umoddi3+0xd8>
  803646:	89 c8                	mov    %ecx,%eax
  803648:	89 f2                	mov    %esi,%edx
  80364a:	f7 f7                	div    %edi
  80364c:	89 d0                	mov    %edx,%eax
  80364e:	31 d2                	xor    %edx,%edx
  803650:	83 c4 1c             	add    $0x1c,%esp
  803653:	5b                   	pop    %ebx
  803654:	5e                   	pop    %esi
  803655:	5f                   	pop    %edi
  803656:	5d                   	pop    %ebp
  803657:	c3                   	ret    
  803658:	39 f0                	cmp    %esi,%eax
  80365a:	0f 87 ac 00 00 00    	ja     80370c <__umoddi3+0xfc>
  803660:	0f bd e8             	bsr    %eax,%ebp
  803663:	83 f5 1f             	xor    $0x1f,%ebp
  803666:	0f 84 ac 00 00 00    	je     803718 <__umoddi3+0x108>
  80366c:	bf 20 00 00 00       	mov    $0x20,%edi
  803671:	29 ef                	sub    %ebp,%edi
  803673:	89 fe                	mov    %edi,%esi
  803675:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803679:	89 e9                	mov    %ebp,%ecx
  80367b:	d3 e0                	shl    %cl,%eax
  80367d:	89 d7                	mov    %edx,%edi
  80367f:	89 f1                	mov    %esi,%ecx
  803681:	d3 ef                	shr    %cl,%edi
  803683:	09 c7                	or     %eax,%edi
  803685:	89 e9                	mov    %ebp,%ecx
  803687:	d3 e2                	shl    %cl,%edx
  803689:	89 14 24             	mov    %edx,(%esp)
  80368c:	89 d8                	mov    %ebx,%eax
  80368e:	d3 e0                	shl    %cl,%eax
  803690:	89 c2                	mov    %eax,%edx
  803692:	8b 44 24 08          	mov    0x8(%esp),%eax
  803696:	d3 e0                	shl    %cl,%eax
  803698:	89 44 24 04          	mov    %eax,0x4(%esp)
  80369c:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036a0:	89 f1                	mov    %esi,%ecx
  8036a2:	d3 e8                	shr    %cl,%eax
  8036a4:	09 d0                	or     %edx,%eax
  8036a6:	d3 eb                	shr    %cl,%ebx
  8036a8:	89 da                	mov    %ebx,%edx
  8036aa:	f7 f7                	div    %edi
  8036ac:	89 d3                	mov    %edx,%ebx
  8036ae:	f7 24 24             	mull   (%esp)
  8036b1:	89 c6                	mov    %eax,%esi
  8036b3:	89 d1                	mov    %edx,%ecx
  8036b5:	39 d3                	cmp    %edx,%ebx
  8036b7:	0f 82 87 00 00 00    	jb     803744 <__umoddi3+0x134>
  8036bd:	0f 84 91 00 00 00    	je     803754 <__umoddi3+0x144>
  8036c3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036c7:	29 f2                	sub    %esi,%edx
  8036c9:	19 cb                	sbb    %ecx,%ebx
  8036cb:	89 d8                	mov    %ebx,%eax
  8036cd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036d1:	d3 e0                	shl    %cl,%eax
  8036d3:	89 e9                	mov    %ebp,%ecx
  8036d5:	d3 ea                	shr    %cl,%edx
  8036d7:	09 d0                	or     %edx,%eax
  8036d9:	89 e9                	mov    %ebp,%ecx
  8036db:	d3 eb                	shr    %cl,%ebx
  8036dd:	89 da                	mov    %ebx,%edx
  8036df:	83 c4 1c             	add    $0x1c,%esp
  8036e2:	5b                   	pop    %ebx
  8036e3:	5e                   	pop    %esi
  8036e4:	5f                   	pop    %edi
  8036e5:	5d                   	pop    %ebp
  8036e6:	c3                   	ret    
  8036e7:	90                   	nop
  8036e8:	89 fd                	mov    %edi,%ebp
  8036ea:	85 ff                	test   %edi,%edi
  8036ec:	75 0b                	jne    8036f9 <__umoddi3+0xe9>
  8036ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f3:	31 d2                	xor    %edx,%edx
  8036f5:	f7 f7                	div    %edi
  8036f7:	89 c5                	mov    %eax,%ebp
  8036f9:	89 f0                	mov    %esi,%eax
  8036fb:	31 d2                	xor    %edx,%edx
  8036fd:	f7 f5                	div    %ebp
  8036ff:	89 c8                	mov    %ecx,%eax
  803701:	f7 f5                	div    %ebp
  803703:	89 d0                	mov    %edx,%eax
  803705:	e9 44 ff ff ff       	jmp    80364e <__umoddi3+0x3e>
  80370a:	66 90                	xchg   %ax,%ax
  80370c:	89 c8                	mov    %ecx,%eax
  80370e:	89 f2                	mov    %esi,%edx
  803710:	83 c4 1c             	add    $0x1c,%esp
  803713:	5b                   	pop    %ebx
  803714:	5e                   	pop    %esi
  803715:	5f                   	pop    %edi
  803716:	5d                   	pop    %ebp
  803717:	c3                   	ret    
  803718:	3b 04 24             	cmp    (%esp),%eax
  80371b:	72 06                	jb     803723 <__umoddi3+0x113>
  80371d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803721:	77 0f                	ja     803732 <__umoddi3+0x122>
  803723:	89 f2                	mov    %esi,%edx
  803725:	29 f9                	sub    %edi,%ecx
  803727:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80372b:	89 14 24             	mov    %edx,(%esp)
  80372e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803732:	8b 44 24 04          	mov    0x4(%esp),%eax
  803736:	8b 14 24             	mov    (%esp),%edx
  803739:	83 c4 1c             	add    $0x1c,%esp
  80373c:	5b                   	pop    %ebx
  80373d:	5e                   	pop    %esi
  80373e:	5f                   	pop    %edi
  80373f:	5d                   	pop    %ebp
  803740:	c3                   	ret    
  803741:	8d 76 00             	lea    0x0(%esi),%esi
  803744:	2b 04 24             	sub    (%esp),%eax
  803747:	19 fa                	sbb    %edi,%edx
  803749:	89 d1                	mov    %edx,%ecx
  80374b:	89 c6                	mov    %eax,%esi
  80374d:	e9 71 ff ff ff       	jmp    8036c3 <__umoddi3+0xb3>
  803752:	66 90                	xchg   %ax,%ax
  803754:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803758:	72 ea                	jb     803744 <__umoddi3+0x134>
  80375a:	89 d9                	mov    %ebx,%ecx
  80375c:	e9 62 ff ff ff       	jmp    8036c3 <__umoddi3+0xb3>
