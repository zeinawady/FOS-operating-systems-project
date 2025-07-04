
obj/user/tst_chan_one_slave:     file format elf32-i386


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
  800031:	e8 6d 00 00 00       	call   8000a3 <libmain>
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
  80003e:	e8 e3 12 00 00       	call   801326 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	//Sleep on the channel
	sys_utilities("__Sleep__", 0);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 00                	push   $0x0
  80004b:	68 00 1c 80 00       	push   $0x801c00
  800050:	e8 b9 15 00 00       	call   80160e <sys_utilities>
  800055:	83 c4 10             	add    $0x10,%esp

	//wait for a while
	env_sleep(RAND(1000, 5000));
  800058:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80005b:	83 ec 0c             	sub    $0xc,%esp
  80005e:	50                   	push   %eax
  80005f:	e8 27 13 00 00       	call   80138b <sys_get_virtual_time>
  800064:	83 c4 0c             	add    $0xc,%esp
  800067:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80006a:	b9 a0 0f 00 00       	mov    $0xfa0,%ecx
  80006f:	ba 00 00 00 00       	mov    $0x0,%edx
  800074:	f7 f1                	div    %ecx
  800076:	89 d0                	mov    %edx,%eax
  800078:	05 e8 03 00 00       	add    $0x3e8,%eax
  80007d:	83 ec 0c             	sub    $0xc,%esp
  800080:	50                   	push   %eax
  800081:	e8 6d 16 00 00       	call   8016f3 <env_sleep>
  800086:	83 c4 10             	add    $0x10,%esp

	//wakeup another one
	sys_utilities("__WakeupOne__", 0);
  800089:	83 ec 08             	sub    $0x8,%esp
  80008c:	6a 00                	push   $0x0
  80008e:	68 0a 1c 80 00       	push   $0x801c0a
  800093:	e8 76 15 00 00       	call   80160e <sys_utilities>
  800098:	83 c4 10             	add    $0x10,%esp

	//indicates wakenup
	inctst();
  80009b:	e8 dd 13 00 00       	call   80147d <inctst>

	return;
  8000a0:	90                   	nop
}
  8000a1:	c9                   	leave  
  8000a2:	c3                   	ret    

008000a3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000a3:	55                   	push   %ebp
  8000a4:	89 e5                	mov    %esp,%ebp
  8000a6:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000a9:	e8 91 12 00 00       	call   80133f <sys_getenvindex>
  8000ae:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000b4:	89 d0                	mov    %edx,%eax
  8000b6:	c1 e0 02             	shl    $0x2,%eax
  8000b9:	01 d0                	add    %edx,%eax
  8000bb:	c1 e0 03             	shl    $0x3,%eax
  8000be:	01 d0                	add    %edx,%eax
  8000c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000c7:	01 d0                	add    %edx,%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000d1:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000d6:	a1 08 30 80 00       	mov    0x803008,%eax
  8000db:	8a 40 20             	mov    0x20(%eax),%al
  8000de:	84 c0                	test   %al,%al
  8000e0:	74 0d                	je     8000ef <libmain+0x4c>
		binaryname = myEnv->prog_name;
  8000e2:	a1 08 30 80 00       	mov    0x803008,%eax
  8000e7:	83 c0 20             	add    $0x20,%eax
  8000ea:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000f3:	7e 0a                	jle    8000ff <libmain+0x5c>
		binaryname = argv[0];
  8000f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  8000ff:	83 ec 08             	sub    $0x8,%esp
  800102:	ff 75 0c             	pushl  0xc(%ebp)
  800105:	ff 75 08             	pushl  0x8(%ebp)
  800108:	e8 2b ff ff ff       	call   800038 <_main>
  80010d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800110:	a1 00 30 80 00       	mov    0x803000,%eax
  800115:	85 c0                	test   %eax,%eax
  800117:	0f 84 9f 00 00 00    	je     8001bc <libmain+0x119>
	{
		sys_lock_cons();
  80011d:	e8 a1 0f 00 00       	call   8010c3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	68 30 1c 80 00       	push   $0x801c30
  80012a:	e8 8d 01 00 00       	call   8002bc <cprintf>
  80012f:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800132:	a1 08 30 80 00       	mov    0x803008,%eax
  800137:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80013d:	a1 08 30 80 00       	mov    0x803008,%eax
  800142:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800148:	83 ec 04             	sub    $0x4,%esp
  80014b:	52                   	push   %edx
  80014c:	50                   	push   %eax
  80014d:	68 58 1c 80 00       	push   $0x801c58
  800152:	e8 65 01 00 00       	call   8002bc <cprintf>
  800157:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80015a:	a1 08 30 80 00       	mov    0x803008,%eax
  80015f:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800165:	a1 08 30 80 00       	mov    0x803008,%eax
  80016a:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800170:	a1 08 30 80 00       	mov    0x803008,%eax
  800175:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80017b:	51                   	push   %ecx
  80017c:	52                   	push   %edx
  80017d:	50                   	push   %eax
  80017e:	68 80 1c 80 00       	push   $0x801c80
  800183:	e8 34 01 00 00       	call   8002bc <cprintf>
  800188:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80018b:	a1 08 30 80 00       	mov    0x803008,%eax
  800190:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 d8 1c 80 00       	push   $0x801cd8
  80019f:	e8 18 01 00 00       	call   8002bc <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	68 30 1c 80 00       	push   $0x801c30
  8001af:	e8 08 01 00 00       	call   8002bc <cprintf>
  8001b4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001b7:	e8 21 0f 00 00       	call   8010dd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001bc:	e8 19 00 00 00       	call   8001da <exit>
}
  8001c1:	90                   	nop
  8001c2:	c9                   	leave  
  8001c3:	c3                   	ret    

008001c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	6a 00                	push   $0x0
  8001cf:	e8 37 11 00 00       	call   80130b <sys_destroy_env>
  8001d4:	83 c4 10             	add    $0x10,%esp
}
  8001d7:	90                   	nop
  8001d8:	c9                   	leave  
  8001d9:	c3                   	ret    

008001da <exit>:

void
exit(void)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8001e0:	e8 8c 11 00 00       	call   801371 <sys_exit_env>
}
  8001e5:	90                   	nop
  8001e6:	c9                   	leave  
  8001e7:	c3                   	ret    

008001e8 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8001ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001f1:	8b 00                	mov    (%eax),%eax
  8001f3:	8d 48 01             	lea    0x1(%eax),%ecx
  8001f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f9:	89 0a                	mov    %ecx,(%edx)
  8001fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001fe:	88 d1                	mov    %dl,%cl
  800200:	8b 55 0c             	mov    0xc(%ebp),%edx
  800203:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800211:	75 2c                	jne    80023f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800213:	a0 0c 30 80 00       	mov    0x80300c,%al
  800218:	0f b6 c0             	movzbl %al,%eax
  80021b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021e:	8b 12                	mov    (%edx),%edx
  800220:	89 d1                	mov    %edx,%ecx
  800222:	8b 55 0c             	mov    0xc(%ebp),%edx
  800225:	83 c2 08             	add    $0x8,%edx
  800228:	83 ec 04             	sub    $0x4,%esp
  80022b:	50                   	push   %eax
  80022c:	51                   	push   %ecx
  80022d:	52                   	push   %edx
  80022e:	e8 4e 0e 00 00       	call   801081 <sys_cputs>
  800233:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80023f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800242:	8b 40 04             	mov    0x4(%eax),%eax
  800245:	8d 50 01             	lea    0x1(%eax),%edx
  800248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80024e:	90                   	nop
  80024f:	c9                   	leave  
  800250:	c3                   	ret    

00800251 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800251:	55                   	push   %ebp
  800252:	89 e5                	mov    %esp,%ebp
  800254:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80025a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800261:	00 00 00 
	b.cnt = 0;
  800264:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80026b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80026e:	ff 75 0c             	pushl  0xc(%ebp)
  800271:	ff 75 08             	pushl  0x8(%ebp)
  800274:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027a:	50                   	push   %eax
  80027b:	68 e8 01 80 00       	push   $0x8001e8
  800280:	e8 11 02 00 00       	call   800496 <vprintfmt>
  800285:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800288:	a0 0c 30 80 00       	mov    0x80300c,%al
  80028d:	0f b6 c0             	movzbl %al,%eax
  800290:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800296:	83 ec 04             	sub    $0x4,%esp
  800299:	50                   	push   %eax
  80029a:	52                   	push   %edx
  80029b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002a1:	83 c0 08             	add    $0x8,%eax
  8002a4:	50                   	push   %eax
  8002a5:	e8 d7 0d 00 00       	call   801081 <sys_cputs>
  8002aa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002ad:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8002b4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002ba:	c9                   	leave  
  8002bb:	c3                   	ret    

008002bc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002c2:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8002c9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d8:	50                   	push   %eax
  8002d9:	e8 73 ff ff ff       	call   800251 <vcprintf>
  8002de:	83 c4 10             	add    $0x10,%esp
  8002e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8002e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  8002ef:	e8 cf 0d 00 00       	call   8010c3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  8002f4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  8002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fd:	83 ec 08             	sub    $0x8,%esp
  800300:	ff 75 f4             	pushl  -0xc(%ebp)
  800303:	50                   	push   %eax
  800304:	e8 48 ff ff ff       	call   800251 <vcprintf>
  800309:	83 c4 10             	add    $0x10,%esp
  80030c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80030f:	e8 c9 0d 00 00       	call   8010dd <sys_unlock_cons>
	return cnt;
  800314:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	53                   	push   %ebx
  80031d:	83 ec 14             	sub    $0x14,%esp
  800320:	8b 45 10             	mov    0x10(%ebp),%eax
  800323:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800326:	8b 45 14             	mov    0x14(%ebp),%eax
  800329:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80032c:	8b 45 18             	mov    0x18(%ebp),%eax
  80032f:	ba 00 00 00 00       	mov    $0x0,%edx
  800334:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800337:	77 55                	ja     80038e <printnum+0x75>
  800339:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80033c:	72 05                	jb     800343 <printnum+0x2a>
  80033e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800341:	77 4b                	ja     80038e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800343:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800346:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800349:	8b 45 18             	mov    0x18(%ebp),%eax
  80034c:	ba 00 00 00 00       	mov    $0x0,%edx
  800351:	52                   	push   %edx
  800352:	50                   	push   %eax
  800353:	ff 75 f4             	pushl  -0xc(%ebp)
  800356:	ff 75 f0             	pushl  -0x10(%ebp)
  800359:	e8 32 16 00 00       	call   801990 <__udivdi3>
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	ff 75 20             	pushl  0x20(%ebp)
  800367:	53                   	push   %ebx
  800368:	ff 75 18             	pushl  0x18(%ebp)
  80036b:	52                   	push   %edx
  80036c:	50                   	push   %eax
  80036d:	ff 75 0c             	pushl  0xc(%ebp)
  800370:	ff 75 08             	pushl  0x8(%ebp)
  800373:	e8 a1 ff ff ff       	call   800319 <printnum>
  800378:	83 c4 20             	add    $0x20,%esp
  80037b:	eb 1a                	jmp    800397 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	ff 75 0c             	pushl  0xc(%ebp)
  800383:	ff 75 20             	pushl  0x20(%ebp)
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	ff d0                	call   *%eax
  80038b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038e:	ff 4d 1c             	decl   0x1c(%ebp)
  800391:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800395:	7f e6                	jg     80037d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800397:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80039a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003a5:	53                   	push   %ebx
  8003a6:	51                   	push   %ecx
  8003a7:	52                   	push   %edx
  8003a8:	50                   	push   %eax
  8003a9:	e8 f2 16 00 00       	call   801aa0 <__umoddi3>
  8003ae:	83 c4 10             	add    $0x10,%esp
  8003b1:	05 14 1f 80 00       	add    $0x801f14,%eax
  8003b6:	8a 00                	mov    (%eax),%al
  8003b8:	0f be c0             	movsbl %al,%eax
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	ff 75 0c             	pushl  0xc(%ebp)
  8003c1:	50                   	push   %eax
  8003c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c5:	ff d0                	call   *%eax
  8003c7:	83 c4 10             	add    $0x10,%esp
}
  8003ca:	90                   	nop
  8003cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003d7:	7e 1c                	jle    8003f5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003dc:	8b 00                	mov    (%eax),%eax
  8003de:	8d 50 08             	lea    0x8(%eax),%edx
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	89 10                	mov    %edx,(%eax)
  8003e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e9:	8b 00                	mov    (%eax),%eax
  8003eb:	83 e8 08             	sub    $0x8,%eax
  8003ee:	8b 50 04             	mov    0x4(%eax),%edx
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	eb 40                	jmp    800435 <getuint+0x65>
	else if (lflag)
  8003f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8003f9:	74 1e                	je     800419 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	8b 00                	mov    (%eax),%eax
  800400:	8d 50 04             	lea    0x4(%eax),%edx
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	89 10                	mov    %edx,(%eax)
  800408:	8b 45 08             	mov    0x8(%ebp),%eax
  80040b:	8b 00                	mov    (%eax),%eax
  80040d:	83 e8 04             	sub    $0x4,%eax
  800410:	8b 00                	mov    (%eax),%eax
  800412:	ba 00 00 00 00       	mov    $0x0,%edx
  800417:	eb 1c                	jmp    800435 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800419:	8b 45 08             	mov    0x8(%ebp),%eax
  80041c:	8b 00                	mov    (%eax),%eax
  80041e:	8d 50 04             	lea    0x4(%eax),%edx
  800421:	8b 45 08             	mov    0x8(%ebp),%eax
  800424:	89 10                	mov    %edx,(%eax)
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	83 e8 04             	sub    $0x4,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800435:	5d                   	pop    %ebp
  800436:	c3                   	ret    

