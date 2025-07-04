
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 48 01 00 00       	call   80017e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 bb 1a 00 00       	call   801afe <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 37 80 00       	push   $0x8037e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 43 15 00 00       	call   801599 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 37 80 00       	push   $0x8037e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 2d 15 00 00       	call   801599 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 37 80 00       	push   $0x8037e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 17 15 00 00       	call   801599 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 9d 1a 00 00       	call   801b31 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 0f 32 00 00       	call   8032cb <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 5c 1a 00 00       	call   801b31 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 ce 31 00 00       	call   8032cb <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 1d 1a 00 00       	call   801b31 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 8f 31 00 00       	call   8032cb <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	struct semaphore T ;

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 25                	jne    80016e <_main+0x136>
	{
		T = get_semaphore(parentenvID, "T");
  800149:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	68 f7 37 80 00       	push   $0x8037f7
  800154:	ff 75 f4             	pushl  -0xc(%ebp)
  800157:	50                   	push   %eax
  800158:	e8 4e 30 00 00       	call   8031ab <get_semaphore>
  80015d:	83 c4 0c             	add    $0xc,%esp
		signal_semaphore(T);
  800160:	83 ec 0c             	sub    $0xc,%esp
  800163:	ff 75 c4             	pushl  -0x3c(%ebp)
  800166:	e8 f3 30 00 00       	call   80325e <signal_semaphore>
  80016b:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	8b 00                	mov    (%eax),%eax
  800173:	8d 50 01             	lea    0x1(%eax),%edx
  800176:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800179:	89 10                	mov    %edx,(%eax)

}
  80017b:	90                   	nop
  80017c:	c9                   	leave  
  80017d:	c3                   	ret    

0080017e <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80017e:	55                   	push   %ebp
  80017f:	89 e5                	mov    %esp,%ebp
  800181:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800184:	e8 5c 19 00 00       	call   801ae5 <sys_getenvindex>
  800189:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018f:	89 d0                	mov    %edx,%eax
  800191:	c1 e0 02             	shl    $0x2,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	c1 e0 03             	shl    $0x3,%eax
  800199:	01 d0                	add    %edx,%eax
  80019b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001a2:	01 d0                	add    %edx,%eax
  8001a4:	c1 e0 02             	shl    $0x2,%eax
  8001a7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ac:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b1:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b6:	8a 40 20             	mov    0x20(%eax),%al
  8001b9:	84 c0                	test   %al,%al
  8001bb:	74 0d                	je     8001ca <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8001bd:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c2:	83 c0 20             	add    $0x20,%eax
  8001c5:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x5c>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001eb:	a1 00 50 80 00       	mov    0x805000,%eax
  8001f0:	85 c0                	test   %eax,%eax
  8001f2:	0f 84 9f 00 00 00    	je     800297 <libmain+0x119>
	{
		sys_lock_cons();
  8001f8:	e8 6c 16 00 00       	call   801869 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	68 14 38 80 00       	push   $0x803814
  800205:	e8 8d 01 00 00       	call   800397 <cprintf>
  80020a:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80020d:	a1 20 50 80 00       	mov    0x805020,%eax
  800212:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800218:	a1 20 50 80 00       	mov    0x805020,%eax
  80021d:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800223:	83 ec 04             	sub    $0x4,%esp
  800226:	52                   	push   %edx
  800227:	50                   	push   %eax
  800228:	68 3c 38 80 00       	push   $0x80383c
  80022d:	e8 65 01 00 00       	call   800397 <cprintf>
  800232:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800235:	a1 20 50 80 00       	mov    0x805020,%eax
  80023a:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800240:	a1 20 50 80 00       	mov    0x805020,%eax
  800245:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80024b:	a1 20 50 80 00       	mov    0x805020,%eax
  800250:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800256:	51                   	push   %ecx
  800257:	52                   	push   %edx
  800258:	50                   	push   %eax
  800259:	68 64 38 80 00       	push   $0x803864
  80025e:	e8 34 01 00 00       	call   800397 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800266:	a1 20 50 80 00       	mov    0x805020,%eax
  80026b:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800271:	83 ec 08             	sub    $0x8,%esp
  800274:	50                   	push   %eax
  800275:	68 bc 38 80 00       	push   $0x8038bc
  80027a:	e8 18 01 00 00       	call   800397 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800282:	83 ec 0c             	sub    $0xc,%esp
  800285:	68 14 38 80 00       	push   $0x803814
  80028a:	e8 08 01 00 00       	call   800397 <cprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800292:	e8 ec 15 00 00       	call   801883 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800297:	e8 19 00 00 00       	call   8002b5 <exit>
}
  80029c:	90                   	nop
  80029d:	c9                   	leave  
  80029e:	c3                   	ret    

0080029f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002a5:	83 ec 0c             	sub    $0xc,%esp
  8002a8:	6a 00                	push   $0x0
  8002aa:	e8 02 18 00 00       	call   801ab1 <sys_destroy_env>
  8002af:	83 c4 10             	add    $0x10,%esp
}
  8002b2:	90                   	nop
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    

008002b5 <exit>:

void
exit(void)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002bb:	e8 57 18 00 00       	call   801b17 <sys_exit_env>
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8002d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d4:	89 0a                	mov    %ecx,(%edx)
  8002d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d9:	88 d1                	mov    %dl,%cl
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ec:	75 2c                	jne    80031a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002ee:	a0 44 50 98 00       	mov    0x985044,%al
  8002f3:	0f b6 c0             	movzbl %al,%eax
  8002f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f9:	8b 12                	mov    (%edx),%edx
  8002fb:	89 d1                	mov    %edx,%ecx
  8002fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800300:	83 c2 08             	add    $0x8,%edx
  800303:	83 ec 04             	sub    $0x4,%esp
  800306:	50                   	push   %eax
  800307:	51                   	push   %ecx
  800308:	52                   	push   %edx
  800309:	e8 19 15 00 00       	call   801827 <sys_cputs>
  80030e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800311:	8b 45 0c             	mov    0xc(%ebp),%eax
  800314:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80031a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031d:	8b 40 04             	mov    0x4(%eax),%eax
  800320:	8d 50 01             	lea    0x1(%eax),%edx
  800323:	8b 45 0c             	mov    0xc(%ebp),%eax
  800326:	89 50 04             	mov    %edx,0x4(%eax)
}
  800329:	90                   	nop
  80032a:	c9                   	leave  
  80032b:	c3                   	ret    

0080032c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800335:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033c:	00 00 00 
	b.cnt = 0;
  80033f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800346:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800355:	50                   	push   %eax
  800356:	68 c3 02 80 00       	push   $0x8002c3
  80035b:	e8 11 02 00 00       	call   800571 <vprintfmt>
  800360:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800363:	a0 44 50 98 00       	mov    0x985044,%al
  800368:	0f b6 c0             	movzbl %al,%eax
  80036b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800371:	83 ec 04             	sub    $0x4,%esp
  800374:	50                   	push   %eax
  800375:	52                   	push   %edx
  800376:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80037c:	83 c0 08             	add    $0x8,%eax
  80037f:	50                   	push   %eax
  800380:	e8 a2 14 00 00       	call   801827 <sys_cputs>
  800385:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800388:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  80038f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80039d:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8003a4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b3:	50                   	push   %eax
  8003b4:	e8 73 ff ff ff       	call   80032c <vcprintf>
  8003b9:	83 c4 10             	add    $0x10,%esp
  8003bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003c2:	c9                   	leave  
  8003c3:	c3                   	ret    

008003c4 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003ca:	e8 9a 14 00 00       	call   801869 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003cf:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d8:	83 ec 08             	sub    $0x8,%esp
  8003db:	ff 75 f4             	pushl  -0xc(%ebp)
  8003de:	50                   	push   %eax
  8003df:	e8 48 ff ff ff       	call   80032c <vcprintf>
  8003e4:	83 c4 10             	add    $0x10,%esp
  8003e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003ea:	e8 94 14 00 00       	call   801883 <sys_unlock_cons>
	return cnt;
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	53                   	push   %ebx
  8003f8:	83 ec 14             	sub    $0x14,%esp
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800401:	8b 45 14             	mov    0x14(%ebp),%eax
  800404:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800407:	8b 45 18             	mov    0x18(%ebp),%eax
  80040a:	ba 00 00 00 00       	mov    $0x0,%edx
  80040f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800412:	77 55                	ja     800469 <printnum+0x75>
  800414:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800417:	72 05                	jb     80041e <printnum+0x2a>
  800419:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80041c:	77 4b                	ja     800469 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800421:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800424:	8b 45 18             	mov    0x18(%ebp),%eax
  800427:	ba 00 00 00 00       	mov    $0x0,%edx
  80042c:	52                   	push   %edx
  80042d:	50                   	push   %eax
  80042e:	ff 75 f4             	pushl  -0xc(%ebp)
  800431:	ff 75 f0             	pushl  -0x10(%ebp)
  800434:	e8 2f 31 00 00       	call   803568 <__udivdi3>
  800439:	83 c4 10             	add    $0x10,%esp
  80043c:	83 ec 04             	sub    $0x4,%esp
  80043f:	ff 75 20             	pushl  0x20(%ebp)
  800442:	53                   	push   %ebx
  800443:	ff 75 18             	pushl  0x18(%ebp)
  800446:	52                   	push   %edx
  800447:	50                   	push   %eax
  800448:	ff 75 0c             	pushl  0xc(%ebp)
  80044b:	ff 75 08             	pushl  0x8(%ebp)
  80044e:	e8 a1 ff ff ff       	call   8003f4 <printnum>
  800453:	83 c4 20             	add    $0x20,%esp
  800456:	eb 1a                	jmp    800472 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800458:	83 ec 08             	sub    $0x8,%esp
  80045b:	ff 75 0c             	pushl  0xc(%ebp)
  80045e:	ff 75 20             	pushl  0x20(%ebp)
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	ff d0                	call   *%eax
  800466:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800469:	ff 4d 1c             	decl   0x1c(%ebp)
  80046c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800470:	7f e6                	jg     800458 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800472:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80047a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800480:	53                   	push   %ebx
  800481:	51                   	push   %ecx
  800482:	52                   	push   %edx
  800483:	50                   	push   %eax
  800484:	e8 ef 31 00 00       	call   803678 <__umoddi3>
  800489:	83 c4 10             	add    $0x10,%esp
  80048c:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800491:	8a 00                	mov    (%eax),%al
  800493:	0f be c0             	movsbl %al,%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	ff 75 0c             	pushl  0xc(%ebp)
  80049c:	50                   	push   %eax
  80049d:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a0:	ff d0                	call   *%eax
  8004a2:	83 c4 10             	add    $0x10,%esp
}
  8004a5:	90                   	nop
  8004a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a9:	c9                   	leave  
  8004aa:	c3                   	ret    

008004ab <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b2:	7e 1c                	jle    8004d0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 50 08             	lea    0x8(%eax),%edx
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	89 10                	mov    %edx,(%eax)
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	83 e8 08             	sub    $0x8,%eax
  8004c9:	8b 50 04             	mov    0x4(%eax),%edx
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	eb 40                	jmp    800510 <getuint+0x65>
	else if (lflag)
  8004d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d4:	74 1e                	je     8004f4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d9:	8b 00                	mov    (%eax),%eax
  8004db:	8d 50 04             	lea    0x4(%eax),%edx
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e1:	89 10                	mov    %edx,(%eax)
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	8b 00                	mov    (%eax),%eax
  8004e8:	83 e8 04             	sub    $0x4,%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f2:	eb 1c                	jmp    800510 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	8d 50 04             	lea    0x4(%eax),%edx
  8004fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ff:	89 10                	mov    %edx,(%eax)
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	8b 00                	mov    (%eax),%eax
  800506:	83 e8 04             	sub    $0x4,%eax
  800509:	8b 00                	mov    (%eax),%eax
  80050b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800510:	5d                   	pop    %ebp
  800511:	c3                   	ret    

