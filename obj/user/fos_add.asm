
obj/user/fos_add:     file format elf32-i386


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
  800031:	e8 a9 00 00 00       	call   8000df <libmain>
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
	int i1=0;
  80003e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int i2=0;
  800045:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

	i1 = strtol("1", NULL, 10);
  80004c:	83 ec 04             	sub    $0x4,%esp
  80004f:	6a 0a                	push   $0xa
  800051:	6a 00                	push   $0x0
  800053:	68 80 1b 80 00       	push   $0x801b80
  800058:	e8 8f 0c 00 00       	call   800cec <strtol>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	89 45 e8             	mov    %eax,-0x18(%ebp)
	i2 = strtol("2", NULL, 10);
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	6a 0a                	push   $0xa
  800068:	6a 00                	push   $0x0
  80006a:	68 82 1b 80 00       	push   $0x801b82
  80006f:	e8 78 0c 00 00       	call   800cec <strtol>
  800074:	83 c4 10             	add    $0x10,%esp
  800077:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  80007a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80007d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800080:	01 d0                	add    %edx,%eax
  800082:	83 ec 08             	sub    $0x8,%esp
  800085:	50                   	push   %eax
  800086:	68 84 1b 80 00       	push   $0x801b84
  80008b:	e8 95 02 00 00       	call   800325 <atomic_cprintf>
  800090:	83 c4 10             	add    $0x10,%esp
	//cprintf("number 1 + number 2 = \n");

	int N = 100000;
  800093:	c7 45 e0 a0 86 01 00 	movl   $0x186a0,-0x20(%ebp)
	int64 sum = 0;
  80009a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8000a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int i = 0; i < N; ++i) {
  8000a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8000af:	eb 0d                	jmp    8000be <_main+0x86>
		sum+=i ;
  8000b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b4:	99                   	cltd   
  8000b5:	01 45 f0             	add    %eax,-0x10(%ebp)
  8000b8:	11 55 f4             	adc    %edx,-0xc(%ebp)
	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
	//cprintf("number 1 + number 2 = \n");

	int N = 100000;
	int64 sum = 0;
	for (int i = 0; i < N; ++i) {
  8000bb:	ff 45 ec             	incl   -0x14(%ebp)
  8000be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8000c4:	7c eb                	jl     8000b1 <_main+0x79>
		sum+=i ;
	}
	cprintf("sum 1->%d = %d\n", N, sum);
  8000c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000c9:	ff 75 f0             	pushl  -0x10(%ebp)
  8000cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8000cf:	68 9e 1b 80 00       	push   $0x801b9e
  8000d4:	e8 1f 02 00 00       	call   8002f8 <cprintf>
  8000d9:	83 c4 10             	add    $0x10,%esp

	return;
  8000dc:	90                   	nop
}
  8000dd:	c9                   	leave  
  8000de:	c3                   	ret    

008000df <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e5:	e8 91 12 00 00       	call   80137b <sys_getenvindex>
  8000ea:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000f0:	89 d0                	mov    %edx,%eax
  8000f2:	c1 e0 02             	shl    $0x2,%eax
  8000f5:	01 d0                	add    %edx,%eax
  8000f7:	c1 e0 03             	shl    $0x3,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800103:	01 d0                	add    %edx,%eax
  800105:	c1 e0 02             	shl    $0x2,%eax
  800108:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80010d:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800112:	a1 08 30 80 00       	mov    0x803008,%eax
  800117:	8a 40 20             	mov    0x20(%eax),%al
  80011a:	84 c0                	test   %al,%al
  80011c:	74 0d                	je     80012b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80011e:	a1 08 30 80 00       	mov    0x803008,%eax
  800123:	83 c0 20             	add    $0x20,%eax
  800126:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012f:	7e 0a                	jle    80013b <libmain+0x5c>
		binaryname = argv[0];
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8b 00                	mov    (%eax),%eax
  800136:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80013b:	83 ec 08             	sub    $0x8,%esp
  80013e:	ff 75 0c             	pushl  0xc(%ebp)
  800141:	ff 75 08             	pushl  0x8(%ebp)
  800144:	e8 ef fe ff ff       	call   800038 <_main>
  800149:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80014c:	a1 00 30 80 00       	mov    0x803000,%eax
  800151:	85 c0                	test   %eax,%eax
  800153:	0f 84 9f 00 00 00    	je     8001f8 <libmain+0x119>
	{
		sys_lock_cons();
  800159:	e8 a1 0f 00 00       	call   8010ff <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	68 c8 1b 80 00       	push   $0x801bc8
  800166:	e8 8d 01 00 00       	call   8002f8 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80016e:	a1 08 30 80 00       	mov    0x803008,%eax
  800173:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800179:	a1 08 30 80 00       	mov    0x803008,%eax
  80017e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	52                   	push   %edx
  800188:	50                   	push   %eax
  800189:	68 f0 1b 80 00       	push   $0x801bf0
  80018e:	e8 65 01 00 00       	call   8002f8 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800196:	a1 08 30 80 00       	mov    0x803008,%eax
  80019b:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001a1:	a1 08 30 80 00       	mov    0x803008,%eax
  8001a6:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001ac:	a1 08 30 80 00       	mov    0x803008,%eax
  8001b1:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001b7:	51                   	push   %ecx
  8001b8:	52                   	push   %edx
  8001b9:	50                   	push   %eax
  8001ba:	68 18 1c 80 00       	push   $0x801c18
  8001bf:	e8 34 01 00 00       	call   8002f8 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c7:	a1 08 30 80 00       	mov    0x803008,%eax
  8001cc:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	50                   	push   %eax
  8001d6:	68 70 1c 80 00       	push   $0x801c70
  8001db:	e8 18 01 00 00       	call   8002f8 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	68 c8 1b 80 00       	push   $0x801bc8
  8001eb:	e8 08 01 00 00       	call   8002f8 <cprintf>
  8001f0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001f3:	e8 21 0f 00 00       	call   801119 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001f8:	e8 19 00 00 00       	call   800216 <exit>
}
  8001fd:	90                   	nop
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800206:	83 ec 0c             	sub    $0xc,%esp
  800209:	6a 00                	push   $0x0
  80020b:	e8 37 11 00 00       	call   801347 <sys_destroy_env>
  800210:	83 c4 10             	add    $0x10,%esp
}
  800213:	90                   	nop
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <exit>:

void
exit(void)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80021c:	e8 8c 11 00 00       	call   8013ad <sys_exit_env>
}
  800221:	90                   	nop
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80022a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022d:	8b 00                	mov    (%eax),%eax
  80022f:	8d 48 01             	lea    0x1(%eax),%ecx
  800232:	8b 55 0c             	mov    0xc(%ebp),%edx
  800235:	89 0a                	mov    %ecx,(%edx)
  800237:	8b 55 08             	mov    0x8(%ebp),%edx
  80023a:	88 d1                	mov    %dl,%cl
  80023c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800243:	8b 45 0c             	mov    0xc(%ebp),%eax
  800246:	8b 00                	mov    (%eax),%eax
  800248:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024d:	75 2c                	jne    80027b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80024f:	a0 0c 30 80 00       	mov    0x80300c,%al
  800254:	0f b6 c0             	movzbl %al,%eax
  800257:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025a:	8b 12                	mov    (%edx),%edx
  80025c:	89 d1                	mov    %edx,%ecx
  80025e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800261:	83 c2 08             	add    $0x8,%edx
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	50                   	push   %eax
  800268:	51                   	push   %ecx
  800269:	52                   	push   %edx
  80026a:	e8 4e 0e 00 00       	call   8010bd <sys_cputs>
  80026f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800272:	8b 45 0c             	mov    0xc(%ebp),%eax
  800275:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	8b 40 04             	mov    0x4(%eax),%eax
  800281:	8d 50 01             	lea    0x1(%eax),%edx
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	89 50 04             	mov    %edx,0x4(%eax)
}
  80028a:	90                   	nop
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800296:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80029d:	00 00 00 
	b.cnt = 0;
  8002a0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b6:	50                   	push   %eax
  8002b7:	68 24 02 80 00       	push   $0x800224
  8002bc:	e8 11 02 00 00       	call   8004d2 <vprintfmt>
  8002c1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002c4:	a0 0c 30 80 00       	mov    0x80300c,%al
  8002c9:	0f b6 c0             	movzbl %al,%eax
  8002cc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002d2:	83 ec 04             	sub    $0x4,%esp
  8002d5:	50                   	push   %eax
  8002d6:	52                   	push   %edx
  8002d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002dd:	83 c0 08             	add    $0x8,%eax
  8002e0:	50                   	push   %eax
  8002e1:	e8 d7 0d 00 00       	call   8010bd <sys_cputs>
  8002e6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e9:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8002f0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002fe:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800305:	8d 45 0c             	lea    0xc(%ebp),%eax
  800308:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80030b:	8b 45 08             	mov    0x8(%ebp),%eax
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	ff 75 f4             	pushl  -0xc(%ebp)
  800314:	50                   	push   %eax
  800315:	e8 73 ff ff ff       	call   80028d <vcprintf>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80032b:	e8 cf 0d 00 00       	call   8010ff <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800330:	8d 45 0c             	lea    0xc(%ebp),%eax
  800333:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800336:	8b 45 08             	mov    0x8(%ebp),%eax
  800339:	83 ec 08             	sub    $0x8,%esp
  80033c:	ff 75 f4             	pushl  -0xc(%ebp)
  80033f:	50                   	push   %eax
  800340:	e8 48 ff ff ff       	call   80028d <vcprintf>
  800345:	83 c4 10             	add    $0x10,%esp
  800348:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80034b:	e8 c9 0d 00 00       	call   801119 <sys_unlock_cons>
	return cnt;
  800350:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800353:	c9                   	leave  
  800354:	c3                   	ret    