00800437 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800437:	55                   	push   %ebp
  800438:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80043a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80043e:	7e 1c                	jle    80045c <getint+0x25>
		return va_arg(*ap, long long);
  800440:	8b 45 08             	mov    0x8(%ebp),%eax
  800443:	8b 00                	mov    (%eax),%eax
  800445:	8d 50 08             	lea    0x8(%eax),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	89 10                	mov    %edx,(%eax)
  80044d:	8b 45 08             	mov    0x8(%ebp),%eax
  800450:	8b 00                	mov    (%eax),%eax
  800452:	83 e8 08             	sub    $0x8,%eax
  800455:	8b 50 04             	mov    0x4(%eax),%edx
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	eb 38                	jmp    800494 <getint+0x5d>
	else if (lflag)
  80045c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800460:	74 1a                	je     80047c <getint+0x45>
		return va_arg(*ap, long);
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	8b 00                	mov    (%eax),%eax
  800467:	8d 50 04             	lea    0x4(%eax),%edx
  80046a:	8b 45 08             	mov    0x8(%ebp),%eax
  80046d:	89 10                	mov    %edx,(%eax)
  80046f:	8b 45 08             	mov    0x8(%ebp),%eax
  800472:	8b 00                	mov    (%eax),%eax
  800474:	83 e8 04             	sub    $0x4,%eax
  800477:	8b 00                	mov    (%eax),%eax
  800479:	99                   	cltd   
  80047a:	eb 18                	jmp    800494 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80047c:	8b 45 08             	mov    0x8(%ebp),%eax
  80047f:	8b 00                	mov    (%eax),%eax
  800481:	8d 50 04             	lea    0x4(%eax),%edx
  800484:	8b 45 08             	mov    0x8(%ebp),%eax
  800487:	89 10                	mov    %edx,(%eax)
  800489:	8b 45 08             	mov    0x8(%ebp),%eax
  80048c:	8b 00                	mov    (%eax),%eax
  80048e:	83 e8 04             	sub    $0x4,%eax
  800491:	8b 00                	mov    (%eax),%eax
  800493:	99                   	cltd   
}
  800494:	5d                   	pop    %ebp
  800495:	c3                   	ret    

00800496 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	56                   	push   %esi
  80049a:	53                   	push   %ebx
  80049b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80049e:	eb 17                	jmp    8004b7 <vprintfmt+0x21>
			if (ch == '\0')
  8004a0:	85 db                	test   %ebx,%ebx
  8004a2:	0f 84 c1 03 00 00    	je     800869 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004a8:	83 ec 08             	sub    $0x8,%esp
  8004ab:	ff 75 0c             	pushl  0xc(%ebp)
  8004ae:	53                   	push   %ebx
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	ff d0                	call   *%eax
  8004b4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	8d 50 01             	lea    0x1(%eax),%edx
  8004bd:	89 55 10             	mov    %edx,0x10(%ebp)
  8004c0:	8a 00                	mov    (%eax),%al
  8004c2:	0f b6 d8             	movzbl %al,%ebx
  8004c5:	83 fb 25             	cmp    $0x25,%ebx
  8004c8:	75 d6                	jne    8004a0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004ca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004ce:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004d5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8004e3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ed:	8d 50 01             	lea    0x1(%eax),%edx
  8004f0:	89 55 10             	mov    %edx,0x10(%ebp)
  8004f3:	8a 00                	mov    (%eax),%al
  8004f5:	0f b6 d8             	movzbl %al,%ebx
  8004f8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8004fb:	83 f8 5b             	cmp    $0x5b,%eax
  8004fe:	0f 87 3d 03 00 00    	ja     800841 <vprintfmt+0x3ab>
  800504:	8b 04 85 38 1f 80 00 	mov    0x801f38(,%eax,4),%eax
  80050b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80050d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800511:	eb d7                	jmp    8004ea <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800513:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800517:	eb d1                	jmp    8004ea <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800519:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800520:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800523:	89 d0                	mov    %edx,%eax
  800525:	c1 e0 02             	shl    $0x2,%eax
  800528:	01 d0                	add    %edx,%eax
  80052a:	01 c0                	add    %eax,%eax
  80052c:	01 d8                	add    %ebx,%eax
  80052e:	83 e8 30             	sub    $0x30,%eax
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800534:	8b 45 10             	mov    0x10(%ebp),%eax
  800537:	8a 00                	mov    (%eax),%al
  800539:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80053c:	83 fb 2f             	cmp    $0x2f,%ebx
  80053f:	7e 3e                	jle    80057f <vprintfmt+0xe9>
  800541:	83 fb 39             	cmp    $0x39,%ebx
  800544:	7f 39                	jg     80057f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800546:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800549:	eb d5                	jmp    800520 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	83 c0 04             	add    $0x4,%eax
  800551:	89 45 14             	mov    %eax,0x14(%ebp)
  800554:	8b 45 14             	mov    0x14(%ebp),%eax
  800557:	83 e8 04             	sub    $0x4,%eax
  80055a:	8b 00                	mov    (%eax),%eax
  80055c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80055f:	eb 1f                	jmp    800580 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800561:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800565:	79 83                	jns    8004ea <vprintfmt+0x54>
				width = 0;
  800567:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80056e:	e9 77 ff ff ff       	jmp    8004ea <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800573:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80057a:	e9 6b ff ff ff       	jmp    8004ea <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80057f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800580:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800584:	0f 89 60 ff ff ff    	jns    8004ea <vprintfmt+0x54>
				width = precision, precision = -1;
  80058a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80058d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800590:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800597:	e9 4e ff ff ff       	jmp    8004ea <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80059f:	e9 46 ff ff ff       	jmp    8004ea <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a7:	83 c0 04             	add    $0x4,%eax
  8005aa:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	83 e8 04             	sub    $0x4,%eax
  8005b3:	8b 00                	mov    (%eax),%eax
  8005b5:	83 ec 08             	sub    $0x8,%esp
  8005b8:	ff 75 0c             	pushl  0xc(%ebp)
  8005bb:	50                   	push   %eax
  8005bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005bf:	ff d0                	call   *%eax
  8005c1:	83 c4 10             	add    $0x10,%esp
			break;
  8005c4:	e9 9b 02 00 00       	jmp    800864 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	83 c0 04             	add    $0x4,%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	83 e8 04             	sub    $0x4,%eax
  8005d8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005da:	85 db                	test   %ebx,%ebx
  8005dc:	79 02                	jns    8005e0 <vprintfmt+0x14a>
				err = -err;
  8005de:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e0:	83 fb 64             	cmp    $0x64,%ebx
  8005e3:	7f 0b                	jg     8005f0 <vprintfmt+0x15a>
  8005e5:	8b 34 9d 80 1d 80 00 	mov    0x801d80(,%ebx,4),%esi
  8005ec:	85 f6                	test   %esi,%esi
  8005ee:	75 19                	jne    800609 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8005f0:	53                   	push   %ebx
  8005f1:	68 25 1f 80 00       	push   $0x801f25
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 70 02 00 00       	call   800871 <printfmt>
  800601:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800604:	e9 5b 02 00 00       	jmp    800864 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800609:	56                   	push   %esi
  80060a:	68 2e 1f 80 00       	push   $0x801f2e
  80060f:	ff 75 0c             	pushl  0xc(%ebp)
  800612:	ff 75 08             	pushl  0x8(%ebp)
  800615:	e8 57 02 00 00       	call   800871 <printfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
			break;
  80061d:	e9 42 02 00 00       	jmp    800864 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800622:	8b 45 14             	mov    0x14(%ebp),%eax
  800625:	83 c0 04             	add    $0x4,%eax
  800628:	89 45 14             	mov    %eax,0x14(%ebp)
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	83 e8 04             	sub    $0x4,%eax
  800631:	8b 30                	mov    (%eax),%esi
  800633:	85 f6                	test   %esi,%esi
  800635:	75 05                	jne    80063c <vprintfmt+0x1a6>
				p = "(null)";
  800637:	be 31 1f 80 00       	mov    $0x801f31,%esi
			if (width > 0 && padc != '-')
  80063c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800640:	7e 6d                	jle    8006af <vprintfmt+0x219>
  800642:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800646:	74 67                	je     8006af <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800648:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064b:	83 ec 08             	sub    $0x8,%esp
  80064e:	50                   	push   %eax
  80064f:	56                   	push   %esi
  800650:	e8 1e 03 00 00       	call   800973 <strnlen>
  800655:	83 c4 10             	add    $0x10,%esp
  800658:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80065b:	eb 16                	jmp    800673 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80065d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	ff 75 0c             	pushl  0xc(%ebp)
  800667:	50                   	push   %eax
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	ff d0                	call   *%eax
  80066d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800670:	ff 4d e4             	decl   -0x1c(%ebp)
  800673:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800677:	7f e4                	jg     80065d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800679:	eb 34                	jmp    8006af <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80067b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80067f:	74 1c                	je     80069d <vprintfmt+0x207>
  800681:	83 fb 1f             	cmp    $0x1f,%ebx
  800684:	7e 05                	jle    80068b <vprintfmt+0x1f5>
  800686:	83 fb 7e             	cmp    $0x7e,%ebx
  800689:	7e 12                	jle    80069d <vprintfmt+0x207>
					putch('?', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	ff 75 0c             	pushl  0xc(%ebp)
  800691:	6a 3f                	push   $0x3f
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
  80069b:	eb 0f                	jmp    8006ac <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80069d:	83 ec 08             	sub    $0x8,%esp
  8006a0:	ff 75 0c             	pushl  0xc(%ebp)
  8006a3:	53                   	push   %ebx
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8006af:	89 f0                	mov    %esi,%eax
  8006b1:	8d 70 01             	lea    0x1(%eax),%esi
  8006b4:	8a 00                	mov    (%eax),%al
  8006b6:	0f be d8             	movsbl %al,%ebx
  8006b9:	85 db                	test   %ebx,%ebx
  8006bb:	74 24                	je     8006e1 <vprintfmt+0x24b>
  8006bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006c1:	78 b8                	js     80067b <vprintfmt+0x1e5>
  8006c3:	ff 4d e0             	decl   -0x20(%ebp)
  8006c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ca:	79 af                	jns    80067b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006cc:	eb 13                	jmp    8006e1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006ce:	83 ec 08             	sub    $0x8,%esp
  8006d1:	ff 75 0c             	pushl  0xc(%ebp)
  8006d4:	6a 20                	push   $0x20
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	ff d0                	call   *%eax
  8006db:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006de:	ff 4d e4             	decl   -0x1c(%ebp)
  8006e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e5:	7f e7                	jg     8006ce <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8006e7:	e9 78 01 00 00       	jmp    800864 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8006f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8006f5:	50                   	push   %eax
  8006f6:	e8 3c fd ff ff       	call   800437 <getint>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800701:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800707:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070a:	85 d2                	test   %edx,%edx
  80070c:	79 23                	jns    800731 <vprintfmt+0x29b>
				putch('-', putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	ff 75 0c             	pushl  0xc(%ebp)
  800714:	6a 2d                	push   $0x2d
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	ff d0                	call   *%eax
  80071b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80071e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800724:	f7 d8                	neg    %eax
  800726:	83 d2 00             	adc    $0x0,%edx
  800729:	f7 da                	neg    %edx
  80072b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80072e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800731:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800738:	e9 bc 00 00 00       	jmp    8007f9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80073d:	83 ec 08             	sub    $0x8,%esp
  800740:	ff 75 e8             	pushl  -0x18(%ebp)
  800743:	8d 45 14             	lea    0x14(%ebp),%eax
  800746:	50                   	push   %eax
  800747:	e8 84 fc ff ff       	call   8003d0 <getuint>
  80074c:	83 c4 10             	add    $0x10,%esp
  80074f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800752:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800755:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80075c:	e9 98 00 00 00       	jmp    8007f9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800761:	83 ec 08             	sub    $0x8,%esp
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	6a 58                	push   $0x58
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	ff d0                	call   *%eax
  80076e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	6a 58                	push   $0x58
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	ff d0                	call   *%eax
  80077e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	6a 58                	push   $0x58
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
			break;
  800791:	e9 ce 00 00 00       	jmp    800864 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  800796:	83 ec 08             	sub    $0x8,%esp
  800799:	ff 75 0c             	pushl  0xc(%ebp)
  80079c:	6a 30                	push   $0x30
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	ff d0                	call   *%eax
  8007a3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007a6:	83 ec 08             	sub    $0x8,%esp
  8007a9:	ff 75 0c             	pushl  0xc(%ebp)
  8007ac:	6a 78                	push   $0x78
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	83 c0 04             	add    $0x4,%eax
  8007bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	83 e8 04             	sub    $0x4,%eax
  8007c5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007d1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007d8:	eb 1f                	jmp    8007f9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007da:	83 ec 08             	sub    $0x8,%esp
  8007dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8007e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	e8 e7 fb ff ff       	call   8003d0 <getuint>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8007f2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007f9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8007fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	52                   	push   %edx
  800804:	ff 75 e4             	pushl  -0x1c(%ebp)
  800807:	50                   	push   %eax
  800808:	ff 75 f4             	pushl  -0xc(%ebp)
  80080b:	ff 75 f0             	pushl  -0x10(%ebp)
  80080e:	ff 75 0c             	pushl  0xc(%ebp)
  800811:	ff 75 08             	pushl  0x8(%ebp)
  800814:	e8 00 fb ff ff       	call   800319 <printnum>
  800819:	83 c4 20             	add    $0x20,%esp
			break;
  80081c:	eb 46                	jmp    800864 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	eb 35                	jmp    800864 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80082f:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800836:	eb 2c                	jmp    800864 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800838:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  80083f:	eb 23                	jmp    800864 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 25                	push   $0x25
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800851:	ff 4d 10             	decl   0x10(%ebp)
  800854:	eb 03                	jmp    800859 <vprintfmt+0x3c3>
  800856:	ff 4d 10             	decl   0x10(%ebp)
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	48                   	dec    %eax
  80085d:	8a 00                	mov    (%eax),%al
  80085f:	3c 25                	cmp    $0x25,%al
  800861:	75 f3                	jne    800856 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800863:	90                   	nop
		}
	}
  800864:	e9 35 fc ff ff       	jmp    80049e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800869:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80086a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80086d:	5b                   	pop    %ebx
  80086e:	5e                   	pop    %esi
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800877:	8d 45 10             	lea    0x10(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800880:	8b 45 10             	mov    0x10(%ebp),%eax
  800883:	ff 75 f4             	pushl  -0xc(%ebp)
  800886:	50                   	push   %eax
  800887:	ff 75 0c             	pushl  0xc(%ebp)
  80088a:	ff 75 08             	pushl  0x8(%ebp)
  80088d:	e8 04 fc ff ff       	call   800496 <vprintfmt>
  800892:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800895:	90                   	nop
  800896:	c9                   	leave  
  800897:	c3                   	ret    

00800898 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80089b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089e:	8b 40 08             	mov    0x8(%eax),%eax
  8008a1:	8d 50 01             	lea    0x1(%eax),%edx
  8008a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ad:	8b 10                	mov    (%eax),%edx
  8008af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b2:	8b 40 04             	mov    0x4(%eax),%eax
  8008b5:	39 c2                	cmp    %eax,%edx
  8008b7:	73 12                	jae    8008cb <sprintputch+0x33>
		*b->buf++ = ch;
  8008b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 48 01             	lea    0x1(%eax),%ecx
  8008c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c4:	89 0a                	mov    %ecx,(%edx)
  8008c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c9:	88 10                	mov    %dl,(%eax)
}
  8008cb:	90                   	nop
  8008cc:	5d                   	pop    %ebp
  8008cd:	c3                   	ret    

