
obj/user/tst_chan_all_slave:     file format elf32-i386


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
  800031:	e8 2a 00 00 00       	call   800060 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program: sleep, increment test after wakeup
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int envID = sys_getenvid();
  80003e:	e8 a0 12 00 00       	call   8012e3 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Sleep on the channel
	sys_utilities("__Sleep__", 0);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 00                	push   $0x0
  80004b:	68 00 1b 80 00       	push   $0x801b00
  800050:	e8 76 15 00 00       	call   8015cb <sys_utilities>
  800055:	83 c4 10             	add    $0x10,%esp

	//indicates wakenup
	inctst();
  800058:	e8 dd 13 00 00       	call   80143a <inctst>

	return;
  80005d:	90                   	nop
}
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800066:	e8 91 12 00 00       	call   8012fc <sys_getenvindex>
  80006b:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80006e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800071:	89 d0                	mov    %edx,%eax
  800073:	c1 e0 02             	shl    $0x2,%eax
  800076:	01 d0                	add    %edx,%eax
  800078:	c1 e0 03             	shl    $0x3,%eax
  80007b:	01 d0                	add    %edx,%eax
  80007d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800084:	01 d0                	add    %edx,%eax
  800086:	c1 e0 02             	shl    $0x2,%eax
  800089:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80008e:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800093:	a1 08 30 80 00       	mov    0x803008,%eax
  800098:	8a 40 20             	mov    0x20(%eax),%al
  80009b:	84 c0                	test   %al,%al
  80009d:	74 0d                	je     8000ac <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80009f:	a1 08 30 80 00       	mov    0x803008,%eax
  8000a4:	83 c0 20             	add    $0x20,%eax
  8000a7:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b0:	7e 0a                	jle    8000bc <libmain+0x5c>
		binaryname = argv[0];
  8000b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b5:	8b 00                	mov    (%eax),%eax
  8000b7:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000bc:	83 ec 08             	sub    $0x8,%esp
  8000bf:	ff 75 0c             	pushl  0xc(%ebp)
  8000c2:	ff 75 08             	pushl  0x8(%ebp)
  8000c5:	e8 6e ff ff ff       	call   800038 <_main>
  8000ca:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000cd:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	0f 84 9f 00 00 00    	je     800179 <libmain+0x119>
	{
		sys_lock_cons();
  8000da:	e8 a1 0f 00 00       	call   801080 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 24 1b 80 00       	push   $0x801b24
  8000e7:	e8 8d 01 00 00       	call   800279 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000ef:	a1 08 30 80 00       	mov    0x803008,%eax
  8000f4:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8000fa:	a1 08 30 80 00       	mov    0x803008,%eax
  8000ff:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	52                   	push   %edx
  800109:	50                   	push   %eax
  80010a:	68 4c 1b 80 00       	push   $0x801b4c
  80010f:	e8 65 01 00 00       	call   800279 <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800117:	a1 08 30 80 00       	mov    0x803008,%eax
  80011c:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800122:	a1 08 30 80 00       	mov    0x803008,%eax
  800127:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80012d:	a1 08 30 80 00       	mov    0x803008,%eax
  800132:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800138:	51                   	push   %ecx
  800139:	52                   	push   %edx
  80013a:	50                   	push   %eax
  80013b:	68 74 1b 80 00       	push   $0x801b74
  800140:	e8 34 01 00 00       	call   800279 <cprintf>
  800145:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800148:	a1 08 30 80 00       	mov    0x803008,%eax
  80014d:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800153:	83 ec 08             	sub    $0x8,%esp
  800156:	50                   	push   %eax
  800157:	68 cc 1b 80 00       	push   $0x801bcc
  80015c:	e8 18 01 00 00       	call   800279 <cprintf>
  800161:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	68 24 1b 80 00       	push   $0x801b24
  80016c:	e8 08 01 00 00       	call   800279 <cprintf>
  800171:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800174:	e8 21 0f 00 00       	call   80109a <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800179:	e8 19 00 00 00       	call   800197 <exit>
}
  80017e:	90                   	nop
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	6a 00                	push   $0x0
  80018c:	e8 37 11 00 00       	call   8012c8 <sys_destroy_env>
  800191:	83 c4 10             	add    $0x10,%esp
}
  800194:	90                   	nop
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <exit>:

void
exit(void)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80019d:	e8 8c 11 00 00       	call   80132e <sys_exit_env>
}
  8001a2:	90                   	nop
  8001a3:	c9                   	leave  
  8001a4:	c3                   	ret    

008001a5 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8001b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b6:	89 0a                	mov    %ecx,(%edx)
  8001b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bb:	88 d1                	mov    %dl,%cl
  8001bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c0:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c7:	8b 00                	mov    (%eax),%eax
  8001c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ce:	75 2c                	jne    8001fc <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001d0:	a0 0c 30 80 00       	mov    0x80300c,%al
  8001d5:	0f b6 c0             	movzbl %al,%eax
  8001d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001db:	8b 12                	mov    (%edx),%edx
  8001dd:	89 d1                	mov    %edx,%ecx
  8001df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e2:	83 c2 08             	add    $0x8,%edx
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	50                   	push   %eax
  8001e9:	51                   	push   %ecx
  8001ea:	52                   	push   %edx
  8001eb:	e8 4e 0e 00 00       	call   80103e <sys_cputs>
  8001f0:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ff:	8b 40 04             	mov    0x4(%eax),%eax
  800202:	8d 50 01             	lea    0x1(%eax),%edx
  800205:	8b 45 0c             	mov    0xc(%ebp),%eax
  800208:	89 50 04             	mov    %edx,0x4(%eax)
}
  80020b:	90                   	nop
  80020c:	c9                   	leave  
  80020d:	c3                   	ret    

0080020e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80020e:	55                   	push   %ebp
  80020f:	89 e5                	mov    %esp,%ebp
  800211:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800217:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80021e:	00 00 00 
	b.cnt = 0;
  800221:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800228:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80022b:	ff 75 0c             	pushl  0xc(%ebp)
  80022e:	ff 75 08             	pushl  0x8(%ebp)
  800231:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800237:	50                   	push   %eax
  800238:	68 a5 01 80 00       	push   $0x8001a5
  80023d:	e8 11 02 00 00       	call   800453 <vprintfmt>
  800242:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800245:	a0 0c 30 80 00       	mov    0x80300c,%al
  80024a:	0f b6 c0             	movzbl %al,%eax
  80024d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800253:	83 ec 04             	sub    $0x4,%esp
  800256:	50                   	push   %eax
  800257:	52                   	push   %edx
  800258:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025e:	83 c0 08             	add    $0x8,%eax
  800261:	50                   	push   %eax
  800262:	e8 d7 0d 00 00       	call   80103e <sys_cputs>
  800267:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80026a:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800271:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800277:	c9                   	leave  
  800278:	c3                   	ret    

00800279 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800279:	55                   	push   %ebp
  80027a:	89 e5                	mov    %esp,%ebp
  80027c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80027f:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800286:	8d 45 0c             	lea    0xc(%ebp),%eax
  800289:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	83 ec 08             	sub    $0x8,%esp
  800292:	ff 75 f4             	pushl  -0xc(%ebp)
  800295:	50                   	push   %eax
  800296:	e8 73 ff ff ff       	call   80020e <vcprintf>
  80029b:	83 c4 10             	add    $0x10,%esp
  80029e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002a4:	c9                   	leave  
  8002a5:	c3                   	ret    

008002a6 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002a6:	55                   	push   %ebp
  8002a7:	89 e5                	mov    %esp,%ebp
  8002a9:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002ac:	e8 cf 0d 00 00       	call   801080 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002b1:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c0:	50                   	push   %eax
  8002c1:	e8 48 ff ff ff       	call   80020e <vcprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
  8002c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002cc:	e8 c9 0d 00 00       	call   80109a <sys_unlock_cons>
	return cnt;
  8002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002d4:	c9                   	leave  
  8002d5:	c3                   	ret    

008002d6 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d6:	55                   	push   %ebp
  8002d7:	89 e5                	mov    %esp,%ebp
  8002d9:	53                   	push   %ebx
  8002da:	83 ec 14             	sub    $0x14,%esp
  8002dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002e9:	8b 45 18             	mov    0x18(%ebp),%eax
  8002ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f4:	77 55                	ja     80034b <printnum+0x75>
  8002f6:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002f9:	72 05                	jb     800300 <printnum+0x2a>
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	77 4b                	ja     80034b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800300:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800303:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800306:	8b 45 18             	mov    0x18(%ebp),%eax
  800309:	ba 00 00 00 00       	mov    $0x0,%edx
  80030e:	52                   	push   %edx
  80030f:	50                   	push   %eax
  800310:	ff 75 f4             	pushl  -0xc(%ebp)
  800313:	ff 75 f0             	pushl  -0x10(%ebp)
  800316:	e8 81 15 00 00       	call   80189c <__udivdi3>
  80031b:	83 c4 10             	add    $0x10,%esp
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	ff 75 20             	pushl  0x20(%ebp)
  800324:	53                   	push   %ebx
  800325:	ff 75 18             	pushl  0x18(%ebp)
  800328:	52                   	push   %edx
  800329:	50                   	push   %eax
  80032a:	ff 75 0c             	pushl  0xc(%ebp)
  80032d:	ff 75 08             	pushl  0x8(%ebp)
  800330:	e8 a1 ff ff ff       	call   8002d6 <printnum>
  800335:	83 c4 20             	add    $0x20,%esp
  800338:	eb 1a                	jmp    800354 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80033a:	83 ec 08             	sub    $0x8,%esp
  80033d:	ff 75 0c             	pushl  0xc(%ebp)
  800340:	ff 75 20             	pushl  0x20(%ebp)
  800343:	8b 45 08             	mov    0x8(%ebp),%eax
  800346:	ff d0                	call   *%eax
  800348:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80034b:	ff 4d 1c             	decl   0x1c(%ebp)
  80034e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800352:	7f e6                	jg     80033a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800354:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800357:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80035f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800362:	53                   	push   %ebx
  800363:	51                   	push   %ecx
  800364:	52                   	push   %edx
  800365:	50                   	push   %eax
  800366:	e8 41 16 00 00       	call   8019ac <__umoddi3>
  80036b:	83 c4 10             	add    $0x10,%esp
  80036e:	05 f4 1d 80 00       	add    $0x801df4,%eax
  800373:	8a 00                	mov    (%eax),%al
  800375:	0f be c0             	movsbl %al,%eax
  800378:	83 ec 08             	sub    $0x8,%esp
  80037b:	ff 75 0c             	pushl  0xc(%ebp)
  80037e:	50                   	push   %eax
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	ff d0                	call   *%eax
  800384:	83 c4 10             	add    $0x10,%esp
}
  800387:	90                   	nop
  800388:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80038b:	c9                   	leave  
  80038c:	c3                   	ret    