00800512 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800512:	55                   	push   %ebp
  800513:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800515:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800519:	7e 1c                	jle    800537 <getint+0x25>
		return va_arg(*ap, long long);
  80051b:	8b 45 08             	mov    0x8(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 50 08             	lea    0x8(%eax),%edx
  800523:	8b 45 08             	mov    0x8(%ebp),%eax
  800526:	89 10                	mov    %edx,(%eax)
  800528:	8b 45 08             	mov    0x8(%ebp),%eax
  80052b:	8b 00                	mov    (%eax),%eax
  80052d:	83 e8 08             	sub    $0x8,%eax
  800530:	8b 50 04             	mov    0x4(%eax),%edx
  800533:	8b 00                	mov    (%eax),%eax
  800535:	eb 38                	jmp    80056f <getint+0x5d>
	else if (lflag)
  800537:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80053b:	74 1a                	je     800557 <getint+0x45>
		return va_arg(*ap, long);
  80053d:	8b 45 08             	mov    0x8(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 04             	lea    0x4(%eax),%edx
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
  80054a:	8b 45 08             	mov    0x8(%ebp),%eax
  80054d:	8b 00                	mov    (%eax),%eax
  80054f:	83 e8 04             	sub    $0x4,%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	99                   	cltd   
  800555:	eb 18                	jmp    80056f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	8d 50 04             	lea    0x4(%eax),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	89 10                	mov    %edx,(%eax)
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	83 e8 04             	sub    $0x4,%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	99                   	cltd   
}
  80056f:	5d                   	pop    %ebp
  800570:	c3                   	ret    

00800571 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	56                   	push   %esi
  800575:	53                   	push   %ebx
  800576:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800579:	eb 17                	jmp    800592 <vprintfmt+0x21>
			if (ch == '\0')
  80057b:	85 db                	test   %ebx,%ebx
  80057d:	0f 84 c1 03 00 00    	je     800944 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	ff 75 0c             	pushl  0xc(%ebp)
  800589:	53                   	push   %ebx
  80058a:	8b 45 08             	mov    0x8(%ebp),%eax
  80058d:	ff d0                	call   *%eax
  80058f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800592:	8b 45 10             	mov    0x10(%ebp),%eax
  800595:	8d 50 01             	lea    0x1(%eax),%edx
  800598:	89 55 10             	mov    %edx,0x10(%ebp)
  80059b:	8a 00                	mov    (%eax),%al
  80059d:	0f b6 d8             	movzbl %al,%ebx
  8005a0:	83 fb 25             	cmp    $0x25,%ebx
  8005a3:	75 d6                	jne    80057b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005a5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005a9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005be:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c8:	8d 50 01             	lea    0x1(%eax),%edx
  8005cb:	89 55 10             	mov    %edx,0x10(%ebp)
  8005ce:	8a 00                	mov    (%eax),%al
  8005d0:	0f b6 d8             	movzbl %al,%ebx
  8005d3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005d6:	83 f8 5b             	cmp    $0x5b,%eax
  8005d9:	0f 87 3d 03 00 00    	ja     80091c <vprintfmt+0x3ab>
  8005df:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  8005e6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005e8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005ec:	eb d7                	jmp    8005c5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005ee:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005f2:	eb d1                	jmp    8005c5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fe:	89 d0                	mov    %edx,%eax
  800600:	c1 e0 02             	shl    $0x2,%eax
  800603:	01 d0                	add    %edx,%eax
  800605:	01 c0                	add    %eax,%eax
  800607:	01 d8                	add    %ebx,%eax
  800609:	83 e8 30             	sub    $0x30,%eax
  80060c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80060f:	8b 45 10             	mov    0x10(%ebp),%eax
  800612:	8a 00                	mov    (%eax),%al
  800614:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800617:	83 fb 2f             	cmp    $0x2f,%ebx
  80061a:	7e 3e                	jle    80065a <vprintfmt+0xe9>
  80061c:	83 fb 39             	cmp    $0x39,%ebx
  80061f:	7f 39                	jg     80065a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800621:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800624:	eb d5                	jmp    8005fb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800626:	8b 45 14             	mov    0x14(%ebp),%eax
  800629:	83 c0 04             	add    $0x4,%eax
  80062c:	89 45 14             	mov    %eax,0x14(%ebp)
  80062f:	8b 45 14             	mov    0x14(%ebp),%eax
  800632:	83 e8 04             	sub    $0x4,%eax
  800635:	8b 00                	mov    (%eax),%eax
  800637:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80063a:	eb 1f                	jmp    80065b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80063c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800640:	79 83                	jns    8005c5 <vprintfmt+0x54>
				width = 0;
  800642:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800649:	e9 77 ff ff ff       	jmp    8005c5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80064e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800655:	e9 6b ff ff ff       	jmp    8005c5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80065a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80065b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065f:	0f 89 60 ff ff ff    	jns    8005c5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800668:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80066b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800672:	e9 4e ff ff ff       	jmp    8005c5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800677:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80067a:	e9 46 ff ff ff       	jmp    8005c5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	83 c0 04             	add    $0x4,%eax
  800685:	89 45 14             	mov    %eax,0x14(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 e8 04             	sub    $0x4,%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	ff 75 0c             	pushl  0xc(%ebp)
  800696:	50                   	push   %eax
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	ff d0                	call   *%eax
  80069c:	83 c4 10             	add    $0x10,%esp
			break;
  80069f:	e9 9b 02 00 00       	jmp    80093f <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a7:	83 c0 04             	add    $0x4,%eax
  8006aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	83 e8 04             	sub    $0x4,%eax
  8006b3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006b5:	85 db                	test   %ebx,%ebx
  8006b7:	79 02                	jns    8006bb <vprintfmt+0x14a>
				err = -err;
  8006b9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006bb:	83 fb 64             	cmp    $0x64,%ebx
  8006be:	7f 0b                	jg     8006cb <vprintfmt+0x15a>
  8006c0:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  8006c7:	85 f6                	test   %esi,%esi
  8006c9:	75 19                	jne    8006e4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006cb:	53                   	push   %ebx
  8006cc:	68 05 3b 80 00       	push   $0x803b05
  8006d1:	ff 75 0c             	pushl  0xc(%ebp)
  8006d4:	ff 75 08             	pushl  0x8(%ebp)
  8006d7:	e8 70 02 00 00       	call   80094c <printfmt>
  8006dc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006df:	e9 5b 02 00 00       	jmp    80093f <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006e4:	56                   	push   %esi
  8006e5:	68 0e 3b 80 00       	push   $0x803b0e
  8006ea:	ff 75 0c             	pushl  0xc(%ebp)
  8006ed:	ff 75 08             	pushl  0x8(%ebp)
  8006f0:	e8 57 02 00 00       	call   80094c <printfmt>
  8006f5:	83 c4 10             	add    $0x10,%esp
			break;
  8006f8:	e9 42 02 00 00       	jmp    80093f <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	83 c0 04             	add    $0x4,%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
  800706:	8b 45 14             	mov    0x14(%ebp),%eax
  800709:	83 e8 04             	sub    $0x4,%eax
  80070c:	8b 30                	mov    (%eax),%esi
  80070e:	85 f6                	test   %esi,%esi
  800710:	75 05                	jne    800717 <vprintfmt+0x1a6>
				p = "(null)";
  800712:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  800717:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071b:	7e 6d                	jle    80078a <vprintfmt+0x219>
  80071d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800721:	74 67                	je     80078a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800723:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	50                   	push   %eax
  80072a:	56                   	push   %esi
  80072b:	e8 1e 03 00 00       	call   800a4e <strnlen>
  800730:	83 c4 10             	add    $0x10,%esp
  800733:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800736:	eb 16                	jmp    80074e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800738:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80073c:	83 ec 08             	sub    $0x8,%esp
  80073f:	ff 75 0c             	pushl  0xc(%ebp)
  800742:	50                   	push   %eax
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	ff d0                	call   *%eax
  800748:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80074b:	ff 4d e4             	decl   -0x1c(%ebp)
  80074e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800752:	7f e4                	jg     800738 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800754:	eb 34                	jmp    80078a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800756:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80075a:	74 1c                	je     800778 <vprintfmt+0x207>
  80075c:	83 fb 1f             	cmp    $0x1f,%ebx
  80075f:	7e 05                	jle    800766 <vprintfmt+0x1f5>
  800761:	83 fb 7e             	cmp    $0x7e,%ebx
  800764:	7e 12                	jle    800778 <vprintfmt+0x207>
					putch('?', putdat);
  800766:	83 ec 08             	sub    $0x8,%esp
  800769:	ff 75 0c             	pushl  0xc(%ebp)
  80076c:	6a 3f                	push   $0x3f
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	ff d0                	call   *%eax
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	eb 0f                	jmp    800787 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800778:	83 ec 08             	sub    $0x8,%esp
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	53                   	push   %ebx
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	ff d0                	call   *%eax
  800784:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800787:	ff 4d e4             	decl   -0x1c(%ebp)
  80078a:	89 f0                	mov    %esi,%eax
  80078c:	8d 70 01             	lea    0x1(%eax),%esi
  80078f:	8a 00                	mov    (%eax),%al
  800791:	0f be d8             	movsbl %al,%ebx
  800794:	85 db                	test   %ebx,%ebx
  800796:	74 24                	je     8007bc <vprintfmt+0x24b>
  800798:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80079c:	78 b8                	js     800756 <vprintfmt+0x1e5>
  80079e:	ff 4d e0             	decl   -0x20(%ebp)
  8007a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a5:	79 af                	jns    800756 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a7:	eb 13                	jmp    8007bc <vprintfmt+0x24b>
				putch(' ', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 20                	push   $0x20
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8007bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c0:	7f e7                	jg     8007a9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007c2:	e9 78 01 00 00       	jmp    80093f <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c7:	83 ec 08             	sub    $0x8,%esp
  8007ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cd:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d0:	50                   	push   %eax
  8007d1:	e8 3c fd ff ff       	call   800512 <getint>
  8007d6:	83 c4 10             	add    $0x10,%esp
  8007d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e5:	85 d2                	test   %edx,%edx
  8007e7:	79 23                	jns    80080c <vprintfmt+0x29b>
				putch('-', putdat);
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	ff 75 0c             	pushl  0xc(%ebp)
  8007ef:	6a 2d                	push   $0x2d
  8007f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f4:	ff d0                	call   *%eax
  8007f6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ff:	f7 d8                	neg    %eax
  800801:	83 d2 00             	adc    $0x0,%edx
  800804:	f7 da                	neg    %edx
  800806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800809:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80080c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800813:	e9 bc 00 00 00       	jmp    8008d4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800818:	83 ec 08             	sub    $0x8,%esp
  80081b:	ff 75 e8             	pushl  -0x18(%ebp)
  80081e:	8d 45 14             	lea    0x14(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	e8 84 fc ff ff       	call   8004ab <getuint>
  800827:	83 c4 10             	add    $0x10,%esp
  80082a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800830:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800837:	e9 98 00 00 00       	jmp    8008d4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	6a 58                	push   $0x58
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	6a 58                	push   $0x58
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	6a 58                	push   $0x58
  800864:	8b 45 08             	mov    0x8(%ebp),%eax
  800867:	ff d0                	call   *%eax
  800869:	83 c4 10             	add    $0x10,%esp
			break;
  80086c:	e9 ce 00 00 00       	jmp    80093f <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	ff 75 0c             	pushl  0xc(%ebp)
  800877:	6a 30                	push   $0x30
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	ff d0                	call   *%eax
  80087e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800881:	83 ec 08             	sub    $0x8,%esp
  800884:	ff 75 0c             	pushl  0xc(%ebp)
  800887:	6a 78                	push   $0x78
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	ff d0                	call   *%eax
  80088e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008b3:	eb 1f                	jmp    8008d4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008b5:	83 ec 08             	sub    $0x8,%esp
  8008b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8008bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8008be:	50                   	push   %eax
  8008bf:	e8 e7 fb ff ff       	call   8004ab <getuint>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008cd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008d4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008db:	83 ec 04             	sub    $0x4,%esp
  8008de:	52                   	push   %edx
  8008df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008e2:	50                   	push   %eax
  8008e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e6:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e9:	ff 75 0c             	pushl  0xc(%ebp)
  8008ec:	ff 75 08             	pushl  0x8(%ebp)
  8008ef:	e8 00 fb ff ff       	call   8003f4 <printnum>
  8008f4:	83 c4 20             	add    $0x20,%esp
			break;
  8008f7:	eb 46                	jmp    80093f <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	ff 75 0c             	pushl  0xc(%ebp)
  8008ff:	53                   	push   %ebx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	ff d0                	call   *%eax
  800905:	83 c4 10             	add    $0x10,%esp
			break;
  800908:	eb 35                	jmp    80093f <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80090a:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800911:	eb 2c                	jmp    80093f <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800913:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  80091a:	eb 23                	jmp    80093f <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	ff 75 0c             	pushl  0xc(%ebp)
  800922:	6a 25                	push   $0x25
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	ff d0                	call   *%eax
  800929:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092c:	ff 4d 10             	decl   0x10(%ebp)
  80092f:	eb 03                	jmp    800934 <vprintfmt+0x3c3>
  800931:	ff 4d 10             	decl   0x10(%ebp)
  800934:	8b 45 10             	mov    0x10(%ebp),%eax
  800937:	48                   	dec    %eax
  800938:	8a 00                	mov    (%eax),%al
  80093a:	3c 25                	cmp    $0x25,%al
  80093c:	75 f3                	jne    800931 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80093e:	90                   	nop
		}
	}
  80093f:	e9 35 fc ff ff       	jmp    800579 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800944:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800945:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800952:	8d 45 10             	lea    0x10(%ebp),%eax
  800955:	83 c0 04             	add    $0x4,%eax
  800958:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80095b:	8b 45 10             	mov    0x10(%ebp),%eax
  80095e:	ff 75 f4             	pushl  -0xc(%ebp)
  800961:	50                   	push   %eax
  800962:	ff 75 0c             	pushl  0xc(%ebp)
  800965:	ff 75 08             	pushl  0x8(%ebp)
  800968:	e8 04 fc ff ff       	call   800571 <vprintfmt>
  80096d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800970:	90                   	nop
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800976:	8b 45 0c             	mov    0xc(%ebp),%eax
  800979:	8b 40 08             	mov    0x8(%eax),%eax
  80097c:	8d 50 01             	lea    0x1(%eax),%edx
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800985:	8b 45 0c             	mov    0xc(%ebp),%eax
  800988:	8b 10                	mov    (%eax),%edx
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	8b 40 04             	mov    0x4(%eax),%eax
  800990:	39 c2                	cmp    %eax,%edx
  800992:	73 12                	jae    8009a6 <sprintputch+0x33>
		*b->buf++ = ch;
  800994:	8b 45 0c             	mov    0xc(%ebp),%eax
  800997:	8b 00                	mov    (%eax),%eax
  800999:	8d 48 01             	lea    0x1(%eax),%ecx
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099f:	89 0a                	mov    %ecx,(%edx)
  8009a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a4:	88 10                	mov    %dl,(%eax)
}
  8009a6:	90                   	nop
  8009a7:	5d                   	pop    %ebp
  8009a8:	c3                   	ret    

008009a9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a9:	55                   	push   %ebp
  8009aa:	89 e5                	mov    %esp,%ebp
  8009ac:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	01 d0                	add    %edx,%eax
  8009c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009ce:	74 06                	je     8009d6 <vsnprintf+0x2d>
  8009d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d4:	7f 07                	jg     8009dd <vsnprintf+0x34>
		return -E_INVAL;
  8009d6:	b8 03 00 00 00       	mov    $0x3,%eax
  8009db:	eb 20                	jmp    8009fd <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009dd:	ff 75 14             	pushl  0x14(%ebp)
  8009e0:	ff 75 10             	pushl  0x10(%ebp)
  8009e3:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e6:	50                   	push   %eax
  8009e7:	68 73 09 80 00       	push   $0x800973
  8009ec:	e8 80 fb ff ff       	call   800571 <vprintfmt>
  8009f1:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a05:	8d 45 10             	lea    0x10(%ebp),%eax
  800a08:	83 c0 04             	add    $0x4,%eax
  800a0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a11:	ff 75 f4             	pushl  -0xc(%ebp)
  800a14:	50                   	push   %eax
  800a15:	ff 75 0c             	pushl  0xc(%ebp)
  800a18:	ff 75 08             	pushl  0x8(%ebp)
  800a1b:	e8 89 ff ff ff       	call   8009a9 <vsnprintf>
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a29:	c9                   	leave  
  800a2a:	c3                   	ret    

00800a2b <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a2b:	55                   	push   %ebp
  800a2c:	89 e5                	mov    %esp,%ebp
  800a2e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a38:	eb 06                	jmp    800a40 <strlen+0x15>
		n++;
  800a3a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a3d:	ff 45 08             	incl   0x8(%ebp)
  800a40:	8b 45 08             	mov    0x8(%ebp),%eax
  800a43:	8a 00                	mov    (%eax),%al
  800a45:	84 c0                	test   %al,%al
  800a47:	75 f1                	jne    800a3a <strlen+0xf>
		n++;
	return n;
  800a49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4c:	c9                   	leave  
  800a4d:	c3                   	ret    

00800a4e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a54:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5b:	eb 09                	jmp    800a66 <strnlen+0x18>
		n++;
  800a5d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a60:	ff 45 08             	incl   0x8(%ebp)
  800a63:	ff 4d 0c             	decl   0xc(%ebp)
  800a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a6a:	74 09                	je     800a75 <strnlen+0x27>
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e8                	jne    800a5d <strnlen+0xf>
		n++;
	return n;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a86:	90                   	nop
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8d 50 01             	lea    0x1(%eax),%edx
  800a8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a99:	8a 12                	mov    (%edx),%dl
  800a9b:	88 10                	mov    %dl,(%eax)
  800a9d:	8a 00                	mov    (%eax),%al
  800a9f:	84 c0                	test   %al,%al
  800aa1:	75 e4                	jne    800a87 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa6:	c9                   	leave  
  800aa7:	c3                   	ret    

00800aa8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ab4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800abb:	eb 1f                	jmp    800adc <strncpy+0x34>
		*dst++ = *src;
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8d 50 01             	lea    0x1(%eax),%edx
  800ac3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac9:	8a 12                	mov    (%edx),%dl
  800acb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad0:	8a 00                	mov    (%eax),%al
  800ad2:	84 c0                	test   %al,%al
  800ad4:	74 03                	je     800ad9 <strncpy+0x31>
			src++;
  800ad6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ad9:	ff 45 fc             	incl   -0x4(%ebp)
  800adc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800adf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ae2:	72 d9                	jb     800abd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ae4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ae7:	c9                   	leave  
  800ae8:	c3                   	ret    

00800ae9 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ae9:	55                   	push   %ebp
  800aea:	89 e5                	mov    %esp,%ebp
  800aec:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800af5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af9:	74 30                	je     800b2b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800afb:	eb 16                	jmp    800b13 <strlcpy+0x2a>
			*dst++ = *src++;
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	8d 50 01             	lea    0x1(%eax),%edx
  800b03:	89 55 08             	mov    %edx,0x8(%ebp)
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b0c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b0f:	8a 12                	mov    (%edx),%dl
  800b11:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b13:	ff 4d 10             	decl   0x10(%ebp)
  800b16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b1a:	74 09                	je     800b25 <strlcpy+0x3c>
  800b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1f:	8a 00                	mov    (%eax),%al
  800b21:	84 c0                	test   %al,%al
  800b23:	75 d8                	jne    800afd <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b31:	29 c2                	sub    %eax,%edx
  800b33:	89 d0                	mov    %edx,%eax
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b3a:	eb 06                	jmp    800b42 <strcmp+0xb>
		p++, q++;
  800b3c:	ff 45 08             	incl   0x8(%ebp)
  800b3f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	84 c0                	test   %al,%al
  800b49:	74 0e                	je     800b59 <strcmp+0x22>
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8a 10                	mov    (%eax),%dl
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	38 c2                	cmp    %al,%dl
  800b57:	74 e3                	je     800b3c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8a 00                	mov    (%eax),%al
  800b5e:	0f b6 d0             	movzbl %al,%edx
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8a 00                	mov    (%eax),%al
  800b66:	0f b6 c0             	movzbl %al,%eax
  800b69:	29 c2                	sub    %eax,%edx
  800b6b:	89 d0                	mov    %edx,%eax
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b72:	eb 09                	jmp    800b7d <strncmp+0xe>
		n--, p++, q++;
  800b74:	ff 4d 10             	decl   0x10(%ebp)
  800b77:	ff 45 08             	incl   0x8(%ebp)
  800b7a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b7d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b81:	74 17                	je     800b9a <strncmp+0x2b>
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	8a 00                	mov    (%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0e                	je     800b9a <strncmp+0x2b>
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	8a 10                	mov    (%eax),%dl
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	38 c2                	cmp    %al,%dl
  800b98:	74 da                	je     800b74 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b9e:	75 07                	jne    800ba7 <strncmp+0x38>
		return 0;
  800ba0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba5:	eb 14                	jmp    800bbb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8a 00                	mov    (%eax),%al
  800bac:	0f b6 d0             	movzbl %al,%edx
  800baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	0f b6 c0             	movzbl %al,%eax
  800bb7:	29 c2                	sub    %eax,%edx
  800bb9:	89 d0                	mov    %edx,%eax
}
  800bbb:	5d                   	pop    %ebp
  800bbc:	c3                   	ret    

00800bbd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 04             	sub    $0x4,%esp
  800bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bc9:	eb 12                	jmp    800bdd <strchr+0x20>
		if (*s == c)
  800bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bce:	8a 00                	mov    (%eax),%al
  800bd0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd3:	75 05                	jne    800bda <strchr+0x1d>
			return (char *) s;
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	eb 11                	jmp    800beb <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bda:	ff 45 08             	incl   0x8(%ebp)
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	84 c0                	test   %al,%al
  800be4:	75 e5                	jne    800bcb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800be6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 04             	sub    $0x4,%esp
  800bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bf9:	eb 0d                	jmp    800c08 <strfind+0x1b>
		if (*s == c)
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c03:	74 0e                	je     800c13 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 ea                	jne    800bfb <strfind+0xe>
  800c11:	eb 01                	jmp    800c14 <strfind+0x27>
		if (*s == c)
			break;
  800c13:	90                   	nop
	return (char *) s;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c17:	c9                   	leave  
  800c18:	c3                   	ret    

00800c19 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c25:	8b 45 10             	mov    0x10(%ebp),%eax
  800c28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c2b:	eb 0e                	jmp    800c3b <memset+0x22>
		*p++ = c;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c30:	8d 50 01             	lea    0x1(%eax),%edx
  800c33:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c36:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c39:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c3b:	ff 4d f8             	decl   -0x8(%ebp)
  800c3e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c42:	79 e9                	jns    800c2d <memset+0x14>
		*p++ = c;

	return v;
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c47:	c9                   	leave  
  800c48:	c3                   	ret    

00800c49 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c5b:	eb 16                	jmp    800c73 <memcpy+0x2a>
		*d++ = *s++;
  800c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c60:	8d 50 01             	lea    0x1(%eax),%edx
  800c63:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c66:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c69:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c6f:	8a 12                	mov    (%edx),%dl
  800c71:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	85 c0                	test   %eax,%eax
  800c7e:	75 dd                	jne    800c5d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c83:	c9                   	leave  
  800c84:	c3                   	ret    

00800c85 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c9d:	73 50                	jae    800cef <memmove+0x6a>
  800c9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ca2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca5:	01 d0                	add    %edx,%eax
  800ca7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800caa:	76 43                	jbe    800cef <memmove+0x6a>
		s += n;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cb8:	eb 10                	jmp    800cca <memmove+0x45>
			*--d = *--s;
  800cba:	ff 4d f8             	decl   -0x8(%ebp)
  800cbd:	ff 4d fc             	decl   -0x4(%ebp)
  800cc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc3:	8a 10                	mov    (%eax),%dl
  800cc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cca:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cd0:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	75 e3                	jne    800cba <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cd7:	eb 23                	jmp    800cfc <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ce2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf5:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	75 dd                	jne    800cd9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cff:	c9                   	leave  
  800d00:	c3                   	ret    

00800d01 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d01:	55                   	push   %ebp
  800d02:	89 e5                	mov    %esp,%ebp
  800d04:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d13:	eb 2a                	jmp    800d3f <memcmp+0x3e>
		if (*s1 != *s2)
  800d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d18:	8a 10                	mov    (%eax),%dl
  800d1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	38 c2                	cmp    %al,%dl
  800d21:	74 16                	je     800d39 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
  800d37:	eb 18                	jmp    800d51 <memcmp+0x50>
		s1++, s2++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
  800d3c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d45:	89 55 10             	mov    %edx,0x10(%ebp)
  800d48:	85 c0                	test   %eax,%eax
  800d4a:	75 c9                	jne    800d15 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5f:	01 d0                	add    %edx,%eax
  800d61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d64:	eb 15                	jmp    800d7b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	0f b6 d0             	movzbl %al,%edx
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	39 c2                	cmp    %eax,%edx
  800d76:	74 0d                	je     800d85 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d78:	ff 45 08             	incl   0x8(%ebp)
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d81:	72 e3                	jb     800d66 <memfind+0x13>
  800d83:	eb 01                	jmp    800d86 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d85:	90                   	nop
	return (void *) s;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d89:	c9                   	leave  
  800d8a:	c3                   	ret    

00800d8b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d91:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d98:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d9f:	eb 03                	jmp    800da4 <strtol+0x19>
		s++;
  800da1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3c 20                	cmp    $0x20,%al
  800dab:	74 f4                	je     800da1 <strtol+0x16>
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	8a 00                	mov    (%eax),%al
  800db2:	3c 09                	cmp    $0x9,%al
  800db4:	74 eb                	je     800da1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 2b                	cmp    $0x2b,%al
  800dbd:	75 05                	jne    800dc4 <strtol+0x39>
		s++;
  800dbf:	ff 45 08             	incl   0x8(%ebp)
  800dc2:	eb 13                	jmp    800dd7 <strtol+0x4c>
	else if (*s == '-')
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	3c 2d                	cmp    $0x2d,%al
  800dcb:	75 0a                	jne    800dd7 <strtol+0x4c>
		s++, neg = 1;
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddb:	74 06                	je     800de3 <strtol+0x58>
  800ddd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800de1:	75 20                	jne    800e03 <strtol+0x78>
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	8a 00                	mov    (%eax),%al
  800de8:	3c 30                	cmp    $0x30,%al
  800dea:	75 17                	jne    800e03 <strtol+0x78>
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	40                   	inc    %eax
  800df0:	8a 00                	mov    (%eax),%al
  800df2:	3c 78                	cmp    $0x78,%al
  800df4:	75 0d                	jne    800e03 <strtol+0x78>
		s += 2, base = 16;
  800df6:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dfa:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e01:	eb 28                	jmp    800e2b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e07:	75 15                	jne    800e1e <strtol+0x93>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	3c 30                	cmp    $0x30,%al
  800e10:	75 0c                	jne    800e1e <strtol+0x93>
		s++, base = 8;
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e1c:	eb 0d                	jmp    800e2b <strtol+0xa0>
	else if (base == 0)
  800e1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e22:	75 07                	jne    800e2b <strtol+0xa0>
		base = 10;
  800e24:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	3c 2f                	cmp    $0x2f,%al
  800e32:	7e 19                	jle    800e4d <strtol+0xc2>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 00                	mov    (%eax),%al
  800e39:	3c 39                	cmp    $0x39,%al
  800e3b:	7f 10                	jg     800e4d <strtol+0xc2>
			dig = *s - '0';
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	0f be c0             	movsbl %al,%eax
  800e45:	83 e8 30             	sub    $0x30,%eax
  800e48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e4b:	eb 42                	jmp    800e8f <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	3c 60                	cmp    $0x60,%al
  800e54:	7e 19                	jle    800e6f <strtol+0xe4>
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	3c 7a                	cmp    $0x7a,%al
  800e5d:	7f 10                	jg     800e6f <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	0f be c0             	movsbl %al,%eax
  800e67:	83 e8 57             	sub    $0x57,%eax
  800e6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e6d:	eb 20                	jmp    800e8f <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8a 00                	mov    (%eax),%al
  800e74:	3c 40                	cmp    $0x40,%al
  800e76:	7e 39                	jle    800eb1 <strtol+0x126>
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	3c 5a                	cmp    $0x5a,%al
  800e7f:	7f 30                	jg     800eb1 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f be c0             	movsbl %al,%eax
  800e89:	83 e8 37             	sub    $0x37,%eax
  800e8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e92:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e95:	7d 19                	jge    800eb0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e97:	ff 45 08             	incl   0x8(%ebp)
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ea1:	89 c2                	mov    %eax,%edx
  800ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea6:	01 d0                	add    %edx,%eax
  800ea8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800eab:	e9 7b ff ff ff       	jmp    800e2b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800eb0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb5:	74 08                	je     800ebf <strtol+0x134>
		*endptr = (char *) s;
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ebf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ec3:	74 07                	je     800ecc <strtol+0x141>
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec8:	f7 d8                	neg    %eax
  800eca:	eb 03                	jmp    800ecf <strtol+0x144>
  800ecc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <ltostr>:

void
ltostr(long value, char *str)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ed7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800ede:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ee5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ee9:	79 13                	jns    800efe <ltostr+0x2d>
	{
		neg = 1;
  800eeb:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ef8:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800efb:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f06:	99                   	cltd   
  800f07:	f7 f9                	idiv   %ecx
  800f09:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	8d 50 01             	lea    0x1(%eax),%edx
  800f12:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f15:	89 c2                	mov    %eax,%edx
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f1f:	83 c2 30             	add    $0x30,%edx
  800f22:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f27:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f2c:	f7 e9                	imul   %ecx
  800f2e:	c1 fa 02             	sar    $0x2,%edx
  800f31:	89 c8                	mov    %ecx,%eax
  800f33:	c1 f8 1f             	sar    $0x1f,%eax
  800f36:	29 c2                	sub    %eax,%edx
  800f38:	89 d0                	mov    %edx,%eax
  800f3a:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f41:	75 bb                	jne    800efe <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4d:	48                   	dec    %eax
  800f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f55:	74 3d                	je     800f94 <ltostr+0xc3>
		start = 1 ;
  800f57:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f5e:	eb 34                	jmp    800f94 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	01 d0                	add    %edx,%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f73:	01 c2                	add    %eax,%edx
  800f75:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7b:	01 c8                	add    %ecx,%eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	01 c2                	add    %eax,%edx
  800f89:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f8c:	88 02                	mov    %al,(%edx)
		start++ ;
  800f8e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f91:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f97:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f9a:	7c c4                	jl     800f60 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	01 d0                	add    %edx,%eax
  800fa4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fa7:	90                   	nop
  800fa8:	c9                   	leave  
  800fa9:	c3                   	ret    

00800faa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fb0:	ff 75 08             	pushl  0x8(%ebp)
  800fb3:	e8 73 fa ff ff       	call   800a2b <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fbe:	ff 75 0c             	pushl  0xc(%ebp)
  800fc1:	e8 65 fa ff ff       	call   800a2b <strlen>
  800fc6:	83 c4 04             	add    $0x4,%esp
  800fc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fd3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fda:	eb 17                	jmp    800ff3 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fdc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe2:	01 c2                	add    %eax,%edx
  800fe4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	01 c8                	add    %ecx,%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ff0:	ff 45 fc             	incl   -0x4(%ebp)
  800ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff9:	7c e1                	jl     800fdc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ffb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801002:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801009:	eb 1f                	jmp    80102a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80100b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100e:	8d 50 01             	lea    0x1(%eax),%edx
  801011:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801014:	89 c2                	mov    %eax,%edx
  801016:	8b 45 10             	mov    0x10(%ebp),%eax
  801019:	01 c2                	add    %eax,%edx
  80101b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80101e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801021:	01 c8                	add    %ecx,%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801027:	ff 45 f8             	incl   -0x8(%ebp)
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801030:	7c d9                	jl     80100b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801032:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801035:	8b 45 10             	mov    0x10(%ebp),%eax
  801038:	01 d0                	add    %edx,%eax
  80103a:	c6 00 00             	movb   $0x0,(%eax)
}
  80103d:	90                   	nop
  80103e:	c9                   	leave  
  80103f:	c3                   	ret    

00801040 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801043:	8b 45 14             	mov    0x14(%ebp),%eax
  801046:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80104c:	8b 45 14             	mov    0x14(%ebp),%eax
  80104f:	8b 00                	mov    (%eax),%eax
  801051:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801058:	8b 45 10             	mov    0x10(%ebp),%eax
  80105b:	01 d0                	add    %edx,%eax
  80105d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	eb 0c                	jmp    801071 <strsplit+0x31>
			*string++ = 0;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8d 50 01             	lea    0x1(%eax),%edx
  80106b:	89 55 08             	mov    %edx,0x8(%ebp)
  80106e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801071:	8b 45 08             	mov    0x8(%ebp),%eax
  801074:	8a 00                	mov    (%eax),%al
  801076:	84 c0                	test   %al,%al
  801078:	74 18                	je     801092 <strsplit+0x52>
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	0f be c0             	movsbl %al,%eax
  801082:	50                   	push   %eax
  801083:	ff 75 0c             	pushl  0xc(%ebp)
  801086:	e8 32 fb ff ff       	call   800bbd <strchr>
  80108b:	83 c4 08             	add    $0x8,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	75 d3                	jne    801065 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	84 c0                	test   %al,%al
  801099:	74 5a                	je     8010f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80109b:	8b 45 14             	mov    0x14(%ebp),%eax
  80109e:	8b 00                	mov    (%eax),%eax
  8010a0:	83 f8 0f             	cmp    $0xf,%eax
  8010a3:	75 07                	jne    8010ac <strsplit+0x6c>
		{
			return 0;
  8010a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010aa:	eb 66                	jmp    801112 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8010af:	8b 00                	mov    (%eax),%eax
  8010b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8010b7:	89 0a                	mov    %ecx,(%edx)
  8010b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c3:	01 c2                	add    %eax,%edx
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010ca:	eb 03                	jmp    8010cf <strsplit+0x8f>
			string++;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	84 c0                	test   %al,%al
  8010d6:	74 8b                	je     801063 <strsplit+0x23>
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	50                   	push   %eax
  8010e1:	ff 75 0c             	pushl  0xc(%ebp)
  8010e4:	e8 d4 fa ff ff       	call   800bbd <strchr>
  8010e9:	83 c4 08             	add    $0x8,%esp
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	74 dc                	je     8010cc <strsplit+0x8c>
			string++;
	}
  8010f0:	e9 6e ff ff ff       	jmp    801063 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f9:	8b 00                	mov    (%eax),%eax
  8010fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801102:	8b 45 10             	mov    0x10(%ebp),%eax
  801105:	01 d0                	add    %edx,%eax
  801107:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80110d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80111a:	83 ec 04             	sub    $0x4,%esp
  80111d:	68 88 3c 80 00       	push   $0x803c88
  801122:	68 3f 01 00 00       	push   $0x13f
  801127:	68 aa 3c 80 00       	push   $0x803caa
  80112c:	e8 4e 22 00 00       	call   80337f <_panic>

00801131 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801131:	55                   	push   %ebp
  801132:	89 e5                	mov    %esp,%ebp
  801134:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 08             	pushl  0x8(%ebp)
  80113d:	e8 90 0c 00 00       	call   801dd2 <sys_sbrk>
  801142:	83 c4 10             	add    $0x10,%esp
}
  801145:	c9                   	leave  
  801146:	c3                   	ret    

