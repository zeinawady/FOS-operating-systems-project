
obj/user/fos_input:     file format elf32-i386


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
  800031:	e8 a5 00 00 00       	call   8000db <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void
_main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 04 00 00    	sub    $0x418,%esp
	int i1=0;
  800041:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int i2=0;
  800048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	char buff1[512];
	char buff2[512];


	atomic_readline("Please enter first number :", buff1);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800058:	50                   	push   %eax
  800059:	68 80 1e 80 00       	push   $0x801e80
  80005e:	e8 24 0a 00 00       	call   800a87 <atomic_readline>
  800063:	83 c4 10             	add    $0x10,%esp
	i1 = strtol(buff1, NULL, 10);
  800066:	83 ec 04             	sub    $0x4,%esp
  800069:	6a 0a                	push   $0xa
  80006b:	6a 00                	push   $0x0
  80006d:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
  800073:	50                   	push   %eax
  800074:	e8 77 0e 00 00       	call   800ef0 <strtol>
  800079:	83 c4 10             	add    $0x10,%esp
  80007c:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//sleep
	env_sleep(2800);
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	68 f0 0a 00 00       	push   $0xaf0
  800087:	e8 a7 18 00 00       	call   801933 <env_sleep>
  80008c:	83 c4 10             	add    $0x10,%esp

	atomic_readline("Please enter second number :", buff2);
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800098:	50                   	push   %eax
  800099:	68 9c 1e 80 00       	push   $0x801e9c
  80009e:	e8 e4 09 00 00       	call   800a87 <atomic_readline>
  8000a3:	83 c4 10             	add    $0x10,%esp
	
	i2 = strtol(buff2, NULL, 10);
  8000a6:	83 ec 04             	sub    $0x4,%esp
  8000a9:	6a 0a                	push   $0xa
  8000ab:	6a 00                	push   $0x0
  8000ad:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8000b3:	50                   	push   %eax
  8000b4:	e8 37 0e 00 00       	call   800ef0 <strtol>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	atomic_cprintf("number 1 + number 2 = %d\n",i1+i2);
  8000bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	01 d0                	add    %edx,%eax
  8000c7:	83 ec 08             	sub    $0x8,%esp
  8000ca:	50                   	push   %eax
  8000cb:	68 b9 1e 80 00       	push   $0x801eb9
  8000d0:	e8 4c 02 00 00       	call   800321 <atomic_cprintf>
  8000d5:	83 c4 10             	add    $0x10,%esp
	return;	
  8000d8:	90                   	nop
}
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    

008000db <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000db:	55                   	push   %ebp
  8000dc:	89 e5                	mov    %esp,%ebp
  8000de:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000e1:	e8 99 14 00 00       	call   80157f <sys_getenvindex>
  8000e6:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000ec:	89 d0                	mov    %edx,%eax
  8000ee:	c1 e0 02             	shl    $0x2,%eax
  8000f1:	01 d0                	add    %edx,%eax
  8000f3:	c1 e0 03             	shl    $0x3,%eax
  8000f6:	01 d0                	add    %edx,%eax
  8000f8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000ff:	01 d0                	add    %edx,%eax
  800101:	c1 e0 02             	shl    $0x2,%eax
  800104:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800109:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80010e:	a1 08 30 80 00       	mov    0x803008,%eax
  800113:	8a 40 20             	mov    0x20(%eax),%al
  800116:	84 c0                	test   %al,%al
  800118:	74 0d                	je     800127 <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80011a:	a1 08 30 80 00       	mov    0x803008,%eax
  80011f:	83 c0 20             	add    $0x20,%eax
  800122:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012b:	7e 0a                	jle    800137 <libmain+0x5c>
		binaryname = argv[0];
  80012d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800130:	8b 00                	mov    (%eax),%eax
  800132:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  800137:	83 ec 08             	sub    $0x8,%esp
  80013a:	ff 75 0c             	pushl  0xc(%ebp)
  80013d:	ff 75 08             	pushl  0x8(%ebp)
  800140:	e8 f3 fe ff ff       	call   800038 <_main>
  800145:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800148:	a1 00 30 80 00       	mov    0x803000,%eax
  80014d:	85 c0                	test   %eax,%eax
  80014f:	0f 84 9f 00 00 00    	je     8001f4 <libmain+0x119>
	{
		sys_lock_cons();
  800155:	e8 a9 11 00 00       	call   801303 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 ec 1e 80 00       	push   $0x801eec
  800162:	e8 8d 01 00 00       	call   8002f4 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80016a:	a1 08 30 80 00       	mov    0x803008,%eax
  80016f:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800175:	a1 08 30 80 00       	mov    0x803008,%eax
  80017a:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800180:	83 ec 04             	sub    $0x4,%esp
  800183:	52                   	push   %edx
  800184:	50                   	push   %eax
  800185:	68 14 1f 80 00       	push   $0x801f14
  80018a:	e8 65 01 00 00       	call   8002f4 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800192:	a1 08 30 80 00       	mov    0x803008,%eax
  800197:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  80019d:	a1 08 30 80 00       	mov    0x803008,%eax
  8001a2:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001a8:	a1 08 30 80 00       	mov    0x803008,%eax
  8001ad:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001b3:	51                   	push   %ecx
  8001b4:	52                   	push   %edx
  8001b5:	50                   	push   %eax
  8001b6:	68 3c 1f 80 00       	push   $0x801f3c
  8001bb:	e8 34 01 00 00       	call   8002f4 <cprintf>
  8001c0:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c3:	a1 08 30 80 00       	mov    0x803008,%eax
  8001c8:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	50                   	push   %eax
  8001d2:	68 94 1f 80 00       	push   $0x801f94
  8001d7:	e8 18 01 00 00       	call   8002f4 <cprintf>
  8001dc:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001df:	83 ec 0c             	sub    $0xc,%esp
  8001e2:	68 ec 1e 80 00       	push   $0x801eec
  8001e7:	e8 08 01 00 00       	call   8002f4 <cprintf>
  8001ec:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001ef:	e8 29 11 00 00       	call   80131d <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001f4:	e8 19 00 00 00       	call   800212 <exit>
}
  8001f9:	90                   	nop
  8001fa:	c9                   	leave  
  8001fb:	c3                   	ret    

008001fc <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	6a 00                	push   $0x0
  800207:	e8 3f 13 00 00       	call   80154b <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
}
  80020f:	90                   	nop
  800210:	c9                   	leave  
  800211:	c3                   	ret    

00800212 <exit>:

void
exit(void)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800218:	e8 94 13 00 00       	call   8015b1 <sys_exit_env>
}
  80021d:	90                   	nop
  80021e:	c9                   	leave  
  80021f:	c3                   	ret    

00800220 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800226:	8b 45 0c             	mov    0xc(%ebp),%eax
  800229:	8b 00                	mov    (%eax),%eax
  80022b:	8d 48 01             	lea    0x1(%eax),%ecx
  80022e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800231:	89 0a                	mov    %ecx,(%edx)
  800233:	8b 55 08             	mov    0x8(%ebp),%edx
  800236:	88 d1                	mov    %dl,%cl
  800238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	3d ff 00 00 00       	cmp    $0xff,%eax
  800249:	75 2c                	jne    800277 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80024b:	a0 0c 30 80 00       	mov    0x80300c,%al
  800250:	0f b6 c0             	movzbl %al,%eax
  800253:	8b 55 0c             	mov    0xc(%ebp),%edx
  800256:	8b 12                	mov    (%edx),%edx
  800258:	89 d1                	mov    %edx,%ecx
  80025a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025d:	83 c2 08             	add    $0x8,%edx
  800260:	83 ec 04             	sub    $0x4,%esp
  800263:	50                   	push   %eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	e8 56 10 00 00       	call   8012c1 <sys_cputs>
  80026b:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800271:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027a:	8b 40 04             	mov    0x4(%eax),%eax
  80027d:	8d 50 01             	lea    0x1(%eax),%edx
  800280:	8b 45 0c             	mov    0xc(%ebp),%eax
  800283:	89 50 04             	mov    %edx,0x4(%eax)
}
  800286:	90                   	nop
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800292:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800299:	00 00 00 
	b.cnt = 0;
  80029c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8002a6:	ff 75 0c             	pushl  0xc(%ebp)
  8002a9:	ff 75 08             	pushl  0x8(%ebp)
  8002ac:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b2:	50                   	push   %eax
  8002b3:	68 20 02 80 00       	push   $0x800220
  8002b8:	e8 11 02 00 00       	call   8004ce <vprintfmt>
  8002bd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002c0:	a0 0c 30 80 00       	mov    0x80300c,%al
  8002c5:	0f b6 c0             	movzbl %al,%eax
  8002c8:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002ce:	83 ec 04             	sub    $0x4,%esp
  8002d1:	50                   	push   %eax
  8002d2:	52                   	push   %edx
  8002d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d9:	83 c0 08             	add    $0x8,%eax
  8002dc:	50                   	push   %eax
  8002dd:	e8 df 0f 00 00       	call   8012c1 <sys_cputs>
  8002e2:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002e5:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8002ec:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002f2:	c9                   	leave  
  8002f3:	c3                   	ret    

008002f4 <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002fa:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  800301:	8d 45 0c             	lea    0xc(%ebp),%eax
  800304:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800307:	8b 45 08             	mov    0x8(%ebp),%eax
  80030a:	83 ec 08             	sub    $0x8,%esp
  80030d:	ff 75 f4             	pushl  -0xc(%ebp)
  800310:	50                   	push   %eax
  800311:	e8 73 ff ff ff       	call   800289 <vcprintf>
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80031c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80031f:	c9                   	leave  
  800320:	c3                   	ret    

00800321 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  800327:	e8 d7 0f 00 00       	call   801303 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  80032c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80032f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  800332:	8b 45 08             	mov    0x8(%ebp),%eax
  800335:	83 ec 08             	sub    $0x8,%esp
  800338:	ff 75 f4             	pushl  -0xc(%ebp)
  80033b:	50                   	push   %eax
  80033c:	e8 48 ff ff ff       	call   800289 <vcprintf>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  800347:	e8 d1 0f 00 00       	call   80131d <sys_unlock_cons>
	return cnt;
  80034c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	53                   	push   %ebx
  800355:	83 ec 14             	sub    $0x14,%esp
  800358:	8b 45 10             	mov    0x10(%ebp),%eax
  80035b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80035e:	8b 45 14             	mov    0x14(%ebp),%eax
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800364:	8b 45 18             	mov    0x18(%ebp),%eax
  800367:	ba 00 00 00 00       	mov    $0x0,%edx
  80036c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80036f:	77 55                	ja     8003c6 <printnum+0x75>
  800371:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800374:	72 05                	jb     80037b <printnum+0x2a>
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	77 4b                	ja     8003c6 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80037b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80037e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800381:	8b 45 18             	mov    0x18(%ebp),%eax
  800384:	ba 00 00 00 00       	mov    $0x0,%edx
  800389:	52                   	push   %edx
  80038a:	50                   	push   %eax
  80038b:	ff 75 f4             	pushl  -0xc(%ebp)
  80038e:	ff 75 f0             	pushl  -0x10(%ebp)
  800391:	e8 76 18 00 00       	call   801c0c <__udivdi3>
  800396:	83 c4 10             	add    $0x10,%esp
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	ff 75 20             	pushl  0x20(%ebp)
  80039f:	53                   	push   %ebx
  8003a0:	ff 75 18             	pushl  0x18(%ebp)
  8003a3:	52                   	push   %edx
  8003a4:	50                   	push   %eax
  8003a5:	ff 75 0c             	pushl  0xc(%ebp)
  8003a8:	ff 75 08             	pushl  0x8(%ebp)
  8003ab:	e8 a1 ff ff ff       	call   800351 <printnum>
  8003b0:	83 c4 20             	add    $0x20,%esp
  8003b3:	eb 1a                	jmp    8003cf <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b5:	83 ec 08             	sub    $0x8,%esp
  8003b8:	ff 75 0c             	pushl  0xc(%ebp)
  8003bb:	ff 75 20             	pushl  0x20(%ebp)
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	ff d0                	call   *%eax
  8003c3:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003c6:	ff 4d 1c             	decl   0x1c(%ebp)
  8003c9:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003cd:	7f e6                	jg     8003b5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cf:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003dd:	53                   	push   %ebx
  8003de:	51                   	push   %ecx
  8003df:	52                   	push   %edx
  8003e0:	50                   	push   %eax
  8003e1:	e8 36 19 00 00       	call   801d1c <__umoddi3>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	05 d4 21 80 00       	add    $0x8021d4,%eax
  8003ee:	8a 00                	mov    (%eax),%al
  8003f0:	0f be c0             	movsbl %al,%eax
  8003f3:	83 ec 08             	sub    $0x8,%esp
  8003f6:	ff 75 0c             	pushl  0xc(%ebp)
  8003f9:	50                   	push   %eax
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	ff d0                	call   *%eax
  8003ff:	83 c4 10             	add    $0x10,%esp
}
  800402:	90                   	nop
  800403:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800406:	c9                   	leave  
  800407:	c3                   	ret    

