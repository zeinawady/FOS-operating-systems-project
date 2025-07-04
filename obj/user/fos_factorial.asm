
obj/user/fos_factorial:     file format elf32-i386


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
  800031:	e8 be 00 00 00       	call   8000f4 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 factorial(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];
	atomic_readline("Please enter a number:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 e0 1d 80 00       	push   $0x801de0
  800057:	e8 44 0a 00 00       	call   800aa0 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 97 0e 00 00       	call   800f09 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = factorial(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <factorial>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("Factorial %d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 f7 1d 80 00       	push   $0x801df7
  80009a:	e8 9b 02 00 00       	call   80033a <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp
	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <factorial>:


int64 factorial(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	57                   	push   %edi
  8000a9:	56                   	push   %esi
  8000aa:	53                   	push   %ebx
  8000ab:	83 ec 0c             	sub    $0xc,%esp
	if (n <= 1)
  8000ae:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000b2:	7f 0c                	jg     8000c0 <factorial+0x1b>
		return 1 ;
  8000b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	eb 2c                	jmp    8000ec <factorial+0x47>
	return n * factorial(n-1) ;
  8000c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000c3:	89 c3                	mov    %eax,%ebx
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	c1 fe 1f             	sar    $0x1f,%esi
  8000ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8000cd:	48                   	dec    %eax
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	50                   	push   %eax
  8000d2:	e8 ce ff ff ff       	call   8000a5 <factorial>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 f7                	mov    %esi,%edi
  8000dc:	0f af f8             	imul   %eax,%edi
  8000df:	89 d1                	mov    %edx,%ecx
  8000e1:	0f af cb             	imul   %ebx,%ecx
  8000e4:	01 f9                	add    %edi,%ecx
  8000e6:	f7 e3                	mul    %ebx
  8000e8:	01 d1                	add    %edx,%ecx
  8000ea:	89 ca                	mov    %ecx,%edx
}
  8000ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000ef:	5b                   	pop    %ebx
  8000f0:	5e                   	pop    %esi
  8000f1:	5f                   	pop    %edi
  8000f2:	5d                   	pop    %ebp
  8000f3:	c3                   	ret    

008000f4 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000f4:	55                   	push   %ebp
  8000f5:	89 e5                	mov    %esp,%ebp
  8000f7:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000fa:	e8 99 14 00 00       	call   801598 <sys_getenvindex>
  8000ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800102:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	c1 e0 02             	shl    $0x2,%eax
  80010a:	01 d0                	add    %edx,%eax
  80010c:	c1 e0 03             	shl    $0x3,%eax
  80010f:	01 d0                	add    %edx,%eax
  800111:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800118:	01 d0                	add    %edx,%eax
  80011a:	c1 e0 02             	shl    $0x2,%eax
  80011d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800122:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800127:	a1 08 30 80 00       	mov    0x803008,%eax
  80012c:	8a 40 20             	mov    0x20(%eax),%al
  80012f:	84 c0                	test   %al,%al
  800131:	74 0d                	je     800140 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800133:	a1 08 30 80 00       	mov    0x803008,%eax
  800138:	83 c0 20             	add    $0x20,%eax
  80013b:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800140:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800144:	7e 0a                	jle    800150 <libmain+0x5c>
		binaryname = argv[0];
  800146:	8b 45 0c             	mov    0xc(%ebp),%eax
  800149:	8b 00                	mov    (%eax),%eax
  80014b:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800150:	83 ec 08             	sub    $0x8,%esp
  800153:	ff 75 0c             	pushl  0xc(%ebp)
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	e8 da fe ff ff       	call   800038 <_main>
  80015e:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800161:	a1 00 30 80 00       	mov    0x803000,%eax
  800166:	85 c0                	test   %eax,%eax
  800168:	0f 84 9f 00 00 00    	je     80020d <libmain+0x119>
	{
		sys_lock_cons();
  80016e:	e8 a9 11 00 00       	call   80131c <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	68 24 1e 80 00       	push   $0x801e24
  80017b:	e8 8d 01 00 00       	call   80030d <cprintf>
  800180:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800183:	a1 08 30 80 00       	mov    0x803008,%eax
  800188:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80018e:	a1 08 30 80 00       	mov    0x803008,%eax
  800193:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	52                   	push   %edx
  80019d:	50                   	push   %eax
  80019e:	68 4c 1e 80 00       	push   $0x801e4c
  8001a3:	e8 65 01 00 00       	call   80030d <cprintf>
  8001a8:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001ab:	a1 08 30 80 00       	mov    0x803008,%eax
  8001b0:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001b6:	a1 08 30 80 00       	mov    0x803008,%eax
  8001bb:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001c1:	a1 08 30 80 00       	mov    0x803008,%eax
  8001c6:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001cc:	51                   	push   %ecx
  8001cd:	52                   	push   %edx
  8001ce:	50                   	push   %eax
  8001cf:	68 74 1e 80 00       	push   $0x801e74
  8001d4:	e8 34 01 00 00       	call   80030d <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001dc:	a1 08 30 80 00       	mov    0x803008,%eax
  8001e1:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	50                   	push   %eax
  8001eb:	68 cc 1e 80 00       	push   $0x801ecc
  8001f0:	e8 18 01 00 00       	call   80030d <cprintf>
  8001f5:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001f8:	83 ec 0c             	sub    $0xc,%esp
  8001fb:	68 24 1e 80 00       	push   $0x801e24
  800200:	e8 08 01 00 00       	call   80030d <cprintf>
  800205:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800208:	e8 29 11 00 00       	call   801336 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80020d:	e8 19 00 00 00       	call   80022b <exit>
}
  800212:	90                   	nop
  800213:	c9                   	leave  
  800214:	c3                   	ret    

00800215 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80021b:	83 ec 0c             	sub    $0xc,%esp
  80021e:	6a 00                	push   $0x0
  800220:	e8 3f 13 00 00       	call   801564 <sys_destroy_env>
  800225:	83 c4 10             	add    $0x10,%esp
}
  800228:	90                   	nop
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <exit>:

void
exit(void)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800231:	e8 94 13 00 00       	call   8015ca <sys_exit_env>
}
  800236:	90                   	nop
  800237:	c9                   	leave  
  800238:	c3                   	ret    

00800239 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800239:	55                   	push   %ebp
  80023a:	89 e5                	mov    %esp,%ebp
  80023c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	8d 48 01             	lea    0x1(%eax),%ecx
  800247:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024a:	89 0a                	mov    %ecx,(%edx)
  80024c:	8b 55 08             	mov    0x8(%ebp),%edx
  80024f:	88 d1                	mov    %dl,%cl
  800251:	8b 55 0c             	mov    0xc(%ebp),%edx
  800254:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800258:	8b 45 0c             	mov    0xc(%ebp),%eax
  80025b:	8b 00                	mov    (%eax),%eax
  80025d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800262:	75 2c                	jne    800290 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800264:	a0 0c 30 80 00       	mov    0x80300c,%al
  800269:	0f b6 c0             	movzbl %al,%eax
  80026c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026f:	8b 12                	mov    (%edx),%edx
  800271:	89 d1                	mov    %edx,%ecx
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	83 c2 08             	add    $0x8,%edx
  800279:	83 ec 04             	sub    $0x4,%esp
  80027c:	50                   	push   %eax
  80027d:	51                   	push   %ecx
  80027e:	52                   	push   %edx
  80027f:	e8 56 10 00 00       	call   8012da <sys_cputs>
  800284:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800290:	8b 45 0c             	mov    0xc(%ebp),%eax
  800293:	8b 40 04             	mov    0x4(%eax),%eax
  800296:	8d 50 01             	lea    0x1(%eax),%edx
  800299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80029f:	90                   	nop
  8002a0:	c9                   	leave  
  8002a1:	c3                   	ret    

008002a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8002a2:	55                   	push   %ebp
  8002a3:	89 e5                	mov    %esp,%ebp
  8002a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b2:	00 00 00 
	b.cnt = 0;
  8002b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002bf:	ff 75 0c             	pushl  0xc(%ebp)
  8002c2:	ff 75 08             	pushl  0x8(%ebp)
  8002c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002cb:	50                   	push   %eax
  8002cc:	68 39 02 80 00       	push   $0x800239
  8002d1:	e8 11 02 00 00       	call   8004e7 <vprintfmt>
  8002d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002d9:	a0 0c 30 80 00       	mov    0x80300c,%al
  8002de:	0f b6 c0             	movzbl %al,%eax
  8002e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	52                   	push   %edx
  8002ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002f2:	83 c0 08             	add    $0x8,%eax
  8002f5:	50                   	push   %eax
  8002f6:	e8 df 0f 00 00       	call   8012da <sys_cputs>
  8002fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002fe:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800305:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80030b:	c9                   	leave  
  80030c:	c3                   	ret    

0080030d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800313:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  80031a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80031d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800320:	8b 45 08             	mov    0x8(%ebp),%eax
  800323:	83 ec 08             	sub    $0x8,%esp
  800326:	ff 75 f4             	pushl  -0xc(%ebp)
  800329:	50                   	push   %eax
  80032a:	e8 73 ff ff ff       	call   8002a2 <vcprintf>
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800335:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800338:	c9                   	leave  
  800339:	c3                   	ret    

0080033a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800340:	e8 d7 0f 00 00       	call   80131c <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800345:	8d 45 0c             	lea    0xc(%ebp),%eax
  800348:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80034b:	8b 45 08             	mov    0x8(%ebp),%eax
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	ff 75 f4             	pushl  -0xc(%ebp)
  800354:	50                   	push   %eax
  800355:	e8 48 ff ff ff       	call   8002a2 <vcprintf>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800360:	e8 d1 0f 00 00       	call   801336 <sys_unlock_cons>
	return cnt;
  800365:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	53                   	push   %ebx
  80036e:	83 ec 14             	sub    $0x14,%esp
  800371:	8b 45 10             	mov    0x10(%ebp),%eax
  800374:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800377:	8b 45 14             	mov    0x14(%ebp),%eax
  80037a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80037d:	8b 45 18             	mov    0x18(%ebp),%eax
  800380:	ba 00 00 00 00       	mov    $0x0,%edx
  800385:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800388:	77 55                	ja     8003df <printnum+0x75>
  80038a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80038d:	72 05                	jb     800394 <printnum+0x2a>
  80038f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800392:	77 4b                	ja     8003df <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800394:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800397:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80039a:	8b 45 18             	mov    0x18(%ebp),%eax
  80039d:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a2:	52                   	push   %edx
  8003a3:	50                   	push   %eax
  8003a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a7:	ff 75 f0             	pushl  -0x10(%ebp)
  8003aa:	e8 c5 17 00 00       	call   801b74 <__udivdi3>
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	83 ec 04             	sub    $0x4,%esp
  8003b5:	ff 75 20             	pushl  0x20(%ebp)
  8003b8:	53                   	push   %ebx
  8003b9:	ff 75 18             	pushl  0x18(%ebp)
  8003bc:	52                   	push   %edx
  8003bd:	50                   	push   %eax
  8003be:	ff 75 0c             	pushl  0xc(%ebp)
  8003c1:	ff 75 08             	pushl  0x8(%ebp)
  8003c4:	e8 a1 ff ff ff       	call   80036a <printnum>
  8003c9:	83 c4 20             	add    $0x20,%esp
  8003cc:	eb 1a                	jmp    8003e8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 0c             	pushl  0xc(%ebp)
  8003d4:	ff 75 20             	pushl  0x20(%ebp)
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	ff d0                	call   *%eax
  8003dc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003df:	ff 4d 1c             	decl   0x1c(%ebp)
  8003e2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003e6:	7f e6                	jg     8003ce <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003f6:	53                   	push   %ebx
  8003f7:	51                   	push   %ecx
  8003f8:	52                   	push   %edx
  8003f9:	50                   	push   %eax
  8003fa:	e8 85 18 00 00       	call   801c84 <__umoddi3>
  8003ff:	83 c4 10             	add    $0x10,%esp
  800402:	05 f4 20 80 00       	add    $0x8020f4,%eax
  800407:	8a 00                	mov    (%eax),%al
  800409:	0f be c0             	movsbl %al,%eax
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	ff 75 0c             	pushl  0xc(%ebp)
  800412:	50                   	push   %eax
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	ff d0                	call   *%eax
  800418:	83 c4 10             	add    $0x10,%esp
}
  80041b:	90                   	nop
  80041c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80041f:	c9                   	leave  
  800420:	c3                   	ret    

