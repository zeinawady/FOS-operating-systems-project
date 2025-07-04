
obj/user/fos_fibonacci:     file format elf32-i386


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
  800031:	e8 b7 00 00 00       	call   8000ed <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

int64 fibonacci(int n);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	char buff1[256];

	atomic_readline("Please enter Fibonacci index:", buff1);
  800048:	83 ec 08             	sub    $0x8,%esp
  80004b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800051:	50                   	push   %eax
  800052:	68 e0 1d 80 00       	push   $0x801de0
  800057:	e8 3d 0a 00 00       	call   800a99 <atomic_readline>
  80005c:	83 c4 10             	add    $0x10,%esp

	i1 = strtol(buff1, NULL, 10);
  80005f:	83 ec 04             	sub    $0x4,%esp
  800062:	6a 0a                	push   $0xa
  800064:	6a 00                	push   $0x0
  800066:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80006c:	50                   	push   %eax
  80006d:	e8 90 0e 00 00       	call   800f02 <strtol>
  800072:	83 c4 10             	add    $0x10,%esp
  800075:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int64 res = fibonacci(i1) ;
  800078:	83 ec 0c             	sub    $0xc,%esp
  80007b:	ff 75 f4             	pushl  -0xc(%ebp)
  80007e:	e8 22 00 00 00       	call   8000a5 <fibonacci>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800089:	89 55 ec             	mov    %edx,-0x14(%ebp)

	atomic_cprintf("%@Fibonacci #%d = %lld\n",i1, res);
  80008c:	ff 75 ec             	pushl  -0x14(%ebp)
  80008f:	ff 75 e8             	pushl  -0x18(%ebp)
  800092:	ff 75 f4             	pushl  -0xc(%ebp)
  800095:	68 fe 1d 80 00       	push   $0x801dfe
  80009a:	e8 94 02 00 00       	call   800333 <atomic_cprintf>
  80009f:	83 c4 10             	add    $0x10,%esp

	return;
  8000a2:	90                   	nop
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    

008000a5 <fibonacci>:


int64 fibonacci(int n)
{
  8000a5:	55                   	push   %ebp
  8000a6:	89 e5                	mov    %esp,%ebp
  8000a8:	56                   	push   %esi
  8000a9:	53                   	push   %ebx
	if (n <= 1)
  8000aa:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ae:	7f 0c                	jg     8000bc <fibonacci+0x17>
		return 1 ;
  8000b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8000b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ba:	eb 2a                	jmp    8000e6 <fibonacci+0x41>
	return fibonacci(n-1) + fibonacci(n-2) ;
  8000bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8000bf:	48                   	dec    %eax
  8000c0:	83 ec 0c             	sub    $0xc,%esp
  8000c3:	50                   	push   %eax
  8000c4:	e8 dc ff ff ff       	call   8000a5 <fibonacci>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	89 c3                	mov    %eax,%ebx
  8000ce:	89 d6                	mov    %edx,%esi
  8000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d3:	83 e8 02             	sub    $0x2,%eax
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	50                   	push   %eax
  8000da:	e8 c6 ff ff ff       	call   8000a5 <fibonacci>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	01 d8                	add    %ebx,%eax
  8000e4:	11 f2                	adc    %esi,%edx
}
  8000e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000f3:	e8 99 14 00 00       	call   801591 <sys_getenvindex>
  8000f8:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000fe:	89 d0                	mov    %edx,%eax
  800100:	c1 e0 02             	shl    $0x2,%eax
  800103:	01 d0                	add    %edx,%eax
  800105:	c1 e0 03             	shl    $0x3,%eax
  800108:	01 d0                	add    %edx,%eax
  80010a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800111:	01 d0                	add    %edx,%eax
  800113:	c1 e0 02             	shl    $0x2,%eax
  800116:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011b:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800120:	a1 08 30 80 00       	mov    0x803008,%eax
  800125:	8a 40 20             	mov    0x20(%eax),%al
  800128:	84 c0                	test   %al,%al
  80012a:	74 0d                	je     800139 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80012c:	a1 08 30 80 00       	mov    0x803008,%eax
  800131:	83 c0 20             	add    $0x20,%eax
  800134:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800139:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80013d:	7e 0a                	jle    800149 <libmain+0x5c>
		binaryname = argv[0];
  80013f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	ff 75 0c             	pushl  0xc(%ebp)
  80014f:	ff 75 08             	pushl  0x8(%ebp)
  800152:	e8 e1 fe ff ff       	call   800038 <_main>
  800157:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80015a:	a1 00 30 80 00       	mov    0x803000,%eax
  80015f:	85 c0                	test   %eax,%eax
  800161:	0f 84 9f 00 00 00    	je     800206 <libmain+0x119>
	{
		sys_lock_cons();
  800167:	e8 a9 11 00 00       	call   801315 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80016c:	83 ec 0c             	sub    $0xc,%esp
  80016f:	68 30 1e 80 00       	push   $0x801e30
  800174:	e8 8d 01 00 00       	call   800306 <cprintf>
  800179:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80017c:	a1 08 30 80 00       	mov    0x803008,%eax
  800181:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800187:	a1 08 30 80 00       	mov    0x803008,%eax
  80018c:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800192:	83 ec 04             	sub    $0x4,%esp
  800195:	52                   	push   %edx
  800196:	50                   	push   %eax
  800197:	68 58 1e 80 00       	push   $0x801e58
  80019c:	e8 65 01 00 00       	call   800306 <cprintf>
  8001a1:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001a4:	a1 08 30 80 00       	mov    0x803008,%eax
  8001a9:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001af:	a1 08 30 80 00       	mov    0x803008,%eax
  8001b4:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001ba:	a1 08 30 80 00       	mov    0x803008,%eax
  8001bf:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001c5:	51                   	push   %ecx
  8001c6:	52                   	push   %edx
  8001c7:	50                   	push   %eax
  8001c8:	68 80 1e 80 00       	push   $0x801e80
  8001cd:	e8 34 01 00 00       	call   800306 <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001d5:	a1 08 30 80 00       	mov    0x803008,%eax
  8001da:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001e0:	83 ec 08             	sub    $0x8,%esp
  8001e3:	50                   	push   %eax
  8001e4:	68 d8 1e 80 00       	push   $0x801ed8
  8001e9:	e8 18 01 00 00       	call   800306 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001f1:	83 ec 0c             	sub    $0xc,%esp
  8001f4:	68 30 1e 80 00       	push   $0x801e30
  8001f9:	e8 08 01 00 00       	call   800306 <cprintf>
  8001fe:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800201:	e8 29 11 00 00       	call   80132f <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  800206:	e8 19 00 00 00       	call   800224 <exit>
}
  80020b:	90                   	nop
  80020c:	c9                   	leave  
  80020d:	c3                   	ret    

0080020e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80020e:	55                   	push   %ebp
  80020f:	89 e5                	mov    %esp,%ebp
  800211:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800214:	83 ec 0c             	sub    $0xc,%esp
  800217:	6a 00                	push   $0x0
  800219:	e8 3f 13 00 00       	call   80155d <sys_destroy_env>
  80021e:	83 c4 10             	add    $0x10,%esp
}
  800221:	90                   	nop
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <exit>:

void
exit(void)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80022a:	e8 94 13 00 00       	call   8015c3 <sys_exit_env>
}
  80022f:	90                   	nop
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800238:	8b 45 0c             	mov    0xc(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	8d 48 01             	lea    0x1(%eax),%ecx
  800240:	8b 55 0c             	mov    0xc(%ebp),%edx
  800243:	89 0a                	mov    %ecx,(%edx)
  800245:	8b 55 08             	mov    0x8(%ebp),%edx
  800248:	88 d1                	mov    %dl,%cl
  80024a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80024d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800251:	8b 45 0c             	mov    0xc(%ebp),%eax
  800254:	8b 00                	mov    (%eax),%eax
  800256:	3d ff 00 00 00       	cmp    $0xff,%eax
  80025b:	75 2c                	jne    800289 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80025d:	a0 0c 30 80 00       	mov    0x80300c,%al
  800262:	0f b6 c0             	movzbl %al,%eax
  800265:	8b 55 0c             	mov    0xc(%ebp),%edx
  800268:	8b 12                	mov    (%edx),%edx
  80026a:	89 d1                	mov    %edx,%ecx
  80026c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026f:	83 c2 08             	add    $0x8,%edx
  800272:	83 ec 04             	sub    $0x4,%esp
  800275:	50                   	push   %eax
  800276:	51                   	push   %ecx
  800277:	52                   	push   %edx
  800278:	e8 56 10 00 00       	call   8012d3 <sys_cputs>
  80027d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800280:	8b 45 0c             	mov    0xc(%ebp),%eax
  800283:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80028c:	8b 40 04             	mov    0x4(%eax),%eax
  80028f:	8d 50 01             	lea    0x1(%eax),%edx
  800292:	8b 45 0c             	mov    0xc(%ebp),%eax
  800295:	89 50 04             	mov    %edx,0x4(%eax)
}
  800298:	90                   	nop
  800299:	c9                   	leave  
  80029a:	c3                   	ret    

0080029b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80029b:	55                   	push   %ebp
  80029c:	89 e5                	mov    %esp,%ebp
  80029e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ab:	00 00 00 
	b.cnt = 0;
  8002ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002b5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002b8:	ff 75 0c             	pushl  0xc(%ebp)
  8002bb:	ff 75 08             	pushl  0x8(%ebp)
  8002be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c4:	50                   	push   %eax
  8002c5:	68 32 02 80 00       	push   $0x800232
  8002ca:	e8 11 02 00 00       	call   8004e0 <vprintfmt>
  8002cf:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002d2:	a0 0c 30 80 00       	mov    0x80300c,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	50                   	push   %eax
  8002e4:	52                   	push   %edx
  8002e5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002eb:	83 c0 08             	add    $0x8,%eax
  8002ee:	50                   	push   %eax
  8002ef:	e8 df 0f 00 00       	call   8012d3 <sys_cputs>
  8002f4:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002f7:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8002fe:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800304:	c9                   	leave  
  800305:	c3                   	ret    

00800306 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80030c:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800313:	8d 45 0c             	lea    0xc(%ebp),%eax
  800316:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	83 ec 08             	sub    $0x8,%esp
  80031f:	ff 75 f4             	pushl  -0xc(%ebp)
  800322:	50                   	push   %eax
  800323:	e8 73 ff ff ff       	call   80029b <vcprintf>
  800328:	83 c4 10             	add    $0x10,%esp
  80032b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800331:	c9                   	leave  
  800332:	c3                   	ret    

00800333 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800333:	55                   	push   %ebp
  800334:	89 e5                	mov    %esp,%ebp
  800336:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800339:	e8 d7 0f 00 00       	call   801315 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80033e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800344:	8b 45 08             	mov    0x8(%ebp),%eax
  800347:	83 ec 08             	sub    $0x8,%esp
  80034a:	ff 75 f4             	pushl  -0xc(%ebp)
  80034d:	50                   	push   %eax
  80034e:	e8 48 ff ff ff       	call   80029b <vcprintf>
  800353:	83 c4 10             	add    $0x10,%esp
  800356:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800359:	e8 d1 0f 00 00       	call   80132f <sys_unlock_cons>
	return cnt;
  80035e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800361:	c9                   	leave  
  800362:	c3                   	ret    