00800408 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80040b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80040f:	7e 1c                	jle    80042d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800411:	8b 45 08             	mov    0x8(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	8d 50 08             	lea    0x8(%eax),%edx
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	89 10                	mov    %edx,(%eax)
  80041e:	8b 45 08             	mov    0x8(%ebp),%eax
  800421:	8b 00                	mov    (%eax),%eax
  800423:	83 e8 08             	sub    $0x8,%eax
  800426:	8b 50 04             	mov    0x4(%eax),%edx
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	eb 40                	jmp    80046d <getuint+0x65>
	else if (lflag)
  80042d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800431:	74 1e                	je     800451 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	8b 00                	mov    (%eax),%eax
  800438:	8d 50 04             	lea    0x4(%eax),%edx
  80043b:	8b 45 08             	mov    0x8(%ebp),%eax
  80043e:	89 10                	mov    %edx,(%eax)
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	83 e8 04             	sub    $0x4,%eax
  800448:	8b 00                	mov    (%eax),%eax
  80044a:	ba 00 00 00 00       	mov    $0x0,%edx
  80044f:	eb 1c                	jmp    80046d <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800451:	8b 45 08             	mov    0x8(%ebp),%eax
  800454:	8b 00                	mov    (%eax),%eax
  800456:	8d 50 04             	lea    0x4(%eax),%edx
  800459:	8b 45 08             	mov    0x8(%ebp),%eax
  80045c:	89 10                	mov    %edx,(%eax)
  80045e:	8b 45 08             	mov    0x8(%ebp),%eax
  800461:	8b 00                	mov    (%eax),%eax
  800463:	83 e8 04             	sub    $0x4,%eax
  800466:	8b 00                	mov    (%eax),%eax
  800468:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80046d:	5d                   	pop    %ebp
  80046e:	c3                   	ret    

0080046f <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800472:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800476:	7e 1c                	jle    800494 <getint+0x25>
		return va_arg(*ap, long long);
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	8d 50 08             	lea    0x8(%eax),%edx
  800480:	8b 45 08             	mov    0x8(%ebp),%eax
  800483:	89 10                	mov    %edx,(%eax)
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	83 e8 08             	sub    $0x8,%eax
  80048d:	8b 50 04             	mov    0x4(%eax),%edx
  800490:	8b 00                	mov    (%eax),%eax
  800492:	eb 38                	jmp    8004cc <getint+0x5d>
	else if (lflag)
  800494:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800498:	74 1a                	je     8004b4 <getint+0x45>
		return va_arg(*ap, long);
  80049a:	8b 45 08             	mov    0x8(%ebp),%eax
  80049d:	8b 00                	mov    (%eax),%eax
  80049f:	8d 50 04             	lea    0x4(%eax),%edx
  8004a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a5:	89 10                	mov    %edx,(%eax)
  8004a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004aa:	8b 00                	mov    (%eax),%eax
  8004ac:	83 e8 04             	sub    $0x4,%eax
  8004af:	8b 00                	mov    (%eax),%eax
  8004b1:	99                   	cltd   
  8004b2:	eb 18                	jmp    8004cc <getint+0x5d>
	else
		return va_arg(*ap, int);
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 50 04             	lea    0x4(%eax),%edx
  8004bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bf:	89 10                	mov    %edx,(%eax)
  8004c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c4:	8b 00                	mov    (%eax),%eax
  8004c6:	83 e8 04             	sub    $0x4,%eax
  8004c9:	8b 00                	mov    (%eax),%eax
  8004cb:	99                   	cltd   
}
  8004cc:	5d                   	pop    %ebp
  8004cd:	c3                   	ret    

008004ce <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	56                   	push   %esi
  8004d2:	53                   	push   %ebx
  8004d3:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d6:	eb 17                	jmp    8004ef <vprintfmt+0x21>
			if (ch == '\0')
  8004d8:	85 db                	test   %ebx,%ebx
  8004da:	0f 84 c1 03 00 00    	je     8008a1 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004e0:	83 ec 08             	sub    $0x8,%esp
  8004e3:	ff 75 0c             	pushl  0xc(%ebp)
  8004e6:	53                   	push   %ebx
  8004e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ea:	ff d0                	call   *%eax
  8004ec:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f2:	8d 50 01             	lea    0x1(%eax),%edx
  8004f5:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f8:	8a 00                	mov    (%eax),%al
  8004fa:	0f b6 d8             	movzbl %al,%ebx
  8004fd:	83 fb 25             	cmp    $0x25,%ebx
  800500:	75 d6                	jne    8004d8 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800502:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800506:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80050d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800514:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80051b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800522:	8b 45 10             	mov    0x10(%ebp),%eax
  800525:	8d 50 01             	lea    0x1(%eax),%edx
  800528:	89 55 10             	mov    %edx,0x10(%ebp)
  80052b:	8a 00                	mov    (%eax),%al
  80052d:	0f b6 d8             	movzbl %al,%ebx
  800530:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800533:	83 f8 5b             	cmp    $0x5b,%eax
  800536:	0f 87 3d 03 00 00    	ja     800879 <vprintfmt+0x3ab>
  80053c:	8b 04 85 f8 21 80 00 	mov    0x8021f8(,%eax,4),%eax
  800543:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800545:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800549:	eb d7                	jmp    800522 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80054b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80054f:	eb d1                	jmp    800522 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800551:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800558:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80055b:	89 d0                	mov    %edx,%eax
  80055d:	c1 e0 02             	shl    $0x2,%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	01 c0                	add    %eax,%eax
  800564:	01 d8                	add    %ebx,%eax
  800566:	83 e8 30             	sub    $0x30,%eax
  800569:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80056c:	8b 45 10             	mov    0x10(%ebp),%eax
  80056f:	8a 00                	mov    (%eax),%al
  800571:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800574:	83 fb 2f             	cmp    $0x2f,%ebx
  800577:	7e 3e                	jle    8005b7 <vprintfmt+0xe9>
  800579:	83 fb 39             	cmp    $0x39,%ebx
  80057c:	7f 39                	jg     8005b7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80057e:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800581:	eb d5                	jmp    800558 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800583:	8b 45 14             	mov    0x14(%ebp),%eax
  800586:	83 c0 04             	add    $0x4,%eax
  800589:	89 45 14             	mov    %eax,0x14(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	83 e8 04             	sub    $0x4,%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800597:	eb 1f                	jmp    8005b8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800599:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80059d:	79 83                	jns    800522 <vprintfmt+0x54>
				width = 0;
  80059f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8005a6:	e9 77 ff ff ff       	jmp    800522 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8005ab:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8005b2:	e9 6b ff ff ff       	jmp    800522 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8005b7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005bc:	0f 89 60 ff ff ff    	jns    800522 <vprintfmt+0x54>
				width = precision, precision = -1;
  8005c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005c8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005cf:	e9 4e ff ff ff       	jmp    800522 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005d4:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005d7:	e9 46 ff ff ff       	jmp    800522 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	83 c0 04             	add    $0x4,%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	83 e8 04             	sub    $0x4,%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	83 ec 08             	sub    $0x8,%esp
  8005f0:	ff 75 0c             	pushl  0xc(%ebp)
  8005f3:	50                   	push   %eax
  8005f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f7:	ff d0                	call   *%eax
  8005f9:	83 c4 10             	add    $0x10,%esp
			break;
  8005fc:	e9 9b 02 00 00       	jmp    80089c <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	83 c0 04             	add    $0x4,%eax
  800607:	89 45 14             	mov    %eax,0x14(%ebp)
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 e8 04             	sub    $0x4,%eax
  800610:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800612:	85 db                	test   %ebx,%ebx
  800614:	79 02                	jns    800618 <vprintfmt+0x14a>
				err = -err;
  800616:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800618:	83 fb 64             	cmp    $0x64,%ebx
  80061b:	7f 0b                	jg     800628 <vprintfmt+0x15a>
  80061d:	8b 34 9d 40 20 80 00 	mov    0x802040(,%ebx,4),%esi
  800624:	85 f6                	test   %esi,%esi
  800626:	75 19                	jne    800641 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800628:	53                   	push   %ebx
  800629:	68 e5 21 80 00       	push   $0x8021e5
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 08             	pushl  0x8(%ebp)
  800634:	e8 70 02 00 00       	call   8008a9 <printfmt>
  800639:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80063c:	e9 5b 02 00 00       	jmp    80089c <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800641:	56                   	push   %esi
  800642:	68 ee 21 80 00       	push   $0x8021ee
  800647:	ff 75 0c             	pushl  0xc(%ebp)
  80064a:	ff 75 08             	pushl  0x8(%ebp)
  80064d:	e8 57 02 00 00       	call   8008a9 <printfmt>
  800652:	83 c4 10             	add    $0x10,%esp
			break;
  800655:	e9 42 02 00 00       	jmp    80089c <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80065a:	8b 45 14             	mov    0x14(%ebp),%eax
  80065d:	83 c0 04             	add    $0x4,%eax
  800660:	89 45 14             	mov    %eax,0x14(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 e8 04             	sub    $0x4,%eax
  800669:	8b 30                	mov    (%eax),%esi
  80066b:	85 f6                	test   %esi,%esi
  80066d:	75 05                	jne    800674 <vprintfmt+0x1a6>
				p = "(null)";
  80066f:	be f1 21 80 00       	mov    $0x8021f1,%esi
			if (width > 0 && padc != '-')
  800674:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800678:	7e 6d                	jle    8006e7 <vprintfmt+0x219>
  80067a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80067e:	74 67                	je     8006e7 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800680:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800683:	83 ec 08             	sub    $0x8,%esp
  800686:	50                   	push   %eax
  800687:	56                   	push   %esi
  800688:	e8 26 05 00 00       	call   800bb3 <strnlen>
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800693:	eb 16                	jmp    8006ab <vprintfmt+0x1dd>
					putch(padc, putdat);
  800695:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 0c             	pushl  0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	ff d0                	call   *%eax
  8006a5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a8:	ff 4d e4             	decl   -0x1c(%ebp)
  8006ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006af:	7f e4                	jg     800695 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006b1:	eb 34                	jmp    8006e7 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8006b3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006b7:	74 1c                	je     8006d5 <vprintfmt+0x207>
  8006b9:	83 fb 1f             	cmp    $0x1f,%ebx
  8006bc:	7e 05                	jle    8006c3 <vprintfmt+0x1f5>
  8006be:	83 fb 7e             	cmp    $0x7e,%ebx
  8006c1:	7e 12                	jle    8006d5 <vprintfmt+0x207>
					putch('?', putdat);
  8006c3:	83 ec 08             	sub    $0x8,%esp
  8006c6:	ff 75 0c             	pushl  0xc(%ebp)
  8006c9:	6a 3f                	push   $0x3f
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	ff d0                	call   *%eax
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	eb 0f                	jmp    8006e4 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006d5:	83 ec 08             	sub    $0x8,%esp
  8006d8:	ff 75 0c             	pushl  0xc(%ebp)
  8006db:	53                   	push   %ebx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	ff d0                	call   *%eax
  8006e1:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e4:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e7:	89 f0                	mov    %esi,%eax
  8006e9:	8d 70 01             	lea    0x1(%eax),%esi
  8006ec:	8a 00                	mov    (%eax),%al
  8006ee:	0f be d8             	movsbl %al,%ebx
  8006f1:	85 db                	test   %ebx,%ebx
  8006f3:	74 24                	je     800719 <vprintfmt+0x24b>
  8006f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006f9:	78 b8                	js     8006b3 <vprintfmt+0x1e5>
  8006fb:	ff 4d e0             	decl   -0x20(%ebp)
  8006fe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800702:	79 af                	jns    8006b3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800704:	eb 13                	jmp    800719 <vprintfmt+0x24b>
				putch(' ', putdat);
  800706:	83 ec 08             	sub    $0x8,%esp
  800709:	ff 75 0c             	pushl  0xc(%ebp)
  80070c:	6a 20                	push   $0x20
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800716:	ff 4d e4             	decl   -0x1c(%ebp)
  800719:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80071d:	7f e7                	jg     800706 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80071f:	e9 78 01 00 00       	jmp    80089c <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	ff 75 e8             	pushl  -0x18(%ebp)
  80072a:	8d 45 14             	lea    0x14(%ebp),%eax
  80072d:	50                   	push   %eax
  80072e:	e8 3c fd ff ff       	call   80046f <getint>
  800733:	83 c4 10             	add    $0x10,%esp
  800736:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800739:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80073c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800742:	85 d2                	test   %edx,%edx
  800744:	79 23                	jns    800769 <vprintfmt+0x29b>
				putch('-', putdat);
  800746:	83 ec 08             	sub    $0x8,%esp
  800749:	ff 75 0c             	pushl  0xc(%ebp)
  80074c:	6a 2d                	push   $0x2d
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	ff d0                	call   *%eax
  800753:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800756:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800759:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80075c:	f7 d8                	neg    %eax
  80075e:	83 d2 00             	adc    $0x0,%edx
  800761:	f7 da                	neg    %edx
  800763:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800766:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800769:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800770:	e9 bc 00 00 00       	jmp    800831 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800775:	83 ec 08             	sub    $0x8,%esp
  800778:	ff 75 e8             	pushl  -0x18(%ebp)
  80077b:	8d 45 14             	lea    0x14(%ebp),%eax
  80077e:	50                   	push   %eax
  80077f:	e8 84 fc ff ff       	call   800408 <getuint>
  800784:	83 c4 10             	add    $0x10,%esp
  800787:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80078a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80078d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800794:	e9 98 00 00 00       	jmp    800831 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800799:	83 ec 08             	sub    $0x8,%esp
  80079c:	ff 75 0c             	pushl  0xc(%ebp)
  80079f:	6a 58                	push   $0x58
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	ff d0                	call   *%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a9:	83 ec 08             	sub    $0x8,%esp
  8007ac:	ff 75 0c             	pushl  0xc(%ebp)
  8007af:	6a 58                	push   $0x58
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	ff d0                	call   *%eax
  8007b6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007b9:	83 ec 08             	sub    $0x8,%esp
  8007bc:	ff 75 0c             	pushl  0xc(%ebp)
  8007bf:	6a 58                	push   $0x58
  8007c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c4:	ff d0                	call   *%eax
  8007c6:	83 c4 10             	add    $0x10,%esp
			break;
  8007c9:	e9 ce 00 00 00       	jmp    80089c <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 30                	push   $0x30
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007de:	83 ec 08             	sub    $0x8,%esp
  8007e1:	ff 75 0c             	pushl  0xc(%ebp)
  8007e4:	6a 78                	push   $0x78
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	ff d0                	call   *%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	83 c0 04             	add    $0x4,%eax
  8007f4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 e8 04             	sub    $0x4,%eax
  8007fd:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800802:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800809:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800810:	eb 1f                	jmp    800831 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800812:	83 ec 08             	sub    $0x8,%esp
  800815:	ff 75 e8             	pushl  -0x18(%ebp)
  800818:	8d 45 14             	lea    0x14(%ebp),%eax
  80081b:	50                   	push   %eax
  80081c:	e8 e7 fb ff ff       	call   800408 <getuint>
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800827:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80082a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800831:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800838:	83 ec 04             	sub    $0x4,%esp
  80083b:	52                   	push   %edx
  80083c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80083f:	50                   	push   %eax
  800840:	ff 75 f4             	pushl  -0xc(%ebp)
  800843:	ff 75 f0             	pushl  -0x10(%ebp)
  800846:	ff 75 0c             	pushl  0xc(%ebp)
  800849:	ff 75 08             	pushl  0x8(%ebp)
  80084c:	e8 00 fb ff ff       	call   800351 <printnum>
  800851:	83 c4 20             	add    $0x20,%esp
			break;
  800854:	eb 46                	jmp    80089c <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	53                   	push   %ebx
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			break;
  800865:	eb 35                	jmp    80089c <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  800867:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  80086e:	eb 2c                	jmp    80089c <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800870:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  800877:	eb 23                	jmp    80089c <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 0c             	pushl  0xc(%ebp)
  80087f:	6a 25                	push   $0x25
  800881:	8b 45 08             	mov    0x8(%ebp),%eax
  800884:	ff d0                	call   *%eax
  800886:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800889:	ff 4d 10             	decl   0x10(%ebp)
  80088c:	eb 03                	jmp    800891 <vprintfmt+0x3c3>
  80088e:	ff 4d 10             	decl   0x10(%ebp)
  800891:	8b 45 10             	mov    0x10(%ebp),%eax
  800894:	48                   	dec    %eax
  800895:	8a 00                	mov    (%eax),%al
  800897:	3c 25                	cmp    $0x25,%al
  800899:	75 f3                	jne    80088e <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  80089b:	90                   	nop
		}
	}
  80089c:	e9 35 fc ff ff       	jmp    8004d6 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8008a1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8008a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5d                   	pop    %ebp
  8008a8:	c3                   	ret    

