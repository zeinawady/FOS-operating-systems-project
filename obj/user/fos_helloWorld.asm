
obj/user/fos_helloWorld:     file format elf32-i386


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
  800031:	e8 31 00 00 00       	call   800067 <libmain>
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
  80003b:	83 ec 08             	sub    $0x8,%esp
	extern unsigned char * etext;
	//cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D %d\n",4);
	atomic_cprintf("HELLO WORLD , FOS IS SAYING HI :D:D:D \n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 20 1b 80 00       	push   $0x801b20
  800046:	e8 62 02 00 00       	call   8002ad <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	atomic_cprintf("end of code = %x\n",etext);
  80004e:	a1 01 1b 80 00       	mov    0x801b01,%eax
  800053:	83 ec 08             	sub    $0x8,%esp
  800056:	50                   	push   %eax
  800057:	68 48 1b 80 00       	push   $0x801b48
  80005c:	e8 4c 02 00 00       	call   8002ad <atomic_cprintf>
  800061:	83 c4 10             	add    $0x10,%esp
}
  800064:	90                   	nop
  800065:	c9                   	leave  
  800066:	c3                   	ret    

00800067 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800067:	55                   	push   %ebp
  800068:	89 e5                	mov    %esp,%ebp
  80006a:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80006d:	e8 91 12 00 00       	call   801303 <sys_getenvindex>
  800072:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800078:	89 d0                	mov    %edx,%eax
  80007a:	c1 e0 02             	shl    $0x2,%eax
  80007d:	01 d0                	add    %edx,%eax
  80007f:	c1 e0 03             	shl    $0x3,%eax
  800082:	01 d0                	add    %edx,%eax
  800084:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80008b:	01 d0                	add    %edx,%eax
  80008d:	c1 e0 02             	shl    $0x2,%eax
  800090:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800095:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80009a:	a1 08 30 80 00       	mov    0x803008,%eax
  80009f:	8a 40 20             	mov    0x20(%eax),%al
  8000a2:	84 c0                	test   %al,%al
  8000a4:	74 0d                	je     8000b3 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000a6:	a1 08 30 80 00       	mov    0x803008,%eax
  8000ab:	83 c0 20             	add    $0x20,%eax
  8000ae:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b7:	7e 0a                	jle    8000c3 <libmain+0x5c>
		binaryname = argv[0];
  8000b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000bc:	8b 00                	mov    (%eax),%eax
  8000be:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000c3:	83 ec 08             	sub    $0x8,%esp
  8000c6:	ff 75 0c             	pushl  0xc(%ebp)
  8000c9:	ff 75 08             	pushl  0x8(%ebp)
  8000cc:	e8 67 ff ff ff       	call   800038 <_main>
  8000d1:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000d4:	a1 00 30 80 00       	mov    0x803000,%eax
  8000d9:	85 c0                	test   %eax,%eax
  8000db:	0f 84 9f 00 00 00    	je     800180 <libmain+0x119>
	{
		sys_lock_cons();
  8000e1:	e8 a1 0f 00 00       	call   801087 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 74 1b 80 00       	push   $0x801b74
  8000ee:	e8 8d 01 00 00       	call   800280 <cprintf>
  8000f3:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000f6:	a1 08 30 80 00       	mov    0x803008,%eax
  8000fb:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800101:	a1 08 30 80 00       	mov    0x803008,%eax
  800106:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	52                   	push   %edx
  800110:	50                   	push   %eax
  800111:	68 9c 1b 80 00       	push   $0x801b9c
  800116:	e8 65 01 00 00       	call   800280 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80011e:	a1 08 30 80 00       	mov    0x803008,%eax
  800123:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800129:	a1 08 30 80 00       	mov    0x803008,%eax
  80012e:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800134:	a1 08 30 80 00       	mov    0x803008,%eax
  800139:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80013f:	51                   	push   %ecx
  800140:	52                   	push   %edx
  800141:	50                   	push   %eax
  800142:	68 c4 1b 80 00       	push   $0x801bc4
  800147:	e8 34 01 00 00       	call   800280 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80014f:	a1 08 30 80 00       	mov    0x803008,%eax
  800154:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  80015a:	83 ec 08             	sub    $0x8,%esp
  80015d:	50                   	push   %eax
  80015e:	68 1c 1c 80 00       	push   $0x801c1c
  800163:	e8 18 01 00 00       	call   800280 <cprintf>
  800168:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  80016b:	83 ec 0c             	sub    $0xc,%esp
  80016e:	68 74 1b 80 00       	push   $0x801b74
  800173:	e8 08 01 00 00       	call   800280 <cprintf>
  800178:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  80017b:	e8 21 0f 00 00       	call   8010a1 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800180:	e8 19 00 00 00       	call   80019e <exit>
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80018e:	83 ec 0c             	sub    $0xc,%esp
  800191:	6a 00                	push   $0x0
  800193:	e8 37 11 00 00       	call   8012cf <sys_destroy_env>
  800198:	83 c4 10             	add    $0x10,%esp
}
  80019b:	90                   	nop
  80019c:	c9                   	leave  
  80019d:	c3                   	ret    

0080019e <exit>:

void
exit(void)
{
  80019e:	55                   	push   %ebp
  80019f:	89 e5                	mov    %esp,%ebp
  8001a1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001a4:	e8 8c 11 00 00       	call   801335 <sys_exit_env>
}
  8001a9:	90                   	nop
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b5:	8b 00                	mov    (%eax),%eax
  8001b7:	8d 48 01             	lea    0x1(%eax),%ecx
  8001ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bd:	89 0a                	mov    %ecx,(%edx)
  8001bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c2:	88 d1                	mov    %dl,%cl
  8001c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001c7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ce:	8b 00                	mov    (%eax),%eax
  8001d0:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d5:	75 2c                	jne    800203 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001d7:	a0 0c 30 80 00       	mov    0x80300c,%al
  8001dc:	0f b6 c0             	movzbl %al,%eax
  8001df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e2:	8b 12                	mov    (%edx),%edx
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001e9:	83 c2 08             	add    $0x8,%edx
  8001ec:	83 ec 04             	sub    $0x4,%esp
  8001ef:	50                   	push   %eax
  8001f0:	51                   	push   %ecx
  8001f1:	52                   	push   %edx
  8001f2:	e8 4e 0e 00 00       	call   801045 <sys_cputs>
  8001f7:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 40 04             	mov    0x4(%eax),%eax
  800209:	8d 50 01             	lea    0x1(%eax),%edx
  80020c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800212:	90                   	nop
  800213:	c9                   	leave  
  800214:	c3                   	ret    

00800215 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80021e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800225:	00 00 00 
	b.cnt = 0;
  800228:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80023e:	50                   	push   %eax
  80023f:	68 ac 01 80 00       	push   $0x8001ac
  800244:	e8 11 02 00 00       	call   80045a <vprintfmt>
  800249:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80024c:	a0 0c 30 80 00       	mov    0x80300c,%al
  800251:	0f b6 c0             	movzbl %al,%eax
  800254:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80025a:	83 ec 04             	sub    $0x4,%esp
  80025d:	50                   	push   %eax
  80025e:	52                   	push   %edx
  80025f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800265:	83 c0 08             	add    $0x8,%eax
  800268:	50                   	push   %eax
  800269:	e8 d7 0d 00 00       	call   801045 <sys_cputs>
  80026e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800271:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800278:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80027e:	c9                   	leave  
  80027f:	c3                   	ret    

00800280 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800286:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  80028d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800290:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800293:	8b 45 08             	mov    0x8(%ebp),%eax
  800296:	83 ec 08             	sub    $0x8,%esp
  800299:	ff 75 f4             	pushl  -0xc(%ebp)
  80029c:	50                   	push   %eax
  80029d:	e8 73 ff ff ff       	call   800215 <vcprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002b3:	e8 cf 0d 00 00       	call   801087 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002b8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 48 ff ff ff       	call   800215 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002d3:	e8 c9 0d 00 00       	call   8010a1 <sys_unlock_cons>
	return cnt;
  8002d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002db:	c9                   	leave  
  8002dc:	c3                   	ret    

008002dd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	53                   	push   %ebx
  8002e1:	83 ec 14             	sub    $0x14,%esp
  8002e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8002f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8002f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002fb:	77 55                	ja     800352 <printnum+0x75>
  8002fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800300:	72 05                	jb     800307 <printnum+0x2a>
  800302:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800305:	77 4b                	ja     800352 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800307:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80030a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80030d:	8b 45 18             	mov    0x18(%ebp),%eax
  800310:	ba 00 00 00 00       	mov    $0x0,%edx
  800315:	52                   	push   %edx
  800316:	50                   	push   %eax
  800317:	ff 75 f4             	pushl  -0xc(%ebp)
  80031a:	ff 75 f0             	pushl  -0x10(%ebp)
  80031d:	e8 7e 15 00 00       	call   8018a0 <__udivdi3>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 20             	pushl  0x20(%ebp)
  80032b:	53                   	push   %ebx
  80032c:	ff 75 18             	pushl  0x18(%ebp)
  80032f:	52                   	push   %edx
  800330:	50                   	push   %eax
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 08             	pushl  0x8(%ebp)
  800337:	e8 a1 ff ff ff       	call   8002dd <printnum>
  80033c:	83 c4 20             	add    $0x20,%esp
  80033f:	eb 1a                	jmp    80035b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	ff 75 0c             	pushl  0xc(%ebp)
  800347:	ff 75 20             	pushl  0x20(%ebp)
  80034a:	8b 45 08             	mov    0x8(%ebp),%eax
  80034d:	ff d0                	call   *%eax
  80034f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800352:	ff 4d 1c             	decl   0x1c(%ebp)
  800355:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800359:	7f e6                	jg     800341 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80035b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80035e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800369:	53                   	push   %ebx
  80036a:	51                   	push   %ecx
  80036b:	52                   	push   %edx
  80036c:	50                   	push   %eax
  80036d:	e8 3e 16 00 00       	call   8019b0 <__umoddi3>
  800372:	83 c4 10             	add    $0x10,%esp
  800375:	05 54 1e 80 00       	add    $0x801e54,%eax
  80037a:	8a 00                	mov    (%eax),%al
  80037c:	0f be c0             	movsbl %al,%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 0c             	pushl  0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	ff d0                	call   *%eax
  80038b:	83 c4 10             	add    $0x10,%esp
}
  80038e:	90                   	nop
  80038f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800392:	c9                   	leave  
  800393:	c3                   	ret    

00800394 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800394:	55                   	push   %ebp
  800395:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800397:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80039b:	7e 1c                	jle    8003b9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80039d:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a0:	8b 00                	mov    (%eax),%eax
  8003a2:	8d 50 08             	lea    0x8(%eax),%edx
  8003a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a8:	89 10                	mov    %edx,(%eax)
  8003aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	83 e8 08             	sub    $0x8,%eax
  8003b2:	8b 50 04             	mov    0x4(%eax),%edx
  8003b5:	8b 00                	mov    (%eax),%eax
  8003b7:	eb 40                	jmp    8003f9 <getuint+0x65>
	else if (lflag)
  8003b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003bd:	74 1e                	je     8003dd <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 50 04             	lea    0x4(%eax),%edx
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	89 10                	mov    %edx,(%eax)
  8003cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cf:	8b 00                	mov    (%eax),%eax
  8003d1:	83 e8 04             	sub    $0x4,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8003db:	eb 1c                	jmp    8003f9 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	8d 50 04             	lea    0x4(%eax),%edx
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	89 10                	mov    %edx,(%eax)
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	8b 00                	mov    (%eax),%eax
  8003ef:	83 e8 04             	sub    $0x4,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f9:	5d                   	pop    %ebp
  8003fa:	c3                   	ret    

