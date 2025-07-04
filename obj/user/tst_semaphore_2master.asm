
obj/user/tst_semaphore_2master:     file format elf32-i386


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
  800031:	e8 a9 01 00 00       	call   8001df <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: take user input, create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 38 01 00 00    	sub    $0x138,%esp
	int envID = sys_getenvid();
  800041:	e8 0d 18 00 00       	call   801853 <sys_getenvid>
  800046:	89 45 f0             	mov    %eax,-0x10(%ebp)
	char line[256] ;
	readline("Enter total number of customers: ", line) ;
  800049:	83 ec 08             	sub    $0x8,%esp
  80004c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800052:	50                   	push   %eax
  800053:	68 80 3a 80 00       	push   $0x803a80
  800058:	e8 18 0c 00 00       	call   800c75 <readline>
  80005d:	83 c4 10             	add    $0x10,%esp
	int totalNumOfCusts = strtol(line, NULL, 10);
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	6a 0a                	push   $0xa
  800065:	6a 00                	push   $0x0
  800067:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80006d:	50                   	push   %eax
  80006e:	e8 6a 11 00 00       	call   8011dd <strtol>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	readline("Enter shop capacity: ", line) ;
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  800082:	50                   	push   %eax
  800083:	68 a2 3a 80 00       	push   $0x803aa2
  800088:	e8 e8 0b 00 00       	call   800c75 <readline>
  80008d:	83 c4 10             	add    $0x10,%esp
	int shopCapacity = strtol(line, NULL, 10);
  800090:	83 ec 04             	sub    $0x4,%esp
  800093:	6a 0a                	push   $0xa
  800095:	6a 00                	push   $0x0
  800097:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  80009d:	50                   	push   %eax
  80009e:	e8 3a 11 00 00       	call   8011dd <strtol>
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct semaphore shopCapacitySem = create_semaphore("shopCapacity", shopCapacity);
  8000a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ac:	8d 85 d8 fe ff ff    	lea    -0x128(%ebp),%eax
  8000b2:	83 ec 04             	sub    $0x4,%esp
  8000b5:	52                   	push   %edx
  8000b6:	68 b8 3a 80 00       	push   $0x803ab8
  8000bb:	50                   	push   %eax
  8000bc:	e8 5f 1b 00 00       	call   801c20 <create_semaphore>
  8000c1:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = create_semaphore("depend", 0);
  8000c4:	8d 85 d4 fe ff ff    	lea    -0x12c(%ebp),%eax
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	6a 00                	push   $0x0
  8000cf:	68 c5 3a 80 00       	push   $0x803ac5
  8000d4:	50                   	push   %eax
  8000d5:	e8 46 1b 00 00       	call   801c20 <create_semaphore>
  8000da:	83 c4 0c             	add    $0xc,%esp

	int i = 0 ;
  8000dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int id ;
	for (; i<totalNumOfCusts; i++)
  8000e4:	eb 61                	jmp    800147 <_main+0x10f>
	{
		id = sys_create_env("sem2Slave", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 90 90 05 00 00    	mov    0x590(%eax),%edx
  8000f1:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f6:	8b 80 88 05 00 00    	mov    0x588(%eax),%eax
  8000fc:	89 c1                	mov    %eax,%ecx
  8000fe:	a1 20 50 80 00       	mov    0x805020,%eax
  800103:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
  800109:	52                   	push   %edx
  80010a:	51                   	push   %ecx
  80010b:	50                   	push   %eax
  80010c:	68 cc 3a 80 00       	push   $0x803acc
  800111:	e8 e8 16 00 00       	call   8017fe <sys_create_env>
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (id == E_ENV_CREATION_ERROR)
  80011c:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800120:	75 14                	jne    800136 <_main+0xfe>
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
  800122:	83 ec 04             	sub    $0x4,%esp
  800125:	68 d8 3a 80 00       	push   $0x803ad8
  80012a:	6a 18                	push   $0x18
  80012c:	68 24 3b 80 00       	push   $0x803b24
  800131:	e8 ee 01 00 00       	call   800324 <_panic>
		sys_run_env(id) ;
  800136:	83 ec 0c             	sub    $0xc,%esp
  800139:	ff 75 e4             	pushl  -0x1c(%ebp)
  80013c:	e8 db 16 00 00       	call   80181c <sys_run_env>
  800141:	83 c4 10             	add    $0x10,%esp
	struct semaphore shopCapacitySem = create_semaphore("shopCapacity", shopCapacity);
	struct semaphore dependSem = create_semaphore("depend", 0);

	int i = 0 ;
	int id ;
	for (; i<totalNumOfCusts; i++)
  800144:	ff 45 f4             	incl   -0xc(%ebp)
  800147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80014a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80014d:	7c 97                	jl     8000e6 <_main+0xae>
		if (id == E_ENV_CREATION_ERROR)
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  80014f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800156:	eb 14                	jmp    80016c <_main+0x134>
	{
		wait_semaphore(dependSem);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
  800161:	e8 86 1b 00 00       	call   801cec <wait_semaphore>
  800166:	83 c4 10             	add    $0x10,%esp
		if (id == E_ENV_CREATION_ERROR)
			panic("NO AVAILABLE ENVs... Please reduce the number of customers and try again...");
		sys_run_env(id) ;
	}

	for (i = 0 ; i<totalNumOfCusts; i++)
  800169:	ff 45 f4             	incl   -0xc(%ebp)
  80016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80016f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800172:	7c e4                	jl     800158 <_main+0x120>
	{
		wait_semaphore(dependSem);
	}
	int sem1val = semaphore_count(shopCapacitySem);
  800174:	83 ec 0c             	sub    $0xc,%esp
  800177:	ff b5 d8 fe ff ff    	pushl  -0x128(%ebp)
  80017d:	e8 36 1c 00 00       	call   801db8 <semaphore_count>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int sem2val = semaphore_count(dependSem);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	ff b5 d4 fe ff ff    	pushl  -0x12c(%ebp)
  800191:	e8 22 1c 00 00       	call   801db8 <semaphore_count>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 dc             	mov    %eax,-0x24(%ebp)

	//wait a while to allow the slaves to finish printing their closing messages
	env_sleep(10000);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	68 10 27 00 00       	push   $0x2710
  8001a4:	e8 1a 1c 00 00       	call   801dc3 <env_sleep>
  8001a9:	83 c4 10             	add    $0x10,%esp
	if (sem2val == 0 && sem1val == shopCapacity)
  8001ac:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001b0:	75 1a                	jne    8001cc <_main+0x194>
  8001b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001b5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8001b8:	75 12                	jne    8001cc <_main+0x194>
		cprintf("\nCongratulations!! Test of Semaphores [2] completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 44 3b 80 00       	push   $0x803b44
  8001c2:	e8 1a 04 00 00       	call   8005e1 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp
  8001ca:	eb 10                	jmp    8001dc <_main+0x1a4>
	else
		cprintf("\nError: wrong semaphore value... please review your semaphore code again...\n");
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	68 8c 3b 80 00       	push   $0x803b8c
  8001d4:	e8 08 04 00 00       	call   8005e1 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp

	return;
  8001dc:	90                   	nop
}
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    

008001df <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8001e5:	e8 82 16 00 00       	call   80186c <sys_getenvindex>
  8001ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8001ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001f0:	89 d0                	mov    %edx,%eax
  8001f2:	c1 e0 02             	shl    $0x2,%eax
  8001f5:	01 d0                	add    %edx,%eax
  8001f7:	c1 e0 03             	shl    $0x3,%eax
  8001fa:	01 d0                	add    %edx,%eax
  8001fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800203:	01 d0                	add    %edx,%eax
  800205:	c1 e0 02             	shl    $0x2,%eax
  800208:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80020d:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800212:	a1 20 50 80 00       	mov    0x805020,%eax
  800217:	8a 40 20             	mov    0x20(%eax),%al
  80021a:	84 c0                	test   %al,%al
  80021c:	74 0d                	je     80022b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80021e:	a1 20 50 80 00       	mov    0x805020,%eax
  800223:	83 c0 20             	add    $0x20,%eax
  800226:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80022b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022f:	7e 0a                	jle    80023b <libmain+0x5c>
		binaryname = argv[0];
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	8b 00                	mov    (%eax),%eax
  800236:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	ff 75 0c             	pushl  0xc(%ebp)
  800241:	ff 75 08             	pushl  0x8(%ebp)
  800244:	e8 ef fd ff ff       	call   800038 <_main>
  800249:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80024c:	a1 00 50 80 00       	mov    0x805000,%eax
  800251:	85 c0                	test   %eax,%eax
  800253:	0f 84 9f 00 00 00    	je     8002f8 <libmain+0x119>
	{
		sys_lock_cons();
  800259:	e8 92 13 00 00       	call   8015f0 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	68 f4 3b 80 00       	push   $0x803bf4
  800266:	e8 76 03 00 00       	call   8005e1 <cprintf>
  80026b:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80026e:	a1 20 50 80 00       	mov    0x805020,%eax
  800273:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800279:	a1 20 50 80 00       	mov    0x805020,%eax
  80027e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800284:	83 ec 04             	sub    $0x4,%esp
  800287:	52                   	push   %edx
  800288:	50                   	push   %eax
  800289:	68 1c 3c 80 00       	push   $0x803c1c
  80028e:	e8 4e 03 00 00       	call   8005e1 <cprintf>
  800293:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800296:	a1 20 50 80 00       	mov    0x805020,%eax
  80029b:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8002a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a6:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8002ac:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b1:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8002b7:	51                   	push   %ecx
  8002b8:	52                   	push   %edx
  8002b9:	50                   	push   %eax
  8002ba:	68 44 3c 80 00       	push   $0x803c44
  8002bf:	e8 1d 03 00 00       	call   8005e1 <cprintf>
  8002c4:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8002cc:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	50                   	push   %eax
  8002d6:	68 9c 3c 80 00       	push   $0x803c9c
  8002db:	e8 01 03 00 00       	call   8005e1 <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8002e3:	83 ec 0c             	sub    $0xc,%esp
  8002e6:	68 f4 3b 80 00       	push   $0x803bf4
  8002eb:	e8 f1 02 00 00       	call   8005e1 <cprintf>
  8002f0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8002f3:	e8 12 13 00 00       	call   80160a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8002f8:	e8 19 00 00 00       	call   800316 <exit>
}
  8002fd:	90                   	nop
  8002fe:	c9                   	leave  
  8002ff:	c3                   	ret    

00800300 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800306:	83 ec 0c             	sub    $0xc,%esp
  800309:	6a 00                	push   $0x0
  80030b:	e8 28 15 00 00       	call   801838 <sys_destroy_env>
  800310:	83 c4 10             	add    $0x10,%esp
}
  800313:	90                   	nop
  800314:	c9                   	leave  
  800315:	c3                   	ret    

00800316 <exit>:

void
exit(void)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031c:	e8 7d 15 00 00       	call   80189e <sys_exit_env>
}
  800321:	90                   	nop
  800322:	c9                   	leave  
  800323:	c3                   	ret    

00800324 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800324:	55                   	push   %ebp
  800325:	89 e5                	mov    %esp,%ebp
  800327:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032a:	8d 45 10             	lea    0x10(%ebp),%eax
  80032d:	83 c0 04             	add    $0x4,%eax
  800330:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800333:	a1 60 50 98 00       	mov    0x985060,%eax
  800338:	85 c0                	test   %eax,%eax
  80033a:	74 16                	je     800352 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033c:	a1 60 50 98 00       	mov    0x985060,%eax
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	50                   	push   %eax
  800345:	68 b0 3c 80 00       	push   $0x803cb0
  80034a:	e8 92 02 00 00       	call   8005e1 <cprintf>
  80034f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800352:	a1 04 50 80 00       	mov    0x805004,%eax
  800357:	ff 75 0c             	pushl  0xc(%ebp)
  80035a:	ff 75 08             	pushl  0x8(%ebp)
  80035d:	50                   	push   %eax
  80035e:	68 b5 3c 80 00       	push   $0x803cb5
  800363:	e8 79 02 00 00       	call   8005e1 <cprintf>
  800368:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036b:	8b 45 10             	mov    0x10(%ebp),%eax
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	ff 75 f4             	pushl  -0xc(%ebp)
  800374:	50                   	push   %eax
  800375:	e8 fc 01 00 00       	call   800576 <vcprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	6a 00                	push   $0x0
  800382:	68 d1 3c 80 00       	push   $0x803cd1
  800387:	e8 ea 01 00 00       	call   800576 <vcprintf>
  80038c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80038f:	e8 82 ff ff ff       	call   800316 <exit>

	// should not return here
	while (1) ;
  800394:	eb fe                	jmp    800394 <_panic+0x70>

00800396 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039c:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8003a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	74 14                	je     8003c2 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ae:	83 ec 04             	sub    $0x4,%esp
  8003b1:	68 d4 3c 80 00       	push   $0x803cd4
  8003b6:	6a 26                	push   $0x26
  8003b8:	68 20 3d 80 00       	push   $0x803d20
  8003bd:	e8 62 ff ff ff       	call   800324 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003d0:	e9 c5 00 00 00       	jmp    80049a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8003d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	01 d0                	add    %edx,%eax
  8003e4:	8b 00                	mov    (%eax),%eax
  8003e6:	85 c0                	test   %eax,%eax
  8003e8:	75 08                	jne    8003f2 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8003ea:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ed:	e9 a5 00 00 00       	jmp    800497 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8003f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800400:	eb 69                	jmp    80046b <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800402:	a1 20 50 80 00       	mov    0x805020,%eax
  800407:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80040d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800410:	89 d0                	mov    %edx,%eax
  800412:	01 c0                	add    %eax,%eax
  800414:	01 d0                	add    %edx,%eax
  800416:	c1 e0 03             	shl    $0x3,%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8a 40 04             	mov    0x4(%eax),%al
  80041e:	84 c0                	test   %al,%al
  800420:	75 46                	jne    800468 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800422:	a1 20 50 80 00       	mov    0x805020,%eax
  800427:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80042d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800430:	89 d0                	mov    %edx,%eax
  800432:	01 c0                	add    %eax,%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c1 e0 03             	shl    $0x3,%eax
  800439:	01 c8                	add    %ecx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800440:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800443:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800448:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80044a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	01 c8                	add    %ecx,%eax
  800459:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045b:	39 c2                	cmp    %eax,%edx
  80045d:	75 09                	jne    800468 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80045f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800466:	eb 15                	jmp    80047d <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800468:	ff 45 e8             	incl   -0x18(%ebp)
  80046b:	a1 20 50 80 00       	mov    0x805020,%eax
  800470:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  800476:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800479:	39 c2                	cmp    %eax,%edx
  80047b:	77 85                	ja     800402 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80047d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800481:	75 14                	jne    800497 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 2c 3d 80 00       	push   $0x803d2c
  80048b:	6a 3a                	push   $0x3a
  80048d:	68 20 3d 80 00       	push   $0x803d20
  800492:	e8 8d fe ff ff       	call   800324 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800497:	ff 45 f0             	incl   -0x10(%ebp)
  80049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a0:	0f 8c 2f ff ff ff    	jl     8003d5 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b4:	eb 26                	jmp    8004dc <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b6:	a1 20 50 80 00       	mov    0x805020,%eax
  8004bb:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8004c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 03             	shl    $0x3,%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8a 40 04             	mov    0x4(%eax),%al
  8004d2:	3c 01                	cmp    $0x1,%al
  8004d4:	75 03                	jne    8004d9 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8004d6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d9:	ff 45 e0             	incl   -0x20(%ebp)
  8004dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004e1:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8004e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ea:	39 c2                	cmp    %eax,%edx
  8004ec:	77 c8                	ja     8004b6 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004f4:	74 14                	je     80050a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 80 3d 80 00       	push   $0x803d80
  8004fe:	6a 44                	push   $0x44
  800500:	68 20 3d 80 00       	push   $0x803d20
  800505:	e8 1a fe ff ff       	call   800324 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80050a:	90                   	nop
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800513:	8b 45 0c             	mov    0xc(%ebp),%eax
  800516:	8b 00                	mov    (%eax),%eax
  800518:	8d 48 01             	lea    0x1(%eax),%ecx
  80051b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80051e:	89 0a                	mov    %ecx,(%edx)
  800520:	8b 55 08             	mov    0x8(%ebp),%edx
  800523:	88 d1                	mov    %dl,%cl
  800525:	8b 55 0c             	mov    0xc(%ebp),%edx
  800528:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052f:	8b 00                	mov    (%eax),%eax
  800531:	3d ff 00 00 00       	cmp    $0xff,%eax
  800536:	75 2c                	jne    800564 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800538:	a0 44 50 98 00       	mov    0x985044,%al
  80053d:	0f b6 c0             	movzbl %al,%eax
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	8b 12                	mov    (%edx),%edx
  800545:	89 d1                	mov    %edx,%ecx
  800547:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054a:	83 c2 08             	add    $0x8,%edx
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	50                   	push   %eax
  800551:	51                   	push   %ecx
  800552:	52                   	push   %edx
  800553:	e8 56 10 00 00       	call   8015ae <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80055b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80055e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 40 04             	mov    0x4(%eax),%eax
  80056a:	8d 50 01             	lea    0x1(%eax),%edx
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	89 50 04             	mov    %edx,0x4(%eax)
}
  800573:	90                   	nop
  800574:	c9                   	leave  
  800575:	c3                   	ret    

00800576 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800576:	55                   	push   %ebp
  800577:	89 e5                	mov    %esp,%ebp
  800579:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80057f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800586:	00 00 00 
	b.cnt = 0;
  800589:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800590:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800593:	ff 75 0c             	pushl  0xc(%ebp)
  800596:	ff 75 08             	pushl  0x8(%ebp)
  800599:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80059f:	50                   	push   %eax
  8005a0:	68 0d 05 80 00       	push   $0x80050d
  8005a5:	e8 11 02 00 00       	call   8007bb <vprintfmt>
  8005aa:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ad:	a0 44 50 98 00       	mov    0x985044,%al
  8005b2:	0f b6 c0             	movzbl %al,%eax
  8005b5:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005bb:	83 ec 04             	sub    $0x4,%esp
  8005be:	50                   	push   %eax
  8005bf:	52                   	push   %edx
  8005c0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005c6:	83 c0 08             	add    $0x8,%eax
  8005c9:	50                   	push   %eax
  8005ca:	e8 df 0f 00 00       	call   8015ae <sys_cputs>
  8005cf:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005d2:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  8005d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005df:	c9                   	leave  
  8005e0:	c3                   	ret    

008005e1 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8005e1:	55                   	push   %ebp
  8005e2:	89 e5                	mov    %esp,%ebp
  8005e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e7:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8005ee:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fd:	50                   	push   %eax
  8005fe:	e8 73 ff ff ff       	call   800576 <vcprintf>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800614:	e8 d7 0f 00 00       	call   8015f0 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800619:	8d 45 0c             	lea    0xc(%ebp),%eax
  80061c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	83 ec 08             	sub    $0x8,%esp
  800625:	ff 75 f4             	pushl  -0xc(%ebp)
  800628:	50                   	push   %eax
  800629:	e8 48 ff ff ff       	call   800576 <vcprintf>
  80062e:	83 c4 10             	add    $0x10,%esp
  800631:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800634:	e8 d1 0f 00 00       	call   80160a <sys_unlock_cons>
	return cnt;
  800639:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	53                   	push   %ebx
  800642:	83 ec 14             	sub    $0x14,%esp
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800651:	8b 45 18             	mov    0x18(%ebp),%eax
  800654:	ba 00 00 00 00       	mov    $0x0,%edx
  800659:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065c:	77 55                	ja     8006b3 <printnum+0x75>
  80065e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800661:	72 05                	jb     800668 <printnum+0x2a>
  800663:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800666:	77 4b                	ja     8006b3 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800668:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80066b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80066e:	8b 45 18             	mov    0x18(%ebp),%eax
  800671:	ba 00 00 00 00       	mov    $0x0,%edx
  800676:	52                   	push   %edx
  800677:	50                   	push   %eax
  800678:	ff 75 f4             	pushl  -0xc(%ebp)
  80067b:	ff 75 f0             	pushl  -0x10(%ebp)
  80067e:	e8 8d 31 00 00       	call   803810 <__udivdi3>
  800683:	83 c4 10             	add    $0x10,%esp
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	ff 75 20             	pushl  0x20(%ebp)
  80068c:	53                   	push   %ebx
  80068d:	ff 75 18             	pushl  0x18(%ebp)
  800690:	52                   	push   %edx
  800691:	50                   	push   %eax
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	ff 75 08             	pushl  0x8(%ebp)
  800698:	e8 a1 ff ff ff       	call   80063e <printnum>
  80069d:	83 c4 20             	add    $0x20,%esp
  8006a0:	eb 1a                	jmp    8006bc <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006a2:	83 ec 08             	sub    $0x8,%esp
  8006a5:	ff 75 0c             	pushl  0xc(%ebp)
  8006a8:	ff 75 20             	pushl  0x20(%ebp)
  8006ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ae:	ff d0                	call   *%eax
  8006b0:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006b3:	ff 4d 1c             	decl   0x1c(%ebp)
  8006b6:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006ba:	7f e6                	jg     8006a2 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006bc:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ca:	53                   	push   %ebx
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	50                   	push   %eax
  8006ce:	e8 4d 32 00 00       	call   803920 <__umoddi3>
  8006d3:	83 c4 10             	add    $0x10,%esp
  8006d6:	05 f4 3f 80 00       	add    $0x803ff4,%eax
  8006db:	8a 00                	mov    (%eax),%al
  8006dd:	0f be c0             	movsbl %al,%eax
  8006e0:	83 ec 08             	sub    $0x8,%esp
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	50                   	push   %eax
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	ff d0                	call   *%eax
  8006ec:	83 c4 10             	add    $0x10,%esp
}
  8006ef:	90                   	nop
  8006f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006fc:	7e 1c                	jle    80071a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	8b 00                	mov    (%eax),%eax
  800703:	8d 50 08             	lea    0x8(%eax),%edx
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	89 10                	mov    %edx,(%eax)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	8b 00                	mov    (%eax),%eax
  800710:	83 e8 08             	sub    $0x8,%eax
  800713:	8b 50 04             	mov    0x4(%eax),%edx
  800716:	8b 00                	mov    (%eax),%eax
  800718:	eb 40                	jmp    80075a <getuint+0x65>
	else if (lflag)
  80071a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80071e:	74 1e                	je     80073e <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	8d 50 04             	lea    0x4(%eax),%edx
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	89 10                	mov    %edx,(%eax)
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	83 e8 04             	sub    $0x4,%eax
  800735:	8b 00                	mov    (%eax),%eax
  800737:	ba 00 00 00 00       	mov    $0x0,%edx
  80073c:	eb 1c                	jmp    80075a <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	8d 50 04             	lea    0x4(%eax),%edx
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	89 10                	mov    %edx,(%eax)
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	8b 00                	mov    (%eax),%eax
  800750:	83 e8 04             	sub    $0x4,%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800763:	7e 1c                	jle    800781 <getint+0x25>
		return va_arg(*ap, long long);
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	8b 00                	mov    (%eax),%eax
  80076a:	8d 50 08             	lea    0x8(%eax),%edx
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	89 10                	mov    %edx,(%eax)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	8b 00                	mov    (%eax),%eax
  800777:	83 e8 08             	sub    $0x8,%eax
  80077a:	8b 50 04             	mov    0x4(%eax),%edx
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	eb 38                	jmp    8007b9 <getint+0x5d>
	else if (lflag)
  800781:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800785:	74 1a                	je     8007a1 <getint+0x45>
		return va_arg(*ap, long);
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	8b 00                	mov    (%eax),%eax
  80078c:	8d 50 04             	lea    0x4(%eax),%edx
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	89 10                	mov    %edx,(%eax)
  800794:	8b 45 08             	mov    0x8(%ebp),%eax
  800797:	8b 00                	mov    (%eax),%eax
  800799:	83 e8 04             	sub    $0x4,%eax
  80079c:	8b 00                	mov    (%eax),%eax
  80079e:	99                   	cltd   
  80079f:	eb 18                	jmp    8007b9 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	99                   	cltd   
}
  8007b9:	5d                   	pop    %ebp
  8007ba:	c3                   	ret    