008008a9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008a9:	55                   	push   %ebp
  8008aa:	89 e5                	mov    %esp,%ebp
  8008ac:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8008af:	8d 45 10             	lea    0x10(%ebp),%eax
  8008b2:	83 c0 04             	add    $0x4,%eax
  8008b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bb:	ff 75 f4             	pushl  -0xc(%ebp)
  8008be:	50                   	push   %eax
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 04 fc ff ff       	call   8004ce <vprintfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008cd:	90                   	nop
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    

008008d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d6:	8b 40 08             	mov    0x8(%eax),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008df:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e5:	8b 10                	mov    (%eax),%edx
  8008e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ea:	8b 40 04             	mov    0x4(%eax),%eax
  8008ed:	39 c2                	cmp    %eax,%edx
  8008ef:	73 12                	jae    800903 <sprintputch+0x33>
		*b->buf++ = ch;
  8008f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f4:	8b 00                	mov    (%eax),%eax
  8008f6:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fc:	89 0a                	mov    %ecx,(%edx)
  8008fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800901:	88 10                	mov    %dl,(%eax)
}
  800903:	90                   	nop
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800912:	8b 45 0c             	mov    0xc(%ebp),%eax
  800915:	8d 50 ff             	lea    -0x1(%eax),%edx
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	01 d0                	add    %edx,%eax
  80091d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800927:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80092b:	74 06                	je     800933 <vsnprintf+0x2d>
  80092d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800931:	7f 07                	jg     80093a <vsnprintf+0x34>
		return -E_INVAL;
  800933:	b8 03 00 00 00       	mov    $0x3,%eax
  800938:	eb 20                	jmp    80095a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80093a:	ff 75 14             	pushl  0x14(%ebp)
  80093d:	ff 75 10             	pushl  0x10(%ebp)
  800940:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	68 d0 08 80 00       	push   $0x8008d0
  800949:	e8 80 fb ff ff       	call   8004ce <vprintfmt>
  80094e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800951:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800954:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800957:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800962:	8d 45 10             	lea    0x10(%ebp),%eax
  800965:	83 c0 04             	add    $0x4,%eax
  800968:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	ff 75 f4             	pushl  -0xc(%ebp)
  800971:	50                   	push   %eax
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	ff 75 08             	pushl  0x8(%ebp)
  800978:	e8 89 ff ff ff       	call   800906 <vsnprintf>
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800983:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800986:	c9                   	leave  
  800987:	c3                   	ret    

00800988 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	83 ec 18             	sub    $0x18,%esp
	int i, c, echoing;

	if (prompt != NULL)
  80098e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800992:	74 13                	je     8009a7 <readline+0x1f>
		cprintf("%s", prompt);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 08             	pushl  0x8(%ebp)
  80099a:	68 68 23 80 00       	push   $0x802368
  80099f:	e8 50 f9 ff ff       	call   8002f4 <cprintf>
  8009a4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8009ae:	83 ec 0c             	sub    $0xc,%esp
  8009b1:	6a 00                	push   $0x0
  8009b3:	e8 61 10 00 00       	call   801a19 <iscons>
  8009b8:	83 c4 10             	add    $0x10,%esp
  8009bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8009be:	e8 43 10 00 00       	call   801a06 <getchar>
  8009c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8009c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009ca:	79 22                	jns    8009ee <readline+0x66>
			if (c != -E_EOF)
  8009cc:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8009d0:	0f 84 ad 00 00 00    	je     800a83 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 ec             	pushl  -0x14(%ebp)
  8009dc:	68 6b 23 80 00       	push   $0x80236b
  8009e1:	e8 0e f9 ff ff       	call   8002f4 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
			break;
  8009e9:	e9 95 00 00 00       	jmp    800a83 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8009ee:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8009f2:	7e 34                	jle    800a28 <readline+0xa0>
  8009f4:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8009fb:	7f 2b                	jg     800a28 <readline+0xa0>
			if (echoing)
  8009fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a01:	74 0e                	je     800a11 <readline+0x89>
				cputchar(c);
  800a03:	83 ec 0c             	sub    $0xc,%esp
  800a06:	ff 75 ec             	pushl  -0x14(%ebp)
  800a09:	e8 d9 0f 00 00       	call   8019e7 <cputchar>
  800a0e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  800a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a14:	8d 50 01             	lea    0x1(%eax),%edx
  800a17:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800a1a:	89 c2                	mov    %eax,%edx
  800a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1f:	01 d0                	add    %edx,%eax
  800a21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a24:	88 10                	mov    %dl,(%eax)
  800a26:	eb 56                	jmp    800a7e <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  800a28:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800a2c:	75 1f                	jne    800a4d <readline+0xc5>
  800a2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a32:	7e 19                	jle    800a4d <readline+0xc5>
			if (echoing)
  800a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a38:	74 0e                	je     800a48 <readline+0xc0>
				cputchar(c);
  800a3a:	83 ec 0c             	sub    $0xc,%esp
  800a3d:	ff 75 ec             	pushl  -0x14(%ebp)
  800a40:	e8 a2 0f 00 00       	call   8019e7 <cputchar>
  800a45:	83 c4 10             	add    $0x10,%esp

			i--;
  800a48:	ff 4d f4             	decl   -0xc(%ebp)
  800a4b:	eb 31                	jmp    800a7e <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  800a4d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800a51:	74 0a                	je     800a5d <readline+0xd5>
  800a53:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800a57:	0f 85 61 ff ff ff    	jne    8009be <readline+0x36>
			if (echoing)
  800a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a61:	74 0e                	je     800a71 <readline+0xe9>
				cputchar(c);
  800a63:	83 ec 0c             	sub    $0xc,%esp
  800a66:	ff 75 ec             	pushl  -0x14(%ebp)
  800a69:	e8 79 0f 00 00       	call   8019e7 <cputchar>
  800a6e:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  800a71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a77:	01 d0                	add    %edx,%eax
  800a79:	c6 00 00             	movb   $0x0,(%eax)
			break;
  800a7c:	eb 06                	jmp    800a84 <readline+0xfc>
		}
	}
  800a7e:	e9 3b ff ff ff       	jmp    8009be <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			break;
  800a83:	90                   	nop

			buf[i] = 0;
			break;
		}
	}
}
  800a84:	90                   	nop
  800a85:	c9                   	leave  
  800a86:	c3                   	ret    

00800a87 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  800a87:	55                   	push   %ebp
  800a88:	89 e5                	mov    %esp,%ebp
  800a8a:	83 ec 18             	sub    $0x18,%esp
	sys_lock_cons();
  800a8d:	e8 71 08 00 00       	call   801303 <sys_lock_cons>
	{
		int i, c, echoing;

		if (prompt != NULL)
  800a92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a96:	74 13                	je     800aab <atomic_readline+0x24>
			cprintf("%s", prompt);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 08             	pushl  0x8(%ebp)
  800a9e:	68 68 23 80 00       	push   $0x802368
  800aa3:	e8 4c f8 ff ff       	call   8002f4 <cprintf>
  800aa8:	83 c4 10             	add    $0x10,%esp

		i = 0;
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		echoing = iscons(0);
  800ab2:	83 ec 0c             	sub    $0xc,%esp
  800ab5:	6a 00                	push   $0x0
  800ab7:	e8 5d 0f 00 00       	call   801a19 <iscons>
  800abc:	83 c4 10             	add    $0x10,%esp
  800abf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		while (1) {
			c = getchar();
  800ac2:	e8 3f 0f 00 00       	call   801a06 <getchar>
  800ac7:	89 45 ec             	mov    %eax,-0x14(%ebp)
			if (c < 0) {
  800aca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800ace:	79 22                	jns    800af2 <atomic_readline+0x6b>
				if (c != -E_EOF)
  800ad0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  800ad4:	0f 84 ad 00 00 00    	je     800b87 <atomic_readline+0x100>
					cprintf("read error: %e\n", c);
  800ada:	83 ec 08             	sub    $0x8,%esp
  800add:	ff 75 ec             	pushl  -0x14(%ebp)
  800ae0:	68 6b 23 80 00       	push   $0x80236b
  800ae5:	e8 0a f8 ff ff       	call   8002f4 <cprintf>
  800aea:	83 c4 10             	add    $0x10,%esp
				break;
  800aed:	e9 95 00 00 00       	jmp    800b87 <atomic_readline+0x100>
			} else if (c >= ' ' && i < BUFLEN-1) {
  800af2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  800af6:	7e 34                	jle    800b2c <atomic_readline+0xa5>
  800af8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  800aff:	7f 2b                	jg     800b2c <atomic_readline+0xa5>
				if (echoing)
  800b01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b05:	74 0e                	je     800b15 <atomic_readline+0x8e>
					cputchar(c);
  800b07:	83 ec 0c             	sub    $0xc,%esp
  800b0a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b0d:	e8 d5 0e 00 00       	call   8019e7 <cputchar>
  800b12:	83 c4 10             	add    $0x10,%esp
				buf[i++] = c;
  800b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b18:	8d 50 01             	lea    0x1(%eax),%edx
  800b1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b1e:	89 c2                	mov    %eax,%edx
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b28:	88 10                	mov    %dl,(%eax)
  800b2a:	eb 56                	jmp    800b82 <atomic_readline+0xfb>
			} else if (c == '\b' && i > 0) {
  800b2c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  800b30:	75 1f                	jne    800b51 <atomic_readline+0xca>
  800b32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800b36:	7e 19                	jle    800b51 <atomic_readline+0xca>
				if (echoing)
  800b38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b3c:	74 0e                	je     800b4c <atomic_readline+0xc5>
					cputchar(c);
  800b3e:	83 ec 0c             	sub    $0xc,%esp
  800b41:	ff 75 ec             	pushl  -0x14(%ebp)
  800b44:	e8 9e 0e 00 00       	call   8019e7 <cputchar>
  800b49:	83 c4 10             	add    $0x10,%esp
				i--;
  800b4c:	ff 4d f4             	decl   -0xc(%ebp)
  800b4f:	eb 31                	jmp    800b82 <atomic_readline+0xfb>
			} else if (c == '\n' || c == '\r') {
  800b51:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  800b55:	74 0a                	je     800b61 <atomic_readline+0xda>
  800b57:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  800b5b:	0f 85 61 ff ff ff    	jne    800ac2 <atomic_readline+0x3b>
				if (echoing)
  800b61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b65:	74 0e                	je     800b75 <atomic_readline+0xee>
					cputchar(c);
  800b67:	83 ec 0c             	sub    $0xc,%esp
  800b6a:	ff 75 ec             	pushl  -0x14(%ebp)
  800b6d:	e8 75 0e 00 00       	call   8019e7 <cputchar>
  800b72:	83 c4 10             	add    $0x10,%esp
				buf[i] = 0;
  800b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	c6 00 00             	movb   $0x0,(%eax)
				break;
  800b80:	eb 06                	jmp    800b88 <atomic_readline+0x101>
			}
		}
  800b82:	e9 3b ff ff ff       	jmp    800ac2 <atomic_readline+0x3b>
		while (1) {
			c = getchar();
			if (c < 0) {
				if (c != -E_EOF)
					cprintf("read error: %e\n", c);
				break;
  800b87:	90                   	nop
				buf[i] = 0;
				break;
			}
		}
	}
	sys_unlock_cons();
  800b88:	e8 90 07 00 00       	call   80131d <sys_unlock_cons>
}
  800b8d:	90                   	nop
  800b8e:	c9                   	leave  
  800b8f:	c3                   	ret    

