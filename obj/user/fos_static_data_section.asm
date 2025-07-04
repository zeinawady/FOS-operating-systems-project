
obj/user/fos_static_data_section:     file format elf32-i386


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
  800031:	e8 1b 00 00 00       	call   800051 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

/// Adding array of 20000 integer on user data section
int arr[20000];

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	atomic_cprintf("user data section contains 20,000 integer\n");
  80003e:	83 ec 0c             	sub    $0xc,%esp
  800041:	68 00 1b 80 00       	push   $0x801b00
  800046:	e8 4c 02 00 00       	call   800297 <atomic_cprintf>
  80004b:	83 c4 10             	add    $0x10,%esp
	
	return;	
  80004e:	90                   	nop
}
  80004f:	c9                   	leave  
  800050:	c3                   	ret    

00800051 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  800051:	55                   	push   %ebp
  800052:	89 e5                	mov    %esp,%ebp
  800054:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  800057:	e8 91 12 00 00       	call   8012ed <sys_getenvindex>
  80005c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  80005f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800062:	89 d0                	mov    %edx,%eax
  800064:	c1 e0 02             	shl    $0x2,%eax
  800067:	01 d0                	add    %edx,%eax
  800069:	c1 e0 03             	shl    $0x3,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800075:	01 d0                	add    %edx,%eax
  800077:	c1 e0 02             	shl    $0x2,%eax
  80007a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80007f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800084:	a1 20 30 80 00       	mov    0x803020,%eax
  800089:	8a 40 20             	mov    0x20(%eax),%al
  80008c:	84 c0                	test   %al,%al
  80008e:	74 0d                	je     80009d <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800090:	a1 20 30 80 00       	mov    0x803020,%eax
  800095:	83 c0 20             	add    $0x20,%eax
  800098:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a1:	7e 0a                	jle    8000ad <libmain+0x5c>
		binaryname = argv[0];
  8000a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a6:	8b 00                	mov    (%eax),%eax
  8000a8:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 0c             	pushl  0xc(%ebp)
  8000b3:	ff 75 08             	pushl  0x8(%ebp)
  8000b6:	e8 7d ff ff ff       	call   800038 <_main>
  8000bb:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  8000be:	a1 00 30 80 00       	mov    0x803000,%eax
  8000c3:	85 c0                	test   %eax,%eax
  8000c5:	0f 84 9f 00 00 00    	je     80016a <libmain+0x119>
	{
		sys_lock_cons();
  8000cb:	e8 a1 0f 00 00       	call   801071 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	68 44 1b 80 00       	push   $0x801b44
  8000d8:	e8 8d 01 00 00       	call   80026a <cprintf>
  8000dd:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  8000eb:	a1 20 30 80 00       	mov    0x803020,%eax
  8000f0:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	52                   	push   %edx
  8000fa:	50                   	push   %eax
  8000fb:	68 6c 1b 80 00       	push   $0x801b6c
  800100:	e8 65 01 00 00       	call   80026a <cprintf>
  800105:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800108:	a1 20 30 80 00       	mov    0x803020,%eax
  80010d:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800113:	a1 20 30 80 00       	mov    0x803020,%eax
  800118:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  80011e:	a1 20 30 80 00       	mov    0x803020,%eax
  800123:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  800129:	51                   	push   %ecx
  80012a:	52                   	push   %edx
  80012b:	50                   	push   %eax
  80012c:	68 94 1b 80 00       	push   $0x801b94
  800131:	e8 34 01 00 00       	call   80026a <cprintf>
  800136:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800139:	a1 20 30 80 00       	mov    0x803020,%eax
  80013e:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800144:	83 ec 08             	sub    $0x8,%esp
  800147:	50                   	push   %eax
  800148:	68 ec 1b 80 00       	push   $0x801bec
  80014d:	e8 18 01 00 00       	call   80026a <cprintf>
  800152:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  800155:	83 ec 0c             	sub    $0xc,%esp
  800158:	68 44 1b 80 00       	push   $0x801b44
  80015d:	e8 08 01 00 00       	call   80026a <cprintf>
  800162:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  800165:	e8 21 0f 00 00       	call   80108b <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  80016a:	e8 19 00 00 00       	call   800188 <exit>
}
  80016f:	90                   	nop
  800170:	c9                   	leave  
  800171:	c3                   	ret    

00800172 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800172:	55                   	push   %ebp
  800173:	89 e5                	mov    %esp,%ebp
  800175:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	6a 00                	push   $0x0
  80017d:	e8 37 11 00 00       	call   8012b9 <sys_destroy_env>
  800182:	83 c4 10             	add    $0x10,%esp
}
  800185:	90                   	nop
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <exit>:

void
exit(void)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80018e:	e8 8c 11 00 00       	call   80131f <sys_exit_env>
}
  800193:	90                   	nop
  800194:	c9                   	leave  
  800195:	c3                   	ret    

00800196 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800196:	55                   	push   %ebp
  800197:	89 e5                	mov    %esp,%ebp
  800199:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8001a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a7:	89 0a                	mov    %ecx,(%edx)
  8001a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ac:	88 d1                	mov    %dl,%cl
  8001ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8001b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001b8:	8b 00                	mov    (%eax),%eax
  8001ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bf:	75 2c                	jne    8001ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8001c1:	a0 c0 68 81 00       	mov    0x8168c0,%al
  8001c6:	0f b6 c0             	movzbl %al,%eax
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	8b 12                	mov    (%edx),%edx
  8001ce:	89 d1                	mov    %edx,%ecx
  8001d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d3:	83 c2 08             	add    $0x8,%edx
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	50                   	push   %eax
  8001da:	51                   	push   %ecx
  8001db:	52                   	push   %edx
  8001dc:	e8 4e 0e 00 00       	call   80102f <sys_cputs>
  8001e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8001ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f0:	8b 40 04             	mov    0x4(%eax),%eax
  8001f3:	8d 50 01             	lea    0x1(%eax),%edx
  8001f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8001fc:	90                   	nop
  8001fd:	c9                   	leave  
  8001fe:	c3                   	ret    

008001ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8001ff:	55                   	push   %ebp
  800200:	89 e5                	mov    %esp,%ebp
  800202:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800208:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020f:	00 00 00 
	b.cnt = 0;
  800212:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800219:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80021c:	ff 75 0c             	pushl  0xc(%ebp)
  80021f:	ff 75 08             	pushl  0x8(%ebp)
  800222:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800228:	50                   	push   %eax
  800229:	68 96 01 80 00       	push   $0x800196
  80022e:	e8 11 02 00 00       	call   800444 <vprintfmt>
  800233:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800236:	a0 c0 68 81 00       	mov    0x8168c0,%al
  80023b:	0f b6 c0             	movzbl %al,%eax
  80023e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800244:	83 ec 04             	sub    $0x4,%esp
  800247:	50                   	push   %eax
  800248:	52                   	push   %edx
  800249:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024f:	83 c0 08             	add    $0x8,%eax
  800252:	50                   	push   %eax
  800253:	e8 d7 0d 00 00       	call   80102f <sys_cputs>
  800258:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80025b:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
	return b.cnt;
  800262:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800268:	c9                   	leave  
  800269:	c3                   	ret    

0080026a <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800270:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
	va_start(ap, fmt);
  800277:	8d 45 0c             	lea    0xc(%ebp),%eax
  80027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80027d:	8b 45 08             	mov    0x8(%ebp),%eax
  800280:	83 ec 08             	sub    $0x8,%esp
  800283:	ff 75 f4             	pushl  -0xc(%ebp)
  800286:	50                   	push   %eax
  800287:	e8 73 ff ff ff       	call   8001ff <vcprintf>
  80028c:	83 c4 10             	add    $0x10,%esp
  80028f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800292:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800295:	c9                   	leave  
  800296:	c3                   	ret    

00800297 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80029d:	e8 cf 0d 00 00       	call   801071 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ab:	83 ec 08             	sub    $0x8,%esp
  8002ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8002b1:	50                   	push   %eax
  8002b2:	e8 48 ff ff ff       	call   8001ff <vcprintf>
  8002b7:	83 c4 10             	add    $0x10,%esp
  8002ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  8002bd:	e8 c9 0d 00 00       	call   80108b <sys_unlock_cons>
	return cnt;
  8002c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002c5:	c9                   	leave  
  8002c6:	c3                   	ret    

008002c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002c7:	55                   	push   %ebp
  8002c8:	89 e5                	mov    %esp,%ebp
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 14             	sub    $0x14,%esp
  8002ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8002d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002da:	8b 45 18             	mov    0x18(%ebp),%eax
  8002dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002e5:	77 55                	ja     80033c <printnum+0x75>
  8002e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8002ea:	72 05                	jb     8002f1 <printnum+0x2a>
  8002ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002ef:	77 4b                	ja     80033c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8002f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8002fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8002ff:	52                   	push   %edx
  800300:	50                   	push   %eax
  800301:	ff 75 f4             	pushl  -0xc(%ebp)
  800304:	ff 75 f0             	pushl  -0x10(%ebp)
  800307:	e8 80 15 00 00       	call   80188c <__udivdi3>
  80030c:	83 c4 10             	add    $0x10,%esp
  80030f:	83 ec 04             	sub    $0x4,%esp
  800312:	ff 75 20             	pushl  0x20(%ebp)
  800315:	53                   	push   %ebx
  800316:	ff 75 18             	pushl  0x18(%ebp)
  800319:	52                   	push   %edx
  80031a:	50                   	push   %eax
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 a1 ff ff ff       	call   8002c7 <printnum>
  800326:	83 c4 20             	add    $0x20,%esp
  800329:	eb 1a                	jmp    800345 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80032b:	83 ec 08             	sub    $0x8,%esp
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 20             	pushl  0x20(%ebp)
  800334:	8b 45 08             	mov    0x8(%ebp),%eax
  800337:	ff d0                	call   *%eax
  800339:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033c:	ff 4d 1c             	decl   0x1c(%ebp)
  80033f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800343:	7f e6                	jg     80032b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800345:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800348:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800350:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800353:	53                   	push   %ebx
  800354:	51                   	push   %ecx
  800355:	52                   	push   %edx
  800356:	50                   	push   %eax
  800357:	e8 40 16 00 00       	call   80199c <__umoddi3>
  80035c:	83 c4 10             	add    $0x10,%esp
  80035f:	05 14 1e 80 00       	add    $0x801e14,%eax
  800364:	8a 00                	mov    (%eax),%al
  800366:	0f be c0             	movsbl %al,%eax
  800369:	83 ec 08             	sub    $0x8,%esp
  80036c:	ff 75 0c             	pushl  0xc(%ebp)
  80036f:	50                   	push   %eax
  800370:	8b 45 08             	mov    0x8(%ebp),%eax
  800373:	ff d0                	call   *%eax
  800375:	83 c4 10             	add    $0x10,%esp
}
  800378:	90                   	nop
  800379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800381:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800385:	7e 1c                	jle    8003a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	8b 00                	mov    (%eax),%eax
  80038c:	8d 50 08             	lea    0x8(%eax),%edx
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	89 10                	mov    %edx,(%eax)
  800394:	8b 45 08             	mov    0x8(%ebp),%eax
  800397:	8b 00                	mov    (%eax),%eax
  800399:	83 e8 08             	sub    $0x8,%eax
  80039c:	8b 50 04             	mov    0x4(%eax),%edx
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	eb 40                	jmp    8003e3 <getuint+0x65>
	else if (lflag)
  8003a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003a7:	74 1e                	je     8003c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	8d 50 04             	lea    0x4(%eax),%edx
  8003b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b4:	89 10                	mov    %edx,(%eax)
  8003b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	83 e8 04             	sub    $0x4,%eax
  8003be:	8b 00                	mov    (%eax),%eax
  8003c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8003c5:	eb 1c                	jmp    8003e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8003c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	8d 50 04             	lea    0x4(%eax),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	89 10                	mov    %edx,(%eax)
  8003d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d7:	8b 00                	mov    (%eax),%eax
  8003d9:	83 e8 04             	sub    $0x4,%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003e3:	5d                   	pop    %ebp
  8003e4:	c3                   	ret    