0080038d <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800390:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800394:	7e 1c                	jle    8003b2 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	8b 00                	mov    (%eax),%eax
  80039b:	8d 50 08             	lea    0x8(%eax),%edx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	89 10                	mov    %edx,(%eax)
  8003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	83 e8 08             	sub    $0x8,%eax
  8003ab:	8b 50 04             	mov    0x4(%eax),%edx
  8003ae:	8b 00                	mov    (%eax),%eax
  8003b0:	eb 40                	jmp    8003f2 <getuint+0x65>
	else if (lflag)
  8003b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003b6:	74 1e                	je     8003d6 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	8b 00                	mov    (%eax),%eax
  8003bd:	8d 50 04             	lea    0x4(%eax),%edx
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	89 10                	mov    %edx,(%eax)
  8003c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c8:	8b 00                	mov    (%eax),%eax
  8003ca:	83 e8 04             	sub    $0x4,%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8003d4:	eb 1c                	jmp    8003f2 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	8d 50 04             	lea    0x4(%eax),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	89 10                	mov    %edx,(%eax)
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	8b 00                	mov    (%eax),%eax
  8003e8:	83 e8 04             	sub    $0x4,%eax
  8003eb:	8b 00                	mov    (%eax),%eax
  8003ed:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f2:	5d                   	pop    %ebp
  8003f3:	c3                   	ret    

008003f4 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003fb:	7e 1c                	jle    800419 <getint+0x25>
		return va_arg(*ap, long long);
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	8b 00                	mov    (%eax),%eax
  800402:	8d 50 08             	lea    0x8(%eax),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	89 10                	mov    %edx,(%eax)
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	8b 00                	mov    (%eax),%eax
  80040f:	83 e8 08             	sub    $0x8,%eax
  800412:	8b 50 04             	mov    0x4(%eax),%edx
  800415:	8b 00                	mov    (%eax),%eax
  800417:	eb 38                	jmp    800451 <getint+0x5d>
	else if (lflag)
  800419:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80041d:	74 1a                	je     800439 <getint+0x45>
		return va_arg(*ap, long);
  80041f:	8b 45 08             	mov    0x8(%ebp),%eax
  800422:	8b 00                	mov    (%eax),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	8b 45 08             	mov    0x8(%ebp),%eax
  80042a:	89 10                	mov    %edx,(%eax)
  80042c:	8b 45 08             	mov    0x8(%ebp),%eax
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	83 e8 04             	sub    $0x4,%eax
  800434:	8b 00                	mov    (%eax),%eax
  800436:	99                   	cltd   
  800437:	eb 18                	jmp    800451 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 04             	lea    0x4(%eax),%edx
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	83 e8 04             	sub    $0x4,%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	99                   	cltd   
}
  800451:	5d                   	pop    %ebp
  800452:	c3                   	ret    

00800453 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800453:	55                   	push   %ebp
  800454:	89 e5                	mov    %esp,%ebp
  800456:	56                   	push   %esi
  800457:	53                   	push   %ebx
  800458:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80045b:	eb 17                	jmp    800474 <vprintfmt+0x21>
			if (ch == '\0')
  80045d:	85 db                	test   %ebx,%ebx
  80045f:	0f 84 c1 03 00 00    	je     800826 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800465:	83 ec 08             	sub    $0x8,%esp
  800468:	ff 75 0c             	pushl  0xc(%ebp)
  80046b:	53                   	push   %ebx
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	ff d0                	call   *%eax
  800471:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800474:	8b 45 10             	mov    0x10(%ebp),%eax
  800477:	8d 50 01             	lea    0x1(%eax),%edx
  80047a:	89 55 10             	mov    %edx,0x10(%ebp)
  80047d:	8a 00                	mov    (%eax),%al
  80047f:	0f b6 d8             	movzbl %al,%ebx
  800482:	83 fb 25             	cmp    $0x25,%ebx
  800485:	75 d6                	jne    80045d <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800487:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80048b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800492:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800499:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004aa:	8d 50 01             	lea    0x1(%eax),%edx
  8004ad:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b0:	8a 00                	mov    (%eax),%al
  8004b2:	0f b6 d8             	movzbl %al,%ebx
  8004b5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004b8:	83 f8 5b             	cmp    $0x5b,%eax
  8004bb:	0f 87 3d 03 00 00    	ja     8007fe <vprintfmt+0x3ab>
  8004c1:	8b 04 85 18 1e 80 00 	mov    0x801e18(,%eax,4),%eax
  8004c8:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004ca:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004ce:	eb d7                	jmp    8004a7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004d0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004d4:	eb d1                	jmp    8004a7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004d6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e0:	89 d0                	mov    %edx,%eax
  8004e2:	c1 e0 02             	shl    $0x2,%eax
  8004e5:	01 d0                	add    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d8                	add    %ebx,%eax
  8004eb:	83 e8 30             	sub    $0x30,%eax
  8004ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f4:	8a 00                	mov    (%eax),%al
  8004f6:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004f9:	83 fb 2f             	cmp    $0x2f,%ebx
  8004fc:	7e 3e                	jle    80053c <vprintfmt+0xe9>
  8004fe:	83 fb 39             	cmp    $0x39,%ebx
  800501:	7f 39                	jg     80053c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800503:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800506:	eb d5                	jmp    8004dd <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	83 c0 04             	add    $0x4,%eax
  80050e:	89 45 14             	mov    %eax,0x14(%ebp)
  800511:	8b 45 14             	mov    0x14(%ebp),%eax
  800514:	83 e8 04             	sub    $0x4,%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80051c:	eb 1f                	jmp    80053d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80051e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800522:	79 83                	jns    8004a7 <vprintfmt+0x54>
				width = 0;
  800524:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80052b:	e9 77 ff ff ff       	jmp    8004a7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800530:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800537:	e9 6b ff ff ff       	jmp    8004a7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80053c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80053d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800541:	0f 89 60 ff ff ff    	jns    8004a7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800547:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80054d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800554:	e9 4e ff ff ff       	jmp    8004a7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800559:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80055c:	e9 46 ff ff ff       	jmp    8004a7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800561:	8b 45 14             	mov    0x14(%ebp),%eax
  800564:	83 c0 04             	add    $0x4,%eax
  800567:	89 45 14             	mov    %eax,0x14(%ebp)
  80056a:	8b 45 14             	mov    0x14(%ebp),%eax
  80056d:	83 e8 04             	sub    $0x4,%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	83 ec 08             	sub    $0x8,%esp
  800575:	ff 75 0c             	pushl  0xc(%ebp)
  800578:	50                   	push   %eax
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	ff d0                	call   *%eax
  80057e:	83 c4 10             	add    $0x10,%esp
			break;
  800581:	e9 9b 02 00 00       	jmp    800821 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800586:	8b 45 14             	mov    0x14(%ebp),%eax
  800589:	83 c0 04             	add    $0x4,%eax
  80058c:	89 45 14             	mov    %eax,0x14(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	83 e8 04             	sub    $0x4,%eax
  800595:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800597:	85 db                	test   %ebx,%ebx
  800599:	79 02                	jns    80059d <vprintfmt+0x14a>
				err = -err;
  80059b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80059d:	83 fb 64             	cmp    $0x64,%ebx
  8005a0:	7f 0b                	jg     8005ad <vprintfmt+0x15a>
  8005a2:	8b 34 9d 60 1c 80 00 	mov    0x801c60(,%ebx,4),%esi
  8005a9:	85 f6                	test   %esi,%esi
  8005ab:	75 19                	jne    8005c6 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005ad:	53                   	push   %ebx
  8005ae:	68 05 1e 80 00       	push   $0x801e05
  8005b3:	ff 75 0c             	pushl  0xc(%ebp)
  8005b6:	ff 75 08             	pushl  0x8(%ebp)
  8005b9:	e8 70 02 00 00       	call   80082e <printfmt>
  8005be:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005c1:	e9 5b 02 00 00       	jmp    800821 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005c6:	56                   	push   %esi
  8005c7:	68 0e 1e 80 00       	push   $0x801e0e
  8005cc:	ff 75 0c             	pushl  0xc(%ebp)
  8005cf:	ff 75 08             	pushl  0x8(%ebp)
  8005d2:	e8 57 02 00 00       	call   80082e <printfmt>
  8005d7:	83 c4 10             	add    $0x10,%esp
			break;
  8005da:	e9 42 02 00 00       	jmp    800821 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	83 c0 04             	add    $0x4,%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005eb:	83 e8 04             	sub    $0x4,%eax
  8005ee:	8b 30                	mov    (%eax),%esi
  8005f0:	85 f6                	test   %esi,%esi
  8005f2:	75 05                	jne    8005f9 <vprintfmt+0x1a6>
				p = "(null)";
  8005f4:	be 11 1e 80 00       	mov    $0x801e11,%esi
			if (width > 0 && padc != '-')
  8005f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005fd:	7e 6d                	jle    80066c <vprintfmt+0x219>
  8005ff:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800603:	74 67                	je     80066c <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800605:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	50                   	push   %eax
  80060c:	56                   	push   %esi
  80060d:	e8 1e 03 00 00       	call   800930 <strnlen>
  800612:	83 c4 10             	add    $0x10,%esp
  800615:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800618:	eb 16                	jmp    800630 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80061a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80061e:	83 ec 08             	sub    $0x8,%esp
  800621:	ff 75 0c             	pushl  0xc(%ebp)
  800624:	50                   	push   %eax
  800625:	8b 45 08             	mov    0x8(%ebp),%eax
  800628:	ff d0                	call   *%eax
  80062a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80062d:	ff 4d e4             	decl   -0x1c(%ebp)
  800630:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800634:	7f e4                	jg     80061a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800636:	eb 34                	jmp    80066c <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800638:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80063c:	74 1c                	je     80065a <vprintfmt+0x207>
  80063e:	83 fb 1f             	cmp    $0x1f,%ebx
  800641:	7e 05                	jle    800648 <vprintfmt+0x1f5>
  800643:	83 fb 7e             	cmp    $0x7e,%ebx
  800646:	7e 12                	jle    80065a <vprintfmt+0x207>
					putch('?', putdat);
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	6a 3f                	push   $0x3f
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	ff d0                	call   *%eax
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	eb 0f                	jmp    800669 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 0c             	pushl  0xc(%ebp)
  800660:	53                   	push   %ebx
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	ff d0                	call   *%eax
  800666:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800669:	ff 4d e4             	decl   -0x1c(%ebp)
  80066c:	89 f0                	mov    %esi,%eax
  80066e:	8d 70 01             	lea    0x1(%eax),%esi
  800671:	8a 00                	mov    (%eax),%al
  800673:	0f be d8             	movsbl %al,%ebx
  800676:	85 db                	test   %ebx,%ebx
  800678:	74 24                	je     80069e <vprintfmt+0x24b>
  80067a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067e:	78 b8                	js     800638 <vprintfmt+0x1e5>
  800680:	ff 4d e0             	decl   -0x20(%ebp)
  800683:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800687:	79 af                	jns    800638 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800689:	eb 13                	jmp    80069e <vprintfmt+0x24b>
				putch(' ', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	6a 20                	push   $0x20
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80069b:	ff 4d e4             	decl   -0x1c(%ebp)
  80069e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a2:	7f e7                	jg     80068b <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006a4:	e9 78 01 00 00       	jmp    800821 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8006af:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 3c fd ff ff       	call   8003f4 <getint>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c7:	85 d2                	test   %edx,%edx
  8006c9:	79 23                	jns    8006ee <vprintfmt+0x29b>
				putch('-', putdat);
  8006cb:	83 ec 08             	sub    $0x8,%esp
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	6a 2d                	push   $0x2d
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
  8006d8:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e1:	f7 d8                	neg    %eax
  8006e3:	83 d2 00             	adc    $0x0,%edx
  8006e6:	f7 da                	neg    %edx
  8006e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006ee:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006f5:	e9 bc 00 00 00       	jmp    8007b6 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	ff 75 e8             	pushl  -0x18(%ebp)
  800700:	8d 45 14             	lea    0x14(%ebp),%eax
  800703:	50                   	push   %eax
  800704:	e8 84 fc ff ff       	call   80038d <getuint>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800712:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800719:	e9 98 00 00 00       	jmp    8007b6 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	ff 75 0c             	pushl  0xc(%ebp)
  800724:	6a 58                	push   $0x58
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	6a 58                	push   $0x58
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	ff d0                	call   *%eax
  80073b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	ff 75 0c             	pushl  0xc(%ebp)
  800744:	6a 58                	push   $0x58
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	ff d0                	call   *%eax
  80074b:	83 c4 10             	add    $0x10,%esp
			break;
  80074e:	e9 ce 00 00 00       	jmp    800821 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	6a 30                	push   $0x30
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	ff d0                	call   *%eax
  800760:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	6a 78                	push   $0x78
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	ff d0                	call   *%eax
  800770:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800773:	8b 45 14             	mov    0x14(%ebp),%eax
  800776:	83 c0 04             	add    $0x4,%eax
  800779:	89 45 14             	mov    %eax,0x14(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	83 e8 04             	sub    $0x4,%eax
  800782:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800787:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80078e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800795:	eb 1f                	jmp    8007b6 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800797:	83 ec 08             	sub    $0x8,%esp
  80079a:	ff 75 e8             	pushl  -0x18(%ebp)
  80079d:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a0:	50                   	push   %eax
  8007a1:	e8 e7 fb ff ff       	call   80038d <getuint>
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007af:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007bd:	83 ec 04             	sub    $0x4,%esp
  8007c0:	52                   	push   %edx
  8007c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007c4:	50                   	push   %eax
  8007c5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8007cb:	ff 75 0c             	pushl  0xc(%ebp)
  8007ce:	ff 75 08             	pushl  0x8(%ebp)
  8007d1:	e8 00 fb ff ff       	call   8002d6 <printnum>
  8007d6:	83 c4 20             	add    $0x20,%esp
			break;
  8007d9:	eb 46                	jmp    800821 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 0c             	pushl  0xc(%ebp)
  8007e1:	53                   	push   %ebx
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	ff d0                	call   *%eax
  8007e7:	83 c4 10             	add    $0x10,%esp
			break;
  8007ea:	eb 35                	jmp    800821 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007ec:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8007f3:	eb 2c                	jmp    800821 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007f5:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8007fc:	eb 23                	jmp    800821 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	6a 25                	push   $0x25
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80080e:	ff 4d 10             	decl   0x10(%ebp)
  800811:	eb 03                	jmp    800816 <vprintfmt+0x3c3>
  800813:	ff 4d 10             	decl   0x10(%ebp)
  800816:	8b 45 10             	mov    0x10(%ebp),%eax
  800819:	48                   	dec    %eax
  80081a:	8a 00                	mov    (%eax),%al
  80081c:	3c 25                	cmp    $0x25,%al
  80081e:	75 f3                	jne    800813 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800820:	90                   	nop
		}
	}
  800821:	e9 35 fc ff ff       	jmp    80045b <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800826:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800827:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80082a:	5b                   	pop    %ebx
  80082b:	5e                   	pop    %esi
  80082c:	5d                   	pop    %ebp
  80082d:	c3                   	ret    

0080082e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80082e:	55                   	push   %ebp
  80082f:	89 e5                	mov    %esp,%ebp
  800831:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800834:	8d 45 10             	lea    0x10(%ebp),%eax
  800837:	83 c0 04             	add    $0x4,%eax
  80083a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80083d:	8b 45 10             	mov    0x10(%ebp),%eax
  800840:	ff 75 f4             	pushl  -0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	ff 75 08             	pushl  0x8(%ebp)
  80084a:	e8 04 fc ff ff       	call   800453 <vprintfmt>
  80084f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800852:	90                   	nop
  800853:	c9                   	leave  
  800854:	c3                   	ret    

00800855 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800855:	55                   	push   %ebp
  800856:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085b:	8b 40 08             	mov    0x8(%eax),%eax
  80085e:	8d 50 01             	lea    0x1(%eax),%edx
  800861:	8b 45 0c             	mov    0xc(%ebp),%eax
  800864:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086a:	8b 10                	mov    (%eax),%edx
  80086c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086f:	8b 40 04             	mov    0x4(%eax),%eax
  800872:	39 c2                	cmp    %eax,%edx
  800874:	73 12                	jae    800888 <sprintputch+0x33>
		*b->buf++ = ch;
  800876:	8b 45 0c             	mov    0xc(%ebp),%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	8d 48 01             	lea    0x1(%eax),%ecx
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800881:	89 0a                	mov    %ecx,(%edx)
  800883:	8b 55 08             	mov    0x8(%ebp),%edx
  800886:	88 10                	mov    %dl,(%eax)
}
  800888:	90                   	nop
  800889:	5d                   	pop    %ebp
  80088a:	c3                   	ret    