00800355 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	53                   	push   %ebx
  800359:	83 ec 14             	sub    $0x14,%esp
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800362:	8b 45 14             	mov    0x14(%ebp),%eax
  800365:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800368:	8b 45 18             	mov    0x18(%ebp),%eax
  80036b:	ba 00 00 00 00       	mov    $0x0,%edx
  800370:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800373:	77 55                	ja     8003ca <printnum+0x75>
  800375:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800378:	72 05                	jb     80037f <printnum+0x2a>
  80037a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80037d:	77 4b                	ja     8003ca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800382:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	ba 00 00 00 00       	mov    $0x0,%edx
  80038d:	52                   	push   %edx
  80038e:	50                   	push   %eax
  80038f:	ff 75 f4             	pushl  -0xc(%ebp)
  800392:	ff 75 f0             	pushl  -0x10(%ebp)
  800395:	e8 7e 15 00 00       	call   801918 <__udivdi3>
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	83 ec 04             	sub    $0x4,%esp
  8003a0:	ff 75 20             	pushl  0x20(%ebp)
  8003a3:	53                   	push   %ebx
  8003a4:	ff 75 18             	pushl  0x18(%ebp)
  8003a7:	52                   	push   %edx
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 0c             	pushl  0xc(%ebp)
  8003ac:	ff 75 08             	pushl  0x8(%ebp)
  8003af:	e8 a1 ff ff ff       	call   800355 <printnum>
  8003b4:	83 c4 20             	add    $0x20,%esp
  8003b7:	eb 1a                	jmp    8003d3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b9:	83 ec 08             	sub    $0x8,%esp
  8003bc:	ff 75 0c             	pushl  0xc(%ebp)
  8003bf:	ff 75 20             	pushl  0x20(%ebp)
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	ff d0                	call   *%eax
  8003c7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ca:	ff 4d 1c             	decl   0x1c(%ebp)
  8003cd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003d1:	7f e6                	jg     8003b9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003e1:	53                   	push   %ebx
  8003e2:	51                   	push   %ecx
  8003e3:	52                   	push   %edx
  8003e4:	50                   	push   %eax
  8003e5:	e8 3e 16 00 00       	call   801a28 <__umoddi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	05 b4 1e 80 00       	add    $0x801eb4,%eax
  8003f2:	8a 00                	mov    (%eax),%al
  8003f4:	0f be c0             	movsbl %al,%eax
  8003f7:	83 ec 08             	sub    $0x8,%esp
  8003fa:	ff 75 0c             	pushl  0xc(%ebp)
  8003fd:	50                   	push   %eax
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	ff d0                	call   *%eax
  800403:	83 c4 10             	add    $0x10,%esp
}
  800406:	90                   	nop
  800407:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80040f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800413:	7e 1c                	jle    800431 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	8b 00                	mov    (%eax),%eax
  80041a:	8d 50 08             	lea    0x8(%eax),%edx
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	89 10                	mov    %edx,(%eax)
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	83 e8 08             	sub    $0x8,%eax
  80042a:	8b 50 04             	mov    0x4(%eax),%edx
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	eb 40                	jmp    800471 <getuint+0x65>
	else if (lflag)
  800431:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800435:	74 1e                	je     800455 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	8d 50 04             	lea    0x4(%eax),%edx
  80043f:	8b 45 08             	mov    0x8(%ebp),%eax
  800442:	89 10                	mov    %edx,(%eax)
  800444:	8b 45 08             	mov    0x8(%ebp),%eax
  800447:	8b 00                	mov    (%eax),%eax
  800449:	83 e8 04             	sub    $0x4,%eax
  80044c:	8b 00                	mov    (%eax),%eax
  80044e:	ba 00 00 00 00       	mov    $0x0,%edx
  800453:	eb 1c                	jmp    800471 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	8d 50 04             	lea    0x4(%eax),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	89 10                	mov    %edx,(%eax)
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	83 e8 04             	sub    $0x4,%eax
  80046a:	8b 00                	mov    (%eax),%eax
  80046c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800471:	5d                   	pop    %ebp
  800472:	c3                   	ret    

00800473 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800476:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80047a:	7e 1c                	jle    800498 <getint+0x25>
		return va_arg(*ap, long long);
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	8d 50 08             	lea    0x8(%eax),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	89 10                	mov    %edx,(%eax)
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	83 e8 08             	sub    $0x8,%eax
  800491:	8b 50 04             	mov    0x4(%eax),%edx
  800494:	8b 00                	mov    (%eax),%eax
  800496:	eb 38                	jmp    8004d0 <getint+0x5d>
	else if (lflag)
  800498:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80049c:	74 1a                	je     8004b8 <getint+0x45>
		return va_arg(*ap, long);
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	8d 50 04             	lea    0x4(%eax),%edx
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	89 10                	mov    %edx,(%eax)
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	83 e8 04             	sub    $0x4,%eax
  8004b3:	8b 00                	mov    (%eax),%eax
  8004b5:	99                   	cltd   
  8004b6:	eb 18                	jmp    8004d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bb:	8b 00                	mov    (%eax),%eax
  8004bd:	8d 50 04             	lea    0x4(%eax),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	89 10                	mov    %edx,(%eax)
  8004c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	83 e8 04             	sub    $0x4,%eax
  8004cd:	8b 00                	mov    (%eax),%eax
  8004cf:	99                   	cltd   
}
  8004d0:	5d                   	pop    %ebp
  8004d1:	c3                   	ret    

008004d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	56                   	push   %esi
  8004d6:	53                   	push   %ebx
  8004d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004da:	eb 17                	jmp    8004f3 <vprintfmt+0x21>
			if (ch == '\0')
  8004dc:	85 db                	test   %ebx,%ebx
  8004de:	0f 84 c1 03 00 00    	je     8008a5 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004e4:	83 ec 08             	sub    $0x8,%esp
  8004e7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ea:	53                   	push   %ebx
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	ff d0                	call   *%eax
  8004f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	8d 50 01             	lea    0x1(%eax),%edx
  8004f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8004fc:	8a 00                	mov    (%eax),%al
  8004fe:	0f b6 d8             	movzbl %al,%ebx
  800501:	83 fb 25             	cmp    $0x25,%ebx
  800504:	75 d6                	jne    8004dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800506:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80050a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800511:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800518:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80051f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800526:	8b 45 10             	mov    0x10(%ebp),%eax
  800529:	8d 50 01             	lea    0x1(%eax),%edx
  80052c:	89 55 10             	mov    %edx,0x10(%ebp)
  80052f:	8a 00                	mov    (%eax),%al
  800531:	0f b6 d8             	movzbl %al,%ebx
  800534:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800537:	83 f8 5b             	cmp    $0x5b,%eax
  80053a:	0f 87 3d 03 00 00    	ja     80087d <vprintfmt+0x3ab>
  800540:	8b 04 85 d8 1e 80 00 	mov    0x801ed8(,%eax,4),%eax
  800547:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800549:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80054d:	eb d7                	jmp    800526 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80054f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800553:	eb d1                	jmp    800526 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800555:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80055c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80055f:	89 d0                	mov    %edx,%eax
  800561:	c1 e0 02             	shl    $0x2,%eax
  800564:	01 d0                	add    %edx,%eax
  800566:	01 c0                	add    %eax,%eax
  800568:	01 d8                	add    %ebx,%eax
  80056a:	83 e8 30             	sub    $0x30,%eax
  80056d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800570:	8b 45 10             	mov    0x10(%ebp),%eax
  800573:	8a 00                	mov    (%eax),%al
  800575:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800578:	83 fb 2f             	cmp    $0x2f,%ebx
  80057b:	7e 3e                	jle    8005bb <vprintfmt+0xe9>
  80057d:	83 fb 39             	cmp    $0x39,%ebx
  800580:	7f 39                	jg     8005bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800582:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800585:	eb d5                	jmp    80055c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	83 c0 04             	add    $0x4,%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	83 e8 04             	sub    $0x4,%eax
  800596:	8b 00                	mov    (%eax),%eax
  800598:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80059b:	eb 1f                	jmp    8005bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80059d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a1:	79 83                	jns    800526 <vprintfmt+0x54>
				width = 0;
  8005a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005aa:	e9 77 ff ff ff       	jmp    800526 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005b6:	e9 6b ff ff ff       	jmp    800526 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005c0:	0f 89 60 ff ff ff    	jns    800526 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005d3:	e9 4e ff ff ff       	jmp    800526 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005db:	e9 46 ff ff ff       	jmp    800526 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	83 c0 04             	add    $0x4,%eax
  8005e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 e8 04             	sub    $0x4,%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	ff 75 0c             	pushl  0xc(%ebp)
  8005f7:	50                   	push   %eax
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	ff d0                	call   *%eax
  8005fd:	83 c4 10             	add    $0x10,%esp
			break;
  800600:	e9 9b 02 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800605:	8b 45 14             	mov    0x14(%ebp),%eax
  800608:	83 c0 04             	add    $0x4,%eax
  80060b:	89 45 14             	mov    %eax,0x14(%ebp)
  80060e:	8b 45 14             	mov    0x14(%ebp),%eax
  800611:	83 e8 04             	sub    $0x4,%eax
  800614:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800616:	85 db                	test   %ebx,%ebx
  800618:	79 02                	jns    80061c <vprintfmt+0x14a>
				err = -err;
  80061a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80061c:	83 fb 64             	cmp    $0x64,%ebx
  80061f:	7f 0b                	jg     80062c <vprintfmt+0x15a>
  800621:	8b 34 9d 20 1d 80 00 	mov    0x801d20(,%ebx,4),%esi
  800628:	85 f6                	test   %esi,%esi
  80062a:	75 19                	jne    800645 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80062c:	53                   	push   %ebx
  80062d:	68 c5 1e 80 00       	push   $0x801ec5
  800632:	ff 75 0c             	pushl  0xc(%ebp)
  800635:	ff 75 08             	pushl  0x8(%ebp)
  800638:	e8 70 02 00 00       	call   8008ad <printfmt>
  80063d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800640:	e9 5b 02 00 00       	jmp    8008a0 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800645:	56                   	push   %esi
  800646:	68 ce 1e 80 00       	push   $0x801ece
  80064b:	ff 75 0c             	pushl  0xc(%ebp)
  80064e:	ff 75 08             	pushl  0x8(%ebp)
  800651:	e8 57 02 00 00       	call   8008ad <printfmt>
  800656:	83 c4 10             	add    $0x10,%esp
			break;
  800659:	e9 42 02 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	83 c0 04             	add    $0x4,%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	83 e8 04             	sub    $0x4,%eax
  80066d:	8b 30                	mov    (%eax),%esi
  80066f:	85 f6                	test   %esi,%esi
  800671:	75 05                	jne    800678 <vprintfmt+0x1a6>
				p = "(null)";
  800673:	be d1 1e 80 00       	mov    $0x801ed1,%esi
			if (width > 0 && padc != '-')
  800678:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80067c:	7e 6d                	jle    8006eb <vprintfmt+0x219>
  80067e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800682:	74 67                	je     8006eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800687:	83 ec 08             	sub    $0x8,%esp
  80068a:	50                   	push   %eax
  80068b:	56                   	push   %esi
  80068c:	e8 1e 03 00 00       	call   8009af <strnlen>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800697:	eb 16                	jmp    8006af <vprintfmt+0x1dd>
					putch(padc, putdat);
  800699:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	50                   	push   %eax
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8006af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006b3:	7f e4                	jg     800699 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b5:	eb 34                	jmp    8006eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006bb:	74 1c                	je     8006d9 <vprintfmt+0x207>
  8006bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8006c0:	7e 05                	jle    8006c7 <vprintfmt+0x1f5>
  8006c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8006c5:	7e 12                	jle    8006d9 <vprintfmt+0x207>
					putch('?', putdat);
  8006c7:	83 ec 08             	sub    $0x8,%esp
  8006ca:	ff 75 0c             	pushl  0xc(%ebp)
  8006cd:	6a 3f                	push   $0x3f
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	eb 0f                	jmp    8006e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	53                   	push   %ebx
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006eb:	89 f0                	mov    %esi,%eax
  8006ed:	8d 70 01             	lea    0x1(%eax),%esi
  8006f0:	8a 00                	mov    (%eax),%al
  8006f2:	0f be d8             	movsbl %al,%ebx
  8006f5:	85 db                	test   %ebx,%ebx
  8006f7:	74 24                	je     80071d <vprintfmt+0x24b>
  8006f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006fd:	78 b8                	js     8006b7 <vprintfmt+0x1e5>
  8006ff:	ff 4d e0             	decl   -0x20(%ebp)
  800702:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800706:	79 af                	jns    8006b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800708:	eb 13                	jmp    80071d <vprintfmt+0x24b>
				putch(' ', putdat);
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	6a 20                	push   $0x20
  800712:	8b 45 08             	mov    0x8(%ebp),%eax
  800715:	ff d0                	call   *%eax
  800717:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071a:	ff 4d e4             	decl   -0x1c(%ebp)
  80071d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800721:	7f e7                	jg     80070a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800723:	e9 78 01 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	ff 75 e8             	pushl  -0x18(%ebp)
  80072e:	8d 45 14             	lea    0x14(%ebp),%eax
  800731:	50                   	push   %eax
  800732:	e8 3c fd ff ff       	call   800473 <getint>
  800737:	83 c4 10             	add    $0x10,%esp
  80073a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800743:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800746:	85 d2                	test   %edx,%edx
  800748:	79 23                	jns    80076d <vprintfmt+0x29b>
				putch('-', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 2d                	push   $0x2d
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80075a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80075d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800760:	f7 d8                	neg    %eax
  800762:	83 d2 00             	adc    $0x0,%edx
  800765:	f7 da                	neg    %edx
  800767:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80076a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80076d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800774:	e9 bc 00 00 00       	jmp    800835 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800779:	83 ec 08             	sub    $0x8,%esp
  80077c:	ff 75 e8             	pushl  -0x18(%ebp)
  80077f:	8d 45 14             	lea    0x14(%ebp),%eax
  800782:	50                   	push   %eax
  800783:	e8 84 fc ff ff       	call   80040c <getuint>
  800788:	83 c4 10             	add    $0x10,%esp
  80078b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800791:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800798:	e9 98 00 00 00       	jmp    800835 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	ff 75 0c             	pushl  0xc(%ebp)
  8007a3:	6a 58                	push   $0x58
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	ff d0                	call   *%eax
  8007aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007ad:	83 ec 08             	sub    $0x8,%esp
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	6a 58                	push   $0x58
  8007b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b8:	ff d0                	call   *%eax
  8007ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	ff 75 0c             	pushl  0xc(%ebp)
  8007c3:	6a 58                	push   $0x58
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	ff d0                	call   *%eax
  8007ca:	83 c4 10             	add    $0x10,%esp
			break;
  8007cd:	e9 ce 00 00 00       	jmp    8008a0 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	6a 30                	push   $0x30
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007e2:	83 ec 08             	sub    $0x8,%esp
  8007e5:	ff 75 0c             	pushl  0xc(%ebp)
  8007e8:	6a 78                	push   $0x78
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	ff d0                	call   *%eax
  8007ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f5:	83 c0 04             	add    $0x4,%eax
  8007f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	83 e8 04             	sub    $0x4,%eax
  800801:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80080d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	ff 75 e8             	pushl  -0x18(%ebp)
  80081c:	8d 45 14             	lea    0x14(%ebp),%eax
  80081f:	50                   	push   %eax
  800820:	e8 e7 fb ff ff       	call   80040c <getuint>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80082b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80082e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800835:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80083c:	83 ec 04             	sub    $0x4,%esp
  80083f:	52                   	push   %edx
  800840:	ff 75 e4             	pushl  -0x1c(%ebp)
  800843:	50                   	push   %eax
  800844:	ff 75 f4             	pushl  -0xc(%ebp)
  800847:	ff 75 f0             	pushl  -0x10(%ebp)
  80084a:	ff 75 0c             	pushl  0xc(%ebp)
  80084d:	ff 75 08             	pushl  0x8(%ebp)
  800850:	e8 00 fb ff ff       	call   800355 <printnum>
  800855:	83 c4 20             	add    $0x20,%esp
			break;
  800858:	eb 46                	jmp    8008a0 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	53                   	push   %ebx
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
			break;
  800869:	eb 35                	jmp    8008a0 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80086b:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800872:	eb 2c                	jmp    8008a0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800874:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  80087b:	eb 23                	jmp    8008a0 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80087d:	83 ec 08             	sub    $0x8,%esp
  800880:	ff 75 0c             	pushl  0xc(%ebp)
  800883:	6a 25                	push   $0x25
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088d:	ff 4d 10             	decl   0x10(%ebp)
  800890:	eb 03                	jmp    800895 <vprintfmt+0x3c3>
  800892:	ff 4d 10             	decl   0x10(%ebp)
  800895:	8b 45 10             	mov    0x10(%ebp),%eax
  800898:	48                   	dec    %eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	3c 25                	cmp    $0x25,%al
  80089d:	75 f3                	jne    800892 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80089f:	90                   	nop
		}
	}
  8008a0:	e9 35 fc ff ff       	jmp    8004da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008a5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008a9:	5b                   	pop    %ebx
  8008aa:	5e                   	pop    %esi
  8008ab:	5d                   	pop    %ebp
  8008ac:	c3                   	ret    