00800b90 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9d:	eb 06                	jmp    800ba5 <strlen+0x15>
		n++;
  800b9f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba2:	ff 45 08             	incl   0x8(%ebp)
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	8a 00                	mov    (%eax),%al
  800baa:	84 c0                	test   %al,%al
  800bac:	75 f1                	jne    800b9f <strlen+0xf>
		n++;
	return n;
  800bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
  800bb6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc0:	eb 09                	jmp    800bcb <strnlen+0x18>
		n++;
  800bc2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc5:	ff 45 08             	incl   0x8(%ebp)
  800bc8:	ff 4d 0c             	decl   0xc(%ebp)
  800bcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bcf:	74 09                	je     800bda <strnlen+0x27>
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	8a 00                	mov    (%eax),%al
  800bd6:	84 c0                	test   %al,%al
  800bd8:	75 e8                	jne    800bc2 <strnlen+0xf>
		n++;
	return n;
  800bda:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bdd:	c9                   	leave  
  800bde:	c3                   	ret    

00800bdf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bdf:	55                   	push   %ebp
  800be0:	89 e5                	mov    %esp,%ebp
  800be2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800beb:	90                   	nop
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	8d 50 01             	lea    0x1(%eax),%edx
  800bf2:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bfe:	8a 12                	mov    (%edx),%dl
  800c00:	88 10                	mov    %dl,(%eax)
  800c02:	8a 00                	mov    (%eax),%al
  800c04:	84 c0                	test   %al,%al
  800c06:	75 e4                	jne    800bec <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0b:	c9                   	leave  
  800c0c:	c3                   	ret    

00800c0d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0d:	55                   	push   %ebp
  800c0e:	89 e5                	mov    %esp,%ebp
  800c10:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c13:	8b 45 08             	mov    0x8(%ebp),%eax
  800c16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c19:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c20:	eb 1f                	jmp    800c41 <strncpy+0x34>
		*dst++ = *src;
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8a 12                	mov    (%edx),%dl
  800c30:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8a 00                	mov    (%eax),%al
  800c37:	84 c0                	test   %al,%al
  800c39:	74 03                	je     800c3e <strncpy+0x31>
			src++;
  800c3b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3e:	ff 45 fc             	incl   -0x4(%ebp)
  800c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c44:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c47:	72 d9                	jb     800c22 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c49:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5e:	74 30                	je     800c90 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c60:	eb 16                	jmp    800c78 <strlcpy+0x2a>
			*dst++ = *src++;
  800c62:	8b 45 08             	mov    0x8(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c71:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c74:	8a 12                	mov    (%edx),%dl
  800c76:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c78:	ff 4d 10             	decl   0x10(%ebp)
  800c7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7f:	74 09                	je     800c8a <strlcpy+0x3c>
  800c81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c84:	8a 00                	mov    (%eax),%al
  800c86:	84 c0                	test   %al,%al
  800c88:	75 d8                	jne    800c62 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	29 c2                	sub    %eax,%edx
  800c98:	89 d0                	mov    %edx,%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800c9f:	eb 06                	jmp    800ca7 <strcmp+0xb>
		p++, q++;
  800ca1:	ff 45 08             	incl   0x8(%ebp)
  800ca4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8a 00                	mov    (%eax),%al
  800cac:	84 c0                	test   %al,%al
  800cae:	74 0e                	je     800cbe <strcmp+0x22>
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	8a 10                	mov    (%eax),%dl
  800cb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	38 c2                	cmp    %al,%dl
  800cbc:	74 e3                	je     800ca1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	0f b6 d0             	movzbl %al,%edx
  800cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc9:	8a 00                	mov    (%eax),%al
  800ccb:	0f b6 c0             	movzbl %al,%eax
  800cce:	29 c2                	sub    %eax,%edx
  800cd0:	89 d0                	mov    %edx,%eax
}
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd7:	eb 09                	jmp    800ce2 <strncmp+0xe>
		n--, p++, q++;
  800cd9:	ff 4d 10             	decl   0x10(%ebp)
  800cdc:	ff 45 08             	incl   0x8(%ebp)
  800cdf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce6:	74 17                	je     800cff <strncmp+0x2b>
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	74 0e                	je     800cff <strncmp+0x2b>
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8a 10                	mov    (%eax),%dl
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	38 c2                	cmp    %al,%dl
  800cfd:	74 da                	je     800cd9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	75 07                	jne    800d0c <strncmp+0x38>
		return 0;
  800d05:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0a:	eb 14                	jmp    800d20 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 00                	mov    (%eax),%al
  800d11:	0f b6 d0             	movzbl %al,%edx
  800d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	0f b6 c0             	movzbl %al,%eax
  800d1c:	29 c2                	sub    %eax,%edx
  800d1e:	89 d0                	mov    %edx,%eax
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 04             	sub    $0x4,%esp
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2e:	eb 12                	jmp    800d42 <strchr+0x20>
		if (*s == c)
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	8a 00                	mov    (%eax),%al
  800d35:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d38:	75 05                	jne    800d3f <strchr+0x1d>
			return (char *) s;
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	eb 11                	jmp    800d50 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e5                	jne    800d30 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 04             	sub    $0x4,%esp
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5e:	eb 0d                	jmp    800d6d <strfind+0x1b>
		if (*s == c)
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d68:	74 0e                	je     800d78 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6a:	ff 45 08             	incl   0x8(%ebp)
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	84 c0                	test   %al,%al
  800d74:	75 ea                	jne    800d60 <strfind+0xe>
  800d76:	eb 01                	jmp    800d79 <strfind+0x27>
		if (*s == c)
			break;
  800d78:	90                   	nop
	return (char *) s;
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7c:	c9                   	leave  
  800d7d:	c3                   	ret    

00800d7e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d90:	eb 0e                	jmp    800da0 <memset+0x22>
		*p++ = c;
  800d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d95:	8d 50 01             	lea    0x1(%eax),%edx
  800d98:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da0:	ff 4d f8             	decl   -0x8(%ebp)
  800da3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da7:	79 e9                	jns    800d92 <memset+0x14>
		*p++ = c;

	return v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc0:	eb 16                	jmp    800dd8 <memcpy+0x2a>
		*d++ = *s++;
  800dc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc5:	8d 50 01             	lea    0x1(%eax),%edx
  800dc8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dce:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd4:	8a 12                	mov    (%edx),%dl
  800dd6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dde:	89 55 10             	mov    %edx,0x10(%ebp)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	75 dd                	jne    800dc2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de8:	c9                   	leave  
  800de9:	c3                   	ret    

00800dea <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dff:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e02:	73 50                	jae    800e54 <memmove+0x6a>
  800e04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	01 d0                	add    %edx,%eax
  800e0c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e0f:	76 43                	jbe    800e54 <memmove+0x6a>
		s += n;
  800e11:	8b 45 10             	mov    0x10(%ebp),%eax
  800e14:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e17:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1d:	eb 10                	jmp    800e2f <memmove+0x45>
			*--d = *--s;
  800e1f:	ff 4d f8             	decl   -0x8(%ebp)
  800e22:	ff 4d fc             	decl   -0x4(%ebp)
  800e25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e35:	89 55 10             	mov    %edx,0x10(%ebp)
  800e38:	85 c0                	test   %eax,%eax
  800e3a:	75 e3                	jne    800e1f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3c:	eb 23                	jmp    800e61 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e41:	8d 50 01             	lea    0x1(%eax),%edx
  800e44:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e50:	8a 12                	mov    (%edx),%dl
  800e52:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 dd                	jne    800e3e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e78:	eb 2a                	jmp    800ea4 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7d:	8a 10                	mov    (%eax),%dl
  800e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	38 c2                	cmp    %al,%dl
  800e86:	74 16                	je     800e9e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 00                	mov    (%eax),%al
  800e8d:	0f b6 d0             	movzbl %al,%edx
  800e90:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	0f b6 c0             	movzbl %al,%eax
  800e98:	29 c2                	sub    %eax,%edx
  800e9a:	89 d0                	mov    %edx,%eax
  800e9c:	eb 18                	jmp    800eb6 <memcmp+0x50>
		s1++, s2++;
  800e9e:	ff 45 fc             	incl   -0x4(%ebp)
  800ea1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 c9                	jne    800e7a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb6:	c9                   	leave  
  800eb7:	c3                   	ret    

00800eb8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	01 d0                	add    %edx,%eax
  800ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ec9:	eb 15                	jmp    800ee0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ece:	8a 00                	mov    (%eax),%al
  800ed0:	0f b6 d0             	movzbl %al,%edx
  800ed3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed6:	0f b6 c0             	movzbl %al,%eax
  800ed9:	39 c2                	cmp    %eax,%edx
  800edb:	74 0d                	je     800eea <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800edd:	ff 45 08             	incl   0x8(%ebp)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee6:	72 e3                	jb     800ecb <memfind+0x13>
  800ee8:	eb 01                	jmp    800eeb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eea:	90                   	nop
	return (void *) s;
  800eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eee:	c9                   	leave  
  800eef:	c3                   	ret    

00800ef0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f04:	eb 03                	jmp    800f09 <strtol+0x19>
		s++;
  800f06:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 00                	mov    (%eax),%al
  800f0e:	3c 20                	cmp    $0x20,%al
  800f10:	74 f4                	je     800f06 <strtol+0x16>
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8a 00                	mov    (%eax),%al
  800f17:	3c 09                	cmp    $0x9,%al
  800f19:	74 eb                	je     800f06 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1e:	8a 00                	mov    (%eax),%al
  800f20:	3c 2b                	cmp    $0x2b,%al
  800f22:	75 05                	jne    800f29 <strtol+0x39>
		s++;
  800f24:	ff 45 08             	incl   0x8(%ebp)
  800f27:	eb 13                	jmp    800f3c <strtol+0x4c>
	else if (*s == '-')
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 2d                	cmp    $0x2d,%al
  800f30:	75 0a                	jne    800f3c <strtol+0x4c>
		s++, neg = 1;
  800f32:	ff 45 08             	incl   0x8(%ebp)
  800f35:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f40:	74 06                	je     800f48 <strtol+0x58>
  800f42:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f46:	75 20                	jne    800f68 <strtol+0x78>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 30                	cmp    $0x30,%al
  800f4f:	75 17                	jne    800f68 <strtol+0x78>
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	40                   	inc    %eax
  800f55:	8a 00                	mov    (%eax),%al
  800f57:	3c 78                	cmp    $0x78,%al
  800f59:	75 0d                	jne    800f68 <strtol+0x78>
		s += 2, base = 16;
  800f5b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f5f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f66:	eb 28                	jmp    800f90 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6c:	75 15                	jne    800f83 <strtol+0x93>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 30                	cmp    $0x30,%al
  800f75:	75 0c                	jne    800f83 <strtol+0x93>
		s++, base = 8;
  800f77:	ff 45 08             	incl   0x8(%ebp)
  800f7a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f81:	eb 0d                	jmp    800f90 <strtol+0xa0>
	else if (base == 0)
  800f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f87:	75 07                	jne    800f90 <strtol+0xa0>
		base = 10;
  800f89:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	3c 2f                	cmp    $0x2f,%al
  800f97:	7e 19                	jle    800fb2 <strtol+0xc2>
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 39                	cmp    $0x39,%al
  800fa0:	7f 10                	jg     800fb2 <strtol+0xc2>
			dig = *s - '0';
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	0f be c0             	movsbl %al,%eax
  800faa:	83 e8 30             	sub    $0x30,%eax
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb0:	eb 42                	jmp    800ff4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8a 00                	mov    (%eax),%al
  800fb7:	3c 60                	cmp    $0x60,%al
  800fb9:	7e 19                	jle    800fd4 <strtol+0xe4>
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	8a 00                	mov    (%eax),%al
  800fc0:	3c 7a                	cmp    $0x7a,%al
  800fc2:	7f 10                	jg     800fd4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	0f be c0             	movsbl %al,%eax
  800fcc:	83 e8 57             	sub    $0x57,%eax
  800fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd2:	eb 20                	jmp    800ff4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd7:	8a 00                	mov    (%eax),%al
  800fd9:	3c 40                	cmp    $0x40,%al
  800fdb:	7e 39                	jle    801016 <strtol+0x126>
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	8a 00                	mov    (%eax),%al
  800fe2:	3c 5a                	cmp    $0x5a,%al
  800fe4:	7f 30                	jg     801016 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	0f be c0             	movsbl %al,%eax
  800fee:	83 e8 37             	sub    $0x37,%eax
  800ff1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffa:	7d 19                	jge    801015 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffc:	ff 45 08             	incl   0x8(%ebp)
  800fff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801002:	0f af 45 10          	imul   0x10(%ebp),%eax
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100b:	01 d0                	add    %edx,%eax
  80100d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801010:	e9 7b ff ff ff       	jmp    800f90 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801015:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801016:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101a:	74 08                	je     801024 <strtol+0x134>
		*endptr = (char *) s;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801024:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801028:	74 07                	je     801031 <strtol+0x141>
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	f7 d8                	neg    %eax
  80102f:	eb 03                	jmp    801034 <strtol+0x144>
  801031:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801034:	c9                   	leave  
  801035:	c3                   	ret    