008007bb <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
  8007be:	56                   	push   %esi
  8007bf:	53                   	push   %ebx
  8007c0:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c3:	eb 17                	jmp    8007dc <vprintfmt+0x21>
			if (ch == '\0')
  8007c5:	85 db                	test   %ebx,%ebx
  8007c7:	0f 84 c1 03 00 00    	je     800b8e <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	53                   	push   %ebx
  8007d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d7:	ff d0                	call   *%eax
  8007d9:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007df:	8d 50 01             	lea    0x1(%eax),%edx
  8007e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f b6 d8             	movzbl %al,%ebx
  8007ea:	83 fb 25             	cmp    $0x25,%ebx
  8007ed:	75 d6                	jne    8007c5 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ef:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007f3:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007fa:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800801:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800808:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80080f:	8b 45 10             	mov    0x10(%ebp),%eax
  800812:	8d 50 01             	lea    0x1(%eax),%edx
  800815:	89 55 10             	mov    %edx,0x10(%ebp)
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f b6 d8             	movzbl %al,%ebx
  80081d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800820:	83 f8 5b             	cmp    $0x5b,%eax
  800823:	0f 87 3d 03 00 00    	ja     800b66 <vprintfmt+0x3ab>
  800829:	8b 04 85 18 40 80 00 	mov    0x804018(,%eax,4),%eax
  800830:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800832:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800836:	eb d7                	jmp    80080f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800838:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80083c:	eb d1                	jmp    80080f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80083e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800845:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800848:	89 d0                	mov    %edx,%eax
  80084a:	c1 e0 02             	shl    $0x2,%eax
  80084d:	01 d0                	add    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d8                	add    %ebx,%eax
  800853:	83 e8 30             	sub    $0x30,%eax
  800856:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	8a 00                	mov    (%eax),%al
  80085e:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800861:	83 fb 2f             	cmp    $0x2f,%ebx
  800864:	7e 3e                	jle    8008a4 <vprintfmt+0xe9>
  800866:	83 fb 39             	cmp    $0x39,%ebx
  800869:	7f 39                	jg     8008a4 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80086b:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80086e:	eb d5                	jmp    800845 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	83 c0 04             	add    $0x4,%eax
  800876:	89 45 14             	mov    %eax,0x14(%ebp)
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	83 e8 04             	sub    $0x4,%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800884:	eb 1f                	jmp    8008a5 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800886:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80088a:	79 83                	jns    80080f <vprintfmt+0x54>
				width = 0;
  80088c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800893:	e9 77 ff ff ff       	jmp    80080f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800898:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80089f:	e9 6b ff ff ff       	jmp    80080f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008a4:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	0f 89 60 ff ff ff    	jns    80080f <vprintfmt+0x54>
				width = precision, precision = -1;
  8008af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008bc:	e9 4e ff ff ff       	jmp    80080f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008c4:	e9 46 ff ff ff       	jmp    80080f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	83 c0 04             	add    $0x4,%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	83 e8 04             	sub    $0x4,%eax
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	83 ec 08             	sub    $0x8,%esp
  8008dd:	ff 75 0c             	pushl  0xc(%ebp)
  8008e0:	50                   	push   %eax
  8008e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e4:	ff d0                	call   *%eax
  8008e6:	83 c4 10             	add    $0x10,%esp
			break;
  8008e9:	e9 9b 02 00 00       	jmp    800b89 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f1:	83 c0 04             	add    $0x4,%eax
  8008f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	83 e8 04             	sub    $0x4,%eax
  8008fd:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008ff:	85 db                	test   %ebx,%ebx
  800901:	79 02                	jns    800905 <vprintfmt+0x14a>
				err = -err;
  800903:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800905:	83 fb 64             	cmp    $0x64,%ebx
  800908:	7f 0b                	jg     800915 <vprintfmt+0x15a>
  80090a:	8b 34 9d 60 3e 80 00 	mov    0x803e60(,%ebx,4),%esi
  800911:	85 f6                	test   %esi,%esi
  800913:	75 19                	jne    80092e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800915:	53                   	push   %ebx
  800916:	68 05 40 80 00       	push   $0x804005
  80091b:	ff 75 0c             	pushl  0xc(%ebp)
  80091e:	ff 75 08             	pushl  0x8(%ebp)
  800921:	e8 70 02 00 00       	call   800b96 <printfmt>
  800926:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800929:	e9 5b 02 00 00       	jmp    800b89 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80092e:	56                   	push   %esi
  80092f:	68 0e 40 80 00       	push   $0x80400e
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 57 02 00 00       	call   800b96 <printfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
			break;
  800942:	e9 42 02 00 00       	jmp    800b89 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800947:	8b 45 14             	mov    0x14(%ebp),%eax
  80094a:	83 c0 04             	add    $0x4,%eax
  80094d:	89 45 14             	mov    %eax,0x14(%ebp)
  800950:	8b 45 14             	mov    0x14(%ebp),%eax
  800953:	83 e8 04             	sub    $0x4,%eax
  800956:	8b 30                	mov    (%eax),%esi
  800958:	85 f6                	test   %esi,%esi
  80095a:	75 05                	jne    800961 <vprintfmt+0x1a6>
				p = "(null)";
  80095c:	be 11 40 80 00       	mov    $0x804011,%esi
			if (width > 0 && padc != '-')
  800961:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800965:	7e 6d                	jle    8009d4 <vprintfmt+0x219>
  800967:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80096b:	74 67                	je     8009d4 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80096d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800970:	83 ec 08             	sub    $0x8,%esp
  800973:	50                   	push   %eax
  800974:	56                   	push   %esi
  800975:	e8 26 05 00 00       	call   800ea0 <strnlen>
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800980:	eb 16                	jmp    800998 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800982:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	ff 75 0c             	pushl  0xc(%ebp)
  80098c:	50                   	push   %eax
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800995:	ff 4d e4             	decl   -0x1c(%ebp)
  800998:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099c:	7f e4                	jg     800982 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80099e:	eb 34                	jmp    8009d4 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009a4:	74 1c                	je     8009c2 <vprintfmt+0x207>
  8009a6:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a9:	7e 05                	jle    8009b0 <vprintfmt+0x1f5>
  8009ab:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ae:	7e 12                	jle    8009c2 <vprintfmt+0x207>
					putch('?', putdat);
  8009b0:	83 ec 08             	sub    $0x8,%esp
  8009b3:	ff 75 0c             	pushl  0xc(%ebp)
  8009b6:	6a 3f                	push   $0x3f
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	ff d0                	call   *%eax
  8009bd:	83 c4 10             	add    $0x10,%esp
  8009c0:	eb 0f                	jmp    8009d1 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009c2:	83 ec 08             	sub    $0x8,%esp
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	53                   	push   %ebx
  8009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cc:	ff d0                	call   *%eax
  8009ce:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d1:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d4:	89 f0                	mov    %esi,%eax
  8009d6:	8d 70 01             	lea    0x1(%eax),%esi
  8009d9:	8a 00                	mov    (%eax),%al
  8009db:	0f be d8             	movsbl %al,%ebx
  8009de:	85 db                	test   %ebx,%ebx
  8009e0:	74 24                	je     800a06 <vprintfmt+0x24b>
  8009e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e6:	78 b8                	js     8009a0 <vprintfmt+0x1e5>
  8009e8:	ff 4d e0             	decl   -0x20(%ebp)
  8009eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ef:	79 af                	jns    8009a0 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f1:	eb 13                	jmp    800a06 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	ff 75 0c             	pushl  0xc(%ebp)
  8009f9:	6a 20                	push   $0x20
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	ff d0                	call   *%eax
  800a00:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a03:	ff 4d e4             	decl   -0x1c(%ebp)
  800a06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0a:	7f e7                	jg     8009f3 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a0c:	e9 78 01 00 00       	jmp    800b89 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a11:	83 ec 08             	sub    $0x8,%esp
  800a14:	ff 75 e8             	pushl  -0x18(%ebp)
  800a17:	8d 45 14             	lea    0x14(%ebp),%eax
  800a1a:	50                   	push   %eax
  800a1b:	e8 3c fd ff ff       	call   80075c <getint>
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a26:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a2f:	85 d2                	test   %edx,%edx
  800a31:	79 23                	jns    800a56 <vprintfmt+0x29b>
				putch('-', putdat);
  800a33:	83 ec 08             	sub    $0x8,%esp
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	6a 2d                	push   $0x2d
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	ff d0                	call   *%eax
  800a40:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a49:	f7 d8                	neg    %eax
  800a4b:	83 d2 00             	adc    $0x0,%edx
  800a4e:	f7 da                	neg    %edx
  800a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a53:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a56:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a5d:	e9 bc 00 00 00       	jmp    800b1e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 84 fc ff ff       	call   8006f5 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a7a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a81:	e9 98 00 00 00       	jmp    800b1e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 0c             	pushl  0xc(%ebp)
  800a8c:	6a 58                	push   $0x58
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 58                	push   $0x58
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 58                	push   $0x58
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			break;
  800ab6:	e9 ce 00 00 00       	jmp    800b89 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	6a 30                	push   $0x30
  800ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac6:	ff d0                	call   *%eax
  800ac8:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	6a 78                	push   $0x78
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800adb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ade:	83 c0 04             	add    $0x4,%eax
  800ae1:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae7:	83 e8 04             	sub    $0x4,%eax
  800aea:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800af6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800afd:	eb 1f                	jmp    800b1e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 e8             	pushl  -0x18(%ebp)
  800b05:	8d 45 14             	lea    0x14(%ebp),%eax
  800b08:	50                   	push   %eax
  800b09:	e8 e7 fb ff ff       	call   8006f5 <getuint>
  800b0e:	83 c4 10             	add    $0x10,%esp
  800b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b14:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b17:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b1e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b25:	83 ec 04             	sub    $0x4,%esp
  800b28:	52                   	push   %edx
  800b29:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b2c:	50                   	push   %eax
  800b2d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b30:	ff 75 f0             	pushl  -0x10(%ebp)
  800b33:	ff 75 0c             	pushl  0xc(%ebp)
  800b36:	ff 75 08             	pushl  0x8(%ebp)
  800b39:	e8 00 fb ff ff       	call   80063e <printnum>
  800b3e:	83 c4 20             	add    $0x20,%esp
			break;
  800b41:	eb 46                	jmp    800b89 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b43:	83 ec 08             	sub    $0x8,%esp
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	53                   	push   %ebx
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	ff d0                	call   *%eax
  800b4f:	83 c4 10             	add    $0x10,%esp
			break;
  800b52:	eb 35                	jmp    800b89 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800b54:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800b5b:	eb 2c                	jmp    800b89 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800b5d:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800b64:	eb 23                	jmp    800b89 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b66:	83 ec 08             	sub    $0x8,%esp
  800b69:	ff 75 0c             	pushl  0xc(%ebp)
  800b6c:	6a 25                	push   $0x25
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	ff d0                	call   *%eax
  800b73:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b76:	ff 4d 10             	decl   0x10(%ebp)
  800b79:	eb 03                	jmp    800b7e <vprintfmt+0x3c3>
  800b7b:	ff 4d 10             	decl   0x10(%ebp)
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	48                   	dec    %eax
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	3c 25                	cmp    $0x25,%al
  800b86:	75 f3                	jne    800b7b <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800b88:	90                   	nop
		}
	}
  800b89:	e9 35 fc ff ff       	jmp    8007c3 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b8e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b92:	5b                   	pop    %ebx
  800b93:	5e                   	pop    %esi
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b9c:	8d 45 10             	lea    0x10(%ebp),%eax
  800b9f:	83 c0 04             	add    $0x4,%eax
  800ba2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ba5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba8:	ff 75 f4             	pushl  -0xc(%ebp)
  800bab:	50                   	push   %eax
  800bac:	ff 75 0c             	pushl  0xc(%ebp)
  800baf:	ff 75 08             	pushl  0x8(%ebp)
  800bb2:	e8 04 fc ff ff       	call   8007bb <vprintfmt>
  800bb7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bba:	90                   	nop
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc3:	8b 40 08             	mov    0x8(%eax),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcc:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd2:	8b 10                	mov    (%eax),%edx
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 40 04             	mov    0x4(%eax),%eax
  800bda:	39 c2                	cmp    %eax,%edx
  800bdc:	73 12                	jae    800bf0 <sprintputch+0x33>
		*b->buf++ = ch;
  800bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	8d 48 01             	lea    0x1(%eax),%ecx
  800be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be9:	89 0a                	mov    %ecx,(%edx)
  800beb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bee:	88 10                	mov    %dl,(%eax)
}
  800bf0:	90                   	nop
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	01 d0                	add    %edx,%eax
  800c0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c18:	74 06                	je     800c20 <vsnprintf+0x2d>
  800c1a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c1e:	7f 07                	jg     800c27 <vsnprintf+0x34>
		return -E_INVAL;
  800c20:	b8 03 00 00 00       	mov    $0x3,%eax
  800c25:	eb 20                	jmp    800c47 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c27:	ff 75 14             	pushl  0x14(%ebp)
  800c2a:	ff 75 10             	pushl  0x10(%ebp)
  800c2d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	68 bd 0b 80 00       	push   $0x800bbd
  800c36:	e8 80 fb ff ff       	call   8007bb <vprintfmt>
  800c3b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c41:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c58:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5e:	50                   	push   %eax
  800c5f:	ff 75 0c             	pushl  0xc(%ebp)
  800c62:	ff 75 08             	pushl  0x8(%ebp)
  800c65:	e8 89 ff ff ff       	call   800bf3 <vsnprintf>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c73:	c9                   	leave  
  800c74:	c3                   	ret    

00800c75 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  800c7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c7f:	74 13                	je     800c94 <readline+0x1f>
		cprintf("%s", prompt);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 08             	pushl  0x8(%ebp)
  800c87:	68 88 41 80 00       	push   $0x804188
  800c8c:	e8 50 f9 ff ff       	call   8005e1 <cprintf>
  800c91:	83 c4 10             	add    $0x10,%esp

	i = 0;
  800c94:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  800c9b:	83 ec 0c             	sub    $0xc,%esp
  800c9e:	6a 00                	push   $0x0
  800ca0:	e8 04 12 00 00       	call   801ea9 <iscons>
  800ca5:	83 c4 10             	add    $0x10,%esp
  800ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  800cab:	e8 e6 11 00 00       	call   801e96 <getchar>
  800cb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  800cb3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800cb7:	79 22                	jns    800cdb <readline+0x66>
			if (c != -E_EOF)
  800cb9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800cbd:	0f 84 ad 00 00 00    	je     800d70 <readline+0xfb>
				cprintf("read error: %e\n", c);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 ec             	pushl  -0x14(%ebp)
  800cc9:	68 8b 41 80 00       	push   $0x80418b
  800cce:	e8 0e f9 ff ff       	call   8005e1 <cprintf>
  800cd3:	83 c4 10             	add    $0x10,%esp
			break;
  800cd6:	e9 95 00 00 00       	jmp    800d70 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800cdb:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800cdf:	7e 34                	jle    800d15 <readline+0xa0>
  800ce1:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800ce8:	7f 2b                	jg     800d15 <readline+0xa0>
			if (echoing)
  800cea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cee:	74 0e                	je     800cfe <readline+0x89>
				cputchar(c);
  800cf0:	83 ec 0c             	sub    $0xc,%esp
  800cf3:	ff 75 ec             	pushl  -0x14(%ebp)
  800cf6:	e8 7c 11 00 00       	call   801e77 <cputchar>
  800cfb:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d01:	8d 50 01             	lea    0x1(%eax),%edx
  800d04:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800d07:	89 c2                	mov    %eax,%edx
  800d09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0c:	01 d0                	add    %edx,%eax
  800d0e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800d11:	88 10                	mov    %dl,(%eax)
  800d13:	eb 56                	jmp    800d6b <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800d15:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800d19:	75 1f                	jne    800d3a <readline+0xc5>
  800d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800d1f:	7e 19                	jle    800d3a <readline+0xc5>
			if (echoing)
  800d21:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d25:	74 0e                	je     800d35 <readline+0xc0>
				cputchar(c);
  800d27:	83 ec 0c             	sub    $0xc,%esp
  800d2a:	ff 75 ec             	pushl  -0x14(%ebp)
  800d2d:	e8 45 11 00 00       	call   801e77 <cputchar>
  800d32:	83 c4 10             	add    $0x10,%esp

			i--;
  800d35:	ff 4d f4             	decl   -0xc(%ebp)
  800d38:	eb 31                	jmp    800d6b <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800d3a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800d3e:	74 0a                	je     800d4a <readline+0xd5>
  800d40:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800d44:	0f 85 61 ff ff ff    	jne    800cab <readline+0x36>
			if (echoing)
  800d4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d4e:	74 0e                	je     800d5e <readline+0xe9>
				cputchar(c);
  800d50:	83 ec 0c             	sub    $0xc,%esp
  800d53:	ff 75 ec             	pushl  -0x14(%ebp)
  800d56:	e8 1c 11 00 00       	call   801e77 <cputchar>
  800d5b:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800d5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d64:	01 d0                	add    %edx,%eax
  800d66:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800d69:	eb 06                	jmp    800d71 <readline+0xfc>
		}
	}
  800d6b:	e9 3b ff ff ff       	jmp    800cab <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800d70:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800d71:	90                   	nop
  800d72:	c9                   	leave  
  800d73:	c3                   	ret    

00800d74 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800d7a:	e8 71 08 00 00       	call   8015f0 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800d7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d83:	74 13                	je     800d98 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	ff 75 08             	pushl  0x8(%ebp)
  800d8b:	68 88 41 80 00       	push   $0x804188
  800d90:	e8 4c f8 ff ff       	call   8005e1 <cprintf>
  800d95:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800d98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	6a 00                	push   $0x0
  800da4:	e8 00 11 00 00       	call   801ea9 <iscons>
  800da9:	83 c4 10             	add    $0x10,%esp
  800dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800daf:	e8 e2 10 00 00       	call   801e96 <getchar>
  800db4:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800db7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dbb:	79 22                	jns    800ddf <atomic_readline+0x6b>
				if (c != -E_EOF)
  800dbd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800dc1:	0f 84 ad 00 00 00    	je     800e74 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800dc7:	83 ec 08             	sub    $0x8,%esp
  800dca:	ff 75 ec             	pushl  -0x14(%ebp)
  800dcd:	68 8b 41 80 00       	push   $0x80418b
  800dd2:	e8 0a f8 ff ff       	call   8005e1 <cprintf>
  800dd7:	83 c4 10             	add    $0x10,%esp
				break;
  800dda:	e9 95 00 00 00       	jmp    800e74 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800ddf:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800de3:	7e 34                	jle    800e19 <atomic_readline+0xa5>
  800de5:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800dec:	7f 2b                	jg     800e19 <atomic_readline+0xa5>
				if (echoing)
  800dee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800df2:	74 0e                	je     800e02 <atomic_readline+0x8e>
					cputchar(c);
  800df4:	83 ec 0c             	sub    $0xc,%esp
  800df7:	ff 75 ec             	pushl  -0x14(%ebp)
  800dfa:	e8 78 10 00 00       	call   801e77 <cputchar>
  800dff:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e05:	8d 50 01             	lea    0x1(%eax),%edx
  800e08:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800e0b:	89 c2                	mov    %eax,%edx
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
  800e17:	eb 56                	jmp    800e6f <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800e19:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800e1d:	75 1f                	jne    800e3e <atomic_readline+0xca>
  800e1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800e23:	7e 19                	jle    800e3e <atomic_readline+0xca>
				if (echoing)
  800e25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e29:	74 0e                	je     800e39 <atomic_readline+0xc5>
					cputchar(c);
  800e2b:	83 ec 0c             	sub    $0xc,%esp
  800e2e:	ff 75 ec             	pushl  -0x14(%ebp)
  800e31:	e8 41 10 00 00       	call   801e77 <cputchar>
  800e36:	83 c4 10             	add    $0x10,%esp
				i--;
  800e39:	ff 4d f4             	decl   -0xc(%ebp)
  800e3c:	eb 31                	jmp    800e6f <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800e3e:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800e42:	74 0a                	je     800e4e <atomic_readline+0xda>
  800e44:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800e48:	0f 85 61 ff ff ff    	jne    800daf <atomic_readline+0x3b>
				if (echoing)
  800e4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e52:	74 0e                	je     800e62 <atomic_readline+0xee>
					cputchar(c);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	ff 75 ec             	pushl  -0x14(%ebp)
  800e5a:	e8 18 10 00 00       	call   801e77 <cputchar>
  800e5f:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800e62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e68:	01 d0                	add    %edx,%eax
  800e6a:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800e6d:	eb 06                	jmp    800e75 <atomic_readline+0x101>
			}
		}
  800e6f:	e9 3b ff ff ff       	jmp    800daf <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800e74:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800e75:	e8 90 07 00 00       	call   80160a <sys_unlock_cons>
}
  800e7a:	90                   	nop
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8a:	eb 06                	jmp    800e92 <strlen+0x15>
		n++;
  800e8c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e8f:	ff 45 08             	incl   0x8(%ebp)
  800e92:	8b 45 08             	mov    0x8(%ebp),%eax
  800e95:	8a 00                	mov    (%eax),%al
  800e97:	84 c0                	test   %al,%al
  800e99:	75 f1                	jne    800e8c <strlen+0xf>
		n++;
	return n;
  800e9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e9e:	c9                   	leave  
  800e9f:	c3                   	ret    