008008ad <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008b3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b6:	83 c0 04             	add    $0x4,%eax
  8008b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8008c2:	50                   	push   %eax
  8008c3:	ff 75 0c             	pushl  0xc(%ebp)
  8008c6:	ff 75 08             	pushl  0x8(%ebp)
  8008c9:	e8 04 fc ff ff       	call   8004d2 <vprintfmt>
  8008ce:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008d1:	90                   	nop
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    

008008d4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008da:	8b 40 08             	mov    0x8(%eax),%eax
  8008dd:	8d 50 01             	lea    0x1(%eax),%edx
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e9:	8b 10                	mov    (%eax),%edx
  8008eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ee:	8b 40 04             	mov    0x4(%eax),%eax
  8008f1:	39 c2                	cmp    %eax,%edx
  8008f3:	73 12                	jae    800907 <sprintputch+0x33>
		*b->buf++ = ch;
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	8d 48 01             	lea    0x1(%eax),%ecx
  8008fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800900:	89 0a                	mov    %ecx,(%edx)
  800902:	8b 55 08             	mov    0x8(%ebp),%edx
  800905:	88 10                	mov    %dl,(%eax)
}
  800907:	90                   	nop
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800916:	8b 45 0c             	mov    0xc(%ebp),%eax
  800919:	8d 50 ff             	lea    -0x1(%eax),%edx
  80091c:	8b 45 08             	mov    0x8(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800924:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80092b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80092f:	74 06                	je     800937 <vsnprintf+0x2d>
  800931:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800935:	7f 07                	jg     80093e <vsnprintf+0x34>
		return -E_INVAL;
  800937:	b8 03 00 00 00       	mov    $0x3,%eax
  80093c:	eb 20                	jmp    80095e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093e:	ff 75 14             	pushl  0x14(%ebp)
  800941:	ff 75 10             	pushl  0x10(%ebp)
  800944:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800947:	50                   	push   %eax
  800948:	68 d4 08 80 00       	push   $0x8008d4
  80094d:	e8 80 fb ff ff       	call   8004d2 <vprintfmt>
  800952:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800958:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80095b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800966:	8d 45 10             	lea    0x10(%ebp),%eax
  800969:	83 c0 04             	add    $0x4,%eax
  80096c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80096f:	8b 45 10             	mov    0x10(%ebp),%eax
  800972:	ff 75 f4             	pushl  -0xc(%ebp)
  800975:	50                   	push   %eax
  800976:	ff 75 0c             	pushl  0xc(%ebp)
  800979:	ff 75 08             	pushl  0x8(%ebp)
  80097c:	e8 89 ff ff ff       	call   80090a <vsnprintf>
  800981:	83 c4 10             	add    $0x10,%esp
  800984:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80098a:	c9                   	leave  
  80098b:	c3                   	ret    

0080098c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800992:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800999:	eb 06                	jmp    8009a1 <strlen+0x15>
		n++;
  80099b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80099e:	ff 45 08             	incl   0x8(%ebp)
  8009a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a4:	8a 00                	mov    (%eax),%al
  8009a6:	84 c0                	test   %al,%al
  8009a8:	75 f1                	jne    80099b <strlen+0xf>
		n++;
	return n;
  8009aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009ad:	c9                   	leave  
  8009ae:	c3                   	ret    

008009af <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009bc:	eb 09                	jmp    8009c7 <strnlen+0x18>
		n++;
  8009be:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c1:	ff 45 08             	incl   0x8(%ebp)
  8009c4:	ff 4d 0c             	decl   0xc(%ebp)
  8009c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009cb:	74 09                	je     8009d6 <strnlen+0x27>
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8a 00                	mov    (%eax),%al
  8009d2:	84 c0                	test   %al,%al
  8009d4:	75 e8                	jne    8009be <strnlen+0xf>
		n++;
	return n;
  8009d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009e7:	90                   	nop
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	8d 50 01             	lea    0x1(%eax),%edx
  8009ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009f7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009fa:	8a 12                	mov    (%edx),%dl
  8009fc:	88 10                	mov    %dl,(%eax)
  8009fe:	8a 00                	mov    (%eax),%al
  800a00:	84 c0                	test   %al,%al
  800a02:	75 e4                	jne    8009e8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a07:	c9                   	leave  
  800a08:	c3                   	ret    

00800a09 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a09:	55                   	push   %ebp
  800a0a:	89 e5                	mov    %esp,%ebp
  800a0c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a1c:	eb 1f                	jmp    800a3d <strncpy+0x34>
		*dst++ = *src;
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8d 50 01             	lea    0x1(%eax),%edx
  800a24:	89 55 08             	mov    %edx,0x8(%ebp)
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	8a 12                	mov    (%edx),%dl
  800a2c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	8a 00                	mov    (%eax),%al
  800a33:	84 c0                	test   %al,%al
  800a35:	74 03                	je     800a3a <strncpy+0x31>
			src++;
  800a37:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3a:	ff 45 fc             	incl   -0x4(%ebp)
  800a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a40:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a43:	72 d9                	jb     800a1e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a45:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a48:	c9                   	leave  
  800a49:	c3                   	ret    

00800a4a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a5a:	74 30                	je     800a8c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a5c:	eb 16                	jmp    800a74 <strlcpy+0x2a>
			*dst++ = *src++;
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 08             	mov    %edx,0x8(%ebp)
  800a67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a70:	8a 12                	mov    (%edx),%dl
  800a72:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a74:	ff 4d 10             	decl   0x10(%ebp)
  800a77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a7b:	74 09                	je     800a86 <strlcpy+0x3c>
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	8a 00                	mov    (%eax),%al
  800a82:	84 c0                	test   %al,%al
  800a84:	75 d8                	jne    800a5e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a92:	29 c2                	sub    %eax,%edx
  800a94:	89 d0                	mov    %edx,%eax
}
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a9b:	eb 06                	jmp    800aa3 <strcmp+0xb>
		p++, q++;
  800a9d:	ff 45 08             	incl   0x8(%ebp)
  800aa0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	8a 00                	mov    (%eax),%al
  800aa8:	84 c0                	test   %al,%al
  800aaa:	74 0e                	je     800aba <strcmp+0x22>
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	8a 10                	mov    (%eax),%dl
  800ab1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	38 c2                	cmp    %al,%dl
  800ab8:	74 e3                	je     800a9d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8a 00                	mov    (%eax),%al
  800abf:	0f b6 d0             	movzbl %al,%edx
  800ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	0f b6 c0             	movzbl %al,%eax
  800aca:	29 c2                	sub    %eax,%edx
  800acc:	89 d0                	mov    %edx,%eax
}
  800ace:	5d                   	pop    %ebp
  800acf:	c3                   	ret    