0080088b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80088b:	55                   	push   %ebp
  80088c:	89 e5                	mov    %esp,%ebp
  80088e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800897:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	01 d0                	add    %edx,%eax
  8008a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008b0:	74 06                	je     8008b8 <vsnprintf+0x2d>
  8008b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008b6:	7f 07                	jg     8008bf <vsnprintf+0x34>
		return -E_INVAL;
  8008b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8008bd:	eb 20                	jmp    8008df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bf:	ff 75 14             	pushl  0x14(%ebp)
  8008c2:	ff 75 10             	pushl  0x10(%ebp)
  8008c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c8:	50                   	push   %eax
  8008c9:	68 55 08 80 00       	push   $0x800855
  8008ce:	e8 80 fb ff ff       	call   800453 <vprintfmt>
  8008d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    

008008e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008f6:	50                   	push   %eax
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	ff 75 08             	pushl  0x8(%ebp)
  8008fd:	e8 89 ff ff ff       	call   80088b <vsnprintf>
  800902:	83 c4 10             	add    $0x10,%esp
  800905:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800908:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80090b:	c9                   	leave  
  80090c:	c3                   	ret    

0080090d <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800913:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80091a:	eb 06                	jmp    800922 <strlen+0x15>
		n++;
  80091c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80091f:	ff 45 08             	incl   0x8(%ebp)
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	8a 00                	mov    (%eax),%al
  800927:	84 c0                	test   %al,%al
  800929:	75 f1                	jne    80091c <strlen+0xf>
		n++;
	return n;
  80092b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800936:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80093d:	eb 09                	jmp    800948 <strnlen+0x18>
		n++;
  80093f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800942:	ff 45 08             	incl   0x8(%ebp)
  800945:	ff 4d 0c             	decl   0xc(%ebp)
  800948:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094c:	74 09                	je     800957 <strnlen+0x27>
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8a 00                	mov    (%eax),%al
  800953:	84 c0                	test   %al,%al
  800955:	75 e8                	jne    80093f <strnlen+0xf>
		n++;
	return n;
  800957:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800962:	8b 45 08             	mov    0x8(%ebp),%eax
  800965:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800968:	90                   	nop
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8d 50 01             	lea    0x1(%eax),%edx
  80096f:	89 55 08             	mov    %edx,0x8(%ebp)
  800972:	8b 55 0c             	mov    0xc(%ebp),%edx
  800975:	8d 4a 01             	lea    0x1(%edx),%ecx
  800978:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80097b:	8a 12                	mov    (%edx),%dl
  80097d:	88 10                	mov    %dl,(%eax)
  80097f:	8a 00                	mov    (%eax),%al
  800981:	84 c0                	test   %al,%al
  800983:	75 e4                	jne    800969 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800985:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800996:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80099d:	eb 1f                	jmp    8009be <strncpy+0x34>
		*dst++ = *src;
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8d 50 01             	lea    0x1(%eax),%edx
  8009a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ab:	8a 12                	mov    (%edx),%dl
  8009ad:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b2:	8a 00                	mov    (%eax),%al
  8009b4:	84 c0                	test   %al,%al
  8009b6:	74 03                	je     8009bb <strncpy+0x31>
			src++;
  8009b8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009bb:	ff 45 fc             	incl   -0x4(%ebp)
  8009be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009c4:	72 d9                	jb     80099f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009c9:	c9                   	leave  
  8009ca:	c3                   	ret    

008009cb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009db:	74 30                	je     800a0d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009dd:	eb 16                	jmp    8009f5 <strlcpy+0x2a>
			*dst++ = *src++;
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	8d 50 01             	lea    0x1(%eax),%edx
  8009e5:	89 55 08             	mov    %edx,0x8(%ebp)
  8009e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009ee:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009f1:	8a 12                	mov    (%edx),%dl
  8009f3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009f5:	ff 4d 10             	decl   0x10(%ebp)
  8009f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009fc:	74 09                	je     800a07 <strlcpy+0x3c>
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	8a 00                	mov    (%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 d8                	jne    8009df <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a0d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a13:	29 c2                	sub    %eax,%edx
  800a15:	89 d0                	mov    %edx,%eax
}
  800a17:	c9                   	leave  
  800a18:	c3                   	ret    

00800a19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a1c:	eb 06                	jmp    800a24 <strcmp+0xb>
		p++, q++;
  800a1e:	ff 45 08             	incl   0x8(%ebp)
  800a21:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	8a 00                	mov    (%eax),%al
  800a29:	84 c0                	test   %al,%al
  800a2b:	74 0e                	je     800a3b <strcmp+0x22>
  800a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a30:	8a 10                	mov    (%eax),%dl
  800a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	38 c2                	cmp    %al,%dl
  800a39:	74 e3                	je     800a1e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8a 00                	mov    (%eax),%al
  800a40:	0f b6 d0             	movzbl %al,%edx
  800a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a46:	8a 00                	mov    (%eax),%al
  800a48:	0f b6 c0             	movzbl %al,%eax
  800a4b:	29 c2                	sub    %eax,%edx
  800a4d:	89 d0                	mov    %edx,%eax
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a54:	eb 09                	jmp    800a5f <strncmp+0xe>
		n--, p++, q++;
  800a56:	ff 4d 10             	decl   0x10(%ebp)
  800a59:	ff 45 08             	incl   0x8(%ebp)
  800a5c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a63:	74 17                	je     800a7c <strncmp+0x2b>
  800a65:	8b 45 08             	mov    0x8(%ebp),%eax
  800a68:	8a 00                	mov    (%eax),%al
  800a6a:	84 c0                	test   %al,%al
  800a6c:	74 0e                	je     800a7c <strncmp+0x2b>
  800a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a71:	8a 10                	mov    (%eax),%dl
  800a73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	38 c2                	cmp    %al,%dl
  800a7a:	74 da                	je     800a56 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a80:	75 07                	jne    800a89 <strncmp+0x38>
		return 0;
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
  800a87:	eb 14                	jmp    800a9d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	8a 00                	mov    (%eax),%al
  800a8e:	0f b6 d0             	movzbl %al,%edx
  800a91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a94:	8a 00                	mov    (%eax),%al
  800a96:	0f b6 c0             	movzbl %al,%eax
  800a99:	29 c2                	sub    %eax,%edx
  800a9b:	89 d0                	mov    %edx,%eax
}
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	83 ec 04             	sub    $0x4,%esp
  800aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aab:	eb 12                	jmp    800abf <strchr+0x20>
		if (*s == c)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8a 00                	mov    (%eax),%al
  800ab2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ab5:	75 05                	jne    800abc <strchr+0x1d>
			return (char *) s;
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	eb 11                	jmp    800acd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800abc:	ff 45 08             	incl   0x8(%ebp)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	84 c0                	test   %al,%al
  800ac6:	75 e5                	jne    800aad <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	83 ec 04             	sub    $0x4,%esp
  800ad5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800adb:	eb 0d                	jmp    800aea <strfind+0x1b>
		if (*s == c)
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	8a 00                	mov    (%eax),%al
  800ae2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ae5:	74 0e                	je     800af5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ae7:	ff 45 08             	incl   0x8(%ebp)
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
  800aed:	8a 00                	mov    (%eax),%al
  800aef:	84 c0                	test   %al,%al
  800af1:	75 ea                	jne    800add <strfind+0xe>
  800af3:	eb 01                	jmp    800af6 <strfind+0x27>
		if (*s == c)
			break;
  800af5:	90                   	nop
	return (char *) s;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800af9:	c9                   	leave  
  800afa:	c3                   	ret    

