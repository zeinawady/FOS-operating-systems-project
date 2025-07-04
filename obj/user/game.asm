
obj/user/game:     file format elf32-i386


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
  800031:	e8 79 00 00 00       	call   8000af <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
	
void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int i=28;
  80003e:	c7 45 f4 1c 00 00 00 	movl   $0x1c,-0xc(%ebp)
	for(;i<128; i++)
  800045:	eb 5f                	jmp    8000a6 <_main+0x6e>
	{
		int c=0;
  800047:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  80004e:	eb 16                	jmp    800066 <_main+0x2e>
		{
			cprintf("%c",i);
  800050:	83 ec 08             	sub    $0x8,%esp
  800053:	ff 75 f4             	pushl  -0xc(%ebp)
  800056:	68 60 1b 80 00       	push   $0x801b60
  80005b:	e8 68 02 00 00       	call   8002c8 <cprintf>
  800060:	83 c4 10             	add    $0x10,%esp
{	
	int i=28;
	for(;i<128; i++)
	{
		int c=0;
		for(;c<10; c++)
  800063:	ff 45 f0             	incl   -0x10(%ebp)
  800066:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  80006a:	7e e4                	jle    800050 <_main+0x18>
		{
			cprintf("%c",i);
		}
		int d=0;
  80006c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(; d< 500000; d++);	
  800073:	eb 03                	jmp    800078 <_main+0x40>
  800075:	ff 45 ec             	incl   -0x14(%ebp)
  800078:	81 7d ec 1f a1 07 00 	cmpl   $0x7a11f,-0x14(%ebp)
  80007f:	7e f4                	jle    800075 <_main+0x3d>
		c=0;
  800081:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for(;c<10; c++)
  800088:	eb 13                	jmp    80009d <_main+0x65>
		{
			cprintf("\b");
  80008a:	83 ec 0c             	sub    $0xc,%esp
  80008d:	68 63 1b 80 00       	push   $0x801b63
  800092:	e8 31 02 00 00       	call   8002c8 <cprintf>
  800097:	83 c4 10             	add    $0x10,%esp
			cprintf("%c",i);
		}
		int d=0;
		for(; d< 500000; d++);	
		c=0;
		for(;c<10; c++)
  80009a:	ff 45 f0             	incl   -0x10(%ebp)
  80009d:	83 7d f0 09          	cmpl   $0x9,-0x10(%ebp)
  8000a1:	7e e7                	jle    80008a <_main+0x52>
	
void
_main(void)
{	
	int i=28;
	for(;i<128; i++)
  8000a3:	ff 45 f4             	incl   -0xc(%ebp)
  8000a6:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
  8000aa:	7e 9b                	jle    800047 <_main+0xf>
		{
			cprintf("\b");
		}		
	}
	
	return;	
  8000ac:	90                   	nop
}
  8000ad:	c9                   	leave  
  8000ae:	c3                   	ret    

008000af <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000af:	55                   	push   %ebp
  8000b0:	89 e5                	mov    %esp,%ebp
  8000b2:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000b5:	e8 91 12 00 00       	call   80134b <sys_getenvindex>
  8000ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c0:	89 d0                	mov    %edx,%eax
  8000c2:	c1 e0 02             	shl    $0x2,%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	c1 e0 03             	shl    $0x3,%eax
  8000ca:	01 d0                	add    %edx,%eax
  8000cc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000d3:	01 d0                	add    %edx,%eax
  8000d5:	c1 e0 02             	shl    $0x2,%eax
  8000d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000dd:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000e2:	a1 08 30 80 00       	mov    0x803008,%eax
  8000e7:	8a 40 20             	mov    0x20(%eax),%al
  8000ea:	84 c0                	test   %al,%al
  8000ec:	74 0d                	je     8000fb <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000ee:	a1 08 30 80 00       	mov    0x803008,%eax
  8000f3:	83 c0 20             	add    $0x20,%eax
  8000f6:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000ff:	7e 0a                	jle    80010b <libmain+0x5c>
		binaryname = argv[0];
  800101:	8b 45 0c             	mov    0xc(%ebp),%eax
  800104:	8b 00                	mov    (%eax),%eax
  800106:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80010b:	83 ec 08             	sub    $0x8,%esp
  80010e:	ff 75 0c             	pushl  0xc(%ebp)
  800111:	ff 75 08             	pushl  0x8(%ebp)
  800114:	e8 1f ff ff ff       	call   800038 <_main>
  800119:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80011c:	a1 00 30 80 00       	mov    0x803000,%eax
  800121:	85 c0                	test   %eax,%eax
  800123:	0f 84 9f 00 00 00    	je     8001c8 <libmain+0x119>
	{
		sys_lock_cons();
  800129:	e8 a1 0f 00 00       	call   8010cf <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80012e:	83 ec 0c             	sub    $0xc,%esp
  800131:	68 80 1b 80 00       	push   $0x801b80
  800136:	e8 8d 01 00 00       	call   8002c8 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80013e:	a1 08 30 80 00       	mov    0x803008,%eax
  800143:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800149:	a1 08 30 80 00       	mov    0x803008,%eax
  80014e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800154:	83 ec 04             	sub    $0x4,%esp
  800157:	52                   	push   %edx
  800158:	50                   	push   %eax
  800159:	68 a8 1b 80 00       	push   $0x801ba8
  80015e:	e8 65 01 00 00       	call   8002c8 <cprintf>
  800163:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800166:	a1 08 30 80 00       	mov    0x803008,%eax
  80016b:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800171:	a1 08 30 80 00       	mov    0x803008,%eax
  800176:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80017c:	a1 08 30 80 00       	mov    0x803008,%eax
  800181:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800187:	51                   	push   %ecx
  800188:	52                   	push   %edx
  800189:	50                   	push   %eax
  80018a:	68 d0 1b 80 00       	push   $0x801bd0
  80018f:	e8 34 01 00 00       	call   8002c8 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800197:	a1 08 30 80 00       	mov    0x803008,%eax
  80019c:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	50                   	push   %eax
  8001a6:	68 28 1c 80 00       	push   $0x801c28
  8001ab:	e8 18 01 00 00       	call   8002c8 <cprintf>
  8001b0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	68 80 1b 80 00       	push   $0x801b80
  8001bb:	e8 08 01 00 00       	call   8002c8 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001c3:	e8 21 0f 00 00       	call   8010e9 <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001c8:	e8 19 00 00 00       	call   8001e6 <exit>
}
  8001cd:	90                   	nop
  8001ce:	c9                   	leave  
  8001cf:	c3                   	ret    

008001d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	6a 00                	push   $0x0
  8001db:	e8 37 11 00 00       	call   801317 <sys_destroy_env>
  8001e0:	83 c4 10             	add    $0x10,%esp
}
  8001e3:	90                   	nop
  8001e4:	c9                   	leave  
  8001e5:	c3                   	ret    

008001e6 <exit>:

void
exit(void)
{
  8001e6:	55                   	push   %ebp
  8001e7:	89 e5                	mov    %esp,%ebp
  8001e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001ec:	e8 8c 11 00 00       	call   80137d <sys_exit_env>
}
  8001f1:	90                   	nop
  8001f2:	c9                   	leave  
  8001f3:	c3                   	ret    

008001f4 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001f4:	55                   	push   %ebp
  8001f5:	89 e5                	mov    %esp,%ebp
  8001f7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001fd:	8b 00                	mov    (%eax),%eax
  8001ff:	8d 48 01             	lea    0x1(%eax),%ecx
  800202:	8b 55 0c             	mov    0xc(%ebp),%edx
  800205:	89 0a                	mov    %ecx,(%edx)
  800207:	8b 55 08             	mov    0x8(%ebp),%edx
  80020a:	88 d1                	mov    %dl,%cl
  80020c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80020f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800213:	8b 45 0c             	mov    0xc(%ebp),%eax
  800216:	8b 00                	mov    (%eax),%eax
  800218:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021d:	75 2c                	jne    80024b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80021f:	a0 0c 30 80 00       	mov    0x80300c,%al
  800224:	0f b6 c0             	movzbl %al,%eax
  800227:	8b 55 0c             	mov    0xc(%ebp),%edx
  80022a:	8b 12                	mov    (%edx),%edx
  80022c:	89 d1                	mov    %edx,%ecx
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800231:	83 c2 08             	add    $0x8,%edx
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	50                   	push   %eax
  800238:	51                   	push   %ecx
  800239:	52                   	push   %edx
  80023a:	e8 4e 0e 00 00       	call   80108d <sys_cputs>
  80023f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800242:	8b 45 0c             	mov    0xc(%ebp),%eax
  800245:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80024b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024e:	8b 40 04             	mov    0x4(%eax),%eax
  800251:	8d 50 01             	lea    0x1(%eax),%edx
  800254:	8b 45 0c             	mov    0xc(%ebp),%eax
  800257:	89 50 04             	mov    %edx,0x4(%eax)
}
  80025a:	90                   	nop
  80025b:	c9                   	leave  
  80025c:	c3                   	ret    

0080025d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80025d:	55                   	push   %ebp
  80025e:	89 e5                	mov    %esp,%ebp
  800260:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800266:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80026d:	00 00 00 
	b.cnt = 0;
  800270:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800277:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80027a:	ff 75 0c             	pushl  0xc(%ebp)
  80027d:	ff 75 08             	pushl  0x8(%ebp)
  800280:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800286:	50                   	push   %eax
  800287:	68 f4 01 80 00       	push   $0x8001f4
  80028c:	e8 11 02 00 00       	call   8004a2 <vprintfmt>
  800291:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800294:	a0 0c 30 80 00       	mov    0x80300c,%al
  800299:	0f b6 c0             	movzbl %al,%eax
  80029c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002a2:	83 ec 04             	sub    $0x4,%esp
  8002a5:	50                   	push   %eax
  8002a6:	52                   	push   %edx
  8002a7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ad:	83 c0 08             	add    $0x8,%eax
  8002b0:	50                   	push   %eax
  8002b1:	e8 d7 0d 00 00       	call   80108d <sys_cputs>
  8002b6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002b9:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8002c0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002c6:	c9                   	leave  
  8002c7:	c3                   	ret    

008002c8 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002c8:	55                   	push   %ebp
  8002c9:	89 e5                	mov    %esp,%ebp
  8002cb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002ce:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8002d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002db:	8b 45 08             	mov    0x8(%ebp),%eax
  8002de:	83 ec 08             	sub    $0x8,%esp
  8002e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e4:	50                   	push   %eax
  8002e5:	e8 73 ff ff ff       	call   80025d <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002f3:	c9                   	leave  
  8002f4:	c3                   	ret    

008002f5 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002f5:	55                   	push   %ebp
  8002f6:	89 e5                	mov    %esp,%ebp
  8002f8:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002fb:	e8 cf 0d 00 00       	call   8010cf <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800300:	8d 45 0c             	lea    0xc(%ebp),%eax
  800303:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800306:	8b 45 08             	mov    0x8(%ebp),%eax
  800309:	83 ec 08             	sub    $0x8,%esp
  80030c:	ff 75 f4             	pushl  -0xc(%ebp)
  80030f:	50                   	push   %eax
  800310:	e8 48 ff ff ff       	call   80025d <vcprintf>
  800315:	83 c4 10             	add    $0x10,%esp
  800318:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80031b:	e8 c9 0d 00 00       	call   8010e9 <sys_unlock_cons>
	return cnt;
  800320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	53                   	push   %ebx
  800329:	83 ec 14             	sub    $0x14,%esp
  80032c:	8b 45 10             	mov    0x10(%ebp),%eax
  80032f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800332:	8b 45 14             	mov    0x14(%ebp),%eax
  800335:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800338:	8b 45 18             	mov    0x18(%ebp),%eax
  80033b:	ba 00 00 00 00       	mov    $0x0,%edx
  800340:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800343:	77 55                	ja     80039a <printnum+0x75>
  800345:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800348:	72 05                	jb     80034f <printnum+0x2a>
  80034a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80034d:	77 4b                	ja     80039a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80034f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800352:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800355:	8b 45 18             	mov    0x18(%ebp),%eax
  800358:	ba 00 00 00 00       	mov    $0x0,%edx
  80035d:	52                   	push   %edx
  80035e:	50                   	push   %eax
  80035f:	ff 75 f4             	pushl  -0xc(%ebp)
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	e8 7e 15 00 00       	call   8018e8 <__udivdi3>
  80036a:	83 c4 10             	add    $0x10,%esp
  80036d:	83 ec 04             	sub    $0x4,%esp
  800370:	ff 75 20             	pushl  0x20(%ebp)
  800373:	53                   	push   %ebx
  800374:	ff 75 18             	pushl  0x18(%ebp)
  800377:	52                   	push   %edx
  800378:	50                   	push   %eax
  800379:	ff 75 0c             	pushl  0xc(%ebp)
  80037c:	ff 75 08             	pushl  0x8(%ebp)
  80037f:	e8 a1 ff ff ff       	call   800325 <printnum>
  800384:	83 c4 20             	add    $0x20,%esp
  800387:	eb 1a                	jmp    8003a3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800389:	83 ec 08             	sub    $0x8,%esp
  80038c:	ff 75 0c             	pushl  0xc(%ebp)
  80038f:	ff 75 20             	pushl  0x20(%ebp)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	ff d0                	call   *%eax
  800397:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039a:	ff 4d 1c             	decl   0x1c(%ebp)
  80039d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003a1:	7f e6                	jg     800389 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003b1:	53                   	push   %ebx
  8003b2:	51                   	push   %ecx
  8003b3:	52                   	push   %edx
  8003b4:	50                   	push   %eax
  8003b5:	e8 3e 16 00 00       	call   8019f8 <__umoddi3>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	05 54 1e 80 00       	add    $0x801e54,%eax
  8003c2:	8a 00                	mov    (%eax),%al
  8003c4:	0f be c0             	movsbl %al,%eax
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	ff 75 0c             	pushl  0xc(%ebp)
  8003cd:	50                   	push   %eax
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	ff d0                	call   *%eax
  8003d3:	83 c4 10             	add    $0x10,%esp
}
  8003d6:	90                   	nop
  8003d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003da:	c9                   	leave  
  8003db:	c3                   	ret    