008003e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8003e5:	55                   	push   %ebp
  8003e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003ec:	7e 1c                	jle    80040a <getint+0x25>
		return va_arg(*ap, long long);
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	8d 50 08             	lea    0x8(%eax),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	89 10                	mov    %edx,(%eax)
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	83 e8 08             	sub    $0x8,%eax
  800403:	8b 50 04             	mov    0x4(%eax),%edx
  800406:	8b 00                	mov    (%eax),%eax
  800408:	eb 38                	jmp    800442 <getint+0x5d>
	else if (lflag)
  80040a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80040e:	74 1a                	je     80042a <getint+0x45>
		return va_arg(*ap, long);
  800410:	8b 45 08             	mov    0x8(%ebp),%eax
  800413:	8b 00                	mov    (%eax),%eax
  800415:	8d 50 04             	lea    0x4(%eax),%edx
  800418:	8b 45 08             	mov    0x8(%ebp),%eax
  80041b:	89 10                	mov    %edx,(%eax)
  80041d:	8b 45 08             	mov    0x8(%ebp),%eax
  800420:	8b 00                	mov    (%eax),%eax
  800422:	83 e8 04             	sub    $0x4,%eax
  800425:	8b 00                	mov    (%eax),%eax
  800427:	99                   	cltd   
  800428:	eb 18                	jmp    800442 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80042a:	8b 45 08             	mov    0x8(%ebp),%eax
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	8d 50 04             	lea    0x4(%eax),%edx
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 10                	mov    %edx,(%eax)
  800437:	8b 45 08             	mov    0x8(%ebp),%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	83 e8 04             	sub    $0x4,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	99                   	cltd   
}
  800442:	5d                   	pop    %ebp
  800443:	c3                   	ret    

00800444 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	56                   	push   %esi
  800448:	53                   	push   %ebx
  800449:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80044c:	eb 17                	jmp    800465 <vprintfmt+0x21>
			if (ch == '\0')
  80044e:	85 db                	test   %ebx,%ebx
  800450:	0f 84 c1 03 00 00    	je     800817 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  800456:	83 ec 08             	sub    $0x8,%esp
  800459:	ff 75 0c             	pushl  0xc(%ebp)
  80045c:	53                   	push   %ebx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	ff d0                	call   *%eax
  800462:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800465:	8b 45 10             	mov    0x10(%ebp),%eax
  800468:	8d 50 01             	lea    0x1(%eax),%edx
  80046b:	89 55 10             	mov    %edx,0x10(%ebp)
  80046e:	8a 00                	mov    (%eax),%al
  800470:	0f b6 d8             	movzbl %al,%ebx
  800473:	83 fb 25             	cmp    $0x25,%ebx
  800476:	75 d6                	jne    80044e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800478:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80047c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800483:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80048a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800491:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800498:	8b 45 10             	mov    0x10(%ebp),%eax
  80049b:	8d 50 01             	lea    0x1(%eax),%edx
  80049e:	89 55 10             	mov    %edx,0x10(%ebp)
  8004a1:	8a 00                	mov    (%eax),%al
  8004a3:	0f b6 d8             	movzbl %al,%ebx
  8004a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004a9:	83 f8 5b             	cmp    $0x5b,%eax
  8004ac:	0f 87 3d 03 00 00    	ja     8007ef <vprintfmt+0x3ab>
  8004b2:	8b 04 85 38 1e 80 00 	mov    0x801e38(,%eax,4),%eax
  8004b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8004bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8004bf:	eb d7                	jmp    800498 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8004c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8004c5:	eb d1                	jmp    800498 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8004ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d1:	89 d0                	mov    %edx,%eax
  8004d3:	c1 e0 02             	shl    $0x2,%eax
  8004d6:	01 d0                	add    %edx,%eax
  8004d8:	01 c0                	add    %eax,%eax
  8004da:	01 d8                	add    %ebx,%eax
  8004dc:	83 e8 30             	sub    $0x30,%eax
  8004df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8004e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e5:	8a 00                	mov    (%eax),%al
  8004e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8004ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8004ed:	7e 3e                	jle    80052d <vprintfmt+0xe9>
  8004ef:	83 fb 39             	cmp    $0x39,%ebx
  8004f2:	7f 39                	jg     80052d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004f7:	eb d5                	jmp    8004ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	83 c0 04             	add    $0x4,%eax
  8004ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800502:	8b 45 14             	mov    0x14(%ebp),%eax
  800505:	83 e8 04             	sub    $0x4,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80050d:	eb 1f                	jmp    80052e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80050f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800513:	79 83                	jns    800498 <vprintfmt+0x54>
				width = 0;
  800515:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80051c:	e9 77 ff ff ff       	jmp    800498 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800521:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800528:	e9 6b ff ff ff       	jmp    800498 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80052d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80052e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800532:	0f 89 60 ff ff ff    	jns    800498 <vprintfmt+0x54>
				width = precision, precision = -1;
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800545:	e9 4e ff ff ff       	jmp    800498 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80054a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80054d:	e9 46 ff ff ff       	jmp    800498 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	83 c0 04             	add    $0x4,%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
  80055b:	8b 45 14             	mov    0x14(%ebp),%eax
  80055e:	83 e8 04             	sub    $0x4,%eax
  800561:	8b 00                	mov    (%eax),%eax
  800563:	83 ec 08             	sub    $0x8,%esp
  800566:	ff 75 0c             	pushl  0xc(%ebp)
  800569:	50                   	push   %eax
  80056a:	8b 45 08             	mov    0x8(%ebp),%eax
  80056d:	ff d0                	call   *%eax
  80056f:	83 c4 10             	add    $0x10,%esp
			break;
  800572:	e9 9b 02 00 00       	jmp    800812 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800577:	8b 45 14             	mov    0x14(%ebp),%eax
  80057a:	83 c0 04             	add    $0x4,%eax
  80057d:	89 45 14             	mov    %eax,0x14(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	83 e8 04             	sub    $0x4,%eax
  800586:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800588:	85 db                	test   %ebx,%ebx
  80058a:	79 02                	jns    80058e <vprintfmt+0x14a>
				err = -err;
  80058c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80058e:	83 fb 64             	cmp    $0x64,%ebx
  800591:	7f 0b                	jg     80059e <vprintfmt+0x15a>
  800593:	8b 34 9d 80 1c 80 00 	mov    0x801c80(,%ebx,4),%esi
  80059a:	85 f6                	test   %esi,%esi
  80059c:	75 19                	jne    8005b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80059e:	53                   	push   %ebx
  80059f:	68 25 1e 80 00       	push   $0x801e25
  8005a4:	ff 75 0c             	pushl  0xc(%ebp)
  8005a7:	ff 75 08             	pushl  0x8(%ebp)
  8005aa:	e8 70 02 00 00       	call   80081f <printfmt>
  8005af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8005b2:	e9 5b 02 00 00       	jmp    800812 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005b7:	56                   	push   %esi
  8005b8:	68 2e 1e 80 00       	push   $0x801e2e
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 57 02 00 00       	call   80081f <printfmt>
  8005c8:	83 c4 10             	add    $0x10,%esp
			break;
  8005cb:	e9 42 02 00 00       	jmp    800812 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	83 c0 04             	add    $0x4,%eax
  8005d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	83 e8 04             	sub    $0x4,%eax
  8005df:	8b 30                	mov    (%eax),%esi
  8005e1:	85 f6                	test   %esi,%esi
  8005e3:	75 05                	jne    8005ea <vprintfmt+0x1a6>
				p = "(null)";
  8005e5:	be 31 1e 80 00       	mov    $0x801e31,%esi
			if (width > 0 && padc != '-')
  8005ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005ee:	7e 6d                	jle    80065d <vprintfmt+0x219>
  8005f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8005f4:	74 67                	je     80065d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	50                   	push   %eax
  8005fd:	56                   	push   %esi
  8005fe:	e8 1e 03 00 00       	call   800921 <strnlen>
  800603:	83 c4 10             	add    $0x10,%esp
  800606:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800609:	eb 16                	jmp    800621 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80060b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80060f:	83 ec 08             	sub    $0x8,%esp
  800612:	ff 75 0c             	pushl  0xc(%ebp)
  800615:	50                   	push   %eax
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	ff d0                	call   *%eax
  80061b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80061e:	ff 4d e4             	decl   -0x1c(%ebp)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	7f e4                	jg     80060b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800627:	eb 34                	jmp    80065d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800629:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80062d:	74 1c                	je     80064b <vprintfmt+0x207>
  80062f:	83 fb 1f             	cmp    $0x1f,%ebx
  800632:	7e 05                	jle    800639 <vprintfmt+0x1f5>
  800634:	83 fb 7e             	cmp    $0x7e,%ebx
  800637:	7e 12                	jle    80064b <vprintfmt+0x207>
					putch('?', putdat);
  800639:	83 ec 08             	sub    $0x8,%esp
  80063c:	ff 75 0c             	pushl  0xc(%ebp)
  80063f:	6a 3f                	push   $0x3f
  800641:	8b 45 08             	mov    0x8(%ebp),%eax
  800644:	ff d0                	call   *%eax
  800646:	83 c4 10             	add    $0x10,%esp
  800649:	eb 0f                	jmp    80065a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	53                   	push   %ebx
  800652:	8b 45 08             	mov    0x8(%ebp),%eax
  800655:	ff d0                	call   *%eax
  800657:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065a:	ff 4d e4             	decl   -0x1c(%ebp)
  80065d:	89 f0                	mov    %esi,%eax
  80065f:	8d 70 01             	lea    0x1(%eax),%esi
  800662:	8a 00                	mov    (%eax),%al
  800664:	0f be d8             	movsbl %al,%ebx
  800667:	85 db                	test   %ebx,%ebx
  800669:	74 24                	je     80068f <vprintfmt+0x24b>
  80066b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80066f:	78 b8                	js     800629 <vprintfmt+0x1e5>
  800671:	ff 4d e0             	decl   -0x20(%ebp)
  800674:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800678:	79 af                	jns    800629 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067a:	eb 13                	jmp    80068f <vprintfmt+0x24b>
				putch(' ', putdat);
  80067c:	83 ec 08             	sub    $0x8,%esp
  80067f:	ff 75 0c             	pushl  0xc(%ebp)
  800682:	6a 20                	push   $0x20
  800684:	8b 45 08             	mov    0x8(%ebp),%eax
  800687:	ff d0                	call   *%eax
  800689:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80068c:	ff 4d e4             	decl   -0x1c(%ebp)
  80068f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800693:	7f e7                	jg     80067c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800695:	e9 78 01 00 00       	jmp    800812 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	ff 75 e8             	pushl  -0x18(%ebp)
  8006a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a3:	50                   	push   %eax
  8006a4:	e8 3c fd ff ff       	call   8003e5 <getint>
  8006a9:	83 c4 10             	add    $0x10,%esp
  8006ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8006b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b8:	85 d2                	test   %edx,%edx
  8006ba:	79 23                	jns    8006df <vprintfmt+0x29b>
				putch('-', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	ff 75 0c             	pushl  0xc(%ebp)
  8006c2:	6a 2d                	push   $0x2d
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	ff d0                	call   *%eax
  8006c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	f7 d8                	neg    %eax
  8006d4:	83 d2 00             	adc    $0x0,%edx
  8006d7:	f7 da                	neg    %edx
  8006d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8006df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8006e6:	e9 bc 00 00 00       	jmp    8007a7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006eb:	83 ec 08             	sub    $0x8,%esp
  8006ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f4:	50                   	push   %eax
  8006f5:	e8 84 fc ff ff       	call   80037e <getuint>
  8006fa:	83 c4 10             	add    $0x10,%esp
  8006fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800700:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800703:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80070a:	e9 98 00 00 00       	jmp    8007a7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	ff 75 0c             	pushl  0xc(%ebp)
  800715:	6a 58                	push   $0x58
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	ff d0                	call   *%eax
  80071c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	6a 58                	push   $0x58
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80072f:	83 ec 08             	sub    $0x8,%esp
  800732:	ff 75 0c             	pushl  0xc(%ebp)
  800735:	6a 58                	push   $0x58
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
			break;
  80073f:	e9 ce 00 00 00       	jmp    800812 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	6a 30                	push   $0x30
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	ff d0                	call   *%eax
  800751:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800754:	83 ec 08             	sub    $0x8,%esp
  800757:	ff 75 0c             	pushl  0xc(%ebp)
  80075a:	6a 78                	push   $0x78
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	ff d0                	call   *%eax
  800761:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800764:	8b 45 14             	mov    0x14(%ebp),%eax
  800767:	83 c0 04             	add    $0x4,%eax
  80076a:	89 45 14             	mov    %eax,0x14(%ebp)
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	83 e8 04             	sub    $0x4,%eax
  800773:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800775:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800778:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80077f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800786:	eb 1f                	jmp    8007a7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800788:	83 ec 08             	sub    $0x8,%esp
  80078b:	ff 75 e8             	pushl  -0x18(%ebp)
  80078e:	8d 45 14             	lea    0x14(%ebp),%eax
  800791:	50                   	push   %eax
  800792:	e8 e7 fb ff ff       	call   80037e <getuint>
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80079d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007a7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ae:	83 ec 04             	sub    $0x4,%esp
  8007b1:	52                   	push   %edx
  8007b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	ff 75 08             	pushl  0x8(%ebp)
  8007c2:	e8 00 fb ff ff       	call   8002c7 <printnum>
  8007c7:	83 c4 20             	add    $0x20,%esp
			break;
  8007ca:	eb 46                	jmp    800812 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007cc:	83 ec 08             	sub    $0x8,%esp
  8007cf:	ff 75 0c             	pushl  0xc(%ebp)
  8007d2:	53                   	push   %ebx
  8007d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d6:	ff d0                	call   *%eax
  8007d8:	83 c4 10             	add    $0x10,%esp
			break;
  8007db:	eb 35                	jmp    800812 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  8007dd:	c6 05 c0 68 81 00 00 	movb   $0x0,0x8168c0
			break;
  8007e4:	eb 2c                	jmp    800812 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  8007e6:	c6 05 c0 68 81 00 01 	movb   $0x1,0x8168c0
			break;
  8007ed:	eb 23                	jmp    800812 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ef:	83 ec 08             	sub    $0x8,%esp
  8007f2:	ff 75 0c             	pushl  0xc(%ebp)
  8007f5:	6a 25                	push   $0x25
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	ff d0                	call   *%eax
  8007fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007ff:	ff 4d 10             	decl   0x10(%ebp)
  800802:	eb 03                	jmp    800807 <vprintfmt+0x3c3>
  800804:	ff 4d 10             	decl   0x10(%ebp)
  800807:	8b 45 10             	mov    0x10(%ebp),%eax
  80080a:	48                   	dec    %eax
  80080b:	8a 00                	mov    (%eax),%al
  80080d:	3c 25                	cmp    $0x25,%al
  80080f:	75 f3                	jne    800804 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800811:	90                   	nop
		}
	}
  800812:	e9 35 fc ff ff       	jmp    80044c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800817:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800818:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80081b:	5b                   	pop    %ebx
  80081c:	5e                   	pop    %esi
  80081d:	5d                   	pop    %ebp
  80081e:	c3                   	ret    