008003fb <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003fb:	55                   	push   %ebp
  8003fc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003fe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800402:	7e 1c                	jle    800420 <getint+0x25>
		return va_arg(*ap, long long);
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	8b 00                	mov    (%eax),%eax
  800409:	8d 50 08             	lea    0x8(%eax),%edx
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	89 10                	mov    %edx,(%eax)
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	83 e8 08             	sub    $0x8,%eax
  800419:	8b 50 04             	mov    0x4(%eax),%edx
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	eb 38                	jmp    800458 <getint+0x5d>
	else if (lflag)
  800420:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800424:	74 1a                	je     800440 <getint+0x45>
		return va_arg(*ap, long);
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	8d 50 04             	lea    0x4(%eax),%edx
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	89 10                	mov    %edx,(%eax)
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	83 e8 04             	sub    $0x4,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	99                   	cltd   
  80043e:	eb 18                	jmp    800458 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	8d 50 04             	lea    0x4(%eax),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	89 10                	mov    %edx,(%eax)
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	83 e8 04             	sub    $0x4,%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	99                   	cltd   
}
  800458:	5d                   	pop    %ebp
  800459:	c3                   	ret    

0080045a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	56                   	push   %esi
  80045e:	53                   	push   %ebx
  80045f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800462:	eb 17                	jmp    80047b <vprintfmt+0x21>
			if (ch == '\0')
  800464:	85 db                	test   %ebx,%ebx
  800466:	0f 84 c1 03 00 00    	je     80082d <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  80046c:	83 ec 08             	sub    $0x8,%esp
  80046f:	ff 75 0c             	pushl  0xc(%ebp)
  800472:	53                   	push   %ebx
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	ff d0                	call   *%eax
  800478:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80047b:	8b 45 10             	mov    0x10(%ebp),%eax
  80047e:	8d 50 01             	lea    0x1(%eax),%edx
  800481:	89 55 10             	mov    %edx,0x10(%ebp)
  800484:	8a 00                	mov    (%eax),%al
  800486:	0f b6 d8             	movzbl %al,%ebx
  800489:	83 fb 25             	cmp    $0x25,%ebx
  80048c:	75 d6                	jne    800464 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80048e:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800492:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800499:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004a7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b1:	8d 50 01             	lea    0x1(%eax),%edx
  8004b4:	89 55 10             	mov    %edx,0x10(%ebp)
  8004b7:	8a 00                	mov    (%eax),%al
  8004b9:	0f b6 d8             	movzbl %al,%ebx
  8004bc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004bf:	83 f8 5b             	cmp    $0x5b,%eax
  8004c2:	0f 87 3d 03 00 00    	ja     800805 <vprintfmt+0x3ab>
  8004c8:	8b 04 85 78 1e 80 00 	mov    0x801e78(,%eax,4),%eax
  8004cf:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004d1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004d5:	eb d7                	jmp    8004ae <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004d7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004db:	eb d1                	jmp    8004ae <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004dd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004e4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e7:	89 d0                	mov    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	01 c0                	add    %eax,%eax
  8004f0:	01 d8                	add    %ebx,%eax
  8004f2:	83 e8 30             	sub    $0x30,%eax
  8004f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fb:	8a 00                	mov    (%eax),%al
  8004fd:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800500:	83 fb 2f             	cmp    $0x2f,%ebx
  800503:	7e 3e                	jle    800543 <vprintfmt+0xe9>
  800505:	83 fb 39             	cmp    $0x39,%ebx
  800508:	7f 39                	jg     800543 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80050a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80050d:	eb d5                	jmp    8004e4 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80050f:	8b 45 14             	mov    0x14(%ebp),%eax
  800512:	83 c0 04             	add    $0x4,%eax
  800515:	89 45 14             	mov    %eax,0x14(%ebp)
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	83 e8 04             	sub    $0x4,%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800523:	eb 1f                	jmp    800544 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800525:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800529:	79 83                	jns    8004ae <vprintfmt+0x54>
				width = 0;
  80052b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800532:	e9 77 ff ff ff       	jmp    8004ae <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800537:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80053e:	e9 6b ff ff ff       	jmp    8004ae <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800543:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800548:	0f 89 60 ff ff ff    	jns    8004ae <vprintfmt+0x54>
				width = precision, precision = -1;
  80054e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800554:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80055b:	e9 4e ff ff ff       	jmp    8004ae <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800560:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800563:	e9 46 ff ff ff       	jmp    8004ae <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	83 c0 04             	add    $0x4,%eax
  80056e:	89 45 14             	mov    %eax,0x14(%ebp)
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	83 e8 04             	sub    $0x4,%eax
  800577:	8b 00                	mov    (%eax),%eax
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	ff 75 0c             	pushl  0xc(%ebp)
  80057f:	50                   	push   %eax
  800580:	8b 45 08             	mov    0x8(%ebp),%eax
  800583:	ff d0                	call   *%eax
  800585:	83 c4 10             	add    $0x10,%esp
			break;
  800588:	e9 9b 02 00 00       	jmp    800828 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	83 c0 04             	add    $0x4,%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	83 e8 04             	sub    $0x4,%eax
  80059c:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80059e:	85 db                	test   %ebx,%ebx
  8005a0:	79 02                	jns    8005a4 <vprintfmt+0x14a>
				err = -err;
  8005a2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005a4:	83 fb 64             	cmp    $0x64,%ebx
  8005a7:	7f 0b                	jg     8005b4 <vprintfmt+0x15a>
  8005a9:	8b 34 9d c0 1c 80 00 	mov    0x801cc0(,%ebx,4),%esi
  8005b0:	85 f6                	test   %esi,%esi
  8005b2:	75 19                	jne    8005cd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005b4:	53                   	push   %ebx
  8005b5:	68 65 1e 80 00       	push   $0x801e65
  8005ba:	ff 75 0c             	pushl  0xc(%ebp)
  8005bd:	ff 75 08             	pushl  0x8(%ebp)
  8005c0:	e8 70 02 00 00       	call   800835 <printfmt>
  8005c5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005c8:	e9 5b 02 00 00       	jmp    800828 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005cd:	56                   	push   %esi
  8005ce:	68 6e 1e 80 00       	push   $0x801e6e
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 08             	pushl  0x8(%ebp)
  8005d9:	e8 57 02 00 00       	call   800835 <printfmt>
  8005de:	83 c4 10             	add    $0x10,%esp
			break;
  8005e1:	e9 42 02 00 00       	jmp    800828 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	83 c0 04             	add    $0x4,%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	83 e8 04             	sub    $0x4,%eax
  8005f5:	8b 30                	mov    (%eax),%esi
  8005f7:	85 f6                	test   %esi,%esi
  8005f9:	75 05                	jne    800600 <vprintfmt+0x1a6>
				p = "(null)";
  8005fb:	be 71 1e 80 00       	mov    $0x801e71,%esi
			if (width > 0 && padc != '-')
  800600:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800604:	7e 6d                	jle    800673 <vprintfmt+0x219>
  800606:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80060a:	74 67                	je     800673 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80060c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	50                   	push   %eax
  800613:	56                   	push   %esi
  800614:	e8 1e 03 00 00       	call   800937 <strnlen>
  800619:	83 c4 10             	add    $0x10,%esp
  80061c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80061f:	eb 16                	jmp    800637 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800621:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800625:	83 ec 08             	sub    $0x8,%esp
  800628:	ff 75 0c             	pushl  0xc(%ebp)
  80062b:	50                   	push   %eax
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	ff d0                	call   *%eax
  800631:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	ff 4d e4             	decl   -0x1c(%ebp)
  800637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063b:	7f e4                	jg     800621 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80063d:	eb 34                	jmp    800673 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80063f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800643:	74 1c                	je     800661 <vprintfmt+0x207>
  800645:	83 fb 1f             	cmp    $0x1f,%ebx
  800648:	7e 05                	jle    80064f <vprintfmt+0x1f5>
  80064a:	83 fb 7e             	cmp    $0x7e,%ebx
  80064d:	7e 12                	jle    800661 <vprintfmt+0x207>
					putch('?', putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	ff 75 0c             	pushl  0xc(%ebp)
  800655:	6a 3f                	push   $0x3f
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	ff d0                	call   *%eax
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	eb 0f                	jmp    800670 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	ff 75 0c             	pushl  0xc(%ebp)
  800667:	53                   	push   %ebx
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	ff d0                	call   *%eax
  80066d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800670:	ff 4d e4             	decl   -0x1c(%ebp)
  800673:	89 f0                	mov    %esi,%eax
  800675:	8d 70 01             	lea    0x1(%eax),%esi
  800678:	8a 00                	mov    (%eax),%al
  80067a:	0f be d8             	movsbl %al,%ebx
  80067d:	85 db                	test   %ebx,%ebx
  80067f:	74 24                	je     8006a5 <vprintfmt+0x24b>
  800681:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800685:	78 b8                	js     80063f <vprintfmt+0x1e5>
  800687:	ff 4d e0             	decl   -0x20(%ebp)
  80068a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80068e:	79 af                	jns    80063f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800690:	eb 13                	jmp    8006a5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 0c             	pushl  0xc(%ebp)
  800698:	6a 20                	push   $0x20
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	ff d0                	call   *%eax
  80069f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006a2:	ff 4d e4             	decl   -0x1c(%ebp)
  8006a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006a9:	7f e7                	jg     800692 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006ab:	e9 78 01 00 00       	jmp    800828 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006b0:	83 ec 08             	sub    $0x8,%esp
  8006b3:	ff 75 e8             	pushl  -0x18(%ebp)
  8006b6:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b9:	50                   	push   %eax
  8006ba:	e8 3c fd ff ff       	call   8003fb <getint>
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006ce:	85 d2                	test   %edx,%edx
  8006d0:	79 23                	jns    8006f5 <vprintfmt+0x29b>
				putch('-', putdat);
  8006d2:	83 ec 08             	sub    $0x8,%esp
  8006d5:	ff 75 0c             	pushl  0xc(%ebp)
  8006d8:	6a 2d                	push   $0x2d
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	ff d0                	call   *%eax
  8006df:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006e8:	f7 d8                	neg    %eax
  8006ea:	83 d2 00             	adc    $0x0,%edx
  8006ed:	f7 da                	neg    %edx
  8006ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006f2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006f5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006fc:	e9 bc 00 00 00       	jmp    8007bd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	ff 75 e8             	pushl  -0x18(%ebp)
  800707:	8d 45 14             	lea    0x14(%ebp),%eax
  80070a:	50                   	push   %eax
  80070b:	e8 84 fc ff ff       	call   800394 <getuint>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800716:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800719:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800720:	e9 98 00 00 00       	jmp    8007bd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800725:	83 ec 08             	sub    $0x8,%esp
  800728:	ff 75 0c             	pushl  0xc(%ebp)
  80072b:	6a 58                	push   $0x58
  80072d:	8b 45 08             	mov    0x8(%ebp),%eax
  800730:	ff d0                	call   *%eax
  800732:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	ff 75 0c             	pushl  0xc(%ebp)
  80073b:	6a 58                	push   $0x58
  80073d:	8b 45 08             	mov    0x8(%ebp),%eax
  800740:	ff d0                	call   *%eax
  800742:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	ff 75 0c             	pushl  0xc(%ebp)
  80074b:	6a 58                	push   $0x58
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
			break;
  800755:	e9 ce 00 00 00       	jmp    800828 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  80075a:	83 ec 08             	sub    $0x8,%esp
  80075d:	ff 75 0c             	pushl  0xc(%ebp)
  800760:	6a 30                	push   $0x30
  800762:	8b 45 08             	mov    0x8(%ebp),%eax
  800765:	ff d0                	call   *%eax
  800767:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	ff 75 0c             	pushl  0xc(%ebp)
  800770:	6a 78                	push   $0x78
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	83 c0 04             	add    $0x4,%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	83 e8 04             	sub    $0x4,%eax
  800789:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80078b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800795:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80079c:	eb 1f                	jmp    8007bd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80079e:	83 ec 08             	sub    $0x8,%esp
  8007a1:	ff 75 e8             	pushl  -0x18(%ebp)
  8007a4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a7:	50                   	push   %eax
  8007a8:	e8 e7 fb ff ff       	call   800394 <getuint>
  8007ad:	83 c4 10             	add    $0x10,%esp
  8007b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007b6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007bd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007c4:	83 ec 04             	sub    $0x4,%esp
  8007c7:	52                   	push   %edx
  8007c8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007cb:	50                   	push   %eax
  8007cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8007cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	ff 75 08             	pushl  0x8(%ebp)
  8007d8:	e8 00 fb ff ff       	call   8002dd <printnum>
  8007dd:	83 c4 20             	add    $0x20,%esp
			break;
  8007e0:	eb 46                	jmp    800828 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	ff d0                	call   *%eax
  8007ee:	83 c4 10             	add    $0x10,%esp
			break;
  8007f1:	eb 35                	jmp    800828 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007f3:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8007fa:	eb 2c                	jmp    800828 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007fc:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800803:	eb 23                	jmp    800828 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	ff 75 0c             	pushl  0xc(%ebp)
  80080b:	6a 25                	push   $0x25
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	ff d0                	call   *%eax
  800812:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800815:	ff 4d 10             	decl   0x10(%ebp)
  800818:	eb 03                	jmp    80081d <vprintfmt+0x3c3>
  80081a:	ff 4d 10             	decl   0x10(%ebp)
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	48                   	dec    %eax
  800821:	8a 00                	mov    (%eax),%al
  800823:	3c 25                	cmp    $0x25,%al
  800825:	75 f3                	jne    80081a <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800827:	90                   	nop
		}
	}
  800828:	e9 35 fc ff ff       	jmp    800462 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80082d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80082e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800831:	5b                   	pop    %ebx
  800832:	5e                   	pop    %esi
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80083b:	8d 45 10             	lea    0x10(%ebp),%eax
  80083e:	83 c0 04             	add    $0x4,%eax
  800841:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800844:	8b 45 10             	mov    0x10(%ebp),%eax
  800847:	ff 75 f4             	pushl  -0xc(%ebp)
  80084a:	50                   	push   %eax
  80084b:	ff 75 0c             	pushl  0xc(%ebp)
  80084e:	ff 75 08             	pushl  0x8(%ebp)
  800851:	e8 04 fc ff ff       	call   80045a <vprintfmt>
  800856:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800859:	90                   	nop
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80085f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800862:	8b 40 08             	mov    0x8(%eax),%eax
  800865:	8d 50 01             	lea    0x1(%eax),%edx
  800868:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80086e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800871:	8b 10                	mov    (%eax),%edx
  800873:	8b 45 0c             	mov    0xc(%ebp),%eax
  800876:	8b 40 04             	mov    0x4(%eax),%eax
  800879:	39 c2                	cmp    %eax,%edx
  80087b:	73 12                	jae    80088f <sprintputch+0x33>
		*b->buf++ = ch;
  80087d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	8d 48 01             	lea    0x1(%eax),%ecx
  800885:	8b 55 0c             	mov    0xc(%ebp),%edx
  800888:	89 0a                	mov    %ecx,(%edx)
  80088a:	8b 55 08             	mov    0x8(%ebp),%edx
  80088d:	88 10                	mov    %dl,(%eax)
}
  80088f:	90                   	nop
  800890:	5d                   	pop    %ebp
  800891:	c3                   	ret    