008003dc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003e3:	7e 1c                	jle    800401 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e8:	8b 00                	mov    (%eax),%eax
  8003ea:	8d 50 08             	lea    0x8(%eax),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	89 10                	mov    %edx,(%eax)
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	8b 00                	mov    (%eax),%eax
  8003f7:	83 e8 08             	sub    $0x8,%eax
  8003fa:	8b 50 04             	mov    0x4(%eax),%edx
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	eb 40                	jmp    800441 <getuint+0x65>
	else if (lflag)
  800401:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800405:	74 1e                	je     800425 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800407:	8b 45 08             	mov    0x8(%ebp),%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	8d 50 04             	lea    0x4(%eax),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	89 10                	mov    %edx,(%eax)
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	8b 00                	mov    (%eax),%eax
  800419:	83 e8 04             	sub    $0x4,%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	ba 00 00 00 00       	mov    $0x0,%edx
  800423:	eb 1c                	jmp    800441 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800425:	8b 45 08             	mov    0x8(%ebp),%eax
  800428:	8b 00                	mov    (%eax),%eax
  80042a:	8d 50 04             	lea    0x4(%eax),%edx
  80042d:	8b 45 08             	mov    0x8(%ebp),%eax
  800430:	89 10                	mov    %edx,(%eax)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	8b 00                	mov    (%eax),%eax
  800437:	83 e8 04             	sub    $0x4,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800441:	5d                   	pop    %ebp
  800442:	c3                   	ret    

00800443 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800446:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80044a:	7e 1c                	jle    800468 <getint+0x25>
		return va_arg(*ap, long long);
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	8b 00                	mov    (%eax),%eax
  800451:	8d 50 08             	lea    0x8(%eax),%edx
  800454:	8b 45 08             	mov    0x8(%ebp),%eax
  800457:	89 10                	mov    %edx,(%eax)
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	8b 00                	mov    (%eax),%eax
  80045e:	83 e8 08             	sub    $0x8,%eax
  800461:	8b 50 04             	mov    0x4(%eax),%edx
  800464:	8b 00                	mov    (%eax),%eax
  800466:	eb 38                	jmp    8004a0 <getint+0x5d>
	else if (lflag)
  800468:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80046c:	74 1a                	je     800488 <getint+0x45>
		return va_arg(*ap, long);
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	8b 00                	mov    (%eax),%eax
  800473:	8d 50 04             	lea    0x4(%eax),%edx
  800476:	8b 45 08             	mov    0x8(%ebp),%eax
  800479:	89 10                	mov    %edx,(%eax)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	83 e8 04             	sub    $0x4,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	99                   	cltd   
  800486:	eb 18                	jmp    8004a0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	8b 00                	mov    (%eax),%eax
  80048d:	8d 50 04             	lea    0x4(%eax),%edx
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	89 10                	mov    %edx,(%eax)
  800495:	8b 45 08             	mov    0x8(%ebp),%eax
  800498:	8b 00                	mov    (%eax),%eax
  80049a:	83 e8 04             	sub    $0x4,%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	99                   	cltd   
}
  8004a0:	5d                   	pop    %ebp
  8004a1:	c3                   	ret    

008004a2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004a2:	55                   	push   %ebp
  8004a3:	89 e5                	mov    %esp,%ebp
  8004a5:	56                   	push   %esi
  8004a6:	53                   	push   %ebx
  8004a7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004aa:	eb 17                	jmp    8004c3 <vprintfmt+0x21>
			if (ch == '\0')
  8004ac:	85 db                	test   %ebx,%ebx
  8004ae:	0f 84 c1 03 00 00    	je     800875 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	ff 75 0c             	pushl  0xc(%ebp)
  8004ba:	53                   	push   %ebx
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	ff d0                	call   *%eax
  8004c0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c6:	8d 50 01             	lea    0x1(%eax),%edx
  8004c9:	89 55 10             	mov    %edx,0x10(%ebp)
  8004cc:	8a 00                	mov    (%eax),%al
  8004ce:	0f b6 d8             	movzbl %al,%ebx
  8004d1:	83 fb 25             	cmp    $0x25,%ebx
  8004d4:	75 d6                	jne    8004ac <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004d6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004da:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004e1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004ef:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f9:	8d 50 01             	lea    0x1(%eax),%edx
  8004fc:	89 55 10             	mov    %edx,0x10(%ebp)
  8004ff:	8a 00                	mov    (%eax),%al
  800501:	0f b6 d8             	movzbl %al,%ebx
  800504:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800507:	83 f8 5b             	cmp    $0x5b,%eax
  80050a:	0f 87 3d 03 00 00    	ja     80084d <vprintfmt+0x3ab>
  800510:	8b 04 85 78 1e 80 00 	mov    0x801e78(,%eax,4),%eax
  800517:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800519:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80051d:	eb d7                	jmp    8004f6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80051f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800523:	eb d1                	jmp    8004f6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800525:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80052c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052f:	89 d0                	mov    %edx,%eax
  800531:	c1 e0 02             	shl    $0x2,%eax
  800534:	01 d0                	add    %edx,%eax
  800536:	01 c0                	add    %eax,%eax
  800538:	01 d8                	add    %ebx,%eax
  80053a:	83 e8 30             	sub    $0x30,%eax
  80053d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800540:	8b 45 10             	mov    0x10(%ebp),%eax
  800543:	8a 00                	mov    (%eax),%al
  800545:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800548:	83 fb 2f             	cmp    $0x2f,%ebx
  80054b:	7e 3e                	jle    80058b <vprintfmt+0xe9>
  80054d:	83 fb 39             	cmp    $0x39,%ebx
  800550:	7f 39                	jg     80058b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800552:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800555:	eb d5                	jmp    80052c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	83 c0 04             	add    $0x4,%eax
  80055d:	89 45 14             	mov    %eax,0x14(%ebp)
  800560:	8b 45 14             	mov    0x14(%ebp),%eax
  800563:	83 e8 04             	sub    $0x4,%eax
  800566:	8b 00                	mov    (%eax),%eax
  800568:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80056b:	eb 1f                	jmp    80058c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80056d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800571:	79 83                	jns    8004f6 <vprintfmt+0x54>
				width = 0;
  800573:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80057a:	e9 77 ff ff ff       	jmp    8004f6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80057f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800586:	e9 6b ff ff ff       	jmp    8004f6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80058b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80058c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800590:	0f 89 60 ff ff ff    	jns    8004f6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005a3:	e9 4e ff ff ff       	jmp    8004f6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005a8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005ab:	e9 46 ff ff ff       	jmp    8004f6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	83 c0 04             	add    $0x4,%eax
  8005b6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bc:	83 e8 04             	sub    $0x4,%eax
  8005bf:	8b 00                	mov    (%eax),%eax
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	ff 75 0c             	pushl  0xc(%ebp)
  8005c7:	50                   	push   %eax
  8005c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005cb:	ff d0                	call   *%eax
  8005cd:	83 c4 10             	add    $0x10,%esp
			break;
  8005d0:	e9 9b 02 00 00       	jmp    800870 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	83 c0 04             	add    $0x4,%eax
  8005db:	89 45 14             	mov    %eax,0x14(%ebp)
  8005de:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e1:	83 e8 04             	sub    $0x4,%eax
  8005e4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005e6:	85 db                	test   %ebx,%ebx
  8005e8:	79 02                	jns    8005ec <vprintfmt+0x14a>
				err = -err;
  8005ea:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005ec:	83 fb 64             	cmp    $0x64,%ebx
  8005ef:	7f 0b                	jg     8005fc <vprintfmt+0x15a>
  8005f1:	8b 34 9d c0 1c 80 00 	mov    0x801cc0(,%ebx,4),%esi
  8005f8:	85 f6                	test   %esi,%esi
  8005fa:	75 19                	jne    800615 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005fc:	53                   	push   %ebx
  8005fd:	68 65 1e 80 00       	push   $0x801e65
  800602:	ff 75 0c             	pushl  0xc(%ebp)
  800605:	ff 75 08             	pushl  0x8(%ebp)
  800608:	e8 70 02 00 00       	call   80087d <printfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800610:	e9 5b 02 00 00       	jmp    800870 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800615:	56                   	push   %esi
  800616:	68 6e 1e 80 00       	push   $0x801e6e
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 57 02 00 00       	call   80087d <printfmt>
  800626:	83 c4 10             	add    $0x10,%esp
			break;
  800629:	e9 42 02 00 00       	jmp    800870 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	83 c0 04             	add    $0x4,%eax
  800634:	89 45 14             	mov    %eax,0x14(%ebp)
  800637:	8b 45 14             	mov    0x14(%ebp),%eax
  80063a:	83 e8 04             	sub    $0x4,%eax
  80063d:	8b 30                	mov    (%eax),%esi
  80063f:	85 f6                	test   %esi,%esi
  800641:	75 05                	jne    800648 <vprintfmt+0x1a6>
				p = "(null)";
  800643:	be 71 1e 80 00       	mov    $0x801e71,%esi
			if (width > 0 && padc != '-')
  800648:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80064c:	7e 6d                	jle    8006bb <vprintfmt+0x219>
  80064e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800652:	74 67                	je     8006bb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	50                   	push   %eax
  80065b:	56                   	push   %esi
  80065c:	e8 1e 03 00 00       	call   80097f <strnlen>
  800661:	83 c4 10             	add    $0x10,%esp
  800664:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800667:	eb 16                	jmp    80067f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800669:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 0c             	pushl  0xc(%ebp)
  800673:	50                   	push   %eax
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	ff d0                	call   *%eax
  800679:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80067c:	ff 4d e4             	decl   -0x1c(%ebp)
  80067f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800683:	7f e4                	jg     800669 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800685:	eb 34                	jmp    8006bb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800687:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80068b:	74 1c                	je     8006a9 <vprintfmt+0x207>
  80068d:	83 fb 1f             	cmp    $0x1f,%ebx
  800690:	7e 05                	jle    800697 <vprintfmt+0x1f5>
  800692:	83 fb 7e             	cmp    $0x7e,%ebx
  800695:	7e 12                	jle    8006a9 <vprintfmt+0x207>
					putch('?', putdat);
  800697:	83 ec 08             	sub    $0x8,%esp
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	6a 3f                	push   $0x3f
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	ff d0                	call   *%eax
  8006a4:	83 c4 10             	add    $0x10,%esp
  8006a7:	eb 0f                	jmp    8006b8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006a9:	83 ec 08             	sub    $0x8,%esp
  8006ac:	ff 75 0c             	pushl  0xc(%ebp)
  8006af:	53                   	push   %ebx
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	ff d0                	call   *%eax
  8006b5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006bb:	89 f0                	mov    %esi,%eax
  8006bd:	8d 70 01             	lea    0x1(%eax),%esi
  8006c0:	8a 00                	mov    (%eax),%al
  8006c2:	0f be d8             	movsbl %al,%ebx
  8006c5:	85 db                	test   %ebx,%ebx
  8006c7:	74 24                	je     8006ed <vprintfmt+0x24b>
  8006c9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006cd:	78 b8                	js     800687 <vprintfmt+0x1e5>
  8006cf:	ff 4d e0             	decl   -0x20(%ebp)
  8006d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d6:	79 af                	jns    800687 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d8:	eb 13                	jmp    8006ed <vprintfmt+0x24b>
				putch(' ', putdat);
  8006da:	83 ec 08             	sub    $0x8,%esp
  8006dd:	ff 75 0c             	pushl  0xc(%ebp)
  8006e0:	6a 20                	push   $0x20
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	ff d0                	call   *%eax
  8006e7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006f1:	7f e7                	jg     8006da <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006f3:	e9 78 01 00 00       	jmp    800870 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	ff 75 e8             	pushl  -0x18(%ebp)
  8006fe:	8d 45 14             	lea    0x14(%ebp),%eax
  800701:	50                   	push   %eax
  800702:	e8 3c fd ff ff       	call   800443 <getint>
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80070d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800713:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800716:	85 d2                	test   %edx,%edx
  800718:	79 23                	jns    80073d <vprintfmt+0x29b>
				putch('-', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	ff 75 0c             	pushl  0xc(%ebp)
  800720:	6a 2d                	push   $0x2d
  800722:	8b 45 08             	mov    0x8(%ebp),%eax
  800725:	ff d0                	call   *%eax
  800727:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80072a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800730:	f7 d8                	neg    %eax
  800732:	83 d2 00             	adc    $0x0,%edx
  800735:	f7 da                	neg    %edx
  800737:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80073a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80073d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800744:	e9 bc 00 00 00       	jmp    800805 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	ff 75 e8             	pushl  -0x18(%ebp)
  80074f:	8d 45 14             	lea    0x14(%ebp),%eax
  800752:	50                   	push   %eax
  800753:	e8 84 fc ff ff       	call   8003dc <getuint>
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80075e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800761:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800768:	e9 98 00 00 00       	jmp    800805 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80076d:	83 ec 08             	sub    $0x8,%esp
  800770:	ff 75 0c             	pushl  0xc(%ebp)
  800773:	6a 58                	push   $0x58
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 0c             	pushl  0xc(%ebp)
  800783:	6a 58                	push   $0x58
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	ff d0                	call   *%eax
  80078a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 58                	push   $0x58
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			break;
  80079d:	e9 ce 00 00 00       	jmp    800870 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007a2:	83 ec 08             	sub    $0x8,%esp
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	6a 30                	push   $0x30
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	ff d0                	call   *%eax
  8007af:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 0c             	pushl  0xc(%ebp)
  8007b8:	6a 78                	push   $0x78
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	ff d0                	call   *%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007e4:	eb 1f                	jmp    800805 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8007ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ef:	50                   	push   %eax
  8007f0:	e8 e7 fb ff ff       	call   8003dc <getuint>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007fe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800805:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800809:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	52                   	push   %edx
  800810:	ff 75 e4             	pushl  -0x1c(%ebp)
  800813:	50                   	push   %eax
  800814:	ff 75 f4             	pushl  -0xc(%ebp)
  800817:	ff 75 f0             	pushl  -0x10(%ebp)
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 00 fb ff ff       	call   800325 <printnum>
  800825:	83 c4 20             	add    $0x20,%esp
			break;
  800828:	eb 46                	jmp    800870 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	53                   	push   %ebx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
			break;
  800839:	eb 35                	jmp    800870 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80083b:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800842:	eb 2c                	jmp    800870 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800844:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  80084b:	eb 23                	jmp    800870 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80084d:	83 ec 08             	sub    $0x8,%esp
  800850:	ff 75 0c             	pushl  0xc(%ebp)
  800853:	6a 25                	push   $0x25
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	ff d0                	call   *%eax
  80085a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80085d:	ff 4d 10             	decl   0x10(%ebp)
  800860:	eb 03                	jmp    800865 <vprintfmt+0x3c3>
  800862:	ff 4d 10             	decl   0x10(%ebp)
  800865:	8b 45 10             	mov    0x10(%ebp),%eax
  800868:	48                   	dec    %eax
  800869:	8a 00                	mov    (%eax),%al
  80086b:	3c 25                	cmp    $0x25,%al
  80086d:	75 f3                	jne    800862 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80086f:	90                   	nop
		}
	}
  800870:	e9 35 fc ff ff       	jmp    8004aa <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800875:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800876:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800879:	5b                   	pop    %ebx
  80087a:	5e                   	pop    %esi
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800883:	8d 45 10             	lea    0x10(%ebp),%eax
  800886:	83 c0 04             	add    $0x4,%eax
  800889:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80088c:	8b 45 10             	mov    0x10(%ebp),%eax
  80088f:	ff 75 f4             	pushl  -0xc(%ebp)
  800892:	50                   	push   %eax
  800893:	ff 75 0c             	pushl  0xc(%ebp)
  800896:	ff 75 08             	pushl  0x8(%ebp)
  800899:	e8 04 fc ff ff       	call   8004a2 <vprintfmt>
  80089e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008a1:	90                   	nop
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    