0080081f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800825:	8d 45 10             	lea    0x10(%ebp),%eax
  800828:	83 c0 04             	add    $0x4,%eax
  80082b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80082e:	8b 45 10             	mov    0x10(%ebp),%eax
  800831:	ff 75 f4             	pushl  -0xc(%ebp)
  800834:	50                   	push   %eax
  800835:	ff 75 0c             	pushl  0xc(%ebp)
  800838:	ff 75 08             	pushl  0x8(%ebp)
  80083b:	e8 04 fc ff ff       	call   800444 <vprintfmt>
  800840:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800843:	90                   	nop
  800844:	c9                   	leave  
  800845:	c3                   	ret    

00800846 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800846:	55                   	push   %ebp
  800847:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800849:	8b 45 0c             	mov    0xc(%ebp),%eax
  80084c:	8b 40 08             	mov    0x8(%eax),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	8b 45 0c             	mov    0xc(%ebp),%eax
  800855:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800858:	8b 45 0c             	mov    0xc(%ebp),%eax
  80085b:	8b 10                	mov    (%eax),%edx
  80085d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800860:	8b 40 04             	mov    0x4(%eax),%eax
  800863:	39 c2                	cmp    %eax,%edx
  800865:	73 12                	jae    800879 <sprintputch+0x33>
		*b->buf++ = ch;
  800867:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	8d 48 01             	lea    0x1(%eax),%ecx
  80086f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800872:	89 0a                	mov    %ecx,(%edx)
  800874:	8b 55 08             	mov    0x8(%ebp),%edx
  800877:	88 10                	mov    %dl,(%eax)
}
  800879:	90                   	nop
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80088e:	8b 45 08             	mov    0x8(%ebp),%eax
  800891:	01 d0                	add    %edx,%eax
  800893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80089d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008a1:	74 06                	je     8008a9 <vsnprintf+0x2d>
  8008a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a7:	7f 07                	jg     8008b0 <vsnprintf+0x34>
		return -E_INVAL;
  8008a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8008ae:	eb 20                	jmp    8008d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008b0:	ff 75 14             	pushl  0x14(%ebp)
  8008b3:	ff 75 10             	pushl  0x10(%ebp)
  8008b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008b9:	50                   	push   %eax
  8008ba:	68 46 08 80 00       	push   $0x800846
  8008bf:	e8 80 fb ff ff       	call   800444 <vprintfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8008c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008d0:	c9                   	leave  
  8008d1:	c3                   	ret    

008008d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008d2:	55                   	push   %ebp
  8008d3:	89 e5                	mov    %esp,%ebp
  8008d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8008db:	83 c0 04             	add    $0x4,%eax
  8008de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8008e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8008e7:	50                   	push   %eax
  8008e8:	ff 75 0c             	pushl  0xc(%ebp)
  8008eb:	ff 75 08             	pushl  0x8(%ebp)
  8008ee:	e8 89 ff ff ff       	call   80087c <vsnprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
  8008f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8008f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800904:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80090b:	eb 06                	jmp    800913 <strlen+0x15>
		n++;
  80090d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800910:	ff 45 08             	incl   0x8(%ebp)
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	8a 00                	mov    (%eax),%al
  800918:	84 c0                	test   %al,%al
  80091a:	75 f1                	jne    80090d <strlen+0xf>
		n++;
	return n;
  80091c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80091f:	c9                   	leave  
  800920:	c3                   	ret    

00800921 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800927:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80092e:	eb 09                	jmp    800939 <strnlen+0x18>
		n++;
  800930:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800933:	ff 45 08             	incl   0x8(%ebp)
  800936:	ff 4d 0c             	decl   0xc(%ebp)
  800939:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093d:	74 09                	je     800948 <strnlen+0x27>
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8a 00                	mov    (%eax),%al
  800944:	84 c0                	test   %al,%al
  800946:	75 e8                	jne    800930 <strnlen+0xf>
		n++;
	return n;
  800948:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80094b:	c9                   	leave  
  80094c:	c3                   	ret    

0080094d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800959:	90                   	nop
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	8d 50 01             	lea    0x1(%eax),%edx
  800960:	89 55 08             	mov    %edx,0x8(%ebp)
  800963:	8b 55 0c             	mov    0xc(%ebp),%edx
  800966:	8d 4a 01             	lea    0x1(%edx),%ecx
  800969:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80096c:	8a 12                	mov    (%edx),%dl
  80096e:	88 10                	mov    %dl,(%eax)
  800970:	8a 00                	mov    (%eax),%al
  800972:	84 c0                	test   %al,%al
  800974:	75 e4                	jne    80095a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800976:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800987:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80098e:	eb 1f                	jmp    8009af <strncpy+0x34>
		*dst++ = *src;
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	8d 50 01             	lea    0x1(%eax),%edx
  800996:	89 55 08             	mov    %edx,0x8(%ebp)
  800999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099c:	8a 12                	mov    (%edx),%dl
  80099e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a3:	8a 00                	mov    (%eax),%al
  8009a5:	84 c0                	test   %al,%al
  8009a7:	74 03                	je     8009ac <strncpy+0x31>
			src++;
  8009a9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ac:	ff 45 fc             	incl   -0x4(%ebp)
  8009af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8009b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8009b5:	72 d9                	jb     800990 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8009b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8009ba:	c9                   	leave  
  8009bb:	c3                   	ret    

008009bc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8009c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009cc:	74 30                	je     8009fe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8009ce:	eb 16                	jmp    8009e6 <strlcpy+0x2a>
			*dst++ = *src++;
  8009d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d3:	8d 50 01             	lea    0x1(%eax),%edx
  8009d6:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009df:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009e2:	8a 12                	mov    (%edx),%dl
  8009e4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e6:	ff 4d 10             	decl   0x10(%ebp)
  8009e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009ed:	74 09                	je     8009f8 <strlcpy+0x3c>
  8009ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f2:	8a 00                	mov    (%eax),%al
  8009f4:	84 c0                	test   %al,%al
  8009f6:	75 d8                	jne    8009d0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a04:	29 c2                	sub    %eax,%edx
  800a06:	89 d0                	mov    %edx,%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a0d:	eb 06                	jmp    800a15 <strcmp+0xb>
		p++, q++;
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8a 00                	mov    (%eax),%al
  800a1a:	84 c0                	test   %al,%al
  800a1c:	74 0e                	je     800a2c <strcmp+0x22>
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	8a 10                	mov    (%eax),%dl
  800a23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a26:	8a 00                	mov    (%eax),%al
  800a28:	38 c2                	cmp    %al,%dl
  800a2a:	74 e3                	je     800a0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	8a 00                	mov    (%eax),%al
  800a31:	0f b6 d0             	movzbl %al,%edx
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	8a 00                	mov    (%eax),%al
  800a39:	0f b6 c0             	movzbl %al,%eax
  800a3c:	29 c2                	sub    %eax,%edx
  800a3e:	89 d0                	mov    %edx,%eax
}
  800a40:	5d                   	pop    %ebp
  800a41:	c3                   	ret    

