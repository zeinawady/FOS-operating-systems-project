
obj/user/fos_data_on_stack:     file format elf32-i386


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
  800031:	e8 1e 00 00 00       	call   800054 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>


void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 48 27 00 00    	sub    $0x2748,%esp
	/// Adding array of 512 integer on user stack
	int arr[2512];

	atomic_cprintf("user stack contains 512 integer\n");
  800041:	83 ec 0c             	sub    $0xc,%esp
  800044:	68 00 1b 80 00       	push   $0x801b00
  800049:	e8 4c 02 00 00       	call   80029a <atomic_cprintf>
  80004e:	83 c4 10             	add    $0x10,%esp

	return;	
  800051:	90                   	nop
}
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  80005a:	e8 91 12 00 00       	call   8012f0 <sys_getenvindex>
  80005f:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  800062:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800065:	89 d0                	mov    %edx,%eax
  800067:	c1 e0 02             	shl    $0x2,%eax
  80006a:	01 d0                	add    %edx,%eax
  80006c:	c1 e0 03             	shl    $0x3,%eax
  80006f:	01 d0                	add    %edx,%eax
  800071:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800078:	01 d0                	add    %edx,%eax
  80007a:	c1 e0 02             	shl    $0x2,%eax
  80007d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800082:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800087:	a1 08 30 80 00       	mov    0x803008,%eax
  80008c:	8a 40 20             	mov    0x20(%eax),%al
  80008f:	84 c0                	test   %al,%al
  800091:	74 0d                	je     8000a0 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800093:	a1 08 30 80 00       	mov    0x803008,%eax
  800098:	83 c0 20             	add    $0x20,%eax
  80009b:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a4:	7e 0a                	jle    8000b0 <libmain+0x5c>
		binaryname = argv[0];
  8000a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a9:	8b 00                	mov    (%eax),%eax
  8000ab:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000b0:	83 ec 08             	sub    $0x8,%esp
  8000b3:	ff 75 0c             	pushl  0xc(%ebp)
  8000b6:	ff 75 08             	pushl  0x8(%ebp)
  8000b9:	e8 7a ff ff ff       	call   800038 <_main>
  8000be:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000c1:	a1 00 30 80 00       	mov    0x803000,%eax
  8000c6:	85 c0                	test   %eax,%eax
  8000c8:	0f 84 9f 00 00 00    	je     80016d <libmain+0x119>
	{
		sys_lock_cons();
  8000ce:	e8 a1 0f 00 00       	call   801074 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	68 3c 1b 80 00       	push   $0x801b3c
  8000db:	e8 8d 01 00 00       	call   80026d <cprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e3:	a1 08 30 80 00       	mov    0x803008,%eax
  8000e8:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8000ee:	a1 08 30 80 00       	mov    0x803008,%eax
  8000f3:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8000f9:	83 ec 04             	sub    $0x4,%esp
  8000fc:	52                   	push   %edx
  8000fd:	50                   	push   %eax
  8000fe:	68 64 1b 80 00       	push   $0x801b64
  800103:	e8 65 01 00 00       	call   80026d <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80010b:	a1 08 30 80 00       	mov    0x803008,%eax
  800110:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800116:	a1 08 30 80 00       	mov    0x803008,%eax
  80011b:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800121:	a1 08 30 80 00       	mov    0x803008,%eax
  800126:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80012c:	51                   	push   %ecx
  80012d:	52                   	push   %edx
  80012e:	50                   	push   %eax
  80012f:	68 8c 1b 80 00       	push   $0x801b8c
  800134:	e8 34 01 00 00       	call   80026d <cprintf>
  800139:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80013c:	a1 08 30 80 00       	mov    0x803008,%eax
  800141:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800147:	83 ec 08             	sub    $0x8,%esp
  80014a:	50                   	push   %eax
  80014b:	68 e4 1b 80 00       	push   $0x801be4
  800150:	e8 18 01 00 00       	call   80026d <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	68 3c 1b 80 00       	push   $0x801b3c
  800160:	e8 08 01 00 00       	call   80026d <cprintf>
  800165:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800168:	e8 21 0f 00 00       	call   80108e <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80016d:	e8 19 00 00 00       	call   80018b <exit>
}
  800172:	90                   	nop
  800173:	c9                   	leave  
  800174:	c3                   	ret    

00800175 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800175:	55                   	push   %ebp
  800176:	89 e5                	mov    %esp,%ebp
  800178:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80017b:	83 ec 0c             	sub    $0xc,%esp
  80017e:	6a 00                	push   $0x0
  800180:	e8 37 11 00 00       	call   8012bc <sys_destroy_env>
  800185:	83 c4 10             	add    $0x10,%esp
}
  800188:	90                   	nop
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <exit>:

void
exit(void)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800191:	e8 8c 11 00 00       	call   801322 <sys_exit_env>
}
  800196:	90                   	nop
  800197:	c9                   	leave  
  800198:	c3                   	ret    

00800199 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800199:	55                   	push   %ebp
  80019a:	89 e5                	mov    %esp,%ebp
  80019c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80019f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001a2:	8b 00                	mov    (%eax),%eax
  8001a4:	8d 48 01             	lea    0x1(%eax),%ecx
  8001a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001aa:	89 0a                	mov    %ecx,(%edx)
  8001ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8001af:	88 d1                	mov    %dl,%cl
  8001b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001bb:	8b 00                	mov    (%eax),%eax
  8001bd:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001c2:	75 2c                	jne    8001f0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001c4:	a0 0c 30 80 00       	mov    0x80300c,%al
  8001c9:	0f b6 c0             	movzbl %al,%eax
  8001cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cf:	8b 12                	mov    (%edx),%edx
  8001d1:	89 d1                	mov    %edx,%ecx
  8001d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d6:	83 c2 08             	add    $0x8,%edx
  8001d9:	83 ec 04             	sub    $0x4,%esp
  8001dc:	50                   	push   %eax
  8001dd:	51                   	push   %ecx
  8001de:	52                   	push   %edx
  8001df:	e8 4e 0e 00 00       	call   801032 <sys_cputs>
  8001e4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f3:	8b 40 04             	mov    0x4(%eax),%eax
  8001f6:	8d 50 01             	lea    0x1(%eax),%edx
  8001f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80020b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800212:	00 00 00 
	b.cnt = 0;
  800215:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80021c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80021f:	ff 75 0c             	pushl  0xc(%ebp)
  800222:	ff 75 08             	pushl  0x8(%ebp)
  800225:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80022b:	50                   	push   %eax
  80022c:	68 99 01 80 00       	push   $0x800199
  800231:	e8 11 02 00 00       	call   800447 <vprintfmt>
  800236:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800239:	a0 0c 30 80 00       	mov    0x80300c,%al
  80023e:	0f b6 c0             	movzbl %al,%eax
  800241:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	50                   	push   %eax
  80024b:	52                   	push   %edx
  80024c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800252:	83 c0 08             	add    $0x8,%eax
  800255:	50                   	push   %eax
  800256:	e8 d7 0d 00 00       	call   801032 <sys_cputs>
  80025b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80025e:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  800265:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80026b:	c9                   	leave  
  80026c:	c3                   	ret    

0080026d <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800273:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  80027a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	ff 75 f4             	pushl  -0xc(%ebp)
  800289:	50                   	push   %eax
  80028a:	e8 73 ff ff ff       	call   800202 <vcprintf>
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800295:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002a0:	e8 cf 0d 00 00       	call   801074 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002a5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ae:	83 ec 08             	sub    $0x8,%esp
  8002b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b4:	50                   	push   %eax
  8002b5:	e8 48 ff ff ff       	call   800202 <vcprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp
  8002bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002c0:	e8 c9 0d 00 00       	call   80108e <sys_unlock_cons>
	return cnt;
  8002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c8:	c9                   	leave  
  8002c9:	c3                   	ret    

008002ca <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002ca:	55                   	push   %ebp
  8002cb:	89 e5                	mov    %esp,%ebp
  8002cd:	53                   	push   %ebx
  8002ce:	83 ec 14             	sub    $0x14,%esp
  8002d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002dd:	8b 45 18             	mov    0x18(%ebp),%eax
  8002e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e8:	77 55                	ja     80033f <printnum+0x75>
  8002ea:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ed:	72 05                	jb     8002f4 <printnum+0x2a>
  8002ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002f2:	77 4b                	ja     80033f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002f7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8002fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800302:	52                   	push   %edx
  800303:	50                   	push   %eax
  800304:	ff 75 f4             	pushl  -0xc(%ebp)
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	e8 81 15 00 00       	call   801890 <__udivdi3>
  80030f:	83 c4 10             	add    $0x10,%esp
  800312:	83 ec 04             	sub    $0x4,%esp
  800315:	ff 75 20             	pushl  0x20(%ebp)
  800318:	53                   	push   %ebx
  800319:	ff 75 18             	pushl  0x18(%ebp)
  80031c:	52                   	push   %edx
  80031d:	50                   	push   %eax
  80031e:	ff 75 0c             	pushl  0xc(%ebp)
  800321:	ff 75 08             	pushl  0x8(%ebp)
  800324:	e8 a1 ff ff ff       	call   8002ca <printnum>
  800329:	83 c4 20             	add    $0x20,%esp
  80032c:	eb 1a                	jmp    800348 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032e:	83 ec 08             	sub    $0x8,%esp
  800331:	ff 75 0c             	pushl  0xc(%ebp)
  800334:	ff 75 20             	pushl  0x20(%ebp)
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	ff d0                	call   *%eax
  80033c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033f:	ff 4d 1c             	decl   0x1c(%ebp)
  800342:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800346:	7f e6                	jg     80032e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800348:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80034b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800353:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800356:	53                   	push   %ebx
  800357:	51                   	push   %ecx
  800358:	52                   	push   %edx
  800359:	50                   	push   %eax
  80035a:	e8 41 16 00 00       	call   8019a0 <__umoddi3>
  80035f:	83 c4 10             	add    $0x10,%esp
  800362:	05 14 1e 80 00       	add    $0x801e14,%eax
  800367:	8a 00                	mov    (%eax),%al
  800369:	0f be c0             	movsbl %al,%eax
  80036c:	83 ec 08             	sub    $0x8,%esp
  80036f:	ff 75 0c             	pushl  0xc(%ebp)
  800372:	50                   	push   %eax
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	ff d0                	call   *%eax
  800378:	83 c4 10             	add    $0x10,%esp
}
  80037b:	90                   	nop
  80037c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037f:	c9                   	leave  
  800380:	c3                   	ret    

00800381 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800381:	55                   	push   %ebp
  800382:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800384:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800388:	7e 1c                	jle    8003a6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	8b 00                	mov    (%eax),%eax
  80038f:	8d 50 08             	lea    0x8(%eax),%edx
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	89 10                	mov    %edx,(%eax)
  800397:	8b 45 08             	mov    0x8(%ebp),%eax
  80039a:	8b 00                	mov    (%eax),%eax
  80039c:	83 e8 08             	sub    $0x8,%eax
  80039f:	8b 50 04             	mov    0x4(%eax),%edx
  8003a2:	8b 00                	mov    (%eax),%eax
  8003a4:	eb 40                	jmp    8003e6 <getuint+0x65>
	else if (lflag)
  8003a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003aa:	74 1e                	je     8003ca <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	8d 50 04             	lea    0x4(%eax),%edx
  8003b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b7:	89 10                	mov    %edx,(%eax)
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	83 e8 04             	sub    $0x4,%eax
  8003c1:	8b 00                	mov    (%eax),%eax
  8003c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c8:	eb 1c                	jmp    8003e6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	8d 50 04             	lea    0x4(%eax),%edx
  8003d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d5:	89 10                	mov    %edx,(%eax)
  8003d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003da:	8b 00                	mov    (%eax),%eax
  8003dc:	83 e8 04             	sub    $0x4,%eax
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    