008008a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008aa:	8b 40 08             	mov    0x8(%eax),%eax
  8008ad:	8d 50 01             	lea    0x1(%eax),%edx
  8008b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b9:	8b 10                	mov    (%eax),%edx
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008be:	8b 40 04             	mov    0x4(%eax),%eax
  8008c1:	39 c2                	cmp    %eax,%edx
  8008c3:	73 12                	jae    8008d7 <sprintputch+0x33>
		*b->buf++ = ch;
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	89 0a                	mov    %ecx,(%edx)
  8008d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d5:	88 10                	mov    %dl,(%eax)
}
  8008d7:	90                   	nop
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ff:	74 06                	je     800907 <vsnprintf+0x2d>
  800901:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800905:	7f 07                	jg     80090e <vsnprintf+0x34>
		return -E_INVAL;
  800907:	b8 03 00 00 00       	mov    $0x3,%eax
  80090c:	eb 20                	jmp    80092e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090e:	ff 75 14             	pushl  0x14(%ebp)
  800911:	ff 75 10             	pushl  0x10(%ebp)
  800914:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800917:	50                   	push   %eax
  800918:	68 a4 08 80 00       	push   $0x8008a4
  80091d:	e8 80 fb ff ff       	call   8004a2 <vprintfmt>
  800922:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800928:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80092e:	c9                   	leave  
  80092f:	c3                   	ret    

00800930 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800936:	8d 45 10             	lea    0x10(%ebp),%eax
  800939:	83 c0 04             	add    $0x4,%eax
  80093c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80093f:	8b 45 10             	mov    0x10(%ebp),%eax
  800942:	ff 75 f4             	pushl  -0xc(%ebp)
  800945:	50                   	push   %eax
  800946:	ff 75 0c             	pushl  0xc(%ebp)
  800949:	ff 75 08             	pushl  0x8(%ebp)
  80094c:	e8 89 ff ff ff       	call   8008da <vsnprintf>
  800951:	83 c4 10             	add    $0x10,%esp
  800954:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800962:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800969:	eb 06                	jmp    800971 <strlen+0x15>
		n++;
  80096b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80096e:	ff 45 08             	incl   0x8(%ebp)
  800971:	8b 45 08             	mov    0x8(%ebp),%eax
  800974:	8a 00                	mov    (%eax),%al
  800976:	84 c0                	test   %al,%al
  800978:	75 f1                	jne    80096b <strlen+0xf>
		n++;
	return n;
  80097a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80097d:	c9                   	leave  
  80097e:	c3                   	ret    

0080097f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800985:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80098c:	eb 09                	jmp    800997 <strnlen+0x18>
		n++;
  80098e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800991:	ff 45 08             	incl   0x8(%ebp)
  800994:	ff 4d 0c             	decl   0xc(%ebp)
  800997:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80099b:	74 09                	je     8009a6 <strnlen+0x27>
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	8a 00                	mov    (%eax),%al
  8009a2:	84 c0                	test   %al,%al
  8009a4:	75 e8                	jne    80098e <strnlen+0xf>
		n++;
	return n;
  8009a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009a9:	c9                   	leave  
  8009aa:	c3                   	ret    

008009ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009b7:	90                   	nop
  8009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 08             	mov    %edx,0x8(%ebp)
  8009c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009c7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009ca:	8a 12                	mov    (%edx),%dl
  8009cc:	88 10                	mov    %dl,(%eax)
  8009ce:	8a 00                	mov    (%eax),%al
  8009d0:	84 c0                	test   %al,%al
  8009d2:	75 e4                	jne    8009b8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009d7:	c9                   	leave  
  8009d8:	c3                   	ret    

008009d9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009ec:	eb 1f                	jmp    800a0d <strncpy+0x34>
		*dst++ = *src;
  8009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f1:	8d 50 01             	lea    0x1(%eax),%edx
  8009f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8009f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fa:	8a 12                	mov    (%edx),%dl
  8009fc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a01:	8a 00                	mov    (%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	74 03                	je     800a0a <strncpy+0x31>
			src++;
  800a07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a0a:	ff 45 fc             	incl   -0x4(%ebp)
  800a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a13:	72 d9                	jb     8009ee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a2a:	74 30                	je     800a5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a2c:	eb 16                	jmp    800a44 <strlcpy+0x2a>
			*dst++ = *src++;
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8d 50 01             	lea    0x1(%eax),%edx
  800a34:	89 55 08             	mov    %edx,0x8(%ebp)
  800a37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a40:	8a 12                	mov    (%edx),%dl
  800a42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a44:	ff 4d 10             	decl   0x10(%ebp)
  800a47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a4b:	74 09                	je     800a56 <strlcpy+0x3c>
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	8a 00                	mov    (%eax),%al
  800a52:	84 c0                	test   %al,%al
  800a54:	75 d8                	jne    800a2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a62:	29 c2                	sub    %eax,%edx
  800a64:	89 d0                	mov    %edx,%eax
}
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    

00800a68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a6b:	eb 06                	jmp    800a73 <strcmp+0xb>
		p++, q++;
  800a6d:	ff 45 08             	incl   0x8(%ebp)
  800a70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a73:	8b 45 08             	mov    0x8(%ebp),%eax
  800a76:	8a 00                	mov    (%eax),%al
  800a78:	84 c0                	test   %al,%al
  800a7a:	74 0e                	je     800a8a <strcmp+0x22>
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	8a 10                	mov    (%eax),%dl
  800a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a84:	8a 00                	mov    (%eax),%al
  800a86:	38 c2                	cmp    %al,%dl
  800a88:	74 e3                	je     800a6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8a 00                	mov    (%eax),%al
  800a8f:	0f b6 d0             	movzbl %al,%edx
  800a92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a95:	8a 00                	mov    (%eax),%al
  800a97:	0f b6 c0             	movzbl %al,%eax
  800a9a:	29 c2                	sub    %eax,%edx
  800a9c:	89 d0                	mov    %edx,%eax
}
  800a9e:	5d                   	pop    %ebp
  800a9f:	c3                   	ret    

