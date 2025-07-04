
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 47 01 00 00       	call   80017d <libmain>
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
  80003e:	e8 ba 1a 00 00       	call   801afd <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 e0 37 80 00       	push   $0x8037e0
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 42 15 00 00       	call   801598 <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 e2 37 80 00       	push   $0x8037e2
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 2c 15 00 00       	call   801598 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 e9 37 80 00       	push   $0x8037e9
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 16 15 00 00       	call   801598 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	struct semaphore T ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 25                	jne    8000b7 <_main+0x7f>
	{
		T = get_semaphore(parentenvID, "T");
  800092:	8d 45 c4             	lea    -0x3c(%ebp),%eax
  800095:	83 ec 04             	sub    $0x4,%esp
  800098:	68 f7 37 80 00       	push   $0x8037f7
  80009d:	ff 75 f4             	pushl  -0xc(%ebp)
  8000a0:	50                   	push   %eax
  8000a1:	e8 04 31 00 00       	call   8031aa <get_semaphore>
  8000a6:	83 c4 0c             	add    $0xc,%esp
		wait_semaphore(T);
  8000a9:	83 ec 0c             	sub    $0xc,%esp
  8000ac:	ff 75 c4             	pushl  -0x3c(%ebp)
  8000af:	e8 3f 31 00 00       	call   8031f3 <wait_semaphore>
  8000b4:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000b7:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	50                   	push   %eax
  8000be:	e8 6d 1a 00 00       	call   801b30 <sys_get_virtual_time>
  8000c3:	83 c4 0c             	add    $0xc,%esp
  8000c6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000c9:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d3:	f7 f1                	div    %ecx
  8000d5:	89 d0                	mov    %edx,%eax
  8000d7:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 df 31 00 00       	call   8032ca <env_sleep>
  8000eb:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000f1:	8b 00                	mov    (%eax),%eax
  8000f3:	40                   	inc    %eax
  8000f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000f7:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 2d 1a 00 00       	call   801b30 <sys_get_virtual_time>
  800103:	83 c4 0c             	add    $0xc,%esp
  800106:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800109:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80010e:	ba 00 00 00 00       	mov    $0x0,%edx
  800113:	f7 f1                	div    %ecx
  800115:	89 d0                	mov    %edx,%eax
  800117:	05 d0 07 00 00       	add    $0x7d0,%eax
  80011c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80011f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	50                   	push   %eax
  800126:	e8 9f 31 00 00       	call   8032ca <env_sleep>
  80012b:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80012e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800131:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800134:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800136:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	50                   	push   %eax
  80013d:	e8 ee 19 00 00       	call   801b30 <sys_get_virtual_time>
  800142:	83 c4 0c             	add    $0xc,%esp
  800145:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800148:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80014d:	ba 00 00 00 00       	mov    $0x0,%edx
  800152:	f7 f1                	div    %ecx
  800154:	89 d0                	mov    %edx,%eax
  800156:	05 d0 07 00 00       	add    $0x7d0,%eax
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80015e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	50                   	push   %eax
  800165:	e8 60 31 00 00       	call   8032ca <env_sleep>
  80016a:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80016d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800170:	8b 00                	mov    (%eax),%eax
  800172:	8d 50 01             	lea    0x1(%eax),%edx
  800175:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800178:	89 10                	mov    %edx,(%eax)

}
  80017a:	90                   	nop
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    

0080017d <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800183:	e8 5c 19 00 00       	call   801ae4 <sys_getenvindex>
  800188:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80018b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018e:	89 d0                	mov    %edx,%eax
  800190:	c1 e0 02             	shl    $0x2,%eax
  800193:	01 d0                	add    %edx,%eax
  800195:	c1 e0 03             	shl    $0x3,%eax
  800198:	01 d0                	add    %edx,%eax
  80019a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8001a1:	01 d0                	add    %edx,%eax
  8001a3:	c1 e0 02             	shl    $0x2,%eax
  8001a6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ab:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b0:	a1 20 50 80 00       	mov    0x805020,%eax
  8001b5:	8a 40 20             	mov    0x20(%eax),%al
  8001b8:	84 c0                	test   %al,%al
  8001ba:	74 0d                	je     8001c9 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8001bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8001c1:	83 c0 20             	add    $0x20,%eax
  8001c4:	a3 04 50 80 00       	mov    %eax,0x805004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001cd:	7e 0a                	jle    8001d9 <libmain+0x5c>
		binaryname = argv[0];
  8001cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	a3 04 50 80 00       	mov    %eax,0x805004

	// call user main routine
	_main(argc, argv);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 0c             	pushl  0xc(%ebp)
  8001df:	ff 75 08             	pushl  0x8(%ebp)
  8001e2:	e8 51 fe ff ff       	call   800038 <_main>
  8001e7:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8001ea:	a1 00 50 80 00       	mov    0x805000,%eax
  8001ef:	85 c0                	test   %eax,%eax
  8001f1:	0f 84 9f 00 00 00    	je     800296 <libmain+0x119>
	{
		sys_lock_cons();
  8001f7:	e8 6c 16 00 00       	call   801868 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8001fc:	83 ec 0c             	sub    $0xc,%esp
  8001ff:	68 14 38 80 00       	push   $0x803814
  800204:	e8 8d 01 00 00       	call   800396 <cprintf>
  800209:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80020c:	a1 20 50 80 00       	mov    0x805020,%eax
  800211:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800217:	a1 20 50 80 00       	mov    0x805020,%eax
  80021c:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800222:	83 ec 04             	sub    $0x4,%esp
  800225:	52                   	push   %edx
  800226:	50                   	push   %eax
  800227:	68 3c 38 80 00       	push   $0x80383c
  80022c:	e8 65 01 00 00       	call   800396 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800234:	a1 20 50 80 00       	mov    0x805020,%eax
  800239:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80023f:	a1 20 50 80 00       	mov    0x805020,%eax
  800244:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80024a:	a1 20 50 80 00       	mov    0x805020,%eax
  80024f:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800255:	51                   	push   %ecx
  800256:	52                   	push   %edx
  800257:	50                   	push   %eax
  800258:	68 64 38 80 00       	push   $0x803864
  80025d:	e8 34 01 00 00       	call   800396 <cprintf>
  800262:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800265:	a1 20 50 80 00       	mov    0x805020,%eax
  80026a:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800270:	83 ec 08             	sub    $0x8,%esp
  800273:	50                   	push   %eax
  800274:	68 bc 38 80 00       	push   $0x8038bc
  800279:	e8 18 01 00 00       	call   800396 <cprintf>
  80027e:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800281:	83 ec 0c             	sub    $0xc,%esp
  800284:	68 14 38 80 00       	push   $0x803814
  800289:	e8 08 01 00 00       	call   800396 <cprintf>
  80028e:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800291:	e8 ec 15 00 00       	call   801882 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800296:	e8 19 00 00 00       	call   8002b4 <exit>
}
  80029b:	90                   	nop
  80029c:	c9                   	leave  
  80029d:	c3                   	ret    

0080029e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	6a 00                	push   $0x0
  8002a9:	e8 02 18 00 00       	call   801ab0 <sys_destroy_env>
  8002ae:	83 c4 10             	add    $0x10,%esp
}
  8002b1:	90                   	nop
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <exit>:

void
exit(void)
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ba:	e8 57 18 00 00       	call   801b16 <sys_exit_env>
}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8002d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002d3:	89 0a                	mov    %ecx,(%edx)
  8002d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d8:	88 d1                	mov    %dl,%cl
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e4:	8b 00                	mov    (%eax),%eax
  8002e6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002eb:	75 2c                	jne    800319 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002ed:	a0 44 50 98 00       	mov    0x985044,%al
  8002f2:	0f b6 c0             	movzbl %al,%eax
  8002f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f8:	8b 12                	mov    (%edx),%edx
  8002fa:	89 d1                	mov    %edx,%ecx
  8002fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ff:	83 c2 08             	add    $0x8,%edx
  800302:	83 ec 04             	sub    $0x4,%esp
  800305:	50                   	push   %eax
  800306:	51                   	push   %ecx
  800307:	52                   	push   %edx
  800308:	e8 19 15 00 00       	call   801826 <sys_cputs>
  80030d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031c:	8b 40 04             	mov    0x4(%eax),%eax
  80031f:	8d 50 01             	lea    0x1(%eax),%edx
  800322:	8b 45 0c             	mov    0xc(%ebp),%eax
  800325:	89 50 04             	mov    %edx,0x4(%eax)
}
  800328:	90                   	nop
  800329:	c9                   	leave  
  80032a:	c3                   	ret    

0080032b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800334:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80033b:	00 00 00 
	b.cnt = 0;
  80033e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800345:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800354:	50                   	push   %eax
  800355:	68 c2 02 80 00       	push   $0x8002c2
  80035a:	e8 11 02 00 00       	call   800570 <vprintfmt>
  80035f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800362:	a0 44 50 98 00       	mov    0x985044,%al
  800367:	0f b6 c0             	movzbl %al,%eax
  80036a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	50                   	push   %eax
  800374:	52                   	push   %edx
  800375:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80037b:	83 c0 08             	add    $0x8,%eax
  80037e:	50                   	push   %eax
  80037f:	e8 a2 14 00 00       	call   801826 <sys_cputs>
  800384:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800387:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
	return b.cnt;
  80038e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800394:	c9                   	leave  
  800395:	c3                   	ret    

00800396 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80039c:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
	va_start(ap, fmt);
  8003a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	83 ec 08             	sub    $0x8,%esp
  8003af:	ff 75 f4             	pushl  -0xc(%ebp)
  8003b2:	50                   	push   %eax
  8003b3:	e8 73 ff ff ff       	call   80032b <vcprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
  8003bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003c1:	c9                   	leave  
  8003c2:	c3                   	ret    

008003c3 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8003c9:	e8 9a 14 00 00       	call   801868 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8003ce:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	ff 75 f4             	pushl  -0xc(%ebp)
  8003dd:	50                   	push   %eax
  8003de:	e8 48 ff ff ff       	call   80032b <vcprintf>
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8003e9:	e8 94 14 00 00       	call   801882 <sys_unlock_cons>
	return cnt;
  8003ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003f1:	c9                   	leave  
  8003f2:	c3                   	ret    

008003f3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003f3:	55                   	push   %ebp
  8003f4:	89 e5                	mov    %esp,%ebp
  8003f6:	53                   	push   %ebx
  8003f7:	83 ec 14             	sub    $0x14,%esp
  8003fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800400:	8b 45 14             	mov    0x14(%ebp),%eax
  800403:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800406:	8b 45 18             	mov    0x18(%ebp),%eax
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
  80040e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800411:	77 55                	ja     800468 <printnum+0x75>
  800413:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800416:	72 05                	jb     80041d <printnum+0x2a>
  800418:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80041b:	77 4b                	ja     800468 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80041d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800420:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800423:	8b 45 18             	mov    0x18(%ebp),%eax
  800426:	ba 00 00 00 00       	mov    $0x0,%edx
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 f4             	pushl  -0xc(%ebp)
  800430:	ff 75 f0             	pushl  -0x10(%ebp)
  800433:	e8 30 31 00 00       	call   803568 <__udivdi3>
  800438:	83 c4 10             	add    $0x10,%esp
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	ff 75 20             	pushl  0x20(%ebp)
  800441:	53                   	push   %ebx
  800442:	ff 75 18             	pushl  0x18(%ebp)
  800445:	52                   	push   %edx
  800446:	50                   	push   %eax
  800447:	ff 75 0c             	pushl  0xc(%ebp)
  80044a:	ff 75 08             	pushl  0x8(%ebp)
  80044d:	e8 a1 ff ff ff       	call   8003f3 <printnum>
  800452:	83 c4 20             	add    $0x20,%esp
  800455:	eb 1a                	jmp    800471 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800457:	83 ec 08             	sub    $0x8,%esp
  80045a:	ff 75 0c             	pushl  0xc(%ebp)
  80045d:	ff 75 20             	pushl  0x20(%ebp)
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	ff d0                	call   *%eax
  800465:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800468:	ff 4d 1c             	decl   0x1c(%ebp)
  80046b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80046f:	7f e6                	jg     800457 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800471:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800474:	bb 00 00 00 00       	mov    $0x0,%ebx
  800479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80047c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80047f:	53                   	push   %ebx
  800480:	51                   	push   %ecx
  800481:	52                   	push   %edx
  800482:	50                   	push   %eax
  800483:	e8 f0 31 00 00       	call   803678 <__umoddi3>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	05 f4 3a 80 00       	add    $0x803af4,%eax
  800490:	8a 00                	mov    (%eax),%al
  800492:	0f be c0             	movsbl %al,%eax
  800495:	83 ec 08             	sub    $0x8,%esp
  800498:	ff 75 0c             	pushl  0xc(%ebp)
  80049b:	50                   	push   %eax
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	ff d0                	call   *%eax
  8004a1:	83 c4 10             	add    $0x10,%esp
}
  8004a4:	90                   	nop
  8004a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004a8:	c9                   	leave  
  8004a9:	c3                   	ret    

008004aa <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004aa:	55                   	push   %ebp
  8004ab:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004ad:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004b1:	7e 1c                	jle    8004cf <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	8d 50 08             	lea    0x8(%eax),%edx
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 10                	mov    %edx,(%eax)
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	83 e8 08             	sub    $0x8,%eax
  8004c8:	8b 50 04             	mov    0x4(%eax),%edx
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	eb 40                	jmp    80050f <getuint+0x65>
	else if (lflag)
  8004cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004d3:	74 1e                	je     8004f3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	8b 00                	mov    (%eax),%eax
  8004da:	8d 50 04             	lea    0x4(%eax),%edx
  8004dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e0:	89 10                	mov    %edx,(%eax)
  8004e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	83 e8 04             	sub    $0x4,%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8004f1:	eb 1c                	jmp    80050f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f6:	8b 00                	mov    (%eax),%eax
  8004f8:	8d 50 04             	lea    0x4(%eax),%edx
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	89 10                	mov    %edx,(%eax)
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	83 e8 04             	sub    $0x4,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80050f:	5d                   	pop    %ebp
  800510:	c3                   	ret    

00800511 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800514:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800518:	7e 1c                	jle    800536 <getint+0x25>
		return va_arg(*ap, long long);
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	8b 00                	mov    (%eax),%eax
  80051f:	8d 50 08             	lea    0x8(%eax),%edx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	89 10                	mov    %edx,(%eax)
  800527:	8b 45 08             	mov    0x8(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	83 e8 08             	sub    $0x8,%eax
  80052f:	8b 50 04             	mov    0x4(%eax),%edx
  800532:	8b 00                	mov    (%eax),%eax
  800534:	eb 38                	jmp    80056e <getint+0x5d>
	else if (lflag)
  800536:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80053a:	74 1a                	je     800556 <getint+0x45>
		return va_arg(*ap, long);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
  800554:	eb 18                	jmp    80056e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800556:	8b 45 08             	mov    0x8(%ebp),%eax
  800559:	8b 00                	mov    (%eax),%eax
  80055b:	8d 50 04             	lea    0x4(%eax),%edx
  80055e:	8b 45 08             	mov    0x8(%ebp),%eax
  800561:	89 10                	mov    %edx,(%eax)
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	83 e8 04             	sub    $0x4,%eax
  80056b:	8b 00                	mov    (%eax),%eax
  80056d:	99                   	cltd   
}
  80056e:	5d                   	pop    %ebp
  80056f:	c3                   	ret    