00801036 <ltostr>:

void
ltostr(long value, char *str)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801043:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104e:	79 13                	jns    801063 <ltostr+0x2d>
	{
		neg = 1;
  801050:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801057:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801060:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106b:	99                   	cltd   
  80106c:	f7 f9                	idiv   %ecx
  80106e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	8d 50 01             	lea    0x1(%eax),%edx
  801077:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801084:	83 c2 30             	add    $0x30,%edx
  801087:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801089:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801091:	f7 e9                	imul   %ecx
  801093:	c1 fa 02             	sar    $0x2,%edx
  801096:	89 c8                	mov    %ecx,%eax
  801098:	c1 f8 1f             	sar    $0x1f,%eax
  80109b:	29 c2                	sub    %eax,%edx
  80109d:	89 d0                	mov    %edx,%eax
  80109f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	75 bb                	jne    801063 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b2:	48                   	dec    %eax
  8010b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010ba:	74 3d                	je     8010f9 <ltostr+0xc3>
		start = 1 ;
  8010bc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010c3:	eb 34                	jmp    8010f9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  8010c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010cb:	01 d0                	add    %edx,%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d8:	01 c2                	add    %eax,%edx
  8010da:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e0:	01 c8                	add    %ecx,%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8010e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ec:	01 c2                	add    %eax,%edx
  8010ee:	8a 45 eb             	mov    -0x15(%ebp),%al
  8010f1:	88 02                	mov    %al,(%edx)
		start++ ;
  8010f3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8010f6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8010f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8010ff:	7c c4                	jl     8010c5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801101:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80110c:	90                   	nop
  80110d:	c9                   	leave  
  80110e:	c3                   	ret    

0080110f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80110f:	55                   	push   %ebp
  801110:	89 e5                	mov    %esp,%ebp
  801112:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 73 fa ff ff       	call   800b90 <strlen>
  80111d:	83 c4 04             	add    $0x4,%esp
  801120:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801123:	ff 75 0c             	pushl  0xc(%ebp)
  801126:	e8 65 fa ff ff       	call   800b90 <strlen>
  80112b:	83 c4 04             	add    $0x4,%esp
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801131:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801138:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80113f:	eb 17                	jmp    801158 <strcconcat+0x49>
		final[s] = str1[s] ;
  801141:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	01 c2                	add    %eax,%edx
  801149:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	01 c8                	add    %ecx,%eax
  801151:	8a 00                	mov    (%eax),%al
  801153:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801155:	ff 45 fc             	incl   -0x4(%ebp)
  801158:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80115e:	7c e1                	jl     801141 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801160:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80116e:	eb 1f                	jmp    80118f <strcconcat+0x80>
		final[s++] = str2[i] ;
  801170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801173:	8d 50 01             	lea    0x1(%eax),%edx
  801176:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801179:	89 c2                	mov    %eax,%edx
  80117b:	8b 45 10             	mov    0x10(%ebp),%eax
  80117e:	01 c2                	add    %eax,%edx
  801180:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c8                	add    %ecx,%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80118c:	ff 45 f8             	incl   -0x8(%ebp)
  80118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c d9                	jl     801170 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801197:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119a:	8b 45 10             	mov    0x10(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b4:	8b 00                	mov    (%eax),%eax
  8011b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c0:	01 d0                	add    %edx,%eax
  8011c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011c8:	eb 0c                	jmp    8011d6 <strsplit+0x31>
			*string++ = 0;
  8011ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cd:	8d 50 01             	lea    0x1(%eax),%edx
  8011d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011d3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	84 c0                	test   %al,%al
  8011dd:	74 18                	je     8011f7 <strsplit+0x52>
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	0f be c0             	movsbl %al,%eax
  8011e7:	50                   	push   %eax
  8011e8:	ff 75 0c             	pushl  0xc(%ebp)
  8011eb:	e8 32 fb ff ff       	call   800d22 <strchr>
  8011f0:	83 c4 08             	add    $0x8,%esp
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	75 d3                	jne    8011ca <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	8a 00                	mov    (%eax),%al
  8011fc:	84 c0                	test   %al,%al
  8011fe:	74 5a                	je     80125a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801200:	8b 45 14             	mov    0x14(%ebp),%eax
  801203:	8b 00                	mov    (%eax),%eax
  801205:	83 f8 0f             	cmp    $0xf,%eax
  801208:	75 07                	jne    801211 <strsplit+0x6c>
		{
			return 0;
  80120a:	b8 00 00 00 00       	mov    $0x0,%eax
  80120f:	eb 66                	jmp    801277 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801211:	8b 45 14             	mov    0x14(%ebp),%eax
  801214:	8b 00                	mov    (%eax),%eax
  801216:	8d 48 01             	lea    0x1(%eax),%ecx
  801219:	8b 55 14             	mov    0x14(%ebp),%edx
  80121c:	89 0a                	mov    %ecx,(%edx)
  80121e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	01 c2                	add    %eax,%edx
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80122f:	eb 03                	jmp    801234 <strsplit+0x8f>
			string++;
  801231:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	84 c0                	test   %al,%al
  80123b:	74 8b                	je     8011c8 <strsplit+0x23>
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
  801240:	8a 00                	mov    (%eax),%al
  801242:	0f be c0             	movsbl %al,%eax
  801245:	50                   	push   %eax
  801246:	ff 75 0c             	pushl  0xc(%ebp)
  801249:	e8 d4 fa ff ff       	call   800d22 <strchr>
  80124e:	83 c4 08             	add    $0x8,%esp
  801251:	85 c0                	test   %eax,%eax
  801253:	74 dc                	je     801231 <strsplit+0x8c>
			string++;
	}
  801255:	e9 6e ff ff ff       	jmp    8011c8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80125a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80125b:	8b 45 14             	mov    0x14(%ebp),%eax
  80125e:	8b 00                	mov    (%eax),%eax
  801260:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801267:	8b 45 10             	mov    0x10(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801272:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801277:	c9                   	leave  
  801278:	c3                   	ret    

00801279 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80127f:	83 ec 04             	sub    $0x4,%esp
  801282:	68 7c 23 80 00       	push   $0x80237c
  801287:	68 3f 01 00 00       	push   $0x13f
  80128c:	68 9e 23 80 00       	push   $0x80239e
  801291:	e8 8d 07 00 00       	call   801a23 <_panic>

00801296 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	57                   	push   %edi
  80129a:	56                   	push   %esi
  80129b:	53                   	push   %ebx
  80129c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ab:	8b 7d 18             	mov    0x18(%ebp),%edi
  8012ae:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8012b1:	cd 30                	int    $0x30
  8012b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  8012b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012b9:	83 c4 10             	add    $0x10,%esp
  8012bc:	5b                   	pop    %ebx
  8012bd:	5e                   	pop    %esi
  8012be:	5f                   	pop    %edi
  8012bf:	5d                   	pop    %ebp
  8012c0:	c3                   	ret    

008012c1 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8012c1:	55                   	push   %ebp
  8012c2:	89 e5                	mov    %esp,%ebp
  8012c4:	83 ec 04             	sub    $0x4,%esp
  8012c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8012cd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	6a 00                	push   $0x0
  8012d6:	6a 00                	push   $0x0
  8012d8:	52                   	push   %edx
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	50                   	push   %eax
  8012dd:	6a 00                	push   $0x0
  8012df:	e8 b2 ff ff ff       	call   801296 <syscall>
  8012e4:	83 c4 18             	add    $0x18,%esp
}
  8012e7:	90                   	nop
  8012e8:	c9                   	leave  
  8012e9:	c3                   	ret    

008012ea <sys_cgetc>:

int sys_cgetc(void) {
  8012ea:	55                   	push   %ebp
  8012eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8012ed:	6a 00                	push   $0x0
  8012ef:	6a 00                	push   $0x0
  8012f1:	6a 00                	push   $0x0
  8012f3:	6a 00                	push   $0x0
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 02                	push   $0x2
  8012f9:	e8 98 ff ff ff       	call   801296 <syscall>
  8012fe:	83 c4 18             	add    $0x18,%esp
}
  801301:	c9                   	leave  
  801302:	c3                   	ret    

00801303 <sys_lock_cons>:

void sys_lock_cons(void) {
  801303:	55                   	push   %ebp
  801304:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  801306:	6a 00                	push   $0x0
  801308:	6a 00                	push   $0x0
  80130a:	6a 00                	push   $0x0
  80130c:	6a 00                	push   $0x0
  80130e:	6a 00                	push   $0x0
  801310:	6a 03                	push   $0x3
  801312:	e8 7f ff ff ff       	call   801296 <syscall>
  801317:	83 c4 18             	add    $0x18,%esp
}
  80131a:	90                   	nop
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <sys_unlock_cons>:
void sys_unlock_cons(void) {
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801320:	6a 00                	push   $0x0
  801322:	6a 00                	push   $0x0
  801324:	6a 00                	push   $0x0
  801326:	6a 00                	push   $0x0
  801328:	6a 00                	push   $0x0
  80132a:	6a 04                	push   $0x4
  80132c:	e8 65 ff ff ff       	call   801296 <syscall>
  801331:	83 c4 18             	add    $0x18,%esp
}
  801334:	90                   	nop
  801335:	c9                   	leave  
  801336:	c3                   	ret    

00801337 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80133a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80133d:	8b 45 08             	mov    0x8(%ebp),%eax
  801340:	6a 00                	push   $0x0
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	52                   	push   %edx
  801347:	50                   	push   %eax
  801348:	6a 08                	push   $0x8
  80134a:	e8 47 ff ff ff       	call   801296 <syscall>
  80134f:	83 c4 18             	add    $0x18,%esp
}
  801352:	c9                   	leave  
  801353:	c3                   	ret    

00801354 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801354:	55                   	push   %ebp
  801355:	89 e5                	mov    %esp,%ebp
  801357:	56                   	push   %esi
  801358:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801359:	8b 75 18             	mov    0x18(%ebp),%esi
  80135c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80135f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	8b 45 08             	mov    0x8(%ebp),%eax
  801368:	56                   	push   %esi
  801369:	53                   	push   %ebx
  80136a:	51                   	push   %ecx
  80136b:	52                   	push   %edx
  80136c:	50                   	push   %eax
  80136d:	6a 09                	push   $0x9
  80136f:	e8 22 ff ff ff       	call   801296 <syscall>
  801374:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801377:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137a:	5b                   	pop    %ebx
  80137b:	5e                   	pop    %esi
  80137c:	5d                   	pop    %ebp
  80137d:	c3                   	ret    

0080137e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801381:	8b 55 0c             	mov    0xc(%ebp),%edx
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	6a 00                	push   $0x0
  801389:	6a 00                	push   $0x0
  80138b:	6a 00                	push   $0x0
  80138d:	52                   	push   %edx
  80138e:	50                   	push   %eax
  80138f:	6a 0a                	push   $0xa
  801391:	e8 00 ff ff ff       	call   801296 <syscall>
  801396:	83 c4 18             	add    $0x18,%esp
}
  801399:	c9                   	leave  
  80139a:	c3                   	ret    