00800892 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800892:	55                   	push   %ebp
  800893:	89 e5                	mov    %esp,%ebp
  800895:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800898:	8b 45 08             	mov    0x8(%ebp),%eax
  80089b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80089e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a7:	01 d0                	add    %edx,%eax
  8008a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008b7:	74 06                	je     8008bf <vsnprintf+0x2d>
  8008b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008bd:	7f 07                	jg     8008c6 <vsnprintf+0x34>
		return -E_INVAL;
  8008bf:	b8 03 00 00 00       	mov    $0x3,%eax
  8008c4:	eb 20                	jmp    8008e6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c6:	ff 75 14             	pushl  0x14(%ebp)
  8008c9:	ff 75 10             	pushl  0x10(%ebp)
  8008cc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008cf:	50                   	push   %eax
  8008d0:	68 5c 08 80 00       	push   $0x80085c
  8008d5:	e8 80 fb ff ff       	call   80045a <vprintfmt>
  8008da:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8008f1:	83 c0 04             	add    $0x4,%eax
  8008f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	50                   	push   %eax
  8008fe:	ff 75 0c             	pushl  0xc(%ebp)
  800901:	ff 75 08             	pushl  0x8(%ebp)
  800904:	e8 89 ff ff ff       	call   800892 <vsnprintf>
  800909:	83 c4 10             	add    $0x10,%esp
  80090c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80090f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800912:	c9                   	leave  
  800913:	c3                   	ret    

00800914 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80091a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800921:	eb 06                	jmp    800929 <strlen+0x15>
		n++;
  800923:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800926:	ff 45 08             	incl   0x8(%ebp)
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	8a 00                	mov    (%eax),%al
  80092e:	84 c0                	test   %al,%al
  800930:	75 f1                	jne    800923 <strlen+0xf>
		n++;
	return n;
  800932:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800935:	c9                   	leave  
  800936:	c3                   	ret    

00800937 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
  80093a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800944:	eb 09                	jmp    80094f <strnlen+0x18>
		n++;
  800946:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800949:	ff 45 08             	incl   0x8(%ebp)
  80094c:	ff 4d 0c             	decl   0xc(%ebp)
  80094f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800953:	74 09                	je     80095e <strnlen+0x27>
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	8a 00                	mov    (%eax),%al
  80095a:	84 c0                	test   %al,%al
  80095c:	75 e8                	jne    800946 <strnlen+0xf>
		n++;
	return n;
  80095e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800961:	c9                   	leave  
  800962:	c3                   	ret    

00800963 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80096f:	90                   	nop
  800970:	8b 45 08             	mov    0x8(%ebp),%eax
  800973:	8d 50 01             	lea    0x1(%eax),%edx
  800976:	89 55 08             	mov    %edx,0x8(%ebp)
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80097f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800982:	8a 12                	mov    (%edx),%dl
  800984:	88 10                	mov    %dl,(%eax)
  800986:	8a 00                	mov    (%eax),%al
  800988:	84 c0                	test   %al,%al
  80098a:	75 e4                	jne    800970 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80098c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80098f:	c9                   	leave  
  800990:	c3                   	ret    

00800991 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80099d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009a4:	eb 1f                	jmp    8009c5 <strncpy+0x34>
		*dst++ = *src;
  8009a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ac:	89 55 08             	mov    %edx,0x8(%ebp)
  8009af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b2:	8a 12                	mov    (%edx),%dl
  8009b4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	8a 00                	mov    (%eax),%al
  8009bb:	84 c0                	test   %al,%al
  8009bd:	74 03                	je     8009c2 <strncpy+0x31>
			src++;
  8009bf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009c2:	ff 45 fc             	incl   -0x4(%ebp)
  8009c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009c8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009cb:	72 d9                	jb     8009a6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e2:	74 30                	je     800a14 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009e4:	eb 16                	jmp    8009fc <strlcpy+0x2a>
			*dst++ = *src++;
  8009e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e9:	8d 50 01             	lea    0x1(%eax),%edx
  8009ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009f5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009f8:	8a 12                	mov    (%edx),%dl
  8009fa:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009fc:	ff 4d 10             	decl   0x10(%ebp)
  8009ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a03:	74 09                	je     800a0e <strlcpy+0x3c>
  800a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a08:	8a 00                	mov    (%eax),%al
  800a0a:	84 c0                	test   %al,%al
  800a0c:	75 d8                	jne    8009e6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a14:	8b 55 08             	mov    0x8(%ebp),%edx
  800a17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a1a:	29 c2                	sub    %eax,%edx
  800a1c:	89 d0                	mov    %edx,%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a23:	eb 06                	jmp    800a2b <strcmp+0xb>
		p++, q++;
  800a25:	ff 45 08             	incl   0x8(%ebp)
  800a28:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8a 00                	mov    (%eax),%al
  800a30:	84 c0                	test   %al,%al
  800a32:	74 0e                	je     800a42 <strcmp+0x22>
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	8a 10                	mov    (%eax),%dl
  800a39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	38 c2                	cmp    %al,%dl
  800a40:	74 e3                	je     800a25 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8a 00                	mov    (%eax),%al
  800a47:	0f b6 d0             	movzbl %al,%edx
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	8a 00                	mov    (%eax),%al
  800a4f:	0f b6 c0             	movzbl %al,%eax
  800a52:	29 c2                	sub    %eax,%edx
  800a54:	89 d0                	mov    %edx,%eax
}
  800a56:	5d                   	pop    %ebp
  800a57:	c3                   	ret    