008003e8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003eb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ef:	7e 1c                	jle    80040d <getint+0x25>
		return va_arg(*ap, long long);
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	8b 00                	mov    (%eax),%eax
  8003f6:	8d 50 08             	lea    0x8(%eax),%edx
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	89 10                	mov    %edx,(%eax)
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	8b 00                	mov    (%eax),%eax
  800403:	83 e8 08             	sub    $0x8,%eax
  800406:	8b 50 04             	mov    0x4(%eax),%edx
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	eb 38                	jmp    800445 <getint+0x5d>
	else if (lflag)
  80040d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800411:	74 1a                	je     80042d <getint+0x45>
		return va_arg(*ap, long);
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	8b 00                	mov    (%eax),%eax
  800418:	8d 50 04             	lea    0x4(%eax),%edx
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	8b 00                	mov    (%eax),%eax
  800425:	83 e8 04             	sub    $0x4,%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	99                   	cltd   
  80042b:	eb 18                	jmp    800445 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	8d 50 04             	lea    0x4(%eax),%edx
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	89 10                	mov    %edx,(%eax)
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	8b 00                	mov    (%eax),%eax
  80043f:	83 e8 04             	sub    $0x4,%eax
  800442:	8b 00                	mov    (%eax),%eax
  800444:	99                   	cltd   
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
  80044a:	56                   	push   %esi
  80044b:	53                   	push   %ebx
  80044c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044f:	eb 17                	jmp    800468 <vprintfmt+0x21>
			if (ch == '\0')
  800451:	85 db                	test   %ebx,%ebx
  800453:	0f 84 c1 03 00 00    	je     80081a <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	ff 75 0c             	pushl  0xc(%ebp)
  80045f:	53                   	push   %ebx
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	ff d0                	call   *%eax
  800465:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800468:	8b 45 10             	mov    0x10(%ebp),%eax
  80046b:	8d 50 01             	lea    0x1(%eax),%edx
  80046e:	89 55 10             	mov    %edx,0x10(%ebp)
  800471:	8a 00                	mov    (%eax),%al
  800473:	0f b6 d8             	movzbl %al,%ebx
  800476:	83 fb 25             	cmp    $0x25,%ebx
  800479:	75 d6                	jne    800451 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80047b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80047f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800486:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80048d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800494:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 45 10             	mov    0x10(%ebp),%eax
  80049e:	8d 50 01             	lea    0x1(%eax),%edx
  8004a1:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a4:	8a 00                	mov    (%eax),%al
  8004a6:	0f b6 d8             	movzbl %al,%ebx
  8004a9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004ac:	83 f8 5b             	cmp    $0x5b,%eax
  8004af:	0f 87 3d 03 00 00    	ja     8007f2 <vprintfmt+0x3ab>
  8004b5:	8b 04 85 38 1e 80 00 	mov    0x801e38(,%eax,4),%eax
  8004bc:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004be:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004c2:	eb d7                	jmp    80049b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004c8:	eb d1                	jmp    80049b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004ca:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004d1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d4:	89 d0                	mov    %edx,%eax
  8004d6:	c1 e0 02             	shl    $0x2,%eax
  8004d9:	01 d0                	add    %edx,%eax
  8004db:	01 c0                	add    %eax,%eax
  8004dd:	01 d8                	add    %ebx,%eax
  8004df:	83 e8 30             	sub    $0x30,%eax
  8004e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e8:	8a 00                	mov    (%eax),%al
  8004ea:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004ed:	83 fb 2f             	cmp    $0x2f,%ebx
  8004f0:	7e 3e                	jle    800530 <vprintfmt+0xe9>
  8004f2:	83 fb 39             	cmp    $0x39,%ebx
  8004f5:	7f 39                	jg     800530 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004fa:	eb d5                	jmp    8004d1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ff:	83 c0 04             	add    $0x4,%eax
  800502:	89 45 14             	mov    %eax,0x14(%ebp)
  800505:	8b 45 14             	mov    0x14(%ebp),%eax
  800508:	83 e8 04             	sub    $0x4,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800510:	eb 1f                	jmp    800531 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800512:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800516:	79 83                	jns    80049b <vprintfmt+0x54>
				width = 0;
  800518:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80051f:	e9 77 ff ff ff       	jmp    80049b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800524:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80052b:	e9 6b ff ff ff       	jmp    80049b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800530:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800531:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800535:	0f 89 60 ff ff ff    	jns    80049b <vprintfmt+0x54>
				width = precision, precision = -1;
  80053b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800541:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800548:	e9 4e ff ff ff       	jmp    80049b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80054d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800550:	e9 46 ff ff ff       	jmp    80049b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	83 c0 04             	add    $0x4,%eax
  80055b:	89 45 14             	mov    %eax,0x14(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	83 e8 04             	sub    $0x4,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 0c             	pushl  0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	8b 45 08             	mov    0x8(%ebp),%eax
  800570:	ff d0                	call   *%eax
  800572:	83 c4 10             	add    $0x10,%esp
			break;
  800575:	e9 9b 02 00 00       	jmp    800815 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	83 c0 04             	add    $0x4,%eax
  800580:	89 45 14             	mov    %eax,0x14(%ebp)
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	83 e8 04             	sub    $0x4,%eax
  800589:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80058b:	85 db                	test   %ebx,%ebx
  80058d:	79 02                	jns    800591 <vprintfmt+0x14a>
				err = -err;
  80058f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800591:	83 fb 64             	cmp    $0x64,%ebx
  800594:	7f 0b                	jg     8005a1 <vprintfmt+0x15a>
  800596:	8b 34 9d 80 1c 80 00 	mov    0x801c80(,%ebx,4),%esi
  80059d:	85 f6                	test   %esi,%esi
  80059f:	75 19                	jne    8005ba <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005a1:	53                   	push   %ebx
  8005a2:	68 25 1e 80 00       	push   $0x801e25
  8005a7:	ff 75 0c             	pushl  0xc(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 70 02 00 00       	call   800822 <printfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005b5:	e9 5b 02 00 00       	jmp    800815 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ba:	56                   	push   %esi
  8005bb:	68 2e 1e 80 00       	push   $0x801e2e
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 57 02 00 00       	call   800822 <printfmt>
  8005cb:	83 c4 10             	add    $0x10,%esp
			break;
  8005ce:	e9 42 02 00 00       	jmp    800815 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d6:	83 c0 04             	add    $0x4,%eax
  8005d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	83 e8 04             	sub    $0x4,%eax
  8005e2:	8b 30                	mov    (%eax),%esi
  8005e4:	85 f6                	test   %esi,%esi
  8005e6:	75 05                	jne    8005ed <vprintfmt+0x1a6>
				p = "(null)";
  8005e8:	be 31 1e 80 00       	mov    $0x801e31,%esi
			if (width > 0 && padc != '-')
  8005ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005f1:	7e 6d                	jle    800660 <vprintfmt+0x219>
  8005f3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005f7:	74 67                	je     800660 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005fc:	83 ec 08             	sub    $0x8,%esp
  8005ff:	50                   	push   %eax
  800600:	56                   	push   %esi
  800601:	e8 1e 03 00 00       	call   800924 <strnlen>
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80060c:	eb 16                	jmp    800624 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80060e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800612:	83 ec 08             	sub    $0x8,%esp
  800615:	ff 75 0c             	pushl  0xc(%ebp)
  800618:	50                   	push   %eax
  800619:	8b 45 08             	mov    0x8(%ebp),%eax
  80061c:	ff d0                	call   *%eax
  80061e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800621:	ff 4d e4             	decl   -0x1c(%ebp)
  800624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800628:	7f e4                	jg     80060e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80062a:	eb 34                	jmp    800660 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80062c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800630:	74 1c                	je     80064e <vprintfmt+0x207>
  800632:	83 fb 1f             	cmp    $0x1f,%ebx
  800635:	7e 05                	jle    80063c <vprintfmt+0x1f5>
  800637:	83 fb 7e             	cmp    $0x7e,%ebx
  80063a:	7e 12                	jle    80064e <vprintfmt+0x207>
					putch('?', putdat);
  80063c:	83 ec 08             	sub    $0x8,%esp
  80063f:	ff 75 0c             	pushl  0xc(%ebp)
  800642:	6a 3f                	push   $0x3f
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	ff d0                	call   *%eax
  800649:	83 c4 10             	add    $0x10,%esp
  80064c:	eb 0f                	jmp    80065d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80064e:	83 ec 08             	sub    $0x8,%esp
  800651:	ff 75 0c             	pushl  0xc(%ebp)
  800654:	53                   	push   %ebx
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	ff d0                	call   *%eax
  80065a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065d:	ff 4d e4             	decl   -0x1c(%ebp)
  800660:	89 f0                	mov    %esi,%eax
  800662:	8d 70 01             	lea    0x1(%eax),%esi
  800665:	8a 00                	mov    (%eax),%al
  800667:	0f be d8             	movsbl %al,%ebx
  80066a:	85 db                	test   %ebx,%ebx
  80066c:	74 24                	je     800692 <vprintfmt+0x24b>
  80066e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800672:	78 b8                	js     80062c <vprintfmt+0x1e5>
  800674:	ff 4d e0             	decl   -0x20(%ebp)
  800677:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80067b:	79 af                	jns    80062c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067d:	eb 13                	jmp    800692 <vprintfmt+0x24b>
				putch(' ', putdat);
  80067f:	83 ec 08             	sub    $0x8,%esp
  800682:	ff 75 0c             	pushl  0xc(%ebp)
  800685:	6a 20                	push   $0x20
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	ff d0                	call   *%eax
  80068c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80068f:	ff 4d e4             	decl   -0x1c(%ebp)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	7f e7                	jg     80067f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800698:	e9 78 01 00 00       	jmp    800815 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 e8             	pushl  -0x18(%ebp)
  8006a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a6:	50                   	push   %eax
  8006a7:	e8 3c fd ff ff       	call   8003e8 <getint>
  8006ac:	83 c4 10             	add    $0x10,%esp
  8006af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006bb:	85 d2                	test   %edx,%edx
  8006bd:	79 23                	jns    8006e2 <vprintfmt+0x29b>
				putch('-', putdat);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	6a 2d                	push   $0x2d
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	ff d0                	call   *%eax
  8006cc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d5:	f7 d8                	neg    %eax
  8006d7:	83 d2 00             	adc    $0x0,%edx
  8006da:	f7 da                	neg    %edx
  8006dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006df:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006e2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e9:	e9 bc 00 00 00       	jmp    8007aa <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f7:	50                   	push   %eax
  8006f8:	e8 84 fc ff ff       	call   800381 <getuint>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800703:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800706:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80070d:	e9 98 00 00 00       	jmp    8007aa <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	6a 58                	push   $0x58
  80071a:	8b 45 08             	mov    0x8(%ebp),%eax
  80071d:	ff d0                	call   *%eax
  80071f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	6a 58                	push   $0x58
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	ff d0                	call   *%eax
  80072f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800732:	83 ec 08             	sub    $0x8,%esp
  800735:	ff 75 0c             	pushl  0xc(%ebp)
  800738:	6a 58                	push   $0x58
  80073a:	8b 45 08             	mov    0x8(%ebp),%eax
  80073d:	ff d0                	call   *%eax
  80073f:	83 c4 10             	add    $0x10,%esp
			break;
  800742:	e9 ce 00 00 00       	jmp    800815 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800747:	83 ec 08             	sub    $0x8,%esp
  80074a:	ff 75 0c             	pushl  0xc(%ebp)
  80074d:	6a 30                	push   $0x30
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	ff d0                	call   *%eax
  800754:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800757:	83 ec 08             	sub    $0x8,%esp
  80075a:	ff 75 0c             	pushl  0xc(%ebp)
  80075d:	6a 78                	push   $0x78
  80075f:	8b 45 08             	mov    0x8(%ebp),%eax
  800762:	ff d0                	call   *%eax
  800764:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800778:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80077b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800782:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800789:	eb 1f                	jmp    8007aa <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80078b:	83 ec 08             	sub    $0x8,%esp
  80078e:	ff 75 e8             	pushl  -0x18(%ebp)
  800791:	8d 45 14             	lea    0x14(%ebp),%eax
  800794:	50                   	push   %eax
  800795:	e8 e7 fb ff ff       	call   800381 <getuint>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007a3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007aa:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007b1:	83 ec 04             	sub    $0x4,%esp
  8007b4:	52                   	push   %edx
  8007b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8007bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bf:	ff 75 0c             	pushl  0xc(%ebp)
  8007c2:	ff 75 08             	pushl  0x8(%ebp)
  8007c5:	e8 00 fb ff ff       	call   8002ca <printnum>
  8007ca:	83 c4 20             	add    $0x20,%esp
			break;
  8007cd:	eb 46                	jmp    800815 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cf:	83 ec 08             	sub    $0x8,%esp
  8007d2:	ff 75 0c             	pushl  0xc(%ebp)
  8007d5:	53                   	push   %ebx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
			break;
  8007de:	eb 35                	jmp    800815 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007e0:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  8007e7:	eb 2c                	jmp    800815 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007e9:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  8007f0:	eb 23                	jmp    800815 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007f2:	83 ec 08             	sub    $0x8,%esp
  8007f5:	ff 75 0c             	pushl  0xc(%ebp)
  8007f8:	6a 25                	push   $0x25
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	ff d0                	call   *%eax
  8007ff:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800802:	ff 4d 10             	decl   0x10(%ebp)
  800805:	eb 03                	jmp    80080a <vprintfmt+0x3c3>
  800807:	ff 4d 10             	decl   0x10(%ebp)
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	48                   	dec    %eax
  80080e:	8a 00                	mov    (%eax),%al
  800810:	3c 25                	cmp    $0x25,%al
  800812:	75 f3                	jne    800807 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800814:	90                   	nop
		}
	}
  800815:	e9 35 fc ff ff       	jmp    80044f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80081a:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80081b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80081e:	5b                   	pop    %ebx
  80081f:	5e                   	pop    %esi
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800828:	8d 45 10             	lea    0x10(%ebp),%eax
  80082b:	83 c0 04             	add    $0x4,%eax
  80082e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800831:	8b 45 10             	mov    0x10(%ebp),%eax
  800834:	ff 75 f4             	pushl  -0xc(%ebp)
  800837:	50                   	push   %eax
  800838:	ff 75 0c             	pushl  0xc(%ebp)
  80083b:	ff 75 08             	pushl  0x8(%ebp)
  80083e:	e8 04 fc ff ff       	call   800447 <vprintfmt>
  800843:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800846:	90                   	nop
  800847:	c9                   	leave  
  800848:	c3                   	ret    

