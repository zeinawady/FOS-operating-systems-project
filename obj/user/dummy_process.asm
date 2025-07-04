
obj/user/dummy_process:     file format elf32-i386


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
  800031:	e8 8d 00 00 00       	call   8000c3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void high_complexity_function();

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 08             	sub    $0x8,%esp
	high_complexity_function() ;
  80003e:	e8 03 00 00 00       	call   800046 <high_complexity_function>
	return;
  800043:	90                   	nop
}
  800044:	c9                   	leave  
  800045:	c3                   	ret    

00800046 <high_complexity_function>:

void high_complexity_function()
{
  800046:	55                   	push   %ebp
  800047:	89 e5                	mov    %esp,%ebp
  800049:	83 ec 38             	sub    $0x38,%esp
	uint32 end1 = RAND(0, 5000);
  80004c:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  80004f:	83 ec 0c             	sub    $0xc,%esp
  800052:	50                   	push   %eax
  800053:	e8 53 13 00 00       	call   8013ab <sys_get_virtual_time>
  800058:	83 c4 0c             	add    $0xc,%esp
  80005b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80005e:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800063:	ba 00 00 00 00       	mov    $0x0,%edx
  800068:	f7 f1                	div    %ecx
  80006a:	89 55 e8             	mov    %edx,-0x18(%ebp)
	uint32 end2 = RAND(0, 5000);
  80006d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	50                   	push   %eax
  800074:	e8 32 13 00 00       	call   8013ab <sys_get_virtual_time>
  800079:	83 c4 0c             	add    $0xc,%esp
  80007c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80007f:	b9 88 13 00 00       	mov    $0x1388,%ecx
  800084:	ba 00 00 00 00       	mov    $0x0,%edx
  800089:	f7 f1                	div    %ecx
  80008b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int x = 10;
  80008e:	c7 45 f4 0a 00 00 00 	movl   $0xa,-0xc(%ebp)
	for(int i = 0; i <= end1; i++)
  800095:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80009c:	eb 1a                	jmp    8000b8 <high_complexity_function+0x72>
	{
		for(int i = 0; i <= end2; i++)
  80009e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8000a5:	eb 06                	jmp    8000ad <high_complexity_function+0x67>
		{
			{
				 x++;
  8000a7:	ff 45 f4             	incl   -0xc(%ebp)
	uint32 end1 = RAND(0, 5000);
	uint32 end2 = RAND(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
	{
		for(int i = 0; i <= end2; i++)
  8000aa:	ff 45 ec             	incl   -0x14(%ebp)
  8000ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000b0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8000b3:	76 f2                	jbe    8000a7 <high_complexity_function+0x61>
void high_complexity_function()
{
	uint32 end1 = RAND(0, 5000);
	uint32 end2 = RAND(0, 5000);
	int x = 10;
	for(int i = 0; i <= end1; i++)
  8000b5:	ff 45 f0             	incl   -0x10(%ebp)
  8000b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000bb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8000be:	76 de                	jbe    80009e <high_complexity_function+0x58>
			{
				 x++;
			}
		}
	}
}
  8000c0:	90                   	nop
  8000c1:	c9                   	leave  
  8000c2:	c3                   	ret    

008000c3 <libmain>:
volatile bool printStats = 1;

volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";
void
libmain(int argc, char **argv)
{
  8000c3:	55                   	push   %ebp
  8000c4:	89 e5                	mov    %esp,%ebp
  8000c6:	83 ec 18             	sub    $0x18,%esp
	//printStats = 1;
	int envIndex = sys_getenvindex();
  8000c9:	e8 91 12 00 00       	call   80135f <sys_getenvindex>
  8000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)

	myEnv = &(envs[envIndex]);
  8000d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8000d4:	89 d0                	mov    %edx,%eax
  8000d6:	c1 e0 02             	shl    $0x2,%eax
  8000d9:	01 d0                	add    %edx,%eax
  8000db:	c1 e0 03             	shl    $0x3,%eax
  8000de:	01 d0                	add    %edx,%eax
  8000e0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8000e7:	01 d0                	add    %edx,%eax
  8000e9:	c1 e0 02             	shl    $0x2,%eax
  8000ec:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000f1:	a3 08 30 80 00       	mov    %eax,0x803008

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8000f6:	a1 08 30 80 00       	mov    0x803008,%eax
  8000fb:	8a 40 20             	mov    0x20(%eax),%al
  8000fe:	84 c0                	test   %al,%al
  800100:	74 0d                	je     80010f <libmain+0x4c>
		binaryname = myEnv->prog_name;
  800102:	a1 08 30 80 00       	mov    0x803008,%eax
  800107:	83 c0 20             	add    $0x20,%eax
  80010a:	a3 04 30 80 00       	mov    %eax,0x803004

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800113:	7e 0a                	jle    80011f <libmain+0x5c>
		binaryname = argv[0];
  800115:	8b 45 0c             	mov    0xc(%ebp),%eax
  800118:	8b 00                	mov    (%eax),%eax
  80011a:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	_main(argc, argv);
  80011f:	83 ec 08             	sub    $0x8,%esp
  800122:	ff 75 0c             	pushl  0xc(%ebp)
  800125:	ff 75 08             	pushl  0x8(%ebp)
  800128:	e8 0b ff ff ff       	call   800038 <_main>
  80012d:	83 c4 10             	add    $0x10,%esp

	if (printStats)
  800130:	a1 00 30 80 00       	mov    0x803000,%eax
  800135:	85 c0                	test   %eax,%eax
  800137:	0f 84 9f 00 00 00    	je     8001dc <libmain+0x119>
	{
		sys_lock_cons();
  80013d:	e8 a1 0f 00 00       	call   8010e3 <sys_lock_cons>
		{
			cprintf("**************************************\n");
  800142:	83 ec 0c             	sub    $0xc,%esp
  800145:	68 78 1b 80 00       	push   $0x801b78
  80014a:	e8 8d 01 00 00       	call   8002dc <cprintf>
  80014f:	83 c4 10             	add    $0x10,%esp
			cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800152:	a1 08 30 80 00       	mov    0x803008,%eax
  800157:	8b 90 a8 05 00 00    	mov    0x5a8(%eax),%edx
  80015d:	a1 08 30 80 00       	mov    0x803008,%eax
  800162:	8b 80 98 05 00 00    	mov    0x598(%eax),%eax
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	52                   	push   %edx
  80016c:	50                   	push   %eax
  80016d:	68 a0 1b 80 00       	push   $0x801ba0
  800172:	e8 65 01 00 00       	call   8002dc <cprintf>
  800177:	83 c4 10             	add    $0x10,%esp
			cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80017a:	a1 08 30 80 00       	mov    0x803008,%eax
  80017f:	8b 88 bc 05 00 00    	mov    0x5bc(%eax),%ecx
  800185:	a1 08 30 80 00       	mov    0x803008,%eax
  80018a:	8b 90 b8 05 00 00    	mov    0x5b8(%eax),%edx
  800190:	a1 08 30 80 00       	mov    0x803008,%eax
  800195:	8b 80 b4 05 00 00    	mov    0x5b4(%eax),%eax
  80019b:	51                   	push   %ecx
  80019c:	52                   	push   %edx
  80019d:	50                   	push   %eax
  80019e:	68 c8 1b 80 00       	push   $0x801bc8
  8001a3:	e8 34 01 00 00       	call   8002dc <cprintf>
  8001a8:	83 c4 10             	add    $0x10,%esp
			//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
			cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001ab:	a1 08 30 80 00       	mov    0x803008,%eax
  8001b0:	8b 80 c0 05 00 00    	mov    0x5c0(%eax),%eax
  8001b6:	83 ec 08             	sub    $0x8,%esp
  8001b9:	50                   	push   %eax
  8001ba:	68 20 1c 80 00       	push   $0x801c20
  8001bf:	e8 18 01 00 00       	call   8002dc <cprintf>
  8001c4:	83 c4 10             	add    $0x10,%esp
			cprintf("**************************************\n");
  8001c7:	83 ec 0c             	sub    $0xc,%esp
  8001ca:	68 78 1b 80 00       	push   $0x801b78
  8001cf:	e8 08 01 00 00       	call   8002dc <cprintf>
  8001d4:	83 c4 10             	add    $0x10,%esp
		}
		sys_unlock_cons();
  8001d7:	e8 21 0f 00 00       	call   8010fd <sys_unlock_cons>
	}

	// exit gracefully
	exit();
  8001dc:	e8 19 00 00 00       	call   8001fa <exit>
}
  8001e1:	90                   	nop
  8001e2:	c9                   	leave  
  8001e3:	c3                   	ret    

008001e4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8001ea:	83 ec 0c             	sub    $0xc,%esp
  8001ed:	6a 00                	push   $0x0
  8001ef:	e8 37 11 00 00       	call   80132b <sys_destroy_env>
  8001f4:	83 c4 10             	add    $0x10,%esp
}
  8001f7:	90                   	nop
  8001f8:	c9                   	leave  
  8001f9:	c3                   	ret    

008001fa <exit>:

void
exit(void)
{
  8001fa:	55                   	push   %ebp
  8001fb:	89 e5                	mov    %esp,%ebp
  8001fd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800200:	e8 8c 11 00 00       	call   801391 <sys_exit_env>
}
  800205:	90                   	nop
  800206:	c9                   	leave  
  800207:	c3                   	ret    

00800208 <putch>:
	int idx; // current buffer index
	int cnt; // total bytes printed so far
	char buf[256];
};

static void putch(int ch, struct printbuf *b) {
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80020e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800211:	8b 00                	mov    (%eax),%eax
  800213:	8d 48 01             	lea    0x1(%eax),%ecx
  800216:	8b 55 0c             	mov    0xc(%ebp),%edx
  800219:	89 0a                	mov    %ecx,(%edx)
  80021b:	8b 55 08             	mov    0x8(%ebp),%edx
  80021e:	88 d1                	mov    %dl,%cl
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	8b 00                	mov    (%eax),%eax
  80022c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800231:	75 2c                	jne    80025f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800233:	a0 0c 30 80 00       	mov    0x80300c,%al
  800238:	0f b6 c0             	movzbl %al,%eax
  80023b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80023e:	8b 12                	mov    (%edx),%edx
  800240:	89 d1                	mov    %edx,%ecx
  800242:	8b 55 0c             	mov    0xc(%ebp),%edx
  800245:	83 c2 08             	add    $0x8,%edx
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	50                   	push   %eax
  80024c:	51                   	push   %ecx
  80024d:	52                   	push   %edx
  80024e:	e8 4e 0e 00 00       	call   8010a1 <sys_cputs>
  800253:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800256:	8b 45 0c             	mov    0xc(%ebp),%eax
  800259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	8b 40 04             	mov    0x4(%eax),%eax
  800265:	8d 50 01             	lea    0x1(%eax),%edx
  800268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80027a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800281:	00 00 00 
	b.cnt = 0;
  800284:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80028b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80029a:	50                   	push   %eax
  80029b:	68 08 02 80 00       	push   $0x800208
  8002a0:	e8 11 02 00 00       	call   8004b6 <vprintfmt>
  8002a5:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8002a8:	a0 0c 30 80 00       	mov    0x80300c,%al
  8002ad:	0f b6 c0             	movzbl %al,%eax
  8002b0:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8002b6:	83 ec 04             	sub    $0x4,%esp
  8002b9:	50                   	push   %eax
  8002ba:	52                   	push   %edx
  8002bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002c1:	83 c0 08             	add    $0x8,%eax
  8002c4:	50                   	push   %eax
  8002c5:	e8 d7 0d 00 00       	call   8010a1 <sys_cputs>
  8002ca:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8002cd:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
	return b.cnt;
  8002d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8002da:	c9                   	leave  
  8002db:	c3                   	ret    

008002dc <cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int cprintf(const char *fmt, ...) {
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8002e2:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
	va_start(ap, fmt);
  8002e9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8002ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f2:	83 ec 08             	sub    $0x8,%esp
  8002f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8002f8:	50                   	push   %eax
  8002f9:	e8 73 ff ff ff       	call   800271 <vcprintf>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800304:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <atomic_cprintf>:

//%@: to print the program name and ID before the message
//%~: to print the message directly
int atomic_cprintf(const char *fmt, ...)
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	83 ec 18             	sub    $0x18,%esp
	int cnt;
	sys_lock_cons();
  80030f:	e8 cf 0d 00 00       	call   8010e3 <sys_lock_cons>
	{
		va_list ap;
		va_start(ap, fmt);
  800314:	8d 45 0c             	lea    0xc(%ebp),%eax
  800317:	89 45 f4             	mov    %eax,-0xc(%ebp)
		cnt = vcprintf(fmt, ap);
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
  80031d:	83 ec 08             	sub    $0x8,%esp
  800320:	ff 75 f4             	pushl  -0xc(%ebp)
  800323:	50                   	push   %eax
  800324:	e8 48 ff ff ff       	call   800271 <vcprintf>
  800329:	83 c4 10             	add    $0x10,%esp
  80032c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		va_end(ap);
	}
	sys_unlock_cons();
  80032f:	e8 c9 0d 00 00       	call   8010fd <sys_unlock_cons>
	return cnt;
  800334:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    

00800339 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	53                   	push   %ebx
  80033d:	83 ec 14             	sub    $0x14,%esp
  800340:	8b 45 10             	mov    0x10(%ebp),%eax
  800343:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800346:	8b 45 14             	mov    0x14(%ebp),%eax
  800349:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80034c:	8b 45 18             	mov    0x18(%ebp),%eax
  80034f:	ba 00 00 00 00       	mov    $0x0,%edx
  800354:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800357:	77 55                	ja     8003ae <printnum+0x75>
  800359:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80035c:	72 05                	jb     800363 <printnum+0x2a>
  80035e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800361:	77 4b                	ja     8003ae <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800363:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800366:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800369:	8b 45 18             	mov    0x18(%ebp),%eax
  80036c:	ba 00 00 00 00       	mov    $0x0,%edx
  800371:	52                   	push   %edx
  800372:	50                   	push   %eax
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	ff 75 f0             	pushl  -0x10(%ebp)
  800379:	e8 7e 15 00 00       	call   8018fc <__udivdi3>
  80037e:	83 c4 10             	add    $0x10,%esp
  800381:	83 ec 04             	sub    $0x4,%esp
  800384:	ff 75 20             	pushl  0x20(%ebp)
  800387:	53                   	push   %ebx
  800388:	ff 75 18             	pushl  0x18(%ebp)
  80038b:	52                   	push   %edx
  80038c:	50                   	push   %eax
  80038d:	ff 75 0c             	pushl  0xc(%ebp)
  800390:	ff 75 08             	pushl  0x8(%ebp)
  800393:	e8 a1 ff ff ff       	call   800339 <printnum>
  800398:	83 c4 20             	add    $0x20,%esp
  80039b:	eb 1a                	jmp    8003b7 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	ff 75 0c             	pushl  0xc(%ebp)
  8003a3:	ff 75 20             	pushl  0x20(%ebp)
  8003a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a9:	ff d0                	call   *%eax
  8003ab:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003ae:	ff 4d 1c             	decl   0x1c(%ebp)
  8003b1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8003b5:	7f e6                	jg     80039d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003b7:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c5:	53                   	push   %ebx
  8003c6:	51                   	push   %ecx
  8003c7:	52                   	push   %edx
  8003c8:	50                   	push   %eax
  8003c9:	e8 3e 16 00 00       	call   801a0c <__umoddi3>
  8003ce:	83 c4 10             	add    $0x10,%esp
  8003d1:	05 54 1e 80 00       	add    $0x801e54,%eax
  8003d6:	8a 00                	mov    (%eax),%al
  8003d8:	0f be c0             	movsbl %al,%eax
  8003db:	83 ec 08             	sub    $0x8,%esp
  8003de:	ff 75 0c             	pushl  0xc(%ebp)
  8003e1:	50                   	push   %eax
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	ff d0                	call   *%eax
  8003e7:	83 c4 10             	add    $0x10,%esp
}
  8003ea:	90                   	nop
  8003eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8003ee:	c9                   	leave  
  8003ef:	c3                   	ret    

008003f0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003f3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8003f7:	7e 1c                	jle    800415 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	8b 00                	mov    (%eax),%eax
  8003fe:	8d 50 08             	lea    0x8(%eax),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	89 10                	mov    %edx,(%eax)
  800406:	8b 45 08             	mov    0x8(%ebp),%eax
  800409:	8b 00                	mov    (%eax),%eax
  80040b:	83 e8 08             	sub    $0x8,%eax
  80040e:	8b 50 04             	mov    0x4(%eax),%edx
  800411:	8b 00                	mov    (%eax),%eax
  800413:	eb 40                	jmp    800455 <getuint+0x65>
	else if (lflag)
  800415:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800419:	74 1e                	je     800439 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	8b 00                	mov    (%eax),%eax
  800420:	8d 50 04             	lea    0x4(%eax),%edx
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	89 10                	mov    %edx,(%eax)
  800428:	8b 45 08             	mov    0x8(%ebp),%eax
  80042b:	8b 00                	mov    (%eax),%eax
  80042d:	83 e8 04             	sub    $0x4,%eax
  800430:	8b 00                	mov    (%eax),%eax
  800432:	ba 00 00 00 00       	mov    $0x0,%edx
  800437:	eb 1c                	jmp    800455 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800439:	8b 45 08             	mov    0x8(%ebp),%eax
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	8d 50 04             	lea    0x4(%eax),%edx
  800441:	8b 45 08             	mov    0x8(%ebp),%eax
  800444:	89 10                	mov    %edx,(%eax)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	83 e8 04             	sub    $0x4,%eax
  80044e:	8b 00                	mov    (%eax),%eax
  800450:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800455:	5d                   	pop    %ebp
  800456:	c3                   	ret    

00800457 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80045a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80045e:	7e 1c                	jle    80047c <getint+0x25>
		return va_arg(*ap, long long);
  800460:	8b 45 08             	mov    0x8(%ebp),%eax
  800463:	8b 00                	mov    (%eax),%eax
  800465:	8d 50 08             	lea    0x8(%eax),%edx
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	89 10                	mov    %edx,(%eax)
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 e8 08             	sub    $0x8,%eax
  800475:	8b 50 04             	mov    0x4(%eax),%edx
  800478:	8b 00                	mov    (%eax),%eax
  80047a:	eb 38                	jmp    8004b4 <getint+0x5d>
	else if (lflag)
  80047c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800480:	74 1a                	je     80049c <getint+0x45>
		return va_arg(*ap, long);
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 00                	mov    (%eax),%eax
  800487:	8d 50 04             	lea    0x4(%eax),%edx
  80048a:	8b 45 08             	mov    0x8(%ebp),%eax
  80048d:	89 10                	mov    %edx,(%eax)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	83 e8 04             	sub    $0x4,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	99                   	cltd   
  80049a:	eb 18                	jmp    8004b4 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 50 04             	lea    0x4(%eax),%edx
  8004a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a7:	89 10                	mov    %edx,(%eax)
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	8b 00                	mov    (%eax),%eax
  8004ae:	83 e8 04             	sub    $0x4,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	99                   	cltd   
}
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	56                   	push   %esi
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004be:	eb 17                	jmp    8004d7 <vprintfmt+0x21>
			if (ch == '\0')
  8004c0:	85 db                	test   %ebx,%ebx
  8004c2:	0f 84 c1 03 00 00    	je     800889 <vprintfmt+0x3d3>
				return;
			putch(ch, putdat);
  8004c8:	83 ec 08             	sub    $0x8,%esp
  8004cb:	ff 75 0c             	pushl  0xc(%ebp)
  8004ce:	53                   	push   %ebx
  8004cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d2:	ff d0                	call   *%eax
  8004d4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004da:	8d 50 01             	lea    0x1(%eax),%edx
  8004dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8004e0:	8a 00                	mov    (%eax),%al
  8004e2:	0f b6 d8             	movzbl %al,%ebx
  8004e5:	83 fb 25             	cmp    $0x25,%ebx
  8004e8:	75 d6                	jne    8004c0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8004ea:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8004ee:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8004f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8004fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800503:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	8b 45 10             	mov    0x10(%ebp),%eax
  80050d:	8d 50 01             	lea    0x1(%eax),%edx
  800510:	89 55 10             	mov    %edx,0x10(%ebp)
  800513:	8a 00                	mov    (%eax),%al
  800515:	0f b6 d8             	movzbl %al,%ebx
  800518:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80051b:	83 f8 5b             	cmp    $0x5b,%eax
  80051e:	0f 87 3d 03 00 00    	ja     800861 <vprintfmt+0x3ab>
  800524:	8b 04 85 78 1e 80 00 	mov    0x801e78(,%eax,4),%eax
  80052b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80052d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800531:	eb d7                	jmp    80050a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800533:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800537:	eb d1                	jmp    80050a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800539:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800540:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800543:	89 d0                	mov    %edx,%eax
  800545:	c1 e0 02             	shl    $0x2,%eax
  800548:	01 d0                	add    %edx,%eax
  80054a:	01 c0                	add    %eax,%eax
  80054c:	01 d8                	add    %ebx,%eax
  80054e:	83 e8 30             	sub    $0x30,%eax
  800551:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800554:	8b 45 10             	mov    0x10(%ebp),%eax
  800557:	8a 00                	mov    (%eax),%al
  800559:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80055c:	83 fb 2f             	cmp    $0x2f,%ebx
  80055f:	7e 3e                	jle    80059f <vprintfmt+0xe9>
  800561:	83 fb 39             	cmp    $0x39,%ebx
  800564:	7f 39                	jg     80059f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800566:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800569:	eb d5                	jmp    800540 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80056b:	8b 45 14             	mov    0x14(%ebp),%eax
  80056e:	83 c0 04             	add    $0x4,%eax
  800571:	89 45 14             	mov    %eax,0x14(%ebp)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	83 e8 04             	sub    $0x4,%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80057f:	eb 1f                	jmp    8005a0 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800581:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800585:	79 83                	jns    80050a <vprintfmt+0x54>
				width = 0;
  800587:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80058e:	e9 77 ff ff ff       	jmp    80050a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800593:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80059a:	e9 6b ff ff ff       	jmp    80050a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80059f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005a4:	0f 89 60 ff ff ff    	jns    80050a <vprintfmt+0x54>
				width = precision, precision = -1;
  8005aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005b0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8005b7:	e9 4e ff ff ff       	jmp    80050a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005bc:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8005bf:	e9 46 ff ff ff       	jmp    80050a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c7:	83 c0 04             	add    $0x4,%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
  8005cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d0:	83 e8 04             	sub    $0x4,%eax
  8005d3:	8b 00                	mov    (%eax),%eax
  8005d5:	83 ec 08             	sub    $0x8,%esp
  8005d8:	ff 75 0c             	pushl  0xc(%ebp)
  8005db:	50                   	push   %eax
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	ff d0                	call   *%eax
  8005e1:	83 c4 10             	add    $0x10,%esp
			break;
  8005e4:	e9 9b 02 00 00       	jmp    800884 <vprintfmt+0x3ce>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	83 c0 04             	add    $0x4,%eax
  8005ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	83 e8 04             	sub    $0x4,%eax
  8005f8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8005fa:	85 db                	test   %ebx,%ebx
  8005fc:	79 02                	jns    800600 <vprintfmt+0x14a>
				err = -err;
  8005fe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800600:	83 fb 64             	cmp    $0x64,%ebx
  800603:	7f 0b                	jg     800610 <vprintfmt+0x15a>
  800605:	8b 34 9d c0 1c 80 00 	mov    0x801cc0(,%ebx,4),%esi
  80060c:	85 f6                	test   %esi,%esi
  80060e:	75 19                	jne    800629 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800610:	53                   	push   %ebx
  800611:	68 65 1e 80 00       	push   $0x801e65
  800616:	ff 75 0c             	pushl  0xc(%ebp)
  800619:	ff 75 08             	pushl  0x8(%ebp)
  80061c:	e8 70 02 00 00       	call   800891 <printfmt>
  800621:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800624:	e9 5b 02 00 00       	jmp    800884 <vprintfmt+0x3ce>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800629:	56                   	push   %esi
  80062a:	68 6e 1e 80 00       	push   $0x801e6e
  80062f:	ff 75 0c             	pushl  0xc(%ebp)
  800632:	ff 75 08             	pushl  0x8(%ebp)
  800635:	e8 57 02 00 00       	call   800891 <printfmt>
  80063a:	83 c4 10             	add    $0x10,%esp
			break;
  80063d:	e9 42 02 00 00       	jmp    800884 <vprintfmt+0x3ce>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	83 c0 04             	add    $0x4,%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
  80064b:	8b 45 14             	mov    0x14(%ebp),%eax
  80064e:	83 e8 04             	sub    $0x4,%eax
  800651:	8b 30                	mov    (%eax),%esi
  800653:	85 f6                	test   %esi,%esi
  800655:	75 05                	jne    80065c <vprintfmt+0x1a6>
				p = "(null)";
  800657:	be 71 1e 80 00       	mov    $0x801e71,%esi
			if (width > 0 && padc != '-')
  80065c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800660:	7e 6d                	jle    8006cf <vprintfmt+0x219>
  800662:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800666:	74 67                	je     8006cf <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	50                   	push   %eax
  80066f:	56                   	push   %esi
  800670:	e8 1e 03 00 00       	call   800993 <strnlen>
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80067b:	eb 16                	jmp    800693 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80067d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800690:	ff 4d e4             	decl   -0x1c(%ebp)
  800693:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800697:	7f e4                	jg     80067d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800699:	eb 34                	jmp    8006cf <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80069b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80069f:	74 1c                	je     8006bd <vprintfmt+0x207>
  8006a1:	83 fb 1f             	cmp    $0x1f,%ebx
  8006a4:	7e 05                	jle    8006ab <vprintfmt+0x1f5>
  8006a6:	83 fb 7e             	cmp    $0x7e,%ebx
  8006a9:	7e 12                	jle    8006bd <vprintfmt+0x207>
					putch('?', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	ff 75 0c             	pushl  0xc(%ebp)
  8006b1:	6a 3f                	push   $0x3f
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	eb 0f                	jmp    8006cc <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8006bd:	83 ec 08             	sub    $0x8,%esp
  8006c0:	ff 75 0c             	pushl  0xc(%ebp)
  8006c3:	53                   	push   %ebx
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	ff d0                	call   *%eax
  8006c9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006cc:	ff 4d e4             	decl   -0x1c(%ebp)
  8006cf:	89 f0                	mov    %esi,%eax
  8006d1:	8d 70 01             	lea    0x1(%eax),%esi
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be d8             	movsbl %al,%ebx
  8006d9:	85 db                	test   %ebx,%ebx
  8006db:	74 24                	je     800701 <vprintfmt+0x24b>
  8006dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006e1:	78 b8                	js     80069b <vprintfmt+0x1e5>
  8006e3:	ff 4d e0             	decl   -0x20(%ebp)
  8006e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ea:	79 af                	jns    80069b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ec:	eb 13                	jmp    800701 <vprintfmt+0x24b>
				putch(' ', putdat);
  8006ee:	83 ec 08             	sub    $0x8,%esp
  8006f1:	ff 75 0c             	pushl  0xc(%ebp)
  8006f4:	6a 20                	push   $0x20
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	ff d0                	call   *%eax
  8006fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fe:	ff 4d e4             	decl   -0x1c(%ebp)
  800701:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800705:	7f e7                	jg     8006ee <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800707:	e9 78 01 00 00       	jmp    800884 <vprintfmt+0x3ce>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	ff 75 e8             	pushl  -0x18(%ebp)
  800712:	8d 45 14             	lea    0x14(%ebp),%eax
  800715:	50                   	push   %eax
  800716:	e8 3c fd ff ff       	call   800457 <getint>
  80071b:	83 c4 10             	add    $0x10,%esp
  80071e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800721:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800727:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072a:	85 d2                	test   %edx,%edx
  80072c:	79 23                	jns    800751 <vprintfmt+0x29b>
				putch('-', putdat);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	ff 75 0c             	pushl  0xc(%ebp)
  800734:	6a 2d                	push   $0x2d
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	ff d0                	call   *%eax
  80073b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80073e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800741:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800744:	f7 d8                	neg    %eax
  800746:	83 d2 00             	adc    $0x0,%edx
  800749:	f7 da                	neg    %edx
  80074b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80074e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800751:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800758:	e9 bc 00 00 00       	jmp    800819 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 e8             	pushl  -0x18(%ebp)
  800763:	8d 45 14             	lea    0x14(%ebp),%eax
  800766:	50                   	push   %eax
  800767:	e8 84 fc ff ff       	call   8003f0 <getuint>
  80076c:	83 c4 10             	add    $0x10,%esp
  80076f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800772:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800775:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80077c:	e9 98 00 00 00       	jmp    800819 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800781:	83 ec 08             	sub    $0x8,%esp
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	6a 58                	push   $0x58
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800791:	83 ec 08             	sub    $0x8,%esp
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	6a 58                	push   $0x58
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	ff d0                	call   *%eax
  80079e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8007a1:	83 ec 08             	sub    $0x8,%esp
  8007a4:	ff 75 0c             	pushl  0xc(%ebp)
  8007a7:	6a 58                	push   $0x58
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	ff d0                	call   *%eax
  8007ae:	83 c4 10             	add    $0x10,%esp
			break;
  8007b1:	e9 ce 00 00 00       	jmp    800884 <vprintfmt+0x3ce>

		// pointer
		case 'p':
			putch('0', putdat);
  8007b6:	83 ec 08             	sub    $0x8,%esp
  8007b9:	ff 75 0c             	pushl  0xc(%ebp)
  8007bc:	6a 30                	push   $0x30
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	ff d0                	call   *%eax
  8007c3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	6a 78                	push   $0x78
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	ff d0                	call   *%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8007d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d9:	83 c0 04             	add    $0x4,%eax
  8007dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8007df:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e2:	83 e8 04             	sub    $0x4,%eax
  8007e5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8007e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8007f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8007f8:	eb 1f                	jmp    800819 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007fa:	83 ec 08             	sub    $0x8,%esp
  8007fd:	ff 75 e8             	pushl  -0x18(%ebp)
  800800:	8d 45 14             	lea    0x14(%ebp),%eax
  800803:	50                   	push   %eax
  800804:	e8 e7 fb ff ff       	call   8003f0 <getuint>
  800809:	83 c4 10             	add    $0x10,%esp
  80080c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80080f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800812:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800819:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80081d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800820:	83 ec 04             	sub    $0x4,%esp
  800823:	52                   	push   %edx
  800824:	ff 75 e4             	pushl  -0x1c(%ebp)
  800827:	50                   	push   %eax
  800828:	ff 75 f4             	pushl  -0xc(%ebp)
  80082b:	ff 75 f0             	pushl  -0x10(%ebp)
  80082e:	ff 75 0c             	pushl  0xc(%ebp)
  800831:	ff 75 08             	pushl  0x8(%ebp)
  800834:	e8 00 fb ff ff       	call   800339 <printnum>
  800839:	83 c4 20             	add    $0x20,%esp
			break;
  80083c:	eb 46                	jmp    800884 <vprintfmt+0x3ce>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083e:	83 ec 08             	sub    $0x8,%esp
  800841:	ff 75 0c             	pushl  0xc(%ebp)
  800844:	53                   	push   %ebx
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	ff d0                	call   *%eax
  80084a:	83 c4 10             	add    $0x10,%esp
			break;
  80084d:	eb 35                	jmp    800884 <vprintfmt+0x3ce>

		/**********************************/
		/*2023*/
		// DON'T Print Program Name & UD
		case '~':
			printProgName = 0;
  80084f:	c6 05 0c 30 80 00 00 	movb   $0x0,0x80300c
			break;
  800856:	eb 2c                	jmp    800884 <vprintfmt+0x3ce>
		// Print Program Name & UD
		case '@':
			printProgName = 1;
  800858:	c6 05 0c 30 80 00 01 	movb   $0x1,0x80300c
			break;
  80085f:	eb 23                	jmp    800884 <vprintfmt+0x3ce>
		/**********************************/

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800861:	83 ec 08             	sub    $0x8,%esp
  800864:	ff 75 0c             	pushl  0xc(%ebp)
  800867:	6a 25                	push   $0x25
  800869:	8b 45 08             	mov    0x8(%ebp),%eax
  80086c:	ff d0                	call   *%eax
  80086e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800871:	ff 4d 10             	decl   0x10(%ebp)
  800874:	eb 03                	jmp    800879 <vprintfmt+0x3c3>
  800876:	ff 4d 10             	decl   0x10(%ebp)
  800879:	8b 45 10             	mov    0x10(%ebp),%eax
  80087c:	48                   	dec    %eax
  80087d:	8a 00                	mov    (%eax),%al
  80087f:	3c 25                	cmp    $0x25,%al
  800881:	75 f3                	jne    800876 <vprintfmt+0x3c0>
				/* do nothing */;
			break;
  800883:	90                   	nop
		}
	}
  800884:	e9 35 fc ff ff       	jmp    8004be <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800889:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80088a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80088d:	5b                   	pop    %ebx
  80088e:	5e                   	pop    %esi
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800897:	8d 45 10             	lea    0x10(%ebp),%eax
  80089a:	83 c0 04             	add    $0x4,%eax
  80089d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8008a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8008a6:	50                   	push   %eax
  8008a7:	ff 75 0c             	pushl  0xc(%ebp)
  8008aa:	ff 75 08             	pushl  0x8(%ebp)
  8008ad:	e8 04 fc ff ff       	call   8004b6 <vprintfmt>
  8008b2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8008b5:	90                   	nop
  8008b6:	c9                   	leave  
  8008b7:	c3                   	ret    