00800a58 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a5b:	eb 09                	jmp    800a66 <strncmp+0xe>
		n--, p++, q++;
  800a5d:	ff 4d 10             	decl   0x10(%ebp)
  800a60:	ff 45 08             	incl   0x8(%ebp)
  800a63:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a66:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a6a:	74 17                	je     800a83 <strncmp+0x2b>
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	74 0e                	je     800a83 <strncmp+0x2b>
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	8a 10                	mov    (%eax),%dl
  800a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	38 c2                	cmp    %al,%dl
  800a81:	74 da                	je     800a5d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a87:	75 07                	jne    800a90 <strncmp+0x38>
		return 0;
  800a89:	b8 00 00 00 00       	mov    $0x0,%eax
  800a8e:	eb 14                	jmp    800aa4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8a 00                	mov    (%eax),%al
  800a95:	0f b6 d0             	movzbl %al,%edx
  800a98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9b:	8a 00                	mov    (%eax),%al
  800a9d:	0f b6 c0             	movzbl %al,%eax
  800aa0:	29 c2                	sub    %eax,%edx
  800aa2:	89 d0                	mov    %edx,%eax
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	83 ec 04             	sub    $0x4,%esp
  800aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ab2:	eb 12                	jmp    800ac6 <strchr+0x20>
		if (*s == c)
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800abc:	75 05                	jne    800ac3 <strchr+0x1d>
			return (char *) s;
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	eb 11                	jmp    800ad4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ac3:	ff 45 08             	incl   0x8(%ebp)
  800ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac9:	8a 00                	mov    (%eax),%al
  800acb:	84 c0                	test   %al,%al
  800acd:	75 e5                	jne    800ab4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800acf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad4:	c9                   	leave  
  800ad5:	c3                   	ret    

00800ad6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ae2:	eb 0d                	jmp    800af1 <strfind+0x1b>
		if (*s == c)
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aec:	74 0e                	je     800afc <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 ea                	jne    800ae4 <strfind+0xe>
  800afa:	eb 01                	jmp    800afd <strfind+0x27>
		if (*s == c)
			break;
  800afc:	90                   	nop
	return (char *) s;
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b11:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b14:	eb 0e                	jmp    800b24 <memset+0x22>
		*p++ = c;
  800b16:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b19:	8d 50 01             	lea    0x1(%eax),%edx
  800b1c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b24:	ff 4d f8             	decl   -0x8(%ebp)
  800b27:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b2b:	79 e9                	jns    800b16 <memset+0x14>
		*p++ = c;

	return v;
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b44:	eb 16                	jmp    800b5c <memcpy+0x2a>
		*d++ = *s++;
  800b46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b52:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b55:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b58:	8a 12                	mov    (%edx),%dl
  800b5a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b5f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b62:	89 55 10             	mov    %edx,0x10(%ebp)
  800b65:	85 c0                	test   %eax,%eax
  800b67:	75 dd                	jne    800b46 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b6e:	55                   	push   %ebp
  800b6f:	89 e5                	mov    %esp,%ebp
  800b71:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b86:	73 50                	jae    800bd8 <memmove+0x6a>
  800b88:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8e:	01 d0                	add    %edx,%eax
  800b90:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b93:	76 43                	jbe    800bd8 <memmove+0x6a>
		s += n;
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ba1:	eb 10                	jmp    800bb3 <memmove+0x45>
			*--d = *--s;
  800ba3:	ff 4d f8             	decl   -0x8(%ebp)
  800ba6:	ff 4d fc             	decl   -0x4(%ebp)
  800ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bac:	8a 10                	mov    (%eax),%dl
  800bae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bb1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bbc:	85 c0                	test   %eax,%eax
  800bbe:	75 e3                	jne    800ba3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bc0:	eb 23                	jmp    800be5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bc5:	8d 50 01             	lea    0x1(%eax),%edx
  800bc8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bcb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bce:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bd1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bd4:	8a 12                	mov    (%edx),%dl
  800bd6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bde:	89 55 10             	mov    %edx,0x10(%ebp)
  800be1:	85 c0                	test   %eax,%eax
  800be3:	75 dd                	jne    800bc2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be8:	c9                   	leave  
  800be9:	c3                   	ret    

00800bea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800bfc:	eb 2a                	jmp    800c28 <memcmp+0x3e>
		if (*s1 != *s2)
  800bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c01:	8a 10                	mov    (%eax),%dl
  800c03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c06:	8a 00                	mov    (%eax),%al
  800c08:	38 c2                	cmp    %al,%dl
  800c0a:	74 16                	je     800c22 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c0f:	8a 00                	mov    (%eax),%al
  800c11:	0f b6 d0             	movzbl %al,%edx
  800c14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c17:	8a 00                	mov    (%eax),%al
  800c19:	0f b6 c0             	movzbl %al,%eax
  800c1c:	29 c2                	sub    %eax,%edx
  800c1e:	89 d0                	mov    %edx,%eax
  800c20:	eb 18                	jmp    800c3a <memcmp+0x50>
		s1++, s2++;
  800c22:	ff 45 fc             	incl   -0x4(%ebp)
  800c25:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c28:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c2e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c31:	85 c0                	test   %eax,%eax
  800c33:	75 c9                	jne    800bfe <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c42:	8b 55 08             	mov    0x8(%ebp),%edx
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	01 d0                	add    %edx,%eax
  800c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c4d:	eb 15                	jmp    800c64 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	0f b6 d0             	movzbl %al,%edx
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	0f b6 c0             	movzbl %al,%eax
  800c5d:	39 c2                	cmp    %eax,%edx
  800c5f:	74 0d                	je     800c6e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c61:	ff 45 08             	incl   0x8(%ebp)
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c6a:	72 e3                	jb     800c4f <memfind+0x13>
  800c6c:	eb 01                	jmp    800c6f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c6e:	90                   	nop
	return (void *) s;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c7a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c81:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c88:	eb 03                	jmp    800c8d <strtol+0x19>
		s++;
  800c8a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8a 00                	mov    (%eax),%al
  800c92:	3c 20                	cmp    $0x20,%al
  800c94:	74 f4                	je     800c8a <strtol+0x16>
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8a 00                	mov    (%eax),%al
  800c9b:	3c 09                	cmp    $0x9,%al
  800c9d:	74 eb                	je     800c8a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	8a 00                	mov    (%eax),%al
  800ca4:	3c 2b                	cmp    $0x2b,%al
  800ca6:	75 05                	jne    800cad <strtol+0x39>
		s++;
  800ca8:	ff 45 08             	incl   0x8(%ebp)
  800cab:	eb 13                	jmp    800cc0 <strtol+0x4c>
	else if (*s == '-')
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	8a 00                	mov    (%eax),%al
  800cb2:	3c 2d                	cmp    $0x2d,%al
  800cb4:	75 0a                	jne    800cc0 <strtol+0x4c>
		s++, neg = 1;
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc4:	74 06                	je     800ccc <strtol+0x58>
  800cc6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cca:	75 20                	jne    800cec <strtol+0x78>
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	3c 30                	cmp    $0x30,%al
  800cd3:	75 17                	jne    800cec <strtol+0x78>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	40                   	inc    %eax
  800cd9:	8a 00                	mov    (%eax),%al
  800cdb:	3c 78                	cmp    $0x78,%al
  800cdd:	75 0d                	jne    800cec <strtol+0x78>
		s += 2, base = 16;
  800cdf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ce3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cea:	eb 28                	jmp    800d14 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf0:	75 15                	jne    800d07 <strtol+0x93>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	3c 30                	cmp    $0x30,%al
  800cf9:	75 0c                	jne    800d07 <strtol+0x93>
		s++, base = 8;
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d05:	eb 0d                	jmp    800d14 <strtol+0xa0>
	else if (base == 0)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	75 07                	jne    800d14 <strtol+0xa0>
		base = 10;
  800d0d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	3c 2f                	cmp    $0x2f,%al
  800d1b:	7e 19                	jle    800d36 <strtol+0xc2>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8a 00                	mov    (%eax),%al
  800d22:	3c 39                	cmp    $0x39,%al
  800d24:	7f 10                	jg     800d36 <strtol+0xc2>
			dig = *s - '0';
  800d26:	8b 45 08             	mov    0x8(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	0f be c0             	movsbl %al,%eax
  800d2e:	83 e8 30             	sub    $0x30,%eax
  800d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d34:	eb 42                	jmp    800d78 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	3c 60                	cmp    $0x60,%al
  800d3d:	7e 19                	jle    800d58 <strtol+0xe4>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	3c 7a                	cmp    $0x7a,%al
  800d46:	7f 10                	jg     800d58 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d48:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4b:	8a 00                	mov    (%eax),%al
  800d4d:	0f be c0             	movsbl %al,%eax
  800d50:	83 e8 57             	sub    $0x57,%eax
  800d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d56:	eb 20                	jmp    800d78 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3c 40                	cmp    $0x40,%al
  800d5f:	7e 39                	jle    800d9a <strtol+0x126>
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3c 5a                	cmp    $0x5a,%al
  800d68:	7f 30                	jg     800d9a <strtol+0x126>
			dig = *s - 'A' + 10;
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	0f be c0             	movsbl %al,%eax
  800d72:	83 e8 37             	sub    $0x37,%eax
  800d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d7b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7e:	7d 19                	jge    800d99 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d80:	ff 45 08             	incl   0x8(%ebp)
  800d83:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d86:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d8a:	89 c2                	mov    %eax,%edx
  800d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d8f:	01 d0                	add    %edx,%eax
  800d91:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d94:	e9 7b ff ff ff       	jmp    800d14 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d99:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d9e:	74 08                	je     800da8 <strtol+0x134>
		*endptr = (char *) s;
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
  800da6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800da8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800dac:	74 07                	je     800db5 <strtol+0x141>
  800dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800db1:	f7 d8                	neg    %eax
  800db3:	eb 03                	jmp    800db8 <strtol+0x144>
  800db5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800db8:	c9                   	leave  
  800db9:	c3                   	ret    

00800dba <ltostr>:

void
ltostr(long value, char *str)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dc0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800dc7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dd2:	79 13                	jns    800de7 <ltostr+0x2d>
	{
		neg = 1;
  800dd4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dde:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800de1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800de4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800def:	99                   	cltd   
  800df0:	f7 f9                	idiv   %ecx
  800df2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800df5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dfe:	89 c2                	mov    %eax,%edx
  800e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e03:	01 d0                	add    %edx,%eax
  800e05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e08:	83 c2 30             	add    $0x30,%edx
  800e0b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e10:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e15:	f7 e9                	imul   %ecx
  800e17:	c1 fa 02             	sar    $0x2,%edx
  800e1a:	89 c8                	mov    %ecx,%eax
  800e1c:	c1 f8 1f             	sar    $0x1f,%eax
  800e1f:	29 c2                	sub    %eax,%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e2a:	75 bb                	jne    800de7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e36:	48                   	dec    %eax
  800e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e3a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e3e:	74 3d                	je     800e7d <ltostr+0xc3>
		start = 1 ;
  800e40:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e47:	eb 34                	jmp    800e7d <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	01 d0                	add    %edx,%eax
  800e51:	8a 00                	mov    (%eax),%al
  800e53:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5c:	01 c2                	add    %eax,%edx
  800e5e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	01 c8                	add    %ecx,%eax
  800e66:	8a 00                	mov    (%eax),%al
  800e68:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	01 c2                	add    %eax,%edx
  800e72:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e75:	88 02                	mov    %al,(%edx)
		start++ ;
  800e77:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e7a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e80:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e83:	7c c4                	jl     800e49 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e85:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	01 d0                	add    %edx,%eax
  800e8d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e90:	90                   	nop
  800e91:	c9                   	leave  
  800e92:	c3                   	ret    

00800e93 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e99:	ff 75 08             	pushl  0x8(%ebp)
  800e9c:	e8 73 fa ff ff       	call   800914 <strlen>
  800ea1:	83 c4 04             	add    $0x4,%esp
  800ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ea7:	ff 75 0c             	pushl  0xc(%ebp)
  800eaa:	e8 65 fa ff ff       	call   800914 <strlen>
  800eaf:	83 c4 04             	add    $0x4,%esp
  800eb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800eb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ebc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ec3:	eb 17                	jmp    800edc <strcconcat+0x49>
		final[s] = str1[s] ;
  800ec5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	01 c2                	add    %eax,%edx
  800ecd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	01 c8                	add    %ecx,%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ed9:	ff 45 fc             	incl   -0x4(%ebp)
  800edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ee2:	7c e1                	jl     800ec5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ee4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800eeb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ef2:	eb 1f                	jmp    800f13 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef7:	8d 50 01             	lea    0x1(%eax),%edx
  800efa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800efd:	89 c2                	mov    %eax,%edx
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	01 c2                	add    %eax,%edx
  800f04:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0a:	01 c8                	add    %ecx,%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f10:	ff 45 f8             	incl   -0x8(%ebp)
  800f13:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f16:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f19:	7c d9                	jl     800ef4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f21:	01 d0                	add    %edx,%eax
  800f23:	c6 00 00             	movb   $0x0,(%eax)
}
  800f26:	90                   	nop
  800f27:	c9                   	leave  
  800f28:	c3                   	ret    

00800f29 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f35:	8b 45 14             	mov    0x14(%ebp),%eax
  800f38:	8b 00                	mov    (%eax),%eax
  800f3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f41:	8b 45 10             	mov    0x10(%ebp),%eax
  800f44:	01 d0                	add    %edx,%eax
  800f46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f4c:	eb 0c                	jmp    800f5a <strsplit+0x31>
			*string++ = 0;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 08             	mov    %edx,0x8(%ebp)
  800f57:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	84 c0                	test   %al,%al
  800f61:	74 18                	je     800f7b <strsplit+0x52>
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f be c0             	movsbl %al,%eax
  800f6b:	50                   	push   %eax
  800f6c:	ff 75 0c             	pushl  0xc(%ebp)
  800f6f:	e8 32 fb ff ff       	call   800aa6 <strchr>
  800f74:	83 c4 08             	add    $0x8,%esp
  800f77:	85 c0                	test   %eax,%eax
  800f79:	75 d3                	jne    800f4e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8a 00                	mov    (%eax),%al
  800f80:	84 c0                	test   %al,%al
  800f82:	74 5a                	je     800fde <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f84:	8b 45 14             	mov    0x14(%ebp),%eax
  800f87:	8b 00                	mov    (%eax),%eax
  800f89:	83 f8 0f             	cmp    $0xf,%eax
  800f8c:	75 07                	jne    800f95 <strsplit+0x6c>
		{
			return 0;
  800f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f93:	eb 66                	jmp    800ffb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f95:	8b 45 14             	mov    0x14(%ebp),%eax
  800f98:	8b 00                	mov    (%eax),%eax
  800f9a:	8d 48 01             	lea    0x1(%eax),%ecx
  800f9d:	8b 55 14             	mov    0x14(%ebp),%edx
  800fa0:	89 0a                	mov    %ecx,(%edx)
  800fa2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 c2                	add    %eax,%edx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb3:	eb 03                	jmp    800fb8 <strsplit+0x8f>
			string++;
  800fb5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	84 c0                	test   %al,%al
  800fbf:	74 8b                	je     800f4c <strsplit+0x23>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	0f be c0             	movsbl %al,%eax
  800fc9:	50                   	push   %eax
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	e8 d4 fa ff ff       	call   800aa6 <strchr>
  800fd2:	83 c4 08             	add    $0x8,%esp
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	74 dc                	je     800fb5 <strsplit+0x8c>
			string++;
	}
  800fd9:	e9 6e ff ff ff       	jmp    800f4c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fde:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe2:	8b 00                	mov    (%eax),%eax
  800fe4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800feb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800ff6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800ffb:	c9                   	leave  
  800ffc:	c3                   	ret    

00800ffd <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 e8 1f 80 00       	push   $0x801fe8
  80100b:	68 3f 01 00 00       	push   $0x13f
  801010:	68 0a 20 80 00       	push   $0x80200a
  801015:	e8 9d 06 00 00       	call   8016b7 <_panic>

0080101a <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8b 55 0c             	mov    0xc(%ebp),%edx
  801029:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80102c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80102f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801032:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801035:	cd 30                	int    $0x30
  801037:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  80103a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80103d:	83 c4 10             	add    $0x10,%esp
  801040:	5b                   	pop    %ebx
  801041:	5e                   	pop    %esi
  801042:	5f                   	pop    %edi
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 04             	sub    $0x4,%esp
  80104b:	8b 45 10             	mov    0x10(%ebp),%eax
  80104e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801051:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	6a 00                	push   $0x0
  80105a:	6a 00                	push   $0x0
  80105c:	52                   	push   %edx
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	50                   	push   %eax
  801061:	6a 00                	push   $0x0
  801063:	e8 b2 ff ff ff       	call   80101a <syscall>
  801068:	83 c4 18             	add    $0x18,%esp
}
  80106b:	90                   	nop
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <sys_cgetc>:

int sys_cgetc(void) {
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801071:	6a 00                	push   $0x0
  801073:	6a 00                	push   $0x0
  801075:	6a 00                	push   $0x0
  801077:	6a 00                	push   $0x0
  801079:	6a 00                	push   $0x0
  80107b:	6a 02                	push   $0x2
  80107d:	e8 98 ff ff ff       	call   80101a <syscall>
  801082:	83 c4 18             	add    $0x18,%esp
}
  801085:	c9                   	leave  
  801086:	c3                   	ret    

00801087 <sys_lock_cons>:

void sys_lock_cons(void) {
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80108a:	6a 00                	push   $0x0
  80108c:	6a 00                	push   $0x0
  80108e:	6a 00                	push   $0x0
  801090:	6a 00                	push   $0x0
  801092:	6a 00                	push   $0x0
  801094:	6a 03                	push   $0x3
  801096:	e8 7f ff ff ff       	call   80101a <syscall>
  80109b:	83 c4 18             	add    $0x18,%esp
}
  80109e:	90                   	nop
  80109f:	c9                   	leave  
  8010a0:	c3                   	ret    

008010a1 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010a4:	6a 00                	push   $0x0
  8010a6:	6a 00                	push   $0x0
  8010a8:	6a 00                	push   $0x0
  8010aa:	6a 00                	push   $0x0
  8010ac:	6a 00                	push   $0x0
  8010ae:	6a 04                	push   $0x4
  8010b0:	e8 65 ff ff ff       	call   80101a <syscall>
  8010b5:	83 c4 18             	add    $0x18,%esp
}
  8010b8:	90                   	nop
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8010be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	6a 00                	push   $0x0
  8010c6:	6a 00                	push   $0x0
  8010c8:	6a 00                	push   $0x0
  8010ca:	52                   	push   %edx
  8010cb:	50                   	push   %eax
  8010cc:	6a 08                	push   $0x8
  8010ce:	e8 47 ff ff ff       	call   80101a <syscall>
  8010d3:	83 c4 18             	add    $0x18,%esp
}
  8010d6:	c9                   	leave  
  8010d7:	c3                   	ret    

008010d8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	56                   	push   %esi
  8010dc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8010dd:	8b 75 18             	mov    0x18(%ebp),%esi
  8010e0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	56                   	push   %esi
  8010ed:	53                   	push   %ebx
  8010ee:	51                   	push   %ecx
  8010ef:	52                   	push   %edx
  8010f0:	50                   	push   %eax
  8010f1:	6a 09                	push   $0x9
  8010f3:	e8 22 ff ff ff       	call   80101a <syscall>
  8010f8:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8010fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010fe:	5b                   	pop    %ebx
  8010ff:	5e                   	pop    %esi
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    

00801102 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801105:	8b 55 0c             	mov    0xc(%ebp),%edx
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	6a 00                	push   $0x0
  80110d:	6a 00                	push   $0x0
  80110f:	6a 00                	push   $0x0
  801111:	52                   	push   %edx
  801112:	50                   	push   %eax
  801113:	6a 0a                	push   $0xa
  801115:	e8 00 ff ff ff       	call   80101a <syscall>
  80111a:	83 c4 18             	add    $0x18,%esp
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 00                	push   $0x0
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	6a 0b                	push   $0xb
  801130:	e8 e5 fe ff ff       	call   80101a <syscall>
  801135:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801138:	c9                   	leave  
  801139:	c3                   	ret    

0080113a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80113d:	6a 00                	push   $0x0
  80113f:	6a 00                	push   $0x0
  801141:	6a 00                	push   $0x0
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	6a 0c                	push   $0xc
  801149:	e8 cc fe ff ff       	call   80101a <syscall>
  80114e:	83 c4 18             	add    $0x18,%esp
}
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801156:	6a 00                	push   $0x0
  801158:	6a 00                	push   $0x0
  80115a:	6a 00                	push   $0x0
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 0d                	push   $0xd
  801162:	e8 b3 fe ff ff       	call   80101a <syscall>
  801167:	83 c4 18             	add    $0x18,%esp
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80116f:	6a 00                	push   $0x0
  801171:	6a 00                	push   $0x0
  801173:	6a 00                	push   $0x0
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 0e                	push   $0xe
  80117b:	e8 9a fe ff ff       	call   80101a <syscall>
  801180:	83 c4 18             	add    $0x18,%esp
}
  801183:	c9                   	leave  
  801184:	c3                   	ret    

00801185 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801188:	6a 00                	push   $0x0
  80118a:	6a 00                	push   $0x0
  80118c:	6a 00                	push   $0x0
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 0f                	push   $0xf
  801194:	e8 81 fe ff ff       	call   80101a <syscall>
  801199:	83 c4 18             	add    $0x18,%esp
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 00                	push   $0x0
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	ff 75 08             	pushl  0x8(%ebp)
  8011ac:	6a 10                	push   $0x10
  8011ae:	e8 67 fe ff ff       	call   80101a <syscall>
  8011b3:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    

008011b8 <sys_scarce_memory>:

void sys_scarce_memory() {
  8011b8:	55                   	push   %ebp
  8011b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 00                	push   $0x0
  8011c3:	6a 00                	push   $0x0
  8011c5:	6a 11                	push   $0x11
  8011c7:	e8 4e fe ff ff       	call   80101a <syscall>
  8011cc:	83 c4 18             	add    $0x18,%esp
}
  8011cf:	90                   	nop
  8011d0:	c9                   	leave  
  8011d1:	c3                   	ret    

008011d2 <sys_cputc>:

void sys_cputc(const char c) {
  8011d2:	55                   	push   %ebp
  8011d3:	89 e5                	mov    %esp,%ebp
  8011d5:	83 ec 04             	sub    $0x4,%esp
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011e2:	6a 00                	push   $0x0
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	50                   	push   %eax
  8011eb:	6a 01                	push   $0x1
  8011ed:	e8 28 fe ff ff       	call   80101a <syscall>
  8011f2:	83 c4 18             	add    $0x18,%esp
}
  8011f5:	90                   	nop
  8011f6:	c9                   	leave  
  8011f7:	c3                   	ret    