00800afb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b0d:	eb 0e                	jmp    800b1d <memset+0x22>
		*p++ = c;
  800b0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b12:	8d 50 01             	lea    0x1(%eax),%edx
  800b15:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b1d:	ff 4d f8             	decl   -0x8(%ebp)
  800b20:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b24:	79 e9                	jns    800b0f <memset+0x14>
		*p++ = c;

	return v;
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b3d:	eb 16                	jmp    800b55 <memcpy+0x2a>
		*d++ = *s++;
  800b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b42:	8d 50 01             	lea    0x1(%eax),%edx
  800b45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b51:	8a 12                	mov    (%edx),%dl
  800b53:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b55:	8b 45 10             	mov    0x10(%ebp),%eax
  800b58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b5e:	85 c0                	test   %eax,%eax
  800b60:	75 dd                	jne    800b3f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b7c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b7f:	73 50                	jae    800bd1 <memmove+0x6a>
  800b81:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b84:	8b 45 10             	mov    0x10(%ebp),%eax
  800b87:	01 d0                	add    %edx,%eax
  800b89:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b8c:	76 43                	jbe    800bd1 <memmove+0x6a>
		s += n;
  800b8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b91:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b94:	8b 45 10             	mov    0x10(%ebp),%eax
  800b97:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b9a:	eb 10                	jmp    800bac <memmove+0x45>
			*--d = *--s;
  800b9c:	ff 4d f8             	decl   -0x8(%ebp)
  800b9f:	ff 4d fc             	decl   -0x4(%ebp)
  800ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ba5:	8a 10                	mov    (%eax),%dl
  800ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800baa:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bac:	8b 45 10             	mov    0x10(%ebp),%eax
  800baf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	75 e3                	jne    800b9c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb9:	eb 23                	jmp    800bde <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bbe:	8d 50 01             	lea    0x1(%eax),%edx
  800bc1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bca:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bcd:	8a 12                	mov    (%edx),%dl
  800bcf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bda:	85 c0                	test   %eax,%eax
  800bdc:	75 dd                	jne    800bbb <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bde:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be1:	c9                   	leave  
  800be2:	c3                   	ret    

00800be3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800be9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bf5:	eb 2a                	jmp    800c21 <memcmp+0x3e>
		if (*s1 != *s2)
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfa:	8a 10                	mov    (%eax),%dl
  800bfc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bff:	8a 00                	mov    (%eax),%al
  800c01:	38 c2                	cmp    %al,%dl
  800c03:	74 16                	je     800c1b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c08:	8a 00                	mov    (%eax),%al
  800c0a:	0f b6 d0             	movzbl %al,%edx
  800c0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f b6 c0             	movzbl %al,%eax
  800c15:	29 c2                	sub    %eax,%edx
  800c17:	89 d0                	mov    %edx,%eax
  800c19:	eb 18                	jmp    800c33 <memcmp+0x50>
		s1++, s2++;
  800c1b:	ff 45 fc             	incl   -0x4(%ebp)
  800c1e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c21:	8b 45 10             	mov    0x10(%ebp),%eax
  800c24:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c27:	89 55 10             	mov    %edx,0x10(%ebp)
  800c2a:	85 c0                	test   %eax,%eax
  800c2c:	75 c9                	jne    800bf7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c41:	01 d0                	add    %edx,%eax
  800c43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c46:	eb 15                	jmp    800c5d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f b6 d0             	movzbl %al,%edx
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	0f b6 c0             	movzbl %al,%eax
  800c56:	39 c2                	cmp    %eax,%edx
  800c58:	74 0d                	je     800c67 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c5a:	ff 45 08             	incl   0x8(%ebp)
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c60:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c63:	72 e3                	jb     800c48 <memfind+0x13>
  800c65:	eb 01                	jmp    800c68 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c67:	90                   	nop
	return (void *) s;
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c7a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c81:	eb 03                	jmp    800c86 <strtol+0x19>
		s++;
  800c83:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	8a 00                	mov    (%eax),%al
  800c8b:	3c 20                	cmp    $0x20,%al
  800c8d:	74 f4                	je     800c83 <strtol+0x16>
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	8a 00                	mov    (%eax),%al
  800c94:	3c 09                	cmp    $0x9,%al
  800c96:	74 eb                	je     800c83 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	3c 2b                	cmp    $0x2b,%al
  800c9f:	75 05                	jne    800ca6 <strtol+0x39>
		s++;
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	eb 13                	jmp    800cb9 <strtol+0x4c>
	else if (*s == '-')
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	3c 2d                	cmp    $0x2d,%al
  800cad:	75 0a                	jne    800cb9 <strtol+0x4c>
		s++, neg = 1;
  800caf:	ff 45 08             	incl   0x8(%ebp)
  800cb2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cbd:	74 06                	je     800cc5 <strtol+0x58>
  800cbf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cc3:	75 20                	jne    800ce5 <strtol+0x78>
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8a 00                	mov    (%eax),%al
  800cca:	3c 30                	cmp    $0x30,%al
  800ccc:	75 17                	jne    800ce5 <strtol+0x78>
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	40                   	inc    %eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	3c 78                	cmp    $0x78,%al
  800cd6:	75 0d                	jne    800ce5 <strtol+0x78>
		s += 2, base = 16;
  800cd8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cdc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ce3:	eb 28                	jmp    800d0d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ce5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce9:	75 15                	jne    800d00 <strtol+0x93>
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	3c 30                	cmp    $0x30,%al
  800cf2:	75 0c                	jne    800d00 <strtol+0x93>
		s++, base = 8;
  800cf4:	ff 45 08             	incl   0x8(%ebp)
  800cf7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cfe:	eb 0d                	jmp    800d0d <strtol+0xa0>
	else if (base == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strtol+0xa0>
		base = 10;
  800d06:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	3c 2f                	cmp    $0x2f,%al
  800d14:	7e 19                	jle    800d2f <strtol+0xc2>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 39                	cmp    $0x39,%al
  800d1d:	7f 10                	jg     800d2f <strtol+0xc2>
			dig = *s - '0';
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8a 00                	mov    (%eax),%al
  800d24:	0f be c0             	movsbl %al,%eax
  800d27:	83 e8 30             	sub    $0x30,%eax
  800d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d2d:	eb 42                	jmp    800d71 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8a 00                	mov    (%eax),%al
  800d34:	3c 60                	cmp    $0x60,%al
  800d36:	7e 19                	jle    800d51 <strtol+0xe4>
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	3c 7a                	cmp    $0x7a,%al
  800d3f:	7f 10                	jg     800d51 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	8a 00                	mov    (%eax),%al
  800d46:	0f be c0             	movsbl %al,%eax
  800d49:	83 e8 57             	sub    $0x57,%eax
  800d4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d4f:	eb 20                	jmp    800d71 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8a 00                	mov    (%eax),%al
  800d56:	3c 40                	cmp    $0x40,%al
  800d58:	7e 39                	jle    800d93 <strtol+0x126>
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8a 00                	mov    (%eax),%al
  800d5f:	3c 5a                	cmp    $0x5a,%al
  800d61:	7f 30                	jg     800d93 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	8a 00                	mov    (%eax),%al
  800d68:	0f be c0             	movsbl %al,%eax
  800d6b:	83 e8 37             	sub    $0x37,%eax
  800d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d74:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d77:	7d 19                	jge    800d92 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d79:	ff 45 08             	incl   0x8(%ebp)
  800d7c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d7f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d83:	89 c2                	mov    %eax,%edx
  800d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d88:	01 d0                	add    %edx,%eax
  800d8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d8d:	e9 7b ff ff ff       	jmp    800d0d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d92:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d97:	74 08                	je     800da1 <strtol+0x134>
		*endptr = (char *) s;
  800d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800da1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800da5:	74 07                	je     800dae <strtol+0x141>
  800da7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800daa:	f7 d8                	neg    %eax
  800dac:	eb 03                	jmp    800db1 <strtol+0x144>
  800dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800db1:	c9                   	leave  
  800db2:	c3                   	ret    

00800db3 <ltostr>:

void
ltostr(long value, char *str)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800db9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dc0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	79 13                	jns    800de0 <ltostr+0x2d>
	{
		neg = 1;
  800dcd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dda:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ddd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800de8:	99                   	cltd   
  800de9:	f7 f9                	idiv   %ecx
  800deb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800dee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df7:	89 c2                	mov    %eax,%edx
  800df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e01:	83 c2 30             	add    $0x30,%edx
  800e04:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e09:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e0e:	f7 e9                	imul   %ecx
  800e10:	c1 fa 02             	sar    $0x2,%edx
  800e13:	89 c8                	mov    %ecx,%eax
  800e15:	c1 f8 1f             	sar    $0x1f,%eax
  800e18:	29 c2                	sub    %eax,%edx
  800e1a:	89 d0                	mov    %edx,%eax
  800e1c:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	75 bb                	jne    800de0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2f:	48                   	dec    %eax
  800e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e33:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e37:	74 3d                	je     800e76 <ltostr+0xc3>
		start = 1 ;
  800e39:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e40:	eb 34                	jmp    800e76 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e48:	01 d0                	add    %edx,%eax
  800e4a:	8a 00                	mov    (%eax),%al
  800e4c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e55:	01 c2                	add    %eax,%edx
  800e57:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	01 c8                	add    %ecx,%eax
  800e5f:	8a 00                	mov    (%eax),%al
  800e61:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e69:	01 c2                	add    %eax,%edx
  800e6b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e6e:	88 02                	mov    %al,(%edx)
		start++ ;
  800e70:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e73:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e7c:	7c c4                	jl     800e42 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e7e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e84:	01 d0                	add    %edx,%eax
  800e86:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e89:	90                   	nop
  800e8a:	c9                   	leave  
  800e8b:	c3                   	ret    

00800e8c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e92:	ff 75 08             	pushl  0x8(%ebp)
  800e95:	e8 73 fa ff ff       	call   80090d <strlen>
  800e9a:	83 c4 04             	add    $0x4,%esp
  800e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ea0:	ff 75 0c             	pushl  0xc(%ebp)
  800ea3:	e8 65 fa ff ff       	call   80090d <strlen>
  800ea8:	83 c4 04             	add    $0x4,%esp
  800eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ebc:	eb 17                	jmp    800ed5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	01 c2                	add    %eax,%edx
  800ec6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	01 c8                	add    %ecx,%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ed2:	ff 45 fc             	incl   -0x4(%ebp)
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800edb:	7c e1                	jl     800ebe <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800edd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ee4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800eeb:	eb 1f                	jmp    800f0c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef0:	8d 50 01             	lea    0x1(%eax),%edx
  800ef3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ef6:	89 c2                	mov    %eax,%edx
  800ef8:	8b 45 10             	mov    0x10(%ebp),%eax
  800efb:	01 c2                	add    %eax,%edx
  800efd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	01 c8                	add    %ecx,%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f09:	ff 45 f8             	incl   -0x8(%ebp)
  800f0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f12:	7c d9                	jl     800eed <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	c6 00 00             	movb   $0x0,(%eax)
}
  800f1f:	90                   	nop
  800f20:	c9                   	leave  
  800f21:	c3                   	ret    

00800f22 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f25:	8b 45 14             	mov    0x14(%ebp),%eax
  800f28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	8b 00                	mov    (%eax),%eax
  800f33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3d:	01 d0                	add    %edx,%eax
  800f3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f45:	eb 0c                	jmp    800f53 <strsplit+0x31>
			*string++ = 0;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8d 50 01             	lea    0x1(%eax),%edx
  800f4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f50:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	84 c0                	test   %al,%al
  800f5a:	74 18                	je     800f74 <strsplit+0x52>
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f be c0             	movsbl %al,%eax
  800f64:	50                   	push   %eax
  800f65:	ff 75 0c             	pushl  0xc(%ebp)
  800f68:	e8 32 fb ff ff       	call   800a9f <strchr>
  800f6d:	83 c4 08             	add    $0x8,%esp
  800f70:	85 c0                	test   %eax,%eax
  800f72:	75 d3                	jne    800f47 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 00                	mov    (%eax),%al
  800f79:	84 c0                	test   %al,%al
  800f7b:	74 5a                	je     800fd7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f80:	8b 00                	mov    (%eax),%eax
  800f82:	83 f8 0f             	cmp    $0xf,%eax
  800f85:	75 07                	jne    800f8e <strsplit+0x6c>
		{
			return 0;
  800f87:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8c:	eb 66                	jmp    800ff4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f91:	8b 00                	mov    (%eax),%eax
  800f93:	8d 48 01             	lea    0x1(%eax),%ecx
  800f96:	8b 55 14             	mov    0x14(%ebp),%edx
  800f99:	89 0a                	mov    %ecx,(%edx)
  800f9b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa5:	01 c2                	add    %eax,%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fac:	eb 03                	jmp    800fb1 <strsplit+0x8f>
			string++;
  800fae:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb4:	8a 00                	mov    (%eax),%al
  800fb6:	84 c0                	test   %al,%al
  800fb8:	74 8b                	je     800f45 <strsplit+0x23>
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	0f be c0             	movsbl %al,%eax
  800fc2:	50                   	push   %eax
  800fc3:	ff 75 0c             	pushl  0xc(%ebp)
  800fc6:	e8 d4 fa ff ff       	call   800a9f <strchr>
  800fcb:	83 c4 08             	add    $0x8,%esp
  800fce:	85 c0                	test   %eax,%eax
  800fd0:	74 dc                	je     800fae <strsplit+0x8c>
			string++;
	}
  800fd2:	e9 6e ff ff ff       	jmp    800f45 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fd7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fd8:	8b 45 14             	mov    0x14(%ebp),%eax
  800fdb:	8b 00                	mov    (%eax),%eax
  800fdd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fef:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ff4:	c9                   	leave  
  800ff5:	c3                   	ret    

00800ff6 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
  800ff9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800ffc:	83 ec 04             	sub    $0x4,%esp
  800fff:	68 88 1f 80 00       	push   $0x801f88
  801004:	68 3f 01 00 00       	push   $0x13f
  801009:	68 aa 1f 80 00       	push   $0x801faa
  80100e:	e8 9d 06 00 00       	call   8016b0 <_panic>

00801013 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	57                   	push   %edi
  801017:	56                   	push   %esi
  801018:	53                   	push   %ebx
  801019:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801022:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801025:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801028:	8b 7d 18             	mov    0x18(%ebp),%edi
  80102b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80102e:	cd 30                	int    $0x30
  801030:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801033:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801036:	83 c4 10             	add    $0x10,%esp
  801039:	5b                   	pop    %ebx
  80103a:	5e                   	pop    %esi
  80103b:	5f                   	pop    %edi
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 04             	sub    $0x4,%esp
  801044:	8b 45 10             	mov    0x10(%ebp),%eax
  801047:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80104a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	6a 00                	push   $0x0
  801053:	6a 00                	push   $0x0
  801055:	52                   	push   %edx
  801056:	ff 75 0c             	pushl  0xc(%ebp)
  801059:	50                   	push   %eax
  80105a:	6a 00                	push   $0x0
  80105c:	e8 b2 ff ff ff       	call   801013 <syscall>
  801061:	83 c4 18             	add    $0x18,%esp
}
  801064:	90                   	nop
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <sys_cgetc>:

int sys_cgetc(void) {
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80106a:	6a 00                	push   $0x0
  80106c:	6a 00                	push   $0x0
  80106e:	6a 00                	push   $0x0
  801070:	6a 00                	push   $0x0
  801072:	6a 00                	push   $0x0
  801074:	6a 02                	push   $0x2
  801076:	e8 98 ff ff ff       	call   801013 <syscall>
  80107b:	83 c4 18             	add    $0x18,%esp
}
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    

00801080 <sys_lock_cons>:

void sys_lock_cons(void) {
  801080:	55                   	push   %ebp
  801081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801083:	6a 00                	push   $0x0
  801085:	6a 00                	push   $0x0
  801087:	6a 00                	push   $0x0
  801089:	6a 00                	push   $0x0
  80108b:	6a 00                	push   $0x0
  80108d:	6a 03                	push   $0x3
  80108f:	e8 7f ff ff ff       	call   801013 <syscall>
  801094:	83 c4 18             	add    $0x18,%esp
}
  801097:	90                   	nop
  801098:	c9                   	leave  
  801099:	c3                   	ret    

0080109a <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80109d:	6a 00                	push   $0x0
  80109f:	6a 00                	push   $0x0
  8010a1:	6a 00                	push   $0x0
  8010a3:	6a 00                	push   $0x0
  8010a5:	6a 00                	push   $0x0
  8010a7:	6a 04                	push   $0x4
  8010a9:	e8 65 ff ff ff       	call   801013 <syscall>
  8010ae:	83 c4 18             	add    $0x18,%esp
}
  8010b1:	90                   	nop
  8010b2:	c9                   	leave  
  8010b3:	c3                   	ret    

008010b4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8010b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	6a 00                	push   $0x0
  8010bf:	6a 00                	push   $0x0
  8010c1:	6a 00                	push   $0x0
  8010c3:	52                   	push   %edx
  8010c4:	50                   	push   %eax
  8010c5:	6a 08                	push   $0x8
  8010c7:	e8 47 ff ff ff       	call   801013 <syscall>
  8010cc:	83 c4 18             	add    $0x18,%esp
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	56                   	push   %esi
  8010d5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8010d6:	8b 75 18             	mov    0x18(%ebp),%esi
  8010d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	51                   	push   %ecx
  8010e8:	52                   	push   %edx
  8010e9:	50                   	push   %eax
  8010ea:	6a 09                	push   $0x9
  8010ec:	e8 22 ff ff ff       	call   801013 <syscall>
  8010f1:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8010f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	6a 00                	push   $0x0
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	52                   	push   %edx
  80110b:	50                   	push   %eax
  80110c:	6a 0a                	push   $0xa
  80110e:	e8 00 ff ff ff       	call   801013 <syscall>
  801113:	83 c4 18             	add    $0x18,%esp
}
  801116:	c9                   	leave  
  801117:	c3                   	ret    

00801118 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80111b:	6a 00                	push   $0x0
  80111d:	6a 00                	push   $0x0
  80111f:	6a 00                	push   $0x0
  801121:	ff 75 0c             	pushl  0xc(%ebp)
  801124:	ff 75 08             	pushl  0x8(%ebp)
  801127:	6a 0b                	push   $0xb
  801129:	e8 e5 fe ff ff       	call   801013 <syscall>
  80112e:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801136:	6a 00                	push   $0x0
  801138:	6a 00                	push   $0x0
  80113a:	6a 00                	push   $0x0
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	6a 0c                	push   $0xc
  801142:	e8 cc fe ff ff       	call   801013 <syscall>
  801147:	83 c4 18             	add    $0x18,%esp
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80114f:	6a 00                	push   $0x0
  801151:	6a 00                	push   $0x0
  801153:	6a 00                	push   $0x0
  801155:	6a 00                	push   $0x0
  801157:	6a 00                	push   $0x0
  801159:	6a 0d                	push   $0xd
  80115b:	e8 b3 fe ff ff       	call   801013 <syscall>
  801160:	83 c4 18             	add    $0x18,%esp
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801168:	6a 00                	push   $0x0
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	6a 00                	push   $0x0
  801172:	6a 0e                	push   $0xe
  801174:	e8 9a fe ff ff       	call   801013 <syscall>
  801179:	83 c4 18             	add    $0x18,%esp
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801181:	6a 00                	push   $0x0
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 00                	push   $0x0
  80118b:	6a 0f                	push   $0xf
  80118d:	e8 81 fe ff ff       	call   801013 <syscall>
  801192:	83 c4 18             	add    $0x18,%esp
}
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	ff 75 08             	pushl  0x8(%ebp)
  8011a5:	6a 10                	push   $0x10
  8011a7:	e8 67 fe ff ff       	call   801013 <syscall>
  8011ac:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8011af:	c9                   	leave  
  8011b0:	c3                   	ret    

008011b1 <sys_scarce_memory>:

void sys_scarce_memory() {
  8011b1:	55                   	push   %ebp
  8011b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 00                	push   $0x0
  8011be:	6a 11                	push   $0x11
  8011c0:	e8 4e fe ff ff       	call   801013 <syscall>
  8011c5:	83 c4 18             	add    $0x18,%esp
}
  8011c8:	90                   	nop
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <sys_cputc>:

void sys_cputc(const char c) {
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 04             	sub    $0x4,%esp
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011d7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011db:	6a 00                	push   $0x0
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	50                   	push   %eax
  8011e4:	6a 01                	push   $0x1
  8011e6:	e8 28 fe ff ff       	call   801013 <syscall>
  8011eb:	83 c4 18             	add    $0x18,%esp
}
  8011ee:	90                   	nop
  8011ef:	c9                   	leave  
  8011f0:	c3                   	ret    