00800570 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	56                   	push   %esi
  800574:	53                   	push   %ebx
  800575:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800578:	eb 17                	jmp    800591 <vprintfmt+0x21>
			if (ch == '\0')
  80057a:	85 db                	test   %ebx,%ebx
  80057c:	0f 84 c1 03 00 00    	je     800943 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800582:	83 ec 08             	sub    $0x8,%esp
  800585:	ff 75 0c             	pushl  0xc(%ebp)
  800588:	53                   	push   %ebx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	ff d0                	call   *%eax
  80058e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	8d 50 01             	lea    0x1(%eax),%edx
  800597:	89 55 10             	mov    %edx,0x10(%ebp)
  80059a:	8a 00                	mov    (%eax),%al
  80059c:	0f b6 d8             	movzbl %al,%ebx
  80059f:	83 fb 25             	cmp    $0x25,%ebx
  8005a2:	75 d6                	jne    80057a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8005a4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8005a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8005af:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8005b6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005c7:	8d 50 01             	lea    0x1(%eax),%edx
  8005ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8005cd:	8a 00                	mov    (%eax),%al
  8005cf:	0f b6 d8             	movzbl %al,%ebx
  8005d2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005d5:	83 f8 5b             	cmp    $0x5b,%eax
  8005d8:	0f 87 3d 03 00 00    	ja     80091b <vprintfmt+0x3ab>
  8005de:	8b 04 85 18 3b 80 00 	mov    0x803b18(,%eax,4),%eax
  8005e5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005e7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005eb:	eb d7                	jmp    8005c4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005ed:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005f1:	eb d1                	jmp    8005c4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005f3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005fd:	89 d0                	mov    %edx,%eax
  8005ff:	c1 e0 02             	shl    $0x2,%eax
  800602:	01 d0                	add    %edx,%eax
  800604:	01 c0                	add    %eax,%eax
  800606:	01 d8                	add    %ebx,%eax
  800608:	83 e8 30             	sub    $0x30,%eax
  80060b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80060e:	8b 45 10             	mov    0x10(%ebp),%eax
  800611:	8a 00                	mov    (%eax),%al
  800613:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800616:	83 fb 2f             	cmp    $0x2f,%ebx
  800619:	7e 3e                	jle    800659 <vprintfmt+0xe9>
  80061b:	83 fb 39             	cmp    $0x39,%ebx
  80061e:	7f 39                	jg     800659 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800620:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800623:	eb d5                	jmp    8005fa <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	83 c0 04             	add    $0x4,%eax
  80062b:	89 45 14             	mov    %eax,0x14(%ebp)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	83 e8 04             	sub    $0x4,%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800639:	eb 1f                	jmp    80065a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80063b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063f:	79 83                	jns    8005c4 <vprintfmt+0x54>
				width = 0;
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800648:	e9 77 ff ff ff       	jmp    8005c4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80064d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800654:	e9 6b ff ff ff       	jmp    8005c4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800659:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80065a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80065e:	0f 89 60 ff ff ff    	jns    8005c4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800667:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80066a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800671:	e9 4e ff ff ff       	jmp    8005c4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800676:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800679:	e9 46 ff ff ff       	jmp    8005c4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	83 c0 04             	add    $0x4,%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
  800687:	8b 45 14             	mov    0x14(%ebp),%eax
  80068a:	83 e8 04             	sub    $0x4,%eax
  80068d:	8b 00                	mov    (%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	ff 75 0c             	pushl  0xc(%ebp)
  800695:	50                   	push   %eax
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	ff d0                	call   *%eax
  80069b:	83 c4 10             	add    $0x10,%esp
			break;
  80069e:	e9 9b 02 00 00       	jmp    80093e <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	83 c0 04             	add    $0x4,%eax
  8006a9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	83 e8 04             	sub    $0x4,%eax
  8006b2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8006b4:	85 db                	test   %ebx,%ebx
  8006b6:	79 02                	jns    8006ba <vprintfmt+0x14a>
				err = -err;
  8006b8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006ba:	83 fb 64             	cmp    $0x64,%ebx
  8006bd:	7f 0b                	jg     8006ca <vprintfmt+0x15a>
  8006bf:	8b 34 9d 60 39 80 00 	mov    0x803960(,%ebx,4),%esi
  8006c6:	85 f6                	test   %esi,%esi
  8006c8:	75 19                	jne    8006e3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006ca:	53                   	push   %ebx
  8006cb:	68 05 3b 80 00       	push   $0x803b05
  8006d0:	ff 75 0c             	pushl  0xc(%ebp)
  8006d3:	ff 75 08             	pushl  0x8(%ebp)
  8006d6:	e8 70 02 00 00       	call   80094b <printfmt>
  8006db:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006de:	e9 5b 02 00 00       	jmp    80093e <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006e3:	56                   	push   %esi
  8006e4:	68 0e 3b 80 00       	push   $0x803b0e
  8006e9:	ff 75 0c             	pushl  0xc(%ebp)
  8006ec:	ff 75 08             	pushl  0x8(%ebp)
  8006ef:	e8 57 02 00 00       	call   80094b <printfmt>
  8006f4:	83 c4 10             	add    $0x10,%esp
			break;
  8006f7:	e9 42 02 00 00       	jmp    80093e <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ff:	83 c0 04             	add    $0x4,%eax
  800702:	89 45 14             	mov    %eax,0x14(%ebp)
  800705:	8b 45 14             	mov    0x14(%ebp),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 30                	mov    (%eax),%esi
  80070d:	85 f6                	test   %esi,%esi
  80070f:	75 05                	jne    800716 <vprintfmt+0x1a6>
				p = "(null)";
  800711:	be 11 3b 80 00       	mov    $0x803b11,%esi
			if (width > 0 && padc != '-')
  800716:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071a:	7e 6d                	jle    800789 <vprintfmt+0x219>
  80071c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800720:	74 67                	je     800789 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800722:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	50                   	push   %eax
  800729:	56                   	push   %esi
  80072a:	e8 1e 03 00 00       	call   800a4d <strnlen>
  80072f:	83 c4 10             	add    $0x10,%esp
  800732:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800735:	eb 16                	jmp    80074d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800737:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	ff 75 0c             	pushl  0xc(%ebp)
  800741:	50                   	push   %eax
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	ff d0                	call   *%eax
  800747:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80074a:	ff 4d e4             	decl   -0x1c(%ebp)
  80074d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800751:	7f e4                	jg     800737 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800753:	eb 34                	jmp    800789 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800755:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800759:	74 1c                	je     800777 <vprintfmt+0x207>
  80075b:	83 fb 1f             	cmp    $0x1f,%ebx
  80075e:	7e 05                	jle    800765 <vprintfmt+0x1f5>
  800760:	83 fb 7e             	cmp    $0x7e,%ebx
  800763:	7e 12                	jle    800777 <vprintfmt+0x207>
					putch('?', putdat);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	6a 3f                	push   $0x3f
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	ff d0                	call   *%eax
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	eb 0f                	jmp    800786 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	ff 75 0c             	pushl  0xc(%ebp)
  80077d:	53                   	push   %ebx
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	ff d0                	call   *%eax
  800783:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800786:	ff 4d e4             	decl   -0x1c(%ebp)
  800789:	89 f0                	mov    %esi,%eax
  80078b:	8d 70 01             	lea    0x1(%eax),%esi
  80078e:	8a 00                	mov    (%eax),%al
  800790:	0f be d8             	movsbl %al,%ebx
  800793:	85 db                	test   %ebx,%ebx
  800795:	74 24                	je     8007bb <vprintfmt+0x24b>
  800797:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80079b:	78 b8                	js     800755 <vprintfmt+0x1e5>
  80079d:	ff 4d e0             	decl   -0x20(%ebp)
  8007a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007a4:	79 af                	jns    800755 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007a6:	eb 13                	jmp    8007bb <vprintfmt+0x24b>
				putch(' ', putdat);
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 0c             	pushl  0xc(%ebp)
  8007ae:	6a 20                	push   $0x20
  8007b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b3:	ff d0                	call   *%eax
  8007b5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8007bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007bf:	7f e7                	jg     8007a8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007c1:	e9 78 01 00 00       	jmp    80093e <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8007cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007cf:	50                   	push   %eax
  8007d0:	e8 3c fd ff ff       	call   800511 <getint>
  8007d5:	83 c4 10             	add    $0x10,%esp
  8007d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007db:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	85 d2                	test   %edx,%edx
  8007e6:	79 23                	jns    80080b <vprintfmt+0x29b>
				putch('-', putdat);
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ee:	6a 2d                	push   $0x2d
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	ff d0                	call   *%eax
  8007f5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007fe:	f7 d8                	neg    %eax
  800800:	83 d2 00             	adc    $0x0,%edx
  800803:	f7 da                	neg    %edx
  800805:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800808:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80080b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800812:	e9 bc 00 00 00       	jmp    8008d3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 e8             	pushl  -0x18(%ebp)
  80081d:	8d 45 14             	lea    0x14(%ebp),%eax
  800820:	50                   	push   %eax
  800821:	e8 84 fc ff ff       	call   8004aa <getuint>
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80082f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800836:	e9 98 00 00 00       	jmp    8008d3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	6a 58                	push   $0x58
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	6a 58                	push   $0x58
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	6a 58                	push   $0x58
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	ff d0                	call   *%eax
  800868:	83 c4 10             	add    $0x10,%esp
			break;
  80086b:	e9 ce 00 00 00       	jmp    80093e <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	ff 75 0c             	pushl  0xc(%ebp)
  800876:	6a 30                	push   $0x30
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	ff d0                	call   *%eax
  80087d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	6a 78                	push   $0x78
  800888:	8b 45 08             	mov    0x8(%ebp),%eax
  80088b:	ff d0                	call   *%eax
  80088d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	83 c0 04             	add    $0x4,%eax
  800896:	89 45 14             	mov    %eax,0x14(%ebp)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 e8 04             	sub    $0x4,%eax
  80089f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8008a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8008ab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8008b2:	eb 1f                	jmp    8008d3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8008ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8008bd:	50                   	push   %eax
  8008be:	e8 e7 fb ff ff       	call   8004aa <getuint>
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008cc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008d3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008da:	83 ec 04             	sub    $0x4,%esp
  8008dd:	52                   	push   %edx
  8008de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	ff 75 08             	pushl  0x8(%ebp)
  8008ee:	e8 00 fb ff ff       	call   8003f3 <printnum>
  8008f3:	83 c4 20             	add    $0x20,%esp
			break;
  8008f6:	eb 46                	jmp    80093e <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008f8:	83 ec 08             	sub    $0x8,%esp
  8008fb:	ff 75 0c             	pushl  0xc(%ebp)
  8008fe:	53                   	push   %ebx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	ff d0                	call   *%eax
  800904:	83 c4 10             	add    $0x10,%esp
			break;
  800907:	eb 35                	jmp    80093e <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800909:	c6 05 44 50 98 00 00 	movb   $0x0,0x985044
			break;
  800910:	eb 2c                	jmp    80093e <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800912:	c6 05 44 50 98 00 01 	movb   $0x1,0x985044
			break;
  800919:	eb 23                	jmp    80093e <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	6a 25                	push   $0x25
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	ff d0                	call   *%eax
  800928:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092b:	ff 4d 10             	decl   0x10(%ebp)
  80092e:	eb 03                	jmp    800933 <vprintfmt+0x3c3>
  800930:	ff 4d 10             	decl   0x10(%ebp)
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	48                   	dec    %eax
  800937:	8a 00                	mov    (%eax),%al
  800939:	3c 25                	cmp    $0x25,%al
  80093b:	75 f3                	jne    800930 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80093d:	90                   	nop
		}
	}
  80093e:	e9 35 fc ff ff       	jmp    800578 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800943:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800944:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800947:	5b                   	pop    %ebx
  800948:	5e                   	pop    %esi
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800951:	8d 45 10             	lea    0x10(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80095a:	8b 45 10             	mov    0x10(%ebp),%eax
  80095d:	ff 75 f4             	pushl  -0xc(%ebp)
  800960:	50                   	push   %eax
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	ff 75 08             	pushl  0x8(%ebp)
  800967:	e8 04 fc ff ff       	call   800570 <vprintfmt>
  80096c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80096f:	90                   	nop
  800970:	c9                   	leave  
  800971:	c3                   	ret    

00800972 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800975:	8b 45 0c             	mov    0xc(%ebp),%eax
  800978:	8b 40 08             	mov    0x8(%eax),%eax
  80097b:	8d 50 01             	lea    0x1(%eax),%edx
  80097e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800981:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800984:	8b 45 0c             	mov    0xc(%ebp),%eax
  800987:	8b 10                	mov    (%eax),%edx
  800989:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098c:	8b 40 04             	mov    0x4(%eax),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	73 12                	jae    8009a5 <sprintputch+0x33>
		*b->buf++ = ch;
  800993:	8b 45 0c             	mov    0xc(%ebp),%eax
  800996:	8b 00                	mov    (%eax),%eax
  800998:	8d 48 01             	lea    0x1(%eax),%ecx
  80099b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099e:	89 0a                	mov    %ecx,(%edx)
  8009a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8009a3:	88 10                	mov    %dl,(%eax)
}
  8009a5:	90                   	nop
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8009ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bd:	01 d0                	add    %edx,%eax
  8009bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8009c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009cd:	74 06                	je     8009d5 <vsnprintf+0x2d>
  8009cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009d3:	7f 07                	jg     8009dc <vsnprintf+0x34>
		return -E_INVAL;
  8009d5:	b8 03 00 00 00       	mov    $0x3,%eax
  8009da:	eb 20                	jmp    8009fc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009dc:	ff 75 14             	pushl  0x14(%ebp)
  8009df:	ff 75 10             	pushl  0x10(%ebp)
  8009e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009e5:	50                   	push   %eax
  8009e6:	68 72 09 80 00       	push   $0x800972
  8009eb:	e8 80 fb ff ff       	call   800570 <vprintfmt>
  8009f0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009f6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a04:	8d 45 10             	lea    0x10(%ebp),%eax
  800a07:	83 c0 04             	add    $0x4,%eax
  800a0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800a0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800a10:	ff 75 f4             	pushl  -0xc(%ebp)
  800a13:	50                   	push   %eax
  800a14:	ff 75 0c             	pushl  0xc(%ebp)
  800a17:	ff 75 08             	pushl  0x8(%ebp)
  800a1a:	e8 89 ff ff ff       	call   8009a8 <vsnprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a37:	eb 06                	jmp    800a3f <strlen+0x15>
		n++;
  800a39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a3c:	ff 45 08             	incl   0x8(%ebp)
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 f1                	jne    800a39 <strlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a5a:	eb 09                	jmp    800a65 <strnlen+0x18>
		n++;
  800a5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a5f:	ff 45 08             	incl   0x8(%ebp)
  800a62:	ff 4d 0c             	decl   0xc(%ebp)
  800a65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a69:	74 09                	je     800a74 <strnlen+0x27>
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	8a 00                	mov    (%eax),%al
  800a70:	84 c0                	test   %al,%al
  800a72:	75 e8                	jne    800a5c <strnlen+0xf>
		n++;
	return n;
  800a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a77:	c9                   	leave  
  800a78:	c3                   	ret    

00800a79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a85:	90                   	nop
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8d 50 01             	lea    0x1(%eax),%edx
  800a8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a98:	8a 12                	mov    (%edx),%dl
  800a9a:	88 10                	mov    %dl,(%eax)
  800a9c:	8a 00                	mov    (%eax),%al
  800a9e:	84 c0                	test   %al,%al
  800aa0:	75 e4                	jne    800a86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800aa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800aa5:	c9                   	leave  
  800aa6:	c3                   	ret    

00800aa7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800aa7:	55                   	push   %ebp
  800aa8:	89 e5                	mov    %esp,%ebp
  800aaa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ab3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800aba:	eb 1f                	jmp    800adb <strncpy+0x34>
		*dst++ = *src;
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8d 50 01             	lea    0x1(%eax),%edx
  800ac2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	8a 12                	mov    (%edx),%dl
  800aca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	8a 00                	mov    (%eax),%al
  800ad1:	84 c0                	test   %al,%al
  800ad3:	74 03                	je     800ad8 <strncpy+0x31>
			src++;
  800ad5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ad8:	ff 45 fc             	incl   -0x4(%ebp)
  800adb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ade:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ae1:	72 d9                	jb     800abc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ae3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ae6:	c9                   	leave  
  800ae7:	c3                   	ret    

00800ae8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800af4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af8:	74 30                	je     800b2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800afa:	eb 16                	jmp    800b12 <strlcpy+0x2a>
			*dst++ = *src++;
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8d 50 01             	lea    0x1(%eax),%edx
  800b02:	89 55 08             	mov    %edx,0x8(%ebp)
  800b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b0e:	8a 12                	mov    (%edx),%dl
  800b10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b12:	ff 4d 10             	decl   0x10(%ebp)
  800b15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b19:	74 09                	je     800b24 <strlcpy+0x3c>
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8a 00                	mov    (%eax),%al
  800b20:	84 c0                	test   %al,%al
  800b22:	75 d8                	jne    800afc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b30:	29 c2                	sub    %eax,%edx
  800b32:	89 d0                	mov    %edx,%eax
}
  800b34:	c9                   	leave  
  800b35:	c3                   	ret    

00800b36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b39:	eb 06                	jmp    800b41 <strcmp+0xb>
		p++, q++;
  800b3b:	ff 45 08             	incl   0x8(%ebp)
  800b3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8a 00                	mov    (%eax),%al
  800b46:	84 c0                	test   %al,%al
  800b48:	74 0e                	je     800b58 <strcmp+0x22>
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	8a 10                	mov    (%eax),%dl
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8a 00                	mov    (%eax),%al
  800b54:	38 c2                	cmp    %al,%dl
  800b56:	74 e3                	je     800b3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	8a 00                	mov    (%eax),%al
  800b5d:	0f b6 d0             	movzbl %al,%edx
  800b60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b63:	8a 00                	mov    (%eax),%al
  800b65:	0f b6 c0             	movzbl %al,%eax
  800b68:	29 c2                	sub    %eax,%edx
  800b6a:	89 d0                	mov    %edx,%eax
}
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    

00800b6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b71:	eb 09                	jmp    800b7c <strncmp+0xe>
		n--, p++, q++;
  800b73:	ff 4d 10             	decl   0x10(%ebp)
  800b76:	ff 45 08             	incl   0x8(%ebp)
  800b79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b80:	74 17                	je     800b99 <strncmp+0x2b>
  800b82:	8b 45 08             	mov    0x8(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	84 c0                	test   %al,%al
  800b89:	74 0e                	je     800b99 <strncmp+0x2b>
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	8a 10                	mov    (%eax),%dl
  800b90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b93:	8a 00                	mov    (%eax),%al
  800b95:	38 c2                	cmp    %al,%dl
  800b97:	74 da                	je     800b73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b9d:	75 07                	jne    800ba6 <strncmp+0x38>
		return 0;
  800b9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ba4:	eb 14                	jmp    800bba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	0f b6 d0             	movzbl %al,%edx
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	0f b6 c0             	movzbl %al,%eax
  800bb6:	29 c2                	sub    %eax,%edx
  800bb8:	89 d0                	mov    %edx,%eax
}
  800bba:	5d                   	pop    %ebp
  800bbb:	c3                   	ret    

00800bbc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 04             	sub    $0x4,%esp
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bc8:	eb 12                	jmp    800bdc <strchr+0x20>
		if (*s == c)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd2:	75 05                	jne    800bd9 <strchr+0x1d>
			return (char *) s;
  800bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd7:	eb 11                	jmp    800bea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bd9:	ff 45 08             	incl   0x8(%ebp)
  800bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdf:	8a 00                	mov    (%eax),%al
  800be1:	84 c0                	test   %al,%al
  800be3:	75 e5                	jne    800bca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 04             	sub    $0x4,%esp
  800bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bf8:	eb 0d                	jmp    800c07 <strfind+0x1b>
		if (*s == c)
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	8a 00                	mov    (%eax),%al
  800bff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c02:	74 0e                	je     800c12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c04:	ff 45 08             	incl   0x8(%ebp)
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 ea                	jne    800bfa <strfind+0xe>
  800c10:	eb 01                	jmp    800c13 <strfind+0x27>
		if (*s == c)
			break;
  800c12:	90                   	nop
	return (char *) s;
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c16:	c9                   	leave  
  800c17:	c3                   	ret    

00800c18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800c2a:	eb 0e                	jmp    800c3a <memset+0x22>
		*p++ = c;
  800c2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2f:	8d 50 01             	lea    0x1(%eax),%edx
  800c32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c3a:	ff 4d f8             	decl   -0x8(%ebp)
  800c3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c41:	79 e9                	jns    800c2c <memset+0x14>
		*p++ = c;

	return v;
  800c43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c46:	c9                   	leave  
  800c47:	c3                   	ret    

00800c48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c5a:	eb 16                	jmp    800c72 <memcpy+0x2a>
		*d++ = *s++;
  800c5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c5f:	8d 50 01             	lea    0x1(%eax),%edx
  800c62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c6e:	8a 12                	mov    (%edx),%dl
  800c70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
  800c75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c78:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7b:	85 c0                	test   %eax,%eax
  800c7d:	75 dd                	jne    800c5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c9c:	73 50                	jae    800cee <memmove+0x6a>
  800c9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca4:	01 d0                	add    %edx,%eax
  800ca6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ca9:	76 43                	jbe    800cee <memmove+0x6a>
		s += n;
  800cab:	8b 45 10             	mov    0x10(%ebp),%eax
  800cae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800cb7:	eb 10                	jmp    800cc9 <memmove+0x45>
			*--d = *--s;
  800cb9:	ff 4d f8             	decl   -0x8(%ebp)
  800cbc:	ff 4d fc             	decl   -0x4(%ebp)
  800cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cc2:	8a 10                	mov    (%eax),%dl
  800cc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ccf:	89 55 10             	mov    %edx,0x10(%ebp)
  800cd2:	85 c0                	test   %eax,%eax
  800cd4:	75 e3                	jne    800cb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800cd6:	eb 23                	jmp    800cfb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cdb:	8d 50 01             	lea    0x1(%eax),%edx
  800cde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ce1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ce4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cea:	8a 12                	mov    (%edx),%dl
  800cec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cee:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cf4:	89 55 10             	mov    %edx,0x10(%ebp)
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	75 dd                	jne    800cd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cfe:	c9                   	leave  
  800cff:	c3                   	ret    