00800a42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a42:	55                   	push   %ebp
  800a43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a45:	eb 09                	jmp    800a50 <strncmp+0xe>
		n--, p++, q++;
  800a47:	ff 4d 10             	decl   0x10(%ebp)
  800a4a:	ff 45 08             	incl   0x8(%ebp)
  800a4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a54:	74 17                	je     800a6d <strncmp+0x2b>
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	8a 00                	mov    (%eax),%al
  800a5b:	84 c0                	test   %al,%al
  800a5d:	74 0e                	je     800a6d <strncmp+0x2b>
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8a 10                	mov    (%eax),%dl
  800a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	38 c2                	cmp    %al,%dl
  800a6b:	74 da                	je     800a47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800a6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a71:	75 07                	jne    800a7a <strncmp+0x38>
		return 0;
  800a73:	b8 00 00 00 00       	mov    $0x0,%eax
  800a78:	eb 14                	jmp    800a8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f b6 d0             	movzbl %al,%edx
  800a82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a85:	8a 00                	mov    (%eax),%al
  800a87:	0f b6 c0             	movzbl %al,%eax
  800a8a:	29 c2                	sub    %eax,%edx
  800a8c:	89 d0                	mov    %edx,%eax
}
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800a9c:	eb 12                	jmp    800ab0 <strchr+0x20>
		if (*s == c)
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8a 00                	mov    (%eax),%al
  800aa3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800aa6:	75 05                	jne    800aad <strchr+0x1d>
			return (char *) s;
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	eb 11                	jmp    800abe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aad:	ff 45 08             	incl   0x8(%ebp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	8a 00                	mov    (%eax),%al
  800ab5:	84 c0                	test   %al,%al
  800ab7:	75 e5                	jne    800a9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abe:	c9                   	leave  
  800abf:	c3                   	ret    

00800ac0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	83 ec 04             	sub    $0x4,%esp
  800ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800acc:	eb 0d                	jmp    800adb <strfind+0x1b>
		if (*s == c)
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8a 00                	mov    (%eax),%al
  800ad3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ad6:	74 0e                	je     800ae6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ad8:	ff 45 08             	incl   0x8(%ebp)
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	84 c0                	test   %al,%al
  800ae2:	75 ea                	jne    800ace <strfind+0xe>
  800ae4:	eb 01                	jmp    800ae7 <strfind+0x27>
		if (*s == c)
			break;
  800ae6:	90                   	nop
	return (char *) s;
  800ae7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800af8:	8b 45 10             	mov    0x10(%ebp),%eax
  800afb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800afe:	eb 0e                	jmp    800b0e <memset+0x22>
		*p++ = c;
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	8d 50 01             	lea    0x1(%eax),%edx
  800b06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b0e:	ff 4d f8             	decl   -0x8(%ebp)
  800b11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b15:	79 e9                	jns    800b00 <memset+0x14>
		*p++ = c;

	return v;
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b1a:	c9                   	leave  
  800b1b:	c3                   	ret    

00800b1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800b2e:	eb 16                	jmp    800b46 <memcpy+0x2a>
		*d++ = *s++;
  800b30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b33:	8d 50 01             	lea    0x1(%eax),%edx
  800b36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b42:	8a 12                	mov    (%edx),%dl
  800b44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b46:	8b 45 10             	mov    0x10(%ebp),%eax
  800b49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800b4f:	85 c0                	test   %eax,%eax
  800b51:	75 dd                	jne    800b30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b56:	c9                   	leave  
  800b57:	c3                   	ret    

00800b58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800b6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b70:	73 50                	jae    800bc2 <memmove+0x6a>
  800b72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b75:	8b 45 10             	mov    0x10(%ebp),%eax
  800b78:	01 d0                	add    %edx,%eax
  800b7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800b7d:	76 43                	jbe    800bc2 <memmove+0x6a>
		s += n;
  800b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800b85:	8b 45 10             	mov    0x10(%ebp),%eax
  800b88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800b8b:	eb 10                	jmp    800b9d <memmove+0x45>
			*--d = *--s;
  800b8d:	ff 4d f8             	decl   -0x8(%ebp)
  800b90:	ff 4d fc             	decl   -0x4(%ebp)
  800b93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b96:	8a 10                	mov    (%eax),%dl
  800b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800b9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ba3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba6:	85 c0                	test   %eax,%eax
  800ba8:	75 e3                	jne    800b8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800baa:	eb 23                	jmp    800bcf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800baf:	8d 50 01             	lea    0x1(%eax),%edx
  800bb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bbe:	8a 12                	mov    (%edx),%dl
  800bc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcb:	85 c0                	test   %eax,%eax
  800bcd:	75 dd                	jne    800bac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800be0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800be6:	eb 2a                	jmp    800c12 <memcmp+0x3e>
		if (*s1 != *s2)
  800be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800beb:	8a 10                	mov    (%eax),%dl
  800bed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bf0:	8a 00                	mov    (%eax),%al
  800bf2:	38 c2                	cmp    %al,%dl
  800bf4:	74 16                	je     800c0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	0f b6 d0             	movzbl %al,%edx
  800bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c01:	8a 00                	mov    (%eax),%al
  800c03:	0f b6 c0             	movzbl %al,%eax
  800c06:	29 c2                	sub    %eax,%edx
  800c08:	89 d0                	mov    %edx,%eax
  800c0a:	eb 18                	jmp    800c24 <memcmp+0x50>
		s1++, s2++;
  800c0c:	ff 45 fc             	incl   -0x4(%ebp)
  800c0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
  800c15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c18:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1b:	85 c0                	test   %eax,%eax
  800c1d:	75 c9                	jne    800be8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	01 d0                	add    %edx,%eax
  800c34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c37:	eb 15                	jmp    800c4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8a 00                	mov    (%eax),%al
  800c3e:	0f b6 d0             	movzbl %al,%edx
  800c41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c44:	0f b6 c0             	movzbl %al,%eax
  800c47:	39 c2                	cmp    %eax,%edx
  800c49:	74 0d                	je     800c58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c4b:	ff 45 08             	incl   0x8(%ebp)
  800c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800c54:	72 e3                	jb     800c39 <memfind+0x13>
  800c56:	eb 01                	jmp    800c59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800c58:	90                   	nop
	return (void *) s;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800c64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800c6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c72:	eb 03                	jmp    800c77 <strtol+0x19>
		s++;
  800c74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c77:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7a:	8a 00                	mov    (%eax),%al
  800c7c:	3c 20                	cmp    $0x20,%al
  800c7e:	74 f4                	je     800c74 <strtol+0x16>
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	3c 09                	cmp    $0x9,%al
  800c87:	74 eb                	je     800c74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	8a 00                	mov    (%eax),%al
  800c8e:	3c 2b                	cmp    $0x2b,%al
  800c90:	75 05                	jne    800c97 <strtol+0x39>
		s++;
  800c92:	ff 45 08             	incl   0x8(%ebp)
  800c95:	eb 13                	jmp    800caa <strtol+0x4c>
	else if (*s == '-')
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	8a 00                	mov    (%eax),%al
  800c9c:	3c 2d                	cmp    $0x2d,%al
  800c9e:	75 0a                	jne    800caa <strtol+0x4c>
		s++, neg = 1;
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800caa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cae:	74 06                	je     800cb6 <strtol+0x58>
  800cb0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800cb4:	75 20                	jne    800cd6 <strtol+0x78>
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	3c 30                	cmp    $0x30,%al
  800cbd:	75 17                	jne    800cd6 <strtol+0x78>
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	40                   	inc    %eax
  800cc3:	8a 00                	mov    (%eax),%al
  800cc5:	3c 78                	cmp    $0x78,%al
  800cc7:	75 0d                	jne    800cd6 <strtol+0x78>
		s += 2, base = 16;
  800cc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800ccd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800cd4:	eb 28                	jmp    800cfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800cd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cda:	75 15                	jne    800cf1 <strtol+0x93>
  800cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdf:	8a 00                	mov    (%eax),%al
  800ce1:	3c 30                	cmp    $0x30,%al
  800ce3:	75 0c                	jne    800cf1 <strtol+0x93>
		s++, base = 8;
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800cef:	eb 0d                	jmp    800cfe <strtol+0xa0>
	else if (base == 0)
  800cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf5:	75 07                	jne    800cfe <strtol+0xa0>
		base = 10;
  800cf7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	3c 2f                	cmp    $0x2f,%al
  800d05:	7e 19                	jle    800d20 <strtol+0xc2>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	3c 39                	cmp    $0x39,%al
  800d0e:	7f 10                	jg     800d20 <strtol+0xc2>
			dig = *s - '0';
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	0f be c0             	movsbl %al,%eax
  800d18:	83 e8 30             	sub    $0x30,%eax
  800d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d1e:	eb 42                	jmp    800d62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	8a 00                	mov    (%eax),%al
  800d25:	3c 60                	cmp    $0x60,%al
  800d27:	7e 19                	jle    800d42 <strtol+0xe4>
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	3c 7a                	cmp    $0x7a,%al
  800d30:	7f 10                	jg     800d42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f be c0             	movsbl %al,%eax
  800d3a:	83 e8 57             	sub    $0x57,%eax
  800d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d40:	eb 20                	jmp    800d62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	3c 40                	cmp    $0x40,%al
  800d49:	7e 39                	jle    800d84 <strtol+0x126>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	3c 5a                	cmp    $0x5a,%al
  800d52:	7f 30                	jg     800d84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 00                	mov    (%eax),%al
  800d59:	0f be c0             	movsbl %al,%eax
  800d5c:	83 e8 37             	sub    $0x37,%eax
  800d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d68:	7d 19                	jge    800d83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800d6a:	ff 45 08             	incl   0x8(%ebp)
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800d74:	89 c2                	mov    %eax,%edx
  800d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d79:	01 d0                	add    %edx,%eax
  800d7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800d7e:	e9 7b ff ff ff       	jmp    800cfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800d83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800d84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d88:	74 08                	je     800d92 <strtol+0x134>
		*endptr = (char *) s;
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800d92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800d96:	74 07                	je     800d9f <strtol+0x141>
  800d98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d9b:	f7 d8                	neg    %eax
  800d9d:	eb 03                	jmp    800da2 <strtol+0x144>
  800d9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800da2:	c9                   	leave  
  800da3:	c3                   	ret    

00800da4 <ltostr>:

void
ltostr(long value, char *str)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800daa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800db1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800db8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dbc:	79 13                	jns    800dd1 <ltostr+0x2d>
	{
		neg = 1;
  800dbe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800dcb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800dce:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dd9:	99                   	cltd   
  800dda:	f7 f9                	idiv   %ecx
  800ddc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	89 c2                	mov    %eax,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	01 d0                	add    %edx,%eax
  800def:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800df2:	83 c2 30             	add    $0x30,%edx
  800df5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800df7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dfa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800dff:	f7 e9                	imul   %ecx
  800e01:	c1 fa 02             	sar    $0x2,%edx
  800e04:	89 c8                	mov    %ecx,%eax
  800e06:	c1 f8 1f             	sar    $0x1f,%eax
  800e09:	29 c2                	sub    %eax,%edx
  800e0b:	89 d0                	mov    %edx,%eax
  800e0d:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e14:	75 bb                	jne    800dd1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e20:	48                   	dec    %eax
  800e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e24:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e28:	74 3d                	je     800e67 <ltostr+0xc3>
		start = 1 ;
  800e2a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e31:	eb 34                	jmp    800e67 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	01 c2                	add    %eax,%edx
  800e48:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4e:	01 c8                	add    %ecx,%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800e54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	01 c2                	add    %eax,%edx
  800e5c:	8a 45 eb             	mov    -0x15(%ebp),%al
  800e5f:	88 02                	mov    %al,(%edx)
		start++ ;
  800e61:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800e64:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6d:	7c c4                	jl     800e33 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800e6f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	01 d0                	add    %edx,%eax
  800e77:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800e7a:	90                   	nop
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800e83:	ff 75 08             	pushl  0x8(%ebp)
  800e86:	e8 73 fa ff ff       	call   8008fe <strlen>
  800e8b:	83 c4 04             	add    $0x4,%esp
  800e8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800e91:	ff 75 0c             	pushl  0xc(%ebp)
  800e94:	e8 65 fa ff ff       	call   8008fe <strlen>
  800e99:	83 c4 04             	add    $0x4,%esp
  800e9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800e9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ea6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ead:	eb 17                	jmp    800ec6 <strcconcat+0x49>
		final[s] = str1[s] ;
  800eaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb5:	01 c2                	add    %eax,%edx
  800eb7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	01 c8                	add    %ecx,%eax
  800ebf:	8a 00                	mov    (%eax),%al
  800ec1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800ecc:	7c e1                	jl     800eaf <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800ece:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ed5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800edc:	eb 1f                	jmp    800efd <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ede:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 c2                	add    %eax,%edx
  800eee:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef4:	01 c8                	add    %ecx,%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800efa:	ff 45 f8             	incl   -0x8(%ebp)
  800efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f03:	7c d9                	jl     800ede <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f08:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0b:	01 d0                	add    %edx,%eax
  800f0d:	c6 00 00             	movb   $0x0,(%eax)
}
  800f10:	90                   	nop
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    

00800f13 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f22:	8b 00                	mov    (%eax),%eax
  800f24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f36:	eb 0c                	jmp    800f44 <strsplit+0x31>
			*string++ = 0;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8d 50 01             	lea    0x1(%eax),%edx
  800f3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800f41:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	8a 00                	mov    (%eax),%al
  800f49:	84 c0                	test   %al,%al
  800f4b:	74 18                	je     800f65 <strsplit+0x52>
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	0f be c0             	movsbl %al,%eax
  800f55:	50                   	push   %eax
  800f56:	ff 75 0c             	pushl  0xc(%ebp)
  800f59:	e8 32 fb ff ff       	call   800a90 <strchr>
  800f5e:	83 c4 08             	add    $0x8,%esp
  800f61:	85 c0                	test   %eax,%eax
  800f63:	75 d3                	jne    800f38 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	84 c0                	test   %al,%al
  800f6c:	74 5a                	je     800fc8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800f6e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	83 f8 0f             	cmp    $0xf,%eax
  800f76:	75 07                	jne    800f7f <strsplit+0x6c>
		{
			return 0;
  800f78:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7d:	eb 66                	jmp    800fe5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800f7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f82:	8b 00                	mov    (%eax),%eax
  800f84:	8d 48 01             	lea    0x1(%eax),%ecx
  800f87:	8b 55 14             	mov    0x14(%ebp),%edx
  800f8a:	89 0a                	mov    %ecx,(%edx)
  800f8c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f93:	8b 45 10             	mov    0x10(%ebp),%eax
  800f96:	01 c2                	add    %eax,%edx
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800f9d:	eb 03                	jmp    800fa2 <strsplit+0x8f>
			string++;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	84 c0                	test   %al,%al
  800fa9:	74 8b                	je     800f36 <strsplit+0x23>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	0f be c0             	movsbl %al,%eax
  800fb3:	50                   	push   %eax
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	e8 d4 fa ff ff       	call   800a90 <strchr>
  800fbc:	83 c4 08             	add    $0x8,%esp
  800fbf:	85 c0                	test   %eax,%eax
  800fc1:	74 dc                	je     800f9f <strsplit+0x8c>
			string++;
	}
  800fc3:	e9 6e ff ff ff       	jmp    800f36 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  800fc8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	8b 00                	mov    (%eax),%eax
  800fce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  800fe0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800fe5:	c9                   	leave  
  800fe6:	c3                   	ret    

00800fe7 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	68 a8 1f 80 00       	push   $0x801fa8
  800ff5:	68 3f 01 00 00       	push   $0x13f
  800ffa:	68 ca 1f 80 00       	push   $0x801fca
  800fff:	e8 9d 06 00 00       	call   8016a1 <_panic>

00801004 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	57                   	push   %edi
  801008:	56                   	push   %esi
  801009:	53                   	push   %ebx
  80100a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8b 55 0c             	mov    0xc(%ebp),%edx
  801013:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801016:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801019:	8b 7d 18             	mov    0x18(%ebp),%edi
  80101c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80101f:	cd 30                	int    $0x30
  801021:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801024:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801027:	83 c4 10             	add    $0x10,%esp
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
  801032:	83 ec 04             	sub    $0x4,%esp
  801035:	8b 45 10             	mov    0x10(%ebp),%eax
  801038:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80103b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	6a 00                	push   $0x0
  801044:	6a 00                	push   $0x0
  801046:	52                   	push   %edx
  801047:	ff 75 0c             	pushl  0xc(%ebp)
  80104a:	50                   	push   %eax
  80104b:	6a 00                	push   $0x0
  80104d:	e8 b2 ff ff ff       	call   801004 <syscall>
  801052:	83 c4 18             	add    $0x18,%esp
}
  801055:	90                   	nop
  801056:	c9                   	leave  
  801057:	c3                   	ret    