00800aa0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800aa0:	55                   	push   %ebp
  800aa1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800aa3:	eb 09                	jmp    800aae <strncmp+0xe>
		n--, p++, q++;
  800aa5:	ff 4d 10             	decl   0x10(%ebp)
  800aa8:	ff 45 08             	incl   0x8(%ebp)
  800aab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ab2:	74 17                	je     800acb <strncmp+0x2b>
  800ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab7:	8a 00                	mov    (%eax),%al
  800ab9:	84 c0                	test   %al,%al
  800abb:	74 0e                	je     800acb <strncmp+0x2b>
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	8a 10                	mov    (%eax),%dl
  800ac2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	38 c2                	cmp    %al,%dl
  800ac9:	74 da                	je     800aa5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800acb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acf:	75 07                	jne    800ad8 <strncmp+0x38>
		return 0;
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	eb 14                	jmp    800aec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	8a 00                	mov    (%eax),%al
  800add:	0f b6 d0             	movzbl %al,%edx
  800ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae3:	8a 00                	mov    (%eax),%al
  800ae5:	0f b6 c0             	movzbl %al,%eax
  800ae8:	29 c2                	sub    %eax,%edx
  800aea:	89 d0                	mov    %edx,%eax
}
  800aec:	5d                   	pop    %ebp
  800aed:	c3                   	ret    

00800aee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	83 ec 04             	sub    $0x4,%esp
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800afa:	eb 12                	jmp    800b0e <strchr+0x20>
		if (*s == c)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8a 00                	mov    (%eax),%al
  800b01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b04:	75 05                	jne    800b0b <strchr+0x1d>
			return (char *) s;
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	eb 11                	jmp    800b1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b0b:	ff 45 08             	incl   0x8(%ebp)
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	84 c0                	test   %al,%al
  800b15:	75 e5                	jne    800afc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b2a:	eb 0d                	jmp    800b39 <strfind+0x1b>
		if (*s == c)
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b34:	74 0e                	je     800b44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b36:	ff 45 08             	incl   0x8(%ebp)
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8a 00                	mov    (%eax),%al
  800b3e:	84 c0                	test   %al,%al
  800b40:	75 ea                	jne    800b2c <strfind+0xe>
  800b42:	eb 01                	jmp    800b45 <strfind+0x27>
		if (*s == c)
			break;
  800b44:	90                   	nop
	return (char *) s;
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b56:	8b 45 10             	mov    0x10(%ebp),%eax
  800b59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b5c:	eb 0e                	jmp    800b6c <memset+0x22>
		*p++ = c;
  800b5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b61:	8d 50 01             	lea    0x1(%eax),%edx
  800b64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b6c:	ff 4d f8             	decl   -0x8(%ebp)
  800b6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b73:	79 e9                	jns    800b5e <memset+0x14>
		*p++ = c;

	return v;
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b78:	c9                   	leave  
  800b79:	c3                   	ret    

00800b7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b86:	8b 45 08             	mov    0x8(%ebp),%eax
  800b89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b8c:	eb 16                	jmp    800ba4 <memcpy+0x2a>
		*d++ = *s++;
  800b8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b91:	8d 50 01             	lea    0x1(%eax),%edx
  800b94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ba0:	8a 12                	mov    (%edx),%dl
  800ba2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baa:	89 55 10             	mov    %edx,0x10(%ebp)
  800bad:	85 c0                	test   %eax,%eax
  800baf:	75 dd                	jne    800b8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bb4:	c9                   	leave  
  800bb5:	c3                   	ret    

00800bb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bcb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bce:	73 50                	jae    800c20 <memmove+0x6a>
  800bd0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bd3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd6:	01 d0                	add    %edx,%eax
  800bd8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bdb:	76 43                	jbe    800c20 <memmove+0x6a>
		s += n;
  800bdd:	8b 45 10             	mov    0x10(%ebp),%eax
  800be0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800be3:	8b 45 10             	mov    0x10(%ebp),%eax
  800be6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800be9:	eb 10                	jmp    800bfb <memmove+0x45>
			*--d = *--s;
  800beb:	ff 4d f8             	decl   -0x8(%ebp)
  800bee:	ff 4d fc             	decl   -0x4(%ebp)
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf4:	8a 10                	mov    (%eax),%dl
  800bf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c01:	89 55 10             	mov    %edx,0x10(%ebp)
  800c04:	85 c0                	test   %eax,%eax
  800c06:	75 e3                	jne    800beb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c08:	eb 23                	jmp    800c2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0d:	8d 50 01             	lea    0x1(%eax),%edx
  800c10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c1c:	8a 12                	mov    (%edx),%dl
  800c1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c20:	8b 45 10             	mov    0x10(%ebp),%eax
  800c23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c26:	89 55 10             	mov    %edx,0x10(%ebp)
  800c29:	85 c0                	test   %eax,%eax
  800c2b:	75 dd                	jne    800c0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c44:	eb 2a                	jmp    800c70 <memcmp+0x3e>
		if (*s1 != *s2)
  800c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c49:	8a 10                	mov    (%eax),%dl
  800c4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c4e:	8a 00                	mov    (%eax),%al
  800c50:	38 c2                	cmp    %al,%dl
  800c52:	74 16                	je     800c6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c57:	8a 00                	mov    (%eax),%al
  800c59:	0f b6 d0             	movzbl %al,%edx
  800c5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c5f:	8a 00                	mov    (%eax),%al
  800c61:	0f b6 c0             	movzbl %al,%eax
  800c64:	29 c2                	sub    %eax,%edx
  800c66:	89 d0                	mov    %edx,%eax
  800c68:	eb 18                	jmp    800c82 <memcmp+0x50>
		s1++, s2++;
  800c6a:	ff 45 fc             	incl   -0x4(%ebp)
  800c6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c70:	8b 45 10             	mov    0x10(%ebp),%eax
  800c73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c76:	89 55 10             	mov    %edx,0x10(%ebp)
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	75 c9                	jne    800c46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c90:	01 d0                	add    %edx,%eax
  800c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c95:	eb 15                	jmp    800cac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	0f b6 d0             	movzbl %al,%edx
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	0f b6 c0             	movzbl %al,%eax
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	74 0d                	je     800cb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca9:	ff 45 08             	incl   0x8(%ebp)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cb2:	72 e3                	jb     800c97 <memfind+0x13>
  800cb4:	eb 01                	jmp    800cb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cb6:	90                   	nop
	return (void *) s;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd0:	eb 03                	jmp    800cd5 <strtol+0x19>
		s++;
  800cd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	3c 20                	cmp    $0x20,%al
  800cdc:	74 f4                	je     800cd2 <strtol+0x16>
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	8a 00                	mov    (%eax),%al
  800ce3:	3c 09                	cmp    $0x9,%al
  800ce5:	74 eb                	je     800cd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 2b                	cmp    $0x2b,%al
  800cee:	75 05                	jne    800cf5 <strtol+0x39>
		s++;
  800cf0:	ff 45 08             	incl   0x8(%ebp)
  800cf3:	eb 13                	jmp    800d08 <strtol+0x4c>
	else if (*s == '-')
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	3c 2d                	cmp    $0x2d,%al
  800cfc:	75 0a                	jne    800d08 <strtol+0x4c>
		s++, neg = 1;
  800cfe:	ff 45 08             	incl   0x8(%ebp)
  800d01:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0c:	74 06                	je     800d14 <strtol+0x58>
  800d0e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d12:	75 20                	jne    800d34 <strtol+0x78>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	3c 30                	cmp    $0x30,%al
  800d1b:	75 17                	jne    800d34 <strtol+0x78>
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	40                   	inc    %eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	3c 78                	cmp    $0x78,%al
  800d25:	75 0d                	jne    800d34 <strtol+0x78>
		s += 2, base = 16;
  800d27:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d2b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d32:	eb 28                	jmp    800d5c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d38:	75 15                	jne    800d4f <strtol+0x93>
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	3c 30                	cmp    $0x30,%al
  800d41:	75 0c                	jne    800d4f <strtol+0x93>
		s++, base = 8;
  800d43:	ff 45 08             	incl   0x8(%ebp)
  800d46:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d4d:	eb 0d                	jmp    800d5c <strtol+0xa0>
	else if (base == 0)
  800d4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d53:	75 07                	jne    800d5c <strtol+0xa0>
		base = 10;
  800d55:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	3c 2f                	cmp    $0x2f,%al
  800d63:	7e 19                	jle    800d7e <strtol+0xc2>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 00                	mov    (%eax),%al
  800d6a:	3c 39                	cmp    $0x39,%al
  800d6c:	7f 10                	jg     800d7e <strtol+0xc2>
			dig = *s - '0';
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	0f be c0             	movsbl %al,%eax
  800d76:	83 e8 30             	sub    $0x30,%eax
  800d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d7c:	eb 42                	jmp    800dc0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	8a 00                	mov    (%eax),%al
  800d83:	3c 60                	cmp    $0x60,%al
  800d85:	7e 19                	jle    800da0 <strtol+0xe4>
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	8a 00                	mov    (%eax),%al
  800d8c:	3c 7a                	cmp    $0x7a,%al
  800d8e:	7f 10                	jg     800da0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	0f be c0             	movsbl %al,%eax
  800d98:	83 e8 57             	sub    $0x57,%eax
  800d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d9e:	eb 20                	jmp    800dc0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800da0:	8b 45 08             	mov    0x8(%ebp),%eax
  800da3:	8a 00                	mov    (%eax),%al
  800da5:	3c 40                	cmp    $0x40,%al
  800da7:	7e 39                	jle    800de2 <strtol+0x126>
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	8a 00                	mov    (%eax),%al
  800dae:	3c 5a                	cmp    $0x5a,%al
  800db0:	7f 30                	jg     800de2 <strtol+0x126>
			dig = *s - 'A' + 10;
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8a 00                	mov    (%eax),%al
  800db7:	0f be c0             	movsbl %al,%eax
  800dba:	83 e8 37             	sub    $0x37,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dc3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dc6:	7d 19                	jge    800de1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dc8:	ff 45 08             	incl   0x8(%ebp)
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dd2:	89 c2                	mov    %eax,%edx
  800dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd7:	01 d0                	add    %edx,%eax
  800dd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800ddc:	e9 7b ff ff ff       	jmp    800d5c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800de1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800de2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de6:	74 08                	je     800df0 <strtol+0x134>
		*endptr = (char *) s;
  800de8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800deb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800df0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800df4:	74 07                	je     800dfd <strtol+0x141>
  800df6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800df9:	f7 d8                	neg    %eax
  800dfb:	eb 03                	jmp    800e00 <strtol+0x144>
  800dfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <ltostr>:

void
ltostr(long value, char *str)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e08:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e0f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e1a:	79 13                	jns    800e2f <ltostr+0x2d>
	{
		neg = 1;
  800e1c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e29:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e2c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e32:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e37:	99                   	cltd   
  800e38:	f7 f9                	idiv   %ecx
  800e3a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e40:	8d 50 01             	lea    0x1(%eax),%edx
  800e43:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e46:	89 c2                	mov    %eax,%edx
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	01 d0                	add    %edx,%eax
  800e4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e50:	83 c2 30             	add    $0x30,%edx
  800e53:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e55:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e58:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e5d:	f7 e9                	imul   %ecx
  800e5f:	c1 fa 02             	sar    $0x2,%edx
  800e62:	89 c8                	mov    %ecx,%eax
  800e64:	c1 f8 1f             	sar    $0x1f,%eax
  800e67:	29 c2                	sub    %eax,%edx
  800e69:	89 d0                	mov    %edx,%eax
  800e6b:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e72:	75 bb                	jne    800e2f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7e:	48                   	dec    %eax
  800e7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e82:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e86:	74 3d                	je     800ec5 <ltostr+0xc3>
		start = 1 ;
  800e88:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e8f:	eb 34                	jmp    800ec5 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e97:	01 d0                	add    %edx,%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea4:	01 c2                	add    %eax,%edx
  800ea6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	01 c8                	add    %ecx,%eax
  800eae:	8a 00                	mov    (%eax),%al
  800eb0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800eb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	01 c2                	add    %eax,%edx
  800eba:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ebd:	88 02                	mov    %al,(%edx)
		start++ ;
  800ebf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ec2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ecb:	7c c4                	jl     800e91 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ecd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	01 d0                	add    %edx,%eax
  800ed5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ed8:	90                   	nop
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 73 fa ff ff       	call   80095c <strlen>
  800ee9:	83 c4 04             	add    $0x4,%esp
  800eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	e8 65 fa ff ff       	call   80095c <strlen>
  800ef7:	83 c4 04             	add    $0x4,%esp
  800efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800efd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f0b:	eb 17                	jmp    800f24 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f10:	8b 45 10             	mov    0x10(%ebp),%eax
  800f13:	01 c2                	add    %eax,%edx
  800f15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	01 c8                	add    %ecx,%eax
  800f1d:	8a 00                	mov    (%eax),%al
  800f1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f21:	ff 45 fc             	incl   -0x4(%ebp)
  800f24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f2a:	7c e1                	jl     800f0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f3a:	eb 1f                	jmp    800f5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3f:	8d 50 01             	lea    0x1(%eax),%edx
  800f42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f45:	89 c2                	mov    %eax,%edx
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 c2                	add    %eax,%edx
  800f4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	01 c8                	add    %ecx,%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f58:	ff 45 f8             	incl   -0x8(%ebp)
  800f5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f61:	7c d9                	jl     800f3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f66:	8b 45 10             	mov    0x10(%ebp),%eax
  800f69:	01 d0                	add    %edx,%eax
  800f6b:	c6 00 00             	movb   $0x0,(%eax)
}
  800f6e:	90                   	nop
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f74:	8b 45 14             	mov    0x14(%ebp),%eax
  800f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f80:	8b 00                	mov    (%eax),%eax
  800f82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f89:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8c:	01 d0                	add    %edx,%eax
  800f8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f94:	eb 0c                	jmp    800fa2 <strsplit+0x31>
			*string++ = 0;
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8d 50 01             	lea    0x1(%eax),%edx
  800f9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	84 c0                	test   %al,%al
  800fa9:	74 18                	je     800fc3 <strsplit+0x52>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f be c0             	movsbl %al,%eax
  800fb3:	50                   	push   %eax
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	e8 32 fb ff ff       	call   800aee <strchr>
  800fbc:	83 c4 08             	add    $0x8,%esp
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	75 d3                	jne    800f96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	8a 00                	mov    (%eax),%al
  800fc8:	84 c0                	test   %al,%al
  800fca:	74 5a                	je     801026 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fcc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcf:	8b 00                	mov    (%eax),%eax
  800fd1:	83 f8 0f             	cmp    $0xf,%eax
  800fd4:	75 07                	jne    800fdd <strsplit+0x6c>
		{
			return 0;
  800fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fdb:	eb 66                	jmp    801043 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe0:	8b 00                	mov    (%eax),%eax
  800fe2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fe5:	8b 55 14             	mov    0x14(%ebp),%edx
  800fe8:	89 0a                	mov    %ecx,(%edx)
  800fea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ff1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff4:	01 c2                	add    %eax,%edx
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ffb:	eb 03                	jmp    801000 <strsplit+0x8f>
			string++;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	8a 00                	mov    (%eax),%al
  801005:	84 c0                	test   %al,%al
  801007:	74 8b                	je     800f94 <strsplit+0x23>
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	8a 00                	mov    (%eax),%al
  80100e:	0f be c0             	movsbl %al,%eax
  801011:	50                   	push   %eax
  801012:	ff 75 0c             	pushl  0xc(%ebp)
  801015:	e8 d4 fa ff ff       	call   800aee <strchr>
  80101a:	83 c4 08             	add    $0x8,%esp
  80101d:	85 c0                	test   %eax,%eax
  80101f:	74 dc                	je     800ffd <strsplit+0x8c>
			string++;
	}
  801021:	e9 6e ff ff ff       	jmp    800f94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801026:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801027:	8b 45 14             	mov    0x14(%ebp),%eax
  80102a:	8b 00                	mov    (%eax),%eax
  80102c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801033:	8b 45 10             	mov    0x10(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80103e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801043:	c9                   	leave  
  801044:	c3                   	ret    

00801045 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80104b:	83 ec 04             	sub    $0x4,%esp
  80104e:	68 e8 1f 80 00       	push   $0x801fe8
  801053:	68 3f 01 00 00       	push   $0x13f
  801058:	68 0a 20 80 00       	push   $0x80200a
  80105d:	e8 9d 06 00 00       	call   8016ff <_panic>

00801062 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
  801065:	57                   	push   %edi
  801066:	56                   	push   %esi
  801067:	53                   	push   %ebx
  801068:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801071:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801074:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801077:	8b 7d 18             	mov    0x18(%ebp),%edi
  80107a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80107d:	cd 30                	int    $0x30
  80107f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801082:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801085:	83 c4 10             	add    $0x10,%esp
  801088:	5b                   	pop    %ebx
  801089:	5e                   	pop    %esi
  80108a:	5f                   	pop    %edi
  80108b:	5d                   	pop    %ebp
  80108c:	c3                   	ret    

0080108d <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80108d:	55                   	push   %ebp
  80108e:	89 e5                	mov    %esp,%ebp
  801090:	83 ec 04             	sub    $0x4,%esp
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  801099:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80109d:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a0:	6a 00                	push   $0x0
  8010a2:	6a 00                	push   $0x0
  8010a4:	52                   	push   %edx
  8010a5:	ff 75 0c             	pushl  0xc(%ebp)
  8010a8:	50                   	push   %eax
  8010a9:	6a 00                	push   $0x0
  8010ab:	e8 b2 ff ff ff       	call   801062 <syscall>
  8010b0:	83 c4 18             	add    $0x18,%esp
}
  8010b3:	90                   	nop
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <sys_cgetc>:

int sys_cgetc(void) {
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010b9:	6a 00                	push   $0x0
  8010bb:	6a 00                	push   $0x0
  8010bd:	6a 00                	push   $0x0
  8010bf:	6a 00                	push   $0x0
  8010c1:	6a 00                	push   $0x0
  8010c3:	6a 02                	push   $0x2
  8010c5:	e8 98 ff ff ff       	call   801062 <syscall>
  8010ca:	83 c4 18             	add    $0x18,%esp
}
  8010cd:	c9                   	leave  
  8010ce:	c3                   	ret    

008010cf <sys_lock_cons>:

void sys_lock_cons(void) {
  8010cf:	55                   	push   %ebp
  8010d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010d2:	6a 00                	push   $0x0
  8010d4:	6a 00                	push   $0x0
  8010d6:	6a 00                	push   $0x0
  8010d8:	6a 00                	push   $0x0
  8010da:	6a 00                	push   $0x0
  8010dc:	6a 03                	push   $0x3
  8010de:	e8 7f ff ff ff       	call   801062 <syscall>
  8010e3:	83 c4 18             	add    $0x18,%esp
}
  8010e6:	90                   	nop
  8010e7:	c9                   	leave  
  8010e8:	c3                   	ret    

008010e9 <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8010e9:	55                   	push   %ebp
  8010ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010ec:	6a 00                	push   $0x0
  8010ee:	6a 00                	push   $0x0
  8010f0:	6a 00                	push   $0x0
  8010f2:	6a 00                	push   $0x0
  8010f4:	6a 00                	push   $0x0
  8010f6:	6a 04                	push   $0x4
  8010f8:	e8 65 ff ff ff       	call   801062 <syscall>
  8010fd:	83 c4 18             	add    $0x18,%esp
}
  801100:	90                   	nop
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  801106:	8b 55 0c             	mov    0xc(%ebp),%edx
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	52                   	push   %edx
  801113:	50                   	push   %eax
  801114:	6a 08                	push   $0x8
  801116:	e8 47 ff ff ff       	call   801062 <syscall>
  80111b:	83 c4 18             	add    $0x18,%esp
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801125:	8b 75 18             	mov    0x18(%ebp),%esi
  801128:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80112b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80112e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	56                   	push   %esi
  801135:	53                   	push   %ebx
  801136:	51                   	push   %ecx
  801137:	52                   	push   %edx
  801138:	50                   	push   %eax
  801139:	6a 09                	push   $0x9
  80113b:	e8 22 ff ff ff       	call   801062 <syscall>
  801140:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80114d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	6a 00                	push   $0x0
  801155:	6a 00                	push   $0x0
  801157:	6a 00                	push   $0x0
  801159:	52                   	push   %edx
  80115a:	50                   	push   %eax
  80115b:	6a 0a                	push   $0xa
  80115d:	e8 00 ff ff ff       	call   801062 <syscall>
  801162:	83 c4 18             	add    $0x18,%esp
}
  801165:	c9                   	leave  
  801166:	c3                   	ret    

00801167 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801167:	55                   	push   %ebp
  801168:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80116a:	6a 00                	push   $0x0
  80116c:	6a 00                	push   $0x0
  80116e:	6a 00                	push   $0x0
  801170:	ff 75 0c             	pushl  0xc(%ebp)
  801173:	ff 75 08             	pushl  0x8(%ebp)
  801176:	6a 0b                	push   $0xb
  801178:	e8 e5 fe ff ff       	call   801062 <syscall>
  80117d:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801185:	6a 00                	push   $0x0
  801187:	6a 00                	push   $0x0
  801189:	6a 00                	push   $0x0
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 0c                	push   $0xc
  801191:	e8 cc fe ff ff       	call   801062 <syscall>
  801196:	83 c4 18             	add    $0x18,%esp
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80119e:	6a 00                	push   $0x0
  8011a0:	6a 00                	push   $0x0
  8011a2:	6a 00                	push   $0x0
  8011a4:	6a 00                	push   $0x0
  8011a6:	6a 00                	push   $0x0
  8011a8:	6a 0d                	push   $0xd
  8011aa:	e8 b3 fe ff ff       	call   801062 <syscall>
  8011af:	83 c4 18             	add    $0x18,%esp
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011b7:	6a 00                	push   $0x0
  8011b9:	6a 00                	push   $0x0
  8011bb:	6a 00                	push   $0x0
  8011bd:	6a 00                	push   $0x0
  8011bf:	6a 00                	push   $0x0
  8011c1:	6a 0e                	push   $0xe
  8011c3:	e8 9a fe ff ff       	call   801062 <syscall>
  8011c8:	83 c4 18             	add    $0x18,%esp
}
  8011cb:	c9                   	leave  
  8011cc:	c3                   	ret    

008011cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	6a 00                	push   $0x0
  8011d6:	6a 00                	push   $0x0
  8011d8:	6a 00                	push   $0x0
  8011da:	6a 0f                	push   $0xf
  8011dc:	e8 81 fe ff ff       	call   801062 <syscall>
  8011e1:	83 c4 18             	add    $0x18,%esp
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 00                	push   $0x0
  8011f1:	ff 75 08             	pushl  0x8(%ebp)
  8011f4:	6a 10                	push   $0x10
  8011f6:	e8 67 fe ff ff       	call   801062 <syscall>
  8011fb:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8011fe:	c9                   	leave  
  8011ff:	c3                   	ret    

00801200 <sys_scarce_memory>:

void sys_scarce_memory() {
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801203:	6a 00                	push   $0x0
  801205:	6a 00                	push   $0x0
  801207:	6a 00                	push   $0x0
  801209:	6a 00                	push   $0x0
  80120b:	6a 00                	push   $0x0
  80120d:	6a 11                	push   $0x11
  80120f:	e8 4e fe ff ff       	call   801062 <syscall>
  801214:	83 c4 18             	add    $0x18,%esp
}
  801217:	90                   	nop
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <sys_cputc>:

void sys_cputc(const char c) {
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 04             	sub    $0x4,%esp
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801226:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80122a:	6a 00                	push   $0x0
  80122c:	6a 00                	push   $0x0
  80122e:	6a 00                	push   $0x0
  801230:	6a 00                	push   $0x0
  801232:	50                   	push   %eax
  801233:	6a 01                	push   $0x1
  801235:	e8 28 fe ff ff       	call   801062 <syscall>
  80123a:	83 c4 18             	add    $0x18,%esp
}
  80123d:	90                   	nop
  80123e:	c9                   	leave  
  80123f:	c3                   	ret    

00801240 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801243:	6a 00                	push   $0x0
  801245:	6a 00                	push   $0x0
  801247:	6a 00                	push   $0x0
  801249:	6a 00                	push   $0x0
  80124b:	6a 00                	push   $0x0
  80124d:	6a 14                	push   $0x14
  80124f:	e8 0e fe ff ff       	call   801062 <syscall>
  801254:	83 c4 18             	add    $0x18,%esp
}
  801257:	90                   	nop
  801258:	c9                   	leave  
  801259:	c3                   	ret    