00800d00 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800d12:	eb 2a                	jmp    800d3e <memcmp+0x3e>
		if (*s1 != *s2)
  800d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d17:	8a 10                	mov    (%eax),%dl
  800d19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d1c:	8a 00                	mov    (%eax),%al
  800d1e:	38 c2                	cmp    %al,%dl
  800d20:	74 16                	je     800d38 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 d0             	movzbl %al,%edx
  800d2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d2d:	8a 00                	mov    (%eax),%al
  800d2f:	0f b6 c0             	movzbl %al,%eax
  800d32:	29 c2                	sub    %eax,%edx
  800d34:	89 d0                	mov    %edx,%eax
  800d36:	eb 18                	jmp    800d50 <memcmp+0x50>
		s1++, s2++;
  800d38:	ff 45 fc             	incl   -0x4(%ebp)
  800d3b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d44:	89 55 10             	mov    %edx,0x10(%ebp)
  800d47:	85 c0                	test   %eax,%eax
  800d49:	75 c9                	jne    800d14 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5e:	01 d0                	add    %edx,%eax
  800d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d63:	eb 15                	jmp    800d7a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	0f b6 d0             	movzbl %al,%edx
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	0f b6 c0             	movzbl %al,%eax
  800d73:	39 c2                	cmp    %eax,%edx
  800d75:	74 0d                	je     800d84 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d77:	ff 45 08             	incl   0x8(%ebp)
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d80:	72 e3                	jb     800d65 <memfind+0x13>
  800d82:	eb 01                	jmp    800d85 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d84:	90                   	nop
	return (void *) s;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d88:	c9                   	leave  
  800d89:	c3                   	ret    

00800d8a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d97:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d9e:	eb 03                	jmp    800da3 <strtol+0x19>
		s++;
  800da0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	3c 20                	cmp    $0x20,%al
  800daa:	74 f4                	je     800da0 <strtol+0x16>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	3c 09                	cmp    $0x9,%al
  800db3:	74 eb                	je     800da0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 2b                	cmp    $0x2b,%al
  800dbc:	75 05                	jne    800dc3 <strtol+0x39>
		s++;
  800dbe:	ff 45 08             	incl   0x8(%ebp)
  800dc1:	eb 13                	jmp    800dd6 <strtol+0x4c>
	else if (*s == '-')
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3c 2d                	cmp    $0x2d,%al
  800dca:	75 0a                	jne    800dd6 <strtol+0x4c>
		s++, neg = 1;
  800dcc:	ff 45 08             	incl   0x8(%ebp)
  800dcf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	74 06                	je     800de2 <strtol+0x58>
  800ddc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800de0:	75 20                	jne    800e02 <strtol+0x78>
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	3c 30                	cmp    $0x30,%al
  800de9:	75 17                	jne    800e02 <strtol+0x78>
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	40                   	inc    %eax
  800def:	8a 00                	mov    (%eax),%al
  800df1:	3c 78                	cmp    $0x78,%al
  800df3:	75 0d                	jne    800e02 <strtol+0x78>
		s += 2, base = 16;
  800df5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800df9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e00:	eb 28                	jmp    800e2a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800e02:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e06:	75 15                	jne    800e1d <strtol+0x93>
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8a 00                	mov    (%eax),%al
  800e0d:	3c 30                	cmp    $0x30,%al
  800e0f:	75 0c                	jne    800e1d <strtol+0x93>
		s++, base = 8;
  800e11:	ff 45 08             	incl   0x8(%ebp)
  800e14:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e1b:	eb 0d                	jmp    800e2a <strtol+0xa0>
	else if (base == 0)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	75 07                	jne    800e2a <strtol+0xa0>
		base = 10;
  800e23:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	3c 2f                	cmp    $0x2f,%al
  800e31:	7e 19                	jle    800e4c <strtol+0xc2>
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	3c 39                	cmp    $0x39,%al
  800e3a:	7f 10                	jg     800e4c <strtol+0xc2>
			dig = *s - '0';
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	8a 00                	mov    (%eax),%al
  800e41:	0f be c0             	movsbl %al,%eax
  800e44:	83 e8 30             	sub    $0x30,%eax
  800e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e4a:	eb 42                	jmp    800e8e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	3c 60                	cmp    $0x60,%al
  800e53:	7e 19                	jle    800e6e <strtol+0xe4>
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 7a                	cmp    $0x7a,%al
  800e5c:	7f 10                	jg     800e6e <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	0f be c0             	movsbl %al,%eax
  800e66:	83 e8 57             	sub    $0x57,%eax
  800e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e6c:	eb 20                	jmp    800e8e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	8a 00                	mov    (%eax),%al
  800e73:	3c 40                	cmp    $0x40,%al
  800e75:	7e 39                	jle    800eb0 <strtol+0x126>
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	3c 5a                	cmp    $0x5a,%al
  800e7e:	7f 30                	jg     800eb0 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	0f be c0             	movsbl %al,%eax
  800e88:	83 e8 37             	sub    $0x37,%eax
  800e8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	7d 19                	jge    800eaf <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e96:	ff 45 08             	incl   0x8(%ebp)
  800e99:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ea0:	89 c2                	mov    %eax,%edx
  800ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea5:	01 d0                	add    %edx,%eax
  800ea7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800eaa:	e9 7b ff ff ff       	jmp    800e2a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800eaf:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800eb0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb4:	74 08                	je     800ebe <strtol+0x134>
		*endptr = (char *) s;
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800ebe:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800ec2:	74 07                	je     800ecb <strtol+0x141>
  800ec4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec7:	f7 d8                	neg    %eax
  800ec9:	eb 03                	jmp    800ece <strtol+0x144>
  800ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <ltostr>:

void
ltostr(long value, char *str)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ed6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800edd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800ee4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ee8:	79 13                	jns    800efd <ltostr+0x2d>
	{
		neg = 1;
  800eea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ef7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800efa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800f05:	99                   	cltd   
  800f06:	f7 f9                	idiv   %ecx
  800f08:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800f0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0e:	8d 50 01             	lea    0x1(%eax),%edx
  800f11:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f14:	89 c2                	mov    %eax,%edx
  800f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f19:	01 d0                	add    %edx,%eax
  800f1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800f1e:	83 c2 30             	add    $0x30,%edx
  800f21:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800f23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f26:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f2b:	f7 e9                	imul   %ecx
  800f2d:	c1 fa 02             	sar    $0x2,%edx
  800f30:	89 c8                	mov    %ecx,%eax
  800f32:	c1 f8 1f             	sar    $0x1f,%eax
  800f35:	29 c2                	sub    %eax,%edx
  800f37:	89 d0                	mov    %edx,%eax
  800f39:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800f3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f40:	75 bb                	jne    800efd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f49:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4c:	48                   	dec    %eax
  800f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f50:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f54:	74 3d                	je     800f93 <ltostr+0xc3>
		start = 1 ;
  800f56:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f5d:	eb 34                	jmp    800f93 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 d0                	add    %edx,%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f72:	01 c2                	add    %eax,%edx
  800f74:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7a:	01 c8                	add    %ecx,%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f86:	01 c2                	add    %eax,%edx
  800f88:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f8b:	88 02                	mov    %al,(%edx)
		start++ ;
  800f8d:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f90:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f96:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f99:	7c c4                	jl     800f5f <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f9b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa1:	01 d0                	add    %edx,%eax
  800fa3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800fa6:	90                   	nop
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800faf:	ff 75 08             	pushl  0x8(%ebp)
  800fb2:	e8 73 fa ff ff       	call   800a2a <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fbd:	ff 75 0c             	pushl  0xc(%ebp)
  800fc0:	e8 65 fa ff ff       	call   800a2a <strlen>
  800fc5:	83 c4 04             	add    $0x4,%esp
  800fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fd9:	eb 17                	jmp    800ff2 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fdb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fde:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe1:	01 c2                	add    %eax,%edx
  800fe3:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	01 c8                	add    %ecx,%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fef:	ff 45 fc             	incl   -0x4(%ebp)
  800ff2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ff8:	7c e1                	jl     800fdb <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ffa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801001:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801008:	eb 1f                	jmp    801029 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80100a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100d:	8d 50 01             	lea    0x1(%eax),%edx
  801010:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801013:	89 c2                	mov    %eax,%edx
  801015:	8b 45 10             	mov    0x10(%ebp),%eax
  801018:	01 c2                	add    %eax,%edx
  80101a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	01 c8                	add    %ecx,%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801026:	ff 45 f8             	incl   -0x8(%ebp)
  801029:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80102f:	7c d9                	jl     80100a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801031:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801034:	8b 45 10             	mov    0x10(%ebp),%eax
  801037:	01 d0                	add    %edx,%eax
  801039:	c6 00 00             	movb   $0x0,(%eax)
}
  80103c:	90                   	nop
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801042:	8b 45 14             	mov    0x14(%ebp),%eax
  801045:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	8b 00                	mov    (%eax),%eax
  801050:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801057:	8b 45 10             	mov    0x10(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	eb 0c                	jmp    801070 <strsplit+0x31>
			*string++ = 0;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	8d 50 01             	lea    0x1(%eax),%edx
  80106a:	89 55 08             	mov    %edx,0x8(%ebp)
  80106d:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	8a 00                	mov    (%eax),%al
  801075:	84 c0                	test   %al,%al
  801077:	74 18                	je     801091 <strsplit+0x52>
  801079:	8b 45 08             	mov    0x8(%ebp),%eax
  80107c:	8a 00                	mov    (%eax),%al
  80107e:	0f be c0             	movsbl %al,%eax
  801081:	50                   	push   %eax
  801082:	ff 75 0c             	pushl  0xc(%ebp)
  801085:	e8 32 fb ff ff       	call   800bbc <strchr>
  80108a:	83 c4 08             	add    $0x8,%esp
  80108d:	85 c0                	test   %eax,%eax
  80108f:	75 d3                	jne    801064 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	8a 00                	mov    (%eax),%al
  801096:	84 c0                	test   %al,%al
  801098:	74 5a                	je     8010f4 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80109a:	8b 45 14             	mov    0x14(%ebp),%eax
  80109d:	8b 00                	mov    (%eax),%eax
  80109f:	83 f8 0f             	cmp    $0xf,%eax
  8010a2:	75 07                	jne    8010ab <strsplit+0x6c>
		{
			return 0;
  8010a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a9:	eb 66                	jmp    801111 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8010ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b3:	8b 55 14             	mov    0x14(%ebp),%edx
  8010b6:	89 0a                	mov    %ecx,(%edx)
  8010b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c2:	01 c2                	add    %eax,%edx
  8010c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c7:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c9:	eb 03                	jmp    8010ce <strsplit+0x8f>
			string++;
  8010cb:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d1:	8a 00                	mov    (%eax),%al
  8010d3:	84 c0                	test   %al,%al
  8010d5:	74 8b                	je     801062 <strsplit+0x23>
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	0f be c0             	movsbl %al,%eax
  8010df:	50                   	push   %eax
  8010e0:	ff 75 0c             	pushl  0xc(%ebp)
  8010e3:	e8 d4 fa ff ff       	call   800bbc <strchr>
  8010e8:	83 c4 08             	add    $0x8,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	74 dc                	je     8010cb <strsplit+0x8c>
			string++;
	}
  8010ef:	e9 6e ff ff ff       	jmp    801062 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010f4:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f8:	8b 00                	mov    (%eax),%eax
  8010fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 d0                	add    %edx,%eax
  801106:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80110c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801111:	c9                   	leave  
  801112:	c3                   	ret    

00801113 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801113:	55                   	push   %ebp
  801114:	89 e5                	mov    %esp,%ebp
  801116:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801119:	83 ec 04             	sub    $0x4,%esp
  80111c:	68 88 3c 80 00       	push   $0x803c88
  801121:	68 3f 01 00 00       	push   $0x13f
  801126:	68 aa 3c 80 00       	push   $0x803caa
  80112b:	e8 4e 22 00 00       	call   80337e <_panic>

00801130 <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801136:	83 ec 0c             	sub    $0xc,%esp
  801139:	ff 75 08             	pushl  0x8(%ebp)
  80113c:	e8 90 0c 00 00       	call   801dd1 <sys_sbrk>
  801141:	83 c4 10             	add    $0x10,%esp
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  80114c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801150:	75 0a                	jne    80115c <malloc+0x16>
		return NULL;
  801152:	b8 00 00 00 00       	mov    $0x0,%eax
  801157:	e9 9e 01 00 00       	jmp    8012fa <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  80115c:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801163:	77 2c                	ja     801191 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801165:	e8 eb 0a 00 00       	call   801c55 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80116a:	85 c0                	test   %eax,%eax
  80116c:	74 19                	je     801187 <malloc+0x41>

			void * block = alloc_block_FF(size);
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 85 11 00 00       	call   8022fe <alloc_block_FF>
  801179:	83 c4 10             	add    $0x10,%esp
  80117c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  80117f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801182:	e9 73 01 00 00       	jmp    8012fa <malloc+0x1b4>
		} else {
			return NULL;
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
  80118c:	e9 69 01 00 00       	jmp    8012fa <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801191:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801198:	8b 55 08             	mov    0x8(%ebp),%edx
  80119b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80119e:	01 d0                	add    %edx,%eax
  8011a0:	48                   	dec    %eax
  8011a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ac:	f7 75 e0             	divl   -0x20(%ebp)
  8011af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011b2:	29 d0                	sub    %edx,%eax
  8011b4:	c1 e8 0c             	shr    $0xc,%eax
  8011b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  8011ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8011c1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  8011c8:	a1 20 50 80 00       	mov    0x805020,%eax
  8011cd:	8b 40 7c             	mov    0x7c(%eax),%eax
  8011d0:	05 00 10 00 00       	add    $0x1000,%eax
  8011d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  8011d8:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8011dd:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8011e0:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  8011e3:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  8011ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8011f0:	01 d0                	add    %edx,%eax
  8011f2:	48                   	dec    %eax
  8011f3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8011f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8011f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fe:	f7 75 cc             	divl   -0x34(%ebp)
  801201:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801204:	29 d0                	sub    %edx,%eax
  801206:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801209:	76 0a                	jbe    801215 <malloc+0xcf>
		return NULL;
  80120b:	b8 00 00 00 00       	mov    $0x0,%eax
  801210:	e9 e5 00 00 00       	jmp    8012fa <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801215:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801218:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80121b:	eb 48                	jmp    801265 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  80121d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801220:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801223:	c1 e8 0c             	shr    $0xc,%eax
  801226:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801229:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80122c:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801233:	85 c0                	test   %eax,%eax
  801235:	75 11                	jne    801248 <malloc+0x102>
			freePagesCount++;
  801237:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80123a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80123e:	75 16                	jne    801256 <malloc+0x110>
				start = i;
  801240:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801243:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801246:	eb 0e                	jmp    801256 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801248:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  80124f:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801259:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80125c:	74 12                	je     801270 <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  80125e:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801265:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80126c:	76 af                	jbe    80121d <malloc+0xd7>
  80126e:	eb 01                	jmp    801271 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801270:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801271:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801275:	74 08                	je     80127f <malloc+0x139>
  801277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80127a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80127d:	74 07                	je     801286 <malloc+0x140>
		return NULL;
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
  801284:	eb 74                	jmp    8012fa <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801286:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801289:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  80128c:	c1 e8 0c             	shr    $0xc,%eax
  80128f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801292:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801295:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801298:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  80129f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8012a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8012a5:	eb 11                	jmp    8012b8 <malloc+0x172>
		markedPages[i] = 1;
  8012a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8012aa:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8012b1:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  8012b5:	ff 45 e8             	incl   -0x18(%ebp)
  8012b8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8012bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8012c3:	77 e2                	ja     8012a7 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  8012c5:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  8012cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8012d2:	01 d0                	add    %edx,%eax
  8012d4:	48                   	dec    %eax
  8012d5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8012d8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8012db:	ba 00 00 00 00       	mov    $0x0,%edx
  8012e0:	f7 75 bc             	divl   -0x44(%ebp)
  8012e3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8012e6:	29 d0                	sub    %edx,%eax
  8012e8:	83 ec 08             	sub    $0x8,%esp
  8012eb:	50                   	push   %eax
  8012ec:	ff 75 f0             	pushl  -0x10(%ebp)
  8012ef:	e8 14 0b 00 00       	call   801e08 <sys_allocate_user_mem>
  8012f4:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  8012f7:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801302:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801306:	0f 84 ee 00 00 00    	je     8013fa <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  80130c:	a1 20 50 80 00       	mov    0x805020,%eax
  801311:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801314:	3b 45 08             	cmp    0x8(%ebp),%eax
  801317:	77 09                	ja     801322 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801319:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801320:	76 14                	jbe    801336 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801322:	83 ec 04             	sub    $0x4,%esp
  801325:	68 b8 3c 80 00       	push   $0x803cb8
  80132a:	6a 68                	push   $0x68
  80132c:	68 d2 3c 80 00       	push   $0x803cd2
  801331:	e8 48 20 00 00       	call   80337e <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801336:	a1 20 50 80 00       	mov    0x805020,%eax
  80133b:	8b 40 74             	mov    0x74(%eax),%eax
  80133e:	3b 45 08             	cmp    0x8(%ebp),%eax
  801341:	77 20                	ja     801363 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801343:	a1 20 50 80 00       	mov    0x805020,%eax
  801348:	8b 40 78             	mov    0x78(%eax),%eax
  80134b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80134e:	76 13                	jbe    801363 <free+0x67>
		free_block(virtual_address);
  801350:	83 ec 0c             	sub    $0xc,%esp
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 6c 16 00 00       	call   8029c7 <free_block>
  80135b:	83 c4 10             	add    $0x10,%esp
		return;
  80135e:	e9 98 00 00 00       	jmp    8013fb <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801363:	8b 55 08             	mov    0x8(%ebp),%edx
  801366:	a1 20 50 80 00       	mov    0x805020,%eax
  80136b:	8b 40 7c             	mov    0x7c(%eax),%eax
  80136e:	29 c2                	sub    %eax,%edx
  801370:	89 d0                	mov    %edx,%eax
  801372:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801377:	c1 e8 0c             	shr    $0xc,%eax
  80137a:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  80137d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801384:	eb 16                	jmp    80139c <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	c7 04 85 40 50 90 00 	movl   $0x0,0x905040(,%eax,4)
  801395:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801399:	ff 45 f4             	incl   -0xc(%ebp)
  80139c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139f:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8013a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013a9:	7f db                	jg     801386 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  8013ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ae:	8b 04 85 40 50 80 00 	mov    0x805040(,%eax,4),%eax
  8013b5:	c1 e0 0c             	shl    $0xc,%eax
  8013b8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013c1:	eb 1a                	jmp    8013dd <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  8013c3:	83 ec 08             	sub    $0x8,%esp
  8013c6:	68 00 10 00 00       	push   $0x1000
  8013cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8013ce:	e8 19 0a 00 00       	call   801dec <sys_free_user_mem>
  8013d3:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  8013d6:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  8013dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013e3:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  8013e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e8:	77 d9                	ja     8013c3 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  8013ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ed:	c7 04 85 40 50 80 00 	movl   $0x0,0x805040(,%eax,4)
  8013f4:	00 00 00 00 
  8013f8:	eb 01                	jmp    8013fb <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  8013fa:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  8013fb:	c9                   	leave  
  8013fc:	c3                   	ret    

008013fd <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
  801400:	83 ec 58             	sub    $0x58,%esp
  801403:	8b 45 10             	mov    0x10(%ebp),%eax
  801406:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140d:	75 0a                	jne    801419 <smalloc+0x1c>
		return NULL;
  80140f:	b8 00 00 00 00       	mov    $0x0,%eax
  801414:	e9 7d 01 00 00       	jmp    801596 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801419:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801420:	8b 55 0c             	mov    0xc(%ebp),%edx
  801423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801426:	01 d0                	add    %edx,%eax
  801428:	48                   	dec    %eax
  801429:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80142c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142f:	ba 00 00 00 00       	mov    $0x0,%edx
  801434:	f7 75 e4             	divl   -0x1c(%ebp)
  801437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143a:	29 d0                	sub    %edx,%eax
  80143c:	c1 e8 0c             	shr    $0xc,%eax
  80143f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801442:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801449:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801450:	a1 20 50 80 00       	mov    0x805020,%eax
  801455:	8b 40 7c             	mov    0x7c(%eax),%eax
  801458:	05 00 10 00 00       	add    $0x1000,%eax
  80145d:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801460:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801465:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801468:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  80146b:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801472:	8b 55 0c             	mov    0xc(%ebp),%edx
  801475:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801478:	01 d0                	add    %edx,%eax
  80147a:	48                   	dec    %eax
  80147b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80147e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801481:	ba 00 00 00 00       	mov    $0x0,%edx
  801486:	f7 75 d0             	divl   -0x30(%ebp)
  801489:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80148c:	29 d0                	sub    %edx,%eax
  80148e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801491:	76 0a                	jbe    80149d <smalloc+0xa0>
		return NULL;
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
  801498:	e9 f9 00 00 00       	jmp    801596 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80149d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014a3:	eb 48                	jmp    8014ed <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  8014a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014a8:	2b 45 d8             	sub    -0x28(%ebp),%eax
  8014ab:	c1 e8 0c             	shr    $0xc,%eax
  8014ae:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  8014b1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8014b4:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	75 11                	jne    8014d0 <smalloc+0xd3>
			freePagesCount++;
  8014bf:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  8014c2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014c6:	75 16                	jne    8014de <smalloc+0xe1>
				start = s;
  8014c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014ce:	eb 0e                	jmp    8014de <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  8014d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8014d7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  8014de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8014e4:	74 12                	je     8014f8 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8014e6:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8014ed:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8014f4:	76 af                	jbe    8014a5 <smalloc+0xa8>
  8014f6:	eb 01                	jmp    8014f9 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  8014f8:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  8014f9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8014fd:	74 08                	je     801507 <smalloc+0x10a>
  8014ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801502:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801505:	74 0a                	je     801511 <smalloc+0x114>
		return NULL;
  801507:	b8 00 00 00 00       	mov    $0x0,%eax
  80150c:	e9 85 00 00 00       	jmp    801596 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801517:	c1 e8 0c             	shr    $0xc,%eax
  80151a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  80151d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801520:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801523:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  80152a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80152d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801530:	eb 11                	jmp    801543 <smalloc+0x146>
		markedPages[s] = 1;
  801532:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801535:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  80153c:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801540:	ff 45 e8             	incl   -0x18(%ebp)
  801543:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801546:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801549:	01 d0                	add    %edx,%eax
  80154b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80154e:	77 e2                	ja     801532 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801553:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801557:	52                   	push   %edx
  801558:	50                   	push   %eax
  801559:	ff 75 0c             	pushl  0xc(%ebp)
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	e8 8f 04 00 00       	call   8019f3 <sys_createSharedObject>
  801564:	83 c4 10             	add    $0x10,%esp
  801567:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  80156a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  80156e:	78 12                	js     801582 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801570:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801573:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801576:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  80157d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801580:	eb 14                	jmp    801596 <smalloc+0x199>
	}
	free((void*) start);
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	83 ec 0c             	sub    $0xc,%esp
  801588:	50                   	push   %eax
  801589:	e8 6e fd ff ff       	call   8012fc <free>
  80158e:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	ff 75 0c             	pushl  0xc(%ebp)
  8015a4:	ff 75 08             	pushl  0x8(%ebp)
  8015a7:	e8 71 04 00 00       	call   801a1d <sys_getSizeOfSharedObject>
  8015ac:	83 c4 10             	add    $0x10,%esp
  8015af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  8015b2:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  8015b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8015bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015bf:	01 d0                	add    %edx,%eax
  8015c1:	48                   	dec    %eax
  8015c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8015c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cd:	f7 75 e0             	divl   -0x20(%ebp)
  8015d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015d3:	29 d0                	sub    %edx,%eax
  8015d5:	c1 e8 0c             	shr    $0xc,%eax
  8015d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  8015db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  8015e2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  8015e9:	a1 20 50 80 00       	mov    0x805020,%eax
  8015ee:	8b 40 7c             	mov    0x7c(%eax),%eax
  8015f1:	05 00 10 00 00       	add    $0x1000,%eax
  8015f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  8015f9:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  8015fe:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801601:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  801604:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80160b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80160e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	48                   	dec    %eax
  801614:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801617:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	f7 75 cc             	divl   -0x34(%ebp)
  801622:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801625:	29 d0                	sub    %edx,%eax
  801627:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80162a:	76 0a                	jbe    801636 <sget+0x9e>
		return NULL;
  80162c:	b8 00 00 00 00       	mov    $0x0,%eax
  801631:	e9 f7 00 00 00       	jmp    80172d <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801636:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801639:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80163c:	eb 48                	jmp    801686 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80163e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801641:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801644:	c1 e8 0c             	shr    $0xc,%eax
  801647:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  80164a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80164d:	8b 04 85 40 50 90 00 	mov    0x905040(,%eax,4),%eax
  801654:	85 c0                	test   %eax,%eax
  801656:	75 11                	jne    801669 <sget+0xd1>
			free_Pages_Count++;
  801658:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80165b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80165f:	75 16                	jne    801677 <sget+0xdf>
				start = s;
  801661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801664:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801667:	eb 0e                	jmp    801677 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  801669:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801670:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  801677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80167d:	74 12                	je     801691 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  80167f:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801686:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  80168d:	76 af                	jbe    80163e <sget+0xa6>
  80168f:	eb 01                	jmp    801692 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  801691:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  801692:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801696:	74 08                	je     8016a0 <sget+0x108>
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80169e:	74 0a                	je     8016aa <sget+0x112>
		return NULL;
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a5:	e9 83 00 00 00       	jmp    80172d <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8016b0:	c1 e8 0c             	shr    $0xc,%eax
  8016b3:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  8016b6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016b9:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016bc:	89 14 85 40 50 80 00 	mov    %edx,0x805040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8016c3:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8016c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016c9:	eb 11                	jmp    8016dc <sget+0x144>
		markedPages[k] = 1;
  8016cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ce:	c7 04 85 40 50 90 00 	movl   $0x1,0x905040(,%eax,4)
  8016d5:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  8016d9:	ff 45 e8             	incl   -0x18(%ebp)
  8016dc:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8016df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8016e7:	77 e2                	ja     8016cb <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  8016e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	50                   	push   %eax
  8016f0:	ff 75 0c             	pushl  0xc(%ebp)
  8016f3:	ff 75 08             	pushl  0x8(%ebp)
  8016f6:	e8 3f 03 00 00       	call   801a3a <sys_getSharedObject>
  8016fb:	83 c4 10             	add    $0x10,%esp
  8016fe:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  801701:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  801705:	78 12                	js     801719 <sget+0x181>
		shardIDs[startPage] = ss;
  801707:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80170a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80170d:	89 14 85 40 50 88 00 	mov    %edx,0x885040(,%eax,4)
		return (void*) start;
  801714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801717:	eb 14                	jmp    80172d <sget+0x195>
	}
	free((void*) start);
  801719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171c:	83 ec 0c             	sub    $0xc,%esp
  80171f:	50                   	push   %eax
  801720:	e8 d7 fb ff ff       	call   8012fc <free>
  801725:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801735:	8b 55 08             	mov    0x8(%ebp),%edx
  801738:	a1 20 50 80 00       	mov    0x805020,%eax
  80173d:	8b 40 7c             	mov    0x7c(%eax),%eax
  801740:	29 c2                	sub    %eax,%edx
  801742:	89 d0                	mov    %edx,%eax
  801744:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  801749:	c1 e8 0c             	shr    $0xc,%eax
  80174c:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80174f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801752:	8b 04 85 40 50 88 00 	mov    0x885040(,%eax,4),%eax
  801759:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80175c:	83 ec 08             	sub    $0x8,%esp
  80175f:	ff 75 08             	pushl  0x8(%ebp)
  801762:	ff 75 f0             	pushl  -0x10(%ebp)
  801765:	e8 ef 02 00 00       	call   801a59 <sys_freeSharedObject>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  801770:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801774:	75 0e                	jne    801784 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  801776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801779:	c7 04 85 40 50 88 00 	movl   $0xffffffff,0x885040(,%eax,4)
  801780:	ff ff ff ff 
	}

}
  801784:	90                   	nop
  801785:	c9                   	leave  
  801786:	c3                   	ret    