00801058 <sys_cgetc>:

int sys_cgetc(void) {
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80105b:	6a 00                	push   $0x0
  80105d:	6a 00                	push   $0x0
  80105f:	6a 00                	push   $0x0
  801061:	6a 00                	push   $0x0
  801063:	6a 00                	push   $0x0
  801065:	6a 02                	push   $0x2
  801067:	e8 98 ff ff ff       	call   801004 <syscall>
  80106c:	83 c4 18             	add    $0x18,%esp
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <sys_lock_cons>:

void sys_lock_cons(void) {
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801074:	6a 00                	push   $0x0
  801076:	6a 00                	push   $0x0
  801078:	6a 00                	push   $0x0
  80107a:	6a 00                	push   $0x0
  80107c:	6a 00                	push   $0x0
  80107e:	6a 03                	push   $0x3
  801080:	e8 7f ff ff ff       	call   801004 <syscall>
  801085:	83 c4 18             	add    $0x18,%esp
}
  801088:	90                   	nop
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  80108e:	6a 00                	push   $0x0
  801090:	6a 00                	push   $0x0
  801092:	6a 00                	push   $0x0
  801094:	6a 00                	push   $0x0
  801096:	6a 00                	push   $0x0
  801098:	6a 04                	push   $0x4
  80109a:	e8 65 ff ff ff       	call   801004 <syscall>
  80109f:	83 c4 18             	add    $0x18,%esp
}
  8010a2:	90                   	nop
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8010a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	6a 00                	push   $0x0
  8010b0:	6a 00                	push   $0x0
  8010b2:	6a 00                	push   $0x0
  8010b4:	52                   	push   %edx
  8010b5:	50                   	push   %eax
  8010b6:	6a 08                	push   $0x8
  8010b8:	e8 47 ff ff ff       	call   801004 <syscall>
  8010bd:	83 c4 18             	add    $0x18,%esp
}
  8010c0:	c9                   	leave  
  8010c1:	c3                   	ret    

008010c2 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  8010c2:	55                   	push   %ebp
  8010c3:	89 e5                	mov    %esp,%ebp
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  8010c7:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8010cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8010d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	56                   	push   %esi
  8010d7:	53                   	push   %ebx
  8010d8:	51                   	push   %ecx
  8010d9:	52                   	push   %edx
  8010da:	50                   	push   %eax
  8010db:	6a 09                	push   $0x9
  8010dd:	e8 22 ff ff ff       	call   801004 <syscall>
  8010e2:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  8010e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010e8:	5b                   	pop    %ebx
  8010e9:	5e                   	pop    %esi
  8010ea:	5d                   	pop    %ebp
  8010eb:	c3                   	ret    

008010ec <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  8010ec:	55                   	push   %ebp
  8010ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	6a 00                	push   $0x0
  8010f7:	6a 00                	push   $0x0
  8010f9:	6a 00                	push   $0x0
  8010fb:	52                   	push   %edx
  8010fc:	50                   	push   %eax
  8010fd:	6a 0a                	push   $0xa
  8010ff:	e8 00 ff ff ff       	call   801004 <syscall>
  801104:	83 c4 18             	add    $0x18,%esp
}
  801107:	c9                   	leave  
  801108:	c3                   	ret    

00801109 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  801109:	55                   	push   %ebp
  80110a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80110c:	6a 00                	push   $0x0
  80110e:	6a 00                	push   $0x0
  801110:	6a 00                	push   $0x0
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	6a 0b                	push   $0xb
  80111a:	e8 e5 fe ff ff       	call   801004 <syscall>
  80111f:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801122:	c9                   	leave  
  801123:	c3                   	ret    

00801124 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801127:	6a 00                	push   $0x0
  801129:	6a 00                	push   $0x0
  80112b:	6a 00                	push   $0x0
  80112d:	6a 00                	push   $0x0
  80112f:	6a 00                	push   $0x0
  801131:	6a 0c                	push   $0xc
  801133:	e8 cc fe ff ff       	call   801004 <syscall>
  801138:	83 c4 18             	add    $0x18,%esp
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801140:	6a 00                	push   $0x0
  801142:	6a 00                	push   $0x0
  801144:	6a 00                	push   $0x0
  801146:	6a 00                	push   $0x0
  801148:	6a 00                	push   $0x0
  80114a:	6a 0d                	push   $0xd
  80114c:	e8 b3 fe ff ff       	call   801004 <syscall>
  801151:	83 c4 18             	add    $0x18,%esp
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801159:	6a 00                	push   $0x0
  80115b:	6a 00                	push   $0x0
  80115d:	6a 00                	push   $0x0
  80115f:	6a 00                	push   $0x0
  801161:	6a 00                	push   $0x0
  801163:	6a 0e                	push   $0xe
  801165:	e8 9a fe ff ff       	call   801004 <syscall>
  80116a:	83 c4 18             	add    $0x18,%esp
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801172:	6a 00                	push   $0x0
  801174:	6a 00                	push   $0x0
  801176:	6a 00                	push   $0x0
  801178:	6a 00                	push   $0x0
  80117a:	6a 00                	push   $0x0
  80117c:	6a 0f                	push   $0xf
  80117e:	e8 81 fe ff ff       	call   801004 <syscall>
  801183:	83 c4 18             	add    $0x18,%esp
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80118b:	6a 00                	push   $0x0
  80118d:	6a 00                	push   $0x0
  80118f:	6a 00                	push   $0x0
  801191:	6a 00                	push   $0x0
  801193:	ff 75 08             	pushl  0x8(%ebp)
  801196:	6a 10                	push   $0x10
  801198:	e8 67 fe ff ff       	call   801004 <syscall>
  80119d:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <sys_scarce_memory>:

void sys_scarce_memory() {
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8011a5:	6a 00                	push   $0x0
  8011a7:	6a 00                	push   $0x0
  8011a9:	6a 00                	push   $0x0
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 11                	push   $0x11
  8011b1:	e8 4e fe ff ff       	call   801004 <syscall>
  8011b6:	83 c4 18             	add    $0x18,%esp
}
  8011b9:	90                   	nop
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <sys_cputc>:

void sys_cputc(const char c) {
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 04             	sub    $0x4,%esp
  8011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8011c8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8011cc:	6a 00                	push   $0x0
  8011ce:	6a 00                	push   $0x0
  8011d0:	6a 00                	push   $0x0
  8011d2:	6a 00                	push   $0x0
  8011d4:	50                   	push   %eax
  8011d5:	6a 01                	push   $0x1
  8011d7:	e8 28 fe ff ff       	call   801004 <syscall>
  8011dc:	83 c4 18             	add    $0x18,%esp
}
  8011df:	90                   	nop
  8011e0:	c9                   	leave  
  8011e1:	c3                   	ret    

008011e2 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  8011e2:	55                   	push   %ebp
  8011e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  8011e5:	6a 00                	push   $0x0
  8011e7:	6a 00                	push   $0x0
  8011e9:	6a 00                	push   $0x0
  8011eb:	6a 00                	push   $0x0
  8011ed:	6a 00                	push   $0x0
  8011ef:	6a 14                	push   $0x14
  8011f1:	e8 0e fe ff ff       	call   801004 <syscall>
  8011f6:	83 c4 18             	add    $0x18,%esp
}
  8011f9:	90                   	nop
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 04             	sub    $0x4,%esp
  801202:	8b 45 10             	mov    0x10(%ebp),%eax
  801205:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  801208:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80120b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80120f:	8b 45 08             	mov    0x8(%ebp),%eax
  801212:	6a 00                	push   $0x0
  801214:	51                   	push   %ecx
  801215:	52                   	push   %edx
  801216:	ff 75 0c             	pushl  0xc(%ebp)
  801219:	50                   	push   %eax
  80121a:	6a 15                	push   $0x15
  80121c:	e8 e3 fd ff ff       	call   801004 <syscall>
  801221:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801224:	c9                   	leave  
  801225:	c3                   	ret    