008011f8 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8011f8:	55                   	push   %ebp
  8011f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	6a 14                	push   $0x14
  801207:	e8 0e fe ff ff       	call   80101a <syscall>
  80120c:	83 c4 18             	add    $0x18,%esp
}
  80120f:	90                   	nop
  801210:	c9                   	leave  
  801211:	c3                   	ret    

00801212 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  801212:	55                   	push   %ebp
  801213:	89 e5                	mov    %esp,%ebp
  801215:	83 ec 04             	sub    $0x4,%esp
  801218:	8b 45 10             	mov    0x10(%ebp),%eax
  80121b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80121e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801221:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	6a 00                	push   $0x0
  80122a:	51                   	push   %ecx
  80122b:	52                   	push   %edx
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	50                   	push   %eax
  801230:	6a 15                	push   $0x15
  801232:	e8 e3 fd ff ff       	call   80101a <syscall>
  801237:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  80123a:	c9                   	leave  
  80123b:	c3                   	ret    

0080123c <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80123f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801242:	8b 45 08             	mov    0x8(%ebp),%eax
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	52                   	push   %edx
  80124c:	50                   	push   %eax
  80124d:	6a 16                	push   $0x16
  80124f:	e8 c6 fd ff ff       	call   80101a <syscall>
  801254:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801257:	c9                   	leave  
  801258:	c3                   	ret    

00801259 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  80125c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	6a 00                	push   $0x0
  801267:	6a 00                	push   $0x0
  801269:	51                   	push   %ecx
  80126a:	52                   	push   %edx
  80126b:	50                   	push   %eax
  80126c:	6a 17                	push   $0x17
  80126e:	e8 a7 fd ff ff       	call   80101a <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	52                   	push   %edx
  801288:	50                   	push   %eax
  801289:	6a 18                	push   $0x18
  80128b:	e8 8a fd ff ff       	call   80101a <syscall>
  801290:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	6a 00                	push   $0x0
  80129d:	ff 75 14             	pushl  0x14(%ebp)
  8012a0:	ff 75 10             	pushl  0x10(%ebp)
  8012a3:	ff 75 0c             	pushl  0xc(%ebp)
  8012a6:	50                   	push   %eax
  8012a7:	6a 19                	push   $0x19
  8012a9:	e8 6c fd ff ff       	call   80101a <syscall>
  8012ae:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8012b1:	c9                   	leave  
  8012b2:	c3                   	ret    

008012b3 <sys_run_env>:

void sys_run_env(int32 envId) {
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	6a 00                	push   $0x0
  8012bb:	6a 00                	push   $0x0
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	50                   	push   %eax
  8012c2:	6a 1a                	push   $0x1a
  8012c4:	e8 51 fd ff ff       	call   80101a <syscall>
  8012c9:	83 c4 18             	add    $0x18,%esp
}
  8012cc:	90                   	nop
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	6a 00                	push   $0x0
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	50                   	push   %eax
  8012de:	6a 1b                	push   $0x1b
  8012e0:	e8 35 fd ff ff       	call   80101a <syscall>
  8012e5:	83 c4 18             	add    $0x18,%esp
}
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <sys_getenvid>:

int32 sys_getenvid(void) {
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 05                	push   $0x5
  8012f9:	e8 1c fd ff ff       	call   80101a <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 06                	push   $0x6
  801312:	e8 03 fd ff ff       	call   80101a <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 07                	push   $0x7
  80132b:	e8 ea fc ff ff       	call   80101a <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <sys_exit_env>:

void sys_exit_env(void) {
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 00                	push   $0x0
  80133e:	6a 00                	push   $0x0
  801340:	6a 00                	push   $0x0
  801342:	6a 1c                	push   $0x1c
  801344:	e8 d1 fc ff ff       	call   80101a <syscall>
  801349:	83 c4 18             	add    $0x18,%esp
}
  80134c:	90                   	nop
  80134d:	c9                   	leave  
  80134e:	c3                   	ret    

0080134f <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801355:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801358:	8d 50 04             	lea    0x4(%eax),%edx
  80135b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80135e:	6a 00                	push   $0x0
  801360:	6a 00                	push   $0x0
  801362:	6a 00                	push   $0x0
  801364:	52                   	push   %edx
  801365:	50                   	push   %eax
  801366:	6a 1d                	push   $0x1d
  801368:	e8 ad fc ff ff       	call   80101a <syscall>
  80136d:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801370:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801373:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801376:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801379:	89 01                	mov    %eax,(%ecx)
  80137b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	c9                   	leave  
  801382:	c2 04 00             	ret    $0x4

00801385 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801388:	6a 00                	push   $0x0
  80138a:	6a 00                	push   $0x0
  80138c:	ff 75 10             	pushl  0x10(%ebp)
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	ff 75 08             	pushl  0x8(%ebp)
  801395:	6a 13                	push   $0x13
  801397:	e8 7e fc ff ff       	call   80101a <syscall>
  80139c:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80139f:	90                   	nop
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <sys_rcr2>:
uint32 sys_rcr2() {
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013a5:	6a 00                	push   $0x0
  8013a7:	6a 00                	push   $0x0
  8013a9:	6a 00                	push   $0x0
  8013ab:	6a 00                	push   $0x0
  8013ad:	6a 00                	push   $0x0
  8013af:	6a 1e                	push   $0x1e
  8013b1:	e8 64 fc ff ff       	call   80101a <syscall>
  8013b6:	83 c4 18             	add    $0x18,%esp
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013c7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	50                   	push   %eax
  8013d4:	6a 1f                	push   $0x1f
  8013d6:	e8 3f fc ff ff       	call   80101a <syscall>
  8013db:	83 c4 18             	add    $0x18,%esp
	return;
  8013de:	90                   	nop
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <rsttst>:
void rsttst() {
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 21                	push   $0x21
  8013f0:	e8 25 fc ff ff       	call   80101a <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
	return;
  8013f8:	90                   	nop
}
  8013f9:	c9                   	leave  
  8013fa:	c3                   	ret    

008013fb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8013fb:	55                   	push   %ebp
  8013fc:	89 e5                	mov    %esp,%ebp
  8013fe:	83 ec 04             	sub    $0x4,%esp
  801401:	8b 45 14             	mov    0x14(%ebp),%eax
  801404:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801407:	8b 55 18             	mov    0x18(%ebp),%edx
  80140a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80140e:	52                   	push   %edx
  80140f:	50                   	push   %eax
  801410:	ff 75 10             	pushl  0x10(%ebp)
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	ff 75 08             	pushl  0x8(%ebp)
  801419:	6a 20                	push   $0x20
  80141b:	e8 fa fb ff ff       	call   80101a <syscall>
  801420:	83 c4 18             	add    $0x18,%esp
	return;
  801423:	90                   	nop
}
  801424:	c9                   	leave  
  801425:	c3                   	ret    

00801426 <chktst>:
void chktst(uint32 n) {
  801426:	55                   	push   %ebp
  801427:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	6a 00                	push   $0x0
  801431:	ff 75 08             	pushl  0x8(%ebp)
  801434:	6a 22                	push   $0x22
  801436:	e8 df fb ff ff       	call   80101a <syscall>
  80143b:	83 c4 18             	add    $0x18,%esp
	return;
  80143e:	90                   	nop
}
  80143f:	c9                   	leave  
  801440:	c3                   	ret    

00801441 <inctst>:

void inctst() {
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 23                	push   $0x23
  801450:	e8 c5 fb ff ff       	call   80101a <syscall>
  801455:	83 c4 18             	add    $0x18,%esp
	return;
  801458:	90                   	nop
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <gettst>:
uint32 gettst() {
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 24                	push   $0x24
  80146a:	e8 ab fb ff ff       	call   80101a <syscall>
  80146f:	83 c4 18             	add    $0x18,%esp
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80147a:	6a 00                	push   $0x0
  80147c:	6a 00                	push   $0x0
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 25                	push   $0x25
  801486:	e8 8f fb ff ff       	call   80101a <syscall>
  80148b:	83 c4 18             	add    $0x18,%esp
  80148e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801491:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801495:	75 07                	jne    80149e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801497:	b8 01 00 00 00       	mov    $0x1,%eax
  80149c:	eb 05                	jmp    8014a3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80149e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a3:	c9                   	leave  
  8014a4:	c3                   	ret    

008014a5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014ab:	6a 00                	push   $0x0
  8014ad:	6a 00                	push   $0x0
  8014af:	6a 00                	push   $0x0
  8014b1:	6a 00                	push   $0x0
  8014b3:	6a 00                	push   $0x0
  8014b5:	6a 25                	push   $0x25
  8014b7:	e8 5e fb ff ff       	call   80101a <syscall>
  8014bc:	83 c4 18             	add    $0x18,%esp
  8014bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014c2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014c6:	75 07                	jne    8014cf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8014cd:	eb 05                	jmp    8014d4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 00                	push   $0x0
  8014e2:	6a 00                	push   $0x0
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 25                	push   $0x25
  8014e8:	e8 2d fb ff ff       	call   80101a <syscall>
  8014ed:	83 c4 18             	add    $0x18,%esp
  8014f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014f3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014f7:	75 07                	jne    801500 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8014fe:	eb 05                	jmp    801505 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801505:	c9                   	leave  
  801506:	c3                   	ret    

00801507 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	6a 00                	push   $0x0
  801517:	6a 25                	push   $0x25
  801519:	e8 fc fa ff ff       	call   80101a <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801524:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801528:	75 07                	jne    801531 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80152a:	b8 01 00 00 00       	mov    $0x1,%eax
  80152f:	eb 05                	jmp    801536 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801531:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80153b:	6a 00                	push   $0x0
  80153d:	6a 00                	push   $0x0
  80153f:	6a 00                	push   $0x0
  801541:	6a 00                	push   $0x0
  801543:	ff 75 08             	pushl  0x8(%ebp)
  801546:	6a 26                	push   $0x26
  801548:	e8 cd fa ff ff       	call   80101a <syscall>
  80154d:	83 c4 18             	add    $0x18,%esp
	return;
  801550:	90                   	nop
}
  801551:	c9                   	leave  
  801552:	c3                   	ret    

00801553 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801553:	55                   	push   %ebp
  801554:	89 e5                	mov    %esp,%ebp
  801556:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801557:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80155a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80155d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	6a 00                	push   $0x0
  801565:	53                   	push   %ebx
  801566:	51                   	push   %ecx
  801567:	52                   	push   %edx
  801568:	50                   	push   %eax
  801569:	6a 27                	push   $0x27
  80156b:	e8 aa fa ff ff       	call   80101a <syscall>
  801570:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  80157b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	52                   	push   %edx
  801588:	50                   	push   %eax
  801589:	6a 28                	push   $0x28
  80158b:	e8 8a fa ff ff       	call   80101a <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801593:	c9                   	leave  
  801594:	c3                   	ret    

00801595 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801598:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80159b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	6a 00                	push   $0x0
  8015a3:	51                   	push   %ecx
  8015a4:	ff 75 10             	pushl  0x10(%ebp)
  8015a7:	52                   	push   %edx
  8015a8:	50                   	push   %eax
  8015a9:	6a 29                	push   $0x29
  8015ab:	e8 6a fa ff ff       	call   80101a <syscall>
  8015b0:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	ff 75 10             	pushl  0x10(%ebp)
  8015bf:	ff 75 0c             	pushl  0xc(%ebp)
  8015c2:	ff 75 08             	pushl  0x8(%ebp)
  8015c5:	6a 12                	push   $0x12
  8015c7:	e8 4e fa ff ff       	call   80101a <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
	return;
  8015cf:	90                   	nop
}
  8015d0:	c9                   	leave  
  8015d1:	c3                   	ret    

008015d2 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8015d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	6a 00                	push   $0x0
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	52                   	push   %edx
  8015e2:	50                   	push   %eax
  8015e3:	6a 2a                	push   $0x2a
  8015e5:	e8 30 fa ff ff       	call   80101a <syscall>
  8015ea:	83 c4 18             	add    $0x18,%esp
	return;
  8015ed:	90                   	nop
}
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	6a 00                	push   $0x0
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	50                   	push   %eax
  8015ff:	6a 2b                	push   $0x2b
  801601:	e8 14 fa ff ff       	call   80101a <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80160e:	6a 00                	push   $0x0
  801610:	6a 00                	push   $0x0
  801612:	6a 00                	push   $0x0
  801614:	ff 75 0c             	pushl  0xc(%ebp)
  801617:	ff 75 08             	pushl  0x8(%ebp)
  80161a:	6a 2c                	push   $0x2c
  80161c:	e8 f9 f9 ff ff       	call   80101a <syscall>
  801621:	83 c4 18             	add    $0x18,%esp
	return;
  801624:	90                   	nop
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    