00800363 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800363:	55                   	push   %ebp
  800364:	89 e5                	mov    %esp,%ebp
  800366:	53                   	push   %ebx
  800367:	83 ec 14             	sub    $0x14,%esp
  80036a:	8b 45 10             	mov    0x10(%ebp),%eax
  80036d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800370:	8b 45 14             	mov    0x14(%ebp),%eax
  800373:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800376:	8b 45 18             	mov    0x18(%ebp),%eax
  800379:	ba 00 00 00 00       	mov    $0x0,%edx
  80037e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800381:	77 55                	ja     8003d8 <printnum+0x75>
  800383:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800386:	72 05                	jb     80038d <printnum+0x2a>
  800388:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038b:	77 4b                	ja     8003d8 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80038d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800390:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800393:	8b 45 18             	mov    0x18(%ebp),%eax
  800396:	ba 00 00 00 00       	mov    $0x0,%edx
  80039b:	52                   	push   %edx
  80039c:	50                   	push   %eax
  80039d:	ff 75 f4             	pushl  -0xc(%ebp)
  8003a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8003a3:	e8 c4 17 00 00       	call   801b6c <__udivdi3>
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	83 ec 04             	sub    $0x4,%esp
  8003ae:	ff 75 20             	pushl  0x20(%ebp)
  8003b1:	53                   	push   %ebx
  8003b2:	ff 75 18             	pushl  0x18(%ebp)
  8003b5:	52                   	push   %edx
  8003b6:	50                   	push   %eax
  8003b7:	ff 75 0c             	pushl  0xc(%ebp)
  8003ba:	ff 75 08             	pushl  0x8(%ebp)
  8003bd:	e8 a1 ff ff ff       	call   800363 <printnum>
  8003c2:	83 c4 20             	add    $0x20,%esp
  8003c5:	eb 1a                	jmp    8003e1 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	ff 75 0c             	pushl  0xc(%ebp)
  8003cd:	ff 75 20             	pushl  0x20(%ebp)
  8003d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d3:	ff d0                	call   *%eax
  8003d5:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003d8:	ff 4d 1c             	decl   0x1c(%ebp)
  8003db:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003df:	7f e6                	jg     8003c7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e1:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ef:	53                   	push   %ebx
  8003f0:	51                   	push   %ecx
  8003f1:	52                   	push   %edx
  8003f2:	50                   	push   %eax
  8003f3:	e8 84 18 00 00       	call   801c7c <__umoddi3>
  8003f8:	83 c4 10             	add    $0x10,%esp
  8003fb:	05 14 21 80 00       	add    $0x802114,%eax
  800400:	8a 00                	mov    (%eax),%al
  800402:	0f be c0             	movsbl %al,%eax
  800405:	83 ec 08             	sub    $0x8,%esp
  800408:	ff 75 0c             	pushl  0xc(%ebp)
  80040b:	50                   	push   %eax
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	ff d0                	call   *%eax
  800411:	83 c4 10             	add    $0x10,%esp
}
  800414:	90                   	nop
  800415:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80041d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800421:	7e 1c                	jle    80043f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	8b 00                	mov    (%eax),%eax
  800428:	8d 50 08             	lea    0x8(%eax),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	89 10                	mov    %edx,(%eax)
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	8b 00                	mov    (%eax),%eax
  800435:	83 e8 08             	sub    $0x8,%eax
  800438:	8b 50 04             	mov    0x4(%eax),%edx
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	eb 40                	jmp    80047f <getuint+0x65>
	else if (lflag)
  80043f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800443:	74 1e                	je     800463 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	8d 50 04             	lea    0x4(%eax),%edx
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	89 10                	mov    %edx,(%eax)
  800452:	8b 45 08             	mov    0x8(%ebp),%eax
  800455:	8b 00                	mov    (%eax),%eax
  800457:	83 e8 04             	sub    $0x4,%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	ba 00 00 00 00       	mov    $0x0,%edx
  800461:	eb 1c                	jmp    80047f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800463:	8b 45 08             	mov    0x8(%ebp),%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	8d 50 04             	lea    0x4(%eax),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 10                	mov    %edx,(%eax)
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	83 e8 04             	sub    $0x4,%eax
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80047f:	5d                   	pop    %ebp
  800480:	c3                   	ret    

00800481 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800481:	55                   	push   %ebp
  800482:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800484:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800488:	7e 1c                	jle    8004a6 <getint+0x25>
		return va_arg(*ap, long long);
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	8d 50 08             	lea    0x8(%eax),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	89 10                	mov    %edx,(%eax)
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	8b 00                	mov    (%eax),%eax
  80049c:	83 e8 08             	sub    $0x8,%eax
  80049f:	8b 50 04             	mov    0x4(%eax),%edx
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	eb 38                	jmp    8004de <getint+0x5d>
	else if (lflag)
  8004a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004aa:	74 1a                	je     8004c6 <getint+0x45>
		return va_arg(*ap, long);
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	8d 50 04             	lea    0x4(%eax),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)
  8004b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bc:	8b 00                	mov    (%eax),%eax
  8004be:	83 e8 04             	sub    $0x4,%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	99                   	cltd   
  8004c4:	eb 18                	jmp    8004de <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	8d 50 04             	lea    0x4(%eax),%edx
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	89 10                	mov    %edx,(%eax)
  8004d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d6:	8b 00                	mov    (%eax),%eax
  8004d8:	83 e8 04             	sub    $0x4,%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	99                   	cltd   
}
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    