00801226 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  801229:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	6a 00                	push   $0x0
  801231:	6a 00                	push   $0x0
  801233:	6a 00                	push   $0x0
  801235:	52                   	push   %edx
  801236:	50                   	push   %eax
  801237:	6a 16                	push   $0x16
  801239:	e8 c6 fd ff ff       	call   801004 <syscall>
  80123e:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801246:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	6a 00                	push   $0x0
  801251:	6a 00                	push   $0x0
  801253:	51                   	push   %ecx
  801254:	52                   	push   %edx
  801255:	50                   	push   %eax
  801256:	6a 17                	push   $0x17
  801258:	e8 a7 fd ff ff       	call   801004 <syscall>
  80125d:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  801265:	8b 55 0c             	mov    0xc(%ebp),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	6a 00                	push   $0x0
  80126d:	6a 00                	push   $0x0
  80126f:	6a 00                	push   $0x0
  801271:	52                   	push   %edx
  801272:	50                   	push   %eax
  801273:	6a 18                	push   $0x18
  801275:	e8 8a fd ff ff       	call   801004 <syscall>
  80127a:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	6a 00                	push   $0x0
  801287:	ff 75 14             	pushl  0x14(%ebp)
  80128a:	ff 75 10             	pushl  0x10(%ebp)
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	50                   	push   %eax
  801291:	6a 19                	push   $0x19
  801293:	e8 6c fd ff ff       	call   801004 <syscall>
  801298:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <sys_run_env>:

void sys_run_env(int32 envId) {
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	6a 00                	push   $0x0
  8012a9:	6a 00                	push   $0x0
  8012ab:	50                   	push   %eax
  8012ac:	6a 1a                	push   $0x1a
  8012ae:	e8 51 fd ff ff       	call   801004 <syscall>
  8012b3:	83 c4 18             	add    $0x18,%esp
}
  8012b6:	90                   	nop
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    

008012b9 <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  8012b9:	55                   	push   %ebp
  8012ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	6a 00                	push   $0x0
  8012c7:	50                   	push   %eax
  8012c8:	6a 1b                	push   $0x1b
  8012ca:	e8 35 fd ff ff       	call   801004 <syscall>
  8012cf:	83 c4 18             	add    $0x18,%esp
}
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <sys_getenvid>:

int32 sys_getenvid(void) {
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8012d7:	6a 00                	push   $0x0
  8012d9:	6a 00                	push   $0x0
  8012db:	6a 00                	push   $0x0
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 05                	push   $0x5
  8012e3:	e8 1c fd ff ff       	call   801004 <syscall>
  8012e8:	83 c4 18             	add    $0x18,%esp
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8012f0:	6a 00                	push   $0x0
  8012f2:	6a 00                	push   $0x0
  8012f4:	6a 00                	push   $0x0
  8012f6:	6a 00                	push   $0x0
  8012f8:	6a 00                	push   $0x0
  8012fa:	6a 06                	push   $0x6
  8012fc:	e8 03 fd ff ff       	call   801004 <syscall>
  801301:	83 c4 18             	add    $0x18,%esp
}
  801304:	c9                   	leave  
  801305:	c3                   	ret    

00801306 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801309:	6a 00                	push   $0x0
  80130b:	6a 00                	push   $0x0
  80130d:	6a 00                	push   $0x0
  80130f:	6a 00                	push   $0x0
  801311:	6a 00                	push   $0x0
  801313:	6a 07                	push   $0x7
  801315:	e8 ea fc ff ff       	call   801004 <syscall>
  80131a:	83 c4 18             	add    $0x18,%esp
}
  80131d:	c9                   	leave  
  80131e:	c3                   	ret    

0080131f <sys_exit_env>:

void sys_exit_env(void) {
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 00                	push   $0x0
  80132c:	6a 1c                	push   $0x1c
  80132e:	e8 d1 fc ff ff       	call   801004 <syscall>
  801333:	83 c4 18             	add    $0x18,%esp
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  80133f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801342:	8d 50 04             	lea    0x4(%eax),%edx
  801345:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 00                	push   $0x0
  80134e:	52                   	push   %edx
  80134f:	50                   	push   %eax
  801350:	6a 1d                	push   $0x1d
  801352:	e8 ad fc ff ff       	call   801004 <syscall>
  801357:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  80135a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801360:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801363:	89 01                	mov    %eax,(%ecx)
  801365:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801368:	8b 45 08             	mov    0x8(%ebp),%eax
  80136b:	c9                   	leave  
  80136c:	c2 04 00             	ret    $0x4

0080136f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  80136f:	55                   	push   %ebp
  801370:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801372:	6a 00                	push   $0x0
  801374:	6a 00                	push   $0x0
  801376:	ff 75 10             	pushl  0x10(%ebp)
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	ff 75 08             	pushl  0x8(%ebp)
  80137f:	6a 13                	push   $0x13
  801381:	e8 7e fc ff ff       	call   801004 <syscall>
  801386:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  801389:	90                   	nop
}
  80138a:	c9                   	leave  
  80138b:	c3                   	ret    

0080138c <sys_rcr2>:
uint32 sys_rcr2() {
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80138f:	6a 00                	push   $0x0
  801391:	6a 00                	push   $0x0
  801393:	6a 00                	push   $0x0
  801395:	6a 00                	push   $0x0
  801397:	6a 00                	push   $0x0
  801399:	6a 1e                	push   $0x1e
  80139b:	e8 64 fc ff ff       	call   801004 <syscall>
  8013a0:	83 c4 18             	add    $0x18,%esp
}
  8013a3:	c9                   	leave  
  8013a4:	c3                   	ret    

008013a5 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8013b1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8013b5:	6a 00                	push   $0x0
  8013b7:	6a 00                	push   $0x0
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	50                   	push   %eax
  8013be:	6a 1f                	push   $0x1f
  8013c0:	e8 3f fc ff ff       	call   801004 <syscall>
  8013c5:	83 c4 18             	add    $0x18,%esp
	return;
  8013c8:	90                   	nop
}
  8013c9:	c9                   	leave  
  8013ca:	c3                   	ret    

008013cb <rsttst>:
void rsttst() {
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8013ce:	6a 00                	push   $0x0
  8013d0:	6a 00                	push   $0x0
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 21                	push   $0x21
  8013da:	e8 25 fc ff ff       	call   801004 <syscall>
  8013df:	83 c4 18             	add    $0x18,%esp
	return;
  8013e2:	90                   	nop
}
  8013e3:	c9                   	leave  
  8013e4:	c3                   	ret    

008013e5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 04             	sub    $0x4,%esp
  8013eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8013f1:	8b 55 18             	mov    0x18(%ebp),%edx
  8013f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8013f8:	52                   	push   %edx
  8013f9:	50                   	push   %eax
  8013fa:	ff 75 10             	pushl  0x10(%ebp)
  8013fd:	ff 75 0c             	pushl  0xc(%ebp)
  801400:	ff 75 08             	pushl  0x8(%ebp)
  801403:	6a 20                	push   $0x20
  801405:	e8 fa fb ff ff       	call   801004 <syscall>
  80140a:	83 c4 18             	add    $0x18,%esp
	return;
  80140d:	90                   	nop
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <chktst>:
void chktst(uint32 n) {
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801413:	6a 00                	push   $0x0
  801415:	6a 00                	push   $0x0
  801417:	6a 00                	push   $0x0
  801419:	6a 00                	push   $0x0
  80141b:	ff 75 08             	pushl  0x8(%ebp)
  80141e:	6a 22                	push   $0x22
  801420:	e8 df fb ff ff       	call   801004 <syscall>
  801425:	83 c4 18             	add    $0x18,%esp
	return;
  801428:	90                   	nop
}
  801429:	c9                   	leave  
  80142a:	c3                   	ret    

0080142b <inctst>:

void inctst() {
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80142e:	6a 00                	push   $0x0
  801430:	6a 00                	push   $0x0
  801432:	6a 00                	push   $0x0
  801434:	6a 00                	push   $0x0
  801436:	6a 00                	push   $0x0
  801438:	6a 23                	push   $0x23
  80143a:	e8 c5 fb ff ff       	call   801004 <syscall>
  80143f:	83 c4 18             	add    $0x18,%esp
	return;
  801442:	90                   	nop
}
  801443:	c9                   	leave  
  801444:	c3                   	ret    

00801445 <gettst>:
uint32 gettst() {
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801448:	6a 00                	push   $0x0
  80144a:	6a 00                	push   $0x0
  80144c:	6a 00                	push   $0x0
  80144e:	6a 00                	push   $0x0
  801450:	6a 00                	push   $0x0
  801452:	6a 24                	push   $0x24
  801454:	e8 ab fb ff ff       	call   801004 <syscall>
  801459:	83 c4 18             	add    $0x18,%esp
}
  80145c:	c9                   	leave  
  80145d:	c3                   	ret    

0080145e <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  80145e:	55                   	push   %ebp
  80145f:	89 e5                	mov    %esp,%ebp
  801461:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801464:	6a 00                	push   $0x0
  801466:	6a 00                	push   $0x0
  801468:	6a 00                	push   $0x0
  80146a:	6a 00                	push   $0x0
  80146c:	6a 00                	push   $0x0
  80146e:	6a 25                	push   $0x25
  801470:	e8 8f fb ff ff       	call   801004 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
  801478:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80147b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80147f:	75 07                	jne    801488 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801481:	b8 01 00 00 00       	mov    $0x1,%eax
  801486:	eb 05                	jmp    80148d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801495:	6a 00                	push   $0x0
  801497:	6a 00                	push   $0x0
  801499:	6a 00                	push   $0x0
  80149b:	6a 00                	push   $0x0
  80149d:	6a 00                	push   $0x0
  80149f:	6a 25                	push   $0x25
  8014a1:	e8 5e fb ff ff       	call   801004 <syscall>
  8014a6:	83 c4 18             	add    $0x18,%esp
  8014a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014ac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8014b0:	75 07                	jne    8014b9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8014b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8014b7:	eb 05                	jmp    8014be <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014c6:	6a 00                	push   $0x0
  8014c8:	6a 00                	push   $0x0
  8014ca:	6a 00                	push   $0x0
  8014cc:	6a 00                	push   $0x0
  8014ce:	6a 00                	push   $0x0
  8014d0:	6a 25                	push   $0x25
  8014d2:	e8 2d fb ff ff       	call   801004 <syscall>
  8014d7:	83 c4 18             	add    $0x18,%esp
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8014dd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8014e1:	75 07                	jne    8014ea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8014e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8014e8:	eb 05                	jmp    8014ef <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014f7:	6a 00                	push   $0x0
  8014f9:	6a 00                	push   $0x0
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 25                	push   $0x25
  801503:	e8 fc fa ff ff       	call   801004 <syscall>
  801508:	83 c4 18             	add    $0x18,%esp
  80150b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80150e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801512:	75 07                	jne    80151b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801514:	b8 01 00 00 00       	mov    $0x1,%eax
  801519:	eb 05                	jmp    801520 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801525:	6a 00                	push   $0x0
  801527:	6a 00                	push   $0x0
  801529:	6a 00                	push   $0x0
  80152b:	6a 00                	push   $0x0
  80152d:	ff 75 08             	pushl  0x8(%ebp)
  801530:	6a 26                	push   $0x26
  801532:	e8 cd fa ff ff       	call   801004 <syscall>
  801537:	83 c4 18             	add    $0x18,%esp
	return;
  80153a:	90                   	nop
}
  80153b:	c9                   	leave  
  80153c:	c3                   	ret    