0080139b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80139e:	6a 00                	push   $0x0
  8013a0:	6a 00                	push   $0x0
  8013a2:	6a 00                	push   $0x0
  8013a4:	ff 75 0c             	pushl  0xc(%ebp)
  8013a7:	ff 75 08             	pushl  0x8(%ebp)
  8013aa:	6a 0b                	push   $0xb
  8013ac:	e8 e5 fe ff ff       	call   801296 <syscall>
  8013b1:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8013b9:	6a 00                	push   $0x0
  8013bb:	6a 00                	push   $0x0
  8013bd:	6a 00                	push   $0x0
  8013bf:	6a 00                	push   $0x0
  8013c1:	6a 00                	push   $0x0
  8013c3:	6a 0c                	push   $0xc
  8013c5:	e8 cc fe ff ff       	call   801296 <syscall>
  8013ca:	83 c4 18             	add    $0x18,%esp
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8013d2:	6a 00                	push   $0x0
  8013d4:	6a 00                	push   $0x0
  8013d6:	6a 00                	push   $0x0
  8013d8:	6a 00                	push   $0x0
  8013da:	6a 00                	push   $0x0
  8013dc:	6a 0d                	push   $0xd
  8013de:	e8 b3 fe ff ff       	call   801296 <syscall>
  8013e3:	83 c4 18             	add    $0x18,%esp
}
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    

008013e8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8013e8:	55                   	push   %ebp
  8013e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8013eb:	6a 00                	push   $0x0
  8013ed:	6a 00                	push   $0x0
  8013ef:	6a 00                	push   $0x0
  8013f1:	6a 00                	push   $0x0
  8013f3:	6a 00                	push   $0x0
  8013f5:	6a 0e                	push   $0xe
  8013f7:	e8 9a fe ff ff       	call   801296 <syscall>
  8013fc:	83 c4 18             	add    $0x18,%esp
}
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    

00801401 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  801401:	55                   	push   %ebp
  801402:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  801404:	6a 00                	push   $0x0
  801406:	6a 00                	push   $0x0
  801408:	6a 00                	push   $0x0
  80140a:	6a 00                	push   $0x0
  80140c:	6a 00                	push   $0x0
  80140e:	6a 0f                	push   $0xf
  801410:	e8 81 fe ff ff       	call   801296 <syscall>
  801415:	83 c4 18             	add    $0x18,%esp
}
  801418:	c9                   	leave  
  801419:	c3                   	ret    

0080141a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  80141d:	6a 00                	push   $0x0
  80141f:	6a 00                	push   $0x0
  801421:	6a 00                	push   $0x0
  801423:	6a 00                	push   $0x0
  801425:	ff 75 08             	pushl  0x8(%ebp)
  801428:	6a 10                	push   $0x10
  80142a:	e8 67 fe ff ff       	call   801296 <syscall>
  80142f:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <sys_scarce_memory>:

void sys_scarce_memory() {
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801437:	6a 00                	push   $0x0
  801439:	6a 00                	push   $0x0
  80143b:	6a 00                	push   $0x0
  80143d:	6a 00                	push   $0x0
  80143f:	6a 00                	push   $0x0
  801441:	6a 11                	push   $0x11
  801443:	e8 4e fe ff ff       	call   801296 <syscall>
  801448:	83 c4 18             	add    $0x18,%esp
}
  80144b:	90                   	nop
  80144c:	c9                   	leave  
  80144d:	c3                   	ret    

0080144e <sys_cputc>:

void sys_cputc(const char c) {
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80145a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80145e:	6a 00                	push   $0x0
  801460:	6a 00                	push   $0x0
  801462:	6a 00                	push   $0x0
  801464:	6a 00                	push   $0x0
  801466:	50                   	push   %eax
  801467:	6a 01                	push   $0x1
  801469:	e8 28 fe ff ff       	call   801296 <syscall>
  80146e:	83 c4 18             	add    $0x18,%esp
}
  801471:	90                   	nop
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801477:	6a 00                	push   $0x0
  801479:	6a 00                	push   $0x0
  80147b:	6a 00                	push   $0x0
  80147d:	6a 00                	push   $0x0
  80147f:	6a 00                	push   $0x0
  801481:	6a 14                	push   $0x14
  801483:	e8 0e fe ff ff       	call   801296 <syscall>
  801488:	83 c4 18             	add    $0x18,%esp
}
  80148b:	90                   	nop
  80148c:	c9                   	leave  
  80148d:	c3                   	ret    

0080148e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	83 ec 04             	sub    $0x4,%esp
  801494:	8b 45 10             	mov    0x10(%ebp),%eax
  801497:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80149a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80149d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	6a 00                	push   $0x0
  8014a6:	51                   	push   %ecx
  8014a7:	52                   	push   %edx
  8014a8:	ff 75 0c             	pushl  0xc(%ebp)
  8014ab:	50                   	push   %eax
  8014ac:	6a 15                	push   $0x15
  8014ae:	e8 e3 fd ff ff       	call   801296 <syscall>
  8014b3:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  8014b6:	c9                   	leave  
  8014b7:	c3                   	ret    

008014b8 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  8014bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	6a 00                	push   $0x0
  8014c3:	6a 00                	push   $0x0
  8014c5:	6a 00                	push   $0x0
  8014c7:	52                   	push   %edx
  8014c8:	50                   	push   %eax
  8014c9:	6a 16                	push   $0x16
  8014cb:	e8 c6 fd ff ff       	call   801296 <syscall>
  8014d0:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8014d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	6a 00                	push   $0x0
  8014e3:	6a 00                	push   $0x0
  8014e5:	51                   	push   %ecx
  8014e6:	52                   	push   %edx
  8014e7:	50                   	push   %eax
  8014e8:	6a 17                	push   $0x17
  8014ea:	e8 a7 fd ff ff       	call   801296 <syscall>
  8014ef:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8014f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	6a 00                	push   $0x0
  801503:	52                   	push   %edx
  801504:	50                   	push   %eax
  801505:	6a 18                	push   $0x18
  801507:	e8 8a fd ff ff       	call   801296 <syscall>
  80150c:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	6a 00                	push   $0x0
  801519:	ff 75 14             	pushl  0x14(%ebp)
  80151c:	ff 75 10             	pushl  0x10(%ebp)
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	50                   	push   %eax
  801523:	6a 19                	push   $0x19
  801525:	e8 6c fd ff ff       	call   801296 <syscall>
  80152a:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80152d:	c9                   	leave  
  80152e:	c3                   	ret    

0080152f <sys_run_env>:

void sys_run_env(int32 envId) {
  80152f:	55                   	push   %ebp
  801530:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 00                	push   $0x0
  80153b:	6a 00                	push   $0x0
  80153d:	50                   	push   %eax
  80153e:	6a 1a                	push   $0x1a
  801540:	e8 51 fd ff ff       	call   801296 <syscall>
  801545:	83 c4 18             	add    $0x18,%esp
}
  801548:	90                   	nop
  801549:	c9                   	leave  
  80154a:	c3                   	ret    

0080154b <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80154b:	55                   	push   %ebp
  80154c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80154e:	8b 45 08             	mov    0x8(%ebp),%eax
  801551:	6a 00                	push   $0x0
  801553:	6a 00                	push   $0x0
  801555:	6a 00                	push   $0x0
  801557:	6a 00                	push   $0x0
  801559:	50                   	push   %eax
  80155a:	6a 1b                	push   $0x1b
  80155c:	e8 35 fd ff ff       	call   801296 <syscall>
  801561:	83 c4 18             	add    $0x18,%esp
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <sys_getenvid>:

int32 sys_getenvid(void) {
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 05                	push   $0x5
  801575:	e8 1c fd ff ff       	call   801296 <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
}
  80157d:	c9                   	leave  
  80157e:	c3                   	ret    

0080157f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80157f:	55                   	push   %ebp
  801580:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801582:	6a 00                	push   $0x0
  801584:	6a 00                	push   $0x0
  801586:	6a 00                	push   $0x0
  801588:	6a 00                	push   $0x0
  80158a:	6a 00                	push   $0x0
  80158c:	6a 06                	push   $0x6
  80158e:	e8 03 fd ff ff       	call   801296 <syscall>
  801593:	83 c4 18             	add    $0x18,%esp
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	6a 00                	push   $0x0
  8015a1:	6a 00                	push   $0x0
  8015a3:	6a 00                	push   $0x0
  8015a5:	6a 07                	push   $0x7
  8015a7:	e8 ea fc ff ff       	call   801296 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <sys_exit_env>:

void sys_exit_env(void) {
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8015b4:	6a 00                	push   $0x0
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 1c                	push   $0x1c
  8015c0:	e8 d1 fc ff ff       	call   801296 <syscall>
  8015c5:	83 c4 18             	add    $0x18,%esp
}
  8015c8:	90                   	nop
  8015c9:	c9                   	leave  
  8015ca:	c3                   	ret    

008015cb <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8015cb:	55                   	push   %ebp
  8015cc:	89 e5                	mov    %esp,%ebp
  8015ce:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8015d1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015d4:	8d 50 04             	lea    0x4(%eax),%edx
  8015d7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8015da:	6a 00                	push   $0x0
  8015dc:	6a 00                	push   $0x0
  8015de:	6a 00                	push   $0x0
  8015e0:	52                   	push   %edx
  8015e1:	50                   	push   %eax
  8015e2:	6a 1d                	push   $0x1d
  8015e4:	e8 ad fc ff ff       	call   801296 <syscall>
  8015e9:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8015ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f5:	89 01                	mov    %eax,(%ecx)
  8015f7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	c9                   	leave  
  8015fe:	c2 04 00             	ret    $0x4

00801601 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  801604:	6a 00                	push   $0x0
  801606:	6a 00                	push   $0x0
  801608:	ff 75 10             	pushl  0x10(%ebp)
  80160b:	ff 75 0c             	pushl  0xc(%ebp)
  80160e:	ff 75 08             	pushl  0x8(%ebp)
  801611:	6a 13                	push   $0x13
  801613:	e8 7e fc ff ff       	call   801296 <syscall>
  801618:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  80161b:	90                   	nop
}
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <sys_rcr2>:
uint32 sys_rcr2() {
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 00                	push   $0x0
  801629:	6a 00                	push   $0x0
  80162b:	6a 1e                	push   $0x1e
  80162d:	e8 64 fc ff ff       	call   801296 <syscall>
  801632:	83 c4 18             	add    $0x18,%esp
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 04             	sub    $0x4,%esp
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801643:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	50                   	push   %eax
  801650:	6a 1f                	push   $0x1f
  801652:	e8 3f fc ff ff       	call   801296 <syscall>
  801657:	83 c4 18             	add    $0x18,%esp
	return;
  80165a:	90                   	nop
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <rsttst>:
void rsttst() {
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 21                	push   $0x21
  80166c:	e8 25 fc ff ff       	call   801296 <syscall>
  801671:	83 c4 18             	add    $0x18,%esp
	return;
  801674:	90                   	nop
}
  801675:	c9                   	leave  
  801676:	c3                   	ret    

00801677 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801677:	55                   	push   %ebp
  801678:	89 e5                	mov    %esp,%ebp
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	8b 45 14             	mov    0x14(%ebp),%eax
  801680:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801683:	8b 55 18             	mov    0x18(%ebp),%edx
  801686:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80168a:	52                   	push   %edx
  80168b:	50                   	push   %eax
  80168c:	ff 75 10             	pushl  0x10(%ebp)
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	6a 20                	push   $0x20
  801697:	e8 fa fb ff ff       	call   801296 <syscall>
  80169c:	83 c4 18             	add    $0x18,%esp
	return;
  80169f:	90                   	nop
}
  8016a0:	c9                   	leave  
  8016a1:	c3                   	ret    

008016a2 <chktst>:
void chktst(uint32 n) {
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	ff 75 08             	pushl  0x8(%ebp)
  8016b0:	6a 22                	push   $0x22
  8016b2:	e8 df fb ff ff       	call   801296 <syscall>
  8016b7:	83 c4 18             	add    $0x18,%esp
	return;
  8016ba:	90                   	nop
}
  8016bb:	c9                   	leave  
  8016bc:	c3                   	ret    

008016bd <inctst>:

void inctst() {
  8016bd:	55                   	push   %ebp
  8016be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8016c0:	6a 00                	push   $0x0
  8016c2:	6a 00                	push   $0x0
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	6a 23                	push   $0x23
  8016cc:	e8 c5 fb ff ff       	call   801296 <syscall>
  8016d1:	83 c4 18             	add    $0x18,%esp
	return;
  8016d4:	90                   	nop
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <gettst>:
uint32 gettst() {
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8016da:	6a 00                	push   $0x0
  8016dc:	6a 00                	push   $0x0
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	6a 24                	push   $0x24
  8016e6:	e8 ab fb ff ff       	call   801296 <syscall>
  8016eb:	83 c4 18             	add    $0x18,%esp
}
  8016ee:	c9                   	leave  
  8016ef:	c3                   	ret    

008016f0 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8016f6:	6a 00                	push   $0x0
  8016f8:	6a 00                	push   $0x0
  8016fa:	6a 00                	push   $0x0
  8016fc:	6a 00                	push   $0x0
  8016fe:	6a 00                	push   $0x0
  801700:	6a 25                	push   $0x25
  801702:	e8 8f fb ff ff       	call   801296 <syscall>
  801707:	83 c4 18             	add    $0x18,%esp
  80170a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80170d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801711:	75 07                	jne    80171a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801713:	b8 01 00 00 00       	mov    $0x1,%eax
  801718:	eb 05                	jmp    80171f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 25                	push   $0x25
  801733:	e8 5e fb ff ff       	call   801296 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
  80173b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80173e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801742:	75 07                	jne    80174b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801744:	b8 01 00 00 00       	mov    $0x1,%eax
  801749:	eb 05                	jmp    801750 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 25                	push   $0x25
  801764:	e8 2d fb ff ff       	call   801296 <syscall>
  801769:	83 c4 18             	add    $0x18,%esp
  80176c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80176f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801773:	75 07                	jne    80177c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801775:	b8 01 00 00 00       	mov    $0x1,%eax
  80177a:	eb 05                	jmp    801781 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80177c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801781:	c9                   	leave  
  801782:	c3                   	ret    

00801783 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	6a 00                	push   $0x0
  801791:	6a 00                	push   $0x0
  801793:	6a 25                	push   $0x25
  801795:	e8 fc fa ff ff       	call   801296 <syscall>
  80179a:	83 c4 18             	add    $0x18,%esp
  80179d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8017a0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8017a4:	75 07                	jne    8017ad <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8017a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ab:	eb 05                	jmp    8017b2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8017ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	ff 75 08             	pushl  0x8(%ebp)
  8017c2:	6a 26                	push   $0x26
  8017c4:	e8 cd fa ff ff       	call   801296 <syscall>
  8017c9:	83 c4 18             	add    $0x18,%esp
	return;
  8017cc:	90                   	nop
}
  8017cd:	c9                   	leave  
  8017ce:	c3                   	ret    

008017cf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8017d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	53                   	push   %ebx
  8017e2:	51                   	push   %ecx
  8017e3:	52                   	push   %edx
  8017e4:	50                   	push   %eax
  8017e5:	6a 27                	push   $0x27
  8017e7:	e8 aa fa ff ff       	call   801296 <syscall>
  8017ec:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8017ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8017f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	52                   	push   %edx
  801804:	50                   	push   %eax
  801805:	6a 28                	push   $0x28
  801807:	e8 8a fa ff ff       	call   801296 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  801814:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801817:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	51                   	push   %ecx
  801820:	ff 75 10             	pushl  0x10(%ebp)
  801823:	52                   	push   %edx
  801824:	50                   	push   %eax
  801825:	6a 29                	push   $0x29
  801827:	e8 6a fa ff ff       	call   801296 <syscall>
  80182c:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80182f:	c9                   	leave  
  801830:	c3                   	ret    

00801831 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801831:	55                   	push   %ebp
  801832:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	ff 75 10             	pushl  0x10(%ebp)
  80183b:	ff 75 0c             	pushl  0xc(%ebp)
  80183e:	ff 75 08             	pushl  0x8(%ebp)
  801841:	6a 12                	push   $0x12
  801843:	e8 4e fa ff ff       	call   801296 <syscall>
  801848:	83 c4 18             	add    $0x18,%esp
	return;
  80184b:	90                   	nop
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801851:	8b 55 0c             	mov    0xc(%ebp),%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	6a 2a                	push   $0x2a
  801861:	e8 30 fa ff ff       	call   801296 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
	return;
  801869:	90                   	nop
}
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	50                   	push   %eax
  80187b:	6a 2b                	push   $0x2b
  80187d:	e8 14 fa ff ff       	call   801296 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	ff 75 08             	pushl  0x8(%ebp)
  801896:	6a 2c                	push   $0x2c
  801898:	e8 f9 f9 ff ff       	call   801296 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
	return;
  8018a0:	90                   	nop
}
  8018a1:	c9                   	leave  
  8018a2:	c3                   	ret    

008018a3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	6a 2d                	push   $0x2d
  8018b4:	e8 dd f9 ff ff       	call   801296 <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
	return;
  8018bc:	90                   	nop
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	50                   	push   %eax
  8018ce:	6a 2f                	push   $0x2f
  8018d0:	e8 c1 f9 ff ff       	call   801296 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
	return;
  8018d8:	90                   	nop
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8018de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	52                   	push   %edx
  8018eb:	50                   	push   %eax
  8018ec:	6a 30                	push   $0x30
  8018ee:	e8 a3 f9 ff ff       	call   801296 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
	return;
  8018f6:	90                   	nop
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	50                   	push   %eax
  801908:	6a 31                	push   $0x31
  80190a:	e8 87 f9 ff ff       	call   801296 <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
	return;
  801912:	90                   	nop
}
  801913:	c9                   	leave  
  801914:	c3                   	ret    

00801915 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  801918:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	52                   	push   %edx
  801925:	50                   	push   %eax
  801926:	6a 2e                	push   $0x2e
  801928:	e8 69 f9 ff ff       	call   801296 <syscall>
  80192d:	83 c4 18             	add    $0x18,%esp
    return;
  801930:	90                   	nop
}
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801939:	8b 55 08             	mov    0x8(%ebp),%edx
  80193c:	89 d0                	mov    %edx,%eax
  80193e:	c1 e0 02             	shl    $0x2,%eax
  801941:	01 d0                	add    %edx,%eax
  801943:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80194a:	01 d0                	add    %edx,%eax
  80194c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801953:	01 d0                	add    %edx,%eax
  801955:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80195c:	01 d0                	add    %edx,%eax
  80195e:	c1 e0 04             	shl    $0x4,%eax
  801961:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801964:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80196b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80196e:	83 ec 0c             	sub    $0xc,%esp
  801971:	50                   	push   %eax
  801972:	e8 54 fc ff ff       	call   8015cb <sys_get_virtual_time>
  801977:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80197a:	eb 41                	jmp    8019bd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80197c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80197f:	83 ec 0c             	sub    $0xc,%esp
  801982:	50                   	push   %eax
  801983:	e8 43 fc ff ff       	call   8015cb <sys_get_virtual_time>
  801988:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80198b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80198e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801991:	29 c2                	sub    %eax,%edx
  801993:	89 d0                	mov    %edx,%eax
  801995:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801998:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80199b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80199e:	89 d1                	mov    %edx,%ecx
  8019a0:	29 c1                	sub    %eax,%ecx
  8019a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019a8:	39 c2                	cmp    %eax,%edx
  8019aa:	0f 97 c0             	seta   %al
  8019ad:	0f b6 c0             	movzbl %al,%eax
  8019b0:	29 c1                	sub    %eax,%ecx
  8019b2:	89 c8                	mov    %ecx,%eax
  8019b4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8019b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8019bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019c3:	72 b7                	jb     80197c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
  8019cb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8019ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8019d5:	eb 03                	jmp    8019da <busy_wait+0x12>
  8019d7:	ff 45 fc             	incl   -0x4(%ebp)
  8019da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8019e0:	72 f5                	jb     8019d7 <busy_wait+0xf>
	return i;
  8019e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8019f3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8019f7:	83 ec 0c             	sub    $0xc,%esp
  8019fa:	50                   	push   %eax
  8019fb:	e8 4e fa ff ff       	call   80144e <sys_cputc>
  801a00:	83 c4 10             	add    $0x10,%esp
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <getchar>:


int
getchar(void)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 18             	sub    $0x18,%esp
	int c =sys_cgetc();
  801a0c:	e8 d9 f8 ff ff       	call   8012ea <sys_cgetc>
  801a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
	return c;
  801a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <iscons>:

int iscons(int fdnum)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  801a1c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801a29:	8d 45 10             	lea    0x10(%ebp),%eax
  801a2c:	83 c0 04             	add    $0x4,%eax
  801a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801a32:	a1 28 30 80 00       	mov    0x803028,%eax
  801a37:	85 c0                	test   %eax,%eax
  801a39:	74 16                	je     801a51 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801a3b:	a1 28 30 80 00       	mov    0x803028,%eax
  801a40:	83 ec 08             	sub    $0x8,%esp
  801a43:	50                   	push   %eax
  801a44:	68 ac 23 80 00       	push   $0x8023ac
  801a49:	e8 a6 e8 ff ff       	call   8002f4 <cprintf>
  801a4e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801a51:	a1 04 30 80 00       	mov    0x803004,%eax
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	50                   	push   %eax
  801a5d:	68 b1 23 80 00       	push   $0x8023b1
  801a62:	e8 8d e8 ff ff       	call   8002f4 <cprintf>
  801a67:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801a6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	ff 75 f4             	pushl  -0xc(%ebp)
  801a73:	50                   	push   %eax
  801a74:	e8 10 e8 ff ff       	call   800289 <vcprintf>
  801a79:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801a7c:	83 ec 08             	sub    $0x8,%esp
  801a7f:	6a 00                	push   $0x0
  801a81:	68 cd 23 80 00       	push   $0x8023cd
  801a86:	e8 fe e7 ff ff       	call   800289 <vcprintf>
  801a8b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801a8e:	e8 7f e7 ff ff       	call   800212 <exit>

	// should not return here
	while (1) ;
  801a93:	eb fe                	jmp    801a93 <_panic+0x70>