00801627 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80162a:	6a 00                	push   $0x0
  80162c:	6a 00                	push   $0x0
  80162e:	6a 00                	push   $0x0
  801630:	ff 75 0c             	pushl  0xc(%ebp)
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	6a 2d                	push   $0x2d
  801638:	e8 dd f9 ff ff       	call   80101a <syscall>
  80163d:	83 c4 18             	add    $0x18,%esp
	return;
  801640:	90                   	nop
}
  801641:	c9                   	leave  
  801642:	c3                   	ret    

00801643 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	50                   	push   %eax
  801652:	6a 2f                	push   $0x2f
  801654:	e8 c1 f9 ff ff       	call   80101a <syscall>
  801659:	83 c4 18             	add    $0x18,%esp
	return;
  80165c:	90                   	nop
}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  801662:	8b 55 0c             	mov    0xc(%ebp),%edx
  801665:	8b 45 08             	mov    0x8(%ebp),%eax
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	52                   	push   %edx
  80166f:	50                   	push   %eax
  801670:	6a 30                	push   $0x30
  801672:	e8 a3 f9 ff ff       	call   80101a <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
	return;
  80167a:	90                   	nop
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	50                   	push   %eax
  80168c:	6a 31                	push   $0x31
  80168e:	e8 87 f9 ff ff       	call   80101a <syscall>
  801693:	83 c4 18             	add    $0x18,%esp
	return;
  801696:	90                   	nop
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	52                   	push   %edx
  8016a9:	50                   	push   %eax
  8016aa:	6a 2e                	push   $0x2e
  8016ac:	e8 69 f9 ff ff       	call   80101a <syscall>
  8016b1:	83 c4 18             	add    $0x18,%esp
    return;
  8016b4:	90                   	nop
}
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016bd:	8d 45 10             	lea    0x10(%ebp),%eax
  8016c0:	83 c0 04             	add    $0x4,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016c6:	a1 28 30 80 00       	mov    0x803028,%eax
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	74 16                	je     8016e5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016cf:	a1 28 30 80 00       	mov    0x803028,%eax
  8016d4:	83 ec 08             	sub    $0x8,%esp
  8016d7:	50                   	push   %eax
  8016d8:	68 18 20 80 00       	push   $0x802018
  8016dd:	e8 9e eb ff ff       	call   800280 <cprintf>
  8016e2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016e5:	a1 04 30 80 00       	mov    0x803004,%eax
  8016ea:	ff 75 0c             	pushl  0xc(%ebp)
  8016ed:	ff 75 08             	pushl  0x8(%ebp)
  8016f0:	50                   	push   %eax
  8016f1:	68 1d 20 80 00       	push   $0x80201d
  8016f6:	e8 85 eb ff ff       	call   800280 <cprintf>
  8016fb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801701:	83 ec 08             	sub    $0x8,%esp
  801704:	ff 75 f4             	pushl  -0xc(%ebp)
  801707:	50                   	push   %eax
  801708:	e8 08 eb ff ff       	call   800215 <vcprintf>
  80170d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	6a 00                	push   $0x0
  801715:	68 39 20 80 00       	push   $0x802039
  80171a:	e8 f6 ea ff ff       	call   800215 <vcprintf>
  80171f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801722:	e8 77 ea ff ff       	call   80019e <exit>

	// should not return here
	while (1) ;
  801727:	eb fe                	jmp    801727 <_panic+0x70>

00801729 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80172f:	a1 08 30 80 00       	mov    0x803008,%eax
  801734:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80173a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173d:	39 c2                	cmp    %eax,%edx
  80173f:	74 14                	je     801755 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801741:	83 ec 04             	sub    $0x4,%esp
  801744:	68 3c 20 80 00       	push   $0x80203c
  801749:	6a 26                	push   $0x26
  80174b:	68 88 20 80 00       	push   $0x802088
  801750:	e8 62 ff ff ff       	call   8016b7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801755:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80175c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801763:	e9 c5 00 00 00       	jmp    80182d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	8b 00                	mov    (%eax),%eax
  801779:	85 c0                	test   %eax,%eax
  80177b:	75 08                	jne    801785 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80177d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801780:	e9 a5 00 00 00       	jmp    80182a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801785:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80178c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801793:	eb 69                	jmp    8017fe <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801795:	a1 08 30 80 00       	mov    0x803008,%eax
  80179a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8017a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017a3:	89 d0                	mov    %edx,%eax
  8017a5:	01 c0                	add    %eax,%eax
  8017a7:	01 d0                	add    %edx,%eax
  8017a9:	c1 e0 03             	shl    $0x3,%eax
  8017ac:	01 c8                	add    %ecx,%eax
  8017ae:	8a 40 04             	mov    0x4(%eax),%al
  8017b1:	84 c0                	test   %al,%al
  8017b3:	75 46                	jne    8017fb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017b5:	a1 08 30 80 00       	mov    0x803008,%eax
  8017ba:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8017c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c3:	89 d0                	mov    %edx,%eax
  8017c5:	01 c0                	add    %eax,%eax
  8017c7:	01 d0                	add    %edx,%eax
  8017c9:	c1 e0 03             	shl    $0x3,%eax
  8017cc:	01 c8                	add    %ecx,%eax
  8017ce:	8b 00                	mov    (%eax),%eax
  8017d0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017d3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017db:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	01 c8                	add    %ecx,%eax
  8017ec:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017ee:	39 c2                	cmp    %eax,%edx
  8017f0:	75 09                	jne    8017fb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017f2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017f9:	eb 15                	jmp    801810 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017fb:	ff 45 e8             	incl   -0x18(%ebp)
  8017fe:	a1 08 30 80 00       	mov    0x803008,%eax
  801803:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801809:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180c:	39 c2                	cmp    %eax,%edx
  80180e:	77 85                	ja     801795 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801810:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801814:	75 14                	jne    80182a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 94 20 80 00       	push   $0x802094
  80181e:	6a 3a                	push   $0x3a
  801820:	68 88 20 80 00       	push   $0x802088
  801825:	e8 8d fe ff ff       	call   8016b7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80182a:	ff 45 f0             	incl   -0x10(%ebp)
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801830:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801833:	0f 8c 2f ff ff ff    	jl     801768 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801839:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801840:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801847:	eb 26                	jmp    80186f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801849:	a1 08 30 80 00       	mov    0x803008,%eax
  80184e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801854:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801857:	89 d0                	mov    %edx,%eax
  801859:	01 c0                	add    %eax,%eax
  80185b:	01 d0                	add    %edx,%eax
  80185d:	c1 e0 03             	shl    $0x3,%eax
  801860:	01 c8                	add    %ecx,%eax
  801862:	8a 40 04             	mov    0x4(%eax),%al
  801865:	3c 01                	cmp    $0x1,%al
  801867:	75 03                	jne    80186c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801869:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80186c:	ff 45 e0             	incl   -0x20(%ebp)
  80186f:	a1 08 30 80 00       	mov    0x803008,%eax
  801874:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80187a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187d:	39 c2                	cmp    %eax,%edx
  80187f:	77 c8                	ja     801849 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801884:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801887:	74 14                	je     80189d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801889:	83 ec 04             	sub    $0x4,%esp
  80188c:	68 e8 20 80 00       	push   $0x8020e8
  801891:	6a 44                	push   $0x44
  801893:	68 88 20 80 00       	push   $0x802088
  801898:	e8 1a fe ff ff       	call   8016b7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80189d:	90                   	nop
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <__udivdi3>:
  8018a0:	55                   	push   %ebp
  8018a1:	57                   	push   %edi
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018b7:	89 ca                	mov    %ecx,%edx
  8018b9:	89 f8                	mov    %edi,%eax
  8018bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018bf:	85 f6                	test   %esi,%esi
  8018c1:	75 2d                	jne    8018f0 <__udivdi3+0x50>
  8018c3:	39 cf                	cmp    %ecx,%edi
  8018c5:	77 65                	ja     80192c <__udivdi3+0x8c>
  8018c7:	89 fd                	mov    %edi,%ebp
  8018c9:	85 ff                	test   %edi,%edi
  8018cb:	75 0b                	jne    8018d8 <__udivdi3+0x38>
  8018cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018d2:	31 d2                	xor    %edx,%edx
  8018d4:	f7 f7                	div    %edi
  8018d6:	89 c5                	mov    %eax,%ebp
  8018d8:	31 d2                	xor    %edx,%edx
  8018da:	89 c8                	mov    %ecx,%eax
  8018dc:	f7 f5                	div    %ebp
  8018de:	89 c1                	mov    %eax,%ecx
  8018e0:	89 d8                	mov    %ebx,%eax
  8018e2:	f7 f5                	div    %ebp
  8018e4:	89 cf                	mov    %ecx,%edi
  8018e6:	89 fa                	mov    %edi,%edx
  8018e8:	83 c4 1c             	add    $0x1c,%esp
  8018eb:	5b                   	pop    %ebx
  8018ec:	5e                   	pop    %esi
  8018ed:	5f                   	pop    %edi
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    
  8018f0:	39 ce                	cmp    %ecx,%esi
  8018f2:	77 28                	ja     80191c <__udivdi3+0x7c>
  8018f4:	0f bd fe             	bsr    %esi,%edi
  8018f7:	83 f7 1f             	xor    $0x1f,%edi
  8018fa:	75 40                	jne    80193c <__udivdi3+0x9c>
  8018fc:	39 ce                	cmp    %ecx,%esi
  8018fe:	72 0a                	jb     80190a <__udivdi3+0x6a>
  801900:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801904:	0f 87 9e 00 00 00    	ja     8019a8 <__udivdi3+0x108>
  80190a:	b8 01 00 00 00       	mov    $0x1,%eax
  80190f:	89 fa                	mov    %edi,%edx
  801911:	83 c4 1c             	add    $0x1c,%esp
  801914:	5b                   	pop    %ebx
  801915:	5e                   	pop    %esi
  801916:	5f                   	pop    %edi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    
  801919:	8d 76 00             	lea    0x0(%esi),%esi
  80191c:	31 ff                	xor    %edi,%edi
  80191e:	31 c0                	xor    %eax,%eax
  801920:	89 fa                	mov    %edi,%edx
  801922:	83 c4 1c             	add    $0x1c,%esp
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5f                   	pop    %edi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    
  80192a:	66 90                	xchg   %ax,%ax
  80192c:	89 d8                	mov    %ebx,%eax
  80192e:	f7 f7                	div    %edi
  801930:	31 ff                	xor    %edi,%edi
  801932:	89 fa                	mov    %edi,%edx
  801934:	83 c4 1c             	add    $0x1c,%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5f                   	pop    %edi
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    
  80193c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801941:	89 eb                	mov    %ebp,%ebx
  801943:	29 fb                	sub    %edi,%ebx
  801945:	89 f9                	mov    %edi,%ecx
  801947:	d3 e6                	shl    %cl,%esi
  801949:	89 c5                	mov    %eax,%ebp
  80194b:	88 d9                	mov    %bl,%cl
  80194d:	d3 ed                	shr    %cl,%ebp
  80194f:	89 e9                	mov    %ebp,%ecx
  801951:	09 f1                	or     %esi,%ecx
  801953:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801957:	89 f9                	mov    %edi,%ecx
  801959:	d3 e0                	shl    %cl,%eax
  80195b:	89 c5                	mov    %eax,%ebp
  80195d:	89 d6                	mov    %edx,%esi
  80195f:	88 d9                	mov    %bl,%cl
  801961:	d3 ee                	shr    %cl,%esi
  801963:	89 f9                	mov    %edi,%ecx
  801965:	d3 e2                	shl    %cl,%edx
  801967:	8b 44 24 08          	mov    0x8(%esp),%eax
  80196b:	88 d9                	mov    %bl,%cl
  80196d:	d3 e8                	shr    %cl,%eax
  80196f:	09 c2                	or     %eax,%edx
  801971:	89 d0                	mov    %edx,%eax
  801973:	89 f2                	mov    %esi,%edx
  801975:	f7 74 24 0c          	divl   0xc(%esp)
  801979:	89 d6                	mov    %edx,%esi
  80197b:	89 c3                	mov    %eax,%ebx
  80197d:	f7 e5                	mul    %ebp
  80197f:	39 d6                	cmp    %edx,%esi
  801981:	72 19                	jb     80199c <__udivdi3+0xfc>
  801983:	74 0b                	je     801990 <__udivdi3+0xf0>
  801985:	89 d8                	mov    %ebx,%eax
  801987:	31 ff                	xor    %edi,%edi
  801989:	e9 58 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  80198e:	66 90                	xchg   %ax,%ax
  801990:	8b 54 24 08          	mov    0x8(%esp),%edx
  801994:	89 f9                	mov    %edi,%ecx
  801996:	d3 e2                	shl    %cl,%edx
  801998:	39 c2                	cmp    %eax,%edx
  80199a:	73 e9                	jae    801985 <__udivdi3+0xe5>
  80199c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80199f:	31 ff                	xor    %edi,%edi
  8019a1:	e9 40 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  8019a6:	66 90                	xchg   %ax,%ax
  8019a8:	31 c0                	xor    %eax,%eax
  8019aa:	e9 37 ff ff ff       	jmp    8018e6 <__udivdi3+0x46>
  8019af:	90                   	nop