00800ad0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ad0:	55                   	push   %ebp
  800ad1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ad3:	eb 09                	jmp    800ade <strncmp+0xe>
		n--, p++, q++;
  800ad5:	ff 4d 10             	decl   0x10(%ebp)
  800ad8:	ff 45 08             	incl   0x8(%ebp)
  800adb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ade:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ae2:	74 17                	je     800afb <strncmp+0x2b>
  800ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae7:	8a 00                	mov    (%eax),%al
  800ae9:	84 c0                	test   %al,%al
  800aeb:	74 0e                	je     800afb <strncmp+0x2b>
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8a 10                	mov    (%eax),%dl
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	38 c2                	cmp    %al,%dl
  800af9:	74 da                	je     800ad5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800afb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aff:	75 07                	jne    800b08 <strncmp+0x38>
		return 0;
  800b01:	b8 00 00 00 00       	mov    $0x0,%eax
  800b06:	eb 14                	jmp    800b1c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b08:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0b:	8a 00                	mov    (%eax),%al
  800b0d:	0f b6 d0             	movzbl %al,%edx
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	0f b6 c0             	movzbl %al,%eax
  800b18:	29 c2                	sub    %eax,%edx
  800b1a:	89 d0                	mov    %edx,%eax
}
  800b1c:	5d                   	pop    %ebp
  800b1d:	c3                   	ret    

00800b1e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b2a:	eb 12                	jmp    800b3e <strchr+0x20>
		if (*s == c)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b34:	75 05                	jne    800b3b <strchr+0x1d>
			return (char *) s;
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	eb 11                	jmp    800b4c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b3b:	ff 45 08             	incl   0x8(%ebp)
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	8a 00                	mov    (%eax),%al
  800b43:	84 c0                	test   %al,%al
  800b45:	75 e5                	jne    800b2c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	83 ec 04             	sub    $0x4,%esp
  800b54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b57:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b5a:	eb 0d                	jmp    800b69 <strfind+0x1b>
		if (*s == c)
  800b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b64:	74 0e                	je     800b74 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b66:	ff 45 08             	incl   0x8(%ebp)
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6c:	8a 00                	mov    (%eax),%al
  800b6e:	84 c0                	test   %al,%al
  800b70:	75 ea                	jne    800b5c <strfind+0xe>
  800b72:	eb 01                	jmp    800b75 <strfind+0x27>
		if (*s == c)
			break;
  800b74:	90                   	nop
	return (char *) s;
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    

00800b7a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b86:	8b 45 10             	mov    0x10(%ebp),%eax
  800b89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b8c:	eb 0e                	jmp    800b9c <memset+0x22>
		*p++ = c;
  800b8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b91:	8d 50 01             	lea    0x1(%eax),%edx
  800b94:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b9c:	ff 4d f8             	decl   -0x8(%ebp)
  800b9f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ba3:	79 e9                	jns    800b8e <memset+0x14>
		*p++ = c;

	return v;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800bbc:	eb 16                	jmp    800bd4 <memcpy+0x2a>
		*d++ = *s++;
  800bbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bc1:	8d 50 01             	lea    0x1(%eax),%edx
  800bc4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bc7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bcd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bd0:	8a 12                	mov    (%edx),%dl
  800bd2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bda:	89 55 10             	mov    %edx,0x10(%ebp)
  800bdd:	85 c0                	test   %eax,%eax
  800bdf:	75 dd                	jne    800bbe <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be4:	c9                   	leave  
  800be5:	c3                   	ret    

00800be6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bfe:	73 50                	jae    800c50 <memmove+0x6a>
  800c00:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	01 d0                	add    %edx,%eax
  800c08:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c0b:	76 43                	jbe    800c50 <memmove+0x6a>
		s += n;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c13:	8b 45 10             	mov    0x10(%ebp),%eax
  800c16:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c19:	eb 10                	jmp    800c2b <memmove+0x45>
			*--d = *--s;
  800c1b:	ff 4d f8             	decl   -0x8(%ebp)
  800c1e:	ff 4d fc             	decl   -0x4(%ebp)
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c24:	8a 10                	mov    (%eax),%dl
  800c26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c29:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c31:	89 55 10             	mov    %edx,0x10(%ebp)
  800c34:	85 c0                	test   %eax,%eax
  800c36:	75 e3                	jne    800c1b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c38:	eb 23                	jmp    800c5d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c3d:	8d 50 01             	lea    0x1(%eax),%edx
  800c40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c43:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c46:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c49:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c4c:	8a 12                	mov    (%edx),%dl
  800c4e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c50:	8b 45 10             	mov    0x10(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	89 55 10             	mov    %edx,0x10(%ebp)
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	75 dd                	jne    800c3a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c5d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c60:	c9                   	leave  
  800c61:	c3                   	ret    

00800c62 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c68:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c74:	eb 2a                	jmp    800ca0 <memcmp+0x3e>
		if (*s1 != *s2)
  800c76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c79:	8a 10                	mov    (%eax),%dl
  800c7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c7e:	8a 00                	mov    (%eax),%al
  800c80:	38 c2                	cmp    %al,%dl
  800c82:	74 16                	je     800c9a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c87:	8a 00                	mov    (%eax),%al
  800c89:	0f b6 d0             	movzbl %al,%edx
  800c8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	0f b6 c0             	movzbl %al,%eax
  800c94:	29 c2                	sub    %eax,%edx
  800c96:	89 d0                	mov    %edx,%eax
  800c98:	eb 18                	jmp    800cb2 <memcmp+0x50>
		s1++, s2++;
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ca0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	75 c9                	jne    800c76 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800cba:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	01 d0                	add    %edx,%eax
  800cc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800cc5:	eb 15                	jmp    800cdc <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 d0             	movzbl %al,%edx
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	0f b6 c0             	movzbl %al,%eax
  800cd5:	39 c2                	cmp    %eax,%edx
  800cd7:	74 0d                	je     800ce6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ce2:	72 e3                	jb     800cc7 <memfind+0x13>
  800ce4:	eb 01                	jmp    800ce7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ce6:	90                   	nop
	return (void *) s;
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cea:	c9                   	leave  
  800ceb:	c3                   	ret    

00800cec <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cec:	55                   	push   %ebp
  800ced:	89 e5                	mov    %esp,%ebp
  800cef:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cf9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d00:	eb 03                	jmp    800d05 <strtol+0x19>
		s++;
  800d02:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	3c 20                	cmp    $0x20,%al
  800d0c:	74 f4                	je     800d02 <strtol+0x16>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	3c 09                	cmp    $0x9,%al
  800d15:	74 eb                	je     800d02 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	8a 00                	mov    (%eax),%al
  800d1c:	3c 2b                	cmp    $0x2b,%al
  800d1e:	75 05                	jne    800d25 <strtol+0x39>
		s++;
  800d20:	ff 45 08             	incl   0x8(%ebp)
  800d23:	eb 13                	jmp    800d38 <strtol+0x4c>
	else if (*s == '-')
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	3c 2d                	cmp    $0x2d,%al
  800d2c:	75 0a                	jne    800d38 <strtol+0x4c>
		s++, neg = 1;
  800d2e:	ff 45 08             	incl   0x8(%ebp)
  800d31:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d38:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3c:	74 06                	je     800d44 <strtol+0x58>
  800d3e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d42:	75 20                	jne    800d64 <strtol+0x78>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	3c 30                	cmp    $0x30,%al
  800d4b:	75 17                	jne    800d64 <strtol+0x78>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	40                   	inc    %eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 78                	cmp    $0x78,%al
  800d55:	75 0d                	jne    800d64 <strtol+0x78>
		s += 2, base = 16;
  800d57:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d5b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d62:	eb 28                	jmp    800d8c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d68:	75 15                	jne    800d7f <strtol+0x93>
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	3c 30                	cmp    $0x30,%al
  800d71:	75 0c                	jne    800d7f <strtol+0x93>
		s++, base = 8;
  800d73:	ff 45 08             	incl   0x8(%ebp)
  800d76:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d7d:	eb 0d                	jmp    800d8c <strtol+0xa0>
	else if (base == 0)
  800d7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d83:	75 07                	jne    800d8c <strtol+0xa0>
		base = 10;
  800d85:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3c 2f                	cmp    $0x2f,%al
  800d93:	7e 19                	jle    800dae <strtol+0xc2>
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	3c 39                	cmp    $0x39,%al
  800d9c:	7f 10                	jg     800dae <strtol+0xc2>
			dig = *s - '0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	0f be c0             	movsbl %al,%eax
  800da6:	83 e8 30             	sub    $0x30,%eax
  800da9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dac:	eb 42                	jmp    800df0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8a 00                	mov    (%eax),%al
  800db3:	3c 60                	cmp    $0x60,%al
  800db5:	7e 19                	jle    800dd0 <strtol+0xe4>
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	3c 7a                	cmp    $0x7a,%al
  800dbe:	7f 10                	jg     800dd0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	0f be c0             	movsbl %al,%eax
  800dc8:	83 e8 57             	sub    $0x57,%eax
  800dcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800dce:	eb 20                	jmp    800df0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	3c 40                	cmp    $0x40,%al
  800dd7:	7e 39                	jle    800e12 <strtol+0x126>
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	3c 5a                	cmp    $0x5a,%al
  800de0:	7f 30                	jg     800e12 <strtol+0x126>
			dig = *s - 'A' + 10;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f be c0             	movsbl %al,%eax
  800dea:	83 e8 37             	sub    $0x37,%eax
  800ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800df3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800df6:	7d 19                	jge    800e11 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800df8:	ff 45 08             	incl   0x8(%ebp)
  800dfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfe:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e02:	89 c2                	mov    %eax,%edx
  800e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e07:	01 d0                	add    %edx,%eax
  800e09:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e0c:	e9 7b ff ff ff       	jmp    800d8c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e11:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e16:	74 08                	je     800e20 <strtol+0x134>
		*endptr = (char *) s;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e20:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e24:	74 07                	je     800e2d <strtol+0x141>
  800e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e29:	f7 d8                	neg    %eax
  800e2b:	eb 03                	jmp    800e30 <strtol+0x144>
  800e2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e30:	c9                   	leave  
  800e31:	c3                   	ret    

00800e32 <ltostr>:

void
ltostr(long value, char *str)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e3f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e4a:	79 13                	jns    800e5f <ltostr+0x2d>
	{
		neg = 1;
  800e4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e59:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e5c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e67:	99                   	cltd   
  800e68:	f7 f9                	idiv   %ecx
  800e6a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e76:	89 c2                	mov    %eax,%edx
  800e78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7b:	01 d0                	add    %edx,%eax
  800e7d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e80:	83 c2 30             	add    $0x30,%edx
  800e83:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e85:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e88:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e8d:	f7 e9                	imul   %ecx
  800e8f:	c1 fa 02             	sar    $0x2,%edx
  800e92:	89 c8                	mov    %ecx,%eax
  800e94:	c1 f8 1f             	sar    $0x1f,%eax
  800e97:	29 c2                	sub    %eax,%edx
  800e99:	89 d0                	mov    %edx,%eax
  800e9b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ea2:	75 bb                	jne    800e5f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800ea4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eae:	48                   	dec    %eax
  800eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800eb2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eb6:	74 3d                	je     800ef5 <ltostr+0xc3>
		start = 1 ;
  800eb8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ebf:	eb 34                	jmp    800ef5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800ec1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	01 d0                	add    %edx,%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed4:	01 c2                	add    %eax,%edx
  800ed6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edc:	01 c8                	add    %ecx,%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ee2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	01 c2                	add    %eax,%edx
  800eea:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eed:	88 02                	mov    %al,(%edx)
		start++ ;
  800eef:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ef2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800efb:	7c c4                	jl     800ec1 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800efd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	01 d0                	add    %edx,%eax
  800f05:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f08:	90                   	nop
  800f09:	c9                   	leave  
  800f0a:	c3                   	ret    

00800f0b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f0b:	55                   	push   %ebp
  800f0c:	89 e5                	mov    %esp,%ebp
  800f0e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800f11:	ff 75 08             	pushl  0x8(%ebp)
  800f14:	e8 73 fa ff ff       	call   80098c <strlen>
  800f19:	83 c4 04             	add    $0x4,%esp
  800f1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f1f:	ff 75 0c             	pushl  0xc(%ebp)
  800f22:	e8 65 fa ff ff       	call   80098c <strlen>
  800f27:	83 c4 04             	add    $0x4,%esp
  800f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f3b:	eb 17                	jmp    800f54 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f3d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f40:	8b 45 10             	mov    0x10(%ebp),%eax
  800f43:	01 c2                	add    %eax,%edx
  800f45:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	01 c8                	add    %ecx,%eax
  800f4d:	8a 00                	mov    (%eax),%al
  800f4f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f51:	ff 45 fc             	incl   -0x4(%ebp)
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f5a:	7c e1                	jl     800f3d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f5c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f63:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f6a:	eb 1f                	jmp    800f8b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6f:	8d 50 01             	lea    0x1(%eax),%edx
  800f72:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f75:	89 c2                	mov    %eax,%edx
  800f77:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7a:	01 c2                	add    %eax,%edx
  800f7c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	01 c8                	add    %ecx,%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f88:	ff 45 f8             	incl   -0x8(%ebp)
  800f8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f8e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f91:	7c d9                	jl     800f6c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	01 d0                	add    %edx,%eax
  800f9b:	c6 00 00             	movb   $0x0,(%eax)
}
  800f9e:	90                   	nop
  800f9f:	c9                   	leave  
  800fa0:	c3                   	ret    

00800fa1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800fa1:	55                   	push   %ebp
  800fa2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800fa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800fad:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb0:	8b 00                	mov    (%eax),%eax
  800fb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 d0                	add    %edx,%eax
  800fbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fc4:	eb 0c                	jmp    800fd2 <strsplit+0x31>
			*string++ = 0;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8d 50 01             	lea    0x1(%eax),%edx
  800fcc:	89 55 08             	mov    %edx,0x8(%ebp)
  800fcf:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	84 c0                	test   %al,%al
  800fd9:	74 18                	je     800ff3 <strsplit+0x52>
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	50                   	push   %eax
  800fe4:	ff 75 0c             	pushl  0xc(%ebp)
  800fe7:	e8 32 fb ff ff       	call   800b1e <strchr>
  800fec:	83 c4 08             	add    $0x8,%esp
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	75 d3                	jne    800fc6 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	84 c0                	test   %al,%al
  800ffa:	74 5a                	je     801056 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800ffc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fff:	8b 00                	mov    (%eax),%eax
  801001:	83 f8 0f             	cmp    $0xf,%eax
  801004:	75 07                	jne    80100d <strsplit+0x6c>
		{
			return 0;
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	eb 66                	jmp    801073 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80100d:	8b 45 14             	mov    0x14(%ebp),%eax
  801010:	8b 00                	mov    (%eax),%eax
  801012:	8d 48 01             	lea    0x1(%eax),%ecx
  801015:	8b 55 14             	mov    0x14(%ebp),%edx
  801018:	89 0a                	mov    %ecx,(%edx)
  80101a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801021:	8b 45 10             	mov    0x10(%ebp),%eax
  801024:	01 c2                	add    %eax,%edx
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80102b:	eb 03                	jmp    801030 <strsplit+0x8f>
			string++;
  80102d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	84 c0                	test   %al,%al
  801037:	74 8b                	je     800fc4 <strsplit+0x23>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	0f be c0             	movsbl %al,%eax
  801041:	50                   	push   %eax
  801042:	ff 75 0c             	pushl  0xc(%ebp)
  801045:	e8 d4 fa ff ff       	call   800b1e <strchr>
  80104a:	83 c4 08             	add    $0x8,%esp
  80104d:	85 c0                	test   %eax,%eax
  80104f:	74 dc                	je     80102d <strsplit+0x8c>
			string++;
	}
  801051:	e9 6e ff ff ff       	jmp    800fc4 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801056:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801057:	8b 45 14             	mov    0x14(%ebp),%eax
  80105a:	8b 00                	mov    (%eax),%eax
  80105c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80106e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801073:	c9                   	leave  
  801074:	c3                   	ret    

00801075 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801075:	55                   	push   %ebp
  801076:	89 e5                	mov    %esp,%ebp
  801078:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80107b:	83 ec 04             	sub    $0x4,%esp
  80107e:	68 48 20 80 00       	push   $0x802048
  801083:	68 3f 01 00 00       	push   $0x13f
  801088:	68 6a 20 80 00       	push   $0x80206a
  80108d:	e8 9d 06 00 00       	call   80172f <_panic>

00801092 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	57                   	push   %edi
  801096:	56                   	push   %esi
  801097:	53                   	push   %ebx
  801098:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010a4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010a7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8010aa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8010ad:	cd 30                	int    $0x30
  8010af:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8010b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	5b                   	pop    %ebx
  8010b9:	5e                   	pop    %esi
  8010ba:	5f                   	pop    %edi
  8010bb:	5d                   	pop    %ebp
  8010bc:	c3                   	ret    

008010bd <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	83 ec 04             	sub    $0x4,%esp
  8010c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8010c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d0:	6a 00                	push   $0x0
  8010d2:	6a 00                	push   $0x0
  8010d4:	52                   	push   %edx
  8010d5:	ff 75 0c             	pushl  0xc(%ebp)
  8010d8:	50                   	push   %eax
  8010d9:	6a 00                	push   $0x0
  8010db:	e8 b2 ff ff ff       	call   801092 <syscall>
  8010e0:	83 c4 18             	add    $0x18,%esp
}
  8010e3:	90                   	nop
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <sys_cgetc>:

int sys_cgetc(void) {
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010e9:	6a 00                	push   $0x0
  8010eb:	6a 00                	push   $0x0
  8010ed:	6a 00                	push   $0x0
  8010ef:	6a 00                	push   $0x0
  8010f1:	6a 00                	push   $0x0
  8010f3:	6a 02                	push   $0x2
  8010f5:	e8 98 ff ff ff       	call   801092 <syscall>
  8010fa:	83 c4 18             	add    $0x18,%esp
}
  8010fd:	c9                   	leave  
  8010fe:	c3                   	ret    

008010ff <sys_lock_cons>:

void sys_lock_cons(void) {
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	6a 00                	push   $0x0
  80110c:	6a 03                	push   $0x3
  80110e:	e8 7f ff ff ff       	call   801092 <syscall>
  801113:	83 c4 18             	add    $0x18,%esp
}
  801116:	90                   	nop
  801117:	c9                   	leave  
  801118:	c3                   	ret    

00801119 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80111c:	6a 00                	push   $0x0
  80111e:	6a 00                	push   $0x0
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	6a 04                	push   $0x4
  801128:	e8 65 ff ff ff       	call   801092 <syscall>
  80112d:	83 c4 18             	add    $0x18,%esp
}
  801130:	90                   	nop
  801131:	c9                   	leave  
  801132:	c3                   	ret    

00801133 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	6a 00                	push   $0x0
  80113e:	6a 00                	push   $0x0
  801140:	6a 00                	push   $0x0
  801142:	52                   	push   %edx
  801143:	50                   	push   %eax
  801144:	6a 08                	push   $0x8
  801146:	e8 47 ff ff ff       	call   801092 <syscall>
  80114b:	83 c4 18             	add    $0x18,%esp
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	56                   	push   %esi
  801154:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801155:	8b 75 18             	mov    0x18(%ebp),%esi
  801158:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80115b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80115e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	51                   	push   %ecx
  801167:	52                   	push   %edx
  801168:	50                   	push   %eax
  801169:	6a 09                	push   $0x9
  80116b:	e8 22 ff ff ff       	call   801092 <syscall>
  801170:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801173:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5d                   	pop    %ebp
  801179:	c3                   	ret    

0080117a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80117d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	6a 00                	push   $0x0
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	52                   	push   %edx
  80118a:	50                   	push   %eax
  80118b:	6a 0a                	push   $0xa
  80118d:	e8 00 ff ff ff       	call   801092 <syscall>
  801192:	83 c4 18             	add    $0x18,%esp
}
  801195:	c9                   	leave  
  801196:	c3                   	ret    

00801197 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80119a:	6a 00                	push   $0x0
  80119c:	6a 00                	push   $0x0
  80119e:	6a 00                	push   $0x0
  8011a0:	ff 75 0c             	pushl  0xc(%ebp)
  8011a3:	ff 75 08             	pushl  0x8(%ebp)
  8011a6:	6a 0b                	push   $0xb
  8011a8:	e8 e5 fe ff ff       	call   801092 <syscall>
  8011ad:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    

008011b2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8011b2:	55                   	push   %ebp
  8011b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8011b5:	6a 00                	push   $0x0
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 0c                	push   $0xc
  8011c1:	e8 cc fe ff ff       	call   801092 <syscall>
  8011c6:	83 c4 18             	add    $0x18,%esp
}
  8011c9:	c9                   	leave  
  8011ca:	c3                   	ret    

008011cb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 0d                	push   $0xd
  8011da:	e8 b3 fe ff ff       	call   801092 <syscall>
  8011df:	83 c4 18             	add    $0x18,%esp
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	6a 0e                	push   $0xe
  8011f3:	e8 9a fe ff ff       	call   801092 <syscall>
  8011f8:	83 c4 18             	add    $0x18,%esp
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801200:	6a 00                	push   $0x0
  801202:	6a 00                	push   $0x0
  801204:	6a 00                	push   $0x0
  801206:	6a 00                	push   $0x0
  801208:	6a 00                	push   $0x0
  80120a:	6a 0f                	push   $0xf
  80120c:	e8 81 fe ff ff       	call   801092 <syscall>
  801211:	83 c4 18             	add    $0x18,%esp
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801219:	6a 00                	push   $0x0
  80121b:	6a 00                	push   $0x0
  80121d:	6a 00                	push   $0x0
  80121f:	6a 00                	push   $0x0
  801221:	ff 75 08             	pushl  0x8(%ebp)
  801224:	6a 10                	push   $0x10
  801226:	e8 67 fe ff ff       	call   801092 <syscall>
  80122b:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80122e:	c9                   	leave  
  80122f:	c3                   	ret    

00801230 <sys_scarce_memory>:

void sys_scarce_memory() {
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801233:	6a 00                	push   $0x0
  801235:	6a 00                	push   $0x0
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 11                	push   $0x11
  80123f:	e8 4e fe ff ff       	call   801092 <syscall>
  801244:	83 c4 18             	add    $0x18,%esp
}
  801247:	90                   	nop
  801248:	c9                   	leave  
  801249:	c3                   	ret    

0080124a <sys_cputc>:

void sys_cputc(const char c) {
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 04             	sub    $0x4,%esp
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801256:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80125a:	6a 00                	push   $0x0
  80125c:	6a 00                	push   $0x0
  80125e:	6a 00                	push   $0x0
  801260:	6a 00                	push   $0x0
  801262:	50                   	push   %eax
  801263:	6a 01                	push   $0x1
  801265:	e8 28 fe ff ff       	call   801092 <syscall>
  80126a:	83 c4 18             	add    $0x18,%esp
}
  80126d:	90                   	nop
  80126e:	c9                   	leave  
  80126f:	c3                   	ret    

00801270 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801273:	6a 00                	push   $0x0
  801275:	6a 00                	push   $0x0
  801277:	6a 00                	push   $0x0
  801279:	6a 00                	push   $0x0
  80127b:	6a 00                	push   $0x0
  80127d:	6a 14                	push   $0x14
  80127f:	e8 0e fe ff ff       	call   801092 <syscall>
  801284:	83 c4 18             	add    $0x18,%esp
}
  801287:	90                   	nop
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 04             	sub    $0x4,%esp
  801290:	8b 45 10             	mov    0x10(%ebp),%eax
  801293:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801296:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801299:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	6a 00                	push   $0x0
  8012a2:	51                   	push   %ecx
  8012a3:	52                   	push   %edx
  8012a4:	ff 75 0c             	pushl  0xc(%ebp)
  8012a7:	50                   	push   %eax
  8012a8:	6a 15                	push   $0x15
  8012aa:	e8 e3 fd ff ff       	call   801092 <syscall>
  8012af:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8012b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	52                   	push   %edx
  8012c4:	50                   	push   %eax
  8012c5:	6a 16                	push   $0x16
  8012c7:	e8 c6 fd ff ff       	call   801092 <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8012d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	51                   	push   %ecx
  8012e2:	52                   	push   %edx
  8012e3:	50                   	push   %eax
  8012e4:	6a 17                	push   $0x17
  8012e6:	e8 a7 fd ff ff       	call   801092 <syscall>
  8012eb:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8012f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 00                	push   $0x0
  8012ff:	52                   	push   %edx
  801300:	50                   	push   %eax
  801301:	6a 18                	push   $0x18
  801303:	e8 8a fd ff ff       	call   801092 <syscall>
  801308:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80130b:	c9                   	leave  
  80130c:	c3                   	ret    

0080130d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80130d:	55                   	push   %ebp
  80130e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	6a 00                	push   $0x0
  801315:	ff 75 14             	pushl  0x14(%ebp)
  801318:	ff 75 10             	pushl  0x10(%ebp)
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	50                   	push   %eax
  80131f:	6a 19                	push   $0x19
  801321:	e8 6c fd ff ff       	call   801092 <syscall>
  801326:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_run_env>:

void sys_run_env(int32 envId) {
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	50                   	push   %eax
  80133a:	6a 1a                	push   $0x1a
  80133c:	e8 51 fd ff ff       	call   801092 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	90                   	nop
  801345:	c9                   	leave  
  801346:	c3                   	ret    

00801347 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801347:	55                   	push   %ebp
  801348:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80134a:	8b 45 08             	mov    0x8(%ebp),%eax
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 00                	push   $0x0
  801355:	50                   	push   %eax
  801356:	6a 1b                	push   $0x1b
  801358:	e8 35 fd ff ff       	call   801092 <syscall>
  80135d:	83 c4 18             	add    $0x18,%esp
}
  801360:	c9                   	leave  
  801361:	c3                   	ret    

00801362 <sys_getenvid>:

int32 sys_getenvid(void) {
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801365:	6a 00                	push   $0x0
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 05                	push   $0x5
  801371:	e8 1c fd ff ff       	call   801092 <syscall>
  801376:	83 c4 18             	add    $0x18,%esp
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80137e:	6a 00                	push   $0x0
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 06                	push   $0x6
  80138a:	e8 03 fd ff ff       	call   801092 <syscall>
  80138f:	83 c4 18             	add    $0x18,%esp
}
  801392:	c9                   	leave  
  801393:	c3                   	ret    

00801394 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801397:	6a 00                	push   $0x0
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	6a 00                	push   $0x0
  8013a1:	6a 07                	push   $0x7
  8013a3:	e8 ea fc ff ff       	call   801092 <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <sys_exit_env>:

void sys_exit_env(void) {
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	6a 00                	push   $0x0
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 1c                	push   $0x1c
  8013bc:	e8 d1 fc ff ff       	call   801092 <syscall>
  8013c1:	83 c4 18             	add    $0x18,%esp
}
  8013c4:	90                   	nop
  8013c5:	c9                   	leave  
  8013c6:	c3                   	ret    

008013c7 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8013cd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013d0:	8d 50 04             	lea    0x4(%eax),%edx
  8013d3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	52                   	push   %edx
  8013dd:	50                   	push   %eax
  8013de:	6a 1d                	push   $0x1d
  8013e0:	e8 ad fc ff ff       	call   801092 <syscall>
  8013e5:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8013e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	89 01                	mov    %eax,(%ecx)
  8013f3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	c9                   	leave  
  8013fa:	c2 04 00             	ret    $0x4

008013fd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801400:	6a 00                	push   $0x0
  801402:	6a 00                	push   $0x0
  801404:	ff 75 10             	pushl  0x10(%ebp)
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	ff 75 08             	pushl  0x8(%ebp)
  80140d:	6a 13                	push   $0x13
  80140f:	e8 7e fc ff ff       	call   801092 <syscall>
  801414:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801417:	90                   	nop
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_rcr2>:
uint32 sys_rcr2() {
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 1e                	push   $0x1e
  801429:	e8 64 fc ff ff       	call   801092 <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 04             	sub    $0x4,%esp
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80143f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801443:	6a 00                	push   $0x0
  801445:	6a 00                	push   $0x0
  801447:	6a 00                	push   $0x0
  801449:	6a 00                	push   $0x0
  80144b:	50                   	push   %eax
  80144c:	6a 1f                	push   $0x1f
  80144e:	e8 3f fc ff ff       	call   801092 <syscall>
  801453:	83 c4 18             	add    $0x18,%esp
	return;
  801456:	90                   	nop
}
  801457:	c9                   	leave  
  801458:	c3                   	ret    

00801459 <rsttst>:
void rsttst() {
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80145c:	6a 00                	push   $0x0
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	6a 21                	push   $0x21
  801468:	e8 25 fc ff ff       	call   801092 <syscall>
  80146d:	83 c4 18             	add    $0x18,%esp
	return;
  801470:	90                   	nop
}
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	8b 45 14             	mov    0x14(%ebp),%eax
  80147c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80147f:	8b 55 18             	mov    0x18(%ebp),%edx
  801482:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801486:	52                   	push   %edx
  801487:	50                   	push   %eax
  801488:	ff 75 10             	pushl  0x10(%ebp)
  80148b:	ff 75 0c             	pushl  0xc(%ebp)
  80148e:	ff 75 08             	pushl  0x8(%ebp)
  801491:	6a 20                	push   $0x20
  801493:	e8 fa fb ff ff       	call   801092 <syscall>
  801498:	83 c4 18             	add    $0x18,%esp
	return;
  80149b:	90                   	nop
}
  80149c:	c9                   	leave  
  80149d:	c3                   	ret    

0080149e <chktst>:
void chktst(uint32 n) {
  80149e:	55                   	push   %ebp
  80149f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8014a1:	6a 00                	push   $0x0
  8014a3:	6a 00                	push   $0x0
  8014a5:	6a 00                	push   $0x0
  8014a7:	6a 00                	push   $0x0
  8014a9:	ff 75 08             	pushl  0x8(%ebp)
  8014ac:	6a 22                	push   $0x22
  8014ae:	e8 df fb ff ff       	call   801092 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
	return;
  8014b6:	90                   	nop
}
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    

008014b9 <inctst>:

void inctst() {
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 23                	push   $0x23
  8014c8:	e8 c5 fb ff ff       	call   801092 <syscall>
  8014cd:	83 c4 18             	add    $0x18,%esp
	return;
  8014d0:	90                   	nop
}
  8014d1:	c9                   	leave  
  8014d2:	c3                   	ret    

008014d3 <gettst>:
uint32 gettst() {
  8014d3:	55                   	push   %ebp
  8014d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 24                	push   $0x24
  8014e2:	e8 ab fb ff ff       	call   801092 <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
}
  8014ea:	c9                   	leave  
  8014eb:	c3                   	ret    

008014ec <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014f2:	6a 00                	push   $0x0
  8014f4:	6a 00                	push   $0x0
  8014f6:	6a 00                	push   $0x0
  8014f8:	6a 00                	push   $0x0
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 25                	push   $0x25
  8014fe:	e8 8f fb ff ff       	call   801092 <syscall>
  801503:	83 c4 18             	add    $0x18,%esp
  801506:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801509:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80150d:	75 07                	jne    801516 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80150f:	b8 01 00 00 00       	mov    $0x1,%eax
  801514:	eb 05                	jmp    80151b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151b:	c9                   	leave  
  80151c:	c3                   	ret    

0080151d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
  801520:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801523:	6a 00                	push   $0x0
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	6a 25                	push   $0x25
  80152f:	e8 5e fb ff ff       	call   801092 <syscall>
  801534:	83 c4 18             	add    $0x18,%esp
  801537:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80153a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80153e:	75 07                	jne    801547 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801540:	b8 01 00 00 00       	mov    $0x1,%eax
  801545:	eb 05                	jmp    80154c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801547:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801554:	6a 00                	push   $0x0
  801556:	6a 00                	push   $0x0
  801558:	6a 00                	push   $0x0
  80155a:	6a 00                	push   $0x0
  80155c:	6a 00                	push   $0x0
  80155e:	6a 25                	push   $0x25
  801560:	e8 2d fb ff ff       	call   801092 <syscall>
  801565:	83 c4 18             	add    $0x18,%esp
  801568:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80156b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80156f:	75 07                	jne    801578 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801571:	b8 01 00 00 00       	mov    $0x1,%eax
  801576:	eb 05                	jmp    80157d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
  801582:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	6a 00                	push   $0x0
  80158d:	6a 00                	push   $0x0
  80158f:	6a 25                	push   $0x25
  801591:	e8 fc fa ff ff       	call   801092 <syscall>
  801596:	83 c4 18             	add    $0x18,%esp
  801599:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80159c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8015a0:	75 07                	jne    8015a9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8015a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8015a7:	eb 05                	jmp    8015ae <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	6a 26                	push   $0x26
  8015c0:	e8 cd fa ff ff       	call   801092 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
	return;
  8015c8:	90                   	nop
}
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8015cf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	6a 00                	push   $0x0
  8015dd:	53                   	push   %ebx
  8015de:	51                   	push   %ecx
  8015df:	52                   	push   %edx
  8015e0:	50                   	push   %eax
  8015e1:	6a 27                	push   $0x27
  8015e3:	e8 aa fa ff ff       	call   801092 <syscall>
  8015e8:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8015eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8015f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	52                   	push   %edx
  801600:	50                   	push   %eax
  801601:	6a 28                	push   $0x28
  801603:	e8 8a fa ff ff       	call   801092 <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    