00800ea0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ead:	eb 09                	jmp    800eb8 <strnlen+0x18>
		n++;
  800eaf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb2:	ff 45 08             	incl   0x8(%ebp)
  800eb5:	ff 4d 0c             	decl   0xc(%ebp)
  800eb8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebc:	74 09                	je     800ec7 <strnlen+0x27>
  800ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	84 c0                	test   %al,%al
  800ec5:	75 e8                	jne    800eaf <strnlen+0xf>
		n++;
	return n;
  800ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800eca:	c9                   	leave  
  800ecb:	c3                   	ret    

00800ecc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ed8:	90                   	nop
  800ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  800edc:	8d 50 01             	lea    0x1(%eax),%edx
  800edf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eeb:	8a 12                	mov    (%edx),%dl
  800eed:	88 10                	mov    %dl,(%eax)
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	84 c0                	test   %al,%al
  800ef3:	75 e4                	jne    800ed9 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0d:	eb 1f                	jmp    800f2e <strncpy+0x34>
		*dst++ = *src;
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8d 50 01             	lea    0x1(%eax),%edx
  800f15:	89 55 08             	mov    %edx,0x8(%ebp)
  800f18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1b:	8a 12                	mov    (%edx),%dl
  800f1d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	84 c0                	test   %al,%al
  800f26:	74 03                	je     800f2b <strncpy+0x31>
			src++;
  800f28:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2b:	ff 45 fc             	incl   -0x4(%ebp)
  800f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f31:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f34:	72 d9                	jb     800f0f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4b:	74 30                	je     800f7d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f4d:	eb 16                	jmp    800f65 <strlcpy+0x2a>
			*dst++ = *src++;
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	8d 50 01             	lea    0x1(%eax),%edx
  800f55:	89 55 08             	mov    %edx,0x8(%ebp)
  800f58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f61:	8a 12                	mov    (%edx),%dl
  800f63:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f65:	ff 4d 10             	decl   0x10(%ebp)
  800f68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6c:	74 09                	je     800f77 <strlcpy+0x3c>
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	84 c0                	test   %al,%al
  800f75:	75 d8                	jne    800f4f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f83:	29 c2                	sub    %eax,%edx
  800f85:	89 d0                	mov    %edx,%eax
}
  800f87:	c9                   	leave  
  800f88:	c3                   	ret    

00800f89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8c:	eb 06                	jmp    800f94 <strcmp+0xb>
		p++, q++;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f94:	8b 45 08             	mov    0x8(%ebp),%eax
  800f97:	8a 00                	mov    (%eax),%al
  800f99:	84 c0                	test   %al,%al
  800f9b:	74 0e                	je     800fab <strcmp+0x22>
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 10                	mov    (%eax),%dl
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	38 c2                	cmp    %al,%dl
  800fa9:	74 e3                	je     800f8e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f b6 d0             	movzbl %al,%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	0f b6 c0             	movzbl %al,%eax
  800fbb:	29 c2                	sub    %eax,%edx
  800fbd:	89 d0                	mov    %edx,%eax
}
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc4:	eb 09                	jmp    800fcf <strncmp+0xe>
		n--, p++, q++;
  800fc6:	ff 4d 10             	decl   0x10(%ebp)
  800fc9:	ff 45 08             	incl   0x8(%ebp)
  800fcc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd3:	74 17                	je     800fec <strncmp+0x2b>
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	84 c0                	test   %al,%al
  800fdc:	74 0e                	je     800fec <strncmp+0x2b>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 10                	mov    (%eax),%dl
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	38 c2                	cmp    %al,%dl
  800fea:	74 da                	je     800fc6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff0:	75 07                	jne    800ff9 <strncmp+0x38>
		return 0;
  800ff2:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff7:	eb 14                	jmp    80100d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	0f b6 d0             	movzbl %al,%edx
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 c0             	movzbl %al,%eax
  801009:	29 c2                	sub    %eax,%edx
  80100b:	89 d0                	mov    %edx,%eax
}
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 04             	sub    $0x4,%esp
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101b:	eb 12                	jmp    80102f <strchr+0x20>
		if (*s == c)
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801025:	75 05                	jne    80102c <strchr+0x1d>
			return (char *) s;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	eb 11                	jmp    80103d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102c:	ff 45 08             	incl   0x8(%ebp)
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	84 c0                	test   %al,%al
  801036:	75 e5                	jne    80101d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	83 ec 04             	sub    $0x4,%esp
  801045:	8b 45 0c             	mov    0xc(%ebp),%eax
  801048:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104b:	eb 0d                	jmp    80105a <strfind+0x1b>
		if (*s == c)
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801055:	74 0e                	je     801065 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801057:	ff 45 08             	incl   0x8(%ebp)
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	84 c0                	test   %al,%al
  801061:	75 ea                	jne    80104d <strfind+0xe>
  801063:	eb 01                	jmp    801066 <strfind+0x27>
		if (*s == c)
			break;
  801065:	90                   	nop
	return (char *) s;
  801066:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801069:	c9                   	leave  
  80106a:	c3                   	ret    

0080106b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
  80106e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801077:	8b 45 10             	mov    0x10(%ebp),%eax
  80107a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80107d:	eb 0e                	jmp    80108d <memset+0x22>
		*p++ = c;
  80107f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801082:	8d 50 01             	lea    0x1(%eax),%edx
  801085:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801088:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80108d:	ff 4d f8             	decl   -0x8(%ebp)
  801090:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801094:	79 e9                	jns    80107f <memset+0x14>
		*p++ = c;

	return v;
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010ad:	eb 16                	jmp    8010c5 <memcpy+0x2a>
		*d++ = *s++;
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	8d 50 01             	lea    0x1(%eax),%edx
  8010b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010bb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010be:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c1:	8a 12                	mov    (%edx),%dl
  8010c3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ce:	85 c0                	test   %eax,%eax
  8010d0:	75 dd                	jne    8010af <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d5:	c9                   	leave  
  8010d6:	c3                   	ret    

008010d7 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010d7:	55                   	push   %ebp
  8010d8:	89 e5                	mov    %esp,%ebp
  8010da:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ef:	73 50                	jae    801141 <memmove+0x6a>
  8010f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010fc:	76 43                	jbe    801141 <memmove+0x6a>
		s += n;
  8010fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801101:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801104:	8b 45 10             	mov    0x10(%ebp),%eax
  801107:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110a:	eb 10                	jmp    80111c <memmove+0x45>
			*--d = *--s;
  80110c:	ff 4d f8             	decl   -0x8(%ebp)
  80110f:	ff 4d fc             	decl   -0x4(%ebp)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111c:	8b 45 10             	mov    0x10(%ebp),%eax
  80111f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801122:	89 55 10             	mov    %edx,0x10(%ebp)
  801125:	85 c0                	test   %eax,%eax
  801127:	75 e3                	jne    80110c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801129:	eb 23                	jmp    80114e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112e:	8d 50 01             	lea    0x1(%eax),%edx
  801131:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801134:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801137:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80113d:	8a 12                	mov    (%edx),%dl
  80113f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801141:	8b 45 10             	mov    0x10(%ebp),%eax
  801144:	8d 50 ff             	lea    -0x1(%eax),%edx
  801147:	89 55 10             	mov    %edx,0x10(%ebp)
  80114a:	85 c0                	test   %eax,%eax
  80114c:	75 dd                	jne    80112b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801165:	eb 2a                	jmp    801191 <memcmp+0x3e>
		if (*s1 != *s2)
  801167:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116a:	8a 10                	mov    (%eax),%dl
  80116c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	38 c2                	cmp    %al,%dl
  801173:	74 16                	je     80118b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801175:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	0f b6 d0             	movzbl %al,%edx
  80117d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	0f b6 c0             	movzbl %al,%eax
  801185:	29 c2                	sub    %eax,%edx
  801187:	89 d0                	mov    %edx,%eax
  801189:	eb 18                	jmp    8011a3 <memcmp+0x50>
		s1++, s2++;
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801191:	8b 45 10             	mov    0x10(%ebp),%eax
  801194:	8d 50 ff             	lea    -0x1(%eax),%edx
  801197:	89 55 10             	mov    %edx,0x10(%ebp)
  80119a:	85 c0                	test   %eax,%eax
  80119c:	75 c9                	jne    801167 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80119e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b1:	01 d0                	add    %edx,%eax
  8011b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b6:	eb 15                	jmp    8011cd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8a 00                	mov    (%eax),%al
  8011bd:	0f b6 d0             	movzbl %al,%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	0f b6 c0             	movzbl %al,%eax
  8011c6:	39 c2                	cmp    %eax,%edx
  8011c8:	74 0d                	je     8011d7 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d3:	72 e3                	jb     8011b8 <memfind+0x13>
  8011d5:	eb 01                	jmp    8011d8 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011d7:	90                   	nop
	return (void *) s;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
  8011e0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ea:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f1:	eb 03                	jmp    8011f6 <strtol+0x19>
		s++;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	3c 20                	cmp    $0x20,%al
  8011fd:	74 f4                	je     8011f3 <strtol+0x16>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 09                	cmp    $0x9,%al
  801206:	74 eb                	je     8011f3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 2b                	cmp    $0x2b,%al
  80120f:	75 05                	jne    801216 <strtol+0x39>
		s++;
  801211:	ff 45 08             	incl   0x8(%ebp)
  801214:	eb 13                	jmp    801229 <strtol+0x4c>
	else if (*s == '-')
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3c 2d                	cmp    $0x2d,%al
  80121d:	75 0a                	jne    801229 <strtol+0x4c>
		s++, neg = 1;
  80121f:	ff 45 08             	incl   0x8(%ebp)
  801222:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801229:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122d:	74 06                	je     801235 <strtol+0x58>
  80122f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801233:	75 20                	jne    801255 <strtol+0x78>
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	8a 00                	mov    (%eax),%al
  80123a:	3c 30                	cmp    $0x30,%al
  80123c:	75 17                	jne    801255 <strtol+0x78>
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	40                   	inc    %eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	3c 78                	cmp    $0x78,%al
  801246:	75 0d                	jne    801255 <strtol+0x78>
		s += 2, base = 16;
  801248:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801253:	eb 28                	jmp    80127d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801255:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801259:	75 15                	jne    801270 <strtol+0x93>
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	8a 00                	mov    (%eax),%al
  801260:	3c 30                	cmp    $0x30,%al
  801262:	75 0c                	jne    801270 <strtol+0x93>
		s++, base = 8;
  801264:	ff 45 08             	incl   0x8(%ebp)
  801267:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80126e:	eb 0d                	jmp    80127d <strtol+0xa0>
	else if (base == 0)
  801270:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801274:	75 07                	jne    80127d <strtol+0xa0>
		base = 10;
  801276:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	3c 2f                	cmp    $0x2f,%al
  801284:	7e 19                	jle    80129f <strtol+0xc2>
  801286:	8b 45 08             	mov    0x8(%ebp),%eax
  801289:	8a 00                	mov    (%eax),%al
  80128b:	3c 39                	cmp    $0x39,%al
  80128d:	7f 10                	jg     80129f <strtol+0xc2>
			dig = *s - '0';
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	8a 00                	mov    (%eax),%al
  801294:	0f be c0             	movsbl %al,%eax
  801297:	83 e8 30             	sub    $0x30,%eax
  80129a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80129d:	eb 42                	jmp    8012e1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8a 00                	mov    (%eax),%al
  8012a4:	3c 60                	cmp    $0x60,%al
  8012a6:	7e 19                	jle    8012c1 <strtol+0xe4>
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ab:	8a 00                	mov    (%eax),%al
  8012ad:	3c 7a                	cmp    $0x7a,%al
  8012af:	7f 10                	jg     8012c1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	0f be c0             	movsbl %al,%eax
  8012b9:	83 e8 57             	sub    $0x57,%eax
  8012bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012bf:	eb 20                	jmp    8012e1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	3c 40                	cmp    $0x40,%al
  8012c8:	7e 39                	jle    801303 <strtol+0x126>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	3c 5a                	cmp    $0x5a,%al
  8012d1:	7f 30                	jg     801303 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	83 e8 37             	sub    $0x37,%eax
  8012de:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e7:	7d 19                	jge    801302 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012e9:	ff 45 08             	incl   0x8(%ebp)
  8012ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ef:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f3:	89 c2                	mov    %eax,%edx
  8012f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012f8:	01 d0                	add    %edx,%eax
  8012fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012fd:	e9 7b ff ff ff       	jmp    80127d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801302:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801303:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801307:	74 08                	je     801311 <strtol+0x134>
		*endptr = (char *) s;
  801309:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130c:	8b 55 08             	mov    0x8(%ebp),%edx
  80130f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801311:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801315:	74 07                	je     80131e <strtol+0x141>
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	f7 d8                	neg    %eax
  80131c:	eb 03                	jmp    801321 <strtol+0x144>
  80131e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801321:	c9                   	leave  
  801322:	c3                   	ret    

00801323 <ltostr>:

void
ltostr(long value, char *str)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801329:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801330:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801337:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133b:	79 13                	jns    801350 <ltostr+0x2d>
	{
		neg = 1;
  80133d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801358:	99                   	cltd   
  801359:	f7 f9                	idiv   %ecx
  80135b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80135e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801367:	89 c2                	mov    %eax,%edx
  801369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136c:	01 d0                	add    %edx,%eax
  80136e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801371:	83 c2 30             	add    $0x30,%edx
  801374:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801376:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801379:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80137e:	f7 e9                	imul   %ecx
  801380:	c1 fa 02             	sar    $0x2,%edx
  801383:	89 c8                	mov    %ecx,%eax
  801385:	c1 f8 1f             	sar    $0x1f,%eax
  801388:	29 c2                	sub    %eax,%edx
  80138a:	89 d0                	mov    %edx,%eax
  80138c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  80138f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801393:	75 bb                	jne    801350 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801395:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80139c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80139f:	48                   	dec    %eax
  8013a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013a3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013a7:	74 3d                	je     8013e6 <ltostr+0xc3>
		start = 1 ;
  8013a9:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013b0:	eb 34                	jmp    8013e6 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8013b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b8:	01 d0                	add    %edx,%eax
  8013ba:	8a 00                	mov    (%eax),%al
  8013bc:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c5:	01 c2                	add    %eax,%edx
  8013c7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cd:	01 c8                	add    %ecx,%eax
  8013cf:	8a 00                	mov    (%eax),%al
  8013d1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d9:	01 c2                	add    %eax,%edx
  8013db:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013de:	88 02                	mov    %al,(%edx)
		start++ ;
  8013e0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013e3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ec:	7c c4                	jl     8013b2 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	01 d0                	add    %edx,%eax
  8013f6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013f9:	90                   	nop
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801402:	ff 75 08             	pushl  0x8(%ebp)
  801405:	e8 73 fa ff ff       	call   800e7d <strlen>
  80140a:	83 c4 04             	add    $0x4,%esp
  80140d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801410:	ff 75 0c             	pushl  0xc(%ebp)
  801413:	e8 65 fa ff ff       	call   800e7d <strlen>
  801418:	83 c4 04             	add    $0x4,%esp
  80141b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80141e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801425:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80142c:	eb 17                	jmp    801445 <strcconcat+0x49>
		final[s] = str1[s] ;
  80142e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801431:	8b 45 10             	mov    0x10(%ebp),%eax
  801434:	01 c2                	add    %eax,%edx
  801436:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	01 c8                	add    %ecx,%eax
  80143e:	8a 00                	mov    (%eax),%al
  801440:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801442:	ff 45 fc             	incl   -0x4(%ebp)
  801445:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801448:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80144b:	7c e1                	jl     80142e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80144d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801454:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80145b:	eb 1f                	jmp    80147c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801460:	8d 50 01             	lea    0x1(%eax),%edx
  801463:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801466:	89 c2                	mov    %eax,%edx
  801468:	8b 45 10             	mov    0x10(%ebp),%eax
  80146b:	01 c2                	add    %eax,%edx
  80146d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 c8                	add    %ecx,%eax
  801475:	8a 00                	mov    (%eax),%al
  801477:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801479:	ff 45 f8             	incl   -0x8(%ebp)
  80147c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80147f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801482:	7c d9                	jl     80145d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801484:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801487:	8b 45 10             	mov    0x10(%ebp),%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	c6 00 00             	movb   $0x0,(%eax)
}
  80148f:	90                   	nop
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801495:	8b 45 14             	mov    0x14(%ebp),%eax
  801498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80149e:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a1:	8b 00                	mov    (%eax),%eax
  8014a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 d0                	add    %edx,%eax
  8014af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b5:	eb 0c                	jmp    8014c3 <strsplit+0x31>
			*string++ = 0;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ba:	8d 50 01             	lea    0x1(%eax),%edx
  8014bd:	89 55 08             	mov    %edx,0x8(%ebp)
  8014c0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	84 c0                	test   %al,%al
  8014ca:	74 18                	je     8014e4 <strsplit+0x52>
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8a 00                	mov    (%eax),%al
  8014d1:	0f be c0             	movsbl %al,%eax
  8014d4:	50                   	push   %eax
  8014d5:	ff 75 0c             	pushl  0xc(%ebp)
  8014d8:	e8 32 fb ff ff       	call   80100f <strchr>
  8014dd:	83 c4 08             	add    $0x8,%esp
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	75 d3                	jne    8014b7 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e7:	8a 00                	mov    (%eax),%al
  8014e9:	84 c0                	test   %al,%al
  8014eb:	74 5a                	je     801547 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f0:	8b 00                	mov    (%eax),%eax
  8014f2:	83 f8 0f             	cmp    $0xf,%eax
  8014f5:	75 07                	jne    8014fe <strsplit+0x6c>
		{
			return 0;
  8014f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fc:	eb 66                	jmp    801564 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014fe:	8b 45 14             	mov    0x14(%ebp),%eax
  801501:	8b 00                	mov    (%eax),%eax
  801503:	8d 48 01             	lea    0x1(%eax),%ecx
  801506:	8b 55 14             	mov    0x14(%ebp),%edx
  801509:	89 0a                	mov    %ecx,(%edx)
  80150b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801512:	8b 45 10             	mov    0x10(%ebp),%eax
  801515:	01 c2                	add    %eax,%edx
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80151c:	eb 03                	jmp    801521 <strsplit+0x8f>
			string++;
  80151e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	84 c0                	test   %al,%al
  801528:	74 8b                	je     8014b5 <strsplit+0x23>
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	0f be c0             	movsbl %al,%eax
  801532:	50                   	push   %eax
  801533:	ff 75 0c             	pushl  0xc(%ebp)
  801536:	e8 d4 fa ff ff       	call   80100f <strchr>
  80153b:	83 c4 08             	add    $0x8,%esp
  80153e:	85 c0                	test   %eax,%eax
  801540:	74 dc                	je     80151e <strsplit+0x8c>
			string++;
	}
  801542:	e9 6e ff ff ff       	jmp    8014b5 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801547:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801548:	8b 45 14             	mov    0x14(%ebp),%eax
  80154b:	8b 00                	mov    (%eax),%eax
  80154d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 d0                	add    %edx,%eax
  801559:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80155f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80156c:	83 ec 04             	sub    $0x4,%esp
  80156f:	68 9c 41 80 00       	push   $0x80419c
  801574:	68 3f 01 00 00       	push   $0x13f
  801579:	68 be 41 80 00       	push   $0x8041be
  80157e:	e8 a1 ed ff ff       	call   800324 <_panic>

00801583 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	57                   	push   %edi
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801592:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801595:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801598:	8b 7d 18             	mov    0x18(%ebp),%edi
  80159b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80159e:	cd 30                	int    $0x30
  8015a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015a6:	83 c4 10             	add    $0x10,%esp
  8015a9:	5b                   	pop    %ebx
  8015aa:	5e                   	pop    %esi
  8015ab:	5f                   	pop    %edi
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    

008015ae <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 04             	sub    $0x4,%esp
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8015ba:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8015be:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c1:	6a 00                	push   $0x0
  8015c3:	6a 00                	push   $0x0
  8015c5:	52                   	push   %edx
  8015c6:	ff 75 0c             	pushl  0xc(%ebp)
  8015c9:	50                   	push   %eax
  8015ca:	6a 00                	push   $0x0
  8015cc:	e8 b2 ff ff ff       	call   801583 <syscall>
  8015d1:	83 c4 18             	add    $0x18,%esp
}
  8015d4:	90                   	nop
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <sys_cgetc>:

int sys_cgetc(void) {
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 02                	push   $0x2
  8015e6:	e8 98 ff ff ff       	call   801583 <syscall>
  8015eb:	83 c4 18             	add    $0x18,%esp
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_lock_cons>:

void sys_lock_cons(void) {
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 03                	push   $0x3
  8015ff:	e8 7f ff ff ff       	call   801583 <syscall>
  801604:	83 c4 18             	add    $0x18,%esp
}
  801607:	90                   	nop
  801608:	c9                   	leave  
  801609:	c3                   	ret    

0080160a <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80160a:	55                   	push   %ebp
  80160b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80160d:	6a 00                	push   $0x0
  80160f:	6a 00                	push   $0x0
  801611:	6a 00                	push   $0x0
  801613:	6a 00                	push   $0x0
  801615:	6a 00                	push   $0x0
  801617:	6a 04                	push   $0x4
  801619:	e8 65 ff ff ff       	call   801583 <syscall>
  80161e:	83 c4 18             	add    $0x18,%esp
}
  801621:	90                   	nop
  801622:	c9                   	leave  
  801623:	c3                   	ret    

00801624 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801624:	55                   	push   %ebp
  801625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801627:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	6a 00                	push   $0x0
  801633:	52                   	push   %edx
  801634:	50                   	push   %eax
  801635:	6a 08                	push   $0x8
  801637:	e8 47 ff ff ff       	call   801583 <syscall>
  80163c:	83 c4 18             	add    $0x18,%esp
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	56                   	push   %esi
  801645:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801646:	8b 75 18             	mov    0x18(%ebp),%esi
  801649:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80164c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80164f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	56                   	push   %esi
  801656:	53                   	push   %ebx
  801657:	51                   	push   %ecx
  801658:	52                   	push   %edx
  801659:	50                   	push   %eax
  80165a:	6a 09                	push   $0x9
  80165c:	e8 22 ff ff ff       	call   801583 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801664:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801667:	5b                   	pop    %ebx
  801668:	5e                   	pop    %esi
  801669:	5d                   	pop    %ebp
  80166a:	c3                   	ret    

0080166b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80166e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	52                   	push   %edx
  80167b:	50                   	push   %eax
  80167c:	6a 0a                	push   $0xa
  80167e:	e8 00 ff ff ff       	call   801583 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80168b:	6a 00                	push   $0x0
  80168d:	6a 00                	push   $0x0
  80168f:	6a 00                	push   $0x0
  801691:	ff 75 0c             	pushl  0xc(%ebp)
  801694:	ff 75 08             	pushl  0x8(%ebp)
  801697:	6a 0b                	push   $0xb
  801699:	e8 e5 fe ff ff       	call   801583 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8016a1:	c9                   	leave  
  8016a2:	c3                   	ret    

008016a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	6a 00                	push   $0x0
  8016ac:	6a 00                	push   $0x0
  8016ae:	6a 00                	push   $0x0
  8016b0:	6a 0c                	push   $0xc
  8016b2:	e8 cc fe ff ff       	call   801583 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
}
  8016ba:	c9                   	leave  
  8016bb:	c3                   	ret    

008016bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8016bc:	55                   	push   %ebp
  8016bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	6a 0d                	push   $0xd
  8016cb:	e8 b3 fe ff ff       	call   801583 <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 0e                	push   $0xe
  8016e4:	e8 9a fe ff ff       	call   801583 <syscall>
  8016e9:	83 c4 18             	add    $0x18,%esp
}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 0f                	push   $0xf
  8016fd:	e8 81 fe ff ff       	call   801583 <syscall>
  801702:	83 c4 18             	add    $0x18,%esp
}
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	ff 75 08             	pushl  0x8(%ebp)
  801715:	6a 10                	push   $0x10
  801717:	e8 67 fe ff ff       	call   801583 <syscall>
  80171c:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_scarce_memory>:

void sys_scarce_memory() {
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 11                	push   $0x11
  801730:	e8 4e fe ff ff       	call   801583 <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	90                   	nop
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <sys_cputc>:

void sys_cputc(const char c) {
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 04             	sub    $0x4,%esp
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801747:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80174b:	6a 00                	push   $0x0
  80174d:	6a 00                	push   $0x0
  80174f:	6a 00                	push   $0x0
  801751:	6a 00                	push   $0x0
  801753:	50                   	push   %eax
  801754:	6a 01                	push   $0x1
  801756:	e8 28 fe ff ff       	call   801583 <syscall>
  80175b:	83 c4 18             	add    $0x18,%esp
}
  80175e:	90                   	nop
  80175f:	c9                   	leave  
  801760:	c3                   	ret    

00801761 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801764:	6a 00                	push   $0x0
  801766:	6a 00                	push   $0x0
  801768:	6a 00                	push   $0x0
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 14                	push   $0x14
  801770:	e8 0e fe ff ff       	call   801583 <syscall>
  801775:	83 c4 18             	add    $0x18,%esp
}
  801778:	90                   	nop
  801779:	c9                   	leave  
  80177a:	c3                   	ret    

0080177b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	8b 45 10             	mov    0x10(%ebp),%eax
  801784:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801787:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80178a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80178e:	8b 45 08             	mov    0x8(%ebp),%eax
  801791:	6a 00                	push   $0x0
  801793:	51                   	push   %ecx
  801794:	52                   	push   %edx
  801795:	ff 75 0c             	pushl  0xc(%ebp)
  801798:	50                   	push   %eax
  801799:	6a 15                	push   $0x15
  80179b:	e8 e3 fd ff ff       	call   801583 <syscall>
  8017a0:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8017a3:	c9                   	leave  
  8017a4:	c3                   	ret    

008017a5 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8017a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	6a 00                	push   $0x0
  8017b0:	6a 00                	push   $0x0
  8017b2:	6a 00                	push   $0x0
  8017b4:	52                   	push   %edx
  8017b5:	50                   	push   %eax
  8017b6:	6a 16                	push   $0x16
  8017b8:	e8 c6 fd ff ff       	call   801583 <syscall>
  8017bd:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8017c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	51                   	push   %ecx
  8017d3:	52                   	push   %edx
  8017d4:	50                   	push   %eax
  8017d5:	6a 17                	push   $0x17
  8017d7:	e8 a7 fd ff ff       	call   801583 <syscall>
  8017dc:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	52                   	push   %edx
  8017f1:	50                   	push   %eax
  8017f2:	6a 18                	push   $0x18
  8017f4:	e8 8a fd ff ff       	call   801583 <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8017fc:	c9                   	leave  
  8017fd:	c3                   	ret    

008017fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8017fe:	55                   	push   %ebp
  8017ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801801:	8b 45 08             	mov    0x8(%ebp),%eax
  801804:	6a 00                	push   $0x0
  801806:	ff 75 14             	pushl  0x14(%ebp)
  801809:	ff 75 10             	pushl  0x10(%ebp)
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	50                   	push   %eax
  801810:	6a 19                	push   $0x19
  801812:	e8 6c fd ff ff       	call   801583 <syscall>
  801817:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80181a:	c9                   	leave  
  80181b:	c3                   	ret    

0080181c <sys_run_env>:

void sys_run_env(int32 envId) {
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	6a 00                	push   $0x0
  80182a:	50                   	push   %eax
  80182b:	6a 1a                	push   $0x1a
  80182d:	e8 51 fd ff ff       	call   801583 <syscall>
  801832:	83 c4 18             	add    $0x18,%esp
}
  801835:	90                   	nop
  801836:	c9                   	leave  
  801837:	c3                   	ret    

00801838 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 00                	push   $0x0
  801846:	50                   	push   %eax
  801847:	6a 1b                	push   $0x1b
  801849:	e8 35 fd ff ff       	call   801583 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <sys_getenvid>:

int32 sys_getenvid(void) {
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 05                	push   $0x5
  801862:	e8 1c fd ff ff       	call   801583 <syscall>
  801867:	83 c4 18             	add    $0x18,%esp
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 06                	push   $0x6
  80187b:	e8 03 fd ff ff       	call   801583 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 07                	push   $0x7
  801894:	e8 ea fc ff ff       	call   801583 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_exit_env>:

void sys_exit_env(void) {
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 1c                	push   $0x1c
  8018ad:	e8 d1 fc ff ff       	call   801583 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	90                   	nop
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8018be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c1:	8d 50 04             	lea    0x4(%eax),%edx
  8018c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	6a 1d                	push   $0x1d
  8018d1:	e8 ad fc ff ff       	call   801583 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8018d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e2:	89 01                	mov    %eax,(%ecx)
  8018e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	c9                   	leave  
  8018eb:	c2 04 00             	ret    $0x4

008018ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 10             	pushl  0x10(%ebp)
  8018f8:	ff 75 0c             	pushl  0xc(%ebp)
  8018fb:	ff 75 08             	pushl  0x8(%ebp)
  8018fe:	6a 13                	push   $0x13
  801900:	e8 7e fc ff ff       	call   801583 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801908:	90                   	nop
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_rcr2>:
uint32 sys_rcr2() {
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 1e                	push   $0x1e
  80191a:	e8 64 fc ff ff       	call   801583 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801930:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	50                   	push   %eax
  80193d:	6a 1f                	push   $0x1f
  80193f:	e8 3f fc ff ff       	call   801583 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <rsttst>:
void rsttst() {
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 21                	push   $0x21
  801959:	e8 25 fc ff ff       	call   801583 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 04             	sub    $0x4,%esp
  80196a:	8b 45 14             	mov    0x14(%ebp),%eax
  80196d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801970:	8b 55 18             	mov    0x18(%ebp),%edx
  801973:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	ff 75 10             	pushl  0x10(%ebp)
  80197c:	ff 75 0c             	pushl  0xc(%ebp)
  80197f:	ff 75 08             	pushl  0x8(%ebp)
  801982:	6a 20                	push   $0x20
  801984:	e8 fa fb ff ff       	call   801583 <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
	return;
  80198c:	90                   	nop
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <chktst>:
void chktst(uint32 n) {
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 08             	pushl  0x8(%ebp)
  80199d:	6a 22                	push   $0x22
  80199f:	e8 df fb ff ff       	call   801583 <syscall>
  8019a4:	83 c4 18             	add    $0x18,%esp
	return;
  8019a7:	90                   	nop
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <inctst>:

void inctst() {
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 23                	push   $0x23
  8019b9:	e8 c5 fb ff ff       	call   801583 <syscall>
  8019be:	83 c4 18             	add    $0x18,%esp
	return;
  8019c1:	90                   	nop
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <gettst>:
uint32 gettst() {
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 24                	push   $0x24
  8019d3:	e8 ab fb ff ff       	call   801583 <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 25                	push   $0x25
  8019ef:	e8 8f fb ff ff       	call   801583 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
  8019f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8019fa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8019fe:	75 07                	jne    801a07 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a00:	b8 01 00 00 00       	mov    $0x1,%eax
  801a05:	eb 05                	jmp    801a0c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 25                	push   $0x25
  801a20:	e8 5e fb ff ff       	call   801583 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
  801a28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a2b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a2f:	75 07                	jne    801a38 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a31:	b8 01 00 00 00       	mov    $0x1,%eax
  801a36:	eb 05                	jmp    801a3d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 25                	push   $0x25
  801a51:	e8 2d fb ff ff       	call   801583 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
  801a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801a5c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801a60:	75 07                	jne    801a69 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801a62:	b8 01 00 00 00       	mov    $0x1,%eax
  801a67:	eb 05                	jmp    801a6e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801a69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
  801a73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 25                	push   $0x25
  801a82:	e8 fc fa ff ff       	call   801583 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
  801a8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a8d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a91:	75 07                	jne    801a9a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a93:	b8 01 00 00 00       	mov    $0x1,%eax
  801a98:	eb 05                	jmp    801a9f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	ff 75 08             	pushl  0x8(%ebp)
  801aaf:	6a 26                	push   $0x26
  801ab1:	e8 cd fa ff ff       	call   801583 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
	return;
  801ab9:	90                   	nop
}
  801aba:	c9                   	leave  
  801abb:	c3                   	ret    

00801abc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801ac0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ac3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	53                   	push   %ebx
  801acf:	51                   	push   %ecx
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 27                	push   $0x27
  801ad4:	e8 aa fa ff ff       	call   801583 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	52                   	push   %edx
  801af1:	50                   	push   %eax
  801af2:	6a 28                	push   $0x28
  801af4:	e8 8a fa ff ff       	call   801583 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801b01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	51                   	push   %ecx
  801b0d:	ff 75 10             	pushl  0x10(%ebp)
  801b10:	52                   	push   %edx
  801b11:	50                   	push   %eax
  801b12:	6a 29                	push   $0x29
  801b14:	e8 6a fa ff ff       	call   801583 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 10             	pushl  0x10(%ebp)
  801b28:	ff 75 0c             	pushl  0xc(%ebp)
  801b2b:	ff 75 08             	pushl  0x8(%ebp)
  801b2e:	6a 12                	push   $0x12
  801b30:	e8 4e fa ff ff       	call   801583 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
	return;
  801b38:	90                   	nop
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 2a                	push   $0x2a
  801b4e:	e8 30 fa ff ff       	call   801583 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
	return;
  801b56:	90                   	nop
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	50                   	push   %eax
  801b68:	6a 2b                	push   $0x2b
  801b6a:	e8 14 fa ff ff       	call   801583 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	6a 2c                	push   $0x2c
  801b85:	e8 f9 f9 ff ff       	call   801583 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
	return;
  801b8d:	90                   	nop
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	6a 2d                	push   $0x2d
  801ba1:	e8 dd f9 ff ff       	call   801583 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
	return;
  801ba9:	90                   	nop
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	50                   	push   %eax
  801bbb:	6a 2f                	push   $0x2f
  801bbd:	e8 c1 f9 ff ff       	call   801583 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
	return;
  801bc5:	90                   	nop
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	52                   	push   %edx
  801bd8:	50                   	push   %eax
  801bd9:	6a 30                	push   $0x30
  801bdb:	e8 a3 f9 ff ff       	call   801583 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
	return;
  801be3:	90                   	nop
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	50                   	push   %eax
  801bf5:	6a 31                	push   $0x31
  801bf7:	e8 87 f9 ff ff       	call   801583 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
	return;
  801bff:	90                   	nop
}
  801c00:	c9                   	leave  
  801c01:	c3                   	ret    

00801c02 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801c02:	55                   	push   %ebp
  801c03:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801c05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	52                   	push   %edx
  801c12:	50                   	push   %eax
  801c13:	6a 2e                	push   $0x2e
  801c15:	e8 69 f9 ff ff       	call   801583 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
    return;
  801c1d:	90                   	nop
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  801c26:	83 ec 04             	sub    $0x4,%esp
  801c29:	6a 01                	push   $0x1
  801c2b:	6a 58                	push   $0x58
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	e8 4b 05 00 00       	call   802180 <smalloc>
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c3f:	75 14                	jne    801c55 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  801c41:	83 ec 04             	sub    $0x4,%esp
  801c44:	68 cc 41 80 00       	push   $0x8041cc
  801c49:	6a 10                	push   $0x10
  801c4b:	68 fa 41 80 00       	push   $0x8041fa
  801c50:	e8 cf e6 ff ff       	call   800324 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  801c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	50                   	push   %eax
  801c5c:	e8 4b ff ff ff       	call   801bac <sys_init_queue>
  801c61:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  801c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c67:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  801c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c71:	83 c0 18             	add    $0x18,%eax
  801c74:	83 ec 04             	sub    $0x4,%esp
  801c77:	6a 40                	push   $0x40
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	50                   	push   %eax
  801c7d:	e8 78 f2 ff ff       	call   800efa <strncpy>
  801c82:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  801c85:	8b 55 10             	mov    0x10(%ebp),%edx
  801c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c8b:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c9a:	89 10                	mov    %edx,(%eax)
}
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	c9                   	leave  
  801ca0:	c2 04 00             	ret    $0x4

00801ca3 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  801ca9:	83 ec 08             	sub    $0x8,%esp
  801cac:	ff 75 10             	pushl  0x10(%ebp)
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	e8 64 06 00 00       	call   80231b <sget>
  801cb7:	83 c4 10             	add    $0x10,%esp
  801cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  801cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cc1:	75 14                	jne    801cd7 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  801cc3:	83 ec 04             	sub    $0x4,%esp
  801cc6:	68 0c 42 80 00       	push   $0x80420c
  801ccb:	6a 2c                	push   $0x2c
  801ccd:	68 fa 41 80 00       	push   $0x8041fa
  801cd2:	e8 4d e6 ff ff       	call   800324 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  801cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ce3:	89 10                	mov    %edx,(%eax)
}
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	c9                   	leave  
  801ce9:	c2 04 00             	ret    $0x4

00801cec <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801cf2:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	8b 40 14             	mov    0x14(%eax),%eax
  801cff:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801d02:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801d08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d11:	f0 87 02             	lock xchg %eax,(%edx)
  801d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	75 db                	jne    801cf9 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	8b 50 10             	mov    0x10(%eax),%edx
  801d24:	4a                   	dec    %edx
  801d25:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	8b 40 10             	mov    0x10(%eax),%eax
  801d2e:	85 c0                	test   %eax,%eax
  801d30:	79 18                	jns    801d4a <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	8d 50 14             	lea    0x14(%eax),%edx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	83 ec 08             	sub    $0x8,%esp
  801d3e:	52                   	push   %edx
  801d3f:	50                   	push   %eax
  801d40:	e8 83 fe ff ff       	call   801bc8 <sys_block_process>
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	eb 0a                	jmp    801d54 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801d5c:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	8b 40 14             	mov    0x14(%eax),%eax
  801d69:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801d6c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801d6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d78:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801d7b:	f0 87 02             	lock xchg %eax,(%edx)
  801d7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d84:	85 c0                	test   %eax,%eax
  801d86:	75 db                	jne    801d63 <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	8b 50 10             	mov    0x10(%eax),%edx
  801d8e:	42                   	inc    %edx
  801d8f:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  801d92:	8b 45 08             	mov    0x8(%ebp),%eax
  801d95:	8b 40 10             	mov    0x10(%eax),%eax
  801d98:	85 c0                	test   %eax,%eax
  801d9a:	7f 0f                	jg     801dab <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	50                   	push   %eax
  801da3:	e8 3e fe ff ff       	call   801be6 <sys_unblock_process>
  801da8:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801db5:	90                   	nop
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8b 40 10             	mov    0x10(%eax),%eax
}
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801dc9:	8b 55 08             	mov    0x8(%ebp),%edx
  801dcc:	89 d0                	mov    %edx,%eax
  801dce:	c1 e0 02             	shl    $0x2,%eax
  801dd1:	01 d0                	add    %edx,%eax
  801dd3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dda:	01 d0                	add    %edx,%eax
  801ddc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801de3:	01 d0                	add    %edx,%eax
  801de5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801dec:	01 d0                	add    %edx,%eax
  801dee:	c1 e0 04             	shl    $0x4,%eax
  801df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801df4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801dfb:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	50                   	push   %eax
  801e02:	e8 b1 fa ff ff       	call   8018b8 <sys_get_virtual_time>
  801e07:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801e0a:	eb 41                	jmp    801e4d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801e0c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	50                   	push   %eax
  801e13:	e8 a0 fa ff ff       	call   8018b8 <sys_get_virtual_time>
  801e18:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801e1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e21:	29 c2                	sub    %eax,%edx
  801e23:	89 d0                	mov    %edx,%eax
  801e25:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801e28:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801e2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2e:	89 d1                	mov    %edx,%ecx
  801e30:	29 c1                	sub    %eax,%ecx
  801e32:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e38:	39 c2                	cmp    %eax,%edx
  801e3a:	0f 97 c0             	seta   %al
  801e3d:	0f b6 c0             	movzbl %al,%eax
  801e40:	29 c1                	sub    %eax,%ecx
  801e42:	89 c8                	mov    %ecx,%eax
  801e44:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801e47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e53:	72 b7                	jb     801e0c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801e55:	90                   	nop
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801e5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801e65:	eb 03                	jmp    801e6a <busy_wait+0x12>
  801e67:	ff 45 fc             	incl   -0x4(%ebp)
  801e6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801e70:	72 f5                	jb     801e67 <busy_wait+0xf>
	return i;
  801e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801e83:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	50                   	push   %eax
  801e8b:	e8 ab f8 ff ff       	call   80173b <sys_cputc>
  801e90:	83 c4 10             	add    $0x10,%esp
}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <getchar>:


int
getchar(void)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801e9c:	e8 36 f7 ff ff       	call   8015d7 <sys_cgetc>
  801ea1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801ea7:	c9                   	leave  
  801ea8:	c3                   	ret    

00801ea9 <iscons>:

int iscons(int fdnum)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801eac:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801eb9:	83 ec 0c             	sub    $0xc,%esp
  801ebc:	ff 75 08             	pushl  0x8(%ebp)
  801ebf:	e8 95 fc ff ff       	call   801b59 <sys_sbrk>
  801ec4:	83 c4 10             	add    $0x10,%esp
}
  801ec7:	c9                   	leave  
  801ec8:	c3                   	ret    