008004e0 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	56                   	push   %esi
  8004e4:	53                   	push   %ebx
  8004e5:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004e8:	eb 17                	jmp    800501 <vprintfmt+0x21>
			if (ch == '\0')
  8004ea:	85 db                	test   %ebx,%ebx
  8004ec:	0f 84 c1 03 00 00    	je     8008b3 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	ff 75 0c             	pushl  0xc(%ebp)
  8004f8:	53                   	push   %ebx
  8004f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fc:	ff d0                	call   *%eax
  8004fe:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800501:	8b 45 10             	mov    0x10(%ebp),%eax
  800504:	8d 50 01             	lea    0x1(%eax),%edx
  800507:	89 55 10             	mov    %edx,0x10(%ebp)
  80050a:	8a 00                	mov    (%eax),%al
  80050c:	0f b6 d8             	movzbl %al,%ebx
  80050f:	83 fb 25             	cmp    $0x25,%ebx
  800512:	75 d6                	jne    8004ea <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800514:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800518:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80051f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800526:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80052d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800534:	8b 45 10             	mov    0x10(%ebp),%eax
  800537:	8d 50 01             	lea    0x1(%eax),%edx
  80053a:	89 55 10             	mov    %edx,0x10(%ebp)
  80053d:	8a 00                	mov    (%eax),%al
  80053f:	0f b6 d8             	movzbl %al,%ebx
  800542:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800545:	83 f8 5b             	cmp    $0x5b,%eax
  800548:	0f 87 3d 03 00 00    	ja     80088b <vprintfmt+0x3ab>
  80054e:	8b 04 85 38 21 80 00 	mov    0x802138(,%eax,4),%eax
  800555:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800557:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80055b:	eb d7                	jmp    800534 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80055d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800561:	eb d1                	jmp    800534 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800563:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80056a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80056d:	89 d0                	mov    %edx,%eax
  80056f:	c1 e0 02             	shl    $0x2,%eax
  800572:	01 d0                	add    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d8                	add    %ebx,%eax
  800578:	83 e8 30             	sub    $0x30,%eax
  80057b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80057e:	8b 45 10             	mov    0x10(%ebp),%eax
  800581:	8a 00                	mov    (%eax),%al
  800583:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800586:	83 fb 2f             	cmp    $0x2f,%ebx
  800589:	7e 3e                	jle    8005c9 <vprintfmt+0xe9>
  80058b:	83 fb 39             	cmp    $0x39,%ebx
  80058e:	7f 39                	jg     8005c9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800590:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800593:	eb d5                	jmp    80056a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	83 c0 04             	add    $0x4,%eax
  80059b:	89 45 14             	mov    %eax,0x14(%ebp)
  80059e:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a1:	83 e8 04             	sub    $0x4,%eax
  8005a4:	8b 00                	mov    (%eax),%eax
  8005a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8005a9:	eb 1f                	jmp    8005ca <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8005ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005af:	79 83                	jns    800534 <vprintfmt+0x54>
				width = 0;
  8005b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005b8:	e9 77 ff ff ff       	jmp    800534 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005bd:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005c4:	e9 6b ff ff ff       	jmp    800534 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005c9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ce:	0f 89 60 ff ff ff    	jns    800534 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005da:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005e1:	e9 4e ff ff ff       	jmp    800534 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005e6:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005e9:	e9 46 ff ff ff       	jmp    800534 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	83 c0 04             	add    $0x4,%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	83 e8 04             	sub    $0x4,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	8b 45 08             	mov    0x8(%ebp),%eax
  800609:	ff d0                	call   *%eax
  80060b:	83 c4 10             	add    $0x10,%esp
			break;
  80060e:	e9 9b 02 00 00       	jmp    8008ae <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 c0 04             	add    $0x4,%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
  80061c:	8b 45 14             	mov    0x14(%ebp),%eax
  80061f:	83 e8 04             	sub    $0x4,%eax
  800622:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800624:	85 db                	test   %ebx,%ebx
  800626:	79 02                	jns    80062a <vprintfmt+0x14a>
				err = -err;
  800628:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80062a:	83 fb 64             	cmp    $0x64,%ebx
  80062d:	7f 0b                	jg     80063a <vprintfmt+0x15a>
  80062f:	8b 34 9d 80 1f 80 00 	mov    0x801f80(,%ebx,4),%esi
  800636:	85 f6                	test   %esi,%esi
  800638:	75 19                	jne    800653 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80063a:	53                   	push   %ebx
  80063b:	68 25 21 80 00       	push   $0x802125
  800640:	ff 75 0c             	pushl  0xc(%ebp)
  800643:	ff 75 08             	pushl  0x8(%ebp)
  800646:	e8 70 02 00 00       	call   8008bb <printfmt>
  80064b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80064e:	e9 5b 02 00 00       	jmp    8008ae <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800653:	56                   	push   %esi
  800654:	68 2e 21 80 00       	push   $0x80212e
  800659:	ff 75 0c             	pushl  0xc(%ebp)
  80065c:	ff 75 08             	pushl  0x8(%ebp)
  80065f:	e8 57 02 00 00       	call   8008bb <printfmt>
  800664:	83 c4 10             	add    $0x10,%esp
			break;
  800667:	e9 42 02 00 00       	jmp    8008ae <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 c0 04             	add    $0x4,%eax
  800672:	89 45 14             	mov    %eax,0x14(%ebp)
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	83 e8 04             	sub    $0x4,%eax
  80067b:	8b 30                	mov    (%eax),%esi
  80067d:	85 f6                	test   %esi,%esi
  80067f:	75 05                	jne    800686 <vprintfmt+0x1a6>
				p = "(null)";
  800681:	be 31 21 80 00       	mov    $0x802131,%esi
			if (width > 0 && padc != '-')
  800686:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068a:	7e 6d                	jle    8006f9 <vprintfmt+0x219>
  80068c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800690:	74 67                	je     8006f9 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800695:	83 ec 08             	sub    $0x8,%esp
  800698:	50                   	push   %eax
  800699:	56                   	push   %esi
  80069a:	e8 26 05 00 00       	call   800bc5 <strnlen>
  80069f:	83 c4 10             	add    $0x10,%esp
  8006a2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8006a5:	eb 16                	jmp    8006bd <vprintfmt+0x1dd>
					putch(padc, putdat);
  8006a7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	ff 75 0c             	pushl  0xc(%ebp)
  8006b1:	50                   	push   %eax
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	ff d0                	call   *%eax
  8006b7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ba:	ff 4d e4             	decl   -0x1c(%ebp)
  8006bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c1:	7f e4                	jg     8006a7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c3:	eb 34                	jmp    8006f9 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006c5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006c9:	74 1c                	je     8006e7 <vprintfmt+0x207>
  8006cb:	83 fb 1f             	cmp    $0x1f,%ebx
  8006ce:	7e 05                	jle    8006d5 <vprintfmt+0x1f5>
  8006d0:	83 fb 7e             	cmp    $0x7e,%ebx
  8006d3:	7e 12                	jle    8006e7 <vprintfmt+0x207>
					putch('?', putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	ff 75 0c             	pushl  0xc(%ebp)
  8006db:	6a 3f                	push   $0x3f
  8006dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e0:	ff d0                	call   *%eax
  8006e2:	83 c4 10             	add    $0x10,%esp
  8006e5:	eb 0f                	jmp    8006f6 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006e7:	83 ec 08             	sub    $0x8,%esp
  8006ea:	ff 75 0c             	pushl  0xc(%ebp)
  8006ed:	53                   	push   %ebx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	ff d0                	call   *%eax
  8006f3:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006f6:	ff 4d e4             	decl   -0x1c(%ebp)
  8006f9:	89 f0                	mov    %esi,%eax
  8006fb:	8d 70 01             	lea    0x1(%eax),%esi
  8006fe:	8a 00                	mov    (%eax),%al
  800700:	0f be d8             	movsbl %al,%ebx
  800703:	85 db                	test   %ebx,%ebx
  800705:	74 24                	je     80072b <vprintfmt+0x24b>
  800707:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80070b:	78 b8                	js     8006c5 <vprintfmt+0x1e5>
  80070d:	ff 4d e0             	decl   -0x20(%ebp)
  800710:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800714:	79 af                	jns    8006c5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800716:	eb 13                	jmp    80072b <vprintfmt+0x24b>
				putch(' ', putdat);
  800718:	83 ec 08             	sub    $0x8,%esp
  80071b:	ff 75 0c             	pushl  0xc(%ebp)
  80071e:	6a 20                	push   $0x20
  800720:	8b 45 08             	mov    0x8(%ebp),%eax
  800723:	ff d0                	call   *%eax
  800725:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800728:	ff 4d e4             	decl   -0x1c(%ebp)
  80072b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072f:	7f e7                	jg     800718 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800731:	e9 78 01 00 00       	jmp    8008ae <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800736:	83 ec 08             	sub    $0x8,%esp
  800739:	ff 75 e8             	pushl  -0x18(%ebp)
  80073c:	8d 45 14             	lea    0x14(%ebp),%eax
  80073f:	50                   	push   %eax
  800740:	e8 3c fd ff ff       	call   800481 <getint>
  800745:	83 c4 10             	add    $0x10,%esp
  800748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80074e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800751:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800754:	85 d2                	test   %edx,%edx
  800756:	79 23                	jns    80077b <vprintfmt+0x29b>
				putch('-', putdat);
  800758:	83 ec 08             	sub    $0x8,%esp
  80075b:	ff 75 0c             	pushl  0xc(%ebp)
  80075e:	6a 2d                	push   $0x2d
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	ff d0                	call   *%eax
  800765:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076e:	f7 d8                	neg    %eax
  800770:	83 d2 00             	adc    $0x0,%edx
  800773:	f7 da                	neg    %edx
  800775:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800778:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80077b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800782:	e9 bc 00 00 00       	jmp    800843 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800787:	83 ec 08             	sub    $0x8,%esp
  80078a:	ff 75 e8             	pushl  -0x18(%ebp)
  80078d:	8d 45 14             	lea    0x14(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	e8 84 fc ff ff       	call   80041a <getuint>
  800796:	83 c4 10             	add    $0x10,%esp
  800799:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80079f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007a6:	e9 98 00 00 00       	jmp    800843 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 0c             	pushl  0xc(%ebp)
  8007b1:	6a 58                	push   $0x58
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	ff d0                	call   *%eax
  8007b8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007bb:	83 ec 08             	sub    $0x8,%esp
  8007be:	ff 75 0c             	pushl  0xc(%ebp)
  8007c1:	6a 58                	push   $0x58
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	ff d0                	call   *%eax
  8007c8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	6a 58                	push   $0x58
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	ff d0                	call   *%eax
  8007d8:	83 c4 10             	add    $0x10,%esp
			break;
  8007db:	e9 ce 00 00 00       	jmp    8008ae <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007e0:	83 ec 08             	sub    $0x8,%esp
  8007e3:	ff 75 0c             	pushl  0xc(%ebp)
  8007e6:	6a 30                	push   $0x30
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	ff d0                	call   *%eax
  8007ed:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007f0:	83 ec 08             	sub    $0x8,%esp
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	6a 78                	push   $0x78
  8007f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fb:	ff d0                	call   *%eax
  8007fd:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800811:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80081b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800822:	eb 1f                	jmp    800843 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 e8             	pushl  -0x18(%ebp)
  80082a:	8d 45 14             	lea    0x14(%ebp),%eax
  80082d:	50                   	push   %eax
  80082e:	e8 e7 fb ff ff       	call   80041a <getuint>
  800833:	83 c4 10             	add    $0x10,%esp
  800836:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800839:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80083c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800843:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80084a:	83 ec 04             	sub    $0x4,%esp
  80084d:	52                   	push   %edx
  80084e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800851:	50                   	push   %eax
  800852:	ff 75 f4             	pushl  -0xc(%ebp)
  800855:	ff 75 f0             	pushl  -0x10(%ebp)
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	ff 75 08             	pushl  0x8(%ebp)
  80085e:	e8 00 fb ff ff       	call   800363 <printnum>
  800863:	83 c4 20             	add    $0x20,%esp
			break;
  800866:	eb 46                	jmp    8008ae <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	53                   	push   %ebx
  80086f:	8b 45 08             	mov    0x8(%ebp),%eax
  800872:	ff d0                	call   *%eax
  800874:	83 c4 10             	add    $0x10,%esp
			break;
  800877:	eb 35                	jmp    8008ae <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800879:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800880:	eb 2c                	jmp    8008ae <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800882:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800889:	eb 23                	jmp    8008ae <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80088b:	83 ec 08             	sub    $0x8,%esp
  80088e:	ff 75 0c             	pushl  0xc(%ebp)
  800891:	6a 25                	push   $0x25
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	ff d0                	call   *%eax
  800898:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089b:	ff 4d 10             	decl   0x10(%ebp)
  80089e:	eb 03                	jmp    8008a3 <vprintfmt+0x3c3>
  8008a0:	ff 4d 10             	decl   0x10(%ebp)
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	48                   	dec    %eax
  8008a7:	8a 00                	mov    (%eax),%al
  8008a9:	3c 25                	cmp    $0x25,%al
  8008ab:	75 f3                	jne    8008a0 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  8008ad:	90                   	nop
		}
	}
  8008ae:	e9 35 fc ff ff       	jmp    8004e8 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008b3:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008b7:	5b                   	pop    %ebx
  8008b8:	5e                   	pop    %esi
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008c1:	8d 45 10             	lea    0x10(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	ff 75 0c             	pushl  0xc(%ebp)
  8008d4:	ff 75 08             	pushl  0x8(%ebp)
  8008d7:	e8 04 fc ff ff       	call   8004e0 <vprintfmt>
  8008dc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008df:	90                   	nop
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    

008008e2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e8:	8b 40 08             	mov    0x8(%eax),%eax
  8008eb:	8d 50 01             	lea    0x1(%eax),%edx
  8008ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f7:	8b 10                	mov    (%eax),%edx
  8008f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fc:	8b 40 04             	mov    0x4(%eax),%eax
  8008ff:	39 c2                	cmp    %eax,%edx
  800901:	73 12                	jae    800915 <sprintputch+0x33>
		*b->buf++ = ch;
  800903:	8b 45 0c             	mov    0xc(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 48 01             	lea    0x1(%eax),%ecx
  80090b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090e:	89 0a                	mov    %ecx,(%edx)
  800910:	8b 55 08             	mov    0x8(%ebp),%edx
  800913:	88 10                	mov    %dl,(%eax)
}
  800915:	90                   	nop
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800924:	8b 45 0c             	mov    0xc(%ebp),%eax
  800927:	8d 50 ff             	lea    -0x1(%eax),%edx
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	01 d0                	add    %edx,%eax
  80092f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093d:	74 06                	je     800945 <vsnprintf+0x2d>
  80093f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800943:	7f 07                	jg     80094c <vsnprintf+0x34>
		return -E_INVAL;
  800945:	b8 03 00 00 00       	mov    $0x3,%eax
  80094a:	eb 20                	jmp    80096c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80094c:	ff 75 14             	pushl  0x14(%ebp)
  80094f:	ff 75 10             	pushl  0x10(%ebp)
  800952:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800955:	50                   	push   %eax
  800956:	68 e2 08 80 00       	push   $0x8008e2
  80095b:	e8 80 fb ff ff       	call   8004e0 <vprintfmt>
  800960:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800963:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800966:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800969:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800974:	8d 45 10             	lea    0x10(%ebp),%eax
  800977:	83 c0 04             	add    $0x4,%eax
  80097a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80097d:	8b 45 10             	mov    0x10(%ebp),%eax
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	e8 89 ff ff ff       	call   800918 <vsnprintf>
  80098f:	83 c4 10             	add    $0x10,%esp
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  8009a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a4:	74 13                	je     8009b9 <readline+0x1f>
		cprintf("%s", prompt);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 08             	pushl  0x8(%ebp)
  8009ac:	68 a8 22 80 00       	push   $0x8022a8
  8009b1:	e8 50 f9 ff ff       	call   800306 <cprintf>
  8009b6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009c0:	83 ec 0c             	sub    $0xc,%esp
  8009c3:	6a 00                	push   $0x0
  8009c5:	e8 ad 0f 00 00       	call   801977 <iscons>
  8009ca:	83 c4 10             	add    $0x10,%esp
  8009cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009d0:	e8 8f 0f 00 00       	call   801964 <getchar>
  8009d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009dc:	79 22                	jns    800a00 <readline+0x66>
			if (c != -E_EOF)
  8009de:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009e2:	0f 84 ad 00 00 00    	je     800a95 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8009ee:	68 ab 22 80 00       	push   $0x8022ab
  8009f3:	e8 0e f9 ff ff       	call   800306 <cprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
			break;
  8009fb:	e9 95 00 00 00       	jmp    800a95 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  800a00:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800a04:	7e 34                	jle    800a3a <readline+0xa0>
  800a06:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800a0d:	7f 2b                	jg     800a3a <readline+0xa0>
			if (echoing)
  800a0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a13:	74 0e                	je     800a23 <readline+0x89>
				cputchar(c);
  800a15:	83 ec 0c             	sub    $0xc,%esp
  800a18:	ff 75 ec             	pushl  -0x14(%ebp)
  800a1b:	e8 25 0f 00 00       	call   801945 <cputchar>
  800a20:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a26:	8d 50 01             	lea    0x1(%eax),%edx
  800a29:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a2c:	89 c2                	mov    %eax,%edx
  800a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a31:	01 d0                	add    %edx,%eax
  800a33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a36:	88 10                	mov    %dl,(%eax)
  800a38:	eb 56                	jmp    800a90 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a3a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a3e:	75 1f                	jne    800a5f <readline+0xc5>
  800a40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a44:	7e 19                	jle    800a5f <readline+0xc5>
			if (echoing)
  800a46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a4a:	74 0e                	je     800a5a <readline+0xc0>
				cputchar(c);
  800a4c:	83 ec 0c             	sub    $0xc,%esp
  800a4f:	ff 75 ec             	pushl  -0x14(%ebp)
  800a52:	e8 ee 0e 00 00       	call   801945 <cputchar>
  800a57:	83 c4 10             	add    $0x10,%esp

			i--;
  800a5a:	ff 4d f4             	decl   -0xc(%ebp)
  800a5d:	eb 31                	jmp    800a90 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a5f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a63:	74 0a                	je     800a6f <readline+0xd5>
  800a65:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a69:	0f 85 61 ff ff ff    	jne    8009d0 <readline+0x36>
			if (echoing)
  800a6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a73:	74 0e                	je     800a83 <readline+0xe9>
				cputchar(c);
  800a75:	83 ec 0c             	sub    $0xc,%esp
  800a78:	ff 75 ec             	pushl  -0x14(%ebp)
  800a7b:	e8 c5 0e 00 00       	call   801945 <cputchar>
  800a80:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	01 d0                	add    %edx,%eax
  800a8b:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a8e:	eb 06                	jmp    800a96 <readline+0xfc>
		}
	}
  800a90:	e9 3b ff ff ff       	jmp    8009d0 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a95:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a96:	90                   	nop
  800a97:	c9                   	leave  
  800a98:	c3                   	ret    