00800421 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800424:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800428:	7e 1c                	jle    800446 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	8d 50 08             	lea    0x8(%eax),%edx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 10                	mov    %edx,(%eax)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	83 e8 08             	sub    $0x8,%eax
  80043f:	8b 50 04             	mov    0x4(%eax),%edx
  800442:	8b 00                	mov    (%eax),%eax
  800444:	eb 40                	jmp    800486 <getuint+0x65>
	else if (lflag)
  800446:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80044a:	74 1e                	je     80046a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	8d 50 04             	lea    0x4(%eax),%edx
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	89 10                	mov    %edx,(%eax)
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	83 e8 04             	sub    $0x4,%eax
  800461:	8b 00                	mov    (%eax),%eax
  800463:	ba 00 00 00 00       	mov    $0x0,%edx
  800468:	eb 1c                	jmp    800486 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	8b 00                	mov    (%eax),%eax
  80046f:	8d 50 04             	lea    0x4(%eax),%edx
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	89 10                	mov    %edx,(%eax)
  800477:	8b 45 08             	mov    0x8(%ebp),%eax
  80047a:	8b 00                	mov    (%eax),%eax
  80047c:	83 e8 04             	sub    $0x4,%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800486:	5d                   	pop    %ebp
  800487:	c3                   	ret    

00800488 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800488:	55                   	push   %ebp
  800489:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80048b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80048f:	7e 1c                	jle    8004ad <getint+0x25>
		return va_arg(*ap, long long);
  800491:	8b 45 08             	mov    0x8(%ebp),%eax
  800494:	8b 00                	mov    (%eax),%eax
  800496:	8d 50 08             	lea    0x8(%eax),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	89 10                	mov    %edx,(%eax)
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	8b 00                	mov    (%eax),%eax
  8004a3:	83 e8 08             	sub    $0x8,%eax
  8004a6:	8b 50 04             	mov    0x4(%eax),%edx
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	eb 38                	jmp    8004e5 <getint+0x5d>
	else if (lflag)
  8004ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b1:	74 1a                	je     8004cd <getint+0x45>
		return va_arg(*ap, long);
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	8b 00                	mov    (%eax),%eax
  8004b8:	8d 50 04             	lea    0x4(%eax),%edx
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	89 10                	mov    %edx,(%eax)
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	8b 00                	mov    (%eax),%eax
  8004c5:	83 e8 04             	sub    $0x4,%eax
  8004c8:	8b 00                	mov    (%eax),%eax
  8004ca:	99                   	cltd   
  8004cb:	eb 18                	jmp    8004e5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	8d 50 04             	lea    0x4(%eax),%edx
  8004d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d8:	89 10                	mov    %edx,(%eax)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	8b 00                	mov    (%eax),%eax
  8004df:	83 e8 04             	sub    $0x4,%eax
  8004e2:	8b 00                	mov    (%eax),%eax
  8004e4:	99                   	cltd   
}
  8004e5:	5d                   	pop    %ebp
  8004e6:	c3                   	ret    

008004e7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	56                   	push   %esi
  8004eb:	53                   	push   %ebx
  8004ec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ef:	eb 17                	jmp    800508 <vprintfmt+0x21>
			if (ch == '\0')
  8004f1:	85 db                	test   %ebx,%ebx
  8004f3:	0f 84 c1 03 00 00    	je     8008ba <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004f9:	83 ec 08             	sub    $0x8,%esp
  8004fc:	ff 75 0c             	pushl  0xc(%ebp)
  8004ff:	53                   	push   %ebx
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	ff d0                	call   *%eax
  800505:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800508:	8b 45 10             	mov    0x10(%ebp),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	89 55 10             	mov    %edx,0x10(%ebp)
  800511:	8a 00                	mov    (%eax),%al
  800513:	0f b6 d8             	movzbl %al,%ebx
  800516:	83 fb 25             	cmp    $0x25,%ebx
  800519:	75 d6                	jne    8004f1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80051b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80051f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800526:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80052d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800534:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80053b:	8b 45 10             	mov    0x10(%ebp),%eax
  80053e:	8d 50 01             	lea    0x1(%eax),%edx
  800541:	89 55 10             	mov    %edx,0x10(%ebp)
  800544:	8a 00                	mov    (%eax),%al
  800546:	0f b6 d8             	movzbl %al,%ebx
  800549:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80054c:	83 f8 5b             	cmp    $0x5b,%eax
  80054f:	0f 87 3d 03 00 00    	ja     800892 <vprintfmt+0x3ab>
  800555:	8b 04 85 18 21 80 00 	mov    0x802118(,%eax,4),%eax
  80055c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80055e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800562:	eb d7                	jmp    80053b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800564:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800568:	eb d1                	jmp    80053b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80056a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800571:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800574:	89 d0                	mov    %edx,%eax
  800576:	c1 e0 02             	shl    $0x2,%eax
  800579:	01 d0                	add    %edx,%eax
  80057b:	01 c0                	add    %eax,%eax
  80057d:	01 d8                	add    %ebx,%eax
  80057f:	83 e8 30             	sub    $0x30,%eax
  800582:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800585:	8b 45 10             	mov    0x10(%ebp),%eax
  800588:	8a 00                	mov    (%eax),%al
  80058a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80058d:	83 fb 2f             	cmp    $0x2f,%ebx
  800590:	7e 3e                	jle    8005d0 <vprintfmt+0xe9>
  800592:	83 fb 39             	cmp    $0x39,%ebx
  800595:	7f 39                	jg     8005d0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800597:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80059a:	eb d5                	jmp    800571 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	83 c0 04             	add    $0x4,%eax
  8005a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a8:	83 e8 04             	sub    $0x4,%eax
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005b0:	eb 1f                	jmp    8005d1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b6:	79 83                	jns    80053b <vprintfmt+0x54>
				width = 0;
  8005b8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005bf:	e9 77 ff ff ff       	jmp    80053b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005cb:	e9 6b ff ff ff       	jmp    80053b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005d0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005d5:	0f 89 60 ff ff ff    	jns    80053b <vprintfmt+0x54>
				width = precision, precision = -1;
  8005db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005e8:	e9 4e ff ff ff       	jmp    80053b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ed:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005f0:	e9 46 ff ff ff       	jmp    80053b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	83 c0 04             	add    $0x4,%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	83 e8 04             	sub    $0x4,%eax
  800604:	8b 00                	mov    (%eax),%eax
  800606:	83 ec 08             	sub    $0x8,%esp
  800609:	ff 75 0c             	pushl  0xc(%ebp)
  80060c:	50                   	push   %eax
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	ff d0                	call   *%eax
  800612:	83 c4 10             	add    $0x10,%esp
			break;
  800615:	e9 9b 02 00 00       	jmp    8008b5 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80061a:	8b 45 14             	mov    0x14(%ebp),%eax
  80061d:	83 c0 04             	add    $0x4,%eax
  800620:	89 45 14             	mov    %eax,0x14(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	83 e8 04             	sub    $0x4,%eax
  800629:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80062b:	85 db                	test   %ebx,%ebx
  80062d:	79 02                	jns    800631 <vprintfmt+0x14a>
				err = -err;
  80062f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800631:	83 fb 64             	cmp    $0x64,%ebx
  800634:	7f 0b                	jg     800641 <vprintfmt+0x15a>
  800636:	8b 34 9d 60 1f 80 00 	mov    0x801f60(,%ebx,4),%esi
  80063d:	85 f6                	test   %esi,%esi
  80063f:	75 19                	jne    80065a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800641:	53                   	push   %ebx
  800642:	68 05 21 80 00       	push   $0x802105
  800647:	ff 75 0c             	pushl  0xc(%ebp)
  80064a:	ff 75 08             	pushl  0x8(%ebp)
  80064d:	e8 70 02 00 00       	call   8008c2 <printfmt>
  800652:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800655:	e9 5b 02 00 00       	jmp    8008b5 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80065a:	56                   	push   %esi
  80065b:	68 0e 21 80 00       	push   $0x80210e
  800660:	ff 75 0c             	pushl  0xc(%ebp)
  800663:	ff 75 08             	pushl  0x8(%ebp)
  800666:	e8 57 02 00 00       	call   8008c2 <printfmt>
  80066b:	83 c4 10             	add    $0x10,%esp
			break;
  80066e:	e9 42 02 00 00       	jmp    8008b5 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800673:	8b 45 14             	mov    0x14(%ebp),%eax
  800676:	83 c0 04             	add    $0x4,%eax
  800679:	89 45 14             	mov    %eax,0x14(%ebp)
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	83 e8 04             	sub    $0x4,%eax
  800682:	8b 30                	mov    (%eax),%esi
  800684:	85 f6                	test   %esi,%esi
  800686:	75 05                	jne    80068d <vprintfmt+0x1a6>
				p = "(null)";
  800688:	be 11 21 80 00       	mov    $0x802111,%esi
			if (width > 0 && padc != '-')
  80068d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800691:	7e 6d                	jle    800700 <vprintfmt+0x219>
  800693:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800697:	74 67                	je     800700 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800699:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	50                   	push   %eax
  8006a0:	56                   	push   %esi
  8006a1:	e8 26 05 00 00       	call   800bcc <strnlen>
  8006a6:	83 c4 10             	add    $0x10,%esp
  8006a9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006ac:	eb 16                	jmp    8006c4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006ae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	50                   	push   %eax
  8006b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bc:	ff d0                	call   *%eax
  8006be:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006c1:	ff 4d e4             	decl   -0x1c(%ebp)
  8006c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c8:	7f e4                	jg     8006ae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ca:	eb 34                	jmp    800700 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006cc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006d0:	74 1c                	je     8006ee <vprintfmt+0x207>
  8006d2:	83 fb 1f             	cmp    $0x1f,%ebx
  8006d5:	7e 05                	jle    8006dc <vprintfmt+0x1f5>
  8006d7:	83 fb 7e             	cmp    $0x7e,%ebx
  8006da:	7e 12                	jle    8006ee <vprintfmt+0x207>
					putch('?', putdat);
  8006dc:	83 ec 08             	sub    $0x8,%esp
  8006df:	ff 75 0c             	pushl  0xc(%ebp)
  8006e2:	6a 3f                	push   $0x3f
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	ff d0                	call   *%eax
  8006e9:	83 c4 10             	add    $0x10,%esp
  8006ec:	eb 0f                	jmp    8006fd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	53                   	push   %ebx
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	ff d0                	call   *%eax
  8006fa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006fd:	ff 4d e4             	decl   -0x1c(%ebp)
  800700:	89 f0                	mov    %esi,%eax
  800702:	8d 70 01             	lea    0x1(%eax),%esi
  800705:	8a 00                	mov    (%eax),%al
  800707:	0f be d8             	movsbl %al,%ebx
  80070a:	85 db                	test   %ebx,%ebx
  80070c:	74 24                	je     800732 <vprintfmt+0x24b>
  80070e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800712:	78 b8                	js     8006cc <vprintfmt+0x1e5>
  800714:	ff 4d e0             	decl   -0x20(%ebp)
  800717:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80071b:	79 af                	jns    8006cc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071d:	eb 13                	jmp    800732 <vprintfmt+0x24b>
				putch(' ', putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	6a 20                	push   $0x20
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e7                	jg     80071f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800738:	e9 78 01 00 00       	jmp    8008b5 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 e8             	pushl  -0x18(%ebp)
  800743:	8d 45 14             	lea    0x14(%ebp),%eax
  800746:	50                   	push   %eax
  800747:	e8 3c fd ff ff       	call   800488 <getint>
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800752:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075b:	85 d2                	test   %edx,%edx
  80075d:	79 23                	jns    800782 <vprintfmt+0x29b>
				putch('-', putdat);
  80075f:	83 ec 08             	sub    $0x8,%esp
  800762:	ff 75 0c             	pushl  0xc(%ebp)
  800765:	6a 2d                	push   $0x2d
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80076f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800772:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800775:	f7 d8                	neg    %eax
  800777:	83 d2 00             	adc    $0x0,%edx
  80077a:	f7 da                	neg    %edx
  80077c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800782:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800789:	e9 bc 00 00 00       	jmp    80084a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 e8             	pushl  -0x18(%ebp)
  800794:	8d 45 14             	lea    0x14(%ebp),%eax
  800797:	50                   	push   %eax
  800798:	e8 84 fc ff ff       	call   800421 <getuint>
  80079d:	83 c4 10             	add    $0x10,%esp
  8007a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8007a6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007ad:	e9 98 00 00 00       	jmp    80084a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	6a 58                	push   $0x58
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	ff 75 0c             	pushl  0xc(%ebp)
  8007c8:	6a 58                	push   $0x58
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	ff d0                	call   *%eax
  8007cf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	ff 75 0c             	pushl  0xc(%ebp)
  8007d8:	6a 58                	push   $0x58
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	ff d0                	call   *%eax
  8007df:	83 c4 10             	add    $0x10,%esp
			break;
  8007e2:	e9 ce 00 00 00       	jmp    8008b5 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 0c             	pushl  0xc(%ebp)
  8007ed:	6a 30                	push   $0x30
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	ff d0                	call   *%eax
  8007f4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007f7:	83 ec 08             	sub    $0x8,%esp
  8007fa:	ff 75 0c             	pushl  0xc(%ebp)
  8007fd:	6a 78                	push   $0x78
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	ff d0                	call   *%eax
  800804:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	83 c0 04             	add    $0x4,%eax
  80080d:	89 45 14             	mov    %eax,0x14(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	83 e8 04             	sub    $0x4,%eax
  800816:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800818:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800822:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800829:	eb 1f                	jmp    80084a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80082b:	83 ec 08             	sub    $0x8,%esp
  80082e:	ff 75 e8             	pushl  -0x18(%ebp)
  800831:	8d 45 14             	lea    0x14(%ebp),%eax
  800834:	50                   	push   %eax
  800835:	e8 e7 fb ff ff       	call   800421 <getuint>
  80083a:	83 c4 10             	add    $0x10,%esp
  80083d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800840:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800843:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80084a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80084e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800851:	83 ec 04             	sub    $0x4,%esp
  800854:	52                   	push   %edx
  800855:	ff 75 e4             	pushl  -0x1c(%ebp)
  800858:	50                   	push   %eax
  800859:	ff 75 f4             	pushl  -0xc(%ebp)
  80085c:	ff 75 f0             	pushl  -0x10(%ebp)
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 00 fb ff ff       	call   80036a <printnum>
  80086a:	83 c4 20             	add    $0x20,%esp
			break;
  80086d:	eb 46                	jmp    8008b5 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
			break;
  80087e:	eb 35                	jmp    8008b5 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800880:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800887:	eb 2c                	jmp    8008b5 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800889:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800890:	eb 23                	jmp    8008b5 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800892:	83 ec 08             	sub    $0x8,%esp
  800895:	ff 75 0c             	pushl  0xc(%ebp)
  800898:	6a 25                	push   $0x25
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	ff d0                	call   *%eax
  80089f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008a2:	ff 4d 10             	decl   0x10(%ebp)
  8008a5:	eb 03                	jmp    8008aa <vprintfmt+0x3c3>
  8008a7:	ff 4d 10             	decl   0x10(%ebp)
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	48                   	dec    %eax
  8008ae:	8a 00                	mov    (%eax),%al
  8008b0:	3c 25                	cmp    $0x25,%al
  8008b2:	75 f3                	jne    8008a7 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008b4:	90                   	nop
		}
	}
  8008b5:	e9 35 fc ff ff       	jmp    8004ef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008ba:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008be:	5b                   	pop    %ebx
  8008bf:	5e                   	pop    %esi
  8008c0:	5d                   	pop    %ebp
  8008c1:	c3                   	ret    

008008c2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008c2:	55                   	push   %ebp
  8008c3:	89 e5                	mov    %esp,%ebp
  8008c5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008c8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008cb:	83 c0 04             	add    $0x4,%eax
  8008ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d7:	50                   	push   %eax
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 04 fc ff ff       	call   8004e7 <vprintfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008e6:	90                   	nop
  8008e7:	c9                   	leave  
  8008e8:	c3                   	ret    

008008e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ef:	8b 40 08             	mov    0x8(%eax),%eax
  8008f2:	8d 50 01             	lea    0x1(%eax),%edx
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fe:	8b 10                	mov    (%eax),%edx
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	8b 40 04             	mov    0x4(%eax),%eax
  800906:	39 c2                	cmp    %eax,%edx
  800908:	73 12                	jae    80091c <sprintputch+0x33>
		*b->buf++ = ch;
  80090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	8d 48 01             	lea    0x1(%eax),%ecx
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
  800915:	89 0a                	mov    %ecx,(%edx)
  800917:	8b 55 08             	mov    0x8(%ebp),%edx
  80091a:	88 10                	mov    %dl,(%eax)
}
  80091c:	90                   	nop
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80092b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	01 d0                	add    %edx,%eax
  800936:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800939:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800940:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800944:	74 06                	je     80094c <vsnprintf+0x2d>
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	7f 07                	jg     800953 <vsnprintf+0x34>
		return -E_INVAL;
  80094c:	b8 03 00 00 00       	mov    $0x3,%eax
  800951:	eb 20                	jmp    800973 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800953:	ff 75 14             	pushl  0x14(%ebp)
  800956:	ff 75 10             	pushl  0x10(%ebp)
  800959:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80095c:	50                   	push   %eax
  80095d:	68 e9 08 80 00       	push   $0x8008e9
  800962:	e8 80 fb ff ff       	call   8004e7 <vprintfmt>
  800967:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80096a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80096d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800970:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800973:	c9                   	leave  
  800974:	c3                   	ret    