00801ec9 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
  801ecc:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801ecf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ed3:	75 0a                	jne    801edf <malloc+0x16>
		return NULL;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	e9 9e 01 00 00       	jmp    80207d <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801edf:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ee6:	77 2c                	ja     801f14 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801ee8:	e8 f0 fa ff ff       	call   8019dd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eed:	85 c0                	test   %eax,%eax
  801eef:	74 19                	je     801f0a <malloc+0x41>

			void * block = alloc_block_FF(size);
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	ff 75 08             	pushl  0x8(%ebp)
  801ef7:	e8 e8 0a 00 00       	call   8029e4 <alloc_block_FF>
  801efc:	83 c4 10             	add    $0x10,%esp
  801eff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801f02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f05:	e9 73 01 00 00       	jmp    80207d <malloc+0x1b4>
		} else {
			return NULL;
  801f0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0f:	e9 69 01 00 00       	jmp    80207d <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801f14:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  801f1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f21:	01 d0                	add    %edx,%eax
  801f23:	48                   	dec    %eax
  801f24:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801f2f:	f7 75 e0             	divl   -0x20(%ebp)
  801f32:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f35:	29 d0                	sub    %edx,%eax
  801f37:	c1 e8 0c             	shr    $0xc,%eax
  801f3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801f3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801f44:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801f4b:	a1 20 50 80 00       	mov    0x805020,%eax
  801f50:	8b 40 7c             	mov    0x7c(%eax),%eax
  801f53:	05 00 10 00 00       	add    $0x1000,%eax
  801f58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801f5b:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801f60:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801f63:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801f66:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801f6d:	8b 55 08             	mov    0x8(%ebp),%edx
  801f70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801f73:	01 d0                	add    %edx,%eax
  801f75:	48                   	dec    %eax
  801f76:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801f79:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f81:	f7 75 cc             	divl   -0x34(%ebp)
  801f84:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801f87:	29 d0                	sub    %edx,%eax
  801f89:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801f8c:	76 0a                	jbe    801f98 <malloc+0xcf>
		return NULL;
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	e9 e5 00 00 00       	jmp    80207d <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801f98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f9e:	eb 48                	jmp    801fe8 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa3:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801fa6:	c1 e8 0c             	shr    $0xc,%eax
  801fa9:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801fac:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801faf:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	75 11                	jne    801fcb <malloc+0x102>
			freePagesCount++;
  801fba:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801fbd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801fc1:	75 16                	jne    801fd9 <malloc+0x110>
				start = i;
  801fc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fc9:	eb 0e                	jmp    801fd9 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801fcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801fd2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801fdf:	74 12                	je     801ff3 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801fe1:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801fe8:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801fef:	76 af                	jbe    801fa0 <malloc+0xd7>
  801ff1:	eb 01                	jmp    801ff4 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801ff3:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801ff4:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801ff8:	74 08                	je     802002 <malloc+0x139>
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802000:	74 07                	je     802009 <malloc+0x140>
		return NULL;
  802002:	b8 00 00 00 00       	mov    $0x0,%eax
  802007:	eb 74                	jmp    80207d <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80200f:	c1 e8 0c             	shr    $0xc,%eax
  802012:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  802015:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802018:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80201b:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802022:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802025:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802028:	eb 11                	jmp    80203b <malloc+0x172>
		markedPages[i] = 1;
  80202a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80202d:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802034:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  802038:	ff 45 e8             	incl   -0x18(%ebp)
  80203b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80203e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802041:	01 d0                	add    %edx,%eax
  802043:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802046:	77 e2                	ja     80202a <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  802048:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  80204f:	8b 55 08             	mov    0x8(%ebp),%edx
  802052:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802055:	01 d0                	add    %edx,%eax
  802057:	48                   	dec    %eax
  802058:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80205b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80205e:	ba 00 00 00 00       	mov    $0x0,%edx
  802063:	f7 75 bc             	divl   -0x44(%ebp)
  802066:	8b 45 b8             	mov    -0x48(%ebp),%eax
  802069:	29 d0                	sub    %edx,%eax
  80206b:	83 ec 08             	sub    $0x8,%esp
  80206e:	50                   	push   %eax
  80206f:	ff 75 f0             	pushl  -0x10(%ebp)
  802072:	e8 19 fb ff ff       	call   801b90 <sys_allocate_user_mem>
  802077:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  80207a:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  802085:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802089:	0f 84 ee 00 00 00    	je     80217d <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80208f:	a1 20 50 80 00       	mov    0x805020,%eax
  802094:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  802097:	3b 45 08             	cmp    0x8(%ebp),%eax
  80209a:	77 09                	ja     8020a5 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80209c:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  8020a3:	76 14                	jbe    8020b9 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  8020a5:	83 ec 04             	sub    $0x4,%esp
  8020a8:	68 30 42 80 00       	push   $0x804230
  8020ad:	6a 68                	push   $0x68
  8020af:	68 4a 42 80 00       	push   $0x80424a
  8020b4:	e8 6b e2 ff ff       	call   800324 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  8020b9:	a1 20 50 80 00       	mov    0x805020,%eax
  8020be:	8b 40 74             	mov    0x74(%eax),%eax
  8020c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020c4:	77 20                	ja     8020e6 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  8020c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8020cb:	8b 40 78             	mov    0x78(%eax),%eax
  8020ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020d1:	76 13                	jbe    8020e6 <free+0x67>
		free_block(virtual_address);
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	ff 75 08             	pushl  0x8(%ebp)
  8020d9:	e8 cf 0f 00 00       	call   8030ad <free_block>
  8020de:	83 c4 10             	add    $0x10,%esp
		return;
  8020e1:	e9 98 00 00 00       	jmp    80217e <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8020e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8020ee:	8b 40 7c             	mov    0x7c(%eax),%eax
  8020f1:	29 c2                	sub    %eax,%edx
  8020f3:	89 d0                	mov    %edx,%eax
  8020f5:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  8020fa:	c1 e8 0c             	shr    $0xc,%eax
  8020fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  802100:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802107:	eb 16                	jmp    80211f <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  802109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80210f:	01 d0                	add    %edx,%eax
  802111:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  802118:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80211c:	ff 45 f4             	incl   -0xc(%ebp)
  80211f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802122:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802129:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80212c:	7f db                	jg     802109 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  80212e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802131:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  802138:	c1 e0 0c             	shl    $0xc,%eax
  80213b:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802144:	eb 1a                	jmp    802160 <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  802146:	83 ec 08             	sub    $0x8,%esp
  802149:	68 00 10 00 00       	push   $0x1000
  80214e:	ff 75 f0             	pushl  -0x10(%ebp)
  802151:	e8 1e fa ff ff       	call   801b74 <sys_free_user_mem>
  802156:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  802159:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  802160:	8b 55 08             	mov    0x8(%ebp),%edx
  802163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802166:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  802168:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80216b:	77 d9                	ja     802146 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  80216d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802170:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  802177:	00 00 00 00 
  80217b:	eb 01                	jmp    80217e <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  80217d:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 58             	sub    $0x58,%esp
  802186:	8b 45 10             	mov    0x10(%ebp),%eax
  802189:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80218c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802190:	75 0a                	jne    80219c <smalloc+0x1c>
		return NULL;
  802192:	b8 00 00 00 00       	mov    $0x0,%eax
  802197:	e9 7d 01 00 00       	jmp    802319 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80219c:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8021a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021a9:	01 d0                	add    %edx,%eax
  8021ab:	48                   	dec    %eax
  8021ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8021af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8021b7:	f7 75 e4             	divl   -0x1c(%ebp)
  8021ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021bd:	29 d0                	sub    %edx,%eax
  8021bf:	c1 e8 0c             	shr    $0xc,%eax
  8021c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  8021c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8021cc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8021d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8021d8:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021db:	05 00 10 00 00       	add    $0x1000,%eax
  8021e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8021e3:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8021e8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8021eb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8021ee:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  8021f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8021fb:	01 d0                	add    %edx,%eax
  8021fd:	48                   	dec    %eax
  8021fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
  802201:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802204:	ba 00 00 00 00       	mov    $0x0,%edx
  802209:	f7 75 d0             	divl   -0x30(%ebp)
  80220c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80220f:	29 d0                	sub    %edx,%eax
  802211:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  802214:	76 0a                	jbe    802220 <smalloc+0xa0>
		return NULL;
  802216:	b8 00 00 00 00       	mov    $0x0,%eax
  80221b:	e9 f9 00 00 00       	jmp    802319 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802220:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802223:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802226:	eb 48                	jmp    802270 <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  802228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222b:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80222e:	c1 e8 0c             	shr    $0xc,%eax
  802231:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  802234:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802237:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  80223e:	85 c0                	test   %eax,%eax
  802240:	75 11                	jne    802253 <smalloc+0xd3>
			freePagesCount++;
  802242:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  802245:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802249:	75 16                	jne    802261 <smalloc+0xe1>
				start = s;
  80224b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80224e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802251:	eb 0e                	jmp    802261 <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  802253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80225a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  802261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802264:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802267:	74 12                	je     80227b <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802269:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802270:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802277:	76 af                	jbe    802228 <smalloc+0xa8>
  802279:	eb 01                	jmp    80227c <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  80227b:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  80227c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802280:	74 08                	je     80228a <smalloc+0x10a>
  802282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802285:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802288:	74 0a                	je     802294 <smalloc+0x114>
		return NULL;
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
  80228f:	e9 85 00 00 00       	jmp    802319 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  802294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802297:	2b 45 d8             	sub    -0x28(%ebp),%eax
  80229a:	c1 e8 0c             	shr    $0xc,%eax
  80229d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  8022a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8022a3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022a6:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8022ad:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8022b3:	eb 11                	jmp    8022c6 <smalloc+0x146>
		markedPages[s] = 1;
  8022b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b8:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8022bf:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  8022c3:	ff 45 e8             	incl   -0x18(%ebp)
  8022c6:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022cc:	01 d0                	add    %edx,%eax
  8022ce:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8022d1:	77 e2                	ja     8022b5 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  8022d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d6:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  8022da:	52                   	push   %edx
  8022db:	50                   	push   %eax
  8022dc:	ff 75 0c             	pushl  0xc(%ebp)
  8022df:	ff 75 08             	pushl  0x8(%ebp)
  8022e2:	e8 94 f4 ff ff       	call   80177b <sys_createSharedObject>
  8022e7:	83 c4 10             	add    $0x10,%esp
  8022ea:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  8022ed:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8022f1:	78 12                	js     802305 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  8022f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8022f6:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8022f9:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  802300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802303:	eb 14                	jmp    802319 <smalloc+0x199>
	}
	free((void*) start);
  802305:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802308:	83 ec 0c             	sub    $0xc,%esp
  80230b:	50                   	push   %eax
  80230c:	e8 6e fd ff ff       	call   80207f <free>
  802311:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802314:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  802321:	83 ec 08             	sub    $0x8,%esp
  802324:	ff 75 0c             	pushl  0xc(%ebp)
  802327:	ff 75 08             	pushl  0x8(%ebp)
  80232a:	e8 76 f4 ff ff       	call   8017a5 <sys_getSizeOfSharedObject>
  80232f:	83 c4 10             	add    $0x10,%esp
  802332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  802335:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  80233c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80233f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802342:	01 d0                	add    %edx,%eax
  802344:	48                   	dec    %eax
  802345:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802348:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80234b:	ba 00 00 00 00       	mov    $0x0,%edx
  802350:	f7 75 e0             	divl   -0x20(%ebp)
  802353:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802356:	29 d0                	sub    %edx,%eax
  802358:	c1 e8 0c             	shr    $0xc,%eax
  80235b:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80235e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802365:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  80236c:	a1 20 50 80 00       	mov    0x805020,%eax
  802371:	8b 40 7c             	mov    0x7c(%eax),%eax
  802374:	05 00 10 00 00       	add    $0x1000,%eax
  802379:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  80237c:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  802381:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802384:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802387:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80238e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802391:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802394:	01 d0                	add    %edx,%eax
  802396:	48                   	dec    %eax
  802397:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80239a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80239d:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a2:	f7 75 cc             	divl   -0x34(%ebp)
  8023a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8023a8:	29 d0                	sub    %edx,%eax
  8023aa:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8023ad:	76 0a                	jbe    8023b9 <sget+0x9e>
		return NULL;
  8023af:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b4:	e9 f7 00 00 00       	jmp    8024b0 <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8023b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8023bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8023bf:	eb 48                	jmp    802409 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  8023c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c4:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8023c7:	c1 e8 0c             	shr    $0xc,%eax
  8023ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  8023cd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8023d0:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8023d7:	85 c0                	test   %eax,%eax
  8023d9:	75 11                	jne    8023ec <sget+0xd1>
			free_Pages_Count++;
  8023db:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8023de:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8023e2:	75 16                	jne    8023fa <sget+0xdf>
				start = s;
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8023ea:	eb 0e                	jmp    8023fa <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8023ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8023f3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802400:	74 12                	je     802414 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802402:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  802409:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  802410:	76 af                	jbe    8023c1 <sget+0xa6>
  802412:	eb 01                	jmp    802415 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  802414:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  802415:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802419:	74 08                	je     802423 <sget+0x108>
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  802421:	74 0a                	je     80242d <sget+0x112>
		return NULL;
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	e9 83 00 00 00       	jmp    8024b0 <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  80242d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802430:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802433:	c1 e8 0c             	shr    $0xc,%eax
  802436:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  802439:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80243c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80243f:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802446:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802449:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80244c:	eb 11                	jmp    80245f <sget+0x144>
		markedPages[k] = 1;
  80244e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802451:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  802458:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  80245c:	ff 45 e8             	incl   -0x18(%ebp)
  80245f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802462:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802465:	01 d0                	add    %edx,%eax
  802467:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80246a:	77 e2                	ja     80244e <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  80246c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	50                   	push   %eax
  802473:	ff 75 0c             	pushl  0xc(%ebp)
  802476:	ff 75 08             	pushl  0x8(%ebp)
  802479:	e8 44 f3 ff ff       	call   8017c2 <sys_getSharedObject>
  80247e:	83 c4 10             	add    $0x10,%esp
  802481:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802484:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802488:	78 12                	js     80249c <sget+0x181>
		shardIDs[startPage] = ss;
  80248a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80248d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  802490:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  802497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249a:	eb 14                	jmp    8024b0 <sget+0x195>
	}
	free((void*) start);
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	83 ec 0c             	sub    $0xc,%esp
  8024a2:	50                   	push   %eax
  8024a3:	e8 d7 fb ff ff       	call   80207f <free>
  8024a8:	83 c4 10             	add    $0x10,%esp
	return NULL;
  8024ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  8024b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bb:	a1 20 50 80 00       	mov    0x805020,%eax
  8024c0:	8b 40 7c             	mov    0x7c(%eax),%eax
  8024c3:	29 c2                	sub    %eax,%edx
  8024c5:	89 d0                	mov    %edx,%eax
  8024c7:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  8024cc:	c1 e8 0c             	shr    $0xc,%eax
  8024cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  8024dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  8024df:	83 ec 08             	sub    $0x8,%esp
  8024e2:	ff 75 08             	pushl  0x8(%ebp)
  8024e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8024e8:	e8 f4 f2 ff ff       	call   8017e1 <sys_freeSharedObject>
  8024ed:	83 c4 10             	add    $0x10,%esp
  8024f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8024f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024f7:	75 0e                	jne    802507 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  802503:	ff ff ff ff 
	}

}
  802507:	90                   	nop
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 58 42 80 00       	push   $0x804258
  802518:	68 19 01 00 00       	push   $0x119
  80251d:	68 4a 42 80 00       	push   $0x80424a
  802522:	e8 fd dd ff ff       	call   800324 <_panic>

00802527 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  802527:	55                   	push   %ebp
  802528:	89 e5                	mov    %esp,%ebp
  80252a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 7e 42 80 00       	push   $0x80427e
  802535:	68 23 01 00 00       	push   $0x123
  80253a:	68 4a 42 80 00       	push   $0x80424a
  80253f:	e8 e0 dd ff ff       	call   800324 <_panic>

00802544 <shrink>:

}
void shrink(uint32 newSize) {
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80254a:	83 ec 04             	sub    $0x4,%esp
  80254d:	68 7e 42 80 00       	push   $0x80427e
  802552:	68 27 01 00 00       	push   $0x127
  802557:	68 4a 42 80 00       	push   $0x80424a
  80255c:	e8 c3 dd ff ff       	call   800324 <_panic>

00802561 <freeHeap>:

}
void freeHeap(void* virtual_address) {
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802567:	83 ec 04             	sub    $0x4,%esp
  80256a:	68 7e 42 80 00       	push   $0x80427e
  80256f:	68 2b 01 00 00       	push   $0x12b
  802574:	68 4a 42 80 00       	push   $0x80424a
  802579:	e8 a6 dd ff ff       	call   800324 <_panic>

0080257e <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802584:	8b 45 08             	mov    0x8(%ebp),%eax
  802587:	83 e8 04             	sub    $0x4,%eax
  80258a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  80258d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802590:	8b 00                	mov    (%eax),%eax
  802592:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	83 e8 04             	sub    $0x4,%eax
  8025a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  8025a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a9:	8b 00                	mov    (%eax),%eax
  8025ab:	83 e0 01             	and    $0x1,%eax
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	0f 94 c0             	sete   %al
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  8025bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  8025c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025c5:	83 f8 02             	cmp    $0x2,%eax
  8025c8:	74 2b                	je     8025f5 <alloc_block+0x40>
  8025ca:	83 f8 02             	cmp    $0x2,%eax
  8025cd:	7f 07                	jg     8025d6 <alloc_block+0x21>
  8025cf:	83 f8 01             	cmp    $0x1,%eax
  8025d2:	74 0e                	je     8025e2 <alloc_block+0x2d>
  8025d4:	eb 58                	jmp    80262e <alloc_block+0x79>
  8025d6:	83 f8 03             	cmp    $0x3,%eax
  8025d9:	74 2d                	je     802608 <alloc_block+0x53>
  8025db:	83 f8 04             	cmp    $0x4,%eax
  8025de:	74 3b                	je     80261b <alloc_block+0x66>
  8025e0:	eb 4c                	jmp    80262e <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  8025e2:	83 ec 0c             	sub    $0xc,%esp
  8025e5:	ff 75 08             	pushl  0x8(%ebp)
  8025e8:	e8 f7 03 00 00       	call   8029e4 <alloc_block_FF>
  8025ed:	83 c4 10             	add    $0x10,%esp
  8025f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8025f3:	eb 4a                	jmp    80263f <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8025f5:	83 ec 0c             	sub    $0xc,%esp
  8025f8:	ff 75 08             	pushl  0x8(%ebp)
  8025fb:	e8 f0 11 00 00       	call   8037f0 <alloc_block_NF>
  802600:	83 c4 10             	add    $0x10,%esp
  802603:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802606:	eb 37                	jmp    80263f <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  802608:	83 ec 0c             	sub    $0xc,%esp
  80260b:	ff 75 08             	pushl  0x8(%ebp)
  80260e:	e8 08 08 00 00       	call   802e1b <alloc_block_BF>
  802613:	83 c4 10             	add    $0x10,%esp
  802616:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  802619:	eb 24                	jmp    80263f <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  80261b:	83 ec 0c             	sub    $0xc,%esp
  80261e:	ff 75 08             	pushl  0x8(%ebp)
  802621:	e8 ad 11 00 00       	call   8037d3 <alloc_block_WF>
  802626:	83 c4 10             	add    $0x10,%esp
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  80262c:	eb 11                	jmp    80263f <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  80262e:	83 ec 0c             	sub    $0xc,%esp
  802631:	68 90 42 80 00       	push   $0x804290
  802636:	e8 a6 df ff ff       	call   8005e1 <cprintf>
  80263b:	83 c4 10             	add    $0x10,%esp
		break;
  80263e:	90                   	nop
	}
	return va;
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802642:	c9                   	leave  
  802643:	c3                   	ret    

00802644 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802644:	55                   	push   %ebp
  802645:	89 e5                	mov    %esp,%ebp
  802647:	53                   	push   %ebx
  802648:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  80264b:	83 ec 0c             	sub    $0xc,%esp
  80264e:	68 b0 42 80 00       	push   $0x8042b0
  802653:	e8 89 df ff ff       	call   8005e1 <cprintf>
  802658:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  80265b:	83 ec 0c             	sub    $0xc,%esp
  80265e:	68 db 42 80 00       	push   $0x8042db
  802663:	e8 79 df ff ff       	call   8005e1 <cprintf>
  802668:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  80266b:	8b 45 08             	mov    0x8(%ebp),%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802671:	eb 37                	jmp    8026aa <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  802673:	83 ec 0c             	sub    $0xc,%esp
  802676:	ff 75 f4             	pushl  -0xc(%ebp)
  802679:	e8 19 ff ff ff       	call   802597 <is_free_block>
  80267e:	83 c4 10             	add    $0x10,%esp
  802681:	0f be d8             	movsbl %al,%ebx
  802684:	83 ec 0c             	sub    $0xc,%esp
  802687:	ff 75 f4             	pushl  -0xc(%ebp)
  80268a:	e8 ef fe ff ff       	call   80257e <get_block_size>
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	83 ec 04             	sub    $0x4,%esp
  802695:	53                   	push   %ebx
  802696:	50                   	push   %eax
  802697:	68 f3 42 80 00       	push   $0x8042f3
  80269c:	e8 40 df ff ff       	call   8005e1 <cprintf>
  8026a1:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  8026a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8026a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ae:	74 07                	je     8026b7 <print_blocks_list+0x73>
  8026b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	eb 05                	jmp    8026bc <print_blocks_list+0x78>
  8026b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bc:	89 45 10             	mov    %eax,0x10(%ebp)
  8026bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	75 ad                	jne    802673 <print_blocks_list+0x2f>
  8026c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ca:	75 a7                	jne    802673 <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	68 b0 42 80 00       	push   $0x8042b0
  8026d4:	e8 08 df ff ff       	call   8005e1 <cprintf>
  8026d9:	83 c4 10             	add    $0x10,%esp

}
  8026dc:	90                   	nop
  8026dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e0:	c9                   	leave  
  8026e1:	c3                   	ret    