008008b8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008be:	8b 40 08             	mov    0x8(%eax),%eax
  8008c1:	8d 50 01             	lea    0x1(%eax),%edx
  8008c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8008ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cd:	8b 10                	mov    (%eax),%edx
  8008cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d2:	8b 40 04             	mov    0x4(%eax),%eax
  8008d5:	39 c2                	cmp    %eax,%edx
  8008d7:	73 12                	jae    8008eb <sprintputch+0x33>
		*b->buf++ = ch;
  8008d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008dc:	8b 00                	mov    (%eax),%eax
  8008de:	8d 48 01             	lea    0x1(%eax),%ecx
  8008e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e4:	89 0a                	mov    %ecx,(%edx)
  8008e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008e9:	88 10                	mov    %dl,(%eax)
}
  8008eb:	90                   	nop
  8008ec:	5d                   	pop    %ebp
  8008ed:	c3                   	ret    

008008ee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ee:	55                   	push   %ebp
  8008ef:	89 e5                	mov    %esp,%ebp
  8008f1:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	01 d0                	add    %edx,%eax
  800905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800908:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800913:	74 06                	je     80091b <vsnprintf+0x2d>
  800915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800919:	7f 07                	jg     800922 <vsnprintf+0x34>
		return -E_INVAL;
  80091b:	b8 03 00 00 00       	mov    $0x3,%eax
  800920:	eb 20                	jmp    800942 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800922:	ff 75 14             	pushl  0x14(%ebp)
  800925:	ff 75 10             	pushl  0x10(%ebp)
  800928:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80092b:	50                   	push   %eax
  80092c:	68 b8 08 80 00       	push   $0x8008b8
  800931:	e8 80 fb ff ff       	call   8004b6 <vprintfmt>
  800936:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80093c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80093f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800942:	c9                   	leave  
  800943:	c3                   	ret    