0080160d <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801610:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801613:	8b 55 0c             	mov    0xc(%ebp),%edx
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	51                   	push   %ecx
  80161c:	ff 75 10             	pushl  0x10(%ebp)
  80161f:	52                   	push   %edx
  801620:	50                   	push   %eax
  801621:	6a 29                	push   $0x29
  801623:	e8 6a fa ff ff       	call   801092 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	ff 75 10             	pushl  0x10(%ebp)
  801637:	ff 75 0c             	pushl  0xc(%ebp)
  80163a:	ff 75 08             	pushl  0x8(%ebp)
  80163d:	6a 12                	push   $0x12
  80163f:	e8 4e fa ff ff       	call   801092 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
	return;
  801647:	90                   	nop
}
  801648:	c9                   	leave  
  801649:	c3                   	ret    

0080164a <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80164d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801650:	8b 45 08             	mov    0x8(%ebp),%eax
  801653:	6a 00                	push   $0x0
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	52                   	push   %edx
  80165a:	50                   	push   %eax
  80165b:	6a 2a                	push   $0x2a
  80165d:	e8 30 fa ff ff       	call   801092 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
	return;
  801665:	90                   	nop
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	6a 00                	push   $0x0
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	50                   	push   %eax
  801677:	6a 2b                	push   $0x2b
  801679:	e8 14 fa ff ff       	call   801092 <syscall>
  80167e:	83 c4 18             	add    $0x18,%esp
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	6a 2c                	push   $0x2c
  801694:	e8 f9 f9 ff ff       	call   801092 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
	return;
  80169c:	90                   	nop
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016a2:	6a 00                	push   $0x0
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	6a 2d                	push   $0x2d
  8016b0:	e8 dd f9 ff ff       	call   801092 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
	return;
  8016b8:	90                   	nop
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	6a 00                	push   $0x0
  8016c9:	50                   	push   %eax
  8016ca:	6a 2f                	push   $0x2f
  8016cc:	e8 c1 f9 ff ff       	call   801092 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 00                	push   $0x0
  8016e6:	52                   	push   %edx
  8016e7:	50                   	push   %eax
  8016e8:	6a 30                	push   $0x30
  8016ea:	e8 a3 f9 ff ff       	call   801092 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
	return;
  8016f2:	90                   	nop
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 00                	push   $0x0
  8016ff:	6a 00                	push   $0x0
  801701:	6a 00                	push   $0x0
  801703:	50                   	push   %eax
  801704:	6a 31                	push   $0x31
  801706:	e8 87 f9 ff ff       	call   801092 <syscall>
  80170b:	83 c4 18             	add    $0x18,%esp
	return;
  80170e:	90                   	nop
}
  80170f:	c9                   	leave  
  801710:	c3                   	ret    

00801711 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801711:	55                   	push   %ebp
  801712:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	6a 00                	push   $0x0
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	52                   	push   %edx
  801721:	50                   	push   %eax
  801722:	6a 2e                	push   $0x2e
  801724:	e8 69 f9 ff ff       	call   801092 <syscall>
  801729:	83 c4 18             	add    $0x18,%esp
    return;
  80172c:	90                   	nop
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801735:	8d 45 10             	lea    0x10(%ebp),%eax
  801738:	83 c0 04             	add    $0x4,%eax
  80173b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80173e:	a1 28 30 80 00       	mov    0x803028,%eax
  801743:	85 c0                	test   %eax,%eax
  801745:	74 16                	je     80175d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801747:	a1 28 30 80 00       	mov    0x803028,%eax
  80174c:	83 ec 08             	sub    $0x8,%esp
  80174f:	50                   	push   %eax
  801750:	68 78 20 80 00       	push   $0x802078
  801755:	e8 9e eb ff ff       	call   8002f8 <cprintf>
  80175a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80175d:	a1 04 30 80 00       	mov    0x803004,%eax
  801762:	ff 75 0c             	pushl  0xc(%ebp)
  801765:	ff 75 08             	pushl  0x8(%ebp)
  801768:	50                   	push   %eax
  801769:	68 7d 20 80 00       	push   $0x80207d
  80176e:	e8 85 eb ff ff       	call   8002f8 <cprintf>
  801773:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801776:	8b 45 10             	mov    0x10(%ebp),%eax
  801779:	83 ec 08             	sub    $0x8,%esp
  80177c:	ff 75 f4             	pushl  -0xc(%ebp)
  80177f:	50                   	push   %eax
  801780:	e8 08 eb ff ff       	call   80028d <vcprintf>
  801785:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801788:	83 ec 08             	sub    $0x8,%esp
  80178b:	6a 00                	push   $0x0
  80178d:	68 99 20 80 00       	push   $0x802099
  801792:	e8 f6 ea ff ff       	call   80028d <vcprintf>
  801797:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80179a:	e8 77 ea ff ff       	call   800216 <exit>

	// should not return here
	while (1) ;
  80179f:	eb fe                	jmp    80179f <_panic+0x70>

008017a1 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8017a7:	a1 08 30 80 00       	mov    0x803008,%eax
  8017ac:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8017b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b5:	39 c2                	cmp    %eax,%edx
  8017b7:	74 14                	je     8017cd <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	68 9c 20 80 00       	push   $0x80209c
  8017c1:	6a 26                	push   $0x26
  8017c3:	68 e8 20 80 00       	push   $0x8020e8
  8017c8:	e8 62 ff ff ff       	call   80172f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8017cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8017d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8017db:	e9 c5 00 00 00       	jmp    8018a5 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8017e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ed:	01 d0                	add    %edx,%eax
  8017ef:	8b 00                	mov    (%eax),%eax
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	75 08                	jne    8017fd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8017f5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8017f8:	e9 a5 00 00 00       	jmp    8018a2 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8017fd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801804:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80180b:	eb 69                	jmp    801876 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80180d:	a1 08 30 80 00       	mov    0x803008,%eax
  801812:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801818:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80181b:	89 d0                	mov    %edx,%eax
  80181d:	01 c0                	add    %eax,%eax
  80181f:	01 d0                	add    %edx,%eax
  801821:	c1 e0 03             	shl    $0x3,%eax
  801824:	01 c8                	add    %ecx,%eax
  801826:	8a 40 04             	mov    0x4(%eax),%al
  801829:	84 c0                	test   %al,%al
  80182b:	75 46                	jne    801873 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80182d:	a1 08 30 80 00       	mov    0x803008,%eax
  801832:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801838:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80183b:	89 d0                	mov    %edx,%eax
  80183d:	01 c0                	add    %eax,%eax
  80183f:	01 d0                	add    %edx,%eax
  801841:	c1 e0 03             	shl    $0x3,%eax
  801844:	01 c8                	add    %ecx,%eax
  801846:	8b 00                	mov    (%eax),%eax
  801848:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80184b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80184e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801853:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801855:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801858:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	01 c8                	add    %ecx,%eax
  801864:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801866:	39 c2                	cmp    %eax,%edx
  801868:	75 09                	jne    801873 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80186a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801871:	eb 15                	jmp    801888 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801873:	ff 45 e8             	incl   -0x18(%ebp)
  801876:	a1 08 30 80 00       	mov    0x803008,%eax
  80187b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801881:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801884:	39 c2                	cmp    %eax,%edx
  801886:	77 85                	ja     80180d <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801888:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80188c:	75 14                	jne    8018a2 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80188e:	83 ec 04             	sub    $0x4,%esp
  801891:	68 f4 20 80 00       	push   $0x8020f4
  801896:	6a 3a                	push   $0x3a
  801898:	68 e8 20 80 00       	push   $0x8020e8
  80189d:	e8 8d fe ff ff       	call   80172f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8018a2:	ff 45 f0             	incl   -0x10(%ebp)
  8018a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8018ab:	0f 8c 2f ff ff ff    	jl     8017e0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8018b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018bf:	eb 26                	jmp    8018e7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8018c1:	a1 08 30 80 00       	mov    0x803008,%eax
  8018c6:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8018cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018cf:	89 d0                	mov    %edx,%eax
  8018d1:	01 c0                	add    %eax,%eax
  8018d3:	01 d0                	add    %edx,%eax
  8018d5:	c1 e0 03             	shl    $0x3,%eax
  8018d8:	01 c8                	add    %ecx,%eax
  8018da:	8a 40 04             	mov    0x4(%eax),%al
  8018dd:	3c 01                	cmp    $0x1,%al
  8018df:	75 03                	jne    8018e4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8018e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018e4:	ff 45 e0             	incl   -0x20(%ebp)
  8018e7:	a1 08 30 80 00       	mov    0x803008,%eax
  8018ec:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8018f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f5:	39 c2                	cmp    %eax,%edx
  8018f7:	77 c8                	ja     8018c1 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8018f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018ff:	74 14                	je     801915 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 48 21 80 00       	push   $0x802148
  801909:	6a 44                	push   $0x44
  80190b:	68 e8 20 80 00       	push   $0x8020e8
  801910:	e8 1a fe ff ff       	call   80172f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <__udivdi3>:
  801918:	55                   	push   %ebp
  801919:	57                   	push   %edi
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	83 ec 1c             	sub    $0x1c,%esp
  80191f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801923:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801927:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80192b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192f:	89 ca                	mov    %ecx,%edx
  801931:	89 f8                	mov    %edi,%eax
  801933:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801937:	85 f6                	test   %esi,%esi
  801939:	75 2d                	jne    801968 <__udivdi3+0x50>
  80193b:	39 cf                	cmp    %ecx,%edi
  80193d:	77 65                	ja     8019a4 <__udivdi3+0x8c>
  80193f:	89 fd                	mov    %edi,%ebp
  801941:	85 ff                	test   %edi,%edi
  801943:	75 0b                	jne    801950 <__udivdi3+0x38>
  801945:	b8 01 00 00 00       	mov    $0x1,%eax
  80194a:	31 d2                	xor    %edx,%edx
  80194c:	f7 f7                	div    %edi
  80194e:	89 c5                	mov    %eax,%ebp
  801950:	31 d2                	xor    %edx,%edx
  801952:	89 c8                	mov    %ecx,%eax
  801954:	f7 f5                	div    %ebp
  801956:	89 c1                	mov    %eax,%ecx
  801958:	89 d8                	mov    %ebx,%eax
  80195a:	f7 f5                	div    %ebp
  80195c:	89 cf                	mov    %ecx,%edi
  80195e:	89 fa                	mov    %edi,%edx
  801960:	83 c4 1c             	add    $0x1c,%esp
  801963:	5b                   	pop    %ebx
  801964:	5e                   	pop    %esi
  801965:	5f                   	pop    %edi
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    
  801968:	39 ce                	cmp    %ecx,%esi
  80196a:	77 28                	ja     801994 <__udivdi3+0x7c>
  80196c:	0f bd fe             	bsr    %esi,%edi
  80196f:	83 f7 1f             	xor    $0x1f,%edi
  801972:	75 40                	jne    8019b4 <__udivdi3+0x9c>
  801974:	39 ce                	cmp    %ecx,%esi
  801976:	72 0a                	jb     801982 <__udivdi3+0x6a>
  801978:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80197c:	0f 87 9e 00 00 00    	ja     801a20 <__udivdi3+0x108>
  801982:	b8 01 00 00 00       	mov    $0x1,%eax
  801987:	89 fa                	mov    %edi,%edx
  801989:	83 c4 1c             	add    $0x1c,%esp
  80198c:	5b                   	pop    %ebx
  80198d:	5e                   	pop    %esi
  80198e:	5f                   	pop    %edi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    
  801991:	8d 76 00             	lea    0x0(%esi),%esi
  801994:	31 ff                	xor    %edi,%edi
  801996:	31 c0                	xor    %eax,%eax
  801998:	89 fa                	mov    %edi,%edx
  80199a:	83 c4 1c             	add    $0x1c,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5f                   	pop    %edi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    
  8019a2:	66 90                	xchg   %ax,%ax
  8019a4:	89 d8                	mov    %ebx,%eax
  8019a6:	f7 f7                	div    %edi
  8019a8:	31 ff                	xor    %edi,%edi
  8019aa:	89 fa                	mov    %edi,%edx
  8019ac:	83 c4 1c             	add    $0x1c,%esp
  8019af:	5b                   	pop    %ebx
  8019b0:	5e                   	pop    %esi
  8019b1:	5f                   	pop    %edi
  8019b2:	5d                   	pop    %ebp
  8019b3:	c3                   	ret    
  8019b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8019b9:	89 eb                	mov    %ebp,%ebx
  8019bb:	29 fb                	sub    %edi,%ebx
  8019bd:	89 f9                	mov    %edi,%ecx
  8019bf:	d3 e6                	shl    %cl,%esi
  8019c1:	89 c5                	mov    %eax,%ebp
  8019c3:	88 d9                	mov    %bl,%cl
  8019c5:	d3 ed                	shr    %cl,%ebp
  8019c7:	89 e9                	mov    %ebp,%ecx
  8019c9:	09 f1                	or     %esi,%ecx
  8019cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019cf:	89 f9                	mov    %edi,%ecx
  8019d1:	d3 e0                	shl    %cl,%eax
  8019d3:	89 c5                	mov    %eax,%ebp
  8019d5:	89 d6                	mov    %edx,%esi
  8019d7:	88 d9                	mov    %bl,%cl
  8019d9:	d3 ee                	shr    %cl,%esi
  8019db:	89 f9                	mov    %edi,%ecx
  8019dd:	d3 e2                	shl    %cl,%edx
  8019df:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019e3:	88 d9                	mov    %bl,%cl
  8019e5:	d3 e8                	shr    %cl,%eax
  8019e7:	09 c2                	or     %eax,%edx
  8019e9:	89 d0                	mov    %edx,%eax
  8019eb:	89 f2                	mov    %esi,%edx
  8019ed:	f7 74 24 0c          	divl   0xc(%esp)
  8019f1:	89 d6                	mov    %edx,%esi
  8019f3:	89 c3                	mov    %eax,%ebx
  8019f5:	f7 e5                	mul    %ebp
  8019f7:	39 d6                	cmp    %edx,%esi
  8019f9:	72 19                	jb     801a14 <__udivdi3+0xfc>
  8019fb:	74 0b                	je     801a08 <__udivdi3+0xf0>
  8019fd:	89 d8                	mov    %ebx,%eax
  8019ff:	31 ff                	xor    %edi,%edi
  801a01:	e9 58 ff ff ff       	jmp    80195e <__udivdi3+0x46>
  801a06:	66 90                	xchg   %ax,%ax
  801a08:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a0c:	89 f9                	mov    %edi,%ecx
  801a0e:	d3 e2                	shl    %cl,%edx
  801a10:	39 c2                	cmp    %eax,%edx
  801a12:	73 e9                	jae    8019fd <__udivdi3+0xe5>
  801a14:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a17:	31 ff                	xor    %edi,%edi
  801a19:	e9 40 ff ff ff       	jmp    80195e <__udivdi3+0x46>
  801a1e:	66 90                	xchg   %ax,%ax
  801a20:	31 c0                	xor    %eax,%eax
  801a22:	e9 37 ff ff ff       	jmp    80195e <__udivdi3+0x46>
  801a27:	90                   	nop