00800849 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800849:	55                   	push   %ebp
  80084a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80084c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084f:	8b 40 08             	mov    0x8(%eax),%eax
  800852:	8d 50 01             	lea    0x1(%eax),%edx
  800855:	8b 45 0c             	mov    0xc(%ebp),%eax
  800858:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80085b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085e:	8b 10                	mov    (%eax),%edx
  800860:	8b 45 0c             	mov    0xc(%ebp),%eax
  800863:	8b 40 04             	mov    0x4(%eax),%eax
  800866:	39 c2                	cmp    %eax,%edx
  800868:	73 12                	jae    80087c <sprintputch+0x33>
		*b->buf++ = ch;
  80086a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 48 01             	lea    0x1(%eax),%ecx
  800872:	8b 55 0c             	mov    0xc(%ebp),%edx
  800875:	89 0a                	mov    %ecx,(%edx)
  800877:	8b 55 08             	mov    0x8(%ebp),%edx
  80087a:	88 10                	mov    %dl,(%eax)
}
  80087c:	90                   	nop
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    

0080087f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087f:	55                   	push   %ebp
  800880:	89 e5                	mov    %esp,%ebp
  800882:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	01 d0                	add    %edx,%eax
  800896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800899:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008a4:	74 06                	je     8008ac <vsnprintf+0x2d>
  8008a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008aa:	7f 07                	jg     8008b3 <vsnprintf+0x34>
		return -E_INVAL;
  8008ac:	b8 03 00 00 00       	mov    $0x3,%eax
  8008b1:	eb 20                	jmp    8008d3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b3:	ff 75 14             	pushl  0x14(%ebp)
  8008b6:	ff 75 10             	pushl  0x10(%ebp)
  8008b9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008bc:	50                   	push   %eax
  8008bd:	68 49 08 80 00       	push   $0x800849
  8008c2:	e8 80 fb ff ff       	call   800447 <vprintfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008d3:	c9                   	leave  
  8008d4:	c3                   	ret    

008008d5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008db:	8d 45 10             	lea    0x10(%ebp),%eax
  8008de:	83 c0 04             	add    $0x4,%eax
  8008e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ea:	50                   	push   %eax
  8008eb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ee:	ff 75 08             	pushl  0x8(%ebp)
  8008f1:	e8 89 ff ff ff       	call   80087f <vsnprintf>
  8008f6:	83 c4 10             	add    $0x10,%esp
  8008f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800907:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80090e:	eb 06                	jmp    800916 <strlen+0x15>
		n++;
  800910:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800913:	ff 45 08             	incl   0x8(%ebp)
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8a 00                	mov    (%eax),%al
  80091b:	84 c0                	test   %al,%al
  80091d:	75 f1                	jne    800910 <strlen+0xf>
		n++;
	return n;
  80091f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80092a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800931:	eb 09                	jmp    80093c <strnlen+0x18>
		n++;
  800933:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800936:	ff 45 08             	incl   0x8(%ebp)
  800939:	ff 4d 0c             	decl   0xc(%ebp)
  80093c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800940:	74 09                	je     80094b <strnlen+0x27>
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8a 00                	mov    (%eax),%al
  800947:	84 c0                	test   %al,%al
  800949:	75 e8                	jne    800933 <strnlen+0xf>
		n++;
	return n;
  80094b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80095c:	90                   	nop
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8d 50 01             	lea    0x1(%eax),%edx
  800963:	89 55 08             	mov    %edx,0x8(%ebp)
  800966:	8b 55 0c             	mov    0xc(%ebp),%edx
  800969:	8d 4a 01             	lea    0x1(%edx),%ecx
  80096c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80096f:	8a 12                	mov    (%edx),%dl
  800971:	88 10                	mov    %dl,(%eax)
  800973:	8a 00                	mov    (%eax),%al
  800975:	84 c0                	test   %al,%al
  800977:	75 e4                	jne    80095d <strcpy+0xd>
		/* do nothing */;
	return ret;
  800979:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80098a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800991:	eb 1f                	jmp    8009b2 <strncpy+0x34>
		*dst++ = *src;
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	89 55 08             	mov    %edx,0x8(%ebp)
  80099c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099f:	8a 12                	mov    (%edx),%dl
  8009a1:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a6:	8a 00                	mov    (%eax),%al
  8009a8:	84 c0                	test   %al,%al
  8009aa:	74 03                	je     8009af <strncpy+0x31>
			src++;
  8009ac:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009af:	ff 45 fc             	incl   -0x4(%ebp)
  8009b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009b8:	72 d9                	jb     800993 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    

008009bf <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009cf:	74 30                	je     800a01 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009d1:	eb 16                	jmp    8009e9 <strlcpy+0x2a>
			*dst++ = *src++;
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	8d 50 01             	lea    0x1(%eax),%edx
  8009d9:	89 55 08             	mov    %edx,0x8(%ebp)
  8009dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009df:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009e2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009e5:	8a 12                	mov    (%edx),%dl
  8009e7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e9:	ff 4d 10             	decl   0x10(%ebp)
  8009ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f0:	74 09                	je     8009fb <strlcpy+0x3c>
  8009f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f5:	8a 00                	mov    (%eax),%al
  8009f7:	84 c0                	test   %al,%al
  8009f9:	75 d8                	jne    8009d3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fe:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a01:	8b 55 08             	mov    0x8(%ebp),%edx
  800a04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a07:	29 c2                	sub    %eax,%edx
  800a09:	89 d0                	mov    %edx,%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a10:	eb 06                	jmp    800a18 <strcmp+0xb>
		p++, q++;
  800a12:	ff 45 08             	incl   0x8(%ebp)
  800a15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	8a 00                	mov    (%eax),%al
  800a1d:	84 c0                	test   %al,%al
  800a1f:	74 0e                	je     800a2f <strcmp+0x22>
  800a21:	8b 45 08             	mov    0x8(%ebp),%eax
  800a24:	8a 10                	mov    (%eax),%dl
  800a26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a29:	8a 00                	mov    (%eax),%al
  800a2b:	38 c2                	cmp    %al,%dl
  800a2d:	74 e3                	je     800a12 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8a 00                	mov    (%eax),%al
  800a34:	0f b6 d0             	movzbl %al,%edx
  800a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3a:	8a 00                	mov    (%eax),%al
  800a3c:	0f b6 c0             	movzbl %al,%eax
  800a3f:	29 c2                	sub    %eax,%edx
  800a41:	89 d0                	mov    %edx,%eax
}
  800a43:	5d                   	pop    %ebp
  800a44:	c3                   	ret    

00800a45 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a48:	eb 09                	jmp    800a53 <strncmp+0xe>
		n--, p++, q++;
  800a4a:	ff 4d 10             	decl   0x10(%ebp)
  800a4d:	ff 45 08             	incl   0x8(%ebp)
  800a50:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a57:	74 17                	je     800a70 <strncmp+0x2b>
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8a 00                	mov    (%eax),%al
  800a5e:	84 c0                	test   %al,%al
  800a60:	74 0e                	je     800a70 <strncmp+0x2b>
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	8a 10                	mov    (%eax),%dl
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	8a 00                	mov    (%eax),%al
  800a6c:	38 c2                	cmp    %al,%dl
  800a6e:	74 da                	je     800a4a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a74:	75 07                	jne    800a7d <strncmp+0x38>
		return 0;
  800a76:	b8 00 00 00 00       	mov    $0x0,%eax
  800a7b:	eb 14                	jmp    800a91 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a80:	8a 00                	mov    (%eax),%al
  800a82:	0f b6 d0             	movzbl %al,%edx
  800a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a88:	8a 00                	mov    (%eax),%al
  800a8a:	0f b6 c0             	movzbl %al,%eax
  800a8d:	29 c2                	sub    %eax,%edx
  800a8f:	89 d0                	mov    %edx,%eax
}
  800a91:	5d                   	pop    %ebp
  800a92:	c3                   	ret    

00800a93 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a93:	55                   	push   %ebp
  800a94:	89 e5                	mov    %esp,%ebp
  800a96:	83 ec 04             	sub    $0x4,%esp
  800a99:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a9f:	eb 12                	jmp    800ab3 <strchr+0x20>
		if (*s == c)
  800aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa4:	8a 00                	mov    (%eax),%al
  800aa6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aa9:	75 05                	jne    800ab0 <strchr+0x1d>
			return (char *) s;
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	eb 11                	jmp    800ac1 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ab0:	ff 45 08             	incl   0x8(%ebp)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8a 00                	mov    (%eax),%al
  800ab8:	84 c0                	test   %al,%al
  800aba:	75 e5                	jne    800aa1 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800abc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ac1:	c9                   	leave  
  800ac2:	c3                   	ret    