00800944 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80094a:	8d 45 10             	lea    0x10(%ebp),%eax
  80094d:	83 c0 04             	add    $0x4,%eax
  800950:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	ff 75 f4             	pushl  -0xc(%ebp)
  800959:	50                   	push   %eax
  80095a:	ff 75 0c             	pushl  0xc(%ebp)
  80095d:	ff 75 08             	pushl  0x8(%ebp)
  800960:	e8 89 ff ff ff       	call   8008ee <vsnprintf>
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80096b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80096e:	c9                   	leave  
  80096f:	c3                   	ret    

00800970 <strlen>:
#include <inc/string.h>
#include <inc/assert.h>

int
strlen(const char *s)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80097d:	eb 06                	jmp    800985 <strlen+0x15>
		n++;
  80097f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800982:	ff 45 08             	incl   0x8(%ebp)
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8a 00                	mov    (%eax),%al
  80098a:	84 c0                	test   %al,%al
  80098c:	75 f1                	jne    80097f <strlen+0xf>
		n++;
	return n;
  80098e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8009a0:	eb 09                	jmp    8009ab <strnlen+0x18>
		n++;
  8009a2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a5:	ff 45 08             	incl   0x8(%ebp)
  8009a8:	ff 4d 0c             	decl   0xc(%ebp)
  8009ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009af:	74 09                	je     8009ba <strnlen+0x27>
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8a 00                	mov    (%eax),%al
  8009b6:	84 c0                	test   %al,%al
  8009b8:	75 e8                	jne    8009a2 <strnlen+0xf>
		n++;
	return n;
  8009ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009bd:	c9                   	leave  
  8009be:	c3                   	ret    

008009bf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8009cb:	90                   	nop
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8d 50 01             	lea    0x1(%eax),%edx
  8009d2:	89 55 08             	mov    %edx,0x8(%ebp)
  8009d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8009db:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8009de:	8a 12                	mov    (%edx),%dl
  8009e0:	88 10                	mov    %dl,(%eax)
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	84 c0                	test   %al,%al
  8009e6:	75 e4                	jne    8009cc <strcpy+0xd>
		/* do nothing */;
	return ret;
  8009e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8009f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a00:	eb 1f                	jmp    800a21 <strncpy+0x34>
		*dst++ = *src;
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8d 50 01             	lea    0x1(%eax),%edx
  800a08:	89 55 08             	mov    %edx,0x8(%ebp)
  800a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a0e:	8a 12                	mov    (%edx),%dl
  800a10:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	74 03                	je     800a1e <strncpy+0x31>
			src++;
  800a1b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1e:	ff 45 fc             	incl   -0x4(%ebp)
  800a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a27:	72 d9                	jb     800a02 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800a29:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800a2c:	c9                   	leave  
  800a2d:	c3                   	ret    

00800a2e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800a2e:	55                   	push   %ebp
  800a2f:	89 e5                	mov    %esp,%ebp
  800a31:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800a3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a3e:	74 30                	je     800a70 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800a40:	eb 16                	jmp    800a58 <strlcpy+0x2a>
			*dst++ = *src++;
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	8d 50 01             	lea    0x1(%eax),%edx
  800a48:	89 55 08             	mov    %edx,0x8(%ebp)
  800a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a51:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a54:	8a 12                	mov    (%edx),%dl
  800a56:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a58:	ff 4d 10             	decl   0x10(%ebp)
  800a5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a5f:	74 09                	je     800a6a <strlcpy+0x3c>
  800a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a64:	8a 00                	mov    (%eax),%al
  800a66:	84 c0                	test   %al,%al
  800a68:	75 d8                	jne    800a42 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a70:	8b 55 08             	mov    0x8(%ebp),%edx
  800a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800a76:	29 c2                	sub    %eax,%edx
  800a78:	89 d0                	mov    %edx,%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800a7f:	eb 06                	jmp    800a87 <strcmp+0xb>
		p++, q++;
  800a81:	ff 45 08             	incl   0x8(%ebp)
  800a84:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8a 00                	mov    (%eax),%al
  800a8c:	84 c0                	test   %al,%al
  800a8e:	74 0e                	je     800a9e <strcmp+0x22>
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8a 10                	mov    (%eax),%dl
  800a95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a98:	8a 00                	mov    (%eax),%al
  800a9a:	38 c2                	cmp    %al,%dl
  800a9c:	74 e3                	je     800a81 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	8a 00                	mov    (%eax),%al
  800aa3:	0f b6 d0             	movzbl %al,%edx
  800aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa9:	8a 00                	mov    (%eax),%al
  800aab:	0f b6 c0             	movzbl %al,%eax
  800aae:	29 c2                	sub    %eax,%edx
  800ab0:	89 d0                	mov    %edx,%eax
}
  800ab2:	5d                   	pop    %ebp
  800ab3:	c3                   	ret    

00800ab4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ab4:	55                   	push   %ebp
  800ab5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800ab7:	eb 09                	jmp    800ac2 <strncmp+0xe>
		n--, p++, q++;
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	ff 45 08             	incl   0x8(%ebp)
  800abf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ac2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac6:	74 17                	je     800adf <strncmp+0x2b>
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8a 00                	mov    (%eax),%al
  800acd:	84 c0                	test   %al,%al
  800acf:	74 0e                	je     800adf <strncmp+0x2b>
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8a 10                	mov    (%eax),%dl
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8a 00                	mov    (%eax),%al
  800adb:	38 c2                	cmp    %al,%dl
  800add:	74 da                	je     800ab9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800adf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ae3:	75 07                	jne    800aec <strncmp+0x38>
		return 0;
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  800aea:	eb 14                	jmp    800b00 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	8a 00                	mov    (%eax),%al
  800af1:	0f b6 d0             	movzbl %al,%edx
  800af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af7:	8a 00                	mov    (%eax),%al
  800af9:	0f b6 c0             	movzbl %al,%eax
  800afc:	29 c2                	sub    %eax,%edx
  800afe:	89 d0                	mov    %edx,%eax
}
  800b00:	5d                   	pop    %ebp
  800b01:	c3                   	ret    

