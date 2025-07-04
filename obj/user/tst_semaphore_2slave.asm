
obj/user/tst_semaphore_2slave:     file format elf32-i386


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

#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	int id = sys_getenvindex();
  80003e:	e8 38 13 00 00       	call   80137b <sys_getenvindex>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	int32 parentenvID = sys_getparentenvid();
  800046:	e8 49 13 00 00       	call   801394 <sys_getparentenvid>
  80004b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//cprintf("Cust %d: outside the shop\n", id);
	struct semaphore shopCapacitySem = get_semaphore(parentenvID, "shopCapacity");
  80004e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800051:	83 ec 04             	sub    $0x4,%esp
  800054:	68 40 37 80 00       	push   $0x803740
  800059:	ff 75 f0             	pushl  -0x10(%ebp)
  80005c:	50                   	push   %eax
  80005d:	e8 50 17 00 00       	call   8017b2 <get_semaphore>
  800062:	83 c4 0c             	add    $0xc,%esp
	struct semaphore dependSem = get_semaphore(parentenvID, "depend");
  800065:	8d 45 e8             	lea    -0x18(%ebp),%eax
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	68 4d 37 80 00       	push   $0x80374d
  800070:	ff 75 f0             	pushl  -0x10(%ebp)
  800073:	50                   	push   %eax
  800074:	e8 39 17 00 00       	call   8017b2 <get_semaphore>
  800079:	83 c4 0c             	add    $0xc,%esp

	wait_semaphore(shopCapacitySem);
  80007c:	83 ec 0c             	sub    $0xc,%esp
  80007f:	ff 75 ec             	pushl  -0x14(%ebp)
  800082:	e8 74 17 00 00       	call   8017fb <wait_semaphore>
  800087:	83 c4 10             	add    $0x10,%esp
	{
		cprintf("Cust %d: inside the shop\n", id) ;
  80008a:	83 ec 08             	sub    $0x8,%esp
  80008d:	ff 75 f4             	pushl  -0xc(%ebp)
  800090:	68 54 37 80 00       	push   $0x803754
  800095:	e8 5e 02 00 00       	call   8002f8 <cprintf>
  80009a:	83 c4 10             	add    $0x10,%esp
		env_sleep(1000) ;
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	68 e8 03 00 00       	push   $0x3e8
  8000a5:	e8 28 18 00 00       	call   8018d2 <env_sleep>
  8000aa:	83 c4 10             	add    $0x10,%esp
	}
	signal_semaphore(shopCapacitySem);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	ff 75 ec             	pushl  -0x14(%ebp)
  8000b3:	e8 ad 17 00 00       	call   801865 <signal_semaphore>
  8000b8:	83 c4 10             	add    $0x10,%esp

	cprintf("Cust %d: exit the shop\n", id);
  8000bb:	83 ec 08             	sub    $0x8,%esp
  8000be:	ff 75 f4             	pushl  -0xc(%ebp)
  8000c1:	68 6e 37 80 00       	push   $0x80376e
  8000c6:	e8 2d 02 00 00       	call   8002f8 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp
	signal_semaphore(dependSem);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d4:	e8 8c 17 00 00       	call   801865 <signal_semaphore>
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
  80010d:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800112:	a1 20 40 80 00       	mov    0x804020,%eax
  800117:	8a 40 20             	mov    0x20(%eax),%al
  80011a:	84 c0                	test   %al,%al
  80011c:	74 0d                	je     80012b <libmain+0x4c>
		binaryname = myEnv->prog_name;
  80011e:	a1 20 40 80 00       	mov    0x804020,%eax
  800123:	83 c0 20             	add    $0x20,%eax
  800126:	a3 04 40 80 00       	mov    %eax,0x804004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80012f:	7e 0a                	jle    80013b <libmain+0x5c>
		binaryname = argv[0];
  800131:	8b 45 0c             	mov    0xc(%ebp),%eax
  800134:	8b 00                	mov    (%eax),%eax
  800136:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	_main(argc, argv);
  80013b:	83 ec 08             	sub    $0x8,%esp
  80013e:	ff 75 0c             	pushl  0xc(%ebp)
  800141:	ff 75 08             	pushl  0x8(%ebp)
  800144:	e8 ef fe ff ff       	call   800038 <_main>
  800149:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  80014c:	a1 00 40 80 00       	mov    0x804000,%eax
  800151:	85 c0                	test   %eax,%eax
  800153:	0f 84 9f 00 00 00    	je     8001f8 <libmain+0x119>
	{
		sys_lock_cons();
  800159:	e8 a1 0f 00 00       	call   8010ff <sys_lock_cons>
		{
			cprintf("**************************************\n");
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	68 a0 37 80 00       	push   $0x8037a0
  800166:	e8 8d 01 00 00       	call   8002f8 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80016e:	a1 20 40 80 00       	mov    0x804020,%eax
  800173:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  800179:	a1 20 40 80 00       	mov    0x804020,%eax
  80017e:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	52                   	push   %edx
  800188:	50                   	push   %eax
  800189:	68 c8 37 80 00       	push   $0x8037c8
  80018e:	e8 65 01 00 00       	call   8002f8 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800196:	a1 20 40 80 00       	mov    0x804020,%eax
  80019b:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  8001a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a6:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  8001b7:	51                   	push   %ecx
  8001b8:	52                   	push   %edx
  8001b9:	50                   	push   %eax
  8001ba:	68 f0 37 80 00       	push   $0x8037f0
  8001bf:	e8 34 01 00 00       	call   8002f8 <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001d2:	83 ec 08             	sub    $0x8,%esp
  8001d5:	50                   	push   %eax
  8001d6:	68 48 38 80 00       	push   $0x803848
  8001db:	e8 18 01 00 00       	call   8002f8 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001e3:	83 ec 0c             	sub    $0xc,%esp
  8001e6:	68 a0 37 80 00       	push   $0x8037a0
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
  80024f:	a0 44 40 98 00       	mov    0x984044,%al
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
  8002c4:	a0 44 40 98 00       	mov    0x984044,%al
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
  8002e9:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
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
  8002fe:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
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
  800395:	e8 32 31 00 00       	call   8034cc <__udivdi3>
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
  8003e5:	e8 f2 31 00 00       	call   8035dc <__umoddi3>
  8003ea:	83 c4 10             	add    $0x10,%esp
  8003ed:	05 74 3a 80 00       	add    $0x803a74,%eax
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
  800540:	8b 04 85 98 3a 80 00 	mov    0x803a98(,%eax,4),%eax
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
  800621:	8b 34 9d e0 38 80 00 	mov    0x8038e0(,%ebx,4),%esi
  800628:	85 f6                	test   %esi,%esi
  80062a:	75 19                	jne    800645 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80062c:	53                   	push   %ebx
  80062d:	68 85 3a 80 00       	push   $0x803a85
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
  800646:	68 8e 3a 80 00       	push   $0x803a8e
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
  800673:	be 91 3a 80 00       	mov    $0x803a91,%esi
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
  80086b:	c6 05 44 40 98 00 00 	movb   $0x0,0x984044
			break;
  800872:	eb 2c                	jmp    8008a0 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800874:	c6 05 44 40 98 00 01 	movb   $0x1,0x984044
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
  80107e:	68 08 3c 80 00       	push   $0x803c08
  801083:	68 3f 01 00 00       	push   $0x13f
  801088:	68 2a 3c 80 00       	push   $0x803c2a
  80108d:	e8 f4 08 00 00       	call   801986 <_panic>

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

0080172f <create_semaphore>:
// User-level Semaphore

#include "inc/lib.h"

struct semaphore create_semaphore(char *semaphoreName, uint32 value)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("create_semaphore is not implemented yet");
	//Your Code is Here...

	//create object of __semdata struct and allocate it using smalloc with sizeof __semdata struct
	struct __semdata* semaphoryData = (struct __semdata *)smalloc(semaphoreName , sizeof(struct __semdata) ,1);
  801735:	83 ec 04             	sub    $0x4,%esp
  801738:	6a 01                	push   $0x1
  80173a:	6a 58                	push   $0x58
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	e8 f8 06 00 00       	call   801e3c <smalloc>
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  80174a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80174e:	75 14                	jne    801764 <create_semaphore+0x35>
	{
		panic("Not Enough Space to allocate semdata object!!");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 38 3c 80 00       	push   $0x803c38
  801758:	6a 10                	push   $0x10
  80175a:	68 66 3c 80 00       	push   $0x803c66
  80175f:	e8 22 02 00 00       	call   801986 <_panic>
	}
	//aboveObject.queue pass it to init_queue() function
	sys_init_queue(&(semaphoryData->queue));
  801764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	50                   	push   %eax
  80176b:	e8 4b ff ff ff       	call   8016bb <sys_init_queue>
  801770:	83 c4 10             	add    $0x10,%esp
	//lock variable initially with zero
	semaphoryData->lock = 0;
  801773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801776:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
	//initialize aboveObject with semaphore name and value
	strncpy(semaphoryData->name , semaphoreName , sizeof(semaphoryData->name));
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	83 c0 18             	add    $0x18,%eax
  801783:	83 ec 04             	sub    $0x4,%esp
  801786:	6a 40                	push   $0x40
  801788:	ff 75 0c             	pushl  0xc(%ebp)
  80178b:	50                   	push   %eax
  80178c:	e8 78 f2 ff ff       	call   800a09 <strncpy>
  801791:	83 c4 10             	add    $0x10,%esp
	semaphoryData->count = value;
  801794:	8b 55 10             	mov    0x10(%ebp),%edx
  801797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179a:	89 50 10             	mov    %edx,0x10(%eax)

	//create object of semaphore struct
	struct semaphore semaphory;
	//add aboveObject to this semaphore object
	semaphory.semdata = semaphoryData;
  80179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	//return semaphore object
	return semaphory;
  8017a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a9:	89 10                	mov    %edx,(%eax)
}
  8017ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ae:	c9                   	leave  
  8017af:	c2 04 00             	ret    $0x4

008017b2 <get_semaphore>:
struct semaphore get_semaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("get_semaphore is not implemented yet");
	//Your Code is Here...

	// get the semdata object that is allocated, using sget
	struct __semdata* semaphoryData = sget(ownerEnvID, semaphoreName);
  8017b8:	83 ec 08             	sub    $0x8,%esp
  8017bb:	ff 75 10             	pushl  0x10(%ebp)
  8017be:	ff 75 0c             	pushl  0xc(%ebp)
  8017c1:	e8 11 08 00 00       	call   801fd7 <sget>
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(semaphoryData == NULL)
  8017cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017d0:	75 14                	jne    8017e6 <get_semaphore+0x34>
	{
		panic("semdatat object does not exist!!");
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	68 78 3c 80 00       	push   $0x803c78
  8017da:	6a 2c                	push   $0x2c
  8017dc:	68 66 3c 80 00       	push   $0x803c66
  8017e1:	e8 a0 01 00 00       	call   801986 <_panic>
	}
	//create object of semaphore struct
	struct semaphore semaphory;
	//add semdata object to this semaphore object
	semaphory.semdata = semaphoryData;
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	return semaphory;
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f2:	89 10                	mov    %edx,(%eax)
}
  8017f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f7:	c9                   	leave  
  8017f8:	c2 04 00             	ret    $0x4

008017fb <wait_semaphore>:

void wait_semaphore(struct semaphore sem)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("wait_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  801801:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	8b 40 14             	mov    0x14(%eax),%eax
  80180e:	8d 55 e8             	lea    -0x18(%ebp),%edx
  801811:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801814:	89 45 f0             	mov    %eax,-0x10(%ebp)
xchg(volatile uint32 *addr, uint32 newval)
{
  uint32 result;

  // The + in "+m" denotes a read-modify-write operand.
  __asm __volatile("lock; xchgl %0, %1" :
  801817:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80181a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801820:	f0 87 02             	lock xchg %eax,(%edx)
  801823:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801829:	85 c0                	test   %eax,%eax
  80182b:	75 db                	jne    801808 <wait_semaphore+0xd>

	//decrement the semaphore counter
	sem.semdata->count--;
  80182d:	8b 45 08             	mov    0x8(%ebp),%eax
  801830:	8b 50 10             	mov    0x10(%eax),%edx
  801833:	4a                   	dec    %edx
  801834:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count < 0)
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	8b 40 10             	mov    0x10(%eax),%eax
  80183d:	85 c0                	test   %eax,%eax
  80183f:	79 18                	jns    801859 <wait_semaphore+0x5e>
	{
		// block the current process
		sys_block_process(&(sem.semdata->queue),&(sem.semdata->lock));
  801841:	8b 45 08             	mov    0x8(%ebp),%eax
  801844:	8d 50 14             	lea    0x14(%eax),%edx
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	83 ec 08             	sub    $0x8,%esp
  80184d:	52                   	push   %edx
  80184e:	50                   	push   %eax
  80184f:	e8 83 fe ff ff       	call   8016d7 <sys_block_process>
  801854:	83 c4 10             	add    $0x10,%esp
  801857:	eb 0a                	jmp    801863 <wait_semaphore+0x68>
		return;
	}
	//release semaphore lock
	sem.semdata->lock = 0;
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <signal_semaphore>:

void signal_semaphore(struct semaphore sem)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	83 ec 18             	sub    $0x18,%esp
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("signal_semaphore is not implemented yet");
	//Your Code is Here...

	//acquire semaphore lock
	uint32 myKey = 1;
  80186b:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
	do
	{
		xchg(&myKey, sem.semdata->lock); // xchg atomically exchanges values
  801872:	8b 45 08             	mov    0x8(%ebp),%eax
  801875:	8b 40 14             	mov    0x14(%eax),%eax
  801878:	8d 55 e8             	lea    -0x18(%ebp),%edx
  80187b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80187e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801884:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801887:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80188a:	f0 87 02             	lock xchg %eax,(%edx)
  80188d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	} while (myKey != 0);
  801890:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801893:	85 c0                	test   %eax,%eax
  801895:	75 db                	jne    801872 <signal_semaphore+0xd>

	// increment the semaphore counter
	sem.semdata->count++;
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8b 50 10             	mov    0x10(%eax),%edx
  80189d:	42                   	inc    %edx
  80189e:	89 50 10             	mov    %edx,0x10(%eax)

	if (sem.semdata->count <= 0) {
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	8b 40 10             	mov    0x10(%eax),%eax
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	7f 0f                	jg     8018ba <signal_semaphore+0x55>
		// unblock the current process
		sys_unblock_process(&(sem.semdata->queue));
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	83 ec 0c             	sub    $0xc,%esp
  8018b1:	50                   	push   %eax
  8018b2:	e8 3e fe ff ff       	call   8016f5 <sys_unblock_process>
  8018b7:	83 c4 10             	add    $0x10,%esp
	}

	// release the lock
	sem.semdata->lock = 0;
  8018ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bd:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
}
  8018c4:	90                   	nop
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <semaphore_count>:

int semaphore_count(struct semaphore sem)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return sem.semdata->count;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8b 40 10             	mov    0x10(%eax),%eax
}
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    

008018d2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8018d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018db:	89 d0                	mov    %edx,%eax
  8018dd:	c1 e0 02             	shl    $0x2,%eax
  8018e0:	01 d0                	add    %edx,%eax
  8018e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018e9:	01 d0                	add    %edx,%eax
  8018eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f2:	01 d0                	add    %edx,%eax
  8018f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018fb:	01 d0                	add    %edx,%eax
  8018fd:	c1 e0 04             	shl    $0x4,%eax
  801900:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801903:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80190a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80190d:	83 ec 0c             	sub    $0xc,%esp
  801910:	50                   	push   %eax
  801911:	e8 b1 fa ff ff       	call   8013c7 <sys_get_virtual_time>
  801916:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801919:	eb 41                	jmp    80195c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80191b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80191e:	83 ec 0c             	sub    $0xc,%esp
  801921:	50                   	push   %eax
  801922:	e8 a0 fa ff ff       	call   8013c7 <sys_get_virtual_time>
  801927:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80192a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80192d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801930:	29 c2                	sub    %eax,%edx
  801932:	89 d0                	mov    %edx,%eax
  801934:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801937:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80193a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80193d:	89 d1                	mov    %edx,%ecx
  80193f:	29 c1                	sub    %eax,%ecx
  801941:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801947:	39 c2                	cmp    %eax,%edx
  801949:	0f 97 c0             	seta   %al
  80194c:	0f b6 c0             	movzbl %al,%eax
  80194f:	29 c1                	sub    %eax,%ecx
  801951:	89 c8                	mov    %ecx,%eax
  801953:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801956:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801959:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80195c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801962:	72 b7                	jb     80191b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801964:	90                   	nop
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
  80196a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80196d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801974:	eb 03                	jmp    801979 <busy_wait+0x12>
  801976:	ff 45 fc             	incl   -0x4(%ebp)
  801979:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80197c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80197f:	72 f5                	jb     801976 <busy_wait+0xf>
	return i;
  801981:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80198c:	8d 45 10             	lea    0x10(%ebp),%eax
  80198f:	83 c0 04             	add    $0x4,%eax
  801992:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801995:	a1 60 40 98 00       	mov    0x984060,%eax
  80199a:	85 c0                	test   %eax,%eax
  80199c:	74 16                	je     8019b4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80199e:	a1 60 40 98 00       	mov    0x984060,%eax
  8019a3:	83 ec 08             	sub    $0x8,%esp
  8019a6:	50                   	push   %eax
  8019a7:	68 9c 3c 80 00       	push   $0x803c9c
  8019ac:	e8 47 e9 ff ff       	call   8002f8 <cprintf>
  8019b1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8019b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	50                   	push   %eax
  8019c0:	68 a1 3c 80 00       	push   $0x803ca1
  8019c5:	e8 2e e9 ff ff       	call   8002f8 <cprintf>
  8019ca:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8019cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d0:	83 ec 08             	sub    $0x8,%esp
  8019d3:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d6:	50                   	push   %eax
  8019d7:	e8 b1 e8 ff ff       	call   80028d <vcprintf>
  8019dc:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8019df:	83 ec 08             	sub    $0x8,%esp
  8019e2:	6a 00                	push   $0x0
  8019e4:	68 bd 3c 80 00       	push   $0x803cbd
  8019e9:	e8 9f e8 ff ff       	call   80028d <vcprintf>
  8019ee:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8019f1:	e8 20 e8 ff ff       	call   800216 <exit>

	// should not return here
	while (1) ;
  8019f6:	eb fe                	jmp    8019f6 <_panic+0x70>