00801147 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80114d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801151:	75 0a                	jne    80115d <malloc+0x16>
		return NULL;
  801153:	b8 00 00 00 00       	mov    $0x0,%eax
  801158:	e9 9e 01 00 00       	jmp    8012fb <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80115d:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801164:	77 2c                	ja     801192 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801166:	e8 eb 0a 00 00       	call   801c56 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80116b:	85 c0                	test   %eax,%eax
  80116d:	74 19                	je     801188 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80116f:	83 ec 0c             	sub    $0xc,%esp
  801172:	ff 75 08             	pushl  0x8(%ebp)
  801175:	e8 85 11 00 00       	call   8022ff <alloc_block_FF>
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801180:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801183:	e9 73 01 00 00       	jmp    8012fb <malloc+0x1b4>
		} else {
			return NULL;
  801188:	b8 00 00 00 00       	mov    $0x0,%eax
  80118d:	e9 69 01 00 00       	jmp    8012fb <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801192:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801199:	8b 55 08             	mov    0x8(%ebp),%edx
  80119c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80119f:	01 d0                	add    %edx,%eax
  8011a1:	48                   	dec    %eax
  8011a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ad:	f7 75 e0             	divl   -0x20(%ebp)
  8011b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b3:	29 d0                	sub    %edx,%eax
  8011b5:	c1 e8 0c             	shr    $0xc,%eax
  8011b8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8011bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8011c2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8011c9:	a1 20 50 80 00       	mov    0x805020,%eax
  8011ce:	8b 40 7c             	mov    0x7c(%eax),%eax
  8011d1:	05 00 10 00 00       	add    $0x1000,%eax
  8011d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8011d9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8011de:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8011e1:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8011e4:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8011eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	48                   	dec    %eax
  8011f4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8011f7:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8011fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ff:	f7 75 cc             	divl   -0x34(%ebp)
  801202:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801205:	29 d0                	sub    %edx,%eax
  801207:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80120a:	76 0a                	jbe    801216 <malloc+0xcf>
		return NULL;
  80120c:	b8 00 00 00 00       	mov    $0x0,%eax
  801211:	e9 e5 00 00 00       	jmp    8012fb <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801216:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801219:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80121c:	eb 48                	jmp    801266 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80121e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801221:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801224:	c1 e8 0c             	shr    $0xc,%eax
  801227:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  80122a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80122d:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801234:	85 c0                	test   %eax,%eax
  801236:	75 11                	jne    801249 <malloc+0x102>
			freePagesCount++;
  801238:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80123b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80123f:	75 16                	jne    801257 <malloc+0x110>
				start = i;
  801241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801244:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801247:	eb 0e                	jmp    801257 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801249:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801250:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80125d:	74 12                	je     801271 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80125f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801266:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80126d:	76 af                	jbe    80121e <malloc+0xd7>
  80126f:	eb 01                	jmp    801272 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801271:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801272:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801276:	74 08                	je     801280 <malloc+0x139>
  801278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80127e:	74 07                	je     801287 <malloc+0x140>
		return NULL;
  801280:	b8 00 00 00 00       	mov    $0x0,%eax
  801285:	eb 74                	jmp    8012fb <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128a:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80128d:	c1 e8 0c             	shr    $0xc,%eax
  801290:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801293:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801296:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801299:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8012a0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8012a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8012a6:	eb 11                	jmp    8012b9 <malloc+0x172>
		markedPages[i] = 1;
  8012a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012ab:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8012b2:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8012b6:	ff 45 e8             	incl   -0x18(%ebp)
  8012b9:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8012bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012c4:	77 e2                	ja     8012a8 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8012c6:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8012cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8012d3:	01 d0                	add    %edx,%eax
  8012d5:	48                   	dec    %eax
  8012d6:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8012d9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8012dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e1:	f7 75 bc             	divl   -0x44(%ebp)
  8012e4:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8012e7:	29 d0                	sub    %edx,%eax
  8012e9:	83 ec 08             	sub    $0x8,%esp
  8012ec:	50                   	push   %eax
  8012ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f0:	e8 14 0b 00 00       	call   801e09 <sys_allocate_user_mem>
  8012f5:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8012f8:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8012fb:	c9                   	leave  
  8012fc:	c3                   	ret    

008012fd <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801303:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801307:	0f 84 ee 00 00 00    	je     8013fb <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80130d:	a1 20 50 80 00       	mov    0x805020,%eax
  801312:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801315:	3b 45 08             	cmp    0x8(%ebp),%eax
  801318:	77 09                	ja     801323 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80131a:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801321:	76 14                	jbe    801337 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801323:	83 ec 04             	sub    $0x4,%esp
  801326:	68 b8 3c 80 00       	push   $0x803cb8
  80132b:	6a 68                	push   $0x68
  80132d:	68 d2 3c 80 00       	push   $0x803cd2
  801332:	e8 48 20 00 00       	call   80337f <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801337:	a1 20 50 80 00       	mov    0x805020,%eax
  80133c:	8b 40 74             	mov    0x74(%eax),%eax
  80133f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801342:	77 20                	ja     801364 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801344:	a1 20 50 80 00       	mov    0x805020,%eax
  801349:	8b 40 78             	mov    0x78(%eax),%eax
  80134c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80134f:	76 13                	jbe    801364 <free+0x67>
		free_block(virtual_address);
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	ff 75 08             	pushl  0x8(%ebp)
  801357:	e8 6c 16 00 00       	call   8029c8 <free_block>
  80135c:	83 c4 10             	add    $0x10,%esp
		return;
  80135f:	e9 98 00 00 00       	jmp    8013fc <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801364:	8b 55 08             	mov    0x8(%ebp),%edx
  801367:	a1 20 50 80 00       	mov    0x805020,%eax
  80136c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80136f:	29 c2                	sub    %eax,%edx
  801371:	89 d0                	mov    %edx,%eax
  801373:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801378:	c1 e8 0c             	shr    $0xc,%eax
  80137b:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80137e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801385:	eb 16                	jmp    80139d <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801387:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138d:	01 d0                	add    %edx,%eax
  80138f:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801396:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80139a:	ff 45 f4             	incl   -0xc(%ebp)
  80139d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a0:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8013a7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013aa:	7f db                	jg     801387 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8013ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013af:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8013b6:	c1 e0 0c             	shl    $0xc,%eax
  8013b9:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c2:	eb 1a                	jmp    8013de <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8013c4:	83 ec 08             	sub    $0x8,%esp
  8013c7:	68 00 10 00 00       	push   $0x1000
  8013cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8013cf:	e8 19 0a 00 00       	call   801ded <sys_free_user_mem>
  8013d4:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8013d7:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8013de:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e4:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8013e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e9:	77 d9                	ja     8013c4 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8013eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ee:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8013f5:	00 00 00 00 
  8013f9:	eb 01                	jmp    8013fc <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8013fb:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	83 ec 58             	sub    $0x58,%esp
  801404:	8b 45 10             	mov    0x10(%ebp),%eax
  801407:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80140a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140e:	75 0a                	jne    80141a <smalloc+0x1c>
		return NULL;
  801410:	b8 00 00 00 00       	mov    $0x0,%eax
  801415:	e9 7d 01 00 00       	jmp    801597 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  80141a:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801421:	8b 55 0c             	mov    0xc(%ebp),%edx
  801424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801427:	01 d0                	add    %edx,%eax
  801429:	48                   	dec    %eax
  80142a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80142d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801430:	ba 00 00 00 00       	mov    $0x0,%edx
  801435:	f7 75 e4             	divl   -0x1c(%ebp)
  801438:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143b:	29 d0                	sub    %edx,%eax
  80143d:	c1 e8 0c             	shr    $0xc,%eax
  801440:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801443:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  80144a:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801451:	a1 20 50 80 00       	mov    0x805020,%eax
  801456:	8b 40 7c             	mov    0x7c(%eax),%eax
  801459:	05 00 10 00 00       	add    $0x1000,%eax
  80145e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801461:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801466:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801469:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80146c:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801473:	8b 55 0c             	mov    0xc(%ebp),%edx
  801476:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	48                   	dec    %eax
  80147c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80147f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801482:	ba 00 00 00 00       	mov    $0x0,%edx
  801487:	f7 75 d0             	divl   -0x30(%ebp)
  80148a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80148d:	29 d0                	sub    %edx,%eax
  80148f:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801492:	76 0a                	jbe    80149e <smalloc+0xa0>
		return NULL;
  801494:	b8 00 00 00 00       	mov    $0x0,%eax
  801499:	e9 f9 00 00 00       	jmp    801597 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80149e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014a4:	eb 48                	jmp    8014ee <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8014a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a9:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8014ac:	c1 e8 0c             	shr    $0xc,%eax
  8014af:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  8014b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014b5:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	75 11                	jne    8014d1 <smalloc+0xd3>
			freePagesCount++;
  8014c0:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8014c3:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014c7:	75 16                	jne    8014df <smalloc+0xe1>
				start = s;
  8014c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014cf:	eb 0e                	jmp    8014df <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8014d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8014d8:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8014df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8014e5:	74 12                	je     8014f9 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8014e7:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8014ee:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8014f5:	76 af                	jbe    8014a6 <smalloc+0xa8>
  8014f7:	eb 01                	jmp    8014fa <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8014f9:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8014fa:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014fe:	74 08                	je     801508 <smalloc+0x10a>
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801506:	74 0a                	je     801512 <smalloc+0x114>
		return NULL;
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
  80150d:	e9 85 00 00 00       	jmp    801597 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801518:	c1 e8 0c             	shr    $0xc,%eax
  80151b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80151e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801521:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801524:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80152b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80152e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801531:	eb 11                	jmp    801544 <smalloc+0x146>
		markedPages[s] = 1;
  801533:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801536:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80153d:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801541:	ff 45 e8             	incl   -0x18(%ebp)
  801544:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80154a:	01 d0                	add    %edx,%eax
  80154c:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80154f:	77 e2                	ja     801533 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801551:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801554:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801558:	52                   	push   %edx
  801559:	50                   	push   %eax
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	ff 75 08             	pushl  0x8(%ebp)
  801560:	e8 8f 04 00 00       	call   8019f4 <sys_createSharedObject>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  80156b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80156f:	78 12                	js     801583 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801571:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801574:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801577:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  80157e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801581:	eb 14                	jmp    801597 <smalloc+0x199>
	}
	free((void*) start);
  801583:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801586:	83 ec 0c             	sub    $0xc,%esp
  801589:	50                   	push   %eax
  80158a:	e8 6e fd ff ff       	call   8012fd <free>
  80158f:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801592:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801597:	c9                   	leave  
  801598:	c3                   	ret    