008011f1 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8011f1:	55                   	push   %ebp
  8011f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8011f4:	6a 00                	push   $0x0
  8011f6:	6a 00                	push   $0x0
  8011f8:	6a 00                	push   $0x0
  8011fa:	6a 00                	push   $0x0
  8011fc:	6a 00                	push   $0x0
  8011fe:	6a 14                	push   $0x14
  801200:	e8 0e fe ff ff       	call   801013 <syscall>
  801205:	83 c4 18             	add    $0x18,%esp
}
  801208:	90                   	nop
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 04             	sub    $0x4,%esp
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801217:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80121a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	6a 00                	push   $0x0
  801223:	51                   	push   %ecx
  801224:	52                   	push   %edx
  801225:	ff 75 0c             	pushl  0xc(%ebp)
  801228:	50                   	push   %eax
  801229:	6a 15                	push   $0x15
  80122b:	e8 e3 fd ff ff       	call   801013 <syscall>
  801230:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	52                   	push   %edx
  801245:	50                   	push   %eax
  801246:	6a 16                	push   $0x16
  801248:	e8 c6 fd ff ff       	call   801013 <syscall>
  80124d:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801255:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801258:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125b:	8b 45 08             	mov    0x8(%ebp),%eax
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	51                   	push   %ecx
  801263:	52                   	push   %edx
  801264:	50                   	push   %eax
  801265:	6a 17                	push   $0x17
  801267:	e8 a7 fd ff ff       	call   801013 <syscall>
  80126c:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	6a 00                	push   $0x0
  80127c:	6a 00                	push   $0x0
  80127e:	6a 00                	push   $0x0
  801280:	52                   	push   %edx
  801281:	50                   	push   %eax
  801282:	6a 18                	push   $0x18
  801284:	e8 8a fd ff ff       	call   801013 <syscall>
  801289:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80128c:	c9                   	leave  
  80128d:	c3                   	ret    

0080128e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801291:	8b 45 08             	mov    0x8(%ebp),%eax
  801294:	6a 00                	push   $0x0
  801296:	ff 75 14             	pushl  0x14(%ebp)
  801299:	ff 75 10             	pushl  0x10(%ebp)
  80129c:	ff 75 0c             	pushl  0xc(%ebp)
  80129f:	50                   	push   %eax
  8012a0:	6a 19                	push   $0x19
  8012a2:	e8 6c fd ff ff       	call   801013 <syscall>
  8012a7:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <sys_run_env>:

void sys_run_env(int32 envId) {
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	6a 00                	push   $0x0
  8012b4:	6a 00                	push   $0x0
  8012b6:	6a 00                	push   $0x0
  8012b8:	6a 00                	push   $0x0
  8012ba:	50                   	push   %eax
  8012bb:	6a 1a                	push   $0x1a
  8012bd:	e8 51 fd ff ff       	call   801013 <syscall>
  8012c2:	83 c4 18             	add    $0x18,%esp
}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	6a 00                	push   $0x0
  8012d0:	6a 00                	push   $0x0
  8012d2:	6a 00                	push   $0x0
  8012d4:	6a 00                	push   $0x0
  8012d6:	50                   	push   %eax
  8012d7:	6a 1b                	push   $0x1b
  8012d9:	e8 35 fd ff ff       	call   801013 <syscall>
  8012de:	83 c4 18             	add    $0x18,%esp
}
  8012e1:	c9                   	leave  
  8012e2:	c3                   	ret    

008012e3 <sys_getenvid>:

int32 sys_getenvid(void) {
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	6a 00                	push   $0x0
  8012ec:	6a 00                	push   $0x0
  8012ee:	6a 00                	push   $0x0
  8012f0:	6a 05                	push   $0x5
  8012f2:	e8 1c fd ff ff       	call   801013 <syscall>
  8012f7:	83 c4 18             	add    $0x18,%esp
}
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 06                	push   $0x6
  80130b:	e8 03 fd ff ff       	call   801013 <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 07                	push   $0x7
  801324:	e8 ea fc ff ff       	call   801013 <syscall>
  801329:	83 c4 18             	add    $0x18,%esp
}
  80132c:	c9                   	leave  
  80132d:	c3                   	ret    

0080132e <sys_exit_env>:

void sys_exit_env(void) {
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 1c                	push   $0x1c
  80133d:	e8 d1 fc ff ff       	call   801013 <syscall>
  801342:	83 c4 18             	add    $0x18,%esp
}
  801345:	90                   	nop
  801346:	c9                   	leave  
  801347:	c3                   	ret    

00801348 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80134e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801351:	8d 50 04             	lea    0x4(%eax),%edx
  801354:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801357:	6a 00                	push   $0x0
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	52                   	push   %edx
  80135e:	50                   	push   %eax
  80135f:	6a 1d                	push   $0x1d
  801361:	e8 ad fc ff ff       	call   801013 <syscall>
  801366:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801369:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801372:	89 01                	mov    %eax,(%ecx)
  801374:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	c9                   	leave  
  80137b:	c2 04 00             	ret    $0x4

0080137e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	ff 75 10             	pushl  0x10(%ebp)
  801388:	ff 75 0c             	pushl  0xc(%ebp)
  80138b:	ff 75 08             	pushl  0x8(%ebp)
  80138e:	6a 13                	push   $0x13
  801390:	e8 7e fc ff ff       	call   801013 <syscall>
  801395:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801398:	90                   	nop
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_rcr2>:
uint32 sys_rcr2() {
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 1e                	push   $0x1e
  8013aa:	e8 64 fc ff ff       	call   801013 <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 04             	sub    $0x4,%esp
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013c0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	6a 00                	push   $0x0
  8013ca:	6a 00                	push   $0x0
  8013cc:	50                   	push   %eax
  8013cd:	6a 1f                	push   $0x1f
  8013cf:	e8 3f fc ff ff       	call   801013 <syscall>
  8013d4:	83 c4 18             	add    $0x18,%esp
	return;
  8013d7:	90                   	nop
}
  8013d8:	c9                   	leave  
  8013d9:	c3                   	ret    

008013da <rsttst>:
void rsttst() {
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013dd:	6a 00                	push   $0x0
  8013df:	6a 00                	push   $0x0
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 21                	push   $0x21
  8013e9:	e8 25 fc ff ff       	call   801013 <syscall>
  8013ee:	83 c4 18             	add    $0x18,%esp
	return;
  8013f1:	90                   	nop
}
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    

008013f4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801400:	8b 55 18             	mov    0x18(%ebp),%edx
  801403:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801407:	52                   	push   %edx
  801408:	50                   	push   %eax
  801409:	ff 75 10             	pushl  0x10(%ebp)
  80140c:	ff 75 0c             	pushl  0xc(%ebp)
  80140f:	ff 75 08             	pushl  0x8(%ebp)
  801412:	6a 20                	push   $0x20
  801414:	e8 fa fb ff ff       	call   801013 <syscall>
  801419:	83 c4 18             	add    $0x18,%esp
	return;
  80141c:	90                   	nop
}
  80141d:	c9                   	leave  
  80141e:	c3                   	ret    

0080141f <chktst>:
void chktst(uint32 n) {
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	ff 75 08             	pushl  0x8(%ebp)
  80142d:	6a 22                	push   $0x22
  80142f:	e8 df fb ff ff       	call   801013 <syscall>
  801434:	83 c4 18             	add    $0x18,%esp
	return;
  801437:	90                   	nop
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <inctst>:

void inctst() {
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 00                	push   $0x0
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 23                	push   $0x23
  801449:	e8 c5 fb ff ff       	call   801013 <syscall>
  80144e:	83 c4 18             	add    $0x18,%esp
	return;
  801451:	90                   	nop
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <gettst>:
uint32 gettst() {
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801457:	6a 00                	push   $0x0
  801459:	6a 00                	push   $0x0
  80145b:	6a 00                	push   $0x0
  80145d:	6a 00                	push   $0x0
  80145f:	6a 00                	push   $0x0
  801461:	6a 24                	push   $0x24
  801463:	e8 ab fb ff ff       	call   801013 <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
}
  80146b:	c9                   	leave  
  80146c:	c3                   	ret    

0080146d <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 25                	push   $0x25
  80147f:	e8 8f fb ff ff       	call   801013 <syscall>
  801484:	83 c4 18             	add    $0x18,%esp
  801487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80148a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80148e:	75 07                	jne    801497 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801490:	b8 01 00 00 00       	mov    $0x1,%eax
  801495:	eb 05                	jmp    80149c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
  8014a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 25                	push   $0x25
  8014b0:	e8 5e fb ff ff       	call   801013 <syscall>
  8014b5:	83 c4 18             	add    $0x18,%esp
  8014b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014bb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014bf:	75 07                	jne    8014c8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8014c6:	eb 05                	jmp    8014cd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cd:	c9                   	leave  
  8014ce:	c3                   	ret    

008014cf <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8014cf:	55                   	push   %ebp
  8014d0:	89 e5                	mov    %esp,%ebp
  8014d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	6a 00                	push   $0x0
  8014db:	6a 00                	push   $0x0
  8014dd:	6a 00                	push   $0x0
  8014df:	6a 25                	push   $0x25
  8014e1:	e8 2d fb ff ff       	call   801013 <syscall>
  8014e6:	83 c4 18             	add    $0x18,%esp
  8014e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014ec:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014f0:	75 07                	jne    8014f9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8014f7:	eb 05                	jmp    8014fe <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801506:	6a 00                	push   $0x0
  801508:	6a 00                	push   $0x0
  80150a:	6a 00                	push   $0x0
  80150c:	6a 00                	push   $0x0
  80150e:	6a 00                	push   $0x0
  801510:	6a 25                	push   $0x25
  801512:	e8 fc fa ff ff       	call   801013 <syscall>
  801517:	83 c4 18             	add    $0x18,%esp
  80151a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80151d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801521:	75 07                	jne    80152a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801523:	b8 01 00 00 00       	mov    $0x1,%eax
  801528:	eb 05                	jmp    80152f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80152a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152f:	c9                   	leave  
  801530:	c3                   	ret    

00801531 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801531:	55                   	push   %ebp
  801532:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801534:	6a 00                	push   $0x0
  801536:	6a 00                	push   $0x0
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	ff 75 08             	pushl  0x8(%ebp)
  80153f:	6a 26                	push   $0x26
  801541:	e8 cd fa ff ff       	call   801013 <syscall>
  801546:	83 c4 18             	add    $0x18,%esp
	return;
  801549:	90                   	nop
}
  80154a:	c9                   	leave  
  80154b:	c3                   	ret    

0080154c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801550:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801553:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801556:	8b 55 0c             	mov    0xc(%ebp),%edx
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	6a 00                	push   $0x0
  80155e:	53                   	push   %ebx
  80155f:	51                   	push   %ecx
  801560:	52                   	push   %edx
  801561:	50                   	push   %eax
  801562:	6a 27                	push   $0x27
  801564:	e8 aa fa ff ff       	call   801013 <syscall>
  801569:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80156c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80156f:	c9                   	leave  
  801570:	c3                   	ret    

00801571 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801571:	55                   	push   %ebp
  801572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801574:	8b 55 0c             	mov    0xc(%ebp),%edx
  801577:	8b 45 08             	mov    0x8(%ebp),%eax
  80157a:	6a 00                	push   $0x0
  80157c:	6a 00                	push   $0x0
  80157e:	6a 00                	push   $0x0
  801580:	52                   	push   %edx
  801581:	50                   	push   %eax
  801582:	6a 28                	push   $0x28
  801584:	e8 8a fa ff ff       	call   801013 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    

0080158e <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80158e:	55                   	push   %ebp
  80158f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801591:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801594:	8b 55 0c             	mov    0xc(%ebp),%edx
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	6a 00                	push   $0x0
  80159c:	51                   	push   %ecx
  80159d:	ff 75 10             	pushl  0x10(%ebp)
  8015a0:	52                   	push   %edx
  8015a1:	50                   	push   %eax
  8015a2:	6a 29                	push   $0x29
  8015a4:	e8 6a fa ff ff       	call   801013 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	ff 75 10             	pushl  0x10(%ebp)
  8015b8:	ff 75 0c             	pushl  0xc(%ebp)
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	6a 12                	push   $0x12
  8015c0:	e8 4e fa ff ff       	call   801013 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
	return;
  8015c8:	90                   	nop
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8015ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	6a 00                	push   $0x0
  8015da:	52                   	push   %edx
  8015db:	50                   	push   %eax
  8015dc:	6a 2a                	push   $0x2a
  8015de:	e8 30 fa ff ff       	call   801013 <syscall>
  8015e3:	83 c4 18             	add    $0x18,%esp
	return;
  8015e6:	90                   	nop
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	50                   	push   %eax
  8015f8:	6a 2b                	push   $0x2b
  8015fa:	e8 14 fa ff ff       	call   801013 <syscall>
  8015ff:	83 c4 18             	add    $0x18,%esp
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	ff 75 0c             	pushl  0xc(%ebp)
  801610:	ff 75 08             	pushl  0x8(%ebp)
  801613:	6a 2c                	push   $0x2c
  801615:	e8 f9 f9 ff ff       	call   801013 <syscall>
  80161a:	83 c4 18             	add    $0x18,%esp
	return;
  80161d:	90                   	nop
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	ff 75 0c             	pushl  0xc(%ebp)
  80162c:	ff 75 08             	pushl  0x8(%ebp)
  80162f:	6a 2d                	push   $0x2d
  801631:	e8 dd f9 ff ff       	call   801013 <syscall>
  801636:	83 c4 18             	add    $0x18,%esp
	return;
  801639:	90                   	nop
}
  80163a:	c9                   	leave  
  80163b:	c3                   	ret    