00801a95 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801a9b:	a1 08 30 80 00       	mov    0x803008,%eax
  801aa0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa9:	39 c2                	cmp    %eax,%edx
  801aab:	74 14                	je     801ac1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801aad:	83 ec 04             	sub    $0x4,%esp
  801ab0:	68 d0 23 80 00       	push   $0x8023d0
  801ab5:	6a 26                	push   $0x26
  801ab7:	68 1c 24 80 00       	push   $0x80241c
  801abc:	e8 62 ff ff ff       	call   801a23 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801ac1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801ac8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801acf:	e9 c5 00 00 00       	jmp    801b99 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ade:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae1:	01 d0                	add    %edx,%eax
  801ae3:	8b 00                	mov    (%eax),%eax
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	75 08                	jne    801af1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801ae9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801aec:	e9 a5 00 00 00       	jmp    801b96 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801af1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801af8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801aff:	eb 69                	jmp    801b6a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801b01:	a1 08 30 80 00       	mov    0x803008,%eax
  801b06:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801b0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b0f:	89 d0                	mov    %edx,%eax
  801b11:	01 c0                	add    %eax,%eax
  801b13:	01 d0                	add    %edx,%eax
  801b15:	c1 e0 03             	shl    $0x3,%eax
  801b18:	01 c8                	add    %ecx,%eax
  801b1a:	8a 40 04             	mov    0x4(%eax),%al
  801b1d:	84 c0                	test   %al,%al
  801b1f:	75 46                	jne    801b67 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b21:	a1 08 30 80 00       	mov    0x803008,%eax
  801b26:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801b2c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b2f:	89 d0                	mov    %edx,%eax
  801b31:	01 c0                	add    %eax,%eax
  801b33:	01 d0                	add    %edx,%eax
  801b35:	c1 e0 03             	shl    $0x3,%eax
  801b38:	01 c8                	add    %ecx,%eax
  801b3a:	8b 00                	mov    (%eax),%eax
  801b3c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801b3f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b42:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b47:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
  801b56:	01 c8                	add    %ecx,%eax
  801b58:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801b5a:	39 c2                	cmp    %eax,%edx
  801b5c:	75 09                	jne    801b67 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801b5e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801b65:	eb 15                	jmp    801b7c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b67:	ff 45 e8             	incl   -0x18(%ebp)
  801b6a:	a1 08 30 80 00       	mov    0x803008,%eax
  801b6f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b78:	39 c2                	cmp    %eax,%edx
  801b7a:	77 85                	ja     801b01 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801b7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b80:	75 14                	jne    801b96 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801b82:	83 ec 04             	sub    $0x4,%esp
  801b85:	68 28 24 80 00       	push   $0x802428
  801b8a:	6a 3a                	push   $0x3a
  801b8c:	68 1c 24 80 00       	push   $0x80241c
  801b91:	e8 8d fe ff ff       	call   801a23 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801b96:	ff 45 f0             	incl   -0x10(%ebp)
  801b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b9f:	0f 8c 2f ff ff ff    	jl     801ad4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801ba5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801bb3:	eb 26                	jmp    801bdb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801bb5:	a1 08 30 80 00       	mov    0x803008,%eax
  801bba:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801bc0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bc3:	89 d0                	mov    %edx,%eax
  801bc5:	01 c0                	add    %eax,%eax
  801bc7:	01 d0                	add    %edx,%eax
  801bc9:	c1 e0 03             	shl    $0x3,%eax
  801bcc:	01 c8                	add    %ecx,%eax
  801bce:	8a 40 04             	mov    0x4(%eax),%al
  801bd1:	3c 01                	cmp    $0x1,%al
  801bd3:	75 03                	jne    801bd8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801bd5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801bd8:	ff 45 e0             	incl   -0x20(%ebp)
  801bdb:	a1 08 30 80 00       	mov    0x803008,%eax
  801be0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801be6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be9:	39 c2                	cmp    %eax,%edx
  801beb:	77 c8                	ja     801bb5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801bf3:	74 14                	je     801c09 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801bf5:	83 ec 04             	sub    $0x4,%esp
  801bf8:	68 7c 24 80 00       	push   $0x80247c
  801bfd:	6a 44                	push   $0x44
  801bff:	68 1c 24 80 00       	push   $0x80241c
  801c04:	e8 1a fe ff ff       	call   801a23 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801c09:	90                   	nop
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <__udivdi3>:
  801c0c:	55                   	push   %ebp
  801c0d:	57                   	push   %edi
  801c0e:	56                   	push   %esi
  801c0f:	53                   	push   %ebx
  801c10:	83 ec 1c             	sub    $0x1c,%esp
  801c13:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801c17:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801c1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c1f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c23:	89 ca                	mov    %ecx,%edx
  801c25:	89 f8                	mov    %edi,%eax
  801c27:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801c2b:	85 f6                	test   %esi,%esi
  801c2d:	75 2d                	jne    801c5c <__udivdi3+0x50>
  801c2f:	39 cf                	cmp    %ecx,%edi
  801c31:	77 65                	ja     801c98 <__udivdi3+0x8c>
  801c33:	89 fd                	mov    %edi,%ebp
  801c35:	85 ff                	test   %edi,%edi
  801c37:	75 0b                	jne    801c44 <__udivdi3+0x38>
  801c39:	b8 01 00 00 00       	mov    $0x1,%eax
  801c3e:	31 d2                	xor    %edx,%edx
  801c40:	f7 f7                	div    %edi
  801c42:	89 c5                	mov    %eax,%ebp
  801c44:	31 d2                	xor    %edx,%edx
  801c46:	89 c8                	mov    %ecx,%eax
  801c48:	f7 f5                	div    %ebp
  801c4a:	89 c1                	mov    %eax,%ecx
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	f7 f5                	div    %ebp
  801c50:	89 cf                	mov    %ecx,%edi
  801c52:	89 fa                	mov    %edi,%edx
  801c54:	83 c4 1c             	add    $0x1c,%esp
  801c57:	5b                   	pop    %ebx
  801c58:	5e                   	pop    %esi
  801c59:	5f                   	pop    %edi
  801c5a:	5d                   	pop    %ebp
  801c5b:	c3                   	ret    
  801c5c:	39 ce                	cmp    %ecx,%esi
  801c5e:	77 28                	ja     801c88 <__udivdi3+0x7c>
  801c60:	0f bd fe             	bsr    %esi,%edi
  801c63:	83 f7 1f             	xor    $0x1f,%edi
  801c66:	75 40                	jne    801ca8 <__udivdi3+0x9c>
  801c68:	39 ce                	cmp    %ecx,%esi
  801c6a:	72 0a                	jb     801c76 <__udivdi3+0x6a>
  801c6c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c70:	0f 87 9e 00 00 00    	ja     801d14 <__udivdi3+0x108>
  801c76:	b8 01 00 00 00       	mov    $0x1,%eax
  801c7b:	89 fa                	mov    %edi,%edx
  801c7d:	83 c4 1c             	add    $0x1c,%esp
  801c80:	5b                   	pop    %ebx
  801c81:	5e                   	pop    %esi
  801c82:	5f                   	pop    %edi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    
  801c85:	8d 76 00             	lea    0x0(%esi),%esi
  801c88:	31 ff                	xor    %edi,%edi
  801c8a:	31 c0                	xor    %eax,%eax
  801c8c:	89 fa                	mov    %edi,%edx
  801c8e:	83 c4 1c             	add    $0x1c,%esp
  801c91:	5b                   	pop    %ebx
  801c92:	5e                   	pop    %esi
  801c93:	5f                   	pop    %edi
  801c94:	5d                   	pop    %ebp
  801c95:	c3                   	ret    
  801c96:	66 90                	xchg   %ax,%ax
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	f7 f7                	div    %edi
  801c9c:	31 ff                	xor    %edi,%edi
  801c9e:	89 fa                	mov    %edi,%edx
  801ca0:	83 c4 1c             	add    $0x1c,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5f                   	pop    %edi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
  801ca8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801cad:	89 eb                	mov    %ebp,%ebx
  801caf:	29 fb                	sub    %edi,%ebx
  801cb1:	89 f9                	mov    %edi,%ecx
  801cb3:	d3 e6                	shl    %cl,%esi
  801cb5:	89 c5                	mov    %eax,%ebp
  801cb7:	88 d9                	mov    %bl,%cl
  801cb9:	d3 ed                	shr    %cl,%ebp
  801cbb:	89 e9                	mov    %ebp,%ecx
  801cbd:	09 f1                	or     %esi,%ecx
  801cbf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801cc3:	89 f9                	mov    %edi,%ecx
  801cc5:	d3 e0                	shl    %cl,%eax
  801cc7:	89 c5                	mov    %eax,%ebp
  801cc9:	89 d6                	mov    %edx,%esi
  801ccb:	88 d9                	mov    %bl,%cl
  801ccd:	d3 ee                	shr    %cl,%esi
  801ccf:	89 f9                	mov    %edi,%ecx
  801cd1:	d3 e2                	shl    %cl,%edx
  801cd3:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd7:	88 d9                	mov    %bl,%cl
  801cd9:	d3 e8                	shr    %cl,%eax
  801cdb:	09 c2                	or     %eax,%edx
  801cdd:	89 d0                	mov    %edx,%eax
  801cdf:	89 f2                	mov    %esi,%edx
  801ce1:	f7 74 24 0c          	divl   0xc(%esp)
  801ce5:	89 d6                	mov    %edx,%esi
  801ce7:	89 c3                	mov    %eax,%ebx
  801ce9:	f7 e5                	mul    %ebp
  801ceb:	39 d6                	cmp    %edx,%esi
  801ced:	72 19                	jb     801d08 <__udivdi3+0xfc>
  801cef:	74 0b                	je     801cfc <__udivdi3+0xf0>
  801cf1:	89 d8                	mov    %ebx,%eax
  801cf3:	31 ff                	xor    %edi,%edi
  801cf5:	e9 58 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801cfa:	66 90                	xchg   %ax,%ax
  801cfc:	8b 54 24 08          	mov    0x8(%esp),%edx
  801d00:	89 f9                	mov    %edi,%ecx
  801d02:	d3 e2                	shl    %cl,%edx
  801d04:	39 c2                	cmp    %eax,%edx
  801d06:	73 e9                	jae    801cf1 <__udivdi3+0xe5>
  801d08:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d0b:	31 ff                	xor    %edi,%edi
  801d0d:	e9 40 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801d12:	66 90                	xchg   %ax,%ax
  801d14:	31 c0                	xor    %eax,%eax
  801d16:	e9 37 ff ff ff       	jmp    801c52 <__udivdi3+0x46>
  801d1b:	90                   	nop

00801d1c <__umoddi3>:
  801d1c:	55                   	push   %ebp
  801d1d:	57                   	push   %edi
  801d1e:	56                   	push   %esi
  801d1f:	53                   	push   %ebx
  801d20:	83 ec 1c             	sub    $0x1c,%esp
  801d23:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801d27:	8b 74 24 34          	mov    0x34(%esp),%esi
  801d2b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d2f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801d33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d37:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d3b:	89 f3                	mov    %esi,%ebx
  801d3d:	89 fa                	mov    %edi,%edx
  801d3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d43:	89 34 24             	mov    %esi,(%esp)
  801d46:	85 c0                	test   %eax,%eax
  801d48:	75 1a                	jne    801d64 <__umoddi3+0x48>
  801d4a:	39 f7                	cmp    %esi,%edi
  801d4c:	0f 86 a2 00 00 00    	jbe    801df4 <__umoddi3+0xd8>
  801d52:	89 c8                	mov    %ecx,%eax
  801d54:	89 f2                	mov    %esi,%edx
  801d56:	f7 f7                	div    %edi
  801d58:	89 d0                	mov    %edx,%eax
  801d5a:	31 d2                	xor    %edx,%edx
  801d5c:	83 c4 1c             	add    $0x1c,%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5f                   	pop    %edi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    
  801d64:	39 f0                	cmp    %esi,%eax
  801d66:	0f 87 ac 00 00 00    	ja     801e18 <__umoddi3+0xfc>
  801d6c:	0f bd e8             	bsr    %eax,%ebp
  801d6f:	83 f5 1f             	xor    $0x1f,%ebp
  801d72:	0f 84 ac 00 00 00    	je     801e24 <__umoddi3+0x108>
  801d78:	bf 20 00 00 00       	mov    $0x20,%edi
  801d7d:	29 ef                	sub    %ebp,%edi
  801d7f:	89 fe                	mov    %edi,%esi
  801d81:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d85:	89 e9                	mov    %ebp,%ecx
  801d87:	d3 e0                	shl    %cl,%eax
  801d89:	89 d7                	mov    %edx,%edi
  801d8b:	89 f1                	mov    %esi,%ecx
  801d8d:	d3 ef                	shr    %cl,%edi
  801d8f:	09 c7                	or     %eax,%edi
  801d91:	89 e9                	mov    %ebp,%ecx
  801d93:	d3 e2                	shl    %cl,%edx
  801d95:	89 14 24             	mov    %edx,(%esp)
  801d98:	89 d8                	mov    %ebx,%eax
  801d9a:	d3 e0                	shl    %cl,%eax
  801d9c:	89 c2                	mov    %eax,%edx
  801d9e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801da2:	d3 e0                	shl    %cl,%eax
  801da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801dac:	89 f1                	mov    %esi,%ecx
  801dae:	d3 e8                	shr    %cl,%eax
  801db0:	09 d0                	or     %edx,%eax
  801db2:	d3 eb                	shr    %cl,%ebx
  801db4:	89 da                	mov    %ebx,%edx
  801db6:	f7 f7                	div    %edi
  801db8:	89 d3                	mov    %edx,%ebx
  801dba:	f7 24 24             	mull   (%esp)
  801dbd:	89 c6                	mov    %eax,%esi
  801dbf:	89 d1                	mov    %edx,%ecx
  801dc1:	39 d3                	cmp    %edx,%ebx
  801dc3:	0f 82 87 00 00 00    	jb     801e50 <__umoddi3+0x134>
  801dc9:	0f 84 91 00 00 00    	je     801e60 <__umoddi3+0x144>
  801dcf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dd3:	29 f2                	sub    %esi,%edx
  801dd5:	19 cb                	sbb    %ecx,%ebx
  801dd7:	89 d8                	mov    %ebx,%eax
  801dd9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801ddd:	d3 e0                	shl    %cl,%eax
  801ddf:	89 e9                	mov    %ebp,%ecx
  801de1:	d3 ea                	shr    %cl,%edx
  801de3:	09 d0                	or     %edx,%eax
  801de5:	89 e9                	mov    %ebp,%ecx
  801de7:	d3 eb                	shr    %cl,%ebx
  801de9:	89 da                	mov    %ebx,%edx
  801deb:	83 c4 1c             	add    $0x1c,%esp
  801dee:	5b                   	pop    %ebx
  801def:	5e                   	pop    %esi
  801df0:	5f                   	pop    %edi
  801df1:	5d                   	pop    %ebp
  801df2:	c3                   	ret    
  801df3:	90                   	nop
  801df4:	89 fd                	mov    %edi,%ebp
  801df6:	85 ff                	test   %edi,%edi
  801df8:	75 0b                	jne    801e05 <__umoddi3+0xe9>
  801dfa:	b8 01 00 00 00       	mov    $0x1,%eax
  801dff:	31 d2                	xor    %edx,%edx
  801e01:	f7 f7                	div    %edi
  801e03:	89 c5                	mov    %eax,%ebp
  801e05:	89 f0                	mov    %esi,%eax
  801e07:	31 d2                	xor    %edx,%edx
  801e09:	f7 f5                	div    %ebp
  801e0b:	89 c8                	mov    %ecx,%eax
  801e0d:	f7 f5                	div    %ebp
  801e0f:	89 d0                	mov    %edx,%eax
  801e11:	e9 44 ff ff ff       	jmp    801d5a <__umoddi3+0x3e>
  801e16:	66 90                	xchg   %ax,%ax
  801e18:	89 c8                	mov    %ecx,%eax
  801e1a:	89 f2                	mov    %esi,%edx
  801e1c:	83 c4 1c             	add    $0x1c,%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
  801e24:	3b 04 24             	cmp    (%esp),%eax
  801e27:	72 06                	jb     801e2f <__umoddi3+0x113>
  801e29:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801e2d:	77 0f                	ja     801e3e <__umoddi3+0x122>
  801e2f:	89 f2                	mov    %esi,%edx
  801e31:	29 f9                	sub    %edi,%ecx
  801e33:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801e37:	89 14 24             	mov    %edx,(%esp)
  801e3a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801e42:	8b 14 24             	mov    (%esp),%edx
  801e45:	83 c4 1c             	add    $0x1c,%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5e                   	pop    %esi
  801e4a:	5f                   	pop    %edi
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    
  801e4d:	8d 76 00             	lea    0x0(%esi),%esi
  801e50:	2b 04 24             	sub    (%esp),%eax
  801e53:	19 fa                	sbb    %edi,%edx
  801e55:	89 d1                	mov    %edx,%ecx
  801e57:	89 c6                	mov    %eax,%esi
  801e59:	e9 71 ff ff ff       	jmp    801dcf <__umoddi3+0xb3>
  801e5e:	66 90                	xchg   %ax,%ax
  801e60:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e64:	72 ea                	jb     801e50 <__umoddi3+0x134>
  801e66:	89 d9                	mov    %ebx,%ecx
  801e68:	e9 62 ff ff ff       	jmp    801dcf <__umoddi3+0xb3>