00800975 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80097b:	8d 45 10             	lea    0x10(%ebp),%eax
  80097e:	83 c0 04             	add    $0x4,%eax
  800981:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800984:	8b 45 10             	mov    0x10(%ebp),%eax
  800987:	ff 75 f4             	pushl  -0xc(%ebp)
  80098a:	50                   	push   %eax
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 89 ff ff ff       	call   80091f <vsnprintf>
  800996:	83 c4 10             	add    $0x10,%esp
  800999:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80099f:	c9                   	leave  
  8009a0:	c3                   	ret    

008009a1 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8009a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009ab:	74 13                	je     8009c0 <readline+0x1f>
		cprintf("%s", prompt);
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	ff 75 08             	pushl  0x8(%ebp)
  8009b3:	68 88 22 80 00       	push   $0x802288
  8009b8:	e8 50 f9 ff ff       	call   80030d <cprintf>
  8009bd:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009c7:	83 ec 0c             	sub    $0xc,%esp
  8009ca:	6a 00                	push   $0x0
  8009cc:	e8 ad 0f 00 00       	call   80197e <iscons>
  8009d1:	83 c4 10             	add    $0x10,%esp
  8009d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009d7:	e8 8f 0f 00 00       	call   80196b <getchar>
  8009dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009e3:	79 22                	jns    800a07 <readline+0x66>
			if (c != -E_EOF)
  8009e5:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009e9:	0f 84 ad 00 00 00    	je     800a9c <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 ec             	pushl  -0x14(%ebp)
  8009f5:	68 8b 22 80 00       	push   $0x80228b
  8009fa:	e8 0e f9 ff ff       	call   80030d <cprintf>
  8009ff:	83 c4 10             	add    $0x10,%esp
			break;
  800a02:	e9 95 00 00 00       	jmp    800a9c <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a07:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a0b:	7e 34                	jle    800a41 <readline+0xa0>
  800a0d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a14:	7f 2b                	jg     800a41 <readline+0xa0>
			if (echoing)
  800a16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a1a:	74 0e                	je     800a2a <readline+0x89>
				cputchar(c);
  800a1c:	83 ec 0c             	sub    $0xc,%esp
  800a1f:	ff 75 ec             	pushl  -0x14(%ebp)
  800a22:	e8 25 0f 00 00       	call   80194c <cputchar>
  800a27:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a33:	89 c2                	mov    %eax,%edx
  800a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a38:	01 d0                	add    %edx,%eax
  800a3a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a3d:	88 10                	mov    %dl,(%eax)
  800a3f:	eb 56                	jmp    800a97 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a41:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a45:	75 1f                	jne    800a66 <readline+0xc5>
  800a47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a4b:	7e 19                	jle    800a66 <readline+0xc5>
			if (echoing)
  800a4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a51:	74 0e                	je     800a61 <readline+0xc0>
				cputchar(c);
  800a53:	83 ec 0c             	sub    $0xc,%esp
  800a56:	ff 75 ec             	pushl  -0x14(%ebp)
  800a59:	e8 ee 0e 00 00       	call   80194c <cputchar>
  800a5e:	83 c4 10             	add    $0x10,%esp

			i--;
  800a61:	ff 4d f4             	decl   -0xc(%ebp)
  800a64:	eb 31                	jmp    800a97 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a66:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a6a:	74 0a                	je     800a76 <readline+0xd5>
  800a6c:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a70:	0f 85 61 ff ff ff    	jne    8009d7 <readline+0x36>
			if (echoing)
  800a76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a7a:	74 0e                	je     800a8a <readline+0xe9>
				cputchar(c);
  800a7c:	83 ec 0c             	sub    $0xc,%esp
  800a7f:	ff 75 ec             	pushl  -0x14(%ebp)
  800a82:	e8 c5 0e 00 00       	call   80194c <cputchar>
  800a87:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a90:	01 d0                	add    %edx,%eax
  800a92:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a95:	eb 06                	jmp    800a9d <readline+0xfc>
		}
	}
  800a97:	e9 3b ff ff ff       	jmp    8009d7 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a9c:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a9d:	90                   	nop
  800a9e:	c9                   	leave  
  800a9f:	c3                   	ret    