0080163c <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	50                   	push   %eax
  80164b:	6a 2f                	push   $0x2f
  80164d:	e8 c1 f9 ff ff       	call   801013 <syscall>
  801652:	83 c4 18             	add    $0x18,%esp
	return;
  801655:	90                   	nop
}
  801656:	c9                   	leave  
  801657:	c3                   	ret    

00801658 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80165b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	52                   	push   %edx
  801668:	50                   	push   %eax
  801669:	6a 30                	push   $0x30
  80166b:	e8 a3 f9 ff ff       	call   801013 <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
	return;
  801673:	90                   	nop
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	50                   	push   %eax
  801685:	6a 31                	push   $0x31
  801687:	e8 87 f9 ff ff       	call   801013 <syscall>
  80168c:	83 c4 18             	add    $0x18,%esp
	return;
  80168f:	90                   	nop
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801695:	8b 55 0c             	mov    0xc(%ebp),%edx
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	52                   	push   %edx
  8016a2:	50                   	push   %eax
  8016a3:	6a 2e                	push   $0x2e
  8016a5:	e8 69 f9 ff ff       	call   801013 <syscall>
  8016aa:	83 c4 18             	add    $0x18,%esp
    return;
  8016ad:	90                   	nop
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016b6:	8d 45 10             	lea    0x10(%ebp),%eax
  8016b9:	83 c0 04             	add    $0x4,%eax
  8016bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016bf:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	74 16                	je     8016de <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016c8:	a1 28 30 80 00       	mov    0x803028,%eax
  8016cd:	83 ec 08             	sub    $0x8,%esp
  8016d0:	50                   	push   %eax
  8016d1:	68 b8 1f 80 00       	push   $0x801fb8
  8016d6:	e8 9e eb ff ff       	call   800279 <cprintf>
  8016db:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016de:	a1 04 30 80 00       	mov    0x803004,%eax
  8016e3:	ff 75 0c             	pushl  0xc(%ebp)
  8016e6:	ff 75 08             	pushl  0x8(%ebp)
  8016e9:	50                   	push   %eax
  8016ea:	68 bd 1f 80 00       	push   $0x801fbd
  8016ef:	e8 85 eb ff ff       	call   800279 <cprintf>
  8016f4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	ff 75 f4             	pushl  -0xc(%ebp)
  801700:	50                   	push   %eax
  801701:	e8 08 eb ff ff       	call   80020e <vcprintf>
  801706:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801709:	83 ec 08             	sub    $0x8,%esp
  80170c:	6a 00                	push   $0x0
  80170e:	68 d9 1f 80 00       	push   $0x801fd9
  801713:	e8 f6 ea ff ff       	call   80020e <vcprintf>
  801718:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80171b:	e8 77 ea ff ff       	call   800197 <exit>

	// should not return here
	while (1) ;
  801720:	eb fe                	jmp    801720 <_panic+0x70>

00801722 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801728:	a1 08 30 80 00       	mov    0x803008,%eax
  80172d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801733:	8b 45 0c             	mov    0xc(%ebp),%eax
  801736:	39 c2                	cmp    %eax,%edx
  801738:	74 14                	je     80174e <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80173a:	83 ec 04             	sub    $0x4,%esp
  80173d:	68 dc 1f 80 00       	push   $0x801fdc
  801742:	6a 26                	push   $0x26
  801744:	68 28 20 80 00       	push   $0x802028
  801749:	e8 62 ff ff ff       	call   8016b0 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80174e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80175c:	e9 c5 00 00 00       	jmp    801826 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	8b 00                	mov    (%eax),%eax
  801772:	85 c0                	test   %eax,%eax
  801774:	75 08                	jne    80177e <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801779:	e9 a5 00 00 00       	jmp    801823 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80177e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80178c:	eb 69                	jmp    8017f7 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80178e:	a1 08 30 80 00       	mov    0x803008,%eax
  801793:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80179c:	89 d0                	mov    %edx,%eax
  80179e:	01 c0                	add    %eax,%eax
  8017a0:	01 d0                	add    %edx,%eax
  8017a2:	c1 e0 03             	shl    $0x3,%eax
  8017a5:	01 c8                	add    %ecx,%eax
  8017a7:	8a 40 04             	mov    0x4(%eax),%al
  8017aa:	84 c0                	test   %al,%al
  8017ac:	75 46                	jne    8017f4 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017ae:	a1 08 30 80 00       	mov    0x803008,%eax
  8017b3:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8017b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017bc:	89 d0                	mov    %edx,%eax
  8017be:	01 c0                	add    %eax,%eax
  8017c0:	01 d0                	add    %edx,%eax
  8017c2:	c1 e0 03             	shl    $0x3,%eax
  8017c5:	01 c8                	add    %ecx,%eax
  8017c7:	8b 00                	mov    (%eax),%eax
  8017c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	01 c8                	add    %ecx,%eax
  8017e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017e7:	39 c2                	cmp    %eax,%edx
  8017e9:	75 09                	jne    8017f4 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017f2:	eb 15                	jmp    801809 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017f4:	ff 45 e8             	incl   -0x18(%ebp)
  8017f7:	a1 08 30 80 00       	mov    0x803008,%eax
  8017fc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801802:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801805:	39 c2                	cmp    %eax,%edx
  801807:	77 85                	ja     80178e <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801809:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80180d:	75 14                	jne    801823 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	68 34 20 80 00       	push   $0x802034
  801817:	6a 3a                	push   $0x3a
  801819:	68 28 20 80 00       	push   $0x802028
  80181e:	e8 8d fe ff ff       	call   8016b0 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801823:	ff 45 f0             	incl   -0x10(%ebp)
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80182c:	0f 8c 2f ff ff ff    	jl     801761 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801832:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801839:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801840:	eb 26                	jmp    801868 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801842:	a1 08 30 80 00       	mov    0x803008,%eax
  801847:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80184d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801850:	89 d0                	mov    %edx,%eax
  801852:	01 c0                	add    %eax,%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	c1 e0 03             	shl    $0x3,%eax
  801859:	01 c8                	add    %ecx,%eax
  80185b:	8a 40 04             	mov    0x4(%eax),%al
  80185e:	3c 01                	cmp    $0x1,%al
  801860:	75 03                	jne    801865 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801862:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801865:	ff 45 e0             	incl   -0x20(%ebp)
  801868:	a1 08 30 80 00       	mov    0x803008,%eax
  80186d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801873:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801876:	39 c2                	cmp    %eax,%edx
  801878:	77 c8                	ja     801842 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801880:	74 14                	je     801896 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	68 88 20 80 00       	push   $0x802088
  80188a:	6a 44                	push   $0x44
  80188c:	68 28 20 80 00       	push   $0x802028
  801891:	e8 1a fe ff ff       	call   8016b0 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801896:	90                   	nop
  801897:	c9                   	leave  
  801898:	c3                   	ret    
  801899:	66 90                	xchg   %ax,%ax
  80189b:	90                   	nop