008019f8 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8019fe:	a1 20 40 80 00       	mov    0x804020,%eax
  801a03:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0c:	39 c2                	cmp    %eax,%edx
  801a0e:	74 14                	je     801a24 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801a10:	83 ec 04             	sub    $0x4,%esp
  801a13:	68 c0 3c 80 00       	push   $0x803cc0
  801a18:	6a 26                	push   $0x26
  801a1a:	68 0c 3d 80 00       	push   $0x803d0c
  801a1f:	e8 62 ff ff ff       	call   801986 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  801a24:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801a2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801a32:	e9 c5 00 00 00       	jmp    801afc <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a41:	8b 45 08             	mov    0x8(%ebp),%eax
  801a44:	01 d0                	add    %edx,%eax
  801a46:	8b 00                	mov    (%eax),%eax
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	75 08                	jne    801a54 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  801a4c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801a4f:	e9 a5 00 00 00       	jmp    801af9 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  801a54:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801a5b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a62:	eb 69                	jmp    801acd <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801a64:	a1 20 40 80 00       	mov    0x804020,%eax
  801a69:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a6f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a72:	89 d0                	mov    %edx,%eax
  801a74:	01 c0                	add    %eax,%eax
  801a76:	01 d0                	add    %edx,%eax
  801a78:	c1 e0 03             	shl    $0x3,%eax
  801a7b:	01 c8                	add    %ecx,%eax
  801a7d:	8a 40 04             	mov    0x4(%eax),%al
  801a80:	84 c0                	test   %al,%al
  801a82:	75 46                	jne    801aca <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801a84:	a1 20 40 80 00       	mov    0x804020,%eax
  801a89:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801a8f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a92:	89 d0                	mov    %edx,%eax
  801a94:	01 c0                	add    %eax,%eax
  801a96:	01 d0                	add    %edx,%eax
  801a98:	c1 e0 03             	shl    $0x3,%eax
  801a9b:	01 c8                	add    %ecx,%eax
  801a9d:	8b 00                	mov    (%eax),%eax
  801a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801aa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aaa:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	01 c8                	add    %ecx,%eax
  801abb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801abd:	39 c2                	cmp    %eax,%edx
  801abf:	75 09                	jne    801aca <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  801ac1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801ac8:	eb 15                	jmp    801adf <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801aca:	ff 45 e8             	incl   -0x18(%ebp)
  801acd:	a1 20 40 80 00       	mov    0x804020,%eax
  801ad2:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801ad8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801adb:	39 c2                	cmp    %eax,%edx
  801add:	77 85                	ja     801a64 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801adf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ae3:	75 14                	jne    801af9 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801ae5:	83 ec 04             	sub    $0x4,%esp
  801ae8:	68 18 3d 80 00       	push   $0x803d18
  801aed:	6a 3a                	push   $0x3a
  801aef:	68 0c 3d 80 00       	push   $0x803d0c
  801af4:	e8 8d fe ff ff       	call   801986 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801af9:	ff 45 f0             	incl   -0x10(%ebp)
  801afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aff:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801b02:	0f 8c 2f ff ff ff    	jl     801a37 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801b08:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b0f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b16:	eb 26                	jmp    801b3e <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  801b18:	a1 20 40 80 00       	mov    0x804020,%eax
  801b1d:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  801b23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b26:	89 d0                	mov    %edx,%eax
  801b28:	01 c0                	add    %eax,%eax
  801b2a:	01 d0                	add    %edx,%eax
  801b2c:	c1 e0 03             	shl    $0x3,%eax
  801b2f:	01 c8                	add    %ecx,%eax
  801b31:	8a 40 04             	mov    0x4(%eax),%al
  801b34:	3c 01                	cmp    $0x1,%al
  801b36:	75 03                	jne    801b3b <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  801b38:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801b3b:	ff 45 e0             	incl   -0x20(%ebp)
  801b3e:	a1 20 40 80 00       	mov    0x804020,%eax
  801b43:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801b49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b4c:	39 c2                	cmp    %eax,%edx
  801b4e:	77 c8                	ja     801b18 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b53:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801b56:	74 14                	je     801b6c <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  801b58:	83 ec 04             	sub    $0x4,%esp
  801b5b:	68 6c 3d 80 00       	push   $0x803d6c
  801b60:	6a 44                	push   $0x44
  801b62:	68 0c 3d 80 00       	push   $0x803d0c
  801b67:	e8 1a fe ff ff       	call   801986 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801b6c:	90                   	nop
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sbrk>:

//=============================================
// [1] CHANGE THE BREAK LIMIT OF THE USER HEAP:
//=============================================
/*2023*/
void* sbrk(int increment) {
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 08             	sub    $0x8,%esp
	return (void*) sys_sbrk(increment);
  801b75:	83 ec 0c             	sub    $0xc,%esp
  801b78:	ff 75 08             	pushl  0x8(%ebp)
  801b7b:	e8 e8 fa ff ff       	call   801668 <sys_sbrk>
  801b80:	83 c4 10             	add    $0x10,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <malloc>:
#define num_of_page ((USER_HEAP_MAX - USER_HEAP_START) / PAGE_SIZE)

int pagesAllocated[num_of_page] = { 0 };
int shardIDs[num_of_page] = { 0 };
bool markedPages[num_of_page] = { 0 };
void* malloc(uint32 size) {
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
  801b88:	83 ec 48             	sub    $0x48,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b8f:	75 0a                	jne    801b9b <malloc+0x16>
		return NULL;
  801b91:	b8 00 00 00 00       	mov    $0x0,%eax
  801b96:	e9 9e 01 00 00       	jmp    801d39 <malloc+0x1b4>

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() and	sys_isUHeapPlacementStrategyBESTFIT()
	//to check the current strategy

	//  our new code
	if (size <= DYN_ALLOC_MAX_BLOCK_SIZE) {
  801b9b:	81 7d 08 00 08 00 00 	cmpl   $0x800,0x8(%ebp)
  801ba2:	77 2c                	ja     801bd0 <malloc+0x4b>
		if (sys_isUHeapPlacementStrategyFIRSTFIT()) {
  801ba4:	e8 43 f9 ff ff       	call   8014ec <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	74 19                	je     801bc6 <malloc+0x41>

			void * block = alloc_block_FF(size);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	ff 75 08             	pushl  0x8(%ebp)
  801bb3:	e8 e8 0a 00 00       	call   8026a0 <alloc_block_FF>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			return block;
  801bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bc1:	e9 73 01 00 00       	jmp    801d39 <malloc+0x1b4>
		} else {
			return NULL;
  801bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bcb:	e9 69 01 00 00       	jmp    801d39 <malloc+0x1b4>
		}
	}

	uint32 numOfPages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801bd0:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  801bda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bdd:	01 d0                	add    %edx,%eax
  801bdf:	48                   	dec    %eax
  801be0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801be3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801be6:	ba 00 00 00 00       	mov    $0x0,%edx
  801beb:	f7 75 e0             	divl   -0x20(%ebp)
  801bee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bf1:	29 d0                	sub    %edx,%eax
  801bf3:	c1 e8 0c             	shr    $0xc,%eax
  801bf6:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 freePagesCount = 0;
  801bf9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801c00:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801c07:	a1 20 40 80 00       	mov    0x804020,%eax
  801c0c:	8b 40 7c             	mov    0x7c(%eax),%eax
  801c0f:	05 00 10 00 00       	add    $0x1000,%eax
  801c14:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801c17:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801c1c:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c1f:	89 45 d0             	mov    %eax,-0x30(%ebp)

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801c22:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  801c29:	8b 55 08             	mov    0x8(%ebp),%edx
  801c2c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c2f:	01 d0                	add    %edx,%eax
  801c31:	48                   	dec    %eax
  801c32:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801c35:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c38:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3d:	f7 75 cc             	divl   -0x34(%ebp)
  801c40:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801c43:	29 d0                	sub    %edx,%eax
  801c45:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  801c48:	76 0a                	jbe    801c54 <malloc+0xcf>
		return NULL;
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4f:	e9 e5 00 00 00       	jmp    801d39 <malloc+0x1b4>
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801c54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c57:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c5a:	eb 48                	jmp    801ca4 <malloc+0x11f>
	{
		uint32 idx = (i - currentAddr) / PAGE_SIZE;
  801c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5f:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801c62:	c1 e8 0c             	shr    $0xc,%eax
  801c65:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if (!markedPages[idx]) {
  801c68:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801c6b:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801c72:	85 c0                	test   %eax,%eax
  801c74:	75 11                	jne    801c87 <malloc+0x102>
			freePagesCount++;
  801c76:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801c79:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801c7d:	75 16                	jne    801c95 <malloc+0x110>
				start = i;
  801c7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c85:	eb 0e                	jmp    801c95 <malloc+0x110>
			}
		} else {
			freePagesCount = 0;
  801c87:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801c8e:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == numOfPages) {
  801c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c98:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801c9b:	74 12                	je     801caf <malloc+0x12a>

	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}

	for (uint32 i = currentAddr; i < USER_HEAP_MAX; i += PAGE_SIZE)
  801c9d:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801ca4:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801cab:	76 af                	jbe    801c5c <malloc+0xd7>
  801cad:	eb 01                	jmp    801cb0 <malloc+0x12b>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == numOfPages) {
			break;
  801caf:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
  801cb0:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801cb4:	74 08                	je     801cbe <malloc+0x139>
  801cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cb9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  801cbc:	74 07                	je     801cc5 <malloc+0x140>
		return NULL;
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc3:	eb 74                	jmp    801d39 <malloc+0x1b4>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc8:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  801ccb:	c1 e8 0c             	shr    $0xc,%eax
  801cce:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numOfPages;
  801cd1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cd4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cd7:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801cde:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801ce1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801ce4:	eb 11                	jmp    801cf7 <malloc+0x172>
		markedPages[i] = 1;
  801ce6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ce9:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801cf0:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != numOfPages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = numOfPages;
	for (uint32 i = startPage; i < startPage + numOfPages; i++) {
  801cf4:	ff 45 e8             	incl   -0x18(%ebp)
  801cf7:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801cfa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cfd:	01 d0                	add    %edx,%eax
  801cff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801d02:	77 e2                	ja     801ce6 <malloc+0x161>
		markedPages[i] = 1;
	}

	sys_allocate_user_mem(start, ROUNDUP(size, PAGE_SIZE));
  801d04:	c7 45 bc 00 10 00 00 	movl   $0x1000,-0x44(%ebp)
  801d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  801d11:	01 d0                	add    %edx,%eax
  801d13:	48                   	dec    %eax
  801d14:	89 45 b8             	mov    %eax,-0x48(%ebp)
  801d17:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1f:	f7 75 bc             	divl   -0x44(%ebp)
  801d22:	8b 45 b8             	mov    -0x48(%ebp),%eax
  801d25:	29 d0                	sub    %edx,%eax
  801d27:	83 ec 08             	sub    $0x8,%esp
  801d2a:	50                   	push   %eax
  801d2b:	ff 75 f0             	pushl  -0x10(%ebp)
  801d2e:	e8 6c f9 ff ff       	call   80169f <sys_allocate_user_mem>
  801d33:	83 c4 10             	add    $0x10,%esp
	return (void*) start;
  801d36:	8b 45 f0             	mov    -0x10(%ebp),%eax

}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <free>:
//=================================
// [3] FREE SPACE FROM USER HEAP:
//=================================
void free(void* virtual_address) {
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
  801d41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d45:	0f 84 ee 00 00 00    	je     801e39 <free+0xfe>
		return;
	}

	if (virtual_address
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801d4b:	a1 20 40 80 00       	mov    0x804020,%eax
  801d50:	8b 40 74             	mov    0x74(%eax),%eax

	if (virtual_address == NULL) {
		return;
	}

	if (virtual_address
  801d53:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d56:	77 09                	ja     801d61 <free+0x26>
			< (void *) myEnv->uheapStart|| virtual_address>(void *) USER_HEAP_MAX) {
  801d58:	81 7d 08 00 00 00 a0 	cmpl   $0xa0000000,0x8(%ebp)
  801d5f:	76 14                	jbe    801d75 <free+0x3a>
		panic("INVALID VIRTUAL ADDRESS!!");
  801d61:	83 ec 04             	sub    $0x4,%esp
  801d64:	68 b8 3d 80 00       	push   $0x803db8
  801d69:	6a 68                	push   $0x68
  801d6b:	68 d2 3d 80 00       	push   $0x803dd2
  801d70:	e8 11 fc ff ff       	call   801986 <_panic>
	}
	if (virtual_address >= (void *) (myEnv->uheapStart)
  801d75:	a1 20 40 80 00       	mov    0x804020,%eax
  801d7a:	8b 40 74             	mov    0x74(%eax),%eax
  801d7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d80:	77 20                	ja     801da2 <free+0x67>
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
  801d82:	a1 20 40 80 00       	mov    0x804020,%eax
  801d87:	8b 40 78             	mov    0x78(%eax),%eax
  801d8a:	3b 45 08             	cmp    0x8(%ebp),%eax
  801d8d:	76 13                	jbe    801da2 <free+0x67>
		free_block(virtual_address);
  801d8f:	83 ec 0c             	sub    $0xc,%esp
  801d92:	ff 75 08             	pushl  0x8(%ebp)
  801d95:	e8 cf 0f 00 00       	call   802d69 <free_block>
  801d9a:	83 c4 10             	add    $0x10,%esp
		return;
  801d9d:	e9 98 00 00 00       	jmp    801e3a <free+0xff>
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  801da2:	8b 55 08             	mov    0x8(%ebp),%edx
  801da5:	a1 20 40 80 00       	mov    0x804020,%eax
  801daa:	8b 40 7c             	mov    0x7c(%eax),%eax
  801dad:	29 c2                	sub    %eax,%edx
  801daf:	89 d0                	mov    %edx,%eax
  801db1:	2d 00 10 00 00       	sub    $0x1000,%eax
			&& virtual_address < (void *) (myEnv->uheapBreak)) {
		free_block(virtual_address);
		return;
	}

	uint32 pageIdx = ((uint32) virtual_address
  801db6:	c1 e8 0c             	shr    $0xc,%eax
  801db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801dbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801dc3:	eb 16                	jmp    801ddb <free+0xa0>
		markedPages[idx + pageIdx] = 0;
  801dc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dcb:	01 d0                	add    %edx,%eax
  801dcd:	c7 04 85 40 40 90 00 	movl   $0x0,0x904040(,%eax,4)
  801dd4:	00 00 00 00 
	}

	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;

	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
  801dd8:	ff 45 f4             	incl   -0xc(%ebp)
  801ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dde:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801de5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de8:	7f db                	jg     801dc5 <free+0x8a>
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;
  801dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ded:	8b 04 85 40 40 80 00 	mov    0x804040(,%eax,4),%eax
  801df4:	c1 e0 0c             	shl    $0xc,%eax
  801df7:	89 45 e8             	mov    %eax,-0x18(%ebp)

	for (uint32 i = (uint32) virtual_address;
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e00:	eb 1a                	jmp    801e1c <free+0xe1>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
  801e02:	83 ec 08             	sub    $0x8,%esp
  801e05:	68 00 10 00 00       	push   $0x1000
  801e0a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e0d:	e8 71 f8 ff ff       	call   801683 <sys_free_user_mem>
  801e12:	83 c4 10             	add    $0x10,%esp
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
  801e15:	81 45 f0 00 10 00 00 	addl   $0x1000,-0x10(%ebp)
  801e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  801e1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e22:	01 d0                	add    %edx,%eax
	for (int idx = 0; idx < pagesAllocated[pageIdx]; idx++) {
		markedPages[idx + pageIdx] = 0;
	}
	uint32 pageSize = pagesAllocated[pageIdx] * PAGE_SIZE;

	for (uint32 i = (uint32) virtual_address;
  801e24:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e27:	77 d9                	ja     801e02 <free+0xc7>
			i < (uint32) virtual_address + pageSize; i += PAGE_SIZE)
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;
  801e29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e2c:	c7 04 85 40 40 80 00 	movl   $0x0,0x804040(,%eax,4)
  801e33:	00 00 00 00 
  801e37:	eb 01                	jmp    801e3a <free+0xff>
	//TODO: [PROJECT'24.MS2 - #14] [3] USER HEAP [USER SIDE] - free()
	// Write your code here, remove the panic and write your code
	//panic("free() is not implemented yet...!!");

	if (virtual_address == NULL) {
		return;
  801e39:	90                   	nop
			{
		sys_free_user_mem(i, PAGE_SIZE);
	}
	pagesAllocated[pageIdx] = 0;

}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <smalloc>:
//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable) {
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 58             	sub    $0x58,%esp
  801e42:	8b 45 10             	mov    0x10(%ebp),%eax
  801e45:	88 45 b4             	mov    %al,-0x4c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	if (size == 0)
  801e48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e4c:	75 0a                	jne    801e58 <smalloc+0x1c>
		return NULL;
  801e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e53:	e9 7d 01 00 00       	jmp    801fd5 <smalloc+0x199>
	//==============================================================
	//TODO: [PROJECT'24.MS2 - #18] [4] SHARED MEMORY [USER SIDE] - smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	uint32 num_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801e58:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801e5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e65:	01 d0                	add    %edx,%eax
  801e67:	48                   	dec    %eax
  801e68:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801e6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e73:	f7 75 e4             	divl   -0x1c(%ebp)
  801e76:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e79:	29 d0                	sub    %edx,%eax
  801e7b:	c1 e8 0c             	shr    $0xc,%eax
  801e7e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	uint32 freePagesCount = 0;
  801e81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  801e88:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
  801e8f:	a1 20 40 80 00       	mov    0x804020,%eax
  801e94:	8b 40 7c             	mov    0x7c(%eax),%eax
  801e97:	05 00 10 00 00       	add    $0x1000,%eax
  801e9c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
  801e9f:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  801ea4:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801ea7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
  801eaa:	c7 45 d0 00 10 00 00 	movl   $0x1000,-0x30(%ebp)
  801eb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801eb7:	01 d0                	add    %edx,%eax
  801eb9:	48                   	dec    %eax
  801eba:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801ebd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ec0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec5:	f7 75 d0             	divl   -0x30(%ebp)
  801ec8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801ecb:	29 d0                	sub    %edx,%eax
  801ecd:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  801ed0:	76 0a                	jbe    801edc <smalloc+0xa0>
		return NULL;
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed7:	e9 f9 00 00 00       	jmp    801fd5 <smalloc+0x199>
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801edc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801edf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ee2:	eb 48                	jmp    801f2c <smalloc+0xf0>
		uint32 idx = (s - currentAddr) / PAGE_SIZE;
  801ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee7:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801eea:	c1 e8 0c             	shr    $0xc,%eax
  801eed:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (!markedPages[idx]) {
  801ef0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801ef3:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  801efa:	85 c0                	test   %eax,%eax
  801efc:	75 11                	jne    801f0f <smalloc+0xd3>
			freePagesCount++;
  801efe:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  801f01:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f05:	75 16                	jne    801f1d <smalloc+0xe1>
				start = s;
  801f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f0d:	eb 0e                	jmp    801f1d <smalloc+0xe1>
			}
		} else {
			freePagesCount = 0;
  801f0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  801f16:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (freePagesCount == num_Of_Pages) {
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f23:	74 12                	je     801f37 <smalloc+0xfb>
	uint32 currentAddr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 uheapSize = USER_HEAP_MAX - currentAddr;
	if (ROUNDUP(size, PAGE_SIZE) > uheapSize) {
		return NULL;
	}
	for (uint32 s = currentAddr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  801f25:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  801f2c:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  801f33:	76 af                	jbe    801ee4 <smalloc+0xa8>
  801f35:	eb 01                	jmp    801f38 <smalloc+0xfc>
		} else {
			freePagesCount = 0;
			start = (uint32) -1;
		}
		if (freePagesCount == num_Of_Pages) {
			break;
  801f37:	90                   	nop
		}
	}
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
  801f38:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  801f3c:	74 08                	je     801f46 <smalloc+0x10a>
  801f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f41:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  801f44:	74 0a                	je     801f50 <smalloc+0x114>
		return NULL;
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	e9 85 00 00 00       	jmp    801fd5 <smalloc+0x199>
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f53:	2b 45 d8             	sub    -0x28(%ebp),%eax
  801f56:	c1 e8 0c             	shr    $0xc,%eax
  801f59:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	pagesAllocated[startPage] = num_Of_Pages;
  801f5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801f5f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f62:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801f69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801f6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f6f:	eb 11                	jmp    801f82 <smalloc+0x146>
		markedPages[s] = 1;
  801f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f74:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  801f7b:	01 00 00 00 
	if (start == (uint32) -1 || freePagesCount != num_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - currentAddr) / PAGE_SIZE;
	pagesAllocated[startPage] = num_Of_Pages;
	for (uint32 s = startPage; s < startPage + num_Of_Pages; s++) {
  801f7f:	ff 45 e8             	incl   -0x18(%ebp)
  801f82:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801f85:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801f88:	01 d0                	add    %edx,%eax
  801f8a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801f8d:	77 e2                	ja     801f71 <smalloc+0x135>
		markedPages[s] = 1;
	}
	int sharedobjID = sys_createSharedObject(sharedVarName, size, isWritable,
  801f8f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
  801f96:	52                   	push   %edx
  801f97:	50                   	push   %eax
  801f98:	ff 75 0c             	pushl  0xc(%ebp)
  801f9b:	ff 75 08             	pushl  0x8(%ebp)
  801f9e:	e8 e7 f2 ff ff       	call   80128a <sys_createSharedObject>
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			(void*) start);

	if (sharedobjID >= 0) {
  801fa9:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801fad:	78 12                	js     801fc1 <smalloc+0x185>
		shardIDs[startPage] = sharedobjID;
  801faf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  801fb2:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801fb5:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	eb 14                	jmp    801fd5 <smalloc+0x199>
	}
	free((void*) start);
  801fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	50                   	push   %eax
  801fc8:	e8 6e fd ff ff       	call   801d3b <free>
  801fcd:	83 c4 10             	add    $0x10,%esp
	return NULL;
  801fd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName) {
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
  801fda:	83 ec 48             	sub    $0x48,%esp
	//cprintf("SSSSSGEEETTT\n");
	//TODO: [PROJECT'24.MS2 - #20] [4] SHARED MEMORY [USER SIDE] - sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	uint32 size = sys_getSizeOfSharedObject(ownerEnvID, sharedVarName);
  801fdd:	83 ec 08             	sub    $0x8,%esp
  801fe0:	ff 75 0c             	pushl  0xc(%ebp)
  801fe3:	ff 75 08             	pushl  0x8(%ebp)
  801fe6:	e8 c9 f2 ff ff       	call   8012b4 <sys_getSizeOfSharedObject>
  801feb:	83 c4 10             	add    $0x10,%esp
  801fee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (size < 0)
		return NULL;
	uint32 numb_Of_Pages = ROUNDUP(size, PAGE_SIZE) / PAGE_SIZE;
  801ff1:	c7 45 e0 00 10 00 00 	movl   $0x1000,-0x20(%ebp)
  801ff8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ffb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ffe:	01 d0                	add    %edx,%eax
  802000:	48                   	dec    %eax
  802001:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802004:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802007:	ba 00 00 00 00       	mov    $0x0,%edx
  80200c:	f7 75 e0             	divl   -0x20(%ebp)
  80200f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802012:	29 d0                	sub    %edx,%eax
  802014:	c1 e8 0c             	shr    $0xc,%eax
  802017:	89 45 d8             	mov    %eax,-0x28(%ebp)
	uint32 free_Pages_Count = 0;
  80201a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 start = (uint32) -1;
  802021:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
  802028:	a1 20 40 80 00       	mov    0x804020,%eax
  80202d:	8b 40 7c             	mov    0x7c(%eax),%eax
  802030:	05 00 10 00 00       	add    $0x1000,%eax
  802035:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
  802038:	b8 00 00 00 a0       	mov    $0xa0000000,%eax
  80203d:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802040:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
  802043:	c7 45 cc 00 10 00 00 	movl   $0x1000,-0x34(%ebp)
  80204a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80204d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802050:	01 d0                	add    %edx,%eax
  802052:	48                   	dec    %eax
  802053:	89 45 c8             	mov    %eax,-0x38(%ebp)
  802056:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802059:	ba 00 00 00 00       	mov    $0x0,%edx
  80205e:	f7 75 cc             	divl   -0x34(%ebp)
  802061:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802064:	29 d0                	sub    %edx,%eax
  802066:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  802069:	76 0a                	jbe    802075 <sget+0x9e>
		return NULL;
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	e9 f7 00 00 00       	jmp    80216c <sget+0x195>
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  802075:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802078:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80207b:	eb 48                	jmp    8020c5 <sget+0xee>
		uint32 idx = (s - current_Addr) / PAGE_SIZE;
  80207d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802080:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  802083:	c1 e8 0c             	shr    $0xc,%eax
  802086:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (!markedPages[idx]) {
  802089:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80208c:	8b 04 85 40 40 90 00 	mov    0x904040(,%eax,4),%eax
  802093:	85 c0                	test   %eax,%eax
  802095:	75 11                	jne    8020a8 <sget+0xd1>
			free_Pages_Count++;
  802097:	ff 45 f4             	incl   -0xc(%ebp)
			if (start == (uint32) -1) {
  80209a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80209e:	75 16                	jne    8020b6 <sget+0xdf>
				start = s;
  8020a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020a6:	eb 0e                	jmp    8020b6 <sget+0xdf>
			}
		} else {
			free_Pages_Count = 0;
  8020a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
			start = (uint32) -1;
  8020af:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		}
		if (free_Pages_Count == numb_Of_Pages) {
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8020bc:	74 12                	je     8020d0 <sget+0xf9>
	uint32 current_Addr = myEnv->uheapHardLimit + PAGE_SIZE;
	uint32 U_heap_Size = USER_HEAP_MAX - current_Addr;
	if (ROUNDUP(size, PAGE_SIZE) > U_heap_Size) {
		return NULL;
	}
	for (uint32 s = current_Addr; s < USER_HEAP_MAX; s += PAGE_SIZE) {
  8020be:	81 45 ec 00 10 00 00 	addl   $0x1000,-0x14(%ebp)
  8020c5:	81 7d ec ff ff ff 9f 	cmpl   $0x9fffffff,-0x14(%ebp)
  8020cc:	76 af                	jbe    80207d <sget+0xa6>
  8020ce:	eb 01                	jmp    8020d1 <sget+0xfa>
		} else {
			free_Pages_Count = 0;
			start = (uint32) -1;
		}
		if (free_Pages_Count == numb_Of_Pages) {
			break;
  8020d0:	90                   	nop
		}
	}
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
  8020d1:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8020d5:	74 08                	je     8020df <sget+0x108>
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8020dd:	74 0a                	je     8020e9 <sget+0x112>
		return NULL;
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	e9 83 00 00 00       	jmp    80216c <sget+0x195>
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
  8020e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ec:	2b 45 d4             	sub    -0x2c(%ebp),%eax
  8020ef:	c1 e8 0c             	shr    $0xc,%eax
  8020f2:	89 45 c0             	mov    %eax,-0x40(%ebp)
	pagesAllocated[startPage] = numb_Of_Pages;
  8020f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8020f8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8020fb:	89 14 85 40 40 80 00 	mov    %edx,0x804040(,%eax,4)
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802102:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802105:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802108:	eb 11                	jmp    80211b <sget+0x144>
		markedPages[k] = 1;
  80210a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80210d:	c7 04 85 40 40 90 00 	movl   $0x1,0x904040(,%eax,4)
  802114:	01 00 00 00 
	if (start == (uint32) -1 || free_Pages_Count != numb_Of_Pages) {
		return NULL;
	}
	uint32 startPage = (start - current_Addr) / PAGE_SIZE;
	pagesAllocated[startPage] = numb_Of_Pages;
	for (uint32 k = startPage; k < startPage + numb_Of_Pages; k++) {
  802118:	ff 45 e8             	incl   -0x18(%ebp)
  80211b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80211e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802121:	01 d0                	add    %edx,%eax
  802123:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802126:	77 e2                	ja     80210a <sget+0x133>
		markedPages[k] = 1;
	}
	int ss = sys_getSharedObject(ownerEnvID, sharedVarName, (void*) start);
  802128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80212b:	83 ec 04             	sub    $0x4,%esp
  80212e:	50                   	push   %eax
  80212f:	ff 75 0c             	pushl  0xc(%ebp)
  802132:	ff 75 08             	pushl  0x8(%ebp)
  802135:	e8 97 f1 ff ff       	call   8012d1 <sys_getSharedObject>
  80213a:	83 c4 10             	add    $0x10,%esp
  80213d:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if (ss >= 0) {
  802140:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  802144:	78 12                	js     802158 <sget+0x181>
		shardIDs[startPage] = ss;
  802146:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802149:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80214c:	89 14 85 40 40 88 00 	mov    %edx,0x884040(,%eax,4)
		return (void*) start;
  802153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802156:	eb 14                	jmp    80216c <sget+0x195>
	}
	free((void*) start);
  802158:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	50                   	push   %eax
  80215f:	e8 d7 fb ff ff       	call   801d3b <free>
  802164:	83 c4 10             	add    $0x10,%esp
	return NULL;
  802167:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sfree>:
//
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address) {
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
  802171:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
  802174:	8b 55 08             	mov    0x8(%ebp),%edx
  802177:	a1 20 40 80 00       	mov    0x804020,%eax
  80217c:	8b 40 7c             	mov    0x7c(%eax),%eax
  80217f:	29 c2                	sub    %eax,%edx
  802181:	89 d0                	mov    %edx,%eax
  802183:	2d 00 10 00 00       	sub    $0x1000,%eax

void sfree(void* virtual_address) {
	//TODO: [PROJECT'24.MS2 - BONUS#4] [4] SHARED MEMORY [USER SIDE] - sfree()
	// Write your code here, remove the panic and write your code
	//panic("sfree() is not implemented yet...!!");
	uint32 pageIdx = ((uint32) virtual_address
  802188:	c1 e8 0c             	shr    $0xc,%eax
  80218b:	89 45 f4             	mov    %eax,-0xc(%ebp)
			- (uint32) (myEnv->uheapHardLimit + PAGE_SIZE)) / PAGE_SIZE;
	int id = shardIDs[pageIdx];
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 04 85 40 40 88 00 	mov    0x884040(,%eax,4),%eax
  802198:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int result = sys_freeSharedObject(id, virtual_address);
  80219b:	83 ec 08             	sub    $0x8,%esp
  80219e:	ff 75 08             	pushl  0x8(%ebp)
  8021a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8021a4:	e8 47 f1 ff ff       	call   8012f0 <sys_freeSharedObject>
  8021a9:	83 c4 10             	add    $0x10,%esp
  8021ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	if (result == 0) {
  8021af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021b3:	75 0e                	jne    8021c3 <sfree+0x55>
		shardIDs[pageIdx] = -1;  // Reset the ID after freeing
  8021b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b8:	c7 04 85 40 40 88 00 	movl   $0xffffffff,0x884040(,%eax,4)
  8021bf:	ff ff ff ff 
	}

}
  8021c3:	90                   	nop
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <realloc>:

//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size) {
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021cc:	83 ec 04             	sub    $0x4,%esp
  8021cf:	68 e0 3d 80 00       	push   $0x803de0
  8021d4:	68 19 01 00 00       	push   $0x119
  8021d9:	68 d2 3d 80 00       	push   $0x803dd2
  8021de:	e8 a3 f7 ff ff       	call   801986 <_panic>

008021e3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//

void expand(uint32 newSize) {
  8021e3:	55                   	push   %ebp
  8021e4:	89 e5                	mov    %esp,%ebp
  8021e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	68 06 3e 80 00       	push   $0x803e06
  8021f1:	68 23 01 00 00       	push   $0x123
  8021f6:	68 d2 3d 80 00       	push   $0x803dd2
  8021fb:	e8 86 f7 ff ff       	call   801986 <_panic>

00802200 <shrink>:

}
void shrink(uint32 newSize) {
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 06 3e 80 00       	push   $0x803e06
  80220e:	68 27 01 00 00       	push   $0x127
  802213:	68 d2 3d 80 00       	push   $0x803dd2
  802218:	e8 69 f7 ff ff       	call   801986 <_panic>

0080221d <freeHeap>:

}
void freeHeap(void* virtual_address) {
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
  802220:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 06 3e 80 00       	push   $0x803e06
  80222b:	68 2b 01 00 00       	push   $0x12b
  802230:	68 d2 3d 80 00       	push   $0x803dd2
  802235:	e8 4c f7 ff ff       	call   801986 <_panic>

0080223a <get_block_size>:

//=====================================================
// 1) GET BLOCK SIZE (including size of its meta data):
//=====================================================
__inline__ uint32 get_block_size(void* va)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
  80223d:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802240:	8b 45 08             	mov    0x8(%ebp),%eax
  802243:	83 e8 04             	sub    $0x4,%eax
  802246:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (*curBlkMetaData) & ~(0x1);
  802249:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80224c:	8b 00                	mov    (%eax),%eax
  80224e:	83 e0 fe             	and    $0xfffffffe,%eax
}
  802251:	c9                   	leave  
  802252:	c3                   	ret    

00802253 <is_free_block>:

//===========================
// 2) GET BLOCK STATUS:
//===========================
__inline__ int8 is_free_block(void* va)
{
  802253:	55                   	push   %ebp
  802254:	89 e5                	mov    %esp,%ebp
  802256:	83 ec 10             	sub    $0x10,%esp
	uint32 *curBlkMetaData = ((uint32 *)va - 1) ;
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	83 e8 04             	sub    $0x4,%eax
  80225f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	return (~(*curBlkMetaData) & 0x1) ;
  802262:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802265:	8b 00                	mov    (%eax),%eax
  802267:	83 e0 01             	and    $0x1,%eax
  80226a:	85 c0                	test   %eax,%eax
  80226c:	0f 94 c0             	sete   %al
}
  80226f:	c9                   	leave  
  802270:	c3                   	ret    

00802271 <alloc_block>:
//===========================
// 3) ALLOCATE BLOCK:
//===========================

void *alloc_block(uint32 size, int ALLOC_STRATEGY)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 18             	sub    $0x18,%esp
	void *va = NULL;
  802277:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	switch (ALLOC_STRATEGY)
  80227e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802281:	83 f8 02             	cmp    $0x2,%eax
  802284:	74 2b                	je     8022b1 <alloc_block+0x40>
  802286:	83 f8 02             	cmp    $0x2,%eax
  802289:	7f 07                	jg     802292 <alloc_block+0x21>
  80228b:	83 f8 01             	cmp    $0x1,%eax
  80228e:	74 0e                	je     80229e <alloc_block+0x2d>
  802290:	eb 58                	jmp    8022ea <alloc_block+0x79>
  802292:	83 f8 03             	cmp    $0x3,%eax
  802295:	74 2d                	je     8022c4 <alloc_block+0x53>
  802297:	83 f8 04             	cmp    $0x4,%eax
  80229a:	74 3b                	je     8022d7 <alloc_block+0x66>
  80229c:	eb 4c                	jmp    8022ea <alloc_block+0x79>
	{
	case DA_FF:
		va = alloc_block_FF(size);
  80229e:	83 ec 0c             	sub    $0xc,%esp
  8022a1:	ff 75 08             	pushl  0x8(%ebp)
  8022a4:	e8 f7 03 00 00       	call   8026a0 <alloc_block_FF>
  8022a9:	83 c4 10             	add    $0x10,%esp
  8022ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022af:	eb 4a                	jmp    8022fb <alloc_block+0x8a>
	case DA_NF:
		va = alloc_block_NF(size);
  8022b1:	83 ec 0c             	sub    $0xc,%esp
  8022b4:	ff 75 08             	pushl  0x8(%ebp)
  8022b7:	e8 f0 11 00 00       	call   8034ac <alloc_block_NF>
  8022bc:	83 c4 10             	add    $0x10,%esp
  8022bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022c2:	eb 37                	jmp    8022fb <alloc_block+0x8a>
	case DA_BF:
		va = alloc_block_BF(size);
  8022c4:	83 ec 0c             	sub    $0xc,%esp
  8022c7:	ff 75 08             	pushl  0x8(%ebp)
  8022ca:	e8 08 08 00 00       	call   802ad7 <alloc_block_BF>
  8022cf:	83 c4 10             	add    $0x10,%esp
  8022d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022d5:	eb 24                	jmp    8022fb <alloc_block+0x8a>
	case DA_WF:
		va = alloc_block_WF(size);
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	ff 75 08             	pushl  0x8(%ebp)
  8022dd:	e8 ad 11 00 00       	call   80348f <alloc_block_WF>
  8022e2:	83 c4 10             	add    $0x10,%esp
  8022e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		break;
  8022e8:	eb 11                	jmp    8022fb <alloc_block+0x8a>
	default:
		cprintf("Invalid allocation strategy\n");
  8022ea:	83 ec 0c             	sub    $0xc,%esp
  8022ed:	68 18 3e 80 00       	push   $0x803e18
  8022f2:	e8 01 e0 ff ff       	call   8002f8 <cprintf>
  8022f7:	83 c4 10             	add    $0x10,%esp
		break;
  8022fa:	90                   	nop
	}
	return va;
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <print_blocks_list>:
//===========================
// 4) PRINT BLOCKS LIST:
//===========================

void print_blocks_list(struct MemBlock_LIST list)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	53                   	push   %ebx
  802304:	83 ec 14             	sub    $0x14,%esp
	cprintf("=========================================\n");
  802307:	83 ec 0c             	sub    $0xc,%esp
  80230a:	68 38 3e 80 00       	push   $0x803e38
  80230f:	e8 e4 df ff ff       	call   8002f8 <cprintf>
  802314:	83 c4 10             	add    $0x10,%esp
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
  802317:	83 ec 0c             	sub    $0xc,%esp
  80231a:	68 63 3e 80 00       	push   $0x803e63
  80231f:	e8 d4 df ff ff       	call   8002f8 <cprintf>
  802324:	83 c4 10             	add    $0x10,%esp
	LIST_FOREACH(blk, &list)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232d:	eb 37                	jmp    802366 <print_blocks_list+0x66>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
  80232f:	83 ec 0c             	sub    $0xc,%esp
  802332:	ff 75 f4             	pushl  -0xc(%ebp)
  802335:	e8 19 ff ff ff       	call   802253 <is_free_block>
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	0f be d8             	movsbl %al,%ebx
  802340:	83 ec 0c             	sub    $0xc,%esp
  802343:	ff 75 f4             	pushl  -0xc(%ebp)
  802346:	e8 ef fe ff ff       	call   80223a <get_block_size>
  80234b:	83 c4 10             	add    $0x10,%esp
  80234e:	83 ec 04             	sub    $0x4,%esp
  802351:	53                   	push   %ebx
  802352:	50                   	push   %eax
  802353:	68 7b 3e 80 00       	push   $0x803e7b
  802358:	e8 9b df ff ff       	call   8002f8 <cprintf>
  80235d:	83 c4 10             	add    $0x10,%esp
void print_blocks_list(struct MemBlock_LIST list)
{
	cprintf("=========================================\n");
	struct BlockElement* blk ;
	cprintf("\nDynAlloc Blocks List:\n");
	LIST_FOREACH(blk, &list)
  802360:	8b 45 10             	mov    0x10(%ebp),%eax
  802363:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236a:	74 07                	je     802373 <print_blocks_list+0x73>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 00                	mov    (%eax),%eax
  802371:	eb 05                	jmp    802378 <print_blocks_list+0x78>
  802373:	b8 00 00 00 00       	mov    $0x0,%eax
  802378:	89 45 10             	mov    %eax,0x10(%ebp)
  80237b:	8b 45 10             	mov    0x10(%ebp),%eax
  80237e:	85 c0                	test   %eax,%eax
  802380:	75 ad                	jne    80232f <print_blocks_list+0x2f>
  802382:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802386:	75 a7                	jne    80232f <print_blocks_list+0x2f>
	{
		cprintf("(size: %d, isFree: %d)\n", get_block_size(blk), is_free_block(blk)) ;
	}
	cprintf("=========================================\n");
  802388:	83 ec 0c             	sub    $0xc,%esp
  80238b:	68 38 3e 80 00       	push   $0x803e38
  802390:	e8 63 df ff ff       	call   8002f8 <cprintf>
  802395:	83 c4 10             	add    $0x10,%esp

}
  802398:	90                   	nop
  802399:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80239c:	c9                   	leave  
  80239d:	c3                   	ret    

0080239e <initialize_dynamic_allocator>:

//==================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//==================================
void initialize_dynamic_allocator(uint32 daStart, uint32 initSizeOfAllocatedSpace)
{
  80239e:	55                   	push   %ebp
  80239f:	89 e5                	mov    %esp,%ebp
  8023a1:	83 ec 18             	sub    $0x18,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
  8023a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a7:	83 e0 01             	and    $0x1,%eax
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	74 03                	je     8023b1 <initialize_dynamic_allocator+0x13>
  8023ae:	ff 45 0c             	incl   0xc(%ebp)
		if (initSizeOfAllocatedSpace == 0)
  8023b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8023b5:	0f 84 f8 00 00 00    	je     8024b3 <initialize_dynamic_allocator+0x115>
			return ;
		is_initialized = 1;
  8023bb:	c7 05 40 40 98 00 01 	movl   $0x1,0x984040
  8023c2:	00 00 00 
	//TODO: [PROJECT'24.MS1 - #04] [3] DYNAMIC ALLOCATOR - initialize_dynamic_allocator
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("initialize_dynamic_allocator is not implemented yet");
	//Your Code is Here...

	if(is_initialized){
  8023c5:	a1 40 40 98 00       	mov    0x984040,%eax
  8023ca:	85 c0                	test   %eax,%eax
  8023cc:	0f 84 e2 00 00 00    	je     8024b4 <initialize_dynamic_allocator+0x116>

		// begin block with size 0 and lsb = 1 (allocated)
		uint32* beginBlock = (uint32*)daStart;
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*beginBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
		// end block with size 0 and lsb = 1 (allocated)
		uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);
  8023e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	01 d0                	add    %edx,%eax
  8023e9:	83 e8 04             	sub    $0x4,%eax
  8023ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		*endBlock = 0 | 1; // size = 0, LSB as a flag = 1
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

		// the block that between begin and end blocks
		struct BlockElement* block = (struct BlockElement*)(daStart + 8);
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	83 c0 08             	add    $0x8,%eax
  8023fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 blockSize = initSizeOfAllocatedSpace - 8; // subtract size of begin and end blocks
  802401:	8b 45 0c             	mov    0xc(%ebp),%eax
  802404:	83 e8 08             	sub    $0x8,%eax
  802407:	89 45 e8             	mov    %eax,-0x18(%ebp)
		set_block_data(block,blockSize,0);
  80240a:	83 ec 04             	sub    $0x4,%esp
  80240d:	6a 00                	push   $0x0
  80240f:	ff 75 e8             	pushl  -0x18(%ebp)
  802412:	ff 75 ec             	pushl  -0x14(%ebp)
  802415:	e8 9c 00 00 00       	call   8024b6 <set_block_data>
  80241a:	83 c4 10             	add    $0x10,%esp

		block->prev_next_info.le_next = NULL;
  80241d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		block->prev_next_info.le_prev = NULL;
  802426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802429:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

		LIST_INIT(&freeBlocksList);
  802430:	c7 05 48 40 98 00 00 	movl   $0x0,0x984048
  802437:	00 00 00 
  80243a:	c7 05 4c 40 98 00 00 	movl   $0x0,0x98404c
  802441:	00 00 00 
  802444:	c7 05 54 40 98 00 00 	movl   $0x0,0x984054
  80244b:	00 00 00 
		LIST_INSERT_HEAD(&freeBlocksList, block);
  80244e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802452:	75 17                	jne    80246b <initialize_dynamic_allocator+0xcd>
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	68 94 3e 80 00       	push   $0x803e94
  80245c:	68 80 00 00 00       	push   $0x80
  802461:	68 b7 3e 80 00       	push   $0x803eb7
  802466:	e8 1b f5 ff ff       	call   801986 <_panic>
  80246b:	8b 15 48 40 98 00    	mov    0x984048,%edx
  802471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802474:	89 10                	mov    %edx,(%eax)
  802476:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802479:	8b 00                	mov    (%eax),%eax
  80247b:	85 c0                	test   %eax,%eax
  80247d:	74 0d                	je     80248c <initialize_dynamic_allocator+0xee>
  80247f:	a1 48 40 98 00       	mov    0x984048,%eax
  802484:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802487:	89 50 04             	mov    %edx,0x4(%eax)
  80248a:	eb 08                	jmp    802494 <initialize_dynamic_allocator+0xf6>
  80248c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802497:	a3 48 40 98 00       	mov    %eax,0x984048
  80249c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a6:	a1 54 40 98 00       	mov    0x984054,%eax
  8024ab:	40                   	inc    %eax
  8024ac:	a3 54 40 98 00       	mov    %eax,0x984054
  8024b1:	eb 01                	jmp    8024b4 <initialize_dynamic_allocator+0x116>
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (initSizeOfAllocatedSpace % 2 != 0) initSizeOfAllocatedSpace++; //ensure it's multiple of 2
		if (initSizeOfAllocatedSpace == 0)
			return ;
  8024b3:	90                   	nop
		block->prev_next_info.le_prev = NULL;

		LIST_INIT(&freeBlocksList);
		LIST_INSERT_HEAD(&freeBlocksList, block);
	}
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <set_block_data>:
//==================================
// [2] SET BLOCK HEADER & FOOTER:
//==================================
void set_block_data(void* va, uint32 totalSize, bool isAllocated)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	83 ec 10             	sub    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #05] [3] DYNAMIC ALLOCATOR - set_block_data
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("set_block_data is not implemented yet");
	//Your Code is Here...

	if(totalSize % 2 != 0)
  8024bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bf:	83 e0 01             	and    $0x1,%eax
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	74 03                	je     8024c9 <set_block_data+0x13>
	{
		totalSize++;
  8024c6:	ff 45 0c             	incl   0xc(%ebp)
	}

	uint32* header = (uint32 *)((uint32*)va-1);
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	83 e8 04             	sub    $0x4,%eax
  8024cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	//	size => totalSize with LSB = 0		 set LSB = 1 if isAllocated
	*header = (totalSize & ~1) | (isAllocated & 1);
  8024d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d5:	83 e0 fe             	and    $0xfffffffe,%eax
  8024d8:	89 c2                	mov    %eax,%edx
  8024da:	8b 45 10             	mov    0x10(%ebp),%eax
  8024dd:	83 e0 01             	and    $0x1,%eax
  8024e0:	09 c2                	or     %eax,%edx
  8024e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024e5:	89 10                	mov    %edx,(%eax)
	uint32* footer = (uint32*) (va + totalSize - 8);
  8024e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ea:	8d 50 f8             	lea    -0x8(%eax),%edx
  8024ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f0:	01 d0                	add    %edx,%eax
  8024f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	*footer = (totalSize & ~1) | (isAllocated & 1);
  8024f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f8:	83 e0 fe             	and    $0xfffffffe,%eax
  8024fb:	89 c2                	mov    %eax,%edx
  8024fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802500:	83 e0 01             	and    $0x1,%eax
  802503:	09 c2                	or     %eax,%edx
  802505:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802508:	89 10                	mov    %edx,(%eax)
}
  80250a:	90                   	nop
  80250b:	c9                   	leave  
  80250c:	c3                   	ret    

0080250d <insert_sorted_in_freeList>:
//=========================================
void insert_sorted_in_freeList(struct BlockElement *newBlock)
{
  80250d:	55                   	push   %ebp
  80250e:	89 e5                	mov    %esp,%ebp
  802510:	83 ec 18             	sub    $0x18,%esp
	if(LIST_EMPTY(&freeBlocksList))
  802513:	a1 48 40 98 00       	mov    0x984048,%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	75 68                	jne    802584 <insert_sorted_in_freeList+0x77>
	{
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
  80251c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802520:	75 17                	jne    802539 <insert_sorted_in_freeList+0x2c>
  802522:	83 ec 04             	sub    $0x4,%esp
  802525:	68 94 3e 80 00       	push   $0x803e94
  80252a:	68 9d 00 00 00       	push   $0x9d
  80252f:	68 b7 3e 80 00       	push   $0x803eb7
  802534:	e8 4d f4 ff ff       	call   801986 <_panic>
  802539:	8b 15 48 40 98 00    	mov    0x984048,%edx
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	89 10                	mov    %edx,(%eax)
  802544:	8b 45 08             	mov    0x8(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 0d                	je     80255a <insert_sorted_in_freeList+0x4d>
  80254d:	a1 48 40 98 00       	mov    0x984048,%eax
  802552:	8b 55 08             	mov    0x8(%ebp),%edx
  802555:	89 50 04             	mov    %edx,0x4(%eax)
  802558:	eb 08                	jmp    802562 <insert_sorted_in_freeList+0x55>
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802562:	8b 45 08             	mov    0x8(%ebp),%eax
  802565:	a3 48 40 98 00       	mov    %eax,0x984048
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802574:	a1 54 40 98 00       	mov    0x984054,%eax
  802579:	40                   	inc    %eax
  80257a:	a3 54 40 98 00       	mov    %eax,0x984054
		return;
  80257f:	e9 1a 01 00 00       	jmp    80269e <insert_sorted_in_freeList+0x191>
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802584:	a1 48 40 98 00       	mov    0x984048,%eax
  802589:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258c:	eb 7f                	jmp    80260d <insert_sorted_in_freeList+0x100>
	{
		if(blk > newBlock) // if address of blk > address of newBlock => add newBlock before blk
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	3b 45 08             	cmp    0x8(%ebp),%eax
  802594:	76 6f                	jbe    802605 <insert_sorted_in_freeList+0xf8>
		{
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	74 06                	je     8025a2 <insert_sorted_in_freeList+0x95>
  80259c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025a0:	75 17                	jne    8025b9 <insert_sorted_in_freeList+0xac>
  8025a2:	83 ec 04             	sub    $0x4,%esp
  8025a5:	68 d0 3e 80 00       	push   $0x803ed0
  8025aa:	68 a6 00 00 00       	push   $0xa6
  8025af:	68 b7 3e 80 00       	push   $0x803eb7
  8025b4:	e8 cd f3 ff ff       	call   801986 <_panic>
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 50 04             	mov    0x4(%eax),%edx
  8025bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cb:	89 10                	mov    %edx,(%eax)
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 04             	mov    0x4(%eax),%eax
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	74 0d                	je     8025e4 <insert_sorted_in_freeList+0xd7>
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8025e0:	89 10                	mov    %edx,(%eax)
  8025e2:	eb 08                	jmp    8025ec <insert_sorted_in_freeList+0xdf>
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	a3 48 40 98 00       	mov    %eax,0x984048
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f2:	89 50 04             	mov    %edx,0x4(%eax)
  8025f5:	a1 54 40 98 00       	mov    0x984054,%eax
  8025fa:	40                   	inc    %eax
  8025fb:	a3 54 40 98 00       	mov    %eax,0x984054
			return;
  802600:	e9 99 00 00 00       	jmp    80269e <insert_sorted_in_freeList+0x191>
		LIST_INSERT_HEAD(&freeBlocksList, newBlock);
		return;
	}

	struct BlockElement *blk;
	LIST_FOREACH(blk, &(freeBlocksList))
  802605:	a1 50 40 98 00       	mov    0x984050,%eax
  80260a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802611:	74 07                	je     80261a <insert_sorted_in_freeList+0x10d>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 00                	mov    (%eax),%eax
  802618:	eb 05                	jmp    80261f <insert_sorted_in_freeList+0x112>
  80261a:	b8 00 00 00 00       	mov    $0x0,%eax
  80261f:	a3 50 40 98 00       	mov    %eax,0x984050
  802624:	a1 50 40 98 00       	mov    0x984050,%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	0f 85 5d ff ff ff    	jne    80258e <insert_sorted_in_freeList+0x81>
  802631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802635:	0f 85 53 ff ff ff    	jne    80258e <insert_sorted_in_freeList+0x81>
			LIST_INSERT_BEFORE(&freeBlocksList,blk,newBlock);
			return;
		}
	}
	// if no blk its address > newBlock
	LIST_INSERT_TAIL(&freeBlocksList, newBlock);
  80263b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80263f:	75 17                	jne    802658 <insert_sorted_in_freeList+0x14b>
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 08 3f 80 00       	push   $0x803f08
  802649:	68 ab 00 00 00       	push   $0xab
  80264e:	68 b7 3e 80 00       	push   $0x803eb7
  802653:	e8 2e f3 ff ff       	call   801986 <_panic>
  802658:	8b 15 4c 40 98 00    	mov    0x98404c,%edx
  80265e:	8b 45 08             	mov    0x8(%ebp),%eax
  802661:	89 50 04             	mov    %edx,0x4(%eax)
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	8b 40 04             	mov    0x4(%eax),%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	74 0c                	je     80267a <insert_sorted_in_freeList+0x16d>
  80266e:	a1 4c 40 98 00       	mov    0x98404c,%eax
  802673:	8b 55 08             	mov    0x8(%ebp),%edx
  802676:	89 10                	mov    %edx,(%eax)
  802678:	eb 08                	jmp    802682 <insert_sorted_in_freeList+0x175>
  80267a:	8b 45 08             	mov    0x8(%ebp),%eax
  80267d:	a3 48 40 98 00       	mov    %eax,0x984048
  802682:	8b 45 08             	mov    0x8(%ebp),%eax
  802685:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802693:	a1 54 40 98 00       	mov    0x984054,%eax
  802698:	40                   	inc    %eax
  802699:	a3 54 40 98 00       	mov    %eax,0x984054
}
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <alloc_block_FF>:
//=========================================
// [3] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *alloc_block_FF(uint32 size)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	83 ec 78             	sub    $0x78,%esp
	//==================================================================================
	//DON'T CHANGE THESE LINES==========================================================
	//==================================================================================
	{
		if (size % 2 != 0) size++;	//ensure that the size is even (to use LSB as allocation flag)
  8026a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a9:	83 e0 01             	and    $0x1,%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	74 03                	je     8026b3 <alloc_block_FF+0x13>
  8026b0:	ff 45 08             	incl   0x8(%ebp)
		if (size < DYN_ALLOC_MIN_BLOCK_SIZE)
  8026b3:	83 7d 08 07          	cmpl   $0x7,0x8(%ebp)
  8026b7:	77 07                	ja     8026c0 <alloc_block_FF+0x20>
			size = DYN_ALLOC_MIN_BLOCK_SIZE ;
  8026b9:	c7 45 08 08 00 00 00 	movl   $0x8,0x8(%ebp)
		if (!is_initialized)
  8026c0:	a1 40 40 98 00       	mov    0x984040,%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	75 63                	jne    80272c <alloc_block_FF+0x8c>
		{
			uint32 required_size = size + 2*sizeof(int) /*header & footer*/ + 2*sizeof(int) /*da begin & end*/ ;
  8026c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cc:	83 c0 10             	add    $0x10,%eax
  8026cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			uint32 da_start = (uint32)sbrk(ROUNDUP(required_size, PAGE_SIZE)/PAGE_SIZE);
  8026d2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8026d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026df:	01 d0                	add    %edx,%eax
  8026e1:	48                   	dec    %eax
  8026e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8026e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8026ed:	f7 75 ec             	divl   -0x14(%ebp)
  8026f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f3:	29 d0                	sub    %edx,%eax
  8026f5:	c1 e8 0c             	shr    $0xc,%eax
  8026f8:	83 ec 0c             	sub    $0xc,%esp
  8026fb:	50                   	push   %eax
  8026fc:	e8 6e f4 ff ff       	call   801b6f <sbrk>
  802701:	83 c4 10             	add    $0x10,%esp
  802704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			uint32 da_break = (uint32)sbrk(0);
  802707:	83 ec 0c             	sub    $0xc,%esp
  80270a:	6a 00                	push   $0x0
  80270c:	e8 5e f4 ff ff       	call   801b6f <sbrk>
  802711:	83 c4 10             	add    $0x10,%esp
  802714:	89 45 e0             	mov    %eax,-0x20(%ebp)
			initialize_dynamic_allocator(da_start, da_break - da_start);
  802717:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80271d:	83 ec 08             	sub    $0x8,%esp
  802720:	50                   	push   %eax
  802721:	ff 75 e4             	pushl  -0x1c(%ebp)
  802724:	e8 75 fc ff ff       	call   80239e <initialize_dynamic_allocator>
  802729:	83 c4 10             	add    $0x10,%esp
	//TODO: [PROJECT'24.MS1 - #06] [3] DYNAMIC ALLOCATOR - alloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(size == 0)
  80272c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802730:	75 0a                	jne    80273c <alloc_block_FF+0x9c>
	{
		return NULL;
  802732:	b8 00 00 00 00       	mov    $0x0,%eax
  802737:	e9 99 03 00 00       	jmp    802ad5 <alloc_block_FF+0x435>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	83 c0 08             	add    $0x8,%eax
  802742:	89 45 dc             	mov    %eax,-0x24(%ebp)

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802745:	a1 48 40 98 00       	mov    0x984048,%eax
  80274a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274d:	e9 03 02 00 00       	jmp    802955 <alloc_block_FF+0x2b5>
	{
		uint32 blockSize = get_block_size(block); // Get size without the (LSB) allocation flag
  802752:	83 ec 0c             	sub    $0xc,%esp
  802755:	ff 75 f4             	pushl  -0xc(%ebp)
  802758:	e8 dd fa ff ff       	call   80223a <get_block_size>
  80275d:	83 c4 10             	add    $0x10,%esp
  802760:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if(blockSize >= totalSize)
  802763:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802766:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  802769:	0f 82 de 01 00 00    	jb     80294d <alloc_block_FF+0x2ad>
		{	//if we can put another block with min size 16
			if(blockSize >= totalSize + 4*sizeof(uint32))
  80276f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802772:	83 c0 10             	add    $0x10,%eax
  802775:	3b 45 9c             	cmp    -0x64(%ebp),%eax
  802778:	0f 87 32 01 00 00    	ja     8028b0 <alloc_block_FF+0x210>
			{
				// the size that will remain from the block that we will allocate a new block in it
				uint32 remainingSize = blockSize - totalSize;
  80277e:	8b 45 9c             	mov    -0x64(%ebp),%eax
  802781:	2b 45 dc             	sub    -0x24(%ebp),%eax
  802784:	89 45 98             	mov    %eax,-0x68(%ebp)

				// the remaining free space from the block that we use to allocate in it
				struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)block + totalSize);
  802787:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80278d:	01 d0                	add    %edx,%eax
  80278f:	89 45 94             	mov    %eax,-0x6c(%ebp)
				set_block_data(remainingFreeBlock, remainingSize, 0);
  802792:	83 ec 04             	sub    $0x4,%esp
  802795:	6a 00                	push   $0x0
  802797:	ff 75 98             	pushl  -0x68(%ebp)
  80279a:	ff 75 94             	pushl  -0x6c(%ebp)
  80279d:	e8 14 fd ff ff       	call   8024b6 <set_block_data>
  8027a2:	83 c4 10             	add    $0x10,%esp
				// add it after the block we allocated to be sorted by addresses
				LIST_INSERT_AFTER(&freeBlocksList, block,remainingFreeBlock);
  8027a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a9:	74 06                	je     8027b1 <alloc_block_FF+0x111>
  8027ab:	83 7d 94 00          	cmpl   $0x0,-0x6c(%ebp)
  8027af:	75 17                	jne    8027c8 <alloc_block_FF+0x128>
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	68 2c 3f 80 00       	push   $0x803f2c
  8027b9:	68 de 00 00 00       	push   $0xde
  8027be:	68 b7 3e 80 00       	push   $0x803eb7
  8027c3:	e8 be f1 ff ff       	call   801986 <_panic>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 10                	mov    (%eax),%edx
  8027cd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0b                	je     8027e6 <alloc_block_FF+0x146>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8027e3:	89 50 04             	mov    %edx,0x4(%eax)
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  8027ec:	89 10                	mov    %edx,(%eax)
  8027ee:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f4:	89 50 04             	mov    %edx,0x4(%eax)
  8027f7:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8027fa:	8b 00                	mov    (%eax),%eax
  8027fc:	85 c0                	test   %eax,%eax
  8027fe:	75 08                	jne    802808 <alloc_block_FF+0x168>
  802800:	8b 45 94             	mov    -0x6c(%ebp),%eax
  802803:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802808:	a1 54 40 98 00       	mov    0x984054,%eax
  80280d:	40                   	inc    %eax
  80280e:	a3 54 40 98 00       	mov    %eax,0x984054

				// update the allocated block and remove it from freeBlocksList
				set_block_data(block,totalSize,1);
  802813:	83 ec 04             	sub    $0x4,%esp
  802816:	6a 01                	push   $0x1
  802818:	ff 75 dc             	pushl  -0x24(%ebp)
  80281b:	ff 75 f4             	pushl  -0xc(%ebp)
  80281e:	e8 93 fc ff ff       	call   8024b6 <set_block_data>
  802823:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  802826:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282a:	75 17                	jne    802843 <alloc_block_FF+0x1a3>
  80282c:	83 ec 04             	sub    $0x4,%esp
  80282f:	68 60 3f 80 00       	push   $0x803f60
  802834:	68 e3 00 00 00       	push   $0xe3
  802839:	68 b7 3e 80 00       	push   $0x803eb7
  80283e:	e8 43 f1 ff ff       	call   801986 <_panic>
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	8b 00                	mov    (%eax),%eax
  802848:	85 c0                	test   %eax,%eax
  80284a:	74 10                	je     80285c <alloc_block_FF+0x1bc>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802854:	8b 52 04             	mov    0x4(%edx),%edx
  802857:	89 50 04             	mov    %edx,0x4(%eax)
  80285a:	eb 0b                	jmp    802867 <alloc_block_FF+0x1c7>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802867:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 0f                	je     802880 <alloc_block_FF+0x1e0>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287a:	8b 12                	mov    (%edx),%edx
  80287c:	89 10                	mov    %edx,(%eax)
  80287e:	eb 0a                	jmp    80288a <alloc_block_FF+0x1ea>
  802880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	a3 48 40 98 00       	mov    %eax,0x984048
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289d:	a1 54 40 98 00       	mov    0x984054,%eax
  8028a2:	48                   	dec    %eax
  8028a3:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  8028a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ab:	e9 25 02 00 00       	jmp    802ad5 <alloc_block_FF+0x435>
			}
			else // if set internal fragmentation
			{
				// add the remaining size to the block we allocate so it will be the same main block size
				set_block_data(block,blockSize,1);
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	6a 01                	push   $0x1
  8028b5:	ff 75 9c             	pushl  -0x64(%ebp)
  8028b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8028bb:	e8 f6 fb ff ff       	call   8024b6 <set_block_data>
  8028c0:	83 c4 10             	add    $0x10,%esp
				// remove the block we allocated from the freeList because it is now allocated.
				LIST_REMOVE(&freeBlocksList, block);
  8028c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c7:	75 17                	jne    8028e0 <alloc_block_FF+0x240>
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	68 60 3f 80 00       	push   $0x803f60
  8028d1:	68 eb 00 00 00       	push   $0xeb
  8028d6:	68 b7 3e 80 00       	push   $0x803eb7
  8028db:	e8 a6 f0 ff ff       	call   801986 <_panic>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 10                	je     8028f9 <alloc_block_FF+0x259>
  8028e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f1:	8b 52 04             	mov    0x4(%edx),%edx
  8028f4:	89 50 04             	mov    %edx,0x4(%eax)
  8028f7:	eb 0b                	jmp    802904 <alloc_block_FF+0x264>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 0f                	je     80291d <alloc_block_FF+0x27d>
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802917:	8b 12                	mov    (%edx),%edx
  802919:	89 10                	mov    %edx,(%eax)
  80291b:	eb 0a                	jmp    802927 <alloc_block_FF+0x287>
  80291d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	a3 48 40 98 00       	mov    %eax,0x984048
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293a:	a1 54 40 98 00       	mov    0x984054,%eax
  80293f:	48                   	dec    %eax
  802940:	a3 54 40 98 00       	mov    %eax,0x984054
				return (void*)((uint32*)block);
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	e9 88 01 00 00       	jmp    802ad5 <alloc_block_FF+0x435>
		return NULL;
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  80294d:	a1 50 40 98 00       	mov    0x984050,%eax
  802952:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802955:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802959:	74 07                	je     802962 <alloc_block_FF+0x2c2>
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 00                	mov    (%eax),%eax
  802960:	eb 05                	jmp    802967 <alloc_block_FF+0x2c7>
  802962:	b8 00 00 00 00       	mov    $0x0,%eax
  802967:	a3 50 40 98 00       	mov    %eax,0x984050
  80296c:	a1 50 40 98 00       	mov    0x984050,%eax
  802971:	85 c0                	test   %eax,%eax
  802973:	0f 85 d9 fd ff ff    	jne    802752 <alloc_block_FF+0xb2>
  802979:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297d:	0f 85 cf fd ff ff    	jne    802752 <alloc_block_FF+0xb2>

//	uint32 *endBlock = &kheapBreak;

	// if we don't find any enough space to allocate the block

	void *oldBreak = sbrk(ROUNDUP(totalSize, PAGE_SIZE) / PAGE_SIZE);
  802983:	c7 45 d8 00 10 00 00 	movl   $0x1000,-0x28(%ebp)
  80298a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80298d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802990:	01 d0                	add    %edx,%eax
  802992:	48                   	dec    %eax
  802993:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  802996:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802999:	ba 00 00 00 00       	mov    $0x0,%edx
  80299e:	f7 75 d8             	divl   -0x28(%ebp)
  8029a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8029a4:	29 d0                	sub    %edx,%eax
  8029a6:	c1 e8 0c             	shr    $0xc,%eax
  8029a9:	83 ec 0c             	sub    $0xc,%esp
  8029ac:	50                   	push   %eax
  8029ad:	e8 bd f1 ff ff       	call   801b6f <sbrk>
  8029b2:	83 c4 10             	add    $0x10,%esp
  8029b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if (oldBreak == (void*)-1) {
  8029b8:	83 7d d0 ff          	cmpl   $0xffffffff,-0x30(%ebp)
  8029bc:	75 0a                	jne    8029c8 <alloc_block_FF+0x328>
		return NULL;
  8029be:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c3:	e9 0d 01 00 00       	jmp    802ad5 <alloc_block_FF+0x435>
	}
	//uint32* endBlock = (uint32*)(daStart + initSizeOfAllocatedSpace - 4);

	uint32* endBlk = (uint32 *)((char *)oldBreak - 4);
  8029c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8029cb:	83 e8 04             	sub    $0x4,%eax
  8029ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
	//endBlk = endBlk+(char *) ROUNDUP(totalSize, PAGE_SIZE);

	endBlk = endBlk + (ROUNDUP(totalSize, PAGE_SIZE) / sizeof(uint32));
  8029d1:	c7 45 c8 00 10 00 00 	movl   $0x1000,-0x38(%ebp)
  8029d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8029db:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8029de:	01 d0                	add    %edx,%eax
  8029e0:	48                   	dec    %eax
  8029e1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8029e4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8029ec:	f7 75 c8             	divl   -0x38(%ebp)
  8029ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8029f2:	29 d0                	sub    %edx,%eax
  8029f4:	c1 e8 02             	shr    $0x2,%eax
  8029f7:	c1 e0 02             	shl    $0x2,%eax
  8029fa:	01 45 cc             	add    %eax,-0x34(%ebp)
	*endBlk = 0 | 1;
  8029fd:	8b 45 cc             	mov    -0x34(%ebp),%eax
  802a00:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	uint32 *footerLast = ((uint32*)oldBreak - 2);
  802a06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a09:	83 e8 08             	sub    $0x8,%eax
  802a0c:	89 45 c0             	mov    %eax,-0x40(%ebp)
	uint32 lastSize = (*footerLast) & ~(0x1);
  802a0f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	83 e0 fe             	and    $0xfffffffe,%eax
  802a17:	89 45 bc             	mov    %eax,-0x44(%ebp)
	// the last block for the block that we want to free it
	struct BlockElement *laskBlk = (struct BlockElement *)((char*)oldBreak - lastSize);
  802a1a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a1d:	f7 d8                	neg    %eax
  802a1f:	89 c2                	mov    %eax,%edx
  802a21:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802a24:	01 d0                	add    %edx,%eax
  802a26:	89 45 b8             	mov    %eax,-0x48(%ebp)
	uint32 isLastFree = is_free_block(laskBlk);
  802a29:	83 ec 0c             	sub    $0xc,%esp
  802a2c:	ff 75 b8             	pushl  -0x48(%ebp)
  802a2f:	e8 1f f8 ff ff       	call   802253 <is_free_block>
  802a34:	83 c4 10             	add    $0x10,%esp
  802a37:	0f be c0             	movsbl %al,%eax
  802a3a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(isLastFree)
  802a3d:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  802a41:	74 42                	je     802a85 <alloc_block_FF+0x3e5>
	{
		// merge the block will be free with its prev block
		uint32 newBlkSize = lastSize + ROUNDUP(totalSize, PAGE_SIZE); // size of main block and its prev block
  802a43:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  802a4a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  802a50:	01 d0                	add    %edx,%eax
  802a52:	48                   	dec    %eax
  802a53:	89 45 ac             	mov    %eax,-0x54(%ebp)
  802a56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a59:	ba 00 00 00 00       	mov    $0x0,%edx
  802a5e:	f7 75 b0             	divl   -0x50(%ebp)
  802a61:	8b 45 ac             	mov    -0x54(%ebp),%eax
  802a64:	29 d0                	sub    %edx,%eax
  802a66:	89 c2                	mov    %eax,%edx
  802a68:	8b 45 bc             	mov    -0x44(%ebp),%eax
  802a6b:	01 d0                	add    %edx,%eax
  802a6d:	89 45 a8             	mov    %eax,-0x58(%ebp)
		// extends last block size to contain its size and the size of new space
		set_block_data(laskBlk,newBlkSize,0);
  802a70:	83 ec 04             	sub    $0x4,%esp
  802a73:	6a 00                	push   $0x0
  802a75:	ff 75 a8             	pushl  -0x58(%ebp)
  802a78:	ff 75 b8             	pushl  -0x48(%ebp)
  802a7b:	e8 36 fa ff ff       	call   8024b6 <set_block_data>
  802a80:	83 c4 10             	add    $0x10,%esp
  802a83:	eb 42                	jmp    802ac7 <alloc_block_FF+0x427>
	}
	else
	{
		set_block_data(oldBreak,ROUNDUP(totalSize, PAGE_SIZE),0);
  802a85:	c7 45 a4 00 10 00 00 	movl   $0x1000,-0x5c(%ebp)
  802a8c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  802a8f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  802a92:	01 d0                	add    %edx,%eax
  802a94:	48                   	dec    %eax
  802a95:	89 45 a0             	mov    %eax,-0x60(%ebp)
  802a98:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  802aa0:	f7 75 a4             	divl   -0x5c(%ebp)
  802aa3:	8b 45 a0             	mov    -0x60(%ebp),%eax
  802aa6:	29 d0                	sub    %edx,%eax
  802aa8:	83 ec 04             	sub    $0x4,%esp
  802aab:	6a 00                	push   $0x0
  802aad:	50                   	push   %eax
  802aae:	ff 75 d0             	pushl  -0x30(%ebp)
  802ab1:	e8 00 fa ff ff       	call   8024b6 <set_block_data>
  802ab6:	83 c4 10             	add    $0x10,%esp
		insert_sorted_in_freeList((struct BlockElement *)oldBreak);
  802ab9:	83 ec 0c             	sub    $0xc,%esp
  802abc:	ff 75 d0             	pushl  -0x30(%ebp)
  802abf:	e8 49 fa ff ff       	call   80250d <insert_sorted_in_freeList>
  802ac4:	83 c4 10             	add    $0x10,%esp
//		LIST_INSERT_TAIL(&freeBlocksList,newBreak);
	}
//	set_block_data((struct BlockElement *)newBreak, totalSize, 1);
	return alloc_block_FF(size);
  802ac7:	83 ec 0c             	sub    $0xc,%esp
  802aca:	ff 75 08             	pushl  0x8(%ebp)
  802acd:	e8 ce fb ff ff       	call   8026a0 <alloc_block_FF>
  802ad2:	83 c4 10             	add    $0x10,%esp
}
  802ad5:	c9                   	leave  
  802ad6:	c3                   	ret    

00802ad7 <alloc_block_BF>:
//=========================================
// [4] ALLOCATE BLOCK BY BEST FIT:
//=========================================
void *alloc_block_BF(uint32 size)
{
  802ad7:	55                   	push   %ebp
  802ad8:	89 e5                	mov    %esp,%ebp
  802ada:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT'24.MS1 - BONUS] [3] DYNAMIC ALLOCATOR - alloc_block_BF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("alloc_block_BF is not implemented yet");
	//Your Code is Here...
	if(size == 0)
  802add:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae1:	75 0a                	jne    802aed <alloc_block_BF+0x16>
	{
		return NULL;
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	e9 7a 02 00 00       	jmp    802d67 <alloc_block_BF+0x290>
	}
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	83 c0 08             	add    $0x8,%eax
  802af3:	89 45 e8             	mov    %eax,-0x18(%ebp)

	struct BlockElement *minBlk= NULL;
  802af6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 minSize = 0xfffffff; // a large number
  802afd:	c7 45 f0 ff ff ff 0f 	movl   $0xfffffff,-0x10(%ebp)
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802b04:	a1 48 40 98 00       	mov    0x984048,%eax
  802b09:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b0c:	eb 32                	jmp    802b40 <alloc_block_BF+0x69>
	{
		uint32 blockSize = get_block_size(block);
  802b0e:	ff 75 ec             	pushl  -0x14(%ebp)
  802b11:	e8 24 f7 ff ff       	call   80223a <get_block_size>
  802b16:	83 c4 04             	add    $0x4,%esp
  802b19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		// if this block can take the new block and its size < min size of all blocks
		if(blockSize >= totalSize && blockSize < minSize)
  802b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b1f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802b22:	72 14                	jb     802b38 <alloc_block_BF+0x61>
  802b24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b27:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b2a:	73 0c                	jae    802b38 <alloc_block_BF+0x61>
		{
			minBlk = block;
  802b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
			minSize = blockSize;
  802b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 totalSize = size + 2*sizeof(uint32); // size + size of header and footer

	struct BlockElement *minBlk= NULL;
	uint32 minSize = 0xfffffff; // a large number
	struct BlockElement *block;
	LIST_FOREACH(block, &(freeBlocksList))
  802b38:	a1 50 40 98 00       	mov    0x984050,%eax
  802b3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b44:	74 07                	je     802b4d <alloc_block_BF+0x76>
  802b46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b49:	8b 00                	mov    (%eax),%eax
  802b4b:	eb 05                	jmp    802b52 <alloc_block_BF+0x7b>
  802b4d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b52:	a3 50 40 98 00       	mov    %eax,0x984050
  802b57:	a1 50 40 98 00       	mov    0x984050,%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	75 ae                	jne    802b0e <alloc_block_BF+0x37>
  802b60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b64:	75 a8                	jne    802b0e <alloc_block_BF+0x37>
			minSize = blockSize;
		}
	}

	// if we don't find any enough space to allocate the block
	if(minBlk == NULL)
  802b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6a:	75 22                	jne    802b8e <alloc_block_BF+0xb7>
	{
		void *newBlock = sbrk(totalSize);
  802b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6f:	83 ec 0c             	sub    $0xc,%esp
  802b72:	50                   	push   %eax
  802b73:	e8 f7 ef ff ff       	call   801b6f <sbrk>
  802b78:	83 c4 10             	add    $0x10,%esp
  802b7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (newBlock == (void*)-1) {
  802b7e:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
  802b82:	75 0a                	jne    802b8e <alloc_block_BF+0xb7>
			return NULL;
  802b84:	b8 00 00 00 00       	mov    $0x0,%eax
  802b89:	e9 d9 01 00 00       	jmp    802d67 <alloc_block_BF+0x290>
		}
	}

	//if we can put another block with min size 16
	if(minSize >= totalSize + 4*sizeof(uint32))
  802b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b91:	83 c0 10             	add    $0x10,%eax
  802b94:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802b97:	0f 87 32 01 00 00    	ja     802ccf <alloc_block_BF+0x1f8>
	{
		// the size that will remain from the block that we will allocate a new block in it
		uint32 remainingSize= minSize - totalSize;
  802b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba0:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ba3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		// the remaining free space from the block that we use to allocate in it
		struct BlockElement *remainingFreeBlock = (struct BlockElement *) ((char *)minBlk + totalSize);
  802ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bac:	01 d0                	add    %edx,%eax
  802bae:	89 45 d8             	mov    %eax,-0x28(%ebp)
		set_block_data(remainingFreeBlock, remainingSize, 0);
  802bb1:	83 ec 04             	sub    $0x4,%esp
  802bb4:	6a 00                	push   $0x0
  802bb6:	ff 75 dc             	pushl  -0x24(%ebp)
  802bb9:	ff 75 d8             	pushl  -0x28(%ebp)
  802bbc:	e8 f5 f8 ff ff       	call   8024b6 <set_block_data>
  802bc1:	83 c4 10             	add    $0x10,%esp
		// add it after the block we allocated to be sorted by addresses
		LIST_INSERT_AFTER(&freeBlocksList, minBlk,remainingFreeBlock);
  802bc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc8:	74 06                	je     802bd0 <alloc_block_BF+0xf9>
  802bca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802bce:	75 17                	jne    802be7 <alloc_block_BF+0x110>
  802bd0:	83 ec 04             	sub    $0x4,%esp
  802bd3:	68 2c 3f 80 00       	push   $0x803f2c
  802bd8:	68 49 01 00 00       	push   $0x149
  802bdd:	68 b7 3e 80 00       	push   $0x803eb7
  802be2:	e8 9f ed ff ff       	call   801986 <_panic>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 10                	mov    (%eax),%edx
  802bec:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bef:	89 10                	mov    %edx,(%eax)
  802bf1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 0b                	je     802c05 <alloc_block_BF+0x12e>
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c02:	89 50 04             	mov    %edx,0x4(%eax)
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802c0b:	89 10                	mov    %edx,(%eax)
  802c0d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c13:	89 50 04             	mov    %edx,0x4(%eax)
  802c16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c19:	8b 00                	mov    (%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	75 08                	jne    802c27 <alloc_block_BF+0x150>
  802c1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802c22:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802c27:	a1 54 40 98 00       	mov    0x984054,%eax
  802c2c:	40                   	inc    %eax
  802c2d:	a3 54 40 98 00       	mov    %eax,0x984054

		// update the allocated block and remove it from freeBlocksList
		set_block_data(minBlk,totalSize,1);
  802c32:	83 ec 04             	sub    $0x4,%esp
  802c35:	6a 01                	push   $0x1
  802c37:	ff 75 e8             	pushl  -0x18(%ebp)
  802c3a:	ff 75 f4             	pushl  -0xc(%ebp)
  802c3d:	e8 74 f8 ff ff       	call   8024b6 <set_block_data>
  802c42:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802c45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c49:	75 17                	jne    802c62 <alloc_block_BF+0x18b>
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	68 60 3f 80 00       	push   $0x803f60
  802c53:	68 4e 01 00 00       	push   $0x14e
  802c58:	68 b7 3e 80 00       	push   $0x803eb7
  802c5d:	e8 24 ed ff ff       	call   801986 <_panic>
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 10                	je     802c7b <alloc_block_BF+0x1a4>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c73:	8b 52 04             	mov    0x4(%edx),%edx
  802c76:	89 50 04             	mov    %edx,0x4(%eax)
  802c79:	eb 0b                	jmp    802c86 <alloc_block_BF+0x1af>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 40 04             	mov    0x4(%eax),%eax
  802c81:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0f                	je     802c9f <alloc_block_BF+0x1c8>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c99:	8b 12                	mov    (%edx),%edx
  802c9b:	89 10                	mov    %edx,(%eax)
  802c9d:	eb 0a                	jmp    802ca9 <alloc_block_BF+0x1d2>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	a3 48 40 98 00       	mov    %eax,0x984048
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbc:	a1 54 40 98 00       	mov    0x984054,%eax
  802cc1:	48                   	dec    %eax
  802cc2:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	e9 98 00 00 00       	jmp    802d67 <alloc_block_BF+0x290>
	}
	else // if set internal fragmentation
	{
		// add the remaining size to the block we allocate so it will be the same main block size
		set_block_data(minBlk,minSize,1);
  802ccf:	83 ec 04             	sub    $0x4,%esp
  802cd2:	6a 01                	push   $0x1
  802cd4:	ff 75 f0             	pushl  -0x10(%ebp)
  802cd7:	ff 75 f4             	pushl  -0xc(%ebp)
  802cda:	e8 d7 f7 ff ff       	call   8024b6 <set_block_data>
  802cdf:	83 c4 10             	add    $0x10,%esp
		// remove the block we allocated from the freeList because it is now allocated.
		LIST_REMOVE(&freeBlocksList, minBlk);
  802ce2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce6:	75 17                	jne    802cff <alloc_block_BF+0x228>
  802ce8:	83 ec 04             	sub    $0x4,%esp
  802ceb:	68 60 3f 80 00       	push   $0x803f60
  802cf0:	68 56 01 00 00       	push   $0x156
  802cf5:	68 b7 3e 80 00       	push   $0x803eb7
  802cfa:	e8 87 ec ff ff       	call   801986 <_panic>
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	85 c0                	test   %eax,%eax
  802d06:	74 10                	je     802d18 <alloc_block_BF+0x241>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d10:	8b 52 04             	mov    0x4(%edx),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 0b                	jmp    802d23 <alloc_block_BF+0x24c>
  802d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1b:	8b 40 04             	mov    0x4(%eax),%eax
  802d1e:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 40 04             	mov    0x4(%eax),%eax
  802d29:	85 c0                	test   %eax,%eax
  802d2b:	74 0f                	je     802d3c <alloc_block_BF+0x265>
  802d2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d30:	8b 40 04             	mov    0x4(%eax),%eax
  802d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d36:	8b 12                	mov    (%edx),%edx
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	eb 0a                	jmp    802d46 <alloc_block_BF+0x26f>
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	a3 48 40 98 00       	mov    %eax,0x984048
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d59:	a1 54 40 98 00       	mov    0x984054,%eax
  802d5e:	48                   	dec    %eax
  802d5f:	a3 54 40 98 00       	mov    %eax,0x984054
		return (void*)((uint32*)minBlk);
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
	}
	return NULL;
}
  802d67:	c9                   	leave  
  802d68:	c3                   	ret    

00802d69 <free_block>:
//===================================================
// [5] FREE BLOCK WITH COALESCING:
//===================================================
void free_block(void *va)
{
  802d69:	55                   	push   %ebp
  802d6a:	89 e5                	mov    %esp,%ebp
  802d6c:	83 ec 48             	sub    $0x48,%esp
	//TODO: [PROJECT'24.MS1 - #07] [3] DYNAMIC ALLOCATOR - free_block
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
  802d6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d73:	0f 84 6a 02 00 00    	je     802fe3 <free_block+0x27a>
	{
		return;
	}

	uint32 freeSize = get_block_size(va);
  802d79:	ff 75 08             	pushl  0x8(%ebp)
  802d7c:	e8 b9 f4 ff ff       	call   80223a <get_block_size>
  802d81:	83 c4 04             	add    $0x4,%esp
  802d84:	89 45 f4             	mov    %eax,-0xc(%ebp)

	// footer for the prev block for the block that we want to free it
	uint32 *footerPrev = ((uint32*)va - 2 );
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	83 e8 08             	sub    $0x8,%eax
  802d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 pSize = (*footerPrev) & ~(0x1);
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	83 e0 fe             	and    $0xfffffffe,%eax
  802d98:	89 45 ec             	mov    %eax,-0x14(%ebp)
	// the prev block for the block that we want to free it
	struct BlockElement * prevBlk = (struct BlockElement *)((char*)va - pSize);
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	f7 d8                	neg    %eax
  802da0:	89 c2                	mov    %eax,%edx
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	01 d0                	add    %edx,%eax
  802da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	uint32 isPrevFree = is_free_block(prevBlk);
  802daa:	ff 75 e8             	pushl  -0x18(%ebp)
  802dad:	e8 a1 f4 ff ff       	call   802253 <is_free_block>
  802db2:	83 c4 04             	add    $0x4,%esp
  802db5:	0f be c0             	movsbl %al,%eax
  802db8:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
  802dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	01 d0                	add    %edx,%eax
  802dc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  802dc6:	ff 75 e0             	pushl  -0x20(%ebp)
  802dc9:	e8 85 f4 ff ff       	call   802253 <is_free_block>
  802dce:	83 c4 04             	add    $0x4,%esp
  802dd1:	0f be c0             	movsbl %al,%eax
  802dd4:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if(isPrevFree == 1 && isNextFree == 0)
  802dd7:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802ddb:	75 34                	jne    802e11 <free_block+0xa8>
  802ddd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  802de1:	75 2e                	jne    802e11 <free_block+0xa8>
	{
		// merge the block will be free with its prev block
		uint32 prevSize = get_block_size(prevBlk);
  802de3:	ff 75 e8             	pushl  -0x18(%ebp)
  802de6:	e8 4f f4 ff ff       	call   80223a <get_block_size>
  802deb:	83 c4 04             	add    $0x4,%esp
  802dee:	89 45 d8             	mov    %eax,-0x28(%ebp)
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
  802df1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802df7:	01 d0                	add    %edx,%eax
  802df9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
  802dfc:	6a 00                	push   $0x0
  802dfe:	ff 75 d4             	pushl  -0x2c(%ebp)
  802e01:	ff 75 e8             	pushl  -0x18(%ebp)
  802e04:	e8 ad f6 ff ff       	call   8024b6 <set_block_data>
  802e09:	83 c4 0c             	add    $0xc,%esp
	// the next block for the block that we want to free it
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + freeSize);
	uint32 isNextFree = is_free_block(nextBlk);

	if(isPrevFree == 1 && isNextFree == 0)
	{
  802e0c:	e9 d3 01 00 00       	jmp    802fe4 <free_block+0x27b>
		uint32 prevSize = get_block_size(prevBlk);
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
  802e11:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802e15:	0f 85 c8 00 00 00    	jne    802ee3 <free_block+0x17a>
  802e1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e1f:	0f 85 be 00 00 00    	jne    802ee3 <free_block+0x17a>
	{
		// merge the block will be free with its next block
		uint32 nextSize = get_block_size(nextBlk);
  802e25:	ff 75 e0             	pushl  -0x20(%ebp)
  802e28:	e8 0d f4 ff ff       	call   80223a <get_block_size>
  802e2d:	83 c4 04             	add    $0x4,%esp
  802e30:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 totalSize = freeSize + nextSize; // size of main block and its next block
  802e33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e36:	8b 45 d0             	mov    -0x30(%ebp),%eax
  802e39:	01 d0                	add    %edx,%eax
  802e3b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		// update the size of block to contain its size and the size of next block
		set_block_data(va,totalSize,0);
  802e3e:	6a 00                	push   $0x0
  802e40:	ff 75 cc             	pushl  -0x34(%ebp)
  802e43:	ff 75 08             	pushl  0x8(%ebp)
  802e46:	e8 6b f6 ff ff       	call   8024b6 <set_block_data>
  802e4b:	83 c4 0c             	add    $0xc,%esp
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
  802e4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e52:	75 17                	jne    802e6b <free_block+0x102>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 60 3f 80 00       	push   $0x803f60
  802e5c:	68 87 01 00 00       	push   $0x187
  802e61:	68 b7 3e 80 00       	push   $0x803eb7
  802e66:	e8 1b eb ff ff       	call   801986 <_panic>
  802e6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 10                	je     802e84 <free_block+0x11b>
  802e74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e7c:	8b 52 04             	mov    0x4(%edx),%edx
  802e7f:	89 50 04             	mov    %edx,0x4(%eax)
  802e82:	eb 0b                	jmp    802e8f <free_block+0x126>
  802e84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e87:	8b 40 04             	mov    0x4(%eax),%eax
  802e8a:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802e8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e92:	8b 40 04             	mov    0x4(%eax),%eax
  802e95:	85 c0                	test   %eax,%eax
  802e97:	74 0f                	je     802ea8 <free_block+0x13f>
  802e99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9c:	8b 40 04             	mov    0x4(%eax),%eax
  802e9f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea2:	8b 12                	mov    (%edx),%edx
  802ea4:	89 10                	mov    %edx,(%eax)
  802ea6:	eb 0a                	jmp    802eb2 <free_block+0x149>
  802ea8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	a3 48 40 98 00       	mov    %eax,0x984048
  802eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eb5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ebe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec5:	a1 54 40 98 00       	mov    0x984054,%eax
  802eca:	48                   	dec    %eax
  802ecb:	a3 54 40 98 00       	mov    %eax,0x984054
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802ed0:	83 ec 0c             	sub    $0xc,%esp
  802ed3:	ff 75 08             	pushl  0x8(%ebp)
  802ed6:	e8 32 f6 ff ff       	call   80250d <insert_sorted_in_freeList>
  802edb:	83 c4 10             	add    $0x10,%esp
		uint32 totalSize = freeSize + prevSize; // size of main block and its prev block
		// extends prev block size to contain its size and the size of main block
		set_block_data(prevBlk,totalSize,0);
	}
	else if(isNextFree == 1 && isPrevFree == 0)
	{
  802ede:	e9 01 01 00 00       	jmp    802fe4 <free_block+0x27b>
		// remove next block because we merge it with its prev block
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
  802ee3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  802ee7:	0f 85 d3 00 00 00    	jne    802fc0 <free_block+0x257>
  802eed:	83 7d dc 01          	cmpl   $0x1,-0x24(%ebp)
  802ef1:	0f 85 c9 00 00 00    	jne    802fc0 <free_block+0x257>
	{
		// merge the block will be free with its prev and next blocks
		uint32 prevSize = get_block_size(prevBlk);
  802ef7:	83 ec 0c             	sub    $0xc,%esp
  802efa:	ff 75 e8             	pushl  -0x18(%ebp)
  802efd:	e8 38 f3 ff ff       	call   80223a <get_block_size>
  802f02:	83 c4 10             	add    $0x10,%esp
  802f05:	89 45 c8             	mov    %eax,-0x38(%ebp)
		uint32 nextSize = get_block_size(nextBlk);
  802f08:	83 ec 0c             	sub    $0xc,%esp
  802f0b:	ff 75 e0             	pushl  -0x20(%ebp)
  802f0e:	e8 27 f3 ff ff       	call   80223a <get_block_size>
  802f13:	83 c4 10             	add    $0x10,%esp
  802f16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		uint32 totalSize = freeSize + prevSize + nextSize; // size of main block and its prev and next blocks
  802f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  802f1f:	01 c2                	add    %eax,%edx
  802f21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  802f24:	01 d0                	add    %edx,%eax
  802f26:	89 45 c0             	mov    %eax,-0x40(%ebp)
		// extends prev block size to contain its size and the size of main and next blocks
		set_block_data(prevBlk,totalSize,0);
  802f29:	83 ec 04             	sub    $0x4,%esp
  802f2c:	6a 00                	push   $0x0
  802f2e:	ff 75 c0             	pushl  -0x40(%ebp)
  802f31:	ff 75 e8             	pushl  -0x18(%ebp)
  802f34:	e8 7d f5 ff ff       	call   8024b6 <set_block_data>
  802f39:	83 c4 10             	add    $0x10,%esp
		// remove next block because we merge it with its prev blocks
		LIST_REMOVE(&freeBlocksList, nextBlk);
  802f3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f40:	75 17                	jne    802f59 <free_block+0x1f0>
  802f42:	83 ec 04             	sub    $0x4,%esp
  802f45:	68 60 3f 80 00       	push   $0x803f60
  802f4a:	68 94 01 00 00       	push   $0x194
  802f4f:	68 b7 3e 80 00       	push   $0x803eb7
  802f54:	e8 2d ea ff ff       	call   801986 <_panic>
  802f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 10                	je     802f72 <free_block+0x209>
  802f62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f65:	8b 00                	mov    (%eax),%eax
  802f67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6a:	8b 52 04             	mov    0x4(%edx),%edx
  802f6d:	89 50 04             	mov    %edx,0x4(%eax)
  802f70:	eb 0b                	jmp    802f7d <free_block+0x214>
  802f72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f75:	8b 40 04             	mov    0x4(%eax),%eax
  802f78:	a3 4c 40 98 00       	mov    %eax,0x98404c
  802f7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f80:	8b 40 04             	mov    0x4(%eax),%eax
  802f83:	85 c0                	test   %eax,%eax
  802f85:	74 0f                	je     802f96 <free_block+0x22d>
  802f87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8a:	8b 40 04             	mov    0x4(%eax),%eax
  802f8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f90:	8b 12                	mov    (%edx),%edx
  802f92:	89 10                	mov    %edx,(%eax)
  802f94:	eb 0a                	jmp    802fa0 <free_block+0x237>
  802f96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	a3 48 40 98 00       	mov    %eax,0x984048
  802fa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb3:	a1 54 40 98 00       	mov    0x984054,%eax
  802fb8:	48                   	dec    %eax
  802fb9:	a3 54 40 98 00       	mov    %eax,0x984054
		LIST_REMOVE(&freeBlocksList,nextBlk);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
	else if(isPrevFree == 1 && isNextFree == 1)
	{
  802fbe:	eb 24                	jmp    802fe4 <free_block+0x27b>
	}
	else
	{
		// free it without any merge
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
  802fc0:	83 ec 04             	sub    $0x4,%esp
  802fc3:	6a 00                	push   $0x0
  802fc5:	ff 75 f4             	pushl  -0xc(%ebp)
  802fc8:	ff 75 08             	pushl  0x8(%ebp)
  802fcb:	e8 e6 f4 ff ff       	call   8024b6 <set_block_data>
  802fd0:	83 c4 10             	add    $0x10,%esp
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
  802fd3:	83 ec 0c             	sub    $0xc,%esp
  802fd6:	ff 75 08             	pushl  0x8(%ebp)
  802fd9:	e8 2f f5 ff ff       	call   80250d <insert_sorted_in_freeList>
  802fde:	83 c4 10             	add    $0x10,%esp
  802fe1:	eb 01                	jmp    802fe4 <free_block+0x27b>
	//panic("free_block is not implemented yet");
	//Your Code is Here...

	if(va == NULL)
	{
		return;
  802fe3:	90                   	nop
		// edit its allocation lsb
		set_block_data(va,freeSize,0);
		// add main block to the freeList because it is free now
		insert_sorted_in_freeList((struct BlockElement *)va);
	}
}
  802fe4:	c9                   	leave  
  802fe5:	c3                   	ret    

00802fe6 <realloc_block_FF>:
//=========================================
// [6] REALLOCATE BLOCK BY FIRST FIT:
//=========================================
void *realloc_block_FF(void* va, uint32 new_size)
{
  802fe6:	55                   	push   %ebp
  802fe7:	89 e5                	mov    %esp,%ebp
  802fe9:	83 ec 38             	sub    $0x38,%esp
	//TODO: [PROJECT'24.MS1 - #08] [3] DYNAMIC ALLOCATOR - realloc_block_FF
	//COMMENT THE FOLLOWING LINE BEFORE START CODING
	//panic("realloc_block_FF is not implemented yet");
	//Your Code is Here...

	if(va == NULL && new_size == 0)
  802fec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff0:	75 10                	jne    803002 <realloc_block_FF+0x1c>
  802ff2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802ff6:	75 0a                	jne    803002 <realloc_block_FF+0x1c>
	{
		return NULL;
  802ff8:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffd:	e9 8b 04 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
	}

	if(new_size == 0)
  803002:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803006:	75 18                	jne    803020 <realloc_block_FF+0x3a>
	{
		free_block(va);
  803008:	83 ec 0c             	sub    $0xc,%esp
  80300b:	ff 75 08             	pushl  0x8(%ebp)
  80300e:	e8 56 fd ff ff       	call   802d69 <free_block>
  803013:	83 c4 10             	add    $0x10,%esp
		return NULL;
  803016:	b8 00 00 00 00       	mov    $0x0,%eax
  80301b:	e9 6d 04 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
	}

	if(va == NULL)
  803020:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803024:	75 13                	jne    803039 <realloc_block_FF+0x53>
	{
		return alloc_block_FF(new_size);
  803026:	83 ec 0c             	sub    $0xc,%esp
  803029:	ff 75 0c             	pushl  0xc(%ebp)
  80302c:	e8 6f f6 ff ff       	call   8026a0 <alloc_block_FF>
  803031:	83 c4 10             	add    $0x10,%esp
  803034:	e9 54 04 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
	}

	// if size is odd must be increment it by one
	if (new_size % 2 != 0)
  803039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80303c:	83 e0 01             	and    $0x1,%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	74 03                	je     803046 <realloc_block_FF+0x60>
	{
		new_size++;
  803043:	ff 45 0c             	incl   0xc(%ebp)
	}

	// if size < 8 must be equal it to 8 because min size 8 excluding metadata
	if(new_size < 8)
  803046:	83 7d 0c 07          	cmpl   $0x7,0xc(%ebp)
  80304a:	77 07                	ja     803053 <realloc_block_FF+0x6d>
	{
		new_size = 8;
  80304c:	c7 45 0c 08 00 00 00 	movl   $0x8,0xc(%ebp)
	}

	new_size += 8; // adds its footer and header size
  803053:	83 45 0c 08          	addl   $0x8,0xc(%ebp)

	uint32 actualSize = get_block_size(va);
  803057:	83 ec 0c             	sub    $0xc,%esp
  80305a:	ff 75 08             	pushl  0x8(%ebp)
  80305d:	e8 d8 f1 ff ff       	call   80223a <get_block_size>
  803062:	83 c4 10             	add    $0x10,%esp
  803065:	89 45 f4             	mov    %eax,-0xc(%ebp)

	if(actualSize == new_size)
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80306e:	75 08                	jne    803078 <realloc_block_FF+0x92>
	{
		// don't change any thing
		return va;
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	e9 15 04 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
	}

	// next block for the block we want to change its size
	struct BlockElement *nextBlk = (struct BlockElement *)((char *)va + actualSize);
  803078:	8b 55 08             	mov    0x8(%ebp),%edx
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	01 d0                	add    %edx,%eax
  803080:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 isNextFree = is_free_block(nextBlk);
  803083:	83 ec 0c             	sub    $0xc,%esp
  803086:	ff 75 f0             	pushl  -0x10(%ebp)
  803089:	e8 c5 f1 ff ff       	call   802253 <is_free_block>
  80308e:	83 c4 10             	add    $0x10,%esp
  803091:	0f be c0             	movsbl %al,%eax
  803094:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 nextSize = get_block_size(nextBlk);
  803097:	83 ec 0c             	sub    $0xc,%esp
  80309a:	ff 75 f0             	pushl  -0x10(%ebp)
  80309d:	e8 98 f1 ff ff       	call   80223a <get_block_size>
  8030a2:	83 c4 10             	add    $0x10,%esp
  8030a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	// increase the size of block
	if(new_size > actualSize)
  8030a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ab:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8030ae:	0f 86 a7 02 00 00    	jbe    80335b <realloc_block_FF+0x375>
	{
		if(isNextFree)
  8030b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b8:	0f 84 86 02 00 00    	je     803344 <realloc_block_FF+0x35e>
		{
			if(nextSize + actualSize == new_size) // block and nextblock = newSizeBlock
  8030be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	01 d0                	add    %edx,%eax
  8030c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030c9:	0f 85 b2 00 00 00    	jne    803181 <realloc_block_FF+0x19b>
			{
				set_block_data(va,new_size,!(is_free_block(va)));// update size in block
  8030cf:	83 ec 0c             	sub    $0xc,%esp
  8030d2:	ff 75 08             	pushl  0x8(%ebp)
  8030d5:	e8 79 f1 ff ff       	call   802253 <is_free_block>
  8030da:	83 c4 10             	add    $0x10,%esp
  8030dd:	84 c0                	test   %al,%al
  8030df:	0f 94 c0             	sete   %al
  8030e2:	0f b6 c0             	movzbl %al,%eax
  8030e5:	83 ec 04             	sub    $0x4,%esp
  8030e8:	50                   	push   %eax
  8030e9:	ff 75 0c             	pushl  0xc(%ebp)
  8030ec:	ff 75 08             	pushl  0x8(%ebp)
  8030ef:	e8 c2 f3 ff ff       	call   8024b6 <set_block_data>
  8030f4:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);// remove next because it is = zero
  8030f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030fb:	75 17                	jne    803114 <realloc_block_FF+0x12e>
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 60 3f 80 00       	push   $0x803f60
  803105:	68 db 01 00 00       	push   $0x1db
  80310a:	68 b7 3e 80 00       	push   $0x803eb7
  80310f:	e8 72 e8 ff ff       	call   801986 <_panic>
  803114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803117:	8b 00                	mov    (%eax),%eax
  803119:	85 c0                	test   %eax,%eax
  80311b:	74 10                	je     80312d <realloc_block_FF+0x147>
  80311d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803120:	8b 00                	mov    (%eax),%eax
  803122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803125:	8b 52 04             	mov    0x4(%edx),%edx
  803128:	89 50 04             	mov    %edx,0x4(%eax)
  80312b:	eb 0b                	jmp    803138 <realloc_block_FF+0x152>
  80312d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803130:	8b 40 04             	mov    0x4(%eax),%eax
  803133:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	8b 40 04             	mov    0x4(%eax),%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	74 0f                	je     803151 <realloc_block_FF+0x16b>
  803142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803145:	8b 40 04             	mov    0x4(%eax),%eax
  803148:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80314b:	8b 12                	mov    (%edx),%edx
  80314d:	89 10                	mov    %edx,(%eax)
  80314f:	eb 0a                	jmp    80315b <realloc_block_FF+0x175>
  803151:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803154:	8b 00                	mov    (%eax),%eax
  803156:	a3 48 40 98 00       	mov    %eax,0x984048
  80315b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803167:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316e:	a1 54 40 98 00       	mov    0x984054,%eax
  803173:	48                   	dec    %eax
  803174:	a3 54 40 98 00       	mov    %eax,0x984054
				return va;
  803179:	8b 45 08             	mov    0x8(%ebp),%eax
  80317c:	e9 0c 03 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
			}
			else if(nextSize + actualSize > new_size) // new size is less than next and main blocks
  803181:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	01 d0                	add    %edx,%eax
  803189:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80318c:	0f 86 b2 01 00 00    	jbe    803344 <realloc_block_FF+0x35e>
			{
				uint32 requiredSize = new_size - actualSize; // size that we need from the next block
  803192:	8b 45 0c             	mov    0xc(%ebp),%eax
  803195:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803198:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				uint32 remainingNext = nextSize - requiredSize; // size that will remain from the next block after we split it
  80319b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8031a1:	89 45 e0             	mov    %eax,-0x20(%ebp)

				// if next size will not fit another block (internal fragmentation)
				if(remainingNext < 16)
  8031a4:	83 7d e0 0f          	cmpl   $0xf,-0x20(%ebp)
  8031a8:	0f 87 b8 00 00 00    	ja     803266 <realloc_block_FF+0x280>
				{
					// we will take the main size of the block and its next size also
					set_block_data(va,actualSize + nextSize,!(is_free_block(va)));
  8031ae:	83 ec 0c             	sub    $0xc,%esp
  8031b1:	ff 75 08             	pushl  0x8(%ebp)
  8031b4:	e8 9a f0 ff ff       	call   802253 <is_free_block>
  8031b9:	83 c4 10             	add    $0x10,%esp
  8031bc:	84 c0                	test   %al,%al
  8031be:	0f 94 c0             	sete   %al
  8031c1:	0f b6 c0             	movzbl %al,%eax
  8031c4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8031c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031ca:	01 ca                	add    %ecx,%edx
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	50                   	push   %eax
  8031d0:	52                   	push   %edx
  8031d1:	ff 75 08             	pushl  0x8(%ebp)
  8031d4:	e8 dd f2 ff ff       	call   8024b6 <set_block_data>
  8031d9:	83 c4 10             	add    $0x10,%esp
					LIST_REMOVE(&freeBlocksList,nextBlk);
  8031dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8031e0:	75 17                	jne    8031f9 <realloc_block_FF+0x213>
  8031e2:	83 ec 04             	sub    $0x4,%esp
  8031e5:	68 60 3f 80 00       	push   $0x803f60
  8031ea:	68 e8 01 00 00       	push   $0x1e8
  8031ef:	68 b7 3e 80 00       	push   $0x803eb7
  8031f4:	e8 8d e7 ff ff       	call   801986 <_panic>
  8031f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fc:	8b 00                	mov    (%eax),%eax
  8031fe:	85 c0                	test   %eax,%eax
  803200:	74 10                	je     803212 <realloc_block_FF+0x22c>
  803202:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803205:	8b 00                	mov    (%eax),%eax
  803207:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80320a:	8b 52 04             	mov    0x4(%edx),%edx
  80320d:	89 50 04             	mov    %edx,0x4(%eax)
  803210:	eb 0b                	jmp    80321d <realloc_block_FF+0x237>
  803212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	a3 4c 40 98 00       	mov    %eax,0x98404c
  80321d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803220:	8b 40 04             	mov    0x4(%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 0f                	je     803236 <realloc_block_FF+0x250>
  803227:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322a:	8b 40 04             	mov    0x4(%eax),%eax
  80322d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803230:	8b 12                	mov    (%edx),%edx
  803232:	89 10                	mov    %edx,(%eax)
  803234:	eb 0a                	jmp    803240 <realloc_block_FF+0x25a>
  803236:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803239:	8b 00                	mov    (%eax),%eax
  80323b:	a3 48 40 98 00       	mov    %eax,0x984048
  803240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803243:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803253:	a1 54 40 98 00       	mov    0x984054,%eax
  803258:	48                   	dec    %eax
  803259:	a3 54 40 98 00       	mov    %eax,0x984054
					return va;
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	e9 27 02 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
				}
				else // if next size can be fit another block (split)
				{
					LIST_REMOVE(&freeBlocksList,nextBlk);
  803266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80326a:	75 17                	jne    803283 <realloc_block_FF+0x29d>
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	68 60 3f 80 00       	push   $0x803f60
  803274:	68 ed 01 00 00       	push   $0x1ed
  803279:	68 b7 3e 80 00       	push   $0x803eb7
  80327e:	e8 03 e7 ff ff       	call   801986 <_panic>
  803283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803286:	8b 00                	mov    (%eax),%eax
  803288:	85 c0                	test   %eax,%eax
  80328a:	74 10                	je     80329c <realloc_block_FF+0x2b6>
  80328c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328f:	8b 00                	mov    (%eax),%eax
  803291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803294:	8b 52 04             	mov    0x4(%edx),%edx
  803297:	89 50 04             	mov    %edx,0x4(%eax)
  80329a:	eb 0b                	jmp    8032a7 <realloc_block_FF+0x2c1>
  80329c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80329f:	8b 40 04             	mov    0x4(%eax),%eax
  8032a2:	a3 4c 40 98 00       	mov    %eax,0x98404c
  8032a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032aa:	8b 40 04             	mov    0x4(%eax),%eax
  8032ad:	85 c0                	test   %eax,%eax
  8032af:	74 0f                	je     8032c0 <realloc_block_FF+0x2da>
  8032b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b4:	8b 40 04             	mov    0x4(%eax),%eax
  8032b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032ba:	8b 12                	mov    (%edx),%edx
  8032bc:	89 10                	mov    %edx,(%eax)
  8032be:	eb 0a                	jmp    8032ca <realloc_block_FF+0x2e4>
  8032c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c3:	8b 00                	mov    (%eax),%eax
  8032c5:	a3 48 40 98 00       	mov    %eax,0x984048
  8032ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032dd:	a1 54 40 98 00       	mov    0x984054,%eax
  8032e2:	48                   	dec    %eax
  8032e3:	a3 54 40 98 00       	mov    %eax,0x984054
					nextBlk = (struct BlockElement *)((char *)va + new_size); //update nextBlk address
  8032e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032ee:	01 d0                	add    %edx,%eax
  8032f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					set_block_data(nextBlk,remainingNext,0); // update nextBlkSize
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	6a 00                	push   $0x0
  8032f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8032fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8032fe:	e8 b3 f1 ff ff       	call   8024b6 <set_block_data>
  803303:	83 c4 10             	add    $0x10,%esp
					set_block_data(va,new_size,!(is_free_block(va))); // update size of newblock
  803306:	83 ec 0c             	sub    $0xc,%esp
  803309:	ff 75 08             	pushl  0x8(%ebp)
  80330c:	e8 42 ef ff ff       	call   802253 <is_free_block>
  803311:	83 c4 10             	add    $0x10,%esp
  803314:	84 c0                	test   %al,%al
  803316:	0f 94 c0             	sete   %al
  803319:	0f b6 c0             	movzbl %al,%eax
  80331c:	83 ec 04             	sub    $0x4,%esp
  80331f:	50                   	push   %eax
  803320:	ff 75 0c             	pushl  0xc(%ebp)
  803323:	ff 75 08             	pushl  0x8(%ebp)
  803326:	e8 8b f1 ff ff       	call   8024b6 <set_block_data>
  80332b:	83 c4 10             	add    $0x10,%esp
					insert_sorted_in_freeList(nextBlk);
  80332e:	83 ec 0c             	sub    $0xc,%esp
  803331:	ff 75 f0             	pushl  -0x10(%ebp)
  803334:	e8 d4 f1 ff ff       	call   80250d <insert_sorted_in_freeList>
  803339:	83 c4 10             	add    $0x10,%esp
					return va;
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	e9 49 01 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
				}
			}
		}
		// if next block isn't free or not fit the new size
		return alloc_block_FF(new_size - 8);
  803344:	8b 45 0c             	mov    0xc(%ebp),%eax
  803347:	83 e8 08             	sub    $0x8,%eax
  80334a:	83 ec 0c             	sub    $0xc,%esp
  80334d:	50                   	push   %eax
  80334e:	e8 4d f3 ff ff       	call   8026a0 <alloc_block_FF>
  803353:	83 c4 10             	add    $0x10,%esp
  803356:	e9 32 01 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
	}
	else if(new_size < actualSize) // to shrink block
  80335b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80335e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803361:	0f 83 21 01 00 00    	jae    803488 <realloc_block_FF+0x4a2>
	{
		uint32 remainingSize = actualSize - new_size; // size that will remain from the main block after we shrink it
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	2b 45 0c             	sub    0xc(%ebp),%eax
  80336d:	89 45 dc             	mov    %eax,-0x24(%ebp)

		if(remainingSize < 16 && isNextFree == 0) // internal fragmentation
  803370:	83 7d dc 0f          	cmpl   $0xf,-0x24(%ebp)
  803374:	77 0e                	ja     803384 <realloc_block_FF+0x39e>
  803376:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80337a:	75 08                	jne    803384 <realloc_block_FF+0x39e>
		{
			// don't change its size
			return va;
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	e9 09 01 00 00       	jmp    80348d <realloc_block_FF+0x4a7>
		}
		else // remainingSize fit in a new block
		{
			struct BlockElement *mainBlk = (struct BlockElement *)va;
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	89 45 d8             	mov    %eax,-0x28(%ebp)
			// update main block with new size
			set_block_data(mainBlk,new_size,!(is_free_block(va)));
  80338a:	83 ec 0c             	sub    $0xc,%esp
  80338d:	ff 75 08             	pushl  0x8(%ebp)
  803390:	e8 be ee ff ff       	call   802253 <is_free_block>
  803395:	83 c4 10             	add    $0x10,%esp
  803398:	84 c0                	test   %al,%al
  80339a:	0f 94 c0             	sete   %al
  80339d:	0f b6 c0             	movzbl %al,%eax
  8033a0:	83 ec 04             	sub    $0x4,%esp
  8033a3:	50                   	push   %eax
  8033a4:	ff 75 0c             	pushl  0xc(%ebp)
  8033a7:	ff 75 d8             	pushl  -0x28(%ebp)
  8033aa:	e8 07 f1 ff ff       	call   8024b6 <set_block_data>
  8033af:	83 c4 10             	add    $0x10,%esp

			// the blk with remaining size
			struct BlockElement *remainingBlk=(struct BlockElement *)((char*)mainBlk + new_size);
  8033b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b8:	01 d0                	add    %edx,%eax
  8033ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			set_block_data(remainingBlk,remainingSize,0);
  8033bd:	83 ec 04             	sub    $0x4,%esp
  8033c0:	6a 00                	push   $0x0
  8033c2:	ff 75 dc             	pushl  -0x24(%ebp)
  8033c5:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033c8:	e8 e9 f0 ff ff       	call   8024b6 <set_block_data>
  8033cd:	83 c4 10             	add    $0x10,%esp

			if(isNextFree)
  8033d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033d4:	0f 84 9b 00 00 00    	je     803475 <realloc_block_FF+0x48f>
			{
				// merge splited block with its next block
				set_block_data(remainingBlk,(remainingSize + nextSize),0);//merge remaining with its next block
  8033da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8033dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033e0:	01 d0                	add    %edx,%eax
  8033e2:	83 ec 04             	sub    $0x4,%esp
  8033e5:	6a 00                	push   $0x0
  8033e7:	50                   	push   %eax
  8033e8:	ff 75 d4             	pushl  -0x2c(%ebp)
  8033eb:	e8 c6 f0 ff ff       	call   8024b6 <set_block_data>
  8033f0:	83 c4 10             	add    $0x10,%esp
				LIST_REMOVE(&freeBlocksList,nextBlk);
  8033f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8033f7:	75 17                	jne    803410 <realloc_block_FF+0x42a>
  8033f9:	83 ec 04             	sub    $0x4,%esp
  8033fc:	68 60 3f 80 00       	push   $0x803f60
  803401:	68 10 02 00 00       	push   $0x210
  803406:	68 b7 3e 80 00       	push   $0x803eb7
  80340b:	e8 76 e5 ff ff       	call   801986 <_panic>
  803410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803413:	8b 00                	mov    (%eax),%eax
  803415:	85 c0                	test   %eax,%eax
  803417:	74 10                	je     803429 <realloc_block_FF+0x443>
  803419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80341c:	8b 00                	mov    (%eax),%eax
  80341e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803421:	8b 52 04             	mov    0x4(%edx),%edx
  803424:	89 50 04             	mov    %edx,0x4(%eax)
  803427:	eb 0b                	jmp    803434 <realloc_block_FF+0x44e>
  803429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80342c:	8b 40 04             	mov    0x4(%eax),%eax
  80342f:	a3 4c 40 98 00       	mov    %eax,0x98404c
  803434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803437:	8b 40 04             	mov    0x4(%eax),%eax
  80343a:	85 c0                	test   %eax,%eax
  80343c:	74 0f                	je     80344d <realloc_block_FF+0x467>
  80343e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803441:	8b 40 04             	mov    0x4(%eax),%eax
  803444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803447:	8b 12                	mov    (%edx),%edx
  803449:	89 10                	mov    %edx,(%eax)
  80344b:	eb 0a                	jmp    803457 <realloc_block_FF+0x471>
  80344d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803450:	8b 00                	mov    (%eax),%eax
  803452:	a3 48 40 98 00       	mov    %eax,0x984048
  803457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80345a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803463:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346a:	a1 54 40 98 00       	mov    0x984054,%eax
  80346f:	48                   	dec    %eax
  803470:	a3 54 40 98 00       	mov    %eax,0x984054
			}
			insert_sorted_in_freeList(remainingBlk);
  803475:	83 ec 0c             	sub    $0xc,%esp
  803478:	ff 75 d4             	pushl  -0x2c(%ebp)
  80347b:	e8 8d f0 ff ff       	call   80250d <insert_sorted_in_freeList>
  803480:	83 c4 10             	add    $0x10,%esp
			return mainBlk;
  803483:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803486:	eb 05                	jmp    80348d <realloc_block_FF+0x4a7>
		}
	}
	return NULL;
  803488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80348d:	c9                   	leave  
  80348e:	c3                   	ret    

0080348f <alloc_block_WF>:
/*********************************************************************************************/
//=========================================
// [7] ALLOCATE BLOCK BY WORST FIT:
//=========================================
void *alloc_block_WF(uint32 size)
{
  80348f:	55                   	push   %ebp
  803490:	89 e5                	mov    %esp,%ebp
  803492:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_WF is not implemented yet");
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	68 80 3f 80 00       	push   $0x803f80
  80349d:	68 20 02 00 00       	push   $0x220
  8034a2:	68 b7 3e 80 00       	push   $0x803eb7
  8034a7:	e8 da e4 ff ff       	call   801986 <_panic>

008034ac <alloc_block_NF>:
}
//=========================================
// [8] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
void *alloc_block_NF(uint32 size)
{
  8034ac:	55                   	push   %ebp
  8034ad:	89 e5                	mov    %esp,%ebp
  8034af:	83 ec 08             	sub    $0x8,%esp
	panic("alloc_block_NF is not implemented yet");
  8034b2:	83 ec 04             	sub    $0x4,%esp
  8034b5:	68 a8 3f 80 00       	push   $0x803fa8
  8034ba:	68 28 02 00 00       	push   $0x228
  8034bf:	68 b7 3e 80 00       	push   $0x803eb7
  8034c4:	e8 bd e4 ff ff       	call   801986 <_panic>
  8034c9:	66 90                	xchg   %ax,%ax
  8034cb:	90                   	nop

008034cc <__udivdi3>:
  8034cc:	55                   	push   %ebp
  8034cd:	57                   	push   %edi
  8034ce:	56                   	push   %esi
  8034cf:	53                   	push   %ebx
  8034d0:	83 ec 1c             	sub    $0x1c,%esp
  8034d3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034d7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034db:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034e3:	89 ca                	mov    %ecx,%edx
  8034e5:	89 f8                	mov    %edi,%eax
  8034e7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034eb:	85 f6                	test   %esi,%esi
  8034ed:	75 2d                	jne    80351c <__udivdi3+0x50>
  8034ef:	39 cf                	cmp    %ecx,%edi
  8034f1:	77 65                	ja     803558 <__udivdi3+0x8c>
  8034f3:	89 fd                	mov    %edi,%ebp
  8034f5:	85 ff                	test   %edi,%edi
  8034f7:	75 0b                	jne    803504 <__udivdi3+0x38>
  8034f9:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fe:	31 d2                	xor    %edx,%edx
  803500:	f7 f7                	div    %edi
  803502:	89 c5                	mov    %eax,%ebp
  803504:	31 d2                	xor    %edx,%edx
  803506:	89 c8                	mov    %ecx,%eax
  803508:	f7 f5                	div    %ebp
  80350a:	89 c1                	mov    %eax,%ecx
  80350c:	89 d8                	mov    %ebx,%eax
  80350e:	f7 f5                	div    %ebp
  803510:	89 cf                	mov    %ecx,%edi
  803512:	89 fa                	mov    %edi,%edx
  803514:	83 c4 1c             	add    $0x1c,%esp
  803517:	5b                   	pop    %ebx
  803518:	5e                   	pop    %esi
  803519:	5f                   	pop    %edi
  80351a:	5d                   	pop    %ebp
  80351b:	c3                   	ret    
  80351c:	39 ce                	cmp    %ecx,%esi
  80351e:	77 28                	ja     803548 <__udivdi3+0x7c>
  803520:	0f bd fe             	bsr    %esi,%edi
  803523:	83 f7 1f             	xor    $0x1f,%edi
  803526:	75 40                	jne    803568 <__udivdi3+0x9c>
  803528:	39 ce                	cmp    %ecx,%esi
  80352a:	72 0a                	jb     803536 <__udivdi3+0x6a>
  80352c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803530:	0f 87 9e 00 00 00    	ja     8035d4 <__udivdi3+0x108>
  803536:	b8 01 00 00 00       	mov    $0x1,%eax
  80353b:	89 fa                	mov    %edi,%edx
  80353d:	83 c4 1c             	add    $0x1c,%esp
  803540:	5b                   	pop    %ebx
  803541:	5e                   	pop    %esi
  803542:	5f                   	pop    %edi
  803543:	5d                   	pop    %ebp
  803544:	c3                   	ret    
  803545:	8d 76 00             	lea    0x0(%esi),%esi
  803548:	31 ff                	xor    %edi,%edi
  80354a:	31 c0                	xor    %eax,%eax
  80354c:	89 fa                	mov    %edi,%edx
  80354e:	83 c4 1c             	add    $0x1c,%esp
  803551:	5b                   	pop    %ebx
  803552:	5e                   	pop    %esi
  803553:	5f                   	pop    %edi
  803554:	5d                   	pop    %ebp
  803555:	c3                   	ret    
  803556:	66 90                	xchg   %ax,%ax
  803558:	89 d8                	mov    %ebx,%eax
  80355a:	f7 f7                	div    %edi
  80355c:	31 ff                	xor    %edi,%edi
  80355e:	89 fa                	mov    %edi,%edx
  803560:	83 c4 1c             	add    $0x1c,%esp
  803563:	5b                   	pop    %ebx
  803564:	5e                   	pop    %esi
  803565:	5f                   	pop    %edi
  803566:	5d                   	pop    %ebp
  803567:	c3                   	ret    
  803568:	bd 20 00 00 00       	mov    $0x20,%ebp
  80356d:	89 eb                	mov    %ebp,%ebx
  80356f:	29 fb                	sub    %edi,%ebx
  803571:	89 f9                	mov    %edi,%ecx
  803573:	d3 e6                	shl    %cl,%esi
  803575:	89 c5                	mov    %eax,%ebp
  803577:	88 d9                	mov    %bl,%cl
  803579:	d3 ed                	shr    %cl,%ebp
  80357b:	89 e9                	mov    %ebp,%ecx
  80357d:	09 f1                	or     %esi,%ecx
  80357f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803583:	89 f9                	mov    %edi,%ecx
  803585:	d3 e0                	shl    %cl,%eax
  803587:	89 c5                	mov    %eax,%ebp
  803589:	89 d6                	mov    %edx,%esi
  80358b:	88 d9                	mov    %bl,%cl
  80358d:	d3 ee                	shr    %cl,%esi
  80358f:	89 f9                	mov    %edi,%ecx
  803591:	d3 e2                	shl    %cl,%edx
  803593:	8b 44 24 08          	mov    0x8(%esp),%eax
  803597:	88 d9                	mov    %bl,%cl
  803599:	d3 e8                	shr    %cl,%eax
  80359b:	09 c2                	or     %eax,%edx
  80359d:	89 d0                	mov    %edx,%eax
  80359f:	89 f2                	mov    %esi,%edx
  8035a1:	f7 74 24 0c          	divl   0xc(%esp)
  8035a5:	89 d6                	mov    %edx,%esi
  8035a7:	89 c3                	mov    %eax,%ebx
  8035a9:	f7 e5                	mul    %ebp
  8035ab:	39 d6                	cmp    %edx,%esi
  8035ad:	72 19                	jb     8035c8 <__udivdi3+0xfc>
  8035af:	74 0b                	je     8035bc <__udivdi3+0xf0>
  8035b1:	89 d8                	mov    %ebx,%eax
  8035b3:	31 ff                	xor    %edi,%edi
  8035b5:	e9 58 ff ff ff       	jmp    803512 <__udivdi3+0x46>
  8035ba:	66 90                	xchg   %ax,%ax
  8035bc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035c0:	89 f9                	mov    %edi,%ecx
  8035c2:	d3 e2                	shl    %cl,%edx
  8035c4:	39 c2                	cmp    %eax,%edx
  8035c6:	73 e9                	jae    8035b1 <__udivdi3+0xe5>
  8035c8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035cb:	31 ff                	xor    %edi,%edi
  8035cd:	e9 40 ff ff ff       	jmp    803512 <__udivdi3+0x46>
  8035d2:	66 90                	xchg   %ax,%ax
  8035d4:	31 c0                	xor    %eax,%eax
  8035d6:	e9 37 ff ff ff       	jmp    803512 <__udivdi3+0x46>
  8035db:	90                   	nop

008035dc <__umoddi3>:
  8035dc:	55                   	push   %ebp
  8035dd:	57                   	push   %edi
  8035de:	56                   	push   %esi
  8035df:	53                   	push   %ebx
  8035e0:	83 ec 1c             	sub    $0x1c,%esp
  8035e3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035e7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035eb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035ef:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035f7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035fb:	89 f3                	mov    %esi,%ebx
  8035fd:	89 fa                	mov    %edi,%edx
  8035ff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803603:	89 34 24             	mov    %esi,(%esp)
  803606:	85 c0                	test   %eax,%eax
  803608:	75 1a                	jne    803624 <__umoddi3+0x48>
  80360a:	39 f7                	cmp    %esi,%edi
  80360c:	0f 86 a2 00 00 00    	jbe    8036b4 <__umoddi3+0xd8>
  803612:	89 c8                	mov    %ecx,%eax
  803614:	89 f2                	mov    %esi,%edx
  803616:	f7 f7                	div    %edi
  803618:	89 d0                	mov    %edx,%eax
  80361a:	31 d2                	xor    %edx,%edx
  80361c:	83 c4 1c             	add    $0x1c,%esp
  80361f:	5b                   	pop    %ebx
  803620:	5e                   	pop    %esi
  803621:	5f                   	pop    %edi
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    
  803624:	39 f0                	cmp    %esi,%eax
  803626:	0f 87 ac 00 00 00    	ja     8036d8 <__umoddi3+0xfc>
  80362c:	0f bd e8             	bsr    %eax,%ebp
  80362f:	83 f5 1f             	xor    $0x1f,%ebp
  803632:	0f 84 ac 00 00 00    	je     8036e4 <__umoddi3+0x108>
  803638:	bf 20 00 00 00       	mov    $0x20,%edi
  80363d:	29 ef                	sub    %ebp,%edi
  80363f:	89 fe                	mov    %edi,%esi
  803641:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803645:	89 e9                	mov    %ebp,%ecx
  803647:	d3 e0                	shl    %cl,%eax
  803649:	89 d7                	mov    %edx,%edi
  80364b:	89 f1                	mov    %esi,%ecx
  80364d:	d3 ef                	shr    %cl,%edi
  80364f:	09 c7                	or     %eax,%edi
  803651:	89 e9                	mov    %ebp,%ecx
  803653:	d3 e2                	shl    %cl,%edx
  803655:	89 14 24             	mov    %edx,(%esp)
  803658:	89 d8                	mov    %ebx,%eax
  80365a:	d3 e0                	shl    %cl,%eax
  80365c:	89 c2                	mov    %eax,%edx
  80365e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803662:	d3 e0                	shl    %cl,%eax
  803664:	89 44 24 04          	mov    %eax,0x4(%esp)
  803668:	8b 44 24 08          	mov    0x8(%esp),%eax
  80366c:	89 f1                	mov    %esi,%ecx
  80366e:	d3 e8                	shr    %cl,%eax
  803670:	09 d0                	or     %edx,%eax
  803672:	d3 eb                	shr    %cl,%ebx
  803674:	89 da                	mov    %ebx,%edx
  803676:	f7 f7                	div    %edi
  803678:	89 d3                	mov    %edx,%ebx
  80367a:	f7 24 24             	mull   (%esp)
  80367d:	89 c6                	mov    %eax,%esi
  80367f:	89 d1                	mov    %edx,%ecx
  803681:	39 d3                	cmp    %edx,%ebx
  803683:	0f 82 87 00 00 00    	jb     803710 <__umoddi3+0x134>
  803689:	0f 84 91 00 00 00    	je     803720 <__umoddi3+0x144>
  80368f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803693:	29 f2                	sub    %esi,%edx
  803695:	19 cb                	sbb    %ecx,%ebx
  803697:	89 d8                	mov    %ebx,%eax
  803699:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80369d:	d3 e0                	shl    %cl,%eax
  80369f:	89 e9                	mov    %ebp,%ecx
  8036a1:	d3 ea                	shr    %cl,%edx
  8036a3:	09 d0                	or     %edx,%eax
  8036a5:	89 e9                	mov    %ebp,%ecx
  8036a7:	d3 eb                	shr    %cl,%ebx
  8036a9:	89 da                	mov    %ebx,%edx
  8036ab:	83 c4 1c             	add    $0x1c,%esp
  8036ae:	5b                   	pop    %ebx
  8036af:	5e                   	pop    %esi
  8036b0:	5f                   	pop    %edi
  8036b1:	5d                   	pop    %ebp
  8036b2:	c3                   	ret    
  8036b3:	90                   	nop
  8036b4:	89 fd                	mov    %edi,%ebp
  8036b6:	85 ff                	test   %edi,%edi
  8036b8:	75 0b                	jne    8036c5 <__umoddi3+0xe9>
  8036ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8036bf:	31 d2                	xor    %edx,%edx
  8036c1:	f7 f7                	div    %edi
  8036c3:	89 c5                	mov    %eax,%ebp
  8036c5:	89 f0                	mov    %esi,%eax
  8036c7:	31 d2                	xor    %edx,%edx
  8036c9:	f7 f5                	div    %ebp
  8036cb:	89 c8                	mov    %ecx,%eax
  8036cd:	f7 f5                	div    %ebp
  8036cf:	89 d0                	mov    %edx,%eax
  8036d1:	e9 44 ff ff ff       	jmp    80361a <__umoddi3+0x3e>
  8036d6:	66 90                	xchg   %ax,%ax
  8036d8:	89 c8                	mov    %ecx,%eax
  8036da:	89 f2                	mov    %esi,%edx
  8036dc:	83 c4 1c             	add    $0x1c,%esp
  8036df:	5b                   	pop    %ebx
  8036e0:	5e                   	pop    %esi
  8036e1:	5f                   	pop    %edi
  8036e2:	5d                   	pop    %ebp
  8036e3:	c3                   	ret    
  8036e4:	3b 04 24             	cmp    (%esp),%eax
  8036e7:	72 06                	jb     8036ef <__umoddi3+0x113>
  8036e9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036ed:	77 0f                	ja     8036fe <__umoddi3+0x122>
  8036ef:	89 f2                	mov    %esi,%edx
  8036f1:	29 f9                	sub    %edi,%ecx
  8036f3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036f7:	89 14 24             	mov    %edx,(%esp)
  8036fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036fe:	8b 44 24 04          	mov    0x4(%esp),%eax
  803702:	8b 14 24             	mov    (%esp),%edx
  803705:	83 c4 1c             	add    $0x1c,%esp
  803708:	5b                   	pop    %ebx
  803709:	5e                   	pop    %esi
  80370a:	5f                   	pop    %edi
  80370b:	5d                   	pop    %ebp
  80370c:	c3                   	ret    
  80370d:	8d 76 00             	lea    0x0(%esi),%esi
  803710:	2b 04 24             	sub    (%esp),%eax
  803713:	19 fa                	sbb    %edi,%edx
  803715:	89 d1                	mov    %edx,%ecx
  803717:	89 c6                	mov    %eax,%esi
  803719:	e9 71 ff ff ff       	jmp    80368f <__umoddi3+0xb3>
  80371e:	66 90                	xchg   %ax,%ax
  803720:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803724:	72 ea                	jb     803710 <__umoddi3+0x134>
  803726:	89 d9                	mov    %ebx,%ecx
  803728:	e9 62 ff ff ff       	jmp    80368f <__umoddi3+0xb3>