00800ac3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800acf:	eb 0d                	jmp    800ade <strfind+0x1b>
		if (*s == c)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ad9:	74 0e                	je     800ae9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800adb:	ff 45 08             	incl   0x8(%ebp)
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8a 00                	mov    (%eax),%al
  800ae3:	84 c0                	test   %al,%al
  800ae5:	75 ea                	jne    800ad1 <strfind+0xe>
  800ae7:	eb 01                	jmp    800aea <strfind+0x27>
		if (*s == c)
			break;
  800ae9:	90                   	nop
	return (char *) s;
  800aea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800afb:	8b 45 10             	mov    0x10(%ebp),%eax
  800afe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b01:	eb 0e                	jmp    800b11 <memset+0x22>
		*p++ = c;
  800b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b11:	ff 4d f8             	decl   -0x8(%ebp)
  800b14:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b18:	79 e9                	jns    800b03 <memset+0x14>
		*p++ = c;

	return v;
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b1d:	c9                   	leave  
  800b1e:	c3                   	ret    

00800b1f <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b1f:	55                   	push   %ebp
  800b20:	89 e5                	mov    %esp,%ebp
  800b22:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b31:	eb 16                	jmp    800b49 <memcpy+0x2a>
		*d++ = *s++;
  800b33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b36:	8d 50 01             	lea    0x1(%eax),%edx
  800b39:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b3c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b3f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b42:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b45:	8a 12                	mov    (%edx),%dl
  800b47:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b49:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b4f:	89 55 10             	mov    %edx,0x10(%ebp)
  800b52:	85 c0                	test   %eax,%eax
  800b54:	75 dd                	jne    800b33 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b70:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b73:	73 50                	jae    800bc5 <memmove+0x6a>
  800b75:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b78:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b80:	76 43                	jbe    800bc5 <memmove+0x6a>
		s += n;
  800b82:	8b 45 10             	mov    0x10(%ebp),%eax
  800b85:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b88:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b8e:	eb 10                	jmp    800ba0 <memmove+0x45>
			*--d = *--s;
  800b90:	ff 4d f8             	decl   -0x8(%ebp)
  800b93:	ff 4d fc             	decl   -0x4(%ebp)
  800b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b99:	8a 10                	mov    (%eax),%dl
  800b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b9e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ba0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba6:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba9:	85 c0                	test   %eax,%eax
  800bab:	75 e3                	jne    800b90 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bad:	eb 23                	jmp    800bd2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800baf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bb2:	8d 50 01             	lea    0x1(%eax),%edx
  800bb5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bbb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bc1:	8a 12                	mov    (%edx),%dl
  800bc3:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bcb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bce:	85 c0                	test   %eax,%eax
  800bd0:	75 dd                	jne    800baf <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800be3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800be9:	eb 2a                	jmp    800c15 <memcmp+0x3e>
		if (*s1 != *s2)
  800beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bee:	8a 10                	mov    (%eax),%dl
  800bf0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf3:	8a 00                	mov    (%eax),%al
  800bf5:	38 c2                	cmp    %al,%dl
  800bf7:	74 16                	je     800c0f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	0f b6 d0             	movzbl %al,%edx
  800c01:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	0f b6 c0             	movzbl %al,%eax
  800c09:	29 c2                	sub    %eax,%edx
  800c0b:	89 d0                	mov    %edx,%eax
  800c0d:	eb 18                	jmp    800c27 <memcmp+0x50>
		s1++, s2++;
  800c0f:	ff 45 fc             	incl   -0x4(%ebp)
  800c12:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c15:	8b 45 10             	mov    0x10(%ebp),%eax
  800c18:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1e:	85 c0                	test   %eax,%eax
  800c20:	75 c9                	jne    800beb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c27:	c9                   	leave  
  800c28:	c3                   	ret    

00800c29 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c32:	8b 45 10             	mov    0x10(%ebp),%eax
  800c35:	01 d0                	add    %edx,%eax
  800c37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c3a:	eb 15                	jmp    800c51 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	0f b6 d0             	movzbl %al,%edx
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	0f b6 c0             	movzbl %al,%eax
  800c4a:	39 c2                	cmp    %eax,%edx
  800c4c:	74 0d                	je     800c5b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c4e:	ff 45 08             	incl   0x8(%ebp)
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c57:	72 e3                	jb     800c3c <memfind+0x13>
  800c59:	eb 01                	jmp    800c5c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c5b:	90                   	nop
	return (void *) s;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5f:	c9                   	leave  
  800c60:	c3                   	ret    

00800c61 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c67:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c6e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c75:	eb 03                	jmp    800c7a <strtol+0x19>
		s++;
  800c77:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8a 00                	mov    (%eax),%al
  800c7f:	3c 20                	cmp    $0x20,%al
  800c81:	74 f4                	je     800c77 <strtol+0x16>
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	3c 09                	cmp    $0x9,%al
  800c8a:	74 eb                	je     800c77 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	3c 2b                	cmp    $0x2b,%al
  800c93:	75 05                	jne    800c9a <strtol+0x39>
		s++;
  800c95:	ff 45 08             	incl   0x8(%ebp)
  800c98:	eb 13                	jmp    800cad <strtol+0x4c>
	else if (*s == '-')
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8a 00                	mov    (%eax),%al
  800c9f:	3c 2d                	cmp    $0x2d,%al
  800ca1:	75 0a                	jne    800cad <strtol+0x4c>
		s++, neg = 1;
  800ca3:	ff 45 08             	incl   0x8(%ebp)
  800ca6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb1:	74 06                	je     800cb9 <strtol+0x58>
  800cb3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cb7:	75 20                	jne    800cd9 <strtol+0x78>
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	3c 30                	cmp    $0x30,%al
  800cc0:	75 17                	jne    800cd9 <strtol+0x78>
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	40                   	inc    %eax
  800cc6:	8a 00                	mov    (%eax),%al
  800cc8:	3c 78                	cmp    $0x78,%al
  800cca:	75 0d                	jne    800cd9 <strtol+0x78>
		s += 2, base = 16;
  800ccc:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800cd0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cd7:	eb 28                	jmp    800d01 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdd:	75 15                	jne    800cf4 <strtol+0x93>
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8a 00                	mov    (%eax),%al
  800ce4:	3c 30                	cmp    $0x30,%al
  800ce6:	75 0c                	jne    800cf4 <strtol+0x93>
		s++, base = 8;
  800ce8:	ff 45 08             	incl   0x8(%ebp)
  800ceb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cf2:	eb 0d                	jmp    800d01 <strtol+0xa0>
	else if (base == 0)
  800cf4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf8:	75 07                	jne    800d01 <strtol+0xa0>
		base = 10;
  800cfa:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8a 00                	mov    (%eax),%al
  800d06:	3c 2f                	cmp    $0x2f,%al
  800d08:	7e 19                	jle    800d23 <strtol+0xc2>
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	3c 39                	cmp    $0x39,%al
  800d11:	7f 10                	jg     800d23 <strtol+0xc2>
			dig = *s - '0';
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	0f be c0             	movsbl %al,%eax
  800d1b:	83 e8 30             	sub    $0x30,%eax
  800d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d21:	eb 42                	jmp    800d65 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	3c 60                	cmp    $0x60,%al
  800d2a:	7e 19                	jle    800d45 <strtol+0xe4>
  800d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	3c 7a                	cmp    $0x7a,%al
  800d33:	7f 10                	jg     800d45 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f be c0             	movsbl %al,%eax
  800d3d:	83 e8 57             	sub    $0x57,%eax
  800d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d43:	eb 20                	jmp    800d65 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	8a 00                	mov    (%eax),%al
  800d4a:	3c 40                	cmp    $0x40,%al
  800d4c:	7e 39                	jle    800d87 <strtol+0x126>
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 5a                	cmp    $0x5a,%al
  800d55:	7f 30                	jg     800d87 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	8a 00                	mov    (%eax),%al
  800d5c:	0f be c0             	movsbl %al,%eax
  800d5f:	83 e8 37             	sub    $0x37,%eax
  800d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	7d 19                	jge    800d86 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d73:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d77:	89 c2                	mov    %eax,%edx
  800d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d7c:	01 d0                	add    %edx,%eax
  800d7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d81:	e9 7b ff ff ff       	jmp    800d01 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d86:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d8b:	74 08                	je     800d95 <strtol+0x134>
		*endptr = (char *) s;
  800d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d90:	8b 55 08             	mov    0x8(%ebp),%edx
  800d93:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d95:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d99:	74 07                	je     800da2 <strtol+0x141>
  800d9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9e:	f7 d8                	neg    %eax
  800da0:	eb 03                	jmp    800da5 <strtol+0x144>
  800da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <ltostr>:

void
ltostr(long value, char *str)
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800db4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800dbb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dbf:	79 13                	jns    800dd4 <ltostr+0x2d>
	{
		neg = 1;
  800dc1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dce:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dd1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ddc:	99                   	cltd   
  800ddd:	f7 f9                	idiv   %ecx
  800ddf:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800de2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de5:	8d 50 01             	lea    0x1(%eax),%edx
  800de8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800deb:	89 c2                	mov    %eax,%edx
  800ded:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df0:	01 d0                	add    %edx,%eax
  800df2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800df5:	83 c2 30             	add    $0x30,%edx
  800df8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800dfa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e02:	f7 e9                	imul   %ecx
  800e04:	c1 fa 02             	sar    $0x2,%edx
  800e07:	89 c8                	mov    %ecx,%eax
  800e09:	c1 f8 1f             	sar    $0x1f,%eax
  800e0c:	29 c2                	sub    %eax,%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e17:	75 bb                	jne    800dd4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e23:	48                   	dec    %eax
  800e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e27:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e2b:	74 3d                	je     800e6a <ltostr+0xc3>
		start = 1 ;
  800e2d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e34:	eb 34                	jmp    800e6a <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	01 d0                	add    %edx,%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e43:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e49:	01 c2                	add    %eax,%edx
  800e4b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	01 c8                	add    %ecx,%eax
  800e53:	8a 00                	mov    (%eax),%al
  800e55:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	01 c2                	add    %eax,%edx
  800e5f:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e62:	88 02                	mov    %al,(%edx)
		start++ ;
  800e64:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e67:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e70:	7c c4                	jl     800e36 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e72:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e7d:	90                   	nop
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e86:	ff 75 08             	pushl  0x8(%ebp)
  800e89:	e8 73 fa ff ff       	call   800901 <strlen>
  800e8e:	83 c4 04             	add    $0x4,%esp
  800e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	e8 65 fa ff ff       	call   800901 <strlen>
  800e9c:	83 c4 04             	add    $0x4,%esp
  800e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ea2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 17                	jmp    800ec9 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eb2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	01 c2                	add    %eax,%edx
  800eba:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec0:	01 c8                	add    %ecx,%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ecf:	7c e1                	jl     800eb2 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ed1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ed8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800edf:	eb 1f                	jmp    800f00 <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee4:	8d 50 01             	lea    0x1(%eax),%edx
  800ee7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eea:	89 c2                	mov    %eax,%edx
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 c2                	add    %eax,%edx
  800ef1:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	01 c8                	add    %ecx,%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
  800f00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f06:	7c d9                	jl     800ee1 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f08:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0e:	01 d0                	add    %edx,%eax
  800f10:	c6 00 00             	movb   $0x0,(%eax)
}
  800f13:	90                   	nop
  800f14:	c9                   	leave  
  800f15:	c3                   	ret    