008019b0 <__umoddi3>:
  8019b0:	55                   	push   %ebp
  8019b1:	57                   	push   %edi
  8019b2:	56                   	push   %esi
  8019b3:	53                   	push   %ebx
  8019b4:	83 ec 1c             	sub    $0x1c,%esp
  8019b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019cf:	89 f3                	mov    %esi,%ebx
  8019d1:	89 fa                	mov    %edi,%edx
  8019d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019d7:	89 34 24             	mov    %esi,(%esp)
  8019da:	85 c0                	test   %eax,%eax
  8019dc:	75 1a                	jne    8019f8 <__umoddi3+0x48>
  8019de:	39 f7                	cmp    %esi,%edi
  8019e0:	0f 86 a2 00 00 00    	jbe    801a88 <__umoddi3+0xd8>
  8019e6:	89 c8                	mov    %ecx,%eax
  8019e8:	89 f2                	mov    %esi,%edx
  8019ea:	f7 f7                	div    %edi
  8019ec:	89 d0                	mov    %edx,%eax
  8019ee:	31 d2                	xor    %edx,%edx
  8019f0:	83 c4 1c             	add    $0x1c,%esp
  8019f3:	5b                   	pop    %ebx
  8019f4:	5e                   	pop    %esi
  8019f5:	5f                   	pop    %edi
  8019f6:	5d                   	pop    %ebp
  8019f7:	c3                   	ret    
  8019f8:	39 f0                	cmp    %esi,%eax
  8019fa:	0f 87 ac 00 00 00    	ja     801aac <__umoddi3+0xfc>
  801a00:	0f bd e8             	bsr    %eax,%ebp
  801a03:	83 f5 1f             	xor    $0x1f,%ebp
  801a06:	0f 84 ac 00 00 00    	je     801ab8 <__umoddi3+0x108>
  801a0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801a11:	29 ef                	sub    %ebp,%edi
  801a13:	89 fe                	mov    %edi,%esi
  801a15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a19:	89 e9                	mov    %ebp,%ecx
  801a1b:	d3 e0                	shl    %cl,%eax
  801a1d:	89 d7                	mov    %edx,%edi
  801a1f:	89 f1                	mov    %esi,%ecx
  801a21:	d3 ef                	shr    %cl,%edi
  801a23:	09 c7                	or     %eax,%edi
  801a25:	89 e9                	mov    %ebp,%ecx
  801a27:	d3 e2                	shl    %cl,%edx
  801a29:	89 14 24             	mov    %edx,(%esp)
  801a2c:	89 d8                	mov    %ebx,%eax
  801a2e:	d3 e0                	shl    %cl,%eax
  801a30:	89 c2                	mov    %eax,%edx
  801a32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a36:	d3 e0                	shl    %cl,%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a40:	89 f1                	mov    %esi,%ecx
  801a42:	d3 e8                	shr    %cl,%eax
  801a44:	09 d0                	or     %edx,%eax
  801a46:	d3 eb                	shr    %cl,%ebx
  801a48:	89 da                	mov    %ebx,%edx
  801a4a:	f7 f7                	div    %edi
  801a4c:	89 d3                	mov    %edx,%ebx
  801a4e:	f7 24 24             	mull   (%esp)
  801a51:	89 c6                	mov    %eax,%esi
  801a53:	89 d1                	mov    %edx,%ecx
  801a55:	39 d3                	cmp    %edx,%ebx
  801a57:	0f 82 87 00 00 00    	jb     801ae4 <__umoddi3+0x134>
  801a5d:	0f 84 91 00 00 00    	je     801af4 <__umoddi3+0x144>
  801a63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a67:	29 f2                	sub    %esi,%edx
  801a69:	19 cb                	sbb    %ecx,%ebx
  801a6b:	89 d8                	mov    %ebx,%eax
  801a6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a71:	d3 e0                	shl    %cl,%eax
  801a73:	89 e9                	mov    %ebp,%ecx
  801a75:	d3 ea                	shr    %cl,%edx
  801a77:	09 d0                	or     %edx,%eax
  801a79:	89 e9                	mov    %ebp,%ecx
  801a7b:	d3 eb                	shr    %cl,%ebx
  801a7d:	89 da                	mov    %ebx,%edx
  801a7f:	83 c4 1c             	add    $0x1c,%esp
  801a82:	5b                   	pop    %ebx
  801a83:	5e                   	pop    %esi
  801a84:	5f                   	pop    %edi
  801a85:	5d                   	pop    %ebp
  801a86:	c3                   	ret    
  801a87:	90                   	nop
  801a88:	89 fd                	mov    %edi,%ebp
  801a8a:	85 ff                	test   %edi,%edi
  801a8c:	75 0b                	jne    801a99 <__umoddi3+0xe9>
  801a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a93:	31 d2                	xor    %edx,%edx
  801a95:	f7 f7                	div    %edi
  801a97:	89 c5                	mov    %eax,%ebp
  801a99:	89 f0                	mov    %esi,%eax
  801a9b:	31 d2                	xor    %edx,%edx
  801a9d:	f7 f5                	div    %ebp
  801a9f:	89 c8                	mov    %ecx,%eax
  801aa1:	f7 f5                	div    %ebp
  801aa3:	89 d0                	mov    %edx,%eax
  801aa5:	e9 44 ff ff ff       	jmp    8019ee <__umoddi3+0x3e>
  801aaa:	66 90                	xchg   %ax,%ax
  801aac:	89 c8                	mov    %ecx,%eax
  801aae:	89 f2                	mov    %esi,%edx
  801ab0:	83 c4 1c             	add    $0x1c,%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5f                   	pop    %edi
  801ab6:	5d                   	pop    %ebp
  801ab7:	c3                   	ret    
  801ab8:	3b 04 24             	cmp    (%esp),%eax
  801abb:	72 06                	jb     801ac3 <__umoddi3+0x113>
  801abd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ac1:	77 0f                	ja     801ad2 <__umoddi3+0x122>
  801ac3:	89 f2                	mov    %esi,%edx
  801ac5:	29 f9                	sub    %edi,%ecx
  801ac7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801acb:	89 14 24             	mov    %edx,(%esp)
  801ace:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ad6:	8b 14 24             	mov    (%esp),%edx
  801ad9:	83 c4 1c             	add    $0x1c,%esp
  801adc:	5b                   	pop    %ebx
  801add:	5e                   	pop    %esi
  801ade:	5f                   	pop    %edi
  801adf:	5d                   	pop    %ebp
  801ae0:	c3                   	ret    
  801ae1:	8d 76 00             	lea    0x0(%esi),%esi
  801ae4:	2b 04 24             	sub    (%esp),%eax
  801ae7:	19 fa                	sbb    %edi,%edx
  801ae9:	89 d1                	mov    %edx,%ecx
  801aeb:	89 c6                	mov    %eax,%esi
  801aed:	e9 71 ff ff ff       	jmp    801a63 <__umoddi3+0xb3>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801af8:	72 ea                	jb     801ae4 <__umoddi3+0x134>
  801afa:	89 d9                	mov    %ebx,%ecx
  801afc:	e9 62 ff ff ff       	jmp    801a63 <__umoddi3+0xb3>