008008ce <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ce:	55                   	push   %ebp
  8008cf:	89 e5                	mov    %esp,%ebp
  8008d1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  8008e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e3:	01 d0                	add    %edx,%eax
  8008e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008f3:	74 06                	je     8008fb <vsnprintf+0x2d>
  8008f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f9:	7f 07                	jg     800902 <vsnprintf+0x34>
		return -E_INVAL;
  8008fb:	b8 03 00 00 00       	mov    $0x3,%eax
  800900:	eb 20                	jmp    800922 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800902:	ff 75 14             	pushl  0x14(%ebp)
  800905:	ff 75 10             	pushl  0x10(%ebp)
  800908:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090b:	50                   	push   %eax
  80090c:	68 98 08 80 00       	push   $0x800898
  800911:	e8 80 fb ff ff       	call   800496 <vprintfmt>
  800916:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80091c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80091f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800922:	c9                   	leave  
  800923:	c3                   	ret    

00800924 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80092a:	8d 45 10             	lea    0x10(%ebp),%eax
  80092d:	83 c0 04             	add    $0x4,%eax
  800930:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800933:	8b 45 10             	mov    0x10(%ebp),%eax
  800936:	ff 75 f4             	pushl  -0xc(%ebp)
  800939:	50                   	push   %eax
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	ff 75 08             	pushl  0x8(%ebp)
  800940:	e8 89 ff ff ff       	call   8008ce <vsnprintf>
  800945:	83 c4 10             	add    $0x10,%esp
  800948:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80094e:	c9                   	leave  
  80094f:	c3                   	ret    

00800950 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800950:	55                   	push   %ebp
  800951:	89 e5                	mov    %esp,%ebp
  800953:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800956:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80095d:	eb 06                	jmp    800965 <strlen+0x15>
		n++;
  80095f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800962:	ff 45 08             	incl   0x8(%ebp)
  800965:	8b 45 08             	mov    0x8(%ebp),%eax
  800968:	8a 00                	mov    (%eax),%al
  80096a:	84 c0                	test   %al,%al
  80096c:	75 f1                	jne    80095f <strlen+0xf>
		n++;
	return n;
  80096e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800971:	c9                   	leave  
  800972:	c3                   	ret    

00800973 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800980:	eb 09                	jmp    80098b <strnlen+0x18>
		n++;
  800982:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800985:	ff 45 08             	incl   0x8(%ebp)
  800988:	ff 4d 0c             	decl   0xc(%ebp)
  80098b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80098f:	74 09                	je     80099a <strnlen+0x27>
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8a 00                	mov    (%eax),%al
  800996:	84 c0                	test   %al,%al
  800998:	75 e8                	jne    800982 <strnlen+0xf>
		n++;
	return n;
  80099a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80099d:	c9                   	leave  
  80099e:	c3                   	ret    

0080099f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
  8009a2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009ab:	90                   	nop
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	8d 50 01             	lea    0x1(%eax),%edx
  8009b2:	89 55 08             	mov    %edx,0x8(%ebp)
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009bb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009be:	8a 12                	mov    (%edx),%dl
  8009c0:	88 10                	mov    %dl,(%eax)
  8009c2:	8a 00                	mov    (%eax),%al
  8009c4:	84 c0                	test   %al,%al
  8009c6:	75 e4                	jne    8009ac <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009cb:	c9                   	leave  
  8009cc:	c3                   	ret    

008009cd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009cd:	55                   	push   %ebp
  8009ce:	89 e5                	mov    %esp,%ebp
  8009d0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009e0:	eb 1f                	jmp    800a01 <strncpy+0x34>
		*dst++ = *src;
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	8d 50 01             	lea    0x1(%eax),%edx
  8009e8:	89 55 08             	mov    %edx,0x8(%ebp)
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ee:	8a 12                	mov    (%edx),%dl
  8009f0:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8009f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f5:	8a 00                	mov    (%eax),%al
  8009f7:	84 c0                	test   %al,%al
  8009f9:	74 03                	je     8009fe <strncpy+0x31>
			src++;
  8009fb:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009fe:	ff 45 fc             	incl   -0x4(%ebp)
  800a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a04:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a07:	72 d9                	jb     8009e2 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a09:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a0c:	c9                   	leave  
  800a0d:	c3                   	ret    

00800a0e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a0e:	55                   	push   %ebp
  800a0f:	89 e5                	mov    %esp,%ebp
  800a11:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a14:	8b 45 08             	mov    0x8(%ebp),%eax
  800a17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a1e:	74 30                	je     800a50 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a20:	eb 16                	jmp    800a38 <strlcpy+0x2a>
			*dst++ = *src++;
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8d 50 01             	lea    0x1(%eax),%edx
  800a28:	89 55 08             	mov    %edx,0x8(%ebp)
  800a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a34:	8a 12                	mov    (%edx),%dl
  800a36:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a38:	ff 4d 10             	decl   0x10(%ebp)
  800a3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a3f:	74 09                	je     800a4a <strlcpy+0x3c>
  800a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a44:	8a 00                	mov    (%eax),%al
  800a46:	84 c0                	test   %al,%al
  800a48:	75 d8                	jne    800a22 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a50:	8b 55 08             	mov    0x8(%ebp),%edx
  800a53:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a56:	29 c2                	sub    %eax,%edx
  800a58:	89 d0                	mov    %edx,%eax
}
  800a5a:	c9                   	leave  
  800a5b:	c3                   	ret    

00800a5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a5f:	eb 06                	jmp    800a67 <strcmp+0xb>
		p++, q++;
  800a61:	ff 45 08             	incl   0x8(%ebp)
  800a64:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	8a 00                	mov    (%eax),%al
  800a6c:	84 c0                	test   %al,%al
  800a6e:	74 0e                	je     800a7e <strcmp+0x22>
  800a70:	8b 45 08             	mov    0x8(%ebp),%eax
  800a73:	8a 10                	mov    (%eax),%dl
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	8a 00                	mov    (%eax),%al
  800a7a:	38 c2                	cmp    %al,%dl
  800a7c:	74 e3                	je     800a61 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	8a 00                	mov    (%eax),%al
  800a83:	0f b6 d0             	movzbl %al,%edx
  800a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a89:	8a 00                	mov    (%eax),%al
  800a8b:	0f b6 c0             	movzbl %al,%eax
  800a8e:	29 c2                	sub    %eax,%edx
  800a90:	89 d0                	mov    %edx,%eax
}
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800a97:	eb 09                	jmp    800aa2 <strncmp+0xe>
		n--, p++, q++;
  800a99:	ff 4d 10             	decl   0x10(%ebp)
  800a9c:	ff 45 08             	incl   0x8(%ebp)
  800a9f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800aa2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa6:	74 17                	je     800abf <strncmp+0x2b>
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	8a 00                	mov    (%eax),%al
  800aad:	84 c0                	test   %al,%al
  800aaf:	74 0e                	je     800abf <strncmp+0x2b>
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	8a 10                	mov    (%eax),%dl
  800ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab9:	8a 00                	mov    (%eax),%al
  800abb:	38 c2                	cmp    %al,%dl
  800abd:	74 da                	je     800a99 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800abf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac3:	75 07                	jne    800acc <strncmp+0x38>
		return 0;
  800ac5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aca:	eb 14                	jmp    800ae0 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	8a 00                	mov    (%eax),%al
  800ad1:	0f b6 d0             	movzbl %al,%edx
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8a 00                	mov    (%eax),%al
  800ad9:	0f b6 c0             	movzbl %al,%eax
  800adc:	29 c2                	sub    %eax,%edx
  800ade:	89 d0                	mov    %edx,%eax
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
  800ae5:	83 ec 04             	sub    $0x4,%esp
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800aee:	eb 12                	jmp    800b02 <strchr+0x20>
		if (*s == c)
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	8a 00                	mov    (%eax),%al
  800af5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800af8:	75 05                	jne    800aff <strchr+0x1d>
			return (char *) s;
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	eb 11                	jmp    800b10 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aff:	ff 45 08             	incl   0x8(%ebp)
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8a 00                	mov    (%eax),%al
  800b07:	84 c0                	test   %al,%al
  800b09:	75 e5                	jne    800af0 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	83 ec 04             	sub    $0x4,%esp
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b1e:	eb 0d                	jmp    800b2d <strfind+0x1b>
		if (*s == c)
  800b20:	8b 45 08             	mov    0x8(%ebp),%eax
  800b23:	8a 00                	mov    (%eax),%al
  800b25:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b28:	74 0e                	je     800b38 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b2a:	ff 45 08             	incl   0x8(%ebp)
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8a 00                	mov    (%eax),%al
  800b32:	84 c0                	test   %al,%al
  800b34:	75 ea                	jne    800b20 <strfind+0xe>
  800b36:	eb 01                	jmp    800b39 <strfind+0x27>
		if (*s == c)
			break;
  800b38:	90                   	nop
	return (char *) s;
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b3c:	c9                   	leave  
  800b3d:	c3                   	ret    