00800a99 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a99:	55                   	push   %ebp
  800a9a:	89 e5                	mov    %esp,%ebp
  800a9c:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a9f:	e8 71 08 00 00       	call   801315 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800aa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aa8:	74 13                	je     800abd <atomic_readline+0x24>
			cprintf("%s", prompt);
  800aaa:	83 ec 08             	sub    $0x8,%esp
  800aad:	ff 75 08             	pushl  0x8(%ebp)
  800ab0:	68 a8 22 80 00       	push   $0x8022a8
  800ab5:	e8 4c f8 ff ff       	call   800306 <cprintf>
  800aba:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800abd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800ac4:	83 ec 0c             	sub    $0xc,%esp
  800ac7:	6a 00                	push   $0x0
  800ac9:	e8 a9 0e 00 00       	call   801977 <iscons>
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ad4:	e8 8b 0e 00 00       	call   801964 <getchar>
  800ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800adc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ae0:	79 22                	jns    800b04 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ae2:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ae6:	0f 84 ad 00 00 00    	je     800b99 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800aec:	83 ec 08             	sub    $0x8,%esp
  800aef:	ff 75 ec             	pushl  -0x14(%ebp)
  800af2:	68 ab 22 80 00       	push   $0x8022ab
  800af7:	e8 0a f8 ff ff       	call   800306 <cprintf>
  800afc:	83 c4 10             	add    $0x10,%esp
				break;
  800aff:	e9 95 00 00 00       	jmp    800b99 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800b04:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800b08:	7e 34                	jle    800b3e <atomic_readline+0xa5>
  800b0a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800b11:	7f 2b                	jg     800b3e <atomic_readline+0xa5>
				if (echoing)
  800b13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b17:	74 0e                	je     800b27 <atomic_readline+0x8e>
					cputchar(c);
  800b19:	83 ec 0c             	sub    $0xc,%esp
  800b1c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b1f:	e8 21 0e 00 00       	call   801945 <cputchar>
  800b24:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b2a:	8d 50 01             	lea    0x1(%eax),%edx
  800b2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b30:	89 c2                	mov    %eax,%edx
  800b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b35:	01 d0                	add    %edx,%eax
  800b37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b3a:	88 10                	mov    %dl,(%eax)
  800b3c:	eb 56                	jmp    800b94 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b3e:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b42:	75 1f                	jne    800b63 <atomic_readline+0xca>
  800b44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b48:	7e 19                	jle    800b63 <atomic_readline+0xca>
				if (echoing)
  800b4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b4e:	74 0e                	je     800b5e <atomic_readline+0xc5>
					cputchar(c);
  800b50:	83 ec 0c             	sub    $0xc,%esp
  800b53:	ff 75 ec             	pushl  -0x14(%ebp)
  800b56:	e8 ea 0d 00 00       	call   801945 <cputchar>
  800b5b:	83 c4 10             	add    $0x10,%esp
				i--;
  800b5e:	ff 4d f4             	decl   -0xc(%ebp)
  800b61:	eb 31                	jmp    800b94 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b63:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b67:	74 0a                	je     800b73 <atomic_readline+0xda>
  800b69:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b6d:	0f 85 61 ff ff ff    	jne    800ad4 <atomic_readline+0x3b>
				if (echoing)
  800b73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b77:	74 0e                	je     800b87 <atomic_readline+0xee>
					cputchar(c);
  800b79:	83 ec 0c             	sub    $0xc,%esp
  800b7c:	ff 75 ec             	pushl  -0x14(%ebp)
  800b7f:	e8 c1 0d 00 00       	call   801945 <cputchar>
  800b84:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8d:	01 d0                	add    %edx,%eax
  800b8f:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b92:	eb 06                	jmp    800b9a <atomic_readline+0x101>
			}
		}
  800b94:	e9 3b ff ff ff       	jmp    800ad4 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b99:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b9a:	e8 90 07 00 00       	call   80132f <sys_unlock_cons>
}
  800b9f:	90                   	nop
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800baf:	eb 06                	jmp    800bb7 <strlen+0x15>
		n++;
  800bb1:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb4:	ff 45 08             	incl   0x8(%ebp)
  800bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	84 c0                	test   %al,%al
  800bbe:	75 f1                	jne    800bb1 <strlen+0xf>
		n++;
	return n;
  800bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc3:	c9                   	leave  
  800bc4:	c3                   	ret    

00800bc5 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bcb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd2:	eb 09                	jmp    800bdd <strnlen+0x18>
		n++;
  800bd4:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	ff 4d 0c             	decl   0xc(%ebp)
  800bdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be1:	74 09                	je     800bec <strnlen+0x27>
  800be3:	8b 45 08             	mov    0x8(%ebp),%eax
  800be6:	8a 00                	mov    (%eax),%al
  800be8:	84 c0                	test   %al,%al
  800bea:	75 e8                	jne    800bd4 <strnlen+0xf>
		n++;
	return n;
  800bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bfd:	90                   	nop
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	8d 50 01             	lea    0x1(%eax),%edx
  800c04:	89 55 08             	mov    %edx,0x8(%ebp)
  800c07:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c10:	8a 12                	mov    (%edx),%dl
  800c12:	88 10                	mov    %dl,(%eax)
  800c14:	8a 00                	mov    (%eax),%al
  800c16:	84 c0                	test   %al,%al
  800c18:	75 e4                	jne    800bfe <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c32:	eb 1f                	jmp    800c53 <strncpy+0x34>
		*dst++ = *src;
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8d 50 01             	lea    0x1(%eax),%edx
  800c3a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c40:	8a 12                	mov    (%edx),%dl
  800c42:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	8a 00                	mov    (%eax),%al
  800c49:	84 c0                	test   %al,%al
  800c4b:	74 03                	je     800c50 <strncpy+0x31>
			src++;
  800c4d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c50:	ff 45 fc             	incl   -0x4(%ebp)
  800c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c56:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c59:	72 d9                	jb     800c34 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c70:	74 30                	je     800ca2 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c72:	eb 16                	jmp    800c8a <strlcpy+0x2a>
			*dst++ = *src++;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	8d 50 01             	lea    0x1(%eax),%edx
  800c7a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c83:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8a:	ff 4d 10             	decl   0x10(%ebp)
  800c8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c91:	74 09                	je     800c9c <strlcpy+0x3c>
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8a 00                	mov    (%eax),%al
  800c98:	84 c0                	test   %al,%al
  800c9a:	75 d8                	jne    800c74 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca8:	29 c2                	sub    %eax,%edx
  800caa:	89 d0                	mov    %edx,%eax
}
  800cac:	c9                   	leave  
  800cad:	c3                   	ret    

00800cae <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb1:	eb 06                	jmp    800cb9 <strcmp+0xb>
		p++, q++;
  800cb3:	ff 45 08             	incl   0x8(%ebp)
  800cb6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	74 0e                	je     800cd0 <strcmp+0x22>
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	8a 10                	mov    (%eax),%dl
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	38 c2                	cmp    %al,%dl
  800cce:	74 e3                	je     800cb3 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	8a 00                	mov    (%eax),%al
  800cd5:	0f b6 d0             	movzbl %al,%edx
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	8a 00                	mov    (%eax),%al
  800cdd:	0f b6 c0             	movzbl %al,%eax
  800ce0:	29 c2                	sub    %eax,%edx
  800ce2:	89 d0                	mov    %edx,%eax
}
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ce9:	eb 09                	jmp    800cf4 <strncmp+0xe>
		n--, p++, q++;
  800ceb:	ff 4d 10             	decl   0x10(%ebp)
  800cee:	ff 45 08             	incl   0x8(%ebp)
  800cf1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf8:	74 17                	je     800d11 <strncmp+0x2b>
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	8a 00                	mov    (%eax),%al
  800cff:	84 c0                	test   %al,%al
  800d01:	74 0e                	je     800d11 <strncmp+0x2b>
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 10                	mov    (%eax),%dl
  800d08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	38 c2                	cmp    %al,%dl
  800d0f:	74 da                	je     800ceb <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d15:	75 07                	jne    800d1e <strncmp+0x38>
		return 0;
  800d17:	b8 00 00 00 00       	mov    $0x0,%eax
  800d1c:	eb 14                	jmp    800d32 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 d0             	movzbl %al,%edx
  800d26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d29:	8a 00                	mov    (%eax),%al
  800d2b:	0f b6 c0             	movzbl %al,%eax
  800d2e:	29 c2                	sub    %eax,%edx
  800d30:	89 d0                	mov    %edx,%eax
}
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 04             	sub    $0x4,%esp
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d40:	eb 12                	jmp    800d54 <strchr+0x20>
		if (*s == c)
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4a:	75 05                	jne    800d51 <strchr+0x1d>
			return (char *) s;
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	eb 11                	jmp    800d62 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d51:	ff 45 08             	incl   0x8(%ebp)
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	84 c0                	test   %al,%al
  800d5b:	75 e5                	jne    800d42 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	83 ec 04             	sub    $0x4,%esp
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d70:	eb 0d                	jmp    800d7f <strfind+0x1b>
		if (*s == c)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7a:	74 0e                	je     800d8a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	84 c0                	test   %al,%al
  800d86:	75 ea                	jne    800d72 <strfind+0xe>
  800d88:	eb 01                	jmp    800d8b <strfind+0x27>
		if (*s == c)
			break;
  800d8a:	90                   	nop
	return (char *) s;
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d8e:	c9                   	leave  
  800d8f:	c3                   	ret    

00800d90 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d90:	55                   	push   %ebp
  800d91:	89 e5                	mov    %esp,%ebp
  800d93:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da2:	eb 0e                	jmp    800db2 <memset+0x22>
		*p++ = c;
  800da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da7:	8d 50 01             	lea    0x1(%eax),%edx
  800daa:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db0:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db2:	ff 4d f8             	decl   -0x8(%ebp)
  800db5:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800db9:	79 e9                	jns    800da4 <memset+0x14>
		*p++ = c;

	return v;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd2:	eb 16                	jmp    800dea <memcpy+0x2a>
		*d++ = *s++;
  800dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dd7:	8d 50 01             	lea    0x1(%eax),%edx
  800dda:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ddd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800de6:	8a 12                	mov    (%edx),%dl
  800de8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dea:	8b 45 10             	mov    0x10(%ebp),%eax
  800ded:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df0:	89 55 10             	mov    %edx,0x10(%ebp)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	75 dd                	jne    800dd4 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e11:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e14:	73 50                	jae    800e66 <memmove+0x6a>
  800e16:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	01 d0                	add    %edx,%eax
  800e1e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e21:	76 43                	jbe    800e66 <memmove+0x6a>
		s += n;
  800e23:	8b 45 10             	mov    0x10(%ebp),%eax
  800e26:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e29:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2c:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e2f:	eb 10                	jmp    800e41 <memmove+0x45>
			*--d = *--s;
  800e31:	ff 4d f8             	decl   -0x8(%ebp)
  800e34:	ff 4d fc             	decl   -0x4(%ebp)
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3a:	8a 10                	mov    (%eax),%dl
  800e3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3f:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e41:	8b 45 10             	mov    0x10(%ebp),%eax
  800e44:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e47:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4a:	85 c0                	test   %eax,%eax
  800e4c:	75 e3                	jne    800e31 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e4e:	eb 23                	jmp    800e73 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e53:	8d 50 01             	lea    0x1(%eax),%edx
  800e56:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e5f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e62:	8a 12                	mov    (%edx),%dl
  800e64:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e66:	8b 45 10             	mov    0x10(%ebp),%eax
  800e69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	75 dd                	jne    800e50 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e76:	c9                   	leave  
  800e77:	c3                   	ret    