00800f16 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f16:	55                   	push   %ebp
  800f17:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f19:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f22:	8b 45 14             	mov    0x14(%ebp),%eax
  800f25:	8b 00                	mov    (%eax),%eax
  800f27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f31:	01 d0                	add    %edx,%eax
  800f33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f39:	eb 0c                	jmp    800f47 <strsplit+0x31>
			*string++ = 0;
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8d 50 01             	lea    0x1(%eax),%edx
  800f41:	89 55 08             	mov    %edx,0x8(%ebp)
  800f44:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	8a 00                	mov    (%eax),%al
  800f4c:	84 c0                	test   %al,%al
  800f4e:	74 18                	je     800f68 <strsplit+0x52>
  800f50:	8b 45 08             	mov    0x8(%ebp),%eax
  800f53:	8a 00                	mov    (%eax),%al
  800f55:	0f be c0             	movsbl %al,%eax
  800f58:	50                   	push   %eax
  800f59:	ff 75 0c             	pushl  0xc(%ebp)
  800f5c:	e8 32 fb ff ff       	call   800a93 <strchr>
  800f61:	83 c4 08             	add    $0x8,%esp
  800f64:	85 c0                	test   %eax,%eax
  800f66:	75 d3                	jne    800f3b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	8a 00                	mov    (%eax),%al
  800f6d:	84 c0                	test   %al,%al
  800f6f:	74 5a                	je     800fcb <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f71:	8b 45 14             	mov    0x14(%ebp),%eax
  800f74:	8b 00                	mov    (%eax),%eax
  800f76:	83 f8 0f             	cmp    $0xf,%eax
  800f79:	75 07                	jne    800f82 <strsplit+0x6c>
		{
			return 0;
  800f7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f80:	eb 66                	jmp    800fe8 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f82:	8b 45 14             	mov    0x14(%ebp),%eax
  800f85:	8b 00                	mov    (%eax),%eax
  800f87:	8d 48 01             	lea    0x1(%eax),%ecx
  800f8a:	8b 55 14             	mov    0x14(%ebp),%edx
  800f8d:	89 0a                	mov    %ecx,(%edx)
  800f8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	01 c2                	add    %eax,%edx
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa0:	eb 03                	jmp    800fa5 <strsplit+0x8f>
			string++;
  800fa2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	84 c0                	test   %al,%al
  800fac:	74 8b                	je     800f39 <strsplit+0x23>
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f be c0             	movsbl %al,%eax
  800fb6:	50                   	push   %eax
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	e8 d4 fa ff ff       	call   800a93 <strchr>
  800fbf:	83 c4 08             	add    $0x8,%esp
  800fc2:	85 c0                	test   %eax,%eax
  800fc4:	74 dc                	je     800fa2 <strsplit+0x8c>
			string++;
	}
  800fc6:	e9 6e ff ff ff       	jmp    800f39 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fcb:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	8b 00                	mov    (%eax),%eax
  800fd1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdb:	01 d0                	add    %edx,%eax
  800fdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fe3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800ff0:	83 ec 04             	sub    $0x4,%esp
  800ff3:	68 a8 1f 80 00       	push   $0x801fa8
  800ff8:	68 3f 01 00 00       	push   $0x13f
  800ffd:	68 ca 1f 80 00       	push   $0x801fca
  801002:	e8 9d 06 00 00       	call   8016a4 <_panic>

00801007 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	57                   	push   %edi
  80100b:	56                   	push   %esi
  80100c:	53                   	push   %ebx
  80100d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8b 55 0c             	mov    0xc(%ebp),%edx
  801016:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801019:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80101c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80101f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801022:	cd 30                	int    $0x30
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801027:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80102a:	83 c4 10             	add    $0x10,%esp
  80102d:	5b                   	pop    %ebx
  80102e:	5e                   	pop    %esi
  80102f:	5f                   	pop    %edi
  801030:	5d                   	pop    %ebp
  801031:	c3                   	ret    

00801032 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
  801035:	83 ec 04             	sub    $0x4,%esp
  801038:	8b 45 10             	mov    0x10(%ebp),%eax
  80103b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80103e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	6a 00                	push   $0x0
  801047:	6a 00                	push   $0x0
  801049:	52                   	push   %edx
  80104a:	ff 75 0c             	pushl  0xc(%ebp)
  80104d:	50                   	push   %eax
  80104e:	6a 00                	push   $0x0
  801050:	e8 b2 ff ff ff       	call   801007 <syscall>
  801055:	83 c4 18             	add    $0x18,%esp
}
  801058:	90                   	nop
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <sys_cgetc>:

int sys_cgetc(void) {
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80105e:	6a 00                	push   $0x0
  801060:	6a 00                	push   $0x0
  801062:	6a 00                	push   $0x0
  801064:	6a 00                	push   $0x0
  801066:	6a 00                	push   $0x0
  801068:	6a 02                	push   $0x2
  80106a:	e8 98 ff ff ff       	call   801007 <syscall>
  80106f:	83 c4 18             	add    $0x18,%esp
}
  801072:	c9                   	leave  
  801073:	c3                   	ret    

00801074 <sys_lock_cons>:

void sys_lock_cons(void) {
  801074:	55                   	push   %ebp
  801075:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801077:	6a 00                	push   $0x0
  801079:	6a 00                	push   $0x0
  80107b:	6a 00                	push   $0x0
  80107d:	6a 00                	push   $0x0
  80107f:	6a 00                	push   $0x0
  801081:	6a 03                	push   $0x3
  801083:	e8 7f ff ff ff       	call   801007 <syscall>
  801088:	83 c4 18             	add    $0x18,%esp
}
  80108b:	90                   	nop
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801091:	6a 00                	push   $0x0
  801093:	6a 00                	push   $0x0
  801095:	6a 00                	push   $0x0
  801097:	6a 00                	push   $0x0
  801099:	6a 00                	push   $0x0
  80109b:	6a 04                	push   $0x4
  80109d:	e8 65 ff ff ff       	call   801007 <syscall>
  8010a2:	83 c4 18             	add    $0x18,%esp
}
  8010a5:	90                   	nop
  8010a6:	c9                   	leave  
  8010a7:	c3                   	ret    

008010a8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8010ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b1:	6a 00                	push   $0x0
  8010b3:	6a 00                	push   $0x0
  8010b5:	6a 00                	push   $0x0
  8010b7:	52                   	push   %edx
  8010b8:	50                   	push   %eax
  8010b9:	6a 08                	push   $0x8
  8010bb:	e8 47 ff ff ff       	call   801007 <syscall>
  8010c0:	83 c4 18             	add    $0x18,%esp
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8010ca:	8b 75 18             	mov    0x18(%ebp),%esi
  8010cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	51                   	push   %ecx
  8010dc:	52                   	push   %edx
  8010dd:	50                   	push   %eax
  8010de:	6a 09                	push   $0x9
  8010e0:	e8 22 ff ff ff       	call   801007 <syscall>
  8010e5:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8010e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	6a 00                	push   $0x0
  8010fa:	6a 00                	push   $0x0
  8010fc:	6a 00                	push   $0x0
  8010fe:	52                   	push   %edx
  8010ff:	50                   	push   %eax
  801100:	6a 0a                	push   $0xa
  801102:	e8 00 ff ff ff       	call   801007 <syscall>
  801107:	83 c4 18             	add    $0x18,%esp
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80110f:	6a 00                	push   $0x0
  801111:	6a 00                	push   $0x0
  801113:	6a 00                	push   $0x0
  801115:	ff 75 0c             	pushl  0xc(%ebp)
  801118:	ff 75 08             	pushl  0x8(%ebp)
  80111b:	6a 0b                	push   $0xb
  80111d:	e8 e5 fe ff ff       	call   801007 <syscall>
  801122:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801125:	c9                   	leave  
  801126:	c3                   	ret    

00801127 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801127:	55                   	push   %ebp
  801128:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80112a:	6a 00                	push   $0x0
  80112c:	6a 00                	push   $0x0
  80112e:	6a 00                	push   $0x0
  801130:	6a 00                	push   $0x0
  801132:	6a 00                	push   $0x0
  801134:	6a 0c                	push   $0xc
  801136:	e8 cc fe ff ff       	call   801007 <syscall>
  80113b:	83 c4 18             	add    $0x18,%esp
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801143:	6a 00                	push   $0x0
  801145:	6a 00                	push   $0x0
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	6a 00                	push   $0x0
  80114d:	6a 0d                	push   $0xd
  80114f:	e8 b3 fe ff ff       	call   801007 <syscall>
  801154:	83 c4 18             	add    $0x18,%esp
}
  801157:	c9                   	leave  
  801158:	c3                   	ret    

00801159 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80115c:	6a 00                	push   $0x0
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	6a 00                	push   $0x0
  801166:	6a 0e                	push   $0xe
  801168:	e8 9a fe ff ff       	call   801007 <syscall>
  80116d:	83 c4 18             	add    $0x18,%esp
}
  801170:	c9                   	leave  
  801171:	c3                   	ret    

00801172 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801175:	6a 00                	push   $0x0
  801177:	6a 00                	push   $0x0
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 0f                	push   $0xf
  801181:	e8 81 fe ff ff       	call   801007 <syscall>
  801186:	83 c4 18             	add    $0x18,%esp
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80118e:	6a 00                	push   $0x0
  801190:	6a 00                	push   $0x0
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	ff 75 08             	pushl  0x8(%ebp)
  801199:	6a 10                	push   $0x10
  80119b:	e8 67 fe ff ff       	call   801007 <syscall>
  8011a0:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <sys_scarce_memory>:

void sys_scarce_memory() {
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8011a8:	6a 00                	push   $0x0
  8011aa:	6a 00                	push   $0x0
  8011ac:	6a 00                	push   $0x0
  8011ae:	6a 00                	push   $0x0
  8011b0:	6a 00                	push   $0x0
  8011b2:	6a 11                	push   $0x11
  8011b4:	e8 4e fe ff ff       	call   801007 <syscall>
  8011b9:	83 c4 18             	add    $0x18,%esp
}
  8011bc:	90                   	nop
  8011bd:	c9                   	leave  
  8011be:	c3                   	ret    

008011bf <sys_cputc>:

void sys_cputc(const char c) {
  8011bf:	55                   	push   %ebp
  8011c0:	89 e5                	mov    %esp,%ebp
  8011c2:	83 ec 04             	sub    $0x4,%esp
  8011c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 00                	push   $0x0
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 00                	push   $0x0
  8011d7:	50                   	push   %eax
  8011d8:	6a 01                	push   $0x1
  8011da:	e8 28 fe ff ff       	call   801007 <syscall>
  8011df:	83 c4 18             	add    $0x18,%esp
}
  8011e2:	90                   	nop
  8011e3:	c9                   	leave  
  8011e4:	c3                   	ret    