0080125a <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80125a:	55                   	push   %ebp
  80125b:	89 e5                	mov    %esp,%ebp
  80125d:	83 ec 04             	sub    $0x4,%esp
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801266:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801269:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
  801270:	6a 00                	push   $0x0
  801272:	51                   	push   %ecx
  801273:	52                   	push   %edx
  801274:	ff 75 0c             	pushl  0xc(%ebp)
  801277:	50                   	push   %eax
  801278:	6a 15                	push   $0x15
  80127a:	e8 e3 fd ff ff       	call   801062 <syscall>
  80127f:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801282:	c9                   	leave  
  801283:	c3                   	ret    

00801284 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801287:	8b 55 0c             	mov    0xc(%ebp),%edx
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	6a 00                	push   $0x0
  80128f:	6a 00                	push   $0x0
  801291:	6a 00                	push   $0x0
  801293:	52                   	push   %edx
  801294:	50                   	push   %eax
  801295:	6a 16                	push   $0x16
  801297:	e8 c6 fd ff ff       	call   801062 <syscall>
  80129c:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  80129f:	c9                   	leave  
  8012a0:	c3                   	ret    

008012a1 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8012a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	6a 00                	push   $0x0
  8012af:	6a 00                	push   $0x0
  8012b1:	51                   	push   %ecx
  8012b2:	52                   	push   %edx
  8012b3:	50                   	push   %eax
  8012b4:	6a 17                	push   $0x17
  8012b6:	e8 a7 fd ff ff       	call   801062 <syscall>
  8012bb:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8012c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	6a 00                	push   $0x0
  8012cb:	6a 00                	push   $0x0
  8012cd:	6a 00                	push   $0x0
  8012cf:	52                   	push   %edx
  8012d0:	50                   	push   %eax
  8012d1:	6a 18                	push   $0x18
  8012d3:	e8 8a fd ff ff       	call   801062 <syscall>
  8012d8:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8012db:	c9                   	leave  
  8012dc:	c3                   	ret    

008012dd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	6a 00                	push   $0x0
  8012e5:	ff 75 14             	pushl  0x14(%ebp)
  8012e8:	ff 75 10             	pushl  0x10(%ebp)
  8012eb:	ff 75 0c             	pushl  0xc(%ebp)
  8012ee:	50                   	push   %eax
  8012ef:	6a 19                	push   $0x19
  8012f1:	e8 6c fd ff ff       	call   801062 <syscall>
  8012f6:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <sys_run_env>:

void sys_run_env(int32 envId) {
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	6a 00                	push   $0x0
  801303:	6a 00                	push   $0x0
  801305:	6a 00                	push   $0x0
  801307:	6a 00                	push   $0x0
  801309:	50                   	push   %eax
  80130a:	6a 1a                	push   $0x1a
  80130c:	e8 51 fd ff ff       	call   801062 <syscall>
  801311:	83 c4 18             	add    $0x18,%esp
}
  801314:	90                   	nop
  801315:	c9                   	leave  
  801316:	c3                   	ret    

00801317 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80131a:	8b 45 08             	mov    0x8(%ebp),%eax
  80131d:	6a 00                	push   $0x0
  80131f:	6a 00                	push   $0x0
  801321:	6a 00                	push   $0x0
  801323:	6a 00                	push   $0x0
  801325:	50                   	push   %eax
  801326:	6a 1b                	push   $0x1b
  801328:	e8 35 fd ff ff       	call   801062 <syscall>
  80132d:	83 c4 18             	add    $0x18,%esp
}
  801330:	c9                   	leave  
  801331:	c3                   	ret    

00801332 <sys_getenvid>:

int32 sys_getenvid(void) {
  801332:	55                   	push   %ebp
  801333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	6a 00                	push   $0x0
  80133b:	6a 00                	push   $0x0
  80133d:	6a 00                	push   $0x0
  80133f:	6a 05                	push   $0x5
  801341:	e8 1c fd ff ff       	call   801062 <syscall>
  801346:	83 c4 18             	add    $0x18,%esp
}
  801349:	c9                   	leave  
  80134a:	c3                   	ret    

0080134b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80134e:	6a 00                	push   $0x0
  801350:	6a 00                	push   $0x0
  801352:	6a 00                	push   $0x0
  801354:	6a 00                	push   $0x0
  801356:	6a 00                	push   $0x0
  801358:	6a 06                	push   $0x6
  80135a:	e8 03 fd ff ff       	call   801062 <syscall>
  80135f:	83 c4 18             	add    $0x18,%esp
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801367:	6a 00                	push   $0x0
  801369:	6a 00                	push   $0x0
  80136b:	6a 00                	push   $0x0
  80136d:	6a 00                	push   $0x0
  80136f:	6a 00                	push   $0x0
  801371:	6a 07                	push   $0x7
  801373:	e8 ea fc ff ff       	call   801062 <syscall>
  801378:	83 c4 18             	add    $0x18,%esp
}
  80137b:	c9                   	leave  
  80137c:	c3                   	ret    

0080137d <sys_exit_env>:

void sys_exit_env(void) {
  80137d:	55                   	push   %ebp
  80137e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801380:	6a 00                	push   $0x0
  801382:	6a 00                	push   $0x0
  801384:	6a 00                	push   $0x0
  801386:	6a 00                	push   $0x0
  801388:	6a 00                	push   $0x0
  80138a:	6a 1c                	push   $0x1c
  80138c:	e8 d1 fc ff ff       	call   801062 <syscall>
  801391:	83 c4 18             	add    $0x18,%esp
}
  801394:	90                   	nop
  801395:	c9                   	leave  
  801396:	c3                   	ret    

00801397 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80139d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013a0:	8d 50 04             	lea    0x4(%eax),%edx
  8013a3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013a6:	6a 00                	push   $0x0
  8013a8:	6a 00                	push   $0x0
  8013aa:	6a 00                	push   $0x0
  8013ac:	52                   	push   %edx
  8013ad:	50                   	push   %eax
  8013ae:	6a 1d                	push   $0x1d
  8013b0:	e8 ad fc ff ff       	call   801062 <syscall>
  8013b5:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8013b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013be:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013c1:	89 01                	mov    %eax,(%ecx)
  8013c3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	c9                   	leave  
  8013ca:	c2 04 00             	ret    $0x4

008013cd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	ff 75 10             	pushl  0x10(%ebp)
  8013d7:	ff 75 0c             	pushl  0xc(%ebp)
  8013da:	ff 75 08             	pushl  0x8(%ebp)
  8013dd:	6a 13                	push   $0x13
  8013df:	e8 7e fc ff ff       	call   801062 <syscall>
  8013e4:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8013e7:	90                   	nop
}
  8013e8:	c9                   	leave  
  8013e9:	c3                   	ret    

008013ea <sys_rcr2>:
uint32 sys_rcr2() {
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 00                	push   $0x0
  8013f7:	6a 1e                	push   $0x1e
  8013f9:	e8 64 fc ff ff       	call   801062 <syscall>
  8013fe:	83 c4 18             	add    $0x18,%esp
}
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	83 ec 04             	sub    $0x4,%esp
  801409:	8b 45 08             	mov    0x8(%ebp),%eax
  80140c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80140f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	50                   	push   %eax
  80141c:	6a 1f                	push   $0x1f
  80141e:	e8 3f fc ff ff       	call   801062 <syscall>
  801423:	83 c4 18             	add    $0x18,%esp
	return;
  801426:	90                   	nop
}
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <rsttst>:
void rsttst() {
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80142c:	6a 00                	push   $0x0
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 21                	push   $0x21
  801438:	e8 25 fc ff ff       	call   801062 <syscall>
  80143d:	83 c4 18             	add    $0x18,%esp
	return;
  801440:	90                   	nop
}
  801441:	c9                   	leave  
  801442:	c3                   	ret    

00801443 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801443:	55                   	push   %ebp
  801444:	89 e5                	mov    %esp,%ebp
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	8b 45 14             	mov    0x14(%ebp),%eax
  80144c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80144f:	8b 55 18             	mov    0x18(%ebp),%edx
  801452:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801456:	52                   	push   %edx
  801457:	50                   	push   %eax
  801458:	ff 75 10             	pushl  0x10(%ebp)
  80145b:	ff 75 0c             	pushl  0xc(%ebp)
  80145e:	ff 75 08             	pushl  0x8(%ebp)
  801461:	6a 20                	push   $0x20
  801463:	e8 fa fb ff ff       	call   801062 <syscall>
  801468:	83 c4 18             	add    $0x18,%esp
	return;
  80146b:	90                   	nop
}
  80146c:	c9                   	leave  
  80146d:	c3                   	ret    

0080146e <chktst>:
void chktst(uint32 n) {
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801471:	6a 00                	push   $0x0
  801473:	6a 00                	push   $0x0
  801475:	6a 00                	push   $0x0
  801477:	6a 00                	push   $0x0
  801479:	ff 75 08             	pushl  0x8(%ebp)
  80147c:	6a 22                	push   $0x22
  80147e:	e8 df fb ff ff       	call   801062 <syscall>
  801483:	83 c4 18             	add    $0x18,%esp
	return;
  801486:	90                   	nop
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <inctst>:

void inctst() {
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80148c:	6a 00                	push   $0x0
  80148e:	6a 00                	push   $0x0
  801490:	6a 00                	push   $0x0
  801492:	6a 00                	push   $0x0
  801494:	6a 00                	push   $0x0
  801496:	6a 23                	push   $0x23
  801498:	e8 c5 fb ff ff       	call   801062 <syscall>
  80149d:	83 c4 18             	add    $0x18,%esp
	return;
  8014a0:	90                   	nop
}
  8014a1:	c9                   	leave  
  8014a2:	c3                   	ret    

008014a3 <gettst>:
uint32 gettst() {
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 00                	push   $0x0
  8014ac:	6a 00                	push   $0x0
  8014ae:	6a 00                	push   $0x0
  8014b0:	6a 24                	push   $0x24
  8014b2:	e8 ab fb ff ff       	call   801062 <syscall>
  8014b7:	83 c4 18             	add    $0x18,%esp
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 00                	push   $0x0
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 25                	push   $0x25
  8014ce:	e8 8f fb ff ff       	call   801062 <syscall>
  8014d3:	83 c4 18             	add    $0x18,%esp
  8014d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014d9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014dd:	75 07                	jne    8014e6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014df:	b8 01 00 00 00       	mov    $0x1,%eax
  8014e4:	eb 05                	jmp    8014eb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    

008014ed <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
  8014f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014f3:	6a 00                	push   $0x0
  8014f5:	6a 00                	push   $0x0
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 25                	push   $0x25
  8014ff:	e8 5e fb ff ff       	call   801062 <syscall>
  801504:	83 c4 18             	add    $0x18,%esp
  801507:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80150a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80150e:	75 07                	jne    801517 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801510:	b8 01 00 00 00       	mov    $0x1,%eax
  801515:	eb 05                	jmp    80151c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801524:	6a 00                	push   $0x0
  801526:	6a 00                	push   $0x0
  801528:	6a 00                	push   $0x0
  80152a:	6a 00                	push   $0x0
  80152c:	6a 00                	push   $0x0
  80152e:	6a 25                	push   $0x25
  801530:	e8 2d fb ff ff       	call   801062 <syscall>
  801535:	83 c4 18             	add    $0x18,%esp
  801538:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80153b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80153f:	75 07                	jne    801548 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801541:	b8 01 00 00 00       	mov    $0x1,%eax
  801546:	eb 05                	jmp    80154d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801548:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	6a 00                	push   $0x0
  80155b:	6a 00                	push   $0x0
  80155d:	6a 00                	push   $0x0
  80155f:	6a 25                	push   $0x25
  801561:	e8 fc fa ff ff       	call   801062 <syscall>
  801566:	83 c4 18             	add    $0x18,%esp
  801569:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80156c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801570:	75 07                	jne    801579 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801572:	b8 01 00 00 00       	mov    $0x1,%eax
  801577:	eb 05                	jmp    80157e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 00                	push   $0x0
  801589:	6a 00                	push   $0x0
  80158b:	ff 75 08             	pushl  0x8(%ebp)
  80158e:	6a 26                	push   $0x26
  801590:	e8 cd fa ff ff       	call   801062 <syscall>
  801595:	83 c4 18             	add    $0x18,%esp
	return;
  801598:	90                   	nop
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  80159f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	6a 00                	push   $0x0
  8015ad:	53                   	push   %ebx
  8015ae:	51                   	push   %ecx
  8015af:	52                   	push   %edx
  8015b0:	50                   	push   %eax
  8015b1:	6a 27                	push   $0x27
  8015b3:	e8 aa fa ff ff       	call   801062 <syscall>
  8015b8:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8015bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8015c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	6a 00                	push   $0x0
  8015cb:	6a 00                	push   $0x0
  8015cd:	6a 00                	push   $0x0
  8015cf:	52                   	push   %edx
  8015d0:	50                   	push   %eax
  8015d1:	6a 28                	push   $0x28
  8015d3:	e8 8a fa ff ff       	call   801062 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8015e0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e9:	6a 00                	push   $0x0
  8015eb:	51                   	push   %ecx
  8015ec:	ff 75 10             	pushl  0x10(%ebp)
  8015ef:	52                   	push   %edx
  8015f0:	50                   	push   %eax
  8015f1:	6a 29                	push   $0x29
  8015f3:	e8 6a fa ff ff       	call   801062 <syscall>
  8015f8:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801600:	6a 00                	push   $0x0
  801602:	6a 00                	push   $0x0
  801604:	ff 75 10             	pushl  0x10(%ebp)
  801607:	ff 75 0c             	pushl  0xc(%ebp)
  80160a:	ff 75 08             	pushl  0x8(%ebp)
  80160d:	6a 12                	push   $0x12
  80160f:	e8 4e fa ff ff       	call   801062 <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
	return;
  801617:	90                   	nop
}
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  80161d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	52                   	push   %edx
  80162a:	50                   	push   %eax
  80162b:	6a 2a                	push   $0x2a
  80162d:	e8 30 fa ff ff       	call   801062 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
	return;
  801635:	90                   	nop
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	6a 00                	push   $0x0
  801640:	6a 00                	push   $0x0
  801642:	6a 00                	push   $0x0
  801644:	6a 00                	push   $0x0
  801646:	50                   	push   %eax
  801647:	6a 2b                	push   $0x2b
  801649:	e8 14 fa ff ff       	call   801062 <syscall>
  80164e:	83 c4 18             	add    $0x18,%esp
}
  801651:	c9                   	leave  
  801652:	c3                   	ret    