00800e78 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8a:	eb 2a                	jmp    800eb6 <memcmp+0x3e>
		if (*s1 != *s2)
  800e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8f:	8a 10                	mov    (%eax),%dl
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	38 c2                	cmp    %al,%dl
  800e98:	74 16                	je     800eb0 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9d:	8a 00                	mov    (%eax),%al
  800e9f:	0f b6 d0             	movzbl %al,%edx
  800ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea5:	8a 00                	mov    (%eax),%al
  800ea7:	0f b6 c0             	movzbl %al,%eax
  800eaa:	29 c2                	sub    %eax,%edx
  800eac:	89 d0                	mov    %edx,%eax
  800eae:	eb 18                	jmp    800ec8 <memcmp+0x50>
		s1++, s2++;
  800eb0:	ff 45 fc             	incl   -0x4(%ebp)
  800eb3:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebc:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	75 c9                	jne    800e8c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800edb:	eb 15                	jmp    800ef2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 00                	mov    (%eax),%al
  800ee2:	0f b6 d0             	movzbl %al,%edx
  800ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee8:	0f b6 c0             	movzbl %al,%eax
  800eeb:	39 c2                	cmp    %eax,%edx
  800eed:	74 0d                	je     800efc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eef:	ff 45 08             	incl   0x8(%ebp)
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ef8:	72 e3                	jb     800edd <memfind+0x13>
  800efa:	eb 01                	jmp    800efd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800efc:	90                   	nop
	return (void *) s;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f0f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f16:	eb 03                	jmp    800f1b <strtol+0x19>
		s++;
  800f18:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 20                	cmp    $0x20,%al
  800f22:	74 f4                	je     800f18 <strtol+0x16>
  800f24:	8b 45 08             	mov    0x8(%ebp),%eax
  800f27:	8a 00                	mov    (%eax),%al
  800f29:	3c 09                	cmp    $0x9,%al
  800f2b:	74 eb                	je     800f18 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f30:	8a 00                	mov    (%eax),%al
  800f32:	3c 2b                	cmp    $0x2b,%al
  800f34:	75 05                	jne    800f3b <strtol+0x39>
		s++;
  800f36:	ff 45 08             	incl   0x8(%ebp)
  800f39:	eb 13                	jmp    800f4e <strtol+0x4c>
	else if (*s == '-')
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	3c 2d                	cmp    $0x2d,%al
  800f42:	75 0a                	jne    800f4e <strtol+0x4c>
		s++, neg = 1;
  800f44:	ff 45 08             	incl   0x8(%ebp)
  800f47:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f52:	74 06                	je     800f5a <strtol+0x58>
  800f54:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f58:	75 20                	jne    800f7a <strtol+0x78>
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	3c 30                	cmp    $0x30,%al
  800f61:	75 17                	jne    800f7a <strtol+0x78>
  800f63:	8b 45 08             	mov    0x8(%ebp),%eax
  800f66:	40                   	inc    %eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	3c 78                	cmp    $0x78,%al
  800f6b:	75 0d                	jne    800f7a <strtol+0x78>
		s += 2, base = 16;
  800f6d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f71:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f78:	eb 28                	jmp    800fa2 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	75 15                	jne    800f95 <strtol+0x93>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 30                	cmp    $0x30,%al
  800f87:	75 0c                	jne    800f95 <strtol+0x93>
		s++, base = 8;
  800f89:	ff 45 08             	incl   0x8(%ebp)
  800f8c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f93:	eb 0d                	jmp    800fa2 <strtol+0xa0>
	else if (base == 0)
  800f95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f99:	75 07                	jne    800fa2 <strtol+0xa0>
		base = 10;
  800f9b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	3c 2f                	cmp    $0x2f,%al
  800fa9:	7e 19                	jle    800fc4 <strtol+0xc2>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 39                	cmp    $0x39,%al
  800fb2:	7f 10                	jg     800fc4 <strtol+0xc2>
			dig = *s - '0';
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f be c0             	movsbl %al,%eax
  800fbc:	83 e8 30             	sub    $0x30,%eax
  800fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc2:	eb 42                	jmp    801006 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 60                	cmp    $0x60,%al
  800fcb:	7e 19                	jle    800fe6 <strtol+0xe4>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 7a                	cmp    $0x7a,%al
  800fd4:	7f 10                	jg     800fe6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	0f be c0             	movsbl %al,%eax
  800fde:	83 e8 57             	sub    $0x57,%eax
  800fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe4:	eb 20                	jmp    801006 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	3c 40                	cmp    $0x40,%al
  800fed:	7e 39                	jle    801028 <strtol+0x126>
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	3c 5a                	cmp    $0x5a,%al
  800ff6:	7f 30                	jg     801028 <strtol+0x126>
			dig = *s - 'A' + 10;
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	0f be c0             	movsbl %al,%eax
  801000:	83 e8 37             	sub    $0x37,%eax
  801003:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801009:	3b 45 10             	cmp    0x10(%ebp),%eax
  80100c:	7d 19                	jge    801027 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80100e:	ff 45 08             	incl   0x8(%ebp)
  801011:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801014:	0f af 45 10          	imul   0x10(%ebp),%eax
  801018:	89 c2                	mov    %eax,%edx
  80101a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101d:	01 d0                	add    %edx,%eax
  80101f:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801022:	e9 7b ff ff ff       	jmp    800fa2 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801027:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801028:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80102c:	74 08                	je     801036 <strtol+0x134>
		*endptr = (char *) s;
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801036:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103a:	74 07                	je     801043 <strtol+0x141>
  80103c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80103f:	f7 d8                	neg    %eax
  801041:	eb 03                	jmp    801046 <strtol+0x144>
  801043:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801046:	c9                   	leave  
  801047:	c3                   	ret    

00801048 <ltostr>:

void
ltostr(long value, char *str)
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80104e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801055:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80105c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801060:	79 13                	jns    801075 <ltostr+0x2d>
	{
		neg = 1;
  801062:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80106f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801072:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80107d:	99                   	cltd   
  80107e:	f7 f9                	idiv   %ecx
  801080:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	8d 50 01             	lea    0x1(%eax),%edx
  801089:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108c:	89 c2                	mov    %eax,%edx
  80108e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801091:	01 d0                	add    %edx,%eax
  801093:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801096:	83 c2 30             	add    $0x30,%edx
  801099:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80109b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a3:	f7 e9                	imul   %ecx
  8010a5:	c1 fa 02             	sar    $0x2,%edx
  8010a8:	89 c8                	mov    %ecx,%eax
  8010aa:	c1 f8 1f             	sar    $0x1f,%eax
  8010ad:	29 c2                	sub    %eax,%edx
  8010af:	89 d0                	mov    %edx,%eax
  8010b1:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b8:	75 bb                	jne    801075 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c4:	48                   	dec    %eax
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010cc:	74 3d                	je     80110b <ltostr+0xc3>
		start = 1 ;
  8010ce:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010d5:	eb 34                	jmp    80110b <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	01 d0                	add    %edx,%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ea:	01 c2                	add    %eax,%edx
  8010ec:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f2:	01 c8                	add    %ecx,%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fe:	01 c2                	add    %eax,%edx
  801100:	8a 45 eb             	mov    -0x15(%ebp),%al
  801103:	88 02                	mov    %al,(%edx)
		start++ ;
  801105:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801108:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80110b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801111:	7c c4                	jl     8010d7 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801113:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801116:	8b 45 0c             	mov    0xc(%ebp),%eax
  801119:	01 d0                	add    %edx,%eax
  80111b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80111e:	90                   	nop
  80111f:	c9                   	leave  
  801120:	c3                   	ret    

00801121 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801121:	55                   	push   %ebp
  801122:	89 e5                	mov    %esp,%ebp
  801124:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801127:	ff 75 08             	pushl  0x8(%ebp)
  80112a:	e8 73 fa ff ff       	call   800ba2 <strlen>
  80112f:	83 c4 04             	add    $0x4,%esp
  801132:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801135:	ff 75 0c             	pushl  0xc(%ebp)
  801138:	e8 65 fa ff ff       	call   800ba2 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80114a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801151:	eb 17                	jmp    80116a <strcconcat+0x49>
		final[s] = str1[s] ;
  801153:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801156:	8b 45 10             	mov    0x10(%ebp),%eax
  801159:	01 c2                	add    %eax,%edx
  80115b:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	01 c8                	add    %ecx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801167:	ff 45 fc             	incl   -0x4(%ebp)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801170:	7c e1                	jl     801153 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801172:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801180:	eb 1f                	jmp    8011a1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	8d 50 01             	lea    0x1(%eax),%edx
  801188:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80118b:	89 c2                	mov    %eax,%edx
  80118d:	8b 45 10             	mov    0x10(%ebp),%eax
  801190:	01 c2                	add    %eax,%edx
  801192:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801195:	8b 45 0c             	mov    0xc(%ebp),%eax
  801198:	01 c8                	add    %ecx,%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80119e:	ff 45 f8             	incl   -0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011a7:	7c d9                	jl     801182 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8011af:	01 d0                	add    %edx,%eax
  8011b1:	c6 00 00             	movb   $0x0,(%eax)
}
  8011b4:	90                   	nop
  8011b5:	c9                   	leave  
  8011b6:	c3                   	ret    

008011b7 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011b7:	55                   	push   %ebp
  8011b8:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8011bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c6:	8b 00                	mov    (%eax),%eax
  8011c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d2:	01 d0                	add    %edx,%eax
  8011d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011da:	eb 0c                	jmp    8011e8 <strsplit+0x31>
			*string++ = 0;
  8011dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011df:	8d 50 01             	lea    0x1(%eax),%edx
  8011e2:	89 55 08             	mov    %edx,0x8(%ebp)
  8011e5:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 18                	je     801209 <strsplit+0x52>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	0f be c0             	movsbl %al,%eax
  8011f9:	50                   	push   %eax
  8011fa:	ff 75 0c             	pushl  0xc(%ebp)
  8011fd:	e8 32 fb ff ff       	call   800d34 <strchr>
  801202:	83 c4 08             	add    $0x8,%esp
  801205:	85 c0                	test   %eax,%eax
  801207:	75 d3                	jne    8011dc <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	84 c0                	test   %al,%al
  801210:	74 5a                	je     80126c <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801212:	8b 45 14             	mov    0x14(%ebp),%eax
  801215:	8b 00                	mov    (%eax),%eax
  801217:	83 f8 0f             	cmp    $0xf,%eax
  80121a:	75 07                	jne    801223 <strsplit+0x6c>
		{
			return 0;
  80121c:	b8 00 00 00 00       	mov    $0x0,%eax
  801221:	eb 66                	jmp    801289 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	8b 00                	mov    (%eax),%eax
  801228:	8d 48 01             	lea    0x1(%eax),%ecx
  80122b:	8b 55 14             	mov    0x14(%ebp),%edx
  80122e:	89 0a                	mov    %ecx,(%edx)
  801230:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801237:	8b 45 10             	mov    0x10(%ebp),%eax
  80123a:	01 c2                	add    %eax,%edx
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801241:	eb 03                	jmp    801246 <strsplit+0x8f>
			string++;
  801243:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	8a 00                	mov    (%eax),%al
  80124b:	84 c0                	test   %al,%al
  80124d:	74 8b                	je     8011da <strsplit+0x23>
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	8a 00                	mov    (%eax),%al
  801254:	0f be c0             	movsbl %al,%eax
  801257:	50                   	push   %eax
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	e8 d4 fa ff ff       	call   800d34 <strchr>
  801260:	83 c4 08             	add    $0x8,%esp
  801263:	85 c0                	test   %eax,%eax
  801265:	74 dc                	je     801243 <strsplit+0x8c>
			string++;
	}
  801267:	e9 6e ff ff ff       	jmp    8011da <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80126c:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80126d:	8b 45 14             	mov    0x14(%ebp),%eax
  801270:	8b 00                	mov    (%eax),%eax
  801272:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801279:	8b 45 10             	mov    0x10(%ebp),%eax
  80127c:	01 d0                	add    %edx,%eax
  80127e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801284:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <str2lower>:


char* str2lower(char *dst, const char *src)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  801291:	83 ec 04             	sub    $0x4,%esp
  801294:	68 bc 22 80 00       	push   $0x8022bc
  801299:	68 3f 01 00 00       	push   $0x13f
  80129e:	68 de 22 80 00       	push   $0x8022de
  8012a3:	e8 d9 06 00 00       	call   801981 <_panic>

008012a8 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	57                   	push   %edi
  8012ac:	56                   	push   %esi
  8012ad:	53                   	push   %ebx
  8012ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012c3:	cd 30                	int    $0x30
  8012c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8012c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012cb:	83 c4 10             	add    $0x10,%esp
  8012ce:	5b                   	pop    %ebx
  8012cf:	5e                   	pop    %esi
  8012d0:	5f                   	pop    %edi
  8012d1:	5d                   	pop    %ebp
  8012d2:	c3                   	ret    

008012d3 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	83 ec 04             	sub    $0x4,%esp
  8012d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8012df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e6:	6a 00                	push   $0x0
  8012e8:	6a 00                	push   $0x0
  8012ea:	52                   	push   %edx
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	50                   	push   %eax
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 b2 ff ff ff       	call   8012a8 <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
}
  8012f9:	90                   	nop
  8012fa:	c9                   	leave  
  8012fb:	c3                   	ret    

008012fc <sys_cgetc>:

int sys_cgetc(void) {
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012ff:	6a 00                	push   $0x0
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	6a 02                	push   $0x2
  80130b:	e8 98 ff ff ff       	call   8012a8 <syscall>
  801310:	83 c4 18             	add    $0x18,%esp
}
  801313:	c9                   	leave  
  801314:	c3                   	ret    

00801315 <sys_lock_cons>:

void sys_lock_cons(void) {
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801318:	6a 00                	push   $0x0
  80131a:	6a 00                	push   $0x0
  80131c:	6a 00                	push   $0x0
  80131e:	6a 00                	push   $0x0
  801320:	6a 00                	push   $0x0
  801322:	6a 03                	push   $0x3
  801324:	e8 7f ff ff ff       	call   8012a8 <syscall>
  801329:	83 c4 18             	add    $0x18,%esp
}
  80132c:	90                   	nop
  80132d:	c9                   	leave  
  80132e:	c3                   	ret    