0080189c <__udivdi3>:
  80189c:	55                   	push   %ebp
  80189d:	57                   	push   %edi
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 1c             	sub    $0x1c,%esp
  8018a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018b3:	89 ca                	mov    %ecx,%edx
  8018b5:	89 f8                	mov    %edi,%eax
  8018b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018bb:	85 f6                	test   %esi,%esi
  8018bd:	75 2d                	jne    8018ec <__udivdi3+0x50>
  8018bf:	39 cf                	cmp    %ecx,%edi
  8018c1:	77 65                	ja     801928 <__udivdi3+0x8c>
  8018c3:	89 fd                	mov    %edi,%ebp
  8018c5:	85 ff                	test   %edi,%edi
  8018c7:	75 0b                	jne    8018d4 <__udivdi3+0x38>
  8018c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ce:	31 d2                	xor    %edx,%edx
  8018d0:	f7 f7                	div    %edi
  8018d2:	89 c5                	mov    %eax,%ebp
  8018d4:	31 d2                	xor    %edx,%edx
  8018d6:	89 c8                	mov    %ecx,%eax
  8018d8:	f7 f5                	div    %ebp
  8018da:	89 c1                	mov    %eax,%ecx
  8018dc:	89 d8                	mov    %ebx,%eax
  8018de:	f7 f5                	div    %ebp
  8018e0:	89 cf                	mov    %ecx,%edi
  8018e2:	89 fa                	mov    %edi,%edx
  8018e4:	83 c4 1c             	add    $0x1c,%esp
  8018e7:	5b                   	pop    %ebx
  8018e8:	5e                   	pop    %esi
  8018e9:	5f                   	pop    %edi
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    
  8018ec:	39 ce                	cmp    %ecx,%esi
  8018ee:	77 28                	ja     801918 <__udivdi3+0x7c>
  8018f0:	0f bd fe             	bsr    %esi,%edi
  8018f3:	83 f7 1f             	xor    $0x1f,%edi
  8018f6:	75 40                	jne    801938 <__udivdi3+0x9c>
  8018f8:	39 ce                	cmp    %ecx,%esi
  8018fa:	72 0a                	jb     801906 <__udivdi3+0x6a>
  8018fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801900:	0f 87 9e 00 00 00    	ja     8019a4 <__udivdi3+0x108>
  801906:	b8 01 00 00 00       	mov    $0x1,%eax
  80190b:	89 fa                	mov    %edi,%edx
  80190d:	83 c4 1c             	add    $0x1c,%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5f                   	pop    %edi
  801913:	5d                   	pop    %ebp
  801914:	c3                   	ret    
  801915:	8d 76 00             	lea    0x0(%esi),%esi
  801918:	31 ff                	xor    %edi,%edi
  80191a:	31 c0                	xor    %eax,%eax
  80191c:	89 fa                	mov    %edi,%edx
  80191e:	83 c4 1c             	add    $0x1c,%esp
  801921:	5b                   	pop    %ebx
  801922:	5e                   	pop    %esi
  801923:	5f                   	pop    %edi
  801924:	5d                   	pop    %ebp
  801925:	c3                   	ret    
  801926:	66 90                	xchg   %ax,%ax
  801928:	89 d8                	mov    %ebx,%eax
  80192a:	f7 f7                	div    %edi
  80192c:	31 ff                	xor    %edi,%edi
  80192e:	89 fa                	mov    %edi,%edx
  801930:	83 c4 1c             	add    $0x1c,%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5f                   	pop    %edi
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    
  801938:	bd 20 00 00 00       	mov    $0x20,%ebp
  80193d:	89 eb                	mov    %ebp,%ebx
  80193f:	29 fb                	sub    %edi,%ebx
  801941:	89 f9                	mov    %edi,%ecx
  801943:	d3 e6                	shl    %cl,%esi
  801945:	89 c5                	mov    %eax,%ebp
  801947:	88 d9                	mov    %bl,%cl
  801949:	d3 ed                	shr    %cl,%ebp
  80194b:	89 e9                	mov    %ebp,%ecx
  80194d:	09 f1                	or     %esi,%ecx
  80194f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801953:	89 f9                	mov    %edi,%ecx
  801955:	d3 e0                	shl    %cl,%eax
  801957:	89 c5                	mov    %eax,%ebp
  801959:	89 d6                	mov    %edx,%esi
  80195b:	88 d9                	mov    %bl,%cl
  80195d:	d3 ee                	shr    %cl,%esi
  80195f:	89 f9                	mov    %edi,%ecx
  801961:	d3 e2                	shl    %cl,%edx
  801963:	8b 44 24 08          	mov    0x8(%esp),%eax
  801967:	88 d9                	mov    %bl,%cl
  801969:	d3 e8                	shr    %cl,%eax
  80196b:	09 c2                	or     %eax,%edx
  80196d:	89 d0                	mov    %edx,%eax
  80196f:	89 f2                	mov    %esi,%edx
  801971:	f7 74 24 0c          	divl   0xc(%esp)
  801975:	89 d6                	mov    %edx,%esi
  801977:	89 c3                	mov    %eax,%ebx
  801979:	f7 e5                	mul    %ebp
  80197b:	39 d6                	cmp    %edx,%esi
  80197d:	72 19                	jb     801998 <__udivdi3+0xfc>
  80197f:	74 0b                	je     80198c <__udivdi3+0xf0>
  801981:	89 d8                	mov    %ebx,%eax
  801983:	31 ff                	xor    %edi,%edi
  801985:	e9 58 ff ff ff       	jmp    8018e2 <__udivdi3+0x46>
  80198a:	66 90                	xchg   %ax,%ax
  80198c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801990:	89 f9                	mov    %edi,%ecx
  801992:	d3 e2                	shl    %cl,%edx
  801994:	39 c2                	cmp    %eax,%edx
  801996:	73 e9                	jae    801981 <__udivdi3+0xe5>
  801998:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80199b:	31 ff                	xor    %edi,%edi
  80199d:	e9 40 ff ff ff       	jmp    8018e2 <__udivdi3+0x46>
  8019a2:	66 90                	xchg   %ax,%ax
  8019a4:	31 c0                	xor    %eax,%eax
  8019a6:	e9 37 ff ff ff       	jmp    8018e2 <__udivdi3+0x46>
  8019ab:	90                   	nop

008019ac <__umoddi3>:
  8019ac:	55                   	push   %ebp
  8019ad:	57                   	push   %edi
  8019ae:	56                   	push   %esi
  8019af:	53                   	push   %ebx
  8019b0:	83 ec 1c             	sub    $0x1c,%esp
  8019b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019cb:	89 f3                	mov    %esi,%ebx
  8019cd:	89 fa                	mov    %edi,%edx
  8019cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019d3:	89 34 24             	mov    %esi,(%esp)
  8019d6:	85 c0                	test   %eax,%eax
  8019d8:	75 1a                	jne    8019f4 <__umoddi3+0x48>
  8019da:	39 f7                	cmp    %esi,%edi
  8019dc:	0f 86 a2 00 00 00    	jbe    801a84 <__umoddi3+0xd8>
  8019e2:	89 c8                	mov    %ecx,%eax
  8019e4:	89 f2                	mov    %esi,%edx
  8019e6:	f7 f7                	div    %edi
  8019e8:	89 d0                	mov    %edx,%eax
  8019ea:	31 d2                	xor    %edx,%edx
  8019ec:	83 c4 1c             	add    $0x1c,%esp
  8019ef:	5b                   	pop    %ebx
  8019f0:	5e                   	pop    %esi
  8019f1:	5f                   	pop    %edi
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    
  8019f4:	39 f0                	cmp    %esi,%eax
  8019f6:	0f 87 ac 00 00 00    	ja     801aa8 <__umoddi3+0xfc>
  8019fc:	0f bd e8             	bsr    %eax,%ebp
  8019ff:	83 f5 1f             	xor    $0x1f,%ebp
  801a02:	0f 84 ac 00 00 00    	je     801ab4 <__umoddi3+0x108>
  801a08:	bf 20 00 00 00       	mov    $0x20,%edi
  801a0d:	29 ef                	sub    %ebp,%edi
  801a0f:	89 fe                	mov    %edi,%esi
  801a11:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a15:	89 e9                	mov    %ebp,%ecx
  801a17:	d3 e0                	shl    %cl,%eax
  801a19:	89 d7                	mov    %edx,%edi
  801a1b:	89 f1                	mov    %esi,%ecx
  801a1d:	d3 ef                	shr    %cl,%edi
  801a1f:	09 c7                	or     %eax,%edi
  801a21:	89 e9                	mov    %ebp,%ecx
  801a23:	d3 e2                	shl    %cl,%edx
  801a25:	89 14 24             	mov    %edx,(%esp)
  801a28:	89 d8                	mov    %ebx,%eax
  801a2a:	d3 e0                	shl    %cl,%eax
  801a2c:	89 c2                	mov    %eax,%edx
  801a2e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a32:	d3 e0                	shl    %cl,%eax
  801a34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a38:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a3c:	89 f1                	mov    %esi,%ecx
  801a3e:	d3 e8                	shr    %cl,%eax
  801a40:	09 d0                	or     %edx,%eax
  801a42:	d3 eb                	shr    %cl,%ebx
  801a44:	89 da                	mov    %ebx,%edx
  801a46:	f7 f7                	div    %edi
  801a48:	89 d3                	mov    %edx,%ebx
  801a4a:	f7 24 24             	mull   (%esp)
  801a4d:	89 c6                	mov    %eax,%esi
  801a4f:	89 d1                	mov    %edx,%ecx
  801a51:	39 d3                	cmp    %edx,%ebx
  801a53:	0f 82 87 00 00 00    	jb     801ae0 <__umoddi3+0x134>
  801a59:	0f 84 91 00 00 00    	je     801af0 <__umoddi3+0x144>
  801a5f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a63:	29 f2                	sub    %esi,%edx
  801a65:	19 cb                	sbb    %ecx,%ebx
  801a67:	89 d8                	mov    %ebx,%eax
  801a69:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a6d:	d3 e0                	shl    %cl,%eax
  801a6f:	89 e9                	mov    %ebp,%ecx
  801a71:	d3 ea                	shr    %cl,%edx
  801a73:	09 d0                	or     %edx,%eax
  801a75:	89 e9                	mov    %ebp,%ecx
  801a77:	d3 eb                	shr    %cl,%ebx
  801a79:	89 da                	mov    %ebx,%edx
  801a7b:	83 c4 1c             	add    $0x1c,%esp
  801a7e:	5b                   	pop    %ebx
  801a7f:	5e                   	pop    %esi
  801a80:	5f                   	pop    %edi
  801a81:	5d                   	pop    %ebp
  801a82:	c3                   	ret    
  801a83:	90                   	nop
  801a84:	89 fd                	mov    %edi,%ebp
  801a86:	85 ff                	test   %edi,%edi
  801a88:	75 0b                	jne    801a95 <__umoddi3+0xe9>
  801a8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8f:	31 d2                	xor    %edx,%edx
  801a91:	f7 f7                	div    %edi
  801a93:	89 c5                	mov    %eax,%ebp
  801a95:	89 f0                	mov    %esi,%eax
  801a97:	31 d2                	xor    %edx,%edx
  801a99:	f7 f5                	div    %ebp
  801a9b:	89 c8                	mov    %ecx,%eax
  801a9d:	f7 f5                	div    %ebp
  801a9f:	89 d0                	mov    %edx,%eax
  801aa1:	e9 44 ff ff ff       	jmp    8019ea <__umoddi3+0x3e>
  801aa6:	66 90                	xchg   %ax,%ax
  801aa8:	89 c8                	mov    %ecx,%eax
  801aaa:	89 f2                	mov    %esi,%edx
  801aac:	83 c4 1c             	add    $0x1c,%esp
  801aaf:	5b                   	pop    %ebx
  801ab0:	5e                   	pop    %esi
  801ab1:	5f                   	pop    %edi
  801ab2:	5d                   	pop    %ebp
  801ab3:	c3                   	ret    
  801ab4:	3b 04 24             	cmp    (%esp),%eax
  801ab7:	72 06                	jb     801abf <__umoddi3+0x113>
  801ab9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801abd:	77 0f                	ja     801ace <__umoddi3+0x122>
  801abf:	89 f2                	mov    %esi,%edx
  801ac1:	29 f9                	sub    %edi,%ecx
  801ac3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ac7:	89 14 24             	mov    %edx,(%esp)
  801aca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ace:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ad2:	8b 14 24             	mov    (%esp),%edx
  801ad5:	83 c4 1c             	add    $0x1c,%esp
  801ad8:	5b                   	pop    %ebx
  801ad9:	5e                   	pop    %esi
  801ada:	5f                   	pop    %edi
  801adb:	5d                   	pop    %ebp
  801adc:	c3                   	ret    
  801add:	8d 76 00             	lea    0x0(%esi),%esi
  801ae0:	2b 04 24             	sub    (%esp),%eax
  801ae3:	19 fa                	sbb    %edi,%edx
  801ae5:	89 d1                	mov    %edx,%ecx
  801ae7:	89 c6                	mov    %eax,%esi
  801ae9:	e9 71 ff ff ff       	jmp    801a5f <__umoddi3+0xb3>
  801aee:	66 90                	xchg   %ax,%ax
  801af0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801af4:	72 ea                	jb     801ae0 <__umoddi3+0x134>
  801af6:	89 d9                	mov    %ebx,%ecx
  801af8:	e9 62 ff ff ff       	jmp    801a5f <__umoddi3+0xb3>