00800b3e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b4d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b50:	eb 0e                	jmp    800b60 <memset+0x22>
		*p++ = c;
  800b52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b60:	ff 4d f8             	decl   -0x8(%ebp)
  800b63:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b67:	79 e9                	jns    800b52 <memset+0x14>
		*p++ = c;

	return v;
  800b69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b6c:	c9                   	leave  
  800b6d:	c3                   	ret    

00800b6e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
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
	while (n-- > 0)
  800b80:	eb 16                	jmp    800b98 <memcpy+0x2a>
		*d++ = *s++;
  800b82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b85:	8d 50 01             	lea    0x1(%eax),%edx
  800b88:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800b8b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800b8e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b91:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800b94:	8a 12                	mov    (%edx),%dl
  800b96:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b9e:	89 55 10             	mov    %edx,0x10(%ebp)
  800ba1:	85 c0                	test   %eax,%eax
  800ba3:	75 dd                	jne    800b82 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ba8:	c9                   	leave  
  800ba9:	c3                   	ret    

00800baa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
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
	if (s < d && s + n > d) {
  800bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bbf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bc2:	73 50                	jae    800c14 <memmove+0x6a>
  800bc4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bca:	01 d0                	add    %edx,%eax
  800bcc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bcf:	76 43                	jbe    800c14 <memmove+0x6a>
		s += n;
  800bd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bda:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bdd:	eb 10                	jmp    800bef <memmove+0x45>
			*--d = *--s;
  800bdf:	ff 4d f8             	decl   -0x8(%ebp)
  800be2:	ff 4d fc             	decl   -0x4(%ebp)
  800be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be8:	8a 10                	mov    (%eax),%dl
  800bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800bed:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bf5:	89 55 10             	mov    %edx,0x10(%ebp)
  800bf8:	85 c0                	test   %eax,%eax
  800bfa:	75 e3                	jne    800bdf <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bfc:	eb 23                	jmp    800c21 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800bfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c01:	8d 50 01             	lea    0x1(%eax),%edx
  800c04:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c07:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c0a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c0d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c10:	8a 12                	mov    (%edx),%dl
  800c12:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c14:	8b 45 10             	mov    0x10(%ebp),%eax
  800c17:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c1a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	75 dd                	jne    800bfe <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c38:	eb 2a                	jmp    800c64 <memcmp+0x3e>
		if (*s1 != *s2)
  800c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c3d:	8a 10                	mov    (%eax),%dl
  800c3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c42:	8a 00                	mov    (%eax),%al
  800c44:	38 c2                	cmp    %al,%dl
  800c46:	74 16                	je     800c5e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f b6 d0             	movzbl %al,%edx
  800c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 c0             	movzbl %al,%eax
  800c58:	29 c2                	sub    %eax,%edx
  800c5a:	89 d0                	mov    %edx,%eax
  800c5c:	eb 18                	jmp    800c76 <memcmp+0x50>
		s1++, s2++;
  800c5e:	ff 45 fc             	incl   -0x4(%ebp)
  800c61:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c64:	8b 45 10             	mov    0x10(%ebp),%eax
  800c67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6d:	85 c0                	test   %eax,%eax
  800c6f:	75 c9                	jne    800c3a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c7e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c81:	8b 45 10             	mov    0x10(%ebp),%eax
  800c84:	01 d0                	add    %edx,%eax
  800c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800c89:	eb 15                	jmp    800ca0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8a 00                	mov    (%eax),%al
  800c90:	0f b6 d0             	movzbl %al,%edx
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	0f b6 c0             	movzbl %al,%eax
  800c99:	39 c2                	cmp    %eax,%edx
  800c9b:	74 0d                	je     800caa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c9d:	ff 45 08             	incl   0x8(%ebp)
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ca6:	72 e3                	jb     800c8b <memfind+0x13>
  800ca8:	eb 01                	jmp    800cab <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800caa:	90                   	nop
	return (void *) s;
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cae:	c9                   	leave  
  800caf:	c3                   	ret    

00800cb0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cb6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cbd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc4:	eb 03                	jmp    800cc9 <strtol+0x19>
		s++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 20                	cmp    $0x20,%al
  800cd0:	74 f4                	je     800cc6 <strtol+0x16>
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	3c 09                	cmp    $0x9,%al
  800cd9:	74 eb                	je     800cc6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	3c 2b                	cmp    $0x2b,%al
  800ce2:	75 05                	jne    800ce9 <strtol+0x39>
		s++;
  800ce4:	ff 45 08             	incl   0x8(%ebp)
  800ce7:	eb 13                	jmp    800cfc <strtol+0x4c>
	else if (*s == '-')
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	3c 2d                	cmp    $0x2d,%al
  800cf0:	75 0a                	jne    800cfc <strtol+0x4c>
		s++, neg = 1;
  800cf2:	ff 45 08             	incl   0x8(%ebp)
  800cf5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d00:	74 06                	je     800d08 <strtol+0x58>
  800d02:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d06:	75 20                	jne    800d28 <strtol+0x78>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 00                	mov    (%eax),%al
  800d0d:	3c 30                	cmp    $0x30,%al
  800d0f:	75 17                	jne    800d28 <strtol+0x78>
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	40                   	inc    %eax
  800d15:	8a 00                	mov    (%eax),%al
  800d17:	3c 78                	cmp    $0x78,%al
  800d19:	75 0d                	jne    800d28 <strtol+0x78>
		s += 2, base = 16;
  800d1b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d1f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d26:	eb 28                	jmp    800d50 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2c:	75 15                	jne    800d43 <strtol+0x93>
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8a 00                	mov    (%eax),%al
  800d33:	3c 30                	cmp    $0x30,%al
  800d35:	75 0c                	jne    800d43 <strtol+0x93>
		s++, base = 8;
  800d37:	ff 45 08             	incl   0x8(%ebp)
  800d3a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d41:	eb 0d                	jmp    800d50 <strtol+0xa0>
	else if (base == 0)
  800d43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d47:	75 07                	jne    800d50 <strtol+0xa0>
		base = 10;
  800d49:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d50:	8b 45 08             	mov    0x8(%ebp),%eax
  800d53:	8a 00                	mov    (%eax),%al
  800d55:	3c 2f                	cmp    $0x2f,%al
  800d57:	7e 19                	jle    800d72 <strtol+0xc2>
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	3c 39                	cmp    $0x39,%al
  800d60:	7f 10                	jg     800d72 <strtol+0xc2>
			dig = *s - '0';
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	0f be c0             	movsbl %al,%eax
  800d6a:	83 e8 30             	sub    $0x30,%eax
  800d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d70:	eb 42                	jmp    800db4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8a 00                	mov    (%eax),%al
  800d77:	3c 60                	cmp    $0x60,%al
  800d79:	7e 19                	jle    800d94 <strtol+0xe4>
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8a 00                	mov    (%eax),%al
  800d80:	3c 7a                	cmp    $0x7a,%al
  800d82:	7f 10                	jg     800d94 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	0f be c0             	movsbl %al,%eax
  800d8c:	83 e8 57             	sub    $0x57,%eax
  800d8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d92:	eb 20                	jmp    800db4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800d94:	8b 45 08             	mov    0x8(%ebp),%eax
  800d97:	8a 00                	mov    (%eax),%al
  800d99:	3c 40                	cmp    $0x40,%al
  800d9b:	7e 39                	jle    800dd6 <strtol+0x126>
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	8a 00                	mov    (%eax),%al
  800da2:	3c 5a                	cmp    $0x5a,%al
  800da4:	7f 30                	jg     800dd6 <strtol+0x126>
			dig = *s - 'A' + 10;
  800da6:	8b 45 08             	mov    0x8(%ebp),%eax
  800da9:	8a 00                	mov    (%eax),%al
  800dab:	0f be c0             	movsbl %al,%eax
  800dae:	83 e8 37             	sub    $0x37,%eax
  800db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dba:	7d 19                	jge    800dd5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800dbc:	ff 45 08             	incl   0x8(%ebp)
  800dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800dc6:	89 c2                	mov    %eax,%edx
  800dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dcb:	01 d0                	add    %edx,%eax
  800dcd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800dd0:	e9 7b ff ff ff       	jmp    800d50 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800dd5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800dd6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dda:	74 08                	je     800de4 <strtol+0x134>
		*endptr = (char *) s;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800de4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800de8:	74 07                	je     800df1 <strtol+0x141>
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	f7 d8                	neg    %eax
  800def:	eb 03                	jmp    800df4 <strtol+0x144>
  800df1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800df4:	c9                   	leave  
  800df5:	c3                   	ret    

00800df6 <ltostr>:

void
ltostr(long value, char *str)
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800dfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e03:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e0e:	79 13                	jns    800e23 <ltostr+0x2d>
	{
		neg = 1;
  800e10:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e1d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e20:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e2b:	99                   	cltd   
  800e2c:	f7 f9                	idiv   %ecx
  800e2e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e34:	8d 50 01             	lea    0x1(%eax),%edx
  800e37:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3a:	89 c2                	mov    %eax,%edx
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	01 d0                	add    %edx,%eax
  800e41:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e44:	83 c2 30             	add    $0x30,%edx
  800e47:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e51:	f7 e9                	imul   %ecx
  800e53:	c1 fa 02             	sar    $0x2,%edx
  800e56:	89 c8                	mov    %ecx,%eax
  800e58:	c1 f8 1f             	sar    $0x1f,%eax
  800e5b:	29 c2                	sub    %eax,%edx
  800e5d:	89 d0                	mov    %edx,%eax
  800e5f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e66:	75 bb                	jne    800e23 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e72:	48                   	dec    %eax
  800e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e76:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e7a:	74 3d                	je     800eb9 <ltostr+0xc3>
		start = 1 ;
  800e7c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800e83:	eb 34                	jmp    800eb9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8b:	01 d0                	add    %edx,%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e98:	01 c2                	add    %eax,%edx
  800e9a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	01 c8                	add    %ecx,%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ea6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eac:	01 c2                	add    %eax,%edx
  800eae:	8a 45 eb             	mov    -0x15(%ebp),%al
  800eb1:	88 02                	mov    %al,(%edx)
		start++ ;
  800eb3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800eb6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ebf:	7c c4                	jl     800e85 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ec1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	01 d0                	add    %edx,%eax
  800ec9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800ecc:	90                   	nop
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ed5:	ff 75 08             	pushl  0x8(%ebp)
  800ed8:	e8 73 fa ff ff       	call   800950 <strlen>
  800edd:	83 c4 04             	add    $0x4,%esp
  800ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800ee3:	ff 75 0c             	pushl  0xc(%ebp)
  800ee6:	e8 65 fa ff ff       	call   800950 <strlen>
  800eeb:	83 c4 04             	add    $0x4,%esp
  800eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800ef1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800ef8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eff:	eb 17                	jmp    800f18 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8b 45 10             	mov    0x10(%ebp),%eax
  800f07:	01 c2                	add    %eax,%edx
  800f09:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	01 c8                	add    %ecx,%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f1e:	7c e1                	jl     800f01 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f20:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f27:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f2e:	eb 1f                	jmp    800f4f <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f33:	8d 50 01             	lea    0x1(%eax),%edx
  800f36:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f39:	89 c2                	mov    %eax,%edx
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 c2                	add    %eax,%edx
  800f40:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	01 c8                	add    %ecx,%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f4c:	ff 45 f8             	incl   -0x8(%ebp)
  800f4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f55:	7c d9                	jl     800f30 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 d0                	add    %edx,%eax
  800f5f:	c6 00 00             	movb   $0x0,(%eax)
}
  800f62:	90                   	nop
  800f63:	c9                   	leave  
  800f64:	c3                   	ret    

00800f65 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f68:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f71:	8b 45 14             	mov    0x14(%ebp),%eax
  800f74:	8b 00                	mov    (%eax),%eax
  800f76:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f80:	01 d0                	add    %edx,%eax
  800f82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f88:	eb 0c                	jmp    800f96 <strsplit+0x31>
			*string++ = 0;
  800f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8d:	8d 50 01             	lea    0x1(%eax),%edx
  800f90:	89 55 08             	mov    %edx,0x8(%ebp)
  800f93:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	84 c0                	test   %al,%al
  800f9d:	74 18                	je     800fb7 <strsplit+0x52>
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	0f be c0             	movsbl %al,%eax
  800fa7:	50                   	push   %eax
  800fa8:	ff 75 0c             	pushl  0xc(%ebp)
  800fab:	e8 32 fb ff ff       	call   800ae2 <strchr>
  800fb0:	83 c4 08             	add    $0x8,%esp
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	75 d3                	jne    800f8a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8a 00                	mov    (%eax),%al
  800fbc:	84 c0                	test   %al,%al
  800fbe:	74 5a                	je     80101a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc3:	8b 00                	mov    (%eax),%eax
  800fc5:	83 f8 0f             	cmp    $0xf,%eax
  800fc8:	75 07                	jne    800fd1 <strsplit+0x6c>
		{
			return 0;
  800fca:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcf:	eb 66                	jmp    801037 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800fd1:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd4:	8b 00                	mov    (%eax),%eax
  800fd6:	8d 48 01             	lea    0x1(%eax),%ecx
  800fd9:	8b 55 14             	mov    0x14(%ebp),%edx
  800fdc:	89 0a                	mov    %ecx,(%edx)
  800fde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 c2                	add    %eax,%edx
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  800fef:	eb 03                	jmp    800ff4 <strsplit+0x8f>
			string++;
  800ff1:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	84 c0                	test   %al,%al
  800ffb:	74 8b                	je     800f88 <strsplit+0x23>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	50                   	push   %eax
  801006:	ff 75 0c             	pushl  0xc(%ebp)
  801009:	e8 d4 fa ff ff       	call   800ae2 <strchr>
  80100e:	83 c4 08             	add    $0x8,%esp
  801011:	85 c0                	test   %eax,%eax
  801013:	74 dc                	je     800ff1 <strsplit+0x8c>
			string++;
	}
  801015:	e9 6e ff ff ff       	jmp    800f88 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80101a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80101b:	8b 45 14             	mov    0x14(%ebp),%eax
  80101e:	8b 00                	mov    (%eax),%eax
  801020:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801032:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	68 a8 20 80 00       	push   $0x8020a8
  801047:	68 3f 01 00 00       	push   $0x13f
  80104c:	68 ca 20 80 00       	push   $0x8020ca
  801051:	e8 51 07 00 00       	call   8017a7 <_panic>

00801056 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	57                   	push   %edi
  80105a:	56                   	push   %esi
  80105b:	53                   	push   %ebx
  80105c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8b 55 0c             	mov    0xc(%ebp),%edx
  801065:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801068:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80106b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80106e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801071:	cd 30                	int    $0x30
  801073:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801076:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801079:	83 c4 10             	add    $0x10,%esp
  80107c:	5b                   	pop    %ebx
  80107d:	5e                   	pop    %esi
  80107e:	5f                   	pop    %edi
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 04             	sub    $0x4,%esp
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
  80108a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  80108d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	6a 00                	push   $0x0
  801096:	6a 00                	push   $0x0
  801098:	52                   	push   %edx
  801099:	ff 75 0c             	pushl  0xc(%ebp)
  80109c:	50                   	push   %eax
  80109d:	6a 00                	push   $0x0
  80109f:	e8 b2 ff ff ff       	call   801056 <syscall>
  8010a4:	83 c4 18             	add    $0x18,%esp
}
  8010a7:	90                   	nop
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <sys_cgetc>:

int sys_cgetc(void) {
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010ad:	6a 00                	push   $0x0
  8010af:	6a 00                	push   $0x0
  8010b1:	6a 00                	push   $0x0
  8010b3:	6a 00                	push   $0x0
  8010b5:	6a 00                	push   $0x0
  8010b7:	6a 02                	push   $0x2
  8010b9:	e8 98 ff ff ff       	call   801056 <syscall>
  8010be:	83 c4 18             	add    $0x18,%esp
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <sys_lock_cons>:

void sys_lock_cons(void) {
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010c6:	6a 00                	push   $0x0
  8010c8:	6a 00                	push   $0x0
  8010ca:	6a 00                	push   $0x0
  8010cc:	6a 00                	push   $0x0
  8010ce:	6a 00                	push   $0x0
  8010d0:	6a 03                	push   $0x3
  8010d2:	e8 7f ff ff ff       	call   801056 <syscall>
  8010d7:	83 c4 18             	add    $0x18,%esp
}
  8010da:	90                   	nop
  8010db:	c9                   	leave  
  8010dc:	c3                   	ret    

008010dd <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  8010e0:	6a 00                	push   $0x0
  8010e2:	6a 00                	push   $0x0
  8010e4:	6a 00                	push   $0x0
  8010e6:	6a 00                	push   $0x0
  8010e8:	6a 00                	push   $0x0
  8010ea:	6a 04                	push   $0x4
  8010ec:	e8 65 ff ff ff       	call   801056 <syscall>
  8010f1:	83 c4 18             	add    $0x18,%esp
}
  8010f4:	90                   	nop
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  8010fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	52                   	push   %edx
  801107:	50                   	push   %eax
  801108:	6a 08                	push   $0x8
  80110a:	e8 47 ff ff ff       	call   801056 <syscall>
  80110f:	83 c4 18             	add    $0x18,%esp
}
  801112:	c9                   	leave  
  801113:	c3                   	ret    

00801114 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801114:	55                   	push   %ebp
  801115:	89 e5                	mov    %esp,%ebp
  801117:	56                   	push   %esi
  801118:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801119:	8b 75 18             	mov    0x18(%ebp),%esi
  80111c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80111f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801122:	8b 55 0c             	mov    0xc(%ebp),%edx
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	56                   	push   %esi
  801129:	53                   	push   %ebx
  80112a:	51                   	push   %ecx
  80112b:	52                   	push   %edx
  80112c:	50                   	push   %eax
  80112d:	6a 09                	push   $0x9
  80112f:	e8 22 ff ff ff       	call   801056 <syscall>
  801134:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801137:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80113a:	5b                   	pop    %ebx
  80113b:	5e                   	pop    %esi
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801141:	8b 55 0c             	mov    0xc(%ebp),%edx
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	6a 00                	push   $0x0
  801149:	6a 00                	push   $0x0
  80114b:	6a 00                	push   $0x0
  80114d:	52                   	push   %edx
  80114e:	50                   	push   %eax
  80114f:	6a 0a                	push   $0xa
  801151:	e8 00 ff ff ff       	call   801056 <syscall>
  801156:	83 c4 18             	add    $0x18,%esp
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80115e:	6a 00                	push   $0x0
  801160:	6a 00                	push   $0x0
  801162:	6a 00                	push   $0x0
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	ff 75 08             	pushl  0x8(%ebp)
  80116a:	6a 0b                	push   $0xb
  80116c:	e8 e5 fe ff ff       	call   801056 <syscall>
  801171:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801179:	6a 00                	push   $0x0
  80117b:	6a 00                	push   $0x0
  80117d:	6a 00                	push   $0x0
  80117f:	6a 00                	push   $0x0
  801181:	6a 00                	push   $0x0
  801183:	6a 0c                	push   $0xc
  801185:	e8 cc fe ff ff       	call   801056 <syscall>
  80118a:	83 c4 18             	add    $0x18,%esp
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801192:	6a 00                	push   $0x0
  801194:	6a 00                	push   $0x0
  801196:	6a 00                	push   $0x0
  801198:	6a 00                	push   $0x0
  80119a:	6a 00                	push   $0x0
  80119c:	6a 0d                	push   $0xd
  80119e:	e8 b3 fe ff ff       	call   801056 <syscall>
  8011a3:	83 c4 18             	add    $0x18,%esp
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011ab:	6a 00                	push   $0x0
  8011ad:	6a 00                	push   $0x0
  8011af:	6a 00                	push   $0x0
  8011b1:	6a 00                	push   $0x0
  8011b3:	6a 00                	push   $0x0
  8011b5:	6a 0e                	push   $0xe
  8011b7:	e8 9a fe ff ff       	call   801056 <syscall>
  8011bc:	83 c4 18             	add    $0x18,%esp
}
  8011bf:	c9                   	leave  
  8011c0:	c3                   	ret    

008011c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8011c4:	6a 00                	push   $0x0
  8011c6:	6a 00                	push   $0x0
  8011c8:	6a 00                	push   $0x0
  8011ca:	6a 00                	push   $0x0
  8011cc:	6a 00                	push   $0x0
  8011ce:	6a 0f                	push   $0xf
  8011d0:	e8 81 fe ff ff       	call   801056 <syscall>
  8011d5:	83 c4 18             	add    $0x18,%esp
}
  8011d8:	c9                   	leave  
  8011d9:	c3                   	ret    

008011da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8011dd:	6a 00                	push   $0x0
  8011df:	6a 00                	push   $0x0
  8011e1:	6a 00                	push   $0x0
  8011e3:	6a 00                	push   $0x0
  8011e5:	ff 75 08             	pushl  0x8(%ebp)
  8011e8:	6a 10                	push   $0x10
  8011ea:	e8 67 fe ff ff       	call   801056 <syscall>
  8011ef:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  8011f2:	c9                   	leave  
  8011f3:	c3                   	ret    

008011f4 <sys_scarce_memory>:

void sys_scarce_memory() {
  8011f4:	55                   	push   %ebp
  8011f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  8011f7:	6a 00                	push   $0x0
  8011f9:	6a 00                	push   $0x0
  8011fb:	6a 00                	push   $0x0
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 11                	push   $0x11
  801203:	e8 4e fe ff ff       	call   801056 <syscall>
  801208:	83 c4 18             	add    $0x18,%esp
}
  80120b:	90                   	nop
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <sys_cputc>:

void sys_cputc(const char c) {
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 04             	sub    $0x4,%esp
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80121a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80121e:	6a 00                	push   $0x0
  801220:	6a 00                	push   $0x0
  801222:	6a 00                	push   $0x0
  801224:	6a 00                	push   $0x0
  801226:	50                   	push   %eax
  801227:	6a 01                	push   $0x1
  801229:	e8 28 fe ff ff       	call   801056 <syscall>
  80122e:	83 c4 18             	add    $0x18,%esp
}
  801231:	90                   	nop
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801237:	6a 00                	push   $0x0
  801239:	6a 00                	push   $0x0
  80123b:	6a 00                	push   $0x0
  80123d:	6a 00                	push   $0x0
  80123f:	6a 00                	push   $0x0
  801241:	6a 14                	push   $0x14
  801243:	e8 0e fe ff ff       	call   801056 <syscall>
  801248:	83 c4 18             	add    $0x18,%esp
}
  80124b:	90                   	nop
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	83 ec 04             	sub    $0x4,%esp
  801254:	8b 45 10             	mov    0x10(%ebp),%eax
  801257:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80125a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80125d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	6a 00                	push   $0x0
  801266:	51                   	push   %ecx
  801267:	52                   	push   %edx
  801268:	ff 75 0c             	pushl  0xc(%ebp)
  80126b:	50                   	push   %eax
  80126c:	6a 15                	push   $0x15
  80126e:	e8 e3 fd ff ff       	call   801056 <syscall>
  801273:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80127b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	6a 00                	push   $0x0
  801283:	6a 00                	push   $0x0
  801285:	6a 00                	push   $0x0
  801287:	52                   	push   %edx
  801288:	50                   	push   %eax
  801289:	6a 16                	push   $0x16
  80128b:	e8 c6 fd ff ff       	call   801056 <syscall>
  801290:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  801293:	c9                   	leave  
  801294:	c3                   	ret    