0080153d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801541:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801544:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801547:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	6a 00                	push   $0x0
  80154f:	53                   	push   %ebx
  801550:	51                   	push   %ecx
  801551:	52                   	push   %edx
  801552:	50                   	push   %eax
  801553:	6a 27                	push   $0x27
  801555:	e8 aa fa ff ff       	call   801004 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  80155d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801560:	c9                   	leave  
  801561:	c3                   	ret    

00801562 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  801562:	55                   	push   %ebp
  801563:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  801565:	8b 55 0c             	mov    0xc(%ebp),%edx
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	52                   	push   %edx
  801572:	50                   	push   %eax
  801573:	6a 28                	push   $0x28
  801575:	e8 8a fa ff ff       	call   801004 <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801582:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801585:	8b 55 0c             	mov    0xc(%ebp),%edx
  801588:	8b 45 08             	mov    0x8(%ebp),%eax
  80158b:	6a 00                	push   $0x0
  80158d:	51                   	push   %ecx
  80158e:	ff 75 10             	pushl  0x10(%ebp)
  801591:	52                   	push   %edx
  801592:	50                   	push   %eax
  801593:	6a 29                	push   $0x29
  801595:	e8 6a fa ff ff       	call   801004 <syscall>
  80159a:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80159d:	c9                   	leave  
  80159e:	c3                   	ret    

0080159f <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  80159f:	55                   	push   %ebp
  8015a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015a2:	6a 00                	push   $0x0
  8015a4:	6a 00                	push   $0x0
  8015a6:	ff 75 10             	pushl  0x10(%ebp)
  8015a9:	ff 75 0c             	pushl  0xc(%ebp)
  8015ac:	ff 75 08             	pushl  0x8(%ebp)
  8015af:	6a 12                	push   $0x12
  8015b1:	e8 4e fa ff ff       	call   801004 <syscall>
  8015b6:	83 c4 18             	add    $0x18,%esp
	return;
  8015b9:	90                   	nop
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  8015bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	52                   	push   %edx
  8015cc:	50                   	push   %eax
  8015cd:	6a 2a                	push   $0x2a
  8015cf:	e8 30 fa ff ff       	call   801004 <syscall>
  8015d4:	83 c4 18             	add    $0x18,%esp
	return;
  8015d7:	90                   	nop
}
  8015d8:	c9                   	leave  
  8015d9:	c3                   	ret    

008015da <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	50                   	push   %eax
  8015e9:	6a 2b                	push   $0x2b
  8015eb:	e8 14 fa ff ff       	call   801004 <syscall>
  8015f0:	83 c4 18             	add    $0x18,%esp
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8015f8:	6a 00                	push   $0x0
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	ff 75 0c             	pushl  0xc(%ebp)
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	6a 2c                	push   $0x2c
  801606:	e8 f9 f9 ff ff       	call   801004 <syscall>
  80160b:	83 c4 18             	add    $0x18,%esp
	return;
  80160e:	90                   	nop
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	ff 75 0c             	pushl  0xc(%ebp)
  80161d:	ff 75 08             	pushl  0x8(%ebp)
  801620:	6a 2d                	push   $0x2d
  801622:	e8 dd f9 ff ff       	call   801004 <syscall>
  801627:	83 c4 18             	add    $0x18,%esp
	return;
  80162a:	90                   	nop
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	6a 00                	push   $0x0
  801635:	6a 00                	push   $0x0
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	50                   	push   %eax
  80163c:	6a 2f                	push   $0x2f
  80163e:	e8 c1 f9 ff ff       	call   801004 <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
	return;
  801646:	90                   	nop
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80164c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	52                   	push   %edx
  801659:	50                   	push   %eax
  80165a:	6a 30                	push   $0x30
  80165c:	e8 a3 f9 ff ff       	call   801004 <syscall>
  801661:	83 c4 18             	add    $0x18,%esp
	return;
  801664:	90                   	nop
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	6a 00                	push   $0x0
  80166f:	6a 00                	push   $0x0
  801671:	6a 00                	push   $0x0
  801673:	6a 00                	push   $0x0
  801675:	50                   	push   %eax
  801676:	6a 31                	push   $0x31
  801678:	e8 87 f9 ff ff       	call   801004 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
	return;
  801680:	90                   	nop
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	8b 45 08             	mov    0x8(%ebp),%eax
  80168c:	6a 00                	push   $0x0
  80168e:	6a 00                	push   $0x0
  801690:	6a 00                	push   $0x0
  801692:	52                   	push   %edx
  801693:	50                   	push   %eax
  801694:	6a 2e                	push   $0x2e
  801696:	e8 69 f9 ff ff       	call   801004 <syscall>
  80169b:	83 c4 18             	add    $0x18,%esp
    return;
  80169e:	90                   	nop
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8016a7:	8d 45 10             	lea    0x10(%ebp),%eax
  8016aa:	83 c0 04             	add    $0x4,%eax
  8016ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8016b0:	a1 dc 68 81 00       	mov    0x8168dc,%eax
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	74 16                	je     8016cf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8016b9:	a1 dc 68 81 00       	mov    0x8168dc,%eax
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	50                   	push   %eax
  8016c2:	68 d8 1f 80 00       	push   $0x801fd8
  8016c7:	e8 9e eb ff ff       	call   80026a <cprintf>
  8016cc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8016cf:	a1 04 30 80 00       	mov    0x803004,%eax
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	50                   	push   %eax
  8016db:	68 dd 1f 80 00       	push   $0x801fdd
  8016e0:	e8 85 eb ff ff       	call   80026a <cprintf>
  8016e5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8016e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016eb:	83 ec 08             	sub    $0x8,%esp
  8016ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f1:	50                   	push   %eax
  8016f2:	e8 08 eb ff ff       	call   8001ff <vcprintf>
  8016f7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8016fa:	83 ec 08             	sub    $0x8,%esp
  8016fd:	6a 00                	push   $0x0
  8016ff:	68 f9 1f 80 00       	push   $0x801ff9
  801704:	e8 f6 ea ff ff       	call   8001ff <vcprintf>
  801709:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80170c:	e8 77 ea ff ff       	call   800188 <exit>

	// should not return here
	while (1) ;
  801711:	eb fe                	jmp    801711 <_panic+0x70>

00801713 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801719:	a1 20 30 80 00       	mov    0x803020,%eax
  80171e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801724:	8b 45 0c             	mov    0xc(%ebp),%eax
  801727:	39 c2                	cmp    %eax,%edx
  801729:	74 14                	je     80173f <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	68 fc 1f 80 00       	push   $0x801ffc
  801733:	6a 26                	push   $0x26
  801735:	68 48 20 80 00       	push   $0x802048
  80173a:	e8 62 ff ff ff       	call   8016a1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80173f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801746:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80174d:	e9 c5 00 00 00       	jmp    801817 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	01 d0                	add    %edx,%eax
  801761:	8b 00                	mov    (%eax),%eax
  801763:	85 c0                	test   %eax,%eax
  801765:	75 08                	jne    80176f <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801767:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80176a:	e9 a5 00 00 00       	jmp    801814 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  80176f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801776:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80177d:	eb 69                	jmp    8017e8 <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80177f:	a1 20 30 80 00       	mov    0x803020,%eax
  801784:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80178a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80178d:	89 d0                	mov    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	01 d0                	add    %edx,%eax
  801793:	c1 e0 03             	shl    $0x3,%eax
  801796:	01 c8                	add    %ecx,%eax
  801798:	8a 40 04             	mov    0x4(%eax),%al
  80179b:	84 c0                	test   %al,%al
  80179d:	75 46                	jne    8017e5 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80179f:	a1 20 30 80 00       	mov    0x803020,%eax
  8017a4:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8017aa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ad:	89 d0                	mov    %edx,%eax
  8017af:	01 c0                	add    %eax,%eax
  8017b1:	01 d0                	add    %edx,%eax
  8017b3:	c1 e0 03             	shl    $0x3,%eax
  8017b6:	01 c8                	add    %ecx,%eax
  8017b8:	8b 00                	mov    (%eax),%eax
  8017ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017c5:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8017c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8017d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d4:	01 c8                	add    %ecx,%eax
  8017d6:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8017d8:	39 c2                	cmp    %eax,%edx
  8017da:	75 09                	jne    8017e5 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8017dc:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8017e3:	eb 15                	jmp    8017fa <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017e5:	ff 45 e8             	incl   -0x18(%ebp)
  8017e8:	a1 20 30 80 00       	mov    0x803020,%eax
  8017ed:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8017f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f6:	39 c2                	cmp    %eax,%edx
  8017f8:	77 85                	ja     80177f <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8017fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017fe:	75 14                	jne    801814 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801800:	83 ec 04             	sub    $0x4,%esp
  801803:	68 54 20 80 00       	push   $0x802054
  801808:	6a 3a                	push   $0x3a
  80180a:	68 48 20 80 00       	push   $0x802048
  80180f:	e8 8d fe ff ff       	call   8016a1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801814:	ff 45 f0             	incl   -0x10(%ebp)
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80181d:	0f 8c 2f ff ff ff    	jl     801752 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801823:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80182a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801831:	eb 26                	jmp    801859 <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801833:	a1 20 30 80 00       	mov    0x803020,%eax
  801838:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80183e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801841:	89 d0                	mov    %edx,%eax
  801843:	01 c0                	add    %eax,%eax
  801845:	01 d0                	add    %edx,%eax
  801847:	c1 e0 03             	shl    $0x3,%eax
  80184a:	01 c8                	add    %ecx,%eax
  80184c:	8a 40 04             	mov    0x4(%eax),%al
  80184f:	3c 01                	cmp    $0x1,%al
  801851:	75 03                	jne    801856 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801853:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801856:	ff 45 e0             	incl   -0x20(%ebp)
  801859:	a1 20 30 80 00       	mov    0x803020,%eax
  80185e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801864:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801867:	39 c2                	cmp    %eax,%edx
  801869:	77 c8                	ja     801833 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80186e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801871:	74 14                	je     801887 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	68 a8 20 80 00       	push   $0x8020a8
  80187b:	6a 44                	push   $0x44
  80187d:	68 48 20 80 00       	push   $0x802048
  801882:	e8 1a fe ff ff       	call   8016a1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801887:	90                   	nop
  801888:	c9                   	leave  
  801889:	c3                   	ret    
  80188a:	66 90                	xchg   %ax,%ax