0080132f <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801332:	6a 00                	push   $0x0
  801334:	6a 00                	push   $0x0
  801336:	6a 00                	push   $0x0
  801338:	6a 00                	push   $0x0
  80133a:	6a 00                	push   $0x0
  80133c:	6a 04                	push   $0x4
  80133e:	e8 65 ff ff ff       	call   8012a8 <syscall>
  801343:	83 c4 18             	add    $0x18,%esp
}
  801346:	90                   	nop
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80134c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80134f:	8b 45 08             	mov    0x8(%ebp),%eax
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	52                   	push   %edx
  801359:	50                   	push   %eax
  80135a:	6a 08                	push   $0x8
  80135c:	e8 47 ff ff ff       	call   8012a8 <syscall>
  801361:	83 c4 18             	add    $0x18,%esp
}
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	56                   	push   %esi
  80136a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  80136b:	8b 75 18             	mov    0x18(%ebp),%esi
  80136e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801371:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801374:	8b 55 0c             	mov    0xc(%ebp),%edx
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	56                   	push   %esi
  80137b:	53                   	push   %ebx
  80137c:	51                   	push   %ecx
  80137d:	52                   	push   %edx
  80137e:	50                   	push   %eax
  80137f:	6a 09                	push   $0x9
  801381:	e8 22 ff ff ff       	call   8012a8 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801389:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5d                   	pop    %ebp
  80138f:	c3                   	ret    

00801390 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801393:	8b 55 0c             	mov    0xc(%ebp),%edx
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	6a 00                	push   $0x0
  80139b:	6a 00                	push   $0x0
  80139d:	6a 00                	push   $0x0
  80139f:	52                   	push   %edx
  8013a0:	50                   	push   %eax
  8013a1:	6a 0a                	push   $0xa
  8013a3:	e8 00 ff ff ff       	call   8012a8 <syscall>
  8013a8:	83 c4 18             	add    $0x18,%esp
}
  8013ab:	c9                   	leave  
  8013ac:	c3                   	ret    

008013ad <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  8013b0:	6a 00                	push   $0x0
  8013b2:	6a 00                	push   $0x0
  8013b4:	6a 00                	push   $0x0
  8013b6:	ff 75 0c             	pushl  0xc(%ebp)
  8013b9:	ff 75 08             	pushl  0x8(%ebp)
  8013bc:	6a 0b                	push   $0xb
  8013be:	e8 e5 fe ff ff       	call   8012a8 <syscall>
  8013c3:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013cb:	6a 00                	push   $0x0
  8013cd:	6a 00                	push   $0x0
  8013cf:	6a 00                	push   $0x0
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 0c                	push   $0xc
  8013d7:	e8 cc fe ff ff       	call   8012a8 <syscall>
  8013dc:	83 c4 18             	add    $0x18,%esp
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	6a 00                	push   $0x0
  8013ea:	6a 00                	push   $0x0
  8013ec:	6a 00                	push   $0x0
  8013ee:	6a 0d                	push   $0xd
  8013f0:	e8 b3 fe ff ff       	call   8012a8 <syscall>
  8013f5:	83 c4 18             	add    $0x18,%esp
}
  8013f8:	c9                   	leave  
  8013f9:	c3                   	ret    

008013fa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013fd:	6a 00                	push   $0x0
  8013ff:	6a 00                	push   $0x0
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 0e                	push   $0xe
  801409:	e8 9a fe ff ff       	call   8012a8 <syscall>
  80140e:	83 c4 18             	add    $0x18,%esp
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	6a 00                	push   $0x0
  801420:	6a 0f                	push   $0xf
  801422:	e8 81 fe ff ff       	call   8012a8 <syscall>
  801427:	83 c4 18             	add    $0x18,%esp
}
  80142a:	c9                   	leave  
  80142b:	c3                   	ret    

0080142c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80142f:	6a 00                	push   $0x0
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	ff 75 08             	pushl  0x8(%ebp)
  80143a:	6a 10                	push   $0x10
  80143c:	e8 67 fe ff ff       	call   8012a8 <syscall>
  801441:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801444:	c9                   	leave  
  801445:	c3                   	ret    

00801446 <sys_scarce_memory>:

void sys_scarce_memory() {
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801449:	6a 00                	push   $0x0
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 11                	push   $0x11
  801455:	e8 4e fe ff ff       	call   8012a8 <syscall>
  80145a:	83 c4 18             	add    $0x18,%esp
}
  80145d:	90                   	nop
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <sys_cputc>:

void sys_cputc(const char c) {
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 04             	sub    $0x4,%esp
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80146c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801470:	6a 00                	push   $0x0
  801472:	6a 00                	push   $0x0
  801474:	6a 00                	push   $0x0
  801476:	6a 00                	push   $0x0
  801478:	50                   	push   %eax
  801479:	6a 01                	push   $0x1
  80147b:	e8 28 fe ff ff       	call   8012a8 <syscall>
  801480:	83 c4 18             	add    $0x18,%esp
}
  801483:	90                   	nop
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	6a 00                	push   $0x0
  80148f:	6a 00                	push   $0x0
  801491:	6a 00                	push   $0x0
  801493:	6a 14                	push   $0x14
  801495:	e8 0e fe ff ff       	call   8012a8 <syscall>
  80149a:	83 c4 18             	add    $0x18,%esp
}
  80149d:	90                   	nop
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 04             	sub    $0x4,%esp
  8014a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  8014ac:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8014af:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b6:	6a 00                	push   $0x0
  8014b8:	51                   	push   %ecx
  8014b9:	52                   	push   %edx
  8014ba:	ff 75 0c             	pushl  0xc(%ebp)
  8014bd:	50                   	push   %eax
  8014be:	6a 15                	push   $0x15
  8014c0:	e8 e3 fd ff ff       	call   8012a8 <syscall>
  8014c5:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8014cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	6a 00                	push   $0x0
  8014d5:	6a 00                	push   $0x0
  8014d7:	6a 00                	push   $0x0
  8014d9:	52                   	push   %edx
  8014da:	50                   	push   %eax
  8014db:	6a 16                	push   $0x16
  8014dd:	e8 c6 fd ff ff       	call   8012a8 <syscall>
  8014e2:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8014ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	51                   	push   %ecx
  8014f8:	52                   	push   %edx
  8014f9:	50                   	push   %eax
  8014fa:	6a 17                	push   $0x17
  8014fc:	e8 a7 fd ff ff       	call   8012a8 <syscall>
  801501:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801509:	8b 55 0c             	mov    0xc(%ebp),%edx
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	6a 00                	push   $0x0
  801511:	6a 00                	push   $0x0
  801513:	6a 00                	push   $0x0
  801515:	52                   	push   %edx
  801516:	50                   	push   %eax
  801517:	6a 18                	push   $0x18
  801519:	e8 8a fd ff ff       	call   8012a8 <syscall>
  80151e:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	6a 00                	push   $0x0
  80152b:	ff 75 14             	pushl  0x14(%ebp)
  80152e:	ff 75 10             	pushl  0x10(%ebp)
  801531:	ff 75 0c             	pushl  0xc(%ebp)
  801534:	50                   	push   %eax
  801535:	6a 19                	push   $0x19
  801537:	e8 6c fd ff ff       	call   8012a8 <syscall>
  80153c:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <sys_run_env>:

void sys_run_env(int32 envId) {
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801544:	8b 45 08             	mov    0x8(%ebp),%eax
  801547:	6a 00                	push   $0x0
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	50                   	push   %eax
  801550:	6a 1a                	push   $0x1a
  801552:	e8 51 fd ff ff       	call   8012a8 <syscall>
  801557:	83 c4 18             	add    $0x18,%esp
}
  80155a:	90                   	nop
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	50                   	push   %eax
  80156c:	6a 1b                	push   $0x1b
  80156e:	e8 35 fd ff ff       	call   8012a8 <syscall>
  801573:	83 c4 18             	add    $0x18,%esp
}
  801576:	c9                   	leave  
  801577:	c3                   	ret    

00801578 <sys_getenvid>:

int32 sys_getenvid(void) {
  801578:	55                   	push   %ebp
  801579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 05                	push   $0x5
  801587:	e8 1c fd ff ff       	call   8012a8 <syscall>
  80158c:	83 c4 18             	add    $0x18,%esp
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801594:	6a 00                	push   $0x0
  801596:	6a 00                	push   $0x0
  801598:	6a 00                	push   $0x0
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	6a 06                	push   $0x6
  8015a0:	e8 03 fd ff ff       	call   8012a8 <syscall>
  8015a5:	83 c4 18             	add    $0x18,%esp
}
  8015a8:	c9                   	leave  
  8015a9:	c3                   	ret    

008015aa <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8015ad:	6a 00                	push   $0x0
  8015af:	6a 00                	push   $0x0
  8015b1:	6a 00                	push   $0x0
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 07                	push   $0x7
  8015b9:	e8 ea fc ff ff       	call   8012a8 <syscall>
  8015be:	83 c4 18             	add    $0x18,%esp
}
  8015c1:	c9                   	leave  
  8015c2:	c3                   	ret    

008015c3 <sys_exit_env>:

void sys_exit_env(void) {
  8015c3:	55                   	push   %ebp
  8015c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015c6:	6a 00                	push   $0x0
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	6a 00                	push   $0x0
  8015d0:	6a 1c                	push   $0x1c
  8015d2:	e8 d1 fc ff ff       	call   8012a8 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
}
  8015da:	90                   	nop
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8015e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015e6:	8d 50 04             	lea    0x4(%eax),%edx
  8015e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015ec:	6a 00                	push   $0x0
  8015ee:	6a 00                	push   $0x0
  8015f0:	6a 00                	push   $0x0
  8015f2:	52                   	push   %edx
  8015f3:	50                   	push   %eax
  8015f4:	6a 1d                	push   $0x1d
  8015f6:	e8 ad fc ff ff       	call   8012a8 <syscall>
  8015fb:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8015fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801601:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801604:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801607:	89 01                	mov    %eax,(%ecx)
  801609:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	c9                   	leave  
  801610:	c2 04 00             	ret    $0x4