00801295 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  801298:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80129b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	51                   	push   %ecx
  8012a6:	52                   	push   %edx
  8012a7:	50                   	push   %eax
  8012a8:	6a 17                	push   $0x17
  8012aa:	e8 a7 fd ff ff       	call   801056 <syscall>
  8012af:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8012b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	6a 00                	push   $0x0
  8012bf:	6a 00                	push   $0x0
  8012c1:	6a 00                	push   $0x0
  8012c3:	52                   	push   %edx
  8012c4:	50                   	push   %eax
  8012c5:	6a 18                	push   $0x18
  8012c7:	e8 8a fd ff ff       	call   801056 <syscall>
  8012cc:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	6a 00                	push   $0x0
  8012d9:	ff 75 14             	pushl  0x14(%ebp)
  8012dc:	ff 75 10             	pushl  0x10(%ebp)
  8012df:	ff 75 0c             	pushl  0xc(%ebp)
  8012e2:	50                   	push   %eax
  8012e3:	6a 19                	push   $0x19
  8012e5:	e8 6c fd ff ff       	call   801056 <syscall>
  8012ea:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <sys_run_env>:

void sys_run_env(int32 envId) {
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  8012f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f5:	6a 00                	push   $0x0
  8012f7:	6a 00                	push   $0x0
  8012f9:	6a 00                	push   $0x0
  8012fb:	6a 00                	push   $0x0
  8012fd:	50                   	push   %eax
  8012fe:	6a 1a                	push   $0x1a
  801300:	e8 51 fd ff ff       	call   801056 <syscall>
  801305:	83 c4 18             	add    $0x18,%esp
}
  801308:	90                   	nop
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	6a 00                	push   $0x0
  801313:	6a 00                	push   $0x0
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	50                   	push   %eax
  80131a:	6a 1b                	push   $0x1b
  80131c:	e8 35 fd ff ff       	call   801056 <syscall>
  801321:	83 c4 18             	add    $0x18,%esp
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <sys_getenvid>:

int32 sys_getenvid(void) {
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801329:	6a 00                	push   $0x0
  80132b:	6a 00                	push   $0x0
  80132d:	6a 00                	push   $0x0
  80132f:	6a 00                	push   $0x0
  801331:	6a 00                	push   $0x0
  801333:	6a 05                	push   $0x5
  801335:	e8 1c fd ff ff       	call   801056 <syscall>
  80133a:	83 c4 18             	add    $0x18,%esp
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801342:	6a 00                	push   $0x0
  801344:	6a 00                	push   $0x0
  801346:	6a 00                	push   $0x0
  801348:	6a 00                	push   $0x0
  80134a:	6a 00                	push   $0x0
  80134c:	6a 06                	push   $0x6
  80134e:	e8 03 fd ff ff       	call   801056 <syscall>
  801353:	83 c4 18             	add    $0x18,%esp
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80135b:	6a 00                	push   $0x0
  80135d:	6a 00                	push   $0x0
  80135f:	6a 00                	push   $0x0
  801361:	6a 00                	push   $0x0
  801363:	6a 00                	push   $0x0
  801365:	6a 07                	push   $0x7
  801367:	e8 ea fc ff ff       	call   801056 <syscall>
  80136c:	83 c4 18             	add    $0x18,%esp
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <sys_exit_env>:

void sys_exit_env(void) {
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801374:	6a 00                	push   $0x0
  801376:	6a 00                	push   $0x0
  801378:	6a 00                	push   $0x0
  80137a:	6a 00                	push   $0x0
  80137c:	6a 00                	push   $0x0
  80137e:	6a 1c                	push   $0x1c
  801380:	e8 d1 fc ff ff       	call   801056 <syscall>
  801385:	83 c4 18             	add    $0x18,%esp
}
  801388:	90                   	nop
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  801391:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801394:	8d 50 04             	lea    0x4(%eax),%edx
  801397:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 00                	push   $0x0
  8013a0:	52                   	push   %edx
  8013a1:	50                   	push   %eax
  8013a2:	6a 1d                	push   $0x1d
  8013a4:	e8 ad fc ff ff       	call   801056 <syscall>
  8013a9:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8013ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b5:	89 01                	mov    %eax,(%ecx)
  8013b7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	c9                   	leave  
  8013be:	c2 04 00             	ret    $0x4

008013c1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8013c4:	6a 00                	push   $0x0
  8013c6:	6a 00                	push   $0x0
  8013c8:	ff 75 10             	pushl  0x10(%ebp)
  8013cb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ce:	ff 75 08             	pushl  0x8(%ebp)
  8013d1:	6a 13                	push   $0x13
  8013d3:	e8 7e fc ff ff       	call   801056 <syscall>
  8013d8:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8013db:	90                   	nop
}
  8013dc:	c9                   	leave  
  8013dd:	c3                   	ret    

008013de <sys_rcr2>:
uint32 sys_rcr2() {
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8013e1:	6a 00                	push   $0x0
  8013e3:	6a 00                	push   $0x0
  8013e5:	6a 00                	push   $0x0
  8013e7:	6a 00                	push   $0x0
  8013e9:	6a 00                	push   $0x0
  8013eb:	6a 1e                	push   $0x1e
  8013ed:	e8 64 fc ff ff       	call   801056 <syscall>
  8013f2:	83 c4 18             	add    $0x18,%esp
}
  8013f5:	c9                   	leave  
  8013f6:	c3                   	ret    

008013f7 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801403:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 00                	push   $0x0
  80140d:	6a 00                	push   $0x0
  80140f:	50                   	push   %eax
  801410:	6a 1f                	push   $0x1f
  801412:	e8 3f fc ff ff       	call   801056 <syscall>
  801417:	83 c4 18             	add    $0x18,%esp
	return;
  80141a:	90                   	nop
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <rsttst>:
void rsttst() {
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801420:	6a 00                	push   $0x0
  801422:	6a 00                	push   $0x0
  801424:	6a 00                	push   $0x0
  801426:	6a 00                	push   $0x0
  801428:	6a 00                	push   $0x0
  80142a:	6a 21                	push   $0x21
  80142c:	e8 25 fc ff ff       	call   801056 <syscall>
  801431:	83 c4 18             	add    $0x18,%esp
	return;
  801434:	90                   	nop
}
  801435:	c9                   	leave  
  801436:	c3                   	ret    

00801437 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801437:	55                   	push   %ebp
  801438:	89 e5                	mov    %esp,%ebp
  80143a:	83 ec 04             	sub    $0x4,%esp
  80143d:	8b 45 14             	mov    0x14(%ebp),%eax
  801440:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801443:	8b 55 18             	mov    0x18(%ebp),%edx
  801446:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80144a:	52                   	push   %edx
  80144b:	50                   	push   %eax
  80144c:	ff 75 10             	pushl  0x10(%ebp)
  80144f:	ff 75 0c             	pushl  0xc(%ebp)
  801452:	ff 75 08             	pushl  0x8(%ebp)
  801455:	6a 20                	push   $0x20
  801457:	e8 fa fb ff ff       	call   801056 <syscall>
  80145c:	83 c4 18             	add    $0x18,%esp
	return;
  80145f:	90                   	nop
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <chktst>:
void chktst(uint32 n) {
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	6a 00                	push   $0x0
  80146b:	6a 00                	push   $0x0
  80146d:	ff 75 08             	pushl  0x8(%ebp)
  801470:	6a 22                	push   $0x22
  801472:	e8 df fb ff ff       	call   801056 <syscall>
  801477:	83 c4 18             	add    $0x18,%esp
	return;
  80147a:	90                   	nop
}
  80147b:	c9                   	leave  
  80147c:	c3                   	ret    

0080147d <inctst>:

void inctst() {
  80147d:	55                   	push   %ebp
  80147e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 00                	push   $0x0
  80148a:	6a 23                	push   $0x23
  80148c:	e8 c5 fb ff ff       	call   801056 <syscall>
  801491:	83 c4 18             	add    $0x18,%esp
	return;
  801494:	90                   	nop
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <gettst>:
uint32 gettst() {
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80149a:	6a 00                	push   $0x0
  80149c:	6a 00                	push   $0x0
  80149e:	6a 00                	push   $0x0
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 24                	push   $0x24
  8014a6:	e8 ab fb ff ff       	call   801056 <syscall>
  8014ab:	83 c4 18             	add    $0x18,%esp
}
  8014ae:	c9                   	leave  
  8014af:	c3                   	ret    

008014b0 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014b6:	6a 00                	push   $0x0
  8014b8:	6a 00                	push   $0x0
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 25                	push   $0x25
  8014c2:	e8 8f fb ff ff       	call   801056 <syscall>
  8014c7:	83 c4 18             	add    $0x18,%esp
  8014ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014cd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014d1:	75 07                	jne    8014da <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8014d8:	eb 05                	jmp    8014df <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014e7:	6a 00                	push   $0x0
  8014e9:	6a 00                	push   $0x0
  8014eb:	6a 00                	push   $0x0
  8014ed:	6a 00                	push   $0x0
  8014ef:	6a 00                	push   $0x0
  8014f1:	6a 25                	push   $0x25
  8014f3:	e8 5e fb ff ff       	call   801056 <syscall>
  8014f8:	83 c4 18             	add    $0x18,%esp
  8014fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8014fe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801502:	75 07                	jne    80150b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801504:	b8 01 00 00 00       	mov    $0x1,%eax
  801509:	eb 05                	jmp    801510 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801510:	c9                   	leave  
  801511:	c3                   	ret    

00801512 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
  801515:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 00                	push   $0x0
  801522:	6a 25                	push   $0x25
  801524:	e8 2d fb ff ff       	call   801056 <syscall>
  801529:	83 c4 18             	add    $0x18,%esp
  80152c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80152f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801533:	75 07                	jne    80153c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801535:	b8 01 00 00 00       	mov    $0x1,%eax
  80153a:	eb 05                	jmp    801541 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801541:	c9                   	leave  
  801542:	c3                   	ret    

00801543 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801549:	6a 00                	push   $0x0
  80154b:	6a 00                	push   $0x0
  80154d:	6a 00                	push   $0x0
  80154f:	6a 00                	push   $0x0
  801551:	6a 00                	push   $0x0
  801553:	6a 25                	push   $0x25
  801555:	e8 fc fa ff ff       	call   801056 <syscall>
  80155a:	83 c4 18             	add    $0x18,%esp
  80155d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801560:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801564:	75 07                	jne    80156d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801566:	b8 01 00 00 00       	mov    $0x1,%eax
  80156b:	eb 05                	jmp    801572 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80156d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801577:	6a 00                	push   $0x0
  801579:	6a 00                	push   $0x0
  80157b:	6a 00                	push   $0x0
  80157d:	6a 00                	push   $0x0
  80157f:	ff 75 08             	pushl  0x8(%ebp)
  801582:	6a 26                	push   $0x26
  801584:	e8 cd fa ff ff       	call   801056 <syscall>
  801589:	83 c4 18             	add    $0x18,%esp
	return;
  80158c:	90                   	nop
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  801593:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801596:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801599:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159c:	8b 45 08             	mov    0x8(%ebp),%eax
  80159f:	6a 00                	push   $0x0
  8015a1:	53                   	push   %ebx
  8015a2:	51                   	push   %ecx
  8015a3:	52                   	push   %edx
  8015a4:	50                   	push   %eax
  8015a5:	6a 27                	push   $0x27
  8015a7:	e8 aa fa ff ff       	call   801056 <syscall>
  8015ac:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8015af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015b2:	c9                   	leave  
  8015b3:	c3                   	ret    

008015b4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8015b4:	55                   	push   %ebp
  8015b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8015b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	6a 00                	push   $0x0
  8015bf:	6a 00                	push   $0x0
  8015c1:	6a 00                	push   $0x0
  8015c3:	52                   	push   %edx
  8015c4:	50                   	push   %eax
  8015c5:	6a 28                	push   $0x28
  8015c7:	e8 8a fa ff ff       	call   801056 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8015d4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	6a 00                	push   $0x0
  8015df:	51                   	push   %ecx
  8015e0:	ff 75 10             	pushl  0x10(%ebp)
  8015e3:	52                   	push   %edx
  8015e4:	50                   	push   %eax
  8015e5:	6a 29                	push   $0x29
  8015e7:	e8 6a fa ff ff       	call   801056 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8015f4:	6a 00                	push   $0x0
  8015f6:	6a 00                	push   $0x0
  8015f8:	ff 75 10             	pushl  0x10(%ebp)
  8015fb:	ff 75 0c             	pushl  0xc(%ebp)
  8015fe:	ff 75 08             	pushl  0x8(%ebp)
  801601:	6a 12                	push   $0x12
  801603:	e8 4e fa ff ff       	call   801056 <syscall>
  801608:	83 c4 18             	add    $0x18,%esp
	return;
  80160b:	90                   	nop
}
  80160c:	c9                   	leave  
  80160d:	c3                   	ret    