008011e5 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 00                	push   $0x0
  8011f0:	6a 00                	push   $0x0
  8011f2:	6a 14                	push   $0x14
  8011f4:	e8 0e fe ff ff       	call   801007 <syscall>
  8011f9:	83 c4 18             	add    $0x18,%esp
}
  8011fc:	90                   	nop
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 04             	sub    $0x4,%esp
  801205:	8b 45 10             	mov    0x10(%ebp),%eax
  801208:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80120b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80120e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	6a 00                	push   $0x0
  801217:	51                   	push   %ecx
  801218:	52                   	push   %edx
  801219:	ff 75 0c             	pushl  0xc(%ebp)
  80121c:	50                   	push   %eax
  80121d:	6a 15                	push   $0x15
  80121f:	e8 e3 fd ff ff       	call   801007 <syscall>
  801224:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80122c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	6a 00                	push   $0x0
  801234:	6a 00                	push   $0x0
  801236:	6a 00                	push   $0x0
  801238:	52                   	push   %edx
  801239:	50                   	push   %eax
  80123a:	6a 16                	push   $0x16
  80123c:	e8 c6 fd ff ff       	call   801007 <syscall>
  801241:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801249:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80124c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	6a 00                	push   $0x0
  801254:	6a 00                	push   $0x0
  801256:	51                   	push   %ecx
  801257:	52                   	push   %edx
  801258:	50                   	push   %eax
  801259:	6a 17                	push   $0x17
  80125b:	e8 a7 fd ff ff       	call   801007 <syscall>
  801260:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801268:	8b 55 0c             	mov    0xc(%ebp),%edx
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	6a 00                	push   $0x0
  801270:	6a 00                	push   $0x0
  801272:	6a 00                	push   $0x0
  801274:	52                   	push   %edx
  801275:	50                   	push   %eax
  801276:	6a 18                	push   $0x18
  801278:	e8 8a fd ff ff       	call   801007 <syscall>
  80127d:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  801280:	c9                   	leave  
  801281:	c3                   	ret    

00801282 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	6a 00                	push   $0x0
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	ff 75 0c             	pushl  0xc(%ebp)
  801293:	50                   	push   %eax
  801294:	6a 19                	push   $0x19
  801296:	e8 6c fd ff ff       	call   801007 <syscall>
  80129b:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80129e:	c9                   	leave  
  80129f:	c3                   	ret    

008012a0 <sys_run_env>:

void sys_run_env(int32 envId) {
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	6a 00                	push   $0x0
  8012a8:	6a 00                	push   $0x0
  8012aa:	6a 00                	push   $0x0
  8012ac:	6a 00                	push   $0x0
  8012ae:	50                   	push   %eax
  8012af:	6a 1a                	push   $0x1a
  8012b1:	e8 51 fd ff ff       	call   801007 <syscall>
  8012b6:	83 c4 18             	add    $0x18,%esp
}
  8012b9:	90                   	nop
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	6a 00                	push   $0x0
  8012c4:	6a 00                	push   $0x0
  8012c6:	6a 00                	push   $0x0
  8012c8:	6a 00                	push   $0x0
  8012ca:	50                   	push   %eax
  8012cb:	6a 1b                	push   $0x1b
  8012cd:	e8 35 fd ff ff       	call   801007 <syscall>
  8012d2:	83 c4 18             	add    $0x18,%esp
}
  8012d5:	c9                   	leave  
  8012d6:	c3                   	ret    

008012d7 <sys_getenvid>:

int32 sys_getenvid(void) {
  8012d7:	55                   	push   %ebp
  8012d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012da:	6a 00                	push   $0x0
  8012dc:	6a 00                	push   $0x0
  8012de:	6a 00                	push   $0x0
  8012e0:	6a 00                	push   $0x0
  8012e2:	6a 00                	push   $0x0
  8012e4:	6a 05                	push   $0x5
  8012e6:	e8 1c fd ff ff       	call   801007 <syscall>
  8012eb:	83 c4 18             	add    $0x18,%esp
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	6a 06                	push   $0x6
  8012ff:	e8 03 fd ff ff       	call   801007 <syscall>
  801304:	83 c4 18             	add    $0x18,%esp
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 00                	push   $0x0
  801312:	6a 00                	push   $0x0
  801314:	6a 00                	push   $0x0
  801316:	6a 07                	push   $0x7
  801318:	e8 ea fc ff ff       	call   801007 <syscall>
  80131d:	83 c4 18             	add    $0x18,%esp
}
  801320:	c9                   	leave  
  801321:	c3                   	ret    

00801322 <sys_exit_env>:

void sys_exit_env(void) {
  801322:	55                   	push   %ebp
  801323:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801325:	6a 00                	push   $0x0
  801327:	6a 00                	push   $0x0
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 1c                	push   $0x1c
  801331:	e8 d1 fc ff ff       	call   801007 <syscall>
  801336:	83 c4 18             	add    $0x18,%esp
}
  801339:	90                   	nop
  80133a:	c9                   	leave  
  80133b:	c3                   	ret    

0080133c <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80133c:	55                   	push   %ebp
  80133d:	89 e5                	mov    %esp,%ebp
  80133f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801342:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801345:	8d 50 04             	lea    0x4(%eax),%edx
  801348:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	52                   	push   %edx
  801352:	50                   	push   %eax
  801353:	6a 1d                	push   $0x1d
  801355:	e8 ad fc ff ff       	call   801007 <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80135d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801360:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801363:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801366:	89 01                	mov    %eax,(%ecx)
  801368:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	c9                   	leave  
  80136f:	c2 04 00             	ret    $0x4

00801372 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801375:	6a 00                	push   $0x0
  801377:	6a 00                	push   $0x0
  801379:	ff 75 10             	pushl  0x10(%ebp)
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	ff 75 08             	pushl  0x8(%ebp)
  801382:	6a 13                	push   $0x13
  801384:	e8 7e fc ff ff       	call   801007 <syscall>
  801389:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80138c:	90                   	nop
}
  80138d:	c9                   	leave  
  80138e:	c3                   	ret    