00801613 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801613:	55                   	push   %ebp
  801614:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	ff 75 10             	pushl  0x10(%ebp)
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	6a 13                	push   $0x13
  801625:	e8 7e fc ff ff       	call   8012a8 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80162d:	90                   	nop
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_rcr2>:
uint32 sys_rcr2() {
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	6a 1e                	push   $0x1e
  80163f:	e8 64 fc ff ff       	call   8012a8 <syscall>
  801644:	83 c4 18             	add    $0x18,%esp
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 04             	sub    $0x4,%esp
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801655:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801659:	6a 00                	push   $0x0
  80165b:	6a 00                	push   $0x0
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	50                   	push   %eax
  801662:	6a 1f                	push   $0x1f
  801664:	e8 3f fc ff ff       	call   8012a8 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
	return;
  80166c:	90                   	nop
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <rsttst>:
void rsttst() {
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	6a 00                	push   $0x0
  80167a:	6a 00                	push   $0x0
  80167c:	6a 21                	push   $0x21
  80167e:	e8 25 fc ff ff       	call   8012a8 <syscall>
  801683:	83 c4 18             	add    $0x18,%esp
	return;
  801686:	90                   	nop
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 04             	sub    $0x4,%esp
  80168f:	8b 45 14             	mov    0x14(%ebp),%eax
  801692:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801695:	8b 55 18             	mov    0x18(%ebp),%edx
  801698:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80169c:	52                   	push   %edx
  80169d:	50                   	push   %eax
  80169e:	ff 75 10             	pushl  0x10(%ebp)
  8016a1:	ff 75 0c             	pushl  0xc(%ebp)
  8016a4:	ff 75 08             	pushl  0x8(%ebp)
  8016a7:	6a 20                	push   $0x20
  8016a9:	e8 fa fb ff ff       	call   8012a8 <syscall>
  8016ae:	83 c4 18             	add    $0x18,%esp
	return;
  8016b1:	90                   	nop
}
  8016b2:	c9                   	leave  
  8016b3:	c3                   	ret    

008016b4 <chktst>:
void chktst(uint32 n) {
  8016b4:	55                   	push   %ebp
  8016b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	ff 75 08             	pushl  0x8(%ebp)
  8016c2:	6a 22                	push   $0x22
  8016c4:	e8 df fb ff ff       	call   8012a8 <syscall>
  8016c9:	83 c4 18             	add    $0x18,%esp
	return;
  8016cc:	90                   	nop
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <inctst>:

void inctst() {
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 23                	push   $0x23
  8016de:	e8 c5 fb ff ff       	call   8012a8 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
	return;
  8016e6:	90                   	nop
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <gettst>:
uint32 gettst() {
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 00                	push   $0x0
  8016f4:	6a 00                	push   $0x0
  8016f6:	6a 24                	push   $0x24
  8016f8:	e8 ab fb ff ff       	call   8012a8 <syscall>
  8016fd:	83 c4 18             	add    $0x18,%esp
}
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 25                	push   $0x25
  801714:	e8 8f fb ff ff       	call   8012a8 <syscall>
  801719:	83 c4 18             	add    $0x18,%esp
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80171f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801723:	75 07                	jne    80172c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801725:	b8 01 00 00 00       	mov    $0x1,%eax
  80172a:	eb 05                	jmp    801731 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801739:	6a 00                	push   $0x0
  80173b:	6a 00                	push   $0x0
  80173d:	6a 00                	push   $0x0
  80173f:	6a 00                	push   $0x0
  801741:	6a 00                	push   $0x0
  801743:	6a 25                	push   $0x25
  801745:	e8 5e fb ff ff       	call   8012a8 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
  80174d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801750:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801754:	75 07                	jne    80175d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801756:	b8 01 00 00 00       	mov    $0x1,%eax
  80175b:	eb 05                	jmp    801762 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80175d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801762:	c9                   	leave  
  801763:	c3                   	ret    

00801764 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80176a:	6a 00                	push   $0x0
  80176c:	6a 00                	push   $0x0
  80176e:	6a 00                	push   $0x0
  801770:	6a 00                	push   $0x0
  801772:	6a 00                	push   $0x0
  801774:	6a 25                	push   $0x25
  801776:	e8 2d fb ff ff       	call   8012a8 <syscall>
  80177b:	83 c4 18             	add    $0x18,%esp
  80177e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801781:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801785:	75 07                	jne    80178e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801787:	b8 01 00 00 00       	mov    $0x1,%eax
  80178c:	eb 05                	jmp    801793 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80178e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80179b:	6a 00                	push   $0x0
  80179d:	6a 00                	push   $0x0
  80179f:	6a 00                	push   $0x0
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 25                	push   $0x25
  8017a7:	e8 fc fa ff ff       	call   8012a8 <syscall>
  8017ac:	83 c4 18             	add    $0x18,%esp
  8017af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017b2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017b6:	75 07                	jne    8017bf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017bd:	eb 05                	jmp    8017c4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c4:	c9                   	leave  
  8017c5:	c3                   	ret    

008017c6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	6a 00                	push   $0x0
  8017cf:	6a 00                	push   $0x0
  8017d1:	ff 75 08             	pushl  0x8(%ebp)
  8017d4:	6a 26                	push   $0x26
  8017d6:	e8 cd fa ff ff       	call   8012a8 <syscall>
  8017db:	83 c4 18             	add    $0x18,%esp
	return;
  8017de:	90                   	nop
}
  8017df:	c9                   	leave  
  8017e0:	c3                   	ret    

008017e1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8017e1:	55                   	push   %ebp
  8017e2:	89 e5                	mov    %esp,%ebp
  8017e4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8017e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f1:	6a 00                	push   $0x0
  8017f3:	53                   	push   %ebx
  8017f4:	51                   	push   %ecx
  8017f5:	52                   	push   %edx
  8017f6:	50                   	push   %eax
  8017f7:	6a 27                	push   $0x27
  8017f9:	e8 aa fa ff ff       	call   8012a8 <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801801:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	52                   	push   %edx
  801816:	50                   	push   %eax
  801817:	6a 28                	push   $0x28
  801819:	e8 8a fa ff ff       	call   8012a8 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801826:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801829:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	6a 00                	push   $0x0
  801831:	51                   	push   %ecx
  801832:	ff 75 10             	pushl  0x10(%ebp)
  801835:	52                   	push   %edx
  801836:	50                   	push   %eax
  801837:	6a 29                	push   $0x29
  801839:	e8 6a fa ff ff       	call   8012a8 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	ff 75 10             	pushl  0x10(%ebp)
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	ff 75 08             	pushl  0x8(%ebp)
  801853:	6a 12                	push   $0x12
  801855:	e8 4e fa ff ff       	call   8012a8 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
	return;
  80185d:	90                   	nop
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	52                   	push   %edx
  801870:	50                   	push   %eax
  801871:	6a 2a                	push   $0x2a
  801873:	e8 30 fa ff ff       	call   8012a8 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
	return;
  80187b:	90                   	nop
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	50                   	push   %eax
  80188d:	6a 2b                	push   $0x2b
  80188f:	e8 14 fa ff ff       	call   8012a8 <syscall>
  801894:	83 c4 18             	add    $0x18,%esp
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	ff 75 08             	pushl  0x8(%ebp)
  8018a8:	6a 2c                	push   $0x2c
  8018aa:	e8 f9 f9 ff ff       	call   8012a8 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
	return;
  8018b2:	90                   	nop
}
  8018b3:	c9                   	leave  
  8018b4:	c3                   	ret    

008018b5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	6a 2d                	push   $0x2d
  8018c6:	e8 dd f9 ff ff       	call   8012a8 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
	return;
  8018ce:	90                   	nop
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	50                   	push   %eax
  8018e0:	6a 2f                	push   $0x2f
  8018e2:	e8 c1 f9 ff ff       	call   8012a8 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
	return;
  8018ea:	90                   	nop
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8018f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	52                   	push   %edx
  8018fd:	50                   	push   %eax
  8018fe:	6a 30                	push   $0x30
  801900:	e8 a3 f9 ff ff       	call   8012a8 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
	return;
  801908:	90                   	nop
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	50                   	push   %eax
  80191a:	6a 31                	push   $0x31
  80191c:	e8 87 f9 ff ff       	call   8012a8 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
	return;
  801924:	90                   	nop
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  80192a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192d:	8b 45 08             	mov    0x8(%ebp),%eax
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 2e                	push   $0x2e
  80193a:	e8 69 f9 ff ff       	call   8012a8 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
    return;
  801942:	90                   	nop
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  801951:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  801955:	83 ec 0c             	sub    $0xc,%esp
  801958:	50                   	push   %eax
  801959:	e8 02 fb ff ff       	call   801460 <sys_cputc>
  80195e:	83 c4 10             	add    $0x10,%esp
}
  801961:	90                   	nop
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <getchar>:


int
getchar(void)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  80196a:	e8 8d f9 ff ff       	call   8012fc <sys_cgetc>
  80196f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801972:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <iscons>:

int iscons(int fdnum)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80197a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    

00801981 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801987:	8d 45 10             	lea    0x10(%ebp),%eax
  80198a:	83 c0 04             	add    $0x4,%eax
  80198d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801990:	a1 28 30 80 00       	mov    0x803028,%eax
  801995:	85 c0                	test   %eax,%eax
  801997:	74 16                	je     8019af <_panic+0x2e>
		cprintf("%s: ", argv0);
  801999:	a1 28 30 80 00       	mov    0x803028,%eax
  80199e:	83 ec 08             	sub    $0x8,%esp
  8019a1:	50                   	push   %eax
  8019a2:	68 ec 22 80 00       	push   $0x8022ec
  8019a7:	e8 5a e9 ff ff       	call   800306 <cprintf>
  8019ac:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019af:	a1 04 30 80 00       	mov    0x803004,%eax
  8019b4:	ff 75 0c             	pushl  0xc(%ebp)
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	50                   	push   %eax
  8019bb:	68 f1 22 80 00       	push   $0x8022f1
  8019c0:	e8 41 e9 ff ff       	call   800306 <cprintf>
  8019c5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cb:	83 ec 08             	sub    $0x8,%esp
  8019ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d1:	50                   	push   %eax
  8019d2:	e8 c4 e8 ff ff       	call   80029b <vcprintf>
  8019d7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019da:	83 ec 08             	sub    $0x8,%esp
  8019dd:	6a 00                	push   $0x0
  8019df:	68 0d 23 80 00       	push   $0x80230d
  8019e4:	e8 b2 e8 ff ff       	call   80029b <vcprintf>
  8019e9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019ec:	e8 33 e8 ff ff       	call   800224 <exit>

	// should not return here
	while (1) ;
  8019f1:	eb fe                	jmp    8019f1 <_panic+0x70>

008019f3 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019f9:	a1 08 30 80 00       	mov    0x803008,%eax
  8019fe:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a07:	39 c2                	cmp    %eax,%edx
  801a09:	74 14                	je     801a1f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a0b:	83 ec 04             	sub    $0x4,%esp
  801a0e:	68 10 23 80 00       	push   $0x802310
  801a13:	6a 26                	push   $0x26
  801a15:	68 5c 23 80 00       	push   $0x80235c
  801a1a:	e8 62 ff ff ff       	call   801981 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a2d:	e9 c5 00 00 00       	jmp    801af7 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	8b 00                	mov    (%eax),%eax
  801a43:	85 c0                	test   %eax,%eax
  801a45:	75 08                	jne    801a4f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a47:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a4a:	e9 a5 00 00 00       	jmp    801af4 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a4f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a56:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a5d:	eb 69                	jmp    801ac8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a5f:	a1 08 30 80 00       	mov    0x803008,%eax
  801a64:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a6a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a6d:	89 d0                	mov    %edx,%eax
  801a6f:	01 c0                	add    %eax,%eax
  801a71:	01 d0                	add    %edx,%eax
  801a73:	c1 e0 03             	shl    $0x3,%eax
  801a76:	01 c8                	add    %ecx,%eax
  801a78:	8a 40 04             	mov    0x4(%eax),%al
  801a7b:	84 c0                	test   %al,%al
  801a7d:	75 46                	jne    801ac5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a7f:	a1 08 30 80 00       	mov    0x803008,%eax
  801a84:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a8d:	89 d0                	mov    %edx,%eax
  801a8f:	01 c0                	add    %eax,%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	c1 e0 03             	shl    $0x3,%eax
  801a96:	01 c8                	add    %ecx,%eax
  801a98:	8b 00                	mov    (%eax),%eax
  801a9a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a9d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aa5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaa:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	01 c8                	add    %ecx,%eax
  801ab6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801ab8:	39 c2                	cmp    %eax,%edx
  801aba:	75 09                	jne    801ac5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801abc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ac3:	eb 15                	jmp    801ada <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801ac5:	ff 45 e8             	incl   -0x18(%ebp)
  801ac8:	a1 08 30 80 00       	mov    0x803008,%eax
  801acd:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ad6:	39 c2                	cmp    %eax,%edx
  801ad8:	77 85                	ja     801a5f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801ada:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ade:	75 14                	jne    801af4 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	68 68 23 80 00       	push   $0x802368
  801ae8:	6a 3a                	push   $0x3a
  801aea:	68 5c 23 80 00       	push   $0x80235c
  801aef:	e8 8d fe ff ff       	call   801981 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801af4:	ff 45 f0             	incl   -0x10(%ebp)
  801af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801afd:	0f 8c 2f ff ff ff    	jl     801a32 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b11:	eb 26                	jmp    801b39 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b13:	a1 08 30 80 00       	mov    0x803008,%eax
  801b18:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801b1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b21:	89 d0                	mov    %edx,%eax
  801b23:	01 c0                	add    %eax,%eax
  801b25:	01 d0                	add    %edx,%eax
  801b27:	c1 e0 03             	shl    $0x3,%eax
  801b2a:	01 c8                	add    %ecx,%eax
  801b2c:	8a 40 04             	mov    0x4(%eax),%al
  801b2f:	3c 01                	cmp    $0x1,%al
  801b31:	75 03                	jne    801b36 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b36:	ff 45 e0             	incl   -0x20(%ebp)
  801b39:	a1 08 30 80 00       	mov    0x803008,%eax
  801b3e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b47:	39 c2                	cmp    %eax,%edx
  801b49:	77 c8                	ja     801b13 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b51:	74 14                	je     801b67 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	68 bc 23 80 00       	push   $0x8023bc
  801b5b:	6a 44                	push   $0x44
  801b5d:	68 5c 23 80 00       	push   $0x80235c
  801b62:	e8 1a fe ff ff       	call   801981 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b67:	90                   	nop
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    
  801b6a:	66 90                	xchg   %ax,%ax