00800aa0 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
  800aa3:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800aa6:	e8 71 08 00 00       	call   80131c <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aaf:	74 13                	je     800ac4 <atomic_readline+0x24>
			cprintf("%s", prompt);
  800ab1:	83 ec 08             	sub    $0x8,%esp
  800ab4:	ff 75 08             	pushl  0x8(%ebp)
  800ab7:	68 88 22 80 00       	push   $0x802288
  800abc:	e8 4c f8 ff ff       	call   80030d <cprintf>
  800ac1:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800ac4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800acb:	83 ec 0c             	sub    $0xc,%esp
  800ace:	6a 00                	push   $0x0
  800ad0:	e8 a9 0e 00 00       	call   80197e <iscons>
  800ad5:	83 c4 10             	add    $0x10,%esp
  800ad8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800adb:	e8 8b 0e 00 00       	call   80196b <getchar>
  800ae0:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800ae3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ae7:	79 22                	jns    800b0b <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ae9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800aed:	0f 84 ad 00 00 00    	je     800ba0 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800af3:	83 ec 08             	sub    $0x8,%esp
  800af6:	ff 75 ec             	pushl  -0x14(%ebp)
  800af9:	68 8b 22 80 00       	push   $0x80228b
  800afe:	e8 0a f8 ff ff       	call   80030d <cprintf>
  800b03:	83 c4 10             	add    $0x10,%esp
				break;
  800b06:	e9 95 00 00 00       	jmp    800ba0 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b0b:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b0f:	7e 34                	jle    800b45 <atomic_readline+0xa5>
  800b11:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b18:	7f 2b                	jg     800b45 <atomic_readline+0xa5>
				if (echoing)
  800b1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b1e:	74 0e                	je     800b2e <atomic_readline+0x8e>
					cputchar(c);
  800b20:	83 ec 0c             	sub    $0xc,%esp
  800b23:	ff 75 ec             	pushl  -0x14(%ebp)
  800b26:	e8 21 0e 00 00       	call   80194c <cputchar>
  800b2b:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b31:	8d 50 01             	lea    0x1(%eax),%edx
  800b34:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3c:	01 d0                	add    %edx,%eax
  800b3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b41:	88 10                	mov    %dl,(%eax)
  800b43:	eb 56                	jmp    800b9b <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b45:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b49:	75 1f                	jne    800b6a <atomic_readline+0xca>
  800b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b4f:	7e 19                	jle    800b6a <atomic_readline+0xca>
				if (echoing)
  800b51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b55:	74 0e                	je     800b65 <atomic_readline+0xc5>
					cputchar(c);
  800b57:	83 ec 0c             	sub    $0xc,%esp
  800b5a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b5d:	e8 ea 0d 00 00       	call   80194c <cputchar>
  800b62:	83 c4 10             	add    $0x10,%esp
				i--;
  800b65:	ff 4d f4             	decl   -0xc(%ebp)
  800b68:	eb 31                	jmp    800b9b <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b6a:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b6e:	74 0a                	je     800b7a <atomic_readline+0xda>
  800b70:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b74:	0f 85 61 ff ff ff    	jne    800adb <atomic_readline+0x3b>
				if (echoing)
  800b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b7e:	74 0e                	je     800b8e <atomic_readline+0xee>
					cputchar(c);
  800b80:	83 ec 0c             	sub    $0xc,%esp
  800b83:	ff 75 ec             	pushl  -0x14(%ebp)
  800b86:	e8 c1 0d 00 00       	call   80194c <cputchar>
  800b8b:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	01 d0                	add    %edx,%eax
  800b96:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b99:	eb 06                	jmp    800ba1 <atomic_readline+0x101>
			}
		}
  800b9b:	e9 3b ff ff ff       	jmp    800adb <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800ba0:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800ba1:	e8 90 07 00 00       	call   801336 <sys_unlock_cons>
}
  800ba6:	90                   	nop
  800ba7:	c9                   	leave  
  800ba8:	c3                   	ret    

00800ba9 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ba9:	55                   	push   %ebp
  800baa:	89 e5                	mov    %esp,%ebp
  800bac:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800baf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb6:	eb 06                	jmp    800bbe <strlen+0x15>
		n++;
  800bb8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	ff 45 08             	incl   0x8(%ebp)
  800bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	84 c0                	test   %al,%al
  800bc5:	75 f1                	jne    800bb8 <strlen+0xf>
		n++;
	return n;
  800bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bca:	c9                   	leave  
  800bcb:	c3                   	ret    

00800bcc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd9:	eb 09                	jmp    800be4 <strnlen+0x18>
		n++;
  800bdb:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	ff 45 08             	incl   0x8(%ebp)
  800be1:	ff 4d 0c             	decl   0xc(%ebp)
  800be4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be8:	74 09                	je     800bf3 <strnlen+0x27>
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	8a 00                	mov    (%eax),%al
  800bef:	84 c0                	test   %al,%al
  800bf1:	75 e8                	jne    800bdb <strnlen+0xf>
		n++;
	return n;
  800bf3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf6:	c9                   	leave  
  800bf7:	c3                   	ret    

00800bf8 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c04:	90                   	nop
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8d 50 01             	lea    0x1(%eax),%edx
  800c0b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c14:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c17:	8a 12                	mov    (%edx),%dl
  800c19:	88 10                	mov    %dl,(%eax)
  800c1b:	8a 00                	mov    (%eax),%al
  800c1d:	84 c0                	test   %al,%al
  800c1f:	75 e4                	jne    800c05 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c32:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c39:	eb 1f                	jmp    800c5a <strncpy+0x34>
		*dst++ = *src;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 08             	mov    %edx,0x8(%ebp)
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	8a 12                	mov    (%edx),%dl
  800c49:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	84 c0                	test   %al,%al
  800c52:	74 03                	je     800c57 <strncpy+0x31>
			src++;
  800c54:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c57:	ff 45 fc             	incl   -0x4(%ebp)
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c60:	72 d9                	jb     800c3b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c62:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
  800c6a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c77:	74 30                	je     800ca9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c79:	eb 16                	jmp    800c91 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c91:	ff 4d 10             	decl   0x10(%ebp)
  800c94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c98:	74 09                	je     800ca3 <strlcpy+0x3c>
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	8a 00                	mov    (%eax),%al
  800c9f:	84 c0                	test   %al,%al
  800ca1:	75 d8                	jne    800c7b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800caf:	29 c2                	sub    %eax,%edx
  800cb1:	89 d0                	mov    %edx,%eax
}
  800cb3:	c9                   	leave  
  800cb4:	c3                   	ret    

00800cb5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb8:	eb 06                	jmp    800cc0 <strcmp+0xb>
		p++, q++;
  800cba:	ff 45 08             	incl   0x8(%ebp)
  800cbd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	84 c0                	test   %al,%al
  800cc7:	74 0e                	je     800cd7 <strcmp+0x22>
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 10                	mov    (%eax),%dl
  800cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd1:	8a 00                	mov    (%eax),%al
  800cd3:	38 c2                	cmp    %al,%dl
  800cd5:	74 e3                	je     800cba <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8a 00                	mov    (%eax),%al
  800cdc:	0f b6 d0             	movzbl %al,%edx
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	0f b6 c0             	movzbl %al,%eax
  800ce7:	29 c2                	sub    %eax,%edx
  800ce9:	89 d0                	mov    %edx,%eax
}
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf0:	eb 09                	jmp    800cfb <strncmp+0xe>
		n--, p++, q++;
  800cf2:	ff 4d 10             	decl   0x10(%ebp)
  800cf5:	ff 45 08             	incl   0x8(%ebp)
  800cf8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cfb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cff:	74 17                	je     800d18 <strncmp+0x2b>
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	84 c0                	test   %al,%al
  800d08:	74 0e                	je     800d18 <strncmp+0x2b>
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 10                	mov    (%eax),%dl
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	38 c2                	cmp    %al,%dl
  800d16:	74 da                	je     800cf2 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	75 07                	jne    800d25 <strncmp+0x38>
		return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d23:	eb 14                	jmp    800d39 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	8a 00                	mov    (%eax),%al
  800d2a:	0f b6 d0             	movzbl %al,%edx
  800d2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d30:	8a 00                	mov    (%eax),%al
  800d32:	0f b6 c0             	movzbl %al,%eax
  800d35:	29 c2                	sub    %eax,%edx
  800d37:	89 d0                	mov    %edx,%eax
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	83 ec 04             	sub    $0x4,%esp
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d47:	eb 12                	jmp    800d5b <strchr+0x20>
		if (*s == c)
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 00                	mov    (%eax),%al
  800d4e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d51:	75 05                	jne    800d58 <strchr+0x1d>
			return (char *) s;
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	eb 11                	jmp    800d69 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d58:	ff 45 08             	incl   0x8(%ebp)
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8a 00                	mov    (%eax),%al
  800d60:	84 c0                	test   %al,%al
  800d62:	75 e5                	jne    800d49 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d69:	c9                   	leave  
  800d6a:	c3                   	ret    

00800d6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	83 ec 04             	sub    $0x4,%esp
  800d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d74:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d77:	eb 0d                	jmp    800d86 <strfind+0x1b>
		if (*s == c)
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d81:	74 0e                	je     800d91 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d83:	ff 45 08             	incl   0x8(%ebp)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8a 00                	mov    (%eax),%al
  800d8b:	84 c0                	test   %al,%al
  800d8d:	75 ea                	jne    800d79 <strfind+0xe>
  800d8f:	eb 01                	jmp    800d92 <strfind+0x27>
		if (*s == c)
			break;
  800d91:	90                   	nop
	return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d95:	c9                   	leave  
  800d96:	c3                   	ret    

00800d97 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d97:	55                   	push   %ebp
  800d98:	89 e5                	mov    %esp,%ebp
  800d9a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da3:	8b 45 10             	mov    0x10(%ebp),%eax
  800da6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da9:	eb 0e                	jmp    800db9 <memset+0x22>
		*p++ = c;
  800dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dae:	8d 50 01             	lea    0x1(%eax),%edx
  800db1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db9:	ff 4d f8             	decl   -0x8(%ebp)
  800dbc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc0:	79 e9                	jns    800dab <memset+0x14>
		*p++ = c;

	return v;
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc5:	c9                   	leave  
  800dc6:	c3                   	ret    

00800dc7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc7:	55                   	push   %ebp
  800dc8:	89 e5                	mov    %esp,%ebp
  800dca:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd9:	eb 16                	jmp    800df1 <memcpy+0x2a>
		*d++ = *s++;
  800ddb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dde:	8d 50 01             	lea    0x1(%eax),%edx
  800de1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dea:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ded:	8a 12                	mov    (%edx),%dl
  800def:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df1:	8b 45 10             	mov    0x10(%ebp),%eax
  800df4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df7:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	75 dd                	jne    800ddb <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e01:	c9                   	leave  
  800e02:	c3                   	ret    

00800e03 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e18:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1b:	73 50                	jae    800e6d <memmove+0x6a>
  800e1d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e20:	8b 45 10             	mov    0x10(%ebp),%eax
  800e23:	01 d0                	add    %edx,%eax
  800e25:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e28:	76 43                	jbe    800e6d <memmove+0x6a>
		s += n;
  800e2a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e36:	eb 10                	jmp    800e48 <memmove+0x45>
			*--d = *--s;
  800e38:	ff 4d f8             	decl   -0x8(%ebp)
  800e3b:	ff 4d fc             	decl   -0x4(%ebp)
  800e3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e41:	8a 10                	mov    (%eax),%dl
  800e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e46:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e48:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4e:	89 55 10             	mov    %edx,0x10(%ebp)
  800e51:	85 c0                	test   %eax,%eax
  800e53:	75 e3                	jne    800e38 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e55:	eb 23                	jmp    800e7a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5a:	8d 50 01             	lea    0x1(%eax),%edx
  800e5d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e66:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e69:	8a 12                	mov    (%edx),%dl
  800e6b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e73:	89 55 10             	mov    %edx,0x10(%ebp)
  800e76:	85 c0                	test   %eax,%eax
  800e78:	75 dd                	jne    800e57 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7d:	c9                   	leave  
  800e7e:	c3                   	ret    

00800e7f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e91:	eb 2a                	jmp    800ebd <memcmp+0x3e>
		if (*s1 != *s2)
  800e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 16                	je     800eb7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea4:	8a 00                	mov    (%eax),%al
  800ea6:	0f b6 d0             	movzbl %al,%edx
  800ea9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eac:	8a 00                	mov    (%eax),%al
  800eae:	0f b6 c0             	movzbl %al,%eax
  800eb1:	29 c2                	sub    %eax,%edx
  800eb3:	89 d0                	mov    %edx,%eax
  800eb5:	eb 18                	jmp    800ecf <memcmp+0x50>
		s1++, s2++;
  800eb7:	ff 45 fc             	incl   -0x4(%ebp)
  800eba:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	75 c9                	jne    800e93 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	01 d0                	add    %edx,%eax
  800edf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee2:	eb 15                	jmp    800ef9 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eef:	0f b6 c0             	movzbl %al,%eax
  800ef2:	39 c2                	cmp    %eax,%edx
  800ef4:	74 0d                	je     800f03 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef6:	ff 45 08             	incl   0x8(%ebp)
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800eff:	72 e3                	jb     800ee4 <memfind+0x13>
  800f01:	eb 01                	jmp    800f04 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f03:	90                   	nop
	return (void *) s;
  800f04:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f07:	c9                   	leave  
  800f08:	c3                   	ret    