00801a28 <__umoddi3>:
  801a28:	55                   	push   %ebp
  801a29:	57                   	push   %edi
  801a2a:	56                   	push   %esi
  801a2b:	53                   	push   %ebx
  801a2c:	83 ec 1c             	sub    $0x1c,%esp
  801a2f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a33:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a37:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a3b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a3f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a43:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a47:	89 f3                	mov    %esi,%ebx
  801a49:	89 fa                	mov    %edi,%edx
  801a4b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a4f:	89 34 24             	mov    %esi,(%esp)
  801a52:	85 c0                	test   %eax,%eax
  801a54:	75 1a                	jne    801a70 <__umoddi3+0x48>
  801a56:	39 f7                	cmp    %esi,%edi
  801a58:	0f 86 a2 00 00 00    	jbe    801b00 <__umoddi3+0xd8>
  801a5e:	89 c8                	mov    %ecx,%eax
  801a60:	89 f2                	mov    %esi,%edx
  801a62:	f7 f7                	div    %edi
  801a64:	89 d0                	mov    %edx,%eax
  801a66:	31 d2                	xor    %edx,%edx
  801a68:	83 c4 1c             	add    $0x1c,%esp
  801a6b:	5b                   	pop    %ebx
  801a6c:	5e                   	pop    %esi
  801a6d:	5f                   	pop    %edi
  801a6e:	5d                   	pop    %ebp
  801a6f:	c3                   	ret    
  801a70:	39 f0                	cmp    %esi,%eax
  801a72:	0f 87 ac 00 00 00    	ja     801b24 <__umoddi3+0xfc>
  801a78:	0f bd e8             	bsr    %eax,%ebp
  801a7b:	83 f5 1f             	xor    $0x1f,%ebp
  801a7e:	0f 84 ac 00 00 00    	je     801b30 <__umoddi3+0x108>
  801a84:	bf 20 00 00 00       	mov    $0x20,%edi
  801a89:	29 ef                	sub    %ebp,%edi
  801a8b:	89 fe                	mov    %edi,%esi
  801a8d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a91:	89 e9                	mov    %ebp,%ecx
  801a93:	d3 e0                	shl    %cl,%eax
  801a95:	89 d7                	mov    %edx,%edi
  801a97:	89 f1                	mov    %esi,%ecx
  801a99:	d3 ef                	shr    %cl,%edi
  801a9b:	09 c7                	or     %eax,%edi
  801a9d:	89 e9                	mov    %ebp,%ecx
  801a9f:	d3 e2                	shl    %cl,%edx
  801aa1:	89 14 24             	mov    %edx,(%esp)
  801aa4:	89 d8                	mov    %ebx,%eax
  801aa6:	d3 e0                	shl    %cl,%eax
  801aa8:	89 c2                	mov    %eax,%edx
  801aaa:	8b 44 24 08          	mov    0x8(%esp),%eax
  801aae:	d3 e0                	shl    %cl,%eax
  801ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab4:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ab8:	89 f1                	mov    %esi,%ecx
  801aba:	d3 e8                	shr    %cl,%eax
  801abc:	09 d0                	or     %edx,%eax
  801abe:	d3 eb                	shr    %cl,%ebx
  801ac0:	89 da                	mov    %ebx,%edx
  801ac2:	f7 f7                	div    %edi
  801ac4:	89 d3                	mov    %edx,%ebx
  801ac6:	f7 24 24             	mull   (%esp)
  801ac9:	89 c6                	mov    %eax,%esi
  801acb:	89 d1                	mov    %edx,%ecx
  801acd:	39 d3                	cmp    %edx,%ebx
  801acf:	0f 82 87 00 00 00    	jb     801b5c <__umoddi3+0x134>
  801ad5:	0f 84 91 00 00 00    	je     801b6c <__umoddi3+0x144>
  801adb:	8b 54 24 04          	mov    0x4(%esp),%edx
  801adf:	29 f2                	sub    %esi,%edx
  801ae1:	19 cb                	sbb    %ecx,%ebx
  801ae3:	89 d8                	mov    %ebx,%eax
  801ae5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ae9:	d3 e0                	shl    %cl,%eax
  801aeb:	89 e9                	mov    %ebp,%ecx
  801aed:	d3 ea                	shr    %cl,%edx
  801aef:	09 d0                	or     %edx,%eax
  801af1:	89 e9                	mov    %ebp,%ecx
  801af3:	d3 eb                	shr    %cl,%ebx
  801af5:	89 da                	mov    %ebx,%edx
  801af7:	83 c4 1c             	add    $0x1c,%esp
  801afa:	5b                   	pop    %ebx
  801afb:	5e                   	pop    %esi
  801afc:	5f                   	pop    %edi
  801afd:	5d                   	pop    %ebp
  801afe:	c3                   	ret    
  801aff:	90                   	nop
  801b00:	89 fd                	mov    %edi,%ebp
  801b02:	85 ff                	test   %edi,%edi
  801b04:	75 0b                	jne    801b11 <__umoddi3+0xe9>
  801b06:	b8 01 00 00 00       	mov    $0x1,%eax
  801b0b:	31 d2                	xor    %edx,%edx
  801b0d:	f7 f7                	div    %edi
  801b0f:	89 c5                	mov    %eax,%ebp
  801b11:	89 f0                	mov    %esi,%eax
  801b13:	31 d2                	xor    %edx,%edx
  801b15:	f7 f5                	div    %ebp
  801b17:	89 c8                	mov    %ecx,%eax
  801b19:	f7 f5                	div    %ebp
  801b1b:	89 d0                	mov    %edx,%eax
  801b1d:	e9 44 ff ff ff       	jmp    801a66 <__umoddi3+0x3e>
  801b22:	66 90                	xchg   %ax,%ax
  801b24:	89 c8                	mov    %ecx,%eax
  801b26:	89 f2                	mov    %esi,%edx
  801b28:	83 c4 1c             	add    $0x1c,%esp
  801b2b:	5b                   	pop    %ebx
  801b2c:	5e                   	pop    %esi
  801b2d:	5f                   	pop    %edi
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    
  801b30:	3b 04 24             	cmp    (%esp),%eax
  801b33:	72 06                	jb     801b3b <__umoddi3+0x113>
  801b35:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b39:	77 0f                	ja     801b4a <__umoddi3+0x122>
  801b3b:	89 f2                	mov    %esi,%edx
  801b3d:	29 f9                	sub    %edi,%ecx
  801b3f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b43:	89 14 24             	mov    %edx,(%esp)
  801b46:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b4a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b4e:	8b 14 24             	mov    (%esp),%edx
  801b51:	83 c4 1c             	add    $0x1c,%esp
  801b54:	5b                   	pop    %ebx
  801b55:	5e                   	pop    %esi
  801b56:	5f                   	pop    %edi
  801b57:	5d                   	pop    %ebp
  801b58:	c3                   	ret    
  801b59:	8d 76 00             	lea    0x0(%esi),%esi
  801b5c:	2b 04 24             	sub    (%esp),%eax
  801b5f:	19 fa                	sbb    %edi,%edx
  801b61:	89 d1                	mov    %edx,%ecx
  801b63:	89 c6                	mov    %eax,%esi
  801b65:	e9 71 ff ff ff       	jmp    801adb <__umoddi3+0xb3>
  801b6a:	66 90                	xchg   %ax,%ax
  801b6c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b70:	72 ea                	jb     801b5c <__umoddi3+0x134>
  801b72:	89 d9                	mov    %ebx,%ecx
  801b74:	e9 62 ff ff ff       	jmp    801adb <__umoddi3+0xb3>