0080138f <sys_rcr2>:
uint32 sys_rcr2() {
  80138f:	55                   	push   %ebp
  801390:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801392:	6a 00                	push   $0x0
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 1e                	push   $0x1e
  80139e:	e8 64 fc ff ff       	call   801007 <syscall>
  8013a3:	83 c4 18             	add    $0x18,%esp
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013b4:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013b8:	6a 00                	push   $0x0
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	50                   	push   %eax
  8013c1:	6a 1f                	push   $0x1f
  8013c3:	e8 3f fc ff ff       	call   801007 <syscall>
  8013c8:	83 c4 18             	add    $0x18,%esp
	return;
  8013cb:	90                   	nop
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <rsttst>:
void rsttst() {
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013d1:	6a 00                	push   $0x0
  8013d3:	6a 00                	push   $0x0
  8013d5:	6a 00                	push   $0x0
  8013d7:	6a 00                	push   $0x0
  8013d9:	6a 00                	push   $0x0
  8013db:	6a 21                	push   $0x21
  8013dd:	e8 25 fc ff ff       	call   801007 <syscall>
  8013e2:	83 c4 18             	add    $0x18,%esp
	return;
  8013e5:	90                   	nop
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
  8013eb:	83 ec 04             	sub    $0x4,%esp
  8013ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013f4:	8b 55 18             	mov    0x18(%ebp),%edx
  8013f7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013fb:	52                   	push   %edx
  8013fc:	50                   	push   %eax
  8013fd:	ff 75 10             	pushl  0x10(%ebp)
  801400:	ff 75 0c             	pushl  0xc(%ebp)
  801403:	ff 75 08             	pushl  0x8(%ebp)
  801406:	6a 20                	push   $0x20
  801408:	e8 fa fb ff ff       	call   801007 <syscall>
  80140d:	83 c4 18             	add    $0x18,%esp
	return;
  801410:	90                   	nop
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <chktst>:
void chktst(uint32 n) {
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801416:	6a 00                	push   $0x0
  801418:	6a 00                	push   $0x0
  80141a:	6a 00                	push   $0x0
  80141c:	6a 00                	push   $0x0
  80141e:	ff 75 08             	pushl  0x8(%ebp)
  801421:	6a 22                	push   $0x22
  801423:	e8 df fb ff ff       	call   801007 <syscall>
  801428:	83 c4 18             	add    $0x18,%esp
	return;
  80142b:	90                   	nop
}
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <inctst>:

void inctst() {
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801431:	6a 00                	push   $0x0
  801433:	6a 00                	push   $0x0
  801435:	6a 00                	push   $0x0
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 23                	push   $0x23
  80143d:	e8 c5 fb ff ff       	call   801007 <syscall>
  801442:	83 c4 18             	add    $0x18,%esp
	return;
  801445:	90                   	nop
}
  801446:	c9                   	leave  
  801447:	c3                   	ret    

00801448 <gettst>:
uint32 gettst() {
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80144b:	6a 00                	push   $0x0
  80144d:	6a 00                	push   $0x0
  80144f:	6a 00                	push   $0x0
  801451:	6a 00                	push   $0x0
  801453:	6a 00                	push   $0x0
  801455:	6a 24                	push   $0x24
  801457:	e8 ab fb ff ff       	call   801007 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	6a 00                	push   $0x0
  80146f:	6a 00                	push   $0x0
  801471:	6a 25                	push   $0x25
  801473:	e8 8f fb ff ff       	call   801007 <syscall>
  801478:	83 c4 18             	add    $0x18,%esp
  80147b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80147e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801482:	75 07                	jne    80148b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801484:	b8 01 00 00 00       	mov    $0x1,%eax
  801489:	eb 05                	jmp    801490 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801498:	6a 00                	push   $0x0
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 25                	push   $0x25
  8014a4:	e8 5e fb ff ff       	call   801007 <syscall>
  8014a9:	83 c4 18             	add    $0x18,%esp
  8014ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014af:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014b3:	75 07                	jne    8014bc <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8014ba:	eb 05                	jmp    8014c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c1:	c9                   	leave  
  8014c2:	c3                   	ret    

008014c3 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8014c3:	55                   	push   %ebp
  8014c4:	89 e5                	mov    %esp,%ebp
  8014c6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014c9:	6a 00                	push   $0x0
  8014cb:	6a 00                	push   $0x0
  8014cd:	6a 00                	push   $0x0
  8014cf:	6a 00                	push   $0x0
  8014d1:	6a 00                	push   $0x0
  8014d3:	6a 25                	push   $0x25
  8014d5:	e8 2d fb ff ff       	call   801007 <syscall>
  8014da:	83 c4 18             	add    $0x18,%esp
  8014dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014e0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014e4:	75 07                	jne    8014ed <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8014eb:	eb 05                	jmp    8014f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014fa:	6a 00                	push   $0x0
  8014fc:	6a 00                	push   $0x0
  8014fe:	6a 00                	push   $0x0
  801500:	6a 00                	push   $0x0
  801502:	6a 00                	push   $0x0
  801504:	6a 25                	push   $0x25
  801506:	e8 fc fa ff ff       	call   801007 <syscall>
  80150b:	83 c4 18             	add    $0x18,%esp
  80150e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801511:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801515:	75 07                	jne    80151e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801517:	b8 01 00 00 00       	mov    $0x1,%eax
  80151c:	eb 05                	jmp    801523 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80151e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801523:	c9                   	leave  
  801524:	c3                   	ret    

00801525 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 00                	push   $0x0
  801530:	ff 75 08             	pushl  0x8(%ebp)
  801533:	6a 26                	push   $0x26
  801535:	e8 cd fa ff ff       	call   801007 <syscall>
  80153a:	83 c4 18             	add    $0x18,%esp
	return;
  80153d:	90                   	nop
}
  80153e:	c9                   	leave  
  80153f:	c3                   	ret    

00801540 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  801540:	55                   	push   %ebp
  801541:	89 e5                	mov    %esp,%ebp
  801543:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801544:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801547:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80154a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	6a 00                	push   $0x0
  801552:	53                   	push   %ebx
  801553:	51                   	push   %ecx
  801554:	52                   	push   %edx
  801555:	50                   	push   %eax
  801556:	6a 27                	push   $0x27
  801558:	e8 aa fa ff ff       	call   801007 <syscall>
  80155d:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  801560:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801563:	c9                   	leave  
  801564:	c3                   	ret    

00801565 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	6a 00                	push   $0x0
  801570:	6a 00                	push   $0x0
  801572:	6a 00                	push   $0x0
  801574:	52                   	push   %edx
  801575:	50                   	push   %eax
  801576:	6a 28                	push   $0x28
  801578:	e8 8a fa ff ff       	call   801007 <syscall>
  80157d:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  801580:	c9                   	leave  
  801581:	c3                   	ret    

00801582 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801585:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	6a 00                	push   $0x0
  801590:	51                   	push   %ecx
  801591:	ff 75 10             	pushl  0x10(%ebp)
  801594:	52                   	push   %edx
  801595:	50                   	push   %eax
  801596:	6a 29                	push   $0x29
  801598:	e8 6a fa ff ff       	call   801007 <syscall>
  80159d:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015a5:	6a 00                	push   $0x0
  8015a7:	6a 00                	push   $0x0
  8015a9:	ff 75 10             	pushl  0x10(%ebp)
  8015ac:	ff 75 0c             	pushl  0xc(%ebp)
  8015af:	ff 75 08             	pushl  0x8(%ebp)
  8015b2:	6a 12                	push   $0x12
  8015b4:	e8 4e fa ff ff       	call   801007 <syscall>
  8015b9:	83 c4 18             	add    $0x18,%esp
	return;
  8015bc:	90                   	nop
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8015c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	6a 00                	push   $0x0
  8015ca:	6a 00                	push   $0x0
  8015cc:	6a 00                	push   $0x0
  8015ce:	52                   	push   %edx
  8015cf:	50                   	push   %eax
  8015d0:	6a 2a                	push   $0x2a
  8015d2:	e8 30 fa ff ff       	call   801007 <syscall>
  8015d7:	83 c4 18             	add    $0x18,%esp
	return;
  8015da:	90                   	nop
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	6a 00                	push   $0x0
  8015eb:	50                   	push   %eax
  8015ec:	6a 2b                	push   $0x2b
  8015ee:	e8 14 fa ff ff       	call   801007 <syscall>
  8015f3:	83 c4 18             	add    $0x18,%esp
}
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    

008015f8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8015f8:	55                   	push   %ebp
  8015f9:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	ff 75 08             	pushl  0x8(%ebp)
  801607:	6a 2c                	push   $0x2c
  801609:	e8 f9 f9 ff ff       	call   801007 <syscall>
  80160e:	83 c4 18             	add    $0x18,%esp
	return;
  801611:	90                   	nop
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	ff 75 08             	pushl  0x8(%ebp)
  801623:	6a 2d                	push   $0x2d
  801625:	e8 dd f9 ff ff       	call   801007 <syscall>
  80162a:	83 c4 18             	add    $0x18,%esp
	return;
  80162d:	90                   	nop
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	6a 00                	push   $0x0
  80163c:	6a 00                	push   $0x0
  80163e:	50                   	push   %eax
  80163f:	6a 2f                	push   $0x2f
  801641:	e8 c1 f9 ff ff       	call   801007 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
	return;
  801649:	90                   	nop
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80164f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	6a 00                	push   $0x0
  801657:	6a 00                	push   $0x0
  801659:	6a 00                	push   $0x0
  80165b:	52                   	push   %edx
  80165c:	50                   	push   %eax
  80165d:	6a 30                	push   $0x30
  80165f:	e8 a3 f9 ff ff       	call   801007 <syscall>
  801664:	83 c4 18             	add    $0x18,%esp
	return;
  801667:	90                   	nop
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	6a 00                	push   $0x0
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	50                   	push   %eax
  801679:	6a 31                	push   $0x31
  80167b:	e8 87 f9 ff ff       	call   801007 <syscall>
  801680:	83 c4 18             	add    $0x18,%esp
	return;
  801683:	90                   	nop
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801689:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	6a 00                	push   $0x0
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	52                   	push   %edx
  801696:	50                   	push   %eax
  801697:	6a 2e                	push   $0x2e
  801699:	e8 69 f9 ff ff       	call   801007 <syscall>
  80169e:	83 c4 18             	add    $0x18,%esp
    return;
  8016a1:	90                   	nop
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016aa:	8d 45 10             	lea    0x10(%ebp),%eax
  8016ad:	83 c0 04             	add    $0x4,%eax
  8016b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016b3:	a1 28 30 80 00       	mov    0x803028,%eax
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	74 16                	je     8016d2 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016bc:	a1 28 30 80 00       	mov    0x803028,%eax
  8016c1:	83 ec 08             	sub    $0x8,%esp
  8016c4:	50                   	push   %eax
  8016c5:	68 d8 1f 80 00       	push   $0x801fd8
  8016ca:	e8 9e eb ff ff       	call   80026d <cprintf>
  8016cf:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016d2:	a1 04 30 80 00       	mov    0x803004,%eax
  8016d7:	ff 75 0c             	pushl  0xc(%ebp)
  8016da:	ff 75 08             	pushl  0x8(%ebp)
  8016dd:	50                   	push   %eax
  8016de:	68 dd 1f 80 00       	push   $0x801fdd
  8016e3:	e8 85 eb ff ff       	call   80026d <cprintf>
  8016e8:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ee:	83 ec 08             	sub    $0x8,%esp
  8016f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f4:	50                   	push   %eax
  8016f5:	e8 08 eb ff ff       	call   800202 <vcprintf>
  8016fa:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	6a 00                	push   $0x0
  801702:	68 f9 1f 80 00       	push   $0x801ff9
  801707:	e8 f6 ea ff ff       	call   800202 <vcprintf>
  80170c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80170f:	e8 77 ea ff ff       	call   80018b <exit>

	// should not return here
	while (1) ;
  801714:	eb fe                	jmp    801714 <_panic+0x70>

00801716 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801716:	55                   	push   %ebp
  801717:	89 e5                	mov    %esp,%ebp
  801719:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80171c:	a1 08 30 80 00       	mov    0x803008,%eax
  801721:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801727:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172a:	39 c2                	cmp    %eax,%edx
  80172c:	74 14                	je     801742 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80172e:	83 ec 04             	sub    $0x4,%esp
  801731:	68 fc 1f 80 00       	push   $0x801ffc
  801736:	6a 26                	push   $0x26
  801738:	68 48 20 80 00       	push   $0x802048
  80173d:	e8 62 ff ff ff       	call   8016a4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801742:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801749:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801750:	e9 c5 00 00 00       	jmp    80181a <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801758:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175f:	8b 45 08             	mov    0x8(%ebp),%eax
  801762:	01 d0                	add    %edx,%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	85 c0                	test   %eax,%eax
  801768:	75 08                	jne    801772 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80176a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80176d:	e9 a5 00 00 00       	jmp    801817 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801772:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801779:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801780:	eb 69                	jmp    8017eb <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801782:	a1 08 30 80 00       	mov    0x803008,%eax
  801787:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80178d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801790:	89 d0                	mov    %edx,%eax
  801792:	01 c0                	add    %eax,%eax
  801794:	01 d0                	add    %edx,%eax
  801796:	c1 e0 03             	shl    $0x3,%eax
  801799:	01 c8                	add    %ecx,%eax
  80179b:	8a 40 04             	mov    0x4(%eax),%al
  80179e:	84 c0                	test   %al,%al
  8017a0:	75 46                	jne    8017e8 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017a2:	a1 08 30 80 00       	mov    0x803008,%eax
  8017a7:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8017ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017b0:	89 d0                	mov    %edx,%eax
  8017b2:	01 c0                	add    %eax,%eax
  8017b4:	01 d0                	add    %edx,%eax
  8017b6:	c1 e0 03             	shl    $0x3,%eax
  8017b9:	01 c8                	add    %ecx,%eax
  8017bb:	8b 00                	mov    (%eax),%eax
  8017bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	01 c8                	add    %ecx,%eax
  8017d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017db:	39 c2                	cmp    %eax,%edx
  8017dd:	75 09                	jne    8017e8 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017e6:	eb 15                	jmp    8017fd <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017e8:	ff 45 e8             	incl   -0x18(%ebp)
  8017eb:	a1 08 30 80 00       	mov    0x803008,%eax
  8017f0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8017f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f9:	39 c2                	cmp    %eax,%edx
  8017fb:	77 85                	ja     801782 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8017fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801801:	75 14                	jne    801817 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 54 20 80 00       	push   $0x802054
  80180b:	6a 3a                	push   $0x3a
  80180d:	68 48 20 80 00       	push   $0x802048
  801812:	e8 8d fe ff ff       	call   8016a4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801817:	ff 45 f0             	incl   -0x10(%ebp)
  80181a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801820:	0f 8c 2f ff ff ff    	jl     801755 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801826:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80182d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801834:	eb 26                	jmp    80185c <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801836:	a1 08 30 80 00       	mov    0x803008,%eax
  80183b:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801841:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801844:	89 d0                	mov    %edx,%eax
  801846:	01 c0                	add    %eax,%eax
  801848:	01 d0                	add    %edx,%eax
  80184a:	c1 e0 03             	shl    $0x3,%eax
  80184d:	01 c8                	add    %ecx,%eax
  80184f:	8a 40 04             	mov    0x4(%eax),%al
  801852:	3c 01                	cmp    $0x1,%al
  801854:	75 03                	jne    801859 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801856:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801859:	ff 45 e0             	incl   -0x20(%ebp)
  80185c:	a1 08 30 80 00       	mov    0x803008,%eax
  801861:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801867:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80186a:	39 c2                	cmp    %eax,%edx
  80186c:	77 c8                	ja     801836 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801871:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801874:	74 14                	je     80188a <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	68 a8 20 80 00       	push   $0x8020a8
  80187e:	6a 44                	push   $0x44
  801880:	68 48 20 80 00       	push   $0x802048
  801885:	e8 1a fe ff ff       	call   8016a4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80188a:	90                   	nop
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    
  80188d:	66 90                	xchg   %ax,%ax
  80188f:	90                   	nop

00801890 <__udivdi3>:
  801890:	55                   	push   %ebp
  801891:	57                   	push   %edi
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	83 ec 1c             	sub    $0x1c,%esp
  801897:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80189b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80189f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018a7:	89 ca                	mov    %ecx,%edx
  8018a9:	89 f8                	mov    %edi,%eax
  8018ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018af:	85 f6                	test   %esi,%esi
  8018b1:	75 2d                	jne    8018e0 <__udivdi3+0x50>
  8018b3:	39 cf                	cmp    %ecx,%edi
  8018b5:	77 65                	ja     80191c <__udivdi3+0x8c>
  8018b7:	89 fd                	mov    %edi,%ebp
  8018b9:	85 ff                	test   %edi,%edi
  8018bb:	75 0b                	jne    8018c8 <__udivdi3+0x38>
  8018bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8018c2:	31 d2                	xor    %edx,%edx
  8018c4:	f7 f7                	div    %edi
  8018c6:	89 c5                	mov    %eax,%ebp
  8018c8:	31 d2                	xor    %edx,%edx
  8018ca:	89 c8                	mov    %ecx,%eax
  8018cc:	f7 f5                	div    %ebp
  8018ce:	89 c1                	mov    %eax,%ecx
  8018d0:	89 d8                	mov    %ebx,%eax
  8018d2:	f7 f5                	div    %ebp
  8018d4:	89 cf                	mov    %ecx,%edi
  8018d6:	89 fa                	mov    %edi,%edx
  8018d8:	83 c4 1c             	add    $0x1c,%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5e                   	pop    %esi
  8018dd:	5f                   	pop    %edi
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    
  8018e0:	39 ce                	cmp    %ecx,%esi
  8018e2:	77 28                	ja     80190c <__udivdi3+0x7c>
  8018e4:	0f bd fe             	bsr    %esi,%edi
  8018e7:	83 f7 1f             	xor    $0x1f,%edi
  8018ea:	75 40                	jne    80192c <__udivdi3+0x9c>
  8018ec:	39 ce                	cmp    %ecx,%esi
  8018ee:	72 0a                	jb     8018fa <__udivdi3+0x6a>
  8018f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018f4:	0f 87 9e 00 00 00    	ja     801998 <__udivdi3+0x108>
  8018fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8018ff:	89 fa                	mov    %edi,%edx
  801901:	83 c4 1c             	add    $0x1c,%esp
  801904:	5b                   	pop    %ebx
  801905:	5e                   	pop    %esi
  801906:	5f                   	pop    %edi
  801907:	5d                   	pop    %ebp
  801908:	c3                   	ret    
  801909:	8d 76 00             	lea    0x0(%esi),%esi
  80190c:	31 ff                	xor    %edi,%edi
  80190e:	31 c0                	xor    %eax,%eax
  801910:	89 fa                	mov    %edi,%edx
  801912:	83 c4 1c             	add    $0x1c,%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5f                   	pop    %edi
  801918:	5d                   	pop    %ebp
  801919:	c3                   	ret    
  80191a:	66 90                	xchg   %ax,%ax
  80191c:	89 d8                	mov    %ebx,%eax
  80191e:	f7 f7                	div    %edi
  801920:	31 ff                	xor    %edi,%edi
  801922:	89 fa                	mov    %edi,%edx
  801924:	83 c4 1c             	add    $0x1c,%esp
  801927:	5b                   	pop    %ebx
  801928:	5e                   	pop    %esi
  801929:	5f                   	pop    %edi
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    
  80192c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801931:	89 eb                	mov    %ebp,%ebx
  801933:	29 fb                	sub    %edi,%ebx
  801935:	89 f9                	mov    %edi,%ecx
  801937:	d3 e6                	shl    %cl,%esi
  801939:	89 c5                	mov    %eax,%ebp
  80193b:	88 d9                	mov    %bl,%cl
  80193d:	d3 ed                	shr    %cl,%ebp
  80193f:	89 e9                	mov    %ebp,%ecx
  801941:	09 f1                	or     %esi,%ecx
  801943:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801947:	89 f9                	mov    %edi,%ecx
  801949:	d3 e0                	shl    %cl,%eax
  80194b:	89 c5                	mov    %eax,%ebp
  80194d:	89 d6                	mov    %edx,%esi
  80194f:	88 d9                	mov    %bl,%cl
  801951:	d3 ee                	shr    %cl,%esi
  801953:	89 f9                	mov    %edi,%ecx
  801955:	d3 e2                	shl    %cl,%edx
  801957:	8b 44 24 08          	mov    0x8(%esp),%eax
  80195b:	88 d9                	mov    %bl,%cl
  80195d:	d3 e8                	shr    %cl,%eax
  80195f:	09 c2                	or     %eax,%edx
  801961:	89 d0                	mov    %edx,%eax
  801963:	89 f2                	mov    %esi,%edx
  801965:	f7 74 24 0c          	divl   0xc(%esp)
  801969:	89 d6                	mov    %edx,%esi
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	f7 e5                	mul    %ebp
  80196f:	39 d6                	cmp    %edx,%esi
  801971:	72 19                	jb     80198c <__udivdi3+0xfc>
  801973:	74 0b                	je     801980 <__udivdi3+0xf0>
  801975:	89 d8                	mov    %ebx,%eax
  801977:	31 ff                	xor    %edi,%edi
  801979:	e9 58 ff ff ff       	jmp    8018d6 <__udivdi3+0x46>
  80197e:	66 90                	xchg   %ax,%ax
  801980:	8b 54 24 08          	mov    0x8(%esp),%edx
  801984:	89 f9                	mov    %edi,%ecx
  801986:	d3 e2                	shl    %cl,%edx
  801988:	39 c2                	cmp    %eax,%edx
  80198a:	73 e9                	jae    801975 <__udivdi3+0xe5>
  80198c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80198f:	31 ff                	xor    %edi,%edi
  801991:	e9 40 ff ff ff       	jmp    8018d6 <__udivdi3+0x46>
  801996:	66 90                	xchg   %ax,%ax
  801998:	31 c0                	xor    %eax,%eax
  80199a:	e9 37 ff ff ff       	jmp    8018d6 <__udivdi3+0x46>
  80199f:	90                   	nop

008019a0 <__umoddi3>:
  8019a0:	55                   	push   %ebp
  8019a1:	57                   	push   %edi
  8019a2:	56                   	push   %esi
  8019a3:	53                   	push   %ebx
  8019a4:	83 ec 1c             	sub    $0x1c,%esp
  8019a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019bf:	89 f3                	mov    %esi,%ebx
  8019c1:	89 fa                	mov    %edi,%edx
  8019c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c7:	89 34 24             	mov    %esi,(%esp)
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	75 1a                	jne    8019e8 <__umoddi3+0x48>
  8019ce:	39 f7                	cmp    %esi,%edi
  8019d0:	0f 86 a2 00 00 00    	jbe    801a78 <__umoddi3+0xd8>
  8019d6:	89 c8                	mov    %ecx,%eax
  8019d8:	89 f2                	mov    %esi,%edx
  8019da:	f7 f7                	div    %edi
  8019dc:	89 d0                	mov    %edx,%eax
  8019de:	31 d2                	xor    %edx,%edx
  8019e0:	83 c4 1c             	add    $0x1c,%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5f                   	pop    %edi
  8019e6:	5d                   	pop    %ebp
  8019e7:	c3                   	ret    
  8019e8:	39 f0                	cmp    %esi,%eax
  8019ea:	0f 87 ac 00 00 00    	ja     801a9c <__umoddi3+0xfc>
  8019f0:	0f bd e8             	bsr    %eax,%ebp
  8019f3:	83 f5 1f             	xor    $0x1f,%ebp
  8019f6:	0f 84 ac 00 00 00    	je     801aa8 <__umoddi3+0x108>
  8019fc:	bf 20 00 00 00       	mov    $0x20,%edi
  801a01:	29 ef                	sub    %ebp,%edi
  801a03:	89 fe                	mov    %edi,%esi
  801a05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a09:	89 e9                	mov    %ebp,%ecx
  801a0b:	d3 e0                	shl    %cl,%eax
  801a0d:	89 d7                	mov    %edx,%edi
  801a0f:	89 f1                	mov    %esi,%ecx
  801a11:	d3 ef                	shr    %cl,%edi
  801a13:	09 c7                	or     %eax,%edi
  801a15:	89 e9                	mov    %ebp,%ecx
  801a17:	d3 e2                	shl    %cl,%edx
  801a19:	89 14 24             	mov    %edx,(%esp)
  801a1c:	89 d8                	mov    %ebx,%eax
  801a1e:	d3 e0                	shl    %cl,%eax
  801a20:	89 c2                	mov    %eax,%edx
  801a22:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a26:	d3 e0                	shl    %cl,%eax
  801a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a30:	89 f1                	mov    %esi,%ecx
  801a32:	d3 e8                	shr    %cl,%eax
  801a34:	09 d0                	or     %edx,%eax
  801a36:	d3 eb                	shr    %cl,%ebx
  801a38:	89 da                	mov    %ebx,%edx
  801a3a:	f7 f7                	div    %edi
  801a3c:	89 d3                	mov    %edx,%ebx
  801a3e:	f7 24 24             	mull   (%esp)
  801a41:	89 c6                	mov    %eax,%esi
  801a43:	89 d1                	mov    %edx,%ecx
  801a45:	39 d3                	cmp    %edx,%ebx
  801a47:	0f 82 87 00 00 00    	jb     801ad4 <__umoddi3+0x134>
  801a4d:	0f 84 91 00 00 00    	je     801ae4 <__umoddi3+0x144>
  801a53:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a57:	29 f2                	sub    %esi,%edx
  801a59:	19 cb                	sbb    %ecx,%ebx
  801a5b:	89 d8                	mov    %ebx,%eax
  801a5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a61:	d3 e0                	shl    %cl,%eax
  801a63:	89 e9                	mov    %ebp,%ecx
  801a65:	d3 ea                	shr    %cl,%edx
  801a67:	09 d0                	or     %edx,%eax
  801a69:	89 e9                	mov    %ebp,%ecx
  801a6b:	d3 eb                	shr    %cl,%ebx
  801a6d:	89 da                	mov    %ebx,%edx
  801a6f:	83 c4 1c             	add    $0x1c,%esp
  801a72:	5b                   	pop    %ebx
  801a73:	5e                   	pop    %esi
  801a74:	5f                   	pop    %edi
  801a75:	5d                   	pop    %ebp
  801a76:	c3                   	ret    
  801a77:	90                   	nop
  801a78:	89 fd                	mov    %edi,%ebp
  801a7a:	85 ff                	test   %edi,%edi
  801a7c:	75 0b                	jne    801a89 <__umoddi3+0xe9>
  801a7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801a83:	31 d2                	xor    %edx,%edx
  801a85:	f7 f7                	div    %edi
  801a87:	89 c5                	mov    %eax,%ebp
  801a89:	89 f0                	mov    %esi,%eax
  801a8b:	31 d2                	xor    %edx,%edx
  801a8d:	f7 f5                	div    %ebp
  801a8f:	89 c8                	mov    %ecx,%eax
  801a91:	f7 f5                	div    %ebp
  801a93:	89 d0                	mov    %edx,%eax
  801a95:	e9 44 ff ff ff       	jmp    8019de <__umoddi3+0x3e>
  801a9a:	66 90                	xchg   %ax,%ax
  801a9c:	89 c8                	mov    %ecx,%eax
  801a9e:	89 f2                	mov    %esi,%edx
  801aa0:	83 c4 1c             	add    $0x1c,%esp
  801aa3:	5b                   	pop    %ebx
  801aa4:	5e                   	pop    %esi
  801aa5:	5f                   	pop    %edi
  801aa6:	5d                   	pop    %ebp
  801aa7:	c3                   	ret    
  801aa8:	3b 04 24             	cmp    (%esp),%eax
  801aab:	72 06                	jb     801ab3 <__umoddi3+0x113>
  801aad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ab1:	77 0f                	ja     801ac2 <__umoddi3+0x122>
  801ab3:	89 f2                	mov    %esi,%edx
  801ab5:	29 f9                	sub    %edi,%ecx
  801ab7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801abb:	89 14 24             	mov    %edx,(%esp)
  801abe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ac6:	8b 14 24             	mov    (%esp),%edx
  801ac9:	83 c4 1c             	add    $0x1c,%esp
  801acc:	5b                   	pop    %ebx
  801acd:	5e                   	pop    %esi
  801ace:	5f                   	pop    %edi
  801acf:	5d                   	pop    %ebp
  801ad0:	c3                   	ret    
  801ad1:	8d 76 00             	lea    0x0(%esi),%esi
  801ad4:	2b 04 24             	sub    (%esp),%eax
  801ad7:	19 fa                	sbb    %edi,%edx
  801ad9:	89 d1                	mov    %edx,%ecx
  801adb:	89 c6                	mov    %eax,%esi
  801add:	e9 71 ff ff ff       	jmp    801a53 <__umoddi3+0xb3>
  801ae2:	66 90                	xchg   %ax,%ax
  801ae4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ae8:	72 ea                	jb     801ad4 <__umoddi3+0x134>
  801aea:	89 d9                	mov    %ebx,%ecx
  801aec:	e9 62 ff ff ff       	jmp    801a53 <__umoddi3+0xb3>