00800f09 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f16:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1d:	eb 03                	jmp    800f22 <strtol+0x19>
		s++;
  800f1f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	3c 20                	cmp    $0x20,%al
  800f29:	74 f4                	je     800f1f <strtol+0x16>
  800f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2e:	8a 00                	mov    (%eax),%al
  800f30:	3c 09                	cmp    $0x9,%al
  800f32:	74 eb                	je     800f1f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	3c 2b                	cmp    $0x2b,%al
  800f3b:	75 05                	jne    800f42 <strtol+0x39>
		s++;
  800f3d:	ff 45 08             	incl   0x8(%ebp)
  800f40:	eb 13                	jmp    800f55 <strtol+0x4c>
	else if (*s == '-')
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	3c 2d                	cmp    $0x2d,%al
  800f49:	75 0a                	jne    800f55 <strtol+0x4c>
		s++, neg = 1;
  800f4b:	ff 45 08             	incl   0x8(%ebp)
  800f4e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f59:	74 06                	je     800f61 <strtol+0x58>
  800f5b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5f:	75 20                	jne    800f81 <strtol+0x78>
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 30                	cmp    $0x30,%al
  800f68:	75 17                	jne    800f81 <strtol+0x78>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	40                   	inc    %eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	3c 78                	cmp    $0x78,%al
  800f72:	75 0d                	jne    800f81 <strtol+0x78>
		s += 2, base = 16;
  800f74:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f78:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7f:	eb 28                	jmp    800fa9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f85:	75 15                	jne    800f9c <strtol+0x93>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	3c 30                	cmp    $0x30,%al
  800f8e:	75 0c                	jne    800f9c <strtol+0x93>
		s++, base = 8;
  800f90:	ff 45 08             	incl   0x8(%ebp)
  800f93:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9a:	eb 0d                	jmp    800fa9 <strtol+0xa0>
	else if (base == 0)
  800f9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa0:	75 07                	jne    800fa9 <strtol+0xa0>
		base = 10;
  800fa2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	8a 00                	mov    (%eax),%al
  800fae:	3c 2f                	cmp    $0x2f,%al
  800fb0:	7e 19                	jle    800fcb <strtol+0xc2>
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3c 39                	cmp    $0x39,%al
  800fb9:	7f 10                	jg     800fcb <strtol+0xc2>
			dig = *s - '0';
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	0f be c0             	movsbl %al,%eax
  800fc3:	83 e8 30             	sub    $0x30,%eax
  800fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc9:	eb 42                	jmp    80100d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	3c 60                	cmp    $0x60,%al
  800fd2:	7e 19                	jle    800fed <strtol+0xe4>
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	3c 7a                	cmp    $0x7a,%al
  800fdb:	7f 10                	jg     800fed <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	0f be c0             	movsbl %al,%eax
  800fe5:	83 e8 57             	sub    $0x57,%eax
  800fe8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800feb:	eb 20                	jmp    80100d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 40                	cmp    $0x40,%al
  800ff4:	7e 39                	jle    80102f <strtol+0x126>
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 5a                	cmp    $0x5a,%al
  800ffd:	7f 30                	jg     80102f <strtol+0x126>
			dig = *s - 'A' + 10;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
  801002:	8a 00                	mov    (%eax),%al
  801004:	0f be c0             	movsbl %al,%eax
  801007:	83 e8 37             	sub    $0x37,%eax
  80100a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801010:	3b 45 10             	cmp    0x10(%ebp),%eax
  801013:	7d 19                	jge    80102e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801015:	ff 45 08             	incl   0x8(%ebp)
  801018:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101f:	89 c2                	mov    %eax,%edx
  801021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801024:	01 d0                	add    %edx,%eax
  801026:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801029:	e9 7b ff ff ff       	jmp    800fa9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801033:	74 08                	je     80103d <strtol+0x134>
		*endptr = (char *) s;
  801035:	8b 45 0c             	mov    0xc(%ebp),%eax
  801038:	8b 55 08             	mov    0x8(%ebp),%edx
  80103b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801041:	74 07                	je     80104a <strtol+0x141>
  801043:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801046:	f7 d8                	neg    %eax
  801048:	eb 03                	jmp    80104d <strtol+0x144>
  80104a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <ltostr>:

void
ltostr(long value, char *str)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801055:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801063:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801067:	79 13                	jns    80107c <ltostr+0x2d>
	{
		neg = 1;
  801069:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801070:	8b 45 0c             	mov    0xc(%ebp),%eax
  801073:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801076:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801079:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801084:	99                   	cltd   
  801085:	f7 f9                	idiv   %ecx
  801087:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108d:	8d 50 01             	lea    0x1(%eax),%edx
  801090:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801093:	89 c2                	mov    %eax,%edx
  801095:	8b 45 0c             	mov    0xc(%ebp),%eax
  801098:	01 d0                	add    %edx,%eax
  80109a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109d:	83 c2 30             	add    $0x30,%edx
  8010a0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010aa:	f7 e9                	imul   %ecx
  8010ac:	c1 fa 02             	sar    $0x2,%edx
  8010af:	89 c8                	mov    %ecx,%eax
  8010b1:	c1 f8 1f             	sar    $0x1f,%eax
  8010b4:	29 c2                	sub    %eax,%edx
  8010b6:	89 d0                	mov    %edx,%eax
  8010b8:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010bf:	75 bb                	jne    80107c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cb:	48                   	dec    %eax
  8010cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010cf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010d3:	74 3d                	je     801112 <ltostr+0xc3>
		start = 1 ;
  8010d5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010dc:	eb 34                	jmp    801112 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e4:	01 d0                	add    %edx,%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c2                	add    %eax,%edx
  8010f3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	01 c8                	add    %ecx,%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	01 c2                	add    %eax,%edx
  801107:	8a 45 eb             	mov    -0x15(%ebp),%al
  80110a:	88 02                	mov    %al,(%edx)
		start++ ;
  80110c:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80110f:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801115:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801118:	7c c4                	jl     8010de <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80111a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801125:	90                   	nop
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80112e:	ff 75 08             	pushl  0x8(%ebp)
  801131:	e8 73 fa ff ff       	call   800ba9 <strlen>
  801136:	83 c4 04             	add    $0x4,%esp
  801139:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80113c:	ff 75 0c             	pushl  0xc(%ebp)
  80113f:	e8 65 fa ff ff       	call   800ba9 <strlen>
  801144:	83 c4 04             	add    $0x4,%esp
  801147:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80114a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801158:	eb 17                	jmp    801171 <strcconcat+0x49>
		final[s] = str1[s] ;
  80115a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115d:	8b 45 10             	mov    0x10(%ebp),%eax
  801160:	01 c2                	add    %eax,%edx
  801162:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	01 c8                	add    %ecx,%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80116e:	ff 45 fc             	incl   -0x4(%ebp)
  801171:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801174:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801177:	7c e1                	jl     80115a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801187:	eb 1f                	jmp    8011a8 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801189:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80118c:	8d 50 01             	lea    0x1(%eax),%edx
  80118f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801192:	89 c2                	mov    %eax,%edx
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	01 c2                	add    %eax,%edx
  801199:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	01 c8                	add    %ecx,%eax
  8011a1:	8a 00                	mov    (%eax),%al
  8011a3:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011a5:	ff 45 f8             	incl   -0x8(%ebp)
  8011a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ab:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ae:	7c d9                	jl     801189 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
}
  8011bb:	90                   	nop
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	8b 00                	mov    (%eax),%eax
  8011cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e1:	eb 0c                	jmp    8011ef <strsplit+0x31>
			*string++ = 0;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	8d 50 01             	lea    0x1(%eax),%edx
  8011e9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ec:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	84 c0                	test   %al,%al
  8011f6:	74 18                	je     801210 <strsplit+0x52>
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	8a 00                	mov    (%eax),%al
  8011fd:	0f be c0             	movsbl %al,%eax
  801200:	50                   	push   %eax
  801201:	ff 75 0c             	pushl  0xc(%ebp)
  801204:	e8 32 fb ff ff       	call   800d3b <strchr>
  801209:	83 c4 08             	add    $0x8,%esp
  80120c:	85 c0                	test   %eax,%eax
  80120e:	75 d3                	jne    8011e3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801210:	8b 45 08             	mov    0x8(%ebp),%eax
  801213:	8a 00                	mov    (%eax),%al
  801215:	84 c0                	test   %al,%al
  801217:	74 5a                	je     801273 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801219:	8b 45 14             	mov    0x14(%ebp),%eax
  80121c:	8b 00                	mov    (%eax),%eax
  80121e:	83 f8 0f             	cmp    $0xf,%eax
  801221:	75 07                	jne    80122a <strsplit+0x6c>
		{
			return 0;
  801223:	b8 00 00 00 00       	mov    $0x0,%eax
  801228:	eb 66                	jmp    801290 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	8b 00                	mov    (%eax),%eax
  80122f:	8d 48 01             	lea    0x1(%eax),%ecx
  801232:	8b 55 14             	mov    0x14(%ebp),%edx
  801235:	89 0a                	mov    %ecx,(%edx)
  801237:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 45 08             	mov    0x8(%ebp),%eax
  801246:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801248:	eb 03                	jmp    80124d <strsplit+0x8f>
			string++;
  80124a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 8b                	je     8011e1 <strsplit+0x23>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 d4 fa ff ff       	call   800d3b <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	74 dc                	je     80124a <strsplit+0x8c>
			string++;
	}
  80126e:	e9 6e ff ff ff       	jmp    8011e1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801273:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801274:	8b 45 14             	mov    0x14(%ebp),%eax
  801277:	8b 00                	mov    (%eax),%eax
  801279:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801280:	8b 45 10             	mov    0x10(%ebp),%eax
  801283:	01 d0                	add    %edx,%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80128b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    

00801292 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801292:	55                   	push   %ebp
  801293:	89 e5                	mov    %esp,%ebp
  801295:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801298:	83 ec 04             	sub    $0x4,%esp
  80129b:	68 9c 22 80 00       	push   $0x80229c
  8012a0:	68 3f 01 00 00       	push   $0x13f
  8012a5:	68 be 22 80 00       	push   $0x8022be
  8012aa:	e8 d9 06 00 00       	call   801988 <_panic>

008012af <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	57                   	push   %edi
  8012b3:	56                   	push   %esi
  8012b4:	53                   	push   %ebx
  8012b5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012c1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012c4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012c7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012ca:	cd 30                	int    $0x30
  8012cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8012cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	5b                   	pop    %ebx
  8012d6:	5e                   	pop    %esi
  8012d7:	5f                   	pop    %edi
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	83 ec 04             	sub    $0x4,%esp
  8012e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8012e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	52                   	push   %edx
  8012f2:	ff 75 0c             	pushl  0xc(%ebp)
  8012f5:	50                   	push   %eax
  8012f6:	6a 00                	push   $0x0
  8012f8:	e8 b2 ff ff ff       	call   8012af <syscall>
  8012fd:	83 c4 18             	add    $0x18,%esp
}
  801300:	90                   	nop
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <sys_cgetc>:

int sys_cgetc(void) {
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 02                	push   $0x2
  801312:	e8 98 ff ff ff       	call   8012af <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <sys_lock_cons>:

void sys_lock_cons(void) {
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 03                	push   $0x3
  80132b:	e8 7f ff ff ff       	call   8012af <syscall>
  801330:	83 c4 18             	add    $0x18,%esp
}
  801333:	90                   	nop
  801334:	c9                   	leave  
  801335:	c3                   	ret    

00801336 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  801336:	55                   	push   %ebp
  801337:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 00                	push   $0x0
  801341:	6a 00                	push   $0x0
  801343:	6a 04                	push   $0x4
  801345:	e8 65 ff ff ff       	call   8012af <syscall>
  80134a:	83 c4 18             	add    $0x18,%esp
}
  80134d:	90                   	nop
  80134e:	c9                   	leave  
  80134f:	c3                   	ret    