0080160e <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801611:	8b 55 0c             	mov    0xc(%ebp),%edx
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	52                   	push   %edx
  80161e:	50                   	push   %eax
  80161f:	6a 2a                	push   $0x2a
  801621:	e8 30 fa ff ff       	call   801056 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
	return;
  801629:	90                   	nop
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 00                	push   $0x0
  80163a:	50                   	push   %eax
  80163b:	6a 2b                	push   $0x2b
  80163d:	e8 14 fa ff ff       	call   801056 <syscall>
  801642:	83 c4 18             	add    $0x18,%esp
}
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80164a:	6a 00                	push   $0x0
  80164c:	6a 00                	push   $0x0
  80164e:	6a 00                	push   $0x0
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	ff 75 08             	pushl  0x8(%ebp)
  801656:	6a 2c                	push   $0x2c
  801658:	e8 f9 f9 ff ff       	call   801056 <syscall>
  80165d:	83 c4 18             	add    $0x18,%esp
	return;
  801660:	90                   	nop
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	ff 75 0c             	pushl  0xc(%ebp)
  80166f:	ff 75 08             	pushl  0x8(%ebp)
  801672:	6a 2d                	push   $0x2d
  801674:	e8 dd f9 ff ff       	call   801056 <syscall>
  801679:	83 c4 18             	add    $0x18,%esp
	return;
  80167c:	90                   	nop
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	6a 00                	push   $0x0
  801687:	6a 00                	push   $0x0
  801689:	6a 00                	push   $0x0
  80168b:	6a 00                	push   $0x0
  80168d:	50                   	push   %eax
  80168e:	6a 2f                	push   $0x2f
  801690:	e8 c1 f9 ff ff       	call   801056 <syscall>
  801695:	83 c4 18             	add    $0x18,%esp
	return;
  801698:	90                   	nop
}
  801699:	c9                   	leave  
  80169a:	c3                   	ret    

0080169b <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  80169b:	55                   	push   %ebp
  80169c:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  80169e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a4:	6a 00                	push   $0x0
  8016a6:	6a 00                	push   $0x0
  8016a8:	6a 00                	push   $0x0
  8016aa:	52                   	push   %edx
  8016ab:	50                   	push   %eax
  8016ac:	6a 30                	push   $0x30
  8016ae:	e8 a3 f9 ff ff       	call   801056 <syscall>
  8016b3:	83 c4 18             	add    $0x18,%esp
	return;
  8016b6:	90                   	nop
}
  8016b7:	c9                   	leave  
  8016b8:	c3                   	ret    

008016b9 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	6a 00                	push   $0x0
  8016c1:	6a 00                	push   $0x0
  8016c3:	6a 00                	push   $0x0
  8016c5:	6a 00                	push   $0x0
  8016c7:	50                   	push   %eax
  8016c8:	6a 31                	push   $0x31
  8016ca:	e8 87 f9 ff ff       	call   801056 <syscall>
  8016cf:	83 c4 18             	add    $0x18,%esp
	return;
  8016d2:	90                   	nop
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	6a 00                	push   $0x0
  8016e0:	6a 00                	push   $0x0
  8016e2:	6a 00                	push   $0x0
  8016e4:	52                   	push   %edx
  8016e5:	50                   	push   %eax
  8016e6:	6a 2e                	push   $0x2e
  8016e8:	e8 69 f9 ff ff       	call   801056 <syscall>
  8016ed:	83 c4 18             	add    $0x18,%esp
    return;
  8016f0:	90                   	nop
}
  8016f1:	c9                   	leave  
  8016f2:	c3                   	ret    

008016f3 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8016f3:	55                   	push   %ebp
  8016f4:	89 e5                	mov    %esp,%ebp
  8016f6:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8016f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fc:	89 d0                	mov    %edx,%eax
  8016fe:	c1 e0 02             	shl    $0x2,%eax
  801701:	01 d0                	add    %edx,%eax
  801703:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170a:	01 d0                	add    %edx,%eax
  80170c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801713:	01 d0                	add    %edx,%eax
  801715:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171c:	01 d0                	add    %edx,%eax
  80171e:	c1 e0 04             	shl    $0x4,%eax
  801721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801724:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80172b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80172e:	83 ec 0c             	sub    $0xc,%esp
  801731:	50                   	push   %eax
  801732:	e8 54 fc ff ff       	call   80138b <sys_get_virtual_time>
  801737:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80173a:	eb 41                	jmp    80177d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80173c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80173f:	83 ec 0c             	sub    $0xc,%esp
  801742:	50                   	push   %eax
  801743:	e8 43 fc ff ff       	call   80138b <sys_get_virtual_time>
  801748:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80174b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80174e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801751:	29 c2                	sub    %eax,%edx
  801753:	89 d0                	mov    %edx,%eax
  801755:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801758:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80175b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175e:	89 d1                	mov    %edx,%ecx
  801760:	29 c1                	sub    %eax,%ecx
  801762:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801765:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801768:	39 c2                	cmp    %eax,%edx
  80176a:	0f 97 c0             	seta   %al
  80176d:	0f b6 c0             	movzbl %al,%eax
  801770:	29 c1                	sub    %eax,%ecx
  801772:	89 c8                	mov    %ecx,%eax
  801774:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801777:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80177a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801783:	72 b7                	jb     80173c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801785:	90                   	nop
  801786:	c9                   	leave  
  801787:	c3                   	ret    

00801788 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80178e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801795:	eb 03                	jmp    80179a <busy_wait+0x12>
  801797:	ff 45 fc             	incl   -0x4(%ebp)
  80179a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80179d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8017a0:	72 f5                	jb     801797 <busy_wait+0xf>
	return i;
  8017a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8017ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8017b0:	83 c0 04             	add    $0x4,%eax
  8017b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8017b6:	a1 28 30 80 00       	mov    0x803028,%eax
  8017bb:	85 c0                	test   %eax,%eax
  8017bd:	74 16                	je     8017d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8017bf:	a1 28 30 80 00       	mov    0x803028,%eax
  8017c4:	83 ec 08             	sub    $0x8,%esp
  8017c7:	50                   	push   %eax
  8017c8:	68 d8 20 80 00       	push   $0x8020d8
  8017cd:	e8 ea ea ff ff       	call   8002bc <cprintf>
  8017d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8017d5:	a1 04 30 80 00       	mov    0x803004,%eax
  8017da:	ff 75 0c             	pushl  0xc(%ebp)
  8017dd:	ff 75 08             	pushl  0x8(%ebp)
  8017e0:	50                   	push   %eax
  8017e1:	68 dd 20 80 00       	push   $0x8020dd
  8017e6:	e8 d1 ea ff ff       	call   8002bc <cprintf>
  8017eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8017ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f1:	83 ec 08             	sub    $0x8,%esp
  8017f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f7:	50                   	push   %eax
  8017f8:	e8 54 ea ff ff       	call   800251 <vcprintf>
  8017fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	6a 00                	push   $0x0
  801805:	68 f9 20 80 00       	push   $0x8020f9
  80180a:	e8 42 ea ff ff       	call   800251 <vcprintf>
  80180f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801812:	e8 c3 e9 ff ff       	call   8001da <exit>

	// should not return here
	while (1) ;
  801817:	eb fe                	jmp    801817 <_panic+0x70>

00801819 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80181f:	a1 08 30 80 00       	mov    0x803008,%eax
  801824:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	39 c2                	cmp    %eax,%edx
  80182f:	74 14                	je     801845 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801831:	83 ec 04             	sub    $0x4,%esp
  801834:	68 fc 20 80 00       	push   $0x8020fc
  801839:	6a 26                	push   $0x26
  80183b:	68 48 21 80 00       	push   $0x802148
  801840:	e8 62 ff ff ff       	call   8017a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801845:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80184c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801853:	e9 c5 00 00 00       	jmp    80191d <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	01 d0                	add    %edx,%eax
  801867:	8b 00                	mov    (%eax),%eax
  801869:	85 c0                	test   %eax,%eax
  80186b:	75 08                	jne    801875 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  80186d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801870:	e9 a5 00 00 00       	jmp    80191a <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801875:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80187c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801883:	eb 69                	jmp    8018ee <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801885:	a1 08 30 80 00       	mov    0x803008,%eax
  80188a:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801890:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801893:	89 d0                	mov    %edx,%eax
  801895:	01 c0                	add    %eax,%eax
  801897:	01 d0                	add    %edx,%eax
  801899:	c1 e0 03             	shl    $0x3,%eax
  80189c:	01 c8                	add    %ecx,%eax
  80189e:	8a 40 04             	mov    0x4(%eax),%al
  8018a1:	84 c0                	test   %al,%al
  8018a3:	75 46                	jne    8018eb <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018a5:	a1 08 30 80 00       	mov    0x803008,%eax
  8018aa:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8018b0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8018b3:	89 d0                	mov    %edx,%eax
  8018b5:	01 c0                	add    %eax,%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	c1 e0 03             	shl    $0x3,%eax
  8018bc:	01 c8                	add    %ecx,%eax
  8018be:	8b 00                	mov    (%eax),%eax
  8018c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8018c3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018cb:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8018cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d0:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8018d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018da:	01 c8                	add    %ecx,%eax
  8018dc:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8018de:	39 c2                	cmp    %eax,%edx
  8018e0:	75 09                	jne    8018eb <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  8018e2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8018e9:	eb 15                	jmp    801900 <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018eb:	ff 45 e8             	incl   -0x18(%ebp)
  8018ee:	a1 08 30 80 00       	mov    0x803008,%eax
  8018f3:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8018f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018fc:	39 c2                	cmp    %eax,%edx
  8018fe:	77 85                	ja     801885 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801900:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801904:	75 14                	jne    80191a <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 54 21 80 00       	push   $0x802154
  80190e:	6a 3a                	push   $0x3a
  801910:	68 48 21 80 00       	push   $0x802148
  801915:	e8 8d fe ff ff       	call   8017a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80191a:	ff 45 f0             	incl   -0x10(%ebp)
  80191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801920:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801923:	0f 8c 2f ff ff ff    	jl     801858 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801929:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801930:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801937:	eb 26                	jmp    80195f <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801939:	a1 08 30 80 00       	mov    0x803008,%eax
  80193e:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801944:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801947:	89 d0                	mov    %edx,%eax
  801949:	01 c0                	add    %eax,%eax
  80194b:	01 d0                	add    %edx,%eax
  80194d:	c1 e0 03             	shl    $0x3,%eax
  801950:	01 c8                	add    %ecx,%eax
  801952:	8a 40 04             	mov    0x4(%eax),%al
  801955:	3c 01                	cmp    $0x1,%al
  801957:	75 03                	jne    80195c <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801959:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80195c:	ff 45 e0             	incl   -0x20(%ebp)
  80195f:	a1 08 30 80 00       	mov    0x803008,%eax
  801964:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  80196a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80196d:	39 c2                	cmp    %eax,%edx
  80196f:	77 c8                	ja     801939 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801971:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801974:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801977:	74 14                	je     80198d <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801979:	83 ec 04             	sub    $0x4,%esp
  80197c:	68 a8 21 80 00       	push   $0x8021a8
  801981:	6a 44                	push   $0x44
  801983:	68 48 21 80 00       	push   $0x802148
  801988:	e8 1a fe ff ff       	call   8017a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80198d:	90                   	nop
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <__udivdi3>:
  801990:	55                   	push   %ebp
  801991:	57                   	push   %edi
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	83 ec 1c             	sub    $0x1c,%esp
  801997:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80199b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80199f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8019a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019a7:	89 ca                	mov    %ecx,%edx
  8019a9:	89 f8                	mov    %edi,%eax
  8019ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8019af:	85 f6                	test   %esi,%esi
  8019b1:	75 2d                	jne    8019e0 <__udivdi3+0x50>
  8019b3:	39 cf                	cmp    %ecx,%edi
  8019b5:	77 65                	ja     801a1c <__udivdi3+0x8c>
  8019b7:	89 fd                	mov    %edi,%ebp
  8019b9:	85 ff                	test   %edi,%edi
  8019bb:	75 0b                	jne    8019c8 <__udivdi3+0x38>
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8019c2:	31 d2                	xor    %edx,%edx
  8019c4:	f7 f7                	div    %edi
  8019c6:	89 c5                	mov    %eax,%ebp
  8019c8:	31 d2                	xor    %edx,%edx
  8019ca:	89 c8                	mov    %ecx,%eax
  8019cc:	f7 f5                	div    %ebp
  8019ce:	89 c1                	mov    %eax,%ecx
  8019d0:	89 d8                	mov    %ebx,%eax
  8019d2:	f7 f5                	div    %ebp
  8019d4:	89 cf                	mov    %ecx,%edi
  8019d6:	89 fa                	mov    %edi,%edx
  8019d8:	83 c4 1c             	add    $0x1c,%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5f                   	pop    %edi
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    
  8019e0:	39 ce                	cmp    %ecx,%esi
  8019e2:	77 28                	ja     801a0c <__udivdi3+0x7c>
  8019e4:	0f bd fe             	bsr    %esi,%edi
  8019e7:	83 f7 1f             	xor    $0x1f,%edi
  8019ea:	75 40                	jne    801a2c <__udivdi3+0x9c>
  8019ec:	39 ce                	cmp    %ecx,%esi
  8019ee:	72 0a                	jb     8019fa <__udivdi3+0x6a>
  8019f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8019f4:	0f 87 9e 00 00 00    	ja     801a98 <__udivdi3+0x108>
  8019fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ff:	89 fa                	mov    %edi,%edx
  801a01:	83 c4 1c             	add    $0x1c,%esp
  801a04:	5b                   	pop    %ebx
  801a05:	5e                   	pop    %esi
  801a06:	5f                   	pop    %edi
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    
  801a09:	8d 76 00             	lea    0x0(%esi),%esi
  801a0c:	31 ff                	xor    %edi,%edi
  801a0e:	31 c0                	xor    %eax,%eax
  801a10:	89 fa                	mov    %edi,%edx
  801a12:	83 c4 1c             	add    $0x1c,%esp
  801a15:	5b                   	pop    %ebx
  801a16:	5e                   	pop    %esi
  801a17:	5f                   	pop    %edi
  801a18:	5d                   	pop    %ebp
  801a19:	c3                   	ret    
  801a1a:	66 90                	xchg   %ax,%ax
  801a1c:	89 d8                	mov    %ebx,%eax
  801a1e:	f7 f7                	div    %edi
  801a20:	31 ff                	xor    %edi,%edi
  801a22:	89 fa                	mov    %edi,%edx
  801a24:	83 c4 1c             	add    $0x1c,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    
  801a2c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801a31:	89 eb                	mov    %ebp,%ebx
  801a33:	29 fb                	sub    %edi,%ebx
  801a35:	89 f9                	mov    %edi,%ecx
  801a37:	d3 e6                	shl    %cl,%esi
  801a39:	89 c5                	mov    %eax,%ebp
  801a3b:	88 d9                	mov    %bl,%cl
  801a3d:	d3 ed                	shr    %cl,%ebp
  801a3f:	89 e9                	mov    %ebp,%ecx
  801a41:	09 f1                	or     %esi,%ecx
  801a43:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801a47:	89 f9                	mov    %edi,%ecx
  801a49:	d3 e0                	shl    %cl,%eax
  801a4b:	89 c5                	mov    %eax,%ebp
  801a4d:	89 d6                	mov    %edx,%esi
  801a4f:	88 d9                	mov    %bl,%cl
  801a51:	d3 ee                	shr    %cl,%esi
  801a53:	89 f9                	mov    %edi,%ecx
  801a55:	d3 e2                	shl    %cl,%edx
  801a57:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a5b:	88 d9                	mov    %bl,%cl
  801a5d:	d3 e8                	shr    %cl,%eax
  801a5f:	09 c2                	or     %eax,%edx
  801a61:	89 d0                	mov    %edx,%eax
  801a63:	89 f2                	mov    %esi,%edx
  801a65:	f7 74 24 0c          	divl   0xc(%esp)
  801a69:	89 d6                	mov    %edx,%esi
  801a6b:	89 c3                	mov    %eax,%ebx
  801a6d:	f7 e5                	mul    %ebp
  801a6f:	39 d6                	cmp    %edx,%esi
  801a71:	72 19                	jb     801a8c <__udivdi3+0xfc>
  801a73:	74 0b                	je     801a80 <__udivdi3+0xf0>
  801a75:	89 d8                	mov    %ebx,%eax
  801a77:	31 ff                	xor    %edi,%edi
  801a79:	e9 58 ff ff ff       	jmp    8019d6 <__udivdi3+0x46>
  801a7e:	66 90                	xchg   %ax,%ax
  801a80:	8b 54 24 08          	mov    0x8(%esp),%edx
  801a84:	89 f9                	mov    %edi,%ecx
  801a86:	d3 e2                	shl    %cl,%edx
  801a88:	39 c2                	cmp    %eax,%edx
  801a8a:	73 e9                	jae    801a75 <__udivdi3+0xe5>
  801a8c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801a8f:	31 ff                	xor    %edi,%edi
  801a91:	e9 40 ff ff ff       	jmp    8019d6 <__udivdi3+0x46>
  801a96:	66 90                	xchg   %ax,%ax
  801a98:	31 c0                	xor    %eax,%eax
  801a9a:	e9 37 ff ff ff       	jmp    8019d6 <__udivdi3+0x46>
  801a9f:	90                   	nop