00800b02 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	83 ec 04             	sub    $0x4,%esp
  800b08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b0e:	eb 12                	jmp    800b22 <strchr+0x20>
		if (*s == c)
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	8a 00                	mov    (%eax),%al
  800b15:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b18:	75 05                	jne    800b1f <strchr+0x1d>
			return (char *) s;
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	eb 11                	jmp    800b30 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b1f:	ff 45 08             	incl   0x8(%ebp)
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	84 c0                	test   %al,%al
  800b29:	75 e5                	jne    800b10 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800b2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	83 ec 04             	sub    $0x4,%esp
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b3e:	eb 0d                	jmp    800b4d <strfind+0x1b>
		if (*s == c)
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	8a 00                	mov    (%eax),%al
  800b45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800b48:	74 0e                	je     800b58 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8a 00                	mov    (%eax),%al
  800b52:	84 c0                	test   %al,%al
  800b54:	75 ea                	jne    800b40 <strfind+0xe>
  800b56:	eb 01                	jmp    800b59 <strfind+0x27>
		if (*s == c)
			break;
  800b58:	90                   	nop
	return (char *) s;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b5c:	c9                   	leave  
  800b5d:	c3                   	ret    

00800b5e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
  800b61:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800b6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800b70:	eb 0e                	jmp    800b80 <memset+0x22>
		*p++ = c;
  800b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b75:	8d 50 01             	lea    0x1(%eax),%edx
  800b78:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800b7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800b80:	ff 4d f8             	decl   -0x8(%ebp)
  800b83:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800b87:	79 e9                	jns    800b72 <memset+0x14>
		*p++ = c;

	return v;
  800b89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800b8c:	c9                   	leave  
  800b8d:	c3                   	ret    

00800b8e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ba0:	eb 16                	jmp    800bb8 <memcpy+0x2a>
		*d++ = *s++;
  800ba2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ba5:	8d 50 01             	lea    0x1(%eax),%edx
  800ba8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800bab:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800bae:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bb1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800bb4:	8a 12                	mov    (%edx),%dl
  800bb6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800bb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800bc1:	85 c0                	test   %eax,%eax
  800bc3:	75 dd                	jne    800ba2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bdf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800be2:	73 50                	jae    800c34 <memmove+0x6a>
  800be4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	01 d0                	add    %edx,%eax
  800bec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800bef:	76 43                	jbe    800c34 <memmove+0x6a>
		s += n;
  800bf1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf4:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800bfd:	eb 10                	jmp    800c0f <memmove+0x45>
			*--d = *--s;
  800bff:	ff 4d f8             	decl   -0x8(%ebp)
  800c02:	ff 4d fc             	decl   -0x4(%ebp)
  800c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c08:	8a 10                	mov    (%eax),%dl
  800c0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c0d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c15:	89 55 10             	mov    %edx,0x10(%ebp)
  800c18:	85 c0                	test   %eax,%eax
  800c1a:	75 e3                	jne    800bff <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c1c:	eb 23                	jmp    800c41 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c21:	8d 50 01             	lea    0x1(%eax),%edx
  800c24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c30:	8a 12                	mov    (%edx),%dl
  800c32:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800c34:	8b 45 10             	mov    0x10(%ebp),%eax
  800c37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	75 dd                	jne    800c1e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c44:	c9                   	leave  
  800c45:	c3                   	ret    

00800c46 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800c46:	55                   	push   %ebp
  800c47:	89 e5                	mov    %esp,%ebp
  800c49:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c55:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800c58:	eb 2a                	jmp    800c84 <memcmp+0x3e>
		if (*s1 != *s2)
  800c5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5d:	8a 10                	mov    (%eax),%dl
  800c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c62:	8a 00                	mov    (%eax),%al
  800c64:	38 c2                	cmp    %al,%dl
  800c66:	74 16                	je     800c7e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d0             	movzbl %al,%edx
  800c70:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c73:	8a 00                	mov    (%eax),%al
  800c75:	0f b6 c0             	movzbl %al,%eax
  800c78:	29 c2                	sub    %eax,%edx
  800c7a:	89 d0                	mov    %edx,%eax
  800c7c:	eb 18                	jmp    800c96 <memcmp+0x50>
		s1++, s2++;
  800c7e:	ff 45 fc             	incl   -0x4(%ebp)
  800c81:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	75 c9                	jne    800c5a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c96:	c9                   	leave  
  800c97:	c3                   	ret    

00800c98 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca4:	01 d0                	add    %edx,%eax
  800ca6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ca9:	eb 15                	jmp    800cc0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	8a 00                	mov    (%eax),%al
  800cb0:	0f b6 d0             	movzbl %al,%edx
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	0f b6 c0             	movzbl %al,%eax
  800cb9:	39 c2                	cmp    %eax,%edx
  800cbb:	74 0d                	je     800cca <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cbd:	ff 45 08             	incl   0x8(%ebp)
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800cc6:	72 e3                	jb     800cab <memfind+0x13>
  800cc8:	eb 01                	jmp    800ccb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800cca:	90                   	nop
	return (void *) s;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cce:	c9                   	leave  
  800ccf:	c3                   	ret    

00800cd0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800cd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800cdd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce4:	eb 03                	jmp    800ce9 <strtol+0x19>
		s++;
  800ce6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	3c 20                	cmp    $0x20,%al
  800cf0:	74 f4                	je     800ce6 <strtol+0x16>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 00                	mov    (%eax),%al
  800cf7:	3c 09                	cmp    $0x9,%al
  800cf9:	74 eb                	je     800ce6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfe:	8a 00                	mov    (%eax),%al
  800d00:	3c 2b                	cmp    $0x2b,%al
  800d02:	75 05                	jne    800d09 <strtol+0x39>
		s++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	eb 13                	jmp    800d1c <strtol+0x4c>
	else if (*s == '-')
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	8a 00                	mov    (%eax),%al
  800d0e:	3c 2d                	cmp    $0x2d,%al
  800d10:	75 0a                	jne    800d1c <strtol+0x4c>
		s++, neg = 1;
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	74 06                	je     800d28 <strtol+0x58>
  800d22:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800d26:	75 20                	jne    800d48 <strtol+0x78>
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	3c 30                	cmp    $0x30,%al
  800d2f:	75 17                	jne    800d48 <strtol+0x78>
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	40                   	inc    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 78                	cmp    $0x78,%al
  800d39:	75 0d                	jne    800d48 <strtol+0x78>
		s += 2, base = 16;
  800d3b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800d3f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800d46:	eb 28                	jmp    800d70 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800d48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4c:	75 15                	jne    800d63 <strtol+0x93>
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	3c 30                	cmp    $0x30,%al
  800d55:	75 0c                	jne    800d63 <strtol+0x93>
		s++, base = 8;
  800d57:	ff 45 08             	incl   0x8(%ebp)
  800d5a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800d61:	eb 0d                	jmp    800d70 <strtol+0xa0>
	else if (base == 0)
  800d63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d67:	75 07                	jne    800d70 <strtol+0xa0>
		base = 10;
  800d69:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	3c 2f                	cmp    $0x2f,%al
  800d77:	7e 19                	jle    800d92 <strtol+0xc2>
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	3c 39                	cmp    $0x39,%al
  800d80:	7f 10                	jg     800d92 <strtol+0xc2>
			dig = *s - '0';
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	0f be c0             	movsbl %al,%eax
  800d8a:	83 e8 30             	sub    $0x30,%eax
  800d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800d90:	eb 42                	jmp    800dd4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	3c 60                	cmp    $0x60,%al
  800d99:	7e 19                	jle    800db4 <strtol+0xe4>
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	3c 7a                	cmp    $0x7a,%al
  800da2:	7f 10                	jg     800db4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	0f be c0             	movsbl %al,%eax
  800dac:	83 e8 57             	sub    $0x57,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800db2:	eb 20                	jmp    800dd4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	3c 40                	cmp    $0x40,%al
  800dbb:	7e 39                	jle    800df6 <strtol+0x126>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 00                	mov    (%eax),%al
  800dc2:	3c 5a                	cmp    $0x5a,%al
  800dc4:	7f 30                	jg     800df6 <strtol+0x126>
			dig = *s - 'A' + 10;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	8a 00                	mov    (%eax),%al
  800dcb:	0f be c0             	movsbl %al,%eax
  800dce:	83 e8 37             	sub    $0x37,%eax
  800dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800dd7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dda:	7d 19                	jge    800df5 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ddc:	ff 45 08             	incl   0x8(%ebp)
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	0f af 45 10          	imul   0x10(%ebp),%eax
  800de6:	89 c2                	mov    %eax,%edx
  800de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800deb:	01 d0                	add    %edx,%eax
  800ded:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800df0:	e9 7b ff ff ff       	jmp    800d70 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800df5:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 08                	je     800e04 <strtol+0x134>
		*endptr = (char *) s;
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e04:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e08:	74 07                	je     800e11 <strtol+0x141>
  800e0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e0d:	f7 d8                	neg    %eax
  800e0f:	eb 03                	jmp    800e14 <strtol+0x144>
  800e11:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e14:	c9                   	leave  
  800e15:	c3                   	ret    

00800e16 <ltostr>:

void
ltostr(long value, char *str)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800e1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800e23:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800e2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e2e:	79 13                	jns    800e43 <ltostr+0x2d>
	{
		neg = 1;
  800e30:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800e37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800e3d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800e40:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800e4b:	99                   	cltd   
  800e4c:	f7 f9                	idiv   %ecx
  800e4e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	89 c2                	mov    %eax,%edx
  800e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5f:	01 d0                	add    %edx,%eax
  800e61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800e64:	83 c2 30             	add    $0x30,%edx
  800e67:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800e69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e6c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800e71:	f7 e9                	imul   %ecx
  800e73:	c1 fa 02             	sar    $0x2,%edx
  800e76:	89 c8                	mov    %ecx,%eax
  800e78:	c1 f8 1f             	sar    $0x1f,%eax
  800e7b:	29 c2                	sub    %eax,%edx
  800e7d:	89 d0                	mov    %edx,%eax
  800e7f:	89 45 08             	mov    %eax,0x8(%ebp)
	/*2023 FIX el7 :)*/
	//} while (value % 10 != 0);
	} while (value != 0);
  800e82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e86:	75 bb                	jne    800e43 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800e88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800e8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e92:	48                   	dec    %eax
  800e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800e96:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9a:	74 3d                	je     800ed9 <ltostr+0xc3>
		start = 1 ;
  800e9c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800ea3:	eb 34                	jmp    800ed9 <ltostr+0xc3>
	{
		char tmp = str[start] ;
  800ea5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	01 d0                	add    %edx,%eax
  800ead:	8a 00                	mov    (%eax),%al
  800eaf:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800eb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	01 c2                	add    %eax,%edx
  800eba:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800ebd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec0:	01 c8                	add    %ecx,%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800ec6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecc:	01 c2                	add    %eax,%edx
  800ece:	8a 45 eb             	mov    -0x15(%ebp),%al
  800ed1:	88 02                	mov    %al,(%edx)
		start++ ;
  800ed3:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800ed6:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800edc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800edf:	7c c4                	jl     800ea5 <ltostr+0x8f>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800ee1:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	01 d0                	add    %edx,%eax
  800ee9:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800eec:	90                   	nop
  800eed:	c9                   	leave  
  800eee:	c3                   	ret    

00800eef <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800ef5:	ff 75 08             	pushl  0x8(%ebp)
  800ef8:	e8 73 fa ff ff       	call   800970 <strlen>
  800efd:	83 c4 04             	add    $0x4,%esp
  800f00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800f03:	ff 75 0c             	pushl  0xc(%ebp)
  800f06:	e8 65 fa ff ff       	call   800970 <strlen>
  800f0b:	83 c4 04             	add    $0x4,%esp
  800f0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800f11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800f18:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f1f:	eb 17                	jmp    800f38 <strcconcat+0x49>
		final[s] = str1[s] ;
  800f21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 c2                	add    %eax,%edx
  800f29:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800f35:	ff 45 fc             	incl   -0x4(%ebp)
  800f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800f3e:	7c e1                	jl     800f21 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800f40:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800f47:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800f4e:	eb 1f                	jmp    800f6f <strcconcat+0x80>
		final[s++] = str2[i] ;
  800f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f53:	8d 50 01             	lea    0x1(%eax),%edx
  800f56:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5e:	01 c2                	add    %eax,%edx
  800f60:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  800f63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f66:	01 c8                	add    %ecx,%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  800f6c:	ff 45 f8             	incl   -0x8(%ebp)
  800f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f72:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f75:	7c d9                	jl     800f50 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  800f77:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	c6 00 00             	movb   $0x0,(%eax)
}
  800f82:	90                   	nop
  800f83:	c9                   	leave  
  800f84:	c3                   	ret    