00801350 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801353:	8b 55 0c             	mov    0xc(%ebp),%edx
  801356:	8b 45 08             	mov    0x8(%ebp),%eax
  801359:	6a 00                	push   $0x0
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	52                   	push   %edx
  801360:	50                   	push   %eax
  801361:	6a 08                	push   $0x8
  801363:	e8 47 ff ff ff       	call   8012af <syscall>
  801368:	83 c4 18             	add    $0x18,%esp
}
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	56                   	push   %esi
  801371:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801372:	8b 75 18             	mov    0x18(%ebp),%esi
  801375:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801378:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80137b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	56                   	push   %esi
  801382:	53                   	push   %ebx
  801383:	51                   	push   %ecx
  801384:	52                   	push   %edx
  801385:	50                   	push   %eax
  801386:	6a 09                	push   $0x9
  801388:	e8 22 ff ff ff       	call   8012af <syscall>
  80138d:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801390:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801393:	5b                   	pop    %ebx
  801394:	5e                   	pop    %esi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80139a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139d:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	6a 00                	push   $0x0
  8013a6:	52                   	push   %edx
  8013a7:	50                   	push   %eax
  8013a8:	6a 0a                	push   $0xa
  8013aa:	e8 00 ff ff ff       	call   8012af <syscall>
  8013af:	83 c4 18             	add    $0x18,%esp
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	ff 75 0c             	pushl  0xc(%ebp)
  8013c0:	ff 75 08             	pushl  0x8(%ebp)
  8013c3:	6a 0b                	push   $0xb
  8013c5:	e8 e5 fe ff ff       	call   8012af <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 0c                	push   $0xc
  8013de:	e8 cc fe ff ff       	call   8012af <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 0d                	push   $0xd
  8013f7:	e8 b3 fe ff ff       	call   8012af <syscall>
  8013fc:	83 c4 18             	add    $0x18,%esp
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 0e                	push   $0xe
  801410:	e8 9a fe ff ff       	call   8012af <syscall>
  801415:	83 c4 18             	add    $0x18,%esp
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	6a 00                	push   $0x0
  801427:	6a 0f                	push   $0xf
  801429:	e8 81 fe ff ff       	call   8012af <syscall>
  80142e:	83 c4 18             	add    $0x18,%esp
}
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  801436:	6a 00                	push   $0x0
  801438:	6a 00                	push   $0x0
  80143a:	6a 00                	push   $0x0
  80143c:	6a 00                	push   $0x0
  80143e:	ff 75 08             	pushl  0x8(%ebp)
  801441:	6a 10                	push   $0x10
  801443:	e8 67 fe ff ff       	call   8012af <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  80144b:	c9                   	leave  
  80144c:	c3                   	ret    

0080144d <sys_scarce_memory>:

void sys_scarce_memory() {
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801450:	6a 00                	push   $0x0
  801452:	6a 00                	push   $0x0
  801454:	6a 00                	push   $0x0
  801456:	6a 00                	push   $0x0
  801458:	6a 00                	push   $0x0
  80145a:	6a 11                	push   $0x11
  80145c:	e8 4e fe ff ff       	call   8012af <syscall>
  801461:	83 c4 18             	add    $0x18,%esp
}
  801464:	90                   	nop
  801465:	c9                   	leave  
  801466:	c3                   	ret    

00801467 <sys_cputc>:

void sys_cputc(const char c) {
  801467:	55                   	push   %ebp
  801468:	89 e5                	mov    %esp,%ebp
  80146a:	83 ec 04             	sub    $0x4,%esp
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801473:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	50                   	push   %eax
  801480:	6a 01                	push   $0x1
  801482:	e8 28 fe ff ff       	call   8012af <syscall>
  801487:	83 c4 18             	add    $0x18,%esp
}
  80148a:	90                   	nop
  80148b:	c9                   	leave  
  80148c:	c3                   	ret    

0080148d <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  80148d:	55                   	push   %ebp
  80148e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 00                	push   $0x0
  801498:	6a 00                	push   $0x0
  80149a:	6a 14                	push   $0x14
  80149c:	e8 0e fe ff ff       	call   8012af <syscall>
  8014a1:	83 c4 18             	add    $0x18,%esp
}
  8014a4:	90                   	nop
  8014a5:	c9                   	leave  
  8014a6:	c3                   	ret    

008014a7 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	83 ec 04             	sub    $0x4,%esp
  8014ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8014b3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014b6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	6a 00                	push   $0x0
  8014bf:	51                   	push   %ecx
  8014c0:	52                   	push   %edx
  8014c1:	ff 75 0c             	pushl  0xc(%ebp)
  8014c4:	50                   	push   %eax
  8014c5:	6a 15                	push   $0x15
  8014c7:	e8 e3 fd ff ff       	call   8012af <syscall>
  8014cc:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8014d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	52                   	push   %edx
  8014e1:	50                   	push   %eax
  8014e2:	6a 16                	push   $0x16
  8014e4:	e8 c6 fd ff ff       	call   8012af <syscall>
  8014e9:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8014ec:	c9                   	leave  
  8014ed:	c3                   	ret    

008014ee <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8014f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	51                   	push   %ecx
  8014ff:	52                   	push   %edx
  801500:	50                   	push   %eax
  801501:	6a 17                	push   $0x17
  801503:	e8 a7 fd ff ff       	call   8012af <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  80150b:	c9                   	leave  
  80150c:	c3                   	ret    

0080150d <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	52                   	push   %edx
  80151d:	50                   	push   %eax
  80151e:	6a 18                	push   $0x18
  801520:	e8 8a fd ff ff       	call   8012af <syscall>
  801525:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  80152d:	8b 45 08             	mov    0x8(%ebp),%eax
  801530:	6a 00                	push   $0x0
  801532:	ff 75 14             	pushl  0x14(%ebp)
  801535:	ff 75 10             	pushl  0x10(%ebp)
  801538:	ff 75 0c             	pushl  0xc(%ebp)
  80153b:	50                   	push   %eax
  80153c:	6a 19                	push   $0x19
  80153e:	e8 6c fd ff ff       	call   8012af <syscall>
  801543:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  801546:	c9                   	leave  
  801547:	c3                   	ret    

00801548 <sys_run_env>:

void sys_run_env(int32 envId) {
  801548:	55                   	push   %ebp
  801549:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 00                	push   $0x0
  801554:	6a 00                	push   $0x0
  801556:	50                   	push   %eax
  801557:	6a 1a                	push   $0x1a
  801559:	e8 51 fd ff ff       	call   8012af <syscall>
  80155e:	83 c4 18             	add    $0x18,%esp
}
  801561:	90                   	nop
  801562:	c9                   	leave  
  801563:	c3                   	ret    

00801564 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801564:	55                   	push   %ebp
  801565:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801567:	8b 45 08             	mov    0x8(%ebp),%eax
  80156a:	6a 00                	push   $0x0
  80156c:	6a 00                	push   $0x0
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	50                   	push   %eax
  801573:	6a 1b                	push   $0x1b
  801575:	e8 35 fd ff ff       	call   8012af <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_getenvid>:

int32 sys_getenvid(void) {
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 05                	push   $0x5
  80158e:	e8 1c fd ff ff       	call   8012af <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 06                	push   $0x6
  8015a7:	e8 03 fd ff ff       	call   8012af <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 07                	push   $0x7
  8015c0:	e8 ea fc ff ff       	call   8012af <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	c9                   	leave  
  8015c9:	c3                   	ret    

008015ca <sys_exit_env>:

void sys_exit_env(void) {
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015cd:	6a 00                	push   $0x0
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	6a 1c                	push   $0x1c
  8015d9:	e8 d1 fc ff ff       	call   8012af <syscall>
  8015de:	83 c4 18             	add    $0x18,%esp
}
  8015e1:	90                   	nop
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8015ea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015ed:	8d 50 04             	lea    0x4(%eax),%edx
  8015f0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015f3:	6a 00                	push   $0x0
  8015f5:	6a 00                	push   $0x0
  8015f7:	6a 00                	push   $0x0
  8015f9:	52                   	push   %edx
  8015fa:	50                   	push   %eax
  8015fb:	6a 1d                	push   $0x1d
  8015fd:	e8 ad fc ff ff       	call   8012af <syscall>
  801602:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  801605:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801608:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160e:	89 01                	mov    %eax,(%ecx)
  801610:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	c9                   	leave  
  801617:	c2 04 00             	ret    $0x4

0080161a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	ff 75 10             	pushl  0x10(%ebp)
  801624:	ff 75 0c             	pushl  0xc(%ebp)
  801627:	ff 75 08             	pushl  0x8(%ebp)
  80162a:	6a 13                	push   $0x13
  80162c:	e8 7e fc ff ff       	call   8012af <syscall>
  801631:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801634:	90                   	nop
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_rcr2>:
uint32 sys_rcr2() {
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 1e                	push   $0x1e
  801646:	e8 64 fc ff ff       	call   8012af <syscall>
  80164b:	83 c4 18             	add    $0x18,%esp
}
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 04             	sub    $0x4,%esp
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80165c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	50                   	push   %eax
  801669:	6a 1f                	push   $0x1f
  80166b:	e8 3f fc ff ff       	call   8012af <syscall>
  801670:	83 c4 18             	add    $0x18,%esp
	return;
  801673:	90                   	nop
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <rsttst>:
void rsttst() {
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801679:	6a 00                	push   $0x0
  80167b:	6a 00                	push   $0x0
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 21                	push   $0x21
  801685:	e8 25 fc ff ff       	call   8012af <syscall>
  80168a:	83 c4 18             	add    $0x18,%esp
	return;
  80168d:	90                   	nop
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 04             	sub    $0x4,%esp
  801696:	8b 45 14             	mov    0x14(%ebp),%eax
  801699:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80169c:	8b 55 18             	mov    0x18(%ebp),%edx
  80169f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8016a3:	52                   	push   %edx
  8016a4:	50                   	push   %eax
  8016a5:	ff 75 10             	pushl  0x10(%ebp)
  8016a8:	ff 75 0c             	pushl  0xc(%ebp)
  8016ab:	ff 75 08             	pushl  0x8(%ebp)
  8016ae:	6a 20                	push   $0x20
  8016b0:	e8 fa fb ff ff       	call   8012af <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
	return;
  8016b8:	90                   	nop
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <chktst>:
void chktst(uint32 n) {
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016be:	6a 00                	push   $0x0
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	ff 75 08             	pushl  0x8(%ebp)
  8016c9:	6a 22                	push   $0x22
  8016cb:	e8 df fb ff ff       	call   8012af <syscall>
  8016d0:	83 c4 18             	add    $0x18,%esp
	return;
  8016d3:	90                   	nop
}
  8016d4:	c9                   	leave  
  8016d5:	c3                   	ret    

008016d6 <inctst>:

void inctst() {
  8016d6:	55                   	push   %ebp
  8016d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016d9:	6a 00                	push   $0x0
  8016db:	6a 00                	push   $0x0
  8016dd:	6a 00                	push   $0x0
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 23                	push   $0x23
  8016e5:	e8 c5 fb ff ff       	call   8012af <syscall>
  8016ea:	83 c4 18             	add    $0x18,%esp
	return;
  8016ed:	90                   	nop
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <gettst>:
uint32 gettst() {
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 00                	push   $0x0
  8016f7:	6a 00                	push   $0x0
  8016f9:	6a 00                	push   $0x0
  8016fb:	6a 00                	push   $0x0
  8016fd:	6a 24                	push   $0x24
  8016ff:	e8 ab fb ff ff       	call   8012af <syscall>
  801704:	83 c4 18             	add    $0x18,%esp
}
  801707:	c9                   	leave  
  801708:	c3                   	ret    

00801709 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80170f:	6a 00                	push   $0x0
  801711:	6a 00                	push   $0x0
  801713:	6a 00                	push   $0x0
  801715:	6a 00                	push   $0x0
  801717:	6a 00                	push   $0x0
  801719:	6a 25                	push   $0x25
  80171b:	e8 8f fb ff ff       	call   8012af <syscall>
  801720:	83 c4 18             	add    $0x18,%esp
  801723:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801726:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80172a:	75 07                	jne    801733 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80172c:	b8 01 00 00 00       	mov    $0x1,%eax
  801731:	eb 05                	jmp    801738 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801740:	6a 00                	push   $0x0
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	6a 25                	push   $0x25
  80174c:	e8 5e fb ff ff       	call   8012af <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
  801754:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801757:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80175b:	75 07                	jne    801764 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80175d:	b8 01 00 00 00       	mov    $0x1,%eax
  801762:	eb 05                	jmp    801769 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 00                	push   $0x0
  80177b:	6a 25                	push   $0x25
  80177d:	e8 2d fb ff ff       	call   8012af <syscall>
  801782:	83 c4 18             	add    $0x18,%esp
  801785:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801788:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80178c:	75 07                	jne    801795 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80178e:	b8 01 00 00 00       	mov    $0x1,%eax
  801793:	eb 05                	jmp    80179a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	6a 00                	push   $0x0
  8017a8:	6a 00                	push   $0x0
  8017aa:	6a 00                	push   $0x0
  8017ac:	6a 25                	push   $0x25
  8017ae:	e8 fc fa ff ff       	call   8012af <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
  8017b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017b9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017bd:	75 07                	jne    8017c6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8017c4:	eb 05                	jmp    8017cb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    

008017cd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8017cd:	55                   	push   %ebp
  8017ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	ff 75 08             	pushl  0x8(%ebp)
  8017db:	6a 26                	push   $0x26
  8017dd:	e8 cd fa ff ff       	call   8012af <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
	return;
  8017e5:	90                   	nop
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8017ec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	6a 00                	push   $0x0
  8017fa:	53                   	push   %ebx
  8017fb:	51                   	push   %ecx
  8017fc:	52                   	push   %edx
  8017fd:	50                   	push   %eax
  8017fe:	6a 27                	push   $0x27
  801800:	e8 aa fa ff ff       	call   8012af <syscall>
  801805:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801810:	8b 55 0c             	mov    0xc(%ebp),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	52                   	push   %edx
  80181d:	50                   	push   %eax
  80181e:	6a 28                	push   $0x28
  801820:	e8 8a fa ff ff       	call   8012af <syscall>
  801825:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801828:	c9                   	leave  
  801829:	c3                   	ret    

0080182a <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80182a:	55                   	push   %ebp
  80182b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  80182d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801830:	8b 55 0c             	mov    0xc(%ebp),%edx
  801833:	8b 45 08             	mov    0x8(%ebp),%eax
  801836:	6a 00                	push   $0x0
  801838:	51                   	push   %ecx
  801839:	ff 75 10             	pushl  0x10(%ebp)
  80183c:	52                   	push   %edx
  80183d:	50                   	push   %eax
  80183e:	6a 29                	push   $0x29
  801840:	e8 6a fa ff ff       	call   8012af <syscall>
  801845:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	ff 75 10             	pushl  0x10(%ebp)
  801854:	ff 75 0c             	pushl  0xc(%ebp)
  801857:	ff 75 08             	pushl  0x8(%ebp)
  80185a:	6a 12                	push   $0x12
  80185c:	e8 4e fa ff ff       	call   8012af <syscall>
  801861:	83 c4 18             	add    $0x18,%esp
	return;
  801864:	90                   	nop
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80186a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	52                   	push   %edx
  801877:	50                   	push   %eax
  801878:	6a 2a                	push   $0x2a
  80187a:	e8 30 fa ff ff       	call   8012af <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
	return;
  801882:	90                   	nop
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	50                   	push   %eax
  801894:	6a 2b                	push   $0x2b
  801896:	e8 14 fa ff ff       	call   8012af <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ac:	ff 75 08             	pushl  0x8(%ebp)
  8018af:	6a 2c                	push   $0x2c
  8018b1:	e8 f9 f9 ff ff       	call   8012af <syscall>
  8018b6:	83 c4 18             	add    $0x18,%esp
	return;
  8018b9:	90                   	nop
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 0c             	pushl  0xc(%ebp)
  8018c8:	ff 75 08             	pushl  0x8(%ebp)
  8018cb:	6a 2d                	push   $0x2d
  8018cd:	e8 dd f9 ff ff       	call   8012af <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
	return;
  8018d5:	90                   	nop
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	50                   	push   %eax
  8018e7:	6a 2f                	push   $0x2f
  8018e9:	e8 c1 f9 ff ff       	call   8012af <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8018f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	6a 30                	push   $0x30
  801907:	e8 a3 f9 ff ff       	call   8012af <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
	return;
  80190f:	90                   	nop
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 00                	push   $0x0
  801920:	50                   	push   %eax
  801921:	6a 31                	push   $0x31
  801923:	e8 87 f9 ff ff       	call   8012af <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
	return;
  80192b:	90                   	nop
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	52                   	push   %edx
  80193e:	50                   	push   %eax
  80193f:	6a 2e                	push   $0x2e
  801941:	e8 69 f9 ff ff       	call   8012af <syscall>
  801946:	83 c4 18             	add    $0x18,%esp
    return;
  801949:	90                   	nop
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801958:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	50                   	push   %eax
  801960:	e8 02 fb ff ff       	call   801467 <sys_cputc>
  801965:	83 c4 10             	add    $0x10,%esp
}
  801968:	90                   	nop
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <getchar>:


int
getchar(void)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801971:	e8 8d f9 ff ff       	call   801303 <sys_cgetc>
  801976:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801979:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <iscons>:

int iscons(int fdnum)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801981:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801986:	5d                   	pop    %ebp
  801987:	c3                   	ret    

00801988 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80198e:	8d 45 10             	lea    0x10(%ebp),%eax
  801991:	83 c0 04             	add    $0x4,%eax
  801994:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801997:	a1 28 30 80 00       	mov    0x803028,%eax
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 16                	je     8019b6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8019a0:	a1 28 30 80 00       	mov    0x803028,%eax
  8019a5:	83 ec 08             	sub    $0x8,%esp
  8019a8:	50                   	push   %eax
  8019a9:	68 cc 22 80 00       	push   $0x8022cc
  8019ae:	e8 5a e9 ff ff       	call   80030d <cprintf>
  8019b3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019b6:	a1 04 30 80 00       	mov    0x803004,%eax
  8019bb:	ff 75 0c             	pushl  0xc(%ebp)
  8019be:	ff 75 08             	pushl  0x8(%ebp)
  8019c1:	50                   	push   %eax
  8019c2:	68 d1 22 80 00       	push   $0x8022d1
  8019c7:	e8 41 e9 ff ff       	call   80030d <cprintf>
  8019cc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d2:	83 ec 08             	sub    $0x8,%esp
  8019d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d8:	50                   	push   %eax
  8019d9:	e8 c4 e8 ff ff       	call   8002a2 <vcprintf>
  8019de:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019e1:	83 ec 08             	sub    $0x8,%esp
  8019e4:	6a 00                	push   $0x0
  8019e6:	68 ed 22 80 00       	push   $0x8022ed
  8019eb:	e8 b2 e8 ff ff       	call   8002a2 <vcprintf>
  8019f0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019f3:	e8 33 e8 ff ff       	call   80022b <exit>

	// should not return here
	while (1) ;
  8019f8:	eb fe                	jmp    8019f8 <_panic+0x70>

008019fa <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
  8019fd:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a00:	a1 08 30 80 00       	mov    0x803008,%eax
  801a05:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	39 c2                	cmp    %eax,%edx
  801a10:	74 14                	je     801a26 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a12:	83 ec 04             	sub    $0x4,%esp
  801a15:	68 f0 22 80 00       	push   $0x8022f0
  801a1a:	6a 26                	push   $0x26
  801a1c:	68 3c 23 80 00       	push   $0x80233c
  801a21:	e8 62 ff ff ff       	call   801988 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a34:	e9 c5 00 00 00       	jmp    801afe <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	01 d0                	add    %edx,%eax
  801a48:	8b 00                	mov    (%eax),%eax
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	75 08                	jne    801a56 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a4e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a51:	e9 a5 00 00 00       	jmp    801afb <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a56:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a5d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a64:	eb 69                	jmp    801acf <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a66:	a1 08 30 80 00       	mov    0x803008,%eax
  801a6b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a71:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a74:	89 d0                	mov    %edx,%eax
  801a76:	01 c0                	add    %eax,%eax
  801a78:	01 d0                	add    %edx,%eax
  801a7a:	c1 e0 03             	shl    $0x3,%eax
  801a7d:	01 c8                	add    %ecx,%eax
  801a7f:	8a 40 04             	mov    0x4(%eax),%al
  801a82:	84 c0                	test   %al,%al
  801a84:	75 46                	jne    801acc <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a86:	a1 08 30 80 00       	mov    0x803008,%eax
  801a8b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a94:	89 d0                	mov    %edx,%eax
  801a96:	01 c0                	add    %eax,%eax
  801a98:	01 d0                	add    %edx,%eax
  801a9a:	c1 e0 03             	shl    $0x3,%eax
  801a9d:	01 c8                	add    %ecx,%eax
  801a9f:	8b 00                	mov    (%eax),%eax
  801aa1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801aa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aac:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	01 c8                	add    %ecx,%eax
  801abd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801abf:	39 c2                	cmp    %eax,%edx
  801ac1:	75 09                	jne    801acc <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ac3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801aca:	eb 15                	jmp    801ae1 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801acc:	ff 45 e8             	incl   -0x18(%ebp)
  801acf:	a1 08 30 80 00       	mov    0x803008,%eax
  801ad4:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801add:	39 c2                	cmp    %eax,%edx
  801adf:	77 85                	ja     801a66 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ae1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ae5:	75 14                	jne    801afb <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801ae7:	83 ec 04             	sub    $0x4,%esp
  801aea:	68 48 23 80 00       	push   $0x802348
  801aef:	6a 3a                	push   $0x3a
  801af1:	68 3c 23 80 00       	push   $0x80233c
  801af6:	e8 8d fe ff ff       	call   801988 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801afb:	ff 45 f0             	incl   -0x10(%ebp)
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b01:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b04:	0f 8c 2f ff ff ff    	jl     801a39 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b0a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b11:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b18:	eb 26                	jmp    801b40 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b1a:	a1 08 30 80 00       	mov    0x803008,%eax
  801b1f:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801b25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b28:	89 d0                	mov    %edx,%eax
  801b2a:	01 c0                	add    %eax,%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	c1 e0 03             	shl    $0x3,%eax
  801b31:	01 c8                	add    %ecx,%eax
  801b33:	8a 40 04             	mov    0x4(%eax),%al
  801b36:	3c 01                	cmp    $0x1,%al
  801b38:	75 03                	jne    801b3d <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b3a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b3d:	ff 45 e0             	incl   -0x20(%ebp)
  801b40:	a1 08 30 80 00       	mov    0x803008,%eax
  801b45:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4e:	39 c2                	cmp    %eax,%edx
  801b50:	77 c8                	ja     801b1a <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b55:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b58:	74 14                	je     801b6e <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	68 9c 23 80 00       	push   $0x80239c
  801b62:	6a 44                	push   $0x44
  801b64:	68 3c 23 80 00       	push   $0x80233c
  801b69:	e8 1a fe ff ff       	call   801988 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b6e:	90                   	nop
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    
  801b71:	66 90                	xchg   %ax,%ax
  801b73:	90                   	nop

00801b74 <__udivdi3>:
  801b74:	55                   	push   %ebp
  801b75:	57                   	push   %edi
  801b76:	56                   	push   %esi
  801b77:	53                   	push   %ebx
  801b78:	83 ec 1c             	sub    $0x1c,%esp
  801b7b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b7f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b83:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b8b:	89 ca                	mov    %ecx,%edx
  801b8d:	89 f8                	mov    %edi,%eax
  801b8f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b93:	85 f6                	test   %esi,%esi
  801b95:	75 2d                	jne    801bc4 <__udivdi3+0x50>
  801b97:	39 cf                	cmp    %ecx,%edi
  801b99:	77 65                	ja     801c00 <__udivdi3+0x8c>
  801b9b:	89 fd                	mov    %edi,%ebp
  801b9d:	85 ff                	test   %edi,%edi
  801b9f:	75 0b                	jne    801bac <__udivdi3+0x38>
  801ba1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba6:	31 d2                	xor    %edx,%edx
  801ba8:	f7 f7                	div    %edi
  801baa:	89 c5                	mov    %eax,%ebp
  801bac:	31 d2                	xor    %edx,%edx
  801bae:	89 c8                	mov    %ecx,%eax
  801bb0:	f7 f5                	div    %ebp
  801bb2:	89 c1                	mov    %eax,%ecx
  801bb4:	89 d8                	mov    %ebx,%eax
  801bb6:	f7 f5                	div    %ebp
  801bb8:	89 cf                	mov    %ecx,%edi
  801bba:	89 fa                	mov    %edi,%edx
  801bbc:	83 c4 1c             	add    $0x1c,%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    
  801bc4:	39 ce                	cmp    %ecx,%esi
  801bc6:	77 28                	ja     801bf0 <__udivdi3+0x7c>
  801bc8:	0f bd fe             	bsr    %esi,%edi
  801bcb:	83 f7 1f             	xor    $0x1f,%edi
  801bce:	75 40                	jne    801c10 <__udivdi3+0x9c>
  801bd0:	39 ce                	cmp    %ecx,%esi
  801bd2:	72 0a                	jb     801bde <__udivdi3+0x6a>
  801bd4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd8:	0f 87 9e 00 00 00    	ja     801c7c <__udivdi3+0x108>
  801bde:	b8 01 00 00 00       	mov    $0x1,%eax
  801be3:	89 fa                	mov    %edi,%edx
  801be5:	83 c4 1c             	add    $0x1c,%esp
  801be8:	5b                   	pop    %ebx
  801be9:	5e                   	pop    %esi
  801bea:	5f                   	pop    %edi
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    
  801bed:	8d 76 00             	lea    0x0(%esi),%esi
  801bf0:	31 ff                	xor    %edi,%edi
  801bf2:	31 c0                	xor    %eax,%eax
  801bf4:	89 fa                	mov    %edi,%edx
  801bf6:	83 c4 1c             	add    $0x1c,%esp
  801bf9:	5b                   	pop    %ebx
  801bfa:	5e                   	pop    %esi
  801bfb:	5f                   	pop    %edi
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    
  801bfe:	66 90                	xchg   %ax,%ax
  801c00:	89 d8                	mov    %ebx,%eax
  801c02:	f7 f7                	div    %edi
  801c04:	31 ff                	xor    %edi,%edi
  801c06:	89 fa                	mov    %edi,%edx
  801c08:	83 c4 1c             	add    $0x1c,%esp
  801c0b:	5b                   	pop    %ebx
  801c0c:	5e                   	pop    %esi
  801c0d:	5f                   	pop    %edi
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    
  801c10:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c15:	89 eb                	mov    %ebp,%ebx
  801c17:	29 fb                	sub    %edi,%ebx
  801c19:	89 f9                	mov    %edi,%ecx
  801c1b:	d3 e6                	shl    %cl,%esi
  801c1d:	89 c5                	mov    %eax,%ebp
  801c1f:	88 d9                	mov    %bl,%cl
  801c21:	d3 ed                	shr    %cl,%ebp
  801c23:	89 e9                	mov    %ebp,%ecx
  801c25:	09 f1                	or     %esi,%ecx
  801c27:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c2b:	89 f9                	mov    %edi,%ecx
  801c2d:	d3 e0                	shl    %cl,%eax
  801c2f:	89 c5                	mov    %eax,%ebp
  801c31:	89 d6                	mov    %edx,%esi
  801c33:	88 d9                	mov    %bl,%cl
  801c35:	d3 ee                	shr    %cl,%esi
  801c37:	89 f9                	mov    %edi,%ecx
  801c39:	d3 e2                	shl    %cl,%edx
  801c3b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c3f:	88 d9                	mov    %bl,%cl
  801c41:	d3 e8                	shr    %cl,%eax
  801c43:	09 c2                	or     %eax,%edx
  801c45:	89 d0                	mov    %edx,%eax
  801c47:	89 f2                	mov    %esi,%edx
  801c49:	f7 74 24 0c          	divl   0xc(%esp)
  801c4d:	89 d6                	mov    %edx,%esi
  801c4f:	89 c3                	mov    %eax,%ebx
  801c51:	f7 e5                	mul    %ebp
  801c53:	39 d6                	cmp    %edx,%esi
  801c55:	72 19                	jb     801c70 <__udivdi3+0xfc>
  801c57:	74 0b                	je     801c64 <__udivdi3+0xf0>
  801c59:	89 d8                	mov    %ebx,%eax
  801c5b:	31 ff                	xor    %edi,%edi
  801c5d:	e9 58 ff ff ff       	jmp    801bba <__udivdi3+0x46>
  801c62:	66 90                	xchg   %ax,%ax
  801c64:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c68:	89 f9                	mov    %edi,%ecx
  801c6a:	d3 e2                	shl    %cl,%edx
  801c6c:	39 c2                	cmp    %eax,%edx
  801c6e:	73 e9                	jae    801c59 <__udivdi3+0xe5>
  801c70:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c73:	31 ff                	xor    %edi,%edi
  801c75:	e9 40 ff ff ff       	jmp    801bba <__udivdi3+0x46>
  801c7a:	66 90                	xchg   %ax,%ax
  801c7c:	31 c0                	xor    %eax,%eax
  801c7e:	e9 37 ff ff ff       	jmp    801bba <__udivdi3+0x46>
  801c83:	90                   	nop

00801c84 <__umoddi3>:
  801c84:	55                   	push   %ebp
  801c85:	57                   	push   %edi
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 1c             	sub    $0x1c,%esp
  801c8b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c8f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c97:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c9f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ca3:	89 f3                	mov    %esi,%ebx
  801ca5:	89 fa                	mov    %edi,%edx
  801ca7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cab:	89 34 24             	mov    %esi,(%esp)
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	75 1a                	jne    801ccc <__umoddi3+0x48>
  801cb2:	39 f7                	cmp    %esi,%edi
  801cb4:	0f 86 a2 00 00 00    	jbe    801d5c <__umoddi3+0xd8>
  801cba:	89 c8                	mov    %ecx,%eax
  801cbc:	89 f2                	mov    %esi,%edx
  801cbe:	f7 f7                	div    %edi
  801cc0:	89 d0                	mov    %edx,%eax
  801cc2:	31 d2                	xor    %edx,%edx
  801cc4:	83 c4 1c             	add    $0x1c,%esp
  801cc7:	5b                   	pop    %ebx
  801cc8:	5e                   	pop    %esi
  801cc9:	5f                   	pop    %edi
  801cca:	5d                   	pop    %ebp
  801ccb:	c3                   	ret    
  801ccc:	39 f0                	cmp    %esi,%eax
  801cce:	0f 87 ac 00 00 00    	ja     801d80 <__umoddi3+0xfc>
  801cd4:	0f bd e8             	bsr    %eax,%ebp
  801cd7:	83 f5 1f             	xor    $0x1f,%ebp
  801cda:	0f 84 ac 00 00 00    	je     801d8c <__umoddi3+0x108>
  801ce0:	bf 20 00 00 00       	mov    $0x20,%edi
  801ce5:	29 ef                	sub    %ebp,%edi
  801ce7:	89 fe                	mov    %edi,%esi
  801ce9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ced:	89 e9                	mov    %ebp,%ecx
  801cef:	d3 e0                	shl    %cl,%eax
  801cf1:	89 d7                	mov    %edx,%edi
  801cf3:	89 f1                	mov    %esi,%ecx
  801cf5:	d3 ef                	shr    %cl,%edi
  801cf7:	09 c7                	or     %eax,%edi
  801cf9:	89 e9                	mov    %ebp,%ecx
  801cfb:	d3 e2                	shl    %cl,%edx
  801cfd:	89 14 24             	mov    %edx,(%esp)
  801d00:	89 d8                	mov    %ebx,%eax
  801d02:	d3 e0                	shl    %cl,%eax
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0a:	d3 e0                	shl    %cl,%eax
  801d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d10:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d14:	89 f1                	mov    %esi,%ecx
  801d16:	d3 e8                	shr    %cl,%eax
  801d18:	09 d0                	or     %edx,%eax
  801d1a:	d3 eb                	shr    %cl,%ebx
  801d1c:	89 da                	mov    %ebx,%edx
  801d1e:	f7 f7                	div    %edi
  801d20:	89 d3                	mov    %edx,%ebx
  801d22:	f7 24 24             	mull   (%esp)
  801d25:	89 c6                	mov    %eax,%esi
  801d27:	89 d1                	mov    %edx,%ecx
  801d29:	39 d3                	cmp    %edx,%ebx
  801d2b:	0f 82 87 00 00 00    	jb     801db8 <__umoddi3+0x134>
  801d31:	0f 84 91 00 00 00    	je     801dc8 <__umoddi3+0x144>
  801d37:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d3b:	29 f2                	sub    %esi,%edx
  801d3d:	19 cb                	sbb    %ecx,%ebx
  801d3f:	89 d8                	mov    %ebx,%eax
  801d41:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d45:	d3 e0                	shl    %cl,%eax
  801d47:	89 e9                	mov    %ebp,%ecx
  801d49:	d3 ea                	shr    %cl,%edx
  801d4b:	09 d0                	or     %edx,%eax
  801d4d:	89 e9                	mov    %ebp,%ecx
  801d4f:	d3 eb                	shr    %cl,%ebx
  801d51:	89 da                	mov    %ebx,%edx
  801d53:	83 c4 1c             	add    $0x1c,%esp
  801d56:	5b                   	pop    %ebx
  801d57:	5e                   	pop    %esi
  801d58:	5f                   	pop    %edi
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    
  801d5b:	90                   	nop
  801d5c:	89 fd                	mov    %edi,%ebp
  801d5e:	85 ff                	test   %edi,%edi
  801d60:	75 0b                	jne    801d6d <__umoddi3+0xe9>
  801d62:	b8 01 00 00 00       	mov    $0x1,%eax
  801d67:	31 d2                	xor    %edx,%edx
  801d69:	f7 f7                	div    %edi
  801d6b:	89 c5                	mov    %eax,%ebp
  801d6d:	89 f0                	mov    %esi,%eax
  801d6f:	31 d2                	xor    %edx,%edx
  801d71:	f7 f5                	div    %ebp
  801d73:	89 c8                	mov    %ecx,%eax
  801d75:	f7 f5                	div    %ebp
  801d77:	89 d0                	mov    %edx,%eax
  801d79:	e9 44 ff ff ff       	jmp    801cc2 <__umoddi3+0x3e>
  801d7e:	66 90                	xchg   %ax,%ax
  801d80:	89 c8                	mov    %ecx,%eax
  801d82:	89 f2                	mov    %esi,%edx
  801d84:	83 c4 1c             	add    $0x1c,%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5f                   	pop    %edi
  801d8a:	5d                   	pop    %ebp
  801d8b:	c3                   	ret    
  801d8c:	3b 04 24             	cmp    (%esp),%eax
  801d8f:	72 06                	jb     801d97 <__umoddi3+0x113>
  801d91:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d95:	77 0f                	ja     801da6 <__umoddi3+0x122>
  801d97:	89 f2                	mov    %esi,%edx
  801d99:	29 f9                	sub    %edi,%ecx
  801d9b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d9f:	89 14 24             	mov    %edx,(%esp)
  801da2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801da6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801daa:	8b 14 24             	mov    (%esp),%edx
  801dad:	83 c4 1c             	add    $0x1c,%esp
  801db0:	5b                   	pop    %ebx
  801db1:	5e                   	pop    %esi
  801db2:	5f                   	pop    %edi
  801db3:	5d                   	pop    %ebp
  801db4:	c3                   	ret    
  801db5:	8d 76 00             	lea    0x0(%esi),%esi
  801db8:	2b 04 24             	sub    (%esp),%eax
  801dbb:	19 fa                	sbb    %edi,%edx
  801dbd:	89 d1                	mov    %edx,%ecx
  801dbf:	89 c6                	mov    %eax,%esi
  801dc1:	e9 71 ff ff ff       	jmp    801d37 <__umoddi3+0xb3>
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dcc:	72 ea                	jb     801db8 <__umoddi3+0x134>
  801dce:	89 d9                	mov    %ebx,%ecx
  801dd0:	e9 62 ff ff ff       	jmp    801d37 <__umoddi3+0xb3>