008026e2 <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  8026e2:	55                   	push   %ebp
  8026e3:	89 e5                	mov    %esp,%ebp
  8026e5:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8026e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026eb:	83 e0 01             	and    $0x1,%eax
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	74 03                	je     8026f5 <initialize_dynamic_allocator+0x13>
  8026f2:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8026f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8026f9:	0f 84 f8 00 00 00    	je     8027f7 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8026ff:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802706:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802709:	a1 40 50 98 00       	mov    0x985040,%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	0f 84 e2 00 00 00    	je     8027f8 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802725:	8b 55 08             	mov    0x8(%ebp),%edx
  802728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80272b:	01 d0                	add    %edx,%eax
  80272d:	83 e8 04             	sub    $0x4,%eax
  802730:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	83 c0 08             	add    $0x8,%eax
  802742:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802745:	8b 45 0c             	mov    0xc(%ebp),%eax
  802748:	83 e8 08             	sub    $0x8,%eax
  80274b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80274e:	83 ec 04             	sub    $0x4,%esp
  802751:	6a 00                	push   $0x0
  802753:	ff 75 e8             	pushl  -0x18(%ebp)
  802756:	ff 75 ec             	pushl  -0x14(%ebp)
  802759:	e8 9c 00 00 00       	call   8027fa <set_block_data>
  80275e:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  802761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802764:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  80276a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802774:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  80277b:	00 00 00 
  80277e:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  802785:	00 00 00 
  802788:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  80278f:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  802792:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802796:	75 17                	jne    8027af <initialize_dynamic_allocator+0xcd>
  802798:	83 ec 04             	sub    $0x4,%esp
  80279b:	68 0c 43 80 00       	push   $0x80430c
  8027a0:	68 80 00 00 00       	push   $0x80
  8027a5:	68 2f 43 80 00       	push   $0x80432f
  8027aa:	e8 75 db ff ff       	call   800324 <_panic>
  8027af:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8027b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b8:	89 10                	mov    %edx,(%eax)
  8027ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bd:	8b 00                	mov    (%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 0d                	je     8027d0 <initialize_dynamic_allocator+0xee>
  8027c3:	a1 48 50 98 00       	mov    0x985048,%eax
  8027c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027cb:	89 50 04             	mov    %edx,0x4(%eax)
  8027ce:	eb 08                	jmp    8027d8 <initialize_dynamic_allocator+0xf6>
  8027d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8027d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027db:	a3 48 50 98 00       	mov    %eax,0x985048
  8027e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ea:	a1 54 50 98 00       	mov    0x985054,%eax
  8027ef:	40                   	inc    %eax
  8027f0:	a3 54 50 98 00       	mov    %eax,0x985054
  8027f5:	eb 01                	jmp    8027f8 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8027f7:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  802800:	8b 45 0c             	mov    0xc(%ebp),%eax
  802803:	83 e0 01             	and    $0x1,%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 03                	je     80280d <set_block_data+0x13>
	{
		totalSize++;
  80280a:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	83 e8 04             	sub    $0x4,%eax
  802813:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802816:	8b 45 0c             	mov    0xc(%ebp),%eax
  802819:	83 e0 fe             	and    $0xfffffffe,%eax
  80281c:	89 c2                	mov    %eax,%edx
  80281e:	8b 45 10             	mov    0x10(%ebp),%eax
  802821:	83 e0 01             	and    $0x1,%eax
  802824:	09 c2                	or     %eax,%edx
  802826:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802829:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  80282b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80282e:	8d 50 f8             	lea    -0x8(%eax),%edx
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	01 d0                	add    %edx,%eax
  802836:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80283c:	83 e0 fe             	and    $0xfffffffe,%eax
  80283f:	89 c2                	mov    %eax,%edx
  802841:	8b 45 10             	mov    0x10(%ebp),%eax
  802844:	83 e0 01             	and    $0x1,%eax
  802847:	09 c2                	or     %eax,%edx
  802849:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80284c:	89 10                	mov    %edx,(%eax)
}
  80284e:	90                   	nop
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802857:	a1 48 50 98 00       	mov    0x985048,%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	75 68                	jne    8028c8 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  802860:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802864:	75 17                	jne    80287d <insert_sorted_in_freeList+0x2c>
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 0c 43 80 00       	push   $0x80430c
  80286e:	68 9d 00 00 00       	push   $0x9d
  802873:	68 2f 43 80 00       	push   $0x80432f
  802878:	e8 a7 da ff ff       	call   800324 <_panic>
  80287d:	8b 15 48 50 98 00    	mov    0x985048,%edx
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	89 10                	mov    %edx,(%eax)
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 0d                	je     80289e <insert_sorted_in_freeList+0x4d>
  802891:	a1 48 50 98 00       	mov    0x985048,%eax
  802896:	8b 55 08             	mov    0x8(%ebp),%edx
  802899:	89 50 04             	mov    %edx,0x4(%eax)
  80289c:	eb 08                	jmp    8028a6 <insert_sorted_in_freeList+0x55>
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	a3 48 50 98 00       	mov    %eax,0x985048
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b8:	a1 54 50 98 00       	mov    0x985054,%eax
  8028bd:	40                   	inc    %eax
  8028be:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8028c3:	e9 1a 01 00 00       	jmp    8029e2 <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8028c8:	a1 48 50 98 00       	mov    0x985048,%eax
  8028cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028d0:	eb 7f                	jmp    802951 <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8028d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d8:	76 6f                	jbe    802949 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8028da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028de:	74 06                	je     8028e6 <insert_sorted_in_freeList+0x95>
  8028e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028e4:	75 17                	jne    8028fd <insert_sorted_in_freeList+0xac>
  8028e6:	83 ec 04             	sub    $0x4,%esp
  8028e9:	68 48 43 80 00       	push   $0x804348
  8028ee:	68 a6 00 00 00       	push   $0xa6
  8028f3:	68 2f 43 80 00       	push   $0x80432f
  8028f8:	e8 27 da ff ff       	call   800324 <_panic>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 50 04             	mov    0x4(%eax),%edx
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	89 50 04             	mov    %edx,0x4(%eax)
  802909:	8b 45 08             	mov    0x8(%ebp),%eax
  80290c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 0d                	je     802928 <insert_sorted_in_freeList+0xd7>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	8b 55 08             	mov    0x8(%ebp),%edx
  802924:	89 10                	mov    %edx,(%eax)
  802926:	eb 08                	jmp    802930 <insert_sorted_in_freeList+0xdf>
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	a3 48 50 98 00       	mov    %eax,0x985048
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 55 08             	mov    0x8(%ebp),%edx
  802936:	89 50 04             	mov    %edx,0x4(%eax)
  802939:	a1 54 50 98 00       	mov    0x985054,%eax
  80293e:	40                   	inc    %eax
  80293f:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  802944:	e9 99 00 00 00       	jmp    8029e2 <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802949:	a1 50 50 98 00       	mov    0x985050,%eax
  80294e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802955:	74 07                	je     80295e <insert_sorted_in_freeList+0x10d>
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	eb 05                	jmp    802963 <insert_sorted_in_freeList+0x112>
  80295e:	b8 00 00 00 00       	mov    $0x0,%eax
  802963:	a3 50 50 98 00       	mov    %eax,0x985050
  802968:	a1 50 50 98 00       	mov    0x985050,%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	0f 85 5d ff ff ff    	jne    8028d2 <insert_sorted_in_freeList+0x81>
  802975:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802979:	0f 85 53 ff ff ff    	jne    8028d2 <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80297f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802983:	75 17                	jne    80299c <insert_sorted_in_freeList+0x14b>
  802985:	83 ec 04             	sub    $0x4,%esp
  802988:	68 80 43 80 00       	push   $0x804380
  80298d:	68 ab 00 00 00       	push   $0xab
  802992:	68 2f 43 80 00       	push   $0x80432f
  802997:	e8 88 d9 ff ff       	call   800324 <_panic>
  80299c:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	89 50 04             	mov    %edx,0x4(%eax)
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	8b 40 04             	mov    0x4(%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 0c                	je     8029be <insert_sorted_in_freeList+0x16d>
  8029b2:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8029b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	eb 08                	jmp    8029c6 <insert_sorted_in_freeList+0x175>
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	a3 48 50 98 00       	mov    %eax,0x985048
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d7:	a1 54 50 98 00       	mov    0x985054,%eax
  8029dc:	40                   	inc    %eax
  8029dd:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8029e2:	c9                   	leave  
  8029e3:	c3                   	ret    

008029e4 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8029e4:	55                   	push   %ebp
  8029e5:	89 e5                	mov    %esp,%ebp
  8029e7:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	83 e0 01             	and    $0x1,%eax
  8029f0:	85 c0                	test   %eax,%eax
  8029f2:	74 03                	je     8029f7 <alloc_block_FF+0x13>
  8029f4:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8029f7:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8029fb:	77 07                	ja     802a04 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8029fd:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  802a04:	a1 40 50 98 00       	mov    0x985040,%eax
  802a09:	85 c0                	test   %eax,%eax
  802a0b:	75 63                	jne    802a70 <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	83 c0 10             	add    $0x10,%eax
  802a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802a16:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a23:	01 d0                	add    %edx,%eax
  802a25:	48                   	dec    %eax
  802a26:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a2c:	ba 00 00 00 00       	mov    $0x0,%edx
  802a31:	f7 75 ec             	divl   -0x14(%ebp)
  802a34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a37:	29 d0                	sub    %edx,%eax
  802a39:	c1 e8 0c             	shr    $0xc,%eax
  802a3c:	83 ec 0c             	sub    $0xc,%esp
  802a3f:	50                   	push   %eax
  802a40:	e8 6e f4 ff ff       	call   801eb3 <sbrk>
  802a45:	83 c4 10             	add    $0x10,%esp
  802a48:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802a4b:	83 ec 0c             	sub    $0xc,%esp
  802a4e:	6a 00                	push   $0x0
  802a50:	e8 5e f4 ff ff       	call   801eb3 <sbrk>
  802a55:	83 c4 10             	add    $0x10,%esp
  802a58:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802a5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802a5e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802a61:	83 ec 08             	sub    $0x8,%esp
  802a64:	50                   	push   %eax
  802a65:	ff 75 e4             	pushl  -0x1c(%ebp)
  802a68:	e8 75 fc ff ff       	call   8026e2 <initialize_dynamic_allocator>
  802a6d:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  802a70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a74:	75 0a                	jne    802a80 <alloc_block_FF+0x9c>
	{
		return NULL;
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7b:	e9 99 03 00 00       	jmp    802e19 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	83 c0 08             	add    $0x8,%eax
  802a86:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802a89:	a1 48 50 98 00       	mov    0x985048,%eax
  802a8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a91:	e9 03 02 00 00       	jmp    802c99 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802a96:	83 ec 0c             	sub    $0xc,%esp
  802a99:	ff 75 f4             	pushl  -0xc(%ebp)
  802a9c:	e8 dd fa ff ff       	call   80257e <get_block_size>
  802aa1:	83 c4 10             	add    $0x10,%esp
  802aa4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802aa7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802aaa:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802aad:	0f 82 de 01 00 00    	jb     802c91 <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  802ab3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ab6:	83 c0 10             	add    $0x10,%eax
  802ab9:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802abc:	0f 87 32 01 00 00    	ja     802bf4 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  802ac2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802ac5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802ac8:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ace:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ad1:	01 d0                	add    %edx,%eax
  802ad3:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	6a 00                	push   $0x0
  802adb:	ff 75 98             	pushl  -0x68(%ebp)
  802ade:	ff 75 94             	pushl  -0x6c(%ebp)
  802ae1:	e8 14 fd ff ff       	call   8027fa <set_block_data>
  802ae6:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aed:	74 06                	je     802af5 <alloc_block_FF+0x111>
  802aef:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  802af3:	75 17                	jne    802b0c <alloc_block_FF+0x128>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 a4 43 80 00       	push   $0x8043a4
  802afd:	68 de 00 00 00       	push   $0xde
  802b02:	68 2f 43 80 00       	push   $0x80432f
  802b07:	e8 18 d8 ff ff       	call   800324 <_panic>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 10                	mov    (%eax),%edx
  802b11:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b14:	89 10                	mov    %edx,(%eax)
  802b16:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	85 c0                	test   %eax,%eax
  802b1d:	74 0b                	je     802b2a <alloc_block_FF+0x146>
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802b27:	89 50 04             	mov    %edx,0x4(%eax)
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802b30:	89 10                	mov    %edx,(%eax)
  802b32:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b38:	89 50 04             	mov    %edx,0x4(%eax)
  802b3b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	75 08                	jne    802b4c <alloc_block_FF+0x168>
  802b44:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802b47:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802b4c:	a1 54 50 98 00       	mov    0x985054,%eax
  802b51:	40                   	inc    %eax
  802b52:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802b57:	83 ec 04             	sub    $0x4,%esp
  802b5a:	6a 01                	push   $0x1
  802b5c:	ff 75 dc             	pushl  -0x24(%ebp)
  802b5f:	ff 75 f4             	pushl  -0xc(%ebp)
  802b62:	e8 93 fc ff ff       	call   8027fa <set_block_data>
  802b67:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802b6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6e:	75 17                	jne    802b87 <alloc_block_FF+0x1a3>
  802b70:	83 ec 04             	sub    $0x4,%esp
  802b73:	68 d8 43 80 00       	push   $0x8043d8
  802b78:	68 e3 00 00 00       	push   $0xe3
  802b7d:	68 2f 43 80 00       	push   $0x80432f
  802b82:	e8 9d d7 ff ff       	call   800324 <_panic>
  802b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	74 10                	je     802ba0 <alloc_block_FF+0x1bc>
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 00                	mov    (%eax),%eax
  802b95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b98:	8b 52 04             	mov    0x4(%edx),%edx
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	eb 0b                	jmp    802bab <alloc_block_FF+0x1c7>
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 04             	mov    0x4(%eax),%eax
  802ba6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bae:	8b 40 04             	mov    0x4(%eax),%eax
  802bb1:	85 c0                	test   %eax,%eax
  802bb3:	74 0f                	je     802bc4 <alloc_block_FF+0x1e0>
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	8b 40 04             	mov    0x4(%eax),%eax
  802bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbe:	8b 12                	mov    (%edx),%edx
  802bc0:	89 10                	mov    %edx,(%eax)
  802bc2:	eb 0a                	jmp    802bce <alloc_block_FF+0x1ea>
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 00                	mov    (%eax),%eax
  802bc9:	a3 48 50 98 00       	mov    %eax,0x985048
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be1:	a1 54 50 98 00       	mov    0x985054,%eax
  802be6:	48                   	dec    %eax
  802be7:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	e9 25 02 00 00       	jmp    802e19 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  802bf4:	83 ec 04             	sub    $0x4,%esp
  802bf7:	6a 01                	push   $0x1
  802bf9:	ff 75 9c             	pushl  -0x64(%ebp)
  802bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  802bff:	e8 f6 fb ff ff       	call   8027fa <set_block_data>
  802c04:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0b:	75 17                	jne    802c24 <alloc_block_FF+0x240>
  802c0d:	83 ec 04             	sub    $0x4,%esp
  802c10:	68 d8 43 80 00       	push   $0x8043d8
  802c15:	68 eb 00 00 00       	push   $0xeb
  802c1a:	68 2f 43 80 00       	push   $0x80432f
  802c1f:	e8 00 d7 ff ff       	call   800324 <_panic>
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 10                	je     802c3d <alloc_block_FF+0x259>
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c35:	8b 52 04             	mov    0x4(%edx),%edx
  802c38:	89 50 04             	mov    %edx,0x4(%eax)
  802c3b:	eb 0b                	jmp    802c48 <alloc_block_FF+0x264>
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 04             	mov    0x4(%eax),%eax
  802c43:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 04             	mov    0x4(%eax),%eax
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	74 0f                	je     802c61 <alloc_block_FF+0x27d>
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 40 04             	mov    0x4(%eax),%eax
  802c58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5b:	8b 12                	mov    (%edx),%edx
  802c5d:	89 10                	mov    %edx,(%eax)
  802c5f:	eb 0a                	jmp    802c6b <alloc_block_FF+0x287>
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	a3 48 50 98 00       	mov    %eax,0x985048
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7e:	a1 54 50 98 00       	mov    0x985054,%eax
  802c83:	48                   	dec    %eax
  802c84:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	e9 88 01 00 00       	jmp    802e19 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802c91:	a1 50 50 98 00       	mov    0x985050,%eax
  802c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9d:	74 07                	je     802ca6 <alloc_block_FF+0x2c2>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	eb 05                	jmp    802cab <alloc_block_FF+0x2c7>
  802ca6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cab:	a3 50 50 98 00       	mov    %eax,0x985050
  802cb0:	a1 50 50 98 00       	mov    0x985050,%eax
  802cb5:	85 c0                	test   %eax,%eax
  802cb7:	0f 85 d9 fd ff ff    	jne    802a96 <alloc_block_FF+0xb2>
  802cbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc1:	0f 85 cf fd ff ff    	jne    802a96 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802cc7:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  802cce:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802cd1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802cd4:	01 d0                	add    %edx,%eax
  802cd6:	48                   	dec    %eax
  802cd7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802cda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  802ce2:	f7 75 d8             	divl   -0x28(%ebp)
  802ce5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802ce8:	29 d0                	sub    %edx,%eax
  802cea:	c1 e8 0c             	shr    $0xc,%eax
  802ced:	83 ec 0c             	sub    $0xc,%esp
  802cf0:	50                   	push   %eax
  802cf1:	e8 bd f1 ff ff       	call   801eb3 <sbrk>
  802cf6:	83 c4 10             	add    $0x10,%esp
  802cf9:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802cfc:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  802d00:	75 0a                	jne    802d0c <alloc_block_FF+0x328>
		return NULL;
  802d02:	b8 00 00 00 00       	mov    $0x0,%eax
  802d07:	e9 0d 01 00 00       	jmp    802e19 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802d0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d0f:	83 e8 04             	sub    $0x4,%eax
  802d12:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802d15:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802d1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d1f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802d22:	01 d0                	add    %edx,%eax
  802d24:	48                   	dec    %eax
  802d25:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802d28:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d2b:	ba 00 00 00 00       	mov    $0x0,%edx
  802d30:	f7 75 c8             	divl   -0x38(%ebp)
  802d33:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802d36:	29 d0                	sub    %edx,%eax
  802d38:	c1 e8 02             	shr    $0x2,%eax
  802d3b:	c1 e0 02             	shl    $0x2,%eax
  802d3e:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  802d41:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802d44:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802d4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d4d:	83 e8 08             	sub    $0x8,%eax
  802d50:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802d53:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	83 e0 fe             	and    $0xfffffffe,%eax
  802d5b:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802d5e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802d61:	f7 d8                	neg    %eax
  802d63:	89 c2                	mov    %eax,%edx
  802d65:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802d68:	01 d0                	add    %edx,%eax
  802d6a:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802d6d:	83 ec 0c             	sub    $0xc,%esp
  802d70:	ff 75 b8             	pushl  -0x48(%ebp)
  802d73:	e8 1f f8 ff ff       	call   802597 <is_free_block>
  802d78:	83 c4 10             	add    $0x10,%esp
  802d7b:	0f be c0             	movsbl %al,%eax
  802d7e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802d81:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802d85:	74 42                	je     802dc9 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802d87:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802d8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802d91:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802d94:	01 d0                	add    %edx,%eax
  802d96:	48                   	dec    %eax
  802d97:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802d9a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  802da2:	f7 75 b0             	divl   -0x50(%ebp)
  802da5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802da8:	29 d0                	sub    %edx,%eax
  802daa:	89 c2                	mov    %eax,%edx
  802dac:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802daf:	01 d0                	add    %edx,%eax
  802db1:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802db4:	83 ec 04             	sub    $0x4,%esp
  802db7:	6a 00                	push   $0x0
  802db9:	ff 75 a8             	pushl  -0x58(%ebp)
  802dbc:	ff 75 b8             	pushl  -0x48(%ebp)
  802dbf:	e8 36 fa ff ff       	call   8027fa <set_block_data>
  802dc4:	83 c4 10             	add    $0x10,%esp
  802dc7:	eb 42                	jmp    802e0b <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802dc9:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802dd3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802dd6:	01 d0                	add    %edx,%eax
  802dd8:	48                   	dec    %eax
  802dd9:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802ddc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802ddf:	ba 00 00 00 00       	mov    $0x0,%edx
  802de4:	f7 75 a4             	divl   -0x5c(%ebp)
  802de7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802dea:	29 d0                	sub    %edx,%eax
  802dec:	83 ec 04             	sub    $0x4,%esp
  802def:	6a 00                	push   $0x0
  802df1:	50                   	push   %eax
  802df2:	ff 75 d0             	pushl  -0x30(%ebp)
  802df5:	e8 00 fa ff ff       	call   8027fa <set_block_data>
  802dfa:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802dfd:	83 ec 0c             	sub    $0xc,%esp
  802e00:	ff 75 d0             	pushl  -0x30(%ebp)
  802e03:	e8 49 fa ff ff       	call   802851 <insert_sorted_in_freeList>
  802e08:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802e0b:	83 ec 0c             	sub    $0xc,%esp
  802e0e:	ff 75 08             	pushl  0x8(%ebp)
  802e11:	e8 ce fb ff ff       	call   8029e4 <alloc_block_FF>
  802e16:	83 c4 10             	add    $0x10,%esp
}
  802e19:	c9                   	leave  
  802e1a:	c3                   	ret    

00802e1b <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802e1b:	55                   	push   %ebp
  802e1c:	89 e5                	mov    %esp,%ebp
  802e1e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802e21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e25:	75 0a                	jne    802e31 <alloc_block_BF+0x16>
	{
		return NULL;
  802e27:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2c:	e9 7a 02 00 00       	jmp    8030ab <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	83 c0 08             	add    $0x8,%eax
  802e37:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802e3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802e41:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e48:	a1 48 50 98 00       	mov    0x985048,%eax
  802e4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e50:	eb 32                	jmp    802e84 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802e52:	ff 75 ec             	pushl  -0x14(%ebp)
  802e55:	e8 24 f7 ff ff       	call   80257e <get_block_size>
  802e5a:	83 c4 04             	add    $0x4,%esp
  802e5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802e60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e63:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e66:	72 14                	jb     802e7c <alloc_block_BF+0x61>
  802e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e6b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e6e:	73 0c                	jae    802e7c <alloc_block_BF+0x61>
		{
			minBlk = block;
  802e70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802e76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802e7c:	a1 50 50 98 00       	mov    0x985050,%eax
  802e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e88:	74 07                	je     802e91 <alloc_block_BF+0x76>
  802e8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	eb 05                	jmp    802e96 <alloc_block_BF+0x7b>
  802e91:	b8 00 00 00 00       	mov    $0x0,%eax
  802e96:	a3 50 50 98 00       	mov    %eax,0x985050
  802e9b:	a1 50 50 98 00       	mov    0x985050,%eax
  802ea0:	85 c0                	test   %eax,%eax
  802ea2:	75 ae                	jne    802e52 <alloc_block_BF+0x37>
  802ea4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ea8:	75 a8                	jne    802e52 <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802eaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eae:	75 22                	jne    802ed2 <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb3:	83 ec 0c             	sub    $0xc,%esp
  802eb6:	50                   	push   %eax
  802eb7:	e8 f7 ef ff ff       	call   801eb3 <sbrk>
  802ebc:	83 c4 10             	add    $0x10,%esp
  802ebf:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802ec2:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802ec6:	75 0a                	jne    802ed2 <alloc_block_BF+0xb7>
			return NULL;
  802ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ecd:	e9 d9 01 00 00       	jmp    8030ab <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed5:	83 c0 10             	add    $0x10,%eax
  802ed8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802edb:	0f 87 32 01 00 00    	ja     803013 <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ee7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802eea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef0:	01 d0                	add    %edx,%eax
  802ef2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	6a 00                	push   $0x0
  802efa:	ff 75 dc             	pushl  -0x24(%ebp)
  802efd:	ff 75 d8             	pushl  -0x28(%ebp)
  802f00:	e8 f5 f8 ff ff       	call   8027fa <set_block_data>
  802f05:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0c:	74 06                	je     802f14 <alloc_block_BF+0xf9>
  802f0e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802f12:	75 17                	jne    802f2b <alloc_block_BF+0x110>
  802f14:	83 ec 04             	sub    $0x4,%esp
  802f17:	68 a4 43 80 00       	push   $0x8043a4
  802f1c:	68 49 01 00 00       	push   $0x149
  802f21:	68 2f 43 80 00       	push   $0x80432f
  802f26:	e8 f9 d3 ff ff       	call   800324 <_panic>
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 10                	mov    (%eax),%edx
  802f30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f33:	89 10                	mov    %edx,(%eax)
  802f35:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 0b                	je     802f49 <alloc_block_BF+0x12e>
  802f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	75 08                	jne    802f6b <alloc_block_BF+0x150>
  802f63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f66:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f6b:	a1 54 50 98 00       	mov    0x985054,%eax
  802f70:	40                   	inc    %eax
  802f71:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	6a 01                	push   $0x1
  802f7b:	ff 75 e8             	pushl  -0x18(%ebp)
  802f7e:	ff 75 f4             	pushl  -0xc(%ebp)
  802f81:	e8 74 f8 ff ff       	call   8027fa <set_block_data>
  802f86:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8d:	75 17                	jne    802fa6 <alloc_block_BF+0x18b>
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	68 d8 43 80 00       	push   $0x8043d8
  802f97:	68 4e 01 00 00       	push   $0x14e
  802f9c:	68 2f 43 80 00       	push   $0x80432f
  802fa1:	e8 7e d3 ff ff       	call   800324 <_panic>
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	85 c0                	test   %eax,%eax
  802fad:	74 10                	je     802fbf <alloc_block_BF+0x1a4>
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 00                	mov    (%eax),%eax
  802fb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fb7:	8b 52 04             	mov    0x4(%edx),%edx
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	eb 0b                	jmp    802fca <alloc_block_BF+0x1af>
  802fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc2:	8b 40 04             	mov    0x4(%eax),%eax
  802fc5:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcd:	8b 40 04             	mov    0x4(%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 0f                	je     802fe3 <alloc_block_BF+0x1c8>
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 40 04             	mov    0x4(%eax),%eax
  802fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fdd:	8b 12                	mov    (%edx),%edx
  802fdf:	89 10                	mov    %edx,(%eax)
  802fe1:	eb 0a                	jmp    802fed <alloc_block_BF+0x1d2>
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	a3 48 50 98 00       	mov    %eax,0x985048
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803000:	a1 54 50 98 00       	mov    0x985054,%eax
  803005:	48                   	dec    %eax
  803006:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  80300b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300e:	e9 98 00 00 00       	jmp    8030ab <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	6a 01                	push   $0x1
  803018:	ff 75 f0             	pushl  -0x10(%ebp)
  80301b:	ff 75 f4             	pushl  -0xc(%ebp)
  80301e:	e8 d7 f7 ff ff       	call   8027fa <set_block_data>
  803023:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  803026:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302a:	75 17                	jne    803043 <alloc_block_BF+0x228>
  80302c:	83 ec 04             	sub    $0x4,%esp
  80302f:	68 d8 43 80 00       	push   $0x8043d8
  803034:	68 56 01 00 00       	push   $0x156
  803039:	68 2f 43 80 00       	push   $0x80432f
  80303e:	e8 e1 d2 ff ff       	call   800324 <_panic>
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 10                	je     80305c <alloc_block_BF+0x241>
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803054:	8b 52 04             	mov    0x4(%edx),%edx
  803057:	89 50 04             	mov    %edx,0x4(%eax)
  80305a:	eb 0b                	jmp    803067 <alloc_block_BF+0x24c>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 40 04             	mov    0x4(%eax),%eax
  803062:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 40 04             	mov    0x4(%eax),%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	74 0f                	je     803080 <alloc_block_BF+0x265>
  803071:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80307a:	8b 12                	mov    (%edx),%edx
  80307c:	89 10                	mov    %edx,(%eax)
  80307e:	eb 0a                	jmp    80308a <alloc_block_BF+0x26f>
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	a3 48 50 98 00       	mov    %eax,0x985048
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803093:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803096:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309d:	a1 54 50 98 00       	mov    0x985054,%eax
  8030a2:	48                   	dec    %eax
  8030a3:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8030a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  8030ab:	c9                   	leave  
  8030ac:	c3                   	ret    

008030ad <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8030ad:	55                   	push   %ebp
  8030ae:	89 e5                	mov    %esp,%ebp
  8030b0:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  8030b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b7:	0f 84 6a 02 00 00    	je     803327 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  8030bd:	ff 75 08             	pushl  0x8(%ebp)
  8030c0:	e8 b9 f4 ff ff       	call   80257e <get_block_size>
  8030c5:	83 c4 04             	add    $0x4,%esp
  8030c8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	83 e8 08             	sub    $0x8,%eax
  8030d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8030d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	83 e0 fe             	and    $0xfffffffe,%eax
  8030dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8030df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e2:	f7 d8                	neg    %eax
  8030e4:	89 c2                	mov    %eax,%edx
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	01 d0                	add    %edx,%eax
  8030eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  8030ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8030f1:	e8 a1 f4 ff ff       	call   802597 <is_free_block>
  8030f6:	83 c4 04             	add    $0x4,%esp
  8030f9:	0f be c0             	movsbl %al,%eax
  8030fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  8030ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803102:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803105:	01 d0                	add    %edx,%eax
  803107:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  80310a:	ff 75 e0             	pushl  -0x20(%ebp)
  80310d:	e8 85 f4 ff ff       	call   802597 <is_free_block>
  803112:	83 c4 04             	add    $0x4,%esp
  803115:	0f be c0             	movsbl %al,%eax
  803118:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  80311b:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80311f:	75 34                	jne    803155 <free_block+0xa8>
  803121:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  803125:	75 2e                	jne    803155 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  803127:	ff 75 e8             	pushl  -0x18(%ebp)
  80312a:	e8 4f f4 ff ff       	call   80257e <get_block_size>
  80312f:	83 c4 04             	add    $0x4,%esp
  803132:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  803135:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803138:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80313b:	01 d0                	add    %edx,%eax
  80313d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  803140:	6a 00                	push   $0x0
  803142:	ff 75 d4             	pushl  -0x2c(%ebp)
  803145:	ff 75 e8             	pushl  -0x18(%ebp)
  803148:	e8 ad f6 ff ff       	call   8027fa <set_block_data>
  80314d:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  803150:	e9 d3 01 00 00       	jmp    803328 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  803155:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803159:	0f 85 c8 00 00 00    	jne    803227 <free_block+0x17a>
  80315f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803163:	0f 85 be 00 00 00    	jne    803227 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  803169:	ff 75 e0             	pushl  -0x20(%ebp)
  80316c:	e8 0d f4 ff ff       	call   80257e <get_block_size>
  803171:	83 c4 04             	add    $0x4,%esp
  803174:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  803177:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80317d:	01 d0                	add    %edx,%eax
  80317f:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  803182:	6a 00                	push   $0x0
  803184:	ff 75 cc             	pushl  -0x34(%ebp)
  803187:	ff 75 08             	pushl  0x8(%ebp)
  80318a:	e8 6b f6 ff ff       	call   8027fa <set_block_data>
  80318f:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  803192:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803196:	75 17                	jne    8031af <free_block+0x102>
  803198:	83 ec 04             	sub    $0x4,%esp
  80319b:	68 d8 43 80 00       	push   $0x8043d8
  8031a0:	68 87 01 00 00       	push   $0x187
  8031a5:	68 2f 43 80 00       	push   $0x80432f
  8031aa:	e8 75 d1 ff ff       	call   800324 <_panic>
  8031af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031b2:	8b 00                	mov    (%eax),%eax
  8031b4:	85 c0                	test   %eax,%eax
  8031b6:	74 10                	je     8031c8 <free_block+0x11b>
  8031b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031bb:	8b 00                	mov    (%eax),%eax
  8031bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031c0:	8b 52 04             	mov    0x4(%edx),%edx
  8031c3:	89 50 04             	mov    %edx,0x4(%eax)
  8031c6:	eb 0b                	jmp    8031d3 <free_block+0x126>
  8031c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031cb:	8b 40 04             	mov    0x4(%eax),%eax
  8031ce:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8031d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031d6:	8b 40 04             	mov    0x4(%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 0f                	je     8031ec <free_block+0x13f>
  8031dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031e0:	8b 40 04             	mov    0x4(%eax),%eax
  8031e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031e6:	8b 12                	mov    (%edx),%edx
  8031e8:	89 10                	mov    %edx,(%eax)
  8031ea:	eb 0a                	jmp    8031f6 <free_block+0x149>
  8031ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031ef:	8b 00                	mov    (%eax),%eax
  8031f1:	a3 48 50 98 00       	mov    %eax,0x985048
  8031f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8031f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803202:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803209:	a1 54 50 98 00       	mov    0x985054,%eax
  80320e:	48                   	dec    %eax
  80320f:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803214:	83 ec 0c             	sub    $0xc,%esp
  803217:	ff 75 08             	pushl  0x8(%ebp)
  80321a:	e8 32 f6 ff ff       	call   802851 <insert_sorted_in_freeList>
  80321f:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  803222:	e9 01 01 00 00       	jmp    803328 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  803227:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  80322b:	0f 85 d3 00 00 00    	jne    803304 <free_block+0x257>
  803231:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  803235:	0f 85 c9 00 00 00    	jne    803304 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  80323b:	83 ec 0c             	sub    $0xc,%esp
  80323e:	ff 75 e8             	pushl  -0x18(%ebp)
  803241:	e8 38 f3 ff ff       	call   80257e <get_block_size>
  803246:	83 c4 10             	add    $0x10,%esp
  803249:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  80324c:	83 ec 0c             	sub    $0xc,%esp
  80324f:	ff 75 e0             	pushl  -0x20(%ebp)
  803252:	e8 27 f3 ff ff       	call   80257e <get_block_size>
  803257:	83 c4 10             	add    $0x10,%esp
  80325a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  80325d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803260:	8b 45 c8             	mov    -0x38(%ebp),%eax
  803263:	01 c2                	add    %eax,%edx
  803265:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  803268:	01 d0                	add    %edx,%eax
  80326a:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  80326d:	83 ec 04             	sub    $0x4,%esp
  803270:	6a 00                	push   $0x0
  803272:	ff 75 c0             	pushl  -0x40(%ebp)
  803275:	ff 75 e8             	pushl  -0x18(%ebp)
  803278:	e8 7d f5 ff ff       	call   8027fa <set_block_data>
  80327d:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  803280:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803284:	75 17                	jne    80329d <free_block+0x1f0>
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 d8 43 80 00       	push   $0x8043d8
  80328e:	68 94 01 00 00       	push   $0x194
  803293:	68 2f 43 80 00       	push   $0x80432f
  803298:	e8 87 d0 ff ff       	call   800324 <_panic>
  80329d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a0:	8b 00                	mov    (%eax),%eax
  8032a2:	85 c0                	test   %eax,%eax
  8032a4:	74 10                	je     8032b6 <free_block+0x209>
  8032a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032a9:	8b 00                	mov    (%eax),%eax
  8032ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032ae:	8b 52 04             	mov    0x4(%edx),%edx
  8032b1:	89 50 04             	mov    %edx,0x4(%eax)
  8032b4:	eb 0b                	jmp    8032c1 <free_block+0x214>
  8032b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b9:	8b 40 04             	mov    0x4(%eax),%eax
  8032bc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8032c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c4:	8b 40 04             	mov    0x4(%eax),%eax
  8032c7:	85 c0                	test   %eax,%eax
  8032c9:	74 0f                	je     8032da <free_block+0x22d>
  8032cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032ce:	8b 40 04             	mov    0x4(%eax),%eax
  8032d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032d4:	8b 12                	mov    (%edx),%edx
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	eb 0a                	jmp    8032e4 <free_block+0x237>
  8032da:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032dd:	8b 00                	mov    (%eax),%eax
  8032df:	a3 48 50 98 00       	mov    %eax,0x985048
  8032e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f7:	a1 54 50 98 00       	mov    0x985054,%eax
  8032fc:	48                   	dec    %eax
  8032fd:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  803302:	eb 24                	jmp    803328 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  803304:	83 ec 04             	sub    $0x4,%esp
  803307:	6a 00                	push   $0x0
  803309:	ff 75 f4             	pushl  -0xc(%ebp)
  80330c:	ff 75 08             	pushl  0x8(%ebp)
  80330f:	e8 e6 f4 ff ff       	call   8027fa <set_block_data>
  803314:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  803317:	83 ec 0c             	sub    $0xc,%esp
  80331a:	ff 75 08             	pushl  0x8(%ebp)
  80331d:	e8 2f f5 ff ff       	call   802851 <insert_sorted_in_freeList>
  803322:	83 c4 10             	add    $0x10,%esp
  803325:	eb 01                	jmp    803328 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  803327:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  803328:	c9                   	leave  
  803329:	c3                   	ret    

0080332a <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  80332a:	55                   	push   %ebp
  80332b:	89 e5                	mov    %esp,%ebp
  80332d:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  803330:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803334:	75 10                	jne    803346 <realloc_block_FF+0x1c>
  803336:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80333a:	75 0a                	jne    803346 <realloc_block_FF+0x1c>
	{
		return NULL;
  80333c:	b8 00 00 00 00       	mov    $0x0,%eax
  803341:	e9 8b 04 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803346:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80334a:	75 18                	jne    803364 <realloc_block_FF+0x3a>
	{
		free_block(va);
  80334c:	83 ec 0c             	sub    $0xc,%esp
  80334f:	ff 75 08             	pushl  0x8(%ebp)
  803352:	e8 56 fd ff ff       	call   8030ad <free_block>
  803357:	83 c4 10             	add    $0x10,%esp
		return NULL;
  80335a:	b8 00 00 00 00       	mov    $0x0,%eax
  80335f:	e9 6d 04 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803364:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803368:	75 13                	jne    80337d <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  80336a:	83 ec 0c             	sub    $0xc,%esp
  80336d:	ff 75 0c             	pushl  0xc(%ebp)
  803370:	e8 6f f6 ff ff       	call   8029e4 <alloc_block_FF>
  803375:	83 c4 10             	add    $0x10,%esp
  803378:	e9 54 04 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  80337d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803380:	83 e0 01             	and    $0x1,%eax
  803383:	85 c0                	test   %eax,%eax
  803385:	74 03                	je     80338a <realloc_block_FF+0x60>
	{
		new_size++;
  803387:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  80338a:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80338e:	77 07                	ja     803397 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  803390:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803397:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  80339b:	83 ec 0c             	sub    $0xc,%esp
  80339e:	ff 75 08             	pushl  0x8(%ebp)
  8033a1:	e8 d8 f1 ff ff       	call   80257e <get_block_size>
  8033a6:	83 c4 10             	add    $0x10,%esp
  8033a9:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033b2:	75 08                	jne    8033bc <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	e9 15 04 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  8033bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c2:	01 d0                	add    %edx,%eax
  8033c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  8033c7:	83 ec 0c             	sub    $0xc,%esp
  8033ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8033cd:	e8 c5 f1 ff ff       	call   802597 <is_free_block>
  8033d2:	83 c4 10             	add    $0x10,%esp
  8033d5:	0f be c0             	movsbl %al,%eax
  8033d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  8033db:	83 ec 0c             	sub    $0xc,%esp
  8033de:	ff 75 f0             	pushl  -0x10(%ebp)
  8033e1:	e8 98 f1 ff ff       	call   80257e <get_block_size>
  8033e6:	83 c4 10             	add    $0x10,%esp
  8033e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8033f2:	0f 86 a7 02 00 00    	jbe    80369f <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8033f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033fc:	0f 84 86 02 00 00    	je     803688 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  803402:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	01 d0                	add    %edx,%eax
  80340a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80340d:	0f 85 b2 00 00 00    	jne    8034c5 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  803413:	83 ec 0c             	sub    $0xc,%esp
  803416:	ff 75 08             	pushl  0x8(%ebp)
  803419:	e8 79 f1 ff ff       	call   802597 <is_free_block>
  80341e:	83 c4 10             	add    $0x10,%esp
  803421:	84 c0                	test   %al,%al
  803423:	0f 94 c0             	sete   %al
  803426:	0f b6 c0             	movzbl %al,%eax
  803429:	83 ec 04             	sub    $0x4,%esp
  80342c:	50                   	push   %eax
  80342d:	ff 75 0c             	pushl  0xc(%ebp)
  803430:	ff 75 08             	pushl  0x8(%ebp)
  803433:	e8 c2 f3 ff ff       	call   8027fa <set_block_data>
  803438:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  80343b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80343f:	75 17                	jne    803458 <realloc_block_FF+0x12e>
  803441:	83 ec 04             	sub    $0x4,%esp
  803444:	68 d8 43 80 00       	push   $0x8043d8
  803449:	68 db 01 00 00       	push   $0x1db
  80344e:	68 2f 43 80 00       	push   $0x80432f
  803453:	e8 cc ce ff ff       	call   800324 <_panic>
  803458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	85 c0                	test   %eax,%eax
  80345f:	74 10                	je     803471 <realloc_block_FF+0x147>
  803461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803469:	8b 52 04             	mov    0x4(%edx),%edx
  80346c:	89 50 04             	mov    %edx,0x4(%eax)
  80346f:	eb 0b                	jmp    80347c <realloc_block_FF+0x152>
  803471:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803474:	8b 40 04             	mov    0x4(%eax),%eax
  803477:	a3 4c 50 98 00       	mov    %eax,0x98504c
  80347c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	74 0f                	je     803495 <realloc_block_FF+0x16b>
  803486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803489:	8b 40 04             	mov    0x4(%eax),%eax
  80348c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80348f:	8b 12                	mov    (%edx),%edx
  803491:	89 10                	mov    %edx,(%eax)
  803493:	eb 0a                	jmp    80349f <realloc_block_FF+0x175>
  803495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	a3 48 50 98 00       	mov    %eax,0x985048
  80349f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b2:	a1 54 50 98 00       	mov    0x985054,%eax
  8034b7:	48                   	dec    %eax
  8034b8:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  8034bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c0:	e9 0c 03 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  8034c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cb:	01 d0                	add    %edx,%eax
  8034cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034d0:	0f 86 b2 01 00 00    	jbe    803688 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  8034d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034d9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8034dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  8034df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8034e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8034e8:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8034ec:	0f 87 b8 00 00 00    	ja     8035aa <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8034f2:	83 ec 0c             	sub    $0xc,%esp
  8034f5:	ff 75 08             	pushl  0x8(%ebp)
  8034f8:	e8 9a f0 ff ff       	call   802597 <is_free_block>
  8034fd:	83 c4 10             	add    $0x10,%esp
  803500:	84 c0                	test   %al,%al
  803502:	0f 94 c0             	sete   %al
  803505:	0f b6 c0             	movzbl %al,%eax
  803508:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80350b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80350e:	01 ca                	add    %ecx,%edx
  803510:	83 ec 04             	sub    $0x4,%esp
  803513:	50                   	push   %eax
  803514:	52                   	push   %edx
  803515:	ff 75 08             	pushl  0x8(%ebp)
  803518:	e8 dd f2 ff ff       	call   8027fa <set_block_data>
  80351d:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803520:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803524:	75 17                	jne    80353d <realloc_block_FF+0x213>
  803526:	83 ec 04             	sub    $0x4,%esp
  803529:	68 d8 43 80 00       	push   $0x8043d8
  80352e:	68 e8 01 00 00       	push   $0x1e8
  803533:	68 2f 43 80 00       	push   $0x80432f
  803538:	e8 e7 cd ff ff       	call   800324 <_panic>
  80353d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803540:	8b 00                	mov    (%eax),%eax
  803542:	85 c0                	test   %eax,%eax
  803544:	74 10                	je     803556 <realloc_block_FF+0x22c>
  803546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80354e:	8b 52 04             	mov    0x4(%edx),%edx
  803551:	89 50 04             	mov    %edx,0x4(%eax)
  803554:	eb 0b                	jmp    803561 <realloc_block_FF+0x237>
  803556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803559:	8b 40 04             	mov    0x4(%eax),%eax
  80355c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803564:	8b 40 04             	mov    0x4(%eax),%eax
  803567:	85 c0                	test   %eax,%eax
  803569:	74 0f                	je     80357a <realloc_block_FF+0x250>
  80356b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80356e:	8b 40 04             	mov    0x4(%eax),%eax
  803571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803574:	8b 12                	mov    (%edx),%edx
  803576:	89 10                	mov    %edx,(%eax)
  803578:	eb 0a                	jmp    803584 <realloc_block_FF+0x25a>
  80357a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80357d:	8b 00                	mov    (%eax),%eax
  80357f:	a3 48 50 98 00       	mov    %eax,0x985048
  803584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80358d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803597:	a1 54 50 98 00       	mov    0x985054,%eax
  80359c:	48                   	dec    %eax
  80359d:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  8035a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a5:	e9 27 02 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8035aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8035ae:	75 17                	jne    8035c7 <realloc_block_FF+0x29d>
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	68 d8 43 80 00       	push   $0x8043d8
  8035b8:	68 ed 01 00 00       	push   $0x1ed
  8035bd:	68 2f 43 80 00       	push   $0x80432f
  8035c2:	e8 5d cd ff ff       	call   800324 <_panic>
  8035c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ca:	8b 00                	mov    (%eax),%eax
  8035cc:	85 c0                	test   %eax,%eax
  8035ce:	74 10                	je     8035e0 <realloc_block_FF+0x2b6>
  8035d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035d3:	8b 00                	mov    (%eax),%eax
  8035d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035d8:	8b 52 04             	mov    0x4(%edx),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	eb 0b                	jmp    8035eb <realloc_block_FF+0x2c1>
  8035e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035e3:	8b 40 04             	mov    0x4(%eax),%eax
  8035e6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8035eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035ee:	8b 40 04             	mov    0x4(%eax),%eax
  8035f1:	85 c0                	test   %eax,%eax
  8035f3:	74 0f                	je     803604 <realloc_block_FF+0x2da>
  8035f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8035f8:	8b 40 04             	mov    0x4(%eax),%eax
  8035fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8035fe:	8b 12                	mov    (%edx),%edx
  803600:	89 10                	mov    %edx,(%eax)
  803602:	eb 0a                	jmp    80360e <realloc_block_FF+0x2e4>
  803604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803607:	8b 00                	mov    (%eax),%eax
  803609:	a3 48 50 98 00       	mov    %eax,0x985048
  80360e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80361a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803621:	a1 54 50 98 00       	mov    0x985054,%eax
  803626:	48                   	dec    %eax
  803627:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  80362c:	8b 55 08             	mov    0x8(%ebp),%edx
  80362f:	8b 45 0c             	mov    0xc(%ebp),%eax
  803632:	01 d0                	add    %edx,%eax
  803634:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  803637:	83 ec 04             	sub    $0x4,%esp
  80363a:	6a 00                	push   $0x0
  80363c:	ff 75 e0             	pushl  -0x20(%ebp)
  80363f:	ff 75 f0             	pushl  -0x10(%ebp)
  803642:	e8 b3 f1 ff ff       	call   8027fa <set_block_data>
  803647:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  80364a:	83 ec 0c             	sub    $0xc,%esp
  80364d:	ff 75 08             	pushl  0x8(%ebp)
  803650:	e8 42 ef ff ff       	call   802597 <is_free_block>
  803655:	83 c4 10             	add    $0x10,%esp
  803658:	84 c0                	test   %al,%al
  80365a:	0f 94 c0             	sete   %al
  80365d:	0f b6 c0             	movzbl %al,%eax
  803660:	83 ec 04             	sub    $0x4,%esp
  803663:	50                   	push   %eax
  803664:	ff 75 0c             	pushl  0xc(%ebp)
  803667:	ff 75 08             	pushl  0x8(%ebp)
  80366a:	e8 8b f1 ff ff       	call   8027fa <set_block_data>
  80366f:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  803672:	83 ec 0c             	sub    $0xc,%esp
  803675:	ff 75 f0             	pushl  -0x10(%ebp)
  803678:	e8 d4 f1 ff ff       	call   802851 <insert_sorted_in_freeList>
  80367d:	83 c4 10             	add    $0x10,%esp
					return va;
  803680:	8b 45 08             	mov    0x8(%ebp),%eax
  803683:	e9 49 01 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80368b:	83 e8 08             	sub    $0x8,%eax
  80368e:	83 ec 0c             	sub    $0xc,%esp
  803691:	50                   	push   %eax
  803692:	e8 4d f3 ff ff       	call   8029e4 <alloc_block_FF>
  803697:	83 c4 10             	add    $0x10,%esp
  80369a:	e9 32 01 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80369f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8036a5:	0f 83 21 01 00 00    	jae    8037cc <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	2b 45 0c             	sub    0xc(%ebp),%eax
  8036b1:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  8036b4:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  8036b8:	77 0e                	ja     8036c8 <realloc_block_FF+0x39e>
  8036ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036be:	75 08                	jne    8036c8 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	e9 09 01 00 00       	jmp    8037d1 <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  8036ce:	83 ec 0c             	sub    $0xc,%esp
  8036d1:	ff 75 08             	pushl  0x8(%ebp)
  8036d4:	e8 be ee ff ff       	call   802597 <is_free_block>
  8036d9:	83 c4 10             	add    $0x10,%esp
  8036dc:	84 c0                	test   %al,%al
  8036de:	0f 94 c0             	sete   %al
  8036e1:	0f b6 c0             	movzbl %al,%eax
  8036e4:	83 ec 04             	sub    $0x4,%esp
  8036e7:	50                   	push   %eax
  8036e8:	ff 75 0c             	pushl  0xc(%ebp)
  8036eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8036ee:	e8 07 f1 ff ff       	call   8027fa <set_block_data>
  8036f3:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8036f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8036f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036fc:	01 d0                	add    %edx,%eax
  8036fe:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  803701:	83 ec 04             	sub    $0x4,%esp
  803704:	6a 00                	push   $0x0
  803706:	ff 75 dc             	pushl  -0x24(%ebp)
  803709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80370c:	e8 e9 f0 ff ff       	call   8027fa <set_block_data>
  803711:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  803714:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803718:	0f 84 9b 00 00 00    	je     8037b9 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  80371e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  803721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803724:	01 d0                	add    %edx,%eax
  803726:	83 ec 04             	sub    $0x4,%esp
  803729:	6a 00                	push   $0x0
  80372b:	50                   	push   %eax
  80372c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80372f:	e8 c6 f0 ff ff       	call   8027fa <set_block_data>
  803734:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803737:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80373b:	75 17                	jne    803754 <realloc_block_FF+0x42a>
  80373d:	83 ec 04             	sub    $0x4,%esp
  803740:	68 d8 43 80 00       	push   $0x8043d8
  803745:	68 10 02 00 00       	push   $0x210
  80374a:	68 2f 43 80 00       	push   $0x80432f
  80374f:	e8 d0 cb ff ff       	call   800324 <_panic>
  803754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803757:	8b 00                	mov    (%eax),%eax
  803759:	85 c0                	test   %eax,%eax
  80375b:	74 10                	je     80376d <realloc_block_FF+0x443>
  80375d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803760:	8b 00                	mov    (%eax),%eax
  803762:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803765:	8b 52 04             	mov    0x4(%edx),%edx
  803768:	89 50 04             	mov    %edx,0x4(%eax)
  80376b:	eb 0b                	jmp    803778 <realloc_block_FF+0x44e>
  80376d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803770:	8b 40 04             	mov    0x4(%eax),%eax
  803773:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80377b:	8b 40 04             	mov    0x4(%eax),%eax
  80377e:	85 c0                	test   %eax,%eax
  803780:	74 0f                	je     803791 <realloc_block_FF+0x467>
  803782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803785:	8b 40 04             	mov    0x4(%eax),%eax
  803788:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80378b:	8b 12                	mov    (%edx),%edx
  80378d:	89 10                	mov    %edx,(%eax)
  80378f:	eb 0a                	jmp    80379b <realloc_block_FF+0x471>
  803791:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803794:	8b 00                	mov    (%eax),%eax
  803796:	a3 48 50 98 00       	mov    %eax,0x985048
  80379b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80379e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ae:	a1 54 50 98 00       	mov    0x985054,%eax
  8037b3:	48                   	dec    %eax
  8037b4:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8037b9:	83 ec 0c             	sub    $0xc,%esp
  8037bc:	ff 75 d4             	pushl  -0x2c(%ebp)
  8037bf:	e8 8d f0 ff ff       	call   802851 <insert_sorted_in_freeList>
  8037c4:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8037c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8037ca:	eb 05                	jmp    8037d1 <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8037cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d1:	c9                   	leave  
  8037d2:	c3                   	ret    

008037d3 <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8037d3:	55                   	push   %ebp
  8037d4:	89 e5                	mov    %esp,%ebp
  8037d6:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8037d9:	83 ec 04             	sub    $0x4,%esp
  8037dc:	68 f8 43 80 00       	push   $0x8043f8
  8037e1:	68 20 02 00 00       	push   $0x220
  8037e6:	68 2f 43 80 00       	push   $0x80432f
  8037eb:	e8 34 cb ff ff       	call   800324 <_panic>

008037f0 <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8037f0:	55                   	push   %ebp
  8037f1:	89 e5                	mov    %esp,%ebp
  8037f3:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8037f6:	83 ec 04             	sub    $0x4,%esp
  8037f9:	68 20 44 80 00       	push   $0x804420
  8037fe:	68 28 02 00 00       	push   $0x228
  803803:	68 2f 43 80 00       	push   $0x80432f
  803808:	e8 17 cb ff ff       	call   800324 <_panic>
  80380d:	66 90                	xchg   %ax,%ax
  80380f:	90                   	nop

00803810 <__udivdi3>:
  803810:	55                   	push   %ebp
  803811:	57                   	push   %edi
  803812:	56                   	push   %esi
  803813:	53                   	push   %ebx
  803814:	83 ec 1c             	sub    $0x1c,%esp
  803817:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80381b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80381f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803823:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803827:	89 ca                	mov    %ecx,%edx
  803829:	89 f8                	mov    %edi,%eax
  80382b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80382f:	85 f6                	test   %esi,%esi
  803831:	75 2d                	jne    803860 <__udivdi3+0x50>
  803833:	39 cf                	cmp    %ecx,%edi
  803835:	77 65                	ja     80389c <__udivdi3+0x8c>
  803837:	89 fd                	mov    %edi,%ebp
  803839:	85 ff                	test   %edi,%edi
  80383b:	75 0b                	jne    803848 <__udivdi3+0x38>
  80383d:	b8 01 00 00 00       	mov    $0x1,%eax
  803842:	31 d2                	xor    %edx,%edx
  803844:	f7 f7                	div    %edi
  803846:	89 c5                	mov    %eax,%ebp
  803848:	31 d2                	xor    %edx,%edx
  80384a:	89 c8                	mov    %ecx,%eax
  80384c:	f7 f5                	div    %ebp
  80384e:	89 c1                	mov    %eax,%ecx
  803850:	89 d8                	mov    %ebx,%eax
  803852:	f7 f5                	div    %ebp
  803854:	89 cf                	mov    %ecx,%edi
  803856:	89 fa                	mov    %edi,%edx
  803858:	83 c4 1c             	add    $0x1c,%esp
  80385b:	5b                   	pop    %ebx
  80385c:	5e                   	pop    %esi
  80385d:	5f                   	pop    %edi
  80385e:	5d                   	pop    %ebp
  80385f:	c3                   	ret    
  803860:	39 ce                	cmp    %ecx,%esi
  803862:	77 28                	ja     80388c <__udivdi3+0x7c>
  803864:	0f bd fe             	bsr    %esi,%edi
  803867:	83 f7 1f             	xor    $0x1f,%edi
  80386a:	75 40                	jne    8038ac <__udivdi3+0x9c>
  80386c:	39 ce                	cmp    %ecx,%esi
  80386e:	72 0a                	jb     80387a <__udivdi3+0x6a>
  803870:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803874:	0f 87 9e 00 00 00    	ja     803918 <__udivdi3+0x108>
  80387a:	b8 01 00 00 00       	mov    $0x1,%eax
  80387f:	89 fa                	mov    %edi,%edx
  803881:	83 c4 1c             	add    $0x1c,%esp
  803884:	5b                   	pop    %ebx
  803885:	5e                   	pop    %esi
  803886:	5f                   	pop    %edi
  803887:	5d                   	pop    %ebp
  803888:	c3                   	ret    
  803889:	8d 76 00             	lea    0x0(%esi),%esi
  80388c:	31 ff                	xor    %edi,%edi
  80388e:	31 c0                	xor    %eax,%eax
  803890:	89 fa                	mov    %edi,%edx
  803892:	83 c4 1c             	add    $0x1c,%esp
  803895:	5b                   	pop    %ebx
  803896:	5e                   	pop    %esi
  803897:	5f                   	pop    %edi
  803898:	5d                   	pop    %ebp
  803899:	c3                   	ret    
  80389a:	66 90                	xchg   %ax,%ax
  80389c:	89 d8                	mov    %ebx,%eax
  80389e:	f7 f7                	div    %edi
  8038a0:	31 ff                	xor    %edi,%edi
  8038a2:	89 fa                	mov    %edi,%edx
  8038a4:	83 c4 1c             	add    $0x1c,%esp
  8038a7:	5b                   	pop    %ebx
  8038a8:	5e                   	pop    %esi
  8038a9:	5f                   	pop    %edi
  8038aa:	5d                   	pop    %ebp
  8038ab:	c3                   	ret    
  8038ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038b1:	89 eb                	mov    %ebp,%ebx
  8038b3:	29 fb                	sub    %edi,%ebx
  8038b5:	89 f9                	mov    %edi,%ecx
  8038b7:	d3 e6                	shl    %cl,%esi
  8038b9:	89 c5                	mov    %eax,%ebp
  8038bb:	88 d9                	mov    %bl,%cl
  8038bd:	d3 ed                	shr    %cl,%ebp
  8038bf:	89 e9                	mov    %ebp,%ecx
  8038c1:	09 f1                	or     %esi,%ecx
  8038c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038c7:	89 f9                	mov    %edi,%ecx
  8038c9:	d3 e0                	shl    %cl,%eax
  8038cb:	89 c5                	mov    %eax,%ebp
  8038cd:	89 d6                	mov    %edx,%esi
  8038cf:	88 d9                	mov    %bl,%cl
  8038d1:	d3 ee                	shr    %cl,%esi
  8038d3:	89 f9                	mov    %edi,%ecx
  8038d5:	d3 e2                	shl    %cl,%edx
  8038d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038db:	88 d9                	mov    %bl,%cl
  8038dd:	d3 e8                	shr    %cl,%eax
  8038df:	09 c2                	or     %eax,%edx
  8038e1:	89 d0                	mov    %edx,%eax
  8038e3:	89 f2                	mov    %esi,%edx
  8038e5:	f7 74 24 0c          	divl   0xc(%esp)
  8038e9:	89 d6                	mov    %edx,%esi
  8038eb:	89 c3                	mov    %eax,%ebx
  8038ed:	f7 e5                	mul    %ebp
  8038ef:	39 d6                	cmp    %edx,%esi
  8038f1:	72 19                	jb     80390c <__udivdi3+0xfc>
  8038f3:	74 0b                	je     803900 <__udivdi3+0xf0>
  8038f5:	89 d8                	mov    %ebx,%eax
  8038f7:	31 ff                	xor    %edi,%edi
  8038f9:	e9 58 ff ff ff       	jmp    803856 <__udivdi3+0x46>
  8038fe:	66 90                	xchg   %ax,%ax
  803900:	8b 54 24 08          	mov    0x8(%esp),%edx
  803904:	89 f9                	mov    %edi,%ecx
  803906:	d3 e2                	shl    %cl,%edx
  803908:	39 c2                	cmp    %eax,%edx
  80390a:	73 e9                	jae    8038f5 <__udivdi3+0xe5>
  80390c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80390f:	31 ff                	xor    %edi,%edi
  803911:	e9 40 ff ff ff       	jmp    803856 <__udivdi3+0x46>
  803916:	66 90                	xchg   %ax,%ax
  803918:	31 c0                	xor    %eax,%eax
  80391a:	e9 37 ff ff ff       	jmp    803856 <__udivdi3+0x46>
  80391f:	90                   	nop

00803920 <__umoddi3>:
  803920:	55                   	push   %ebp
  803921:	57                   	push   %edi
  803922:	56                   	push   %esi
  803923:	53                   	push   %ebx
  803924:	83 ec 1c             	sub    $0x1c,%esp
  803927:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80392b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80392f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803933:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803937:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80393b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80393f:	89 f3                	mov    %esi,%ebx
  803941:	89 fa                	mov    %edi,%edx
  803943:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803947:	89 34 24             	mov    %esi,(%esp)
  80394a:	85 c0                	test   %eax,%eax
  80394c:	75 1a                	jne    803968 <__umoddi3+0x48>
  80394e:	39 f7                	cmp    %esi,%edi
  803950:	0f 86 a2 00 00 00    	jbe    8039f8 <__umoddi3+0xd8>
  803956:	89 c8                	mov    %ecx,%eax
  803958:	89 f2                	mov    %esi,%edx
  80395a:	f7 f7                	div    %edi
  80395c:	89 d0                	mov    %edx,%eax
  80395e:	31 d2                	xor    %edx,%edx
  803960:	83 c4 1c             	add    $0x1c,%esp
  803963:	5b                   	pop    %ebx
  803964:	5e                   	pop    %esi
  803965:	5f                   	pop    %edi
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    
  803968:	39 f0                	cmp    %esi,%eax
  80396a:	0f 87 ac 00 00 00    	ja     803a1c <__umoddi3+0xfc>
  803970:	0f bd e8             	bsr    %eax,%ebp
  803973:	83 f5 1f             	xor    $0x1f,%ebp
  803976:	0f 84 ac 00 00 00    	je     803a28 <__umoddi3+0x108>
  80397c:	bf 20 00 00 00       	mov    $0x20,%edi
  803981:	29 ef                	sub    %ebp,%edi
  803983:	89 fe                	mov    %edi,%esi
  803985:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803989:	89 e9                	mov    %ebp,%ecx
  80398b:	d3 e0                	shl    %cl,%eax
  80398d:	89 d7                	mov    %edx,%edi
  80398f:	89 f1                	mov    %esi,%ecx
  803991:	d3 ef                	shr    %cl,%edi
  803993:	09 c7                	or     %eax,%edi
  803995:	89 e9                	mov    %ebp,%ecx
  803997:	d3 e2                	shl    %cl,%edx
  803999:	89 14 24             	mov    %edx,(%esp)
  80399c:	89 d8                	mov    %ebx,%eax
  80399e:	d3 e0                	shl    %cl,%eax
  8039a0:	89 c2                	mov    %eax,%edx
  8039a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039a6:	d3 e0                	shl    %cl,%eax
  8039a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b0:	89 f1                	mov    %esi,%ecx
  8039b2:	d3 e8                	shr    %cl,%eax
  8039b4:	09 d0                	or     %edx,%eax
  8039b6:	d3 eb                	shr    %cl,%ebx
  8039b8:	89 da                	mov    %ebx,%edx
  8039ba:	f7 f7                	div    %edi
  8039bc:	89 d3                	mov    %edx,%ebx
  8039be:	f7 24 24             	mull   (%esp)
  8039c1:	89 c6                	mov    %eax,%esi
  8039c3:	89 d1                	mov    %edx,%ecx
  8039c5:	39 d3                	cmp    %edx,%ebx
  8039c7:	0f 82 87 00 00 00    	jb     803a54 <__umoddi3+0x134>
  8039cd:	0f 84 91 00 00 00    	je     803a64 <__umoddi3+0x144>
  8039d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039d7:	29 f2                	sub    %esi,%edx
  8039d9:	19 cb                	sbb    %ecx,%ebx
  8039db:	89 d8                	mov    %ebx,%eax
  8039dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039e1:	d3 e0                	shl    %cl,%eax
  8039e3:	89 e9                	mov    %ebp,%ecx
  8039e5:	d3 ea                	shr    %cl,%edx
  8039e7:	09 d0                	or     %edx,%eax
  8039e9:	89 e9                	mov    %ebp,%ecx
  8039eb:	d3 eb                	shr    %cl,%ebx
  8039ed:	89 da                	mov    %ebx,%edx
  8039ef:	83 c4 1c             	add    $0x1c,%esp
  8039f2:	5b                   	pop    %ebx
  8039f3:	5e                   	pop    %esi
  8039f4:	5f                   	pop    %edi
  8039f5:	5d                   	pop    %ebp
  8039f6:	c3                   	ret    
  8039f7:	90                   	nop
  8039f8:	89 fd                	mov    %edi,%ebp
  8039fa:	85 ff                	test   %edi,%edi
  8039fc:	75 0b                	jne    803a09 <__umoddi3+0xe9>
  8039fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803a03:	31 d2                	xor    %edx,%edx
  803a05:	f7 f7                	div    %edi
  803a07:	89 c5                	mov    %eax,%ebp
  803a09:	89 f0                	mov    %esi,%eax
  803a0b:	31 d2                	xor    %edx,%edx
  803a0d:	f7 f5                	div    %ebp
  803a0f:	89 c8                	mov    %ecx,%eax
  803a11:	f7 f5                	div    %ebp
  803a13:	89 d0                	mov    %edx,%eax
  803a15:	e9 44 ff ff ff       	jmp    80395e <__umoddi3+0x3e>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	89 c8                	mov    %ecx,%eax
  803a1e:	89 f2                	mov    %esi,%edx
  803a20:	83 c4 1c             	add    $0x1c,%esp
  803a23:	5b                   	pop    %ebx
  803a24:	5e                   	pop    %esi
  803a25:	5f                   	pop    %edi
  803a26:	5d                   	pop    %ebp
  803a27:	c3                   	ret    
  803a28:	3b 04 24             	cmp    (%esp),%eax
  803a2b:	72 06                	jb     803a33 <__umoddi3+0x113>
  803a2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a31:	77 0f                	ja     803a42 <__umoddi3+0x122>
  803a33:	89 f2                	mov    %esi,%edx
  803a35:	29 f9                	sub    %edi,%ecx
  803a37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a3b:	89 14 24             	mov    %edx,(%esp)
  803a3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a42:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a46:	8b 14 24             	mov    (%esp),%edx
  803a49:	83 c4 1c             	add    $0x1c,%esp
  803a4c:	5b                   	pop    %ebx
  803a4d:	5e                   	pop    %esi
  803a4e:	5f                   	pop    %edi
  803a4f:	5d                   	pop    %ebp
  803a50:	c3                   	ret    
  803a51:	8d 76 00             	lea    0x0(%esi),%esi
  803a54:	2b 04 24             	sub    (%esp),%eax
  803a57:	19 fa                	sbb    %edi,%edx
  803a59:	89 d1                	mov    %edx,%ecx
  803a5b:	89 c6                	mov    %eax,%esi
  803a5d:	e9 71 ff ff ff       	jmp    8039d3 <__umoddi3+0xb3>
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a68:	72 ea                	jb     803a54 <__umoddi3+0x134>
  803a6a:	89 d9                	mov    %ebx,%ecx
  803a6c:	e9 62 ff ff ff       	jmp    8039d3 <__umoddi3+0xb3>