0080188c <__udivdi3>:
  80188c:	55                   	push   %ebp
  80188d:	57                   	push   %edi
  80188e:	56                   	push   %esi
  80188f:	53                   	push   %ebx
  801890:	83 ec 1c             	sub    $0x1c,%esp
  801893:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801897:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80189b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80189f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018a3:	89 ca                	mov    %ecx,%edx
  8018a5:	89 f8                	mov    %edi,%eax
  8018a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8018ab:	85 f6                	test   %esi,%esi
  8018ad:	75 2d                	jne    8018dc <__udivdi3+0x50>
  8018af:	39 cf                	cmp    %ecx,%edi
  8018b1:	77 65                	ja     801918 <__udivdi3+0x8c>
  8018b3:	89 fd                	mov    %edi,%ebp
  8018b5:	85 ff                	test   %edi,%edi
  8018b7:	75 0b                	jne    8018c4 <__udivdi3+0x38>
  8018b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8018be:	31 d2                	xor    %edx,%edx
  8018c0:	f7 f7                	div    %edi
  8018c2:	89 c5                	mov    %eax,%ebp
  8018c4:	31 d2                	xor    %edx,%edx
  8018c6:	89 c8                	mov    %ecx,%eax
  8018c8:	f7 f5                	div    %ebp
  8018ca:	89 c1                	mov    %eax,%ecx
  8018cc:	89 d8                	mov    %ebx,%eax
  8018ce:	f7 f5                	div    %ebp
  8018d0:	89 cf                	mov    %ecx,%edi
  8018d2:	89 fa                	mov    %edi,%edx
  8018d4:	83 c4 1c             	add    $0x1c,%esp
  8018d7:	5b                   	pop    %ebx
  8018d8:	5e                   	pop    %esi
  8018d9:	5f                   	pop    %edi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    
  8018dc:	39 ce                	cmp    %ecx,%esi
  8018de:	77 28                	ja     801908 <__udivdi3+0x7c>
  8018e0:	0f bd fe             	bsr    %esi,%edi
  8018e3:	83 f7 1f             	xor    $0x1f,%edi
  8018e6:	75 40                	jne    801928 <__udivdi3+0x9c>
  8018e8:	39 ce                	cmp    %ecx,%esi
  8018ea:	72 0a                	jb     8018f6 <__udivdi3+0x6a>
  8018ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8018f0:	0f 87 9e 00 00 00    	ja     801994 <__udivdi3+0x108>
  8018f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8018fb:	89 fa                	mov    %edi,%edx
  8018fd:	83 c4 1c             	add    $0x1c,%esp
  801900:	5b                   	pop    %ebx
  801901:	5e                   	pop    %esi
  801902:	5f                   	pop    %edi
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    
  801905:	8d 76 00             	lea    0x0(%esi),%esi
  801908:	31 ff                	xor    %edi,%edi
  80190a:	31 c0                	xor    %eax,%eax
  80190c:	89 fa                	mov    %edi,%edx
  80190e:	83 c4 1c             	add    $0x1c,%esp
  801911:	5b                   	pop    %ebx
  801912:	5e                   	pop    %esi
  801913:	5f                   	pop    %edi
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    
  801916:	66 90                	xchg   %ax,%ax
  801918:	89 d8                	mov    %ebx,%eax
  80191a:	f7 f7                	div    %edi
  80191c:	31 ff                	xor    %edi,%edi
  80191e:	89 fa                	mov    %edi,%edx
  801920:	83 c4 1c             	add    $0x1c,%esp
  801923:	5b                   	pop    %ebx
  801924:	5e                   	pop    %esi
  801925:	5f                   	pop    %edi
  801926:	5d                   	pop    %ebp
  801927:	c3                   	ret    
  801928:	bd 20 00 00 00       	mov    $0x20,%ebp
  80192d:	89 eb                	mov    %ebp,%ebx
  80192f:	29 fb                	sub    %edi,%ebx
  801931:	89 f9                	mov    %edi,%ecx
  801933:	d3 e6                	shl    %cl,%esi
  801935:	89 c5                	mov    %eax,%ebp
  801937:	88 d9                	mov    %bl,%cl
  801939:	d3 ed                	shr    %cl,%ebp
  80193b:	89 e9                	mov    %ebp,%ecx
  80193d:	09 f1                	or     %esi,%ecx
  80193f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801943:	89 f9                	mov    %edi,%ecx
  801945:	d3 e0                	shl    %cl,%eax
  801947:	89 c5                	mov    %eax,%ebp
  801949:	89 d6                	mov    %edx,%esi
  80194b:	88 d9                	mov    %bl,%cl
  80194d:	d3 ee                	shr    %cl,%esi
  80194f:	89 f9                	mov    %edi,%ecx
  801951:	d3 e2                	shl    %cl,%edx
  801953:	8b 44 24 08          	mov    0x8(%esp),%eax
  801957:	88 d9                	mov    %bl,%cl
  801959:	d3 e8                	shr    %cl,%eax
  80195b:	09 c2                	or     %eax,%edx
  80195d:	89 d0                	mov    %edx,%eax
  80195f:	89 f2                	mov    %esi,%edx
  801961:	f7 74 24 0c          	divl   0xc(%esp)
  801965:	89 d6                	mov    %edx,%esi
  801967:	89 c3                	mov    %eax,%ebx
  801969:	f7 e5                	mul    %ebp
  80196b:	39 d6                	cmp    %edx,%esi
  80196d:	72 19                	jb     801988 <__udivdi3+0xfc>
  80196f:	74 0b                	je     80197c <__udivdi3+0xf0>
  801971:	89 d8                	mov    %ebx,%eax
  801973:	31 ff                	xor    %edi,%edi
  801975:	e9 58 ff ff ff       	jmp    8018d2 <__udivdi3+0x46>
  80197a:	66 90                	xchg   %ax,%ax
  80197c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801980:	89 f9                	mov    %edi,%ecx
  801982:	d3 e2                	shl    %cl,%edx
  801984:	39 c2                	cmp    %eax,%edx
  801986:	73 e9                	jae    801971 <__udivdi3+0xe5>
  801988:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80198b:	31 ff                	xor    %edi,%edi
  80198d:	e9 40 ff ff ff       	jmp    8018d2 <__udivdi3+0x46>
  801992:	66 90                	xchg   %ax,%ax
  801994:	31 c0                	xor    %eax,%eax
  801996:	e9 37 ff ff ff       	jmp    8018d2 <__udivdi3+0x46>
  80199b:	90                   	nop

0080199c <__umoddi3>:
  80199c:	55                   	push   %ebp
  80199d:	57                   	push   %edi
  80199e:	56                   	push   %esi
  80199f:	53                   	push   %ebx
  8019a0:	83 ec 1c             	sub    $0x1c,%esp
  8019a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8019a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8019ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8019b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019bb:	89 f3                	mov    %esi,%ebx
  8019bd:	89 fa                	mov    %edi,%edx
  8019bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019c3:	89 34 24             	mov    %esi,(%esp)
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	75 1a                	jne    8019e4 <__umoddi3+0x48>
  8019ca:	39 f7                	cmp    %esi,%edi
  8019cc:	0f 86 a2 00 00 00    	jbe    801a74 <__umoddi3+0xd8>
  8019d2:	89 c8                	mov    %ecx,%eax
  8019d4:	89 f2                	mov    %esi,%edx
  8019d6:	f7 f7                	div    %edi
  8019d8:	89 d0                	mov    %edx,%eax
  8019da:	31 d2                	xor    %edx,%edx
  8019dc:	83 c4 1c             	add    $0x1c,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5f                   	pop    %edi
  8019e2:	5d                   	pop    %ebp
  8019e3:	c3                   	ret    
  8019e4:	39 f0                	cmp    %esi,%eax
  8019e6:	0f 87 ac 00 00 00    	ja     801a98 <__umoddi3+0xfc>
  8019ec:	0f bd e8             	bsr    %eax,%ebp
  8019ef:	83 f5 1f             	xor    $0x1f,%ebp
  8019f2:	0f 84 ac 00 00 00    	je     801aa4 <__umoddi3+0x108>
  8019f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8019fd:	29 ef                	sub    %ebp,%edi
  8019ff:	89 fe                	mov    %edi,%esi
  801a01:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a05:	89 e9                	mov    %ebp,%ecx
  801a07:	d3 e0                	shl    %cl,%eax
  801a09:	89 d7                	mov    %edx,%edi
  801a0b:	89 f1                	mov    %esi,%ecx
  801a0d:	d3 ef                	shr    %cl,%edi
  801a0f:	09 c7                	or     %eax,%edi
  801a11:	89 e9                	mov    %ebp,%ecx
  801a13:	d3 e2                	shl    %cl,%edx
  801a15:	89 14 24             	mov    %edx,(%esp)
  801a18:	89 d8                	mov    %ebx,%eax
  801a1a:	d3 e0                	shl    %cl,%eax
  801a1c:	89 c2                	mov    %eax,%edx
  801a1e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a22:	d3 e0                	shl    %cl,%eax
  801a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a28:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a2c:	89 f1                	mov    %esi,%ecx
  801a2e:	d3 e8                	shr    %cl,%eax
  801a30:	09 d0                	or     %edx,%eax
  801a32:	d3 eb                	shr    %cl,%ebx
  801a34:	89 da                	mov    %ebx,%edx
  801a36:	f7 f7                	div    %edi
  801a38:	89 d3                	mov    %edx,%ebx
  801a3a:	f7 24 24             	mull   (%esp)
  801a3d:	89 c6                	mov    %eax,%esi
  801a3f:	89 d1                	mov    %edx,%ecx
  801a41:	39 d3                	cmp    %edx,%ebx
  801a43:	0f 82 87 00 00 00    	jb     801ad0 <__umoddi3+0x134>
  801a49:	0f 84 91 00 00 00    	je     801ae0 <__umoddi3+0x144>
  801a4f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801a53:	29 f2                	sub    %esi,%edx
  801a55:	19 cb                	sbb    %ecx,%ebx
  801a57:	89 d8                	mov    %ebx,%eax
  801a59:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801a5d:	d3 e0                	shl    %cl,%eax
  801a5f:	89 e9                	mov    %ebp,%ecx
  801a61:	d3 ea                	shr    %cl,%edx
  801a63:	09 d0                	or     %edx,%eax
  801a65:	89 e9                	mov    %ebp,%ecx
  801a67:	d3 eb                	shr    %cl,%ebx
  801a69:	89 da                	mov    %ebx,%edx
  801a6b:	83 c4 1c             	add    $0x1c,%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5e                   	pop    %esi
  801a70:	5f                   	pop    %edi
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    
  801a73:	90                   	nop
  801a74:	89 fd                	mov    %edi,%ebp
  801a76:	85 ff                	test   %edi,%edi
  801a78:	75 0b                	jne    801a85 <__umoddi3+0xe9>
  801a7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a7f:	31 d2                	xor    %edx,%edx
  801a81:	f7 f7                	div    %edi
  801a83:	89 c5                	mov    %eax,%ebp
  801a85:	89 f0                	mov    %esi,%eax
  801a87:	31 d2                	xor    %edx,%edx
  801a89:	f7 f5                	div    %ebp
  801a8b:	89 c8                	mov    %ecx,%eax
  801a8d:	f7 f5                	div    %ebp
  801a8f:	89 d0                	mov    %edx,%eax
  801a91:	e9 44 ff ff ff       	jmp    8019da <__umoddi3+0x3e>
  801a96:	66 90                	xchg   %ax,%ax
  801a98:	89 c8                	mov    %ecx,%eax
  801a9a:	89 f2                	mov    %esi,%edx
  801a9c:	83 c4 1c             	add    $0x1c,%esp
  801a9f:	5b                   	pop    %ebx
  801aa0:	5e                   	pop    %esi
  801aa1:	5f                   	pop    %edi
  801aa2:	5d                   	pop    %ebp
  801aa3:	c3                   	ret    
  801aa4:	3b 04 24             	cmp    (%esp),%eax
  801aa7:	72 06                	jb     801aaf <__umoddi3+0x113>
  801aa9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801aad:	77 0f                	ja     801abe <__umoddi3+0x122>
  801aaf:	89 f2                	mov    %esi,%edx
  801ab1:	29 f9                	sub    %edi,%ecx
  801ab3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ab7:	89 14 24             	mov    %edx,(%esp)
  801aba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801abe:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ac2:	8b 14 24             	mov    (%esp),%edx
  801ac5:	83 c4 1c             	add    $0x1c,%esp
  801ac8:	5b                   	pop    %ebx
  801ac9:	5e                   	pop    %esi
  801aca:	5f                   	pop    %edi
  801acb:	5d                   	pop    %ebp
  801acc:	c3                   	ret    
  801acd:	8d 76 00             	lea    0x0(%esi),%esi
  801ad0:	2b 04 24             	sub    (%esp),%eax
  801ad3:	19 fa                	sbb    %edi,%edx
  801ad5:	89 d1                	mov    %edx,%ecx
  801ad7:	89 c6                	mov    %eax,%esi
  801ad9:	e9 71 ff ff ff       	jmp    801a4f <__umoddi3+0xb3>
  801ade:	66 90                	xchg   %ax,%ax
  801ae0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ae4:	72 ea                	jb     801ad0 <__umoddi3+0x134>
  801ae6:	89 d9                	mov    %ebx,%ecx
  801ae8:	e9 62 ff ff ff       	jmp    801a4f <__umoddi3+0xb3>