00801599 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80159f:	83 ec 08             	sub    $0x8,%esp
  8015a2:	ff 75 0c             	pushl  0xc(%ebp)
  8015a5:	ff 75 08             	pushl  0x8(%ebp)
  8015a8:	e8 71 04 00 00       	call   801a1e <sys_getSizeOfSharedObject>
  8015ad:	83 c4 10             	add    $0x10,%esp
  8015b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8015b3:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8015ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	48                   	dec    %eax
  8015c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8015c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ce:	f7 75 e0             	divl   -0x20(%ebp)
  8015d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015d4:	29 d0                	sub    %edx,%eax
  8015d6:	c1 e8 0c             	shr    $0xc,%eax
  8015d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  8015dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8015e3:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8015ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8015ef:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015f2:	05 00 10 00 00       	add    $0x1000,%eax
  8015f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8015fa:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8015ff:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801602:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801605:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80160c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801612:	01 d0                	add    %edx,%eax
  801614:	48                   	dec    %eax
  801615:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801618:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80161b:	ba 00 00 00 00       	mov    $0x0,%edx
  801620:	f7 75 cc             	divl   -0x34(%ebp)
  801623:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801626:	29 d0                	sub    %edx,%eax
  801628:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80162b:	76 0a                	jbe    801637 <sget+0x9e>
		return NULL;
  80162d:	b8 00 00 00 00       	mov    $0x0,%eax
  801632:	e9 f7 00 00 00       	jmp    80172e <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801637:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80163a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80163d:	eb 48                	jmp    801687 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80163f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801642:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801645:	c1 e8 0c             	shr    $0xc,%eax
  801648:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  80164b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80164e:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801655:	85 c0                	test   %eax,%eax
  801657:	75 11                	jne    80166a <sget+0xd1>
			free_Pages_Count++;
  801659:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80165c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801660:	75 16                	jne    801678 <sget+0xdf>
				start = s;
  801662:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801665:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801668:	eb 0e                	jmp    801678 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  80166a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801671:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80167e:	74 12                	je     801692 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801680:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801687:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80168e:	76 af                	jbe    80163f <sget+0xa6>
  801690:	eb 01                	jmp    801693 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801692:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801693:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801697:	74 08                	je     8016a1 <sget+0x108>
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80169f:	74 0a                	je     8016ab <sget+0x112>
		return NULL;
  8016a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a6:	e9 83 00 00 00       	jmp    80172e <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ae:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8016b1:	c1 e8 0c             	shr    $0xc,%eax
  8016b4:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  8016b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016ba:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016bd:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8016c4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016ca:	eb 11                	jmp    8016dd <sget+0x144>
		markedPages[k] = 1;
  8016cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016cf:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8016d6:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8016da:	ff 45 e8             	incl   -0x18(%ebp)
  8016dd:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8016e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e3:	01 d0                	add    %edx,%eax
  8016e5:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016e8:	77 e2                	ja     8016cc <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8016ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	50                   	push   %eax
  8016f1:	ff 75 0c             	pushl  0xc(%ebp)
  8016f4:	ff 75 08             	pushl  0x8(%ebp)
  8016f7:	e8 3f 03 00 00       	call   801a3b <sys_getSharedObject>
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801702:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801706:	78 12                	js     80171a <sget+0x181>
		shardIDs[startPage] = ss;
  801708:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80170b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80170e:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	eb 14                	jmp    80172e <sget+0x195>
	}
	free((void*) start);
  80171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171d:	83 ec 0c             	sub    $0xc,%esp
  801720:	50                   	push   %eax
  801721:	e8 d7 fb ff ff       	call   8012fd <free>
  801726:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801736:	8b 55 08             	mov    0x8(%ebp),%edx
  801739:	a1 20 50 80 00       	mov    0x805020,%eax
  80173e:	8b 40 7c             	mov    0x7c(%eax),%eax
  801741:	29 c2                	sub    %eax,%edx
  801743:	89 d0                	mov    %edx,%eax
  801745:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  80174a:	c1 e8 0c             	shr    $0xc,%eax
  80174d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  801750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801753:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  80175a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	ff 75 08             	pushl  0x8(%ebp)
  801763:	ff 75 f0             	pushl  -0x10(%ebp)
  801766:	e8 ef 02 00 00       	call   801a5a <sys_freeSharedObject>
  80176b:	83 c4 10             	add    $0x10,%esp
  80176e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801771:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801775:	75 0e                	jne    801785 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177a:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801781:	ff ff ff ff 
	}

}
  801785:	90                   	nop
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 e0 3c 80 00       	push   $0x803ce0
  801796:	68 19 01 00 00       	push   $0x119
  80179b:	68 d2 3c 80 00       	push   $0x803cd2
  8017a0:	e8 da 1b 00 00       	call   80337f <_panic>

008017a5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 06 3d 80 00       	push   $0x803d06
  8017b3:	68 23 01 00 00       	push   $0x123
  8017b8:	68 d2 3c 80 00       	push   $0x803cd2
  8017bd:	e8 bd 1b 00 00       	call   80337f <_panic>