00801653 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801653:	55                   	push   %ebp
  801654:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	6a 00                	push   $0x0
  80165c:	ff 75 0c             	pushl  0xc(%ebp)
  80165f:	ff 75 08             	pushl  0x8(%ebp)
  801662:	6a 2c                	push   $0x2c
  801664:	e8 f9 f9 ff ff       	call   801062 <syscall>
  801669:	83 c4 18             	add    $0x18,%esp
	return;
  80166c:	90                   	nop
}
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801672:	6a 00                	push   $0x0
  801674:	6a 00                	push   $0x0
  801676:	6a 00                	push   $0x0
  801678:	ff 75 0c             	pushl  0xc(%ebp)
  80167b:	ff 75 08             	pushl  0x8(%ebp)
  80167e:	6a 2d                	push   $0x2d
  801680:	e8 dd f9 ff ff       	call   801062 <syscall>
  801685:	83 c4 18             	add    $0x18,%esp
	return;
  801688:	90                   	nop
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	6a 00                	push   $0x0
  801693:	6a 00                	push   $0x0
  801695:	6a 00                	push   $0x0
  801697:	6a 00                	push   $0x0
  801699:	50                   	push   %eax
  80169a:	6a 2f                	push   $0x2f
  80169c:	e8 c1 f9 ff ff       	call   801062 <syscall>
  8016a1:	83 c4 18             	add    $0x18,%esp
	return;
  8016a4:	90                   	nop
}
  8016a5:	c9                   	leave  
  8016a6:	c3                   	ret    

008016a7 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8016a7:	55                   	push   %ebp
  8016a8:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8016aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	6a 00                	push   $0x0
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	52                   	push   %edx
  8016b7:	50                   	push   %eax
  8016b8:	6a 30                	push   $0x30
  8016ba:	e8 a3 f9 ff ff       	call   801062 <syscall>
  8016bf:	83 c4 18             	add    $0x18,%esp
	return;
  8016c2:	90                   	nop
}
  8016c3:	c9                   	leave  
  8016c4:	c3                   	ret    

008016c5 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	6a 00                	push   $0x0
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	50                   	push   %eax
  8016d4:	6a 31                	push   $0x31
  8016d6:	e8 87 f9 ff ff       	call   801062 <syscall>
  8016db:	83 c4 18             	add    $0x18,%esp
	return;
  8016de:	90                   	nop
}
  8016df:	c9                   	leave  
  8016e0:	c3                   	ret    

008016e1 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	52                   	push   %edx
  8016f1:	50                   	push   %eax
  8016f2:	6a 2e                	push   $0x2e
  8016f4:	e8 69 f9 ff ff       	call   801062 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
    return;
  8016fc:	90                   	nop
}
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
  801702:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801705:	8d 45 10             	lea    0x10(%ebp),%eax
  801708:	83 c0 04             	add    $0x4,%eax
  80170b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80170e:	a1 28 30 80 00       	mov    0x803028,%eax
  801713:	85 c0                	test   %eax,%eax
  801715:	74 16                	je     80172d <_panic+0x2e>
		cprintf("%s: ", argv0);
  801717:	a1 28 30 80 00       	mov    0x803028,%eax
  80171c:	83 ec 08             	sub    $0x8,%esp
  80171f:	50                   	push   %eax
  801720:	68 18 20 80 00       	push   $0x802018
  801725:	e8 9e eb ff ff       	call   8002c8 <cprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80172d:	a1 04 30 80 00       	mov    0x803004,%eax
  801732:	ff 75 0c             	pushl  0xc(%ebp)
  801735:	ff 75 08             	pushl  0x8(%ebp)
  801738:	50                   	push   %eax
  801739:	68 1d 20 80 00       	push   $0x80201d
  80173e:	e8 85 eb ff ff       	call   8002c8 <cprintf>
  801743:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801746:	8b 45 10             	mov    0x10(%ebp),%eax
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	ff 75 f4             	pushl  -0xc(%ebp)
  80174f:	50                   	push   %eax
  801750:	e8 08 eb ff ff       	call   80025d <vcprintf>
  801755:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	6a 00                	push   $0x0
  80175d:	68 39 20 80 00       	push   $0x802039
  801762:	e8 f6 ea ff ff       	call   80025d <vcprintf>
  801767:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80176a:	e8 77 ea ff ff       	call   8001e6 <exit>

	// should not return here
	while (1) ;
  80176f:	eb fe                	jmp    80176f <_panic+0x70>

00801771 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801777:	a1 08 30 80 00       	mov    0x803008,%eax
  80177c:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	39 c2                	cmp    %eax,%edx
  801787:	74 14                	je     80179d <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801789:	83 ec 04             	sub    $0x4,%esp
  80178c:	68 3c 20 80 00       	push   $0x80203c
  801791:	6a 26                	push   $0x26
  801793:	68 88 20 80 00       	push   $0x802088
  801798:	e8 62 ff ff ff       	call   8016ff <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80179d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8017a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8017ab:	e9 c5 00 00 00       	jmp    801875 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	01 d0                	add    %edx,%eax
  8017bf:	8b 00                	mov    (%eax),%eax
  8017c1:	85 c0                	test   %eax,%eax
  8017c3:	75 08                	jne    8017cd <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8017c5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8017c8:	e9 a5 00 00 00       	jmp    801872 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8017cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017db:	eb 69                	jmp    801846 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8017dd:	a1 08 30 80 00       	mov    0x803008,%eax
  8017e2:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8017e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017eb:	89 d0                	mov    %edx,%eax
  8017ed:	01 c0                	add    %eax,%eax
  8017ef:	01 d0                	add    %edx,%eax
  8017f1:	c1 e0 03             	shl    $0x3,%eax
  8017f4:	01 c8                	add    %ecx,%eax
  8017f6:	8a 40 04             	mov    0x4(%eax),%al
  8017f9:	84 c0                	test   %al,%al
  8017fb:	75 46                	jne    801843 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017fd:	a1 08 30 80 00       	mov    0x803008,%eax
  801802:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801808:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80180b:	89 d0                	mov    %edx,%eax
  80180d:	01 c0                	add    %eax,%eax
  80180f:	01 d0                	add    %edx,%eax
  801811:	c1 e0 03             	shl    $0x3,%eax
  801814:	01 c8                	add    %ecx,%eax
  801816:	8b 00                	mov    (%eax),%eax
  801818:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80181b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80181e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801823:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801828:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	01 c8                	add    %ecx,%eax
  801834:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801836:	39 c2                	cmp    %eax,%edx
  801838:	75 09                	jne    801843 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80183a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801841:	eb 15                	jmp    801858 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801843:	ff 45 e8             	incl   -0x18(%ebp)
  801846:	a1 08 30 80 00       	mov    0x803008,%eax
  80184b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801854:	39 c2                	cmp    %eax,%edx
  801856:	77 85                	ja     8017dd <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801858:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80185c:	75 14                	jne    801872 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  80185e:	83 ec 04             	sub    $0x4,%esp
  801861:	68 94 20 80 00       	push   $0x802094
  801866:	6a 3a                	push   $0x3a
  801868:	68 88 20 80 00       	push   $0x802088
  80186d:	e8 8d fe ff ff       	call   8016ff <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801872:	ff 45 f0             	incl   -0x10(%ebp)
  801875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801878:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80187b:	0f 8c 2f ff ff ff    	jl     8017b0 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801881:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801888:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80188f:	eb 26                	jmp    8018b7 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801891:	a1 08 30 80 00       	mov    0x803008,%eax
  801896:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80189c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80189f:	89 d0                	mov    %edx,%eax
  8018a1:	01 c0                	add    %eax,%eax
  8018a3:	01 d0                	add    %edx,%eax
  8018a5:	c1 e0 03             	shl    $0x3,%eax
  8018a8:	01 c8                	add    %ecx,%eax
  8018aa:	8a 40 04             	mov    0x4(%eax),%al
  8018ad:	3c 01                	cmp    $0x1,%al
  8018af:	75 03                	jne    8018b4 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8018b1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018b4:	ff 45 e0             	incl   -0x20(%ebp)
  8018b7:	a1 08 30 80 00       	mov    0x803008,%eax
  8018bc:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8018c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c5:	39 c2                	cmp    %eax,%edx
  8018c7:	77 c8                	ja     801891 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018cf:	74 14                	je     8018e5 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8018d1:	83 ec 04             	sub    $0x4,%esp
  8018d4:	68 e8 20 80 00       	push   $0x8020e8
  8018d9:	6a 44                	push   $0x44
  8018db:	68 88 20 80 00       	push   $0x802088
  8018e0:	e8 1a fe ff ff       	call   8016ff <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8018e5:	90                   	nop
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <__udivdi3>:
  8018e8:	55                   	push   %ebp
  8018e9:	57                   	push   %edi
  8018ea:	56                   	push   %esi
  8018eb:	53                   	push   %ebx
  8018ec:	83 ec 1c             	sub    $0x1c,%esp
  8018ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8018f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8018f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8018fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ff:	89 ca                	mov    %ecx,%edx
  801901:	89 f8                	mov    %edi,%eax
  801903:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801907:	85 f6                	test   %esi,%esi
  801909:	75 2d                	jne    801938 <__udivdi3+0x50>
  80190b:	39 cf                	cmp    %ecx,%edi
  80190d:	77 65                	ja     801974 <__udivdi3+0x8c>
  80190f:	89 fd                	mov    %edi,%ebp
  801911:	85 ff                	test   %edi,%edi
  801913:	75 0b                	jne    801920 <__udivdi3+0x38>
  801915:	b8 01 00 00 00       	mov    $0x1,%eax
  80191a:	31 d2                	xor    %edx,%edx
  80191c:	f7 f7                	div    %edi
  80191e:	89 c5                	mov    %eax,%ebp
  801920:	31 d2                	xor    %edx,%edx
  801922:	89 c8                	mov    %ecx,%eax
  801924:	f7 f5                	div    %ebp
  801926:	89 c1                	mov    %eax,%ecx
  801928:	89 d8                	mov    %ebx,%eax
  80192a:	f7 f5                	div    %ebp
  80192c:	89 cf                	mov    %ecx,%edi
  80192e:	89 fa                	mov    %edi,%edx
  801930:	83 c4 1c             	add    $0x1c,%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5f                   	pop    %edi
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    
  801938:	39 ce                	cmp    %ecx,%esi
  80193a:	77 28                	ja     801964 <__udivdi3+0x7c>
  80193c:	0f bd fe             	bsr    %esi,%edi
  80193f:	83 f7 1f             	xor    $0x1f,%edi
  801942:	75 40                	jne    801984 <__udivdi3+0x9c>
  801944:	39 ce                	cmp    %ecx,%esi
  801946:	72 0a                	jb     801952 <__udivdi3+0x6a>
  801948:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80194c:	0f 87 9e 00 00 00    	ja     8019f0 <__udivdi3+0x108>
  801952:	b8 01 00 00 00       	mov    $0x1,%eax
  801957:	89 fa                	mov    %edi,%edx
  801959:	83 c4 1c             	add    $0x1c,%esp
  80195c:	5b                   	pop    %ebx
  80195d:	5e                   	pop    %esi
  80195e:	5f                   	pop    %edi
  80195f:	5d                   	pop    %ebp
  801960:	c3                   	ret    
  801961:	8d 76 00             	lea    0x0(%esi),%esi
  801964:	31 ff                	xor    %edi,%edi
  801966:	31 c0                	xor    %eax,%eax
  801968:	89 fa                	mov    %edi,%edx
  80196a:	83 c4 1c             	add    $0x1c,%esp
  80196d:	5b                   	pop    %ebx
  80196e:	5e                   	pop    %esi
  80196f:	5f                   	pop    %edi
  801970:	5d                   	pop    %ebp
  801971:	c3                   	ret    
  801972:	66 90                	xchg   %ax,%ax
  801974:	89 d8                	mov    %ebx,%eax
  801976:	f7 f7                	div    %edi
  801978:	31 ff                	xor    %edi,%edi
  80197a:	89 fa                	mov    %edi,%edx
  80197c:	83 c4 1c             	add    $0x1c,%esp
  80197f:	5b                   	pop    %ebx
  801980:	5e                   	pop    %esi
  801981:	5f                   	pop    %edi
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    
  801984:	bd 20 00 00 00       	mov    $0x20,%ebp
  801989:	89 eb                	mov    %ebp,%ebx
  80198b:	29 fb                	sub    %edi,%ebx
  80198d:	89 f9                	mov    %edi,%ecx
  80198f:	d3 e6                	shl    %cl,%esi
  801991:	89 c5                	mov    %eax,%ebp
  801993:	88 d9                	mov    %bl,%cl
  801995:	d3 ed                	shr    %cl,%ebp
  801997:	89 e9                	mov    %ebp,%ecx
  801999:	09 f1                	or     %esi,%ecx
  80199b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80199f:	89 f9                	mov    %edi,%ecx
  8019a1:	d3 e0                	shl    %cl,%eax
  8019a3:	89 c5                	mov    %eax,%ebp
  8019a5:	89 d6                	mov    %edx,%esi
  8019a7:	88 d9                	mov    %bl,%cl
  8019a9:	d3 ee                	shr    %cl,%esi
  8019ab:	89 f9                	mov    %edi,%ecx
  8019ad:	d3 e2                	shl    %cl,%edx
  8019af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019b3:	88 d9                	mov    %bl,%cl
  8019b5:	d3 e8                	shr    %cl,%eax
  8019b7:	09 c2                	or     %eax,%edx
  8019b9:	89 d0                	mov    %edx,%eax
  8019bb:	89 f2                	mov    %esi,%edx
  8019bd:	f7 74 24 0c          	divl   0xc(%esp)
  8019c1:	89 d6                	mov    %edx,%esi
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	f7 e5                	mul    %ebp
  8019c7:	39 d6                	cmp    %edx,%esi
  8019c9:	72 19                	jb     8019e4 <__udivdi3+0xfc>
  8019cb:	74 0b                	je     8019d8 <__udivdi3+0xf0>
  8019cd:	89 d8                	mov    %ebx,%eax
  8019cf:	31 ff                	xor    %edi,%edi
  8019d1:	e9 58 ff ff ff       	jmp    80192e <__udivdi3+0x46>
  8019d6:	66 90                	xchg   %ax,%ax
  8019d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019dc:	89 f9                	mov    %edi,%ecx
  8019de:	d3 e2                	shl    %cl,%edx
  8019e0:	39 c2                	cmp    %eax,%edx
  8019e2:	73 e9                	jae    8019cd <__udivdi3+0xe5>
  8019e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019e7:	31 ff                	xor    %edi,%edi
  8019e9:	e9 40 ff ff ff       	jmp    80192e <__udivdi3+0x46>
  8019ee:	66 90                	xchg   %ax,%ax
  8019f0:	31 c0                	xor    %eax,%eax
  8019f2:	e9 37 ff ff ff       	jmp    80192e <__udivdi3+0x46>
  8019f7:	90                   	nop