00801aa0 <__umoddi3>:
  801aa0:	55                   	push   %ebp
  801aa1:	57                   	push   %edi
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 1c             	sub    $0x1c,%esp
  801aa7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801aab:	8b 74 24 34          	mov    0x34(%esp),%esi
  801aaf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ab3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ab7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801abb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801abf:	89 f3                	mov    %esi,%ebx
  801ac1:	89 fa                	mov    %edi,%edx
  801ac3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ac7:	89 34 24             	mov    %esi,(%esp)
  801aca:	85 c0                	test   %eax,%eax
  801acc:	75 1a                	jne    801ae8 <__umoddi3+0x48>
  801ace:	39 f7                	cmp    %esi,%edi
  801ad0:	0f 86 a2 00 00 00    	jbe    801b78 <__umoddi3+0xd8>
  801ad6:	89 c8                	mov    %ecx,%eax
  801ad8:	89 f2                	mov    %esi,%edx
  801ada:	f7 f7                	div    %edi
  801adc:	89 d0                	mov    %edx,%eax
  801ade:	31 d2                	xor    %edx,%edx
  801ae0:	83 c4 1c             	add    $0x1c,%esp
  801ae3:	5b                   	pop    %ebx
  801ae4:	5e                   	pop    %esi
  801ae5:	5f                   	pop    %edi
  801ae6:	5d                   	pop    %ebp
  801ae7:	c3                   	ret    
  801ae8:	39 f0                	cmp    %esi,%eax
  801aea:	0f 87 ac 00 00 00    	ja     801b9c <__umoddi3+0xfc>
  801af0:	0f bd e8             	bsr    %eax,%ebp
  801af3:	83 f5 1f             	xor    $0x1f,%ebp
  801af6:	0f 84 ac 00 00 00    	je     801ba8 <__umoddi3+0x108>
  801afc:	bf 20 00 00 00       	mov    $0x20,%edi
  801b01:	29 ef                	sub    %ebp,%edi
  801b03:	89 fe                	mov    %edi,%esi
  801b05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801b09:	89 e9                	mov    %ebp,%ecx
  801b0b:	d3 e0                	shl    %cl,%eax
  801b0d:	89 d7                	mov    %edx,%edi
  801b0f:	89 f1                	mov    %esi,%ecx
  801b11:	d3 ef                	shr    %cl,%edi
  801b13:	09 c7                	or     %eax,%edi
  801b15:	89 e9                	mov    %ebp,%ecx
  801b17:	d3 e2                	shl    %cl,%edx
  801b19:	89 14 24             	mov    %edx,(%esp)
  801b1c:	89 d8                	mov    %ebx,%eax
  801b1e:	d3 e0                	shl    %cl,%eax
  801b20:	89 c2                	mov    %eax,%edx
  801b22:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b26:	d3 e0                	shl    %cl,%eax
  801b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801b30:	89 f1                	mov    %esi,%ecx
  801b32:	d3 e8                	shr    %cl,%eax
  801b34:	09 d0                	or     %edx,%eax
  801b36:	d3 eb                	shr    %cl,%ebx
  801b38:	89 da                	mov    %ebx,%edx
  801b3a:	f7 f7                	div    %edi
  801b3c:	89 d3                	mov    %edx,%ebx
  801b3e:	f7 24 24             	mull   (%esp)
  801b41:	89 c6                	mov    %eax,%esi
  801b43:	89 d1                	mov    %edx,%ecx
  801b45:	39 d3                	cmp    %edx,%ebx
  801b47:	0f 82 87 00 00 00    	jb     801bd4 <__umoddi3+0x134>
  801b4d:	0f 84 91 00 00 00    	je     801be4 <__umoddi3+0x144>
  801b53:	8b 54 24 04          	mov    0x4(%esp),%edx
  801b57:	29 f2                	sub    %esi,%edx
  801b59:	19 cb                	sbb    %ecx,%ebx
  801b5b:	89 d8                	mov    %ebx,%eax
  801b5d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801b61:	d3 e0                	shl    %cl,%eax
  801b63:	89 e9                	mov    %ebp,%ecx
  801b65:	d3 ea                	shr    %cl,%edx
  801b67:	09 d0                	or     %edx,%eax
  801b69:	89 e9                	mov    %ebp,%ecx
  801b6b:	d3 eb                	shr    %cl,%ebx
  801b6d:	89 da                	mov    %ebx,%edx
  801b6f:	83 c4 1c             	add    $0x1c,%esp
  801b72:	5b                   	pop    %ebx
  801b73:	5e                   	pop    %esi
  801b74:	5f                   	pop    %edi
  801b75:	5d                   	pop    %ebp
  801b76:	c3                   	ret    
  801b77:	90                   	nop
  801b78:	89 fd                	mov    %edi,%ebp
  801b7a:	85 ff                	test   %edi,%edi
  801b7c:	75 0b                	jne    801b89 <__umoddi3+0xe9>
  801b7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b83:	31 d2                	xor    %edx,%edx
  801b85:	f7 f7                	div    %edi
  801b87:	89 c5                	mov    %eax,%ebp
  801b89:	89 f0                	mov    %esi,%eax
  801b8b:	31 d2                	xor    %edx,%edx
  801b8d:	f7 f5                	div    %ebp
  801b8f:	89 c8                	mov    %ecx,%eax
  801b91:	f7 f5                	div    %ebp
  801b93:	89 d0                	mov    %edx,%eax
  801b95:	e9 44 ff ff ff       	jmp    801ade <__umoddi3+0x3e>
  801b9a:	66 90                	xchg   %ax,%ax
  801b9c:	89 c8                	mov    %ecx,%eax
  801b9e:	89 f2                	mov    %esi,%edx
  801ba0:	83 c4 1c             	add    $0x1c,%esp
  801ba3:	5b                   	pop    %ebx
  801ba4:	5e                   	pop    %esi
  801ba5:	5f                   	pop    %edi
  801ba6:	5d                   	pop    %ebp
  801ba7:	c3                   	ret    
  801ba8:	3b 04 24             	cmp    (%esp),%eax
  801bab:	72 06                	jb     801bb3 <__umoddi3+0x113>
  801bad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801bb1:	77 0f                	ja     801bc2 <__umoddi3+0x122>
  801bb3:	89 f2                	mov    %esi,%edx
  801bb5:	29 f9                	sub    %edi,%ecx
  801bb7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801bbb:	89 14 24             	mov    %edx,(%esp)
  801bbe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801bc2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801bc6:	8b 14 24             	mov    (%esp),%edx
  801bc9:	83 c4 1c             	add    $0x1c,%esp
  801bcc:	5b                   	pop    %ebx
  801bcd:	5e                   	pop    %esi
  801bce:	5f                   	pop    %edi
  801bcf:	5d                   	pop    %ebp
  801bd0:	c3                   	ret    
  801bd1:	8d 76 00             	lea    0x0(%esi),%esi
  801bd4:	2b 04 24             	sub    (%esp),%eax
  801bd7:	19 fa                	sbb    %edi,%edx
  801bd9:	89 d1                	mov    %edx,%ecx
  801bdb:	89 c6                	mov    %eax,%esi
  801bdd:	e9 71 ff ff ff       	jmp    801b53 <__umoddi3+0xb3>
  801be2:	66 90                	xchg   %ax,%ax
  801be4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801be8:	72 ea                	jb     801bd4 <__umoddi3+0x134>
  801bea:	89 d9                	mov    %ebx,%ecx
  801bec:	e9 62 ff ff ff       	jmp    801b53 <__umoddi3+0xb3>