00801b6c <__udivdi3>:
  801b6c:	55                   	push   %ebp
  801b6d:	57                   	push   %edi
  801b6e:	56                   	push   %esi
  801b6f:	53                   	push   %ebx
  801b70:	83 ec 1c             	sub    $0x1c,%esp
  801b73:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b77:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b7b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b7f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b83:	89 ca                	mov    %ecx,%edx
  801b85:	89 f8                	mov    %edi,%eax
  801b87:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b8b:	85 f6                	test   %esi,%esi
  801b8d:	75 2d                	jne    801bbc <__udivdi3+0x50>
  801b8f:	39 cf                	cmp    %ecx,%edi
  801b91:	77 65                	ja     801bf8 <__udivdi3+0x8c>
  801b93:	89 fd                	mov    %edi,%ebp
  801b95:	85 ff                	test   %edi,%edi
  801b97:	75 0b                	jne    801ba4 <__udivdi3+0x38>
  801b99:	b8 01 00 00 00       	mov    $0x1,%eax
  801b9e:	31 d2                	xor    %edx,%edx
  801ba0:	f7 f7                	div    %edi
  801ba2:	89 c5                	mov    %eax,%ebp
  801ba4:	31 d2                	xor    %edx,%edx
  801ba6:	89 c8                	mov    %ecx,%eax
  801ba8:	f7 f5                	div    %ebp
  801baa:	89 c1                	mov    %eax,%ecx
  801bac:	89 d8                	mov    %ebx,%eax
  801bae:	f7 f5                	div    %ebp
  801bb0:	89 cf                	mov    %ecx,%edi
  801bb2:	89 fa                	mov    %edi,%edx
  801bb4:	83 c4 1c             	add    $0x1c,%esp
  801bb7:	5b                   	pop    %ebx
  801bb8:	5e                   	pop    %esi
  801bb9:	5f                   	pop    %edi
  801bba:	5d                   	pop    %ebp
  801bbb:	c3                   	ret    
  801bbc:	39 ce                	cmp    %ecx,%esi
  801bbe:	77 28                	ja     801be8 <__udivdi3+0x7c>
  801bc0:	0f bd fe             	bsr    %esi,%edi
  801bc3:	83 f7 1f             	xor    $0x1f,%edi
  801bc6:	75 40                	jne    801c08 <__udivdi3+0x9c>
  801bc8:	39 ce                	cmp    %ecx,%esi
  801bca:	72 0a                	jb     801bd6 <__udivdi3+0x6a>
  801bcc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bd0:	0f 87 9e 00 00 00    	ja     801c74 <__udivdi3+0x108>
  801bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bdb:	89 fa                	mov    %edi,%edx
  801bdd:	83 c4 1c             	add    $0x1c,%esp
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    
  801be5:	8d 76 00             	lea    0x0(%esi),%esi
  801be8:	31 ff                	xor    %edi,%edi
  801bea:	31 c0                	xor    %eax,%eax
  801bec:	89 fa                	mov    %edi,%edx
  801bee:	83 c4 1c             	add    $0x1c,%esp
  801bf1:	5b                   	pop    %ebx
  801bf2:	5e                   	pop    %esi
  801bf3:	5f                   	pop    %edi
  801bf4:	5d                   	pop    %ebp
  801bf5:	c3                   	ret    
  801bf6:	66 90                	xchg   %ax,%ax
  801bf8:	89 d8                	mov    %ebx,%eax
  801bfa:	f7 f7                	div    %edi
  801bfc:	31 ff                	xor    %edi,%edi
  801bfe:	89 fa                	mov    %edi,%edx
  801c00:	83 c4 1c             	add    $0x1c,%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5f                   	pop    %edi
  801c06:	5d                   	pop    %ebp
  801c07:	c3                   	ret    
  801c08:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c0d:	89 eb                	mov    %ebp,%ebx
  801c0f:	29 fb                	sub    %edi,%ebx
  801c11:	89 f9                	mov    %edi,%ecx
  801c13:	d3 e6                	shl    %cl,%esi
  801c15:	89 c5                	mov    %eax,%ebp
  801c17:	88 d9                	mov    %bl,%cl
  801c19:	d3 ed                	shr    %cl,%ebp
  801c1b:	89 e9                	mov    %ebp,%ecx
  801c1d:	09 f1                	or     %esi,%ecx
  801c1f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c23:	89 f9                	mov    %edi,%ecx
  801c25:	d3 e0                	shl    %cl,%eax
  801c27:	89 c5                	mov    %eax,%ebp
  801c29:	89 d6                	mov    %edx,%esi
  801c2b:	88 d9                	mov    %bl,%cl
  801c2d:	d3 ee                	shr    %cl,%esi
  801c2f:	89 f9                	mov    %edi,%ecx
  801c31:	d3 e2                	shl    %cl,%edx
  801c33:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c37:	88 d9                	mov    %bl,%cl
  801c39:	d3 e8                	shr    %cl,%eax
  801c3b:	09 c2                	or     %eax,%edx
  801c3d:	89 d0                	mov    %edx,%eax
  801c3f:	89 f2                	mov    %esi,%edx
  801c41:	f7 74 24 0c          	divl   0xc(%esp)
  801c45:	89 d6                	mov    %edx,%esi
  801c47:	89 c3                	mov    %eax,%ebx
  801c49:	f7 e5                	mul    %ebp
  801c4b:	39 d6                	cmp    %edx,%esi
  801c4d:	72 19                	jb     801c68 <__udivdi3+0xfc>
  801c4f:	74 0b                	je     801c5c <__udivdi3+0xf0>
  801c51:	89 d8                	mov    %ebx,%eax
  801c53:	31 ff                	xor    %edi,%edi
  801c55:	e9 58 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c5a:	66 90                	xchg   %ax,%ax
  801c5c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c60:	89 f9                	mov    %edi,%ecx
  801c62:	d3 e2                	shl    %cl,%edx
  801c64:	39 c2                	cmp    %eax,%edx
  801c66:	73 e9                	jae    801c51 <__udivdi3+0xe5>
  801c68:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c6b:	31 ff                	xor    %edi,%edi
  801c6d:	e9 40 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	31 c0                	xor    %eax,%eax
  801c76:	e9 37 ff ff ff       	jmp    801bb2 <__udivdi3+0x46>
  801c7b:	90                   	nop

00801c7c <__umoddi3>:
  801c7c:	55                   	push   %ebp
  801c7d:	57                   	push   %edi
  801c7e:	56                   	push   %esi
  801c7f:	53                   	push   %ebx
  801c80:	83 ec 1c             	sub    $0x1c,%esp
  801c83:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c87:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c8f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c97:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c9b:	89 f3                	mov    %esi,%ebx
  801c9d:	89 fa                	mov    %edi,%edx
  801c9f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ca3:	89 34 24             	mov    %esi,(%esp)
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	75 1a                	jne    801cc4 <__umoddi3+0x48>
  801caa:	39 f7                	cmp    %esi,%edi
  801cac:	0f 86 a2 00 00 00    	jbe    801d54 <__umoddi3+0xd8>
  801cb2:	89 c8                	mov    %ecx,%eax
  801cb4:	89 f2                	mov    %esi,%edx
  801cb6:	f7 f7                	div    %edi
  801cb8:	89 d0                	mov    %edx,%eax
  801cba:	31 d2                	xor    %edx,%edx
  801cbc:	83 c4 1c             	add    $0x1c,%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5f                   	pop    %edi
  801cc2:	5d                   	pop    %ebp
  801cc3:	c3                   	ret    
  801cc4:	39 f0                	cmp    %esi,%eax
  801cc6:	0f 87 ac 00 00 00    	ja     801d78 <__umoddi3+0xfc>
  801ccc:	0f bd e8             	bsr    %eax,%ebp
  801ccf:	83 f5 1f             	xor    $0x1f,%ebp
  801cd2:	0f 84 ac 00 00 00    	je     801d84 <__umoddi3+0x108>
  801cd8:	bf 20 00 00 00       	mov    $0x20,%edi
  801cdd:	29 ef                	sub    %ebp,%edi
  801cdf:	89 fe                	mov    %edi,%esi
  801ce1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ce5:	89 e9                	mov    %ebp,%ecx
  801ce7:	d3 e0                	shl    %cl,%eax
  801ce9:	89 d7                	mov    %edx,%edi
  801ceb:	89 f1                	mov    %esi,%ecx
  801ced:	d3 ef                	shr    %cl,%edi
  801cef:	09 c7                	or     %eax,%edi
  801cf1:	89 e9                	mov    %ebp,%ecx
  801cf3:	d3 e2                	shl    %cl,%edx
  801cf5:	89 14 24             	mov    %edx,(%esp)
  801cf8:	89 d8                	mov    %ebx,%eax
  801cfa:	d3 e0                	shl    %cl,%eax
  801cfc:	89 c2                	mov    %eax,%edx
  801cfe:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d02:	d3 e0                	shl    %cl,%eax
  801d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d08:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d0c:	89 f1                	mov    %esi,%ecx
  801d0e:	d3 e8                	shr    %cl,%eax
  801d10:	09 d0                	or     %edx,%eax
  801d12:	d3 eb                	shr    %cl,%ebx
  801d14:	89 da                	mov    %ebx,%edx
  801d16:	f7 f7                	div    %edi
  801d18:	89 d3                	mov    %edx,%ebx
  801d1a:	f7 24 24             	mull   (%esp)
  801d1d:	89 c6                	mov    %eax,%esi
  801d1f:	89 d1                	mov    %edx,%ecx
  801d21:	39 d3                	cmp    %edx,%ebx
  801d23:	0f 82 87 00 00 00    	jb     801db0 <__umoddi3+0x134>
  801d29:	0f 84 91 00 00 00    	je     801dc0 <__umoddi3+0x144>
  801d2f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d33:	29 f2                	sub    %esi,%edx
  801d35:	19 cb                	sbb    %ecx,%ebx
  801d37:	89 d8                	mov    %ebx,%eax
  801d39:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d3d:	d3 e0                	shl    %cl,%eax
  801d3f:	89 e9                	mov    %ebp,%ecx
  801d41:	d3 ea                	shr    %cl,%edx
  801d43:	09 d0                	or     %edx,%eax
  801d45:	89 e9                	mov    %ebp,%ecx
  801d47:	d3 eb                	shr    %cl,%ebx
  801d49:	89 da                	mov    %ebx,%edx
  801d4b:	83 c4 1c             	add    $0x1c,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5e                   	pop    %esi
  801d50:	5f                   	pop    %edi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    
  801d53:	90                   	nop
  801d54:	89 fd                	mov    %edi,%ebp
  801d56:	85 ff                	test   %edi,%edi
  801d58:	75 0b                	jne    801d65 <__umoddi3+0xe9>
  801d5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5f:	31 d2                	xor    %edx,%edx
  801d61:	f7 f7                	div    %edi
  801d63:	89 c5                	mov    %eax,%ebp
  801d65:	89 f0                	mov    %esi,%eax
  801d67:	31 d2                	xor    %edx,%edx
  801d69:	f7 f5                	div    %ebp
  801d6b:	89 c8                	mov    %ecx,%eax
  801d6d:	f7 f5                	div    %ebp
  801d6f:	89 d0                	mov    %edx,%eax
  801d71:	e9 44 ff ff ff       	jmp    801cba <__umoddi3+0x3e>
  801d76:	66 90                	xchg   %ax,%ax
  801d78:	89 c8                	mov    %ecx,%eax
  801d7a:	89 f2                	mov    %esi,%edx
  801d7c:	83 c4 1c             	add    $0x1c,%esp
  801d7f:	5b                   	pop    %ebx
  801d80:	5e                   	pop    %esi
  801d81:	5f                   	pop    %edi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    
  801d84:	3b 04 24             	cmp    (%esp),%eax
  801d87:	72 06                	jb     801d8f <__umoddi3+0x113>
  801d89:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d8d:	77 0f                	ja     801d9e <__umoddi3+0x122>
  801d8f:	89 f2                	mov    %esi,%edx
  801d91:	29 f9                	sub    %edi,%ecx
  801d93:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d97:	89 14 24             	mov    %edx,(%esp)
  801d9a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d9e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801da2:	8b 14 24             	mov    (%esp),%edx
  801da5:	83 c4 1c             	add    $0x1c,%esp
  801da8:	5b                   	pop    %ebx
  801da9:	5e                   	pop    %esi
  801daa:	5f                   	pop    %edi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    
  801dad:	8d 76 00             	lea    0x0(%esi),%esi
  801db0:	2b 04 24             	sub    (%esp),%eax
  801db3:	19 fa                	sbb    %edi,%edx
  801db5:	89 d1                	mov    %edx,%ecx
  801db7:	89 c6                	mov    %eax,%esi
  801db9:	e9 71 ff ff ff       	jmp    801d2f <__umoddi3+0xb3>
  801dbe:	66 90                	xchg   %ax,%ax
  801dc0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801dc4:	72 ea                	jb     801db0 <__umoddi3+0x134>
  801dc6:	89 d9                	mov    %ebx,%ecx
  801dc8:	e9 62 ff ff ff       	jmp    801d2f <__umoddi3+0xb3>