00801787 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 e0 3c 80 00       	push   $0x803ce0
  801795:	68 19 01 00 00       	push   $0x119
  80179a:	68 d2 3c 80 00       	push   $0x803cd2
  80179f:	e8 da 1b 00 00       	call   80337e <_panic>

008017a4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 06 3d 80 00       	push   $0x803d06
  8017b2:	68 23 01 00 00       	push   $0x123
  8017b7:	68 d2 3c 80 00       	push   $0x803cd2
  8017bc:	e8 bd 1b 00 00       	call   80337e <_panic>

008017c1 <shrink>:

}
void shrink(uint32 newSize) {
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 06 3d 80 00       	push   $0x803d06
  8017cf:	68 27 01 00 00       	push   $0x127
  8017d4:	68 d2 3c 80 00       	push   $0x803cd2
  8017d9:	e8 a0 1b 00 00       	call   80337e <_panic>

008017de <freeHeap>:

}
void freeHeap(void* virtual_address) {
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 06 3d 80 00       	push   $0x803d06
  8017ec:	68 2b 01 00 00       	push   $0x12b
  8017f1:	68 d2 3c 80 00       	push   $0x803cd2
  8017f6:	e8 83 1b 00 00       	call   80337e <_panic>

008017fb <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	57                   	push   %edi
  8017ff:	56                   	push   %esi
  801800:	53                   	push   %ebx
  801801:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80180d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801810:	8b 7d 18             	mov    0x18(%ebp),%edi
  801813:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801816:	cd 30                	int    $0x30
  801818:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80181b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	5b                   	pop    %ebx
  801822:	5e                   	pop    %esi
  801823:	5f                   	pop    %edi
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 04             	sub    $0x4,%esp
  80182c:	8b 45 10             	mov    0x10(%ebp),%eax
  80182f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801832:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	52                   	push   %edx
  80183e:	ff 75 0c             	pushl  0xc(%ebp)
  801841:	50                   	push   %eax
  801842:	6a 00                	push   $0x0
  801844:	e8 b2 ff ff ff       	call   8017fb <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	90                   	nop
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_cgetc>:

int sys_cgetc(void) {
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	6a 02                	push   $0x2
  80185e:	e8 98 ff ff ff       	call   8017fb <syscall>
  801863:	83 c4 18             	add    $0x18,%esp
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <sys_lock_cons>:

void sys_lock_cons(void) {
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 03                	push   $0x3
  801877:	e8 7f ff ff ff       	call   8017fb <syscall>
  80187c:	83 c4 18             	add    $0x18,%esp
}
  80187f:	90                   	nop
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801885:	6a 00                	push   $0x0
  801887:	6a 00                	push   $0x0
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 04                	push   $0x4
  801891:	e8 65 ff ff ff       	call   8017fb <syscall>
  801896:	83 c4 18             	add    $0x18,%esp
}
  801899:	90                   	nop
  80189a:	c9                   	leave  
  80189b:	c3                   	ret    

0080189c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80189f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	52                   	push   %edx
  8018ac:	50                   	push   %eax
  8018ad:	6a 08                	push   $0x8
  8018af:	e8 47 ff ff ff       	call   8017fb <syscall>
  8018b4:	83 c4 18             	add    $0x18,%esp
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	56                   	push   %esi
  8018bd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8018be:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	56                   	push   %esi
  8018ce:	53                   	push   %ebx
  8018cf:	51                   	push   %ecx
  8018d0:	52                   	push   %edx
  8018d1:	50                   	push   %eax
  8018d2:	6a 09                	push   $0x9
  8018d4:	e8 22 ff ff ff       	call   8017fb <syscall>
  8018d9:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8018dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5e                   	pop    %esi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 0a                	push   $0xa
  8018f6:	e8 00 ff ff ff       	call   8017fb <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	6a 0b                	push   $0xb
  801911:	e8 e5 fe ff ff       	call   8017fb <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 0c                	push   $0xc
  80192a:	e8 cc fe ff ff       	call   8017fb <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 0d                	push   $0xd
  801943:	e8 b3 fe ff ff       	call   8017fb <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 0e                	push   $0xe
  80195c:	e8 9a fe ff ff       	call   8017fb <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 0f                	push   $0xf
  801975:	e8 81 fe ff ff       	call   8017fb <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	ff 75 08             	pushl  0x8(%ebp)
  80198d:	6a 10                	push   $0x10
  80198f:	e8 67 fe ff ff       	call   8017fb <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_scarce_memory>:

void sys_scarce_memory() {
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 11                	push   $0x11
  8019a8:	e8 4e fe ff ff       	call   8017fb <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	90                   	nop
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_cputc>:

void sys_cputc(const char c) {
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 04             	sub    $0x4,%esp
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019bf:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	50                   	push   %eax
  8019cc:	6a 01                	push   $0x1
  8019ce:	e8 28 fe ff ff       	call   8017fb <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	90                   	nop
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 14                	push   $0x14
  8019e8:	e8 0e fe ff ff       	call   8017fb <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	90                   	nop
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8019ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a02:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	6a 00                	push   $0x0
  801a0b:	51                   	push   %ecx
  801a0c:	52                   	push   %edx
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	50                   	push   %eax
  801a11:	6a 15                	push   $0x15
  801a13:	e8 e3 fd ff ff       	call   8017fb <syscall>
  801a18:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801a1b:	c9                   	leave  
  801a1c:	c3                   	ret    

00801a1d <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a23:	8b 45 08             	mov    0x8(%ebp),%eax
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	52                   	push   %edx
  801a2d:	50                   	push   %eax
  801a2e:	6a 16                	push   $0x16
  801a30:	e8 c6 fd ff ff       	call   8017fb <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801a3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	51                   	push   %ecx
  801a4b:	52                   	push   %edx
  801a4c:	50                   	push   %eax
  801a4d:	6a 17                	push   $0x17
  801a4f:	e8 a7 fd ff ff       	call   8017fb <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	6a 18                	push   $0x18
  801a6c:	e8 8a fd ff ff       	call   8017fb <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	ff 75 14             	pushl  0x14(%ebp)
  801a81:	ff 75 10             	pushl  0x10(%ebp)
  801a84:	ff 75 0c             	pushl  0xc(%ebp)
  801a87:	50                   	push   %eax
  801a88:	6a 19                	push   $0x19
  801a8a:	e8 6c fd ff ff       	call   8017fb <syscall>
  801a8f:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_run_env>:

void sys_run_env(int32 envId) {
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	50                   	push   %eax
  801aa3:	6a 1a                	push   $0x1a
  801aa5:	e8 51 fd ff ff       	call   8017fb <syscall>
  801aaa:	83 c4 18             	add    $0x18,%esp
}
  801aad:	90                   	nop
  801aae:	c9                   	leave  
  801aaf:	c3                   	ret    

00801ab0 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801ab0:	55                   	push   %ebp
  801ab1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	50                   	push   %eax
  801abf:	6a 1b                	push   $0x1b
  801ac1:	e8 35 fd ff ff       	call   8017fb <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getenvid>:

int32 sys_getenvid(void) {
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 05                	push   $0x5
  801ada:	e8 1c fd ff ff       	call   8017fb <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 06                	push   $0x6
  801af3:	e8 03 fd ff ff       	call   8017fb <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 07                	push   $0x7
  801b0c:	e8 ea fc ff ff       	call   8017fb <syscall>
  801b11:	83 c4 18             	add    $0x18,%esp
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <sys_exit_env>:

void sys_exit_env(void) {
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 1c                	push   $0x1c
  801b25:	e8 d1 fc ff ff       	call   8017fb <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	90                   	nop
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801b36:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b39:	8d 50 04             	lea    0x4(%eax),%edx
  801b3c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	52                   	push   %edx
  801b46:	50                   	push   %eax
  801b47:	6a 1d                	push   $0x1d
  801b49:	e8 ad fc ff ff       	call   8017fb <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801b51:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b54:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b5a:	89 01                	mov    %eax,(%ecx)
  801b5c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	c9                   	leave  
  801b63:	c2 04 00             	ret    $0x4

00801b66 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	ff 75 10             	pushl  0x10(%ebp)
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	6a 13                	push   $0x13
  801b78:	e8 7e fc ff ff       	call   8017fb <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801b80:	90                   	nop
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_rcr2>:
uint32 sys_rcr2() {
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 1e                	push   $0x1e
  801b92:	e8 64 fc ff ff       	call   8017fb <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
  801b9f:	83 ec 04             	sub    $0x4,%esp
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ba8:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	50                   	push   %eax
  801bb5:	6a 1f                	push   $0x1f
  801bb7:	e8 3f fc ff ff       	call   8017fb <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
	return;
  801bbf:	90                   	nop
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <rsttst>:
void rsttst() {
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 21                	push   $0x21
  801bd1:	e8 25 fc ff ff       	call   8017fb <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
	return;
  801bd9:	90                   	nop
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	8b 45 14             	mov    0x14(%ebp),%eax
  801be5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801be8:	8b 55 18             	mov    0x18(%ebp),%edx
  801beb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 10             	pushl  0x10(%ebp)
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	6a 20                	push   $0x20
  801bfc:	e8 fa fb ff ff       	call   8017fb <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
	return;
  801c04:	90                   	nop
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <chktst>:
void chktst(uint32 n) {
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	ff 75 08             	pushl  0x8(%ebp)
  801c15:	6a 22                	push   $0x22
  801c17:	e8 df fb ff ff       	call   8017fb <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
	return;
  801c1f:	90                   	nop
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <inctst>:

void inctst() {
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 23                	push   $0x23
  801c31:	e8 c5 fb ff ff       	call   8017fb <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
	return;
  801c39:	90                   	nop
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <gettst>:
uint32 gettst() {
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 24                	push   $0x24
  801c4b:	e8 ab fb ff ff       	call   8017fb <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 25                	push   $0x25
  801c67:	e8 8f fb ff ff       	call   8017fb <syscall>
  801c6c:	83 c4 18             	add    $0x18,%esp
  801c6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c72:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c76:	75 07                	jne    801c7f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c78:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7d:	eb 05                	jmp    801c84 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 25                	push   $0x25
  801c98:	e8 5e fb ff ff       	call   8017fb <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
  801ca0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ca3:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ca7:	75 07                	jne    801cb0 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cae:	eb 05                	jmp    801cb5 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 25                	push   $0x25
  801cc9:	e8 2d fb ff ff       	call   8017fb <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
  801cd1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cd4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cd8:	75 07                	jne    801ce1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801cda:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdf:	eb 05                	jmp    801ce6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ce1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 25                	push   $0x25
  801cfa:	e8 fc fa ff ff       	call   8017fb <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
  801d02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d05:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d09:	75 07                	jne    801d12 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d10:	eb 05                	jmp    801d17 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	ff 75 08             	pushl  0x8(%ebp)
  801d27:	6a 26                	push   $0x26
  801d29:	e8 cd fa ff ff       	call   8017fb <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801d38:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d3b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	6a 00                	push   $0x0
  801d46:	53                   	push   %ebx
  801d47:	51                   	push   %ecx
  801d48:	52                   	push   %edx
  801d49:	50                   	push   %eax
  801d4a:	6a 27                	push   $0x27
  801d4c:	e8 aa fa ff ff       	call   8017fb <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801d54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	52                   	push   %edx
  801d69:	50                   	push   %eax
  801d6a:	6a 28                	push   $0x28
  801d6c:	e8 8a fa ff ff       	call   8017fb <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801d79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	51                   	push   %ecx
  801d85:	ff 75 10             	pushl  0x10(%ebp)
  801d88:	52                   	push   %edx
  801d89:	50                   	push   %eax
  801d8a:	6a 29                	push   $0x29
  801d8c:	e8 6a fa ff ff       	call   8017fb <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	ff 75 10             	pushl  0x10(%ebp)
  801da0:	ff 75 0c             	pushl  0xc(%ebp)
  801da3:	ff 75 08             	pushl  0x8(%ebp)
  801da6:	6a 12                	push   $0x12
  801da8:	e8 4e fa ff ff       	call   8017fb <syscall>
  801dad:	83 c4 18             	add    $0x18,%esp
	return;
  801db0:	90                   	nop
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801db6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	52                   	push   %edx
  801dc3:	50                   	push   %eax
  801dc4:	6a 2a                	push   $0x2a
  801dc6:	e8 30 fa ff ff       	call   8017fb <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
	return;
  801dce:	90                   	nop
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	50                   	push   %eax
  801de0:	6a 2b                	push   $0x2b
  801de2:	e8 14 fa ff ff       	call   8017fb <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	ff 75 0c             	pushl  0xc(%ebp)
  801df8:	ff 75 08             	pushl  0x8(%ebp)
  801dfb:	6a 2c                	push   $0x2c
  801dfd:	e8 f9 f9 ff ff       	call   8017fb <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
	return;
  801e05:	90                   	nop
}
  801e06:	c9                   	leave  
  801e07:	c3                   	ret    

00801e08 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	ff 75 0c             	pushl  0xc(%ebp)
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	6a 2d                	push   $0x2d
  801e19:	e8 dd f9 ff ff       	call   8017fb <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
	return;
  801e21:	90                   	nop
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	50                   	push   %eax
  801e33:	6a 2f                	push   $0x2f
  801e35:	e8 c1 f9 ff ff       	call   8017fb <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
	return;
  801e3d:	90                   	nop
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 45 08             	mov    0x8(%ebp),%eax
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	52                   	push   %edx
  801e50:	50                   	push   %eax
  801e51:	6a 30                	push   $0x30
  801e53:	e8 a3 f9 ff ff       	call   8017fb <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
	return;
  801e5b:	90                   	nop
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	50                   	push   %eax
  801e6d:	6a 31                	push   $0x31
  801e6f:	e8 87 f9 ff ff       	call   8017fb <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
	return;
  801e77:	90                   	nop
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	8b 45 08             	mov    0x8(%ebp),%eax
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	52                   	push   %edx
  801e8a:	50                   	push   %eax
  801e8b:	6a 2e                	push   $0x2e
  801e8d:	e8 69 f9 ff ff       	call   8017fb <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
    return;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea1:	83 e8 04             	sub    $0x4,%eax
  801ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  801ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801eaa:	8b 00                	mov    (%eax),%eax
  801eac:	83 e0 fe             	and    $0xfffffffe,%eax
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	83 e8 04             	sub    $0x4,%eax
  801ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  801ec0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ec3:	8b 00                	mov    (%eax),%eax
  801ec5:	83 e0 01             	and    $0x1,%eax
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	0f 94 c0             	sete   %al
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  801ed5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  801edc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edf:	83 f8 02             	cmp    $0x2,%eax
  801ee2:	74 2b                	je     801f0f <alloc_block+0x40>
  801ee4:	83 f8 02             	cmp    $0x2,%eax
  801ee7:	7f 07                	jg     801ef0 <alloc_block+0x21>
  801ee9:	83 f8 01             	cmp    $0x1,%eax
  801eec:	74 0e                	je     801efc <alloc_block+0x2d>
  801eee:	eb 58                	jmp    801f48 <alloc_block+0x79>
  801ef0:	83 f8 03             	cmp    $0x3,%eax
  801ef3:	74 2d                	je     801f22 <alloc_block+0x53>
  801ef5:	83 f8 04             	cmp    $0x4,%eax
  801ef8:	74 3b                	je     801f35 <alloc_block+0x66>
  801efa:	eb 4c                	jmp    801f48 <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  801efc:	83 ec 0c             	sub    $0xc,%esp
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	e8 f7 03 00 00       	call   8022fe <alloc_block_FF>
  801f07:	83 c4 10             	add    $0x10,%esp
  801f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f0d:	eb 4a                	jmp    801f59 <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	ff 75 08             	pushl  0x8(%ebp)
  801f15:	e8 f0 11 00 00       	call   80310a <alloc_block_NF>
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f20:	eb 37                	jmp    801f59 <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  801f22:	83 ec 0c             	sub    $0xc,%esp
  801f25:	ff 75 08             	pushl  0x8(%ebp)
  801f28:	e8 08 08 00 00       	call   802735 <alloc_block_BF>
  801f2d:	83 c4 10             	add    $0x10,%esp
  801f30:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f33:	eb 24                	jmp    801f59 <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	ff 75 08             	pushl  0x8(%ebp)
  801f3b:	e8 ad 11 00 00       	call   8030ed <alloc_block_WF>
  801f40:	83 c4 10             	add    $0x10,%esp
  801f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  801f46:	eb 11                	jmp    801f59 <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  801f48:	83 ec 0c             	sub    $0xc,%esp
  801f4b:	68 18 3d 80 00       	push   $0x803d18
  801f50:	e8 41 e4 ff ff       	call   800396 <cprintf>
  801f55:	83 c4 10             	add    $0x10,%esp
		break;
  801f58:	90                   	nop
	}
	return va;
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801f5c:	c9                   	leave  
  801f5d:	c3                   	ret    

00801f5e <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  801f5e:	55                   	push   %ebp
  801f5f:	89 e5                	mov    %esp,%ebp
  801f61:	53                   	push   %ebx
  801f62:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 38 3d 80 00       	push   $0x803d38
  801f6d:	e8 24 e4 ff ff       	call   800396 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	68 63 3d 80 00       	push   $0x803d63
  801f7d:	e8 14 e4 ff ff       	call   800396 <cprintf>
  801f82:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8b:	eb 37                	jmp    801fc4 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	ff 75 f4             	pushl  -0xc(%ebp)
  801f93:	e8 19 ff ff ff       	call   801eb1 <is_free_block>
  801f98:	83 c4 10             	add    $0x10,%esp
  801f9b:	0f be d8             	movsbl %al,%ebx
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fa4:	e8 ef fe ff ff       	call   801e98 <get_block_size>
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	83 ec 04             	sub    $0x4,%esp
  801faf:	53                   	push   %ebx
  801fb0:	50                   	push   %eax
  801fb1:	68 7b 3d 80 00       	push   $0x803d7b
  801fb6:	e8 db e3 ff ff       	call   800396 <cprintf>
  801fbb:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  801fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc8:	74 07                	je     801fd1 <print_blocks_list+0x73>
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 00                	mov    (%eax),%eax
  801fcf:	eb 05                	jmp    801fd6 <print_blocks_list+0x78>
  801fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd6:	89 45 10             	mov    %eax,0x10(%ebp)
  801fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	75 ad                	jne    801f8d <print_blocks_list+0x2f>
  801fe0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe4:	75 a7                	jne    801f8d <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  801fe6:	83 ec 0c             	sub    $0xc,%esp
  801fe9:	68 38 3d 80 00       	push   $0x803d38
  801fee:	e8 a3 e3 ff ff       	call   800396 <cprintf>
  801ff3:	83 c4 10             	add    $0x10,%esp

}
  801ff6:	90                   	nop
  801ff7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  802002:	8b 45 0c             	mov    0xc(%ebp),%eax
  802005:	83 e0 01             	and    $0x1,%eax
  802008:	85 c0                	test   %eax,%eax
  80200a:	74 03                	je     80200f <initialize_dynamic_allocator+0x13>
  80200c:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  80200f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802013:	0f 84 f8 00 00 00    	je     802111 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  802019:	c7 05 40 50 98 00 01 	movl   $0x1,0x985040
  802020:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  802023:	a1 40 50 98 00       	mov    0x985040,%eax
  802028:	85 c0                	test   %eax,%eax
  80202a:	0f 84 e2 00 00 00    	je     802112 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  80203f:	8b 55 08             	mov    0x8(%ebp),%edx
  802042:	8b 45 0c             	mov    0xc(%ebp),%eax
  802045:	01 d0                	add    %edx,%eax
  802047:	83 e8 04             	sub    $0x4,%eax
  80204a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	83 c0 08             	add    $0x8,%eax
  80205c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  80205f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802062:	83 e8 08             	sub    $0x8,%eax
  802065:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 e8             	pushl  -0x18(%ebp)
  802070:	ff 75 ec             	pushl  -0x14(%ebp)
  802073:	e8 9c 00 00 00       	call   802114 <set_block_data>
  802078:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80207b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802084:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802087:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  80208e:	c7 05 48 50 98 00 00 	movl   $0x0,0x985048
  802095:	00 00 00 
  802098:	c7 05 4c 50 98 00 00 	movl   $0x0,0x98504c
  80209f:	00 00 00 
  8020a2:	c7 05 54 50 98 00 00 	movl   $0x0,0x985054
  8020a9:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  8020ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020b0:	75 17                	jne    8020c9 <initialize_dynamic_allocator+0xcd>
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	68 94 3d 80 00       	push   $0x803d94
  8020ba:	68 80 00 00 00       	push   $0x80
  8020bf:	68 b7 3d 80 00       	push   $0x803db7
  8020c4:	e8 b5 12 00 00       	call   80337e <_panic>
  8020c9:	8b 15 48 50 98 00    	mov    0x985048,%edx
  8020cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d2:	89 10                	mov    %edx,(%eax)
  8020d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020d7:	8b 00                	mov    (%eax),%eax
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	74 0d                	je     8020ea <initialize_dynamic_allocator+0xee>
  8020dd:	a1 48 50 98 00       	mov    0x985048,%eax
  8020e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8020e5:	89 50 04             	mov    %edx,0x4(%eax)
  8020e8:	eb 08                	jmp    8020f2 <initialize_dynamic_allocator+0xf6>
  8020ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020ed:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8020f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020f5:	a3 48 50 98 00       	mov    %eax,0x985048
  8020fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802104:	a1 54 50 98 00       	mov    0x985054,%eax
  802109:	40                   	inc    %eax
  80210a:	a3 54 50 98 00       	mov    %eax,0x985054
  80210f:	eb 01                	jmp    802112 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  802111:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  80211a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211d:	83 e0 01             	and    $0x1,%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 03                	je     802127 <set_block_data+0x13>
	{
		totalSize++;
  802124:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	83 e8 04             	sub    $0x4,%eax
  80212d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  802130:	8b 45 0c             	mov    0xc(%ebp),%eax
  802133:	83 e0 fe             	and    $0xfffffffe,%eax
  802136:	89 c2                	mov    %eax,%edx
  802138:	8b 45 10             	mov    0x10(%ebp),%eax
  80213b:	83 e0 01             	and    $0x1,%eax
  80213e:	09 c2                	or     %eax,%edx
  802140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802143:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  802145:	8b 45 0c             	mov    0xc(%ebp),%eax
  802148:	8d 50 f8             	lea    -0x8(%eax),%edx
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	01 d0                	add    %edx,%eax
  802150:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  802153:	8b 45 0c             	mov    0xc(%ebp),%eax
  802156:	83 e0 fe             	and    $0xfffffffe,%eax
  802159:	89 c2                	mov    %eax,%edx
  80215b:	8b 45 10             	mov    0x10(%ebp),%eax
  80215e:	83 e0 01             	and    $0x1,%eax
  802161:	09 c2                	or     %eax,%edx
  802163:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802166:	89 10                	mov    %edx,(%eax)
}
  802168:	90                   	nop
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802171:	a1 48 50 98 00       	mov    0x985048,%eax
  802176:	85 c0                	test   %eax,%eax
  802178:	75 68                	jne    8021e2 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80217a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217e:	75 17                	jne    802197 <insert_sorted_in_freeList+0x2c>
  802180:	83 ec 04             	sub    $0x4,%esp
  802183:	68 94 3d 80 00       	push   $0x803d94
  802188:	68 9d 00 00 00       	push   $0x9d
  80218d:	68 b7 3d 80 00       	push   $0x803db7
  802192:	e8 e7 11 00 00       	call   80337e <_panic>
  802197:	8b 15 48 50 98 00    	mov    0x985048,%edx
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	89 10                	mov    %edx,(%eax)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 00                	mov    (%eax),%eax
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	74 0d                	je     8021b8 <insert_sorted_in_freeList+0x4d>
  8021ab:	a1 48 50 98 00       	mov    0x985048,%eax
  8021b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b3:	89 50 04             	mov    %edx,0x4(%eax)
  8021b6:	eb 08                	jmp    8021c0 <insert_sorted_in_freeList+0x55>
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	a3 48 50 98 00       	mov    %eax,0x985048
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d2:	a1 54 50 98 00       	mov    0x985054,%eax
  8021d7:	40                   	inc    %eax
  8021d8:	a3 54 50 98 00       	mov    %eax,0x985054
		return;
  8021dd:	e9 1a 01 00 00       	jmp    8022fc <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  8021e2:	a1 48 50 98 00       	mov    0x985048,%eax
  8021e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ea:	eb 7f                	jmp    80226b <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f2:	76 6f                	jbe    802263 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  8021f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021f8:	74 06                	je     802200 <insert_sorted_in_freeList+0x95>
  8021fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fe:	75 17                	jne    802217 <insert_sorted_in_freeList+0xac>
  802200:	83 ec 04             	sub    $0x4,%esp
  802203:	68 d0 3d 80 00       	push   $0x803dd0
  802208:	68 a6 00 00 00       	push   $0xa6
  80220d:	68 b7 3d 80 00       	push   $0x803db7
  802212:	e8 67 11 00 00       	call   80337e <_panic>
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 50 04             	mov    0x4(%eax),%edx
  80221d:	8b 45 08             	mov    0x8(%ebp),%eax
  802220:	89 50 04             	mov    %edx,0x4(%eax)
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802229:	89 10                	mov    %edx,(%eax)
  80222b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222e:	8b 40 04             	mov    0x4(%eax),%eax
  802231:	85 c0                	test   %eax,%eax
  802233:	74 0d                	je     802242 <insert_sorted_in_freeList+0xd7>
  802235:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802238:	8b 40 04             	mov    0x4(%eax),%eax
  80223b:	8b 55 08             	mov    0x8(%ebp),%edx
  80223e:	89 10                	mov    %edx,(%eax)
  802240:	eb 08                	jmp    80224a <insert_sorted_in_freeList+0xdf>
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	a3 48 50 98 00       	mov    %eax,0x985048
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 55 08             	mov    0x8(%ebp),%edx
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	a1 54 50 98 00       	mov    0x985054,%eax
  802258:	40                   	inc    %eax
  802259:	a3 54 50 98 00       	mov    %eax,0x985054
			return;
  80225e:	e9 99 00 00 00       	jmp    8022fc <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802263:	a1 50 50 98 00       	mov    0x985050,%eax
  802268:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226f:	74 07                	je     802278 <insert_sorted_in_freeList+0x10d>
  802271:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802274:	8b 00                	mov    (%eax),%eax
  802276:	eb 05                	jmp    80227d <insert_sorted_in_freeList+0x112>
  802278:	b8 00 00 00 00       	mov    $0x0,%eax
  80227d:	a3 50 50 98 00       	mov    %eax,0x985050
  802282:	a1 50 50 98 00       	mov    0x985050,%eax
  802287:	85 c0                	test   %eax,%eax
  802289:	0f 85 5d ff ff ff    	jne    8021ec <insert_sorted_in_freeList+0x81>
  80228f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802293:	0f 85 53 ff ff ff    	jne    8021ec <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  802299:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229d:	75 17                	jne    8022b6 <insert_sorted_in_freeList+0x14b>
  80229f:	83 ec 04             	sub    $0x4,%esp
  8022a2:	68 08 3e 80 00       	push   $0x803e08
  8022a7:	68 ab 00 00 00       	push   $0xab
  8022ac:	68 b7 3d 80 00       	push   $0x803db7
  8022b1:	e8 c8 10 00 00       	call   80337e <_panic>
  8022b6:	8b 15 4c 50 98 00    	mov    0x98504c,%edx
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	89 50 04             	mov    %edx,0x4(%eax)
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	8b 40 04             	mov    0x4(%eax),%eax
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	74 0c                	je     8022d8 <insert_sorted_in_freeList+0x16d>
  8022cc:	a1 4c 50 98 00       	mov    0x98504c,%eax
  8022d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
  8022d6:	eb 08                	jmp    8022e0 <insert_sorted_in_freeList+0x175>
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	a3 48 50 98 00       	mov    %eax,0x985048
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f1:	a1 54 50 98 00       	mov    0x985054,%eax
  8022f6:	40                   	inc    %eax
  8022f7:	a3 54 50 98 00       	mov    %eax,0x985054
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	83 e0 01             	and    $0x1,%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	74 03                	je     802311 <alloc_block_FF+0x13>
  80230e:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  802311:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  802315:	77 07                	ja     80231e <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  802317:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  80231e:	a1 40 50 98 00       	mov    0x985040,%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	75 63                	jne    80238a <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	83 c0 10             	add    $0x10,%eax
  80232d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  802330:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802337:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80233a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233d:	01 d0                	add    %edx,%eax
  80233f:	48                   	dec    %eax
  802340:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802346:	ba 00 00 00 00       	mov    $0x0,%edx
  80234b:	f7 75 ec             	divl   -0x14(%ebp)
  80234e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802351:	29 d0                	sub    %edx,%eax
  802353:	c1 e8 0c             	shr    $0xc,%eax
  802356:	83 ec 0c             	sub    $0xc,%esp
  802359:	50                   	push   %eax
  80235a:	e8 d1 ed ff ff       	call   801130 <sbrk>
  80235f:	83 c4 10             	add    $0x10,%esp
  802362:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802365:	83 ec 0c             	sub    $0xc,%esp
  802368:	6a 00                	push   $0x0
  80236a:	e8 c1 ed ff ff       	call   801130 <sbrk>
  80236f:	83 c4 10             	add    $0x10,%esp
  802372:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802378:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80237b:	83 ec 08             	sub    $0x8,%esp
  80237e:	50                   	push   %eax
  80237f:	ff 75 e4             	pushl  -0x1c(%ebp)
  802382:	e8 75 fc ff ff       	call   801ffc <initialize_dynamic_allocator>
  802387:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80238a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238e:	75 0a                	jne    80239a <alloc_block_FF+0x9c>
	{
		return NULL;
  802390:	b8 00 00 00 00       	mov    $0x0,%eax
  802395:	e9 99 03 00 00       	jmp    802733 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	83 c0 08             	add    $0x8,%eax
  8023a0:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8023a3:	a1 48 50 98 00       	mov    0x985048,%eax
  8023a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ab:	e9 03 02 00 00       	jmp    8025b3 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  8023b0:	83 ec 0c             	sub    $0xc,%esp
  8023b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8023b6:	e8 dd fa ff ff       	call   801e98 <get_block_size>
  8023bb:	83 c4 10             	add    $0x10,%esp
  8023be:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  8023c1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8023c4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8023c7:	0f 82 de 01 00 00    	jb     8025ab <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  8023cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023d0:	83 c0 10             	add    $0x10,%eax
  8023d3:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  8023d6:	0f 87 32 01 00 00    	ja     80250e <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  8023dc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8023df:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8023e2:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  8023e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8023eb:	01 d0                	add    %edx,%eax
  8023ed:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  8023f0:	83 ec 04             	sub    $0x4,%esp
  8023f3:	6a 00                	push   $0x0
  8023f5:	ff 75 98             	pushl  -0x68(%ebp)
  8023f8:	ff 75 94             	pushl  -0x6c(%ebp)
  8023fb:	e8 14 fd ff ff       	call   802114 <set_block_data>
  802400:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  802403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802407:	74 06                	je     80240f <alloc_block_FF+0x111>
  802409:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  80240d:	75 17                	jne    802426 <alloc_block_FF+0x128>
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 2c 3e 80 00       	push   $0x803e2c
  802417:	68 de 00 00 00       	push   $0xde
  80241c:	68 b7 3d 80 00       	push   $0x803db7
  802421:	e8 58 0f 00 00       	call   80337e <_panic>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 10                	mov    (%eax),%edx
  80242b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80242e:	89 10                	mov    %edx,(%eax)
  802430:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 0b                	je     802444 <alloc_block_FF+0x146>
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	8b 55 94             	mov    -0x6c(%ebp),%edx
  802441:	89 50 04             	mov    %edx,0x4(%eax)
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 55 94             	mov    -0x6c(%ebp),%edx
  80244a:	89 10                	mov    %edx,(%eax)
  80244c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80244f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802452:	89 50 04             	mov    %edx,0x4(%eax)
  802455:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	75 08                	jne    802466 <alloc_block_FF+0x168>
  80245e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802461:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802466:	a1 54 50 98 00       	mov    0x985054,%eax
  80246b:	40                   	inc    %eax
  80246c:	a3 54 50 98 00       	mov    %eax,0x985054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802471:	83 ec 04             	sub    $0x4,%esp
  802474:	6a 01                	push   $0x1
  802476:	ff 75 dc             	pushl  -0x24(%ebp)
  802479:	ff 75 f4             	pushl  -0xc(%ebp)
  80247c:	e8 93 fc ff ff       	call   802114 <set_block_data>
  802481:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802488:	75 17                	jne    8024a1 <alloc_block_FF+0x1a3>
  80248a:	83 ec 04             	sub    $0x4,%esp
  80248d:	68 60 3e 80 00       	push   $0x803e60
  802492:	68 e3 00 00 00       	push   $0xe3
  802497:	68 b7 3d 80 00       	push   $0x803db7
  80249c:	e8 dd 0e 00 00       	call   80337e <_panic>
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 00                	mov    (%eax),%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	74 10                	je     8024ba <alloc_block_FF+0x1bc>
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 00                	mov    (%eax),%eax
  8024af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b2:	8b 52 04             	mov    0x4(%edx),%edx
  8024b5:	89 50 04             	mov    %edx,0x4(%eax)
  8024b8:	eb 0b                	jmp    8024c5 <alloc_block_FF+0x1c7>
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	8b 40 04             	mov    0x4(%eax),%eax
  8024c0:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 40 04             	mov    0x4(%eax),%eax
  8024cb:	85 c0                	test   %eax,%eax
  8024cd:	74 0f                	je     8024de <alloc_block_FF+0x1e0>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d8:	8b 12                	mov    (%edx),%edx
  8024da:	89 10                	mov    %edx,(%eax)
  8024dc:	eb 0a                	jmp    8024e8 <alloc_block_FF+0x1ea>
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	a3 48 50 98 00       	mov    %eax,0x985048
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fb:	a1 54 50 98 00       	mov    0x985054,%eax
  802500:	48                   	dec    %eax
  802501:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	e9 25 02 00 00       	jmp    802733 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  80250e:	83 ec 04             	sub    $0x4,%esp
  802511:	6a 01                	push   $0x1
  802513:	ff 75 9c             	pushl  -0x64(%ebp)
  802516:	ff 75 f4             	pushl  -0xc(%ebp)
  802519:	e8 f6 fb ff ff       	call   802114 <set_block_data>
  80251e:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802525:	75 17                	jne    80253e <alloc_block_FF+0x240>
  802527:	83 ec 04             	sub    $0x4,%esp
  80252a:	68 60 3e 80 00       	push   $0x803e60
  80252f:	68 eb 00 00 00       	push   $0xeb
  802534:	68 b7 3d 80 00       	push   $0x803db7
  802539:	e8 40 0e 00 00       	call   80337e <_panic>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	85 c0                	test   %eax,%eax
  802545:	74 10                	je     802557 <alloc_block_FF+0x259>
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 00                	mov    (%eax),%eax
  80254c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254f:	8b 52 04             	mov    0x4(%edx),%edx
  802552:	89 50 04             	mov    %edx,0x4(%eax)
  802555:	eb 0b                	jmp    802562 <alloc_block_FF+0x264>
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 04             	mov    0x4(%eax),%eax
  80255d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 04             	mov    0x4(%eax),%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	74 0f                	je     80257b <alloc_block_FF+0x27d>
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 40 04             	mov    0x4(%eax),%eax
  802572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802575:	8b 12                	mov    (%edx),%edx
  802577:	89 10                	mov    %edx,(%eax)
  802579:	eb 0a                	jmp    802585 <alloc_block_FF+0x287>
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	a3 48 50 98 00       	mov    %eax,0x985048
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802598:	a1 54 50 98 00       	mov    0x985054,%eax
  80259d:	48                   	dec    %eax
  80259e:	a3 54 50 98 00       	mov    %eax,0x985054
				return (void*)((uint32*)block);
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	e9 88 01 00 00       	jmp    802733 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  8025ab:	a1 50 50 98 00       	mov    0x985050,%eax
  8025b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b7:	74 07                	je     8025c0 <alloc_block_FF+0x2c2>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	eb 05                	jmp    8025c5 <alloc_block_FF+0x2c7>
  8025c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c5:	a3 50 50 98 00       	mov    %eax,0x985050
  8025ca:	a1 50 50 98 00       	mov    0x985050,%eax
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	0f 85 d9 fd ff ff    	jne    8023b0 <alloc_block_FF+0xb2>
  8025d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025db:	0f 85 cf fd ff ff    	jne    8023b0 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  8025e1:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  8025e8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8025eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ee:	01 d0                	add    %edx,%eax
  8025f0:	48                   	dec    %eax
  8025f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8025f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8025fc:	f7 75 d8             	divl   -0x28(%ebp)
  8025ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802602:	29 d0                	sub    %edx,%eax
  802604:	c1 e8 0c             	shr    $0xc,%eax
  802607:	83 ec 0c             	sub    $0xc,%esp
  80260a:	50                   	push   %eax
  80260b:	e8 20 eb ff ff       	call   801130 <sbrk>
  802610:	83 c4 10             	add    $0x10,%esp
  802613:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  802616:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  80261a:	75 0a                	jne    802626 <alloc_block_FF+0x328>
		return NULL;
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
  802621:	e9 0d 01 00 00       	jmp    802733 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  802626:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802629:	83 e8 04             	sub    $0x4,%eax
  80262c:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  80262f:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  802636:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802639:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80263c:	01 d0                	add    %edx,%eax
  80263e:	48                   	dec    %eax
  80263f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802642:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802645:	ba 00 00 00 00       	mov    $0x0,%edx
  80264a:	f7 75 c8             	divl   -0x38(%ebp)
  80264d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802650:	29 d0                	sub    %edx,%eax
  802652:	c1 e8 02             	shr    $0x2,%eax
  802655:	c1 e0 02             	shl    $0x2,%eax
  802658:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  80265b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80265e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802664:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802667:	83 e8 08             	sub    $0x8,%eax
  80266a:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  80266d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802670:	8b 00                	mov    (%eax),%eax
  802672:	83 e0 fe             	and    $0xfffffffe,%eax
  802675:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802678:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80267b:	f7 d8                	neg    %eax
  80267d:	89 c2                	mov    %eax,%edx
  80267f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802682:	01 d0                	add    %edx,%eax
  802684:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802687:	83 ec 0c             	sub    $0xc,%esp
  80268a:	ff 75 b8             	pushl  -0x48(%ebp)
  80268d:	e8 1f f8 ff ff       	call   801eb1 <is_free_block>
  802692:	83 c4 10             	add    $0x10,%esp
  802695:	0f be c0             	movsbl %al,%eax
  802698:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  80269b:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  80269f:	74 42                	je     8026e3 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  8026a1:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  8026a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8026ae:	01 d0                	add    %edx,%eax
  8026b0:	48                   	dec    %eax
  8026b1:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8026b4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8026b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026bc:	f7 75 b0             	divl   -0x50(%ebp)
  8026bf:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8026c2:	29 d0                	sub    %edx,%eax
  8026c4:	89 c2                	mov    %eax,%edx
  8026c6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8026c9:	01 d0                	add    %edx,%eax
  8026cb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	6a 00                	push   $0x0
  8026d3:	ff 75 a8             	pushl  -0x58(%ebp)
  8026d6:	ff 75 b8             	pushl  -0x48(%ebp)
  8026d9:	e8 36 fa ff ff       	call   802114 <set_block_data>
  8026de:	83 c4 10             	add    $0x10,%esp
  8026e1:	eb 42                	jmp    802725 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  8026e3:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  8026ea:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8026ed:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8026f0:	01 d0                	add    %edx,%eax
  8026f2:	48                   	dec    %eax
  8026f3:	89 45 a0             	mov    %eax,-0x60(%ebp)
  8026f6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8026f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fe:	f7 75 a4             	divl   -0x5c(%ebp)
  802701:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802704:	29 d0                	sub    %edx,%eax
  802706:	83 ec 04             	sub    $0x4,%esp
  802709:	6a 00                	push   $0x0
  80270b:	50                   	push   %eax
  80270c:	ff 75 d0             	pushl  -0x30(%ebp)
  80270f:	e8 00 fa ff ff       	call   802114 <set_block_data>
  802714:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802717:	83 ec 0c             	sub    $0xc,%esp
  80271a:	ff 75 d0             	pushl  -0x30(%ebp)
  80271d:	e8 49 fa ff ff       	call   80216b <insert_sorted_in_freeList>
  802722:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802725:	83 ec 0c             	sub    $0xc,%esp
  802728:	ff 75 08             	pushl  0x8(%ebp)
  80272b:	e8 ce fb ff ff       	call   8022fe <alloc_block_FF>
  802730:	83 c4 10             	add    $0x10,%esp
}
  802733:	c9                   	leave  
  802734:	c3                   	ret    

00802735 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802735:	55                   	push   %ebp
  802736:	89 e5                	mov    %esp,%ebp
  802738:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  80273b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80273f:	75 0a                	jne    80274b <alloc_block_BF+0x16>
	{
		return NULL;
  802741:	b8 00 00 00 00       	mov    $0x0,%eax
  802746:	e9 7a 02 00 00       	jmp    8029c5 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	83 c0 08             	add    $0x8,%eax
  802751:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802754:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  80275b:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802762:	a1 48 50 98 00       	mov    0x985048,%eax
  802767:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80276a:	eb 32                	jmp    80279e <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  80276c:	ff 75 ec             	pushl  -0x14(%ebp)
  80276f:	e8 24 f7 ff ff       	call   801e98 <get_block_size>
  802774:	83 c4 04             	add    $0x4,%esp
  802777:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  80277a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802780:	72 14                	jb     802796 <alloc_block_BF+0x61>
  802782:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802785:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802788:	73 0c                	jae    802796 <alloc_block_BF+0x61>
		{
			minBlk = block;
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802793:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802796:	a1 50 50 98 00       	mov    0x985050,%eax
  80279b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80279e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027a2:	74 07                	je     8027ab <alloc_block_BF+0x76>
  8027a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	eb 05                	jmp    8027b0 <alloc_block_BF+0x7b>
  8027ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b0:	a3 50 50 98 00       	mov    %eax,0x985050
  8027b5:	a1 50 50 98 00       	mov    0x985050,%eax
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	75 ae                	jne    80276c <alloc_block_BF+0x37>
  8027be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027c2:	75 a8                	jne    80276c <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	75 22                	jne    8027ec <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  8027ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cd:	83 ec 0c             	sub    $0xc,%esp
  8027d0:	50                   	push   %eax
  8027d1:	e8 5a e9 ff ff       	call   801130 <sbrk>
  8027d6:	83 c4 10             	add    $0x10,%esp
  8027d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  8027dc:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  8027e0:	75 0a                	jne    8027ec <alloc_block_BF+0xb7>
			return NULL;
  8027e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e7:	e9 d9 01 00 00       	jmp    8029c5 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  8027ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ef:	83 c0 10             	add    $0x10,%eax
  8027f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027f5:	0f 87 32 01 00 00    	ja     80292d <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802801:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802804:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802807:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280a:	01 d0                	add    %edx,%eax
  80280c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	6a 00                	push   $0x0
  802814:	ff 75 dc             	pushl  -0x24(%ebp)
  802817:	ff 75 d8             	pushl  -0x28(%ebp)
  80281a:	e8 f5 f8 ff ff       	call   802114 <set_block_data>
  80281f:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802826:	74 06                	je     80282e <alloc_block_BF+0xf9>
  802828:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80282c:	75 17                	jne    802845 <alloc_block_BF+0x110>
  80282e:	83 ec 04             	sub    $0x4,%esp
  802831:	68 2c 3e 80 00       	push   $0x803e2c
  802836:	68 49 01 00 00       	push   $0x149
  80283b:	68 b7 3d 80 00       	push   $0x803db7
  802840:	e8 39 0b 00 00       	call   80337e <_panic>
  802845:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802848:	8b 10                	mov    (%eax),%edx
  80284a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80284d:	89 10                	mov    %edx,(%eax)
  80284f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	85 c0                	test   %eax,%eax
  802856:	74 0b                	je     802863 <alloc_block_BF+0x12e>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802860:	89 50 04             	mov    %edx,0x4(%eax)
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802869:	89 10                	mov    %edx,(%eax)
  80286b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80286e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802871:	89 50 04             	mov    %edx,0x4(%eax)
  802874:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	75 08                	jne    802885 <alloc_block_BF+0x150>
  80287d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802880:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802885:	a1 54 50 98 00       	mov    0x985054,%eax
  80288a:	40                   	inc    %eax
  80288b:	a3 54 50 98 00       	mov    %eax,0x985054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802890:	83 ec 04             	sub    $0x4,%esp
  802893:	6a 01                	push   $0x1
  802895:	ff 75 e8             	pushl  -0x18(%ebp)
  802898:	ff 75 f4             	pushl  -0xc(%ebp)
  80289b:	e8 74 f8 ff ff       	call   802114 <set_block_data>
  8028a0:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  8028a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a7:	75 17                	jne    8028c0 <alloc_block_BF+0x18b>
  8028a9:	83 ec 04             	sub    $0x4,%esp
  8028ac:	68 60 3e 80 00       	push   $0x803e60
  8028b1:	68 4e 01 00 00       	push   $0x14e
  8028b6:	68 b7 3d 80 00       	push   $0x803db7
  8028bb:	e8 be 0a 00 00       	call   80337e <_panic>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 10                	je     8028d9 <alloc_block_BF+0x1a4>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d1:	8b 52 04             	mov    0x4(%edx),%edx
  8028d4:	89 50 04             	mov    %edx,0x4(%eax)
  8028d7:	eb 0b                	jmp    8028e4 <alloc_block_BF+0x1af>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	a3 4c 50 98 00       	mov    %eax,0x98504c
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 0f                	je     8028fd <alloc_block_BF+0x1c8>
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f7:	8b 12                	mov    (%edx),%edx
  8028f9:	89 10                	mov    %edx,(%eax)
  8028fb:	eb 0a                	jmp    802907 <alloc_block_BF+0x1d2>
  8028fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	a3 48 50 98 00       	mov    %eax,0x985048
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802910:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291a:	a1 54 50 98 00       	mov    0x985054,%eax
  80291f:	48                   	dec    %eax
  802920:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	e9 98 00 00 00       	jmp    8029c5 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	6a 01                	push   $0x1
  802932:	ff 75 f0             	pushl  -0x10(%ebp)
  802935:	ff 75 f4             	pushl  -0xc(%ebp)
  802938:	e8 d7 f7 ff ff       	call   802114 <set_block_data>
  80293d:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802940:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802944:	75 17                	jne    80295d <alloc_block_BF+0x228>
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	68 60 3e 80 00       	push   $0x803e60
  80294e:	68 56 01 00 00       	push   $0x156
  802953:	68 b7 3d 80 00       	push   $0x803db7
  802958:	e8 21 0a 00 00       	call   80337e <_panic>
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 10                	je     802976 <alloc_block_BF+0x241>
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296e:	8b 52 04             	mov    0x4(%edx),%edx
  802971:	89 50 04             	mov    %edx,0x4(%eax)
  802974:	eb 0b                	jmp    802981 <alloc_block_BF+0x24c>
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	74 0f                	je     80299a <alloc_block_BF+0x265>
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 40 04             	mov    0x4(%eax),%eax
  802991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802994:	8b 12                	mov    (%edx),%edx
  802996:	89 10                	mov    %edx,(%eax)
  802998:	eb 0a                	jmp    8029a4 <alloc_block_BF+0x26f>
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	a3 48 50 98 00       	mov    %eax,0x985048
  8029a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b7:	a1 54 50 98 00       	mov    0x985054,%eax
  8029bc:	48                   	dec    %eax
  8029bd:	a3 54 50 98 00       	mov    %eax,0x985054
		return (void*)((uint32*)minBlk);
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  8029c5:	c9                   	leave  
  8029c6:	c3                   	ret    

008029c7 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  8029c7:	55                   	push   %ebp
  8029c8:	89 e5                	mov    %esp,%ebp
  8029ca:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  8029cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d1:	0f 84 6a 02 00 00    	je     802c41 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  8029d7:	ff 75 08             	pushl  0x8(%ebp)
  8029da:	e8 b9 f4 ff ff       	call   801e98 <get_block_size>
  8029df:	83 c4 04             	add    $0x4,%esp
  8029e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  8029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e8:	83 e8 08             	sub    $0x8,%eax
  8029eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	83 e0 fe             	and    $0xfffffffe,%eax
  8029f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  8029f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fc:	f7 d8                	neg    %eax
  8029fe:	89 c2                	mov    %eax,%edx
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	01 d0                	add    %edx,%eax
  802a05:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802a08:	ff 75 e8             	pushl  -0x18(%ebp)
  802a0b:	e8 a1 f4 ff ff       	call   801eb1 <is_free_block>
  802a10:	83 c4 04             	add    $0x4,%esp
  802a13:	0f be c0             	movsbl %al,%eax
  802a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802a19:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	01 d0                	add    %edx,%eax
  802a21:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802a24:	ff 75 e0             	pushl  -0x20(%ebp)
  802a27:	e8 85 f4 ff ff       	call   801eb1 <is_free_block>
  802a2c:	83 c4 04             	add    $0x4,%esp
  802a2f:	0f be c0             	movsbl %al,%eax
  802a32:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802a35:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802a39:	75 34                	jne    802a6f <free_block+0xa8>
  802a3b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802a3f:	75 2e                	jne    802a6f <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802a41:	ff 75 e8             	pushl  -0x18(%ebp)
  802a44:	e8 4f f4 ff ff       	call   801e98 <get_block_size>
  802a49:	83 c4 04             	add    $0x4,%esp
  802a4c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802a4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802a55:	01 d0                	add    %edx,%eax
  802a57:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802a5a:	6a 00                	push   $0x0
  802a5c:	ff 75 d4             	pushl  -0x2c(%ebp)
  802a5f:	ff 75 e8             	pushl  -0x18(%ebp)
  802a62:	e8 ad f6 ff ff       	call   802114 <set_block_data>
  802a67:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802a6a:	e9 d3 01 00 00       	jmp    802c42 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802a6f:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802a73:	0f 85 c8 00 00 00    	jne    802b41 <free_block+0x17a>
  802a79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a7d:	0f 85 be 00 00 00    	jne    802b41 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802a83:	ff 75 e0             	pushl  -0x20(%ebp)
  802a86:	e8 0d f4 ff ff       	call   801e98 <get_block_size>
  802a8b:	83 c4 04             	add    $0x4,%esp
  802a8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a94:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a97:	01 d0                	add    %edx,%eax
  802a99:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802a9c:	6a 00                	push   $0x0
  802a9e:	ff 75 cc             	pushl  -0x34(%ebp)
  802aa1:	ff 75 08             	pushl  0x8(%ebp)
  802aa4:	e8 6b f6 ff ff       	call   802114 <set_block_data>
  802aa9:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802aac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ab0:	75 17                	jne    802ac9 <free_block+0x102>
  802ab2:	83 ec 04             	sub    $0x4,%esp
  802ab5:	68 60 3e 80 00       	push   $0x803e60
  802aba:	68 87 01 00 00       	push   $0x187
  802abf:	68 b7 3d 80 00       	push   $0x803db7
  802ac4:	e8 b5 08 00 00       	call   80337e <_panic>
  802ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 10                	je     802ae2 <free_block+0x11b>
  802ad2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ada:	8b 52 04             	mov    0x4(%edx),%edx
  802add:	89 50 04             	mov    %edx,0x4(%eax)
  802ae0:	eb 0b                	jmp    802aed <free_block+0x126>
  802ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae5:	8b 40 04             	mov    0x4(%eax),%eax
  802ae8:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	85 c0                	test   %eax,%eax
  802af5:	74 0f                	je     802b06 <free_block+0x13f>
  802af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afa:	8b 40 04             	mov    0x4(%eax),%eax
  802afd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b00:	8b 12                	mov    (%edx),%edx
  802b02:	89 10                	mov    %edx,(%eax)
  802b04:	eb 0a                	jmp    802b10 <free_block+0x149>
  802b06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	a3 48 50 98 00       	mov    %eax,0x985048
  802b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b23:	a1 54 50 98 00       	mov    0x985054,%eax
  802b28:	48                   	dec    %eax
  802b29:	a3 54 50 98 00       	mov    %eax,0x985054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802b2e:	83 ec 0c             	sub    $0xc,%esp
  802b31:	ff 75 08             	pushl  0x8(%ebp)
  802b34:	e8 32 f6 ff ff       	call   80216b <insert_sorted_in_freeList>
  802b39:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802b3c:	e9 01 01 00 00       	jmp    802c42 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802b41:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802b45:	0f 85 d3 00 00 00    	jne    802c1e <free_block+0x257>
  802b4b:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802b4f:	0f 85 c9 00 00 00    	jne    802c1e <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802b55:	83 ec 0c             	sub    $0xc,%esp
  802b58:	ff 75 e8             	pushl  -0x18(%ebp)
  802b5b:	e8 38 f3 ff ff       	call   801e98 <get_block_size>
  802b60:	83 c4 10             	add    $0x10,%esp
  802b63:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802b66:	83 ec 0c             	sub    $0xc,%esp
  802b69:	ff 75 e0             	pushl  -0x20(%ebp)
  802b6c:	e8 27 f3 ff ff       	call   801e98 <get_block_size>
  802b71:	83 c4 10             	add    $0x10,%esp
  802b74:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802b7d:	01 c2                	add    %eax,%edx
  802b7f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802b82:	01 d0                	add    %edx,%eax
  802b84:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	6a 00                	push   $0x0
  802b8c:	ff 75 c0             	pushl  -0x40(%ebp)
  802b8f:	ff 75 e8             	pushl  -0x18(%ebp)
  802b92:	e8 7d f5 ff ff       	call   802114 <set_block_data>
  802b97:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802b9a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802b9e:	75 17                	jne    802bb7 <free_block+0x1f0>
  802ba0:	83 ec 04             	sub    $0x4,%esp
  802ba3:	68 60 3e 80 00       	push   $0x803e60
  802ba8:	68 94 01 00 00       	push   $0x194
  802bad:	68 b7 3d 80 00       	push   $0x803db7
  802bb2:	e8 c7 07 00 00       	call   80337e <_panic>
  802bb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bba:	8b 00                	mov    (%eax),%eax
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	74 10                	je     802bd0 <free_block+0x209>
  802bc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bc8:	8b 52 04             	mov    0x4(%edx),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	eb 0b                	jmp    802bdb <free_block+0x214>
  802bd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd3:	8b 40 04             	mov    0x4(%eax),%eax
  802bd6:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802bdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bde:	8b 40 04             	mov    0x4(%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 0f                	je     802bf4 <free_block+0x22d>
  802be5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802be8:	8b 40 04             	mov    0x4(%eax),%eax
  802beb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802bee:	8b 12                	mov    (%edx),%edx
  802bf0:	89 10                	mov    %edx,(%eax)
  802bf2:	eb 0a                	jmp    802bfe <free_block+0x237>
  802bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	a3 48 50 98 00       	mov    %eax,0x985048
  802bfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c11:	a1 54 50 98 00       	mov    0x985054,%eax
  802c16:	48                   	dec    %eax
  802c17:	a3 54 50 98 00       	mov    %eax,0x985054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802c1c:	eb 24                	jmp    802c42 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802c1e:	83 ec 04             	sub    $0x4,%esp
  802c21:	6a 00                	push   $0x0
  802c23:	ff 75 f4             	pushl  -0xc(%ebp)
  802c26:	ff 75 08             	pushl  0x8(%ebp)
  802c29:	e8 e6 f4 ff ff       	call   802114 <set_block_data>
  802c2e:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802c31:	83 ec 0c             	sub    $0xc,%esp
  802c34:	ff 75 08             	pushl  0x8(%ebp)
  802c37:	e8 2f f5 ff ff       	call   80216b <insert_sorted_in_freeList>
  802c3c:	83 c4 10             	add    $0x10,%esp
  802c3f:	eb 01                	jmp    802c42 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802c41:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802c42:	c9                   	leave  
  802c43:	c3                   	ret    

00802c44 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802c44:	55                   	push   %ebp
  802c45:	89 e5                	mov    %esp,%ebp
  802c47:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802c4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4e:	75 10                	jne    802c60 <realloc_block_FF+0x1c>
  802c50:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c54:	75 0a                	jne    802c60 <realloc_block_FF+0x1c>
	{
		return NULL;
  802c56:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5b:	e9 8b 04 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  802c60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c64:	75 18                	jne    802c7e <realloc_block_FF+0x3a>
	{
		free_block(va);
  802c66:	83 ec 0c             	sub    $0xc,%esp
  802c69:	ff 75 08             	pushl  0x8(%ebp)
  802c6c:	e8 56 fd ff ff       	call   8029c7 <free_block>
  802c71:	83 c4 10             	add    $0x10,%esp
		return NULL;
  802c74:	b8 00 00 00 00       	mov    $0x0,%eax
  802c79:	e9 6d 04 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  802c7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c82:	75 13                	jne    802c97 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  802c84:	83 ec 0c             	sub    $0xc,%esp
  802c87:	ff 75 0c             	pushl  0xc(%ebp)
  802c8a:	e8 6f f6 ff ff       	call   8022fe <alloc_block_FF>
  802c8f:	83 c4 10             	add    $0x10,%esp
  802c92:	e9 54 04 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  802c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c9a:	83 e0 01             	and    $0x1,%eax
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	74 03                	je     802ca4 <realloc_block_FF+0x60>
	{
		new_size++;
  802ca1:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  802ca4:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  802ca8:	77 07                	ja     802cb1 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  802caa:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  802cb1:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  802cb5:	83 ec 0c             	sub    $0xc,%esp
  802cb8:	ff 75 08             	pushl  0x8(%ebp)
  802cbb:	e8 d8 f1 ff ff       	call   801e98 <get_block_size>
  802cc0:	83 c4 10             	add    $0x10,%esp
  802cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ccc:	75 08                	jne    802cd6 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	e9 15 04 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  802cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	01 d0                	add    %edx,%eax
  802cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	ff 75 f0             	pushl  -0x10(%ebp)
  802ce7:	e8 c5 f1 ff ff       	call   801eb1 <is_free_block>
  802cec:	83 c4 10             	add    $0x10,%esp
  802cef:	0f be c0             	movsbl %al,%eax
  802cf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  802cf5:	83 ec 0c             	sub    $0xc,%esp
  802cf8:	ff 75 f0             	pushl  -0x10(%ebp)
  802cfb:	e8 98 f1 ff ff       	call   801e98 <get_block_size>
  802d00:	83 c4 10             	add    $0x10,%esp
  802d03:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  802d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d09:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802d0c:	0f 86 a7 02 00 00    	jbe    802fb9 <realloc_block_FF+0x375>
	{
		if(isNextFree)
  802d12:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d16:	0f 84 86 02 00 00    	je     802fa2 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  802d1c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	01 d0                	add    %edx,%eax
  802d24:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802d27:	0f 85 b2 00 00 00    	jne    802ddf <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  802d2d:	83 ec 0c             	sub    $0xc,%esp
  802d30:	ff 75 08             	pushl  0x8(%ebp)
  802d33:	e8 79 f1 ff ff       	call   801eb1 <is_free_block>
  802d38:	83 c4 10             	add    $0x10,%esp
  802d3b:	84 c0                	test   %al,%al
  802d3d:	0f 94 c0             	sete   %al
  802d40:	0f b6 c0             	movzbl %al,%eax
  802d43:	83 ec 04             	sub    $0x4,%esp
  802d46:	50                   	push   %eax
  802d47:	ff 75 0c             	pushl  0xc(%ebp)
  802d4a:	ff 75 08             	pushl  0x8(%ebp)
  802d4d:	e8 c2 f3 ff ff       	call   802114 <set_block_data>
  802d52:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  802d55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d59:	75 17                	jne    802d72 <realloc_block_FF+0x12e>
  802d5b:	83 ec 04             	sub    $0x4,%esp
  802d5e:	68 60 3e 80 00       	push   $0x803e60
  802d63:	68 db 01 00 00       	push   $0x1db
  802d68:	68 b7 3d 80 00       	push   $0x803db7
  802d6d:	e8 0c 06 00 00       	call   80337e <_panic>
  802d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	74 10                	je     802d8b <realloc_block_FF+0x147>
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d83:	8b 52 04             	mov    0x4(%edx),%edx
  802d86:	89 50 04             	mov    %edx,0x4(%eax)
  802d89:	eb 0b                	jmp    802d96 <realloc_block_FF+0x152>
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	85 c0                	test   %eax,%eax
  802d9e:	74 0f                	je     802daf <realloc_block_FF+0x16b>
  802da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802da9:	8b 12                	mov    (%edx),%edx
  802dab:	89 10                	mov    %edx,(%eax)
  802dad:	eb 0a                	jmp    802db9 <realloc_block_FF+0x175>
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	8b 00                	mov    (%eax),%eax
  802db4:	a3 48 50 98 00       	mov    %eax,0x985048
  802db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dcc:	a1 54 50 98 00       	mov    0x985054,%eax
  802dd1:	48                   	dec    %eax
  802dd2:	a3 54 50 98 00       	mov    %eax,0x985054
				return va;
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	e9 0c 03 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  802ddf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	01 d0                	add    %edx,%eax
  802de7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802dea:	0f 86 b2 01 00 00    	jbe    802fa2 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  802df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  802df3:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802df6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  802df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfc:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  802dff:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  802e02:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  802e06:	0f 87 b8 00 00 00    	ja     802ec4 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  802e0c:	83 ec 0c             	sub    $0xc,%esp
  802e0f:	ff 75 08             	pushl  0x8(%ebp)
  802e12:	e8 9a f0 ff ff       	call   801eb1 <is_free_block>
  802e17:	83 c4 10             	add    $0x10,%esp
  802e1a:	84 c0                	test   %al,%al
  802e1c:	0f 94 c0             	sete   %al
  802e1f:	0f b6 c0             	movzbl %al,%eax
  802e22:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802e25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e28:	01 ca                	add    %ecx,%edx
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	50                   	push   %eax
  802e2e:	52                   	push   %edx
  802e2f:	ff 75 08             	pushl  0x8(%ebp)
  802e32:	e8 dd f2 ff ff       	call   802114 <set_block_data>
  802e37:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802e3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e3e:	75 17                	jne    802e57 <realloc_block_FF+0x213>
  802e40:	83 ec 04             	sub    $0x4,%esp
  802e43:	68 60 3e 80 00       	push   $0x803e60
  802e48:	68 e8 01 00 00       	push   $0x1e8
  802e4d:	68 b7 3d 80 00       	push   $0x803db7
  802e52:	e8 27 05 00 00       	call   80337e <_panic>
  802e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	85 c0                	test   %eax,%eax
  802e5e:	74 10                	je     802e70 <realloc_block_FF+0x22c>
  802e60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e68:	8b 52 04             	mov    0x4(%edx),%edx
  802e6b:	89 50 04             	mov    %edx,0x4(%eax)
  802e6e:	eb 0b                	jmp    802e7b <realloc_block_FF+0x237>
  802e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e73:	8b 40 04             	mov    0x4(%eax),%eax
  802e76:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7e:	8b 40 04             	mov    0x4(%eax),%eax
  802e81:	85 c0                	test   %eax,%eax
  802e83:	74 0f                	je     802e94 <realloc_block_FF+0x250>
  802e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e8e:	8b 12                	mov    (%edx),%edx
  802e90:	89 10                	mov    %edx,(%eax)
  802e92:	eb 0a                	jmp    802e9e <realloc_block_FF+0x25a>
  802e94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e97:	8b 00                	mov    (%eax),%eax
  802e99:	a3 48 50 98 00       	mov    %eax,0x985048
  802e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eaa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb1:	a1 54 50 98 00       	mov    0x985054,%eax
  802eb6:	48                   	dec    %eax
  802eb7:	a3 54 50 98 00       	mov    %eax,0x985054
					return va;
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	e9 27 02 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  802ec4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ec8:	75 17                	jne    802ee1 <realloc_block_FF+0x29d>
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 60 3e 80 00       	push   $0x803e60
  802ed2:	68 ed 01 00 00       	push   $0x1ed
  802ed7:	68 b7 3d 80 00       	push   $0x803db7
  802edc:	e8 9d 04 00 00       	call   80337e <_panic>
  802ee1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 10                	je     802efa <realloc_block_FF+0x2b6>
  802eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ef2:	8b 52 04             	mov    0x4(%edx),%edx
  802ef5:	89 50 04             	mov    %edx,0x4(%eax)
  802ef8:	eb 0b                	jmp    802f05 <realloc_block_FF+0x2c1>
  802efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efd:	8b 40 04             	mov    0x4(%eax),%eax
  802f00:	a3 4c 50 98 00       	mov    %eax,0x98504c
  802f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f08:	8b 40 04             	mov    0x4(%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 0f                	je     802f1e <realloc_block_FF+0x2da>
  802f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f12:	8b 40 04             	mov    0x4(%eax),%eax
  802f15:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802f18:	8b 12                	mov    (%edx),%edx
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	eb 0a                	jmp    802f28 <realloc_block_FF+0x2e4>
  802f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	a3 48 50 98 00       	mov    %eax,0x985048
  802f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3b:	a1 54 50 98 00       	mov    0x985054,%eax
  802f40:	48                   	dec    %eax
  802f41:	a3 54 50 98 00       	mov    %eax,0x985054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  802f46:	8b 55 08             	mov    0x8(%ebp),%edx
  802f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f4c:	01 d0                	add    %edx,%eax
  802f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  802f51:	83 ec 04             	sub    $0x4,%esp
  802f54:	6a 00                	push   $0x0
  802f56:	ff 75 e0             	pushl  -0x20(%ebp)
  802f59:	ff 75 f0             	pushl  -0x10(%ebp)
  802f5c:	e8 b3 f1 ff ff       	call   802114 <set_block_data>
  802f61:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  802f64:	83 ec 0c             	sub    $0xc,%esp
  802f67:	ff 75 08             	pushl  0x8(%ebp)
  802f6a:	e8 42 ef ff ff       	call   801eb1 <is_free_block>
  802f6f:	83 c4 10             	add    $0x10,%esp
  802f72:	84 c0                	test   %al,%al
  802f74:	0f 94 c0             	sete   %al
  802f77:	0f b6 c0             	movzbl %al,%eax
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	50                   	push   %eax
  802f7e:	ff 75 0c             	pushl  0xc(%ebp)
  802f81:	ff 75 08             	pushl  0x8(%ebp)
  802f84:	e8 8b f1 ff ff       	call   802114 <set_block_data>
  802f89:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  802f8c:	83 ec 0c             	sub    $0xc,%esp
  802f8f:	ff 75 f0             	pushl  -0x10(%ebp)
  802f92:	e8 d4 f1 ff ff       	call   80216b <insert_sorted_in_freeList>
  802f97:	83 c4 10             	add    $0x10,%esp
					return va;
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	e9 49 01 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  802fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fa5:	83 e8 08             	sub    $0x8,%eax
  802fa8:	83 ec 0c             	sub    $0xc,%esp
  802fab:	50                   	push   %eax
  802fac:	e8 4d f3 ff ff       	call   8022fe <alloc_block_FF>
  802fb1:	83 c4 10             	add    $0x10,%esp
  802fb4:	e9 32 01 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  802fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802fbf:	0f 83 21 01 00 00    	jae    8030e6 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	2b 45 0c             	sub    0xc(%ebp),%eax
  802fcb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  802fce:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  802fd2:	77 0e                	ja     802fe2 <realloc_block_FF+0x39e>
  802fd4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fd8:	75 08                	jne    802fe2 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	e9 09 01 00 00       	jmp    8030eb <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  802fe8:	83 ec 0c             	sub    $0xc,%esp
  802feb:	ff 75 08             	pushl  0x8(%ebp)
  802fee:	e8 be ee ff ff       	call   801eb1 <is_free_block>
  802ff3:	83 c4 10             	add    $0x10,%esp
  802ff6:	84 c0                	test   %al,%al
  802ff8:	0f 94 c0             	sete   %al
  802ffb:	0f b6 c0             	movzbl %al,%eax
  802ffe:	83 ec 04             	sub    $0x4,%esp
  803001:	50                   	push   %eax
  803002:	ff 75 0c             	pushl  0xc(%ebp)
  803005:	ff 75 d8             	pushl  -0x28(%ebp)
  803008:	e8 07 f1 ff ff       	call   802114 <set_block_data>
  80300d:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  803010:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803013:	8b 45 0c             	mov    0xc(%ebp),%eax
  803016:	01 d0                	add    %edx,%eax
  803018:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	6a 00                	push   $0x0
  803020:	ff 75 dc             	pushl  -0x24(%ebp)
  803023:	ff 75 d4             	pushl  -0x2c(%ebp)
  803026:	e8 e9 f0 ff ff       	call   802114 <set_block_data>
  80302b:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  80302e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803032:	0f 84 9b 00 00 00    	je     8030d3 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  803038:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80303b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303e:	01 d0                	add    %edx,%eax
  803040:	83 ec 04             	sub    $0x4,%esp
  803043:	6a 00                	push   $0x0
  803045:	50                   	push   %eax
  803046:	ff 75 d4             	pushl  -0x2c(%ebp)
  803049:	e8 c6 f0 ff ff       	call   802114 <set_block_data>
  80304e:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  803051:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803055:	75 17                	jne    80306e <realloc_block_FF+0x42a>
  803057:	83 ec 04             	sub    $0x4,%esp
  80305a:	68 60 3e 80 00       	push   $0x803e60
  80305f:	68 10 02 00 00       	push   $0x210
  803064:	68 b7 3d 80 00       	push   $0x803db7
  803069:	e8 10 03 00 00       	call   80337e <_panic>
  80306e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	85 c0                	test   %eax,%eax
  803075:	74 10                	je     803087 <realloc_block_FF+0x443>
  803077:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80307f:	8b 52 04             	mov    0x4(%edx),%edx
  803082:	89 50 04             	mov    %edx,0x4(%eax)
  803085:	eb 0b                	jmp    803092 <realloc_block_FF+0x44e>
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	8b 40 04             	mov    0x4(%eax),%eax
  80308d:	a3 4c 50 98 00       	mov    %eax,0x98504c
  803092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	85 c0                	test   %eax,%eax
  80309a:	74 0f                	je     8030ab <realloc_block_FF+0x467>
  80309c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309f:	8b 40 04             	mov    0x4(%eax),%eax
  8030a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030a5:	8b 12                	mov    (%edx),%edx
  8030a7:	89 10                	mov    %edx,(%eax)
  8030a9:	eb 0a                	jmp    8030b5 <realloc_block_FF+0x471>
  8030ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	a3 48 50 98 00       	mov    %eax,0x985048
  8030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c8:	a1 54 50 98 00       	mov    0x985054,%eax
  8030cd:	48                   	dec    %eax
  8030ce:	a3 54 50 98 00       	mov    %eax,0x985054
			}
			insert_sorted_in_freeList(remainingBlk);
  8030d3:	83 ec 0c             	sub    $0xc,%esp
  8030d6:	ff 75 d4             	pushl  -0x2c(%ebp)
  8030d9:	e8 8d f0 ff ff       	call   80216b <insert_sorted_in_freeList>
  8030de:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  8030e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030e4:	eb 05                	jmp    8030eb <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  8030e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030eb:	c9                   	leave  
  8030ec:	c3                   	ret    

008030ed <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  8030ed:	55                   	push   %ebp
  8030ee:	89 e5                	mov    %esp,%ebp
  8030f0:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  8030f3:	83 ec 04             	sub    $0x4,%esp
  8030f6:	68 80 3e 80 00       	push   $0x803e80
  8030fb:	68 20 02 00 00       	push   $0x220
  803100:	68 b7 3d 80 00       	push   $0x803db7
  803105:	e8 74 02 00 00       	call   80337e <_panic>

0080310a <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  80310a:	55                   	push   %ebp
  80310b:	89 e5                	mov    %esp,%ebp
  80310d:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  803110:	83 ec 04             	sub    $0x4,%esp
  803113:	68 a8 3e 80 00       	push   $0x803ea8
  803118:	68 28 02 00 00       	push   $0x228
  80311d:	68 b7 3d 80 00       	push   $0x803db7
  803122:	e8 57 02 00 00       	call   80337e <_panic>

00803127 <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  803127:	55                   	push   %ebp
  803128:	89 e5                	mov    %esp,%ebp
  80312a:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  80312d:	83 ec 04             	sub    $0x4,%esp
  803130:	6a 01                	push   $0x1
  803132:	6a 58                	push   $0x58
  803134:	ff 75 0c             	pushl  0xc(%ebp)
  803137:	e8 c1 e2 ff ff       	call   8013fd <smalloc>
  80313c:	83 c4 10             	add    $0x10,%esp
  80313f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  803142:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803146:	75 14                	jne    80315c <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  803148:	83 ec 04             	sub    $0x4,%esp
  80314b:	68 d0 3e 80 00       	push   $0x803ed0
  803150:	6a 10                	push   $0x10
  803152:	68 fe 3e 80 00       	push   $0x803efe
  803157:	e8 22 02 00 00       	call   80337e <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  80315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315f:	83 ec 0c             	sub    $0xc,%esp
  803162:	50                   	push   %eax
  803163:	e8 bc ec ff ff       	call   801e24 <sys_init_queue>
  803168:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	83 c0 18             	add    $0x18,%eax
  80317b:	83 ec 04             	sub    $0x4,%esp
  80317e:	6a 40                	push   $0x40
  803180:	ff 75 0c             	pushl  0xc(%ebp)
  803183:	50                   	push   %eax
  803184:	e8 1e d9 ff ff       	call   800aa7 <strncpy>
  803189:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  80318c:	8b 55 10             	mov    0x10(%ebp),%edx
  80318f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803192:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031a1:	89 10                	mov    %edx,(%eax)
}
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	c9                   	leave  
  8031a7:	c2 04 00             	ret    $0x4

008031aa <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8031aa:	55                   	push   %ebp
  8031ab:	89 e5                	mov    %esp,%ebp
  8031ad:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  8031b0:	83 ec 08             	sub    $0x8,%esp
  8031b3:	ff 75 10             	pushl  0x10(%ebp)
  8031b6:	ff 75 0c             	pushl  0xc(%ebp)
  8031b9:	e8 da e3 ff ff       	call   801598 <sget>
  8031be:	83 c4 10             	add    $0x10,%esp
  8031c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8031c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031c8:	75 14                	jne    8031de <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  8031ca:	83 ec 04             	sub    $0x4,%esp
  8031cd:	68 10 3f 80 00       	push   $0x803f10
  8031d2:	6a 2c                	push   $0x2c
  8031d4:	68 fe 3e 80 00       	push   $0x803efe
  8031d9:	e8 a0 01 00 00       	call   80337e <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ea:	89 10                	mov    %edx,(%eax)
}
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	c9                   	leave  
  8031f0:	c2 04 00             	ret    $0x4

008031f3 <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  8031f3:	55                   	push   %ebp
  8031f4:	89 e5                	mov    %esp,%ebp
  8031f6:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  8031f9:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	8b 40 14             	mov    0x14(%eax),%eax
  803206:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803209:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80320c:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  80320f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803218:	f0 87 02             	lock xchg %eax,(%edx)
  80321b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  80321e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803221:	85 c0                	test   %eax,%eax
  803223:	75 db                	jne    803200 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	8b 50 10             	mov    0x10(%eax),%edx
  80322b:	4a                   	dec    %edx
  80322c:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  80322f:	8b 45 08             	mov    0x8(%ebp),%eax
  803232:	8b 40 10             	mov    0x10(%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	79 18                	jns    803251 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	8d 50 14             	lea    0x14(%eax),%edx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	83 ec 08             	sub    $0x8,%esp
  803245:	52                   	push   %edx
  803246:	50                   	push   %eax
  803247:	e8 f4 eb ff ff       	call   801e40 <sys_block_process>
  80324c:	83 c4 10             	add    $0x10,%esp
  80324f:	eb 0a                	jmp    80325b <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  80325b:	c9                   	leave  
  80325c:	c3                   	ret    

0080325d <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  80325d:	55                   	push   %ebp
  80325e:	89 e5                	mov    %esp,%ebp
  803260:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  803263:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	8b 40 14             	mov    0x14(%eax),%eax
  803270:	8d 55 e8             	lea    -0x18(%ebp),%edx
  803273:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803276:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803279:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80327c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803282:	f0 87 02             	lock xchg %eax,(%edx)
  803285:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  803288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80328b:	85 c0                	test   %eax,%eax
  80328d:	75 db                	jne    80326a <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	8b 50 10             	mov    0x10(%eax),%edx
  803295:	42                   	inc    %edx
  803296:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	8b 40 10             	mov    0x10(%eax),%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	7f 0f                	jg     8032b2 <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	83 ec 0c             	sub    $0xc,%esp
  8032a9:	50                   	push   %eax
  8032aa:	e8 af eb ff ff       	call   801e5e <sys_unblock_process>
  8032af:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8032bc:	90                   	nop
  8032bd:	c9                   	leave  
  8032be:	c3                   	ret    

008032bf <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  8032bf:	55                   	push   %ebp
  8032c0:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	8b 40 10             	mov    0x10(%eax),%eax
}
  8032c8:	5d                   	pop    %ebp
  8032c9:	c3                   	ret    

008032ca <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8032ca:	55                   	push   %ebp
  8032cb:	89 e5                	mov    %esp,%ebp
  8032cd:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8032d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d3:	89 d0                	mov    %edx,%eax
  8032d5:	c1 e0 02             	shl    $0x2,%eax
  8032d8:	01 d0                	add    %edx,%eax
  8032da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032e1:	01 d0                	add    %edx,%eax
  8032e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032ea:	01 d0                	add    %edx,%eax
  8032ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f3:	01 d0                	add    %edx,%eax
  8032f5:	c1 e0 04             	shl    $0x4,%eax
  8032f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8032fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803302:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803305:	83 ec 0c             	sub    $0xc,%esp
  803308:	50                   	push   %eax
  803309:	e8 22 e8 ff ff       	call   801b30 <sys_get_virtual_time>
  80330e:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803311:	eb 41                	jmp    803354 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803313:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803316:	83 ec 0c             	sub    $0xc,%esp
  803319:	50                   	push   %eax
  80331a:	e8 11 e8 ff ff       	call   801b30 <sys_get_virtual_time>
  80331f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803322:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803325:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803328:	29 c2                	sub    %eax,%edx
  80332a:	89 d0                	mov    %edx,%eax
  80332c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80332f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803335:	89 d1                	mov    %edx,%ecx
  803337:	29 c1                	sub    %eax,%ecx
  803339:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80333c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80333f:	39 c2                	cmp    %eax,%edx
  803341:	0f 97 c0             	seta   %al
  803344:	0f b6 c0             	movzbl %al,%eax
  803347:	29 c1                	sub    %eax,%ecx
  803349:	89 c8                	mov    %ecx,%eax
  80334b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80334e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803351:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803357:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80335a:	72 b7                	jb     803313 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80335c:	90                   	nop
  80335d:	c9                   	leave  
  80335e:	c3                   	ret    

0080335f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80335f:	55                   	push   %ebp
  803360:	89 e5                	mov    %esp,%ebp
  803362:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803365:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80336c:	eb 03                	jmp    803371 <busy_wait+0x12>
  80336e:	ff 45 fc             	incl   -0x4(%ebp)
  803371:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803374:	3b 45 08             	cmp    0x8(%ebp),%eax
  803377:	72 f5                	jb     80336e <busy_wait+0xf>
	return i;
  803379:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80337c:	c9                   	leave  
  80337d:	c3                   	ret    

0080337e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80337e:	55                   	push   %ebp
  80337f:	89 e5                	mov    %esp,%ebp
  803381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803384:	8d 45 10             	lea    0x10(%ebp),%eax
  803387:	83 c0 04             	add    $0x4,%eax
  80338a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80338d:	a1 60 50 98 00       	mov    0x985060,%eax
  803392:	85 c0                	test   %eax,%eax
  803394:	74 16                	je     8033ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  803396:	a1 60 50 98 00       	mov    0x985060,%eax
  80339b:	83 ec 08             	sub    $0x8,%esp
  80339e:	50                   	push   %eax
  80339f:	68 34 3f 80 00       	push   $0x803f34
  8033a4:	e8 ed cf ff ff       	call   800396 <cprintf>
  8033a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8033ac:	a1 04 50 80 00       	mov    0x805004,%eax
  8033b1:	ff 75 0c             	pushl  0xc(%ebp)
  8033b4:	ff 75 08             	pushl  0x8(%ebp)
  8033b7:	50                   	push   %eax
  8033b8:	68 39 3f 80 00       	push   $0x803f39
  8033bd:	e8 d4 cf ff ff       	call   800396 <cprintf>
  8033c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8033c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8033c8:	83 ec 08             	sub    $0x8,%esp
  8033cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8033ce:	50                   	push   %eax
  8033cf:	e8 57 cf ff ff       	call   80032b <vcprintf>
  8033d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8033d7:	83 ec 08             	sub    $0x8,%esp
  8033da:	6a 00                	push   $0x0
  8033dc:	68 55 3f 80 00       	push   $0x803f55
  8033e1:	e8 45 cf ff ff       	call   80032b <vcprintf>
  8033e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8033e9:	e8 c6 ce ff ff       	call   8002b4 <exit>

	// should not return here
	while (1) ;
  8033ee:	eb fe                	jmp    8033ee <_panic+0x70>

008033f0 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8033f0:	55                   	push   %ebp
  8033f1:	89 e5                	mov    %esp,%ebp
  8033f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8033f6:	a1 20 50 80 00       	mov    0x805020,%eax
  8033fb:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803401:	8b 45 0c             	mov    0xc(%ebp),%eax
  803404:	39 c2                	cmp    %eax,%edx
  803406:	74 14                	je     80341c <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 58 3f 80 00       	push   $0x803f58
  803410:	6a 26                	push   $0x26
  803412:	68 a4 3f 80 00       	push   $0x803fa4
  803417:	e8 62 ff ff ff       	call   80337e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80341c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803423:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80342a:	e9 c5 00 00 00       	jmp    8034f4 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  80342f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803432:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803439:	8b 45 08             	mov    0x8(%ebp),%eax
  80343c:	01 d0                	add    %edx,%eax
  80343e:	8b 00                	mov    (%eax),%eax
  803440:	85 c0                	test   %eax,%eax
  803442:	75 08                	jne    80344c <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  803444:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803447:	e9 a5 00 00 00       	jmp    8034f1 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80344c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803453:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80345a:	eb 69                	jmp    8034c5 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80345c:	a1 20 50 80 00       	mov    0x805020,%eax
  803461:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803467:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80346a:	89 d0                	mov    %edx,%eax
  80346c:	01 c0                	add    %eax,%eax
  80346e:	01 d0                	add    %edx,%eax
  803470:	c1 e0 03             	shl    $0x3,%eax
  803473:	01 c8                	add    %ecx,%eax
  803475:	8a 40 04             	mov    0x4(%eax),%al
  803478:	84 c0                	test   %al,%al
  80347a:	75 46                	jne    8034c2 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80347c:	a1 20 50 80 00       	mov    0x805020,%eax
  803481:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  803487:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80348a:	89 d0                	mov    %edx,%eax
  80348c:	01 c0                	add    %eax,%eax
  80348e:	01 d0                	add    %edx,%eax
  803490:	c1 e0 03             	shl    $0x3,%eax
  803493:	01 c8                	add    %ecx,%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80349a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80349d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8034a2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8034a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034a7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	01 c8                	add    %ecx,%eax
  8034b3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8034b5:	39 c2                	cmp    %eax,%edx
  8034b7:	75 09                	jne    8034c2 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8034b9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8034c0:	eb 15                	jmp    8034d7 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8034c2:	ff 45 e8             	incl   -0x18(%ebp)
  8034c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8034ca:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	39 c2                	cmp    %eax,%edx
  8034d5:	77 85                	ja     80345c <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8034d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034db:	75 14                	jne    8034f1 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  8034dd:	83 ec 04             	sub    $0x4,%esp
  8034e0:	68 b0 3f 80 00       	push   $0x803fb0
  8034e5:	6a 3a                	push   $0x3a
  8034e7:	68 a4 3f 80 00       	push   $0x803fa4
  8034ec:	e8 8d fe ff ff       	call   80337e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8034f1:	ff 45 f0             	incl   -0x10(%ebp)
  8034f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8034fa:	0f 8c 2f ff ff ff    	jl     80342f <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803500:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803507:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80350e:	eb 26                	jmp    803536 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803510:	a1 20 50 80 00       	mov    0x805020,%eax
  803515:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80351b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80351e:	89 d0                	mov    %edx,%eax
  803520:	01 c0                	add    %eax,%eax
  803522:	01 d0                	add    %edx,%eax
  803524:	c1 e0 03             	shl    $0x3,%eax
  803527:	01 c8                	add    %ecx,%eax
  803529:	8a 40 04             	mov    0x4(%eax),%al
  80352c:	3c 01                	cmp    $0x1,%al
  80352e:	75 03                	jne    803533 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  803530:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803533:	ff 45 e0             	incl   -0x20(%ebp)
  803536:	a1 20 50 80 00       	mov    0x805020,%eax
  80353b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  803541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803544:	39 c2                	cmp    %eax,%edx
  803546:	77 c8                	ja     803510 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80354e:	74 14                	je     803564 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  803550:	83 ec 04             	sub    $0x4,%esp
  803553:	68 04 40 80 00       	push   $0x804004
  803558:	6a 44                	push   $0x44
  80355a:	68 a4 3f 80 00       	push   $0x803fa4
  80355f:	e8 1a fe ff ff       	call   80337e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803564:	90                   	nop
  803565:	c9                   	leave  
  803566:	c3                   	ret    
  803567:	90                   	nop

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