008019f8 <__umoddi3>:
  8019f8:	55                   	push   %ebp
  8019f9:	57                   	push   %edi
  8019fa:	56                   	push   %esi
  8019fb:	53                   	push   %ebx
  8019fc:	83 ec 1c             	sub    $0x1c,%esp
  8019ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a03:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a07:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a0b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a0f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a13:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a17:	89 f3                	mov    %esi,%ebx
  801a19:	89 fa                	mov    %edi,%edx
  801a1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a1f:	89 34 24             	mov    %esi,(%esp)
  801a22:	85 c0                	test   %eax,%eax
  801a24:	75 1a                	jne    801a40 <__umoddi3+0x48>
  801a26:	39 f7                	cmp    %esi,%edi
  801a28:	0f 86 a2 00 00 00    	jbe    801ad0 <__umoddi3+0xd8>
  801a2e:	89 c8                	mov    %ecx,%eax
  801a30:	89 f2                	mov    %esi,%edx
  801a32:	f7 f7                	div    %edi
  801a34:	89 d0                	mov    %edx,%eax
  801a36:	31 d2                	xor    %edx,%edx
  801a38:	83 c4 1c             	add    $0x1c,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5f                   	pop    %edi
  801a3e:	5d                   	pop    %ebp
  801a3f:	c3                   	ret    
  801a40:	39 f0                	cmp    %esi,%eax
  801a42:	0f 87 ac 00 00 00    	ja     801af4 <__umoddi3+0xfc>
  801a48:	0f bd e8             	bsr    %eax,%ebp
  801a4b:	83 f5 1f             	xor    $0x1f,%ebp
  801a4e:	0f 84 ac 00 00 00    	je     801b00 <__umoddi3+0x108>
  801a54:	bf 20 00 00 00       	mov    $0x20,%edi
  801a59:	29 ef                	sub    %ebp,%edi
  801a5b:	89 fe                	mov    %edi,%esi
  801a5d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a61:	89 e9                	mov    %ebp,%ecx
  801a63:	d3 e0                	shl    %cl,%eax
  801a65:	89 d7                	mov    %edx,%edi
  801a67:	89 f1                	mov    %esi,%ecx
  801a69:	d3 ef                	shr    %cl,%edi
  801a6b:	09 c7                	or     %eax,%edi
  801a6d:	89 e9                	mov    %ebp,%ecx
  801a6f:	d3 e2                	shl    %cl,%edx
  801a71:	89 14 24             	mov    %edx,(%esp)
  801a74:	89 d8                	mov    %ebx,%eax
  801a76:	d3 e0                	shl    %cl,%eax
  801a78:	89 c2                	mov    %eax,%edx
  801a7a:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a7e:	d3 e0                	shl    %cl,%eax
  801a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a84:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a88:	89 f1                	mov    %esi,%ecx
  801a8a:	d3 e8                	shr    %cl,%eax
  801a8c:	09 d0                	or     %edx,%eax
  801a8e:	d3 eb                	shr    %cl,%ebx
  801a90:	89 da                	mov    %ebx,%edx
  801a92:	f7 f7                	div    %edi
  801a94:	89 d3                	mov    %edx,%ebx
  801a96:	f7 24 24             	mull   (%esp)
  801a99:	89 c6                	mov    %eax,%esi
  801a9b:	89 d1                	mov    %edx,%ecx
  801a9d:	39 d3                	cmp    %edx,%ebx
  801a9f:	0f 82 87 00 00 00    	jb     801b2c <__umoddi3+0x134>
  801aa5:	0f 84 91 00 00 00    	je     801b3c <__umoddi3+0x144>
  801aab:	8b 54 24 04          	mov    0x4(%esp),%edx
  801aaf:	29 f2                	sub    %esi,%edx
  801ab1:	19 cb                	sbb    %ecx,%ebx
  801ab3:	89 d8                	mov    %ebx,%eax
  801ab5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ab9:	d3 e0                	shl    %cl,%eax
  801abb:	89 e9                	mov    %ebp,%ecx
  801abd:	d3 ea                	shr    %cl,%edx
  801abf:	09 d0                	or     %edx,%eax
  801ac1:	89 e9                	mov    %ebp,%ecx
  801ac3:	d3 eb                	shr    %cl,%ebx
  801ac5:	89 da                	mov    %ebx,%edx
  801ac7:	83 c4 1c             	add    $0x1c,%esp
  801aca:	5b                   	pop    %ebx
  801acb:	5e                   	pop    %esi
  801acc:	5f                   	pop    %edi
  801acd:	5d                   	pop    %ebp
  801ace:	c3                   	ret    
  801acf:	90                   	nop
  801ad0:	89 fd                	mov    %edi,%ebp
  801ad2:	85 ff                	test   %edi,%edi
  801ad4:	75 0b                	jne    801ae1 <__umoddi3+0xe9>
  801ad6:	b8 01 00 00 00       	mov    $0x1,%eax
  801adb:	31 d2                	xor    %edx,%edx
  801add:	f7 f7                	div    %edi
  801adf:	89 c5                	mov    %eax,%ebp
  801ae1:	89 f0                	mov    %esi,%eax
  801ae3:	31 d2                	xor    %edx,%edx
  801ae5:	f7 f5                	div    %ebp
  801ae7:	89 c8                	mov    %ecx,%eax
  801ae9:	f7 f5                	div    %ebp
  801aeb:	89 d0                	mov    %edx,%eax
  801aed:	e9 44 ff ff ff       	jmp    801a36 <__umoddi3+0x3e>
  801af2:	66 90                	xchg   %ax,%ax
  801af4:	89 c8                	mov    %ecx,%eax
  801af6:	89 f2                	mov    %esi,%edx
  801af8:	83 c4 1c             	add    $0x1c,%esp
  801afb:	5b                   	pop    %ebx
  801afc:	5e                   	pop    %esi
  801afd:	5f                   	pop    %edi
  801afe:	5d                   	pop    %ebp
  801aff:	c3                   	ret    
  801b00:	3b 04 24             	cmp    (%esp),%eax
  801b03:	72 06                	jb     801b0b <__umoddi3+0x113>
  801b05:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b09:	77 0f                	ja     801b1a <__umoddi3+0x122>
  801b0b:	89 f2                	mov    %esi,%edx
  801b0d:	29 f9                	sub    %edi,%ecx
  801b0f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b13:	89 14 24             	mov    %edx,(%esp)
  801b16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b1a:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b1e:	8b 14 24             	mov    (%esp),%edx
  801b21:	83 c4 1c             	add    $0x1c,%esp
  801b24:	5b                   	pop    %ebx
  801b25:	5e                   	pop    %esi
  801b26:	5f                   	pop    %edi
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    
  801b29:	8d 76 00             	lea    0x0(%esi),%esi
  801b2c:	2b 04 24             	sub    (%esp),%eax
  801b2f:	19 fa                	sbb    %edi,%edx
  801b31:	89 d1                	mov    %edx,%ecx
  801b33:	89 c6                	mov    %eax,%esi
  801b35:	e9 71 ff ff ff       	jmp    801aab <__umoddi3+0xb3>
  801b3a:	66 90                	xchg   %ax,%ax
  801b3c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b40:	72 ea                	jb     801b2c <__umoddi3+0x134>
  801b42:	89 d9                	mov    %ebx,%ecx
  801b44:	e9 62 ff ff ff       	jmp    801aab <__umoddi3+0xb3>