00800f85 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  800f85:	55                   	push   %ebp
  800f86:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  800f88:	8b 45 14             	mov    0x14(%ebp),%eax
  800f8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  800f91:	8b 45 14             	mov    0x14(%ebp),%eax
  800f94:	8b 00                	mov    (%eax),%eax
  800f96:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa0:	01 d0                	add    %edx,%eax
  800fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fa8:	eb 0c                	jmp    800fb6 <strsplit+0x31>
			*string++ = 0;
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	89 55 08             	mov    %edx,0x8(%ebp)
  800fb3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	84 c0                	test   %al,%al
  800fbd:	74 18                	je     800fd7 <strsplit+0x52>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	50                   	push   %eax
  800fc8:	ff 75 0c             	pushl  0xc(%ebp)
  800fcb:	e8 32 fb ff ff       	call   800b02 <strchr>
  800fd0:	83 c4 08             	add    $0x8,%esp
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	75 d3                	jne    800faa <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	84 c0                	test   %al,%al
  800fde:	74 5a                	je     80103a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  800fe0:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe3:	8b 00                	mov    (%eax),%eax
  800fe5:	83 f8 0f             	cmp    $0xf,%eax
  800fe8:	75 07                	jne    800ff1 <strsplit+0x6c>
		{
			return 0;
  800fea:	b8 00 00 00 00       	mov    $0x0,%eax
  800fef:	eb 66                	jmp    801057 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  800ff1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff4:	8b 00                	mov    (%eax),%eax
  800ff6:	8d 48 01             	lea    0x1(%eax),%ecx
  800ff9:	8b 55 14             	mov    0x14(%ebp),%edx
  800ffc:	89 0a                	mov    %ecx,(%edx)
  800ffe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801005:	8b 45 10             	mov    0x10(%ebp),%eax
  801008:	01 c2                	add    %eax,%edx
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80100f:	eb 03                	jmp    801014 <strsplit+0x8f>
			string++;
  801011:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	84 c0                	test   %al,%al
  80101b:	74 8b                	je     800fa8 <strsplit+0x23>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	0f be c0             	movsbl %al,%eax
  801025:	50                   	push   %eax
  801026:	ff 75 0c             	pushl  0xc(%ebp)
  801029:	e8 d4 fa ff ff       	call   800b02 <strchr>
  80102e:	83 c4 08             	add    $0x8,%esp
  801031:	85 c0                	test   %eax,%eax
  801033:	74 dc                	je     801011 <strsplit+0x8c>
			string++;
	}
  801035:	e9 6e ff ff ff       	jmp    800fa8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80103a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80103b:	8b 45 14             	mov    0x14(%ebp),%eax
  80103e:	8b 00                	mov    (%eax),%eax
  801040:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801047:	8b 45 10             	mov    0x10(%ebp),%eax
  80104a:	01 d0                	add    %edx,%eax
  80104c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801052:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801057:	c9                   	leave  
  801058:	c3                   	ret    

00801059 <str2lower>:


char* str2lower(char *dst, const char *src)
{
  801059:	55                   	push   %ebp
  80105a:	89 e5                	mov    %esp,%ebp
  80105c:	83 ec 08             	sub    $0x8,%esp
	//[PROJECT]
	panic("str2lower is not implemented yet!");
  80105f:	83 ec 04             	sub    $0x4,%esp
  801062:	68 e8 1f 80 00       	push   $0x801fe8
  801067:	68 3f 01 00 00       	push   $0x13f
  80106c:	68 0a 20 80 00       	push   $0x80200a
  801071:	e8 9d 06 00 00       	call   801713 <_panic>

00801076 <syscall>:

#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32 syscall(int num, uint32 a1, uint32 a2, uint32 a3,
		uint32 a4, uint32 a5) {
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8b 55 0c             	mov    0xc(%ebp),%edx
  801085:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801088:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80108b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80108e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801091:	cd 30                	int    $0x30
  801093:	89 45 f0             	mov    %eax,-0x10(%ebp)
			"b" (a3),
			"D" (a4),
			"S" (a5)
			: "cc", "memory");

	return ret;
  801096:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	5b                   	pop    %ebx
  80109d:	5e                   	pop    %esi
  80109e:	5f                   	pop    %edi
  80109f:	5d                   	pop    %ebp
  8010a0:	c3                   	ret    

008010a1 <sys_cputs>:

void sys_cputs(const char *s, uint32 len, uint8 printProgName) {
  8010a1:	55                   	push   %ebp
  8010a2:	89 e5                	mov    %esp,%ebp
  8010a4:	83 ec 04             	sub    $0x4,%esp
  8010a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32) printProgName, 0, 0);
  8010ad:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	6a 00                	push   $0x0
  8010b6:	6a 00                	push   $0x0
  8010b8:	52                   	push   %edx
  8010b9:	ff 75 0c             	pushl  0xc(%ebp)
  8010bc:	50                   	push   %eax
  8010bd:	6a 00                	push   $0x0
  8010bf:	e8 b2 ff ff ff       	call   801076 <syscall>
  8010c4:	83 c4 18             	add    $0x18,%esp
}
  8010c7:	90                   	nop
  8010c8:	c9                   	leave  
  8010c9:	c3                   	ret    

008010ca <sys_cgetc>:

int sys_cgetc(void) {
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8010cd:	6a 00                	push   $0x0
  8010cf:	6a 00                	push   $0x0
  8010d1:	6a 00                	push   $0x0
  8010d3:	6a 00                	push   $0x0
  8010d5:	6a 00                	push   $0x0
  8010d7:	6a 02                	push   $0x2
  8010d9:	e8 98 ff ff ff       	call   801076 <syscall>
  8010de:	83 c4 18             	add    $0x18,%esp
}
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    

008010e3 <sys_lock_cons>:

void sys_lock_cons(void) {
  8010e3:	55                   	push   %ebp
  8010e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_lock_cons, 0, 0, 0, 0, 0);
  8010e6:	6a 00                	push   $0x0
  8010e8:	6a 00                	push   $0x0
  8010ea:	6a 00                	push   $0x0
  8010ec:	6a 00                	push   $0x0
  8010ee:	6a 00                	push   $0x0
  8010f0:	6a 03                	push   $0x3
  8010f2:	e8 7f ff ff ff       	call   801076 <syscall>
  8010f7:	83 c4 18             	add    $0x18,%esp
}
  8010fa:	90                   	nop
  8010fb:	c9                   	leave  
  8010fc:	c3                   	ret    

008010fd <sys_unlock_cons>:
void sys_unlock_cons(void) {
  8010fd:	55                   	push   %ebp
  8010fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_unlock_cons, 0, 0, 0, 0, 0);
  801100:	6a 00                	push   $0x0
  801102:	6a 00                	push   $0x0
  801104:	6a 00                	push   $0x0
  801106:	6a 00                	push   $0x0
  801108:	6a 00                	push   $0x0
  80110a:	6a 04                	push   $0x4
  80110c:	e8 65 ff ff ff       	call   801076 <syscall>
  801111:	83 c4 18             	add    $0x18,%esp
}
  801114:	90                   	nop
  801115:	c9                   	leave  
  801116:	c3                   	ret    

00801117 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm) {
  801117:	55                   	push   %ebp
  801118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0, 0, 0);
  80111a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80111d:	8b 45 08             	mov    0x8(%ebp),%eax
  801120:	6a 00                	push   $0x0
  801122:	6a 00                	push   $0x0
  801124:	6a 00                	push   $0x0
  801126:	52                   	push   %edx
  801127:	50                   	push   %eax
  801128:	6a 08                	push   $0x8
  80112a:	e8 47 ff ff ff       	call   801076 <syscall>
  80112f:	83 c4 18             	add    $0x18,%esp
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva,
		int perm) {
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	56                   	push   %esi
  801138:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv,
  801139:	8b 75 18             	mov    0x18(%ebp),%esi
  80113c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80113f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801142:	8b 55 0c             	mov    0xc(%ebp),%edx
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	56                   	push   %esi
  801149:	53                   	push   %ebx
  80114a:	51                   	push   %ecx
  80114b:	52                   	push   %edx
  80114c:	50                   	push   %eax
  80114d:	6a 09                	push   $0x9
  80114f:	e8 22 ff ff ff       	call   801076 <syscall>
  801154:	83 c4 18             	add    $0x18,%esp
			(uint32) dstva, perm);
}
  801157:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115a:	5b                   	pop    %ebx
  80115b:	5e                   	pop    %esi
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va) {
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801161:	8b 55 0c             	mov    0xc(%ebp),%edx
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	6a 00                	push   $0x0
  801169:	6a 00                	push   $0x0
  80116b:	6a 00                	push   $0x0
  80116d:	52                   	push   %edx
  80116e:	50                   	push   %eax
  80116f:	6a 0a                	push   $0xa
  801171:	e8 00 ff ff ff       	call   801076 <syscall>
  801176:	83 c4 18             	add    $0x18,%esp
}
  801179:	c9                   	leave  
  80117a:	c3                   	ret    

0080117b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size) {
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0,
  80117e:	6a 00                	push   $0x0
  801180:	6a 00                	push   $0x0
  801182:	6a 00                	push   $0x0
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	ff 75 08             	pushl  0x8(%ebp)
  80118a:	6a 0b                	push   $0xb
  80118c:	e8 e5 fe ff ff       	call   801076 <syscall>
  801191:	83 c4 18             	add    $0x18,%esp
			0, 0);
}
  801194:	c9                   	leave  
  801195:	c3                   	ret    

00801196 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames() {
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801199:	6a 00                	push   $0x0
  80119b:	6a 00                	push   $0x0
  80119d:	6a 00                	push   $0x0
  80119f:	6a 00                	push   $0x0
  8011a1:	6a 00                	push   $0x0
  8011a3:	6a 0c                	push   $0xc
  8011a5:	e8 cc fe ff ff       	call   801076 <syscall>
  8011aa:	83 c4 18             	add    $0x18,%esp
}
  8011ad:	c9                   	leave  
  8011ae:	c3                   	ret    

008011af <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames() {
  8011af:	55                   	push   %ebp
  8011b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8011b2:	6a 00                	push   $0x0
  8011b4:	6a 00                	push   $0x0
  8011b6:	6a 00                	push   $0x0
  8011b8:	6a 00                	push   $0x0
  8011ba:	6a 00                	push   $0x0
  8011bc:	6a 0d                	push   $0xd
  8011be:	e8 b3 fe ff ff       	call   801076 <syscall>
  8011c3:	83 c4 18             	add    $0x18,%esp
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    

008011c8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames() {
  8011c8:	55                   	push   %ebp
  8011c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8011cb:	6a 00                	push   $0x0
  8011cd:	6a 00                	push   $0x0
  8011cf:	6a 00                	push   $0x0
  8011d1:	6a 00                	push   $0x0
  8011d3:	6a 00                	push   $0x0
  8011d5:	6a 0e                	push   $0xe
  8011d7:	e8 9a fe ff ff       	call   801076 <syscall>
  8011dc:	83 c4 18             	add    $0x18,%esp
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages() {
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0, 0, 0, 0, 0);
  8011e4:	6a 00                	push   $0x0
  8011e6:	6a 00                	push   $0x0
  8011e8:	6a 00                	push   $0x0
  8011ea:	6a 00                	push   $0x0
  8011ec:	6a 00                	push   $0x0
  8011ee:	6a 0f                	push   $0xf
  8011f0:	e8 81 fe ff ff       	call   801076 <syscall>
  8011f5:	83 c4 18             	add    $0x18,%esp
}
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag) {
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit,
  8011fd:	6a 00                	push   $0x0
  8011ff:	6a 00                	push   $0x0
  801201:	6a 00                	push   $0x0
  801203:	6a 00                	push   $0x0
  801205:	ff 75 08             	pushl  0x8(%ebp)
  801208:	6a 10                	push   $0x10
  80120a:	e8 67 fe ff ff       	call   801076 <syscall>
  80120f:	83 c4 18             	add    $0x18,%esp
			WS_or_MEMORY_flag, 0, 0, 0, 0);
}
  801212:	c9                   	leave  
  801213:	c3                   	ret    

00801214 <sys_scarce_memory>:

void sys_scarce_memory() {
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory, 0, 0, 0, 0, 0);
  801217:	6a 00                	push   $0x0
  801219:	6a 00                	push   $0x0
  80121b:	6a 00                	push   $0x0
  80121d:	6a 00                	push   $0x0
  80121f:	6a 00                	push   $0x0
  801221:	6a 11                	push   $0x11
  801223:	e8 4e fe ff ff       	call   801076 <syscall>
  801228:	83 c4 18             	add    $0x18,%esp
}
  80122b:	90                   	nop
  80122c:	c9                   	leave  
  80122d:	c3                   	ret    

0080122e <sys_cputc>:

void sys_cputc(const char c) {
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 04             	sub    $0x4,%esp
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80123a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80123e:	6a 00                	push   $0x0
  801240:	6a 00                	push   $0x0
  801242:	6a 00                	push   $0x0
  801244:	6a 00                	push   $0x0
  801246:	50                   	push   %eax
  801247:	6a 01                	push   $0x1
  801249:	e8 28 fe ff ff       	call   801076 <syscall>
  80124e:	83 c4 18             	add    $0x18,%esp
}
  801251:	90                   	nop
  801252:	c9                   	leave  
  801253:	c3                   	ret    

00801254 <sys_clear_ffl>:

//NEW'12: BONUS2 Testing
void sys_clear_ffl() {
  801254:	55                   	push   %ebp
  801255:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL, 0, 0, 0, 0, 0);
  801257:	6a 00                	push   $0x0
  801259:	6a 00                	push   $0x0
  80125b:	6a 00                	push   $0x0
  80125d:	6a 00                	push   $0x0
  80125f:	6a 00                	push   $0x0
  801261:	6a 14                	push   $0x14
  801263:	e8 0e fe ff ff       	call   801076 <syscall>
  801268:	83 c4 18             	add    $0x18,%esp
}
  80126b:	90                   	nop
  80126c:	c9                   	leave  
  80126d:	c3                   	ret    

0080126e <sys_createSharedObject>:

int sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable,
		void* virtual_address) {
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 04             	sub    $0x4,%esp
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object, (uint32) shareName, (uint32) size,
  80127a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80127d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	6a 00                	push   $0x0
  801286:	51                   	push   %ecx
  801287:	52                   	push   %edx
  801288:	ff 75 0c             	pushl  0xc(%ebp)
  80128b:	50                   	push   %eax
  80128c:	6a 15                	push   $0x15
  80128e:	e8 e3 fd ff ff       	call   801076 <syscall>
  801293:	83 c4 18             	add    $0x18,%esp
			isWritable, (uint32) virtual_address, 0);
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <sys_getSizeOfSharedObject>:

//2017:
int sys_getSizeOfSharedObject(int32 ownerID, char* shareName) {
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object, (uint32) ownerID,
  80129b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	6a 00                	push   $0x0
  8012a3:	6a 00                	push   $0x0
  8012a5:	6a 00                	push   $0x0
  8012a7:	52                   	push   %edx
  8012a8:	50                   	push   %eax
  8012a9:	6a 16                	push   $0x16
  8012ab:	e8 c6 fd ff ff       	call   801076 <syscall>
  8012b0:	83 c4 18             	add    $0x18,%esp
			(uint32) shareName, 0, 0, 0);
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <sys_getSharedObject>:
//==========

int sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address) {
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object, (uint32) ownerID, (uint32) shareName,
  8012b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8012bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	6a 00                	push   $0x0
  8012c3:	6a 00                	push   $0x0
  8012c5:	51                   	push   %ecx
  8012c6:	52                   	push   %edx
  8012c7:	50                   	push   %eax
  8012c8:	6a 17                	push   $0x17
  8012ca:	e8 a7 fd ff ff       	call   801076 <syscall>
  8012cf:	83 c4 18             	add    $0x18,%esp
			(uint32) virtual_address, 0, 0);
}
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <sys_freeSharedObject>:

int sys_freeSharedObject(int32 sharedObjectID, void *startVA) {
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object, (uint32) sharedObjectID,
  8012d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	6a 00                	push   $0x0
  8012df:	6a 00                	push   $0x0
  8012e1:	6a 00                	push   $0x0
  8012e3:	52                   	push   %edx
  8012e4:	50                   	push   %eax
  8012e5:	6a 18                	push   $0x18
  8012e7:	e8 8a fd ff ff       	call   801076 <syscall>
  8012ec:	83 c4 18             	add    $0x18,%esp
			(uint32) startVA, 0, 0, 0);
}
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,
		unsigned int LRU_second_list_size,
		unsigned int percent_WS_pages_to_remove) {
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env, (uint32) programName, (uint32) page_WS_size,
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	6a 00                	push   $0x0
  8012f9:	ff 75 14             	pushl  0x14(%ebp)
  8012fc:	ff 75 10             	pushl  0x10(%ebp)
  8012ff:	ff 75 0c             	pushl  0xc(%ebp)
  801302:	50                   	push   %eax
  801303:	6a 19                	push   $0x19
  801305:	e8 6c fd ff ff       	call   801076 <syscall>
  80130a:	83 c4 18             	add    $0x18,%esp
			(uint32) LRU_second_list_size, (uint32) percent_WS_pages_to_remove,
			0);
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <sys_run_env>:

void sys_run_env(int32 envId) {
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32) envId, 0, 0, 0, 0);
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	6a 00                	push   $0x0
  801317:	6a 00                	push   $0x0
  801319:	6a 00                	push   $0x0
  80131b:	6a 00                	push   $0x0
  80131d:	50                   	push   %eax
  80131e:	6a 1a                	push   $0x1a
  801320:	e8 51 fd ff ff       	call   801076 <syscall>
  801325:	83 c4 18             	add    $0x18,%esp
}
  801328:	90                   	nop
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <sys_destroy_env>:

int sys_destroy_env(int32 envid) {
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	6a 00                	push   $0x0
  801333:	6a 00                	push   $0x0
  801335:	6a 00                	push   $0x0
  801337:	6a 00                	push   $0x0
  801339:	50                   	push   %eax
  80133a:	6a 1b                	push   $0x1b
  80133c:	e8 35 fd ff ff       	call   801076 <syscall>
  801341:	83 c4 18             	add    $0x18,%esp
}
  801344:	c9                   	leave  
  801345:	c3                   	ret    

00801346 <sys_getenvid>:

int32 sys_getenvid(void) {
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801349:	6a 00                	push   $0x0
  80134b:	6a 00                	push   $0x0
  80134d:	6a 00                	push   $0x0
  80134f:	6a 00                	push   $0x0
  801351:	6a 00                	push   $0x0
  801353:	6a 05                	push   $0x5
  801355:	e8 1c fd ff ff       	call   801076 <syscall>
  80135a:	83 c4 18             	add    $0x18,%esp
}
  80135d:	c9                   	leave  
  80135e:	c3                   	ret    

0080135f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void) {
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801362:	6a 00                	push   $0x0
  801364:	6a 00                	push   $0x0
  801366:	6a 00                	push   $0x0
  801368:	6a 00                	push   $0x0
  80136a:	6a 00                	push   $0x0
  80136c:	6a 06                	push   $0x6
  80136e:	e8 03 fd ff ff       	call   801076 <syscall>
  801373:	83 c4 18             	add    $0x18,%esp
}
  801376:	c9                   	leave  
  801377:	c3                   	ret    

00801378 <sys_getparentenvid>:

int32 sys_getparentenvid(void) {
  801378:	55                   	push   %ebp
  801379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80137b:	6a 00                	push   $0x0
  80137d:	6a 00                	push   $0x0
  80137f:	6a 00                	push   $0x0
  801381:	6a 00                	push   $0x0
  801383:	6a 00                	push   $0x0
  801385:	6a 07                	push   $0x7
  801387:	e8 ea fc ff ff       	call   801076 <syscall>
  80138c:	83 c4 18             	add    $0x18,%esp
}
  80138f:	c9                   	leave  
  801390:	c3                   	ret    

00801391 <sys_exit_env>:

void sys_exit_env(void) {
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801394:	6a 00                	push   $0x0
  801396:	6a 00                	push   $0x0
  801398:	6a 00                	push   $0x0
  80139a:	6a 00                	push   $0x0
  80139c:	6a 00                	push   $0x0
  80139e:	6a 1c                	push   $0x1c
  8013a0:	e8 d1 fc ff ff       	call   801076 <syscall>
  8013a5:	83 c4 18             	add    $0x18,%esp
}
  8013a8:	90                   	nop
  8013a9:	c9                   	leave  
  8013aa:	c3                   	ret    

008013ab <sys_get_virtual_time>:

struct uint64 sys_get_virtual_time() {
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32) &(result.low), (uint32) &(result.hi),
  8013b1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013b4:	8d 50 04             	lea    0x4(%eax),%edx
  8013b7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8013ba:	6a 00                	push   $0x0
  8013bc:	6a 00                	push   $0x0
  8013be:	6a 00                	push   $0x0
  8013c0:	52                   	push   %edx
  8013c1:	50                   	push   %eax
  8013c2:	6a 1d                	push   $0x1d
  8013c4:	e8 ad fc ff ff       	call   801076 <syscall>
  8013c9:	83 c4 18             	add    $0x18,%esp
			0, 0, 0);
	return result;
  8013cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d5:	89 01                	mov    %eax,(%ecx)
  8013d7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	c9                   	leave  
  8013de:	c2 04 00             	ret    $0x4

008013e1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address,
		uint32 size) {
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size,
  8013e4:	6a 00                	push   $0x0
  8013e6:	6a 00                	push   $0x0
  8013e8:	ff 75 10             	pushl  0x10(%ebp)
  8013eb:	ff 75 0c             	pushl  0xc(%ebp)
  8013ee:	ff 75 08             	pushl  0x8(%ebp)
  8013f1:	6a 13                	push   $0x13
  8013f3:	e8 7e fc ff ff       	call   801076 <syscall>
  8013f8:	83 c4 18             	add    $0x18,%esp
			0, 0);
	return;
  8013fb:	90                   	nop
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <sys_rcr2>:
uint32 sys_rcr2() {
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801401:	6a 00                	push   $0x0
  801403:	6a 00                	push   $0x0
  801405:	6a 00                	push   $0x0
  801407:	6a 00                	push   $0x0
  801409:	6a 00                	push   $0x0
  80140b:	6a 1e                	push   $0x1e
  80140d:	e8 64 fc ff ff       	call   801076 <syscall>
  801412:	83 c4 18             	add    $0x18,%esp
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <sys_bypassPageFault>:

void sys_bypassPageFault(uint8 instrLength) {
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 04             	sub    $0x4,%esp
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801423:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801427:	6a 00                	push   $0x0
  801429:	6a 00                	push   $0x0
  80142b:	6a 00                	push   $0x0
  80142d:	6a 00                	push   $0x0
  80142f:	50                   	push   %eax
  801430:	6a 1f                	push   $0x1f
  801432:	e8 3f fc ff ff       	call   801076 <syscall>
  801437:	83 c4 18             	add    $0x18,%esp
	return;
  80143a:	90                   	nop
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <rsttst>:
void rsttst() {
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801440:	6a 00                	push   $0x0
  801442:	6a 00                	push   $0x0
  801444:	6a 00                	push   $0x0
  801446:	6a 00                	push   $0x0
  801448:	6a 00                	push   $0x0
  80144a:	6a 21                	push   $0x21
  80144c:	e8 25 fc ff ff       	call   801076 <syscall>
  801451:	83 c4 18             	add    $0x18,%esp
	return;
  801454:	90                   	nop
}
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv) {
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	8b 45 14             	mov    0x14(%ebp),%eax
  801460:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801463:	8b 55 18             	mov    0x18(%ebp),%edx
  801466:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80146a:	52                   	push   %edx
  80146b:	50                   	push   %eax
  80146c:	ff 75 10             	pushl  0x10(%ebp)
  80146f:	ff 75 0c             	pushl  0xc(%ebp)
  801472:	ff 75 08             	pushl  0x8(%ebp)
  801475:	6a 20                	push   $0x20
  801477:	e8 fa fb ff ff       	call   801076 <syscall>
  80147c:	83 c4 18             	add    $0x18,%esp
	return;
  80147f:	90                   	nop
}
  801480:	c9                   	leave  
  801481:	c3                   	ret    

00801482 <chktst>:
void chktst(uint32 n) {
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801485:	6a 00                	push   $0x0
  801487:	6a 00                	push   $0x0
  801489:	6a 00                	push   $0x0
  80148b:	6a 00                	push   $0x0
  80148d:	ff 75 08             	pushl  0x8(%ebp)
  801490:	6a 22                	push   $0x22
  801492:	e8 df fb ff ff       	call   801076 <syscall>
  801497:	83 c4 18             	add    $0x18,%esp
	return;
  80149a:	90                   	nop
}
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <inctst>:

void inctst() {
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8014a0:	6a 00                	push   $0x0
  8014a2:	6a 00                	push   $0x0
  8014a4:	6a 00                	push   $0x0
  8014a6:	6a 00                	push   $0x0
  8014a8:	6a 00                	push   $0x0
  8014aa:	6a 23                	push   $0x23
  8014ac:	e8 c5 fb ff ff       	call   801076 <syscall>
  8014b1:	83 c4 18             	add    $0x18,%esp
	return;
  8014b4:	90                   	nop
}
  8014b5:	c9                   	leave  
  8014b6:	c3                   	ret    

008014b7 <gettst>:
uint32 gettst() {
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8014ba:	6a 00                	push   $0x0
  8014bc:	6a 00                	push   $0x0
  8014be:	6a 00                	push   $0x0
  8014c0:	6a 00                	push   $0x0
  8014c2:	6a 00                	push   $0x0
  8014c4:	6a 24                	push   $0x24
  8014c6:	e8 ab fb ff ff       	call   801076 <syscall>
  8014cb:	83 c4 18             	add    $0x18,%esp
}
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <sys_isUHeapPlacementStrategyFIRSTFIT>:

//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT() {
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8014d6:	6a 00                	push   $0x0
  8014d8:	6a 00                	push   $0x0
  8014da:	6a 00                	push   $0x0
  8014dc:	6a 00                	push   $0x0
  8014de:	6a 00                	push   $0x0
  8014e0:	6a 25                	push   $0x25
  8014e2:	e8 8f fb ff ff       	call   801076 <syscall>
  8014e7:	83 c4 18             	add    $0x18,%esp
  8014ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8014ed:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8014f1:	75 07                	jne    8014fa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8014f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8014f8:	eb 05                	jmp    8014ff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8014fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT() {
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801507:	6a 00                	push   $0x0
  801509:	6a 00                	push   $0x0
  80150b:	6a 00                	push   $0x0
  80150d:	6a 00                	push   $0x0
  80150f:	6a 00                	push   $0x0
  801511:	6a 25                	push   $0x25
  801513:	e8 5e fb ff ff       	call   801076 <syscall>
  801518:	83 c4 18             	add    $0x18,%esp
  80151b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80151e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801522:	75 07                	jne    80152b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801524:	b8 01 00 00 00       	mov    $0x1,%eax
  801529:	eb 05                	jmp    801530 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801530:	c9                   	leave  
  801531:	c3                   	ret    

00801532 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT() {
  801532:	55                   	push   %ebp
  801533:	89 e5                	mov    %esp,%ebp
  801535:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801538:	6a 00                	push   $0x0
  80153a:	6a 00                	push   $0x0
  80153c:	6a 00                	push   $0x0
  80153e:	6a 00                	push   $0x0
  801540:	6a 00                	push   $0x0
  801542:	6a 25                	push   $0x25
  801544:	e8 2d fb ff ff       	call   801076 <syscall>
  801549:	83 c4 18             	add    $0x18,%esp
  80154c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80154f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801553:	75 07                	jne    80155c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801555:	b8 01 00 00 00       	mov    $0x1,%eax
  80155a:	eb 05                	jmp    801561 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT() {
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	6a 00                	push   $0x0
  80156f:	6a 00                	push   $0x0
  801571:	6a 00                	push   $0x0
  801573:	6a 25                	push   $0x25
  801575:	e8 fc fa ff ff       	call   801076 <syscall>
  80157a:	83 c4 18             	add    $0x18,%esp
  80157d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801580:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801584:	75 07                	jne    80158d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801586:	b8 01 00 00 00       	mov    $0x1,%eax
  80158b:	eb 05                	jmp    801592 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80158d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801592:	c9                   	leave  
  801593:	c3                   	ret    

00801594 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy) {
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801597:	6a 00                	push   $0x0
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	6a 00                	push   $0x0
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	6a 26                	push   $0x26
  8015a4:	e8 cd fa ff ff       	call   801076 <syscall>
  8015a9:	83 c4 18             	add    $0x18,%esp
	return;
  8015ac:	90                   	nop
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content,
		uint32* second_list_content, int actual_active_list_size,
		int actual_second_list_size) {
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32) active_list_content,
  8015b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	6a 00                	push   $0x0
  8015c1:	53                   	push   %ebx
  8015c2:	51                   	push   %ecx
  8015c3:	52                   	push   %edx
  8015c4:	50                   	push   %eax
  8015c5:	6a 27                	push   $0x27
  8015c7:	e8 aa fa ff ff       	call   801076 <syscall>
  8015cc:	83 c4 18             	add    $0x18,%esp
			(uint32) second_list_content, (uint32) actual_active_list_size,
			(uint32) actual_second_list_size, 0);
}
  8015cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015d2:	c9                   	leave  
  8015d3:	c3                   	ret    

008015d4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size) {
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32) list_content,
  8015d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	6a 00                	push   $0x0
  8015df:	6a 00                	push   $0x0
  8015e1:	6a 00                	push   $0x0
  8015e3:	52                   	push   %edx
  8015e4:	50                   	push   %eax
  8015e5:	6a 28                	push   $0x28
  8015e7:	e8 8a fa ff ff       	call   801076 <syscall>
  8015ec:	83 c4 18             	add    $0x18,%esp
			(uint32) list_size, 0, 0, 0);
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <sys_check_WS_list>:

int sys_check_WS_list(uint32* WS_list_content, int actual_WS_list_size,
		uint32 last_WS_element_content, bool chk_in_order) {
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_WS_list, (uint32) WS_list_content,
  8015f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8015f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	6a 00                	push   $0x0
  8015ff:	51                   	push   %ecx
  801600:	ff 75 10             	pushl  0x10(%ebp)
  801603:	52                   	push   %edx
  801604:	50                   	push   %eax
  801605:	6a 29                	push   $0x29
  801607:	e8 6a fa ff ff       	call   801076 <syscall>
  80160c:	83 c4 18             	add    $0x18,%esp
			(uint32) actual_WS_list_size, last_WS_element_content,
			(uint32) chk_in_order, 0);
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    

00801611 <sys_allocate_chunk>:
void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms) {
  801611:	55                   	push   %ebp
  801612:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	ff 75 10             	pushl  0x10(%ebp)
  80161b:	ff 75 0c             	pushl  0xc(%ebp)
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	6a 12                	push   $0x12
  801623:	e8 4e fa ff ff       	call   801076 <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
	return;
  80162b:	90                   	nop
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <sys_utilities>:
void sys_utilities(char* utilityName, int value) {
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_utilities, (uint32) utilityName, value, 0, 0, 0);
  801631:	8b 55 0c             	mov    0xc(%ebp),%edx
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	6a 00                	push   $0x0
  801639:	6a 00                	push   $0x0
  80163b:	6a 00                	push   $0x0
  80163d:	52                   	push   %edx
  80163e:	50                   	push   %eax
  80163f:	6a 2a                	push   $0x2a
  801641:	e8 30 fa ff ff       	call   801076 <syscall>
  801646:	83 c4 18             	add    $0x18,%esp
	return;
  801649:	90                   	nop
}
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <sys_sbrk>:

//TODO: [PROJECT'24.MS1 - #02] [2] SYSTEM CALLS - Implement these system calls
void* sys_sbrk(int increment) {
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");

	return (void*) syscall(SYS_sbrk, increment, 0, 0, 0, 0);
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	6a 00                	push   $0x0
  801654:	6a 00                	push   $0x0
  801656:	6a 00                	push   $0x0
  801658:	6a 00                	push   $0x0
  80165a:	50                   	push   %eax
  80165b:	6a 2b                	push   $0x2b
  80165d:	e8 14 fa ff ff       	call   801076 <syscall>
  801662:	83 c4 18             	add    $0x18,%esp
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size) {
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 00                	push   $0x0
  801670:	ff 75 0c             	pushl  0xc(%ebp)
  801673:	ff 75 08             	pushl  0x8(%ebp)
  801676:	6a 2c                	push   $0x2c
  801678:	e8 f9 f9 ff ff       	call   801076 <syscall>
  80167d:	83 c4 18             	add    $0x18,%esp
	return;
  801680:	90                   	nop
}
  801681:	c9                   	leave  
  801682:	c3                   	ret    

00801683 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size) {
  801683:	55                   	push   %ebp
  801684:	89 e5                	mov    %esp,%ebp

	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 00                	push   $0x0
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	6a 2d                	push   $0x2d
  801694:	e8 dd f9 ff ff       	call   801076 <syscall>
  801699:	83 c4 18             	add    $0x18,%esp
	return;
  80169c:	90                   	nop
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <sys_init_queue>:

void sys_init_queue(struct Env_Queue * queue) {
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_init_queue, (uint32) queue, 0, 0, 0, 0);
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	6a 00                	push   $0x0
  8016a7:	6a 00                	push   $0x0
  8016a9:	6a 00                	push   $0x0
  8016ab:	6a 00                	push   $0x0
  8016ad:	50                   	push   %eax
  8016ae:	6a 2f                	push   $0x2f
  8016b0:	e8 c1 f9 ff ff       	call   801076 <syscall>
  8016b5:	83 c4 18             	add    $0x18,%esp
	return;
  8016b8:	90                   	nop
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sys_block_process>:
void sys_block_process(struct Env_Queue * queue, uint32* lock) {
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_block_process, (uint32)queue, (uint32)lock, 0, 0, 0);
  8016be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	6a 00                	push   $0x0
  8016c6:	6a 00                	push   $0x0
  8016c8:	6a 00                	push   $0x0
  8016ca:	52                   	push   %edx
  8016cb:	50                   	push   %eax
  8016cc:	6a 30                	push   $0x30
  8016ce:	e8 a3 f9 ff ff       	call   801076 <syscall>
  8016d3:	83 c4 18             	add    $0x18,%esp
	return;
  8016d6:	90                   	nop
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <sys_unblock_process>:

void sys_unblock_process(struct Env_Queue * queue) {
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
	//Comment the following line before start coding...
	//panic("not implemented yet");
	syscall(SYS_unblock_process, (uint32) queue, 0, 0, 0, 0);
  8016dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016df:	6a 00                	push   $0x0
  8016e1:	6a 00                	push   $0x0
  8016e3:	6a 00                	push   $0x0
  8016e5:	6a 00                	push   $0x0
  8016e7:	50                   	push   %eax
  8016e8:	6a 31                	push   $0x31
  8016ea:	e8 87 f9 ff ff       	call   801076 <syscall>
  8016ef:	83 c4 18             	add    $0x18,%esp
	return;
  8016f2:	90                   	nop
}
  8016f3:	c9                   	leave  
  8016f4:	c3                   	ret    

008016f5 <sys_env_set_priority>:
void sys_env_set_priority(int32 envID, int priority)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
    syscall(SYS_env_set_priority, envID, priority, 0, 0, 0);
  8016f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fe:	6a 00                	push   $0x0
  801700:	6a 00                	push   $0x0
  801702:	6a 00                	push   $0x0
  801704:	52                   	push   %edx
  801705:	50                   	push   %eax
  801706:	6a 2e                	push   $0x2e
  801708:	e8 69 f9 ff ff       	call   801076 <syscall>
  80170d:	83 c4 18             	add    $0x18,%esp
    return;
  801710:	90                   	nop
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801719:	8d 45 10             	lea    0x10(%ebp),%eax
  80171c:	83 c0 04             	add    $0x4,%eax
  80171f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801722:	a1 28 30 80 00       	mov    0x803028,%eax
  801727:	85 c0                	test   %eax,%eax
  801729:	74 16                	je     801741 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80172b:	a1 28 30 80 00       	mov    0x803028,%eax
  801730:	83 ec 08             	sub    $0x8,%esp
  801733:	50                   	push   %eax
  801734:	68 18 20 80 00       	push   $0x802018
  801739:	e8 9e eb ff ff       	call   8002dc <cprintf>
  80173e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801741:	a1 04 30 80 00       	mov    0x803004,%eax
  801746:	ff 75 0c             	pushl  0xc(%ebp)
  801749:	ff 75 08             	pushl  0x8(%ebp)
  80174c:	50                   	push   %eax
  80174d:	68 1d 20 80 00       	push   $0x80201d
  801752:	e8 85 eb ff ff       	call   8002dc <cprintf>
  801757:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80175a:	8b 45 10             	mov    0x10(%ebp),%eax
  80175d:	83 ec 08             	sub    $0x8,%esp
  801760:	ff 75 f4             	pushl  -0xc(%ebp)
  801763:	50                   	push   %eax
  801764:	e8 08 eb ff ff       	call   800271 <vcprintf>
  801769:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80176c:	83 ec 08             	sub    $0x8,%esp
  80176f:	6a 00                	push   $0x0
  801771:	68 39 20 80 00       	push   $0x802039
  801776:	e8 f6 ea ff ff       	call   800271 <vcprintf>
  80177b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80177e:	e8 77 ea ff ff       	call   8001fa <exit>

	// should not return here
	while (1) ;
  801783:	eb fe                	jmp    801783 <_panic+0x70>

00801785 <CheckWSArrayWithoutLastIndex>:
}

void CheckWSArrayWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80178b:	a1 08 30 80 00       	mov    0x803008,%eax
  801790:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801796:	8b 45 0c             	mov    0xc(%ebp),%eax
  801799:	39 c2                	cmp    %eax,%edx
  80179b:	74 14                	je     8017b1 <CheckWSArrayWithoutLastIndex+0x2c>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80179d:	83 ec 04             	sub    $0x4,%esp
  8017a0:	68 3c 20 80 00       	push   $0x80203c
  8017a5:	6a 26                	push   $0x26
  8017a7:	68 88 20 80 00       	push   $0x802088
  8017ac:	e8 62 ff ff ff       	call   801713 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8017b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8017b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8017bf:	e9 c5 00 00 00       	jmp    801889 <CheckWSArrayWithoutLastIndex+0x104>
		if (expectedPages[e] == 0) {
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	01 d0                	add    %edx,%eax
  8017d3:	8b 00                	mov    (%eax),%eax
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	75 08                	jne    8017e1 <CheckWSArrayWithoutLastIndex+0x5c>
			expectedNumOfEmptyLocs++;
  8017d9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8017dc:	e9 a5 00 00 00       	jmp    801886 <CheckWSArrayWithoutLastIndex+0x101>
		}
		int found = 0;
  8017e1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8017e8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8017ef:	eb 69                	jmp    80185a <CheckWSArrayWithoutLastIndex+0xd5>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8017f1:	a1 08 30 80 00       	mov    0x803008,%eax
  8017f6:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8017fc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ff:	89 d0                	mov    %edx,%eax
  801801:	01 c0                	add    %eax,%eax
  801803:	01 d0                	add    %edx,%eax
  801805:	c1 e0 03             	shl    $0x3,%eax
  801808:	01 c8                	add    %ecx,%eax
  80180a:	8a 40 04             	mov    0x4(%eax),%al
  80180d:	84 c0                	test   %al,%al
  80180f:	75 46                	jne    801857 <CheckWSArrayWithoutLastIndex+0xd2>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801811:	a1 08 30 80 00       	mov    0x803008,%eax
  801816:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  80181c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80181f:	89 d0                	mov    %edx,%eax
  801821:	01 c0                	add    %eax,%eax
  801823:	01 d0                	add    %edx,%eax
  801825:	c1 e0 03             	shl    $0x3,%eax
  801828:	01 c8                	add    %ecx,%eax
  80182a:	8b 00                	mov    (%eax),%eax
  80182c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80182f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801832:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801837:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801843:	8b 45 08             	mov    0x8(%ebp),%eax
  801846:	01 c8                	add    %ecx,%eax
  801848:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80184a:	39 c2                	cmp    %eax,%edx
  80184c:	75 09                	jne    801857 <CheckWSArrayWithoutLastIndex+0xd2>
						== expectedPages[e]) {
					found = 1;
  80184e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801855:	eb 15                	jmp    80186c <CheckWSArrayWithoutLastIndex+0xe7>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801857:	ff 45 e8             	incl   -0x18(%ebp)
  80185a:	a1 08 30 80 00       	mov    0x803008,%eax
  80185f:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  801865:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801868:	39 c2                	cmp    %eax,%edx
  80186a:	77 85                	ja     8017f1 <CheckWSArrayWithoutLastIndex+0x6c>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80186c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801870:	75 14                	jne    801886 <CheckWSArrayWithoutLastIndex+0x101>
			panic(
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	68 94 20 80 00       	push   $0x802094
  80187a:	6a 3a                	push   $0x3a
  80187c:	68 88 20 80 00       	push   $0x802088
  801881:	e8 8d fe ff ff       	call   801713 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801886:	ff 45 f0             	incl   -0x10(%ebp)
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80188f:	0f 8c 2f ff ff ff    	jl     8017c4 <CheckWSArrayWithoutLastIndex+0x3f>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  801895:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80189c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8018a3:	eb 26                	jmp    8018cb <CheckWSArrayWithoutLastIndex+0x146>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8018a5:	a1 08 30 80 00       	mov    0x803008,%eax
  8018aa:	8b 88 8c 05 00 00    	mov    0x58c(%eax),%ecx
  8018b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018b3:	89 d0                	mov    %edx,%eax
  8018b5:	01 c0                	add    %eax,%eax
  8018b7:	01 d0                	add    %edx,%eax
  8018b9:	c1 e0 03             	shl    $0x3,%eax
  8018bc:	01 c8                	add    %ecx,%eax
  8018be:	8a 40 04             	mov    0x4(%eax),%al
  8018c1:	3c 01                	cmp    $0x1,%al
  8018c3:	75 03                	jne    8018c8 <CheckWSArrayWithoutLastIndex+0x143>
			actualNumOfEmptyLocs++;
  8018c5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8018c8:	ff 45 e0             	incl   -0x20(%ebp)
  8018cb:	a1 08 30 80 00       	mov    0x803008,%eax
  8018d0:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
  8018d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d9:	39 c2                	cmp    %eax,%edx
  8018db:	77 c8                	ja     8018a5 <CheckWSArrayWithoutLastIndex+0x120>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8018e3:	74 14                	je     8018f9 <CheckWSArrayWithoutLastIndex+0x174>
		panic(
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	68 e8 20 80 00       	push   $0x8020e8
  8018ed:	6a 44                	push   $0x44
  8018ef:	68 88 20 80 00       	push   $0x802088
  8018f4:	e8 1a fe ff ff       	call   801713 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8018f9:	90                   	nop
  8018fa:	c9                   	leave  
  8018fb:	c3                   	ret    

008018fc <__udivdi3>:
  8018fc:	55                   	push   %ebp
  8018fd:	57                   	push   %edi
  8018fe:	56                   	push   %esi
  8018ff:	53                   	push   %ebx
  801900:	83 ec 1c             	sub    $0x1c,%esp
  801903:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801907:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80190b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80190f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801913:	89 ca                	mov    %ecx,%edx
  801915:	89 f8                	mov    %edi,%eax
  801917:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80191b:	85 f6                	test   %esi,%esi
  80191d:	75 2d                	jne    80194c <__udivdi3+0x50>
  80191f:	39 cf                	cmp    %ecx,%edi
  801921:	77 65                	ja     801988 <__udivdi3+0x8c>
  801923:	89 fd                	mov    %edi,%ebp
  801925:	85 ff                	test   %edi,%edi
  801927:	75 0b                	jne    801934 <__udivdi3+0x38>
  801929:	b8 01 00 00 00       	mov    $0x1,%eax
  80192e:	31 d2                	xor    %edx,%edx
  801930:	f7 f7                	div    %edi
  801932:	89 c5                	mov    %eax,%ebp
  801934:	31 d2                	xor    %edx,%edx
  801936:	89 c8                	mov    %ecx,%eax
  801938:	f7 f5                	div    %ebp
  80193a:	89 c1                	mov    %eax,%ecx
  80193c:	89 d8                	mov    %ebx,%eax
  80193e:	f7 f5                	div    %ebp
  801940:	89 cf                	mov    %ecx,%edi
  801942:	89 fa                	mov    %edi,%edx
  801944:	83 c4 1c             	add    $0x1c,%esp
  801947:	5b                   	pop    %ebx
  801948:	5e                   	pop    %esi
  801949:	5f                   	pop    %edi
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    
  80194c:	39 ce                	cmp    %ecx,%esi
  80194e:	77 28                	ja     801978 <__udivdi3+0x7c>
  801950:	0f bd fe             	bsr    %esi,%edi
  801953:	83 f7 1f             	xor    $0x1f,%edi
  801956:	75 40                	jne    801998 <__udivdi3+0x9c>
  801958:	39 ce                	cmp    %ecx,%esi
  80195a:	72 0a                	jb     801966 <__udivdi3+0x6a>
  80195c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801960:	0f 87 9e 00 00 00    	ja     801a04 <__udivdi3+0x108>
  801966:	b8 01 00 00 00       	mov    $0x1,%eax
  80196b:	89 fa                	mov    %edi,%edx
  80196d:	83 c4 1c             	add    $0x1c,%esp
  801970:	5b                   	pop    %ebx
  801971:	5e                   	pop    %esi
  801972:	5f                   	pop    %edi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    
  801975:	8d 76 00             	lea    0x0(%esi),%esi
  801978:	31 ff                	xor    %edi,%edi
  80197a:	31 c0                	xor    %eax,%eax
  80197c:	89 fa                	mov    %edi,%edx
  80197e:	83 c4 1c             	add    $0x1c,%esp
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5f                   	pop    %edi
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    
  801986:	66 90                	xchg   %ax,%ax
  801988:	89 d8                	mov    %ebx,%eax
  80198a:	f7 f7                	div    %edi
  80198c:	31 ff                	xor    %edi,%edi
  80198e:	89 fa                	mov    %edi,%edx
  801990:	83 c4 1c             	add    $0x1c,%esp
  801993:	5b                   	pop    %ebx
  801994:	5e                   	pop    %esi
  801995:	5f                   	pop    %edi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    
  801998:	bd 20 00 00 00       	mov    $0x20,%ebp
  80199d:	89 eb                	mov    %ebp,%ebx
  80199f:	29 fb                	sub    %edi,%ebx
  8019a1:	89 f9                	mov    %edi,%ecx
  8019a3:	d3 e6                	shl    %cl,%esi
  8019a5:	89 c5                	mov    %eax,%ebp
  8019a7:	88 d9                	mov    %bl,%cl
  8019a9:	d3 ed                	shr    %cl,%ebp
  8019ab:	89 e9                	mov    %ebp,%ecx
  8019ad:	09 f1                	or     %esi,%ecx
  8019af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8019b3:	89 f9                	mov    %edi,%ecx
  8019b5:	d3 e0                	shl    %cl,%eax
  8019b7:	89 c5                	mov    %eax,%ebp
  8019b9:	89 d6                	mov    %edx,%esi
  8019bb:	88 d9                	mov    %bl,%cl
  8019bd:	d3 ee                	shr    %cl,%esi
  8019bf:	89 f9                	mov    %edi,%ecx
  8019c1:	d3 e2                	shl    %cl,%edx
  8019c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8019c7:	88 d9                	mov    %bl,%cl
  8019c9:	d3 e8                	shr    %cl,%eax
  8019cb:	09 c2                	or     %eax,%edx
  8019cd:	89 d0                	mov    %edx,%eax
  8019cf:	89 f2                	mov    %esi,%edx
  8019d1:	f7 74 24 0c          	divl   0xc(%esp)
  8019d5:	89 d6                	mov    %edx,%esi
  8019d7:	89 c3                	mov    %eax,%ebx
  8019d9:	f7 e5                	mul    %ebp
  8019db:	39 d6                	cmp    %edx,%esi
  8019dd:	72 19                	jb     8019f8 <__udivdi3+0xfc>
  8019df:	74 0b                	je     8019ec <__udivdi3+0xf0>
  8019e1:	89 d8                	mov    %ebx,%eax
  8019e3:	31 ff                	xor    %edi,%edi
  8019e5:	e9 58 ff ff ff       	jmp    801942 <__udivdi3+0x46>
  8019ea:	66 90                	xchg   %ax,%ax
  8019ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8019f0:	89 f9                	mov    %edi,%ecx
  8019f2:	d3 e2                	shl    %cl,%edx
  8019f4:	39 c2                	cmp    %eax,%edx
  8019f6:	73 e9                	jae    8019e1 <__udivdi3+0xe5>
  8019f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8019fb:	31 ff                	xor    %edi,%edi
  8019fd:	e9 40 ff ff ff       	jmp    801942 <__udivdi3+0x46>
  801a02:	66 90                	xchg   %ax,%ax
  801a04:	31 c0                	xor    %eax,%eax
  801a06:	e9 37 ff ff ff       	jmp    801942 <__udivdi3+0x46>
  801a0b:	90                   	nop

00801a0c <__umoddi3>:
  801a0c:	55                   	push   %ebp
  801a0d:	57                   	push   %edi
  801a0e:	56                   	push   %esi
  801a0f:	53                   	push   %ebx
  801a10:	83 ec 1c             	sub    $0x1c,%esp
  801a13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801a17:	8b 74 24 34          	mov    0x34(%esp),%esi
  801a1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801a1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801a23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a2b:	89 f3                	mov    %esi,%ebx
  801a2d:	89 fa                	mov    %edi,%edx
  801a2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a33:	89 34 24             	mov    %esi,(%esp)
  801a36:	85 c0                	test   %eax,%eax
  801a38:	75 1a                	jne    801a54 <__umoddi3+0x48>
  801a3a:	39 f7                	cmp    %esi,%edi
  801a3c:	0f 86 a2 00 00 00    	jbe    801ae4 <__umoddi3+0xd8>
  801a42:	89 c8                	mov    %ecx,%eax
  801a44:	89 f2                	mov    %esi,%edx
  801a46:	f7 f7                	div    %edi
  801a48:	89 d0                	mov    %edx,%eax
  801a4a:	31 d2                	xor    %edx,%edx
  801a4c:	83 c4 1c             	add    $0x1c,%esp
  801a4f:	5b                   	pop    %ebx
  801a50:	5e                   	pop    %esi
  801a51:	5f                   	pop    %edi
  801a52:	5d                   	pop    %ebp
  801a53:	c3                   	ret    
  801a54:	39 f0                	cmp    %esi,%eax
  801a56:	0f 87 ac 00 00 00    	ja     801b08 <__umoddi3+0xfc>
  801a5c:	0f bd e8             	bsr    %eax,%ebp
  801a5f:	83 f5 1f             	xor    $0x1f,%ebp
  801a62:	0f 84 ac 00 00 00    	je     801b14 <__umoddi3+0x108>
  801a68:	bf 20 00 00 00       	mov    $0x20,%edi
  801a6d:	29 ef                	sub    %ebp,%edi
  801a6f:	89 fe                	mov    %edi,%esi
  801a71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a75:	89 e9                	mov    %ebp,%ecx
  801a77:	d3 e0                	shl    %cl,%eax
  801a79:	89 d7                	mov    %edx,%edi
  801a7b:	89 f1                	mov    %esi,%ecx
  801a7d:	d3 ef                	shr    %cl,%edi
  801a7f:	09 c7                	or     %eax,%edi
  801a81:	89 e9                	mov    %ebp,%ecx
  801a83:	d3 e2                	shl    %cl,%edx
  801a85:	89 14 24             	mov    %edx,(%esp)
  801a88:	89 d8                	mov    %ebx,%eax
  801a8a:	d3 e0                	shl    %cl,%eax
  801a8c:	89 c2                	mov    %eax,%edx
  801a8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a92:	d3 e0                	shl    %cl,%eax
  801a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a98:	8b 44 24 08          	mov    0x8(%esp),%eax
  801a9c:	89 f1                	mov    %esi,%ecx
  801a9e:	d3 e8                	shr    %cl,%eax
  801aa0:	09 d0                	or     %edx,%eax
  801aa2:	d3 eb                	shr    %cl,%ebx
  801aa4:	89 da                	mov    %ebx,%edx
  801aa6:	f7 f7                	div    %edi
  801aa8:	89 d3                	mov    %edx,%ebx
  801aaa:	f7 24 24             	mull   (%esp)
  801aad:	89 c6                	mov    %eax,%esi
  801aaf:	89 d1                	mov    %edx,%ecx
  801ab1:	39 d3                	cmp    %edx,%ebx
  801ab3:	0f 82 87 00 00 00    	jb     801b40 <__umoddi3+0x134>
  801ab9:	0f 84 91 00 00 00    	je     801b50 <__umoddi3+0x144>
  801abf:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ac3:	29 f2                	sub    %esi,%edx
  801ac5:	19 cb                	sbb    %ecx,%ebx
  801ac7:	89 d8                	mov    %ebx,%eax
  801ac9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801acd:	d3 e0                	shl    %cl,%eax
  801acf:	89 e9                	mov    %ebp,%ecx
  801ad1:	d3 ea                	shr    %cl,%edx
  801ad3:	09 d0                	or     %edx,%eax
  801ad5:	89 e9                	mov    %ebp,%ecx
  801ad7:	d3 eb                	shr    %cl,%ebx
  801ad9:	89 da                	mov    %ebx,%edx
  801adb:	83 c4 1c             	add    $0x1c,%esp
  801ade:	5b                   	pop    %ebx
  801adf:	5e                   	pop    %esi
  801ae0:	5f                   	pop    %edi
  801ae1:	5d                   	pop    %ebp
  801ae2:	c3                   	ret    
  801ae3:	90                   	nop
  801ae4:	89 fd                	mov    %edi,%ebp
  801ae6:	85 ff                	test   %edi,%edi
  801ae8:	75 0b                	jne    801af5 <__umoddi3+0xe9>
  801aea:	b8 01 00 00 00       	mov    $0x1,%eax
  801aef:	31 d2                	xor    %edx,%edx
  801af1:	f7 f7                	div    %edi
  801af3:	89 c5                	mov    %eax,%ebp
  801af5:	89 f0                	mov    %esi,%eax
  801af7:	31 d2                	xor    %edx,%edx
  801af9:	f7 f5                	div    %ebp
  801afb:	89 c8                	mov    %ecx,%eax
  801afd:	f7 f5                	div    %ebp
  801aff:	89 d0                	mov    %edx,%eax
  801b01:	e9 44 ff ff ff       	jmp    801a4a <__umoddi3+0x3e>
  801b06:	66 90                	xchg   %ax,%ax
  801b08:	89 c8                	mov    %ecx,%eax
  801b0a:	89 f2                	mov    %esi,%edx
  801b0c:	83 c4 1c             	add    $0x1c,%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5f                   	pop    %edi
  801b12:	5d                   	pop    %ebp
  801b13:	c3                   	ret    
  801b14:	3b 04 24             	cmp    (%esp),%eax
  801b17:	72 06                	jb     801b1f <__umoddi3+0x113>
  801b19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801b1d:	77 0f                	ja     801b2e <__umoddi3+0x122>
  801b1f:	89 f2                	mov    %esi,%edx
  801b21:	29 f9                	sub    %edi,%ecx
  801b23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801b27:	89 14 24             	mov    %edx,(%esp)
  801b2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801b32:	8b 14 24             	mov    (%esp),%edx
  801b35:	83 c4 1c             	add    $0x1c,%esp
  801b38:	5b                   	pop    %ebx
  801b39:	5e                   	pop    %esi
  801b3a:	5f                   	pop    %edi
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    
  801b3d:	8d 76 00             	lea    0x0(%esi),%esi
  801b40:	2b 04 24             	sub    (%esp),%eax
  801b43:	19 fa                	sbb    %edi,%edx
  801b45:	89 d1                	mov    %edx,%ecx
  801b47:	89 c6                	mov    %eax,%esi
  801b49:	e9 71 ff ff ff       	jmp    801abf <__umoddi3+0xb3>
  801b4e:	66 90                	xchg   %ax,%ax
  801b50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801b54:	72 ea                	jb     801b40 <__umoddi3+0x134>
  801b56:	89 d9                	mov    %ebx,%ecx
  801b58:	e9 62 ff ff ff       	jmp    801abf <__umoddi3+0xb3>