008017c2 <shrink>:

}
void shrink(uint32 newSize) {
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	68 06 3d 80 00       	push   $0x803d06
  8017d0:	68 27 01 00 00       	push   $0x127
  8017d5:	68 d2 3c 80 00       	push   $0x803cd2
  8017da:	e8 a0 1b 00 00       	call   80337f <_panic>

008017df <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e5:	83 ec 04             	sub    $0x4,%esp
  8017e8:	68 06 3d 80 00       	push   $0x803d06
  8017ed:	68 2b 01 00 00       	push   $0x12b
  8017f2:	68 d2 3c 80 00       	push   $0x803cd2
  8017f7:	e8 83 1b 00 00       	call   80337f <_panic>

008017fc <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	57                   	push   %edi
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801805:	8b 45 08             	mov    0x8(%ebp),%eax
  801808:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801811:	8b 7d 18             	mov    0x18(%ebp),%edi
  801814:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801817:	cd 30                	int    $0x30
  801819:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	5b                   	pop    %ebx
  801823:	5e                   	pop    %esi
  801824:	5f                   	pop    %edi
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    

00801827 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 04             	sub    $0x4,%esp
  80182d:	8b 45 10             	mov    0x10(%ebp),%eax
  801830:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801833:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	52                   	push   %edx
  80183f:	ff 75 0c             	pushl  0xc(%ebp)
  801842:	50                   	push   %eax
  801843:	6a 00                	push   $0x0
  801845:	e8 b2 ff ff ff       	call   8017fc <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	90                   	nop
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <sys_cgetc>:

int sys_cgetc(void) {
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 02                	push   $0x2
  80185f:	e8 98 ff ff ff       	call   8017fc <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <sys_lock_cons>:

void sys_lock_cons(void) {
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 03                	push   $0x3
  801878:	e8 7f ff ff ff       	call   8017fc <syscall>
  80187d:	83 c4 18             	add    $0x18,%esp
}
  801880:	90                   	nop
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 04                	push   $0x4
  801892:	e8 65 ff ff ff       	call   8017fc <syscall>
  801897:	83 c4 18             	add    $0x18,%esp
}
  80189a:	90                   	nop
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8018a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	52                   	push   %edx
  8018ad:	50                   	push   %eax
  8018ae:	6a 08                	push   $0x8
  8018b0:	e8 47 ff ff ff       	call   8017fc <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	56                   	push   %esi
  8018be:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8018bf:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	56                   	push   %esi
  8018cf:	53                   	push   %ebx
  8018d0:	51                   	push   %ecx
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	6a 09                	push   $0x9
  8018d5:	e8 22 ff ff ff       	call   8017fc <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8018dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5e                   	pop    %esi
  8018e2:	5d                   	pop    %ebp
  8018e3:	c3                   	ret    

008018e4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	52                   	push   %edx
  8018f4:	50                   	push   %eax
  8018f5:	6a 0a                	push   $0xa
  8018f7:	e8 00 ff ff ff       	call   8017fc <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	ff 75 0c             	pushl  0xc(%ebp)
  80190d:	ff 75 08             	pushl  0x8(%ebp)
  801910:	6a 0b                	push   $0xb
  801912:	e8 e5 fe ff ff       	call   8017fc <syscall>
  801917:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  80191a:	c9                   	leave  
  80191b:	c3                   	ret    

0080191c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 0c                	push   $0xc
  80192b:	e8 cc fe ff ff       	call   8017fc <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 0d                	push   $0xd
  801944:	e8 b3 fe ff ff       	call   8017fc <syscall>
  801949:	83 c4 18             	add    $0x18,%esp
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 0e                	push   $0xe
  80195d:	e8 9a fe ff ff       	call   8017fc <syscall>
  801962:	83 c4 18             	add    $0x18,%esp
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 0f                	push   $0xf
  801976:	e8 81 fe ff ff       	call   8017fc <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 10                	push   $0x10
  801990:	e8 67 fe ff ff       	call   8017fc <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_scarce_memory>:

void sys_scarce_memory() {
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 11                	push   $0x11
  8019a9:	e8 4e fe ff ff       	call   8017fc <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_cputc>:

void sys_cputc(const char c) {
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 04             	sub    $0x4,%esp
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	50                   	push   %eax
  8019cd:	6a 01                	push   $0x1
  8019cf:	e8 28 fe ff ff       	call   8017fc <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	90                   	nop
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 14                	push   $0x14
  8019e9:	e8 0e fe ff ff       	call   8017fc <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	90                   	nop
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 04             	sub    $0x4,%esp
  8019fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801a00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	51                   	push   %ecx
  801a0d:	52                   	push   %edx
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	50                   	push   %eax
  801a12:	6a 15                	push   $0x15
  801a14:	e8 e3 fd ff ff       	call   8017fc <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a24:	8b 45 08             	mov    0x8(%ebp),%eax
  801a27:	6a 00                	push   $0x0
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	52                   	push   %edx
  801a2e:	50                   	push   %eax
  801a2f:	6a 16                	push   $0x16
  801a31:	e8 c6 fd ff ff       	call   8017fc <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801a3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	51                   	push   %ecx
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 17                	push   $0x17
  801a50:	e8 a7 fd ff ff       	call   8017fc <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 18                	push   $0x18
  801a6d:	e8 8a fd ff ff       	call   8017fc <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	ff 75 14             	pushl  0x14(%ebp)
  801a82:	ff 75 10             	pushl  0x10(%ebp)
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	6a 19                	push   $0x19
  801a8b:	e8 6c fd ff ff       	call   8017fc <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_run_env>:

void sys_run_env(int32 envId) {
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801a98:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	50                   	push   %eax
  801aa4:	6a 1a                	push   $0x1a
  801aa6:	e8 51 fd ff ff       	call   8017fc <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	90                   	nop
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	50                   	push   %eax
  801ac0:	6a 1b                	push   $0x1b
  801ac2:	e8 35 fd ff ff       	call   8017fc <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_getenvid>:

int32 sys_getenvid(void) {
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 05                	push   $0x5
  801adb:	e8 1c fd ff ff       	call   8017fc <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 06                	push   $0x6
  801af4:	e8 03 fd ff ff       	call   8017fc <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 07                	push   $0x7
  801b0d:	e8 ea fc ff ff       	call   8017fc <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_exit_env>:

void sys_exit_env(void) {
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 1c                	push   $0x1c
  801b26:	e8 d1 fc ff ff       	call   8017fc <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801b37:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3a:	8d 50 04             	lea    0x4(%eax),%edx
  801b3d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	52                   	push   %edx
  801b47:	50                   	push   %eax
  801b48:	6a 1d                	push   $0x1d
  801b4a:	e8 ad fc ff ff       	call   8017fc <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801b52:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b58:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5b:	89 01                	mov    %eax,(%ecx)
  801b5d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	c9                   	leave  
  801b64:	c2 04 00             	ret    $0x4

00801b67 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	ff 75 10             	pushl  0x10(%ebp)
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	6a 13                	push   $0x13
  801b79:	e8 7e fc ff ff       	call   8017fc <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801b81:	90                   	nop
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_rcr2>:
uint32 sys_rcr2() {
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 1e                	push   $0x1e
  801b93:	e8 64 fc ff ff       	call   8017fc <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	50                   	push   %eax
  801bb6:	6a 1f                	push   $0x1f
  801bb8:	e8 3f fc ff ff       	call   8017fc <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
	return;
  801bc0:	90                   	nop
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <rsttst>:
void rsttst() {
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 21                	push   $0x21
  801bd2:	e8 25 fc ff ff       	call   8017fc <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return;
  801bda:	90                   	nop
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	83 ec 04             	sub    $0x4,%esp
  801be3:	8b 45 14             	mov    0x14(%ebp),%eax
  801be6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be9:	8b 55 18             	mov    0x18(%ebp),%edx
  801bec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf0:	52                   	push   %edx
  801bf1:	50                   	push   %eax
  801bf2:	ff 75 10             	pushl  0x10(%ebp)
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	6a 20                	push   $0x20
  801bfd:	e8 fa fb ff ff       	call   8017fc <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
	return;
  801c05:	90                   	nop
}
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <chktst>:
void chktst(uint32 n) {
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	ff 75 08             	pushl  0x8(%ebp)
  801c16:	6a 22                	push   $0x22
  801c18:	e8 df fb ff ff       	call   8017fc <syscall>
  801c1d:	83 c4 18             	add    $0x18,%esp
	return;
  801c20:	90                   	nop
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <inctst>:

void inctst() {
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 23                	push   $0x23
  801c32:	e8 c5 fb ff ff       	call   8017fc <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <gettst>:
uint32 gettst() {
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 24                	push   $0x24
  801c4c:	e8 ab fb ff ff       	call   8017fc <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 25                	push   $0x25
  801c68:	e8 8f fb ff ff       	call   8017fc <syscall>
  801c6d:	83 c4 18             	add    $0x18,%esp
  801c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c73:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c77:	75 07                	jne    801c80 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c79:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7e:	eb 05                	jmp    801c85 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 25                	push   $0x25
  801c99:	e8 5e fb ff ff       	call   8017fc <syscall>
  801c9e:	83 c4 18             	add    $0x18,%esp
  801ca1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ca4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ca8:	75 07                	jne    801cb1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801caa:	b8 01 00 00 00       	mov    $0x1,%eax
  801caf:	eb 05                	jmp    801cb6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 25                	push   $0x25
  801cca:	e8 2d fb ff ff       	call   8017fc <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
  801cd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cd5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cd9:	75 07                	jne    801ce2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cdb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce0:	eb 05                	jmp    801ce7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ce2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 25                	push   $0x25
  801cfb:	e8 fc fa ff ff       	call   8017fc <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
  801d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d06:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d0a:	75 07                	jne    801d13 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d0c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d11:	eb 05                	jmp    801d18 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d18:	c9                   	leave  
  801d19:	c3                   	ret    

00801d1a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	ff 75 08             	pushl  0x8(%ebp)
  801d28:	6a 26                	push   $0x26
  801d2a:	e8 cd fa ff ff       	call   8017fc <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
	return;
  801d32:	90                   	nop
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801d39:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d3c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d42:	8b 45 08             	mov    0x8(%ebp),%eax
  801d45:	6a 00                	push   $0x0
  801d47:	53                   	push   %ebx
  801d48:	51                   	push   %ecx
  801d49:	52                   	push   %edx
  801d4a:	50                   	push   %eax
  801d4b:	6a 27                	push   $0x27
  801d4d:	e8 aa fa ff ff       	call   8017fc <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801d55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801d5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	52                   	push   %edx
  801d6a:	50                   	push   %eax
  801d6b:	6a 28                	push   $0x28
  801d6d:	e8 8a fa ff ff       	call   8017fc <syscall>
  801d72:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801d7a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	51                   	push   %ecx
  801d86:	ff 75 10             	pushl  0x10(%ebp)
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 29                	push   $0x29
  801d8d:	e8 6a fa ff ff       	call   8017fc <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	ff 75 10             	pushl  0x10(%ebp)
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	ff 75 08             	pushl  0x8(%ebp)
  801da7:	6a 12                	push   $0x12
  801da9:	e8 4e fa ff ff       	call   8017fc <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
	return;
  801db1:	90                   	nop
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801db7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	6a 2a                	push   $0x2a
  801dc7:	e8 30 fa ff ff       	call   8017fc <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
	return;
  801dcf:	90                   	nop
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	50                   	push   %eax
  801de1:	6a 2b                	push   $0x2b
  801de3:	e8 14 fa ff ff       	call   8017fc <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	c9                   	leave  
  801dec:	c3                   	ret    

00801ded <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	6a 2c                	push   $0x2c
  801dfe:	e8 f9 f9 ff ff       	call   8017fc <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	ff 75 0c             	pushl  0xc(%ebp)
  801e15:	ff 75 08             	pushl  0x8(%ebp)
  801e18:	6a 2d                	push   $0x2d
  801e1a:	e8 dd f9 ff ff       	call   8017fc <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
	return;
  801e22:	90                   	nop
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	50                   	push   %eax
  801e34:	6a 2f                	push   $0x2f
  801e36:	e8 c1 f9 ff ff       	call   8017fc <syscall>
  801e3b:	83 c4 18             	add    $0x18,%esp
	return;
  801e3e:	90                   	nop
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801e44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	52                   	push   %edx
  801e51:	50                   	push   %eax
  801e52:	6a 30                	push   $0x30
  801e54:	e8 a3 f9 ff ff       	call   8017fc <syscall>
  801e59:	83 c4 18             	add    $0x18,%esp
	return;
  801e5c:	90                   	nop
}
  801e5d:	c9                   	leave  
  801e5e:	c3                   	ret    

00801e5f <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801e5f:	55                   	push   %ebp
  801e60:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801e62:	8b 45 08             	mov    0x8(%ebp),%eax
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	50                   	push   %eax
  801e6e:	6a 31                	push   $0x31
  801e70:	e8 87 f9 ff ff       	call   8017fc <syscall>
  801e75:	83 c4 18             	add    $0x18,%esp
	return;
  801e78:	90                   	nop
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801e7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e81:	8b 45 08             	mov    0x8(%ebp),%eax
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	52                   	push   %edx
  801e8b:	50                   	push   %eax
  801e8c:	6a 2e                	push   $0x2e
  801e8e:	e8 69 f9 ff ff       	call   8017fc <syscall>
  801e93:	83 c4 18             	add    $0x18,%esp
    return;
  801e96:	90                   	nop
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	83 e8 04             	sub    $0x4,%eax
  801ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eab:	8b 00                	mov    (%eax),%eax
  801ead:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	83 e8 04             	sub    $0x4,%eax
  801ebe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ec1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec4:	8b 00                	mov    (%eax),%eax
  801ec6:	83 e0 01             	and    $0x1,%eax
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	0f 94 c0             	sete   %al
}
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ed6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee0:	83 f8 02             	cmp    $0x2,%eax
  801ee3:	74 2b                	je     801f10 <alloc_block+0x40>
  801ee5:	83 f8 02             	cmp    $0x2,%eax
  801ee8:	7f 07                	jg     801ef1 <alloc_block+0x21>
  801eea:	83 f8 01             	cmp    $0x1,%eax
  801eed:	74 0e                	je     801efd <alloc_block+0x2d>
  801eef:	eb 58                	jmp    801f49 <alloc_block+0x79>
  801ef1:	83 f8 03             	cmp    $0x3,%eax
  801ef4:	74 2d                	je     801f23 <alloc_block+0x53>
  801ef6:	83 f8 04             	cmp    $0x4,%eax
  801ef9:	74 3b                	je     801f36 <alloc_block+0x66>
  801efb:	eb 4c                	jmp    801f49 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 75 08             	pushl  0x8(%ebp)
  801f03:	e8 f7 03 00 00       	call   8022ff <alloc_block_FF>
  801f08:	83 c4 10             	add    $0x10,%esp
  801f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f0e:	eb 4a                	jmp    801f5a <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	ff 75 08             	pushl  0x8(%ebp)
  801f16:	e8 f0 11 00 00       	call   80310b <alloc_block_NF>
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f21:	eb 37                	jmp    801f5a <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f23:	83 ec 0c             	sub    $0xc,%esp
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	e8 08 08 00 00       	call   802736 <alloc_block_BF>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f34:	eb 24                	jmp    801f5a <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	ff 75 08             	pushl  0x8(%ebp)
  801f3c:	e8 ad 11 00 00       	call   8030ee <alloc_block_WF>
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f47:	eb 11                	jmp    801f5a <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f49:	83 ec 0c             	sub    $0xc,%esp
  801f4c:	68 18 3d 80 00       	push   $0x803d18
  801f51:	e8 41 e4 ff ff       	call   800397 <cprintf>
  801f56:	83 c4 10             	add    $0x10,%esp
		break;
  801f59:	90                   	nop
	}
	return va;
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	53                   	push   %ebx
  801f63:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f66:	83 ec 0c             	sub    $0xc,%esp
  801f69:	68 38 3d 80 00       	push   $0x803d38
  801f6e:	e8 24 e4 ff ff       	call   800397 <cprintf>
  801f73:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f76:	83 ec 0c             	sub    $0xc,%esp
  801f79:	68 63 3d 80 00       	push   $0x803d63
  801f7e:	e8 14 e4 ff ff       	call   800397 <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f86:	8b 45 08             	mov    0x8(%ebp),%eax
  801f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8c:	eb 37                	jmp    801fc5 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	e8 19 ff ff ff       	call   801eb2 <is_free_block>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	0f be d8             	movsbl %al,%ebx
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa5:	e8 ef fe ff ff       	call   801e99 <get_block_size>
  801faa:	83 c4 10             	add    $0x10,%esp
  801fad:	83 ec 04             	sub    $0x4,%esp
  801fb0:	53                   	push   %ebx
  801fb1:	50                   	push   %eax
  801fb2:	68 7b 3d 80 00       	push   $0x803d7b
  801fb7:	e8 db e3 ff ff       	call   800397 <cprintf>
  801fbc:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc9:	74 07                	je     801fd2 <print_blocks_list+0x73>
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	eb 05                	jmp    801fd7 <print_blocks_list+0x78>
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	89 45 10             	mov    %eax,0x10(%ebp)
  801fda:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	75 ad                	jne    801f8e <print_blocks_list+0x2f>
  801fe1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe5:	75 a7                	jne    801f8e <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	68 38 3d 80 00       	push   $0x803d38
  801fef:	e8 a3 e3 ff ff       	call   800397 <cprintf>
  801ff4:	83 c4 10             	add    $0x10,%esp

}
  801ff7:	90                   	nop
  801ff8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802003:	8b 45 0c             	mov    0xc(%ebp),%eax
  802006:	83 e0 01             	and    $0x1,%eax
  802009:	85 c0                	test   %eax,%eax
  80200b:	74 03                	je     802010 <initialize_dynamic_allocator+0x13>
  80200d:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  802010:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802014:	0f 84 f8 00 00 00    	je     802112 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  80201a:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802021:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802024:	a1 40 50 98 00       	mov    0x985040,%eax
  802029:	85 c0                	test   %eax,%eax
  80202b:	0f 84 e2 00 00 00    	je     802113 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  802040:	8b 55 08             	mov    0x8(%ebp),%edx
  802043:	8b 45 0c             	mov    0xc(%ebp),%eax
  802046:	01 d0                	add    %edx,%eax
  802048:	83 e8 04             	sub    $0x4,%eax
  80204b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80204e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802051:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	83 c0 08             	add    $0x8,%eax
  80205d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802060:	8b 45 0c             	mov    0xc(%ebp),%eax
  802063:	83 e8 08             	sub    $0x8,%eax
  802066:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 e8             	pushl  -0x18(%ebp)
  802071:	ff 75 ec             	pushl  -0x14(%ebp)
  802074:	e8 9c 00 00 00       	call   802115 <set_block_data>
  802079:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80207c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80208f:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802096:	00 00 00 
  802099:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  8020a0:	00 00 00 
  8020a3:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8020aa:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8020ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020b1:	75 17                	jne    8020ca <initialize_dynamic_allocator+0xcd>
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	68 94 3d 80 00       	push   $0x803d94
  8020bb:	68 80 00 00 00       	push   $0x80
  8020c0:	68 b7 3d 80 00       	push   $0x803db7
  8020c5:	e8 b5 12 00 00       	call   80337f <_panic>
  8020ca:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8020d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d3:	89 10                	mov    %edx,(%eax)
  8020d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	74 0d                	je     8020eb <initialize_dynamic_allocator+0xee>
  8020de:	a1 48 50 98 00       	mov    0x985048,%eax
  8020e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e6:	89 50 04             	mov    %edx,0x4(%eax)
  8020e9:	eb 08                	jmp    8020f3 <initialize_dynamic_allocator+0xf6>
  8020eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ee:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8020f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f6:	a3 48 50 98 00       	mov    %eax,0x985048
  8020fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802105:	a1 54 50 98 00       	mov    0x985054,%eax
  80210a:	40                   	inc    %eax
  80210b:	a3 54 50 98 00       	mov    %eax,0x985054
  802110:	eb 01                	jmp    802113 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802112:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80211b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211e:	83 e0 01             	and    $0x1,%eax
  802121:	85 c0                	test   %eax,%eax
  802123:	74 03                	je     802128 <set_block_data+0x13>
	{
		totalSize++;
  802125:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	83 e8 04             	sub    $0x4,%eax
  80212e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802131:	8b 45 0c             	mov    0xc(%ebp),%eax
  802134:	83 e0 fe             	and    $0xfffffffe,%eax
  802137:	89 c2                	mov    %eax,%edx
  802139:	8b 45 10             	mov    0x10(%ebp),%eax
  80213c:	83 e0 01             	and    $0x1,%eax
  80213f:	09 c2                	or     %eax,%edx
  802141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802144:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802146:	8b 45 0c             	mov    0xc(%ebp),%eax
  802149:	8d 50 f8             	lea    -0x8(%eax),%edx
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	01 d0                	add    %edx,%eax
  802151:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802154:	8b 45 0c             	mov    0xc(%ebp),%eax
  802157:	83 e0 fe             	and    $0xfffffffe,%eax
  80215a:	89 c2                	mov    %eax,%edx
  80215c:	8b 45 10             	mov    0x10(%ebp),%eax
  80215f:	83 e0 01             	and    $0x1,%eax
  802162:	09 c2                	or     %eax,%edx
  802164:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802167:	89 10                	mov    %edx,(%eax)
}
  802169:	90                   	nop
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802172:	a1 48 50 98 00       	mov    0x985048,%eax
  802177:	85 c0                	test   %eax,%eax
  802179:	75 68                	jne    8021e3 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80217b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217f:	75 17                	jne    802198 <insert_sorted_in_freeList+0x2c>
  802181:	83 ec 04             	sub    $0x4,%esp
  802184:	68 94 3d 80 00       	push   $0x803d94
  802189:	68 9d 00 00 00       	push   $0x9d
  80218e:	68 b7 3d 80 00       	push   $0x803db7
  802193:	e8 e7 11 00 00       	call   80337f <_panic>
  802198:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	89 10                	mov    %edx,(%eax)
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8b 00                	mov    (%eax),%eax
  8021a8:	85 c0                	test   %eax,%eax
  8021aa:	74 0d                	je     8021b9 <insert_sorted_in_freeList+0x4d>
  8021ac:	a1 48 50 98 00       	mov    0x985048,%eax
  8021b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b4:	89 50 04             	mov    %edx,0x4(%eax)
  8021b7:	eb 08                	jmp    8021c1 <insert_sorted_in_freeList+0x55>
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	a3 48 50 98 00       	mov    %eax,0x985048
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d3:	a1 54 50 98 00       	mov    0x985054,%eax
  8021d8:	40                   	inc    %eax
  8021d9:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8021de:	e9 1a 01 00 00       	jmp    8022fd <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8021e3:	a1 48 50 98 00       	mov    0x985048,%eax
  8021e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021eb:	eb 7f                	jmp    80226c <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f3:	76 6f                	jbe    802264 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8021f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f9:	74 06                	je     802201 <insert_sorted_in_freeList+0x95>
  8021fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ff:	75 17                	jne    802218 <insert_sorted_in_freeList+0xac>
  802201:	83 ec 04             	sub    $0x4,%esp
  802204:	68 d0 3d 80 00       	push   $0x803dd0
  802209:	68 a6 00 00 00       	push   $0xa6
  80220e:	68 b7 3d 80 00       	push   $0x803db7
  802213:	e8 67 11 00 00       	call   80337f <_panic>
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 50 04             	mov    0x4(%eax),%edx
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	89 50 04             	mov    %edx,0x4(%eax)
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222a:	89 10                	mov    %edx,(%eax)
  80222c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222f:	8b 40 04             	mov    0x4(%eax),%eax
  802232:	85 c0                	test   %eax,%eax
  802234:	74 0d                	je     802243 <insert_sorted_in_freeList+0xd7>
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	8b 40 04             	mov    0x4(%eax),%eax
  80223c:	8b 55 08             	mov    0x8(%ebp),%edx
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	eb 08                	jmp    80224b <insert_sorted_in_freeList+0xdf>
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	a3 48 50 98 00       	mov    %eax,0x985048
  80224b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224e:	8b 55 08             	mov    0x8(%ebp),%edx
  802251:	89 50 04             	mov    %edx,0x4(%eax)
  802254:	a1 54 50 98 00       	mov    0x985054,%eax
  802259:	40                   	inc    %eax
  80225a:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80225f:	e9 99 00 00 00       	jmp    8022fd <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802264:	a1 50 50 98 00       	mov    0x985050,%eax
  802269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802270:	74 07                	je     802279 <insert_sorted_in_freeList+0x10d>
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	eb 05                	jmp    80227e <insert_sorted_in_freeList+0x112>
  802279:	b8 00 00 00 00       	mov    $0x0,%eax
  80227e:	a3 50 50 98 00       	mov    %eax,0x985050
  802283:	a1 50 50 98 00       	mov    0x985050,%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	0f 85 5d ff ff ff    	jne    8021ed <insert_sorted_in_freeList+0x81>
  802290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802294:	0f 85 53 ff ff ff    	jne    8021ed <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80229a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229e:	75 17                	jne    8022b7 <insert_sorted_in_freeList+0x14b>
  8022a0:	83 ec 04             	sub    $0x4,%esp
  8022a3:	68 08 3e 80 00       	push   $0x803e08
  8022a8:	68 ab 00 00 00       	push   $0xab
  8022ad:	68 b7 3d 80 00       	push   $0x803db7
  8022b2:	e8 c8 10 00 00       	call   80337f <_panic>
  8022b7:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	89 50 04             	mov    %edx,0x4(%eax)
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 0c                	je     8022d9 <insert_sorted_in_freeList+0x16d>
  8022cd:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8022d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d5:	89 10                	mov    %edx,(%eax)
  8022d7:	eb 08                	jmp    8022e1 <insert_sorted_in_freeList+0x175>
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	a3 48 50 98 00       	mov    %eax,0x985048
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f2:	a1 54 50 98 00       	mov    0x985054,%eax
  8022f7:	40                   	inc    %eax
  8022f8:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	83 e0 01             	and    $0x1,%eax
  80230b:	85 c0                	test   %eax,%eax
  80230d:	74 03                	je     802312 <alloc_block_FF+0x13>
  80230f:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802312:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802316:	77 07                	ja     80231f <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802318:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80231f:	a1 40 50 98 00       	mov    0x985040,%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	75 63                	jne    80238b <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	83 c0 10             	add    $0x10,%eax
  80232e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802331:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233e:	01 d0                	add    %edx,%eax
  802340:	48                   	dec    %eax
  802341:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802344:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802347:	ba 00 00 00 00       	mov    $0x0,%edx
  80234c:	f7 75 ec             	divl   -0x14(%ebp)
  80234f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802352:	29 d0                	sub    %edx,%eax
  802354:	c1 e8 0c             	shr    $0xc,%eax
  802357:	83 ec 0c             	sub    $0xc,%esp
  80235a:	50                   	push   %eax
  80235b:	e8 d1 ed ff ff       	call   801131 <sbrk>
  802360:	83 c4 10             	add    $0x10,%esp
  802363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802366:	83 ec 0c             	sub    $0xc,%esp
  802369:	6a 00                	push   $0x0
  80236b:	e8 c1 ed ff ff       	call   801131 <sbrk>
  802370:	83 c4 10             	add    $0x10,%esp
  802373:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802376:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802379:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80237c:	83 ec 08             	sub    $0x8,%esp
  80237f:	50                   	push   %eax
  802380:	ff 75 e4             	pushl  -0x1c(%ebp)
  802383:	e8 75 fc ff ff       	call   801ffd <initialize_dynamic_allocator>
  802388:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80238b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238f:	75 0a                	jne    80239b <alloc_block_FF+0x9c>
	{
		return NULL;
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
  802396:	e9 99 03 00 00       	jmp    802734 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	83 c0 08             	add    $0x8,%eax
  8023a1:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8023a4:	a1 48 50 98 00       	mov    0x985048,%eax
  8023a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ac:	e9 03 02 00 00       	jmp    8025b4 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8023b1:	83 ec 0c             	sub    $0xc,%esp
  8023b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b7:	e8 dd fa ff ff       	call   801e99 <get_block_size>
  8023bc:	83 c4 10             	add    $0x10,%esp
  8023bf:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8023c2:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8023c5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8023c8:	0f 82 de 01 00 00    	jb     8025ac <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8023ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023d1:	83 c0 10             	add    $0x10,%eax
  8023d4:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8023d7:	0f 87 32 01 00 00    	ja     80250f <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8023dd:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8023e0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8023e3:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8023e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023ec:	01 d0                	add    %edx,%eax
  8023ee:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8023f1:	83 ec 04             	sub    $0x4,%esp
  8023f4:	6a 00                	push   $0x0
  8023f6:	ff 75 98             	pushl  -0x68(%ebp)
  8023f9:	ff 75 94             	pushl  -0x6c(%ebp)
  8023fc:	e8 14 fd ff ff       	call   802115 <set_block_data>
  802401:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802408:	74 06                	je     802410 <alloc_block_FF+0x111>
  80240a:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80240e:	75 17                	jne    802427 <alloc_block_FF+0x128>
  802410:	83 ec 04             	sub    $0x4,%esp
  802413:	68 2c 3e 80 00       	push   $0x803e2c
  802418:	68 de 00 00 00       	push   $0xde
  80241d:	68 b7 3d 80 00       	push   $0x803db7
  802422:	e8 58 0f 00 00       	call   80337f <_panic>
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 10                	mov    (%eax),%edx
  80242c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80242f:	89 10                	mov    %edx,(%eax)
  802431:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	85 c0                	test   %eax,%eax
  802438:	74 0b                	je     802445 <alloc_block_FF+0x146>
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802442:	89 50 04             	mov    %edx,0x4(%eax)
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80244b:	89 10                	mov    %edx,(%eax)
  80244d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802450:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802453:	89 50 04             	mov    %edx,0x4(%eax)
  802456:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802459:	8b 00                	mov    (%eax),%eax
  80245b:	85 c0                	test   %eax,%eax
  80245d:	75 08                	jne    802467 <alloc_block_FF+0x168>
  80245f:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802462:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802467:	a1 54 50 98 00       	mov    0x985054,%eax
  80246c:	40                   	inc    %eax
  80246d:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	6a 01                	push   $0x1
  802477:	ff 75 dc             	pushl  -0x24(%ebp)
  80247a:	ff 75 f4             	pushl  -0xc(%ebp)
  80247d:	e8 93 fc ff ff       	call   802115 <set_block_data>
  802482:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802489:	75 17                	jne    8024a2 <alloc_block_FF+0x1a3>
  80248b:	83 ec 04             	sub    $0x4,%esp
  80248e:	68 60 3e 80 00       	push   $0x803e60
  802493:	68 e3 00 00 00       	push   $0xe3
  802498:	68 b7 3d 80 00       	push   $0x803db7
  80249d:	e8 dd 0e 00 00       	call   80337f <_panic>
  8024a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a5:	8b 00                	mov    (%eax),%eax
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	74 10                	je     8024bb <alloc_block_FF+0x1bc>
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b3:	8b 52 04             	mov    0x4(%edx),%edx
  8024b6:	89 50 04             	mov    %edx,0x4(%eax)
  8024b9:	eb 0b                	jmp    8024c6 <alloc_block_FF+0x1c7>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 04             	mov    0x4(%eax),%eax
  8024c1:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 04             	mov    0x4(%eax),%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	74 0f                	je     8024df <alloc_block_FF+0x1e0>
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 40 04             	mov    0x4(%eax),%eax
  8024d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d9:	8b 12                	mov    (%edx),%edx
  8024db:	89 10                	mov    %edx,(%eax)
  8024dd:	eb 0a                	jmp    8024e9 <alloc_block_FF+0x1ea>
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	a3 48 50 98 00       	mov    %eax,0x985048
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fc:	a1 54 50 98 00       	mov    0x985054,%eax
  802501:	48                   	dec    %eax
  802502:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	e9 25 02 00 00       	jmp    802734 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80250f:	83 ec 04             	sub    $0x4,%esp
  802512:	6a 01                	push   $0x1
  802514:	ff 75 9c             	pushl  -0x64(%ebp)
  802517:	ff 75 f4             	pushl  -0xc(%ebp)
  80251a:	e8 f6 fb ff ff       	call   802115 <set_block_data>
  80251f:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802522:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802526:	75 17                	jne    80253f <alloc_block_FF+0x240>
  802528:	83 ec 04             	sub    $0x4,%esp
  80252b:	68 60 3e 80 00       	push   $0x803e60
  802530:	68 eb 00 00 00       	push   $0xeb
  802535:	68 b7 3d 80 00       	push   $0x803db7
  80253a:	e8 40 0e 00 00       	call   80337f <_panic>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 00                	mov    (%eax),%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	74 10                	je     802558 <alloc_block_FF+0x259>
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802550:	8b 52 04             	mov    0x4(%edx),%edx
  802553:	89 50 04             	mov    %edx,0x4(%eax)
  802556:	eb 0b                	jmp    802563 <alloc_block_FF+0x264>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 40 04             	mov    0x4(%eax),%eax
  80255e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 04             	mov    0x4(%eax),%eax
  802569:	85 c0                	test   %eax,%eax
  80256b:	74 0f                	je     80257c <alloc_block_FF+0x27d>
  80256d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802570:	8b 40 04             	mov    0x4(%eax),%eax
  802573:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802576:	8b 12                	mov    (%edx),%edx
  802578:	89 10                	mov    %edx,(%eax)
  80257a:	eb 0a                	jmp    802586 <alloc_block_FF+0x287>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	a3 48 50 98 00       	mov    %eax,0x985048
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802599:	a1 54 50 98 00       	mov    0x985054,%eax
  80259e:	48                   	dec    %eax
  80259f:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	e9 88 01 00 00       	jmp    802734 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8025ac:	a1 50 50 98 00       	mov    0x985050,%eax
  8025b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b8:	74 07                	je     8025c1 <alloc_block_FF+0x2c2>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	eb 05                	jmp    8025c6 <alloc_block_FF+0x2c7>
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c6:	a3 50 50 98 00       	mov    %eax,0x985050
  8025cb:	a1 50 50 98 00       	mov    0x985050,%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	0f 85 d9 fd ff ff    	jne    8023b1 <alloc_block_FF+0xb2>
  8025d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dc:	0f 85 cf fd ff ff    	jne    8023b1 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8025e2:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025ec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ef:	01 d0                	add    %edx,%eax
  8025f1:	48                   	dec    %eax
  8025f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025f5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fd:	f7 75 d8             	divl   -0x28(%ebp)
  802600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802603:	29 d0                	sub    %edx,%eax
  802605:	c1 e8 0c             	shr    $0xc,%eax
  802608:	83 ec 0c             	sub    $0xc,%esp
  80260b:	50                   	push   %eax
  80260c:	e8 20 eb ff ff       	call   801131 <sbrk>
  802611:	83 c4 10             	add    $0x10,%esp
  802614:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802617:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80261b:	75 0a                	jne    802627 <alloc_block_FF+0x328>
		return NULL;
  80261d:	b8 00 00 00 00       	mov    $0x0,%eax
  802622:	e9 0d 01 00 00       	jmp    802734 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802627:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80262a:	83 e8 04             	sub    $0x4,%eax
  80262d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  802630:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802637:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80263a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80263d:	01 d0                	add    %edx,%eax
  80263f:	48                   	dec    %eax
  802640:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802643:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802646:	ba 00 00 00 00       	mov    $0x0,%edx
  80264b:	f7 75 c8             	divl   -0x38(%ebp)
  80264e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802651:	29 d0                	sub    %edx,%eax
  802653:	c1 e8 02             	shr    $0x2,%eax
  802656:	c1 e0 02             	shl    $0x2,%eax
  802659:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  80265c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80265f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802665:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802668:	83 e8 08             	sub    $0x8,%eax
  80266b:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80266e:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802671:	8b 00                	mov    (%eax),%eax
  802673:	83 e0 fe             	and    $0xfffffffe,%eax
  802676:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802679:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80267c:	f7 d8                	neg    %eax
  80267e:	89 c2                	mov    %eax,%edx
  802680:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802683:	01 d0                	add    %edx,%eax
  802685:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802688:	83 ec 0c             	sub    $0xc,%esp
  80268b:	ff 75 b8             	pushl  -0x48(%ebp)
  80268e:	e8 1f f8 ff ff       	call   801eb2 <is_free_block>
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	0f be c0             	movsbl %al,%eax
  802699:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  80269c:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8026a0:	74 42                	je     8026e4 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8026a2:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8026a9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ac:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	48                   	dec    %eax
  8026b2:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8026b5:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8026b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bd:	f7 75 b0             	divl   -0x50(%ebp)
  8026c0:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8026c3:	29 d0                	sub    %edx,%eax
  8026c5:	89 c2                	mov    %eax,%edx
  8026c7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026ca:	01 d0                	add    %edx,%eax
  8026cc:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  8026cf:	83 ec 04             	sub    $0x4,%esp
  8026d2:	6a 00                	push   $0x0
  8026d4:	ff 75 a8             	pushl  -0x58(%ebp)
  8026d7:	ff 75 b8             	pushl  -0x48(%ebp)
  8026da:	e8 36 fa ff ff       	call   802115 <set_block_data>
  8026df:	83 c4 10             	add    $0x10,%esp
  8026e2:	eb 42                	jmp    802726 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8026e4:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8026eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ee:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026f1:	01 d0                	add    %edx,%eax
  8026f3:	48                   	dec    %eax
  8026f4:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8026f7:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8026fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ff:	f7 75 a4             	divl   -0x5c(%ebp)
  802702:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802705:	29 d0                	sub    %edx,%eax
  802707:	83 ec 04             	sub    $0x4,%esp
  80270a:	6a 00                	push   $0x0
  80270c:	50                   	push   %eax
  80270d:	ff 75 d0             	pushl  -0x30(%ebp)
  802710:	e8 00 fa ff ff       	call   802115 <set_block_data>
  802715:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802718:	83 ec 0c             	sub    $0xc,%esp
  80271b:	ff 75 d0             	pushl  -0x30(%ebp)
  80271e:	e8 49 fa ff ff       	call   80216c <insert_sorted_in_freeList>
  802723:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802726:	83 ec 0c             	sub    $0xc,%esp
  802729:	ff 75 08             	pushl  0x8(%ebp)
  80272c:	e8 ce fb ff ff       	call   8022ff <alloc_block_FF>
  802731:	83 c4 10             	add    $0x10,%esp
}
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  80273c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802740:	75 0a                	jne    80274c <alloc_block_BF+0x16>
	{
		return NULL;
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
  802747:	e9 7a 02 00 00       	jmp    8029c6 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	83 c0 08             	add    $0x8,%eax
  802752:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802755:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  80275c:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802763:	a1 48 50 98 00       	mov    0x985048,%eax
  802768:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80276b:	eb 32                	jmp    80279f <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  80276d:	ff 75 ec             	pushl  -0x14(%ebp)
  802770:	e8 24 f7 ff ff       	call   801e99 <get_block_size>
  802775:	83 c4 04             	add    $0x4,%esp
  802778:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  80277b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802781:	72 14                	jb     802797 <alloc_block_BF+0x61>
  802783:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802786:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802789:	73 0c                	jae    802797 <alloc_block_BF+0x61>
		{
			minBlk = block;
  80278b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278e:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802791:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802797:	a1 50 50 98 00       	mov    0x985050,%eax
  80279c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80279f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027a3:	74 07                	je     8027ac <alloc_block_BF+0x76>
  8027a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	eb 05                	jmp    8027b1 <alloc_block_BF+0x7b>
  8027ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b1:	a3 50 50 98 00       	mov    %eax,0x985050
  8027b6:	a1 50 50 98 00       	mov    0x985050,%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	75 ae                	jne    80276d <alloc_block_BF+0x37>
  8027bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027c3:	75 a8                	jne    80276d <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	75 22                	jne    8027ed <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  8027cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ce:	83 ec 0c             	sub    $0xc,%esp
  8027d1:	50                   	push   %eax
  8027d2:	e8 5a e9 ff ff       	call   801131 <sbrk>
  8027d7:	83 c4 10             	add    $0x10,%esp
  8027da:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  8027dd:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8027e1:	75 0a                	jne    8027ed <alloc_block_BF+0xb7>
			return NULL;
  8027e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e8:	e9 d9 01 00 00       	jmp    8029c6 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8027ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f0:	83 c0 10             	add    $0x10,%eax
  8027f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027f6:	0f 87 32 01 00 00    	ja     80292e <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802802:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802805:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280b:	01 d0                	add    %edx,%eax
  80280d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802810:	83 ec 04             	sub    $0x4,%esp
  802813:	6a 00                	push   $0x0
  802815:	ff 75 dc             	pushl  -0x24(%ebp)
  802818:	ff 75 d8             	pushl  -0x28(%ebp)
  80281b:	e8 f5 f8 ff ff       	call   802115 <set_block_data>
  802820:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	74 06                	je     80282f <alloc_block_BF+0xf9>
  802829:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80282d:	75 17                	jne    802846 <alloc_block_BF+0x110>
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	68 2c 3e 80 00       	push   $0x803e2c
  802837:	68 49 01 00 00       	push   $0x149
  80283c:	68 b7 3d 80 00       	push   $0x803db7
  802841:	e8 39 0b 00 00       	call   80337f <_panic>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 10                	mov    (%eax),%edx
  80284b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	74 0b                	je     802864 <alloc_block_BF+0x12e>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 00                	mov    (%eax),%eax
  80285e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802861:	89 50 04             	mov    %edx,0x4(%eax)
  802864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802867:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80286a:	89 10                	mov    %edx,(%eax)
  80286c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80286f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802872:	89 50 04             	mov    %edx,0x4(%eax)
  802875:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	75 08                	jne    802886 <alloc_block_BF+0x150>
  80287e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802881:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802886:	a1 54 50 98 00       	mov    0x985054,%eax
  80288b:	40                   	inc    %eax
  80288c:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	6a 01                	push   $0x1
  802896:	ff 75 e8             	pushl  -0x18(%ebp)
  802899:	ff 75 f4             	pushl  -0xc(%ebp)
  80289c:	e8 74 f8 ff ff       	call   802115 <set_block_data>
  8028a1:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8028a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a8:	75 17                	jne    8028c1 <alloc_block_BF+0x18b>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 60 3e 80 00       	push   $0x803e60
  8028b2:	68 4e 01 00 00       	push   $0x14e
  8028b7:	68 b7 3d 80 00       	push   $0x803db7
  8028bc:	e8 be 0a 00 00       	call   80337f <_panic>
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	74 10                	je     8028da <alloc_block_BF+0x1a4>
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d2:	8b 52 04             	mov    0x4(%edx),%edx
  8028d5:	89 50 04             	mov    %edx,0x4(%eax)
  8028d8:	eb 0b                	jmp    8028e5 <alloc_block_BF+0x1af>
  8028da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e8:	8b 40 04             	mov    0x4(%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 0f                	je     8028fe <alloc_block_BF+0x1c8>
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f8:	8b 12                	mov    (%edx),%edx
  8028fa:	89 10                	mov    %edx,(%eax)
  8028fc:	eb 0a                	jmp    802908 <alloc_block_BF+0x1d2>
  8028fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	a3 48 50 98 00       	mov    %eax,0x985048
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291b:	a1 54 50 98 00       	mov    0x985054,%eax
  802920:	48                   	dec    %eax
  802921:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	e9 98 00 00 00       	jmp    8029c6 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  80292e:	83 ec 04             	sub    $0x4,%esp
  802931:	6a 01                	push   $0x1
  802933:	ff 75 f0             	pushl  -0x10(%ebp)
  802936:	ff 75 f4             	pushl  -0xc(%ebp)
  802939:	e8 d7 f7 ff ff       	call   802115 <set_block_data>
  80293e:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802945:	75 17                	jne    80295e <alloc_block_BF+0x228>
  802947:	83 ec 04             	sub    $0x4,%esp
  80294a:	68 60 3e 80 00       	push   $0x803e60
  80294f:	68 56 01 00 00       	push   $0x156
  802954:	68 b7 3d 80 00       	push   $0x803db7
  802959:	e8 21 0a 00 00       	call   80337f <_panic>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	85 c0                	test   %eax,%eax
  802965:	74 10                	je     802977 <alloc_block_BF+0x241>
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	8b 00                	mov    (%eax),%eax
  80296c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296f:	8b 52 04             	mov    0x4(%edx),%edx
  802972:	89 50 04             	mov    %edx,0x4(%eax)
  802975:	eb 0b                	jmp    802982 <alloc_block_BF+0x24c>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 04             	mov    0x4(%eax),%eax
  80297d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 40 04             	mov    0x4(%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 0f                	je     80299b <alloc_block_BF+0x265>
  80298c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298f:	8b 40 04             	mov    0x4(%eax),%eax
  802992:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802995:	8b 12                	mov    (%edx),%edx
  802997:	89 10                	mov    %edx,(%eax)
  802999:	eb 0a                	jmp    8029a5 <alloc_block_BF+0x26f>
  80299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	a3 48 50 98 00       	mov    %eax,0x985048
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b8:	a1 54 50 98 00       	mov    0x985054,%eax
  8029bd:	48                   	dec    %eax
  8029be:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  8029c6:	c9                   	leave  
  8029c7:	c3                   	ret    

008029c8 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
  8029cb:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  8029ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d2:	0f 84 6a 02 00 00    	je     802c42 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  8029d8:	ff 75 08             	pushl  0x8(%ebp)
  8029db:	e8 b9 f4 ff ff       	call   801e99 <get_block_size>
  8029e0:	83 c4 04             	add    $0x4,%esp
  8029e3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	83 e8 08             	sub    $0x8,%eax
  8029ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8029ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	83 e0 fe             	and    $0xfffffffe,%eax
  8029f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	f7 d8                	neg    %eax
  8029ff:	89 c2                	mov    %eax,%edx
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	01 d0                	add    %edx,%eax
  802a06:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802a09:	ff 75 e8             	pushl  -0x18(%ebp)
  802a0c:	e8 a1 f4 ff ff       	call   801eb2 <is_free_block>
  802a11:	83 c4 04             	add    $0x4,%esp
  802a14:	0f be c0             	movsbl %al,%eax
  802a17:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	01 d0                	add    %edx,%eax
  802a22:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802a25:	ff 75 e0             	pushl  -0x20(%ebp)
  802a28:	e8 85 f4 ff ff       	call   801eb2 <is_free_block>
  802a2d:	83 c4 04             	add    $0x4,%esp
  802a30:	0f be c0             	movsbl %al,%eax
  802a33:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802a36:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802a3a:	75 34                	jne    802a70 <free_block+0xa8>
  802a3c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a40:	75 2e                	jne    802a70 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802a42:	ff 75 e8             	pushl  -0x18(%ebp)
  802a45:	e8 4f f4 ff ff       	call   801e99 <get_block_size>
  802a4a:	83 c4 04             	add    $0x4,%esp
  802a4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802a50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a53:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a56:	01 d0                	add    %edx,%eax
  802a58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802a5b:	6a 00                	push   $0x0
  802a5d:	ff 75 d4             	pushl  -0x2c(%ebp)
  802a60:	ff 75 e8             	pushl  -0x18(%ebp)
  802a63:	e8 ad f6 ff ff       	call   802115 <set_block_data>
  802a68:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802a6b:	e9 d3 01 00 00       	jmp    802c43 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802a70:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802a74:	0f 85 c8 00 00 00    	jne    802b42 <free_block+0x17a>
  802a7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a7e:	0f 85 be 00 00 00    	jne    802b42 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802a84:	ff 75 e0             	pushl  -0x20(%ebp)
  802a87:	e8 0d f4 ff ff       	call   801e99 <get_block_size>
  802a8c:	83 c4 04             	add    $0x4,%esp
  802a8f:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802a92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a95:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a98:	01 d0                	add    %edx,%eax
  802a9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802a9d:	6a 00                	push   $0x0
  802a9f:	ff 75 cc             	pushl  -0x34(%ebp)
  802aa2:	ff 75 08             	pushl  0x8(%ebp)
  802aa5:	e8 6b f6 ff ff       	call   802115 <set_block_data>
  802aaa:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802aad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ab1:	75 17                	jne    802aca <free_block+0x102>
  802ab3:	83 ec 04             	sub    $0x4,%esp
  802ab6:	68 60 3e 80 00       	push   $0x803e60
  802abb:	68 87 01 00 00       	push   $0x187
  802ac0:	68 b7 3d 80 00       	push   $0x803db7
  802ac5:	e8 b5 08 00 00       	call   80337f <_panic>
  802aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	74 10                	je     802ae3 <free_block+0x11b>
  802ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad6:	8b 00                	mov    (%eax),%eax
  802ad8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802adb:	8b 52 04             	mov    0x4(%edx),%edx
  802ade:	89 50 04             	mov    %edx,0x4(%eax)
  802ae1:	eb 0b                	jmp    802aee <free_block+0x126>
  802ae3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae6:	8b 40 04             	mov    0x4(%eax),%eax
  802ae9:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802aee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af1:	8b 40 04             	mov    0x4(%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	74 0f                	je     802b07 <free_block+0x13f>
  802af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b01:	8b 12                	mov    (%edx),%edx
  802b03:	89 10                	mov    %edx,(%eax)
  802b05:	eb 0a                	jmp    802b11 <free_block+0x149>
  802b07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0a:	8b 00                	mov    (%eax),%eax
  802b0c:	a3 48 50 98 00       	mov    %eax,0x985048
  802b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b14:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b24:	a1 54 50 98 00       	mov    0x985054,%eax
  802b29:	48                   	dec    %eax
  802b2a:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802b2f:	83 ec 0c             	sub    $0xc,%esp
  802b32:	ff 75 08             	pushl  0x8(%ebp)
  802b35:	e8 32 f6 ff ff       	call   80216c <insert_sorted_in_freeList>
  802b3a:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802b3d:	e9 01 01 00 00       	jmp    802c43 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802b42:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802b46:	0f 85 d3 00 00 00    	jne    802c1f <free_block+0x257>
  802b4c:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802b50:	0f 85 c9 00 00 00    	jne    802c1f <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802b56:	83 ec 0c             	sub    $0xc,%esp
  802b59:	ff 75 e8             	pushl  -0x18(%ebp)
  802b5c:	e8 38 f3 ff ff       	call   801e99 <get_block_size>
  802b61:	83 c4 10             	add    $0x10,%esp
  802b64:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802b67:	83 ec 0c             	sub    $0xc,%esp
  802b6a:	ff 75 e0             	pushl  -0x20(%ebp)
  802b6d:	e8 27 f3 ff ff       	call   801e99 <get_block_size>
  802b72:	83 c4 10             	add    $0x10,%esp
  802b75:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802b78:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b7e:	01 c2                	add    %eax,%edx
  802b80:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b83:	01 d0                	add    %edx,%eax
  802b85:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802b88:	83 ec 04             	sub    $0x4,%esp
  802b8b:	6a 00                	push   $0x0
  802b8d:	ff 75 c0             	pushl  -0x40(%ebp)
  802b90:	ff 75 e8             	pushl  -0x18(%ebp)
  802b93:	e8 7d f5 ff ff       	call   802115 <set_block_data>
  802b98:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802b9b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b9f:	75 17                	jne    802bb8 <free_block+0x1f0>
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	68 60 3e 80 00       	push   $0x803e60
  802ba9:	68 94 01 00 00       	push   $0x194
  802bae:	68 b7 3d 80 00       	push   $0x803db7
  802bb3:	e8 c7 07 00 00       	call   80337f <_panic>
  802bb8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	74 10                	je     802bd1 <free_block+0x209>
  802bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bc9:	8b 52 04             	mov    0x4(%edx),%edx
  802bcc:	89 50 04             	mov    %edx,0x4(%eax)
  802bcf:	eb 0b                	jmp    802bdc <free_block+0x214>
  802bd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd4:	8b 40 04             	mov    0x4(%eax),%eax
  802bd7:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bdf:	8b 40 04             	mov    0x4(%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 0f                	je     802bf5 <free_block+0x22d>
  802be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bef:	8b 12                	mov    (%edx),%edx
  802bf1:	89 10                	mov    %edx,(%eax)
  802bf3:	eb 0a                	jmp    802bff <free_block+0x237>
  802bf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	a3 48 50 98 00       	mov    %eax,0x985048
  802bff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c12:	a1 54 50 98 00       	mov    0x985054,%eax
  802c17:	48                   	dec    %eax
  802c18:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802c1d:	eb 24                	jmp    802c43 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802c1f:	83 ec 04             	sub    $0x4,%esp
  802c22:	6a 00                	push   $0x0
  802c24:	ff 75 f4             	pushl  -0xc(%ebp)
  802c27:	ff 75 08             	pushl  0x8(%ebp)
  802c2a:	e8 e6 f4 ff ff       	call   802115 <set_block_data>
  802c2f:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802c32:	83 ec 0c             	sub    $0xc,%esp
  802c35:	ff 75 08             	pushl  0x8(%ebp)
  802c38:	e8 2f f5 ff ff       	call   80216c <insert_sorted_in_freeList>
  802c3d:	83 c4 10             	add    $0x10,%esp
  802c40:	eb 01                	jmp    802c43 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802c42:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802c43:	c9                   	leave  
  802c44:	c3                   	ret    

00802c45 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802c45:	55                   	push   %ebp
  802c46:	89 e5                	mov    %esp,%ebp
  802c48:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802c4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4f:	75 10                	jne    802c61 <realloc_block_FF+0x1c>
  802c51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c55:	75 0a                	jne    802c61 <realloc_block_FF+0x1c>
	{
		return NULL;
  802c57:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5c:	e9 8b 04 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802c61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c65:	75 18                	jne    802c7f <realloc_block_FF+0x3a>
	{
		free_block(va);
  802c67:	83 ec 0c             	sub    $0xc,%esp
  802c6a:	ff 75 08             	pushl  0x8(%ebp)
  802c6d:	e8 56 fd ff ff       	call   8029c8 <free_block>
  802c72:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802c75:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7a:	e9 6d 04 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c83:	75 13                	jne    802c98 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802c85:	83 ec 0c             	sub    $0xc,%esp
  802c88:	ff 75 0c             	pushl  0xc(%ebp)
  802c8b:	e8 6f f6 ff ff       	call   8022ff <alloc_block_FF>
  802c90:	83 c4 10             	add    $0x10,%esp
  802c93:	e9 54 04 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9b:	83 e0 01             	and    $0x1,%eax
  802c9e:	85 c0                	test   %eax,%eax
  802ca0:	74 03                	je     802ca5 <realloc_block_FF+0x60>
	{
		new_size++;
  802ca2:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802ca5:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802ca9:	77 07                	ja     802cb2 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802cab:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802cb2:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802cb6:	83 ec 0c             	sub    $0xc,%esp
  802cb9:	ff 75 08             	pushl  0x8(%ebp)
  802cbc:	e8 d8 f1 ff ff       	call   801e99 <get_block_size>
  802cc1:	83 c4 10             	add    $0x10,%esp
  802cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ccd:	75 08                	jne    802cd7 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	e9 15 04 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	01 d0                	add    %edx,%eax
  802cdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ce2:	83 ec 0c             	sub    $0xc,%esp
  802ce5:	ff 75 f0             	pushl  -0x10(%ebp)
  802ce8:	e8 c5 f1 ff ff       	call   801eb2 <is_free_block>
  802ced:	83 c4 10             	add    $0x10,%esp
  802cf0:	0f be c0             	movsbl %al,%eax
  802cf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802cf6:	83 ec 0c             	sub    $0xc,%esp
  802cf9:	ff 75 f0             	pushl  -0x10(%ebp)
  802cfc:	e8 98 f1 ff ff       	call   801e99 <get_block_size>
  802d01:	83 c4 10             	add    $0x10,%esp
  802d04:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d0a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d0d:	0f 86 a7 02 00 00    	jbe    802fba <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802d13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d17:	0f 84 86 02 00 00    	je     802fa3 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802d1d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	01 d0                	add    %edx,%eax
  802d25:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d28:	0f 85 b2 00 00 00    	jne    802de0 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802d2e:	83 ec 0c             	sub    $0xc,%esp
  802d31:	ff 75 08             	pushl  0x8(%ebp)
  802d34:	e8 79 f1 ff ff       	call   801eb2 <is_free_block>
  802d39:	83 c4 10             	add    $0x10,%esp
  802d3c:	84 c0                	test   %al,%al
  802d3e:	0f 94 c0             	sete   %al
  802d41:	0f b6 c0             	movzbl %al,%eax
  802d44:	83 ec 04             	sub    $0x4,%esp
  802d47:	50                   	push   %eax
  802d48:	ff 75 0c             	pushl  0xc(%ebp)
  802d4b:	ff 75 08             	pushl  0x8(%ebp)
  802d4e:	e8 c2 f3 ff ff       	call   802115 <set_block_data>
  802d53:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802d56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d5a:	75 17                	jne    802d73 <realloc_block_FF+0x12e>
  802d5c:	83 ec 04             	sub    $0x4,%esp
  802d5f:	68 60 3e 80 00       	push   $0x803e60
  802d64:	68 db 01 00 00       	push   $0x1db
  802d69:	68 b7 3d 80 00       	push   $0x803db7
  802d6e:	e8 0c 06 00 00       	call   80337f <_panic>
  802d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	85 c0                	test   %eax,%eax
  802d7a:	74 10                	je     802d8c <realloc_block_FF+0x147>
  802d7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7f:	8b 00                	mov    (%eax),%eax
  802d81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d84:	8b 52 04             	mov    0x4(%edx),%edx
  802d87:	89 50 04             	mov    %edx,0x4(%eax)
  802d8a:	eb 0b                	jmp    802d97 <realloc_block_FF+0x152>
  802d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8f:	8b 40 04             	mov    0x4(%eax),%eax
  802d92:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	8b 40 04             	mov    0x4(%eax),%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 0f                	je     802db0 <realloc_block_FF+0x16b>
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	8b 40 04             	mov    0x4(%eax),%eax
  802da7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802daa:	8b 12                	mov    (%edx),%edx
  802dac:	89 10                	mov    %edx,(%eax)
  802dae:	eb 0a                	jmp    802dba <realloc_block_FF+0x175>
  802db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db3:	8b 00                	mov    (%eax),%eax
  802db5:	a3 48 50 98 00       	mov    %eax,0x985048
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcd:	a1 54 50 98 00       	mov    0x985054,%eax
  802dd2:	48                   	dec    %eax
  802dd3:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	e9 0c 03 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802de0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	01 d0                	add    %edx,%eax
  802de8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802deb:	0f 86 b2 01 00 00    	jbe    802fa3 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802dfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802e00:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802e03:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802e07:	0f 87 b8 00 00 00    	ja     802ec5 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802e0d:	83 ec 0c             	sub    $0xc,%esp
  802e10:	ff 75 08             	pushl  0x8(%ebp)
  802e13:	e8 9a f0 ff ff       	call   801eb2 <is_free_block>
  802e18:	83 c4 10             	add    $0x10,%esp
  802e1b:	84 c0                	test   %al,%al
  802e1d:	0f 94 c0             	sete   %al
  802e20:	0f b6 c0             	movzbl %al,%eax
  802e23:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802e26:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e29:	01 ca                	add    %ecx,%edx
  802e2b:	83 ec 04             	sub    $0x4,%esp
  802e2e:	50                   	push   %eax
  802e2f:	52                   	push   %edx
  802e30:	ff 75 08             	pushl  0x8(%ebp)
  802e33:	e8 dd f2 ff ff       	call   802115 <set_block_data>
  802e38:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802e3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3f:	75 17                	jne    802e58 <realloc_block_FF+0x213>
  802e41:	83 ec 04             	sub    $0x4,%esp
  802e44:	68 60 3e 80 00       	push   $0x803e60
  802e49:	68 e8 01 00 00       	push   $0x1e8
  802e4e:	68 b7 3d 80 00       	push   $0x803db7
  802e53:	e8 27 05 00 00       	call   80337f <_panic>
  802e58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5b:	8b 00                	mov    (%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 10                	je     802e71 <realloc_block_FF+0x22c>
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e69:	8b 52 04             	mov    0x4(%edx),%edx
  802e6c:	89 50 04             	mov    %edx,0x4(%eax)
  802e6f:	eb 0b                	jmp    802e7c <realloc_block_FF+0x237>
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	8b 40 04             	mov    0x4(%eax),%eax
  802e77:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	74 0f                	je     802e95 <realloc_block_FF+0x250>
  802e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8f:	8b 12                	mov    (%edx),%edx
  802e91:	89 10                	mov    %edx,(%eax)
  802e93:	eb 0a                	jmp    802e9f <realloc_block_FF+0x25a>
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	a3 48 50 98 00       	mov    %eax,0x985048
  802e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb2:	a1 54 50 98 00       	mov    0x985054,%eax
  802eb7:	48                   	dec    %eax
  802eb8:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	e9 27 02 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802ec5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec9:	75 17                	jne    802ee2 <realloc_block_FF+0x29d>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 60 3e 80 00       	push   $0x803e60
  802ed3:	68 ed 01 00 00       	push   $0x1ed
  802ed8:	68 b7 3d 80 00       	push   $0x803db7
  802edd:	e8 9d 04 00 00       	call   80337f <_panic>
  802ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee5:	8b 00                	mov    (%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 10                	je     802efb <realloc_block_FF+0x2b6>
  802eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eee:	8b 00                	mov    (%eax),%eax
  802ef0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef3:	8b 52 04             	mov    0x4(%edx),%edx
  802ef6:	89 50 04             	mov    %edx,0x4(%eax)
  802ef9:	eb 0b                	jmp    802f06 <realloc_block_FF+0x2c1>
  802efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efe:	8b 40 04             	mov    0x4(%eax),%eax
  802f01:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f09:	8b 40 04             	mov    0x4(%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 0f                	je     802f1f <realloc_block_FF+0x2da>
  802f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f13:	8b 40 04             	mov    0x4(%eax),%eax
  802f16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f19:	8b 12                	mov    (%edx),%edx
  802f1b:	89 10                	mov    %edx,(%eax)
  802f1d:	eb 0a                	jmp    802f29 <realloc_block_FF+0x2e4>
  802f1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	a3 48 50 98 00       	mov    %eax,0x985048
  802f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3c:	a1 54 50 98 00       	mov    0x985054,%eax
  802f41:	48                   	dec    %eax
  802f42:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  802f47:	8b 55 08             	mov    0x8(%ebp),%edx
  802f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4d:	01 d0                	add    %edx,%eax
  802f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	6a 00                	push   $0x0
  802f57:	ff 75 e0             	pushl  -0x20(%ebp)
  802f5a:	ff 75 f0             	pushl  -0x10(%ebp)
  802f5d:	e8 b3 f1 ff ff       	call   802115 <set_block_data>
  802f62:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  802f65:	83 ec 0c             	sub    $0xc,%esp
  802f68:	ff 75 08             	pushl  0x8(%ebp)
  802f6b:	e8 42 ef ff ff       	call   801eb2 <is_free_block>
  802f70:	83 c4 10             	add    $0x10,%esp
  802f73:	84 c0                	test   %al,%al
  802f75:	0f 94 c0             	sete   %al
  802f78:	0f b6 c0             	movzbl %al,%eax
  802f7b:	83 ec 04             	sub    $0x4,%esp
  802f7e:	50                   	push   %eax
  802f7f:	ff 75 0c             	pushl  0xc(%ebp)
  802f82:	ff 75 08             	pushl  0x8(%ebp)
  802f85:	e8 8b f1 ff ff       	call   802115 <set_block_data>
  802f8a:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  802f8d:	83 ec 0c             	sub    $0xc,%esp
  802f90:	ff 75 f0             	pushl  -0x10(%ebp)
  802f93:	e8 d4 f1 ff ff       	call   80216c <insert_sorted_in_freeList>
  802f98:	83 c4 10             	add    $0x10,%esp
					return va;
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	e9 49 01 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  802fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa6:	83 e8 08             	sub    $0x8,%eax
  802fa9:	83 ec 0c             	sub    $0xc,%esp
  802fac:	50                   	push   %eax
  802fad:	e8 4d f3 ff ff       	call   8022ff <alloc_block_FF>
  802fb2:	83 c4 10             	add    $0x10,%esp
  802fb5:	e9 32 01 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  802fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802fc0:	0f 83 21 01 00 00    	jae    8030e7 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  802fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc9:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fcc:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  802fcf:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  802fd3:	77 0e                	ja     802fe3 <realloc_block_FF+0x39e>
  802fd5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fd9:	75 08                	jne    802fe3 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	e9 09 01 00 00       	jmp    8030ec <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  802fe9:	83 ec 0c             	sub    $0xc,%esp
  802fec:	ff 75 08             	pushl  0x8(%ebp)
  802fef:	e8 be ee ff ff       	call   801eb2 <is_free_block>
  802ff4:	83 c4 10             	add    $0x10,%esp
  802ff7:	84 c0                	test   %al,%al
  802ff9:	0f 94 c0             	sete   %al
  802ffc:	0f b6 c0             	movzbl %al,%eax
  802fff:	83 ec 04             	sub    $0x4,%esp
  803002:	50                   	push   %eax
  803003:	ff 75 0c             	pushl  0xc(%ebp)
  803006:	ff 75 d8             	pushl  -0x28(%ebp)
  803009:	e8 07 f1 ff ff       	call   802115 <set_block_data>
  80300e:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803011:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803014:	8b 45 0c             	mov    0xc(%ebp),%eax
  803017:	01 d0                	add    %edx,%eax
  803019:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80301c:	83 ec 04             	sub    $0x4,%esp
  80301f:	6a 00                	push   $0x0
  803021:	ff 75 dc             	pushl  -0x24(%ebp)
  803024:	ff 75 d4             	pushl  -0x2c(%ebp)
  803027:	e8 e9 f0 ff ff       	call   802115 <set_block_data>
  80302c:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80302f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803033:	0f 84 9b 00 00 00    	je     8030d4 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803039:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80303c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303f:	01 d0                	add    %edx,%eax
  803041:	83 ec 04             	sub    $0x4,%esp
  803044:	6a 00                	push   $0x0
  803046:	50                   	push   %eax
  803047:	ff 75 d4             	pushl  -0x2c(%ebp)
  80304a:	e8 c6 f0 ff ff       	call   802115 <set_block_data>
  80304f:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803052:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803056:	75 17                	jne    80306f <realloc_block_FF+0x42a>
  803058:	83 ec 04             	sub    $0x4,%esp
  80305b:	68 60 3e 80 00       	push   $0x803e60
  803060:	68 10 02 00 00       	push   $0x210
  803065:	68 b7 3d 80 00       	push   $0x803db7
  80306a:	e8 10 03 00 00       	call   80337f <_panic>
  80306f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	85 c0                	test   %eax,%eax
  803076:	74 10                	je     803088 <realloc_block_FF+0x443>
  803078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803080:	8b 52 04             	mov    0x4(%edx),%edx
  803083:	89 50 04             	mov    %edx,0x4(%eax)
  803086:	eb 0b                	jmp    803093 <realloc_block_FF+0x44e>
  803088:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803093:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803096:	8b 40 04             	mov    0x4(%eax),%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	74 0f                	je     8030ac <realloc_block_FF+0x467>
  80309d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a0:	8b 40 04             	mov    0x4(%eax),%eax
  8030a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a6:	8b 12                	mov    (%edx),%edx
  8030a8:	89 10                	mov    %edx,(%eax)
  8030aa:	eb 0a                	jmp    8030b6 <realloc_block_FF+0x471>
  8030ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030af:	8b 00                	mov    (%eax),%eax
  8030b1:	a3 48 50 98 00       	mov    %eax,0x985048
  8030b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c9:	a1 54 50 98 00       	mov    0x985054,%eax
  8030ce:	48                   	dec    %eax
  8030cf:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8030d4:	83 ec 0c             	sub    $0xc,%esp
  8030d7:	ff 75 d4             	pushl  -0x2c(%ebp)
  8030da:	e8 8d f0 ff ff       	call   80216c <insert_sorted_in_freeList>
  8030df:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8030e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030e5:	eb 05                	jmp    8030ec <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8030e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030ec:	c9                   	leave  
  8030ed:	c3                   	ret    

008030ee <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8030ee:	55                   	push   %ebp
  8030ef:	89 e5                	mov    %esp,%ebp
  8030f1:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8030f4:	83 ec 04             	sub    $0x4,%esp
  8030f7:	68 80 3e 80 00       	push   $0x803e80
  8030fc:	68 20 02 00 00       	push   $0x220
  803101:	68 b7 3d 80 00       	push   $0x803db7
  803106:	e8 74 02 00 00       	call   80337f <_panic>

0080310b <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80310b:	55                   	push   %ebp
  80310c:	89 e5                	mov    %esp,%ebp
  80310e:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 a8 3e 80 00       	push   $0x803ea8
  803119:	68 28 02 00 00       	push   $0x228
  80311e:	68 b7 3d 80 00       	push   $0x803db7
  803123:	e8 57 02 00 00       	call   80337f <_panic>

00803128 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803128:	55                   	push   %ebp
  803129:	89 e5                	mov    %esp,%ebp
  80312b:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  80312e:	83 ec 04             	sub    $0x4,%esp
  803131:	6a 01                	push   $0x1
  803133:	6a 58                	push   $0x58
  803135:	ff 75 0c             	pushl  0xc(%ebp)
  803138:	e8 c1 e2 ff ff       	call   8013fe <smalloc>
  80313d:	83 c4 10             	add    $0x10,%esp
  803140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803147:	75 14                	jne    80315d <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  803149:	83 ec 04             	sub    $0x4,%esp
  80314c:	68 d0 3e 80 00       	push   $0x803ed0
  803151:	6a 10                	push   $0x10
  803153:	68 fe 3e 80 00       	push   $0x803efe
  803158:	e8 22 02 00 00       	call   80337f <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	83 ec 0c             	sub    $0xc,%esp
  803163:	50                   	push   %eax
  803164:	e8 bc ec ff ff       	call   801e25 <sys_init_queue>
  803169:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  80316c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	83 c0 18             	add    $0x18,%eax
  80317c:	83 ec 04             	sub    $0x4,%esp
  80317f:	6a 40                	push   $0x40
  803181:	ff 75 0c             	pushl  0xc(%ebp)
  803184:	50                   	push   %eax
  803185:	e8 1e d9 ff ff       	call   800aa8 <strncpy>
  80318a:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  80318d:	8b 55 10             	mov    0x10(%ebp),%edx
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803199:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a2:	89 10                	mov    %edx,(%eax)
}
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	c9                   	leave  
  8031a8:	c2 04 00             	ret    $0x4

008031ab <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8031ab:	55                   	push   %ebp
  8031ac:	89 e5                	mov    %esp,%ebp
  8031ae:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  8031b1:	83 ec 08             	sub    $0x8,%esp
  8031b4:	ff 75 10             	pushl  0x10(%ebp)
  8031b7:	ff 75 0c             	pushl  0xc(%ebp)
  8031ba:	e8 da e3 ff ff       	call   801599 <sget>
  8031bf:	83 c4 10             	add    $0x10,%esp
  8031c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8031c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c9:	75 14                	jne    8031df <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  8031cb:	83 ec 04             	sub    $0x4,%esp
  8031ce:	68 10 3f 80 00       	push   $0x803f10
  8031d3:	6a 2c                	push   $0x2c
  8031d5:	68 fe 3e 80 00       	push   $0x803efe
  8031da:	e8 a0 01 00 00       	call   80337f <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  8031df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031eb:	89 10                	mov    %edx,(%eax)
}
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	c9                   	leave  
  8031f1:	c2 04 00             	ret    $0x4

008031f4 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  8031f4:	55                   	push   %ebp
  8031f5:	89 e5                	mov    %esp,%ebp
  8031f7:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  8031fa:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	8b 40 14             	mov    0x14(%eax),%eax
  803207:	8d 55 e8             	lea    -0x18(%ebp),%edx
  80320a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80320d:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  803210:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803213:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803216:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803219:	f0 87 02             	lock xchg %eax,(%edx)
  80321c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  80321f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803222:	85 c0                	test   %eax,%eax
  803224:	75 db                	jne    803201 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	8b 50 10             	mov    0x10(%eax),%edx
  80322c:	4a                   	dec    %edx
  80322d:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 40 10             	mov    0x10(%eax),%eax
  803236:	85 c0                	test   %eax,%eax
  803238:	79 18                	jns    803252 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  80323a:	8b 45 08             	mov    0x8(%ebp),%eax
  80323d:	8d 50 14             	lea    0x14(%eax),%edx
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	83 ec 08             	sub    $0x8,%esp
  803246:	52                   	push   %edx
  803247:	50                   	push   %eax
  803248:	e8 f4 eb ff ff       	call   801e41 <sys_block_process>
  80324d:	83 c4 10             	add    $0x10,%esp
  803250:	eb 0a                	jmp    80325c <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  80325c:	c9                   	leave  
  80325d:	c3                   	ret    

0080325e <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  80325e:	55                   	push   %ebp
  80325f:	89 e5                	mov    %esp,%ebp
  803261:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803264:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	8b 40 14             	mov    0x14(%eax),%eax
  803271:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803274:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803277:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80327a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803280:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803283:	f0 87 02             	lock xchg %eax,(%edx)
  803286:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803289:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	75 db                	jne    80326b <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	8b 50 10             	mov    0x10(%eax),%edx
  803296:	42                   	inc    %edx
  803297:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 40 10             	mov    0x10(%eax),%eax
  8032a0:	85 c0                	test   %eax,%eax
  8032a2:	7f 0f                	jg     8032b3 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	83 ec 0c             	sub    $0xc,%esp
  8032aa:	50                   	push   %eax
  8032ab:	e8 af eb ff ff       	call   801e5f <sys_unblock_process>
  8032b0:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8032bd:	90                   	nop
  8032be:	c9                   	leave  
  8032bf:	c3                   	ret    

008032c0 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  8032c0:	55                   	push   %ebp
  8032c1:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	8b 40 10             	mov    0x10(%eax),%eax
}
  8032c9:	5d                   	pop    %ebp
  8032ca:	c3                   	ret    

008032cb <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032cb:	55                   	push   %ebp
  8032cc:	89 e5                	mov    %esp,%ebp
  8032ce:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d4:	89 d0                	mov    %edx,%eax
  8032d6:	c1 e0 02             	shl    $0x2,%eax
  8032d9:	01 d0                	add    %edx,%eax
  8032db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032e2:	01 d0                	add    %edx,%eax
  8032e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032eb:	01 d0                	add    %edx,%eax
  8032ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f4:	01 d0                	add    %edx,%eax
  8032f6:	c1 e0 04             	shl    $0x4,%eax
  8032f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803303:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803306:	83 ec 0c             	sub    $0xc,%esp
  803309:	50                   	push   %eax
  80330a:	e8 22 e8 ff ff       	call   801b31 <sys_get_virtual_time>
  80330f:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803312:	eb 41                	jmp    803355 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803314:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803317:	83 ec 0c             	sub    $0xc,%esp
  80331a:	50                   	push   %eax
  80331b:	e8 11 e8 ff ff       	call   801b31 <sys_get_virtual_time>
  803320:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803323:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803326:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803329:	29 c2                	sub    %eax,%edx
  80332b:	89 d0                	mov    %edx,%eax
  80332d:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803333:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803336:	89 d1                	mov    %edx,%ecx
  803338:	29 c1                	sub    %eax,%ecx
  80333a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80333d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803340:	39 c2                	cmp    %eax,%edx
  803342:	0f 97 c0             	seta   %al
  803345:	0f b6 c0             	movzbl %al,%eax
  803348:	29 c1                	sub    %eax,%ecx
  80334a:	89 c8                	mov    %ecx,%eax
  80334c:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80334f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803352:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80335b:	72 b7                	jb     803314 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80335d:	90                   	nop
  80335e:	c9                   	leave  
  80335f:	c3                   	ret    

00803360 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803360:	55                   	push   %ebp
  803361:	89 e5                	mov    %esp,%ebp
  803363:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80336d:	eb 03                	jmp    803372 <busy_wait+0x12>
  80336f:	ff 45 fc             	incl   -0x4(%ebp)
  803372:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803375:	3b 45 08             	cmp    0x8(%ebp),%eax
  803378:	72 f5                	jb     80336f <busy_wait+0xf>
	return i;
  80337a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80337d:	c9                   	leave  
  80337e:	c3                   	ret    

0080337f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80337f:	55                   	push   %ebp
  803380:	89 e5                	mov    %esp,%ebp
  803382:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803385:	8d 45 10             	lea    0x10(%ebp),%eax
  803388:	83 c0 04             	add    $0x4,%eax
  80338b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80338e:	a1 60 50 98 00       	mov    0x985060,%eax
  803393:	85 c0                	test   %eax,%eax
  803395:	74 16                	je     8033ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  803397:	a1 60 50 98 00       	mov    0x985060,%eax
  80339c:	83 ec 08             	sub    $0x8,%esp
  80339f:	50                   	push   %eax
  8033a0:	68 34 3f 80 00       	push   $0x803f34
  8033a5:	e8 ed cf ff ff       	call   800397 <cprintf>
  8033aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033ad:	a1 04 50 80 00       	mov    0x805004,%eax
  8033b2:	ff 75 0c             	pushl  0xc(%ebp)
  8033b5:	ff 75 08             	pushl  0x8(%ebp)
  8033b8:	50                   	push   %eax
  8033b9:	68 39 3f 80 00       	push   $0x803f39
  8033be:	e8 d4 cf ff ff       	call   800397 <cprintf>
  8033c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8033c9:	83 ec 08             	sub    $0x8,%esp
  8033cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8033cf:	50                   	push   %eax
  8033d0:	e8 57 cf ff ff       	call   80032c <vcprintf>
  8033d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033d8:	83 ec 08             	sub    $0x8,%esp
  8033db:	6a 00                	push   $0x0
  8033dd:	68 55 3f 80 00       	push   $0x803f55
  8033e2:	e8 45 cf ff ff       	call   80032c <vcprintf>
  8033e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033ea:	e8 c6 ce ff ff       	call   8002b5 <exit>

	// should not return here
	while (1) ;
  8033ef:	eb fe                	jmp    8033ef <_panic+0x70>

008033f1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033f1:	55                   	push   %ebp
  8033f2:	89 e5                	mov    %esp,%ebp
  8033f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8033f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8033fc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803402:	8b 45 0c             	mov    0xc(%ebp),%eax
  803405:	39 c2                	cmp    %eax,%edx
  803407:	74 14                	je     80341d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803409:	83 ec 04             	sub    $0x4,%esp
  80340c:	68 58 3f 80 00       	push   $0x803f58
  803411:	6a 26                	push   $0x26
  803413:	68 a4 3f 80 00       	push   $0x803fa4
  803418:	e8 62 ff ff ff       	call   80337f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80341d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803424:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80342b:	e9 c5 00 00 00       	jmp    8034f5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  803430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	01 d0                	add    %edx,%eax
  80343f:	8b 00                	mov    (%eax),%eax
  803441:	85 c0                	test   %eax,%eax
  803443:	75 08                	jne    80344d <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803445:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803448:	e9 a5 00 00 00       	jmp    8034f2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80344d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803454:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80345b:	eb 69                	jmp    8034c6 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80345d:	a1 20 50 80 00       	mov    0x805020,%eax
  803462:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803468:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80346b:	89 d0                	mov    %edx,%eax
  80346d:	01 c0                	add    %eax,%eax
  80346f:	01 d0                	add    %edx,%eax
  803471:	c1 e0 03             	shl    $0x3,%eax
  803474:	01 c8                	add    %ecx,%eax
  803476:	8a 40 04             	mov    0x4(%eax),%al
  803479:	84 c0                	test   %al,%al
  80347b:	75 46                	jne    8034c3 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80347d:	a1 20 50 80 00       	mov    0x805020,%eax
  803482:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803488:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348b:	89 d0                	mov    %edx,%eax
  80348d:	01 c0                	add    %eax,%eax
  80348f:	01 d0                	add    %edx,%eax
  803491:	c1 e0 03             	shl    $0x3,%eax
  803494:	01 c8                	add    %ecx,%eax
  803496:	8b 00                	mov    (%eax),%eax
  803498:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80349b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80349e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	01 c8                	add    %ecx,%eax
  8034b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034b6:	39 c2                	cmp    %eax,%edx
  8034b8:	75 09                	jne    8034c3 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8034ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034c1:	eb 15                	jmp    8034d8 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034c3:	ff 45 e8             	incl   -0x18(%ebp)
  8034c6:	a1 20 50 80 00       	mov    0x805020,%eax
  8034cb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8034d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d4:	39 c2                	cmp    %eax,%edx
  8034d6:	77 85                	ja     80345d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034dc:	75 14                	jne    8034f2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8034de:	83 ec 04             	sub    $0x4,%esp
  8034e1:	68 b0 3f 80 00       	push   $0x803fb0
  8034e6:	6a 3a                	push   $0x3a
  8034e8:	68 a4 3f 80 00       	push   $0x803fa4
  8034ed:	e8 8d fe ff ff       	call   80337f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034f2:	ff 45 f0             	incl   -0x10(%ebp)
  8034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034fb:	0f 8c 2f ff ff ff    	jl     803430 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803501:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803508:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80350f:	eb 26                	jmp    803537 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803511:	a1 20 50 80 00       	mov    0x805020,%eax
  803516:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80351c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80351f:	89 d0                	mov    %edx,%eax
  803521:	01 c0                	add    %eax,%eax
  803523:	01 d0                	add    %edx,%eax
  803525:	c1 e0 03             	shl    $0x3,%eax
  803528:	01 c8                	add    %ecx,%eax
  80352a:	8a 40 04             	mov    0x4(%eax),%al
  80352d:	3c 01                	cmp    $0x1,%al
  80352f:	75 03                	jne    803534 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803531:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803534:	ff 45 e0             	incl   -0x20(%ebp)
  803537:	a1 20 50 80 00       	mov    0x805020,%eax
  80353c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803542:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803545:	39 c2                	cmp    %eax,%edx
  803547:	77 c8                	ja     803511 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80354f:	74 14                	je     803565 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803551:	83 ec 04             	sub    $0x4,%esp
  803554:	68 04 40 80 00       	push   $0x804004
  803559:	6a 44                	push   $0x44
  80355b:	68 a4 3f 80 00       	push   $0x803fa4
  803560:	e8 1a fe ff ff       	call   80337f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803565:	90                   	nop
  803566:	c9                   	leave  
  803567:	c3                   	ret    

00803568 <__udivdi3>:
  803568:	55                   	push   %ebp
  803569:	57                   	push   %edi
  80356a:	56                   	push   %esi
  80356b:	53                   	push   %ebx
  80356c:	83 ec 1c             	sub    $0x1c,%esp
  80356f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803573:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803577:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80357b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80357f:	89 ca                	mov    %ecx,%edx
  803581:	89 f8                	mov    %edi,%eax
  803583:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803587:	85 f6                	test   %esi,%esi
  803589:	75 2d                	jne    8035b8 <__udivdi3+0x50>
  80358b:	39 cf                	cmp    %ecx,%edi
  80358d:	77 65                	ja     8035f4 <__udivdi3+0x8c>
  80358f:	89 fd                	mov    %edi,%ebp
  803591:	85 ff                	test   %edi,%edi
  803593:	75 0b                	jne    8035a0 <__udivdi3+0x38>
  803595:	b8 01 00 00 00       	mov    $0x1,%eax
  80359a:	31 d2                	xor    %edx,%edx
  80359c:	f7 f7                	div    %edi
  80359e:	89 c5                	mov    %eax,%ebp
  8035a0:	31 d2                	xor    %edx,%edx
  8035a2:	89 c8                	mov    %ecx,%eax
  8035a4:	f7 f5                	div    %ebp
  8035a6:	89 c1                	mov    %eax,%ecx
  8035a8:	89 d8                	mov    %ebx,%eax
  8035aa:	f7 f5                	div    %ebp
  8035ac:	89 cf                	mov    %ecx,%edi
  8035ae:	89 fa                	mov    %edi,%edx
  8035b0:	83 c4 1c             	add    $0x1c,%esp
  8035b3:	5b                   	pop    %ebx
  8035b4:	5e                   	pop    %esi
  8035b5:	5f                   	pop    %edi
  8035b6:	5d                   	pop    %ebp
  8035b7:	c3                   	ret    
  8035b8:	39 ce                	cmp    %ecx,%esi
  8035ba:	77 28                	ja     8035e4 <__udivdi3+0x7c>
  8035bc:	0f bd fe             	bsr    %esi,%edi
  8035bf:	83 f7 1f             	xor    $0x1f,%edi
  8035c2:	75 40                	jne    803604 <__udivdi3+0x9c>
  8035c4:	39 ce                	cmp    %ecx,%esi
  8035c6:	72 0a                	jb     8035d2 <__udivdi3+0x6a>
  8035c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035cc:	0f 87 9e 00 00 00    	ja     803670 <__udivdi3+0x108>
  8035d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8035d7:	89 fa                	mov    %edi,%edx
  8035d9:	83 c4 1c             	add    $0x1c,%esp
  8035dc:	5b                   	pop    %ebx
  8035dd:	5e                   	pop    %esi
  8035de:	5f                   	pop    %edi
  8035df:	5d                   	pop    %ebp
  8035e0:	c3                   	ret    
  8035e1:	8d 76 00             	lea    0x0(%esi),%esi
  8035e4:	31 ff                	xor    %edi,%edi
  8035e6:	31 c0                	xor    %eax,%eax
  8035e8:	89 fa                	mov    %edi,%edx
  8035ea:	83 c4 1c             	add    $0x1c,%esp
  8035ed:	5b                   	pop    %ebx
  8035ee:	5e                   	pop    %esi
  8035ef:	5f                   	pop    %edi
  8035f0:	5d                   	pop    %ebp
  8035f1:	c3                   	ret    
  8035f2:	66 90                	xchg   %ax,%ax
  8035f4:	89 d8                	mov    %ebx,%eax
  8035f6:	f7 f7                	div    %edi
  8035f8:	31 ff                	xor    %edi,%edi
  8035fa:	89 fa                	mov    %edi,%edx
  8035fc:	83 c4 1c             	add    $0x1c,%esp
  8035ff:	5b                   	pop    %ebx
  803600:	5e                   	pop    %esi
  803601:	5f                   	pop    %edi
  803602:	5d                   	pop    %ebp
  803603:	c3                   	ret    
  803604:	bd 20 00 00 00       	mov    $0x20,%ebp
  803609:	89 eb                	mov    %ebp,%ebx
  80360b:	29 fb                	sub    %edi,%ebx
  80360d:	89 f9                	mov    %edi,%ecx
  80360f:	d3 e6                	shl    %cl,%esi
  803611:	89 c5                	mov    %eax,%ebp
  803613:	88 d9                	mov    %bl,%cl
  803615:	d3 ed                	shr    %cl,%ebp
  803617:	89 e9                	mov    %ebp,%ecx
  803619:	09 f1                	or     %esi,%ecx
  80361b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80361f:	89 f9                	mov    %edi,%ecx
  803621:	d3 e0                	shl    %cl,%eax
  803623:	89 c5                	mov    %eax,%ebp
  803625:	89 d6                	mov    %edx,%esi
  803627:	88 d9                	mov    %bl,%cl
  803629:	d3 ee                	shr    %cl,%esi
  80362b:	89 f9                	mov    %edi,%ecx
  80362d:	d3 e2                	shl    %cl,%edx
  80362f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803633:	88 d9                	mov    %bl,%cl
  803635:	d3 e8                	shr    %cl,%eax
  803637:	09 c2                	or     %eax,%edx
  803639:	89 d0                	mov    %edx,%eax
  80363b:	89 f2                	mov    %esi,%edx
  80363d:	f7 74 24 0c          	divl   0xc(%esp)
  803641:	89 d6                	mov    %edx,%esi
  803643:	89 c3                	mov    %eax,%ebx
  803645:	f7 e5                	mul    %ebp
  803647:	39 d6                	cmp    %edx,%esi
  803649:	72 19                	jb     803664 <__udivdi3+0xfc>
  80364b:	74 0b                	je     803658 <__udivdi3+0xf0>
  80364d:	89 d8                	mov    %ebx,%eax
  80364f:	31 ff                	xor    %edi,%edi
  803651:	e9 58 ff ff ff       	jmp    8035ae <__udivdi3+0x46>
  803656:	66 90                	xchg   %ax,%ax
  803658:	8b 54 24 08          	mov    0x8(%esp),%edx
  80365c:	89 f9                	mov    %edi,%ecx
  80365e:	d3 e2                	shl    %cl,%edx
  803660:	39 c2                	cmp    %eax,%edx
  803662:	73 e9                	jae    80364d <__udivdi3+0xe5>
  803664:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803667:	31 ff                	xor    %edi,%edi
  803669:	e9 40 ff ff ff       	jmp    8035ae <__udivdi3+0x46>
  80366e:	66 90                	xchg   %ax,%ax
  803670:	31 c0                	xor    %eax,%eax
  803672:	e9 37 ff ff ff       	jmp    8035ae <__udivdi3+0x46>
  803677:	90                   	nop

00803678 <__umoddi3>:
  803678:	55                   	push   %ebp
  803679:	57                   	push   %edi
  80367a:	56                   	push   %esi
  80367b:	53                   	push   %ebx
  80367c:	83 ec 1c             	sub    $0x1c,%esp
  80367f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803683:	8b 74 24 34          	mov    0x34(%esp),%esi
  803687:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80368b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80368f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803693:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803697:	89 f3                	mov    %esi,%ebx
  803699:	89 fa                	mov    %edi,%edx
  80369b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369f:	89 34 24             	mov    %esi,(%esp)
  8036a2:	85 c0                	test   %eax,%eax
  8036a4:	75 1a                	jne    8036c0 <__umoddi3+0x48>
  8036a6:	39 f7                	cmp    %esi,%edi
  8036a8:	0f 86 a2 00 00 00    	jbe    803750 <__umoddi3+0xd8>
  8036ae:	89 c8                	mov    %ecx,%eax
  8036b0:	89 f2                	mov    %esi,%edx
  8036b2:	f7 f7                	div    %edi
  8036b4:	89 d0                	mov    %edx,%eax
  8036b6:	31 d2                	xor    %edx,%edx
  8036b8:	83 c4 1c             	add    $0x1c,%esp
  8036bb:	5b                   	pop    %ebx
  8036bc:	5e                   	pop    %esi
  8036bd:	5f                   	pop    %edi
  8036be:	5d                   	pop    %ebp
  8036bf:	c3                   	ret    
  8036c0:	39 f0                	cmp    %esi,%eax
  8036c2:	0f 87 ac 00 00 00    	ja     803774 <__umoddi3+0xfc>
  8036c8:	0f bd e8             	bsr    %eax,%ebp
  8036cb:	83 f5 1f             	xor    $0x1f,%ebp
  8036ce:	0f 84 ac 00 00 00    	je     803780 <__umoddi3+0x108>
  8036d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8036d9:	29 ef                	sub    %ebp,%edi
  8036db:	89 fe                	mov    %edi,%esi
  8036dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036e1:	89 e9                	mov    %ebp,%ecx
  8036e3:	d3 e0                	shl    %cl,%eax
  8036e5:	89 d7                	mov    %edx,%edi
  8036e7:	89 f1                	mov    %esi,%ecx
  8036e9:	d3 ef                	shr    %cl,%edi
  8036eb:	09 c7                	or     %eax,%edi
  8036ed:	89 e9                	mov    %ebp,%ecx
  8036ef:	d3 e2                	shl    %cl,%edx
  8036f1:	89 14 24             	mov    %edx,(%esp)
  8036f4:	89 d8                	mov    %ebx,%eax
  8036f6:	d3 e0                	shl    %cl,%eax
  8036f8:	89 c2                	mov    %eax,%edx
  8036fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036fe:	d3 e0                	shl    %cl,%eax
  803700:	89 44 24 04          	mov    %eax,0x4(%esp)
  803704:	8b 44 24 08          	mov    0x8(%esp),%eax
  803708:	89 f1                	mov    %esi,%ecx
  80370a:	d3 e8                	shr    %cl,%eax
  80370c:	09 d0                	or     %edx,%eax
  80370e:	d3 eb                	shr    %cl,%ebx
  803710:	89 da                	mov    %ebx,%edx
  803712:	f7 f7                	div    %edi
  803714:	89 d3                	mov    %edx,%ebx
  803716:	f7 24 24             	mull   (%esp)
  803719:	89 c6                	mov    %eax,%esi
  80371b:	89 d1                	mov    %edx,%ecx
  80371d:	39 d3                	cmp    %edx,%ebx
  80371f:	0f 82 87 00 00 00    	jb     8037ac <__umoddi3+0x134>
  803725:	0f 84 91 00 00 00    	je     8037bc <__umoddi3+0x144>
  80372b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80372f:	29 f2                	sub    %esi,%edx
  803731:	19 cb                	sbb    %ecx,%ebx
  803733:	89 d8                	mov    %ebx,%eax
  803735:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803739:	d3 e0                	shl    %cl,%eax
  80373b:	89 e9                	mov    %ebp,%ecx
  80373d:	d3 ea                	shr    %cl,%edx
  80373f:	09 d0                	or     %edx,%eax
  803741:	89 e9                	mov    %ebp,%ecx
  803743:	d3 eb                	shr    %cl,%ebx
  803745:	89 da                	mov    %ebx,%edx
  803747:	83 c4 1c             	add    $0x1c,%esp
  80374a:	5b                   	pop    %ebx
  80374b:	5e                   	pop    %esi
  80374c:	5f                   	pop    %edi
  80374d:	5d                   	pop    %ebp
  80374e:	c3                   	ret    
  80374f:	90                   	nop
  803750:	89 fd                	mov    %edi,%ebp
  803752:	85 ff                	test   %edi,%edi
  803754:	75 0b                	jne    803761 <__umoddi3+0xe9>
  803756:	b8 01 00 00 00       	mov    $0x1,%eax
  80375b:	31 d2                	xor    %edx,%edx
  80375d:	f7 f7                	div    %edi
  80375f:	89 c5                	mov    %eax,%ebp
  803761:	89 f0                	mov    %esi,%eax
  803763:	31 d2                	xor    %edx,%edx
  803765:	f7 f5                	div    %ebp
  803767:	89 c8                	mov    %ecx,%eax
  803769:	f7 f5                	div    %ebp
  80376b:	89 d0                	mov    %edx,%eax
  80376d:	e9 44 ff ff ff       	jmp    8036b6 <__umoddi3+0x3e>
  803772:	66 90                	xchg   %ax,%ax
  803774:	89 c8                	mov    %ecx,%eax
  803776:	89 f2                	mov    %esi,%edx
  803778:	83 c4 1c             	add    $0x1c,%esp
  80377b:	5b                   	pop    %ebx
  80377c:	5e                   	pop    %esi
  80377d:	5f                   	pop    %edi
  80377e:	5d                   	pop    %ebp
  80377f:	c3                   	ret    
  803780:	3b 04 24             	cmp    (%esp),%eax
  803783:	72 06                	jb     80378b <__umoddi3+0x113>
  803785:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803789:	77 0f                	ja     80379a <__umoddi3+0x122>
  80378b:	89 f2                	mov    %esi,%edx
  80378d:	29 f9                	sub    %edi,%ecx
  80378f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803793:	89 14 24             	mov    %edx,(%esp)
  803796:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80379a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80379e:	8b 14 24             	mov    (%esp),%edx
  8037a1:	83 c4 1c             	add    $0x1c,%esp
  8037a4:	5b                   	pop    %ebx
  8037a5:	5e                   	pop    %esi
  8037a6:	5f                   	pop    %edi
  8037a7:	5d                   	pop    %ebp
  8037a8:	c3                   	ret    
  8037a9:	8d 76 00             	lea    0x0(%esi),%esi
  8037ac:	2b 04 24             	sub    (%esp),%eax
  8037af:	19 fa                	sbb    %edi,%edx
  8037b1:	89 d1                	mov    %edx,%ecx
  8037b3:	89 c6                	mov    %eax,%esi
  8037b5:	e9 71 ff ff ff       	jmp    80372b <__umoddi3+0xb3>
  8037ba:	66 90                	xchg   %ax,%ax
  8037bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037c0:	72 ea                	jb     8037ac <__umoddi3+0x134>
  8037c2:	89 d9                	mov    %ebx,%ecx
  8037c4:	e9 62 ff ff ff       	jmp    80372b <__umoddi3+0xb3>
